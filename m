Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46412 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbdFSMHK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jun 2017 08:07:10 -0400
Date: Mon, 19 Jun 2017 08:07:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 07/13] xfs: check if an inode is cached and allocated
Message-ID: <20170619120708.GA25516@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643868294.23065.8094890990886436794.stgit@birch.djwong.org>
 <20170616175932.GF5421@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170616175932.GF5421@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 16, 2017 at 10:59:32AM -0700, Darrick J. Wong wrote:
> Check the inode cache for a particular inode number.  If it's in the
> cache, check that it's not currently being reclaimed.  If it's not being
> reclaimed, return zero if the inode is allocated.  This function will be
> used by various scrubbers to decide if the cache is more up to date
> than the disk in terms of checking if an inode is allocated.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: plumb in an opportunistic "get it from the cache" flag to _iget
>     and refactor the helper to use it.
> ---
>  fs/xfs/xfs_icache.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_icache.h |    4 ++++
>  2 files changed, 54 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index f61c84f8..45845b7 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -369,6 +369,11 @@ xfs_iget_cache_hit(
>  	if (ip->i_flags & XFS_IRECLAIMABLE) {
>  		trace_xfs_iget_reclaim(ip);
>  
> +		if (flags & XFS_IGET_INCORE) {
> +			error = -EAGAIN;
> +			goto out_error;
> +		}
> +
>  		/*
>  		 * We need to set XFS_IRECLAIM to prevent xfs_reclaim_inode
>  		 * from stomping over us while we recycle the inode.  We can't
> @@ -433,7 +438,8 @@ xfs_iget_cache_hit(
>  	if (lock_flags != 0)
>  		xfs_ilock(ip, lock_flags);
>  
> -	xfs_iflags_clear(ip, XFS_ISTALE | XFS_IDONTCACHE);
> +	if (!(flags & XFS_IGET_INCORE))
> +		xfs_iflags_clear(ip, XFS_ISTALE | XFS_IDONTCACHE);
>  	XFS_STATS_INC(mp, xs_ig_found);
>  
>  	return 0;
> @@ -604,6 +610,10 @@ xfs_iget(

It might be a good idea to check (or assert) that _IGET_INCORE isn't
specified with any other flags that don't make sense. Otherwise this
looks good to me, thanks...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  			goto out_error_or_again;
>  	} else {
>  		rcu_read_unlock();
> +		if (flags & XFS_IGET_INCORE) {
> +			error = -ENOENT;
> +			goto out_error_or_again;
> +		}
>  		XFS_STATS_INC(mp, xs_ig_missed);
>  
>  		error = xfs_iget_cache_miss(mp, pag, tp, ino, &ip,
> @@ -624,7 +634,7 @@ xfs_iget(
>  	return 0;
>  
>  out_error_or_again:
> -	if (error == -EAGAIN) {
> +	if (!(flags & XFS_IGET_INCORE) && error == -EAGAIN) {
>  		delay(1);
>  		goto again;
>  	}
> @@ -633,6 +643,44 @@ xfs_iget(
>  }
>  
>  /*
> + * "Is this a cached inode that's also allocated?"
> + *
> + * Look up an inode by number in the given file system.  If the inode is
> + * in cache and isn't in purgatory, return 1 if the inode is allocated
> + * and 0 if it is not.  For all other cases (not in cache, being torn
> + * down, etc.), return a negative error code.
> + *
> + * The caller has to prevent inode allocation and freeing activity,
> + * presumably by locking the AGI buffer.   This is to ensure that an
> + * inode cannot transition from allocated to freed until the caller is
> + * ready to allow that.  If the inode is in an intermediate state (new,
> + * reclaimable, or being reclaimed), -EAGAIN will be returned; if the
> + * inode is not in the cache, -ENOENT will be returned.  The caller must
> + * deal with these scenarios appropriately.
> + *
> + * This is a specialized use case for the online scrubber; if you're
> + * reading this, you probably want xfs_iget.
> + */
> +int
> +xfs_icache_inode_is_allocated(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_ino_t		ino,
> +	bool			*inuse)
> +{
> +	struct xfs_inode	*ip;
> +	int			error;
> +
> +	error = xfs_iget(mp, tp, ino, XFS_IGET_INCORE, 0, &ip);
> +	if (error)
> +		return error;
> +
> +	*inuse = !!(VFS_I(ip)->i_mode);
> +	IRELE(ip);
> +	return 0;
> +}
> +
> +/*
>   * The inode lookup is done in batches to keep the amount of lock traffic and
>   * radix tree lookups to a minimum. The batch size is a trade off between
>   * lookup reduction and stack usage. This is in the reclaim path, so we can't
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 9183f77..bff4d85 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -47,6 +47,7 @@ struct xfs_eofblocks {
>  #define XFS_IGET_CREATE		0x1
>  #define XFS_IGET_UNTRUSTED	0x2
>  #define XFS_IGET_DONTCACHE	0x4
> +#define XFS_IGET_INCORE		0x8	/* don't read from disk or reinit */
>  
>  /*
>   * flags for AG inode iterator
> @@ -126,4 +127,7 @@ xfs_fs_eofblocks_from_user(
>  	return 0;
>  }
>  
> +int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
> +				  xfs_ino_t ino, bool *inuse);
> +
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
