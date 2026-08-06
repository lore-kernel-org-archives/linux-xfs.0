Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B29A353A8F
	for <linux-xfs@vger.kernel.org>; Thu,  6 Aug 2026 09:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786007897; cv=none; b=A96BBA+ipTlFLHRgxuiy/QhNXVUTz+kJH7yzwAvkLokbY56fV/jBbLAIKlIN/sPnOx8BJ2atJWOJLnBqIwdOUc++Xb0Ci0lEz3k4kL+AS6X1Q+uB63ytmoe/gw3FcZL/rIBfUVFl6ao6ELVxH4A6o6JZq+jM20XSSW9Lafvyt30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786007897; c=relaxed/simple;
	bh=JpHwjZn0QUSdBbZlFkc08H4OZgOCgRI9KGovcE2bi5I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EKAkjN0e0ox6LBMEJw2Emh6sCTxF7+vTaCBHPOSSbKxmcO1zl+S0cBA4u/kP8MGNDF9lXRp8Fe9j6Aa1ktVl4RS6PN2ppAKCC8JVVl0uhlj+QO7urk/9/kVUHGi1j/vVJQW4t/iu840fGRm9zvHfjMG6OKbFXdX1Zl28RoUPYZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FvjS4XsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FvjS4XsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888841F000E9;
	Thu,  6 Aug 2026 09:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786007896;
	bh=QV3TnC1/HkTYUwuWfRzLhbpbREb4B36KyZxgm1mfOAQ=;
	h=Date:From:To:Cc:Subject;
	b=FvjS4XsB21twHQMzlFPNgdmKNuI5O7XJZhB7sSA++0T9SHU8WwhT9XrTkwTe86MSO
	 bx+rpCcEJtl7x0bRMnJj54cG1e6e7TUL7cUdnZinPwRwtvMNlzwRmalGHmEbVmBKx3
	 abBSPPvpqade/79CzCgcqX2kRPiCATkps3kvwERz2z2YUxKSbeL13ngCgRQTjUGfFP
	 hTxKnCs1NPh7NGqEhyN2w8FO6myC/oNzbVC1tqakxxZ+VRrhTaoMR8w618Socv2PdW
	 1D5OjUdnHKHQ9S90X9NjF6mw5gCHXr5vSn2kMEmuDgTLng0XFO6xlCyQVua6d3fa6i
	 g4oyM7ivcVtag==
Date: Thu, 6 Aug 2026 11:18:11 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.2-rc7
Message-ID: <anRAZ3k7id6zqYh-@andromeda.toxiclabs.cc>
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

This contains mostly a collection of bug fixes found by LLM tools.

An attempt merge against your current TOT has been successful.

Thanks,
Carlos

"The following changes since commit 59c462b0f5cfa107794228051724b34ae9334168:

  xfs: don't zap bmbt forks if they are MAXLEVELS tall (2026-07-14 11:01:47 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.2-rc7

for you to fetch changes up to eb6b2cc1fc8ad566d746d128a559989ff0bba5cc:

  xfs: check v5 superblock features early (2026-08-03 10:30:28 +0200)

----------------------------------------------------------------
xfs: fixes for 7.2-rc7

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Andrey Albershteyn (1):
      xfs: fix inverted clearance of inode junk flags

Christoph Hellwig (4):
      xfs: update BDI {io,ra}_pages values based on the RT device limits
      xfs: add a separate bio_set for spliting GC writes
      xfs: add a comment to describe xfs_gc_bio.victim_rtg
      xfs: check v5 superblock features early

Darrick J. Wong (21):
      xfs: check cowextsize in xrep_inode_cowextsize
      xfs: fix transaction block reservation in xrep_rtbitmap
      xfs: rtsummary scrub should treat rtbitmap corruption errors as an xref error
      xfs: zero i_nlink before repair puts inode on unlinked list
      xfs: mark nonzero sb_gquotino as corrupt on metadir filesystems
      xfs: only check mergeability of bnobt records
      xfs: don't double-lock when deleting a self-referential directory
      xfs: don't return EFSCORRUPTED when scrubbing corrupt parent pointers
      xfs: don't zap the attr fork on repair when there are queued pptr updates
      xfs: nlink scrub must take IOLOCK before determining ILOCK state
      xfs: avoid UAF on sc->tempip in xrep_tempfile_create
      xfs: hoist per-bucket unlinked list check to helper
      xfs: don't livelock in scrub on a circular unlinked list
      xfs: don't walk off the end of a null sc->sa.agi_bp in AGI repair
      xfs: load next_agino from the correct xfarray in xrep_iunlink_relink_prev
      xfs: pass runtime errors from xrep_iunlink_mark_ondisk_rec up to callers
      xfs: check xfarray iteration errors when committing unlinked inode lists
      xfs: fix allocated inodes that show up in the unlinked list
      xfs: fix another iunlink infinite loop bug in online fsck
      xfs: set the prev pointer when reinserting an inode on the unlinked list
      xfs: don't ignore runtime errors in xrep_iunlink_reload_next

Guanghui Yang (1):
      xfs: propagate errors from xfs_rtginode_load

Ibrahim Hashimov (1):
      xfs: bounds-check buffer log item's dirty bitmap

Lin Jiapeng (1):
      xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Long Li (2):
      xfs: fix ilock leak on error in xfs_dq_get_next_id
      xfs: don't swallow dquot recovery verification errors

Qiang Ma (1):
      xfs: clear zapped attr fork state when bmap repair finds no attr fork

Xiang Mei (1):
      xfs: fix off-by-one in rtrefcount btree root level validation

Yun Zhou (1):
      xfs: handle NULL b_addr in xfs_buf_free

 fs/xfs/libxfs/xfs_exchmaps.c         |  10 +++
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   4 +-
 fs/xfs/libxfs/xfs_sb.c               |   4 +-
 fs/xfs/scrub/agheader.c              |  98 ++++++++++++++------
 fs/xfs/scrub/agheader_repair.c       | 169 +++++++++++++++++++++++++++++------
 fs/xfs/scrub/alloc.c                 |   5 +-
 fs/xfs/scrub/attr_repair.c           |   3 +-
 fs/xfs/scrub/bmap.c                  |   5 ++
 fs/xfs/scrub/dirtree_repair.c        |  22 ++++-
 fs/xfs/scrub/inode_repair.c          |   6 +-
 fs/xfs/scrub/nlinks.c                |  13 +--
 fs/xfs/scrub/nlinks_repair.c         |   7 +-
 fs/xfs/scrub/parent.c                |   2 +-
 fs/xfs/scrub/rtbitmap_repair.c       |  46 ++++++----
 fs/xfs/scrub/rtsummary.c             |   2 +-
 fs/xfs/scrub/tempfile.c              |   1 +
 fs/xfs/scrub/trace.h                 |   2 +
 fs/xfs/xfs_buf.c                     |   2 +-
 fs/xfs/xfs_buf_item_recover.c        |  57 ++++++++----
 fs/xfs/xfs_dquot.c                   |   3 +-
 fs/xfs/xfs_dquot_item_recover.c      |   2 +-
 fs/xfs/xfs_mount.h                   |   7 ++
 fs/xfs/xfs_rtalloc.c                 |   2 +-
 fs/xfs/xfs_super.c                   |  53 ++++++++++-
 fs/xfs/xfs_zone_gc.c                 |  13 ++-
 25 files changed, 421 insertions(+), 117 deletions(-)"
