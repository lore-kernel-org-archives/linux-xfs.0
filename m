Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B3CFB7F4C
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:26:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 55F86AC001
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 05:26:24 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id fBMEm9BUbvXwsxQy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 05:26:23 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r0SDQMXj006099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:26:22 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r0SDQLjx007385
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:26:21 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	r0SDQL69019767 for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:26:21 -0600
Message-ID: <51067C78.8040607@oracle.com>
Date: Mon, 28 Jan 2013 21:26:16 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v4 03/13] xfs: calculate XFS_TRANS_QM_SBCHANGE space log
	reservation at mount time
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

The transaction log space for clearing/reseting the quota flags
is calculated out at runtime, this patch can figure it out at
mount time.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
CC: Dave Chinner <david@fromorbit.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_mount.c |    4 ++--
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_trans.c |   12 ++++++++++++
 fs/xfs/xfs_trans.h |    2 +-
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b2bd3a0..b39fa96 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1056,8 +1056,8 @@ xfs_mount_reset_sbqflags(
 		return 0;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
-	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
-				      XFS_DEFAULT_LOG_COUNT);
+	error = xfs_trans_reserve(tp, 0, XFS_QM_SBCHANGE_LOG_RES(mp),
+				  0, 0, XFS_DEFAULT_LOG_COUNT);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		xfs_alert(mp, "%s: Superblock update failed!", __func__);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index deee09e..9e3a03b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -40,6 +40,7 @@ typedef struct xfs_trans_reservations {
 	uint	tr_growrtalloc;	/* grow realtime allocations */
 	uint	tr_growrtzero;	/* grow realtime zeroing */
 	uint	tr_growrtfree;	/* grow realtime freeing */
+	uint	tr_qm_sbchange;	/* change quota flags */
 } xfs_trans_reservations_t;
 
 #ifndef __KERNEL__
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 1fc2877..236e53e 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -545,6 +545,17 @@ xfs_calc_clear_agi_bucket_reservation(
 }
 
 /*
+ * Clearing the quotaflags in the superblock.
+ *	the super block for changing quota flags: sector size
+ */
+STATIC uint
+xfs_calc_qm_sbchange_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+}
+
+/*
  * Initialize the precomputed transaction reservation values
  * in the mount structure.
  */
@@ -575,6 +586,7 @@ xfs_trans_init(
 	resp->tr_growrtalloc = xfs_calc_growrtalloc_reservation(mp);
 	resp->tr_growrtzero = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree = xfs_calc_growrtfree_reservation(mp);
+	resp->tr_qm_sbchange = xfs_calc_qm_sbchange_reservation(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index db05654..4eb1140 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -262,7 +262,7 @@ struct xfs_log_item_desc {
 	 (128 * (ext + (ext * XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))))
 #define	XFS_ATTRRM_LOG_RES(mp)	((mp)->m_reservations.tr_attrrm)
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
-
+#define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange)
 
 /*
  * Various log count values.
-- 
1.7.9.5
	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
