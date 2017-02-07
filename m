Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19396 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751694AbdBGBOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2017 20:14:42 -0500
Date: Mon, 6 Feb 2017 17:14:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: handle indlen shortage on delalloc extent merge
Message-ID: <20170207011432.GB12378@birch.djwong.org>
References: <1486146865-47286-1-git-send-email-bfoster@redhat.com>
 <1486146865-47286-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486146865-47286-2-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Patrick Dung <mpatdung@gmail.com>

On Fri, Feb 03, 2017 at 01:34:24PM -0500, Brian Foster wrote:
> When a delalloc extent is created, it can be merged with pre-existing,
> contiguous, delalloc extents. When this occurs,
> xfs_bmap_add_extent_hole_delay() merges the extents along with the
> associated indirect block reservations. The expectation here is that the
> combined worst case indlen reservation is always less than or equal to
> the indlen reservation for the individual extents.
> 
> This is not always the case, however, as existing extents can less than
> the expected indlen reservation if the extent was previously split due
> to a hole punch. If a new extent merges with such an extent, the total
> indlen requirement may be larger than the sum of the indlen reservations
> held by both extents.
> 
> xfs_bmap_add_extent_hole_delay() assumes that the worst case indlen
> reservation is always available and assigns it to the merged extent
> without consideration for the indlen held by the pre-existing extent. As
> a result, the subsequent xfs_mod_fdblocks() call can attempt an
> unintentional allocation rather than a free (indicated by an ASSERT()
> failure). Further, if the allocation happens to fail in this context,
> the failure goes unhandled and creates a filesystem wide block
> accounting inconsistency.
> 
> Fix xfs_bmap_add_extent_hole_delay() to function as designed. Cap the
> indlen reservation assigned to the merged extent to the sum of the
> indlen reservations held by each of the individual extents.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index bfc00de..d2e48ed 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -2809,7 +2809,8 @@ xfs_bmap_add_extent_hole_delay(
>  		oldlen = startblockval(left.br_startblock) +
>  			startblockval(new->br_startblock) +
>  			startblockval(right.br_startblock);
> -		newlen = xfs_bmap_worst_indlen(ip, temp);
> +		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
> +					 oldlen);
>  		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, *idx),
>  			nullstartblock((int)newlen));
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
> @@ -2830,7 +2831,8 @@ xfs_bmap_add_extent_hole_delay(
>  		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx), temp);
>  		oldlen = startblockval(left.br_startblock) +
>  			startblockval(new->br_startblock);
> -		newlen = xfs_bmap_worst_indlen(ip, temp);
> +		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
> +					 oldlen);
>  		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, *idx),
>  			nullstartblock((int)newlen));
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
> @@ -2846,7 +2848,8 @@ xfs_bmap_add_extent_hole_delay(
>  		temp = new->br_blockcount + right.br_blockcount;
>  		oldlen = startblockval(new->br_startblock) +
>  			startblockval(right.br_startblock);
> -		newlen = xfs_bmap_worst_indlen(ip, temp);
> +		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
> +					 oldlen);
>  		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx),
>  			new->br_startoff,
>  			nullstartblock((int)newlen), temp, right.br_state);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
