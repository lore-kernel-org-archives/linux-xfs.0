Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0HKEEbZ174873 for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 14:14:14 -0600
Date: Tue, 17 Jan 2012 14:14:13 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 09/11] xfs: remove the i_new_size field in struct xfs_inode
Message-ID: <20120117201413.GF16581@sgi.com>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200132.299481659@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218200132.299481659@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hey,

On Sun, Dec 18, 2011 at 03:00:12PM -0500, Christoph Hellwig wrote:
> Now that we use the VFS i_size field throughout XFS there is no need for the
> i_new_size field any more given that the VFS i_size field gets updated
> in ->write_end before unlocking the page, and thus is a) always uptodate when
							^^ there's no b), so
							i've removed this.
> writeback could see a page.

> Removing i_new_size also has the advantage that
> we will never have to trim back di_size during a failed buffered write,
> given that it never gets updated past i_size.

Not trimming di_size back is very nice.  That was ugly.

> Note that currently the generic direct I/O code only updates i_size after
> calling our end_io handler, which requires a small workaround to make
> sure di_size actually makes it to disk.  I hope to fix this properly in
> the generic code.

Yeah, it looks like not doing this workaround might cause xfs not to
update the di_size properly.  And if it's ok for
generic_file_direct_write to update isize after calling ->direct_IO, it
looks like it should be for it to be done out of dio_complete.  This
workaround looks fine.

