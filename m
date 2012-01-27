Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RLFuN8253297 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 15:15:56 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wCJ8T1Ru1lAS68A5 for
	<xfs@oss.sgi.com>; Fri, 27 Jan 2012 13:15:54 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/3] xfs: honor the O_SYNC flag for aysnchronous direct I/O
	requests
Date: Fri, 27 Jan 2012 16:15:47 -0500
Message-Id: <1327698949-12616-2-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
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
To: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
Cc: Jeff Moyer <jmoyer@redhat.com>

Hi,

If a file is opened with O_SYNC|O_DIRECT, the drive cache does not get
flushed after the write completion.  Instead, it's flushed *before* the
I/O is sent to the disk (in __generic_file_aio_write).  This patch
attempts to fix that problem by marking an I/O as requiring a cache
flush in endio processing.  I'll send a follow-on patch to the
generic write code to get rid of the bogus generic_write_sync call
when EIOCBQUEUED is returned.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/xfs/xfs_aops.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_aops.h |    1 +
 fs/xfs/xfs_buf.c  |    9 +++++++
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 574d4ee..909e020 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -158,6 +158,48 @@ xfs_setfilesize(
 }
 
 /*
+ * In the case of synchronous, AIO, O_DIRECT writes, we need to flush
+ * the disk cache when the I/O is complete.
+ */
+STATIC bool
+xfs_ioend_needs_cache_flush(
+	struct xfs_ioend	*ioend)
+{
+	if (!ioend->io_isasync)
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
+STATIC void
+xfs_ioend_flush_cache(
+	struct xfs_ioend	*ioend)
+{
+	struct bio *bio;
+
+	bio = bio_alloc(GFP_KERNEL, 0);
+	bio->bi_end_io = xfs_end_io_flush;
+	bio->bi_bdev = xfs_find_bdev_for_inode(ioend->io_inode);
+	bio->bi_private = ioend;
+	submit_bio(WRITE_FLUSH, bio);
+}
+
+/*
  * Schedule IO completion handling on the final put of an ioend.
  *
  * If there is no work to do we might as well call it a day and free the
@@ -172,6 +214,8 @@ xfs_finish_ioend(
 			queue_work(xfsconvertd_workqueue, &ioend->io_work);
 		else if (xfs_ioend_is_append(ioend))
 			queue_work(xfsdatad_workqueue, &ioend->io_work);
+		else if (xfs_ioend_needs_cache_flush(ioend))
+			queue_work(xfsflushd_workqueue, &ioend->io_work);
 		else
 			xfs_destroy_ioend(ioend);
 	}
@@ -226,9 +270,30 @@ done:
 		xfs_finish_ioend(ioend);
 		/* ensure we don't spin on blocked ioends */
 		delay(1);
-	} else {
+	} else if (xfs_ioend_needs_cache_flush(ioend)) {
+		struct xfs_inode *ip = XFS_I(ioend->io_inode);
+		struct xfs_mount *mp = ip->i_mount;
+		int	err;
+		int	log_flushed = 0;
+
+		/*
+		 * Check to see if we only need to sync data.  If so,
+		 * we can skip the log flush.
+		 */
+		if (IS_SYNC(ioend->io_inode) ||
+		    (ioend->io_iocb->ki_filp->f_flags & __O_SYNC)) {
+			err = _xfs_log_force(mp, XFS_LOG_SYNC, &log_flushed);
+			if (err && ioend->io_result > 0)
+				ioend->io_result = err;
+			if (err || log_flushed) {
+				xfs_destroy_ioend(ioend);
+				return;
+			}
+		}
+		/* log not flushed or data sync only, flush the disk cache */
+		xfs_ioend_flush_cache(ioend);
+	} else
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
index 4dff85c..39980a8 100644
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
+					      WQ_MEM_RECLAIM, 1);
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
