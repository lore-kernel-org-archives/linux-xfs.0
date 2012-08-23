Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53En0134995 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:14 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mYwkThb3K3kkvziE for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pa0-0003Fn-J9
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pa0-0003dc-G7
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 030/102] xfs: remove the i_new_size field in struct xfs_inode
Date: Thu, 23 Aug 2012 15:01:48 +1000
Message-Id: <1345698180-13612-31-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 2813d682e8e6a278f94817429afd46b30875bb6e

Now that we use the VFS i_size field throughout XFS there is no need for the
i_new_size field any more given that the VFS i_size field gets updated
in ->write_end before unlocking the page, and thus is always uptodate when
writeback could see a page.  Removing i_new_size also has the advantage that
we will never have to trim back di_size during a failed buffered write,
given that it never gets updated past i_size.

Note that currently the generic direct I/O code only updates i_size after
calling our end_io handler, which requires a small workaround to make
sure di_size actually makes it to disk.  I hope to fix this properly in
the generic code.

A downside is that we lose the support for parallel non-overlapping O_DIRECT
appending writes that recently was added.  I don't think keeping the complex
and fragile i_new_size infrastructure for this is a good tradeoff - if we
really care about parallel appending writers we should investigate turning
the iolock into a range lock, which would also allow for parallel
non-overlapping buffered writers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c  |   29 +++++++++--------
 fs/xfs/linux-2.6/xfs_file.c  |   72 ++++++------------------------------------
 fs/xfs/linux-2.6/xfs_trace.h |   18 +++--------
 fs/xfs/xfs_iget.c            |    1 -
 fs/xfs/xfs_inode.h           |    1 -
 5 files changed, 30 insertions(+), 91 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index a284ea7..91aa080 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -145,8 +145,7 @@ xfs_ioend_new_eof(
 	xfs_fsize_t		bsize;
 
 	bsize = ioend->io_offset + ioend->io_size;
-	isize = MAX(i_size_read(VFS_I(ip)), ip->i_new_size);
-	isize = MIN(isize, bsize);
+	isize = MIN(i_size_read(VFS_I(ip)), bsize);
 	return isize > ip->i_d.di_size ? isize : 0;
 }
 
@@ -160,11 +159,7 @@ static inline bool xfs_ioend_is_append(struct xfs_ioend *ioend)
 }
 
 /*
- * Update on-disk file size now that data has been written to disk.  The
- * current in-memory file size is i_size.  If a write is beyond eof i_new_size
- * will be the intended file size until i_size is updated.  If this write does
- * not extend all the way to the valid file size then restrict this update to
- * the end of the write.
+ * Update on-disk file size now that data has been written to disk.
  *
  * This function does not block as blocking on the inode lock in IO completion
  * can lead to IO completion order dependency deadlocks.. If it can't get the
@@ -1325,6 +1320,15 @@ xfs_end_io_direct_write(
 	struct xfs_ioend	*ioend = iocb->private;
 
 	/*
+	 * While the generic direct I/O code updates the inode size, it does
+	 * so only after the end_io handler is called, which means our
+	 * end_io handler thinks the on-disk size is outside the in-core
+	 * size.  To prevent this just update it a little bit earlier here.
+	 */
+	if (offset + size > i_size_read(ioend->io_inode))
+		i_size_write(ioend->io_inode, offset + size);
+
+	/*
 	 * blockdev_direct_IO can return an error even after the I/O
 	 * completion handler was called.  Thus we need to protect
 	 * against double-freeing.
@@ -1386,12 +1390,11 @@ xfs_vm_write_failed(
 
 	if (to > inode->i_size) {
 		/*
-		 * punch out the delalloc blocks we have already allocated. We
-		 * don't call xfs_setattr() to do this as we may be in the
-		 * middle of a multi-iovec write and so the vfs inode->i_size
-		 * will not match the xfs ip->i_size and so it will zero too
-		 * much. Hence we jus truncate the page cache to zero what is
-		 * necessary and punch the delalloc blocks directly.
+		 * Punch out the delalloc blocks we have already allocated.
+		 *
+		 * Don't bother with xfs_setattr given that nothing can have
+		 * made it to disk yet as the page is still locked at this
+		 * point.
 		 */
 		struct xfs_inode	*ip = XFS_I(inode);
 		xfs_fileoff_t		start_fsb;
diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 78a9cf4..e3076f0 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -406,27 +406,6 @@ xfs_file_splice_read(
 }
 
 /*
- * If this was a direct or synchronous I/O that failed (such as ENOSPC) then
- * part of the I/O may have been written to disk before the error occurred.  In
- * this case the on-disk file size may have been adjusted beyond the in-memory
- * file size and now needs to be truncated back.
- */
-STATIC void
-xfs_aio_write_newsize_update(
-	struct xfs_inode	*ip,
-	xfs_fsize_t		new_size)
-{
-	if (new_size == ip->i_new_size) {
-		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
-		if (new_size == ip->i_new_size)
-			ip->i_new_size = 0;
-		if (ip->i_d.di_size > i_size_read(VFS_I(ip)))
-			ip->i_d.di_size = i_size_read(VFS_I(ip));
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
-	}
-}
-
-/*
  * xfs_file_splice_write() does not use xfs_rw_ilock() because
  * generic_file_splice_write() takes the i_mutex itself. This, in theory,
  * couuld cause lock inversions between the aio_write path and the splice path
@@ -444,7 +423,6 @@ xfs_file_splice_write(
 {
 	struct inode		*inode = outfilp->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	xfs_fsize_t		new_size;
 	int			ioflags = 0;
 	ssize_t			ret;
 
@@ -458,20 +436,12 @@ xfs_file_splice_write(
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
-	new_size = *ppos + count;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (new_size > i_size_read(inode))
-		ip->i_new_size = new_size;
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
 	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
 
 	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
 	if (ret > 0)
 		XFS_STATS_ADD(xs_write_bytes, ret);
 
-	xfs_aio_write_newsize_update(ip, new_size);
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	return ret;
 }
@@ -668,16 +638,13 @@ xfs_file_aio_write_checks(
 	struct file		*file,
 	loff_t			*pos,
 	size_t			*count,
-	xfs_fsize_t		*new_sizep,
 	int			*iolock)
 {
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	xfs_fsize_t		new_size;
 	int			error = 0;
 
 	xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
-	*new_sizep = 0;
 restart:
 	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
 	if (error) {
@@ -692,15 +659,13 @@ restart:
 	/*
 	 * If the offset is beyond the size of the file, we need to zero any
 	 * blocks that fall between the existing EOF and the start of this
-	 * write. There is no need to issue zeroing if another in-flght IO ends
-	 * at or before this one If zeronig is needed and we are currently
-	 * holding the iolock shared, we need to update it to exclusive which
-	 * involves dropping all locks and relocking to maintain correct locking
-	 * order. If we do this, restart the function to ensure all checks and
-	 * values are still valid.
+	 * write.  If zeroing is needed and we are currently holding the
+	 * iolock shared, we need to update it to exclusive which involves
+	 * dropping all locks and relocking to maintain correct locking order.
+	 * If we do this, restart the function to ensure all checks and values
+	 * are still valid.
 	 */
