Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17988 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbdDKWOy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 18:14:54 -0400
Date: Tue, 11 Apr 2017 15:14:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] xfs: remove attr fork handling in xfs_bmap_finish_one
Message-ID: <20170411221448.GD8502@birch.djwong.org>
References: <20170411111011.9437-1-hch@lst.de>
 <20170411111011.9437-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170411111011.9437-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2017 at 01:10:07PM +0200, Christoph Hellwig wrote:
> We never do COW operations for the attr fork, so don't pretend we handle
> them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 2a426d127e05..b95e66fd0935 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6491,7 +6491,6 @@ xfs_bmap_finish_one(
>  	struct xfs_bmbt_irec		bmap;
>  	int				nimaps = 1;
>  	xfs_fsblock_t			firstfsb;
> -	int				flags = XFS_BMAPI_REMAP;
>  	int				done;
>  	int				error = 0;
>  
> @@ -6505,10 +6504,8 @@ xfs_bmap_finish_one(
>  			XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
>  			ip->i_ino, whichfork, startoff, blockcount, state);
>  
> -	if (whichfork != XFS_DATA_FORK && whichfork != XFS_ATTR_FORK)
> +	if (WARN_ON_ONCE(whichfork != XFS_DATA_FORK))
>  		return -EFSCORRUPTED;
> -	if (whichfork == XFS_ATTR_FORK)
> -		flags |= XFS_BMAPI_ATTRFORK;
>  
>  	if (XFS_TEST_ERROR(false, tp->t_mountp,
>  			XFS_ERRTAG_BMAP_FINISH_ONE,
> @@ -6519,13 +6516,13 @@ xfs_bmap_finish_one(
>  	case XFS_BMAP_MAP:
>  		firstfsb = bmap.br_startblock;
>  		error = xfs_bmapi_write(tp, ip, bmap.br_startoff,
> -					bmap.br_blockcount, flags, &firstfsb,
> +					bmap.br_blockcount, XFS_BMAPI_REMAP, &firstfsb,
>  					bmap.br_blockcount, &bmap, &nimaps,
>  					dfops);
>  		break;
>  	case XFS_BMAP_UNMAP:
>  		error = xfs_bunmapi(tp, ip, bmap.br_startoff,
> -				bmap.br_blockcount, flags, 1, &firstfsb,
> +				bmap.br_blockcount, XFS_BMAPI_REMAP, 1, &firstfsb,
>  				dfops, &done);
>  		ASSERT(done);
>  		break;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
