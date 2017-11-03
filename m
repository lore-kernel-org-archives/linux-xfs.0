Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22802 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756170AbdKCQzM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 12:55:12 -0400
Date: Fri, 3 Nov 2017 09:55:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/21] xfs: simplify xfs_reflink_convert_cow
Message-ID: <20171103165507.GO4911@magnolia>
References: <20171103144539.2187-1-hch@lst.de>
 <20171103144539.2187-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103144539.2187-15-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 03, 2017 at 05:45:32PM +0300, Christoph Hellwig wrote:
> Instead of looking up extents to convert and calling xfs_bmapi_write on
> each of them just let xfs_bmapi_write handle the full range.  To make
> this robust add a new XFS_BMAPI_CONVERT_ONLY that only converts ranges
> and never allocates blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |  3 ++-
>  fs/xfs/libxfs/xfs_bmap.h |  6 +++++-
>  fs/xfs/xfs_reflink.c     | 29 +++++++++++------------------
>  3 files changed, 18 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b08c4863c2af..8fcb186341ce 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4331,7 +4331,8 @@ xfs_bmapi_write(
>  		 * First, deal with the hole before the allocated space
>  		 * that we found, if any.
>  		 */
> -		if (need_alloc || wasdelay) {
> +		if ((need_alloc || wasdelay) &&
> +		    !(flags & XFS_BMAPI_CONVERT_ONLY)) {
>  			bma.eof = eof;
>  			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
>  			bma.wasdel = wasdelay;
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index b6a395949d0c..eaf975eb35f8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -113,6 +113,9 @@ struct xfs_extent_free_item
>  /* Only convert delalloc space, don't allocate entirely new extents */
>  #define XFS_BMAPI_DELALLOC	0x400
>  
> +/* Only convert unwritten extents, don't allocate new blocks */
> +#define XFS_BMAPI_CONVERT_ONLY	0x800
> +
>  #define XFS_BMAPI_FLAGS \
>  	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
>  	{ XFS_BMAPI_METADATA,	"METADATA" }, \
> @@ -124,7 +127,8 @@ struct xfs_extent_free_item
>  	{ XFS_BMAPI_ZERO,	"ZERO" }, \
>  	{ XFS_BMAPI_REMAP,	"REMAP" }, \
>  	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
> -	{ XFS_BMAPI_DELALLOC,	"DELALLOC" }
> +	{ XFS_BMAPI_DELALLOC,	"DELALLOC" }, \
> +	{ XFS_BMAPI_CONVERT_ONLY, "XFS_BMAPI_CONVERT_ONLY" }

"CONVERT_ONLY" to be consistent with the other flag strings?
I can fix this on the way in.

Otherwise,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
>  
>  static inline int xfs_bmapi_aflag(int w)
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index cf976ed65260..cc041a29eb70 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -353,29 +353,22 @@ xfs_reflink_convert_cow(
>  	xfs_off_t		offset,
>  	xfs_off_t		count)
>  {
> -	struct xfs_bmbt_irec	got;
> -	struct xfs_defer_ops	dfops;
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
> -	struct xfs_iext_cursor	icur;
> -	bool			found;
> -	int			error = 0;
> -
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_filblks_t		count_fsb = end_fsb - offset_fsb;
> +	struct xfs_bmbt_irec	imap;
> +	struct xfs_defer_ops	dfops;
> +	xfs_fsblock_t		first_block = NULLFSBLOCK;
> +	int			nimaps = 1, error = 0;
>  
> -	/* Convert all the extents to real from unwritten. */
> -	for (found = xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got);
> -	     found && got.br_startoff < end_fsb;
> -	     found = xfs_iext_next_extent(ifp, &icur, &got)) {
> -		error = xfs_reflink_convert_cow_extent(ip, &got, offset_fsb,
> -				end_fsb - offset_fsb, &dfops);
> -		if (error)
> -			break;
> -	}
> +	ASSERT(count != 0);
>  
> -	/* Finish up. */
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	error = xfs_bmapi_write(NULL, ip, offset_fsb, count_fsb,
> +			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT |
> +			XFS_BMAPI_CONVERT_ONLY, &first_block, 0, &imap, &nimaps,
> +			&dfops);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  }
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
