Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B6157F4C
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:26:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0319AC001
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 05:26:10 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id xrGMl88hMrIhU6uu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 05:26:09 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id r0SDQ73e027928
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:26:08 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r0SDQ7Yi001458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:26:07 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	r0SDQ7Me011630 for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:26:07 -0600
Message-ID: <51067C69.2020509@oracle.com>
Date: Mon, 28 Jan 2013 21:26:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v4 02/13] xfs: make use of xfs_calc_buf_res() in xfs_trans.c
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
To: xfs@oss.sgi.com

Refining the existing reservations with xfs_calc_buf_res() in xfs_trans.c

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
CC: Dave Chinner <david@fromorbit.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_trans.c |  237 ++++++++++++++++++++++++----------------------------
 1 file changed, 110 insertions(+), 127 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 6c601ea..1fc2877 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -116,18 +116,15 @@ xfs_calc_write_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((mp->m_sb.sb_inodesize +
-		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) +
-		     2 * mp->m_sb.sb_sectsize +
-		     mp->m_sb.sb_sectsize +
-		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
-		     128 * (4 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) +
-			    XFS_ALLOCFREE_LOG_COUNT(mp, 2))),
-		    (2 * mp->m_sb.sb_sectsize +
-		     2 * mp->m_sb.sb_sectsize +
-		     mp->m_sb.sb_sectsize +
-		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
-		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
+		MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
+				      XFS_FSB_TO_B(mp, 1)) +
+		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
+				      XFS_FSB_TO_B(mp, 1))),
+		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
+				      XFS_FSB_TO_B(mp, 1))));
 }
 
 /*
@@ -148,18 +145,17 @@ xfs_calc_itruncate_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((mp->m_sb.sb_inodesize +
-		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1) +
-		     128 * (2 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
-		    (4 * mp->m_sb.sb_sectsize +
-		     4 * mp->m_sb.sb_sectsize +
-		     mp->m_sb.sb_sectsize +
-		     XFS_ALLOCFREE_LOG_RES(mp, 4) +
-		     128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4)) +
-		     128 * 5 +
-		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
-			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
+		MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1,
+				      XFS_FSB_TO_B(mp, 1))),
+		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 4),
+				      XFS_FSB_TO_B(mp, 1)) +
+		    xfs_calc_buf_res(5, 0) +
+		    xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				     XFS_FSB_TO_B(mp, 1)) +
+		    xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
+				     mp->m_in_maxlevels, 0)));
 }
 
 /*
@@ -179,14 +175,12 @@ xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((4 * mp->m_sb.sb_inodesize +
-		     2 * XFS_DIROP_LOG_RES(mp) +
-		     128 * (4 + 2 * XFS_DIROP_LOG_COUNT(mp))),
-		    (3 * mp->m_sb.sb_sectsize +
-		     3 * mp->m_sb.sb_sectsize +
-		     mp->m_sb.sb_sectsize +
-		     XFS_ALLOCFREE_LOG_RES(mp, 3) +
-		     128 * (7 + XFS_ALLOCFREE_LOG_COUNT(mp, 3))));
+		MAX((xfs_calc_buf_res(4, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
+				      XFS_FSB_TO_B(mp, 1))),
+		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 3),
+				      XFS_FSB_TO_B(mp, 1))));
 }
 
 /*
@@ -206,15 +200,12 @@ xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((mp->m_sb.sb_inodesize +
-		     mp->m_sb.sb_inodesize +
-		     XFS_DIROP_LOG_RES(mp) +
-		     128 * (2 + XFS_DIROP_LOG_COUNT(mp))),
-		    (mp->m_sb.sb_sectsize +
-		     mp->m_sb.sb_sectsize +
-		     mp->m_sb.sb_sectsize +
-		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		     128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
+		MAX((xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
+				      XFS_FSB_TO_B(mp, 1))),
+		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				      XFS_FSB_TO_B(mp, 1))));
 }
 
 /*
@@ -234,15 +225,12 @@ xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((mp->m_sb.sb_inodesize +
-		     mp->m_sb.sb_inodesize +
-		     XFS_DIROP_LOG_RES(mp) +
-		     128 * (2 + XFS_DIROP_LOG_COUNT(mp))),
-		    (2 * mp->m_sb.sb_sectsize +
-		     2 * mp->m_sb.sb_sectsize +
-		     mp->m_sb.sb_sectsize +
-		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
-		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
+		MAX((xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
+				      XFS_FSB_TO_B(mp, 1))),
+		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
+				      XFS_FSB_TO_B(mp, 1))));
 }
 
 /*
@@ -264,18 +252,18 @@ xfs_calc_symlink_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((mp->m_sb.sb_inodesize +
-		     mp->m_sb.sb_inodesize +
-		     XFS_FSB_TO_B(mp, 1) +
-		     XFS_DIROP_LOG_RES(mp) +
-		     1024 +
-		     128 * (4 + XFS_DIROP_LOG_COUNT(mp))),
-		    (2 * mp->m_sb.sb_sectsize +
-		     XFS_FSB_TO_B(mp, XFS_IALLOC_BLOCKS(mp)) +
-		     XFS_FSB_TO_B(mp, mp->m_in_maxlevels) +
-		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
-			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
+		MAX((xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
+		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
+				      XFS_FSB_TO_B(mp, 1)) +
+		     xfs_calc_buf_res(1, 1024)),
+		    (xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp),
+				      XFS_FSB_TO_B(mp, 1)) +
+		     xfs_calc_buf_res(mp->m_in_maxlevels,
+				      XFS_FSB_TO_B(mp, 1)) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				      XFS_FSB_TO_B(mp, 1))));
 }
 
 /*
@@ -298,18 +286,19 @@ xfs_calc_create_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((mp->m_sb.sb_inodesize +
-		     mp->m_sb.sb_inodesize +
-		     mp->m_sb.sb_sectsize +
+		MAX((xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		     XFS_FSB_TO_B(mp, 1) +
-		     XFS_DIROP_LOG_RES(mp) +
-		     128 * (3 + XFS_DIROP_LOG_COUNT(mp))),
-		    (3 * mp->m_sb.sb_sectsize +
-		     XFS_FSB_TO_B(mp, XFS_IALLOC_BLOCKS(mp)) +
-		     XFS_FSB_TO_B(mp, mp->m_in_maxlevels) +
-		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
-			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
+		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
+				      XFS_FSB_TO_B(mp, 1))),
+		    (xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		     mp->m_sb.sb_sectsize +
+		     xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp),
+				      XFS_FSB_TO_B(mp, 1)) +
+		     xfs_calc_buf_res(mp->m_in_maxlevels,
+				      XFS_FSB_TO_B(mp, 1)) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				      XFS_FSB_TO_B(mp, 1))));
 }
 
 /*
@@ -337,16 +326,16 @@ xfs_calc_ifree_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		mp->m_sb.sb_inodesize +
-		mp->m_sb.sb_sectsize +
-		mp->m_sb.sb_sectsize +
-		XFS_FSB_TO_B(mp, 1) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
 		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
 		    XFS_INODE_CLUSTER_SIZE(mp)) +
-		128 * 5 +
-		XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
-		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
+		xfs_calc_buf_res(1, 0) +
+		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
+				 mp->m_in_maxlevels, 0) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
 }
 
 /*
@@ -374,9 +363,9 @@ STATIC uint
 xfs_calc_growdata_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_sectsize * 3 +
-		XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1));
+	return xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
 }
 
 /*
@@ -393,12 +382,12 @@ STATIC uint
 xfs_calc_growrtalloc_reservation(
 	struct xfs_mount	*mp)
 {
-	return 2 * mp->m_sb.sb_sectsize +
-		XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK)) +
-		mp->m_sb.sb_inodesize +
-		XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		128 * (3 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) +
-		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
+	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
+				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
 }
 
 /*
@@ -410,7 +399,7 @@ STATIC uint
 xfs_calc_growrtzero_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_blocksize + 128;
+	return xfs_calc_buf_res(1, mp->m_sb.sb_blocksize);
 }
 
 /*
@@ -427,11 +416,10 @@ STATIC uint
 xfs_calc_growrtfree_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_sectsize +
-		2 * mp->m_sb.sb_inodesize +
-		mp->m_sb.sb_blocksize +
-		mp->m_rsumsize +
-		128 * 5;
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_blocksize) +
+		xfs_calc_buf_res(1, mp->m_rsumsize);
 }
 
 /*
@@ -442,7 +430,7 @@ STATIC uint
 xfs_calc_swrite_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_inodesize + 128;
+	return xfs_calc_buf_res(1, mp->m_sb.sb_inodesize);
 }
 
 /*
@@ -452,7 +440,7 @@ xfs_calc_swrite_reservation(
 STATIC uint
 xfs_calc_writeid_reservation(xfs_mount_t *mp)
 {
-	return mp->m_sb.sb_inodesize + 128;
+	return xfs_calc_buf_res(1, mp->m_sb.sb_inodesize);
 }
 
 /*
@@ -468,13 +456,13 @@ xfs_calc_addafork_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		mp->m_sb.sb_inodesize +
-		mp->m_sb.sb_sectsize * 2 +
-		mp->m_dirblksize +
-		XFS_FSB_TO_B(mp, XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1) +
-		XFS_ALLOCFREE_LOG_RES(mp, 1) +
-		128 * (4 + XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1 +
-		       XFS_ALLOCFREE_LOG_COUNT(mp, 1));
+		xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(1, mp->m_dirblksize) +
+		xfs_calc_buf_res(XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1,
+				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
 }
 
 /*
@@ -492,14 +480,12 @@ STATIC uint
 xfs_calc_attrinval_reservation(
 	struct xfs_mount	*mp)
 {
-	return MAX((mp->m_sb.sb_inodesize +
-		    XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
-		    128 * (1 + XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))),
-		   (4 * mp->m_sb.sb_sectsize +
-		    4 * mp->m_sb.sb_sectsize +
-		    mp->m_sb.sb_sectsize +
-		    XFS_ALLOCFREE_LOG_RES(mp, 4) +
-		    128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))));
+	return MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		    xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
+				     XFS_FSB_TO_B(mp, 1))),
+		   (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
+		    xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 4),
+				     XFS_FSB_TO_B(mp, 1))));
 }
 
 /*
@@ -517,10 +503,9 @@ xfs_calc_attrset_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		mp->m_sb.sb_inodesize +
-		mp->m_sb.sb_sectsize +
-		XFS_FSB_TO_B(mp, XFS_DA_NODE_MAXDEPTH) +
-		128 * (2 + XFS_DA_NODE_MAXDEPTH);
+		xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
 }
 
 /*
@@ -539,16 +524,14 @@ xfs_calc_attrrm_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((mp->m_sb.sb_inodesize +
-		     XFS_FSB_TO_B(mp, XFS_DA_NODE_MAXDEPTH) +
+		MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
+		     xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH,
+				      XFS_FSB_TO_B(mp, 1)) +
 		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
-		     128 * (1 + XFS_DA_NODE_MAXDEPTH +
-			    XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
-		    (2 * mp->m_sb.sb_sectsize +
-		     2 * mp->m_sb.sb_sectsize +
-		     mp->m_sb.sb_sectsize +
-		     XFS_ALLOCFREE_LOG_RES(mp, 2) +
-		     128 * (5 + XFS_ALLOCFREE_LOG_COUNT(mp, 2))));
+		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), 0)),
+		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 2),
+				      XFS_FSB_TO_B(mp, 1))));
 }
 
 /*
@@ -558,7 +541,7 @@ STATIC uint
 xfs_calc_clear_agi_bucket_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_sectsize + 128;
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
 /*
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
