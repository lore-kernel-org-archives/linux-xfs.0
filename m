Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C616D39
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816169; cv=none; b=PhZesRjxtsKVwH16N8ESo4KSNj7TGq9COWoTajX6p1mO4ri8McOibnQh6c5PmL7esW53OMyfL3otNEeP5wJK5/V491bgoaSdl22L1sL1hmJ5FZAJ1affMQqBDbiq37ACwJqdiqGGfXb/TarN4QajvzAjr4iCOe5YQd9TSMzAYWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816169; c=relaxed/simple;
	bh=/RaiVPuUwXqxvebAL9w6bIs7bki2H/PaDzBdGoFjVPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZekLhTxh0/yV3CcAM5InOfpycvYH4KY8WWYECPtoOkFQ32MjyZDlYoVVaXTxT31K8J0dHCkA6hROA5uaO+RJhdIaHQ42iBOvKmYdTO8hyF7coLQQSzElM+RA1YZJCR1Hs+3lIdglwoM9L1LezV6Hpgps1mZ+CHBMm4n8n8XnFuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a9tlkqN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9tlkqN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2617C433C7;
	Thu,  1 Feb 2024 19:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816169;
	bh=/RaiVPuUwXqxvebAL9w6bIs7bki2H/PaDzBdGoFjVPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a9tlkqN2pyd1FpdhmdeEghR+LTJawUX6kV0gftkACvWpXwn2pRhaDV8C1F/6GCvRx
	 StDp0vi95WAhCHGbhEyfMDq9jI+dXS4ceYwohPzULlUcNwFmG047B1myduKMBI1+fk
	 /mP6AVpbljCNtq+aKz0cjHwhtqdqwDXQHNbqRYVC7RY0oD9BNH8Nb3Na4/GTPaErAf
	 I/LHAlD1Ohwa18JpypxtsRbdtOXtK8iydb44HUmoyclwcT+aZqpUOrDFJt+XSsB+Un
	 N8ed/P7pAR6d3sbfDru3KtS7t3PI7Eq+TcqkLBucsmmZpzyCYFlxVE9JvsXnYxXNJa
	 YEFQXoyAvyndg==
Date: Thu, 1 Feb 2024 11:36:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from
 xfs_iget
Message-ID: <20240201193608.GG616564@frogsfrogsfrogs>
References: <20240201005217.1011010-1-david@fromorbit.com>
 <20240201005217.1011010-5-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201005217.1011010-5-david@fromorbit.com>

