Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727159AbeIZVbe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Sep 2018 17:31:34 -0400
Date: Wed, 26 Sep 2018 11:18:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 10/10] xfs: use a separate iomap_ops for delalloc writes
Message-ID: <20180926151805.GC899@bfoster>
References: <20180917205354.15401-1-hch@lst.de>
 <20180917205354.15401-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180917205354.15401-11-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 17, 2018 at 10:53:54PM +0200, Christoph Hellwig wrote:
> Introduce a new xfs_delalloc_iomap_ops instance that is passed to
> iomap_apply when we are doing delayed allocations.  This keeps the code
> more neatly separated for future work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_util.c |   3 +-
>  fs/xfs/xfs_file.c      |   6 +-
>  fs/xfs/xfs_iomap.c     | 177 ++++++++++++++++++++---------------------
>  fs/xfs/xfs_iomap.h     |   1 +
>  fs/xfs/xfs_iops.c      |   4 +-
>  fs/xfs/xfs_reflink.c   |   2 +-
>  6 files changed, 95 insertions(+), 98 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 9079196bbc35..1bfc40ce581a 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -512,8 +512,16 @@ xfs_iomap_prealloc_size(
>  	return alloc_blocks;
>  }
>  
> +static int xfs_file_iomap_begin(struct inode *inode, loff_t offset,
> +		loff_t length, unsigned flags, struct iomap *iomap);
> +
> +/*
> + * Start writing to a file, allocating blocks using delayed allocations if
> + * needed.  Note that in case of doing COW overwrites the iomap needs to return
> + * the address of the existing data.
> + */
>  static int
> -xfs_file_iomap_begin_delay(
> +xfs_delalloc_iomap_begin(

Ok, but wouldn't something like xfs_buffered_iomap_begin/end() be a
better name? Technically a real extent may already exist in this
codepath, so I find the delalloc name kind of confusing.

>  	struct inode		*inode,
>  	loff_t			offset,
>  	loff_t			count,
...
> @@ -658,6 +671,73 @@ xfs_file_iomap_begin_delay(
>  	return error;
>  }
>  
> +static int
> +xfs_delalloc_iomap_end(
> +	struct inode		*inode,
> +	loff_t			offset,
> +	loff_t			length,
> +	ssize_t			written,
> +	unsigned		flags,
> +	struct iomap		*iomap)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		start_fsb;
> +	xfs_fileoff_t		end_fsb;
> +	int			error = 0;
> +
> +	if (iomap->type != IOMAP_DELALLOC)
> +		return 0;

Any reason we don't continue to filter out !IOMAP_WRITE as well?

Brian

> +
> +	/*
> +	 * Behave as if the write failed if drop writes is enabled. Set the NEW
> +	 * flag to force delalloc cleanup.
> +	 */
> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_DROP_WRITES)) {
> +		iomap->flags |= IOMAP_F_NEW;
> +		written = 0;
> +	}
> +
> +	/*
> +	 * start_fsb refers to the first unused block after a short write. If
> +	 * nothing was written, round offset down to point at the first block in
> +	 * the range.
> +	 */
> +	if (unlikely(!written))
> +		start_fsb = XFS_B_TO_FSBT(mp, offset);
> +	else
> +		start_fsb = XFS_B_TO_FSB(mp, offset + written);
> +	end_fsb = XFS_B_TO_FSB(mp, offset + length);
> +
> +	/*
> +	 * Trim delalloc blocks if they were allocated by this write and we
> +	 * didn't manage to write the whole range.
> +	 *
> +	 * We don't need to care about racing delalloc as we hold i_mutex
> +	 * across the reserve/allocate/unreserve calls. If there are delalloc
> +	 * blocks in the range, they are ours.
> +	 */
> +	if ((iomap->flags & IOMAP_F_NEW) && start_fsb < end_fsb) {
> +		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
> +					 XFS_FSB_TO_B(mp, end_fsb) - 1);
> +
> +		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
> +					       end_fsb - start_fsb);
> +		if (error && !XFS_FORCED_SHUTDOWN(mp)) {
> +			xfs_alert(mp, "%s: unable to clean up ino %lld",
> +				__func__, ip->i_ino);
> +			return error;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +const struct iomap_ops xfs_delalloc_iomap_ops = {
> +	.iomap_begin		= xfs_delalloc_iomap_begin,
> +	.iomap_end		= xfs_delalloc_iomap_end,
> +};
> +
>  /*
>   * Pass in a delayed allocate extent, convert it to real extents;
>   * return to the caller the extent we create which maps on top of
> @@ -1028,16 +1108,13 @@ xfs_file_iomap_begin(
>  	bool			shared = false;
>  	unsigned		lockmode;
>  
> +	ASSERT(!(flags & (IOMAP_WRITE | IOMAP_ZERO)) ||
> +		(flags & IOMAP_DIRECT) || IS_DAX(inode));
> +	ASSERT(!(flags & IOMAP_ZERO) || XFS_IS_REALTIME_INODE(ip));
> +
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && !(flags & IOMAP_DIRECT) &&
> -			!IS_DAX(inode) && !XFS_IS_REALTIME_INODE(ip)) {
> -		/* Reserve delalloc blocks for regular writeback. */
> -		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
> -				iomap);
> -	}
> -
>  	/*
>  	 * Lock the inode in the manner required for the specified operation and
>  	 * check for as many conditions that would result in blocking as
> @@ -1070,15 +1147,6 @@ xfs_file_iomap_begin(
>  	if (!(flags & (IOMAP_WRITE | IOMAP_ZERO)))
>  		goto out_found;
>  
> -	/*
> -	 * Don't need to allocate over holes when doing zeroing operations,
> -	 * unless we need to COW and have an existing extent.
> -	 */
> -	if ((flags & IOMAP_ZERO) &&
> -	    (!xfs_is_reflink_inode(ip) ||
> -	     !needs_cow_for_zeroing(&imap, nimaps)))
> -		goto out_found;
> -
>  	/*
>  	 * Break shared extents if necessary. Checks for non-blocking IO have
>  	 * been done up front, so we don't need to do them here.
> @@ -1148,81 +1216,8 @@ xfs_file_iomap_begin(
>  	return error;
>  }
>  
> -static int
> -xfs_file_iomap_end_delalloc(
> -	struct xfs_inode	*ip,
> -	loff_t			offset,
> -	loff_t			length,
> -	ssize_t			written,
> -	struct iomap		*iomap)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -	xfs_fileoff_t		start_fsb;
> -	xfs_fileoff_t		end_fsb;
> -	int			error = 0;
> -
> -	/*
> -	 * Behave as if the write failed if drop writes is enabled. Set the NEW
> -	 * flag to force delalloc cleanup.
> -	 */
> -	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_DROP_WRITES)) {
> -		iomap->flags |= IOMAP_F_NEW;
> -		written = 0;
> -	}
> -
> -	/*
> -	 * start_fsb refers to the first unused block after a short write. If
> -	 * nothing was written, round offset down to point at the first block in
> -	 * the range.
> -	 */
> -	if (unlikely(!written))
> -		start_fsb = XFS_B_TO_FSBT(mp, offset);
> -	else
> -		start_fsb = XFS_B_TO_FSB(mp, offset + written);
> -	end_fsb = XFS_B_TO_FSB(mp, offset + length);
> -
> -	/*
> -	 * Trim delalloc blocks if they were allocated by this write and we
> -	 * didn't manage to write the whole range.
> -	 *
> -	 * We don't need to care about racing delalloc as we hold i_mutex
> -	 * across the reserve/allocate/unreserve calls. If there are delalloc
> -	 * blocks in the range, they are ours.
> -	 */
> -	if ((iomap->flags & IOMAP_F_NEW) && start_fsb < end_fsb) {
> -		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
> -					 XFS_FSB_TO_B(mp, end_fsb) - 1);
> -
> -		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
> -					       end_fsb - start_fsb);
> -		if (error && !XFS_FORCED_SHUTDOWN(mp)) {
> -			xfs_alert(mp, "%s: unable to clean up ino %lld",
> -				__func__, ip->i_ino);
> -			return error;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
> -static int
> -xfs_file_iomap_end(
> -	struct inode		*inode,
> -	loff_t			offset,
> -	loff_t			length,
> -	ssize_t			written,
> -	unsigned		flags,
> -	struct iomap		*iomap)
> -{
> -	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
> -		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
> -				length, written, iomap);
> -	return 0;
> -}
> -
>  const struct iomap_ops xfs_iomap_ops = {
>  	.iomap_begin		= xfs_file_iomap_begin,
> -	.iomap_end		= xfs_file_iomap_end,
>  };
>  
>  static int
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index c6170548831b..fe4cde2c30c9 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -42,6 +42,7 @@ xfs_aligned_fsb_count(
>  }
>  
>  extern const struct iomap_ops xfs_iomap_ops;
> +extern const struct iomap_ops xfs_delalloc_iomap_ops;
>  extern const struct iomap_ops xfs_xattr_iomap_ops;
>  
>  #endif /* __XFS_IOMAP_H__*/
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index c3e74f9128e8..fb8035e3ba0b 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -865,10 +865,10 @@ xfs_setattr_size(
>  	if (newsize > oldsize) {
>  		trace_xfs_zero_eof(ip, oldsize, newsize - oldsize);
>  		error = iomap_zero_range(inode, oldsize, newsize - oldsize,
> -				&did_zeroing, &xfs_iomap_ops);
> +				&did_zeroing, &xfs_delalloc_iomap_ops);
>  	} else {
>  		error = iomap_truncate_page(inode, newsize, &did_zeroing,
> -				&xfs_iomap_ops);
> +				&xfs_delalloc_iomap_ops);
>  	}
>  
>  	if (error)
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index e0111d31140b..ac94ace45424 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1393,7 +1393,7 @@ xfs_reflink_dirty_extents(
>  			if (fpos + flen > isize)
>  				flen = isize - fpos;
>  			error = iomap_file_dirty(VFS_I(ip), fpos, flen,
> -					&xfs_iomap_ops);
> +					&xfs_delalloc_iomap_ops);
>  			xfs_ilock(ip, XFS_ILOCK_EXCL);
>  			if (error)
>  				goto out;
> -- 
> 2.18.0
> 
