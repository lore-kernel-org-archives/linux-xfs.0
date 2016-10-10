Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:40547 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751061AbcJJFhn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 01:37:43 -0400
Date: Mon, 10 Oct 2016 16:37:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: rework refcount cow recovery error handling
Message-ID: <20161010053740.GV9806@dastard>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588164562.12127.10503063159516084342.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147588164562.12127.10503063159516084342.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Fri, Oct 07, 2016 at 04:07:25PM -0700, Darrick J. Wong wrote:
> The error handling in xfs_refcount_recover_cow_leftovers is confused
> and can potentially leak memory, so rework it to release resources
> correctly on error.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |   18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 56bfef1..87f00df 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1643,7 +1643,7 @@ xfs_refcount_recover_cow_leftovers(
>  	error = xfs_btree_query_range(cur, &low, &high,
>  			xfs_refcount_recover_extent, &debris);
>  	if (error)
> -		goto out_error;
> +		goto out_cursor;
>  	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>  	xfs_buf_relse(agbp);
>  
> @@ -1675,26 +1675,22 @@ xfs_refcount_recover_cow_leftovers(
>  
>  		error = xfs_trans_commit(tp);
>  		if (error)
> -			goto out_cancel;
> +			goto out_free;
>  	}
> -	goto out_free;
> +	return 0;

How does the debris list entries get freed in this case?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
