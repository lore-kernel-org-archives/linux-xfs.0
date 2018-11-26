Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbeK0Jxp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Nov 2018 04:53:45 -0500
Date: Mon, 26 Nov 2018 14:57:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3] xfs: cache minimum realtime summary level
Message-ID: <20181126225757.GC6792@magnolia>
References: <95c54025014c6d5d3944924b52637cdc2b50cf4e.1542137269.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95c54025014c6d5d3944924b52637cdc2b50cf4e.1542137269.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com

On Tue, Nov 13, 2018 at 11:28:59AM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The realtime summary is a two-dimensional array on disk, effectively:
> 
> u32 rsum[log2(number of realtime extents) + 1][number of blocks in the bitmap]
> 
> rsum[log][bbno] is the number of extents of size 2**log which start in
> bitmap block bbno.
> 
> xfs_rtallocate_extent_near() uses xfs_rtany_summary() to check whether
> rsum[log][bbno] != 0 for any log level. However, the summary array is
> stored in row-major order (i.e., like an array in C), so all of these
> entries are not adjacent, but rather spread across the entire summary
> file. In the worst case (a full bitmap block), xfs_rtany_summary() has
> to check every level.
> 
> This means that on a moderately-used realtime device, an allocation will
> waste a lot of time finding, reading, and releasing buffers for the
> realtime summary. In particular, one of our storage services (which runs
> on servers with 8 very slow CPUs and 15 8 TB XFS realtime filesystems)
> spends almost 5% of its CPU cycles in xfs_rtbuf_get() and
> xfs_trans_brelse() called from xfs_rtany_summary().
> 
> One solution would be to also store the summary with the dimensions
> swapped. However, this would require a disk format change to a very old
> component of XFS.
> 
> Instead, we can cache the minimum size which contains any extents. We do
> so lazily; rather than guaranteeing that the cache contains the precise
> minimum, it always contains a loose lower bound which we tighten when we
> read or update a summary block. This only uses a few kilobytes of memory
> and is already serialized via the realtime bitmap and summary inode
> locks, so the cost is minimal. With this change, the same workload only
> spends 0.2% of its CPU cycles in the realtime allocator.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Looks good, will put this in my tree for 4.21/5.0.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> Based on Linus' master branch.
> 
> Changes from v2:
> - Allow the cache allocation to fail, in which case we just don't use it
> 
> Changes from v1:
> - Clarify comment in xfs_rtmount_inodes().
> - Use kmem_* instead of kvmalloc/kvfree
> 
>  fs/xfs/libxfs/xfs_rtbitmap.c |  6 ++++++
>  fs/xfs/xfs_mount.h           |  7 +++++++
>  fs/xfs/xfs_rtalloc.c         | 25 +++++++++++++++++++++----
>  3 files changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index b228c821bae6..eaaff67e9626 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -505,6 +505,12 @@ xfs_rtmodify_summary_int(
>  		uint first = (uint)((char *)sp - (char *)bp->b_addr);
>  
>  		*sp += delta;
> +		if (mp->m_rsum_cache) {
> +			if (*sp == 0 && log == mp->m_rsum_cache[bbno])
> +				mp->m_rsum_cache[bbno]++;
> +			if (*sp != 0 && log < mp->m_rsum_cache[bbno])
> +				mp->m_rsum_cache[bbno] = log;
> +		}
>  		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
>  	}
>  	if (sum)
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 7964513c3128..39f04aca8c3a 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -89,6 +89,13 @@ typedef struct xfs_mount {
>  	int			m_logbsize;	/* size of each log buffer */
>  	uint			m_rsumlevels;	/* rt summary levels */
>  	uint			m_rsumsize;	/* size of rt summary, bytes */
> +	/*
> +	 * Optional cache of rt summary level per bitmap block with the
> +	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
> +	 * rsum[i][bbno] != 0. Reads and writes are serialized by the rsumip
> +	 * inode lock.
> +	 */
> +	uint8_t			*m_rsum_cache;
>  	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
>  	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
>  	struct xfs_inode	*m_rootip;	/* pointer to root directory */
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 926ed314ffba..aefd63d46397 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -64,8 +64,12 @@ xfs_rtany_summary(
>  	int		log;		/* loop counter, log2 of ext. size */
>  	xfs_suminfo_t	sum;		/* summary data */
>  
> +	/* There are no extents at levels < m_rsum_cache[bbno]. */
> +	if (mp->m_rsum_cache && low < mp->m_rsum_cache[bbno])
> +		low = mp->m_rsum_cache[bbno];
> +
>  	/*
> -	 * Loop over logs of extent sizes.  Order is irrelevant.
> +	 * Loop over logs of extent sizes.
>  	 */
>  	for (log = low; log <= high; log++) {
>  		/*
> @@ -80,13 +84,17 @@ xfs_rtany_summary(
>  		 */
>  		if (sum) {
>  			*stat = 1;
> -			return 0;
> +			goto out;
>  		}
>  	}
>  	/*
>  	 * Found nothing, return failure.
>  	 */
>  	*stat = 0;
> +out:
> +	/* There were no extents at levels < log. */
> +	if (mp->m_rsum_cache && log > mp->m_rsum_cache[bbno])
> +		mp->m_rsum_cache[bbno] = log;
>  	return 0;
>  }
>  
> @@ -1187,8 +1195,8 @@ xfs_rtmount_init(
>  }
>  
>  /*
> - * Get the bitmap and summary inodes into the mount structure
> - * at mount time.
> + * Get the bitmap and summary inodes and the summary cache into the mount
> + * structure at mount time.
>   */
>  int					/* error */
>  xfs_rtmount_inodes(
> @@ -1211,6 +1219,14 @@ xfs_rtmount_inodes(
>  		return error;
>  	}
>  	ASSERT(mp->m_rsumip != NULL);
> +	/*
> +	 * The rsum cache is initialized to all zeroes, which is trivially a
> +	 * lower bound on the minimum level with any free extents. We can
> +	 * continue without the cache if it couldn't be allocated.
> +	 */
> +	mp->m_rsum_cache = kmem_zalloc_large(sbp->sb_rbmblocks, KM_SLEEP);
> +	if (!mp->m_rsum_cache)
> +		xfs_warn(mp, "could not allocate realtime summary cache");
>  	return 0;
>  }
>  
> @@ -1218,6 +1234,7 @@ void
>  xfs_rtunmount_inodes(
>  	struct xfs_mount	*mp)
>  {
> +	kmem_free(mp->m_rsum_cache);
>  	if (mp->m_rbmip)
>  		xfs_irele(mp->m_rbmip);
>  	if (mp->m_rsumip)
> -- 
> 2.19.1
> 
