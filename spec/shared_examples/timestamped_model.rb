shared_examples_for "timestamped model" do
  before do
    # stub these out so they return the same values all the time
    @time = Time.now
    @tomorrow = Time.now.tomorrow
    Time.stub(:now).and_return(@time)
    subject.save!
  end

  it "should have set updated_at" do
    subject.updated_at.to_i.should == Time.now.to_i
  end

  it "should have set created_at" do
    subject.created_at.to_i == Time.now.to_i
  end

  context "when updated" do
    before(:each) do
      Time.stub(:now).and_return(@tomorrow)
    end

    it "created_at is not changed" do
      lambda { subject.update_attributes!(:a => 1, :b => 2) }.should_not change(subject, :created_at)
    end

    it "should have altered the updated_at property" do
      lambda { subject.update_attributes!(:a => 1, :b => 2) }.should change(subject, :updated_at)
    end

    context "without modifications" do
      it "should not alter the updated_at property" do
        lambda { subject.save! }.should_not change(subject, :updated_at)
      end
    end
  end
end
