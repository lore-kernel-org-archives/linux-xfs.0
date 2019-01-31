Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48676 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbfAaT24 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 14:28:56 -0500
Date: Thu, 31 Jan 2019 14:28:53 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/11] xfs: move transaction handling to
 xfs_bmapi_convert_delalloc
Message-ID: <20190131192853.GJ36239@bfoster>
References: <20190131075524.4769-1-hch@lst.de>
 <20190131075524.4769-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131075524.4769-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 08:55:21AM +0100, Christoph Hellwig wrote:
> No need to deal with the transaction and the inode locking in the
> caller.  Also move to automatic unlocking on transaction commit or
> cancel to simplify the code a little more.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 33 +++++++++++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_bmap.h |  6 +++---
>  fs/xfs/xfs_iomap.c       | 32 ++++----------------------------
>  3 files changed, 36 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 818cd018d510..408a6da14849 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4446,16 +4446,32 @@ xfs_bmapi_write(
>   */
>  int
>  xfs_bmapi_convert_delalloc(
> -	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	int			whichfork,
>  	xfs_fileoff_t		offset_fsb,
> -	struct xfs_bmbt_irec	*imap)
> +	struct xfs_bmbt_irec	*imap,
> +	unsigned int		*seq)
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_bmalloca	bma = { NULL };
> +	struct xfs_trans	*tp;
>  	int			error;
>  
> +	/*
> +	 * Space for the extent and indirect blocks was reserved when the
> +	 * delalloc extent was created so there's no need to do so here.
> +	 */
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
> +				XFS_TRANS_RESERVE, &tp);
> +	if (error)
> +		return error;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +
> +	*seq = READ_ONCE(ifp->if_seq);
> +

seq is going to change once we do the allocation. I think you want to
move this further down to where we set imap, otherwise looks good.

Brian

>  	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
>  	    bma.got.br_startoff > offset_fsb) {
>  		/*
> @@ -4464,7 +4480,8 @@ xfs_bmapi_convert_delalloc(
>  		 * might have moved the extent to the data fork in the meantime.
>  		 */
>  		WARN_ON_ONCE(whichfork != XFS_COW_FORK);
> -		return -EAGAIN;
> +		error = -EAGAIN;
> +		goto out_trans_cancel;
>  	}
>  
>  	/*
> @@ -4473,7 +4490,7 @@ xfs_bmapi_convert_delalloc(
>  	 */
>  	if (!isnullstartblock(bma.got.br_startblock)) {
>  		*imap = bma.got;
> -		return 0;
> +		goto out_trans_cancel;
>  	}
>  
>  	bma.tp = tp;
> @@ -4510,8 +4527,16 @@ xfs_bmapi_convert_delalloc(
>  
>  	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
>  			whichfork);
> +	if (error)
> +		goto out_finish;
> +
> +	xfs_bmapi_finish(&bma, whichfork, 0);
> +	return xfs_trans_commit(tp);
> +
>  out_finish:
>  	xfs_bmapi_finish(&bma, whichfork, error);
> +out_trans_cancel:
> +	xfs_trans_cancel(tp);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 5bdfa8001f07..78b190b6e908 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -223,9 +223,9 @@ int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
>  		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
>  		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
>  		int eof);
> -int	xfs_bmapi_convert_delalloc(struct xfs_trans *tp, struct xfs_inode *ip,
> -		int whichfork, xfs_fileoff_t offset_fsb,
> -		struct xfs_bmbt_irec *imap);
> +int	xfs_bmapi_convert_delalloc(struct xfs_inode *ip, int whichfork,
> +		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap,
> +		unsigned int *seq);
>  
>  static inline void
>  xfs_bmap_add_free(
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index b7c1b279057b..39be741cac5a 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -684,11 +684,9 @@ xfs_iomap_write_allocate(
>  	unsigned int		*seq)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	xfs_fileoff_t		offset_fsb;
>  	xfs_fileoff_t		map_start_fsb;
>  	xfs_extlen_t		map_count_fsb;
> -	struct xfs_trans	*tp;
>  	int			error = 0;
>  
>  	/*
> @@ -716,17 +714,8 @@ xfs_iomap_write_allocate(
>  		/*
>  		 * Allocate in a loop because it may take several attempts to
>  		 * allocate real blocks for a contiguous delalloc extent if free
> -		 * space is sufficiently fragmented. Note that space for the
> -		 * extent and indirect blocks was reserved when the delalloc
> -		 * extent was created so there's no need to do so here.
> +		 * space is sufficiently fragmented.
>  		 */
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
> -					XFS_TRANS_RESERVE, &tp);
> -		if (error)
> -			return error;
> -
> -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> -		xfs_trans_ijoin(tp, ip, 0);
>  
>  		/*
>  		 * ilock was dropped since imap was populated which means it
> @@ -737,17 +726,10 @@ xfs_iomap_write_allocate(
>  		 * caller. We'll trim it down to the caller's most recently
>  		 * validated range before we return.
>  		 */
> -		error = xfs_bmapi_convert_delalloc(tp, ip, whichfork,
> -				offset_fsb, imap);
> -		if (error)
> -			goto trans_cancel;
> -
> -		error = xfs_trans_commit(tp);
> +		error = xfs_bmapi_convert_delalloc(ip, whichfork, offset_fsb,
> +				imap, seq);
>  		if (error)
> -			goto error0;
> -
> -		*seq = READ_ONCE(ifp->if_seq);
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +			return error;
>  
>  		/*
>  		 * See if we were able to allocate an extent that covers at
> @@ -766,12 +748,6 @@ xfs_iomap_write_allocate(
>  			return 0;
>  		}
>  	}
> -
> -trans_cancel:
> -	xfs_trans_cancel(tp);
> -error0:
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	return error;
>  }
>  
>  int
> -- 
> 2.20.1
> 
