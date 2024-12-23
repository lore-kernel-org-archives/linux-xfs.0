Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA61433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992876; cv=none; b=Sdvs4CeCSP7cgXL6XfoD+mWLj+VjwLXc+v1NKi7LQNC2Z8mZhAS50GF2gsSbHNvXh65fyOKMuMEa1E3TpwbFXxjdfCRRmuLzUb5meCyTBiMjwwyOt52cc0P1x7QNEAG+Gi/E+kjLRkjLPbMHNhn8fZPFItfVbvyOBkhCs9XWnTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992876; c=relaxed/simple;
	bh=cRZ0WkxbzPP52F2SEnRiQtsEWBbwmpdDwG1cCRytp3s=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Bx6fTqEF2dP3/cLXGacQ/bfSlvmxjJ3PHUFEFo5mBDy2htJHsbZfwSfZNHFxq8a4qtbSjuZf/tZcZ9S+AtITwV3+U2e2lW7uCh5jJlOvavsbTor/IiwkPWgG1s9dkhz6vtknpvxQQ//Jc46PEvam7czh40mFgKYXXbRR+pGbmyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bB9rUmYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bB9rUmYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24274C4CED3;
	Mon, 23 Dec 2024 22:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992876;
	bh=cRZ0WkxbzPP52F2SEnRiQtsEWBbwmpdDwG1cCRytp3s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bB9rUmYNoMO3p5lC3DEamFYvvs5njwzFUHfkEqDfZ0REkoidQJHeivaA2GZ/sXW1M
	 tHIB0Fl92/X+NVqaokPOPjMvvENFUY+6ZNQr+cIBf9hww7EmBKqtBq2zHoyziSv/ci
	 hlH9akhuDaOG2bDYMuzsWkdFNYEVsd+eYUAwLCcUDDS5UhTBNTFuXgtoO7tRJNimmh
	 GKeRVShAB/BDFl1gIs0S6uRpgqfD8haEcIFNc8/s8ucV9qKsRahtEe2J3xXy+WMClh
	 PKiR+giEfxKwIoM7pYw0Fi4ShFpvJ+Gl6YfaF3hfJcGuauT7RDGPvLqvREi9jgatHO
	 MUhzQKnd+U4fg==
Date: Mon, 23 Dec 2024 14:27:55 -0800
Subject: [GIT PULL 2/8] libxfs: metadata inode directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, dchinner@redhat.com, hch@lst.de, leo.lilong@huawei.com, linux-xfs@vger.kernel.org
Message-ID: <173498954185.2301496.11361460660288656447.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241223212904.GQ6174@frogsfrogsfrogs>
References: <20241223212904.GQ6174@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 50e3f6684fe5adb4138ec5882b316c00524a6051:

