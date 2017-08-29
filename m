Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38454 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdH2Sly (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 14:41:54 -0400
Date: Tue, 29 Aug 2017 11:41:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/8] xfs: use xfs_iext_get_extent in xfs_bmap_first_unused
Message-ID: <20170829184148.GX4757@magnolia>
References: <20170829174835.2218-1-hch@lst.de>
 <20170829174835.2218-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829174835.2218-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

This probably ought to have a justification in the changelog, such as
"Use the bmap abstraction instead of open-coding bmbt details here."

Code otherwise looks ok.

--D

On Tue, Aug 29, 2017 at 07:48:30PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index bbde43c99323..c944987c485d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1359,7 +1359,6 @@ xfs_bmap_first_unused(
>  	xfs_fileoff_t	lastaddr;		/* last block number seen */
>  	xfs_fileoff_t	lowest;			/* lowest useful block */
>  	xfs_fileoff_t	max;			/* starting useful block */
> -	xfs_fileoff_t	off;			/* offset for this block */
>  	xfs_extnum_t	nextents;		/* number of extent entries */
>  
>  	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE ||
> @@ -1376,16 +1375,19 @@ xfs_bmap_first_unused(
>  	lowest = *first_unused;
>  	nextents = xfs_iext_count(ifp);
>  	for (idx = 0, lastaddr = 0, max = lowest; idx < nextents; idx++) {
> -		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, idx);
> -		off = xfs_bmbt_get_startoff(ep);
> +		struct xfs_bmbt_irec got;
> +
> +		xfs_iext_get_extent(ifp, idx, &got);
> +
>  		/*
>  		 * See if the hole before this extent will work.
>  		 */
> -		if (off >= lowest + len && off - max >= len) {
> +		if (got.br_startoff >= lowest + len &&
> +		    got.br_startoff - max >= len) {
>  			*first_unused = max;
>  			return 0;
>  		}
> -		lastaddr = off + xfs_bmbt_get_blockcount(ep);
> +		lastaddr = got.br_startoff + got.br_blockcount;
>  		max = XFS_FILEOFF_MAX(lastaddr, lowest);
>  	}
>  	*first_unused = max;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
