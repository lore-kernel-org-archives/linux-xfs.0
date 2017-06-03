Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51629 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbdFCNPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:15:51 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/23] xfs: reserve enough blocks to handle btree splits when remapping
Date: Sat,  3 Jun 2017 15:15:00 +0200
Message-Id: <20170603131511.25032-13-hch@lst.de>
In-Reply-To: <20170603131511.25032-1-hch@lst.de>
References: <20170603131511.25032-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit fe0be23e68200573de027de9b8cc2b27e7fce35e upstream.

In xfs_reflink_end_cow, we erroneously reserve only enough blocks to
handle adding 1 extent.  This is problematic if we fragment free space,
have to do CoW, and then have to perform multiple bmap btree expansions.
Furthermore, the BUI recovery routine doesn't reserve /any/ blocks to
handle btree splits, so log recovery fails after our first error causes
the filesystem to go down.

Therefore, refactor the transaction block reservation macros until we
have a macro that works for our deferred (re)mapping activities, and fix
both problems by using that macro.

With 1k blocks we can hit this fairly often in g/187 if the scratch fs
is big enough.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_trans_space.h | 23 +++++++++++++++++------
 fs/xfs/xfs_bmap_item.c          |  5 ++++-
 fs/xfs/xfs_reflink.c            | 18 ++++++++++++++++--
 3 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 7917f6e44286..d787c677d2a3 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -21,8 +21,20 @@
 /*
  * Components of space reservations.
  */
+
+/* Worst case number of rmaps that can be held in a block. */
 #define XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)    \
 		(((mp)->m_rmap_mxr[0]) - ((mp)->m_rmap_mnr[0]))
+
+/* Adding one rmap could split every level up to the top of the tree. */
+#define XFS_RMAPADD_SPACE_RES(mp) ((mp)->m_rmap_maxlevels)
+
+/* Blocks we might need to add "b" rmaps to a tree. */
+#define XFS_NRMAPADD_SPACE_RES(mp, b)\
+	(((b + XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp) - 1) / \
+	  XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) * \
+	  XFS_RMAPADD_SPACE_RES(mp))
+
 #define XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)    \
 		(((mp)->m_alloc_mxr[0]) - ((mp)->m_alloc_mnr[0]))
 #define	XFS_EXTENTADD_SPACE_RES(mp,w)	(XFS_BM_MAXLEVELS(mp,w) - 1)
@@ -30,13 +42,12 @@
 	(((b + XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp) - 1) / \
 	  XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * \
 	  XFS_EXTENTADD_SPACE_RES(mp,w))
+
+/* Blocks we might need to add "b" mappings & rmappings to a file. */
 #define XFS_SWAP_RMAP_SPACE_RES(mp,b,w)\
-	(((b + XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp) - 1) / \
-	  XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * \
-	  XFS_EXTENTADD_SPACE_RES(mp,w) + \
-	 ((b + XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp) - 1) / \
-	  XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) * \
-	  (mp)->m_rmap_maxlevels)
+	(XFS_NEXTENTADD_SPACE_RES((mp), (b), (w)) + \
+	 XFS_NRMAPADD_SPACE_RES((mp), (b)))
+
 #define	XFS_DAENTER_1B(mp,w)	\
 	((w) == XFS_DATA_FORK ? (mp)->m_dir_geo->fsbcount : 1)
 #define	XFS_DAENTER_DBS(mp,w)	\
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 9bf57c76623b..c4b90e794e41 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -34,6 +34,8 @@
 #include "xfs_bmap.h"
 #include "xfs_icache.h"
 #include "xfs_trace.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
 
 
 kmem_zone_t	*xfs_bui_zone;
@@ -446,7 +448,8 @@ xfs_bui_recover(
 		return -EIO;
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
 	if (error)
 		return error;
 	budp = xfs_trans_get_bud(tp, buip);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4a84c5ea266d..20c46d2ff4f5 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -709,8 +709,22 @@ xfs_reflink_end_cow(
 	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
 	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
 
-	/* Start a rolling transaction to switch the mappings */
-	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
+	/*
+	 * Start a rolling transaction to switch the mappings.  We're
+	 * unlikely ever to have to remap 16T worth of single-block
+	 * extents, so just cap the worst case extent count to 2^32-1.
+	 * Stick a warning in just in case, and avoid 64-bit division.
+	 */
+	BUILD_BUG_ON(MAX_RW_COUNT > UINT_MAX);
+	if (end_fsb - offset_fsb > UINT_MAX) {
+		error = -EFSCORRUPTED;
+		xfs_force_shutdown(ip->i_mount, SHUTDOWN_CORRUPT_INCORE);
+		ASSERT(0);
+		goto out;
+	}
+	resblks = XFS_NEXTENTADD_SPACE_RES(ip->i_mount,
+			(unsigned int)(end_fsb - offset_fsb),
+			XFS_DATA_FORK);
 	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
 			resblks, 0, 0, &tp);
 	if (error)
-- 
2.11.0

