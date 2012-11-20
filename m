Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK8E2iX125628 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 02:14:03 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id cM9Ak7g4DuCSnwxY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 00:16:11 -0800 (PST)
Subject: [PATCH 4/9] xfs: honor the O_SYNC flag for aysnchronous direct I/O
	requests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 19 Nov 2012 23:51:14 -0800
Message-ID: <20121120075114.25270.40680.stgit@blackbox.djwong.org>
In-Reply-To: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com, jmoyer@redhat.com, bpm@sgi.com, viro@zeniv.linux.org.uk, jack@suse.cz
Cc: djwong+kernel@djwong.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

If a file is opened with O_SYNC|O_DIRECT, the drive cache does not get
flushed after the write completion for AIOs.  This patch attempts to fix
that problem by marking an I/O as requiring a cache flush in endio
processing, and then issuing the cache flush after any unwritten extent
conversion is done.

From: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
[darrick.wong@oracle.com: Rework patch to use per-mount workqueues]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c  |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_aops.h  |    1 +
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_super.c |    8 ++++++++
 4 files changed, 61 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e57e2da..9cebbb7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -173,6 +173,24 @@ xfs_setfilesize(
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
+	if (!(mp->m_flags & XFS_MOUNT_BARRIER))
+		return false;
+
+	return IS_SYNC(ioend->io_inode) ||
+	       (ioend->io_iocb->ki_filp->f_flags & O_DSYNC);
+}
+
+/*
  * Schedule IO completion handling on the final put of an ioend.
  *
  * If there is no work to do we might as well call it a day and free the
@@ -189,11 +207,30 @@ xfs_finish_ioend(
 			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
 		else if (ioend->io_append_trans)
 			queue_work(mp->m_data_workqueue, &ioend->io_work);
+		else if (ioend->io_needs_fsync)
+			queue_work(mp->m_aio_blkdev_flush_wq, &ioend->io_work);
 		else
 			xfs_destroy_ioend(ioend);
 	}
 }
 
+STATIC int
+xfs_ioend_force_cache_flush(
+	xfs_ioend_t	*ioend)
+{
+	struct xfs_inode *ip = XFS_I(ioend->io_inode);
+	struct xfs_mount *mp = ip->i_mount;
+	int		err = 0;
+	int		datasync;
+
+	datasync = !IS_SYNC(ioend->io_inode) &&
+		!(ioend->io_iocb->ki_filp->f_flags & __O_SYNC);
+	err = do_xfs_file_fsync(ip, mp, datasync);
+	xfs_destroy_ioend(ioend);
+	/* do_xfs_file_fsync returns -errno. our caller expects positive. */
+	return -err;
+}
+
 /*
  * IO write completion.
  */
@@ -250,12 +287,22 @@ xfs_end_io(
 		error = xfs_setfilesize(ioend);
 		if (error)
 			ioend->io_error = -error;
+	} else if (ioend->io_needs_fsync) {
+		error = xfs_ioend_force_cache_flush(ioend);
+		if (error && ioend->io_result > 0)
+			ioend->io_error = -error;
+		ioend->io_needs_fsync = 0;
 	} else {
 		ASSERT(!xfs_ioend_is_append(ioend));
 	}
 
 done:
-	xfs_destroy_ioend(ioend);
+	/* the honoring of O_SYNC has to be done last */
+	if (ioend->io_needs_fsync) {
+		atomic_inc(&ioend->io_remaining);
+		xfs_finish_ioend(ioend);
+	} else
+		xfs_destroy_ioend(ioend);
 }
 
 /*
@@ -292,6 +339,7 @@ xfs_alloc_ioend(
 	atomic_set(&ioend->io_remaining, 1);
 	ioend->io_isasync = 0;
 	ioend->io_isdirect = 0;
+	ioend->io_needs_fsync = 0;
 	ioend->io_error = 0;
 	ioend->io_list = NULL;
 	ioend->io_type = type;
@@ -1409,6 +1457,8 @@ xfs_end_io_direct_write(
 
 	if (is_async) {
 		ioend->io_isasync = 1;
+		if (xfs_ioend_needs_cache_flush(ioend))
+			ioend->io_needs_fsync = 1;
 		xfs_finish_ioend(ioend);
 	} else {
 		xfs_finish_ioend_sync(ioend);
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index c325abb..e48c7c2 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -47,6 +47,7 @@ typedef struct xfs_ioend {
 	atomic_t		io_remaining;	/* hold count */
 	unsigned int		io_isasync : 1;	/* needs aio_complete */
 	unsigned int		io_isdirect : 1;/* direct I/O */
+	unsigned int		io_needs_fsync : 1; /* aio+dio+o_sync */
 	struct inode		*io_inode;	/* file being written to */
 	struct buffer_head	*io_buffer_head;/* buffer linked list head */
 	struct buffer_head	*io_buffer_tail;/* buffer linked list tail */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index deee09e..ecd3d2e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -209,6 +209,7 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_data_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
+	struct workqueue_struct *m_aio_blkdev_flush_wq;
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 26a09bd..b05b557 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -863,8 +863,15 @@ xfs_init_mount_workqueues(
 			WQ_MEM_RECLAIM, 0, mp->m_fsname);
 	if (!mp->m_cil_workqueue)
 		goto out_destroy_unwritten;
+
+	mp->m_aio_blkdev_flush_wq = alloc_workqueue("xfs-aio-blkdev-flush/%s",
+			WQ_MEM_RECLAIM, 0, mp->m_fsname);
+	if (!mp->m_aio_blkdev_flush_wq)
+		goto out_destroy_cil_queue;
 	return 0;
 
+out_destroy_cil_queue:
+	destroy_workqueue(mp->m_cil_workqueue);
 out_destroy_unwritten:
 	destroy_workqueue(mp->m_unwritten_workqueue);
 out_destroy_data_iodone_queue:
@@ -877,6 +884,7 @@ STATIC void
 xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
+	destroy_workqueue(mp->m_aio_blkdev_flush_wq);
 	destroy_workqueue(mp->m_cil_workqueue);
 	destroy_workqueue(mp->m_data_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
