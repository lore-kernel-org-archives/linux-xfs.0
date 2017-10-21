Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39398 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752858AbdJUAZ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 20:25:59 -0400
Date: Fri, 20 Oct 2017 17:25:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/15] xfs: update got in xfs_bmap_shift_update_extent
Message-ID: <20171021002555.GF4755@magnolia>
References: <20171019065942.18813-1-hch@lst.de>
 <20171019065942.18813-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019065942.18813-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2017 at 08:59:39AM +0200, Christoph Hellwig wrote:
> This way the caller gets the proper updated extent returned in got.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 703596caf255..2de9458903b6 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5580,35 +5580,33 @@ xfs_bmap_shift_update_extent(
>  	xfs_fileoff_t		startoff)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_bmbt_irec	new;
> +	struct xfs_bmbt_irec	prev = *got;
>  	int			error, i;
>  
>  	*logflags |= XFS_ILOG_CORE;
>  
> -	new = *got;
> -	new.br_startoff = startoff;
> +	got->br_startoff = startoff;
>  
>  	if (cur) {
> -		error = xfs_bmbt_lookup_eq(cur, got, &i);
> +		error = xfs_bmbt_lookup_eq(cur, &prev, &i);
>  		if (error)
>  			return error;
>  		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
>  
> -		error = xfs_bmbt_update(cur, &new);
> +		error = xfs_bmbt_update(cur, got);
>  		if (error)
>  			return error;
>  	} else {
>  		*logflags |= XFS_ILOG_DEXT;
>  	}
>  
> -	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork), idx,
> -			&new);
> +	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork), idx, got);
>  
>  	/* update reverse mapping */
> -	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
> +	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, &prev);
>  	if (error)
>  		return error;
> -	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, &new);
> +	return xfs_rmap_map_extent(mp, dfops, ip, whichfork, got);
>  }
>  
>  int
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
