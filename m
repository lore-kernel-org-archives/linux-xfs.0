Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 18FD57F5D
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:27:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A12DDAC001
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 05:27:29 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id cyOi8yWp9G6BfGGO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 05:27:28 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id r0SDRRAq029289
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:27:27 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r0SDRQ8s011079
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:27:27 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	r0SDRQq5004739 for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:27:26 -0600
Message-ID: <51067CB9.6050801@oracle.com>
Date: Mon, 28 Jan 2013 21:27:21 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v4 08/13] xfs: calculate XFS_TRANS_QM_QUOTAOFF_END space log
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

Convert the calculation for end of quotaoff log space reservation
from runtime to mount time.

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
index 66b5449..c5abd86 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -44,6 +44,7 @@ typedef struct xfs_trans_reservations {
 	uint	tr_qm_setqlim;	/* adjust quota limits */
 	uint	tr_qm_dqalloc;	/* allocate quota on disk */
 	uint	tr_qm_quotaoff;	/* turn quota off */
+	uint	tr_qm_equotaoff;/* end of turn quota off */
 } xfs_trans_reservations_t;
 
 #ifndef __KERNEL__
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index e4204be..2b25980 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -638,8 +638,9 @@ xfs_qm_log_quotaoff_end(
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QUOTAOFF_END);
 
-	if ((error = xfs_trans_reserve(tp, 0, sizeof(xfs_qoff_logitem_t) * 2,
-				      0, 0, XFS_DEFAULT_LOG_COUNT))) {
+	error = xfs_trans_reserve(tp, 0, XFS_QM_QUOTAOFF_END_LOG_RES(mp),
+				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return (error);
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3d8b20f..d43e839 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -594,6 +594,17 @@ xfs_calc_qm_quotaoff_reservation(
 }
 
 /*
+ * End of turning off quotas.
+ *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ */
+STATIC uint
+xfs_calc_qm_quotaoff_end_reservation(
+	struct xfs_mount	*mp)
+{
+	return sizeof(struct xfs_qoff_logitem) * 2;
+}
+
+/*
  * Initialize the precomputed transaction reservation values
  * in the mount structure.
  */
@@ -628,6 +639,7 @@ xfs_trans_init(
 	resp->tr_qm_setqlim = xfs_calc_qm_setqlim_reservation(mp);
 	resp->tr_qm_dqalloc = xfs_calc_qm_dqalloc_reservation(mp);
 	resp->tr_qm_quotaoff = xfs_calc_qm_quotaoff_reservation(mp);
+	resp->tr_qm_equotaoff = xfs_calc_qm_quotaoff_end_reservation(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 747e7d8..77ccc36 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -266,6 +266,7 @@ struct xfs_log_item_desc {
 #define XFS_QM_SETQLIM_LOG_RES(mp)	((mp)->m_reservations.tr_qm_setqlim)
 #define XFS_QM_DQALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_qm_dqalloc)
 #define XFS_QM_QUOTAOFF_LOG_RES(mp)	((mp)->m_reservations.tr_qm_quotaoff)
+#define XFS_QM_QUOTAOFF_END_LOG_RES(mp)	((mp)->m_reservations.tr_qm_equotaoff)
 
 /*
  * Various log count values.
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
