Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22Judwk138292 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 13:56:39 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id b1yL2CMyHfSEBCBc for
	<xfs@oss.sgi.com>; Fri, 02 Mar 2012 11:56:38 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 5/7] xfs: honor the O_SYNC flag for aysnchronous direct I/O
	requests
Date: Fri,  2 Mar 2012 14:56:13 -0500
Message-Id: <1330718175-21540-6-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1330718175-21540-1-git-send-email-jmoyer@redhat.com>
References: <1330718175-21540-1-git-send-email-jmoyer@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
Cc: hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>, jack@suse.cz

Hi,

If a file is opened with O_SYNC|O_DIRECT, the drive cache does not get
flushed after the write completion for AIOs.  This patch attempts to fix
that problem by marking an I/O as requiring a cache flush in endio
processing, and then issuing the cache flush after any unwritten extent
conversion is done.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/xfs/xfs_aops.c |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_aops.h |    1 +
 fs/xfs/xfs_buf.c  |    9 ++++
 3 files changed, 119 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 574d4ee..90bed4e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -26,6 +26,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
+#include "xfs_inode_item.h"
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 #include "xfs_rw.h"
@@ -158,6 +159,58 @@ xfs_setfilesize(
 }
 
 /*
+ * In the case of synchronous, AIO, O_DIRECT writes, we need to flush
+ * the disk cache when the I/O is complete.
+ */
+STATIC bool
+xfs_ioend_needs_cache_flush(
+	struct xfs_ioend	*ioend)
+{
+	struct xfs_inode *ip = XFS_I(ioend->io_inode);
+	struct xfs_mount *mp = ip->i_mount;
+
+	if (!ioend->io_isasync)
+		return false;
+
+	if (!(mp->m_flags & XFS_MOUNT_BARRIER))
+		return false;
+
+	return (IS_SYNC(ioend->io_inode) ||
+		(ioend->io_iocb->ki_filp->f_flags & O_DSYNC));
+}
+
+STATIC void
+xfs_end_io_flush(
+	struct bio	*bio,
+	int		error)
+{
+	struct xfs_ioend *ioend = bio->bi_private;
+
+	if (error && ioend->io_result > 0)
+		ioend->io_result = error;
+
+	xfs_destroy_ioend(ioend);
+	bio_put(bio);
+}
+
+/*
+ * Issue a WRITE_FLUSH to the specified device.
+ */
+STATIC void
+xfs_ioend_flush_cache(
+	struct xfs_ioend	*ioend,
+	xfs_buftarg_t		*targp)
+{
+	struct bio *bio;
+
+	bio = bio_alloc(GFP_KERNEL, 0);
+	bio->bi_end_io = xfs_end_io_flush;
+	bio->bi_bdev = targp->bt_bdev;
+	bio->bi_private = ioend;
+	submit_bio(WRITE_FLUSH, bio);
+}
+
+/*
  * Schedule IO completion handling on the final put of an ioend.
  *
  * If there is no work to do we might as well call it a day and free the
@@ -172,11 +225,61 @@ xfs_finish_ioend(
 			queue_work(xfsconvertd_workqueue, &ioend->io_work);
 		else if (xfs_ioend_is_append(ioend))
 			queue_work(xfsdatad_workqueue, &ioend->io_work);
+		else if (xfs_ioend_needs_cache_flush(ioend))
+			queue_work(xfsflushd_workqueue, &ioend->io_work);
 		else
 			xfs_destroy_ioend(ioend);
 	}
 }
 
+STATIC void
+xfs_ioend_force_cache_flush(
+	xfs_ioend_t	*ioend)
+{
+	struct xfs_inode *ip = XFS_I(ioend->io_inode);
+	struct xfs_mount *mp = ip->i_mount;
+	xfs_lsn_t	lsn = 0;
+	int		err = 0;
+	int		log_flushed = 0;
+
+	/*
+	 * Check to see if we need to sync metadata.  If so,
+	 * perform a log flush.  If not, just flush the disk
+	 * write cache for the data disk.
+	 */
+	if (IS_SYNC(ioend->io_inode) ||
+	    (ioend->io_iocb->ki_filp->f_flags & __O_SYNC)) {
+		/*
+		 * TODO: xfs_blkdev_issue_flush and _xfs_log_force_lsn
+		 * are synchronous, and so will block the I/O
+		 * completion work queue.
+		 */
+		/*
+		 * If the log device is different from the data device,
+		 * be sure to flush the cache on the data device
+		 * first.
+		 */
+		if (mp->m_logdev_targp != mp->m_ddev_targp)
+			xfs_blkdev_issue_flush(mp->m_ddev_targp);
+
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
+		if (xfs_ipincount(ip))
+			lsn = ip->i_itemp->ili_last_lsn;
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		if (lsn)
+			err = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC,
+						 &log_flushed);
+		if (err && ioend->io_result > 0)
+			ioend->io_result = err;
+		if (err || log_flushed)
+			xfs_destroy_ioend(ioend);
+		else
+			xfs_ioend_flush_cache(ioend, mp->m_logdev_targp);
+	} else
+		/* data sync only, flush the disk cache */
+		xfs_ioend_flush_cache(ioend, mp->m_ddev_targp);
+}
+
 /*
  * IO write completion.
  */
