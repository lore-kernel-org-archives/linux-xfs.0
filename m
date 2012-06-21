Return-Path: <xfs-bounces@oss.sgi.com>
Received: from tinguely (eagdhcp-232-130.americas.sgi.com [128.162.232.130])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5LJYSO1125271 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 14:34:29 -0500
Received: from tinguely (localhost [127.0.0.1])
	by tinguely (8.14.5/8.14.5) with ESMTP id q5LJYSBP003097
	for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 14:34:28 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Received: (from tinguely@localhost)
	by tinguely (8.14.5/8.14.5/Submit) id q5LJYSSu003096
	for xfs@oss.sgi.com; Thu, 21 Jun 2012 14:34:28 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20120621192600.936441949@sgi.com>
Date: Thu, 21 Jun 2012 14:25:42 -0500
From: tinguely@sgi.com
Subject: [PATCH] xfs: force log before unmount
References: <20120621192541.630212563@sgi.com>
Content-Disposition: inline; filename=xfs-force-log-before-unmount.patch
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

From: Mark Tinguely <tinguely@sgi.com>

Testing has found a few crashes of dereference of NULL in the
xlog_assign_tail_lsn_locked() and xlog_get_lowest_lsn() routines from
buf iodone callbacks. The filesystem is be shutdown. At the point of
the crash, the log has alreadly been freed which leads to the NULL pointer
dereference. 

One crash still pointed to the buffer that was going through the iodone
path and that buffer had XFS_SB_MAGIC in it.

This patch sits on top of Ben's proposed patch to shutdown the sync worker.
Although it did not cause the crash I would like to be on the safe side, and
perform the shutdown of the sync worker to occur before the last write of the
superblock. Then force the log to get the superblock buffer into the AIL before
it is pushed for the last time..

To the best of my searching, xfs_log_unmount_write() should not dirty the
superblock..

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log.c   |    1 -
 fs/xfs/xfs_mount.c |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -810,7 +810,6 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 void
 xfs_log_unmount(xfs_mount_t *mp)
 {
-	cancel_delayed_work_sync(&mp->m_sync_work);
 	xfs_trans_ail_destroy(mp);
 	xlog_dealloc_log(mp->m_log);
 }
Index: b/fs/xfs/xfs_mount.c
===================================================================
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1517,6 +1517,7 @@ xfs_unmountfs(
 		xfs_warn(mp, "Unable to free reserved block pool. "
 				"Freespace may not be correct on next mount.");
 
+	cancel_delayed_work_sync(&mp->m_sync_work);
 	error = xfs_log_sbcount(mp);
 	if (error)
 		xfs_warn(mp, "Unable to update superblock counters. "
@@ -1526,6 +1527,7 @@ xfs_unmountfs(
 	 * At this point we might have modified the superblock again and thus
 	 * added an item to the AIL, thus flush it again.
 	 */
+	xfs_log_force(mp, XFS_LOG_SYNC);
 	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_wait_buftarg(mp->m_ddev_targp);
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
