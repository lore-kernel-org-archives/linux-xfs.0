Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D9FB7FF5
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:58:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 637AE304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:58:20 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 61zCk1mT5oJAFMtG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:58:17 -0800 (PST)
Subject: [PATCH 17/76] xfs: rmap btree transaction reservations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:58:14 -0800
Message-ID: <20151219085814.12713.90876.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

>From : Dave Chinner <dchinner@redhat.com>

The rmap btrees will use the AGFL as the block allocation source, so
we need to ensure that the transaction reservations reflect the fact
this tree is modified by allocation and freeing. Hence we need to
extend all the extent allocation/free reservations used in
transactions to handle this.

Note that this also gets rid of the unused XFS_ALLOCFREE_LOG_RES
macro, as we now do buffer reservations based on the number of
buffers logged via xfs_calc_buf_res(). Hence we only need the buffer
count calculation now.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c |   56 ++++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_trans_resv.h |   10 -------
 2 files changed, 39 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 68cb1e7..d495f82 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -64,6 +64,28 @@ xfs_calc_buf_res(
 }
 
 /*
+ * Per-extent log reservation for the allocation btree changes
+ * involved in freeing or allocating an extent. When rmap is not enabled,
+ * there are only two trees that will be modified (free space trees), and when
+ * rmap is enabled there will be three (freespace + rmap trees). The number of
+ * blocks reserved is based on the formula:
+ *
+ * num trees * ((2 blocks/level * max depth) - 1)
+ */
+static uint
+xfs_allocfree_log_count(
+	struct xfs_mount *mp,
+	uint		num_ops)
+{
+	uint		num_trees = 2;
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		num_trees++;
+
+	return num_ops * num_trees * (2 * mp->m_ag_maxlevels - 1);
+}
+
+/*
  * Logging inodes is really tricksy. They are logged in memory format,
  * which means that what we write into the log doesn't directly translate into
  * the amount of space they use on disk.
@@ -126,7 +148,7 @@ xfs_calc_inode_res(
  */
 STATIC uint
 xfs_calc_finobt_res(
-	struct xfs_mount 	*mp,
+	struct xfs_mount	*mp,
 	int			alloc,
 	int			modify)
 {
@@ -137,7 +159,7 @@ xfs_calc_finobt_res(
 
 	res = xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1));
 	if (alloc)
-		res += xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1), 
+		res += xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
 					XFS_FSB_TO_B(mp, 1));
 	if (modify)
 		res += (uint)XFS_FSB_TO_B(mp, 1);
@@ -188,10 +210,10 @@ xfs_calc_write_reservation(
 		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
 				      XFS_FSB_TO_B(mp, 1)) +
 		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
+		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
+		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
 				      XFS_FSB_TO_B(mp, 1))));
 }
 
@@ -217,10 +239,10 @@ xfs_calc_itruncate_reservation(
 		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1,
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 4),
+		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
 				      XFS_FSB_TO_B(mp, 1)) +
 		    xfs_calc_buf_res(5, 0) +
-		    xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+		    xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
 				     XFS_FSB_TO_B(mp, 1)) +
 		    xfs_calc_buf_res(2 + mp->m_ialloc_blks +
 				     mp->m_in_maxlevels, 0)));
@@ -247,7 +269,7 @@ xfs_calc_rename_reservation(
 		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 3),
+		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 3),
 				      XFS_FSB_TO_B(mp, 1))));
 }
 
@@ -286,7 +308,7 @@ xfs_calc_link_reservation(
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
 				      XFS_FSB_TO_B(mp, 1))));
 }
 
@@ -324,7 +346,7 @@ xfs_calc_remove_reservation(
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
+		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
 				      XFS_FSB_TO_B(mp, 1))));
 }
 
@@ -371,7 +393,7 @@ xfs_calc_create_resv_alloc(
 		mp->m_sb.sb_sectsize +
 		xfs_calc_buf_res(mp->m_ialloc_blks, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
 }
 
@@ -399,7 +421,7 @@ xfs_calc_icreate_resv_alloc(
 	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		mp->m_sb.sb_sectsize +
 		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
 				 XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_finobt_res(mp, 0, 0);
 }
@@ -483,7 +505,7 @@ xfs_calc_ifree_reservation(
 		xfs_calc_buf_res(1, 0) +
 		xfs_calc_buf_res(2 + mp->m_ialloc_blks +
 				 mp->m_in_maxlevels, 0) +
-		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
 				 XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_finobt_res(mp, 0, 1);
 }
@@ -513,7 +535,7 @@ xfs_calc_growdata_reservation(
 	struct xfs_mount	*mp)
 {
 	return xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
 }
 
@@ -535,7 +557,7 @@ xfs_calc_growrtalloc_reservation(
 		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
 				 XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_inode_res(mp, 1) +
-		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
 }
 
@@ -611,7 +633,7 @@ xfs_calc_addafork_reservation(
 		xfs_calc_buf_res(1, mp->m_dir_geo->blksize) +
 		xfs_calc_buf_res(XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1,
 				 XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
 }
 
@@ -634,7 +656,7 @@ xfs_calc_attrinval_reservation(
 		    xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
 				     XFS_FSB_TO_B(mp, 1))),
 		   (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
-		    xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 4),
+		    xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
 				     XFS_FSB_TO_B(mp, 1))));
 }
 
@@ -701,7 +723,7 @@ xfs_calc_attrrm_reservation(
 					XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
 		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), 0)),
 		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
+		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
 				      XFS_FSB_TO_B(mp, 1))));
 }
 
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 7978150..0eb46ed 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -68,16 +68,6 @@ struct xfs_trans_resv {
 #define M_RES(mp)	(&(mp)->m_resv)
 
 /*
- * Per-extent log reservation for the allocation btree changes
- * involved in freeing or allocating an extent.
- * 2 trees * (2 blocks/level * max depth - 1) * block size
- */
-#define	XFS_ALLOCFREE_LOG_RES(mp,nx) \
-	((nx) * (2 * XFS_FSB_TO_B((mp), 2 * (mp)->m_ag_maxlevels - 1)))
-#define	XFS_ALLOCFREE_LOG_COUNT(mp,nx) \
-	((nx) * (2 * (2 * (mp)->m_ag_maxlevels - 1)))
-
-/*
  * Per-directory log reservation for any directory change.
  * dir blocks: (1 btree block per level + data block + free block) * dblock size
  * bmap btree: (levels + 2) * max depth * block size

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
