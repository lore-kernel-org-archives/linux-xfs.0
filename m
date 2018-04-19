Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752118AbeDSM4I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Apr 2018 08:56:08 -0400
Date: Thu, 19 Apr 2018 08:56:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/11] xfs: avoid ABBA deadlock when scrubbing parent
 pointers
Message-ID: <20180419125606.GE25844@bfoster.bfoster>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401924456.11465.4870308714829350533.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152401924456.11465.4870308714829350533.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 17, 2018 at 07:40:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In normal operation, the XFS convention is to take an inode's iolock
> and then allocate a transaction.  However, when scrubbing parent inodes
> this is inverted -- we allocated the transaction to do the scrub, and
> now we're trying to grab the parent's iolock.  This can lead to ABBA
> deadlocks: some thread grabbed the parent's iolock and is waiting for
> space for a transaction while our parent scrubber is sitting on a
> transaction trying to get the parent's iolock.
> 

Is that really an issue if the scrub transaction doesn't acquire a log
reservation (or does it in certain circumstances)..?

Brian

> Therefore, convert all iolock attempts to use trylock; if that fails,
> they can use the existing mechanisms to back off and try again.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/common.c |   22 ++++++++++++++++++++++
>  fs/xfs/scrub/common.h |    2 ++
>  fs/xfs/scrub/parent.c |   16 ++++++++++++++--
>  3 files changed, 38 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index f5e281a..93f9e7d 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -787,3 +787,25 @@ xfs_scrub_buffer_recheck(
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
>  	trace_xfs_scrub_block_error(sc, bp->b_bn, fa);
>  }
> +
> +/*
> + * Try to lock an inode in violation of the usual locking order rules.  For
> + * example, trying to get the IOLOCK while in transaction context, or just
> + * plain breaking AG-order or inode-order inode locking rules.  Either way,
> + * the only way to avoid an ABBA deadlock is to use trylock and back off if
> + * we can't.
> + */
> +int
> +xfs_scrub_ilock_inverted(
> +	struct xfs_inode	*ip,
> +	uint			lock_mode)
> +{
> +	int			i;
> +
> +	for (i = 0; i < 20; i++) {
> +		if (xfs_ilock_nowait(ip, lock_mode))
> +			return 0;
> +		delay(1);
> +	}
> +	return -EDEADLOCK;
> +}
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index 8296873..191c369 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -151,4 +151,6 @@ static inline bool xfs_scrub_found_corruption(struct xfs_scrub_metadata *sm)
>  			       XFS_SCRUB_OFLAG_XCORRUPT);
>  }
>  
> +int xfs_scrub_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
> +
>  #endif	/* __XFS_SCRUB_COMMON_H__ */
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index 1fb88c1..19cd54d 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -211,7 +211,9 @@ xfs_scrub_parent_validate(
>  	 */
>  	xfs_iunlock(sc->ip, sc->ilock_flags);
>  	sc->ilock_flags = 0;
> -	xfs_ilock(dp, XFS_IOLOCK_SHARED);
> +	error = xfs_scrub_ilock_inverted(dp, XFS_IOLOCK_SHARED);
> +	if (error)
> +		goto out_rele;
>  
>  	/* Go looking for our dentry. */
>  	error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nlink);
> @@ -220,8 +222,10 @@ xfs_scrub_parent_validate(
>  
>  	/* Drop the parent lock, relock this inode. */
>  	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
> +	error = xfs_scrub_ilock_inverted(sc->ip, XFS_IOLOCK_EXCL);
> +	if (error)
> +		goto out_rele;
>  	sc->ilock_flags = XFS_IOLOCK_EXCL;
> -	xfs_ilock(sc->ip, sc->ilock_flags);
>  
>  	/*
>  	 * If we're an unlinked directory, the parent /won't/ have a link
> @@ -323,5 +327,13 @@ xfs_scrub_parent(
>  	if (try_again && tries == 20)
>  		xfs_scrub_set_incomplete(sc);
>  out:
> +	/*
> +	 * If we failed to lock the parent inode even after a retry, just mark
> +	 * this scrub incomplete and return.
> +	 */
> +	if (sc->try_harder && error == -EDEADLOCK) {
> +		error = 0;
> +		xfs_scrub_set_incomplete(sc);
> +	}
>  	return error;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