man: document the -n parent mkfs option (2024-12-23 13:05:06 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/metadata-directory-tree-sync_2024-12-23

for you to fetch changes up to 1d6b5c7e0476de97a15123768513cb3bb10803c7:

xfs: check metadata directory file path connectivity (2024-12-23 13:05:08 -0800)

----------------------------------------------------------------
libxfs: metadata inode directory trees [v6.2 02/23]

Synchronize libxfs with the kernel.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (22):
xfs: remove the unused pagb_count field in struct xfs_perag
xfs: remove the unused pag_active_wq field in struct xfs_perag
xfs: pass a pag to xfs_difree_inode_chunk
xfs: remove the agno argument to xfs_free_ag_extent
xfs: add xfs_agbno_to_fsb and xfs_agbno_to_daddr helpers
xfs: add a xfs_agino_to_ino helper
xfs: pass a pag to xfs_extent_busy_{search,reuse}
xfs: pass a perag structure to the xfs_ag_resv_init_error trace point
xfs: pass objects to the xfs_irec_merge_{pre,post} trace points
xfs: convert remaining trace points to pass pag structures
xfs: split xfs_initialize_perag
xfs: insert the pag structures into the xarray later
xfs: factor out a generic xfs_group structure
xfs: add a xfs_group_next_range helper
xfs: switch perag iteration from the for_each macros to a while based iterator
xfs: move metadata health tracking to the generic group structure
xfs: move draining of deferred operations to the generic group structure
xfs: move the online repair rmap hooks to the generic group structure
xfs: convert busy extent tracking to the generic group structure
xfs: add a generic group pointer to the btree cursor
xfs: add group based bno conversion helpers
xfs: store a generic group structure in the intents

Darrick J. Wong (12):
xfs: constify the xfs_sb predicates
xfs: rename metadata inode predicates
xfs: define the on-disk format for the metadir feature
xfs: iget for metadata inodes
xfs: enforce metadata inode flag
xfs: read and write metadata inode directory tree
xfs: disable the agi rotor for metadata inodes
xfs: advertise metadata directory feature
xfs: allow bulkstat to return metadata directories
xfs: adjust xfs_bmap_add_attrfork for metadir
xfs: record health problems with the metadata directory
xfs: check metadata directory file path connectivity

Dave Chinner (1):
xfs: sb_spino_align is not verified

Long Li (1):
xfs: remove the redundant xfs_alloc_log_agf

db/check.c                  |   2 +-
db/fsmap.c                  |  10 +-
db/info.c                   |   7 +-
db/inode.c                  |   4 +-
db/iunlink.c                |   6 +-
include/libxfs.h            |   2 +
include/xfs_inode.h         |  11 +
include/xfs_mount.h         |  45 ++++-
include/xfs_trace.h         |  31 ++-
include/xfs_trans.h         |   3 +
libfrog/radix-tree.h        |   9 +
libxfs/Makefile             |   6 +
libxfs/defer_item.c         |  35 ++--
libxfs/init.c               |   8 +-
libxfs/inode.c              |  55 +++++
libxfs/iunlink.c            |  11 +-
libxfs/libxfs_api_defs.h    |  15 +-
libxfs/libxfs_priv.h        |  10 +-
libxfs/trans.c              |  39 ++++
libxfs/util.c               |   4 +-
libxfs/xfs_ag.c             | 246 ++++++++---------------
libxfs/xfs_ag.h             | 189 ++++++++++-------
libxfs/xfs_ag_resv.c        |  22 +-
libxfs/xfs_alloc.c          | 104 +++++-----
libxfs/xfs_alloc.h          |   7 +-
libxfs/xfs_alloc_btree.c    |  30 +--
libxfs/xfs_attr.c           |   5 +-
libxfs/xfs_bmap.c           |   7 +-
libxfs/xfs_bmap.h           |   2 +-
libxfs/xfs_btree.c          |  38 ++--
libxfs/xfs_btree.h          |   3 +-
libxfs/xfs_btree_mem.c      |   6 +-
libxfs/xfs_format.h         | 121 ++++++++---
libxfs/xfs_fs.h             |  25 ++-
libxfs/xfs_group.c          | 223 ++++++++++++++++++++
libxfs/xfs_group.h          | 131 ++++++++++++
libxfs/xfs_health.h         |  51 ++---
libxfs/xfs_ialloc.c         | 175 ++++++++--------
libxfs/xfs_ialloc_btree.c   |  29 +--
libxfs/xfs_inode_buf.c      |  90 ++++++++-
libxfs/xfs_inode_buf.h      |   3 +
libxfs/xfs_inode_util.c     |   6 +-
libxfs/xfs_log_format.h     |   2 +-
libxfs/xfs_metadir.c        | 480 ++++++++++++++++++++++++++++++++++++++++++++
libxfs/xfs_metadir.h        |  47 +++++
libxfs/xfs_metafile.c       |  52 +++++
libxfs/xfs_metafile.h       |  31 +++
libxfs/xfs_ondisk.h         |   2 +-
libxfs/xfs_refcount.c       |  33 ++-
libxfs/xfs_refcount.h       |   2 +-
libxfs/xfs_refcount_btree.c |  17 +-
libxfs/xfs_rmap.c           |  42 ++--
libxfs/xfs_rmap.h           |   6 +-
libxfs/xfs_rmap_btree.c     |  28 +--
libxfs/xfs_sb.c             |  54 +++--
libxfs/xfs_types.c          |   9 +-
libxfs/xfs_types.h          |  10 +-
repair/agbtree.c            |  27 ++-
repair/bmap_repair.c        |  11 +-
repair/bulkload.c           |   9 +-
repair/dino_chunks.c        |   2 +-
repair/dinode.c             |  12 +-
repair/phase2.c             |  17 +-
repair/phase5.c             |   6 +-
repair/rmap.c               |  12 +-
65 files changed, 2032 insertions(+), 705 deletions(-)
create mode 100644 libxfs/xfs_group.c
create mode 100644 libxfs/xfs_group.h
create mode 100644 libxfs/xfs_metadir.c
create mode 100644 libxfs/xfs_metadir.h
create mode 100644 libxfs/xfs_metafile.c
create mode 100644 libxfs/xfs_metafile.h