@@ -218,17 +321,19 @@ xfs_end_io(
 done:
 	/*
 	 * If we didn't complete processing of the ioend, requeue it to the
-	 * tail of the workqueue for another attempt later. Otherwise destroy
-	 * it.
+	 * tail of the workqueue for another attempt later. Otherwise, see
+	 * if we need to perform a disk write cache flush.  If not, destroy
+	 * the ioend.
 	 */
 	if (error == EAGAIN) {
 		atomic_inc(&ioend->io_remaining);
 		xfs_finish_ioend(ioend);
 		/* ensure we don't spin on blocked ioends */
 		delay(1);
-	} else {
+	} else if (xfs_ioend_needs_cache_flush(ioend))
+		xfs_ioend_force_cache_flush(ioend);
+	else
 		xfs_destroy_ioend(ioend);
-	}
 }
 
 /*
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 116dd5c..3f4a1c4 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -20,6 +20,7 @@
 
 extern struct workqueue_struct *xfsdatad_workqueue;
 extern struct workqueue_struct *xfsconvertd_workqueue;
+extern struct workqueue_struct *xfsflushd_workqueue;
 extern mempool_t *xfs_ioend_pool;
 
 /*
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4dff85c..fcc20e1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -47,6 +47,7 @@ STATIC int xfsbufd(void *);
 static struct workqueue_struct *xfslogd_workqueue;
 struct workqueue_struct *xfsdatad_workqueue;
 struct workqueue_struct *xfsconvertd_workqueue;
+struct workqueue_struct *xfsflushd_workqueue;
 
 #ifdef XFS_BUF_LOCK_TRACKING
 # define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
@@ -1802,8 +1803,15 @@ xfs_buf_init(void)
 	if (!xfsconvertd_workqueue)
 		goto out_destroy_xfsdatad_workqueue;
 
+	xfsflushd_workqueue = alloc_workqueue("xfsflushd",
+					      WQ_MEM_RECLAIM, 0);
+	if (!xfsflushd_workqueue)
+		goto out_destroy_xfsconvertd_workqueue;
+
 	return 0;
 
+ out_destroy_xfsconvertd_workqueue:
+	destroy_workqueue(xfsconvertd_workqueue);
  out_destroy_xfsdatad_workqueue:
 	destroy_workqueue(xfsdatad_workqueue);
  out_destroy_xfslogd_workqueue:
@@ -1817,6 +1825,7 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
+	destroy_workqueue(xfsflushd_workqueue);
 	destroy_workqueue(xfsconvertd_workqueue);
 	destroy_workqueue(xfsdatad_workqueue);
 	destroy_workqueue(xfslogd_workqueue);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
