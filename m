Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39794 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbeLVRlx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Dec 2018 12:41:53 -0500
Date: Sat, 22 Dec 2018 09:41:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: reallocate realtime summary cache on growfs
Message-ID: <20181222174147.GG27208@magnolia>
References: <1f6a98905845d1b03cf0aa96539715d29da32034.1545438588.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f6a98905845d1b03cf0aa96539715d29da32034.1545438588.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com

On Fri, Dec 21, 2018 at 04:32:38PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> At mount time, we allocate m_rsum_cache with the number of realtime
> bitmap blocks. However, xfs_growfs_rt() can increase the number of
> realtime bitmap blocks. Using the cache after this happens may access
> out of the bounds of the cache. Fix it by reallocating the cache in this
> case.
> 
> Fixes: 355e3532132b ("xfs: cache minimum realtime summary level")
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Looks ok (though rt growfs seems to have unrelated lurking bugs...),
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> Hi,
> 
> This is a quick for for my previous patch which is queued up for 4.21,
> based on xfs-linux/for-next. This is bad timing with the holidays coming
> up, but growfs on a realtime volume is probably pretty rare :)
> 
> Thanks!
> 
>  fs/xfs/xfs_rtalloc.c | 44 ++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index afe4d29f7ab4..ac0fcdad0c4e 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -861,6 +861,21 @@ xfs_growfs_rt_alloc(
>  	return error;
>  }
>  
> +static void
> +xfs_alloc_rsum_cache(
> +	xfs_mount_t	*mp,		/* file system mount structure */
> +	xfs_extlen_t	rbmblocks)	/* number of rt bitmap blocks */
> +{
> +	/*
> +	 * The rsum cache is initialized to all zeroes, which is trivially a
> +	 * lower bound on the minimum level with any free extents. We can
> +	 * continue without the cache if it couldn't be allocated.
> +	 */
> +	mp->m_rsum_cache = kmem_zalloc_large(rbmblocks, KM_SLEEP);
> +	if (!mp->m_rsum_cache)
> +		xfs_warn(mp, "could not allocate realtime summary cache");
> +}
> +
>  /*
>   * Visible (exported) functions.
>   */
> @@ -889,6 +904,7 @@ xfs_growfs_rt(
>  	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
>  	xfs_sb_t	*sbp;		/* old superblock */
>  	xfs_fsblock_t	sumbno;		/* summary block number */
> +	uint8_t		*rsum_cache;	/* old summary cache */
>  
>  	sbp = &mp->m_sb;
>  	/*
> @@ -945,6 +961,11 @@ xfs_growfs_rt(
>  	error = xfs_growfs_rt_alloc(mp, rsumblocks, nrsumblocks, mp->m_rsumip);
>  	if (error)
>  		return error;
> +
> +	rsum_cache = mp->m_rsum_cache;
> +	if (nrbmblocks != sbp->sb_rbmblocks)
> +		xfs_alloc_rsum_cache(mp, nrbmblocks);
> +
>  	/*
>  	 * Allocate a new (fake) mount/sb.
>  	 */
> @@ -1070,6 +1091,20 @@ xfs_growfs_rt(
>  	 */
>  	kmem_free(nmp);
>  
> +	/*
> +	 * If we had to allocate a new rsum_cache, we either need to free the
> +	 * old one (if we succeeded) or free the new one and restore the old one
> +	 * (if there was an error).
> +	 */
> +	if (rsum_cache != mp->m_rsum_cache) {
> +		if (error) {
> +			kmem_free(mp->m_rsum_cache);
> +			mp->m_rsum_cache = rsum_cache;
> +		} else {
> +			kmem_free(rsum_cache);
> +		}
> +	}
> +
>  	return error;
>  }
>  
> @@ -1217,14 +1252,7 @@ xfs_rtmount_inodes(
>  		return error;
>  	}
>  	ASSERT(mp->m_rsumip != NULL);
> -	/*
> -	 * The rsum cache is initialized to all zeroes, which is trivially a
> -	 * lower bound on the minimum level with any free extents. We can
> -	 * continue without the cache if it couldn't be allocated.
> -	 */
> -	mp->m_rsum_cache = kmem_zalloc_large(sbp->sb_rbmblocks, KM_SLEEP);
> -	if (!mp->m_rsum_cache)
> -		xfs_warn(mp, "could not allocate realtime summary cache");
> +	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
>  	return 0;
>  }
>  
> -- 
> 2.20.1
> 
