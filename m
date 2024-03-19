Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936FE2B9D7
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 18:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871865; cv=none; b=mAfpwhl+xgEbqWHU2lWxZhX7SfHHS0y8osK+p7PDsn34An5bWkwohnP8jEUfsdPS+4rYRbroLfRFkArmb6qzmFZ4lTX2juwCQDnbyQFpFBI3xThrwCGFEQQ2PXSpsoPmOc+j8W+Dr9T75VcO6MEl9tp4kxLN1Ue4HEeFazR5hww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871865; c=relaxed/simple;
	bh=Np+f9ULg1aiXDCOJD0oO/St3flOp5A4bATa3Hp1JR6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P9UocrA5UvTeFlAdP4IPeNsusXCkhwntF+2rZ1VQDQMLrGtW5sXWKZQw3i/5bhOMvx8XXet6nUmDCZCGLBpcmrlelaiR3iQ5cYS+OQhTf+D03oqUmsGmQj9Ry4QsBB49+SQxrY6D2U41wg3dVxRD8FQ/rUk1StjfdNDwSBPCCXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pBDic7Dm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pBDic7Dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197ECC433F1;
	Tue, 19 Mar 2024 18:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710871865;
	bh=Np+f9ULg1aiXDCOJD0oO/St3flOp5A4bATa3Hp1JR6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pBDic7DmucVfysFgPkHgm3Q1jJNH4nw6RcJB4Bkl3+NmZTKNGRCZHpnufHx2MtssQ
	 iYIYHFyXmUUZUPwuRaa16++jcVJv0Y6/mf5RuJdCzsXkr8IjFCl9iqcu+HmGtJnkVJ
	 a4JSc8gMwjCDdLCOzGzyXYFJqrI2Uvn0kdPIIpt3WTps6HFDcFcpibW3lU24cco+uS
	 N4RRNal3M33fohsHMcAIMtIByIbf3Y7ddz8GJUVrqco043/ABVSjGLSCjzF0LU1d48
	 Xhgo4gmj/dR1Pp2ufoA8QyJ4Cs7qg5AkXrZIkMWuPCd2r+Ph+4E+AcP/17z4i9Ein4
	 ISPpe3SHZc8ng==
Date: Tue, 19 Mar 2024 11:11:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from
 xfs_iget
Message-ID: <20240319181104.GA1927156@frogsfrogsfrogs>
References: <20240319001707.3430251-1-david@fromorbit.com>
 <20240319001707.3430251-5-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319001707.3430251-5-david@fromorbit.com>

On Tue, Mar 19, 2024 at 11:16:00AM +1100, Dave Chinner wrote:
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
>  fs/xfs/xfs_icache.c | 110 +++++++++++++++++++++++++++++++++++---------
>  1 file changed, 87 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 7359753b892b..56de3e843df2 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -63,6 +63,8 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
>  					 XFS_ICWALK_FLAG_RECLAIM_SICK | \
>  					 XFS_ICWALK_FLAG_UNION)
>  
> +static void xfs_inodegc_queue(struct xfs_inode *ip);
> +
>  /*
>   * Allocate and initialise an xfs_inode.
>   */
> @@ -325,6 +327,7 @@ xfs_reinit_inode(
>  	return error;
>  }
>  
> +
>  /*
>   * Carefully nudge an inode whose VFS state has been torn down back into a
>   * usable state.  Drops the i_flags_lock and the rcu read lock.
> @@ -388,7 +391,82 @@ xfs_iget_recycle(
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
> +	 * If the inode has been unlinked, then the lookup must not find it
> +	 * until inactivation has actually freed the inode.
> +	 */
> +	if (VFS_I(ip)->i_nlink == 0) {
> +		spin_unlock(&ip->i_flags_lock);
> +		rcu_read_unlock();
> +		return -ENOENT;
> +	}
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

The sentence structure here is a little funky to me.  How about:

"...and clear the INACTIVATING flag without another lookup racing with us..."

?

With that changed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


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
> +		trace_xfs_iget_recycle_fail(ip);
> +		return error;
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
> @@ -526,15 +604,6 @@ xfs_iget_cache_hit(
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
> -
>  	/*
>  	 * Check the inode free state is valid. This also detects lookup
>  	 * racing with unlinks.
> @@ -545,11 +614,18 @@ xfs_iget_cache_hit(
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
> @@ -578,23 +654,11 @@ xfs_iget_cache_hit(
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
