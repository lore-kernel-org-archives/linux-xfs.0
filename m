Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A06747FC4
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 02:33:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7F0728F8087
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 00:33:31 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5pJQLIDSxQChgmxu for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 00:33:27 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCkrW-0005gU-R8
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 17:33:18 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCkrW-0003y2-Pp
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 17:33:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs: consolidate superblock logging functions
Date: Thu, 31 Jul 2014 17:33:11 +1000
Message-Id: <1406791995-14723-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1406791995-14723-1-git-send-email-david@fromorbit.com>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

We now have several superblock loggin functions that are identical
except for the transaction reservation and whether it shoul dbe a
synchronous transaction or not. Consolidate these all into a single
function, a single reserveration and a sync flag and call it
xfs_sync_sb().

Also, xfs_mod_sb() is not really a modification function - it's the
operation of logging the superblock buffer. hence change the name of
it to reflect this.

Note that we have to change the mp->m_update_flags that are passed
around at mount time to a boolean simply to indicate a superblock
update is needed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |  2 +-
 fs/xfs/libxfs/xfs_bmap.c       | 10 +++---
 fs/xfs/libxfs/xfs_sb.c         | 41 ++++++++++++++++++----
 fs/xfs/libxfs/xfs_sb.h         | 42 ++---------------------
 fs/xfs/libxfs/xfs_shared.h     | 26 ++++++--------
 fs/xfs/libxfs/xfs_trans_resv.c | 14 --------
 fs/xfs/libxfs/xfs_trans_resv.h |  1 -
 fs/xfs/xfs_fsops.c             | 29 ----------------
 fs/xfs/xfs_log.c               | 17 +++++++--
 fs/xfs/xfs_mount.c             | 78 +++++++-----------------------------------
 fs/xfs/xfs_mount.h             |  3 +-
 fs/xfs/xfs_qm.c                | 27 ++-------------
 fs/xfs/xfs_qm_syscalls.c       |  7 ++--
 fs/xfs/xfs_super.c             | 13 +++----
 14 files changed, 94 insertions(+), 216 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index f4a47a7..bcb0ab1 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -405,7 +405,7 @@ xfs_sbversion_add_attr2(xfs_mount_t *mp, xfs_trans_t *tp)
 		if (!xfs_sb_version_hasattr2(&mp->m_sb)) {
 			xfs_sb_version_addattr2(&mp->m_sb);
 			spin_unlock(&mp->m_sb_lock);
-			xfs_mod_sb(tp);
+			xfs_log_sb(tp);
 		} else
 			spin_unlock(&mp->m_sb_lock);
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 15e8c09..3a6a700 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1224,20 +1224,20 @@ xfs_bmap_add_attrfork(
 		goto bmap_cancel;
 	if (!xfs_sb_version_hasattr(&mp->m_sb) ||
 	   (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2)) {
-		bool mod_sb = false;
+		bool log_sb = false;
 
 		spin_lock(&mp->m_sb_lock);
 		if (!xfs_sb_version_hasattr(&mp->m_sb)) {
 			xfs_sb_version_addattr(&mp->m_sb);
-			mod_sb = true;
+			log_sb = true;
 		}
 		if (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2) {
 			xfs_sb_version_addattr2(&mp->m_sb);
-			mod_sb = true;
+			log_sb = true;
 		}
 		spin_unlock(&mp->m_sb_lock);
-		if (mod_sb)
-			xfs_mod_sb(tp);
+		if (log_sb)
+			xfs_log_sb(tp);
 	}
 
 	error = xfs_bmap_finish(&tp, &flist, &committed);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d16b549..d77d344 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -726,14 +726,13 @@ xfs_initialize_perag_data(
 }
 
 /*
- * xfs_mod_sb() can be used to copy arbitrary changes to the
- * in-core superblock into the superblock buffer to be logged.
- * It does not provide the higher level of locking that is
- * needed to protect the in-core superblock from concurrent
- * access.
+ * xfs_log_sb() can be used to copy arbitrary changes to the in-core superblock
+ * into the superblock buffer to be logged.  It does not provide the higher
+ * level of locking that is needed to protect the in-core superblock from
+ * concurrent access.
  */
 void
-xfs_mod_sb(
+xfs_log_sb(
 	struct xfs_trans	*tp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
@@ -743,3 +742,33 @@ xfs_mod_sb(
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb));
 }
+
+/*
+ * xfs_sync_sb
+ *
+ * Sync the superblock to disk.
+ *
+ * Note this code can be called during the process of freezing, so
+ * we may need to use the transaction allocator which does not
+ * block when the transaction subsystem is in its frozen state.
+ */
+int
+xfs_sync_sb(
+	struct xfs_mount	*mp,
+	bool			wait)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_CHANGE, KM_SLEEP);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	xfs_log_sb(tp);
+	if (wait)
+		xfs_trans_set_sync(tp);
+	return xfs_trans_commit(tp, 0);
+}
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index c28b3c1..73dff28 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -274,45 +274,6 @@ typedef enum {
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 
-/*
- * Mask values, defined based on the xfs_sb_field_t values.
- * Only define the ones we're using.
- */
-#define	XFS_SB_MVAL(x)		(1LL << XFS_SBS_ ## x)
-#define	XFS_SB_UUID		XFS_SB_MVAL(UUID)
-#define	XFS_SB_FNAME		XFS_SB_MVAL(FNAME)
-#define	XFS_SB_ROOTINO		XFS_SB_MVAL(ROOTINO)
-#define	XFS_SB_RBMINO		XFS_SB_MVAL(RBMINO)
-#define	XFS_SB_RSUMINO		XFS_SB_MVAL(RSUMINO)
-#define	XFS_SB_VERSIONNUM	XFS_SB_MVAL(VERSIONNUM)
-#define XFS_SB_UQUOTINO		XFS_SB_MVAL(UQUOTINO)
-#define XFS_SB_GQUOTINO		XFS_SB_MVAL(GQUOTINO)
-#define XFS_SB_QFLAGS		XFS_SB_MVAL(QFLAGS)
-#define XFS_SB_SHARED_VN	XFS_SB_MVAL(SHARED_VN)
-#define XFS_SB_UNIT		XFS_SB_MVAL(UNIT)
-#define XFS_SB_WIDTH		XFS_SB_MVAL(WIDTH)
-#define XFS_SB_ICOUNT		XFS_SB_MVAL(ICOUNT)
-#define XFS_SB_IFREE		XFS_SB_MVAL(IFREE)
-#define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
-#define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
-#define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
-#define XFS_SB_FEATURES_COMPAT	XFS_SB_MVAL(FEATURES_COMPAT)
-#define XFS_SB_FEATURES_RO_COMPAT XFS_SB_MVAL(FEATURES_RO_COMPAT)
-#define XFS_SB_FEATURES_INCOMPAT XFS_SB_MVAL(FEATURES_INCOMPAT)
-#define XFS_SB_FEATURES_LOG_INCOMPAT XFS_SB_MVAL(FEATURES_LOG_INCOMPAT)
-#define XFS_SB_CRC		XFS_SB_MVAL(CRC)
-#define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
-#define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
-#define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
-#define	XFS_SB_MOD_BITS		\
-	(XFS_SB_UUID | XFS_SB_ROOTINO | XFS_SB_RBMINO | XFS_SB_RSUMINO | \
-	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
-	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
-	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
-	 XFS_SB_BAD_FEATURES2 | XFS_SB_FEATURES_COMPAT | \
-	 XFS_SB_FEATURES_RO_COMPAT | XFS_SB_FEATURES_INCOMPAT | \
-	 XFS_SB_FEATURES_LOG_INCOMPAT | XFS_SB_PQUOTINO)
-
 
 /*
  * Misc. Flags - warning - these will be cleared by xfs_repair unless
@@ -612,7 +573,8 @@ extern void	xfs_perag_put(struct xfs_perag *pag);
 extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
 
 extern void	xfs_sb_calc_crc(struct xfs_buf *bp);
-extern void	xfs_mod_sb(struct xfs_trans *tp);
+extern void	xfs_log_sb(struct xfs_trans *tp);
+extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 82404da..4ae617a 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -82,7 +82,7 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 #define	XFS_TRANS_ATTR_RM		23
 #define	XFS_TRANS_ATTR_FLAG		24
 #define	XFS_TRANS_CLEAR_AGI_BUCKET	25
-#define XFS_TRANS_QM_SBCHANGE		26
+#define XFS_TRANS_SB_CHANGE		26
 /*
  * Dummy entries since we use the transaction type to index into the
  * trans_type[] in xlog_recover_print_trans_head()
@@ -95,17 +95,15 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 #define XFS_TRANS_QM_DQCLUSTER		32
 #define XFS_TRANS_QM_QINOCREATE		33
 #define XFS_TRANS_QM_QUOTAOFF_END	34
-#define XFS_TRANS_SB_UNIT		35
-#define XFS_TRANS_FSYNC_TS		36
-#define	XFS_TRANS_GROWFSRT_ALLOC	37
-#define	XFS_TRANS_GROWFSRT_ZERO		38
-#define	XFS_TRANS_GROWFSRT_FREE		39
-#define	XFS_TRANS_SWAPEXT		40
-#define	XFS_TRANS_SB_COUNT		41
-#define	XFS_TRANS_CHECKPOINT		42
-#define	XFS_TRANS_ICREATE		43
-#define	XFS_TRANS_CREATE_TMPFILE	44
-#define	XFS_TRANS_TYPE_MAX		44
+#define XFS_TRANS_FSYNC_TS		35
+#define	XFS_TRANS_GROWFSRT_ALLOC	36
+#define	XFS_TRANS_GROWFSRT_ZERO		37
+#define	XFS_TRANS_GROWFSRT_FREE		37
+#define	XFS_TRANS_SWAPEXT		39
+#define	XFS_TRANS_CHECKPOINT		40
+#define	XFS_TRANS_ICREATE		41
+#define	XFS_TRANS_CREATE_TMPFILE	42
+#define	XFS_TRANS_TYPE_MAX		43
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 #define XFS_TRANS_TYPES \
@@ -134,20 +132,18 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 	{ XFS_TRANS_ATTR_RM,		"ATTR_RM" }, \
 	{ XFS_TRANS_ATTR_FLAG,		"ATTR_FLAG" }, \
 	{ XFS_TRANS_CLEAR_AGI_BUCKET,	"CLEAR_AGI_BUCKET" }, \
-	{ XFS_TRANS_QM_SBCHANGE,	"QM_SBCHANGE" }, \
+	{ XFS_TRANS_SB_CHANGE,		"SBCHANGE" }, \
 	{ XFS_TRANS_QM_QUOTAOFF,	"QM_QUOTAOFF" }, \
 	{ XFS_TRANS_QM_DQALLOC,		"QM_DQALLOC" }, \
 	{ XFS_TRANS_QM_SETQLIM,		"QM_SETQLIM" }, \
 	{ XFS_TRANS_QM_DQCLUSTER,	"QM_DQCLUSTER" }, \
 	{ XFS_TRANS_QM_QINOCREATE,	"QM_QINOCREATE" }, \
 	{ XFS_TRANS_QM_QUOTAOFF_END,	"QM_QOFF_END" }, \
-	{ XFS_TRANS_SB_UNIT,		"SB_UNIT" }, \
 	{ XFS_TRANS_FSYNC_TS,		"FSYNC_TS" }, \
 	{ XFS_TRANS_GROWFSRT_ALLOC,	"GROWFSRT_ALLOC" }, \
 	{ XFS_TRANS_GROWFSRT_ZERO,	"GROWFSRT_ZERO" }, \
 	{ XFS_TRANS_GROWFSRT_FREE,	"GROWFSRT_FREE" }, \
 	{ XFS_TRANS_SWAPEXT,		"SWAPEXT" }, \
-	{ XFS_TRANS_SB_COUNT,		"SB_COUNT" }, \
 	{ XFS_TRANS_CHECKPOINT,		"CHECKPOINT" }, \
 	{ XFS_TRANS_DUMMY1,		"DUMMY1" }, \
 	{ XFS_TRANS_DUMMY2,		"DUMMY2" }, \
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index f2bda7c..7c42e2c 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -718,17 +718,6 @@ xfs_calc_clear_agi_bucket_reservation(
 }
 
 /*
- * Clearing the quotaflags in the superblock.
- *	the super block for changing quota flags: sector size
- */
-STATIC uint
-xfs_calc_qm_sbchange_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
-}
-
-/*
  * Adjusting quota limits.
  *    the xfs_disk_dquot_t: sizeof(struct xfs_disk_dquot)
  */
