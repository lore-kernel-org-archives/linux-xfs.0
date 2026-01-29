Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76A531ED88
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 11:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769686219; cv=none; b=V781Abg1Xkx26JTpNxT5v3wN85ujAYgNRileq8mcvKpXG+2tfi/MJOt1TrwCbQUmp23pREl1ssTWP7CMVzxwI2bTzxx/l71pys4hqbX6IOamHc473DQsdKj066c1I8YBblpZfu2eOFwLmwlRZ4JjapCw71FiioZRui9K9WKmwAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769686219; c=relaxed/simple;
	bh=BO18ZJDuAHier5uhcHcP3RoNgle4Exwy/lc4Cz24YTA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dA2Ljc0OaEtX6AlvWig91qVsIEvKjemxZ0ntcn6d5R+cS0+WQfbWavwajb1XycaFoel8lbbY0Xa4dqdzC3xD9IhEQ+yTdJkoGSJZdyreL9Vk8vcsXOkel+2YGLx0Xkxdo0FMaaKk+PoJ2I/1lM8Vnme3fUgjGRU1aQUyg/nKL8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SdvaByLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SdvaByLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E2FC4CEF7
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 11:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769686219;
	bh=BO18ZJDuAHier5uhcHcP3RoNgle4Exwy/lc4Cz24YTA=;
	h=Date:From:To:Subject:From;
	b=SdvaByLkm+4Fji8AglMBq3DIFc65Rr8CExaNVtBBM8EvpojTVr1pTPvX/X9vjOWBZ
	 4PRUD/9jZbpHqupwAiwnnnQMGi0/wFnMRopXvWcAovIOxf9fk7zjVx8KTrbuAWwUu6
	 7axcLTAl0H83Xp0v3wxyNNqaYSBG7XbBbeBqbUn9u0agjpPmtdzBiGCUWawAeNly7B
	 KxjMzK/mUE9V2Uwa61wqoJzVl6ohGC59s7m+6G1+FE6SMjjho1YUnX3FesK43H/zK1
	 kLCOJ4n/g0xoMOYiLIjx1vHE7FEOvKnUjOeZfJc1AKm6VvvRQiTxgElneNX6E2HmXb
	 5JlhQakfDHYpA==
Date: Thu, 29 Jan 2026 12:30:15 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 0ead3b72469e
Message-ID: <aXtEkInQa-oMQSZf@nidhogg.toxiclabs.cc>
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

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

0ead3b72469e xfs: fix spacing style issues in xfs_alloc.c

38 new commits:

Carlos Maiolino (4):
      [04a65666a695] Merge tag 'health-monitoring-7.0_2026-01-20' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-7.0-merge
      [2744d7adb262] Merge tag 'attr-leaf-freemap-fixes-7.0_2026-01-25' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-7.0-merge
      [c04ed39d8578] Merge tag 'attr-pptr-speedup-7.0_2026-01-25' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-7.0-merge
      [692243cac631] Merge tag 'scrub-syzbot-fixes-7.0_2026-01-25' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-7.0-merge

Christoph Hellwig (2):
      [c17a1c03493b] xfs: use a seprate member to track space availabe in the GC scatch buffer
      [7da4ebea8332] xfs: remove xfs_zone_gc_space_available

Darrick J. Wong (27):
      [602544773763] uapi: promote EFSCORRUPTED and EUCLEAN to errno.h
      [efd87a100729] xfs: report fs metadata errors via fsnotify
      [94503211d2fd] xfs: translate fsdax media errors into file "data lost" errors when convenient
      [a48373e7d35a] xfs: start creating infrastructure for health monitoring
      [b3a289a2a939] xfs: create event queuing, formatting, and discovery infrastructure
      [25ca57fa3624] xfs: convey filesystem unmount events to the health monitor
      [5eb4cb18e445] xfs: convey metadata health events to the health monitor
      [74c4795e50f8] xfs: convey filesystem shutdown events to the health monitor
      [e76e0e3fc995] xfs: convey externally discovered fsdax media errors to the health monitor
      [dfa8bad3a879] xfs: convey file I/O errors to the health monitor
      [c0e719cb3667] xfs: allow toggling verbose logging on the health monitoring file
      [8b85dc4090e1] xfs: check if an open file is on the health monitored fs
      [b8accfd65d31] xfs: add media verification ioctl
      [6f13c1d2a627] xfs: delete attr leaf freemap entries when empty
      [3eefc0c2b784] xfs: fix freemap adjustments when adding xattrs to leaf blocks
      [a165f7e7633e] xfs: refactor attr3 leaf table size computation
      [27a0c41f33d8] xfs: strengthen attr leaf block freemap checking
      [6fed8270448c] xfs: fix the xattr scrub to detect freemap/entries array collisions
      [bd3138e8912c] xfs: fix remote xattr valuelblk check
      [1ef7729df1f0] xfs: reduce xfs_attr_try_sf_addname parameters
      [d693534513d8] xfs: speed up parent pointer operations when possible
      [eaec8aeff31d] xfs: add a method to replace shortform attrs
      [60382993a2e1] xfs: get rid of the xchk_xfile_*_descr calls
      [ba408d299a3b] xfs: only call xf{array,blob}_destroy if we have a valid pointer
      [ca27313fb3f2] xfs: check return value of xchk_scrub_create_subord
      [1c253e11225b] xfs: fix UAF in xchk_btree_check_block_owner
      [55e03b8cbe27] xfs: check for deleted cursors when revalidating two btrees

