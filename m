Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:40029 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751034AbdJLFZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 01:25:40 -0400
Date: Thu, 12 Oct 2017 16:25:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/30] xfs: return a distinct error code value for
 IGET_INCORE cache misses
Message-ID: <20171012052537.GP15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777244964.1724.18204520366062829583.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777244964.1724.18204520366062829583.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Wed, Oct 11, 2017 at 06:40:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> For an XFS_IGET_INCORE iget operation, if the inode isn't in the cache,
> return ENODATA so that we don't confuse it with the pre-existing ENOENT
> cases (inode is in cache, but freed).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> ---
>  fs/xfs/xfs_icache.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 3422711..43005fb 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -610,7 +610,7 @@ xfs_iget(
>  	} else {
>  		rcu_read_unlock();
>  		if (flags & XFS_IGET_INCORE) {
> -			error = -ENOENT;
> +			error = -ENODATA;
>  			goto out_error_or_again;
>  		}
>  		XFS_STATS_INC(mp, xs_ig_missed);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com
