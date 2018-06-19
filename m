Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58290 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752308AbeFSFak (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 01:30:40 -0400
Date: Mon, 18 Jun 2018 22:30:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/24] xfs: remove xfs_reflink_trim_irec_to_next_cow
Message-ID: <20180619053035.GS8128@magnolia>
References: <20180615130209.1970-1-hch@lst.de>
 <20180615130209.1970-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615130209.1970-11-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Jun 15, 2018 at 03:01:55PM +0200, Christoph Hellwig wrote:
> We already have to check for overlapping COW extents everytime we
> come back to a page in xfs_writepage_map / xfs_map_cow, so this
> additional trim is not required.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c    |  7 -------
>  fs/xfs/xfs_reflink.c | 33 ---------------------------------
>  fs/xfs/xfs_reflink.h |  2 --
>  fs/xfs/xfs_trace.h   |  1 -
>  4 files changed, 43 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 39b933e17192..c8fc6786b06c 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -416,13 +416,6 @@ xfs_map_blocks(
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
>  				imap, &nimaps, XFS_BMAPI_ENTIRE);
> -	/*
> -	 * Truncate an overwrite extent if there's a pending CoW
> -	 * reservation before the end of this extent.  This forces us
> -	 * to come back to writepage to take care of the CoW.
> -	 */
> -	if (nimaps && type == XFS_IO_OVERWRITE)
> -		xfs_reflink_trim_irec_to_next_cow(ip, offset_fsb, imap);
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  
>  	if (error)
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 713e857d9ffa..d0092c864458 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -514,39 +514,6 @@ xfs_reflink_find_cow_mapping(
>  	return true;
>  }
>  
> -/*
> - * Trim an extent to end at the next CoW reservation past offset_fsb.
> - */
> -void
> -xfs_reflink_trim_irec_to_next_cow(
> -	struct xfs_inode		*ip,
> -	xfs_fileoff_t			offset_fsb,
> -	struct xfs_bmbt_irec		*imap)
> -{
> -	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> -	struct xfs_bmbt_irec		got;
> -	struct xfs_iext_cursor		icur;
> -
> -	if (!xfs_is_reflink_inode(ip))
> -		return;
> -
> -	/* Find the extent in the CoW fork. */
> -	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got))
> -		return;
> -
> -	/* This is the extent before; try sliding up one. */
> -	if (got.br_startoff < offset_fsb) {
> -		if (!xfs_iext_next_extent(ifp, &icur, &got))
> -			return;
> -	}
> -
> -	if (got.br_startoff >= imap->br_startoff + imap->br_blockcount)
> -		return;
> -
> -	imap->br_blockcount = got.br_startoff - imap->br_startoff;
> -	trace_xfs_reflink_trim_irec(ip, imap);
> -}
> -
>  /*
>   * Cancel CoW reservations for some block range of an inode.
>   *
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 701487bab468..c0a25609007b 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -34,8 +34,6 @@ extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t count);
>  extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
>  		struct xfs_bmbt_irec *imap);
> -extern void xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
> -		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap);
>  
>  extern int xfs_reflink_cancel_cow_blocks(struct xfs_inode *ip,
>  		struct xfs_trans **tpp, xfs_fileoff_t offset_fsb,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 9d4c4ca24fe6..041045a8d65c 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3228,7 +3228,6 @@ DEFINE_RW_EVENT(xfs_reflink_reserve_cow);
>  
>  DEFINE_SIMPLE_IO_EVENT(xfs_reflink_bounce_dio_write);
>  DEFINE_IOMAP_EVENT(xfs_reflink_find_cow_mapping);
> -DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_irec);
>  
>  DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
>  DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