Shin Seong-jun (1):
      [0ead3b72469e] xfs: fix spacing style issues in xfs_alloc.c

Code Diffstat:

 fs/xfs/Makefile                  |    2 +
 fs/xfs/libxfs/xfs_alloc.c        |    8 +-
 fs/xfs/libxfs/xfs_attr.c         |  114 +++-
 fs/xfs/libxfs/xfs_attr.h         |    6 +-
 fs/xfs/libxfs/xfs_attr_leaf.c    |  195 ++++--
 fs/xfs/libxfs/xfs_attr_leaf.h    |    1 +
 fs/xfs/libxfs/xfs_da_format.h    |    2 +-
 fs/xfs/libxfs/xfs_fs.h           |  189 ++++++
 fs/xfs/libxfs/xfs_health.h       |    5 +
 fs/xfs/libxfs/xfs_parent.c       |   14 +-
 fs/xfs/scrub/agheader_repair.c   |   21 +-
 fs/xfs/scrub/alloc_repair.c      |   20 +-
 fs/xfs/scrub/attr.c              |   59 +-
 fs/xfs/scrub/attr_repair.c       |   26 +-
 fs/xfs/scrub/bmap_repair.c       |    6 +-
 fs/xfs/scrub/btree.c             |    7 +-
 fs/xfs/scrub/common.c            |    3 +
 fs/xfs/scrub/common.h            |   25 -
 fs/xfs/scrub/dir.c               |   13 +-
 fs/xfs/scrub/dir_repair.c        |   19 +-
 fs/xfs/scrub/dirtree.c           |   19 +-
 fs/xfs/scrub/ialloc_repair.c     |   25 +-
 fs/xfs/scrub/nlinks.c            |    9 +-
 fs/xfs/scrub/parent.c            |   11 +-
 fs/xfs/scrub/parent_repair.c     |   23 +-
 fs/xfs/scrub/quotacheck.c        |   13 +-
 fs/xfs/scrub/refcount_repair.c   |   13 +-
 fs/xfs/scrub/repair.c            |    3 +
 fs/xfs/scrub/rmap_repair.c       |    5 +-
 fs/xfs/scrub/rtbitmap_repair.c   |    6 +-
 fs/xfs/scrub/rtrefcount_repair.c |   15 +-
 fs/xfs/scrub/rtrmap_repair.c     |    5 +-
 fs/xfs/scrub/rtsummary.c         |    7 +-
 fs/xfs/scrub/scrub.c             |    2 +-
 fs/xfs/xfs_fsops.c               |    6 +
 fs/xfs/xfs_health.c              |  138 +++++
 fs/xfs/xfs_healthmon.c           | 1255 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_healthmon.h           |  184 ++++++
 fs/xfs/xfs_ioctl.c               |    7 +
 fs/xfs/xfs_mount.c               |    2 +
 fs/xfs/xfs_mount.h               |    4 +
 fs/xfs/xfs_notify_failure.c      |   21 +-
 fs/xfs/xfs_platform.h            |    2 -
 fs/xfs/xfs_super.c               |   12 +
 fs/xfs/xfs_trace.c               |    5 +
 fs/xfs/xfs_trace.h               |  513 ++++++++++++++++
 fs/xfs/xfs_verify_media.c        |  445 ++++++++++++++
 fs/xfs/xfs_verify_media.h        |   13 +
 fs/xfs/xfs_zone_gc.c             |   44 +-
 49 files changed, 3241 insertions(+), 301 deletions(-)
 create mode 100644 fs/xfs/xfs_healthmon.c
 create mode 100644 fs/xfs/xfs_healthmon.h
 create mode 100644 fs/xfs/xfs_verify_media.c
 create mode 100644 fs/xfs/xfs_verify_media.h
