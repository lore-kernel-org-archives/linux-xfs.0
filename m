Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750813AbcKQTHu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Nov 2016 14:07:50 -0500
Date: Thu, 17 Nov 2016 14:07:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/14] xfs: cleanup xfs_reflink_find_cow_mapping
Message-ID: <20161117190722.GK49658@bfoster.bfoster>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
 <1479143565-30615-10-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479143565-30615-10-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 14, 2016 at 06:12:40PM +0100, Christoph Hellwig wrote:
> Use xfs_iext_lookup_extent to look up the extent, drop a useless check,
> drop a unneeded return value and clean up the general style a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c    | 16 ++++++++--------
>  fs/xfs/xfs_reflink.c | 30 +++++++++---------------------
>  fs/xfs/xfs_reflink.h |  2 +-
>  3 files changed, 18 insertions(+), 30 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 35e02ce..6056fd1 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -427,37 +427,25 @@ bool
>  xfs_reflink_find_cow_mapping(
>  	struct xfs_inode		*ip,
>  	xfs_off_t			offset,
> -	struct xfs_bmbt_irec		*imap,
> -	bool				*need_alloc)
> +	struct xfs_bmbt_irec		*imap)

The comment above the function needs fixing as well. Otherwise:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  {
> -	struct xfs_bmbt_irec		irec;
> -	struct xfs_ifork		*ifp;
> -	struct xfs_bmbt_rec_host	*gotp;
> -	xfs_fileoff_t			bno;
> +	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> +	xfs_fileoff_t			offset_fsb;
> +	struct xfs_bmbt_irec		got;
>  	xfs_extnum_t			idx;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
>  	ASSERT(xfs_is_reflink_inode(ip));
>  
> -	/* Find the extent in the CoW fork. */
> -	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> -	bno = XFS_B_TO_FSBT(ip->i_mount, offset);
> -	gotp = xfs_iext_bno_to_ext(ifp, bno, &idx);
> -	if (!gotp)
> +	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
> +	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got))
>  		return false;
> -
> -	xfs_bmbt_get_all(gotp, &irec);
> -	if (bno >= irec.br_startoff + irec.br_blockcount ||
> -	    bno < irec.br_startoff)
> +	if (got.br_startoff > offset_fsb)
>  		return false;
>  
>  	trace_xfs_reflink_find_cow_mapping(ip, offset, 1, XFS_IO_OVERWRITE,
> -			&irec);
> -
> -	/* If it's still delalloc, we must allocate later. */
> -	*imap = irec;
> -	*need_alloc = !!(isnullstartblock(irec.br_startblock));
> -
> +			&got);
> +	*imap = got;
>  	return true;
>  }
>  
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 97ea9b4..cff5fc3 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -31,7 +31,7 @@ extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
>  extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip,
>  		xfs_off_t offset, xfs_off_t count);
>  extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
> -		struct xfs_bmbt_irec *imap, bool *need_alloc);
> +		struct xfs_bmbt_irec *imap);
>  extern int xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
>  		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap);
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
