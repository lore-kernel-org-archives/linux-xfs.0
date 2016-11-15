Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965687AbcKOPeV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Nov 2016 10:34:21 -0500
Date: Tue, 15 Nov 2016 10:34:19 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: use iomap_dio_rw
Message-ID: <20161115153418.GB65218@bfoster.bfoster>
References: <1479064054-10474-1-git-send-email-hch@lst.de>
 <1479064054-10474-6-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479064054-10474-6-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sun, Nov 13, 2016 at 08:07:34PM +0100, Christoph Hellwig wrote:
> Straight switch over to using iomap for direct I/O - we already have the
> non-COW dio path in write_begin for DAX and files with extent size hints,
> so nothing to add there.  The COW path is ported over from the old
> get_blocks version and a bit of a mess, but I have some work in progress
> to make it look more like the buffered I/O COW path.
> 
> This gets rid of xfs_get_blocks_direct and the last caller of
> xfs_get_blocks with the create flag set, so all that code can be removed.
> 
> Last but not least I've removed a comment in xfs_filemap_fault that
> refers to xfs_get_blocks entirely instead of updating it - while the
> reference is correct, the whole DAX fault path looks different than
> the non-DAX one, so it seems rather pointless.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap.c         |   2 +-
>  fs/xfs/xfs_aops.c  | 291 ++---------------------------------------------------
>  fs/xfs/xfs_aops.h  |   6 --
>  fs/xfs/xfs_file.c  | 149 +++++++++++----------------
>  fs/xfs/xfs_iomap.c |  53 ++++++++--
>  5 files changed, 114 insertions(+), 387 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index d054b73..f5effa6 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -210,62 +210,21 @@ xfs_file_dio_aio_read(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*to)
>  {
> -	struct address_space	*mapping = iocb->ki_filp->f_mapping;
> -	struct inode		*inode = mapping->host;
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	loff_t			isize = i_size_read(inode);
> +	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
>  	size_t			count = iov_iter_count(to);
> -	loff_t			end = iocb->ki_pos + count - 1;
> -	struct iov_iter		data;
> -	struct xfs_buftarg	*target;
> -	ssize_t			ret = 0;
> +	ssize_t			ret;
>  
>  	trace_xfs_file_direct_read(ip, count, iocb->ki_pos);
>  
>  	if (!count)
>  		return 0; /* skip atime */
>  
> -	if (XFS_IS_REALTIME_INODE(ip))
> -		target = ip->i_mount->m_rtdev_targp;
> -	else
> -		target = ip->i_mount->m_ddev_targp;
> -
> -	/* DIO must be aligned to device logical sector size */
> -	if ((iocb->ki_pos | count) & target->bt_logical_sectormask) {
> -		if (iocb->ki_pos == isize)
> -			return 0;
> -		return -EINVAL;
> -	}

Do we not still need this, or is it checked elsewhere?

The rest looks sane to me, but I need to test and I haven't grabbed your
tree yet..

Brian

> -
>  	file_accessed(iocb->ki_filp);
>  
>  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> -	if (mapping->nrpages) {
> -		ret = filemap_write_and_wait_range(mapping, iocb->ki_pos, end);
> -		if (ret)
> -			goto out_unlock;
> -
> -		/*
> -		 * Invalidate whole pages. This can return an error if we fail
> -		 * to invalidate a page, but this should never happen on XFS.
> -		 * Warn if it does fail.
> -		 */
> -		ret = invalidate_inode_pages2_range(mapping,
> -				iocb->ki_pos >> PAGE_SHIFT, end >> PAGE_SHIFT);
> -		WARN_ON_ONCE(ret);
> -		ret = 0;
> -	}
> -
> -	data = *to;
> -	ret = __blockdev_direct_IO(iocb, inode, target->bt_bdev, &data,
> -			xfs_get_blocks_direct, NULL, NULL, 0);
> -	if (ret >= 0) {
> -		iocb->ki_pos += ret;
> -		iov_iter_advance(to, ret);
> -	}
> -
> -out_unlock:
> +	ret = iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> +
>  	return ret;
>  }
>  
> @@ -465,6 +424,58 @@ xfs_file_aio_write_checks(
>  	return 0;
>  }
>  
> +static int
> +xfs_dio_write_end_io(
> +	struct kiocb		*iocb,
> +	ssize_t			size,
> +	unsigned		flags)
> +{
> +	struct inode		*inode = file_inode(iocb->ki_filp);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	loff_t			offset = iocb->ki_pos;
> +	bool			update_size = false;
> +	int			error = 0;
> +
> +	trace_xfs_end_io_direct_write(ip, offset, size);
> +
> +	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> +		return -EIO;
> +
> +	if (size <= 0)
> +		return size;
> +
> +	/*
> +	 * We need to update the in-core inode size here so that we don't end up
> +	 * with the on-disk inode size being outside the in-core inode size. We
> +	 * have no other method of updating EOF for AIO, so always do it here
> +	 * if necessary.
> +	 *
> +	 * We need to lock the test/set EOF update as we can be racing with
> +	 * other IO completions here to update the EOF. Failing to serialise
> +	 * here can result in EOF moving backwards and Bad Things Happen when
> +	 * that occurs.
> +	 */
> +	spin_lock(&ip->i_flags_lock);
> +	if (offset + size > i_size_read(inode)) {
> +		i_size_write(inode, offset + size);
> +		update_size = true;
> +	}
> +	spin_unlock(&ip->i_flags_lock);
> +
> +	if (flags & IOMAP_DIO_COW) {
> +		error = xfs_reflink_end_cow(ip, offset, size);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (flags & IOMAP_DIO_UNWRITTEN)
> +		error = xfs_iomap_write_unwritten(ip, offset, size);
> +	else if (update_size)
> +		error = xfs_setfilesize(ip, offset, size);
> +
> +	return error;
> +}
> +
>  /*
>   * xfs_file_dio_aio_write - handle direct IO writes
>   *
> @@ -504,9 +515,7 @@ xfs_file_dio_aio_write(
>  	int			unaligned_io = 0;
>  	int			iolock;
>  	size_t			count = iov_iter_count(from);
> -	loff_t			end;
> -	struct iov_iter		data;
> -	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
> +	struct xfs_buftarg      *target = XFS_IS_REALTIME_INODE(ip) ?
>  					mp->m_rtdev_targp : mp->m_ddev_targp;
>  
>  	/* DIO must be aligned to device logical sector size */
> @@ -534,23 +543,6 @@ xfs_file_dio_aio_write(
>  	if (ret)
>  		goto out;
>  	count = iov_iter_count(from);
> -	end = iocb->ki_pos + count - 1;
> -
> -	if (mapping->nrpages) {
> -		ret = filemap_write_and_wait_range(mapping, iocb->ki_pos, end);
> -		if (ret)
> -			goto out;
> -
> -		/*
> -		 * Invalidate whole pages. This can return an error if we fail
> -		 * to invalidate a page, but this should never happen on XFS.
> -		 * Warn if it does fail.
> -		 */
> -		ret = invalidate_inode_pages2_range(mapping,
> -				iocb->ki_pos >> PAGE_SHIFT, end >> PAGE_SHIFT);
> -		WARN_ON_ONCE(ret);
> -		ret = 0;
> -	}
>  
>  	/*
>  	 * If we are doing unaligned IO, wait for all other IO to drain,
> @@ -573,22 +565,7 @@ xfs_file_dio_aio_write(
>  			goto out;
>  	}
>  
> -	data = *from;
> -	ret = __blockdev_direct_IO(iocb, inode, target->bt_bdev, &data,
> -			xfs_get_blocks_direct, xfs_end_io_direct_write,
> -			NULL, DIO_ASYNC_EXTEND);
> -
> -	/* see generic_file_direct_write() for why this is necessary */
> -	if (mapping->nrpages) {
> -		invalidate_inode_pages2_range(mapping,
> -					      iocb->ki_pos >> PAGE_SHIFT,
> -					      end >> PAGE_SHIFT);
> -	}
> -
> -	if (ret > 0) {
> -		iocb->ki_pos += ret;
> -		iov_iter_advance(from, ret);
> -	}
> +	ret = iomap_dio_rw(iocb, from, &xfs_iomap_ops, xfs_dio_write_end_io);
>  out:
>  	xfs_iunlock(ip, iolock);
>  
> @@ -1468,15 +1445,9 @@ xfs_filemap_fault(
>  		return xfs_filemap_page_mkwrite(vma, vmf);
>  
>  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -	if (IS_DAX(inode)) {
> -		/*
> -		 * we do not want to trigger unwritten extent conversion on read
> -		 * faults - that is unnecessary overhead and would also require
> -		 * changes to xfs_get_blocks_direct() to map unwritten extent
> -		 * ioend for conversion on read-only mappings.
> -		 */
> +	if (IS_DAX(inode))
>  		ret = dax_iomap_fault(vma, vmf, &xfs_iomap_ops);
> -	} else
> +	else
>  		ret = filemap_fault(vma, vmf);
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 436e109..9444170 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -960,6 +960,19 @@ static inline bool imap_needs_alloc(struct inode *inode,
>  		(IS_DAX(inode) && ISUNWRITTEN(imap));
>  }
>  
> +static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
> +{
> +	/*
> +	 * COW writes will allocate delalloc space, so we need to make sure
> +	 * to take the lock exclusively here.
> +	 */
> +	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO)))
> +		return true;
> +	if ((flags & IOMAP_DIRECT) && (flags & IOMAP_WRITE))
> +		return true;
> +	return false;
> +}
> +
>  static int
>  xfs_file_iomap_begin(
>  	struct inode		*inode,
> @@ -979,18 +992,14 @@ xfs_file_iomap_begin(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	if ((flags & IOMAP_WRITE) && !IS_DAX(inode) &&
> -		   !xfs_get_extsz_hint(ip)) {
> +	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
> +			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
>  		/* Reserve delalloc blocks for regular writeback. */
>  		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
>  				iomap);
>  	}
>  
> -	/*
> -	 * COW writes will allocate delalloc space, so we need to make sure
> -	 * to take the lock exclusively here.
> -	 */
> -	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
> +	if (need_excl_ilock(ip, flags)) {
>  		lockmode = XFS_ILOCK_EXCL;
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	} else {
> @@ -1003,17 +1012,44 @@ xfs_file_iomap_begin(
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	end_fsb = XFS_B_TO_FSB(mp, offset + length);
>  
> +	if (xfs_is_reflink_inode(ip) &&
> +	    (flags & IOMAP_WRITE) && (flags & IOMAP_DIRECT)) {
> +		bool need_alloc = false;
> +
> +		shared = xfs_reflink_find_cow_mapping(ip, offset, &imap,
> +					&need_alloc);
> +		if (shared) {
> +			xfs_iunlock(ip, lockmode);
> +			goto alloc_done;
> +		}
> +		ASSERT(!need_alloc);
> +	}
> +
>  	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
>  			       &nimaps, 0);
>  	if (error)
>  		goto out_unlock;
>  
> -	if (flags & IOMAP_REPORT) {
> +	if ((flags & IOMAP_REPORT) ||
> +	    (xfs_is_reflink_inode(ip) &&
> +	     (flags & IOMAP_WRITE) && (flags & IOMAP_DIRECT))) {
>  		/* Trim the mapping to the nearest shared extent boundary. */
>  		error = xfs_reflink_trim_around_shared(ip, &imap, &shared,
>  				&trimmed);
>  		if (error)
>  			goto out_unlock;
> +
> +		/*
> +		 * We're here because we're trying to do a directio write to a
> +		 * region that isn't aligned to a filesystem block.  If the
> +		 * extent is shared, fall back to buffered mode to handle the
> +		 * RMW.
> +		 */
> +		if (!(flags & IOMAP_REPORT) && shared) {
> +			trace_xfs_reflink_bounce_dio_write(ip, &imap);
> +			error = -EREMCHG;
> +			goto out_unlock;
> +		}
>  	}
>  
>  	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
> @@ -1048,6 +1084,7 @@ xfs_file_iomap_begin(
>  		if (error)
>  			return error;
>  
> +alloc_done:
>  		iomap->flags = IOMAP_F_NEW;
>  		trace_xfs_iomap_alloc(ip, offset, length, 0, &imap);
>  	} else {
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
