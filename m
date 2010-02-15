Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1F9ilAh047249 for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 03:44:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 330321D0406
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 01:46:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tMoNZEdyHwHXdCpa for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2010 01:46:04 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NgxWm-0000Eg-GT
	for xfs@oss.sgi.com; Mon, 15 Feb 2010 09:46:04 +0000
Message-Id: <20100215094604.318261333@bombadil.infradead.org>
Date: Mon, 15 Feb 2010 04:44:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] [PATCH 2/4] xfs: remove wrappers for read/write file
	operations
References: <20100215094445.528696829@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fops-cleanup
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

Currently the aio_read, aio_write, splice_read and splice_write file
operations are divided into a low-level routine doing all the work and
one that implements the Linux file operations and does minimal argument
wrapping.  This is a leftover from the days of the vnode operations layer
and can be removed to simplify the code a lot.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-02-15 10:14:28.107003961 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-02-15 10:18:58.640023657 +0100
@@ -96,28 +96,34 @@ xfs_iozero(
 	return (-status);
 }
 
-ssize_t			/* bytes read, or (-)  error */
-xfs_read(
-	xfs_inode_t		*ip,
+STATIC ssize_t
+xfs_file_aio_read(
 	struct kiocb		*iocb,
 	const struct iovec	*iovp,
-	unsigned int		segs,
-	loff_t			*offset,
-	int			ioflags)
+	unsigned long		nr_segs,
+	loff_t			pos)
 {
 	struct file		*file = iocb->ki_filp;
 	struct inode		*inode = file->f_mapping->host;
-	xfs_mount_t		*mp = ip->i_mount;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	size_t			size = 0;
 	ssize_t			ret = 0;
+	int			ioflags = 0;
 	xfs_fsize_t		n;
 	unsigned long		seg;
 
-
 	XFS_STATS_INC(xs_read_calls);
 
+	BUG_ON(iocb->ki_pos != pos);
+
+	if (unlikely(file->f_flags & O_DIRECT))
+		ioflags |= IO_ISDIRECT;
+	if (file->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
+
 	/* START copy & waste from filemap.c */
-	for (seg = 0; seg < segs; seg++) {
+	for (seg = 0; seg < nr_segs; seg++) {
 		const struct iovec *iv = &iovp[seg];
 
 		/*
@@ -134,17 +140,16 @@ xfs_read(
 		xfs_buftarg_t	*target =
 			XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp;
-		if ((*offset & target->bt_smask) ||
+		if ((iocb->ki_pos & target->bt_smask) ||
 		    (size & target->bt_smask)) {
-			if (*offset == ip->i_size) {
-				return (0);
-			}
+			if (iocb->ki_pos == ip->i_size)
+				return 0;
 			return -XFS_ERROR(EINVAL);
 		}
 	}
 
-	n = XFS_MAXIOFFSET(mp) - *offset;
-	if ((n <= 0) || (size == 0))
+	n = XFS_MAXIOFFSET(mp) - iocb->ki_pos;
+	if (n <= 0 || size == 0)
 		return 0;
 
 	if (n < size)
@@ -161,7 +166,7 @@ xfs_read(
 		int dmflags = FILP_DELAY_FLAG(file) | DM_SEM_FLAG_RD(ioflags);
 		int iolock = XFS_IOLOCK_SHARED;
 
-		ret = -XFS_SEND_DATA(mp, DM_EVENT_READ, ip, *offset, size,
+		ret = -XFS_SEND_DATA(mp, DM_EVENT_READ, ip, iocb->ki_pos, size,
 					dmflags, &iolock);
 		if (ret) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
@@ -172,9 +177,11 @@ xfs_read(
 	}
 
 	if (unlikely(ioflags & IO_ISDIRECT)) {
-		if (inode->i_mapping->nrpages)
-			ret = -xfs_flushinval_pages(ip, (*offset & PAGE_CACHE_MASK),
-						    -1, FI_REMAPF_LOCKED);
+		if (inode->i_mapping->nrpages) {
+			ret = -xfs_flushinval_pages(ip,
+					(iocb->ki_pos & PAGE_CACHE_MASK),
+					-1, FI_REMAPF_LOCKED);
+		}
 		mutex_unlock(&inode->i_mutex);
 		if (ret) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
@@ -182,10 +189,9 @@ xfs_read(
 		}
 	}
 
-	trace_xfs_file_read(ip, size, *offset, ioflags);
+	trace_xfs_file_read(ip, size, iocb->ki_pos, ioflags);
 
-	iocb->ki_pos = *offset;
-	ret = generic_file_aio_read(iocb, iovp, segs, *offset);
+	ret = generic_file_aio_read(iocb, iovp, nr_segs, iocb->ki_pos);
 	if (ret > 0)
 		XFS_STATS_ADD(xs_read_bytes, ret);
 
@@ -193,20 +199,24 @@ xfs_read(
 	return ret;
 }
 
-ssize_t
-xfs_splice_read(
-	xfs_inode_t		*ip,
+STATIC ssize_t
+xfs_file_splice_read(
 	struct file		*infilp,
 	loff_t			*ppos,
 	struct pipe_inode_info	*pipe,
 	size_t			count,
-	int			flags,
-	int			ioflags)
+	unsigned int		flags)
 {
-	xfs_mount_t		*mp = ip->i_mount;
+	struct xfs_inode	*ip = XFS_I(infilp->f_mapping->host);
+	struct xfs_mount	*mp = ip->i_mount;
+	int			ioflags = 0;
 	ssize_t			ret;
 
 	XFS_STATS_INC(xs_read_calls);
+
+	if (infilp->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
+
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
@@ -234,22 +244,26 @@ xfs_splice_read(
 	return ret;
 }
 
-ssize_t
-xfs_splice_write(
-	xfs_inode_t		*ip,
+STATIC ssize_t
+xfs_file_splice_write(
 	struct pipe_inode_info	*pipe,
 	struct file		*outfilp,
 	loff_t			*ppos,
 	size_t			count,
-	int			flags,
-	int			ioflags)
+	unsigned int		flags)
 {
-	xfs_mount_t		*mp = ip->i_mount;
-	ssize_t			ret;
 	struct inode		*inode = outfilp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fsize_t		isize, new_size;
+	int			ioflags = 0;
+	ssize_t			ret;
 
 	XFS_STATS_INC(xs_write_calls);
+
+	if (outfilp->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
+
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
@@ -484,42 +498,43 @@ out_lock:
 	return error;
 }
 
-ssize_t				/* bytes written, or (-) error */
-xfs_write(
-	struct xfs_inode	*xip,
+STATIC ssize_t
+xfs_file_aio_write(
 	struct kiocb		*iocb,
 	const struct iovec	*iovp,
-	unsigned int		nsegs,
-	loff_t			*offset,
-	int			ioflags)
+	unsigned long		nr_segs,
+	loff_t			pos)
 {
 	struct file		*file = iocb->ki_filp;
 	struct address_space	*mapping = file->f_mapping;
 	struct inode		*inode = mapping->host;
-	unsigned long		segs = nsegs;
-	xfs_mount_t		*mp;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0, error = 0;
+	int			ioflags = 0;
 	xfs_fsize_t		isize, new_size;
 	int			iolock;
 	int			eventsent = 0;
 	size_t			ocount = 0, count;
-	loff_t			pos;
 	int			need_i_mutex;
 
 	XFS_STATS_INC(xs_write_calls);
 
-	error = generic_segment_checks(iovp, &segs, &ocount, VERIFY_READ);
+	BUG_ON(iocb->ki_pos != pos);
+
+	if (unlikely(file->f_flags & O_DIRECT))
+		ioflags |= IO_ISDIRECT;
+	if (file->f_mode & FMODE_NOCMTIME)
+		ioflags |= IO_INVIS;
+
+	error = generic_segment_checks(iovp, &nr_segs, &ocount, VERIFY_READ);
 	if (error)
 		return error;
 
 	count = ocount;
-	pos = *offset;
-
 	if (count == 0)
 		return 0;
 
-	mp = xip->i_mount;
-
 	xfs_wait_for_freeze(mp, SB_FREEZE_WRITE);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -535,30 +550,30 @@ relock:
 		mutex_lock(&inode->i_mutex);
 	}
 
-	xfs_ilock(xip, XFS_ILOCK_EXCL|iolock);
+	xfs_ilock(ip, XFS_ILOCK_EXCL|iolock);
 
 start:
 	error = -generic_write_checks(file, &pos, &count,
 					S_ISBLK(inode->i_mode));
 	if (error) {
-		xfs_iunlock(xip, XFS_ILOCK_EXCL|iolock);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 		goto out_unlock_mutex;
 	}
 
-	if ((DM_EVENT_ENABLED(xip, DM_EVENT_WRITE) &&
+	if ((DM_EVENT_ENABLED(ip, DM_EVENT_WRITE) &&
 	    !(ioflags & IO_INVIS) && !eventsent)) {
 		int		dmflags = FILP_DELAY_FLAG(file);
 
 		if (need_i_mutex)
 			dmflags |= DM_FLAGS_IMUX;
 
-		xfs_iunlock(xip, XFS_ILOCK_EXCL);
-		error = XFS_SEND_DATA(xip->i_mount, DM_EVENT_WRITE, xip,
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		error = XFS_SEND_DATA(ip->i_mount, DM_EVENT_WRITE, ip,
 				      pos, count, dmflags, &iolock);
 		if (error) {
 			goto out_unlock_internal;
 		}
-		xfs_ilock(xip, XFS_ILOCK_EXCL);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		eventsent = 1;
 
 		/*
@@ -568,33 +583,33 @@ start:
 		 * event prevents another call to XFS_SEND_DATA, which is
 		 * what allows the size to change in the first place.
 		 */
-		if ((file->f_flags & O_APPEND) && pos != xip->i_size)
+		if ((file->f_flags & O_APPEND) && pos != ip->i_size)
 			goto start;
 	}
 
 	if (ioflags & IO_ISDIRECT) {
 		xfs_buftarg_t	*target =
-			XFS_IS_REALTIME_INODE(xip) ?
+			XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp;
 
 		if ((pos & target->bt_smask) || (count & target->bt_smask)) {
-			xfs_iunlock(xip, XFS_ILOCK_EXCL|iolock);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 			return XFS_ERROR(-EINVAL);
 		}
 
-		if (!need_i_mutex && (mapping->nrpages || pos > xip->i_size)) {
-			xfs_iunlock(xip, XFS_ILOCK_EXCL|iolock);
+		if (!need_i_mutex && (mapping->nrpages || pos > ip->i_size)) {
+			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 			iolock = XFS_IOLOCK_EXCL;
 			need_i_mutex = 1;
 			mutex_lock(&inode->i_mutex);
-			xfs_ilock(xip, XFS_ILOCK_EXCL|iolock);
+			xfs_ilock(ip, XFS_ILOCK_EXCL|iolock);
 			goto start;
 		}
 	}
 
 	new_size = pos + count;
-	if (new_size > xip->i_size)
-		xip->i_new_size = new_size;
+	if (new_size > ip->i_size)
+		ip->i_new_size = new_size;
 
 	if (likely(!(ioflags & IO_INVIS)))
 		file_update_time(file);
@@ -608,14 +623,14 @@ start:
 	 * to zero it out up to the new size.
 	 */
 
-	if (pos > xip->i_size) {
-		error = xfs_zero_eof(xip, pos, xip->i_size);
+	if (pos > ip->i_size) {
+		error = xfs_zero_eof(ip, pos, ip->i_size);
 		if (error) {
-			xfs_iunlock(xip, XFS_ILOCK_EXCL);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			goto out_unlock_internal;
 		}
 	}
-	xfs_iunlock(xip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	/*
 	 * If we're writing the file then make sure to clear the
@@ -633,7 +648,7 @@ start:
 	if ((ioflags & IO_ISDIRECT)) {
 		if (mapping->nrpages) {
 			WARN_ON(need_i_mutex == 0);
-			error = xfs_flushinval_pages(xip,
+			error = xfs_flushinval_pages(ip,
 					(pos & PAGE_CACHE_MASK),
 					-1, FI_REMAPF_LOCKED);
 			if (error)
@@ -642,16 +657,16 @@ start:
 
 		if (need_i_mutex) {
 			/* demote the lock now the cached pages are gone */
-			xfs_ilock_demote(xip, XFS_IOLOCK_EXCL);
+			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 			mutex_unlock(&inode->i_mutex);
 
 			iolock = XFS_IOLOCK_SHARED;
 			need_i_mutex = 0;
 		}
 
-		trace_xfs_file_direct_write(xip, count, *offset, ioflags);
+		trace_xfs_file_direct_write(ip, count, iocb->ki_pos, ioflags);
 		ret = generic_file_direct_write(iocb, iovp,
-				&segs, pos, offset, count, ocount);
+				&nr_segs, pos, &iocb->ki_pos, count, ocount);
 
 		/*
 		 * direct-io write to a hole: fall through to buffered I/O
@@ -664,7 +679,7 @@ start:
 			count -= ret;
 
 			ioflags &= ~IO_ISDIRECT;
-			xfs_iunlock(xip, iolock);
+			xfs_iunlock(ip, iolock);
 			goto relock;
 		}
 	} else {
@@ -672,15 +687,15 @@ start:
 		ssize_t ret2 = 0;
 
 write_retry:
-		trace_xfs_file_buffered_write(xip, count, *offset, ioflags);
-		ret2 = generic_file_buffered_write(iocb, iovp, segs,
-				pos, offset, count, ret);
+		trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, ioflags);
+		ret2 = generic_file_buffered_write(iocb, iovp, nr_segs,
+				pos, &iocb->ki_pos, count, ret);
 		/*
 		 * if we just got an ENOSPC, flush the inode now we
 		 * aren't holding any page locks and retry *once*
 		 */
 		if (ret2 == -ENOSPC && !enospc) {
-			error = xfs_flush_pages(xip, 0, -1, 0, FI_NONE);
+			error = xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
 			if (error)
 				goto out_unlock_internal;
 			enospc = 1;
@@ -692,27 +707,27 @@ write_retry:
 	current->backing_dev_info = NULL;
 
 	isize = i_size_read(inode);
-	if (unlikely(ret < 0 && ret != -EFAULT && *offset > isize))
-		*offset = isize;
+	if (unlikely(ret < 0 && ret != -EFAULT && iocb->ki_pos > isize))
+		iocb->ki_pos = isize;
 
-	if (*offset > xip->i_size) {
-		xfs_ilock(xip, XFS_ILOCK_EXCL);
-		if (*offset > xip->i_size)
-			xip->i_size = *offset;
-		xfs_iunlock(xip, XFS_ILOCK_EXCL);
+	if (iocb->ki_pos > ip->i_size) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		if (iocb->ki_pos > ip->i_size)
+			ip->i_size = iocb->ki_pos;
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
 	if (ret == -ENOSPC &&
-	    DM_EVENT_ENABLED(xip, DM_EVENT_NOSPACE) && !(ioflags & IO_INVIS)) {
-		xfs_iunlock(xip, iolock);
+	    DM_EVENT_ENABLED(ip, DM_EVENT_NOSPACE) && !(ioflags & IO_INVIS)) {
+		xfs_iunlock(ip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
-		error = XFS_SEND_NAMESP(xip->i_mount, DM_EVENT_NOSPACE, xip,
-				DM_RIGHT_NULL, xip, DM_RIGHT_NULL, NULL, NULL,
+		error = XFS_SEND_NAMESP(ip->i_mount, DM_EVENT_NOSPACE, ip,
+				DM_RIGHT_NULL, ip, DM_RIGHT_NULL, NULL, NULL,
 				0, 0, 0); /* Delay flag intentionally  unused */
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
-		xfs_ilock(xip, iolock);
+		xfs_ilock(ip, iolock);
 		if (error)
 			goto out_unlock_internal;
 		goto start;
@@ -729,7 +744,7 @@ write_retry:
 		loff_t end = pos + ret - 1;
 		int error2;
 
-		xfs_iunlock(xip, iolock);
+		xfs_iunlock(ip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
 
@@ -738,17 +753,17 @@ write_retry:
 			error = error2;
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
-		xfs_ilock(xip, iolock);
+		xfs_ilock(ip, iolock);
 
-		error2 = xfs_fsync(xip);
+		error2 = xfs_fsync(ip);
 		if (!error)
 			error = error2;
 	}
 
  out_unlock_internal:
-	if (xip->i_new_size) {
-		xfs_ilock(xip, XFS_ILOCK_EXCL);
-		xip->i_new_size = 0;
+	if (ip->i_new_size) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		ip->i_new_size = 0;
 		/*
 		 * If this was a direct or synchronous I/O that failed (such
 		 * as ENOSPC) then part of the I/O may have been written to
@@ -756,89 +771,17 @@ write_retry:
 		 * file size may have been adjusted beyond the in-memory file
 		 * size and now needs to be truncated back.
 		 */
-		if (xip->i_d.di_size > xip->i_size)
-			xip->i_d.di_size = xip->i_size;
-		xfs_iunlock(xip, XFS_ILOCK_EXCL);
+		if (ip->i_d.di_size > ip->i_size)
+			ip->i_d.di_size = ip->i_size;
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
-	xfs_iunlock(xip, iolock);
+	xfs_iunlock(ip, iolock);
  out_unlock_mutex:
 	if (need_i_mutex)
 		mutex_unlock(&inode->i_mutex);
 	return -error;
 }
 
-STATIC ssize_t
-xfs_file_aio_read(
-	struct kiocb		*iocb,
-	const struct iovec	*iov,
-	unsigned long		nr_segs,
-	loff_t			pos)
-{
-	struct file		*file = iocb->ki_filp;
-	int			ioflags = 0;
-
-	BUG_ON(iocb->ki_pos != pos);
-	if (unlikely(file->f_flags & O_DIRECT))
-		ioflags |= IO_ISDIRECT;
-	if (file->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
-	return xfs_read(XFS_I(file->f_path.dentry->d_inode), iocb, iov,
-				nr_segs, &iocb->ki_pos, ioflags);
-}
-
-STATIC ssize_t
-xfs_file_aio_write(
-	struct kiocb		*iocb,
-	const struct iovec	*iov,
-	unsigned long		nr_segs,
-	loff_t			pos)
-{
-	struct file		*file = iocb->ki_filp;
-	int			ioflags = 0;
-
-	BUG_ON(iocb->ki_pos != pos);
-	if (unlikely(file->f_flags & O_DIRECT))
-		ioflags |= IO_ISDIRECT;
-	if (file->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
-	return xfs_write(XFS_I(file->f_mapping->host), iocb, iov, nr_segs,
-				&iocb->ki_pos, ioflags);
-}
-
-STATIC ssize_t
-xfs_file_splice_read(
-	struct file		*infilp,
-	loff_t			*ppos,
-	struct pipe_inode_info	*pipe,
-	size_t			len,
-	unsigned int		flags)
-{
-	int			ioflags = 0;
-
-	if (infilp->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
-
-	return xfs_splice_read(XFS_I(infilp->f_path.dentry->d_inode),
-				   infilp, ppos, pipe, len, flags, ioflags);
-}
-
-STATIC ssize_t
-xfs_file_splice_write(
-	struct pipe_inode_info	*pipe,
-	struct file		*outfilp,
-	loff_t			*ppos,
-	size_t			len,
-	unsigned int		flags)
-{
-	int			ioflags = 0;
-
-	if (outfilp->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
-
-	return xfs_splice_write(XFS_I(outfilp->f_path.dentry->d_inode),
-				    pipe, outfilp, ppos, len, flags, ioflags);
-}
-
 STATIC int
 xfs_file_open(
 	struct inode	*inode,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
