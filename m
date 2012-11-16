Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6iHtv067433 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:44:18 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id RPPkT7yU3lXmIhgc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:46:23 -0800 (PST)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6kLAq020640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:46:22 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6kKnc006054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:46:21 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6kKCr011295 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:46:20 -0600
Message-ID: <50A5E138.3080801@oracle.com>
Date: Fri, 16 Nov 2012 14:46:16 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 10/15] xfs: Introduce a new transaction for shrinking fs data
	section
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

This is a new transaction which would be used for shrinking fs data section.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_mount.h       |    1 +
 fs/xfs/xfs_trans.c       |   16 ++++++++++++++++
 fs/xfs/xfs_trans.h       |    7 +++++--
 fs/xfs/xfs_trans_space.h |    2 ++
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9eaea5a..9bf3ed6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -41,6 +41,7 @@ typedef struct xfs_trans_reservations {
 	uint	tr_growrtzero;	/* grow realtime zeroing */
 	uint	tr_growrtfree;	/* grow realtime freeing */
 	uint	tr_setagstate;	/* set a.g. state trans */
+	uint	tr_shrinkdata;	/* fs data section shrink trans */
 } xfs_trans_reservations_t;
 
 #ifndef __KERNEL__
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 5a5c4d8..d7346da 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -542,6 +542,21 @@ xfs_calc_set_agstate_reservation(
 }
 
 /*
+ * Shrinking the data section of the filesystem.
+ *	superblock
+ *	agi and agf
+ *	allocation btrees
+ */
+STATIC uint
+xfs_calc_shrinkdata_reservation(
+	struct xfs_mount	*mp)
+{
+	return mp->m_sb.sb_sectsize * 3 +
+		XFS_ALLOCFREE_LOG_RES(mp, 1) +
+		128 * (3 + XFS_ALLOCFREE_LOG_COUNT(mp, 1));
+}
+
+/*
  * Initialize the precomputed transaction reservation values
  * in the mount structure.
  */
@@ -573,6 +588,7 @@ xfs_trans_init(
 	resp->tr_growrtzero = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree = xfs_calc_growrtfree_reservation(mp);
 	resp->tr_setagstate = xfs_calc_set_agstate_reservation(mp);
+	resp->tr_shrinkdata = xfs_calc_shrinkdata_reservation(mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 33aafda..6dc1fe8 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -109,7 +109,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_CHECKPOINT		42
 #define XFS_TRANS_SET_AGSTATE		43
 #define XFS_TRANS_SWAPINO		44
-#define	XFS_TRANS_TYPE_MAX		44
+#define XFS_TRANS_SHRINKFS		45
+#define	XFS_TRANS_TYPE_MAX		45
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 #define XFS_TRANS_TYPES \
@@ -156,7 +157,8 @@ typedef struct xfs_trans_header {
 	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
 	{ XLOG_UNMOUNT_REC_TYPE,	"UNMOUNT" }, \
 	{ XFS_TRANS_SET_AGSTATE,	"SET_AGSTATE" }, \
-	{ XFS_TRANS_SWAPINO,		"SWAPINO" }
+	{ XFS_TRANS_SWAPINO,		"SWAPINO" }, \
+	{ XFS_TRANS_SHRINKFS,		"SHRINKFS" }
 
 /*
  * This structure is used to track log items associated with
@@ -267,6 +269,7 @@ struct xfs_log_item_desc {
 #define	XFS_ATTRRM_LOG_RES(mp)	((mp)->m_reservations.tr_attrrm)
 #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
 #define XFS_SETAGSTATE_LOG_RES(mp) ((mp)->m_reservations.tr_setagstate)
+#define XFS_SHRINKDATA_LOG_RES(mp) ((mp)->m_reservations.tr_shrinkdata)
 
 /*
  * Various log count values.
diff --git a/fs/xfs/xfs_trans_space.h b/fs/xfs/xfs_trans_space.h
index 7d2c920..103e442 100644
--- a/fs/xfs/xfs_trans_space.h
+++ b/fs/xfs/xfs_trans_space.h
@@ -82,5 +82,7 @@
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
+#define	XFS_SHRINKFS_SPACE_RES(mp)	\
+	(2 * XFS_AG_MAXLEVELS(mp))
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
