class Podcast < ApplicationRecord
  has_many :podcast_episodes

  mount_uploader :image, ProfileImageUploader
  mount_uploader :pattern_image, ProfileImageUploader

  validates :main_color_hex, presence: true

  after_save :bust_cache
  after_create :pull_all_episodes

  def path
    slug
  end

  def profile_image_url
    image_url
  end

  def name
    title
  end

  private

  def bust_cache
    CacheBuster.new.bust("/" + path)
  end

  def pull_all_episodes
    Podcasts::GetEpisodesJob.perform_later(id)
  end

  def pull_all_episodes_without_delay
    Podcasts::GetEpisodesJob.perform_now(id)
  end
end
