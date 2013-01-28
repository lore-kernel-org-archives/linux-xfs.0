Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E3AB7F51
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:26:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 229B78F8052
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 05:26:57 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Elb1BuvdNrb6MvkC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 05:26:56 -0800 (PST)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id r0SDQtLd028589
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:26:55 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r0SDQsBX024276
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:26:54 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	r0SDQsGP012113 for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:26:54 -0600
Message-ID: <51067C99.80906@oracle.com>
Date: Mon, 28 Jan 2013 21:26:49 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v4 05/13] xfs: calcuate XFS_TRANS_QM_SETQLIM space log
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

For adjusting quota limits transactions, we calculate out the log space
reservation at runtime, this patch does it at mount time.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
CC: Dave Chinner <david@fromorbit.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_mount.h       |    1 +
 fs/xfs/xfs_qm_syscalls.c |    5 +++--
 fs/xfs/xfs_trans.c       |   12 ++++++++++++
 fs/xfs/xfs_trans.h       |    1 +
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9e3a03b..cebcb7f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -41,6 +41,7 @@ typedef struct xfs_trans_reservations {
 	uint	tr_growrtzero;	/* grow realtime zeroing */
 	uint	tr_growrtfree;	/* grow realtime freeing */
 	uint	tr_qm_sbchange;	/* change quota flags */
+	uint	tr_qm_setqlim;	/* adjust quota limits */
 } xfs_trans_reservations_t;
 
 #ifndef __KERNEL__
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 858a3b1..9b25992 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -489,8 +489,9 @@ xfs_qm_scall_setqlim(
 		return 0;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SETQLIM);
-	if ((error = xfs_trans_reserve(tp, 0, sizeof(xfs_disk_dquot_t) + 128,
-				      0, 0, XFS_DEFAULT_LOG_COUNT))) {
+	error = xfs_trans_reserve(tp, 0, XFS_QM_SETQLIM_LOG_RES(mp),
+				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return (error);
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 236e53e..3f7fa4b 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -556,6 +556,17 @@ xfs_calc_qm_sbchange_reservation(
 }
 
 /*
+ * Adjusting quota limits.
+ *    the xfs_disk_dquot_t: sizeof(struct xfs_disk_dquot)
+ */
+STATIC uint
+xfs_calc_qm_setqlim_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(1, sizeof(struct xfs_disk_dquot));
+}
+
+/*
  * Initialize the precomputed transaction reservation values
  * in the mount structure.
  */
@@ -587,6 +598,7 @@ xfs_trans_init(
 	resp->tr_growrtzero = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree = xfs_calc_growrtfree_reservation(mp);
 	resp->tr_qm_sbchange = xfs_calc_qm_sbchange_reservation(mp);
+	resp->tr_qm_setqlim = xfs_calc_qm_setqlim_reservation(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 4eb1140..8f0645a 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -263,6 +263,7 @@ struct xfs_log_item_desc {
 #define	XFS_ATTRRM_LOG_RES(mp)	((mp)->m_reservations.tr_attrrm)
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
 #define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange)
+#define XFS_QM_SETQLIM_LOG_RES(mp)	((mp)->m_reservations.tr_qm_setqlim)
 
 /*
  * Various log count values.
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
