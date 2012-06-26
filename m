Return-Path: <xfs-bounces@oss.sgi.com>
Received: from tinguely (eagdhcp-232-130.americas.sgi.com [128.162.232.130])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5QGeH6i124933 for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 11:40:17 -0500
Received: from tinguely (localhost [127.0.0.1])
	by tinguely (8.14.5/8.14.5) with ESMTP id q5QGeHQo002757
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 11:40:17 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Received: (from tinguely@localhost)
	by tinguely (8.14.5/8.14.5/Submit) id q5QGeHRU002756
	for xfs@oss.sgi.com; Tue, 26 Jun 2012 11:40:17 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20120626160102.898671754@sgi.com>
Date: Tue, 26 Jun 2012 11:00:52 -0500
From: tinguely@sgi.com
Subject: [PATCH] xfs: synchronously write the superblock on unmount
References: <20120626160051.364635296@sgi.com>
Content-Disposition: inline; filename=xfs-unmountfs_write_superblock.patch
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_wait_buftarg() does not wait for the completion of the write of the uncached
superblock. This write can race with the shutdown of the log and cause a panic if the
write does not win the race. Per Dave's suggestion, turn the final write of the
superblock into a syncronous write.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>

---
 fs/xfs/xfs_mount.c |   43 +++++++++++++++++++------------------------
 fs/xfs/xfs_mount.h |    4 +++-
 fs/xfs/xfs_sync.c  |    8 +-------
 3 files changed, 23 insertions(+), 32 deletions(-)

Index: b/fs/xfs/xfs_mount.c
===================================================================
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1517,11 +1517,6 @@ xfs_unmountfs(
 		xfs_warn(mp, "Unable to free reserved block pool. "
 				"Freespace may not be correct on next mount.");
 
-	error = xfs_log_sbcount(mp);
-	if (error)
-		xfs_warn(mp, "Unable to update superblock counters. "
-				"Freespace may not be correct on next mount.");
-
 	/*
 	 * At this point we might have modified the superblock again and thus
 	 * added an item to the AIL, thus flush it again.
@@ -1529,6 +1524,11 @@ xfs_unmountfs(
 	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_wait_buftarg(mp->m_ddev_targp);
 
+	error = xfs_write_sbcount(mp);
+	if (error)
+		xfs_warn(mp, "Unable to update superblock counters. "
+				"Freespace may not be correct on next mount.");
+
 	xfs_log_unmount_write(mp);
 	xfs_log_unmount(mp);
 	xfs_uuid_unmount(mp);
@@ -1547,19 +1547,17 @@ xfs_fs_writable(xfs_mount_t *mp)
 }
 
 /*
- * xfs_log_sbcount
+ * xfs_write_sbcount
  *
  * Sync the superblock counters to disk.
  *
- * Note this code can be called during the process of freezing, so
- * we may need to use the transaction allocator which does not
- * block when the transaction subsystem is in its frozen state.
  */
 int
-xfs_log_sbcount(xfs_mount_t *mp)
+xfs_write_sbcount(
+	struct xfs_mount	*mp)
 {
-	xfs_trans_t	*tp;
-	int		error;
+	struct xfs_buf		*bp;
+	int			error;
 
 	if (!xfs_fs_writable(mp))
 		return 0;
@@ -1571,19 +1569,16 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	 * counters on every modification.
 	 */
 	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
-		return 0;
+	return 0;
 
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP);
-	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
-					XFS_DEFAULT_LOG_COUNT);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		return error;
-	}
-
-	xfs_mod_sb(tp, XFS_SB_IFREE | XFS_SB_ICOUNT | XFS_SB_FDBLOCKS);
-	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
+	bp = xfs_getsb(mp, 0);
+	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb,
+		XFS_SB_IFREE | XFS_SB_ICOUNT | XFS_SB_FDBLOCKS);
+
+	if (xfs_buf_ispinned(bp))
+		xfs_log_force(mp, 0);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
 	return error;
 }
 
Index: b/fs/xfs/xfs_mount.h
===================================================================
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -371,7 +371,9 @@ typedef struct xfs_mod_sb {
 	int64_t		msb_delta;	/* Change to make to specified field */
 } xfs_mod_sb_t;
 
-extern int	xfs_log_sbcount(xfs_mount_t *);
+extern int
+xfs_write_sbcount(
+	struct xfs_mount *mp);
 extern __uint64_t xfs_default_resblks(xfs_mount_t *mp);
 extern int	xfs_mountfs(xfs_mount_t *mp);
 
Index: b/fs/xfs/xfs_sync.c
===================================================================
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -348,17 +348,11 @@ xfs_quiesce_attr(
 	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
 
 	/* Push the superblock and write an unmount record */
-	error = xfs_log_sbcount(mp);
+	error = xfs_write_sbcount(mp);
 	if (error)
 		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
 				"Frozen image may not be consistent.");
 	xfs_log_unmount_write(mp);
-
-	/*
-	 * At this point we might have modified the superblock again and thus
-	 * added an item to the AIL, thus flush it again.
-	 */
-	xfs_ail_push_all_sync(mp->m_ail);
 }
 
 static void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
