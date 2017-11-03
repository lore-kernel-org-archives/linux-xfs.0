Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42846 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754486AbdKCQwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 12:52:42 -0400
Date: Fri, 3 Nov 2017 09:52:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/21] xfs: iterate backwards in
 xfs_reflink_cancel_cow_blocks
Message-ID: <20171103165236.GN4911@magnolia>
References: <20171103144539.2187-1-hch@lst.de>
 <20171103144539.2187-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103144539.2187-14-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 03, 2017 at 05:45:31PM +0300, Christoph Hellwig wrote:
> Match the iteration order for extent deletion in the truncate and
> reflink I/O completion path.
> 
> This also happens to make implementing the new incore extent list
> a lot easier.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_reflink.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index d86c4378facf..cf976ed65260 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -569,12 +569,20 @@ xfs_reflink_cancel_cow_blocks(
>  
>  	if (!xfs_is_reflink_inode(ip))
>  		return 0;
> -	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got))
> +	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
>  		return 0;
>  
> -	while (got.br_startoff < end_fsb) {
> +	/* Walk backwards until we're out of the I/O range... */
> +	while (got.br_startoff + got.br_blockcount > offset_fsb) {
>  		del = got;
>  		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
> +
> +		/* Extent delete may have bumped ext forward */
> +		if (!del.br_blockcount) {
> +			xfs_iext_prev(ifp, &icur);
> +			goto next_extent;
> +		}
> +
>  		trace_xfs_reflink_cancel_cow(ip, &del);
>  
>  		if (isnullstartblock(del.br_startblock)) {
> @@ -612,8 +620,8 @@ xfs_reflink_cancel_cow_blocks(
>  			/* Remove the mapping from the CoW fork. */
>  			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
>  		}
> -
> -		if (!xfs_iext_next_extent(ifp, &icur, &got))
> +next_extent:
> +		if (!xfs_iext_get_extent(ifp, &icur, &got))
>  			break;
>  	}
>  
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
