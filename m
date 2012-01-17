Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0HKgMKC175830 for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 14:42:22 -0600
Date: Tue, 17 Jan 2012 14:42:23 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 11/11] xfs: cleanup xfs_file_aio_write
Message-ID: <20120117204223.GH16581@sgi.com>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200132.680867265@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218200132.680867265@bombadil.infradead.org>
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

On Sun, Dec 18, 2011 at 03:00:14PM -0500, Christoph Hellwig wrote:
> With all the size field updates out of the way xfs_file_aio_write can
> be further simplified by pushing all iolock handling into
> xfs_file_dio_aio_write and xfs_file_buffered_aio_write and using
> the generic generic_write_sync helper for synchronous writes.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good!
Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
>  fs/xfs/xfs_file.c |   82 ++++++++++++++++++++++++------------------------------
>  1 file changed, 37 insertions(+), 45 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_file.c	2011-12-07 12:48:33.309903801 +0100
> +++ xfs/fs/xfs/xfs_file.c	2011-12-07 12:48:48.546487926 +0100
> @@ -724,8 +724,7 @@ xfs_file_dio_aio_write(
>  	const struct iovec	*iovp,
>  	unsigned long		nr_segs,
>  	loff_t			pos,
> -	size_t			ocount,
> -	int			*iolock)
> +	size_t			ocount)
>  {
>  	struct file		*file = iocb->ki_filp;
>  	struct address_space	*mapping = file->f_mapping;
> @@ -735,10 +734,10 @@ xfs_file_dio_aio_write(
>  	ssize_t			ret = 0;
>  	size_t			count = ocount;
>  	int			unaligned_io = 0;
> +	int			iolock;
>  	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
>  					mp->m_rtdev_targp : mp->m_ddev_targp;
>  
> -	*iolock = 0;
>  	if ((pos & target->bt_smask) || (count & target->bt_smask))
>  		return -XFS_ERROR(EINVAL);
>  
> @@ -753,31 +752,31 @@ xfs_file_dio_aio_write(
>  	 * EOF zeroing cases and fill out the new inode size as appropriate.
>  	 */
>  	if (unaligned_io || mapping->nrpages)
> -		*iolock = XFS_IOLOCK_EXCL;
> +		iolock = XFS_IOLOCK_EXCL;
>  	else
> -		*iolock = XFS_IOLOCK_SHARED;
> -	xfs_rw_ilock(ip, *iolock);
> +		iolock = XFS_IOLOCK_SHARED;
> +	xfs_rw_ilock(ip, iolock);
>  
>  	/*
>  	 * Recheck if there are cached pages that need invalidate after we got
>  	 * the iolock to protect against other threads adding new pages while
>  	 * we were waiting for the iolock.
>  	 */
> -	if (mapping->nrpages && *iolock == XFS_IOLOCK_SHARED) {
> -		xfs_rw_iunlock(ip, *iolock);
> -		*iolock = XFS_IOLOCK_EXCL;
> -		xfs_rw_ilock(ip, *iolock);
> +	if (mapping->nrpages && iolock == XFS_IOLOCK_SHARED) {
> +		xfs_rw_iunlock(ip, iolock);
> +		iolock = XFS_IOLOCK_EXCL;
> +		xfs_rw_ilock(ip, iolock);
>  	}
>  
> -	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
> +	ret = xfs_file_aio_write_checks(file, &pos, &count, &iolock);
>  	if (ret)
> -		return ret;
> +		goto out;
>  
>  	if (mapping->nrpages) {
>  		ret = -xfs_flushinval_pages(ip, (pos & PAGE_CACHE_MASK), -1,
>  							FI_REMAPF_LOCKED);
>  		if (ret)
> -			return ret;
> +			goto out;
>  	}
>  
>  	/*
> @@ -786,15 +785,18 @@ xfs_file_dio_aio_write(
>  	 */
>  	if (unaligned_io)
>  		inode_dio_wait(inode);
> -	else if (*iolock == XFS_IOLOCK_EXCL) {
> +	else if (iolock == XFS_IOLOCK_EXCL) {
>  		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
> -		*iolock = XFS_IOLOCK_SHARED;
> +		iolock = XFS_IOLOCK_SHARED;
>  	}
>  
>  	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
>  	ret = generic_file_direct_write(iocb, iovp,
>  			&nr_segs, pos, &iocb->ki_pos, count, ocount);
>  
> +out:
> +	xfs_rw_iunlock(ip, iolock);
> +
>  	/* No fallback to buffered IO on errors for XFS. */
>  	ASSERT(ret < 0 || ret == count);
>  	return ret;
> @@ -806,8 +808,7 @@ xfs_file_buffered_aio_write(
>  	const struct iovec	*iovp,
>  	unsigned long		nr_segs,
>  	loff_t			pos,
> -	size_t			ocount,
> -	int			*iolock)
> +	size_t			ocount)
>  {
>  	struct file		*file = iocb->ki_filp;
>  	struct address_space	*mapping = file->f_mapping;
> @@ -815,14 +816,14 @@ xfs_file_buffered_aio_write(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	ssize_t			ret;
>  	int			enospc = 0;
> +	int			iolock = XFS_IOLOCK_EXCL;
>  	size_t			count = ocount;
>  
> -	*iolock = XFS_IOLOCK_EXCL;
> -	xfs_rw_ilock(ip, *iolock);
> +	xfs_rw_ilock(ip, iolock);
>  
> -	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
> +	ret = xfs_file_aio_write_checks(file, &pos, &count, &iolock);
>  	if (ret)
> -		return ret;
> +		goto out;
>  
>  	/* We can write back this queue in page reclaim */
>  	current->backing_dev_info = mapping->backing_dev_info;
> @@ -836,13 +837,15 @@ write_retry:
>  	 * page locks and retry *once*
>  	 */
>  	if (ret == -ENOSPC && !enospc) {
> -		ret = -xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
> -		if (ret)
> -			return ret;
>  		enospc = 1;
> -		goto write_retry;
> +		ret = -xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
> +		if (!ret)
> +			goto write_retry;
>  	}
> +
>  	current->backing_dev_info = NULL;
> +out:
> +	xfs_rw_iunlock(ip, iolock);
>  	return ret;
>  }
>  
> @@ -858,7 +861,6 @@ xfs_file_aio_write(
>  	struct inode		*inode = mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	ssize_t			ret;
> -	int			iolock;
>  	size_t			ocount = 0;
>  
>  	XFS_STATS_INC(xs_write_calls);
> @@ -878,32 +880,22 @@ xfs_file_aio_write(
>  		return -EIO;
>  
>  	if (unlikely(file->f_flags & O_DIRECT))
> -		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos,
> -						ocount, &iolock);
> +		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos, ocount);
>  	else
>  		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
> -						ocount, &iolock);
> +						  ocount);
>  
> -	if (ret <= 0)
> -		goto out_unlock;
> +	if (ret > 0) {
> +		ssize_t err;
>  
> -	XFS_STATS_ADD(xs_write_bytes, ret);
> +		XFS_STATS_ADD(xs_write_bytes, ret);
>  
> -	/* Handle various SYNC-type writes */
> -	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
> -		loff_t end = pos + ret - 1;
> -		int error;
> -
> -		xfs_rw_iunlock(ip, iolock);
> -		error = xfs_file_fsync(file, pos, end,
> -				      (file->f_flags & __O_SYNC) ? 0 : 1);
> -		xfs_rw_ilock(ip, iolock);
> -		if (error)
> -			ret = error;
> +		/* Handle various SYNC-type writes */
> +		err = generic_write_sync(file, pos, ret);
> +		if (err < 0)
> +			ret = err;
>  	}
>  
> -out_unlock:
> -	xfs_rw_iunlock(ip, iolock);
>  	return ret;
>  }
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
