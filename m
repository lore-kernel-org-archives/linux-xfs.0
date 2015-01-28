Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C6FC17F5A
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 16:55:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B44AE304053
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 14:55:29 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id iJp0svFc8HW3ggZd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Jan 2015 14:55:26 -0800 (PST)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YGbW9-0004FN-1r
	for xfs@oss.sgi.com; Wed, 28 Jan 2015 22:55:25 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: don't allocate an ioend for direct I/O completions
Date: Wed, 28 Jan 2015 23:54:21 +0100
Message-Id: <1422485661-520-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Back in the days when the direct I/O ->end_io callback could be called
from interrupt context for AIO we needed a structure to hand off to the
workqueue, and reused the ioend structure for this purpose.  These days
->end_io is always called from user or workqueue context, which allows us
to avoid this memory allocation and simplify the code significantly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 133 ++++++++++++++++++++++++------------------------------
 fs/xfs/xfs_aops.h |   3 --
 2 files changed, 59 insertions(+), 77 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 18e2f3b..31d3d7d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -135,30 +135,22 @@ xfs_setfilesize_trans_alloc(
  */
 STATIC int
 xfs_setfilesize(
-	struct xfs_ioend	*ioend)
+	struct xfs_inode	*ip,
+	struct xfs_trans	*tp,
+	xfs_off_t		offset,
+	size_t			size)
 {
-	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
-	struct xfs_trans	*tp = ioend->io_append_trans;
 	xfs_fsize_t		isize;
 
-	/*
-	 * The transaction may have been allocated in the I/O submission thread,
-	 * thus we need to mark ourselves as beeing in a transaction manually.
-	 * Similarly for freeze protection.
-	 */
-	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
-	rwsem_acquire_read(&VFS_I(ip)->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
-			   0, 1, _THIS_IP_);
-
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	isize = xfs_new_eof(ip, ioend->io_offset + ioend->io_size);
+	isize = xfs_new_eof(ip, offset + size);
 	if (!isize) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_cancel(tp, 0);
 		return 0;
 	}
 
-	trace_xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
+	trace_xfs_setfilesize(ip, offset, size);
 
 	ip->i_d.di_size = isize;
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
@@ -167,6 +159,25 @@ xfs_setfilesize(
 	return xfs_trans_commit(tp, 0);
 }
 
+STATIC int
+xfs_setfilesize_ioend(
+	struct xfs_ioend	*ioend)
+{
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_trans	*tp = ioend->io_append_trans;
+
+	/*
+	 * The transaction may have been allocated in the I/O submission thread,
+	 * thus we need to mark ourselves as beeing in a transaction manually.
+	 * Similarly for freeze protection.
+	 */
+	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
+	rwsem_acquire_read(&VFS_I(ip)->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
+			   0, 1, _THIS_IP_);
+
+	return xfs_setfilesize(ip, tp, ioend->io_offset, ioend->io_size);
+}
+
 /*
  * Schedule IO completion handling on the final put of an ioend.
  *
@@ -182,8 +193,7 @@ xfs_finish_ioend(
 
 		if (ioend->io_type == XFS_IO_UNWRITTEN)
 			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
-		else if (ioend->io_append_trans ||
-			 (ioend->io_isdirect && xfs_ioend_is_append(ioend)))
+		else if (ioend->io_append_trans)
 			queue_work(mp->m_data_workqueue, &ioend->io_work);
 		else
 			xfs_destroy_ioend(ioend);
@@ -215,22 +225,8 @@ xfs_end_io(
 	if (ioend->io_type == XFS_IO_UNWRITTEN) {
 		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
 						  ioend->io_size);
-	} else if (ioend->io_isdirect && xfs_ioend_is_append(ioend)) {
-		/*
-		 * For direct I/O we do not know if we need to allocate blocks
-		 * or not so we can't preallocate an append transaction as that
-		 * results in nested reservations and log space deadlocks. Hence
-		 * allocate the transaction here. While this is sub-optimal and
-		 * can block IO completion for some time, we're stuck with doing
-		 * it this way until we can pass the ioend to the direct IO
-		 * allocation callbacks and avoid nesting that way.
-		 */
-		error = xfs_setfilesize_trans_alloc(ioend);
-		if (error)
-			goto done;
-		error = xfs_setfilesize(ioend);
 	} else if (ioend->io_append_trans) {
-		error = xfs_setfilesize(ioend);
+		error = xfs_setfilesize_ioend(ioend);
 	} else {
 		ASSERT(!xfs_ioend_is_append(ioend));
 	}
