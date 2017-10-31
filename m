Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47838 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751324AbdJaVeq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 17:34:46 -0400
Date: Tue, 31 Oct 2017 14:34:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/18] xfs: don't create overlapping extents in
 xfs_bmap_add_extent_delay_real
Message-ID: <20171031213442.GK4911@magnolia>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031142230.11755-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 04:22:14PM +0200, Christoph Hellwig wrote:
> Two cases in xfs_bmap_add_extent_delay_real currently insert a new
> extent before updating the existing one that is being split.  While
> this works fine with a simple extent list, a more complex tree can't
> easily cope with overlapping extent.  Reshuffle the code a bit to update
> the slot of the existing delalloc extent to the new real extent before
> inserting the shortened delalloc extent before or after it.  This
> avoids the overlapping extents while still allowing to update the
> br_startblock field of the delalloc extent with the updated indirect
> block reservation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b2b6832b9e6b..0eda6892b9d0 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1790,7 +1790,7 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in the first part of a previous delayed allocation.
>  		 * The left neighbor is not contiguous.
>  		 */
> -		xfs_iext_insert(bma->ip, bma->idx, 1, new, state);
> +		xfs_iext_update_extent(bma->ip, state, bma->idx, new);
>  		(*nextents)++;
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> @@ -1823,7 +1823,7 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_startoff = new_endoff;
>  		PREV.br_blockcount = temp;
>  		PREV.br_startblock = nullstartblock(da_new);
> -		xfs_iext_update_extent(bma->ip, state, bma->idx + 1, &PREV);
> +		xfs_iext_insert(bma->ip, bma->idx + 1, 1, &PREV, state);
>  		break;
>  
>  	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
> @@ -1866,7 +1866,7 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in the last part of a previous delayed allocation.
>  		 * The right neighbor is not contiguous.
>  		 */
> -		xfs_iext_insert(bma->ip, bma->idx + 1, 1, new, state);
> +		xfs_iext_update_extent(bma->ip, state, bma->idx, new);
>  		(*nextents)++;
>  		if (bma->cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> @@ -1898,7 +1898,7 @@ xfs_bmap_add_extent_delay_real(
>  
>  		PREV.br_startblock = nullstartblock(da_new);
>  		PREV.br_blockcount = temp;
> -		xfs_iext_update_extent(bma->ip, state, bma->idx, &PREV);
> +		xfs_iext_insert(bma->ip, bma->idx, 1, &PREV, state);
>  
>  		bma->idx++;
>  		break;
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
