Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFE43A9D9C
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 07:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297752; cv=none; b=ZHNVK80IwjN5ahTGbwAmcb1m8QU3gCEPij3ETk3VcdNqbIRGFZFgFFUHriiNRSBqG/oyFSCZPVs8u5TaN1Im4jsa4StlFtLLIXKyanc0FVFXNFb0iMle59a6diQ02TDAjfsYwLGfNh5BtOaKDC8zV78RNflpm2p2k3sXp/Ay+GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297752; c=relaxed/simple;
	bh=Pf3BPWryRyLtEfUv7aTv3QeCzhP43O8TryAI6IG3TUs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BE0nJDk1zkTLD/MaFpINa0eh+RIsWaV0IW5+TBzqQSacplDXyuNcIg/Ypvca/obamU9gkSgBeFNvJgb6vgvVFgKAQV3Q/uxJJiA2woqwJ3eLhN0nYFAHYSyB3mSEOm5/f+BglgRGpPyoZ+oT5i/Z8wmHgZBQQL02WS07ZKMI7yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BRMBoRTl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRMBoRTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48D81F000E9
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 07:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787297742;
	bh=y0N1rD8GJm0vfOiTiWO5gWhhEdyuI/ZN+4yVLoRvYOY=;
	h=Date:From:To:Subject;
	b=BRMBoRTln0j6eRuZbY9fkX4BhekEuW/EhiXFHOooYEsAiFyz4DF6bWGxySJG6ernp
	 PPZGGjfhvZAKlnmD2QWMWReiQcFtGYWVs97TSjw2pV0Y4yha7O/aXysHTsMU0Mu5UF
	 UcXjhtD2T1v/GbH1w34J0jfMCn6gEr2o9KoxTWMLxecV+MY4xHH1X8kFrfEHGW+8yi
	 vsiofDfR3lQq90m3uWImuUYYeCt7L+D8hPmRwHMdu4hmXsALVLlMIIQHQhWccgqv4E
	 324oZycnRWdqrj28ahSVtSRuJlmzQ3wrGBkRnydasqHPNp5+ry7FkmNRIk0ham3IcG
	 ZtJXolsdQweng==
Date: Fri, 21 Aug 2026 09:35:38 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 412f89fb3988
Message-ID: <aof-4lB16m-tmaFN@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

Please bear in mind this resets for-next to Linus's current TOT, before
the xfs patches were applied.

The new head of the for-next branch is commit:

412f89fb3988 capability: unexport has_capability_noaudit

16 new commits:

Carlos Maiolino (5):
      [e2f62a9744eb] xfs: fix capability check in xfs
      [1b91724d0bdc] capability: Add new capable_noaudit
      [4642259374fc] quota: Don't issue audit messages on quota enforcing
      [be9c45bdb194] xfs: replace ns_capable_noaudit
      [412f89fb3988] capability: unexport has_capability_noaudit

Christoph Hellwig (9):
      [b9b541e70d46] xfs: split an assert in xfs_trans_log_buf
      [7fc296b379ed] xfs: don't flush and invalidate internal RT device twice in xfs_shutdown_devices
      [4e07cd78e159] xfs: use inode_init_always_gfp with __GFP_NOFAIL in xfs_inode_alloc
      [ae285611891f] xfs: handle NULL open_zone for merged ioends in xfs_ioend_put_open_zones
      [2d829cc76777] xfs: fix racy open zone caching
      [4bc67fc800ed] xfs: fix zoned write iomap flags assignments
      [0510346e8e30] xfs: factor out a xfs_iomap_set_anon_write helper
      [6b855256eb9e] xfs: split ioend handling into a separate source file
      [885435535bb1] xfs: restore bi_bdev in xfs_zone_gc_write_chunk

Tal Zussman (1):
      [750a361bfc8a] xfs: remove kmem_to_page()

Yun Zhou (1):
      [41a28c865d1d] xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf

Code Diffstat:

 fs/quota/dquot.c            |   2 +-
 fs/xfs/Makefile             |   1 +
 fs/xfs/libxfs/xfs_rtgroup.h |   6 +-
 fs/xfs/libxfs/xfs_sb.c      |  37 ++++-----
 fs/xfs/xfs_aops.c           | 188 +-------------------------------------------
 fs/xfs/xfs_aops.h           |   1 -
 fs/xfs/xfs_file.c           |   2 +-
 fs/xfs/xfs_fsmap.c          |   3 +-
 fs/xfs/xfs_icache.c         |  16 ++--
 fs/xfs/xfs_ioctl.c          |   2 +-
 fs/xfs/xfs_ioend.c          | 184 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioend.h          |  16 ++++
 fs/xfs/xfs_iomap.c          |   7 +-
 fs/xfs/xfs_iomap.h          |  14 ++++
 fs/xfs/xfs_iops.c           |   2 +-
 fs/xfs/xfs_platform.h       |  11 ---
 fs/xfs/xfs_super.c          |   2 +-
 fs/xfs/xfs_trans_buf.c      |   3 +-
 fs/xfs/xfs_zone_alloc.c     |  66 +++++++++++++---
 fs/xfs/xfs_zone_gc.c        |   5 ++
 include/linux/capability.h  |   5 ++
 kernel/capability.c         |  19 ++++-
 22 files changed, 336 insertions(+), 256 deletions(-)
 create mode 100644 fs/xfs/xfs_ioend.c
 create mode 100644 fs/xfs/xfs_ioend.h
