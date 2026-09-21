Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0D049EC6B
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997892; cv=none; b=h99TpHegITddtFhufuidCda9wPHiUyOJRWcSR82BsQICLmSV54LX66l6D/OtBl30JK2xgww/gXBy02Fbq9uhCWwufJmD1SP/38w3puHcd4stGEJPlaWO/UPlVUE1S6ouRjspSIPWwWrNFELjXVvHChMQ4CjQbJtGH9IgBzoa2XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997892; c=relaxed/simple;
	bh=CM6p6oV1s18V6Llx++Quaes1rHN2yJL6X2icA3THg44=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PfaL7ov7a5d5kv8oI5dWaE4pRcDPO2K3zLgavHjCWBJgjUylwcaNN9Row5HDNoinPj940GdxFV+zWsxxdoiS8yKWmN+TdreMbCuXfQE4Bjo8P7mI6WFdXiHXMS6JSyAoIVdJBrpaZR4su/Dfb00AhmilMdHNVk4Vc2e/bxrC+L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUNgw5ma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUNgw5ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787581F000FF;
	Mon, 21 Sep 2026 13:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789997891;
	bh=f4bIizeO61kU2djucmeBkSE/CE1+w/X+CAYXN4arC8E=;
	h=Date:From:To:Cc:Subject;
	b=DUNgw5ma/09UJ7SD6faMVo7HxlA9EQnmN+J03CYzeI4yFxopkn00X7Q6HTa4/1LFE
	 EsX+gtQ12k7yK1x5kIaMRGlS/rS22tkeEDiAM+CiBjfe3j2ppvwyfc4Vpa5AUsvL1X
	 oykNHE2Qk6Mxk92qvL1Z2mkU6JWer0dd8BMDO2ViFw/HtuGhvy+Vqd+PXdWFoeTWNV
	 pj9sCbtEQbifFvtGVZLwsOyeFgCWdS4TiBPZt7LnvbgdudzO4u75Acy8EZkCp+IlAD
	 X/EJj3b78Y9gNbxyy+4fCSEhH+9tkMGAM9BYRE27OBjDECbR+Y2eSORN+d7CRgLhe9
	 Um+eRC4CErwig==
Date: Mon, 21 Sep 2026 15:38:07 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.3-rc5
Message-ID: <arEueJixQ0UvCcC6@nidhogg.toxiclabs.cc>
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

This mostly contain 'random' bugfixes found by LLM tools on different xfs
subsystems. A few code cleanups and a NULL ptr deref on zoned support.
Those 'random' bugfixes include possible buf overrus, UAFs, block leaks,
etc...

Thanks,
Carlos

"The following changes since commit ad4497a92caba4630f75c80d49cb947026213280:

  xfs: advance the findparent inode scan cursor while holding ILOCK (2026-09-11 08:45:11 +0200)

are available in the Git repository at:

  gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.3-rc5

for you to fetch changes up to fe2f9135df43db849e74f03956d322ac20b59af7:

  xfs: fix wild memcpy access when formatting ondisk rtrefcount btree roots (2026-09-17 11:27:41 +0200)

----------------------------------------------------------------
xfs: fixes for v7.3-rc5

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Anuj Gupta (1):
      xfs: remove unused xfs_reflink_remap_range declaration

Christoph Hellwig (1):
      xfs: don't try to get a reference to a NULL oz in xfs_get_cached_zone