> A downside is that we lose the support for parallel non-overlapping O_DIRECT
> appending writes that recently was added.  I don't think keeping the complex
> and fragile i_new_size infrastructure for this is a good tradeoff - if we
> really care about parallel appending writers we should investigate turning
> the iolock into a range lock, which would also allow for parallel
> non-overlapping buffered writers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I asked around and spent a little time trying to track down where
i_new_size came from.  It had been in xfs for some time even before the
initial import of from cvs into the history.git tree on kernel.org.
Before that it was merged into xfs as part of the iocore with some other
CXFS infrastructure.  From there the trail went cold.  So it looks like
it's historical and even today doesn't appear to have value for XFS.

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
>  fs/xfs/xfs_aops.c  |   28 +++++++++++---------
>  fs/xfs/xfs_file.c  |   72 +++++++----------------------------------------------
>  fs/xfs/xfs_iget.c  |    1 
>  fs/xfs/xfs_inode.h |    2 -
>  fs/xfs/xfs_trace.h |   18 ++-----------
>  5 files changed, 29 insertions(+), 92 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_file.c	2011-11-30 12:59:11.669698558 +0100
> +++ xfs/fs/xfs/xfs_file.c	2011-11-30 12:59:13.533021797 +0100
> @@ -413,27 +413,6 @@ xfs_file_splice_read(
>  }
>  
>  /*
> - * If this was a direct or synchronous I/O that failed (such as ENOSPC) then
> - * part of the I/O may have been written to disk before the error occurred.  In
> - * this case the on-disk file size may have been adjusted beyond the in-memory
> - * file size and now needs to be truncated back.
> - */
> -STATIC void
> -xfs_aio_write_newsize_update(
> -	struct xfs_inode	*ip,
> -	xfs_fsize_t		new_size)
> -{
> -	if (new_size == ip->i_new_size) {
> -		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
> -		if (new_size == ip->i_new_size)
> -			ip->i_new_size = 0;
> -		if (ip->i_d.di_size > i_size_read(VFS_I(ip)))
> -			ip->i_d.di_size = i_size_read(VFS_I(ip));
> -		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
> -	}
> -}
> -
> -/*
>   * xfs_file_splice_write() does not use xfs_rw_ilock() because
>   * generic_file_splice_write() takes the i_mutex itself. This, in theory,
>   * couuld cause lock inversions between the aio_write path and the splice path
> @@ -451,7 +430,6 @@ xfs_file_splice_write(
>  {
>  	struct inode		*inode = outfilp->f_mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
> -	xfs_fsize_t		new_size;
>  	int			ioflags = 0;
>  	ssize_t			ret;
>  
> @@ -465,20 +443,12 @@ xfs_file_splice_write(
>  
>  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
>  
> -	new_size = *ppos + count;
> -
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if (new_size > i_size_read(inode))
> -		ip->i_new_size = new_size;
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -
>  	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
>  
>  	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
>  	if (ret > 0)
>  		XFS_STATS_ADD(xs_write_bytes, ret);
>  
> -	xfs_aio_write_newsize_update(ip, new_size);
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  	return ret;
>  }
> @@ -673,16 +643,13 @@ xfs_file_aio_write_checks(
>  	struct file		*file,
>  	loff_t			*pos,
>  	size_t			*count,
> -	xfs_fsize_t		*new_sizep,
>  	int			*iolock)
>  {
>  	struct inode		*inode = file->f_mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
> -	xfs_fsize_t		new_size;
>  	int			error = 0;
>  
>  	xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
> -	*new_sizep = 0;
>  restart:
>  	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
>  	if (error) {
> @@ -697,15 +664,13 @@ restart:
>  	/*
>  	 * If the offset is beyond the size of the file, we need to zero any
>  	 * blocks that fall between the existing EOF and the start of this
> -	 * write. There is no need to issue zeroing if another in-flght IO ends
> -	 * at or before this one If zeronig is needed and we are currently
> -	 * holding the iolock shared, we need to update it to exclusive which
> -	 * involves dropping all locks and relocking to maintain correct locking
> -	 * order. If we do this, restart the function to ensure all checks and
> -	 * values are still valid.
> +	 * write.  If zeroing is needed and we are currently holding the
> +	 * iolock shared, we need to update it to exclusive which involves
> +	 * dropping all locks and relocking to maintain correct locking order.
> +	 * If we do this, restart the function to ensure all checks and values
> +	 * are still valid.
>  	 */
> -	if ((ip->i_new_size && *pos > ip->i_new_size) ||
> -	    (!ip->i_new_size && *pos > i_size_read(inode))) {
> +	if (*pos > i_size_read(inode)) {
>  		if (*iolock == XFS_IOLOCK_SHARED) {
>  			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
>  			*iolock = XFS_IOLOCK_EXCL;
> @@ -714,19 +679,6 @@ restart:
>  		}
>  		error = -xfs_zero_eof(ip, *pos, i_size_read(inode));
>  	}
> -
> -	/*
> -	 * If this IO extends beyond EOF, we may need to update ip->i_new_size.
> -	 * We have already zeroed space beyond EOF (if necessary).  Only update
> -	 * ip->i_new_size if this IO ends beyond any other in-flight writes.
> -	 */
> -	new_size = *pos + *count;
> -	if (new_size > i_size_read(inode)) {
> -		if (new_size > ip->i_new_size)
> -			ip->i_new_size = new_size;
> -		*new_sizep = new_size;
> -	}
> -
>  	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
>  	if (error)
>  		return error;
> @@ -772,7 +724,6 @@ xfs_file_dio_aio_write(
>  	unsigned long		nr_segs,
>  	loff_t			pos,
>  	size_t			ocount,
> -	xfs_fsize_t		*new_size,
>  	int			*iolock)
>  {
>  	struct file		*file = iocb->ki_filp;
> @@ -817,7 +768,7 @@ xfs_file_dio_aio_write(
>  		xfs_rw_ilock(ip, *iolock);
>  	}
>  
> -	ret = xfs_file_aio_write_checks(file, &pos, &count, new_size, iolock);
> +	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
>  	if (ret)
>  		return ret;
>  
> @@ -855,7 +806,6 @@ xfs_file_buffered_aio_write(
>  	unsigned long		nr_segs,
>  	loff_t			pos,
>  	size_t			ocount,
> -	xfs_fsize_t		*new_size,
>  	int			*iolock)
>  {
>  	struct file		*file = iocb->ki_filp;
> @@ -869,7 +819,7 @@ xfs_file_buffered_aio_write(
>  	*iolock = XFS_IOLOCK_EXCL;
>  	xfs_rw_ilock(ip, *iolock);
>  
> -	ret = xfs_file_aio_write_checks(file, &pos, &count, new_size, iolock);
> +	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
>  	if (ret)
>  		return ret;
>  
> @@ -909,7 +859,6 @@ xfs_file_aio_write(
>  	ssize_t			ret;
>  	int			iolock;
>  	size_t			ocount = 0;
> -	xfs_fsize_t		new_size = 0;
>  
>  	XFS_STATS_INC(xs_write_calls);
>  
> @@ -929,10 +878,10 @@ xfs_file_aio_write(
>  
>  	if (unlikely(file->f_flags & O_DIRECT))
>  		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos,
> -						ocount, &new_size, &iolock);
> +						ocount, &iolock);
>  	else
>  		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
> -						ocount, &new_size, &iolock);
> +						ocount, &iolock);
>  
>  	if (ret <= 0)
>  		goto out_unlock;
> @@ -953,7 +902,6 @@ xfs_file_aio_write(
>  	}
>  
>  out_unlock:
> -	xfs_aio_write_newsize_update(ip, new_size);
>  	xfs_rw_iunlock(ip, iolock);
>  	return ret;
>  }
> Index: xfs/fs/xfs/xfs_aops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_aops.c	2011-11-30 12:59:11.669698558 +0100
> +++ xfs/fs/xfs/xfs_aops.c	2011-12-01 08:12:10.946664057 +0100
> @@ -111,8 +111,7 @@ xfs_ioend_new_eof(
>  	xfs_fsize_t		bsize;
>  
>  	bsize = ioend->io_offset + ioend->io_size;
> -	isize = MAX(i_size_read(VFS_I(ip)), ip->i_new_size);
> -	isize = MIN(isize, bsize);
> +	isize = MIN(i_size_read(VFS_I(ip)), bsize);
>  	return isize > ip->i_d.di_size ? isize : 0;
>  }
>  
> @@ -126,11 +125,7 @@ static inline bool xfs_ioend_is_append(s
>  }
>  
>  /*
> - * Update on-disk file size now that data has been written to disk.  The
> - * current in-memory file size is i_size.  If a write is beyond eof i_new_size
> - * will be the intended file size until i_size is updated.  If this write does
> - * not extend all the way to the valid file size then restrict this update to
> - * the end of the write.
> + * Update on-disk file size now that data has been written to disk.
>   *
>   * This function does not block as blocking on the inode lock in IO completion
>   * can lead to IO completion order dependency deadlocks.. If it can't get the
> @@ -1279,6 +1274,15 @@ xfs_end_io_direct_write(
>  	struct xfs_ioend	*ioend = iocb->private;
>  
>  	/*
> +	 * While the generic direct I/O code updates the inode size, it does
> +	 * so only after the end_io handler is called, which means our
> +	 * end_io handler thinks the on-disk size is outside the in-core
> +	 * size.  To prevent this just update it a little bit earlier here.
> +	 */
> +	if (offset + size > i_size_read(ioend->io_inode))
> +		i_size_write(ioend->io_inode, offset + size);
> +
> +	/*
>  	 * blockdev_direct_IO can return an error even after the I/O
>  	 * completion handler was called.  Thus we need to protect
>  	 * against double-freeing.
> @@ -1340,12 +1344,10 @@ xfs_vm_write_failed(
>  
>  	if (to > inode->i_size) {
>  		/*
> -		 * punch out the delalloc blocks we have already allocated. We
> -		 * don't call xfs_setattr() to do this as we may be in the
> -		 * middle of a multi-iovec write and so the vfs inode->i_size
> -		 * will not match the xfs ip->i_size and so it will zero too
> -		 * much. Hence we jus truncate the page cache to zero what is
> -		 * necessary and punch the delalloc blocks directly.
> +		 * Punch out the delalloc blocks we have already allocated.
> +		 *
> +		 * Don't bother with xfs_setattr given that nothing can have
> +		 * it do disk yet as the page is still locked at this point.
	      made    to

updated this 

>  		 */
>  		struct xfs_inode	*ip = XFS_I(inode);
>  		xfs_fileoff_t		start_fsb;
> Index: xfs/fs/xfs/xfs_iget.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iget.c	2011-11-30 12:59:11.676365190 +0100
> +++ xfs/fs/xfs/xfs_iget.c	2011-11-30 12:59:13.533021797 +0100
> @@ -94,7 +94,6 @@ xfs_inode_alloc(
>  	ip->i_update_core = 0;
>  	ip->i_delayed_blks = 0;
>  	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
> -	ip->i_new_size = 0;
>  
>  	return ip;
>  }
> Index: xfs/fs/xfs/xfs_trace.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_trace.h	2011-11-30 12:59:11.673031874 +0100
> +++ xfs/fs/xfs/xfs_trace.h	2011-11-30 12:59:13.536355113 +0100
> @@ -891,7 +891,6 @@ DECLARE_EVENT_CLASS(xfs_file_class,
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
>  		__field(xfs_fsize_t, size)
> -		__field(xfs_fsize_t, new_size)
>  		__field(loff_t, offset)
>  		__field(size_t, count)
>  		__field(int, flags)
> @@ -900,17 +899,15 @@ DECLARE_EVENT_CLASS(xfs_file_class,
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
>  		__entry->size = ip->i_d.di_size;
> -		__entry->new_size = ip->i_new_size;
>  		__entry->offset = offset;
>  		__entry->count = count;
>  		__entry->flags = flags;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
> +	TP_printk("dev %d:%d ino 0x%llx size 0x%llx "
>  		  "offset 0x%llx count 0x%zx ioflags %s",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
> -		  __entry->new_size,
>  		  __entry->offset,
>  		  __entry->count,
>  		  __print_flags(__entry->flags, "|", XFS_IO_FLAGS))
> @@ -978,7 +975,6 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
>  		__field(loff_t, size)
> -		__field(loff_t, new_size)
>  		__field(loff_t, offset)
>  		__field(size_t, count)
>  		__field(int, type)
> @@ -990,7 +986,6 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
>  		__entry->size = ip->i_d.di_size;
> -		__entry->new_size = ip->i_new_size;
>  		__entry->offset = offset;
>  		__entry->count = count;
>  		__entry->type = type;
> @@ -998,13 +993,11 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
>  		__entry->startblock = irec ? irec->br_startblock : 0;
>  		__entry->blockcount = irec ? irec->br_blockcount : 0;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx "
> -		  "offset 0x%llx count %zd type %s "
> -		  "startoff 0x%llx startblock %lld blockcount 0x%llx",
> +	TP_printk("dev %d:%d ino 0x%llx size 0x%llx offset 0x%llx count %zd "
> +		  "type %s startoff 0x%llx startblock %lld blockcount 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
> -		  __entry->new_size,
>  		  __entry->offset,
>  		  __entry->count,
>  		  __print_symbolic(__entry->type, XFS_IO_TYPES),
> @@ -1031,7 +1024,6 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
>  		__field(xfs_ino_t, ino)
>  		__field(loff_t, isize)
>  		__field(loff_t, disize)
> -		__field(loff_t, new_size)
>  		__field(loff_t, offset)
>  		__field(size_t, count)
>  	),
> @@ -1040,17 +1032,15 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
>  		__entry->ino = ip->i_ino;
>  		__entry->isize = VFS_I(ip)->i_size;
>  		__entry->disize = ip->i_d.di_size;
> -		__entry->new_size = ip->i_new_size;
>  		__entry->offset = offset;
>  		__entry->count = count;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx disize 0x%llx new_size 0x%llx "
> +	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx disize 0x%llx "
>  		  "offset 0x%llx count %zd",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->isize,
>  		  __entry->disize,
> -		  __entry->new_size,
>  		  __entry->offset,
>  		  __entry->count)
>  );
> Index: xfs/fs/xfs/xfs_inode.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.h	2011-11-30 12:59:11.679698505 +0100
> +++ xfs/fs/xfs/xfs_inode.h	2011-12-01 08:12:10.839997391 +0100
> @@ -246,8 +246,6 @@ typedef struct xfs_inode {
>  
>  	xfs_icdinode_t		i_d;		/* most of ondisk inode */
>  
> -	xfs_fsize_t		i_new_size;	/* size when write completes */
> -
>  	/* VFS inode */
>  	struct inode		i_vnode;	/* embedded VFS inode */
>  } xfs_inode_t;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
