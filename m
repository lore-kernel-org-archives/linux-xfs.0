Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6guVf067061 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:42:56 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id mnRQ4sGwvEbh01Am (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:45:01 -0800 (PST)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6j0PU002916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:45:01 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6j0iK004074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:45:00 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6j0HC010523 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:45:00 -0600
Message-ID: <50A5E0E7.7010002@oracle.com>
Date: Fri, 16 Nov 2012 14:44:55 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 01/15] xfs: Add a new transaction for changing ag state
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

This a new tranaction which would be use for Changing AG state via ioctl(2)

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_trans.c |   12 ++++++++++++
 fs/xfs/xfs_trans.h |    8 +++++---
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index deee09e..4fe2232 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -40,6 +40,7 @@ typedef struct xfs_trans_reservations {
 	uint	tr_growrtalloc;	/* grow realtime allocations */
 	uint	tr_growrtzero;	/* grow realtime zeroing */
 	uint	tr_growrtfree;	/* grow realtime freeing */
+	uint	tr_setagstate;	/* set a.g. state trans */
 } xfs_trans_reservations_t;
 
 #ifndef __KERNEL__
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 06ed520..5a5c4d8 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -531,6 +531,17 @@ xfs_calc_clear_agi_bucket_reservation(
 }
 
 /*
+ * Setting the state of an allocation group.
+ *	agf of the ag: sector size
+ */
+STATIC uint
+xfs_calc_set_agstate_reservation(
+	struct xfs_mount	*mp)
+{
+	return mp->m_sb.sb_sectsize + 128;
+}
+
+/*
  * Initialize the precomputed transaction reservation values
  * in the mount structure.
  */
@@ -561,6 +572,7 @@ xfs_trans_init(
 	resp->tr_growrtalloc = xfs_calc_growrtalloc_reservation(mp);
 	resp->tr_growrtzero = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree = xfs_calc_growrtfree_reservation(mp);
+	resp->tr_setagstate = xfs_calc_set_agstate_reservation(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index db05654..a4f4092 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -107,7 +107,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_SWAPEXT		40
 #define	XFS_TRANS_SB_COUNT		41
 #define	XFS_TRANS_CHECKPOINT		42
-#define	XFS_TRANS_TYPE_MAX		42
+#define XFS_TRANS_SET_AGSTATE		43
+#define	XFS_TRANS_TYPE_MAX		43
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 #define XFS_TRANS_TYPES \
@@ -152,7 +153,8 @@ typedef struct xfs_trans_header {
 	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
 	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
 	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
-	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }
+	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }, \
+	{ XFS_TRANS_SET_AGSTATE,	"SET_AGSTATE" }
 
 /*
  * This structure is used to track log items associated with
@@ -262,7 +264,7 @@ struct xfs_log_item_desc {
 	 (128 * (ext + (ext * XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))))
 #define	XFS_ATTRRM_LOG_RES(mp)	((mp)->m_reservations.tr_attrrm)
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
-
+#define XFS_SETAGSTATE_LOG_RES ((mp)->m_reservations.tr_setagstate)
 
 /*
  * Various log count values.
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
