Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 889897F50
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:27:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 776CA304043
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 05:27:22 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id yLOo9DChp13cdUfL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 05:27:21 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id r0SDRKcp029177
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:27:21 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r0SDRJj4003157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:27:20 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	r0SDRJeE020466 for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:27:19 -0600
Message-ID: <51067CB3.5090505@oracle.com>
Date: Mon, 28 Jan 2013 21:27:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v4 07/13] xfs: calculate XFS_TRANS_QM_QUOTAOFF space log
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

Convert the calculation of quota off transaction log space reservation
from runtime to mount time.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
CC: Dave Chinner <david@fromorbit.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_mount.h       |    1 +
 fs/xfs/xfs_qm_syscalls.c |   10 +++-------
 fs/xfs/xfs_trans.c       |   14 ++++++++++++++
 fs/xfs/xfs_trans.h       |    1 +
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a52f34c..66b5449 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -43,6 +43,7 @@ typedef struct xfs_trans_reservations {
 	uint	tr_qm_sbchange;	/* change quota flags */
 	uint	tr_qm_setqlim;	/* adjust quota limits */
 	uint	tr_qm_dqalloc;	/* allocate quota on disk */
+	uint	tr_qm_quotaoff;	/* turn quota off */
 } xfs_trans_reservations_t;
 
 #ifndef __KERNEL__
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 9b25992..e4204be 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -671,14 +671,10 @@ xfs_qm_log_quotaoff(
 	uint			oldsbqflag=0;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QUOTAOFF);
-	if ((error = xfs_trans_reserve(tp, 0,
-				      sizeof(xfs_qoff_logitem_t) * 2 +
-				      mp->m_sb.sb_sectsize + 128,
-				      0,
-				      0,
-				      XFS_DEFAULT_LOG_COUNT))) {
+	error = xfs_trans_reserve(tp, 0, XFS_QM_QUOTAOFF_LOG_RES(mp),
+				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	if (error)
 		goto error0;
-	}
 
 	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 2530937..3d8b20f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -581,6 +581,19 @@ xfs_calc_qm_dqalloc_reservation(
 }
 
 /*
+ * Turning off quotas.
+ *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ *    the superblock for the quota flags: sector size
+ */
+STATIC uint
+xfs_calc_qm_quotaoff_reservation(
+	struct xfs_mount	*mp)
+{
+	return sizeof(struct xfs_qoff_logitem) * 2 +
+		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+}
+
+/*
  * Initialize the precomputed transaction reservation values
  * in the mount structure.
  */
@@ -614,6 +627,7 @@ xfs_trans_init(
 	resp->tr_qm_sbchange = xfs_calc_qm_sbchange_reservation(mp);
 	resp->tr_qm_setqlim = xfs_calc_qm_setqlim_reservation(mp);
 	resp->tr_qm_dqalloc = xfs_calc_qm_dqalloc_reservation(mp);
+	resp->tr_qm_quotaoff = xfs_calc_qm_quotaoff_reservation(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3ab1fe6..747e7d8 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -265,6 +265,7 @@ struct xfs_log_item_desc {
 #define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange)
 #define XFS_QM_SETQLIM_LOG_RES(mp)	((mp)->m_reservations.tr_qm_setqlim)
 #define XFS_QM_DQALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_qm_dqalloc)
+#define XFS_QM_QUOTAOFF_LOG_RES(mp)	((mp)->m_reservations.tr_qm_quotaoff)
 
 /*
  * Various log count values.
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
