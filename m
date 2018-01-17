Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35885 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750811AbeAQAda (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 19:33:30 -0500
Date: Wed, 17 Jan 2018 11:33:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: check that br_blockcount doesn't overflow
Message-ID: <20180117003304.GB6304@dastard>
References: <20180116233415.GH5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116233415.GH5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 16, 2018 at 03:34:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_bmbt_irec.br_blockcount is declared as xfs_filblks_t, which is an
> unsigned 64-bit integer.  Though the bmbt helpers will never set a value
> larger than 2^21 (since the underlying on-disk extent record has a
> length field that is only 21 bits wide), we should be a little defensive
> about checking that a bmbt record doesn't exceed what we're expecting or
> overflow into the next AG.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/bmap.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 3a815db..fa64bd4 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -348,6 +348,7 @@ xfs_scrub_bmap_extent(
>  {
>  	struct xfs_mount		*mp = info->sc->mp;
>  	struct xfs_buf			*bp = NULL;
> +	xfs_filblks_t			end;
>  	int				error = 0;
>  
>  	if (cur)
> @@ -375,19 +376,23 @@ xfs_scrub_bmap_extent(
>  				irec->br_startoff);
>  
>  	/* Make sure the extent points to a valid place. */
> +	if (irec->br_blockcount > MAXEXTLEN)
> +		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
> +				irec->br_startoff);
>  	if (irec->br_startblock + irec->br_blockcount <= irec->br_startblock)
>  		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
>  				irec->br_startoff);
> +	end = irec->br_startblock + irec->br_blockcount - 1;
>  	if (info->is_rt &&
>  	    (!xfs_verify_rtbno(mp, irec->br_startblock) ||
> -	     !xfs_verify_rtbno(mp, irec->br_startblock +
> -				irec->br_blockcount - 1)))
> +	     !xfs_verify_rtbno(mp, end)))
>  		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
>  				irec->br_startoff);
>  	if (!info->is_rt &&
>  	    (!xfs_verify_fsbno(mp, irec->br_startblock) ||
> -	     !xfs_verify_fsbno(mp, irec->br_startblock +
> -				irec->br_blockcount - 1)))
> +	     !xfs_verify_fsbno(mp, end) ||
> +	     XFS_FSB_TO_AGNO(mp, irec->br_startblock) !=
> +	     XFS_FSB_TO_AGNO(mp, end)))

Indent that last part of the check so it's clear the two lines are a
single logic statement:

	     XFS_FSB_TO_AGNO(mp, irec->br_startblock) !=
				XFS_FSB_TO_AGNO(mp, end)))

Otherwise it looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
