Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7CAwoE215443 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 06:10:58 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id NFnBlGyy6sNTa5NR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Dec 2012 04:13:22 -0800 (PST)
Message-ID: <50C1DD53.5070304@oracle.com>
Date: Fri, 07 Dec 2012 20:13:07 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 1/4] xfs: Add a new function xfs_buf_log_overhead() to replace
	the hard-code number of 128
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Introduce a helper to calculate the size of log buffer overhead for log format
structures.  With that, we can kill the old magic number "128" so that we don't
change the historical reservation that has been used for this overhead.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.c |  113 +++++++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_trans.h |    4 +-
 2 files changed, 76 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 06ed520..fe8f097 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -40,18 +40,34 @@
 #include "xfs_trans_priv.h"
 #include "xfs_trans_space.h"
 #include "xfs_inode_item.h"
+#include "xfs_log_priv.h"
+#include "xfs_buf_item.h"
 #include "xfs_trace.h"
 
 kmem_zone_t	*xfs_trans_zone;
 kmem_zone_t	*xfs_log_item_desc_zone;
 
+/*
+ * A buffer has a format structure overhead in the log in addition
+ * to the data, so we need to take this into account when reserving
+ * space in a transaction for a buffer.  Round the space required up
+ * to a multiple of 128 bytes so that we don't change the historical
+ * reservation that has been used for this overhead.
+ */
+uint
+xfs_buf_log_overhead(void)
+{
+	return round_up(sizeof(struct xlog_op_header) +
+			sizeof(struct xfs_buf_log_format), 128);
+}
 
 /*
  * Various log reservation values.
  *
  * These are based on the size of the file system block because that is what
- * most transactions manipulate.  Each adds in an additional 128 bytes per
- * item logged to try to account for the overhead of the transaction mechanism.
+ * most transactions manipulate.  Each adds in an additional bytes indicated
+ * by xfs_buf_log_overhead() per item logged to try to account for the overhead
+ * of the transaction mechanism.
  *
  * Note:  Most of the reservations underestimate the number of allocation
  * groups into which they could free extents in the xfs_bmap_finish() call.
@@ -90,13 +106,15 @@ xfs_calc_write_reservation(
 		     2 * mp->m_sb.sb_sectsize +
 		     mp->m_sb.sb_sectsize +
 		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
-		     128 * (4 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) +
-			    XFS_ALLOCFREE_LOG_COUNT(mp, 2))),
+		     xfs_buf_log_overhead() *
+		     (4 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) +
+		      XFS_ALLOCFREE_LOG_COUNT(mp, 2))),
 		    (2 * mp->m_sb.sb_sectsize +
 		     2 * mp->m_sb.sb_sectsize +
 		     mp->m_sb.sb_sectsize +
 		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
-		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
+		     xfs_buf_log_overhead() *
+		     (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
 /*
@@ -119,16 +137,19 @@ xfs_calc_itruncate_reservation(
 	return XFS_DQUOT_LOGRES(mp) +
 		MAX((mp->m_sb.sb_inodesize +
 		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1) +
-		     128 * (2 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
+		     xfs_buf_log_overhead() *
+		     (2 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
 		    (4 * mp->m_sb.sb_sectsize +
 		     4 * mp->m_sb.sb_sectsize +
 		     mp->m_sb.sb_sectsize +
 		     XFS_ALLOCFREE_LOG_RES(mp, 4) +
-		     128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4)) +
-		     128 * 5 +
+		     xfs_buf_log_overhead() *
+		     (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4)) +
+		     xfs_buf_log_overhead() * 5 +
 		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
-			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
+		     xfs_buf_log_overhead() *
+		     (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+		      XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
 /*
@@ -150,12 +171,14 @@ xfs_calc_rename_reservation(
 	return XFS_DQUOT_LOGRES(mp) +
 		MAX((4 * mp->m_sb.sb_inodesize +
 		     2 * XFS_DIROP_LOG_RES(mp) +
-		     128 * (4 + 2 * XFS_DIROP_LOG_COUNT(mp))),
+		     xfs_buf_log_overhead() *
+		     (4 + 2 * XFS_DIROP_LOG_COUNT(mp))),
 		    (3 * mp->m_sb.sb_sectsize +
 		     3 * mp->m_sb.sb_sectsize +
 		     mp->m_sb.sb_sectsize +
 		     XFS_ALLOCFREE_LOG_RES(mp, 3) +
-		     128 * (7 + XFS_ALLOCFREE_LOG_COUNT(mp, 3))));
+		     xfs_buf_log_overhead() *
+		     (7 + XFS_ALLOCFREE_LOG_COUNT(mp, 3))));
 }
 
 /*
@@ -178,12 +201,13 @@ xfs_calc_link_reservation(
 		MAX((mp->m_sb.sb_inodesize +
 		     mp->m_sb.sb_inodesize +
 		     XFS_DIROP_LOG_RES(mp) +
-		     128 * (2 + XFS_DIROP_LOG_COUNT(mp))),
+		     xfs_buf_log_overhead() * (2 + XFS_DIROP_LOG_COUNT(mp))),
 		    (mp->m_sb.sb_sectsize +
 		     mp->m_sb.sb_sectsize +
 		     mp->m_sb.sb_sectsize +
 		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		     128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
+		     xfs_buf_log_overhead() *
+		     (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
 /*
@@ -206,12 +230,13 @@ xfs_calc_remove_reservation(
 		MAX((mp->m_sb.sb_inodesize +
 		     mp->m_sb.sb_inodesize +
 		     XFS_DIROP_LOG_RES(mp) +
-		     128 * (2 + XFS_DIROP_LOG_COUNT(mp))),
+		     xfs_buf_log_overhead() * (2 + XFS_DIROP_LOG_COUNT(mp))),
 		    (2 * mp->m_sb.sb_sectsize +
 		     2 * mp->m_sb.sb_sectsize +
 		     mp->m_sb.sb_sectsize +
 		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
-		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
+		     xfs_buf_log_overhead() *
+		     (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
 /*
@@ -238,13 +263,14 @@ xfs_calc_symlink_reservation(
 		     XFS_FSB_TO_B(mp, 1) +
 		     XFS_DIROP_LOG_RES(mp) +
 		     1024 +
-		     128 * (4 + XFS_DIROP_LOG_COUNT(mp))),
+		     xfs_buf_log_overhead() * (4 + XFS_DIROP_LOG_COUNT(mp))),
 		    (2 * mp->m_sb.sb_sectsize +
 		     XFS_FSB_TO_B(mp, XFS_IALLOC_BLOCKS(mp)) +
 		     XFS_FSB_TO_B(mp, mp->m_in_maxlevels) +
 		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
-			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
+		     xfs_buf_log_overhead() *
+		     (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+		      XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
 /*
@@ -272,13 +298,14 @@ xfs_calc_create_reservation(
 		     mp->m_sb.sb_sectsize +
 		     XFS_FSB_TO_B(mp, 1) +
 		     XFS_DIROP_LOG_RES(mp) +
-		     128 * (3 + XFS_DIROP_LOG_COUNT(mp))),
+		     xfs_buf_log_overhead() * (3 + XFS_DIROP_LOG_COUNT(mp))),
 		    (3 * mp->m_sb.sb_sectsize +
 		     XFS_FSB_TO_B(mp, XFS_IALLOC_BLOCKS(mp)) +
 		     XFS_FSB_TO_B(mp, mp->m_in_maxlevels) +
 		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
-			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
+		     xfs_buf_log_overhead() *
+		     (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+		      XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
 /*
@@ -312,10 +339,11 @@ xfs_calc_ifree_reservation(
 		XFS_FSB_TO_B(mp, 1) +
 		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
 		    XFS_INODE_CLUSTER_SIZE(mp)) +
-		128 * 5 +
+		xfs_buf_log_overhead() * 5 +
 		XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
-		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
+		xfs_buf_log_overhead() *
+		(2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
+		 XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
 /*
@@ -345,7 +373,7 @@ xfs_calc_growdata_reservation(
 {
 	return mp->m_sb.sb_sectsize * 3 +
 		XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1));
+		xfs_buf_log_overhead() * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
 /*
@@ -366,8 +394,9 @@ xfs_calc_growrtalloc_reservation(
 		XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) +
 		mp->m_sb.sb_inodesize +
 		XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		128 * (3 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) +
-		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
+		xfs_buf_log_overhead() *
+		(3 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) +
+		 XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
 /*
@@ -379,7 +408,7 @@ STATIC uint
 xfs_calc_growrtzero_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_blocksize + 128;
+	return mp->m_sb.sb_blocksize + xfs_buf_log_overhead();
 }
 
 /*
@@ -400,7 +429,7 @@ xfs_calc_growrtfree_reservation(
 		2 * mp->m_sb.sb_inodesize +
 		mp->m_sb.sb_blocksize +
 		mp->m_rsumsize +
-		128 * 5;
+		xfs_buf_log_overhead() * 5;
 }
 
 /*
@@ -411,7 +440,7 @@ STATIC uint
 xfs_calc_swrite_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_inodesize + 128;
+	return mp->m_sb.sb_inodesize + xfs_buf_log_overhead();
 }
 
 /*
@@ -421,7 +450,7 @@ xfs_calc_swrite_reservation(
 STATIC uint
 xfs_calc_writeid_reservation(xfs_mount_t *mp)
 {
-	return mp->m_sb.sb_inodesize + 128;
+	return mp->m_sb.sb_inodesize + xfs_buf_log_overhead();
 }
 
 /*
@@ -442,8 +471,9 @@ xfs_calc_addafork_reservation(
 		mp->m_dirblksize +
 		XFS_FSB_TO_B(mp, XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1) +
 		XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		128 * (4 + XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1 +
-		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
+		xfs_buf_log_overhead() *
+		(4 + XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1 +
+		 XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
 /*
@@ -463,12 +493,14 @@ xfs_calc_attrinval_reservation(
 {
 	return MAX((mp->m_sb.sb_inodesize +
 		    XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
-		    128 * (1 + XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))),
+		    xfs_buf_log_overhead() *
+		    (1 + XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))),
 		   (4 * mp->m_sb.sb_sectsize +
 		    4 * mp->m_sb.sb_sectsize +
 		    mp->m_sb.sb_sectsize +
 		    XFS_ALLOCFREE_LOG_RES(mp, 4) +
-		    128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))));
+		    xfs_buf_log_overhead() *
+		    (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))));
 }
 
 /*
@@ -489,7 +521,7 @@ xfs_calc_attrset_reservation(
 		mp->m_sb.sb_inodesize +
 		mp->m_sb.sb_sectsize +
 		XFS_FSB_TO_B(mp, XFS_DA_NODE_MAXDEPTH) +
-		128 * (2 + XFS_DA_NODE_MAXDEPTH);
+		xfs_buf_log_overhead() * (2 + XFS_DA_NODE_MAXDEPTH);
 }
 
 /*
@@ -511,13 +543,14 @@ xfs_calc_attrrm_reservation(
 		MAX((mp->m_sb.sb_inodesize +
 		     XFS_FSB_TO_B(mp, XFS_DA_NODE_MAXDEPTH) +
 		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
-		     128 * (1 + XFS_DA_NODE_MAXDEPTH +
+		     xfs_buf_log_overhead() * (1 + XFS_DA_NODE_MAXDEPTH +
 			    XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
 		    (2 * mp->m_sb.sb_sectsize +
 		     2 * mp->m_sb.sb_sectsize +
 		     mp->m_sb.sb_sectsize +
 		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
-		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
+		     xfs_buf_log_overhead() *
+		     (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
 /*
@@ -527,7 +560,7 @@ STATIC uint
 xfs_calc_clear_agi_bucket_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_sectsize + 128;
+	return mp->m_sb.sb_sectsize + xfs_buf_log_overhead();
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index db05654..1f24edc 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -259,7 +259,8 @@ struct xfs_log_item_desc {
 	((mp)->m_reservations.tr_attrset + \
 	 (ext * (mp)->m_sb.sb_sectsize) + \
 	 (ext * XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))) + \
-	 (128 * (ext + (ext * XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))))
+	 (xfs_buf_log_overhead() * \
+	  (ext + (ext * XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))))
 #define	XFS_ATTRRM_LOG_RES(mp)	((mp)->m_reservations.tr_attrrm)
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
 
@@ -535,5 +536,6 @@ extern kmem_zone_t	*xfs_log_item_desc_zone;
 
 void		xfs_trans_init(struct xfs_mount *);
 int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
+uint		xfs_buf_log_overhead(void);
 
 #endif	/* __XFS_TRANS_H__ */
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
