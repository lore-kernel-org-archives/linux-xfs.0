Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64E8E803D
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 08:18:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40A96304043
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 06:18:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZHp4uQBmTM6Lx9Ra (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 06:18:39 -0800 (PST)
Date: Thu, 5 Feb 2015 09:18:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/7] xfs: use generic percpu counters for free block
	counter
Message-ID: <20150205141829.GJ31625@laptop.bfoster>
References: <1423083249-27493-1-git-send-email-david@fromorbit.com>
	<1423083249-27493-4-git-send-email-david@fromorbit.com>
	<20150205141015.GE31625@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150205141015.GE31625@laptop.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 05, 2015 at 09:10:15AM -0500, Brian Foster wrote:
> On Thu, Feb 05, 2015 at 07:54:05AM +1100, Dave Chinner wrote:
> > XFS has hand-rolled per-cpu counters for the superblock since before
> > there was any generic implementation. The free block counter is
> > special in that it is used for ENOSPC detection outside transaction
> > contexts for for delayed allocation. This means that the counter
> > needs to be accurate at zero. The current per-cpu counter code jumps
> > through lots of hoops to ensure we never run past zero, but we don't
> > need to make all those jumps with the generic counter
> > implementation.
> > 
> > The generic counter implementation allows us to pass a "batch"
> > threshold at which the addition/subtraction to the counter value
> > will be folded back into global value under lock. We can use this
> > feature to reduce the batch size as we approach 0 in a very similar
> > manner to the existing counters and their rebalance algorithm. If we
> > use a batch size of 1 as we approach 0, then every addition and
> > subtraction will be done against the global value and hence allow
> > accurate detection of zero threshold crossing.
> > 
> > Hence we can replace the handrolled, accurate-at-zero counters with
> > generic percpu counters.
> > 
> > Note: this removes just enough of the icsb infrastructure to compile
> > without warnings. The rest will go in subsequent commits.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c |  32 ++++----
> >  fs/xfs/libxfs/xfs_sb.c   |   1 +
> >  fs/xfs/xfs_fsops.c       |   9 ++-
> >  fs/xfs/xfs_iomap.c       |   2 +-
> >  fs/xfs/xfs_mount.c       | 193 ++++++++++++++++++++++++-----------------------
> >  fs/xfs/xfs_mount.h       |   3 +
> >  fs/xfs/xfs_super.c       |  10 ++-
> >  fs/xfs/xfs_trans.c       |  16 ++--
> >  8 files changed, 135 insertions(+), 131 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 61ec015..e39c9e8 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -2212,9 +2212,8 @@ xfs_bmap_add_extent_delay_real(
> >  		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
> >  			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
> >  		if (diff > 0) {
> > -			error = xfs_icsb_modify_counters(bma->ip->i_mount,
> > -					XFS_SBS_FDBLOCKS,
> > -					-((int64_t)diff), 0);
> > +			error = xfs_mod_fdblocks(bma->ip->i_mount,
> > +						 -((int64_t)diff), false);
> >  			ASSERT(!error);
> >  			if (error)
> >  				goto done;
> > @@ -2265,9 +2264,8 @@ xfs_bmap_add_extent_delay_real(
> >  			temp += bma->cur->bc_private.b.allocated;
> >  		ASSERT(temp <= da_old);
> >  		if (temp < da_old)
> > -			xfs_icsb_modify_counters(bma->ip->i_mount,
> > -					XFS_SBS_FDBLOCKS,
> > -					(int64_t)(da_old - temp), 0);
> > +			xfs_mod_fdblocks(bma->ip->i_mount,
> > +					(int64_t)(da_old - temp), false);
> >  	}
> >  
> >  	/* clear out the allocated field, done with it now in any case. */
> > @@ -2944,8 +2942,8 @@ xfs_bmap_add_extent_hole_delay(
> >  	}
> >  	if (oldlen != newlen) {
> >  		ASSERT(oldlen > newlen);
> > -		xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
> > -			(int64_t)(oldlen - newlen), 0);
> > +		xfs_mod_fdblocks(ip->i_mount, (int64_t)(oldlen - newlen),
> > +				 false);
> >  		/*
> >  		 * Nothing to do for disk quota accounting here.
> >  		 */
> > @@ -4163,15 +4161,13 @@ xfs_bmapi_reserve_delalloc(
> >  		error = xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS,
> >  					  -((int64_t)extsz), 0);
> >  	} else {
> > -		error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
> > -						 -((int64_t)alen), 0);
> > +		error = xfs_mod_fdblocks(mp, -((int64_t)alen), false);
> >  	}
> >  
> >  	if (error)
> >  		goto out_unreserve_quota;
> >  
> > -	error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
> > -					 -((int64_t)indlen), 0);
> > +	error = xfs_mod_fdblocks(mp, -((int64_t)indlen), false);
> >  	if (error)
> >  		goto out_unreserve_blocks;
> >  
> > @@ -4200,7 +4196,7 @@ out_unreserve_blocks:
> >  	if (rt)
> >  		xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS, extsz, 0);
> >  	else
> > -		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS, alen, 0);
> > +		xfs_mod_fdblocks(mp, alen, false);
> >  out_unreserve_quota:
> >  	if (XFS_IS_QUOTA_ON(mp))
> >  		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0, rt ?
> > @@ -5012,10 +5008,8 @@ xfs_bmap_del_extent(
> >  	 * Nothing to do for disk quota accounting here.
> >  	 */
> >  	ASSERT(da_old >= da_new);
> > -	if (da_old > da_new) {
> > -		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
> > -			(int64_t)(da_old - da_new), 0);
> > -	}
> > +	if (da_old > da_new)
> > +		xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new), false);
> >  done:
> >  	*logflagsp = flags;
> >  	return error;
> > @@ -5290,8 +5284,8 @@ xfs_bunmapi(
> >  					ip, -((long)del.br_blockcount), 0,
> >  					XFS_QMOPT_RES_RTBLKS);
> >  			} else {
> > -				xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
> > -						(int64_t)del.br_blockcount, 0);
> > +				xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount,
> > +						 false);
> >  				(void)xfs_trans_reserve_quota_nblks(NULL,
> >  					ip, -((long)del.br_blockcount), 0,
> >  					XFS_QMOPT_RES_REGBLKS);
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index b66aeab..31a3e97 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -773,6 +773,7 @@ xfs_log_sb(
> >  
> >  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> >  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > +	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> >  
> >  	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
> >  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index fa74d03..fed97a9 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -633,9 +633,10 @@ xfs_fs_counts(
> >  	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
> >  	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
> >  	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
> > +	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
> > +							XFS_ALLOC_SET_ASIDE(mp);
> >  
> >  	spin_lock(&mp->m_sb_lock);
> > -	cnt->freedata = mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
> >  	cnt->freertx = mp->m_sb.sb_frextents;
> >  	spin_unlock(&mp->m_sb_lock);
> >  	return 0;
> > @@ -710,7 +711,8 @@ retry:
> >  	} else {
> >  		__int64_t	free;
> >  
> > -		free =  mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
> > +		free = percpu_counter_sum(&mp->m_fdblocks) -
> > +							XFS_ALLOC_SET_ASIDE(mp);
> >  		if (!free)
> >  			goto out; /* ENOSPC and fdblks_delta = 0 */
> >  
> > @@ -749,8 +751,7 @@ out:
> >  		 * the extra reserve blocks from the reserve.....
> >  		 */
> >  		int error;
> > -		error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
> > -						 fdblks_delta, 0);
> > +		error = xfs_mod_fdblocks(mp, fdblks_delta, 0);
> >  		if (error == -ENOSPC)
> >  			goto retry;
> >  	}
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index ccb1dd0..205b948 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -461,7 +461,7 @@ xfs_iomap_prealloc_size(
> >  				       alloc_blocks);
> >  
> >  	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
> > -	freesp = mp->m_sb.sb_fdblocks;
> > +	freesp = percpu_counter_read_positive(&mp->m_fdblocks);
> >  	if (freesp < mp->m_low_space[XFS_LOWSP_5_PCNT]) {
> >  		shift = 2;
> >  		if (freesp < mp->m_low_space[XFS_LOWSP_4_PCNT])
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 650e8f1..9e433b2 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -1114,7 +1114,6 @@ xfs_mod_icount(
> >  	return 0;
> >  }
> >  
> > -
> >  int
> >  xfs_mod_ifree(
> >  	struct xfs_mount	*mp,
> > @@ -1128,6 +1127,93 @@ xfs_mod_ifree(
> >  	}
> >  	return 0;
> >  }
> > +
> > +int
> > +xfs_mod_fdblocks(
> > +	struct xfs_mount	*mp,
> > +	int64_t			delta,
> > +	bool			rsvd)
> > +{
> > +	int64_t			lcounter;
> > +	long long		res_used;
> > +	s32			batch;
> > +
> > +	if (delta > 0) {
> > +		/*
> > +		 * If the reserve pool is depleted, put blocks back into it
> > +		 * first. Most of the time the pool is full.
> > +		 */
> > +		if (likely(mp->m_resblks == mp->m_resblks_avail)) {
> > +			percpu_counter_add(&mp->m_fdblocks, delta);
> > +			return 0;
> > +		}
> > +
> > +		spin_lock(&mp->m_sb_lock);
> > +		res_used = (long long)
> > +				(mp->m_resblks - mp->m_resblks_avail);
> > +
> > +		if (res_used > delta) {
> > +			mp->m_resblks_avail += delta;
> > +		} else {
> > +			delta -= res_used;
> > +				mp->m_resblks_avail = mp->m_resblks;
> 
> Extra tab on the line above.
> 

Forgot tag, this looks fine otherwise:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Brian
> 
> > +			percpu_counter_add(&mp->m_fdblocks, delta);
> > +		}
> > +		spin_unlock(&mp->m_sb_lock);
> > +		return 0;
> > +	}
> > +
> > +	/*
> > +	 * Taking blocks away, need to be more accurate the closer we
> > +	 * are to zero.
> > +	 *
> > +	 * batch size is set to a maximum of 1024 blocks - if we are
> > +	 * allocating of freeing extents larger than this then we aren't
> > +	 * going to be hammering the counter lock so a lock per update
> > +	 * is not a problem.
> > +	 *
> > +	 * If the counter has a value of less than 2 * max batch size,
> > +	 * then make everything serialise as we are real close to
> > +	 * ENOSPC.
> > +	 */
> > +#define __BATCH	1024
> > +	if (percpu_counter_compare(&mp->m_fdblocks, 2 * __BATCH) < 0)
> > +		batch = 1;
> > +	else
> > +		batch = __BATCH;
> > +#undef __BATCH
> > +
> > +	__percpu_counter_add(&mp->m_fdblocks, delta, batch);
> > +	if (percpu_counter_compare(&mp->m_fdblocks,
> > +				   XFS_ALLOC_SET_ASIDE(mp)) >= 0) {
> > +		/* we had space! */
> > +		return 0;
> > +	}
> > +
> > +	/*
> > +	 * lock up the sb for dipping into reserves before releasing the space
> > +	 * that took us to ENOSPC.
> > +	 */
> > +	spin_lock(&mp->m_sb_lock);
> > +	percpu_counter_add(&mp->m_fdblocks, -delta);
> > +	if (!rsvd)
> > +		goto fdblocks_enospc;
> > +
> > +	lcounter = (long long)mp->m_resblks_avail + delta;
> > +	if (lcounter >= 0) {
> > +		mp->m_resblks_avail = lcounter;
> > +		spin_unlock(&mp->m_sb_lock);
> > +		return 0;
> > +	}
> > +	printk_once(KERN_WARNING
> > +		"Filesystem \"%s\": reserve blocks depleted! "
> > +		"Consider increasing reserve pool size.",
> > +		mp->m_fsname);
> > +fdblocks_enospc:
> > +	spin_unlock(&mp->m_sb_lock);
> > +	return -ENOSPC;
> > +}
> > +
> >  /*
> >   * xfs_mod_incore_sb_unlocked() is a utility routine commonly used to apply
> >   * a delta to a specified field in the in-core superblock.  Simply
> > @@ -1146,7 +1232,6 @@ xfs_mod_incore_sb_unlocked(
> >  {
> >  	int		scounter;	/* short counter for 32 bit fields */
> >  	long long	lcounter;	/* long counter for 64 bit fields */
> > -	long long	res_used, rem;
> >  
> >  	/*
> >  	 * With the in-core superblock spin lock held, switch
> > @@ -1157,50 +1242,9 @@ xfs_mod_incore_sb_unlocked(
> >  	switch (field) {
> >  	case XFS_SBS_ICOUNT:
> >  	case XFS_SBS_IFREE:
> > +	case XFS_SBS_FDBLOCKS:
> >  		ASSERT(0);
> >  		return -EINVAL;
> > -	case XFS_SBS_FDBLOCKS:
> > -		lcounter = (long long)
> > -			mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
> > -		res_used = (long long)(mp->m_resblks - mp->m_resblks_avail);
> > -
> > -		if (delta > 0) {		/* Putting blocks back */
> > -			if (res_used > delta) {
> > -				mp->m_resblks_avail += delta;
> > -			} else {
> > -				rem = delta - res_used;
> > -				mp->m_resblks_avail = mp->m_resblks;
> > -				lcounter += rem;
> > -			}
> > -		} else {				/* Taking blocks away */
> > -			lcounter += delta;
> > -			if (lcounter >= 0) {
> > -				mp->m_sb.sb_fdblocks = lcounter +
> > -							XFS_ALLOC_SET_ASIDE(mp);
> > -				return 0;
> > -			}
> > -
> > -			/*
> > -			 * We are out of blocks, use any available reserved
> > -			 * blocks if were allowed to.
> > -			 */
> > -			if (!rsvd)
> > -				return -ENOSPC;
> > -
> > -			lcounter = (long long)mp->m_resblks_avail + delta;
> > -			if (lcounter >= 0) {
> > -				mp->m_resblks_avail = lcounter;
> > -				return 0;
> > -			}
> > -			printk_once(KERN_WARNING
> > -				"Filesystem \"%s\": reserve blocks depleted! "
> > -				"Consider increasing reserve pool size.",
> > -				mp->m_fsname);
> > -			return -ENOSPC;
> > -		}
> > -
> > -		mp->m_sb.sb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);
> > -		return 0;
> >  	case XFS_SBS_FREXTENTS:
> >  		lcounter = (long long)mp->m_sb.sb_frextents;
> >  		lcounter += delta;
> > @@ -1323,7 +1367,7 @@ xfs_mod_incore_sb(
> >   *
> >   * Note that this function may not be used for the superblock values that
> >   * are tracked with the in-memory per-cpu counters - a direct call to
> > - * xfs_icsb_modify_counters is required for these.
> > + * xfs_mod_incore_sb is required for these.
> >   */
> >  int
> >  xfs_mod_incore_sb_batch(
> > @@ -1508,7 +1552,6 @@ xfs_icsb_cpu_notify(
> >  	case CPU_ONLINE:
> >  	case CPU_ONLINE_FROZEN:
> >  		xfs_icsb_lock(mp);
> > -		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
> >  		xfs_icsb_unlock(mp);
> >  		break;
> >  	case CPU_DEAD:
> > @@ -1518,13 +1561,9 @@ xfs_icsb_cpu_notify(
> >  		 * re-enable the counters. */
> >  		xfs_icsb_lock(mp);
> >  		spin_lock(&mp->m_sb_lock);
> > -		xfs_icsb_disable_counter(mp, XFS_SBS_FDBLOCKS);
> > -
> > -		mp->m_sb.sb_fdblocks += cntp->icsb_fdblocks;
> >  
> >  		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
> >  
> > -		xfs_icsb_balance_counter_locked(mp, XFS_SBS_FDBLOCKS, 0);
> >  		spin_unlock(&mp->m_sb_lock);
> >  		xfs_icsb_unlock(mp);
> >  		break;
> > @@ -1550,10 +1589,14 @@ xfs_icsb_init_counters(
> >  	if (error)
> >  		goto free_icount;
> >  
> > +	error = percpu_counter_init(&mp->m_fdblocks, 0, GFP_KERNEL);
> > +	if (error)
> > +		goto free_ifree;
> > +
> >  	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
> >  	if (!mp->m_sb_cnts) {
> >  		error = -ENOMEM;
> > -		goto free_ifree;
> > +		goto free_fdblocks;
> >  	}
> >  
> >  	for_each_online_cpu(i) {
> > @@ -1577,6 +1620,8 @@ xfs_icsb_init_counters(
> >  
> >  	return 0;
> >  
> > +free_fdblocks:
> > +	percpu_counter_destroy(&mp->m_fdblocks);
> >  free_ifree:
> >  	percpu_counter_destroy(&mp->m_ifree);
> >  free_icount:
> > @@ -1590,6 +1635,7 @@ xfs_icsb_reinit_counters(
> >  {
> >  	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
> >  	percpu_counter_set(&mp->m_ifree, mp->m_sb.sb_ifree);
> > +	percpu_counter_set(&mp->m_fdblocks, mp->m_sb.sb_fdblocks);
> >  
> >  	xfs_icsb_lock(mp);
> >  	/*
> > @@ -1597,7 +1643,6 @@ xfs_icsb_reinit_counters(
> >  	 * initial balance kicks us off correctly
> >  	 */
> >  	mp->m_icsb_counters = -1;
> > -	xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
> >  	xfs_icsb_unlock(mp);
> >  }
> >  
> > @@ -1612,6 +1657,7 @@ xfs_icsb_destroy_counters(
> >  
> >  	percpu_counter_destroy(&mp->m_icount);
> >  	percpu_counter_destroy(&mp->m_ifree);
> > +	percpu_counter_destroy(&mp->m_fdblocks);
> >  
> >  	mutex_destroy(&mp->m_icsb_mutex);
> >  }
> > @@ -1665,18 +1711,11 @@ xfs_icsb_count(
> >  	xfs_icsb_cnts_t	*cnt,
> >  	int		flags)
> >  {
> > -	xfs_icsb_cnts_t *cntp;
> > -	int		i;
> > -
> >  	memset(cnt, 0, sizeof(xfs_icsb_cnts_t));
> >  
> >  	if (!(flags & XFS_ICSB_LAZY_COUNT))
> >  		xfs_icsb_lock_all_counters(mp);
> >  
> > -	for_each_online_cpu(i) {
> > -		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
> > -		cnt->icsb_fdblocks += cntp->icsb_fdblocks;
> > -	}
> >  
> >  	if (!(flags & XFS_ICSB_LAZY_COUNT))
> >  		xfs_icsb_unlock_all_counters(mp);
> > @@ -1687,7 +1726,6 @@ xfs_icsb_counter_disabled(
> >  	xfs_mount_t	*mp,
> >  	xfs_sb_field_t	field)
> >  {
> > -	ASSERT(field == XFS_SBS_FDBLOCKS);
> >  	return test_bit(field, &mp->m_icsb_counters);
> >  }
> >  
> > @@ -1698,8 +1736,6 @@ xfs_icsb_disable_counter(
> >  {
> >  	xfs_icsb_cnts_t	cnt;
> >  
> > -	ASSERT(field == XFS_SBS_FDBLOCKS);
> > -
> >  	/*
> >  	 * If we are already disabled, then there is nothing to do
> >  	 * here. We check before locking all the counters to avoid
> > @@ -1717,9 +1753,6 @@ xfs_icsb_disable_counter(
> >  
> >  		xfs_icsb_count(mp, &cnt, XFS_ICSB_LAZY_COUNT);
> >  		switch(field) {
> > -		case XFS_SBS_FDBLOCKS:
> > -			mp->m_sb.sb_fdblocks = cnt.icsb_fdblocks;
> > -			break;
> >  		default:
> >  			BUG();
> >  		}
> > @@ -1735,18 +1768,11 @@ xfs_icsb_enable_counter(
> >  	uint64_t	count,
> >  	uint64_t	resid)
> >  {
> > -	xfs_icsb_cnts_t	*cntp;
> >  	int		i;
> >  
> > -	ASSERT(field == XFS_SBS_FDBLOCKS);
> > -
> >  	xfs_icsb_lock_all_counters(mp);
> >  	for_each_online_cpu(i) {
> > -		cntp = per_cpu_ptr(mp->m_sb_cnts, i);
> >  		switch (field) {
> > -		case XFS_SBS_FDBLOCKS:
> > -			cntp->icsb_fdblocks = count + resid;
> > -			break;
> >  		default:
> >  			BUG();
> >  			break;
> > @@ -1765,9 +1791,6 @@ xfs_icsb_sync_counters_locked(
> >  	xfs_icsb_cnts_t	cnt;
> >  
> >  	xfs_icsb_count(mp, &cnt, flags);
> > -
> > -	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_FDBLOCKS))
> > -		mp->m_sb.sb_fdblocks = cnt.icsb_fdblocks;
> >  }
> >  
> >  /*
> > @@ -1809,20 +1832,12 @@ xfs_icsb_balance_counter_locked(
> >  	int		min_per_cpu)
> >  {
> >  	uint64_t	count, resid;
> > -	int		weight = num_online_cpus();
> > -	uint64_t	min = (uint64_t)min_per_cpu;
> >  
> >  	/* disable counter and sync counter */
> >  	xfs_icsb_disable_counter(mp, field);
> >  
> >  	/* update counters  - first CPU gets residual*/
> >  	switch (field) {
> > -	case XFS_SBS_FDBLOCKS:
> > -		count = mp->m_sb.sb_fdblocks;
> > -		resid = do_div(count, weight);
> > -		if (count < max(min, XFS_ICSB_FDBLK_CNTR_REENABLE(mp)))
> > -			return;
> > -		break;
> >  	default:
> >  		BUG();
> >  		count = resid = 0;	/* quiet, gcc */
> > @@ -1851,7 +1866,6 @@ xfs_icsb_modify_counters(
> >  	int		rsvd)
> >  {
> >  	xfs_icsb_cnts_t	*icsbp;
> > -	long long	lcounter;	/* long counter for 64 bit fields */
> >  	int		ret = 0;
> >  
> >  	might_sleep();
> > @@ -1871,18 +1885,9 @@ again:
> >  	}
> >  
> >  	switch (field) {
> > -	case XFS_SBS_FDBLOCKS:
> > -		BUG_ON((mp->m_resblks - mp->m_resblks_avail) != 0);
> > -
> > -		lcounter = icsbp->icsb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
> > -		lcounter += delta;
> > -		if (unlikely(lcounter < 0))
> > -			goto balance_counter;
> > -		icsbp->icsb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);
> > -		break;
> >  	default:
> >  		BUG();
> > -		break;
> > +		goto balance_counter; /* be still, gcc */
> >  	}
> >  	xfs_icsb_unlock_cntr(icsbp);
> >  	preempt_enable();
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 0cb32ce..76f5d25 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -85,6 +85,7 @@ typedef struct xfs_mount {
> >  	spinlock_t		m_sb_lock;	/* sb counter lock */
> >  	struct percpu_counter	m_icount;	/* allocated inodes counter */
> >  	struct percpu_counter	m_ifree;	/* free inodes counter */
> > +	struct percpu_counter	m_fdblocks;	/* free block counter */
> >  
> >  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
> >  	char			*m_fsname;	/* filesystem name */
> > @@ -382,6 +383,8 @@ extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
> >  			uint, int);
> >  extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
> >  extern int	xfs_mod_ifree(struct xfs_mount *mp, int64_t delta);
> > +extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
> > +				 bool reserved);
> >  extern int	xfs_mount_log_sb(xfs_mount_t *);
> >  extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
> >  extern int	xfs_readsb(xfs_mount_t *, int);
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index e06aa6b..4c6af31 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1089,6 +1089,7 @@ xfs_fs_statfs(
> >  	__uint64_t		fakeinos, id;
> >  	__uint64_t		icount;
> >  	__uint64_t		ifree;
> > +	__uint64_t		fdblocks;
> >  	xfs_extlen_t		lsize;
> >  	__int64_t		ffree;
> >  
> > @@ -1102,13 +1103,17 @@ xfs_fs_statfs(
> >  	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
> >  	icount = percpu_counter_sum(&mp->m_icount);
> >  	ifree = percpu_counter_sum(&mp->m_ifree);
> > +	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> >  
> >  	spin_lock(&mp->m_sb_lock);
> >  	statp->f_bsize = sbp->sb_blocksize;
> >  	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
> >  	statp->f_blocks = sbp->sb_dblocks - lsize;
> > -	statp->f_bfree = statp->f_bavail =
> > -				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
> > +	spin_unlock(&mp->m_sb_lock);
> > +
> > +	statp->f_bfree = fdblocks - XFS_ALLOC_SET_ASIDE(mp);
> > +	statp->f_bavail = statp->f_bfree;
> > +
> >  	fakeinos = statp->f_bfree << sbp->sb_inopblog;
> >  	statp->f_files = MIN(icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
> >  	if (mp->m_maxicount)
> > @@ -1120,7 +1125,6 @@ xfs_fs_statfs(
> >  	ffree = statp->f_files - (icount - ifree);
> >  	statp->f_ffree = max_t(__int64_t, ffree, 0);
> >  
> > -	spin_unlock(&mp->m_sb_lock);
> >  
> >  	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
> >  	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 68680ce..e99f5e5 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -173,7 +173,7 @@ xfs_trans_reserve(
> >  	uint			rtextents)
> >  {
> >  	int		error = 0;
> > -	int		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
> > +	bool		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
> >  
> >  	/* Mark this thread as being in a transaction */
> >  	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
> > @@ -184,8 +184,7 @@ xfs_trans_reserve(
> >  	 * fail if the count would go below zero.
> >  	 */
> >  	if (blocks > 0) {
> > -		error = xfs_icsb_modify_counters(tp->t_mountp, XFS_SBS_FDBLOCKS,
> > -					  -((int64_t)blocks), rsvd);
> > +		error = xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), rsvd);
> >  		if (error != 0) {
> >  			current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
> >  			return -ENOSPC;
> > @@ -268,8 +267,7 @@ undo_log:
> >  
> >  undo_blocks:
> >  	if (blocks > 0) {
> > -		xfs_icsb_modify_counters(tp->t_mountp, XFS_SBS_FDBLOCKS,
> > -					 (int64_t)blocks, rsvd);
> > +		xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), rsvd);
> >  		tp->t_blk_res = 0;
> >  	}
> >  
> > @@ -516,14 +514,13 @@ xfs_trans_unreserve_and_mod_sb(
> >  	xfs_mount_t	*mp = tp->t_mountp;
> >  	/* REFERENCED */
> >  	int		error;
> > -	int		rsvd;
> > +	bool		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
> >  	int64_t		blkdelta = 0;
> >  	int64_t		rtxdelta = 0;
> >  	int64_t		idelta = 0;
> >  	int64_t		ifreedelta = 0;
> >  
> >  	msbp = msb;
> > -	rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
> >  
> >  	/* calculate deltas */
> >  	if (tp->t_blk_res > 0)
> > @@ -547,8 +544,7 @@ xfs_trans_unreserve_and_mod_sb(
> >  
> >  	/* apply the per-cpu counters */
> >  	if (blkdelta) {
> > -		error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
> > -						 blkdelta, rsvd);
> > +		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
> >  		if (error)
> >  			goto out;
> >  	}
> > @@ -635,7 +631,7 @@ out_undo_icount:
> >  		xfs_mod_icount(mp, -idelta);
> >  out_undo_fdblocks:
> >  	if (blkdelta)
> > -		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS, -blkdelta, rsvd);
> > +		xfs_mod_fdblocks(mp, -blkdelta, rsvd);
> >  out:
> >  	ASSERT(error == 0);
> >  	return;
> > -- 
> > 2.0.0
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
