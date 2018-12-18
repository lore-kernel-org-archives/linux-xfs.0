Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58140 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbeLRVoc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 16:44:32 -0500
Date: Tue, 18 Dec 2018 13:44:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/11] xfs: don't use delalloc extents for COW on files
 with extsize hints
Message-ID: <20181218214425.GL27208@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181203222503.30649-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203222503.30649-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 03, 2018 at 05:24:58PM -0500, Christoph Hellwig wrote:
> While using delalloc for extsize hints is generally a good idea, the
> current code that does so only for COW doesn't help us much and creates
> a lot of special cases.  Switch it to use real allocations like we
> do for direct I/O.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iomap.c   | 28 +++++++++++++++++-----------
>  fs/xfs/xfs_reflink.c |  5 ++++-
>  fs/xfs/xfs_reflink.h |  5 ++---
>  3 files changed, 23 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 9f1fd224bb06..d851abac16a9 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1039,22 +1039,28 @@ xfs_file_iomap_begin(
>  	 * been done up front, so we don't need to do them here.
>  	 */
>  	if (xfs_is_reflink_inode(ip)) {
> +		struct xfs_bmbt_irec	orig = imap;
> +
>  		/* if zeroing doesn't need COW allocation, then we are done. */
>  		if ((flags & IOMAP_ZERO) &&
>  		    !needs_cow_for_zeroing(&imap, nimaps))
>  			goto out_found;
>  
> -		if (flags & IOMAP_DIRECT) {
> -			/* may drop and re-acquire the ilock */
> -			error = xfs_reflink_allocate_cow(ip, &imap, &shared,
> -					&lockmode);
> -			if (error)
> -				goto out_unlock;
> -		} else {
> -			error = xfs_reflink_reserve_cow(ip, &imap);
> -			if (error)
> -				goto out_unlock;
> -		}
> +		error = xfs_reflink_allocate_cow(ip, &imap, &shared, &lockmode,
> +						 flags);
> +		if (error)
> +			goto out_unlock;
> +
> +		/*
> +		 * For buffered writes we need to report the address of the
> +		 * previous block (if there was any) so that the higher level
> +		 * write code can perform read-modify-write operations.  For
> +		 * direct I/O code, which must be block aligned we need to
> +		 * report the newly allocated address.
> +		 */
> +		if (!(flags & IOMAP_DIRECT) &&
> +		    orig.br_startblock != HOLESTARTBLOCK)
> +			imap = orig;
>  
>  		end_fsb = imap.br_startoff + imap.br_blockcount;
>  		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index a8c32632090c..bdbaff1b3fb7 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -397,7 +397,8 @@ xfs_reflink_allocate_cow(
>  	struct xfs_inode	*ip,
>  	struct xfs_bmbt_irec	*imap,
>  	bool			*shared,
> -	uint			*lockmode)
> +	uint			*lockmode,
> +	unsigned		flags)

I'm not thrilled with passing iomap flags into the reflink code here...

>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fileoff_t		offset_fsb = imap->br_startoff;
> @@ -471,6 +472,8 @@ xfs_reflink_allocate_cow(
>  	if (nimaps == 0)
>  		return -ENOSPC;
>  convert:
> +	if (!(flags & IOMAP_DIRECT))

...because I feel that it's easy to miss the subtlety here that for
buffered writes we don't care if the cow extent is unwritten or written,
but for directio we very /much/ care that the cow extent is written,
because we're writing to it immediately.  Can this grow a comment to
reinforce why we skip the conversion?

Also, can we call this 'iomap_flags' to make it clearer which flags
we're talking about?

/*
 * COW fork extents are supposed to remain unwritten until we're ready
 * to initiate a disk write.  For directio we /are/ going to write the
 * data and need the conversion, but for buffered writes we're done.
 */
if (!(iomap_flags & IOMAP_DIRECT))
	return 0;
return xfs_reflink_convert_cow_extent(...);

--D

> +		return 0;
>  	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb);
>  
>  out_unreserve:
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 6d73daef1f13..d76fc520cac8 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -12,10 +12,9 @@ extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
>  extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *irec, bool *shared);
>  
> -extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
> -		struct xfs_bmbt_irec *imap);
>  extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
> -		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode);
> +		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode,
> +		unsigned flags);
>  extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t count);
>  
> -- 
> 2.19.1
> 
