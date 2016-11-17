Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750714AbcKQTHu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Nov 2016 14:07:50 -0500
Date: Thu, 17 Nov 2016 14:07:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/14] xfs: use new extent lookup helpers in
 __xfs_reflink_reserve_cow
Message-ID: <20161117190716.GJ49658@bfoster.bfoster>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
 <1479143565-30615-9-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479143565-30615-9-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 14, 2016 at 06:12:39PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 52cdfba..35e02ce 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -243,10 +243,11 @@ xfs_reflink_reserve_cow(
>  	struct xfs_bmbt_irec	*imap,
>  	bool			*shared)
>  {
> -	struct xfs_bmbt_irec	got, prev;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> +	struct xfs_bmbt_irec	got;
>  	xfs_fileoff_t		end_fsb, orig_end_fsb;
> -	int			eof = 0, error = 0;
> -	bool			trimmed;
> +	int			error = 0;
> +	bool			eof = false, trimmed;
>  	xfs_extnum_t		idx;
>  	xfs_extlen_t		align;
>  
> @@ -258,8 +259,9 @@ xfs_reflink_reserve_cow(
>  	 * extent list is generally faster than going out to the shared extent
>  	 * tree.
>  	 */
> -	xfs_bmap_search_extents(ip, imap->br_startoff, XFS_COW_FORK, &eof, &idx,
> -			&got, &prev);
> +
> +	if (!xfs_iext_lookup_extent(ip, ifp, imap->br_startoff, &idx, &got))
> +		eof = true;
>  	if (!eof && got.br_startoff <= imap->br_startoff) {
>  		trace_xfs_reflink_cow_found(ip, imap);
>  		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
