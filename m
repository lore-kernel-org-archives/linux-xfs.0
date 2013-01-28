Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6EE527F55
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:28:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 10324AC004
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 05:28:02 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id MezCVsaaYsysn6Eq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 05:28:01 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r0SDS08k007971
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:28:01 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r0SDRxs0012139
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:28:00 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	r0SDRxWX005126 for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:27:59 -0600
Message-ID: <51067CD9.9060107@oracle.com>
Date: Mon, 28 Jan 2013 21:27:53 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v4 13/13] xfs: refactor space log reservation for
	XFS_TRANS_ATTR_SET
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

Currently, we calculate the attribute set transaction
log space reservation at runtime in two parts:

1) XFS_ATTRSET_LOG_RES() which is calcuated out at mount time.

2) ((ext * (mp)->m_sb.sb_sectsize) + \
    (ext * XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))) + \
    (128 * (ext + (ext * XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))))))
which is calculated out at runtime since it depend on the given extent length in blocks.

This patch renamed XFS_ATTRSET_LOG_RES(mp) to XFS_ATTRSETM_LOG_RES(mp) to indicate
that it is figured out at mount time.  Introduce XFS_ATTRSETRT_LOG_RES(mp) which would
be used to calculate out the unit of the log space reservation for one block.

In this way, the total runtime space for the given extent length can be figured out by:
XFS_ATTRSETM_LOG_RES(mp) + XFS_ATTRSETRT_LOG_RES(mp) * ext

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
CC: Dave Chinner <david@fromorbit.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_attr.c  |    9 ++++++---
 fs/xfs/xfs_mount.h |    3 ++-
 fs/xfs/xfs_trans.c |   28 ++++++++++++++++++++++++----
 fs/xfs/xfs_trans.h |   11 ++++-------
 4 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 0ca1f0b..20d114e 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -300,9 +300,12 @@ xfs_attr_set_int(
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
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b9b7dbc..b715c93 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -34,7 +34,8 @@ typedef struct xfs_trans_reservations {
 	uint	tr_addafork;	/* cvt inode to attributed trans */
 	uint	tr_writeid;	/* write setuid/setgid file */
 	uint	tr_attrinval;	/* attr fork buffer invalidation */
-	uint	tr_attrset;	/* set/create an attribute */
+	uint	tr_attrsetm;	/* set/create an attribute at mount time */
+	uint	tr_attrsetrt;	/* set/create an attribute at runtime */
 	uint	tr_attrrm;	/* remove an attribute */
 	uint	tr_clearagi;	/* clear bad agi unlinked ino bucket */
 	uint	tr_growrtalloc;	/* grow realtime allocations */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3e4c5f1..f8c60e2 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -489,17 +489,18 @@ xfs_calc_attrinval_reservation(
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
@@ -509,6 +510,24 @@ xfs_calc_attrset_reservation(
 }
 
 /*
+ * Setting an attribute at runtime, transaction space unit per block.
+ * 	the superblock for allocations: sector size
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
+}
+
+/*
  * Removing an attribute.
  *    the inode: inode size
  *    the attribute btree could join: max depth * block size
@@ -640,7 +659,8 @@ xfs_trans_init(
 	resp->tr_writeid = xfs_calc_writeid_reservation(mp);
 	resp->tr_addafork = xfs_calc_addafork_reservation(mp);
 	resp->tr_attrinval = xfs_calc_attrinval_reservation(mp);
-	resp->tr_attrset = xfs_calc_attrset_reservation(mp);
+	resp->tr_attrsetm = xfs_calc_attrsetm_reservation(mp);
+	resp->tr_attrsetrt = xfs_calc_attrsetrt_reservation(mp);
 	resp->tr_attrrm = xfs_calc_attrrm_reservation(mp);
 	resp->tr_clearagi = xfs_calc_clear_agi_bucket_reservation(mp);
 	resp->tr_growrtalloc = xfs_calc_growrtalloc_reservation(mp);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a150074..e99c7e8 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -252,15 +252,12 @@ struct xfs_log_item_desc {
  * as long as SWRITE logs the entire inode core
  */
 #define XFS_FSYNC_TS_LOG_RES(mp)        ((mp)->m_reservations.tr_swrite)
-#define	XFS_WRITEID_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
+#define	XFS_WRITEID_LOG_RES(mp)		((mp)->m_reservations.tr_swrite)
 #define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
 #define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
-#define	XFS_ATTRSET_LOG_RES(mp, ext)	\
-	((mp)->m_reservations.tr_attrset + \
-	 (ext * (mp)->m_sb.sb_sectsize) + \
-	 (ext * XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))) + \
-	 (128 * (ext + (ext * XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))))
-#define	XFS_ATTRRM_LOG_RES(mp)	((mp)->m_reservations.tr_attrrm)
+#define	XFS_ATTRSETM_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetm)
+#define XFS_ATTRSETRT_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetrt)
+#define	XFS_ATTRRM_LOG_RES(mp)		((mp)->m_reservations.tr_attrrm)
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
 #define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange)
 #define XFS_QM_SETQLIM_LOG_RES(mp)	((mp)->m_reservations.tr_qm_setqlim)
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
