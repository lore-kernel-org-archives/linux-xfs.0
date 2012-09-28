Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S4i4wH174880 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 23:44:04 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	49BdAec9UXXrOHOn for <xfs@oss.sgi.com>;
	Thu, 27 Sep 2012 21:45:23 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1THSRf-0007Lv-IF
	for xfs@oss.sgi.com; Fri, 28 Sep 2012 14:44:59 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1THSRV-0005GT-4D
	for xfs@oss.sgi.com; Fri, 28 Sep 2012 14:44:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/13] xfs: Bring some sanity to log unmounting
Date: Fri, 28 Sep 2012 14:44:37 +1000
Message-Id: <1348807485-20165-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1348807485-20165-1-git-send-email-david@fromorbit.com>
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
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

When unmounting the filesystem, there are lots of operations that
need to be done in a specific order, and they are spread across
across a couple of functions. We have to drain the AIL before we
write the unmount record, and we have to shut down the background
log work before we do either of them.

But this is all split haphazardly across xfs_unmountfs() and
xfs_log_unmount(). Move all the AIL flushing and log manipulations
to xfs_log_unmount() so that the responisbilities of each function
is clear and the operations they perform obvious.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log.c   |   29 ++++++++++++++++++++++++++---
 fs/xfs/xfs_mount.c |   24 ------------------------
 2 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a1fe7a7..a400e71 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -853,15 +853,38 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 }	/* xfs_log_unmount_write */
 
 /*
- * Deallocate log structures for unmount/relocation.
+ * Shut down and release the AIL and Log.
  *
- * We need to stop the aild from running before we destroy
- * and deallocate the log as the aild references the log.
+ * During unmount, we need to ensure we flush all the dirty metadata objects
+ * from the AIL so that the log is empty before we write the unmount record to
+ * the log.
+ *
+ * To do this, we first need to shut down the background log work so it is not
+ * trying to cover the log as we clean up. We then need to unpin all objects in
+ * the log so we can then flush them out. Once they have completed their IO and
+ * run the callbacks removing themselves from the AIL, we can write the unmount
+ * record, tear down the AIL and finally free the log.
  */
 void
 xfs_log_unmount(xfs_mount_t *mp)
 {
 	cancel_delayed_work_sync(&mp->m_log->l_work);
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
+	/*
+	 * The superblock buffer is uncached and while xfs_ail_push_all_sync()
+	 * will push it, xfs_wait_buftarg() will not wait for it. Further,
+	 * xfs_buf_iowait() cannot be used because it was pushed with the
+	 * XBF_ASYNC flag set, so we need to use a lock/unlock pair to wait for
+	 * the IO to complete.
+	 */
+	xfs_ail_push_all_sync(mp->m_ail);
+	xfs_wait_buftarg(mp->m_ddev_targp);
+	xfs_buf_lock(mp->m_sb_bp);
+	xfs_buf_unlock(mp->m_sb_bp);
+
+	xfs_log_unmount_write(mp);
+
 	xfs_trans_ail_destroy(mp);
 	xlog_dealloc_log(mp->m_log);
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3152924..149b601 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1493,13 +1493,6 @@ xfs_unmountfs(
 	xfs_qm_unmount(mp);
 
 	/*
-	 * Flush out the log synchronously so that we know for sure
-	 * that nothing is pinned.  This is important because bflush()
-	 * will skip pinned buffers.
-	 */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
-	/*
 	 * Unreserve any blocks we have so that when we unmount we don't account
 	 * the reserved free space as used. This is really only necessary for
 	 * lazy superblock counting because it trusts the incore superblock
@@ -1524,23 +1517,6 @@ xfs_unmountfs(
 		xfs_warn(mp, "Unable to update superblock counters. "
 				"Freespace may not be correct on next mount.");
 
-	/*
-	 * At this point we might have modified the superblock again and thus
-	 * added an item to the AIL, thus flush it again.
-	 */
-	xfs_ail_push_all_sync(mp->m_ail);
-	xfs_wait_buftarg(mp->m_ddev_targp);
-
-	/*
-	 * The superblock buffer is uncached and xfsaild_push() will lock and
-	 * set the XBF_ASYNC flag on the buffer. We cannot do xfs_buf_iowait()
-	 * here but a lock on the superblock buffer will block until iodone()
-	 * has completed.
-	 */
-	xfs_buf_lock(mp->m_sb_bp);
-	xfs_buf_unlock(mp->m_sb_bp);
-
-	xfs_log_unmount_write(mp);
 	xfs_log_unmount(mp);
 	xfs_uuid_unmount(mp);
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
