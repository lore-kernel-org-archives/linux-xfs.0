Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44456 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeCMUpr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 16:45:47 -0400
Date: Tue, 13 Mar 2018 13:45:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/8] xfs: remove xfs_zero_range
Message-ID: <20180313204543.GF4865@magnolia>
References: <20180313143601.30028-1-hch@lst.de>
 <20180313143601.30028-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313143601.30028-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 03:35:57PM +0100, Christoph Hellwig wrote:
> This helper doesn't add any real value over just calling iomap_zero_range
> directly, so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 11 ++++-------
>  fs/xfs/xfs_file.c      | 48 +++++++-----------------------------------------
>  fs/xfs/xfs_inode.h     |  4 ----
>  fs/xfs/xfs_iops.c      |  4 +++-
>  4 files changed, 14 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 19ea7d086cf8..05dee8fdd895 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1208,18 +1208,15 @@ xfs_free_file_space(
>  
>  	/*
>  	 * Now that we've unmap all full blocks we'll have to zero out any
> -	 * partial block at the beginning and/or end.  xfs_zero_range is
> -	 * smart enough to skip any holes, including those we just created,
> -	 * but we must take care not to zero beyond EOF and enlarge i_size.
> +	 * partial block at the beginning and/or end.  iomap_zero_range is smart
> +	 * enough to skip any holes, including those we just created, but we
> +	 * must take care not to zero beyond EOF and enlarge i_size.
>  	 */
> -
>  	if (offset >= XFS_ISIZE(ip))
>  		return 0;
> -
>  	if (offset + len > XFS_ISIZE(ip))
>  		len = XFS_ISIZE(ip) - offset;
> -
> -	return xfs_zero_range(ip, offset, len, NULL);
> +	return iomap_zero_range(VFS_I(ip), offset, len, NULL, &xfs_iomap_ops);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 9ea08326f876..d2666ddf7381 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -48,20 +48,6 @@
>  
>  static const struct vm_operations_struct xfs_file_vm_ops;
>  
> -/*
> - * Clear the specified ranges to zero through either the pagecache or DAX.
> - * Holes and unwritten extents will be left as-is as they already are zeroed.
> - */
> -int
> -xfs_zero_range(
> -	struct xfs_inode	*ip,
> -	xfs_off_t		pos,
> -	xfs_off_t		count,
> -	bool			*did_zero)
> -{
> -	return iomap_zero_range(VFS_I(ip), pos, count, did_zero, &xfs_iomap_ops);
> -}
> -
>  int
>  xfs_update_prealloc_flags(
>  	struct xfs_inode	*ip,
> @@ -300,31 +286,6 @@ xfs_file_read_iter(
>  	return ret;
>  }
>  
> -/*
> - * Zero any on disk space between the current EOF and the new, larger EOF.
> - *
> - * This handles the normal case of zeroing the remainder of the last block in
> - * the file and the unusual case of zeroing blocks out beyond the size of the
> - * file.  This second case only happens with fixed size extents and when the
> - * system crashes before the inode size was updated but after blocks were
> - * allocated.
> - *
> - * Expects the iolock to be held exclusive, and will take the ilock internally.
> - */
> -int					/* error (positive) */
> -xfs_zero_eof(
> -	struct xfs_inode	*ip,
> -	xfs_off_t		offset,		/* starting I/O offset */
> -	xfs_fsize_t		isize,		/* current inode size */
> -	bool			*did_zeroing)
> -{
> -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> -	ASSERT(offset > isize);
> -
> -	trace_xfs_zero_eof(ip, isize, offset - isize);
> -	return xfs_zero_range(ip, isize, offset - isize, did_zeroing);
> -}
> -
>  /*
>   * Common pre-write limit and setup checks.
>   *
> @@ -344,6 +305,7 @@ xfs_file_aio_write_checks(
>  	ssize_t			error = 0;
>  	size_t			count = iov_iter_count(from);
>  	bool			drained_dio = false;
> +	loff_t			isize;
>  
>  restart:
>  	error = generic_write_checks(iocb, from);
> @@ -380,7 +342,8 @@ xfs_file_aio_write_checks(
>  	 * and hence be able to correctly determine if we need to run zeroing.
>  	 */
>  	spin_lock(&ip->i_flags_lock);
> -	if (iocb->ki_pos > i_size_read(inode)) {
> +	isize = i_size_read(inode);
> +	if (iocb->ki_pos > isize) {
>  		spin_unlock(&ip->i_flags_lock);
>  		if (!drained_dio) {
>  			if (*iolock == XFS_IOLOCK_SHARED) {
> @@ -401,7 +364,10 @@ xfs_file_aio_write_checks(
>  			drained_dio = true;
>  			goto restart;
>  		}
> -		error = xfs_zero_eof(ip, iocb->ki_pos, i_size_read(inode), NULL);
> +	
> +		trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
> +		error = iomap_zero_range(inode, isize, iocb->ki_pos - isize,
> +				NULL, &xfs_iomap_ops);
>  		if (error)
>  			return error;
>  	} else
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 3e8dc990d41c..132d8aa2afc4 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -443,10 +443,6 @@ enum xfs_prealloc_flags {
>  
>  int	xfs_update_prealloc_flags(struct xfs_inode *ip,
>  				  enum xfs_prealloc_flags flags);
> -int	xfs_zero_eof(struct xfs_inode *ip, xfs_off_t offset,
> -		     xfs_fsize_t isize, bool *did_zeroing);
> -int	xfs_zero_range(struct xfs_inode *ip, xfs_off_t pos, xfs_off_t count,
> -		bool *did_zero);
>  
>  /* from xfs_iops.c */
>  extern void xfs_setup_inode(struct xfs_inode *ip);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 8567951eff10..e0307fbff911 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -875,7 +875,9 @@ xfs_setattr_size(
>  	 * truncate.
>  	 */
>  	if (newsize > oldsize) {
> -		error = xfs_zero_eof(ip, newsize, oldsize, &did_zeroing);
> +		trace_xfs_zero_eof(ip, oldsize, newsize - oldsize);
> +		error = iomap_zero_range(inode, oldsize, newsize - oldsize,
> +				&did_zeroing, &xfs_iomap_ops);
>  	} else {
>  		error = iomap_truncate_page(inode, newsize, &did_zeroing,
>  				&xfs_iomap_ops);
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