Darrick J. Wong (22):
      xfs: guard against igrab failure in xrep_findparent_from_dcache
      xfs: don't assert when XFS_SCRUB_TYPE_HEALTHY scans return corruption
      xfs: fix attr fork block count checks in xrep_inode_blockcounts
      xfs: release orphanage dir inode if chown fails
      xfs: release AGFL after walking it during rmapbt repair
      xfs: use correct jiffies comparison function in xchk_maybe_relax
      xfs: check padding field in xfs_ioc_commit_range
      xfs: don't call xfs_exchange_range_finish for a dry run
      xfs: use the correct reservations for rtrmap/refcount recovery
      xfs: fix integer overflows in xbitmap set functions
      xfs: only flag zero padding for dir3 data blocks, not dir3 block blocks
      xfs: check di_forkoff correctly in scrub
      xfs: call xfs_dquot_set_prealloc_limits if we installed default rtb limits
      xfs: fix rtgroup repair estimations
      xfs: don't cross reference rmapbt with bitmaps if they're incomplete
      xfs: don't let memory failures leak blocks and kill repairs
      xfs: don't merge different file IO error types
      xfs: fix blockgc group quota scanning when usrquota isn't enforced
      xfs: fix cursor and pointer handling when recovering iunlink buckets
      xfs: drop dquot flush lock when we can't find a buffer to flush
      xfs: don't let hidden_space go negative in xfs_metafile_resv_init
      xfs: fix wild memcpy access when formatting ondisk rtrefcount btree roots

Hemanth Selam (1):
      xfs: fix typos and repeated words in comments

Jiangshan Yi (1):
      xfs: remove duplicate INO1_WRITTEN check

 fs/xfs/libxfs/xfs_ag.h               |  2 +-
 fs/xfs/libxfs/xfs_alloc.c            |  4 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c        |  2 +-
 fs/xfs/libxfs/xfs_errortag.h         |  2 +-
 fs/xfs/libxfs/xfs_exchmaps.c         | 12 +-----------
 fs/xfs/libxfs/xfs_format.h           |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c        |  2 +-
 fs/xfs/libxfs/xfs_metafile.c         |  8 ++++----
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  4 ++--
 fs/xfs/scrub/agheader_repair.c       |  2 +-
 fs/xfs/scrub/alloc_repair.c          |  2 +-
 fs/xfs/scrub/bitmap.c                | 26 ++++++++++++++++++--------
 fs/xfs/scrub/dir.c                   |  2 +-
 fs/xfs/scrub/dirtree.c               |  2 +-
 fs/xfs/scrub/findparent.c            |  3 +++
 fs/xfs/scrub/health.c                |  6 +++---
 fs/xfs/scrub/inode.c                 |  2 +-
 fs/xfs/scrub/inode_repair.c          |  2 +-
 fs/xfs/scrub/newbt.c                 |  8 +++++---
 fs/xfs/scrub/orphanage.c             |  6 +++++-
 fs/xfs/scrub/reap.c                  |  2 +-
 fs/xfs/scrub/repair.c                | 19 +++++++++++++++++--
 fs/xfs/scrub/rmap.c                  | 20 ++++++++++++++------
 fs/xfs/scrub/rmap_repair.c           |  1 +
 fs/xfs/scrub/scrub.h                 |  2 +-
 fs/xfs/scrub/trace.h                 | 12 ++++++++----
 fs/xfs/xfs_bmap_item.c               |  2 +-
 fs/xfs/xfs_dquot.c                   |  8 ++++++--
 fs/xfs/xfs_exchrange.c               | 13 +++++++++----
 fs/xfs/xfs_healthmon.c               |  4 +++-
 fs/xfs/xfs_icache.c                  |  2 +-
 fs/xfs/xfs_inode.c                   |  2 +-
 fs/xfs/xfs_log_cil.c                 |  2 +-
 fs/xfs/xfs_log_recover.c             | 13 ++++++++-----
 fs/xfs/xfs_platform.h                |  2 +-
 fs/xfs/xfs_qm.c                      | 10 ++++++++--
 fs/xfs/xfs_refcount_item.c           |  8 ++++++--
 fs/xfs/xfs_reflink.h                 |  3 ---
 fs/xfs/xfs_rmap_item.c               |  8 ++++++--
 fs/xfs/xfs_zone_alloc.c              |  4 ++--
 fs/xfs/xfs_zone_gc.c                 |  2 +-
 41 files changed, 150 insertions(+), 88 deletions(-)"
