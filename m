Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 025637FFC
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 08:10:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E524E8F804C
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 06:10:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rdPaZPy9Upba6673 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 06:10:12 -0800 (PST)
Date: Thu, 5 Feb 2015 09:10:05 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/7] xfs: use generic percpu counters for free inode
	counter
Message-ID: <20150205141005.GD31625@laptop.bfoster>
References: <1423083249-27493-1-git-send-email-david@fromorbit.com>
	<1423083249-27493-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423083249-27493-3-git-send-email-david@fromorbit.com>
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

On Thu, Feb 05, 2015 at 07:54:04AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS has hand-rolled per-cpu counters for the superblock since before
> there was any generic implementation. The free inode counter is not
> used for any limit enforcement - the per-AG free inode counters are
> used during allocation to determine if there are inode available for
> allocation.
> 
> Hence we don't need any of the complexity of the hand-rolled
> counters and we can simply replace them with generic per-cpu
> counters similar to the inode counter.
> 
> This version introduces a xfs_mod_ifree() helper function from
> Christoph Hellwig.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_sb.c |  1 +
>  fs/xfs/xfs_fsops.c     |  2 +-
>  fs/xfs/xfs_mount.c     | 76 ++++++++++++++++++++++----------------------------
>  fs/xfs/xfs_mount.h     |  2 ++
>  fs/xfs/xfs_super.c     |  4 ++-
>  fs/xfs/xfs_trans.c     |  5 ++--
>  6 files changed, 42 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 017cb2f..b66aeab 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -772,6 +772,7 @@ xfs_log_sb(
>  	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp, 0);
>  
>  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> +	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
>  
>  	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index e1470f2..fa74d03 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -632,11 +632,11 @@ xfs_fs_counts(
>  {
>  	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
>  	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
> +	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
>  
>  	spin_lock(&mp->m_sb_lock);
>  	cnt->freedata = mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
>  	cnt->freertx = mp->m_sb.sb_frextents;
> -	cnt->freeino = mp->m_sb.sb_ifree;
>  	spin_unlock(&mp->m_sb_lock);
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 702ea6a..650e8f1 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1114,6 +1114,20 @@ xfs_mod_icount(
>  	return 0;
>  }
>  
> +
> +int
> +xfs_mod_ifree(
> +	struct xfs_mount	*mp,
> +	int64_t			delta)
> +{
> +	percpu_counter_add(&mp->m_ifree, delta);
> +	if (percpu_counter_compare(&mp->m_ifree, 0) < 0) {
> +		ASSERT(0);
> +		percpu_counter_add(&mp->m_ifree, -delta);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
>  /*
>   * xfs_mod_incore_sb_unlocked() is a utility routine commonly used to apply
>   * a delta to a specified field in the in-core superblock.  Simply
> @@ -1142,17 +1156,9 @@ xfs_mod_incore_sb_unlocked(
>  	 */
>  	switch (field) {
>  	case XFS_SBS_ICOUNT:
> -		ASSERT(0);
> -		return -ENOSPC;
>  	case XFS_SBS_IFREE:
> -		lcounter = (long long)mp->m_sb.sb_ifree;
> -		lcounter += delta;
> -		if (lcounter < 0) {
> -			ASSERT(0);
> -			return -EINVAL;
> -		}
> -		mp->m_sb.sb_ifree = lcounter;
> -		return 0;
> +		ASSERT(0);
> +		return -EINVAL;
>  	case XFS_SBS_FDBLOCKS:
>  		lcounter = (long long)
>  			mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
> @@ -1502,7 +1508,6 @@ xfs_icsb_cpu_notify(
>  	case CPU_ONLINE:
>  	case CPU_ONLINE_FROZEN:
>  		xfs_icsb_lock(mp);
> -		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
>  		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
>  		xfs_icsb_unlock(mp);
>  		break;
> @@ -1513,15 +1518,12 @@ xfs_icsb_cpu_notify(
>  		 * re-enable the counters. */
>  		xfs_icsb_lock(mp);
>  		spin_lock(&mp->m_sb_lock);
> -		xfs_icsb_disable_counter(mp, XFS_SBS_IFREE);
>  		xfs_icsb_disable_counter(mp, XFS_SBS_FDBLOCKS);
>  
> -		mp->m_sb.sb_ifree += cntp->icsb_ifree;
>  		mp->m_sb.sb_fdblocks += cntp->icsb_fdblocks;
>  
>  		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
>  
> -		xfs_icsb_balance_counter_locked(mp, XFS_SBS_IFREE, 0);
>  		xfs_icsb_balance_counter_locked(mp, XFS_SBS_FDBLOCKS, 0);
>  		spin_unlock(&mp->m_sb_lock);
>  		xfs_icsb_unlock(mp);
> @@ -1544,10 +1546,14 @@ xfs_icsb_init_counters(
>  	if (error)
>  		return error;
>  
> +	error = percpu_counter_init(&mp->m_ifree, 0, GFP_KERNEL);
> +	if (error)
> +		goto free_icount;
> +
>  	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
>  	if (!mp->m_sb_cnts) {
> -		percpu_counter_destroy(&mp->m_icount);
> -		return -ENOMEM;
> +		error = -ENOMEM;
> +		goto free_ifree;
>  	}
>  
>  	for_each_online_cpu(i) {
> @@ -1570,6 +1576,12 @@ xfs_icsb_init_counters(
>  #endif /* CONFIG_HOTPLUG_CPU */
>  
>  	return 0;
> +
> +free_ifree:
> +	percpu_counter_destroy(&mp->m_ifree);
> +free_icount:
> +	percpu_counter_destroy(&mp->m_icount);
> +	return error;
>  }
>  
>  void
> @@ -1577,6 +1589,7 @@ xfs_icsb_reinit_counters(
>  	xfs_mount_t	*mp)
>  {
>  	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
> +	percpu_counter_set(&mp->m_ifree, mp->m_sb.sb_ifree);
>  
>  	xfs_icsb_lock(mp);
>  	/*
> @@ -1584,7 +1597,6 @@ xfs_icsb_reinit_counters(
>  	 * initial balance kicks us off correctly
>  	 */
>  	mp->m_icsb_counters = -1;
> -	xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0);
>  	xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS, 0);
>  	xfs_icsb_unlock(mp);
>  }
> @@ -1599,6 +1611,7 @@ xfs_icsb_destroy_counters(
>  	}
>  
>  	percpu_counter_destroy(&mp->m_icount);
> +	percpu_counter_destroy(&mp->m_ifree);
>  
>  	mutex_destroy(&mp->m_icsb_mutex);
>  }
> @@ -1662,7 +1675,6 @@ xfs_icsb_count(
>  
>  	for_each_online_cpu(i) {
>  		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
> -		cnt->icsb_ifree += cntp->icsb_ifree;
>  		cnt->icsb_fdblocks += cntp->icsb_fdblocks;
>  	}
>  
> @@ -1675,7 +1687,7 @@ xfs_icsb_counter_disabled(
>  	xfs_mount_t	*mp,
>  	xfs_sb_field_t	field)
>  {
> -	ASSERT((field >= XFS_SBS_IFREE) && (field <= XFS_SBS_FDBLOCKS));
> +	ASSERT(field == XFS_SBS_FDBLOCKS);
>  	return test_bit(field, &mp->m_icsb_counters);
>  }
>  
> @@ -1686,7 +1698,7 @@ xfs_icsb_disable_counter(
>  {
>  	xfs_icsb_cnts_t	cnt;
>  
> -	ASSERT((field >= XFS_SBS_IFREE) && (field <= XFS_SBS_FDBLOCKS));
> +	ASSERT(field == XFS_SBS_FDBLOCKS);
>  
>  	/*
>  	 * If we are already disabled, then there is nothing to do
> @@ -1705,9 +1717,6 @@ xfs_icsb_disable_counter(
>  
>  		xfs_icsb_count(mp, &cnt, XFS_ICSB_LAZY_COUNT);
>  		switch(field) {
> -		case XFS_SBS_IFREE:
> -			mp->m_sb.sb_ifree = cnt.icsb_ifree;
> -			break;
>  		case XFS_SBS_FDBLOCKS:
>  			mp->m_sb.sb_fdblocks = cnt.icsb_fdblocks;
>  			break;
> @@ -1729,15 +1738,12 @@ xfs_icsb_enable_counter(
>  	xfs_icsb_cnts_t	*cntp;
>  	int		i;
>  
> -	ASSERT((field >= XFS_SBS_IFREE) && (field <= XFS_SBS_FDBLOCKS));
> +	ASSERT(field == XFS_SBS_FDBLOCKS);
>  
>  	xfs_icsb_lock_all_counters(mp);
>  	for_each_online_cpu(i) {
>  		cntp = per_cpu_ptr(mp->m_sb_cnts, i);
>  		switch (field) {
> -		case XFS_SBS_IFREE:
> -			cntp->icsb_ifree = count + resid;
> -			break;
>  		case XFS_SBS_FDBLOCKS:
>  			cntp->icsb_fdblocks = count + resid;
>  			break;
> @@ -1760,8 +1766,6 @@ xfs_icsb_sync_counters_locked(
>  
>  	xfs_icsb_count(mp, &cnt, flags);
>  
> -	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_IFREE))
> -		mp->m_sb.sb_ifree = cnt.icsb_ifree;
>  	if (!xfs_icsb_counter_disabled(mp, XFS_SBS_FDBLOCKS))
>  		mp->m_sb.sb_fdblocks = cnt.icsb_fdblocks;
>  }
> @@ -1813,12 +1817,6 @@ xfs_icsb_balance_counter_locked(
>  
>  	/* update counters  - first CPU gets residual*/
>  	switch (field) {
> -	case XFS_SBS_IFREE:
> -		count = mp->m_sb.sb_ifree;
> -		resid = do_div(count, weight);
> -		if (count < max(min, XFS_ICSB_INO_CNTR_REENABLE))
> -			return;
> -		break;
>  	case XFS_SBS_FDBLOCKS:
>  		count = mp->m_sb.sb_fdblocks;
>  		resid = do_div(count, weight);
> @@ -1873,14 +1871,6 @@ again:
>  	}
>  
>  	switch (field) {
> -	case XFS_SBS_IFREE:
> -		lcounter = icsbp->icsb_ifree;
> -		lcounter += delta;
> -		if (unlikely(lcounter < 0))
> -			goto balance_counter;
> -		icsbp->icsb_ifree = lcounter;
> -		break;
> -
>  	case XFS_SBS_FDBLOCKS:
>  		BUG_ON((mp->m_resblks - mp->m_resblks_avail) != 0);
>  
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 457c6e3..0cb32ce 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -84,6 +84,7 @@ typedef struct xfs_mount {
>  	struct xfs_sb		m_sb;		/* copy of fs superblock */
>  	spinlock_t		m_sb_lock;	/* sb counter lock */
>  	struct percpu_counter	m_icount;	/* allocated inodes counter */
> +	struct percpu_counter	m_ifree;	/* free inodes counter */
>  
>  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
>  	char			*m_fsname;	/* filesystem name */
> @@ -380,6 +381,7 @@ extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
>  extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
>  			uint, int);
>  extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
> +extern int	xfs_mod_ifree(struct xfs_mount *mp, int64_t delta);
>  extern int	xfs_mount_log_sb(xfs_mount_t *);
>  extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
>  extern int	xfs_readsb(xfs_mount_t *, int);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 87e169f..e06aa6b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1088,6 +1088,7 @@ xfs_fs_statfs(
>  	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
>  	__uint64_t		fakeinos, id;
>  	__uint64_t		icount;
> +	__uint64_t		ifree;
>  	xfs_extlen_t		lsize;
>  	__int64_t		ffree;
>  
> @@ -1100,6 +1101,7 @@ xfs_fs_statfs(
>  
>  	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
>  	icount = percpu_counter_sum(&mp->m_icount);
> +	ifree = percpu_counter_sum(&mp->m_ifree);
>  
>  	spin_lock(&mp->m_sb_lock);
>  	statp->f_bsize = sbp->sb_blocksize;
> @@ -1115,7 +1117,7 @@ xfs_fs_statfs(
>  					mp->m_maxicount);
>  
>  	/* make sure statp->f_ffree does not underflow */
> -	ffree = statp->f_files - (icount - sbp->sb_ifree);
> +	ffree = statp->f_files - (icount - ifree);
>  	statp->f_ffree = max_t(__int64_t, ffree, 0);
>  
>  	spin_unlock(&mp->m_sb_lock);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 9bc742b..68680ce 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -560,8 +560,7 @@ xfs_trans_unreserve_and_mod_sb(
>  	}
>  
>  	if (ifreedelta) {
> -		error = xfs_icsb_modify_counters(mp, XFS_SBS_IFREE,
> -						 ifreedelta, rsvd);
> +		error = xfs_mod_ifree(mp, ifreedelta);
>  		if (error)
>  			goto out_undo_icount;
>  	}
> @@ -630,7 +629,7 @@ xfs_trans_unreserve_and_mod_sb(
>  
>  out_undo_ifreecount:
>  	if (ifreedelta)
> -		xfs_icsb_modify_counters(mp, XFS_SBS_IFREE, -ifreedelta, rsvd);
> +		xfs_mod_ifree(mp, -ifreedelta);
>  out_undo_icount:
>  	if (idelta)
>  		xfs_mod_icount(mp, -idelta);
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
