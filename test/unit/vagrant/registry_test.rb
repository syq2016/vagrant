require File.expand_path("../../base", __FILE__)

describe Vagrant::Registry do
  let(:instance) { described_class.new }

  it "should return nil for nonexistent items" do
    instance.get("foo").should be_nil
  end

  it "should register a simple key/value" do
    instance.register("foo", "value")
    instance.get("foo").should == "value"
  end

  it "should register an item without calling the block yet" do
    expect do
      instance.register("foo") do
        raise Exception, "BOOM!"
      end
    end.to_not raise_error
  end

  it "should call and return the result of a block when asking for the ite" do
    object = Object.new
    instance.register("foo") do
      object
    end

    instance.get("foo").should eql(object)
  end

  it "should be enumerable" do
    instance.register("foo", "foovalue")
    instance.register("bar", "barvalue")

    keys   = []
    values = []
    instance.each do |key, value|
      keys << key
      values << value
    end

    keys.sort.should == ["bar", "foo"]
    values.sort.should == ["barvalue", "foovalue"]
  end
end
