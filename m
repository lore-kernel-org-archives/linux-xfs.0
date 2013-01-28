Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6DA397F5A
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:38:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D4D2AC003
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 05:38:34 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5d8yM1YjpBaEicmX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 05:38:33 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r0SDcVFP020724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:38:32 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r0SDcVhO026917
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:38:31 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	r0SDcVU4020372 for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:38:31 -0600
Message-ID: <51067F51.7040904@oracle.com>
Date: Mon, 28 Jan 2013 21:38:25 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 2/2] xfsprogs: sync transaction log spaces changes to the
	user space
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

Sync the kernel codes changes regarding transaction log space reservations
to the user space.

As we have splitted the calculation of attrset log space reservations into mount
time and runtime in kernel code, here we need to fix max_attrset_trans_res_adjust()
to reflect this change.  

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 include/xfs_mount.h |    3 +-
 include/xfs_trans.h |    9 +-
 libxfs/xfs_attr.c   |    9 +-
 libxfs/xfs_trans.c  |  265 ++++++++++++++++++++++++++-------------------------
 mkfs/maxtrres.c     |    9 +-
 5 files changed, 147 insertions(+), 148 deletions(-)

diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 94a02e1..9be9a05 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -34,7 +34,8 @@ typedef struct xfs_trans_reservations {
 	uint	tr_addafork;	/* cvt inode to attributed trans */
 	uint	tr_writeid;	/* write setuid/setgid file */
 	uint	tr_attrinval;	/* attr fork buffer invalidation */
-	uint	tr_attrset;	/* set/create an attribute */
+	uint	tr_attrsetm;    /* set/create an attribute at mount time */
+	uint	tr_attrsetrt;   /* set/create an attribute at runtime */
 	uint	tr_attrrm;	/* remove an attribute */
 	uint	tr_clearagi;	/* clear bad agi unlinked ino bucket */
 	uint	tr_growrtalloc;	/* grow realtime allocations */
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index c2042b7..2870308 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -254,12 +254,9 @@ struct xfs_log_item_desc {
 #define	XFS_WRITEID_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
 #define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
 #define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
-#define	XFS_ATTRSET_LOG_RES(mp, ext)	\
-	((mp)->m_reservations.tr_attrset + \
-	 (ext * (mp)->m_sb.sb_sectsize) + \
-	 (ext * XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))) + \
-	 (128 * (ext + (ext * XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))))
-#define	XFS_ATTRRM_LOG_RES(mp)	((mp)->m_reservations.tr_attrrm)
+#define	XFS_ATTRSETM_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetm)
+#define	XFS_ATTRSETRT_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetrt)
+#define	XFS_ATTRRM_LOG_RES(mp)		((mp)->m_reservations.tr_attrrm)
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
 
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index aaeaec4..eec7f8f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -275,9 +275,12 @@ xfs_attr_set_int(
 	if (rsvd)
 		args.trans->t_flags |= XFS_TRANS_RESERVE;
 
-	if ((error = xfs_trans_reserve(args.trans, args.total,
-			XFS_ATTRSET_LOG_RES(mp, args.total), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_ATTRSET_LOG_COUNT))) {
+	error = xfs_trans_reserve(args.trans, args.total,
+				  XFS_ATTRSETM_LOG_RES(mp) +
+				  XFS_ATTRSETRT_LOG_RES(mp) * args.total,
+				  0, XFS_TRANS_PERM_LOG_RES,
+				  XFS_ATTRSET_LOG_COUNT);
+	if (error) {
 		xfs_trans_cancel(args.trans, 0);
 		return(error);
 	}
diff --git a/libxfs/xfs_trans.c b/libxfs/xfs_trans.c
index d7ff1a9..7249196 100644
--- a/libxfs/xfs_trans.c
+++ b/libxfs/xfs_trans.c
@@ -90,18 +90,15 @@ xfs_calc_write_reservation(
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
@@ -122,18 +119,17 @@ xfs_calc_itruncate_reservation(
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
@@ -153,14 +149,12 @@ xfs_calc_rename_reservation(
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
@@ -180,15 +174,12 @@ xfs_calc_link_reservation(
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
@@ -208,15 +199,12 @@ xfs_calc_remove_reservation(
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
@@ -238,18 +226,18 @@ xfs_calc_symlink_reservation(
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
@@ -272,18 +260,19 @@ xfs_calc_create_reservation(
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
@@ -311,16 +300,16 @@ xfs_calc_ifree_reservation(
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
@@ -348,9 +337,9 @@ STATIC uint
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
@@ -367,12 +356,12 @@ STATIC uint
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
@@ -384,7 +373,7 @@ STATIC uint
 xfs_calc_growrtzero_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_blocksize + 128;
+	return xfs_calc_buf_res(1, mp->m_sb.sb_blocksize);
 }
 
 /*
@@ -401,11 +390,10 @@ STATIC uint
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
@@ -416,7 +404,7 @@ STATIC uint
 xfs_calc_swrite_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_inodesize + 128;
+	return xfs_calc_buf_res(1, mp->m_sb.sb_inodesize);
 }
 
 /*
@@ -426,7 +414,7 @@ xfs_calc_swrite_reservation(
 STATIC uint
 xfs_calc_writeid_reservation(xfs_mount_t *mp)
 {
-	return mp->m_sb.sb_inodesize + 128;
+	return xfs_calc_buf_res(1, mp->m_sb.sb_inodesize);
 }
 
 /*
@@ -442,13 +430,13 @@ xfs_calc_addafork_reservation(
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
@@ -466,35 +454,51 @@ STATIC uint
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
- * Setting an attribute.
+ * Setting an attribute at mount time.
  *	the inode getting the attribute
  *	the superblock for allocations
  *	the agfs extents are allocated from
  *	the attribute btree * max depth
  *	the inode allocation btree
  * Since attribute transaction space is dependent on the size of the attribute,
- * the calculation is done partially at mount time and partially at runtime.
+ * the calculation is done partially at mount time and partially at runtime(see
+ * below).
  */
 STATIC uint
-xfs_calc_attrset_reservation(
+xfs_calc_attrsetm_reservation(
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
+}
+
+/*
+ * Setting an attribute at runtime, transaction space unit per block.
+ *	the superblock for allocations: sector size
+ *	the inode bmap btree could join or split: max depth * block size
+ * Since the runtime attribute transaction space is dependent on the total
+ * blocks needed for the 1st bmap, here we calculate out the space unit for
+ * one block so that the caller could figure out the total space according
+ * to the attibute extent length in blocks by: ext * XFS_ATTRSETRT_LOG_RES(mp).
+ */
+STATIC uint
+xfs_calc_attrsetrt_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
+				 XFS_FSB_TO_B(mp, 1));
 }
 
 /*
@@ -513,16 +517,14 @@ xfs_calc_attrrm_reservation(
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
@@ -532,7 +534,7 @@ STATIC uint
 xfs_calc_clear_agi_bucket_reservation(
 	struct xfs_mount	*mp)
 {
-	return mp->m_sb.sb_sectsize + 128;
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
 /*
@@ -560,7 +562,8 @@ xfs_trans_init(
 	resp->tr_writeid = xfs_calc_writeid_reservation(mp);
 	resp->tr_addafork = xfs_calc_addafork_reservation(mp);
 	resp->tr_attrinval = xfs_calc_attrinval_reservation(mp);
-	resp->tr_attrset = xfs_calc_attrset_reservation(mp);
+	resp->tr_attrsetm = xfs_calc_attrsetm_reservation(mp);
+	resp->tr_attrsetrt = xfs_calc_attrsetrt_reservation(mp);
 	resp->tr_attrrm = xfs_calc_attrrm_reservation(mp);
 	resp->tr_clearagi = xfs_calc_clear_agi_bucket_reservation(mp);
 	resp->tr_growrtalloc = xfs_calc_growrtalloc_reservation(mp);
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index 33dee52..bf8a2c5 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -34,7 +34,6 @@ max_attrset_trans_res_adjust(
 	int				local;
 	int				size;
 	int				nblks;
-	int				res;
 
 	/*
 	 * Determine space the maximal sized attribute will use,
@@ -46,13 +45,9 @@ max_attrset_trans_res_adjust(
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	nblks += XFS_B_TO_FSB(mp, size);
 	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
-	res = XFS_ATTRSET_LOG_RES(mp, nblks);
 
-#if 0
-	printf("size = %d nblks = %d res = %d\n", size, nblks, res);
-#endif
-
-	mp->m_reservations.tr_attrset = res;
+	mp->m_reservations.tr_attrsetm = XFS_ATTRSETM_LOG_RES(mp);
+	mp->m_reservations.tr_attrsetrt = XFS_ATTRSETRT_LOG_RES(mp) * nblks;
 }
 
 static int
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
