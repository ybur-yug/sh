defmodule ShTest do
  use ExUnit.Case

  alias Sh.CommandNotFound
  alias Sh.AbnormalExit

  @tmp_dir Path.expand("tmp", __DIR__)

  setup_all do
    File.mkdir_p!(@tmp_dir)

    on_exit fn ->
      File.rm_rf!(@tmp_dir)
      :ok
    end

    :ok
  end

  test "simple commands" do
    assert Sh.true == ""
    assert Sh.echo("Hello World!") == "Hello World!\n"
    assert Sh.ls(Path.expand("fixtures", __DIR__)) == "test.txt\n"
    assert Sh.cat(fixture_path("test.txt")) == "foo\nbar\nbaz\n"
    assert Sh.tail("-n1", fixture_path("test.txt")) == "baz\n"
  end

  test "commands with options" do
    assert Sh.echo("Hello World!", n: true) == "Hello World!"
    assert Sh.curl("http://httpbin.org/html", o: tmp_path("page.html"), silent: true) == ""
    assert File.exists?(tmp_path("page.html"))
  end

  test "command not found" do
    assert_raise CommandNotFound, fn ->
      Sh.kurvin
    end
  end

  test "non-zero exits" do
    assert_raise AbnormalExit, fn ->
      Sh.false
    end
  end

  defp fixture_path(path) do
    Path.expand(Path.join(["fixtures", path]), __DIR__)
  end

  defp tmp_path(path) do
    Path.expand(Path.join(["tmp", path]), __DIR__)
  end
end