@@ -866,9 +855,6 @@ xfs_trans_resv_calc(
 	 * The following transactions are logged in logical format with
 	 * a default log count.
 	 */
-	resp->tr_qm_sbchange.tr_logres = xfs_calc_qm_sbchange_reservation(mp);
-	resp->tr_qm_sbchange.tr_logcount = XFS_DEFAULT_LOG_COUNT;
-
 	resp->tr_qm_setqlim.tr_logres = xfs_calc_qm_setqlim_reservation(mp);
 	resp->tr_qm_setqlim.tr_logcount = XFS_DEFAULT_LOG_COUNT;
 
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 1097d14..2d5bdfc 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -56,7 +56,6 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_growrtalloc;	/* grow realtime allocations */
 	struct xfs_trans_res	tr_growrtzero;	/* grow realtime zeroing */
 	struct xfs_trans_res	tr_growrtfree;	/* grow realtime freeing */
-	struct xfs_trans_res	tr_qm_sbchange;	/* change quota flags */
 	struct xfs_trans_res	tr_qm_setqlim;	/* adjust quota limits */
 	struct xfs_trans_res	tr_qm_dqalloc;	/* allocate quota on disk */
 	struct xfs_trans_res	tr_qm_quotaoff;	/* turn quota off */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 2c44e0b..126b4b3 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -763,35 +763,6 @@ out:
 	return 0;
 }
 
