Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47426 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfBSFRa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Feb 2019 00:17:30 -0500
Date: Mon, 18 Feb 2019 21:17:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/8] xfs: don't use delalloc extents for COW on files
 with extsize hints
Message-ID: <20190219051724.GD32253@magnolia>
References: <20190218091827.12619-1-hch@lst.de>
 <20190218091827.12619-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218091827.12619-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 18, 2019 at 10:18:22AM +0100, Christoph Hellwig wrote:
> While using delalloc for extsize hints is generally a good idea, the
> current code that does so only for COW doesn't help us much and creates
> a lot of special cases.  Switch it to use real allocations like we
> do for direct I/O.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iomap.c   | 28 +++++++++++++++++-----------
>  fs/xfs/xfs_reflink.c | 10 +++++++++-
>  fs/xfs/xfs_reflink.h |  3 ++-
>  3 files changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index a7599b084571..19a3331b4a56 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -918,22 +918,28 @@ xfs_file_iomap_begin(
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

AFAICT we can still cycle the ilock in _reflink_allocate_cow, so we
should retain the comment.  I'll fix that in my tree if I end up pulling
in this series...

Otherwise looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


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
> index 2babc2cbe103..8a5353daf9ab 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -397,7 +397,8 @@ xfs_reflink_allocate_cow(
>  	struct xfs_inode	*ip,
>  	struct xfs_bmbt_irec	*imap,
>  	bool			*shared,
> -	uint			*lockmode)
> +	uint			*lockmode,
> +	unsigned		iomap_flags)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fileoff_t		offset_fsb = imap->br_startoff;
> @@ -471,6 +472,13 @@ xfs_reflink_allocate_cow(
>  	if (nimaps == 0)
>  		return -ENOSPC;
>  convert:
> +	/*
> +	 * COW fork extents are supposed to remain unwritten until we're ready
> +	 * to initiate a disk write.  For direct I/O we are going to write the
> +	 * data and need the conversion, but for buffered writes we're done.
> +	 */
> +	if (!(iomap_flags & IOMAP_DIRECT))
> +		return 0;
>  	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb);
>  
>  out_unreserve:
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 6d73daef1f13..70d68a1a9b49 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -15,7 +15,8 @@ extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
>  extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *imap);
>  extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
> -		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode);
> +		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode,
> +		unsigned iomap_flags);
>  extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t count);
>  
> -- 
> 2.20.1
> 
