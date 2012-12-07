Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7CHcLC216041 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 06:17:38 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Rj9k0QJrQ4v8p2ue (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Dec 2012 04:20:03 -0800 (PST)
Message-ID: <50C1DEE9.8010302@oracle.com>
Date: Fri, 07 Dec 2012 20:19:53 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfsprogs: sync libxfs/xfs_trans.c to the kernel code
	changes
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

Sync libxfs/xfs_trans.c to the kernel code change of replacing
the hard-coding number "128" with xfs_buf_log_overhead().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_trans.h |    1 +
 libxfs/xfs_trans.c  |  113 +++++++++++++++++++++++++++++++++------------------
 2 files changed, 75 insertions(+), 39 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index c2042b7..ae6e47e 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -504,5 +504,6 @@ extern kmem_zone_t	*xfs_log_item_desc_zone;
 
 void		xfs_trans_init(struct xfs_mount *);
 int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
+uint		xfs_buf_log_overhead(void);
 
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/xfs_trans.c b/libxfs/xfs_trans.c
index 635de8f..39c1a8f 100644
--- a/libxfs/xfs_trans.c
+++ b/libxfs/xfs_trans.c
@@ -23,6 +23,20 @@ kmem_zone_t	*xfs_trans_zone;
 kmem_zone_t	*xfs_log_item_desc_zone;
 
 /*
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
+
+/*
  * Various log reservation values.
  *
  * These are based on the size of the file system block because that is what
@@ -66,13 +80,15 @@ xfs_calc_write_reservation(
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
@@ -95,16 +111,19 @@ xfs_calc_itruncate_reservation(
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
@@ -126,12 +145,14 @@ xfs_calc_rename_reservation(
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
@@ -154,12 +175,14 @@ xfs_calc_link_reservation(
 		MAX((mp->m_sb.sb_inodesize +
 		     mp->m_sb.sb_inodesize +
 		     XFS_DIROP_LOG_RES(mp) +
-		     128 * (2 + XFS_DIROP_LOG_COUNT(mp))),
+		     xfs_buf_log_overhead() *
+		     (2 + XFS_DIROP_LOG_COUNT(mp))),
 		    (mp->m_sb.sb_sectsize +
 		     mp->m_sb.sb_sectsize +
 		     mp->m_sb.sb_sectsize +
 		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		     128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
+		     xfs_buf_log_overhead() *
+		     (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
 }
 
 /*
@@ -182,12 +205,14 @@ xfs_calc_remove_reservation(
 		MAX((mp->m_sb.sb_inodesize +
 		     mp->m_sb.sb_inodesize +
 		     XFS_DIROP_LOG_RES(mp) +
-		     128 * (2 + XFS_DIROP_LOG_COUNT(mp))),
+		     xfs_buf_log_overhead() *
+		     (2 + XFS_DIROP_LOG_COUNT(mp))),
 		    (2 * mp->m_sb.sb_sectsize +
 		     2 * mp->m_sb.sb_sectsize +
 		     mp->m_sb.sb_sectsize +
 		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
-		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
+		     xfs_buf_log_overhead() *
+		     (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
 /*
@@ -214,13 +239,14 @@ xfs_calc_symlink_reservation(
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
@@ -248,13 +274,14 @@ xfs_calc_create_reservation(
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
@@ -288,10 +315,11 @@ xfs_calc_ifree_reservation(
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
@@ -321,7 +349,8 @@ xfs_calc_growdata_reservation(
 {
 	return mp->m_sb.sb_sectsize * 3 +
 		XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1));
+		xfs_buf_log_overhead() *
+		(3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1));
 }
 
 /*
@@ -342,8 +371,9 @@ xfs_calc_growrtalloc_reservation(
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
@@ -355,7 +385,7 @@ STATIC uint
 xfs_calc_growrtzero_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_blocksize + 128;
+	return mp->m_sb.sb_blocksize + xfs_buf_log_overhead();
 }
 
 /*
@@ -376,7 +406,7 @@ xfs_calc_growrtfree_reservation(
 		2 * mp->m_sb.sb_inodesize +
 		mp->m_sb.sb_blocksize +
 		mp->m_rsumsize +
-		128 * 5;
+		xfs_buf_log_overhead() * 5;
 }
 
 /*
@@ -387,7 +417,7 @@ STATIC uint
 xfs_calc_swrite_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_inodesize + 128;
+	return mp->m_sb.sb_inodesize + xfs_buf_log_overhead();
 }
 
 /*
@@ -397,7 +427,7 @@ xfs_calc_swrite_reservation(
 STATIC uint
 xfs_calc_writeid_reservation(xfs_mount_t *mp)
 {
-	return mp->m_sb.sb_inodesize + 128;
+	return mp->m_sb.sb_inodesize + xfs_buf_log_overhead();
 }
 
 /*
@@ -418,8 +448,9 @@ xfs_calc_addafork_reservation(
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
@@ -439,12 +470,14 @@ xfs_calc_attrinval_reservation(
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
@@ -465,7 +498,7 @@ xfs_calc_attrset_reservation(
 		mp->m_sb.sb_inodesize +
 		mp->m_sb.sb_sectsize +
 		XFS_FSB_TO_B(mp, XFS_DA_NODE_MAXDEPTH) +
-		128 * (2 + XFS_DA_NODE_MAXDEPTH);
+		xfs_buf_log_overhead() * (2 + XFS_DA_NODE_MAXDEPTH);
 }
 
 /*
@@ -487,13 +520,15 @@ xfs_calc_attrrm_reservation(
 		MAX((mp->m_sb.sb_inodesize +
 		     XFS_FSB_TO_B(mp, XFS_DA_NODE_MAXDEPTH) +
 		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
-		     128 * (1 + XFS_DA_NODE_MAXDEPTH +
-			    XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
+		     xfs_buf_log_overhead() *
+		     (1 + XFS_DA_NODE_MAXDEPTH +
+		      XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
 		    (2 * mp->m_sb.sb_sectsize +
 		     2 * mp->m_sb.sb_sectsize +
 		     mp->m_sb.sb_sectsize +
 		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
-		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
+		     xfs_buf_log_overhead() *
+		     (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
 }
 
 /*
@@ -503,7 +538,7 @@ STATIC uint
 xfs_calc_clear_agi_bucket_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_sectsize + 128;
+	return mp->m_sb.sb_sectsize + xfs_buf_log_overhead();
 }
 
 /*
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
