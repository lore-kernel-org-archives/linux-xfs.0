Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UJjlEs193022 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 14:45:47 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id inscDXBBityIXYwW for
	<xfs@oss.sgi.com>; Fri, 30 Mar 2012 12:45:45 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 5/7] xfs: honor the O_SYNC flag for aysnchronous direct
	I/O requests
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
	<1333058705-31512-6-git-send-email-jmoyer@redhat.com>
	<20120329225743.GC18323@dastard>
	<x49y5qii1mx.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 30 Mar 2012 15:45:37 -0400
In-Reply-To: <x49y5qii1mx.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Fri, 30 Mar 2012 10:50:30 -0400")
Message-ID: <x49d37tj2ji.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, linux-ext4@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

--=-=-=

Jeff Moyer <jmoyer@redhat.com> writes:

> Hi, Dave,
>
> Thanks for the review!
>
>> or better still, factor xfs_file_fsync() so that it calls a helper
>> that doesn't wait for data IO completion, and call that helper here
>> too. The semantics of fsync/fdatasync are too complex to have to
>> implement and maintain in multiple locations....
>
> I definitely agree with consolidating things.  However, there are four
> blocking calls in xfs_file_fsync (filemap_write_and_wait_range,
> xfs_blkdev_issue_flush, _xfs_log_force_lsn, and another call to
> xfs_blkdev_issue_flush).  How would you propose to make that
> non-blocking given that those steps have to happen in sequence?

OK, so re-reading your mail, I think you meant to just factor out
everything except the filemap_write_and_wait_range.  Here are a couple
of patches which do that.  Also, since we're not worried about blocking
in the endio processing, just making things synchronous makes the code a
lot simpler.  Let me know what you think of the attached two patches
(which I've already run through xfstests).

Thanks!
Jeff


--=-=-=
Content-Disposition: attachment;
 filename=xfs-factor-out-xfs-file-fsync.patch

xfs: factor out everything but the filemap_write_and_wait from xfs_file_fsync

Hi,

Fsyncing is tricky business, so factor out the bits of the xfs_file_fsync
function that can be used from the I/O post-processing path.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 54a67dd..e63030f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -153,25 +153,18 @@ xfs_dir_fsync(
 	return _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
 }
 
+/*
+ * Returns 0 on success, -errno on failure.
+ */
 STATIC int
-xfs_file_fsync(
-	struct file		*file,
-	loff_t			start,
-	loff_t			end,
+do_xfs_file_fsync(
+	struct xfs_inode	*ip,
+	struct xfs_mount	*mp,
 	int			datasync)
 {
-	struct inode		*inode = file->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	int			error = 0;
 	int			log_flushed = 0;
 	xfs_lsn_t		lsn = 0;
-
-	trace_xfs_file_fsync(ip);
-
-	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (error)
-		return error;
+	int			error = 0;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -XFS_ERROR(EIO);
@@ -223,6 +216,27 @@ xfs_file_fsync(
 	return -error;
 }
 
+STATIC int
+xfs_file_fsync(
+	struct file		*file,
+	loff_t			start,
+	loff_t			end,
+	int			datasync)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error = 0;
+
+	trace_xfs_file_fsync(ip);
+
+	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (error)
+		return error;
+
+	return do_xfs_file_fsync(ip, mp, datasync);
+}
+
 STATIC ssize_t
 xfs_file_aio_read(
 	struct kiocb		*iocb,

--=-=-=
Content-Disposition: attachment;
 filename=xfs-flush-disk-cache-for-aio-dio-osync-writes.patch

xfs: honor the O_SYNC flag for aysnchronous direct I/O requests

Hi,

If a file is opened with O_SYNC|O_DIRECT, the drive cache does not get
flushed after the write completion for AIOs.  This patch attempts to fix
that problem by marking an I/O as requiring a cache flush in endio
processing, and then issuing the cache flush after any unwritten extent
conversion is done.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0dbb9e7..5c71d25 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -39,6 +39,8 @@
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
 
+extern int do_xfs_file_fsync(struct xfs_inode *, struct xfs_mount *, int);
+
 void
 xfs_count_page_state(
 	struct page		*page,
@@ -170,6 +172,24 @@ xfs_setfilesize(
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
+	return (IS_SYNC(ioend->io_inode) ||
+		(ioend->io_iocb->ki_filp->f_flags & O_DSYNC));
+}
+
+/*
  * Schedule IO completion handling on the final put of an ioend.
  *
  * If there is no work to do we might as well call it a day and free the
@@ -186,11 +206,30 @@ xfs_finish_ioend(
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
@@ -238,12 +277,22 @@ xfs_end_io(
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
@@ -280,6 +329,7 @@ xfs_alloc_ioend(
 	atomic_set(&ioend->io_remaining, 1);
 	ioend->io_isasync = 0;
 	ioend->io_isdirect = 0;
+	ioend->io_needs_fsync = 0;
 	ioend->io_error = 0;
 	ioend->io_list = NULL;
 	ioend->io_type = type;
@@ -1324,6 +1374,8 @@ xfs_end_io_direct_write(
 
 	if (is_async) {
 		ioend->io_isasync = 1;
+		if (xfs_ioend_needs_cache_flush(ioend))
+			ioend->io_needs_fsync = 1;
 		xfs_finish_ioend(ioend);
 	} else {
 		xfs_finish_ioend_sync(ioend);
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 84eafbc..f0ec42a 100644
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
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e63030f..9c1b5e8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -156,7 +156,7 @@ xfs_dir_fsync(
 /*
  * Returns 0 on success, -errno on failure.
  */
-STATIC int
+int
 do_xfs_file_fsync(
 	struct xfs_inode	*ip,
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9eba738..4d85234 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -214,6 +214,7 @@ typedef struct xfs_mount {
 
 	struct workqueue_struct	*m_data_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
+	struct workqueue_struct *m_aio_blkdev_flush_wq;
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index dab9a5f..5543223 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -773,8 +773,15 @@ xfs_init_mount_workqueues(
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_data_iodone_queue;
 
+	mp->m_aio_blkdev_flush_wq = alloc_workqueue("xfs-aio-blkdev-flush/%s",
+			WQ_MEM_RECLAIM, 0, mp->m_fsname);
+	if (!mp->m_aio_blkdev_flush_wq)
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
+	destroy_workqueue(mp->m_aio_blkdev_flush_wq);
 	destroy_workqueue(mp->m_data_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
 }

--=-=-=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-=-=--
