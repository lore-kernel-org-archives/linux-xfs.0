Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:8455 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751312AbeDEXH0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 19:07:26 -0400
Date: Fri, 6 Apr 2018 09:07:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/21] xfs: add BMAPI_NORMAP flag to perform block
 remapping without updating rmapbt
Message-ID: <20180405230722.GJ23861@dastard>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
 <152269900729.16346.3322708934701882860.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152269900729.16346.3322708934701882860.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 02, 2018 at 12:56:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new flag, XFS_BMAPI_NORMAP, which will perform file block
> remapping without updating the rmapbt.  This will be used by the repair
> code to reconstruct bmbts from the rmapbt, in which case we don't want
> the rmapbt update.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |   25 ++++++++++++++++---------
>  fs/xfs/libxfs/xfs_bmap.h |    6 +++++-
>  2 files changed, 21 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 3b03d88..519ef9c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1998,9 +1998,12 @@ xfs_bmap_add_extent_delay_real(
>  	}
>  
>  	/* add reverse mapping */
> -	error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip, whichfork, new);
> -	if (error)
> -		goto done;
> +	if (!(bma->flags & XFS_BMAPI_NORMAP)) {
> +		error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip,
> +				whichfork, new);
> +		if (error)
> +			goto done;
> +	}

Double negatives are a bit hard to parse (not NORMAP) but I don't
have a better idea for this.

....

> @@ -4119,7 +4125,8 @@ xfs_bmapi_allocate(
>  	else
>  		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
>  				whichfork, &bma->icur, &bma->cur, &bma->got,
> -				bma->firstblock, bma->dfops, &bma->logflags);
> +				bma->firstblock, bma->dfops, &bma->logflags,
> +				bma->flags);

Ob: The number of function parameters is starting to get out of hand
again :/

Regardless,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
