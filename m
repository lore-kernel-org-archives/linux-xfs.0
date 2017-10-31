Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24857 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751344AbdJaWKQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 18:10:16 -0400
Date: Tue, 31 Oct 2017 15:10:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/18] xfs: iterate backwards in
 xfs_reflink_cancel_cow_blocks
Message-ID: <20171031221011.GU4911@magnolia>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031142230.11755-14-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 04:22:25PM +0200, Christoph Hellwig wrote:
> This follow the iteration oder for extent deletion in both the regular
                            ^^^^
Jeez man I didn't think the code smelled /that/ bad. :P

"order", I'm assuming. :)

> reflink I/O completion path and normal block truncation, and makes
> implementing the new incore extent list easier.

"Make consistent the extent iteration order for deleting extents in both
the regular reflink IO completion path and regular block truncation, so
that implementing the new incore extent map is easier." ?

(Eh, the language is still a bit tortured...)

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_reflink.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index cadf0ff68003..43bec0def51d 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -569,12 +569,20 @@ xfs_reflink_cancel_cow_blocks(
>  
>  	if (!xfs_is_reflink_inode(ip))
>  		return 0;
> -	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &ext, &got))
> +	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &ext, &got))
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
> +			xfs_iext_prev(ifp, &ext);
> +			goto next_extent;
> +		}
> +
>  		trace_xfs_reflink_cancel_cow(ip, &del);
>  
>  		if (isnullstartblock(del.br_startblock)) {
> @@ -612,8 +620,8 @@ xfs_reflink_cancel_cow_blocks(
>  			/* Remove the mapping from the CoW fork. */
>  			xfs_bmap_del_extent_cow(ip, &ext, &got, &del);
>  		}
> -
> -		if (!xfs_iext_next_extent(ifp, &ext, &got))
> +next_extent:
> +		if (!xfs_iext_get_extent(ifp, &ext, &got))
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
