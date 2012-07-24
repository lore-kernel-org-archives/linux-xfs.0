Return-Path: <xfs-bounces@oss.sgi.com>
Received: from tinguely (eagdhcp-232-130.americas.sgi.com [128.162.232.130])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6OFwxoI137236 for <xfs@oss.sgi.com>; Tue, 24 Jul 2012 10:58:59 -0500
Received: from tinguely (localhost [127.0.0.1])
	by tinguely (8.14.5/8.14.5) with ESMTP id q6OFww7K002654
	for <xfs@oss.sgi.com>; Tue, 24 Jul 2012 10:58:58 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Received: (from tinguely@localhost)
	by tinguely (8.14.5/8.14.5/Submit) id q6OFwwP0002653
	for xfs@oss.sgi.com; Tue, 24 Jul 2012 10:58:58 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20120724155925.079108655@sgi.com>
Date: Tue, 24 Jul 2012 10:59:19 -0500
From: tinguely@sgi.com
Subject: [PATCH v2] xfs: wait for the write the superblock on unmount
References: <20120724155918.484063773@sgi.com>
Content-Disposition: inline; filename=xfs-lock_sbcount_wait.patch
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

v2: Add the xfs_buf_lock to xfs_quiesce_attr().
    Add explaination why xfs_buf_lock() is used to wait for write.

xfs_wait_buftarg() does not wait for the completion of the write of the
uncached superblock. This write can race with the shutdown of the log and
causes a panic if the write does not win the race.

During the log write, xfsaild_push() will lock the buffer and set the
XBF_ASYNC flag. Because the XBF_FLAG is set, complete() is not performed
on the buffer's iowait entry, we cannot call xfs_buf_iowait() to wait for
the write to complete. The buffer's lock is held until the write is complete,
so we can block on a xfs_buf_lock() request to be notified that the write
is complete.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Christoph Hellwig<hch@lst.de>

---
 fs/xfs/xfs_mount.c |    9 +++++++++
 fs/xfs/xfs_sync.c  |    9 +++++++++
 2 files changed, 18 insertions(+)

Index: b/fs/xfs/xfs_mount.c
===================================================================
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1529,6 +1529,15 @@ xfs_unmountfs(
 	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_wait_buftarg(mp->m_ddev_targp);
 
+	/*
+	 * The superblock buffer is uncached and xfsaild_push() will lock and
+	 * set the XBF_ASYNC flag on the buffer. We cannot do xfs_buf_iowait()
+	 * here but a lock on the superblock buffer will block until iodone()
+	 * has completed.
+	 */
+	xfs_buf_lock(mp->m_sb_bp);
+	xfs_buf_unlock(mp->m_sb_bp);
+
 	xfs_log_unmount_write(mp);
 	xfs_log_unmount(mp);
 	xfs_uuid_unmount(mp);
Index: b/fs/xfs/xfs_sync.c
===================================================================
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -359,6 +359,15 @@ xfs_quiesce_attr(
 	 * added an item to the AIL, thus flush it again.
 	 */
 	xfs_ail_push_all_sync(mp->m_ail);
+
+	/*
+	 * The superblock buffer is uncached and xfsaild_push() will lock and
+	 * set the XBF_ASYNC flag on the buffer. We cannot do xfs_buf_iowait()
+	 * here but a lock on the superblock buffer will block until iodone()
+	 * has completed.
+	 */
+	xfs_buf_lock(mp->m_sb_bp);
+	xfs_buf_unlock(mp->m_sb_bp);
 }
 
 static void


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
