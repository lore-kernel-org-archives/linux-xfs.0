Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E52188596;
	Mon, 23 Dec 2024 22:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992923; cv=none; b=AEJH9kTnMkGf2vaJKNVd0wrOtQXRO00gx8V67WGQMxTpfhgtEdaxhIEwEOul7UiCPuKYrqkF9UrhNpCP5FkyvMTF/W3vVM9IMh2kseeOcOJrL7MaQOnPQrWitHUUpTUmmuD5ppVTEYY0UiumJKWkxgZfML1IMXB2WvoDceMWFC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992923; c=relaxed/simple;
	bh=BKMhmsocqaQ8j1Miatar58/pD1rw0gYWFuKrEGxYFbY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=ScRmmSgUmrgs9ka0iKx3X8H5q7Bl2I28HodFeaArydIiQZQ7aFpFfDqyJ89Bre7sfLGvEfEckagt3dKTiK7OjIWpRy9DIQQXcgQ6le3n5j8ajZ2T3t27bGeEOu72097YrdhUpfAaQOLbTlktJMDEYlxXBbRpuXRAh6MBWlYVseE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGX9APS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGX9APS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00130C4CED3;
	Mon, 23 Dec 2024 22:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992923;
	bh=BKMhmsocqaQ8j1Miatar58/pD1rw0gYWFuKrEGxYFbY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AGX9APS104VNdxcv7LumWpLmKmbQluJs/iBLWQFG+eSCRm4g4TFVj6vj4ymvNPtYJ
	 76UaXEQWY8Ygm9yGCIhgMlzAXHiugXivMF/LURiCh9894v2rgPIaX20OgPdOk6y5og
	 hbIrnQkb7nWTKCJwORqsbesvU7nagiHWUzFKM3V9hWcS8XITRgWTSqlqxXVjbKaFkC
	 mqwjbpUNPErcCnqNBZqnEUWpuKLcoO4B2Q24+/fVO4dwpYr4bWluBgPyy+OBvRgC8u
	 3xBZ+9JzZgjiesfCwdvMyiqyfIISMWgvizZzoCWkC4DAPWbXTu9suiH3uZSs6tm5IO
	 lL3q2T5i8/7RQ==
Date: Mon, 23 Dec 2024 14:28:42 -0800
Subject: [GIT PULL 5/8] xfsprogs: new code for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: brauner@kernel.org, cem@kernel.org, dan.carpenter@linaro.org, dchinner@redhat.com, hch@lst.de, jlayton@kernel.org, josef@toxicpanda.com, leo.lilong@huawei.com, linux-xfs@vger.kernel.org, rdunlap@infradead.org, stable@vger.kernel.org
Message-ID: <173498954462.2301496.14094263333139867704.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 513300e9565b0d446ac8e6a3a990444d766c728b:

