Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43239 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751598AbcKQTHu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Nov 2016 14:07:50 -0500
Date: Thu, 17 Nov 2016 14:07:32 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/14] xfs: use new extent lookup helpers in
 xfs_reflink_cancel_cow_blocks
Message-ID: <20161117190731.GM49658@bfoster.bfoster>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
 <1479143565-30615-12-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479143565-30615-12-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 14, 2016 at 06:12:42PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 0668490..a878d42 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -493,18 +493,15 @@ xfs_reflink_cancel_cow_blocks(
>  	xfs_fileoff_t			end_fsb)
>  {
>  	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> -	struct xfs_bmbt_irec		got, prev, del;
> +	struct xfs_bmbt_irec		got, del;
>  	xfs_extnum_t			idx;
>  	xfs_fsblock_t			firstfsb;
>  	struct xfs_defer_ops		dfops;
> -	int				error = 0, eof = 0;
> +	int				error = 0;
>  
>  	if (!xfs_is_reflink_inode(ip))
>  		return 0;
> -
> -	xfs_bmap_search_extents(ip, offset_fsb, XFS_COW_FORK, &eof, &idx,
> -			&got, &prev);
> -	if (eof)
> +	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got))
>  		return 0;
>  
>  	while (got.br_startoff < end_fsb) {
> @@ -547,9 +544,8 @@ xfs_reflink_cancel_cow_blocks(
>  			xfs_bmap_del_extent_cow(ip, &idx, &got, &del);
>  		}
>  
> -		if (++idx >= xfs_iext_count(ifp))
> +		if (!xfs_iext_get_extent(ifp, ++idx, &got))
>  			break;
> -		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &got);
>  	}
>  
>  	/* clear tag if cow fork is emptied */
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
