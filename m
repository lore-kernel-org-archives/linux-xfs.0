Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC4777F3F
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 08:10:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA8EE304039
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 06:10:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YHfgCqhnG7eSoj2Z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 06:10:33 -0800 (PST)
Date: Thu, 5 Feb 2015 09:10:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/7] xfs: Remove icsb infrastructure
Message-ID: <20150205141024.GF31625@laptop.bfoster>
References: <1423083249-27493-1-git-send-email-david@fromorbit.com>
	<1423083249-27493-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423083249-27493-5-git-send-email-david@fromorbit.com>
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

On Thu, Feb 05, 2015 at 07:54:06AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the in-core superblock infrastructure has been replaced with
> generic per-cpu counters, we don't need it anymore. Nuke it from
> orbit so we are sure that it won't haunt us again...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_sb.c   |   8 +-
>  fs/xfs/xfs_fsops.c       |   2 -
>  fs/xfs/xfs_iomap.c       |   1 -
>  fs/xfs/xfs_linux.h       |   9 -
>  fs/xfs/xfs_log_recover.c |   4 +-
>  fs/xfs/xfs_mount.c       | 516 +----------------------------------------------
>  fs/xfs/xfs_mount.h       |  67 ------
>  fs/xfs/xfs_super.c       |  84 ++++++--
>  fs/xfs/xfs_super.h       |   2 +
>  9 files changed, 72 insertions(+), 621 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 31a3e97..a270095 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -743,17 +743,15 @@ xfs_initialize_perag_data(
>  		btree += pag->pagf_btreeblks;
>  		xfs_perag_put(pag);
>  	}
> -	/*
> -	 * Overwrite incore superblock counters with just-read data
> -	 */
> +
> +	/* Overwrite incore superblock counters with just-read data */
>  	spin_lock(&mp->m_sb_lock);
>  	sbp->sb_ifree = ifree;
>  	sbp->sb_icount = ialloc;
>  	sbp->sb_fdblocks = bfree + bfreelst + btree;
>  	spin_unlock(&mp->m_sb_lock);
>  
> -	/* Fixup the per-cpu counters as well. */
> -	xfs_icsb_reinit_counters(mp);
> +	xfs_reinit_percpu_counters(mp);
>  
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index fed97a9..a45c82b4 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -630,7 +630,6 @@ xfs_fs_counts(
>  	xfs_mount_t		*mp,
>  	xfs_fsop_counts_t	*cnt)
>  {
> -	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
>  	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
>  	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
>  	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
> @@ -694,7 +693,6 @@ xfs_reserve_blocks(
>  	 */
>  retry:
>  	spin_lock(&mp->m_sb_lock);
> -	xfs_icsb_sync_counters_locked(mp, 0);
>  
>  	/*
>  	 * If our previous reservation was larger than the current value,
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 205b948..38e633b 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -460,7 +460,6 @@ xfs_iomap_prealloc_size(
>  	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(MAXEXTLEN),
>  				       alloc_blocks);
>  
> -	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
>  	freesp = percpu_counter_read_positive(&mp->m_fdblocks);
>  	if (freesp < mp->m_low_space[XFS_LOWSP_5_PCNT]) {
>  		shift = 2;
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index c31d2c2..7c7842c 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -116,15 +116,6 @@ typedef __uint64_t __psunsigned_t;
>  #undef XFS_NATIVE_HOST
>  #endif
>  
> -/*
> - * Feature macros (disable/enable)
> - */
> -#ifdef CONFIG_SMP
> -#define HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */
> -#else
> -#undef  HAVE_PERCPU_SB	/* per cpu superblock counters are a 2.6 feature */
> -#endif
> -
>  #define irix_sgid_inherit	xfs_params.sgid_inherit.val
>  #define irix_symlink_mode	xfs_params.symlink_mode.val
>  #define xfs_panic_mask		xfs_params.panic_mask.val
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index a5a945f..4f5784f 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4463,10 +4463,10 @@ xlog_do_recover(
>  	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
>  	ASSERT(sbp->sb_magicnum == XFS_SB_MAGIC);
>  	ASSERT(xfs_sb_good_version(sbp));
> +	xfs_reinit_percpu_counters(log->l_mp);
> +
>  	xfs_buf_relse(bp);
>  
> -	/* We've re-read the superblock so re-initialize per-cpu counters */
> -	xfs_icsb_reinit_counters(log->l_mp);
>  
>  	xlog_recover_check_summary(log);
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 9e433b2..1d26200 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -43,18 +43,6 @@
>  #include "xfs_sysfs.h"
>  
>  
> -#ifdef HAVE_PERCPU_SB
> -STATIC void	xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_field_t,
> -						int);
> -STATIC void	xfs_icsb_balance_counter_locked(xfs_mount_t *, xfs_sb_field_t,
> -						int);
> -STATIC void	xfs_icsb_disable_counter(xfs_mount_t *, xfs_sb_field_t);
> -#else
> -
> -#define xfs_icsb_balance_counter(mp, a, b)		do { } while (0)
> -#define xfs_icsb_balance_counter_locked(mp, a, b)	do { } while (0)
> -#endif
> -
>  static DEFINE_MUTEX(xfs_uuid_table_mutex);
>  static int xfs_uuid_table_size;
>  static uuid_t *xfs_uuid_table;
> @@ -347,8 +335,7 @@ reread:
>  		goto reread;
>  	}
>  
> -	/* Initialize per-cpu counters */
> -	xfs_icsb_reinit_counters(mp);
> +	xfs_reinit_percpu_counters(mp);
>  
>  	/* no need to be quiet anymore, so reset the buf ops */
>  	bp->b_ops = &xfs_sb_buf_ops;
> @@ -1087,8 +1074,6 @@ xfs_log_sbcount(xfs_mount_t *mp)
>  	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
>  		return 0;
>  
> -	xfs_icsb_sync_counters(mp, 0);
> -
>  	/*
>  	 * we don't need to do this if we are updating the superblock
>  	 * counters on every modification.
> @@ -1467,502 +1452,3 @@ xfs_dev_is_read_only(
>  	}
>  	return 0;
>  }
> -
> -#ifdef HAVE_PERCPU_SB
> -/*
> - * Per-cpu incore superblock counters
> - *
> - * Simple concept, difficult implementation
> - *
> - * Basically, replace the incore superblock counters with a distributed per cpu
> - * counter for contended fields (e.g.  free block count).
> - *
> - * Difficulties arise in that the incore sb is used for ENOSPC checking, and
> - * hence needs to be accurately read when we are running low on space. Hence
> - * there is a method to enable and disable the per-cpu counters based on how
> - * much "stuff" is available in them.
> - *
> - * Basically, a counter is enabled if there is enough free resource to justify
> - * running a per-cpu fast-path. If the per-cpu counter runs out (i.e. a local
> - * ENOSPC), then we disable the counters to synchronise all callers and
> - * re-distribute the available resources.
> - *
> - * If, once we redistributed the available resources, we still get a failure,
> - * we disable the per-cpu counter and go through the slow path.
> - *
> - * The slow path is the current xfs_mod_incore_sb() function.  This means that
> - * when we disable a per-cpu counter, we need to drain its resources back to
> - * the global superblock. We do this after disabling the counter to prevent
> - * more threads from queueing up on the counter.
> - *
> - * Essentially, this means that we still need a lock in the fast path to enable
> - * synchronisation between the global counters and the per-cpu counters. This
> - * is not a problem because the lock will be local to a CPU almost all the time
> - * and have little contention except when we get to ENOSPC conditions.
> - *
> - * Basically, this lock becomes a barrier that enables us to lock out the fast
> - * path while we do things like enabling and disabling counters and
> - * synchronising the counters.
> - *
> - * Locking rules:
> - *
> - * 	1. m_sb_lock before picking up per-cpu locks
> - * 	2. per-cpu locks always picked up via for_each_online_cpu() order
> - * 	3. accurate counter sync requires m_sb_lock + per cpu locks
> - * 	4. modifying per-cpu counters requires holding per-cpu lock
> - * 	5. modifying global counters requires holding m_sb_lock
> - *	6. enabling or disabling a counter requires holding the m_sb_lock 
> - *	   and _none_ of the per-cpu locks.
> - *
> - * Disabled counters are only ever re-enabled by a balance operation
> - * that results in more free resources per CPU than a given threshold.
> - * To ensure counters don't remain disabled, they are rebalanced when
> - * the global resource goes above a higher threshold (i.e. some hysteresis
> - * is present to prevent thrashing).
> - */
> -
> -#ifdef CONFIG_HOTPLUG_CPU
> -/*
> - * hot-plug CPU notifier support.
> - *
> - * We need a notifier per filesystem as we need to be able to identify
> - * the filesystem to balance the counters out. This is achieved by
> - * having a notifier block embedded in the xfs_mount_t and doing pointer
> - * magic to get the mount pointer from the notifier block address.
> - */
> -STATIC int
> -xfs_icsb_cpu_notify(
> -	struct notifier_block *nfb,
> -	unsigned long action,
> -	void *hcpu)
> -{
> -	xfs_icsb_cnts_t *cntp;
> -	xfs_mount_t	*mp;
> -
> -	mp = (xfs_mount_t *)container_of(nfb, xfs_mount_t, m_icsb_notifier);
> -	cntp = (xfs_icsb_cnts_t *)
> -			per_cpu_ptr(mp->m_sb_cnts, (unsigned long)hcpu);
> -	switch (action) {
> -	case CPU_UP_PREPARE:
> -	case CPU_UP_PREPARE_FROZEN:
> -		/* Easy Case - initialize the area and locks, and
> -		 * then rebalance when online does everything else for us. */
> -		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
> -		break;
> -	case CPU_ONLINE:
> -	case CPU_ONLINE_FROZEN:
> -		xfs_icsb_lock(mp);
> -		xfs_icsb_unlock(mp);
> -		break;
> -	case CPU_DEAD:
> -	case CPU_DEAD_FROZEN:
> -		/* Disable all the counters, then fold the dead cpu's
> -		 * count into the total on the global superblock and
> -		 * re-enable the counters. */
> -		xfs_icsb_lock(mp);
> -		spin_lock(&mp->m_sb_lock);
> -
> -		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
> -
> -		spin_unlock(&mp->m_sb_lock);
> -		xfs_icsb_unlock(mp);
> -		break;
> -	}
> -
> -	return NOTIFY_OK;
> -}
> -#endif /* CONFIG_HOTPLUG_CPU */
> -
> -int
> -xfs_icsb_init_counters(
> -	xfs_mount_t	*mp)
> -{
> -	xfs_icsb_cnts_t *cntp;
> -	int		error;
> -	int		i;
> -
> -	error = percpu_counter_init(&mp->m_icount, 0, GFP_KERNEL);
> -	if (error)
> -		return error;
> -
> -	error = percpu_counter_init(&mp->m_ifree, 0, GFP_KERNEL);
> -	if (error)
> -		goto free_icount;
> -
> -	error = percpu_counter_init(&mp->m_fdblocks, 0, GFP_KERNEL);
> -	if (error)
> -		goto free_ifree;
> -
> -	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
> -	if (!mp->m_sb_cnts) {
> -		error = -ENOMEM;
> -		goto free_fdblocks;
> -	}
> -
> -	for_each_online_cpu(i) {
> -		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
> -		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
> -	}
> -
> -	mutex_init(&mp->m_icsb_mutex);
> -
> -	/*
> -	 * start with all counters disabled so that the
> -	 * initial balance kicks us off correctly
> -	 */
> -	mp->m_icsb_counters = -1;
> -
> -#ifdef CONFIG_HOTPLUG_CPU
> -	mp->m_icsb_notifier.notifier_call = xfs_icsb_cpu_notify;
> -	mp->m_icsb_notifier.priority = 0;
> -	register_hotcpu_notifier(&mp->m_icsb_notifier);
> -#endif /* CONFIG_HOTPLUG_CPU */
> -
> -	return 0;
> -
> -free_fdblocks:
> -	percpu_counter_destroy(&mp->m_fdblocks);
> -free_ifree:
> -	percpu_counter_destroy(&mp->m_ifree);
> -free_icount:
> -	percpu_counter_destroy(&mp->m_icount);
> -	return error;
> -}
> -
> -void
> -xfs_icsb_reinit_counters(
> -	xfs_mount_t	*mp)
> -{
> -	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
> -	percpu_counter_set(&mp->m_ifree, mp->m_sb.sb_ifree);
> -	percpu_counter_set(&mp->m_fdblocks, mp->m_sb.sb_fdblocks);
> -
> -	xfs_icsb_lock(mp);
> -	/*
> -	 * start with all counters disabled so that the
> -	 * initial balance kicks us off correctly
> -	 */
> -	mp->m_icsb_counters = -1;
> -	xfs_icsb_unlock(mp);
> -}
> -
> -void
> -xfs_icsb_destroy_counters(
> -	xfs_mount_t	*mp)
> -{
> -	if (mp->m_sb_cnts) {
> -		unregister_hotcpu_notifier(&mp->m_icsb_notifier);
> -		free_percpu(mp->m_sb_cnts);
> -	}
> -
> -	percpu_counter_destroy(&mp->m_icount);
> -	percpu_counter_destroy(&mp->m_ifree);
> -	percpu_counter_destroy(&mp->m_fdblocks);
> -
> -	mutex_destroy(&mp->m_icsb_mutex);
> -}
> -
> -STATIC void
> -xfs_icsb_lock_cntr(
> -	xfs_icsb_cnts_t	*icsbp)
> -{
> -	while (test_and_set_bit(XFS_ICSB_FLAG_LOCK, &icsbp->icsb_flags)) {
> -		ndelay(1000);
> -	}
> -}
> -
> -STATIC void
> -xfs_icsb_unlock_cntr(
> -	xfs_icsb_cnts_t	*icsbp)
> -{
> -	clear_bit(XFS_ICSB_FLAG_LOCK, &icsbp->icsb_flags);
> -}
> -
> -
> -STATIC void
> -xfs_icsb_lock_all_counters(
> -	xfs_mount_t	*mp)
> -{
> -	xfs_icsb_cnts_t *cntp;
> -	int		i;
> -
> -	for_each_online_cpu(i) {
> -		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
> -		xfs_icsb_lock_cntr(cntp);
> -	}
> -}
> -
> -STATIC void
> -xfs_icsb_unlock_all_counters(
> -	xfs_mount_t	*mp)
> -{
> -	xfs_icsb_cnts_t *cntp;
> -	int		i;
> -
> -	for_each_online_cpu(i) {
> -		cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
> -		xfs_icsb_unlock_cntr(cntp);
> -	}
> -}
> -
> -STATIC void
> -xfs_icsb_count(
> -	xfs_mount_t	*mp,
> -	xfs_icsb_cnts_t	*cnt,
> -	int		flags)
> -{
> -	memset(cnt, 0, sizeof(xfs_icsb_cnts_t));
> -
> -	if (!(flags & XFS_ICSB_LAZY_COUNT))
> -		xfs_icsb_lock_all_counters(mp);
> -
> -
> -	if (!(flags & XFS_ICSB_LAZY_COUNT))
> -		xfs_icsb_unlock_all_counters(mp);
> -}
> -
> -STATIC int
> -xfs_icsb_counter_disabled(
> -	xfs_mount_t	*mp,
> -	xfs_sb_field_t	field)
> -{
> -	return test_bit(field, &mp->m_icsb_counters);
> -}
> -
> -STATIC void
> -xfs_icsb_disable_counter(
> -	xfs_mount_t	*mp,
> -	xfs_sb_field_t	field)
> -{
> -	xfs_icsb_cnts_t	cnt;
> -
> -	/*
> -	 * If we are already disabled, then there is nothing to do
> -	 * here. We check before locking all the counters to avoid
> -	 * the expensive lock operation when being called in the
> -	 * slow path and the counter is already disabled. This is
> -	 * safe because the only time we set or clear this state is under
> -	 * the m_icsb_mutex.
> -	 */
> -	if (xfs_icsb_counter_disabled(mp, field))
> -		return;
> -
> -	xfs_icsb_lock_all_counters(mp);
> -	if (!test_and_set_bit(field, &mp->m_icsb_counters)) {
> -		/* drain back to superblock */
> -
> -		xfs_icsb_count(mp, &cnt, XFS_ICSB_LAZY_COUNT);
> -		switch(field) {
> -		default:
> -			BUG();
> -		}
> -	}
> -
> -	xfs_icsb_unlock_all_counters(mp);
> -}
> -
> -STATIC void
> -xfs_icsb_enable_counter(
> -	xfs_mount_t	*mp,
> -	xfs_sb_field_t	field,
> -	uint64_t	count,
> -	uint64_t	resid)
> -{
> -	int		i;
> -
> -	xfs_icsb_lock_all_counters(mp);
> -	for_each_online_cpu(i) {
> -		switch (field) {
> -		default:
> -			BUG();
> -			break;
> -		}
> -		resid = 0;
> -	}
> -	clear_bit(field, &mp->m_icsb_counters);
> -	xfs_icsb_unlock_all_counters(mp);
> -}
> -
> -void
> -xfs_icsb_sync_counters_locked(
> -	xfs_mount_t	*mp,
> -	int		flags)
> -{
> -	xfs_icsb_cnts_t	cnt;
> -
> -	xfs_icsb_count(mp, &cnt, flags);
> -}
> -
> -/*
> - * Accurate update of per-cpu counters to incore superblock
> - */
> -void
> -xfs_icsb_sync_counters(
> -	xfs_mount_t	*mp,
> -	int		flags)
> -{
> -	spin_lock(&mp->m_sb_lock);
> -	xfs_icsb_sync_counters_locked(mp, flags);
> -	spin_unlock(&mp->m_sb_lock);
> -}
> -
> -/*
> - * Balance and enable/disable counters as necessary.
> - *
> - * Thresholds for re-enabling counters are somewhat magic.  inode counts are
> - * chosen to be the same number as single on disk allocation chunk per CPU, and
> - * free blocks is something far enough zero that we aren't going thrash when we
> - * get near ENOSPC. We also need to supply a minimum we require per cpu to
> - * prevent looping endlessly when xfs_alloc_space asks for more than will
> - * be distributed to a single CPU but each CPU has enough blocks to be
> - * reenabled.
> - *
> - * Note that we can be called when counters are already disabled.
> - * xfs_icsb_disable_counter() optimises the counter locking in this case to
> - * prevent locking every per-cpu counter needlessly.
> - */
> -
> -#define XFS_ICSB_INO_CNTR_REENABLE	(uint64_t)64
> -#define XFS_ICSB_FDBLK_CNTR_REENABLE(mp) \
> -		(uint64_t)(512 + XFS_ALLOC_SET_ASIDE(mp))
> -STATIC void
> -xfs_icsb_balance_counter_locked(
> -	xfs_mount_t	*mp,
> -	xfs_sb_field_t  field,
> -	int		min_per_cpu)
> -{
> -	uint64_t	count, resid;
> -
> -	/* disable counter and sync counter */
> -	xfs_icsb_disable_counter(mp, field);
> -
> -	/* update counters  - first CPU gets residual*/
> -	switch (field) {
> -	default:
> -		BUG();
> -		count = resid = 0;	/* quiet, gcc */
> -		break;
> -	}
> -
> -	xfs_icsb_enable_counter(mp, field, count, resid);
> -}
> -
> -STATIC void
> -xfs_icsb_balance_counter(
> -	xfs_mount_t	*mp,
> -	xfs_sb_field_t  fields,
> -	int		min_per_cpu)
> -{
> -	spin_lock(&mp->m_sb_lock);
> -	xfs_icsb_balance_counter_locked(mp, fields, min_per_cpu);
> -	spin_unlock(&mp->m_sb_lock);
> -}
> -
> -int
> -xfs_icsb_modify_counters(
> -	xfs_mount_t	*mp,
> -	xfs_sb_field_t	field,
> -	int64_t		delta,
> -	int		rsvd)
> -{
> -	xfs_icsb_cnts_t	*icsbp;
> -	int		ret = 0;
> -
> -	might_sleep();
> -again:
> -	preempt_disable();
> -	icsbp = this_cpu_ptr(mp->m_sb_cnts);
> -
> -	/*
> -	 * if the counter is disabled, go to slow path
> -	 */
> -	if (unlikely(xfs_icsb_counter_disabled(mp, field)))
> -		goto slow_path;
> -	xfs_icsb_lock_cntr(icsbp);
> -	if (unlikely(xfs_icsb_counter_disabled(mp, field))) {
> -		xfs_icsb_unlock_cntr(icsbp);
> -		goto slow_path;
> -	}
> -
> -	switch (field) {
> -	default:
> -		BUG();
> -		goto balance_counter; /* be still, gcc */
> -	}
> -	xfs_icsb_unlock_cntr(icsbp);
> -	preempt_enable();
> -	return 0;
> -
> -slow_path:
> -	preempt_enable();
> -
> -	/*
> -	 * serialise with a mutex so we don't burn lots of cpu on
> -	 * the superblock lock. We still need to hold the superblock
> -	 * lock, however, when we modify the global structures.
> -	 */
> -	xfs_icsb_lock(mp);
> -
> -	/*
> -	 * Now running atomically.
> -	 *
> -	 * If the counter is enabled, someone has beaten us to rebalancing.
> -	 * Drop the lock and try again in the fast path....
> -	 */
> -	if (!(xfs_icsb_counter_disabled(mp, field))) {
> -		xfs_icsb_unlock(mp);
> -		goto again;
> -	}
> -
> -	/*
> -	 * The counter is currently disabled. Because we are
> -	 * running atomically here, we know a rebalance cannot
> -	 * be in progress. Hence we can go straight to operating
> -	 * on the global superblock. We do not call xfs_mod_incore_sb()
> -	 * here even though we need to get the m_sb_lock. Doing so
> -	 * will cause us to re-enter this function and deadlock.
> -	 * Hence we get the m_sb_lock ourselves and then call
> -	 * xfs_mod_incore_sb_unlocked() as the unlocked path operates
> -	 * directly on the global counters.
> -	 */
> -	spin_lock(&mp->m_sb_lock);
> -	ret = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
> -	spin_unlock(&mp->m_sb_lock);
> -
> -	/*
> -	 * Now that we've modified the global superblock, we
> -	 * may be able to re-enable the distributed counters
> -	 * (e.g. lots of space just got freed). After that
> -	 * we are done.
> -	 */
> -	if (ret != -ENOSPC)
> -		xfs_icsb_balance_counter(mp, field, 0);
> -	xfs_icsb_unlock(mp);
> -	return ret;
> -
> -balance_counter:
> -	xfs_icsb_unlock_cntr(icsbp);
> -	preempt_enable();
> -
> -	/*
> -	 * We may have multiple threads here if multiple per-cpu
> -	 * counters run dry at the same time. This will mean we can
> -	 * do more balances than strictly necessary but it is not
> -	 * the common slowpath case.
> -	 */
> -	xfs_icsb_lock(mp);
> -
> -	/*
> -	 * running atomically.
> -	 *
> -	 * This will leave the counter in the correct state for future
> -	 * accesses. After the rebalance, we simply try again and our retry
> -	 * will either succeed through the fast path or slow path without
> -	 * another balance operation being required.
> -	 */
> -	xfs_icsb_balance_counter(mp, field, delta);
> -	xfs_icsb_unlock(mp);
> -	goto again;
> -}
> -
> -#endif
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 76f5d25..ff1d1d5 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -18,8 +18,6 @@
>  #ifndef __XFS_MOUNT_H__
>  #define	__XFS_MOUNT_H__
>  
> -#ifdef __KERNEL__
> -
>  struct xlog;
>  struct xfs_inode;
>  struct xfs_mru_cache;
> @@ -29,43 +27,6 @@ struct xfs_quotainfo;
>  struct xfs_dir_ops;
>  struct xfs_da_geometry;
>  
> -#ifdef HAVE_PERCPU_SB
> -
> -/*
> - * Valid per-cpu incore superblock counters. Note that if you add new counters,
> - * you may need to define new counter disabled bit field descriptors as there
> - * are more possible fields in the superblock that can fit in a bitfield on a
> - * 32 bit platform. The XFS_SBS_* values for the current current counters just
> - * fit.
> - */
> -typedef struct xfs_icsb_cnts {
> -	uint64_t	icsb_fdblocks;
> -	uint64_t	icsb_ifree;
> -	unsigned long	icsb_flags;
> -} xfs_icsb_cnts_t;
> -
> -#define XFS_ICSB_FLAG_LOCK	(1 << 0)	/* counter lock bit */
> -
> -#define XFS_ICSB_LAZY_COUNT	(1 << 1)	/* accuracy not needed */
> -
> -extern int	xfs_icsb_init_counters(struct xfs_mount *);
> -extern void	xfs_icsb_reinit_counters(struct xfs_mount *);
> -extern void	xfs_icsb_destroy_counters(struct xfs_mount *);
> -extern void	xfs_icsb_sync_counters(struct xfs_mount *, int);
> -extern void	xfs_icsb_sync_counters_locked(struct xfs_mount *, int);
> -extern int	xfs_icsb_modify_counters(struct xfs_mount *, xfs_sb_field_t,
> -						int64_t, int);
> -
> -#else
> -#define xfs_icsb_init_counters(mp)		(0)
> -#define xfs_icsb_destroy_counters(mp)		do { } while (0)
> -#define xfs_icsb_reinit_counters(mp)		do { } while (0)
> -#define xfs_icsb_sync_counters(mp, flags)	do { } while (0)
> -#define xfs_icsb_sync_counters_locked(mp, flags) do { } while (0)
> -#define xfs_icsb_modify_counters(mp, field, delta, rsvd) \
> -	xfs_mod_incore_sb(mp, field, delta, rsvd)
> -#endif
> -
>  /* dynamic preallocation free space thresholds, 5% down to 1% */
>  enum {
>  	XFS_LOWSP_1_PCNT = 0,
> @@ -156,12 +117,6 @@ typedef struct xfs_mount {
>  	const struct xfs_dir_ops *m_nondir_inode_ops; /* !dir inode ops */
>  	uint			m_chsize;	/* size of next field */
>  	atomic_t		m_active_trans;	/* number trans frozen */
> -#ifdef HAVE_PERCPU_SB
> -	xfs_icsb_cnts_t __percpu *m_sb_cnts;	/* per-cpu superblock counters */
> -	unsigned long		m_icsb_counters; /* disabled per-cpu counters */
> -	struct notifier_block	m_icsb_notifier; /* hotplug cpu notifier */
> -	struct mutex		m_icsb_mutex;	/* balancer sync lock */
> -#endif
>  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
>  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
>  	struct delayed_work	m_eofblocks_work; /* background eof blocks
> @@ -294,26 +249,6 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
>  }
>  
>  /*
> - * Per-cpu superblock locking functions
> - */
> -#ifdef HAVE_PERCPU_SB
> -static inline void
> -xfs_icsb_lock(xfs_mount_t *mp)
> -{
> -	mutex_lock(&mp->m_icsb_mutex);
> -}
> -
> -static inline void
> -xfs_icsb_unlock(xfs_mount_t *mp)
> -{
> -	mutex_unlock(&mp->m_icsb_mutex);
> -}
> -#else
> -#define xfs_icsb_lock(mp)
> -#define xfs_icsb_unlock(mp)
> -#endif
> -
> -/*
>   * This structure is for use by the xfs_mod_incore_sb_batch() routine.
>   * xfs_growfs can specify a few fields which are more than int limit
>   */
> @@ -396,6 +331,4 @@ extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
>  
>  extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
>  
> -#endif	/* __KERNEL__ */
> -
>  #endif	/* __XFS_MOUNT_H__ */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 4c6af31..af6d268 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1035,23 +1035,6 @@ xfs_free_fsname(
>  	kfree(mp->m_logname);
>  }
>  
> -STATIC void
> -xfs_fs_put_super(
> -	struct super_block	*sb)
> -{
> -	struct xfs_mount	*mp = XFS_M(sb);
> -
> -	xfs_filestream_unmount(mp);
> -	xfs_unmountfs(mp);
> -
> -	xfs_freesb(mp);
> -	xfs_icsb_destroy_counters(mp);
> -	xfs_destroy_mount_workqueues(mp);
> -	xfs_close_devices(mp);
> -	xfs_free_fsname(mp);
> -	kfree(mp);
> -}
> -
>  STATIC int
>  xfs_fs_sync_fs(
>  	struct super_block	*sb,
> @@ -1100,7 +1083,6 @@ xfs_fs_statfs(
>  	statp->f_fsid.val[0] = (u32)id;
>  	statp->f_fsid.val[1] = (u32)(id >> 32);
>  
> -	xfs_icsb_sync_counters(mp, XFS_ICSB_LAZY_COUNT);
>  	icount = percpu_counter_sum(&mp->m_icount);
>  	ifree = percpu_counter_sum(&mp->m_ifree);
>  	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> @@ -1405,6 +1387,51 @@ xfs_finish_flags(
>  	return 0;
>  }
>  
> +static int
> +xfs_init_percpu_counters(
> +	struct xfs_mount	*mp)
> +{
> +	int		error;
> +
> +	error = percpu_counter_init(&mp->m_icount, 0, GFP_KERNEL);
> +	if (error)
> +		return ENOMEM;
> +
> +	error = percpu_counter_init(&mp->m_ifree, 0, GFP_KERNEL);
> +	if (error)
> +		goto free_icount;
> +
> +	error = percpu_counter_init(&mp->m_fdblocks, 0, GFP_KERNEL);
> +	if (error)
> +		goto free_ifree;
> +
> +	return 0;
> +
> +free_ifree:
> +	percpu_counter_destroy(&mp->m_ifree);
> +free_icount:
> +	percpu_counter_destroy(&mp->m_icount);
> +	return -ENOMEM;
> +}
> +
> +void
> +xfs_reinit_percpu_counters(
> +	struct xfs_mount	*mp)
> +{
> +	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
> +	percpu_counter_set(&mp->m_ifree, mp->m_sb.sb_ifree);
> +	percpu_counter_set(&mp->m_fdblocks, mp->m_sb.sb_fdblocks);
> +}
> +
> +static void
> +xfs_destroy_percpu_counters(
> +	struct xfs_mount	*mp)
> +{
> +	percpu_counter_destroy(&mp->m_icount);
> +	percpu_counter_destroy(&mp->m_ifree);
> +	percpu_counter_destroy(&mp->m_fdblocks);
> +}
> +
>  STATIC int
>  xfs_fs_fill_super(
>  	struct super_block	*sb,
> @@ -1453,7 +1480,7 @@ xfs_fs_fill_super(
>  	if (error)
>  		goto out_close_devices;
>  
> -	error = xfs_icsb_init_counters(mp);
> +	error = xfs_init_percpu_counters(mp);
>  	if (error)
>  		goto out_destroy_workqueues;
>  
> @@ -1511,7 +1538,7 @@ xfs_fs_fill_super(
>   out_free_sb:
>  	xfs_freesb(mp);
>   out_destroy_counters:
> -	xfs_icsb_destroy_counters(mp);
> +	xfs_destroy_percpu_counters(mp);
>  out_destroy_workqueues:
>  	xfs_destroy_mount_workqueues(mp);
>   out_close_devices:
> @@ -1528,6 +1555,23 @@ out_destroy_workqueues:
>  	goto out_free_sb;
>  }
>  
> +STATIC void
> +xfs_fs_put_super(
> +	struct super_block	*sb)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +
> +	xfs_filestream_unmount(mp);
> +	xfs_unmountfs(mp);
> +
> +	xfs_freesb(mp);
> +	xfs_destroy_percpu_counters(mp);
> +	xfs_destroy_mount_workqueues(mp);
> +	xfs_close_devices(mp);
> +	xfs_free_fsname(mp);
> +	kfree(mp);
> +}
> +
>  STATIC struct dentry *
>  xfs_fs_mount(
>  	struct file_system_type	*fs_type,
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 2b830c2..499058f 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -72,6 +72,8 @@ extern const struct export_operations xfs_export_operations;
>  extern const struct xattr_handler *xfs_xattr_handlers[];
>  extern const struct quotactl_ops xfs_quotactl_operations;
>  
> +extern void xfs_reinit_percpu_counters(struct xfs_mount *mp);
> +
>  #define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
>  
>  #endif	/* __XFS_SUPER_H__ */
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