-	if ((ip->i_new_size && *pos > ip->i_new_size) ||
-	    (!ip->i_new_size && *pos > i_size_read(inode))) {
+	if (*pos > i_size_read(inode)) {
 		if (*iolock == XFS_IOLOCK_SHARED) {
 			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
 			*iolock = XFS_IOLOCK_EXCL;
@@ -709,19 +674,6 @@ restart:
 		}
 		error = -xfs_zero_eof(ip, *pos, i_size_read(inode));
 	}
-
-	/*
-	 * If this IO extends beyond EOF, we may need to update ip->i_new_size.
-	 * We have already zeroed space beyond EOF (if necessary).  Only update
-	 * ip->i_new_size if this IO ends beyond any other in-flight writes.
-	 */
-	new_size = *pos + *count;
-	if (new_size > i_size_read(inode)) {
-		if (new_size > ip->i_new_size)
-			ip->i_new_size = new_size;
-		*new_sizep = new_size;
-	}
-
 	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 	if (error)
 		return error;
@@ -767,7 +719,6 @@ xfs_file_dio_aio_write(
 	unsigned long		nr_segs,
 	loff_t			pos,
 	size_t			ocount,
-	xfs_fsize_t		*new_size,
 	int			*iolock)
 {
 	struct file		*file = iocb->ki_filp;
@@ -801,7 +752,7 @@ xfs_file_dio_aio_write(
 		*iolock = XFS_IOLOCK_SHARED;
 	xfs_rw_ilock(ip, *iolock);
 
-	ret = xfs_file_aio_write_checks(file, &pos, &count, new_size, iolock);
+	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
 	if (ret)
 		return ret;
 
@@ -850,7 +801,6 @@ xfs_file_buffered_aio_write(
 	unsigned long		nr_segs,
 	loff_t			pos,
 	size_t			ocount,
-	xfs_fsize_t		*new_size,
 	int			*iolock)
 {
 	struct file		*file = iocb->ki_filp;
@@ -864,7 +814,7 @@ xfs_file_buffered_aio_write(
 	*iolock = XFS_IOLOCK_EXCL;
 	xfs_rw_ilock(ip, *iolock);
 
-	ret = xfs_file_aio_write_checks(file, &pos, &count, new_size, iolock);
+	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
 	if (ret)
 		return ret;
 
@@ -904,7 +854,6 @@ xfs_file_aio_write(
 	ssize_t			ret;
 	int			iolock;
 	size_t			ocount = 0;
-	xfs_fsize_t		new_size = 0;
 
 	XFS_STATS_INC(xs_write_calls);
 
@@ -924,10 +873,10 @@ xfs_file_aio_write(
 
 	if (unlikely(file->f_flags & O_DIRECT))
 		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos,
-						ocount, &new_size, &iolock);
+						ocount, &iolock);
 	else
 		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
-						ocount, &new_size, &iolock);
+						ocount, &iolock);
 
 	if (ret <= 0)
 		goto out_unlock;
@@ -952,7 +901,6 @@ xfs_file_aio_write(
 	}
 
 out_unlock:
-	xfs_aio_write_newsize_update(ip, new_size);
 	xfs_rw_iunlock(ip, iolock);
 	return ret;
 }
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 59e8096..70c7739 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -894,7 +894,6 @@ DECLARE_EVENT_CLASS(xfs_file_class,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(xfs_fsize_t, size)
-		__field(xfs_fsize_t, new_size)
 		__field(loff_t, offset)
 		__field(size_t, count)
 		__field(int, flags)
@@ -903,17 +902,15 @@ DECLARE_EVENT_CLASS(xfs_file_class,
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->size = ip->i_d.di_size;
-		__entry->new_size = ip->i_new_size;
 		__entry->offset = offset;
 		__entry->count = count;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx "
 		  "offset 0x%llx count 0x%zx ioflags %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
-		  __entry->new_size,
 		  __entry->offset,
 		  __entry->count,
 		  __print_flags(__entry->flags, "|", XFS_IO_FLAGS))
@@ -981,7 +978,6 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(loff_t, size)
-		__field(loff_t, new_size)
 		__field(loff_t, offset)
 		__field(size_t, count)
 		__field(int, type)
@@ -993,7 +989,6 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->size = ip->i_d.di_size;
-		__entry->new_size = ip->i_new_size;
 		__entry->offset = offset;
 		__entry->count = count;
 		__entry->type = type;
@@ -1001,13 +996,11 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
 		__entry->startblock = irec ? irec->br_startblock : 0;
 		__entry->blockcount = irec ? irec->br_blockcount : 0;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
-		  "offset 0x%llx count %zd type %s "
-		  "startoff 0x%llx startblock %lld blockcount 0x%llx",
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx offset 0x%llx count %zd "
+		  "type %s startoff 0x%llx startblock %lld blockcount 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
-		  __entry->new_size,
 		  __entry->offset,
 		  __entry->count,
 		  __print_symbolic(__entry->type, XFS_IO_TYPES),
@@ -1033,7 +1026,6 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(loff_t, size)
-		__field(loff_t, new_size)
 		__field(loff_t, offset)
 		__field(size_t, count)
 	),
@@ -1041,16 +1033,14 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->size = ip->i_d.di_size;
-		__entry->new_size = ip->i_new_size;
 		__entry->offset = offset;
 		__entry->count = count;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx "
 		  "offset 0x%llx count %zd",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
-		  __entry->new_size,
 		  __entry->offset,
 		  __entry->count)
 );
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 4c8df0b..6364fc0 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -96,7 +96,6 @@ xfs_inode_alloc(
 	ip->i_update_core = 0;
 	ip->i_delayed_blks = 0;
 	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
-	ip->i_new_size = 0;
 
 	return ip;
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ed1c89e..1a181d5 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -256,7 +256,6 @@ typedef struct xfs_inode {
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
 
-	xfs_fsize_t		i_new_size;	/* size when write completes */
 	atomic_t		i_iocount;	/* outstanding I/O count */
 
 	/* VFS inode */
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