@@ -273,7 +269,6 @@ xfs_alloc_ioend(
 	 * all the I/O from calling the completion routine too early.
 	 */
 	atomic_set(&ioend->io_remaining, 1);
-	ioend->io_isdirect = 0;
 	ioend->io_error = 0;
 	ioend->io_list = NULL;
 	ioend->io_type = type;
@@ -1459,11 +1454,7 @@ xfs_get_blocks_direct(
  *
  * If the private argument is non-NULL __xfs_get_blocks signals us that we
  * need to issue a transaction to convert the range from unwritten to written
- * extents.  In case this is regular synchronous I/O we just call xfs_end_io
- * to do this and we are done.  But in case this was a successful AIO
- * request this handler is called from interrupt context, from which we
- * can't start transactions.  In that case offload the I/O completion to
- * the workqueues we also use for buffered I/O completion.
+ * extents.
  */
 STATIC void
 xfs_end_io_direct_write(
@@ -1472,7 +1463,12 @@ xfs_end_io_direct_write(
 	ssize_t			size,
 	void			*private)
 {
-	struct xfs_ioend	*ioend = iocb->private;
+	struct inode		*inode = file_inode(iocb->ki_filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return;
 
 	/*
 	 * While the generic direct I/O code updates the inode size, it does
@@ -1480,22 +1476,33 @@ xfs_end_io_direct_write(
 	 * end_io handler thinks the on-disk size is outside the in-core
 	 * size.  To prevent this just update it a little bit earlier here.
 	 */
-	if (offset + size > i_size_read(ioend->io_inode))
-		i_size_write(ioend->io_inode, offset + size);
+	if (offset + size > i_size_read(inode))
+		i_size_write(inode, offset + size);
 
 	/*
-	 * blockdev_direct_IO can return an error even after the I/O
-	 * completion handler was called.  Thus we need to protect
-	 * against double-freeing.
+	 * For direct I/O we do not know if we need to allocate blocks or not,
+	 * so we can't preallocate an append transaction, as that results in
+	 * nested reservations and log space deadlocks. Hence allocate the
+	 * transaction here. While this is sub-optimal and can block IO
+	 * completion for some time, we're stuck with doing it this way until
+	 * we can pass the ioend to the direct IO allocation callbacks and
+	 * avoid nesting that way.
 	 */
-	iocb->private = NULL;
-
-	ioend->io_offset = offset;
-	ioend->io_size = size;
-	if (private && size > 0)
-		ioend->io_type = XFS_IO_UNWRITTEN;
+	if (private && size > 0) {
+		xfs_iomap_write_unwritten(ip, offset, size);
+	} else if (offset + size > ip->i_d.di_size) {
+		struct xfs_trans	*tp;
+		int			error;
+
+		tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
+		if (error) {
+			xfs_trans_cancel(tp, 0);
+			return;
+		}
 
-	xfs_finish_ioend_sync(ioend);
+		xfs_setfilesize(ip, tp, offset, size);
+	}
 }
 
 STATIC ssize_t
@@ -1507,39 +1514,17 @@ xfs_vm_direct_IO(
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
-	struct xfs_ioend	*ioend = NULL;
-	ssize_t			ret;
 
 	if (rw & WRITE) {
-		size_t size = iov_iter_count(iter);
-
-		/*
-		 * We cannot preallocate a size update transaction here as we
-		 * don't know whether allocation is necessary or not. Hence we
-		 * can only tell IO completion that one is necessary if we are
-		 * not doing unwritten extent conversion.
-		 */
-		iocb->private = ioend = xfs_alloc_ioend(inode, XFS_IO_DIRECT);
-		if (offset + size > XFS_I(inode)->i_d.di_size)
-			ioend->io_isdirect = 1;
-
-		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iter,
+		return __blockdev_direct_IO(rw, iocb, inode, bdev, iter,
 					    offset, xfs_get_blocks_direct,
 					    xfs_end_io_direct_write, NULL,
 					    DIO_ASYNC_EXTEND);
-		if (ret != -EIOCBQUEUED && iocb->private)
-			goto out_destroy_ioend;
 	} else {
-		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iter,
+		return __blockdev_direct_IO(rw, iocb, inode, bdev, iter,
 					    offset, xfs_get_blocks_direct,
 					    NULL, NULL, 0);
 	}
-
-	return ret;
-
-out_destroy_ioend:
-	xfs_destroy_ioend(ioend);
-	return ret;
 }
 
 /*
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index f94dd45..ac644e0 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -24,14 +24,12 @@ extern mempool_t *xfs_ioend_pool;
  * Types of I/O for bmap clustering and I/O completion tracking.
  */
 enum {
-	XFS_IO_DIRECT = 0,	/* special case for direct I/O ioends */
 	XFS_IO_DELALLOC,	/* covers delalloc region */
 	XFS_IO_UNWRITTEN,	/* covers allocated but uninitialized data */
 	XFS_IO_OVERWRITE,	/* covers already allocated extent */
 };
 
 #define XFS_IO_TYPES \
-	{ 0,			"" }, \
 	{ XFS_IO_DELALLOC,		"delalloc" }, \
 	{ XFS_IO_UNWRITTEN,		"unwritten" }, \
 	{ XFS_IO_OVERWRITE,		"overwrite" }
@@ -45,7 +43,6 @@ typedef struct xfs_ioend {
 	unsigned int		io_type;	/* delalloc / unwritten */
 	int			io_error;	/* I/O error code */
 	atomic_t		io_remaining;	/* hold count */
-	unsigned int		io_isdirect : 1;/* direct I/O */
 	struct inode		*io_inode;	/* file being written to */
 	struct buffer_head	*io_buffer_head;/* buffer linked list head */
 	struct buffer_head	*io_buffer_tail;/* buffer linked list tail */
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