-/*
- * Dump a transaction into the log that contains no real change. This is needed
- * to be able to make the log dirty or stamp the current tail LSN into the log
- * during the covering operation.
- *
- * We cannot use an inode here for this - that will push dirty state back up
- * into the VFS and then periodic inode flushing will prevent log covering from
- * making progress. Hence we log a field in the superblock instead and use a
- * synchronous transaction to ensure the superblock is immediately unpinned
- * and can be written back.
- */
-int
-xfs_fs_log_dummy(
-	xfs_mount_t	*mp)
-{
-	xfs_trans_t	*tp;
-	int		error;
-
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		return error;
-	}
-	xfs_mod_sb(tp);
-	xfs_trans_set_sync(tp);
-	return xfs_trans_commit(tp, 0);
-}
-
 int
 xfs_fs_goingdown(
 	xfs_mount_t	*mp,
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ca4fd5b..8eaa8f5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1292,9 +1292,20 @@ xfs_log_worker(
 	struct xfs_mount	*mp = log->l_mp;
 
 	/* dgc: errors ignored - not fatal and nowhere to report them */
-	if (xfs_log_need_covered(mp))
-		xfs_fs_log_dummy(mp);
-	else
+	if (xfs_log_need_covered(mp)) {
+		/*
+		 * Dump a transaction into the log that contains no real change.
+		 * This is needed stamp the current tail LSN into the log during
+		 * the covering operation.
+		 *
+		 * We cannot use an inode here for this - that will push dirty
+		 * state back up into the VFS and then periodic inode flushing
+		 * will prevent log covering from making progress. Hence we
+		 * synchronously log the superblock instead to ensure the
+		 * superblock is immediately unpinned and can be written back.
+		 */
+		xfs_sync_sb(mp, true);
+	} else
 		xfs_log_force(mp, 0);
 
 	/* start pushing all the metadata that is currently dirty */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 592e169..af4e01f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -419,11 +419,11 @@ xfs_update_alignment(xfs_mount_t *mp)
 		if (xfs_sb_version_hasdalign(sbp)) {
 			if (sbp->sb_unit != mp->m_dalign) {
 				sbp->sb_unit = mp->m_dalign;
-				mp->m_update_flags |= XFS_SB_UNIT;
+				mp->m_update_sb = true;
 			}
 			if (sbp->sb_width != mp->m_swidth) {
 				sbp->sb_width = mp->m_swidth;
-				mp->m_update_flags |= XFS_SB_WIDTH;
+				mp->m_update_sb = true;
 			}
 		} else {
 			xfs_warn(mp,
@@ -591,38 +591,19 @@ int
 xfs_mount_reset_sbqflags(
 	struct xfs_mount	*mp)
 {
-	int			error;
-	struct xfs_trans	*tp;
-
 	mp->m_qflags = 0;
 
-	/*
-	 * It is OK to look at sb_qflags here in mount path,
-	 * without m_sb_lock.
-	 */
+	/* It is OK to look at sb_qflags in the mount path without m_sb_lock. */
 	if (mp->m_sb.sb_qflags == 0)
 		return 0;
 	spin_lock(&mp->m_sb_lock);
 	mp->m_sb.sb_qflags = 0;
 	spin_unlock(&mp->m_sb_lock);
 
-	/*
-	 * If the fs is readonly, let the incore superblock run
-	 * with quotas off but don't flush the update out to disk
-	 */
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (!xfs_fs_writable(mp))
 		return 0;
 
-	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_sbchange, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		xfs_alert(mp, "%s: Superblock update failed!", __func__);
-		return error;
-	}
-
-	xfs_mod_sb(tp);
-	return xfs_trans_commit(tp, 0);
+	return xfs_sync_sb(mp, false);
 }
 
 __uint64_t
@@ -686,7 +667,7 @@ xfs_mountfs(
 		xfs_warn(mp, "correcting sb_features alignment problem");
 		sbp->sb_features2 |= sbp->sb_bad_features2;
 		sbp->sb_bad_features2 = sbp->sb_features2;
-		mp->m_update_flags |= XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;
+		mp->m_update_sb = true;
 
 		/*
 		 * Re-check for ATTR2 in case it was found in bad_features2
@@ -700,17 +681,17 @@ xfs_mountfs(
 	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
 	   (mp->m_flags & XFS_MOUNT_NOATTR2)) {
 		xfs_sb_version_removeattr2(&mp->m_sb);
-		mp->m_update_flags |= XFS_SB_FEATURES2;
+		mp->m_update_sb = true;
 
 		/* update sb_versionnum for the clearing of the morebits */
 		if (!sbp->sb_features2)
-			mp->m_update_flags |= XFS_SB_VERSIONNUM;
+			mp->m_update_sb = true;
 	}
 
 	/* always use v2 inodes by default now */
 	if (!(mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
 		mp->m_sb.sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
-		mp->m_update_flags |= XFS_SB_VERSIONNUM;
+		mp->m_update_sb = true;
 	}
 
 	/*
@@ -904,8 +885,8 @@ xfs_mountfs(
 	 * the next remount into writeable mode.  Otherwise we would never
 	 * perform the update e.g. for the root filesystem.
 	 */
-	if (mp->m_update_flags && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		error = xfs_mount_log_sb(mp);
+	if (mp->m_update_sb && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		error = xfs_sync_sb(mp, false);
 		if (error) {
 			xfs_warn(mp, "failed to write sb changes");
 			goto out_rtunmount;
@@ -1100,9 +1081,6 @@ xfs_fs_writable(xfs_mount_t *mp)
 int
 xfs_log_sbcount(xfs_mount_t *mp)
 {
-	xfs_trans_t	*tp;
-	int		error;
-
 	if (!xfs_fs_writable(mp))
 		return 0;
 
@@ -1115,17 +1093,7 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
 		return 0;
 
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		return error;
-	}
-
-	xfs_mod_sb(tp);
-	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
-	return error;
+	return xfs_sync_sb(mp, true);
 }
 
 /*
@@ -1419,28 +1387,6 @@ xfs_freesb(
 }
 
 /*
- * Used to log changes to the superblock unit and width fields which could
- * be altered by the mount options, as well as any potential sb_features2
- * fixup. Only the first superblock is updated.
- */
-int
-xfs_mount_log_sb(
-	xfs_mount_t	*mp)
-{
-	xfs_trans_t	*tp;
-	int		error;
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_SB_UNIT);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		return error;
-	}
-	xfs_mod_sb(tp);
-	return xfs_trans_commit(tp, 0);
-}
-
-/*
  * If the underlying (data/log/rt) device is readonly, there are some
  * operations that cannot proceed.
  */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1ae9f56..40e72e3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -162,8 +162,7 @@ typedef struct xfs_mount {
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct delayed_work	m_eofblocks_work; /* background eof blocks
 						     trimming */
-	__int64_t		m_update_flags;	/* sb flags we need to update
-						   on the next remount,rw */
+	bool			m_update_sb;	/* sb needs update in mount */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 170f951..37486c1 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -793,7 +793,7 @@ xfs_qm_qino_alloc(
 	else
 		mp->m_sb.sb_pquotino = (*ip)->i_ino;
 	spin_unlock(&mp->m_sb_lock);
-	xfs_mod_sb(tp);
+	xfs_log_sb(tp);
 
 	if ((error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES))) {
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
@@ -1446,7 +1446,7 @@ xfs_qm_mount_quotas(
 	spin_unlock(&mp->m_sb_lock);
 
 	if (sbf != (mp->m_qflags & XFS_MOUNT_QUOTA_ALL)) {
-		if (xfs_qm_write_sb_changes(mp)) {
+		if (xfs_sync_sb(mp, false)) {
 			/*
 			 * We could only have been turning quotas off.
 			 * We aren't in very good shape actually because
@@ -1575,29 +1575,6 @@ xfs_qm_dqfree_one(
 	xfs_qm_dqdestroy(dqp);
 }
 
-/*
- * Start a transaction and write the incore superblock changes to
- * disk. flags parameter indicates which fields have changed.
- */
-int
-xfs_qm_write_sb_changes(
-	struct xfs_mount *mp)
-{
-	xfs_trans_t	*tp;
-	int		error;
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
-	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_sbchange, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		return error;
-	}
-
-	xfs_mod_sb(tp);
-	return xfs_trans_commit(tp, 0);
-}
-
-
 /* --------------- utility functions for vnodeops ---------------- */
 
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 45f28f1..d558306 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -93,7 +93,7 @@ xfs_qm_scall_quotaoff(
 		mutex_unlock(&q->qi_quotaofflock);
 
 		/* XXX what to do if error ? Revert back to old vals incore ? */
-		return xfs_qm_write_sb_changes(mp);
+		return xfs_sync_sb(mp, false);
 	}
 
 	dqtype = 0;
@@ -370,7 +370,8 @@ xfs_qm_scall_quotaon(
 	if ((qf & flags) == flags)
 		return -EEXIST;
 
-	if ((error = xfs_qm_write_sb_changes(mp)))
+	error = xfs_sync_sb(mp, false);
+	if (error)
 		return error;
 	/*
 	 * If we aren't trying to switch on quota enforcement, we are done.
@@ -795,7 +796,7 @@ xfs_qm_log_quotaoff(
 	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
 	spin_unlock(&mp->m_sb_lock);
 
-	xfs_mod_sb(tp);
+	xfs_log_sb(tp);
 
 	/*
 	 * We have to make sure that the transaction is secure on disk before we
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8aa9eb4..1c52726 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1249,13 +1249,13 @@ xfs_fs_remount(
 		 * If this is the first remount to writeable state we
 		 * might have some superblock changes to update.
 		 */
-		if (mp->m_update_flags) {
-			error = xfs_mount_log_sb(mp);
+		if (mp->m_update_sb) {
+			error = xfs_sync_sb(mp, false);
 			if (error) {
 				xfs_warn(mp, "failed to write sb changes");
 				return error;
 			}
-			mp->m_update_flags = 0;
+			mp->m_update_sb = false;
 		}
 
 		/*
@@ -1285,8 +1285,9 @@ xfs_fs_remount(
 
 /*
  * Second stage of a freeze. The data is already frozen so we only
- * need to take care of the metadata. Once that's done write a dummy
- * record to dirty the log in case of a crash while frozen.
+ * need to take care of the metadata. Once that's done sync the superblock
+ * to the log to dirty it in case of a crash while frozen. This ensures that we
+ * will recover the unlinked inode lists on the next mount.
  */
 STATIC int
 xfs_fs_freeze(
@@ -1296,7 +1297,7 @@ xfs_fs_freeze(
 
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
-	return xfs_fs_log_dummy(mp);
+	return xfs_sync_sb(mp, true);
 }
 
 STATIC int
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
