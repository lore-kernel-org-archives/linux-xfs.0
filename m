Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TM5KLu198860 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 17:05:20 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YLTMQoy0H2c6oteQ for
	<xfs@oss.sgi.com>; Thu, 29 Mar 2012 15:05:19 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 5/7] xfs: honor the O_SYNC flag for aysnchronous direct I/O
	requests
Date: Thu, 29 Mar 2012 18:05:03 -0400
Message-Id: <1333058705-31512-6-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

Hi,

If a file is opened with O_SYNC|O_DIRECT, the drive cache does not get
flushed after the write completion for AIOs.  This patch attempts to fix
that problem by marking an I/O as requiring a cache flush in endio
processing, and then issuing the cache flush after any unwritten extent
conversion is done.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/xfs/xfs_aops.c  |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_super.c |    8 ++++
 3 files changed, 116 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0dbb9e7..6ef8f7a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -170,6 +170,58 @@ xfs_setfilesize(
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
@@ -186,11 +238,61 @@ xfs_finish_ioend(
 			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
 		else if (ioend->io_append_trans)
 			queue_work(mp->m_data_workqueue, &ioend->io_work);
+		else if (xfs_ioend_needs_cache_flush(ioend))
+			queue_work(mp->m_flush_workqueue, &ioend->io_work);
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
@@ -243,7 +345,11 @@ xfs_end_io(
 	}
 
 done:
-	xfs_destroy_ioend(ioend);
+	/* the honoring of O_SYNC has to be done last */
+	if (xfs_ioend_needs_cache_flush(ioend))
+		xfs_ioend_force_cache_flush(ioend);
+	else
+		xfs_destroy_ioend(ioend);
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9eba738..e406204 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -214,6 +214,7 @@ typedef struct xfs_mount {
 
 	struct workqueue_struct	*m_data_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
+	struct workqueue_struct *m_flush_workqueue;
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index dab9a5f..e32b309 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -773,8 +773,15 @@ xfs_init_mount_workqueues(
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_data_iodone_queue;
 
+	mp->m_flush_workqueue = alloc_workqueue("xfs-flush/%s",
+			WQ_MEM_RECLAIM, 0, mp->m_fsname);
+	if (!mp->m_flush_workqueue)
+		goto out_destroy_unwritten_queue;
+
 	return 0;
 
+out_destroy_unwritten_queue:
+	destroy_workqueue(mp->m_unwritten_workqueue);
 out_destroy_data_iodone_queue:
 	destroy_workqueue(mp->m_data_workqueue);
 out:
@@ -785,6 +792,7 @@ STATIC void
 xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
+	destroy_workqueue(mp->m_flush_workqueue);
 	destroy_workqueue(mp->m_data_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
