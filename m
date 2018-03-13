Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60574 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752749AbeCMUqQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 16:46:16 -0400
Date: Tue, 13 Mar 2018 13:46:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/8] xfs: minor cleanup for xfs_reflink_end_cow
Message-ID: <20180313204611.GH4865@magnolia>
References: <20180313143601.30028-1-hch@lst.de>
 <20180313143601.30028-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313143601.30028-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 03:35:59PM +0100, Christoph Hellwig wrote:
> Use xfs_iext_prev_extent to skip to the previous extent instead of
> opencoding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_reflink.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 90aac8889dd9..cdbd342a5249 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -762,10 +762,8 @@ xfs_reflink_end_cow(
>  		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
>  
>  		/* Extent delete may have bumped ext forward */
> -		if (!del.br_blockcount) {
> -			xfs_iext_prev(ifp, &icur);
> -			goto next_extent;
> -		}
> +		if (!del.br_blockcount)
> +			goto prev_extent;
>  
>  		ASSERT(!isnullstartblock(got.br_startblock));
>  
> @@ -774,10 +772,8 @@ xfs_reflink_end_cow(
>  		 * speculatively preallocated CoW extents that have been
>  		 * allocated but have not yet been involved in a write.
>  		 */
> -		if (got.br_state == XFS_EXT_UNWRITTEN) {
> -			xfs_iext_prev(ifp, &icur);
> -			goto next_extent;
> -		}
> +		if (got.br_state == XFS_EXT_UNWRITTEN)
> +			goto prev_extent;
>  
>  		/* Unmap the old blocks in the data fork. */
>  		xfs_defer_init(&dfops, &firstfsb);
> @@ -816,9 +812,12 @@ xfs_reflink_end_cow(
>  		error = xfs_defer_finish(&tp, &dfops);
>  		if (error)
>  			goto out_defer;
> -next_extent:
>  		if (!xfs_iext_get_extent(ifp, &icur, &got))
>  			break;
> +		continue;
> +prev_extent:
> +		if (!xfs_iext_prev_extent(ifp, &icur, &got))
> +			break;
>  	}
>  
>  	error = xfs_trans_commit(tp);
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
