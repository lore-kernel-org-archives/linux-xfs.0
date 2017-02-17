Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42811 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753785AbdBQBL1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2017 20:11:27 -0500
Date: Thu, 16 Feb 2017 17:11:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: tune down agno asserts in the bmap code
Message-ID: <20170217011117.GK6813@birch.djwong.org>
References: <20170216211035.4206-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170216211035.4206-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 16, 2017 at 10:10:35PM +0100, Christoph Hellwig wrote:
> In various places we currently assert that xfs_bmap_btalloc allocates
> from the same as the firstblock value passed in, unless it's either
> NULLAGNO or the dop_low flag is set.  But the reflink code does not
> fully follow this convention as it passes in firstblock purely as
> a hint for the allocator without actually having previous allocations

Are you referring to BMAPI_REMAP?  In that case *firstblock isn't a
hint, it's the new physical location of the extent.

> in the transaction, and without having a minleft check on the current
> AG, leading to the assert firing on a very full and heavily used
> file system.  As even the reflink code only allocates from equal or
> higher AGs for now we can simply the check to always allow for equal
> or higher AGs.
> 
> Note that we need to eventually split the two meanings of the firstblock
> value.  At that point we can also allow the reflink code to allocate
> from any AG instead of limiting it in any way.

...but you're correct that we probably ought to disambiguate the two.

For now,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

By the way, was it your intent to push this series into 4.11?

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 22 ++++++----------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index bfc00de5c6f1..2e79f4cc9a8e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -804,9 +804,7 @@ xfs_bmap_extents_to_btree(
>  	 */
>  	ASSERT(args.fsbno != NULLFSBLOCK);
>  	ASSERT(*firstblock == NULLFSBLOCK ||
> -	       args.agno == XFS_FSB_TO_AGNO(mp, *firstblock) ||
> -	       (dfops->dop_low &&
> -		args.agno > XFS_FSB_TO_AGNO(mp, *firstblock)));
> +	       args.agno >= XFS_FSB_TO_AGNO(mp, *firstblock));
>  	*firstblock = cur->bc_private.b.firstblock = args.fsbno;
>  	cur->bc_private.b.allocated++;
>  	ip->i_d.di_nblocks++;
> @@ -3822,17 +3820,13 @@ xfs_bmap_btalloc(
>  		 * the first block that was allocated.
>  		 */
>  		ASSERT(*ap->firstblock == NULLFSBLOCK ||
> -		       XFS_FSB_TO_AGNO(mp, *ap->firstblock) ==
> -		       XFS_FSB_TO_AGNO(mp, args.fsbno) ||
> -		       (ap->dfops->dop_low &&
> -			XFS_FSB_TO_AGNO(mp, *ap->firstblock) <
> -			XFS_FSB_TO_AGNO(mp, args.fsbno)));
> +		       XFS_FSB_TO_AGNO(mp, *ap->firstblock) <=
> +		       XFS_FSB_TO_AGNO(mp, args.fsbno));
>  
>  		ap->blkno = args.fsbno;
>  		if (*ap->firstblock == NULLFSBLOCK)
>  			*ap->firstblock = args.fsbno;
> -		ASSERT(nullfb || fb_agno == args.agno ||
> -		       (ap->dfops->dop_low && fb_agno < args.agno));
> +		ASSERT(nullfb || fb_agno <= args.agno);
>  		ap->length = args.len;
>  		if (!(ap->flags & XFS_BMAPI_COWFORK))
>  			ap->ip->i_d.di_nblocks += args.len;
> @@ -4746,13 +4740,9 @@ xfs_bmapi_write(
>  	if (bma.cur) {
>  		if (!error) {
>  			ASSERT(*firstblock == NULLFSBLOCK ||
> -			       XFS_FSB_TO_AGNO(mp, *firstblock) ==
> +			       XFS_FSB_TO_AGNO(mp, *firstblock) <=
>  			       XFS_FSB_TO_AGNO(mp,
> -				       bma.cur->bc_private.b.firstblock) ||
> -			       (dfops->dop_low &&
> -				XFS_FSB_TO_AGNO(mp, *firstblock) <
> -				XFS_FSB_TO_AGNO(mp,
> -					bma.cur->bc_private.b.firstblock)));
> +				       bma.cur->bc_private.b.firstblock));
>  			*firstblock = bma.cur->bc_private.b.firstblock;
>  		}
>  		xfs_btree_del_cursor(bma.cur,
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
