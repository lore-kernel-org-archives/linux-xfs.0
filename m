Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47654 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751598AbdIUMHM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 08:07:12 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 89F471297
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 12:07:12 +0000 (UTC)
Date: Thu, 21 Sep 2017 08:07:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: update i_size after unwritten conversion in dio
 completion
Message-ID: <20170921120709.GA58956@bfoster.bfoster>
References: <20170921103828.18690-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921103828.18690-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2017 at 06:38:28PM +0800, Eryu Guan wrote:
> Since commit d531d91d6990 ("xfs: always use unwritten extents for
> direct I/O writes"), we start allocating unwritten extents for all
> direct writes to allow appending aio in XFS.
> 
> But for dio writes that could extend file size we update the in-core
> inode size first, then convert the unwritten extents to real
> allocations at dio completion time in xfs_dio_write_end_io(). Thus a
> racing direct read could see the new i_size and find the unwritten
> extents first and read zeros instead of actual data, if the direct
> writer also takes a shared iolock.
> 
> Fix it by updating the in-core inode size after the unwritten extent
> conversion. To do this, introduce a new boolean argument to
> xfs_iomap_write_unwritten() to tell if we want to update in-core
> i_size or not.
> 
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> 
> Patch passed the test posted by Eric[1] and a locally modified aio
> version of the test.
> 
> I also ran fstests with config xfs_4k_crc, xfs_2k_reflink, xfs_1k_rmap
> and xfs_512, and aio-dio tests from ltp, I don't see any new failures
> introduced.
> 
> [1] http://www.spinics.net/lists/fstests/msg06978.html
> 

Looks pretty good, just a few comment/whitespace nits...

>  fs/xfs/xfs_aops.c  |  9 ++++++++-
>  fs/xfs/xfs_file.c  | 34 ++++++++++++++++++++--------------
>  fs/xfs/xfs_iomap.c |  7 ++++++-
>  fs/xfs/xfs_iomap.h |  2 +-
>  fs/xfs/xfs_pnfs.c  |  2 +-
>  5 files changed, 36 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 29172609f2a3..f937968e9515 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -343,7 +343,14 @@ xfs_end_io(
>  		error = xfs_reflink_end_cow(ip, offset, size);
>  		break;
>  	case XFS_IO_UNWRITTEN:
> -		error = xfs_iomap_write_unwritten(ip, offset, size);
> +		/*
> +		 * The correct in-core inode size should have been updated by
> +		 * generic_write_end, and the 'size' here is buffer head
> +		 * granularity size of the ioend, which could be larger than
> +		 * the actual bytes written. So skip in-core i_size update in
> +		 * xfs_iomap_write_unwritten()
> +		 */

The more I think about this, the less applicable the granularity seems
to be (sorry :P). It seems rather broken if writeback were to affect
isize in general. Perhaps just the following?

		/* writeback should never update isize */

> +		error = xfs_iomap_write_unwritten(ip, offset, size, false);
>  		break;
>  	default:
>  		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_append_trans);
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 350b6d43ba23..d4796c5a88fe 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -434,7 +434,6 @@ xfs_dio_write_end_io(
>  	struct inode		*inode = file_inode(iocb->ki_filp);
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	loff_t			offset = iocb->ki_pos;
> -	bool			update_size = false;
>  	int			error = 0;
>  
>  	trace_xfs_end_io_direct_write(ip, offset, size);
> @@ -445,6 +444,22 @@ xfs_dio_write_end_io(
>  	if (size <= 0)
>  		return size;
>  
> +	if (flags & IOMAP_DIO_COW) {
> +		error = xfs_reflink_end_cow(ip, offset, size);
> +		if (error)
> +			return error;
> +	}
> +
> +	 /*
> +	 * Deal with IOMAP_DIO_UNWRITTEN case before check & update in-core
> +	 * inode size, we do it only after converting the unwritten extents to
> +	 * real allocations in xfs_iomap_write_write_unwritten() (by passing
> +	 * 'true' as the last argument to it), otherwise a racing direct read
> +	 * could see the new size thus read zeros because of unwritten extents.
> +	 */

/*
 * Unwritten conversion updates the in-core isize after extent
 * conversion but before updating the on-disk size. Updating isize any
 * earlier allows a racing dio read to find unwritten extents before
 * they are converted.
 */

> +	if (flags & IOMAP_DIO_UNWRITTEN)
> +		return xfs_iomap_write_unwritten(ip, offset, size, true);
> +
>  	/*
>  	 * We need to update the in-core inode size here so that we don't end up
>  	 * with the on-disk inode size being outside the in-core inode size. We
> @@ -459,20 +474,11 @@ xfs_dio_write_end_io(
>  	spin_lock(&ip->i_flags_lock);
>  	if (offset + size > i_size_read(inode)) {
>  		i_size_write(inode, offset + size);
> -		update_size = true;
> -	}
> -	spin_unlock(&ip->i_flags_lock);
> -
> -	if (flags & IOMAP_DIO_COW) {
> -		error = xfs_reflink_end_cow(ip, offset, size);
> -		if (error)
> -			return error;
> -	}
> -
> -	if (flags & IOMAP_DIO_UNWRITTEN)
> -		error = xfs_iomap_write_unwritten(ip, offset, size);
> -	else if (update_size)
> +		spin_unlock(&ip->i_flags_lock);
>  		error = xfs_setfilesize(ip, offset, size);
> +	} else {
> +		spin_unlock(&ip->i_flags_lock);
> +	}
>  
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index a1909bc064e9..90dc551a8621 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -829,7 +829,8 @@ int
>  xfs_iomap_write_unwritten(
>  	xfs_inode_t	*ip,
>  	xfs_off_t	offset,
> -	xfs_off_t	count)
> +	xfs_off_t	count,
> +	bool		update_isize)
>  {
>  	xfs_mount_t	*mp = ip->i_mount;
>  	xfs_fileoff_t	offset_fsb;
> @@ -840,6 +841,7 @@ xfs_iomap_write_unwritten(
>  	xfs_trans_t	*tp;
>  	xfs_bmbt_irec_t imap;
>  	struct xfs_defer_ops dfops;
> +	struct inode	*inode = VFS_I(ip);
>  	xfs_fsize_t	i_size;
>  	uint		resblks;
>  	int		error;
> @@ -900,6 +902,9 @@ xfs_iomap_write_unwritten(
>  		if (i_size > offset + count)
>  			i_size = offset + count;
>  
> +		if (update_isize && (i_size > i_size_read(inode)))
> +			i_size_write(inode, i_size);
> +

We could probably kill the blank lines around the above hunk.

With those minor fixups:

Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for taking care of this!

>  		i_size = xfs_new_eof(ip, i_size);
>  		if (i_size) {
>  			ip->i_d.di_size = i_size;
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index 00db3ecea084..ee535065c5d0 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -27,7 +27,7 @@ int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
>  			struct xfs_bmbt_irec *, int);
>  int xfs_iomap_write_allocate(struct xfs_inode *, int, xfs_off_t,
>  			struct xfs_bmbt_irec *);
> -int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
> +int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
>  
>  void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
>  		struct xfs_bmbt_irec *);
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 2f2dc3c09ad0..4246876df7b7 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -274,7 +274,7 @@ xfs_fs_commit_blocks(
>  					(end - 1) >> PAGE_SHIFT);
>  		WARN_ON_ONCE(error);
>  
> -		error = xfs_iomap_write_unwritten(ip, start, length);
> +		error = xfs_iomap_write_unwritten(ip, start, length, false);
>  		if (error)
>  			goto out_drop_iolock;
>  	}
> -- 
> 2.13.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
