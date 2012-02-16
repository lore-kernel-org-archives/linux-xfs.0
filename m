Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GILIdN010421 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 12:21:18 -0600
Date: Thu, 16 Feb 2012 12:21:21 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 01/12] xfs: split tail_lsn assignments from log space
	wakeups
Message-ID: <20120216182121.GQ7762@sgi.com>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141433.542846138@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212141433.542846138@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Dec 12, 2011 at 09:13:48AM -0500, Christoph Hellwig wrote:
> Currently xfs_log_move_tail has a tail_lsn argument that is horribly
> overloaded: it may contain either an actual lsn to assign to the log tail,
> 0 as a special case to use the last sync LSN, or 1 to indicate that no tail
> LSN assignment should be performed, and we should opportunisticly wake up
> at least one task waiting for log space.
> 
> Remove the tail lsn assigned from xfs_log_move_tail and make the two callers
> use xlog_assign_tail_lsn instead of the current variant of partially using
> the code in xfs_log_move_tail and partially opencoding it.  Note that means
> we grow an addition lock roundtrip on the AIL lock for each bulk update
> or delete, which is still far less than what we had before introducing the
> bulk operations.  If this proves to be a problem we can still add a variant
> of xlog_assign_tail_lsn that expects the lock to be held already.
> 
> Also rename the remainder of xfs_log_move_tail to xfs_log_space_wake as
> that name describes its functionality much better.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_log.c       |   74 ++++++++++++++++++++-----------------------------
>  fs/xfs/xfs_log.h       |    5 +--
>  fs/xfs/xfs_log_priv.h  |    1 
>  fs/xfs/xfs_trans_ail.c |   45 +++++++----------------------
>  4 files changed, 45 insertions(+), 80 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2011-11-29 08:38:46.856733941 +0100
> +++ xfs/fs/xfs/xfs_log.c	2011-11-29 08:38:48.576724621 +0100
> @@ -760,37 +760,35 @@ xfs_log_item_init(
>  	INIT_LIST_HEAD(&item->li_cil);
>  }
>  
> +/*
> + * Wake up processes waiting for log space after we have moved the log tail.
> + *
> + * If opportunistic is set wake up one waiter even if we do not have enough
> + * free space by our strict accounting.
> + */
>  void
> -xfs_log_move_tail(xfs_mount_t	*mp,
> -		  xfs_lsn_t	tail_lsn)
> +xfs_log_space_wake(
> +	struct xfs_mount	*mp,
> +	bool			opportunistic)
>  {
> -	xlog_ticket_t	*tic;
> -	xlog_t		*log = mp->m_log;
> -	int		need_bytes, free_bytes;
> +	struct xlog_ticket	*tic;
> +	struct log		*log = mp->m_log;
> +	int			need_bytes, free_bytes;
>  
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return;
>  
> -	if (tail_lsn == 0)
> -		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
> -
> -	/* tail_lsn == 1 implies that we weren't passed a valid value.  */
> -	if (tail_lsn != 1)
> -		atomic64_set(&log->l_tail_lsn, tail_lsn);
> -
>  	if (!list_empty_careful(&log->l_writeq)) {
> -#ifdef DEBUG
> -		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
> -			panic("Recovery problem");
> -#endif
> +		ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
> +
>  		spin_lock(&log->l_grant_write_lock);
>  		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
>  		list_for_each_entry(tic, &log->l_writeq, t_queue) {
>  			ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
>  
> -			if (free_bytes < tic->t_unit_res && tail_lsn != 1)
> +			if (free_bytes < tic->t_unit_res && !opportunistic)
>  				break;
> -			tail_lsn = 0;
> +			opportunistic = false;

One idea I didn't get right away related to the opportunistic wakes is
that we were wanting to wake one from the write queue, if there were
waiters on it.  But, we wouldn't subsequently go after one on the
reserveq.  If there were no waiters on the writeq we wanted to wake one
on the reserveq.  A return might have been clearer here instead of a
break, but it doesn't matter anymore...  You've removed the all inexact
opportunistic wakes in subsequent patches.

>  			free_bytes -= tic->t_unit_res;
>  			trace_xfs_log_regrant_write_wake_up(log, tic);
>  			wake_up(&tic->t_wait);
> @@ -799,10 +797,8 @@ xfs_log_move_tail(xfs_mount_t	*mp,
>  	}
>  
>  	if (!list_empty_careful(&log->l_reserveq)) {
> -#ifdef DEBUG
> -		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
> -			panic("Recovery problem");
> -#endif
> +		ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
> +
>  		spin_lock(&log->l_grant_reserve_lock);
>  		free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
>  		list_for_each_entry(tic, &log->l_reserveq, t_queue) {
> @@ -810,9 +806,9 @@ xfs_log_move_tail(xfs_mount_t	*mp,
>  				need_bytes = tic->t_unit_res*tic->t_cnt;
>  			else
>  				need_bytes = tic->t_unit_res;
> -			if (free_bytes < need_bytes && tail_lsn != 1)
> +			if (free_bytes < need_bytes && !opportunistic)
>  				break;
> -			tail_lsn = 0;
> +			opportunistic = false;
>  			free_bytes -= need_bytes;
>  			trace_xfs_log_grant_wake_up(log, tic);
>  			wake_up(&tic->t_wait);
> @@ -867,21 +863,7 @@ xfs_log_need_covered(xfs_mount_t *mp)
>  	return needed;
>  }
>  
> -/******************************************************************************
> - *
> - *	local routines
> - *
> - ******************************************************************************
> - */
> -
> -/* xfs_trans_tail_ail returns 0 when there is nothing in the list.
> - * The log manager must keep track of the last LR which was committed
> - * to disk.  The lsn of this LR will become the new tail_lsn whenever
> - * xfs_trans_tail_ail returns 0.  If we don't do this, we run into
> - * the situation where stuff could be written into the log but nothing
> - * was ever in the AIL when asked.  Eventually, we panic since the
> - * tail hits the head.
> - *
> +/*
>   * We may be holding the log iclog lock upon entering this routine.
>   */
>  xfs_lsn_t
> @@ -891,10 +873,17 @@ xlog_assign_tail_lsn(
>  	xfs_lsn_t		tail_lsn;
>  	struct log		*log = mp->m_log;
>  
> +	/*
> +	 * To make sure we always have a valid LSN for the log tail we keep
> +	 * track of the last LSN which was committed in log->l_last_sync_lsn,
> +	 * and use that when the AIL was empty and xfs_ail_min_lsn returns 0.
> +	 *
> +	 * If the AIL has been emptied we also need to wake any process
> +	 * waiting for this condition.
> +	 */
>  	tail_lsn = xfs_ail_min_lsn(mp->m_ail);
>  	if (!tail_lsn)
>  		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
> -
>  	atomic64_set(&log->l_tail_lsn, tail_lsn);
>  	return tail_lsn;
>  }
> @@ -2759,9 +2748,8 @@ xlog_ungrant_log_space(xlog_t	     *log,
>  
>  	trace_xfs_log_ungrant_exit(log, ticket);
>  
> -	xfs_log_move_tail(log->l_mp, 1);
> -}	/* xlog_ungrant_log_space */
> -
> +	xfs_log_space_wake(log->l_mp, true);
> +}
>  
>  /*
>   * Flush iclog to disk if this is the last reference to the given iclog and
> Index: xfs/fs/xfs/xfs_trans_ail.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-11-29 08:38:46.870067201 +0100
> +++ xfs/fs/xfs/xfs_trans_ail.c	2011-11-29 08:38:48.580057936 +0100
> @@ -643,15 +643,15 @@ xfs_trans_unlocked_item(
>  	 * at the tail, it doesn't matter what result we get back.  This
>  	 * is slightly racy because since we were just unlocked, we could
>  	 * go to sleep between the call to xfs_ail_min and the call to
> -	 * xfs_log_move_tail, have someone else lock us, commit to us disk,
> +	 * xfs_log_space_wake, have someone else lock us, commit to us disk,
>  	 * move us out of the tail of the AIL, and then we wake up.  However,
> -	 * the call to xfs_log_move_tail() doesn't do anything if there's
> +	 * the call to xfs_log_space_wake() doesn't do anything if there's
>  	 * not enough free space to wake people up so we're safe calling it.
>  	 */
>  	min_lip = xfs_ail_min(ailp);
>  
>  	if (min_lip == lip)
> -		xfs_log_move_tail(ailp->xa_mount, 1);
> +		xfs_log_space_wake(ailp->xa_mount, 1);
>  }	/* xfs_trans_unlocked_item */
>  
>  /*
> @@ -685,7 +685,6 @@ xfs_trans_ail_update_bulk(
>  	xfs_lsn_t		lsn) __releases(ailp->xa_lock)
>  {
>  	xfs_log_item_t		*mlip;
> -	xfs_lsn_t		tail_lsn;
>  	int			mlip_changed = 0;
>  	int			i;
>  	LIST_HEAD(tmp);
> @@ -712,22 +711,12 @@ xfs_trans_ail_update_bulk(
>  
>  	if (!list_empty(&tmp))
>  		xfs_ail_splice(ailp, cur, &tmp, lsn);
> +	spin_unlock(&ailp->xa_lock);

Right.  I am uncomfortable with the idea of dropping the ail lock here
and then retaking it below in xlog_assign_tail_lsn.  Your suggestion
that a variant of xlog_assign_tail_lsn which expects the lock to be held
seems reasonable.

>  
> -	if (!mlip_changed) {
> -		spin_unlock(&ailp->xa_lock);
> -		return;
> +	if (mlip_changed && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
> +		xlog_assign_tail_lsn(ailp->xa_mount);
> +		xfs_log_space_wake(ailp->xa_mount, false);
>  	}
> -
> -	/*
> -	 * It is not safe to access mlip after the AIL lock is dropped, so we
> -	 * must get a copy of li_lsn before we do so.  This is especially
> -	 * important on 32-bit platforms where accessing and updating 64-bit
> -	 * values like li_lsn is not atomic.
> -	 */
> -	mlip = xfs_ail_min(ailp);
> -	tail_lsn = mlip->li_lsn;
> -	spin_unlock(&ailp->xa_lock);
> -	xfs_log_move_tail(ailp->xa_mount, tail_lsn);

I mean... since we're updating the tail_lsn after we drop the ail lock,
we could be updating it to a stale value, after some other thread took
the ail lock and updated the first entry of the ail.  So maybe what I'm
getting at isn't a problem with your patch.  It now lies in
xlog_assign_tail_lsn.  Even if we do drop the ail lock here in
xfs_trans_ail_update_bulk before calling xlog_assign_tail_lsn, we will
still get the right value for xfs_ail_min.

So, I think my concern for the dropping the ail lock earlier in
xfs_trains_ail_update_bulk and delete_bulk is unfounded.  But maybe we
have an issue with xlog_assign_tail_lsn.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
