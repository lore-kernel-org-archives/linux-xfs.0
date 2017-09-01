Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47789 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdIAQBl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 12:01:41 -0400
Date: Fri, 1 Sep 2017 09:01:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: ASSERT should always evaluate its parameter
Message-ID: <20170901160109.GB3775@magnolia>
References: <20170901155733.GA3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901155733.GA3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>

On Fri, Sep 01, 2017 at 08:57:33AM -0700, Darrick J. Wong wrote:
> Ensure that ASSERT evalulates its expression argument so that we don't
> get a ton of compiler warnings in non-warn non-debug mode.  Fix up
> everything that breaks as a result.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c      |    2 +-
>  fs/xfs/libxfs/xfs_dir2_node.c |    2 --
>  fs/xfs/xfs_inode.c            |    8 ++++++++
>  fs/xfs/xfs_linux.h            |    3 ++-
>  fs/xfs/xfs_trans.c            |    2 ++
>  5 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9558f5e..883a626 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -579,7 +579,7 @@ xfs_bmap_validate_ret(
>  
>  #else
>  #define xfs_bmap_check_leaf_extents(cur, ip, whichfork)		do { } while (0)
> -#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)
> +#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)	((void)0)
>  #endif /* DEBUG */
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 682e2bf..e57a80b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1005,9 +1005,7 @@ xfs_dir2_leafn_rebalance(
>  	xfs_dir2_leaf_t		*leaf1;		/* first leaf structure */
>  	xfs_dir2_leaf_t		*leaf2;		/* second leaf structure */
>  	int			mid;		/* midpoint leaf index */
> -#if defined(DEBUG) || defined(XFS_WARN)
>  	int			oldstale;	/* old count of stale leaves */
> -#endif
>  	int			oldsum;		/* old total leaf count */
>  	int			swap;		/* swapped leaf blocks */
>  	struct xfs_dir2_leaf_entry *ents1;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5599dda..0eaf1f1 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -382,6 +382,14 @@ xfs_isilocked(
>  	ASSERT(0);
>  	return 0;
>  }
> +#else
> +int
> +xfs_isilocked(
> +	xfs_inode_t		*ip,
> +	uint			lock_flags)
> +{
> +	return 0;
> +}

Bah, this doesn't work, never mind.  Kill this whole patch.

/me goes back for another cup of coffee.

--D

>  #endif
>  
>  #ifdef DEBUG
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index c19c999..7c69f08 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -260,7 +260,8 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
>  
>  #else	/* !DEBUG && !XFS_WARN */
>  
> -#define ASSERT(expr)	((void)0)
> +#define ASSERT(expr)	\
> +	(likely(expr) ? (void)0 : (void)0)
>  
>  #ifndef STATIC
>  # define STATIC static noinline
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index a87f657..45e30ba 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -421,9 +421,11 @@ xfs_trans_apply_sb_deltas(
>  	/*
>  	 * Check that superblock mods match the mods made to AGF counters.
>  	 */
> +#if defined(DEBUG) || defined(XFS_WARN)
>  	ASSERT((tp->t_fdblocks_delta + tp->t_res_fdblocks_delta) ==
>  	       (tp->t_ag_freeblks_delta + tp->t_ag_flist_delta +
>  		tp->t_ag_btree_delta));
> +#endif
>  
>  	/*
>  	 * Only update the superblock counters if we are logging them
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
