Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39144 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdH2Sms (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 14:42:48 -0400
Date: Tue, 29 Aug 2017 11:42:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/8] xfs: use xfs_iext_*_extent helpers in
 xfs_bmap_split_extent_at
Message-ID: <20170829184243.GY4757@magnolia>
References: <20170829174835.2218-1-hch@lst.de>
 <20170829174835.2218-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829174835.2218-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 07:48:33PM +0200, Christoph Hellwig wrote:
> This abstracts the function away from details of the low-level extent
> list implementation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 20 ++++----------------
>  1 file changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 02725becedfa..51571113b270 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6253,7 +6253,6 @@ xfs_bmap_split_extent_at(
>  {
>  	int				whichfork = XFS_DATA_FORK;
>  	struct xfs_btree_cur		*cur = NULL;
> -	struct xfs_bmbt_rec_host	*gotp;
>  	struct xfs_bmbt_irec		got;
>  	struct xfs_bmbt_irec		new; /* split extent */
>  	struct xfs_mount		*mp = ip->i_mount;
> @@ -6285,21 +6284,10 @@ xfs_bmap_split_extent_at(
>  	}
>  
>  	/*
> -	 * gotp can be null in 2 cases: 1) if there are no extents
> -	 * or 2) split_fsb lies in a hole beyond which there are
> -	 * no extents. Either way, we are done.
> +	 * If there are not extents, or split_fsb lies in a hole we are done.
>  	 */
> -	gotp = xfs_iext_bno_to_ext(ifp, split_fsb, &current_ext);
> -	if (!gotp)
> -		return 0;
> -
> -	xfs_bmbt_get_all(gotp, &got);
> -
> -	/*
> -	 * Check split_fsb lies in a hole or the start boundary offset
> -	 * of the extent.
> -	 */
> -	if (got.br_startoff >= split_fsb)
> +	if (!xfs_iext_lookup_extent(ip, ifp, split_fsb, &current_ext, &got) ||
> +	    got.br_startoff >= split_fsb)
>  		return 0;
>  
>  	gotblkcnt = split_fsb - got.br_startoff;
> @@ -6322,8 +6310,8 @@ xfs_bmap_split_extent_at(
>  		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, del_cursor);
>  	}
>  
> -	xfs_bmbt_set_blockcount(gotp, gotblkcnt);
>  	got.br_blockcount = gotblkcnt;
> +	xfs_iext_update_extent(ifp, current_ext, &got);
>  
>  	logflags = XFS_ILOG_CORE;
>  	if (cur) {
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