On Thu, Feb 01, 2024 at 11:30:16AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When xfs_iget() finds an inode that is queued for inactivation, it
> issues an inodegc flush to trigger the inactivation work and then
> retries the lookup.
> 
> However, when the filesystem is frozen, inodegc is turned off and
> the flush does nothing and does not block. This results in lookup
> spinning on NEED_INACTIVE inodes and being unable to make progress
> until the filesystem is thawed. This is less than ideal.
> 
> The only reason we can't immediately recycle the inode is that it
> queued on a lockless list we can't remove it from. However, those
> lists now support lazy removal, and so we can now modify the lookup
> code to reactivate inode queued for inactivation. The process is
> identical to how we recycle reclaimable inodes from xfs_iget(), so
> this ends up being a relatively simple change to make.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 98 +++++++++++++++++++++++++++++++++++----------
>  1 file changed, 76 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 10588f78f679..1fc55ed0692c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -64,6 +64,8 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
>  					 XFS_ICWALK_FLAG_RECLAIM_SICK | \
>  					 XFS_ICWALK_FLAG_UNION)
>  
> +static void xfs_inodegc_queue(struct xfs_inode *ip);
> +
>  /*
>   * Allocate and initialise an xfs_inode.
>   */
> @@ -328,6 +330,7 @@ xfs_reinit_inode(
>  	return error;
>  }
>  
> +
>  /*
>   * Carefully nudge an inode whose VFS state has been torn down back into a
>   * usable state.  Drops the i_flags_lock and the rcu read lock.
> @@ -391,7 +394,71 @@ xfs_iget_recycle(
>  	inode->i_state = I_NEW;
>  	spin_unlock(&ip->i_flags_lock);
>  	spin_unlock(&pag->pag_ici_lock);
> +	XFS_STATS_INC(mp, xs_ig_frecycle);
> +	return 0;
> +}
>  
> +static int
> +xfs_iget_reactivate(
> +	struct xfs_perag	*pag,
> +	struct xfs_inode	*ip) __releases(&ip->i_flags_lock)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct inode		*inode = VFS_I(ip);
> +	int			error;
> +
> +	trace_xfs_iget_recycle(ip);
> +
> +	/*
> +	 * Take the ILOCK here to serialise against lookup races with putting
> +	 * the inode back on the inodegc queue during error handling.
> +	 */
> +	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
> +		return -EAGAIN;
> +
> +	/*
> +	 * Move the state to inactivating so both inactivation and racing
> +	 * lookups will skip over this inode until we've finished reactivating
> +	 * it and can return it to the XFS_INEW state.
> +	 */
> +	ip->i_flags &= ~XFS_NEED_INACTIVE;
> +	ip->i_flags |= XFS_INACTIVATING;
> +	spin_unlock(&ip->i_flags_lock);
> +	rcu_read_unlock();
> +
> +	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
> +	error = xfs_reinit_inode(mp, inode);
> +	if (error) {
> +		/*
> +		 * Well, that sucks. Put the inode back on the inactive queue.
> +		 * Do this while still under the ILOCK so that we can set the
> +		 * NEED_INACTIVE flag and clear the INACTIVATING flag an not
> +		 * have another lookup race with us before we've finished
> +		 * putting the inode back on the inodegc queue.
> +		 */
> +		spin_unlock(&ip->i_flags_lock);
> +		ip->i_flags |= XFS_NEED_INACTIVE;
> +		ip->i_flags &= ~XFS_INACTIVATING;
> +		spin_unlock(&ip->i_flags_lock);
> +
> +		xfs_inodegc_queue(ip);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
> +		return error;

Needs a trace_xfs_iget_recycle_fail here.

Do we want/need separate tracepoints for reactivation?  I'm guessing not
really since either way (reclaim/inactivation) we're recreating the vfs
state of an inode that hadn't yet been fully zapped.

The code changes here look good to me otherwise.

--D

> +	}
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
> +	/*
> +	 * Reset the inode state to new so that xfs_iget() will complete
> +	 * the required remaining inode initialisation before it returns the
> +	 * inode to the caller.
> +	 */
> +	spin_lock(&ip->i_flags_lock);
> +	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
> +	ip->i_flags |= XFS_INEW;
> +	inode->i_state = I_NEW;
> +	spin_unlock(&ip->i_flags_lock);
> +	XFS_STATS_INC(mp, xs_ig_frecycle);
>  	return 0;
>  }
>  
> @@ -523,14 +590,6 @@ xfs_iget_cache_hit(
>  	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_INACTIVATING))
>  		goto out_skip;
>  
> -	if (ip->i_flags & XFS_NEED_INACTIVE) {
> -		/* Unlinked inodes cannot be re-grabbed. */
> -		if (VFS_I(ip)->i_nlink == 0) {
> -			error = -ENOENT;
> -			goto out_error;
> -		}
> -		goto out_inodegc_flush;
> -	}
>  
>  	/*
>  	 * Check the inode free state is valid. This also detects lookup
> @@ -542,11 +601,18 @@ xfs_iget_cache_hit(
>  
>  	/* Skip inodes that have no vfs state. */
>  	if ((flags & XFS_IGET_INCORE) &&
> -	    (ip->i_flags & XFS_IRECLAIMABLE))
> +	    (ip->i_flags & (XFS_IRECLAIMABLE | XFS_NEED_INACTIVE)))
>  		goto out_skip;
>  
>  	/* The inode fits the selection criteria; process it. */
> -	if (ip->i_flags & XFS_IRECLAIMABLE) {
> +	if (ip->i_flags & XFS_NEED_INACTIVE) {
> +		/* Drops i_flags_lock and RCU read lock. */
> +		error = xfs_iget_reactivate(pag, ip);
> +		if (error == -EAGAIN)
> +			goto out_skip;
> +		if (error)
> +			return error;
> +	} else if (ip->i_flags & XFS_IRECLAIMABLE) {
>  		/* Drops i_flags_lock and RCU read lock. */
>  		error = xfs_iget_recycle(pag, ip);
>  		if (error == -EAGAIN)
> @@ -575,23 +641,11 @@ xfs_iget_cache_hit(
>  
>  out_skip:
>  	trace_xfs_iget_skip(ip);
> -	XFS_STATS_INC(mp, xs_ig_frecycle);
>  	error = -EAGAIN;
>  out_error:
>  	spin_unlock(&ip->i_flags_lock);
>  	rcu_read_unlock();
>  	return error;
> -
> -out_inodegc_flush:
> -	spin_unlock(&ip->i_flags_lock);
> -	rcu_read_unlock();
> -	/*
> -	 * Do not wait for the workers, because the caller could hold an AGI
> -	 * buffer lock.  We're just going to sleep in a loop anyway.
> -	 */
> -	if (xfs_is_inodegc_enabled(mp))
> -		xfs_inodegc_queue_all(mp);
> -	return -EAGAIN;
>  }
>  
>  static int
> -- 
> 2.43.0
> 
> 
