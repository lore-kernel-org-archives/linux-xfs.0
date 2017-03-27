Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47348 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752176AbdC0IuW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:50:22 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/27] xfs: filter out obviously bad btree pointers
Date: Mon, 27 Mar 2017 10:49:03 +0200
Message-Id: <20170327084922.11691-9-hch@lst.de>
In-Reply-To: <20170327084922.11691-1-hch@lst.de>
References: <20170327084922.11691-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit d5a91baeb6033c3392121e4d5c011cdc08dfa9f7 upstream.

Don't let anybody load an obviously bad btree pointer.  Since the values
come from disk, we must return an error, not just ASSERT.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c  | 5 +----
 fs/xfs/libxfs/xfs_btree.c | 3 ++-
 fs/xfs/libxfs/xfs_btree.h | 2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f52fd63fce19..02c466081991 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1278,7 +1278,6 @@ xfs_bmap_read_extents(
 	/* REFERENCED */
 	xfs_extnum_t		room;	/* number of entries there's room for */
 
-	bno = NULLFSBLOCK;
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	exntf = (whichfork != XFS_DATA_FORK) ? XFS_EXTFMT_NOSTATE :
@@ -1291,9 +1290,7 @@ xfs_bmap_read_extents(
 	ASSERT(level > 0);
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
-	ASSERT(bno != NULLFSBLOCK);
-	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
-	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
+
 	/*
 	 * Go down the tree until leaf level is reached, following the first
 	 * pointer (leftmost) at each level.
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 21e6a6ab6b9a..2849d3fa3d0b 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -810,7 +810,8 @@ xfs_btree_read_bufl(
 	xfs_daddr_t		d;		/* real disk block address */
 	int			error;
 
-	ASSERT(fsbno != NULLFSBLOCK);
+	if (!XFS_FSB_SANITY_CHECK(mp, fsbno))
+		return -EFSCORRUPTED;
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
 				   mp->m_bsize, lock, &bp, ops);
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index c2b01d1c79ee..3b0fc1afada5 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -491,7 +491,7 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
 #define	XFS_FILBLKS_MAX(a,b)	max_t(xfs_filblks_t, (a), (b))
 
 #define	XFS_FSB_SANITY_CHECK(mp,fsb)	\
-	(XFS_FSB_TO_AGNO(mp, fsb) < mp->m_sb.sb_agcount && \
+	(fsb && XFS_FSB_TO_AGNO(mp, fsb) < mp->m_sb.sb_agcount && \
 		XFS_FSB_TO_AGBNO(mp, fsb) < mp->m_sb.sb_agblocks)
 
 /*
-- 
2.11.0

