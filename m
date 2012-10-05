Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95HIK1f071564 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 12:18:20 -0500
Message-Id: <20121005171947.213673389@sgi.com>
Date: Fri, 05 Oct 2012 12:19:03 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [patch v4 10/13] [PATCH 10/13] xfs: xfs_quiesce_attr() should quiesce
	the log like
References: <20121005171853.985930109@sgi.com>
Content-Disposition: inline;
	filename=xfs-xfs_quiesce_attr-should-quiesce-the-log-like.patch
	unmount
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

xfs_quiesce_attr() is supposed to leave the log empty with an
unmount record written. Right now it does not wait for the AIL to be
emptied before writing the unmount record, not does it wait for
metadata IO completion, either. Fix it to use the same method and
code as xfs_log_unmount().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log.c   |   25 ++++++++++++++++++-------
 fs/xfs/xfs_log.h   |    1 +
 fs/xfs/xfs_super.c |   41 ++++++++---------------------------------
 3 files changed, 27 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 96ea9ed..67d63f6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -853,20 +853,17 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 }	/* xfs_log_unmount_write */
 
 /*
- * Shut down and release the AIL and Log.
- *
- * During unmount, we need to ensure we flush all the dirty metadata objects
- * from the AIL so that the log is empty before we write the unmount record to
- * the log.
+ * Empty the log for unmount/freeze.
  *
  * To do this, we first need to shut down the background log work so it is not
  * trying to cover the log as we clean up. We then need to unpin all objects in
  * the log so we can then flush them out. Once they have completed their IO and
  * run the callbacks removing themselves from the AIL, we can write the unmount
- * record, tear down the AIL and finally free the log.
+ * record.
  */
 void
-xfs_log_unmount(xfs_mount_t *mp)
+xfs_log_quiesce(
+	struct xfs_mount	*mp)
 {
 	cancel_delayed_work_sync(&mp->m_log->l_work);
 	xfs_log_force(mp, XFS_LOG_SYNC);
@@ -884,6 +881,20 @@ xfs_log_unmount(xfs_mount_t *mp)
 	xfs_buf_unlock(mp->m_sb_bp);
 
 	xfs_log_unmount_write(mp);
+}
+
+/*
+ * Shut down and release the AIL and Log.
+ *
+ * During unmount, we need to ensure we flush all the dirty metadata objects
+ * from the AIL so that the log is empty before we write the unmount record to
+ * the log. Once this is done, we can tear down the AIL and the log.
+ */
+void
+xfs_log_unmount(
+	struct xfs_mount	*mp)
+{
+	xfs_log_quiesce(mp);
 
 	xfs_trans_ail_destroy(mp);
 	xlog_dealloc_log(mp->m_log);
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 26ed7de..5caee96 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -183,6 +183,7 @@ bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
 void	xfs_log_work_queue(struct xfs_mount *mp);
 void	xfs_log_worker(struct work_struct *work);
+void	xfs_log_quiesce(struct xfs_mount *mp);
 
 #endif
 #endif	/* __XFS_LOG_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4806e46..81de924 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1048,15 +1048,11 @@ xfs_restore_resvblks(struct xfs_mount *mp)
  *
  * This ensures that the metadata is written to their location on disk rather
  * than just existing in transactions in the log. This means after a quiesce
- * there is no log replay required to write the inodes to disk (this is the main
- * difference between a sync and a quiesce).
+ * there is no log replay required to write the inodes to disk - this is the
+ * primary difference between a sync and a quiesce.
  *
- * This shoul deffectively mimic the code in xfs_unmountfs() and
- * xfs_log_umount() but without tearing down any structures.
- * XXX: bug fixes needed!
- *
- * Note: this stops background log work - the callers must ensure it is started
- * again when appropriate.
+ * Note: xfs_log_quiesce() stops background log work - the callers must ensure
+ * it is started again when appropriate.
  */
 void
 xfs_quiesce_attr(
@@ -1075,39 +1071,18 @@ xfs_quiesce_attr(
 	xfs_reclaim_inodes(mp, 0);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
 
-	/* flush all pending changes from the AIL */
-	xfs_ail_push_all_sync(mp->m_ail);
-
-	/* stop background log work */
-	cancel_delayed_work_sync(&mp->m_log->l_work);
-
-	/*
-	 * Just warn here till VFS can correctly support
-	 * read-only remount without racing.
-	 */
-	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
-
 	/* Push the superblock and write an unmount record */
 	error = xfs_log_sbcount(mp);
 	if (error)
 		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
 				"Frozen image may not be consistent.");
-	xfs_log_unmount_write(mp);
-
 	/*
-	 * At this point we might have modified the superblock again and thus
-	 * added an item to the AIL, thus flush it again.
+	 * Just warn here till VFS can correctly support
+	 * read-only remount without racing.
 	 */
-	xfs_ail_push_all_sync(mp->m_ail);
+	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
 
-	/*
-	 * The superblock buffer is uncached and xfsaild_push() will lock and
-	 * set the XBF_ASYNC flag on the buffer. We cannot do xfs_buf_iowait()
-	 * here but a lock on the superblock buffer will block until iodone()
-	 * has completed.
-	 */
-	xfs_buf_lock(mp->m_sb_bp);
-	xfs_buf_unlock(mp->m_sb_bp);
+	xfs_log_quiesce(mp);
 }
 
 STATIC int
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