mkfs: add a utility to generate protofiles (2024-12-23 13:05:10 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/xfs-6.13-merge_2024-12-23

for you to fetch changes up to 80b81c84f015ee01fed80c32184cc763ee1a655e:

xfs: return from xfs_symlink_verify early on V4 filesystems (2024-12-23 13:05:13 -0800)

----------------------------------------------------------------
xfsprogs: new code for 6.13 [05/23]

New code for 6.12.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (9):
xfs: add a xfs_bmap_free_rtblocks helper
xfs: move RT bitmap and summary information to the rtgroup
xfs: support creating per-RTG files in growfs
xfs: refactor xfs_rtbitmap_blockcount
xfs: refactor xfs_rtsummary_blockcount
xfs: make RT extent numbers relative to the rtgroup
xfs: add a helper to prevent bmap merges across rtgroup boundaries
xfs: make the RT allocator rtgroup aware
xfs: don't call xfs_bmap_same_rtgroup in xfs_bmap_add_extent_hole_delay

Darrick J. Wong (40):
xfs: create incore realtime group structures
xfs: define locking primitives for realtime groups
xfs: add a lockdep class key for rtgroup inodes
xfs: support caching rtgroup metadata inodes
libfrog: add memchr_inv
xfs: define the format of rt groups
xfs: update realtime super every time we update the primary fs super
xfs: export realtime group geometry via XFS_FSOP_GEOM
xfs: check that rtblock extents do not break rtsupers or rtgroups
xfs: add frextents to the lazysbcounters when rtgroups enabled
xfs: record rt group metadata errors in the health system
xfs: export the geometry of realtime groups to userspace
xfs: add block headers to realtime bitmap and summary blocks
xfs: encode the rtbitmap in big endian format
xfs: encode the rtsummary in big endian format
xfs: grow the realtime section when realtime groups are enabled
xfs: support logging EFIs for realtime extents
xfs: support error injection when freeing rt extents
xfs: use realtime EFI to free extents when rtgroups are enabled
xfs: don't merge ioends across RTGs
xfs: scrub the realtime group superblock
xfs: scrub metadir paths for rtgroup metadata
xfs: mask off the rtbitmap and summary inodes when metadir in use
xfs: create helpers to deal with rounding xfs_fileoff_t to rtx boundaries
xfs: create helpers to deal with rounding xfs_filblks_t to rtx boundaries
xfs: make xfs_rtblock_t a segmented address like xfs_fsblock_t
xfs: adjust min_block usage in xfs_verify_agbno
xfs: move the min and max group block numbers to xfs_group
xfs: implement busy extent tracking for rtgroups
xfs: use metadir for quota inodes
xfs: scrub quota file metapaths
xfs: enable metadata directory feature
xfs: convert struct typedefs in xfs_ondisk.h
xfs: separate space btree structures in xfs_ondisk.h
xfs: port ondisk structure checks from xfs/122 to the kernel
xfs: return a 64-bit block count from xfs_btree_count_blocks
xfs: fix error bailout in xfs_rtginode_create
xfs: update btree keys correctly when _insrec splits an inode root block
xfs: fix sb_spino_align checks for large fsblock sizes
xfs: return from xfs_symlink_verify early on V4 filesystems

Dave Chinner (1):
xfs: fix sparse inode limits on runt AG

Jeff Layton (1):
xfs: switch to multigrain timestamps

Long Li (1):
xfs: remove unknown compat feature check in superblock write validation

db/block.c                  |   2 +-
db/block.h                  |  16 -
db/convert.c                |   1 -
db/faddr.c                  |   1 -
include/libxfs.h            |   2 +
include/platform_defs.h     |  33 +++
include/xfs_mount.h         |  30 +-
include/xfs_trace.h         |   7 +
include/xfs_trans.h         |   1 +
libfrog/util.c              |  14 +
libfrog/util.h              |   4 +
libxfs/Makefile             |   2 +
libxfs/init.c               |  35 ++-
libxfs/libxfs_api_defs.h    |  16 +
libxfs/libxfs_io.h          |   1 +
libxfs/libxfs_priv.h        |  34 +--
libxfs/rdwr.c               |  17 ++
libxfs/trans.c              |  29 ++
libxfs/util.c               |   8 +-
libxfs/xfs_ag.c             |  22 +-
libxfs/xfs_ag.h             |  16 +-
libxfs/xfs_alloc.c          |  15 +-
libxfs/xfs_alloc.h          |  12 +-
libxfs/xfs_bmap.c           | 124 ++++++--
libxfs/xfs_btree.c          |  33 ++-
libxfs/xfs_btree.h          |   2 +-
libxfs/xfs_defer.c          |   6 +
libxfs/xfs_defer.h          |   1 +
libxfs/xfs_dquot_buf.c      | 190 ++++++++++++
libxfs/xfs_format.h         |  80 ++++-
libxfs/xfs_fs.h             |  32 +-
libxfs/xfs_group.h          |  33 +++
libxfs/xfs_health.h         |  42 +--
libxfs/xfs_ialloc.c         |  16 +-
libxfs/xfs_ialloc_btree.c   |   6 +-
libxfs/xfs_log_format.h     |   6 +-
libxfs/xfs_ondisk.h         | 186 +++++++++---
libxfs/xfs_quota_defs.h     |  43 +++
libxfs/xfs_rtbitmap.c       | 405 +++++++++++++++++---------
libxfs/xfs_rtbitmap.h       | 247 ++++++++++------
libxfs/xfs_rtgroup.c        | 694 ++++++++++++++++++++++++++++++++++++++++++++
libxfs/xfs_rtgroup.h        | 284 ++++++++++++++++++
libxfs/xfs_sb.c             | 246 ++++++++++++++--
libxfs/xfs_sb.h             |   6 +-
libxfs/xfs_shared.h         |   4 +
libxfs/xfs_symlink_remote.c |   4 +-
libxfs/xfs_trans_inode.c    |   6 +-
libxfs/xfs_trans_resv.c     |   2 +-
libxfs/xfs_types.c          |  35 ++-
libxfs/xfs_types.h          |   8 +-
mkfs/proto.c                |  33 ++-
mkfs/xfs_mkfs.c             |   8 +
repair/dinode.c             |   4 +-
repair/phase6.c             | 203 +++++++------
repair/rt.c                 |  34 +--
repair/rt.h                 |   4 +-
56 files changed, 2728 insertions(+), 617 deletions(-)
create mode 100644 libxfs/xfs_rtgroup.c
create mode 100644 libxfs/xfs_rtgroup.h

