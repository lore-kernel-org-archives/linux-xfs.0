Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q98AtKhF055678 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 05:55:20 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vA4tZOQS3OMJGnCQ for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 03:56:47 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLB0h-0000Vj-70
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 21:56:31 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLB0h-00027r-3e
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 21:56:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/14] xfs: move xfs_quiesce_attr() into xfs_super.c
Date: Mon,  8 Oct 2012 21:56:07 +1100
Message-Id: <1349693772-8064-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1349693772-8064-1-git-send-email-david@fromorbit.com>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Both callers of xfs_quiesce_attr() are in xfs_super.c, and there's
nothing really sync-specific about this functionality so it doesn't
really matter where it lives. Move it to benext to it's callers, so
all the remount/sync_fs code is in the one place.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_super.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sync.c  |   65 --------------------------------------------------
 fs/xfs/xfs_sync.h  |    3 ---
 3 files changed, 67 insertions(+), 68 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6b0af18..bdb41dc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1148,6 +1148,73 @@ xfs_restore_resvblks(struct xfs_mount *mp)
 	xfs_reserve_blocks(mp, &resblks, NULL);
 }
 
+/*
+ * Trigger writeback of all the dirty metadata in the file system.
+ *
+ * This ensures that the metadata is written to their location on disk rather
+ * than just existing in transactions in the log. This means after a quiesce
+ * there is no log replay required to write the inodes to disk (this is the main
+ * difference between a sync and a quiesce).
+ *
+ * This shoul deffectively mimic the code in xfs_unmountfs() and
+ * xfs_log_umount() but without tearing down any structures.
+ * XXX: bug fixes needed!
+ *
+ * Note: this stops background log work - the callers must ensure it is started
+ * again when appropriate.
+ */
+void
+xfs_quiesce_attr(
+	struct xfs_mount	*mp)
+{
+	int	error = 0;
+
+	/* wait for all modifications to complete */
+	while (atomic_read(&mp->m_active_trans) > 0)
+		delay(100);
+
+	/* force the log to unpin objects from the now complete transactions */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
+	/* reclaim inodes to do any IO before the freeze completes */
+	xfs_reclaim_inodes(mp, 0);
+	xfs_reclaim_inodes(mp, SYNC_WAIT);
+
+	/* flush all pending changes from the AIL */
+	xfs_ail_push_all_sync(mp->m_ail);
+
+	/* stop background log work */
+	cancel_delayed_work_sync(&mp->m_log->l_work);
+
+	/*
+	 * Just warn here till VFS can correctly support
+	 * read-only remount without racing.
+	 */
+	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
+
+	/* Push the superblock and write an unmount record */
+	error = xfs_log_sbcount(mp);
+	if (error)
+		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
+				"Frozen image may not be consistent.");
+	xfs_log_unmount_write(mp);
+
+	/*
+	 * At this point we might have modified the superblock again and thus
+	 * added an item to the AIL, thus flush it again.
+	 */
+	xfs_ail_push_all_sync(mp->m_ail);
+
+	/*
+	 * The superblock buffer is uncached and xfsaild_push() will lock and
+	 * set the XBF_ASYNC flag on the buffer. We cannot do xfs_buf_iowait()
+	 * here but a lock on the superblock buffer will block until iodone()
+	 * has completed.
+	 */
+	xfs_buf_lock(mp->m_sb_bp);
+	xfs_buf_unlock(mp->m_sb_bp);
+}
+
 STATIC int
 xfs_fs_remount(
 	struct super_block	*sb,
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 581eb59..7b63028 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -215,71 +215,6 @@ xfs_inode_ag_iterator(
 }
 
 /*
- * Second stage of a quiesce. The data is already synced, now we have to take
- * care of the metadata. New transactions are already blocked, so we need to
- * wait for any remaining transactions to drain out before proceeding.
- *
- * The second phase ensures that the inodes are written to their
- * location on disk rather than just existing in transactions in the log. This
- * means after a quiesce there is no log replay required to write the inodes to
- * disk (this is the main difference between a sync and a quiesce).
- *
- * Note: this stops background sync work - the callers must ensure it is started
- * again when appropriate.
- */
-void
-xfs_quiesce_attr(
-	struct xfs_mount	*mp)
-{
-	int	error = 0;
-
-	/* wait for all modifications to complete */
-	while (atomic_read(&mp->m_active_trans) > 0)
-		delay(100);
-
-	/* force the log to unpin objects from the now complete transactions */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
-	/* reclaim inodes to do any IO before the freeze completes */
-	xfs_reclaim_inodes(mp, 0);
-	xfs_reclaim_inodes(mp, SYNC_WAIT);
-
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
-	/* Push the superblock and write an unmount record */
-	error = xfs_log_sbcount(mp);
-	if (error)
-		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
-				"Frozen image may not be consistent.");
-	xfs_log_unmount_write(mp);
-
-	/*
-	 * At this point we might have modified the superblock again and thus
-	 * added an item to the AIL, thus flush it again.
-	 */
-	xfs_ail_push_all_sync(mp->m_ail);
-
-	/*
-	 * The superblock buffer is uncached and xfsaild_push() will lock and
-	 * set the XBF_ASYNC flag on the buffer. We cannot do xfs_buf_iowait()
-	 * here but a lock on the superblock buffer will block until iodone()
-	 * has completed.
-	 */
-	xfs_buf_lock(mp->m_sb_bp);
-	xfs_buf_unlock(mp->m_sb_bp);
-}
-
-/*
  * Queue a new inode reclaim pass if there are reclaimable inodes and there
  * isn't a reclaim pass already in progress. By default it runs every 5s based
  * on the xfs periodic sync default of 30s. Perhaps this should have it's own
diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
index 0beabea..0ba9c89 100644
--- a/fs/xfs/xfs_sync.h
+++ b/fs/xfs/xfs_sync.h
@@ -26,9 +26,6 @@ struct xfs_perag;
 
 void xfs_reclaim_worker(struct work_struct *work);
 
-int xfs_quiesce_data(struct xfs_mount *mp);
-void xfs_quiesce_attr(struct xfs_mount *mp);
-
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 void xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
