Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C401F3BA2
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 05:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788155611; cv=none; b=aP4BkLr6W1FxW/fI76ScesSbD8Ax7S7j0Q3tXJlJgP0V+i9tuB6Be3jhIHCOiwesskRUxRTuD6B25A9/koOlcobMWb9zpHbCirwlif9exv0Ilu+U90SOpArJ6MIDYwRwQmLPEpJvAPtpsgcyV+aTFRvvSwom7oaKtBr08dK4URo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788155611; c=relaxed/simple;
	bh=kHi+LkwUyD9teSMIZrzt8h92lL/twszzL4tCDPzqwjo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SR94rObKCVJGMvjFiFbDrwl/zn8eNC+UfXPZzWUxVnrrUKzI4YFcDoDo1ycQLPdqA0cAQTFzL54euZKAM2+IeUoJ0zeRWbJ16u7RXMm6Pd/A48YLi73XVId5B/anMGisbhHlry4BfCguEyVhzP4rhL90Wn8pWaQhMyxDSXArnLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MoKrWTxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MoKrWTxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE441F000E9;
	Mon, 31 Aug 2026 05:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788155609;
	bh=NgGkVjNxpbxbHWl86QTkVw7kxXy1Rm4fptZLZYyvtdI=;
	h=Date:From:To:Cc:Subject;
	b=MoKrWTxldkrDBE0eFW3Zd7a/JpWIFyCuBnVLuUo6mtDF74xOV0u60iIu1BX83dWvp
	 lJWd0h1jfpq6tZzuVq7ER6RgDpakgm0fwgiGR7pXMps6C/dV3Cwjv1J6n8bjIsj7un
	 AFauCUr57bskspSNO6dTWf8+15L8jcHa0zIO7M38el6aeMSxapwF3orAXxP8hUEpIx
	 gqXp9a2oPmXleRGYI9k2pcigaah93+FWGNwjmODQPiELONxd+kKnZz6/oNLqjz5LS2
	 gSAb1npd/c5rly9qvgq2bM47XSwVBYuTMhvAdT0JC9lBbJUlx8c6zdxlhaN+nf5Suq
	 n6C0jKm4toi8w==
Date: Mon, 31 Aug 2026 07:53:25 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.3-rc2
Message-ID: <apUSmA9aI8wpLyXf@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.

This contains a set of fixes for rc-2. I just want to highlight from
this series that it contains a couple patches for capabilities subsystem
and another for the quota subsystem. All three patches have been acked
by the respective maintainers and they agreed for these patches to go
through xfs tree as they are dependencies for a xfs bugfix.

Thanks,
Carlos

"The following changes since commit 818bebeb63dd6bf5f4e07e145f6cdbace520a34c:

  drm/xe: Don't hand out the flat CCS storage as usable VRAM (2026-08-20 20:12:39 -0700)

are available in the Git repository at:

  gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.3-rc2

for you to fetch changes up to 412f89fb3988a344175899776c8bc7073524ad84:

  capability: unexport has_capability_noaudit (2026-08-21 09:09:55 +0200)

----------------------------------------------------------------
xfs: fixes for 7.3-rc2

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Carlos Maiolino (5):
      xfs: fix capability check in xfs
      capability: Add new capable_noaudit
      quota: Don't issue audit messages on quota enforcing
      xfs: replace ns_capable_noaudit
      capability: unexport has_capability_noaudit

Christoph Hellwig (9):
      xfs: split an assert in xfs_trans_log_buf
      xfs: don't flush and invalidate internal RT device twice in xfs_shutdown_devices
      xfs: use inode_init_always_gfp with __GFP_NOFAIL in xfs_inode_alloc
      xfs: handle NULL open_zone for merged ioends in xfs_ioend_put_open_zones
      xfs: fix racy open zone caching
      xfs: fix zoned write iomap flags assignments
      xfs: factor out a xfs_iomap_set_anon_write helper
      xfs: split ioend handling into a separate source file
      xfs: restore bi_bdev in xfs_zone_gc_write_chunk

Tal Zussman (1):
      xfs: remove kmem_to_page()

Yun Zhou (1):
      xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf

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
 create mode 100644 fs/xfs/xfs_ioend.h"
