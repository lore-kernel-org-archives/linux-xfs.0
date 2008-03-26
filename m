Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 19:26:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2Q2PiCW027868
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 19:25:46 -0700
Message-ID: <47E9B5E3.7050007@sgi.com>
Date: Wed, 26 Mar 2008 13:33:07 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] kill mrlock_t
References: <20080320093940.GA28966@lst.de>
In-Reply-To: <20080320093940.GA28966@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

I like the idea but the i_lock_state thing needs work.  See comments below.

Christoph Hellwig wrote:
> XFS inodes are locked via the xfs_ilock family of functions which
> internally use a rw_semaphore wrapper into an abstraction called
> mrlock_t.  The mrlock_t should be purely internal to xfs_ilock functions
> but leaks through to the callers via various lock state asserts.
> 
> This patch:
> 
>  - adds new xfs_isilocked abstraction to make the lock state asserts
>    fits into the xfs_ilock API family
>  - opencodes the mrlock wrappers in the xfs_ilock family of functions
>  - makes the state tracking debug-only and merged into a single state
>    word
>  - remove superflous flags to the xfs_ilock family of functions
> 
> This kills 8 bytes per inode for non-debug builds, which would e.g.
> be the space for ACL caching on 32bit systems.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
>   */
>  void
> -xfs_ilock(xfs_inode_t	*ip,
> -	  uint		lock_flags)
> +xfs_ilock(
> +	xfs_inode_t		*ip,
> +	uint			lock_flags)
>  {
>  	/*
>  	 * You can't set both SHARED and EXCL for the same lock,
> @@ -608,16 +608,19 @@ xfs_ilock(xfs_inode_t	*ip,
>  	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
>  
>  	if (lock_flags & XFS_IOLOCK_EXCL) {
> -		mrupdate_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
> +		down_write_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
>  	} else if (lock_flags & XFS_IOLOCK_SHARED) {
> -		mraccess_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
> +		down_read_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
>  	}
>  	if (lock_flags & XFS_ILOCK_EXCL) {
> -		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
> +		down_write_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
>  	} else if (lock_flags & XFS_ILOCK_SHARED) {
> -		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
> +		down_read_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
>  	}
>  	xfs_ilock_trace(ip, 1, lock_flags, (inst_t *)__return_address);
> +#ifdef DEBUG
> +	ip->i_lock_state |= (lock_flags & (XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
> +#endif
This seems racy - if we only acquire one of ilock/iolock exclusive and another
thread acquires the other lock exclusive then we'll race setting i_lock_state.

>  }
>  
>  /*
> @@ -634,11 +637,12 @@ xfs_ilock(xfs_inode_t	*ip,
>   *
>   */
>  int
> -xfs_ilock_nowait(xfs_inode_t	*ip,
> -		 uint		lock_flags)
> +xfs_ilock_nowait(
> +	xfs_inode_t		*ip,
> +	uint			lock_flags)
>  {
> -	int	iolocked;
> -	int	ilocked;
> +	int			iolocked;
> +	int			ilocked;
>  
>  	/*
>  	 * You can't set both SHARED and EXCL for the same lock,
> @@ -653,35 +657,36 @@ xfs_ilock_nowait(xfs_inode_t	*ip,
>  
>  	iolocked = 0;
>  	if (lock_flags & XFS_IOLOCK_EXCL) {
> -		iolocked = mrtryupdate(&ip->i_iolock);
> -		if (!iolocked) {
> +		iolocked = down_write_trylock(&ip->i_iolock);
> +		if (!iolocked)
>  			return 0;
> -		}
>  	} else if (lock_flags & XFS_IOLOCK_SHARED) {
> -		iolocked = mrtryaccess(&ip->i_iolock);
> -		if (!iolocked) {
> +		iolocked = down_read_trylock(&ip->i_iolock);
> +		if (!iolocked)
>  			return 0;
> -		}
>  	}
> +
>  	if (lock_flags & XFS_ILOCK_EXCL) {
> -		ilocked = mrtryupdate(&ip->i_lock);
> -		if (!ilocked) {
> -			if (iolocked) {
> -				mrunlock(&ip->i_iolock);
> -			}
> -			return 0;
> -		}
> +		ilocked = down_write_trylock(&ip->i_lock);
> +		if (!ilocked)
> +			goto out_ilock_fail;
>  	} else if (lock_flags & XFS_ILOCK_SHARED) {
> -		ilocked = mrtryaccess(&ip->i_lock);
> -		if (!ilocked) {
> -			if (iolocked) {
> -				mrunlock(&ip->i_iolock);
> -			}
> -			return 0;
> -		}
> +		ilocked = down_read_trylock(&ip->i_lock);
> +		if (!ilocked)
> +			goto out_ilock_fail;
>  	}
>  	xfs_ilock_trace(ip, 2, lock_flags, (inst_t *)__return_address);
> +#ifdef DEBUG
> +	ip->i_lock_state |= (lock_flags & (XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
> +#endif
Same deal, setting i_lock_state looks racy.

>  	return 1;
> +
> + out_ilock_fail:
> +	if (lock_flags & XFS_IOLOCK_EXCL)
> +		up_write(&ip->i_iolock);
> +	else if (lock_flags & XFS_IOLOCK_SHARED)
> +		up_read(&ip->i_iolock);
> +	return 0;
>  }
>  
>  /*
> @@ -697,8 +702,9 @@ xfs_ilock_nowait(xfs_inode_t	*ip,
>   *
>   */
>  void
> -xfs_iunlock(xfs_inode_t	*ip,
> -	    uint	lock_flags)
> +xfs_iunlock(
> +	xfs_inode_t		*ip,
> +	uint			lock_flags)
>  {
>  	/*
>  	 * You can't set both SHARED and EXCL for the same lock,
> @@ -711,35 +717,33 @@ xfs_iunlock(xfs_inode_t	*ip,
>  	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
>  	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_IUNLOCK_NONOTIFY |
>  			XFS_LOCK_DEP_MASK)) == 0);
> +	ASSERT(ip->i_lock_state & lock_flags);
This assertion will always fail when *_SHARED flags are present in
lock_flags.

>  	ASSERT(lock_flags != 0);
>  
> -	if (lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) {
> -		ASSERT(!(lock_flags & XFS_IOLOCK_SHARED) ||
> -		       (ismrlocked(&ip->i_iolock, MR_ACCESS)));
> -		ASSERT(!(lock_flags & XFS_IOLOCK_EXCL) ||
> -		       (ismrlocked(&ip->i_iolock, MR_UPDATE)));
> -		mrunlock(&ip->i_iolock);
> -	}
> -
> -	if (lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) {
> -		ASSERT(!(lock_flags & XFS_ILOCK_SHARED) ||
> -		       (ismrlocked(&ip->i_lock, MR_ACCESS)));
> -		ASSERT(!(lock_flags & XFS_ILOCK_EXCL) ||
> -		       (ismrlocked(&ip->i_lock, MR_UPDATE)));
> -		mrunlock(&ip->i_lock);
> +	if (lock_flags & XFS_IOLOCK_EXCL)
> +		up_write(&ip->i_iolock);
> +	else if (lock_flags & XFS_IOLOCK_SHARED)
> +		up_read(&ip->i_iolock);
> +
> +	if (lock_flags & XFS_ILOCK_EXCL)
> +		up_write(&ip->i_lock);
> +	else if (lock_flags & (XFS_ILOCK_SHARED))
> +		up_read(&ip->i_lock);
>  
> +	if ((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) &&
> +	    !(lock_flags & XFS_IUNLOCK_NONOTIFY) && ip->i_itemp) {
>  		/*
>  		 * Let the AIL know that this item has been unlocked in case
>  		 * it is in the AIL and anyone is waiting on it.  Don't do
>  		 * this if the caller has asked us not to.
>  		 */
> -		if (!(lock_flags & XFS_IUNLOCK_NONOTIFY) &&
> -		     ip->i_itemp != NULL) {
> -			xfs_trans_unlocked_item(ip->i_mount,
> -						(xfs_log_item_t*)(ip->i_itemp));
> -		}
> +		xfs_trans_unlocked_item(ip->i_mount,
> +					(xfs_log_item_t *)ip->i_itemp);
>  	}
>  	xfs_ilock_trace(ip, 3, lock_flags, (inst_t *)__return_address);
> +#ifdef DEBUG
> +	ip->i_lock_state &= ~(lock_flags & (XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
> +#endif
This seems racy - another thread could have acquired the ilock/iolock and set
the flags before we get here and remove the flags.  Unsetting the flags before
we release the lock would still be racy if both iolock and ilock are released
at the same time by different threads.

>  }
>  
>  /*
> @@ -747,21 +751,42 @@ xfs_iunlock(xfs_inode_t	*ip,
>   * if it is being demoted.
>   */
>  void
> -xfs_ilock_demote(xfs_inode_t	*ip,
> -		 uint		lock_flags)
> +xfs_ilock_demote(
> +	xfs_inode_t		*ip,
> +	uint			lock_flags)
>  {
>  	ASSERT(lock_flags & (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL));
>  	ASSERT((lock_flags & ~(XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
> +	ASSERT(ip->i_lock_state & lock_flags);
>  
> -	if (lock_flags & XFS_ILOCK_EXCL) {
> -		ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
> -		mrdemote(&ip->i_lock);
> -	}
> -	if (lock_flags & XFS_IOLOCK_EXCL) {
> -		ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
> -		mrdemote(&ip->i_iolock);
> -	}
> +	if (lock_flags & XFS_ILOCK_EXCL)
> +		downgrade_write(&ip->i_lock);
> +	if (lock_flags & XFS_IOLOCK_EXCL)
> +		downgrade_write(&ip->i_iolock);
> +
> +#ifdef DEBUG
> +	ip->i_lock_state &= ~lock_flags;
> +#endif
> +}
> +
> +#ifdef DEBUG
> +/*
> + * Debug-only routine, without additional rw_semaphore APIs, we can
> + * now only answer requests regarding whether we hold the lock for write
> + * (reader state is outside our visibility, we only track writer state).
> + *
> + * Note: means !xfs_isilocked would give false positives, so don't do that.
> + */
> +int
> +xfs_isilocked(
> +	xfs_inode_t		*ip,
> +	uint			lock_flags)
> +{
> +	if (lock_flags & (XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL))
> +		return (ip->i_lock_state & lock_flags);
> +	return 1;
>  }
> +#endif
>  

Splitting i_lock_state into two separate fields - one for each lock - and
unsetting the fields prior to releasing/demoting the lock might be enough
to solve all these races.
