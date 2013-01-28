Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 782C17F4C
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:27:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 197CCAC001
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 05:27:12 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id c7HHymkUTdh2L330 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 05:27:10 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id r0SDR97i029017
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:27:10 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r0SDR9me009213
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:27:09 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	r0SDR90r020358 for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:27:09 -0600
Message-ID: <51067CA8.4090606@oracle.com>
Date: Mon, 28 Jan 2013 21:27:04 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v4 06/13] xfs: calculate XFS_TRANS_QM_DQALLOC space log
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

The disk quota allocation log space reservation is calcuated at runtime,
this patch does it at mount time.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
CC: Dave Chinner <david@fromorbit.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_dquot.c |   12 +++---------
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_trans.c |   15 +++++++++++++++
 fs/xfs/xfs_trans.h |    1 +
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bf27fcc..96d9aae 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -524,15 +524,9 @@ xfs_qm_dqread(
 	if (flags & XFS_QMOPT_DQALLOC) {
 		tp = xfs_trans_alloc(mp, XFS_TRANS_QM_DQALLOC);
 		error = xfs_trans_reserve(tp, XFS_QM_DQALLOC_SPACE_RES(mp),
-				XFS_WRITE_LOG_RES(mp) +
-				/*
-				 * Round the chunklen up to the next multiple
-				 * of 128 (buf log item chunk size)).
-				 */
-				BBTOB(mp->m_quotainfo->qi_dqchunklen) - 1 + 128,
-				0,
-				XFS_TRANS_PERM_LOG_RES,
-				XFS_WRITE_LOG_COUNT);
+					  XFS_QM_DQALLOC_LOG_RES(mp), 0,
+					  XFS_TRANS_PERM_LOG_RES,
+					  XFS_WRITE_LOG_COUNT);
 		if (error)
 			goto error1;
 		cancelflags = XFS_TRANS_RELEASE_LOG_RES;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index cebcb7f..a52f34c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -42,6 +42,7 @@ typedef struct xfs_trans_reservations {
 	uint	tr_growrtfree;	/* grow realtime freeing */
 	uint	tr_qm_sbchange;	/* change quota flags */
 	uint	tr_qm_setqlim;	/* adjust quota limits */
+	uint	tr_qm_dqalloc;	/* allocate quota on disk */
 } xfs_trans_reservations_t;
 
 #ifndef __KERNEL__
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3f7fa4b..2530937 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -567,6 +567,20 @@ xfs_calc_qm_setqlim_reservation(
 }
 
 /*
+ * Allocating quota on disk if needed.
+ *	the write transaction log space: XFS_WRITE_LOG_RES(mp)
+ *	the unit of quota allocation: one system block size
+ */
+STATIC uint
+xfs_calc_qm_dqalloc_reservation(
+	struct xfs_mount	*mp)
+{
+	return XFS_WRITE_LOG_RES(mp) +
+		xfs_calc_buf_res(1,
+			XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
+}
+
+/*
  * Initialize the precomputed transaction reservation values
  * in the mount structure.
  */
@@ -599,6 +613,7 @@ xfs_trans_init(
 	resp->tr_growrtfree = xfs_calc_growrtfree_reservation(mp);
 	resp->tr_qm_sbchange = xfs_calc_qm_sbchange_reservation(mp);
 	resp->tr_qm_setqlim = xfs_calc_qm_setqlim_reservation(mp);
+	resp->tr_qm_dqalloc = xfs_calc_qm_dqalloc_reservation(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 8f0645a..3ab1fe6 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -264,6 +264,7 @@ struct xfs_log_item_desc {
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
 #define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange)
 #define XFS_QM_SETQLIM_LOG_RES(mp)	((mp)->m_reservations.tr_qm_setqlim)
+#define XFS_QM_DQALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_qm_dqalloc)
 
 /*
  * Various log count values.
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
