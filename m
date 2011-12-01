Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB1JT0Ef020311 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 13:29:01 -0600
Received: from e31.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80AFE4D4AA0
	for <xfs@oss.sgi.com>; Thu,  1 Dec 2011 11:29:00 -0800 (PST)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id e5CHHFRdGig9Vvav for
	<xfs@oss.sgi.com>; Thu, 01 Dec 2011 11:29:00 -0800 (PST)
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 1 Dec 2011 12:28:59 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pB1JSau3068332 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 12:28:37 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id pB1JSZAL018914
	for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 12:28:35 -0700
Subject: Re: [PATCH 4/4] xfs: fix the logspace waiting algorithm
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20111128081925.981681380@bombadil.infradead.org>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111128081925.981681380@bombadil.infradead.org>
Date: Thu, 01 Dec 2011 13:28:33 -0600
Message-ID: <1322767713.7115.1548.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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

Tested the patch with testcases 234 and 273. They ran for more than 350
iterations without getting into the hang situation.

Tested-by: Chandra Seetharaman <sekharan@us.ibm.com>

Few generic comments on the patch

1. xlog_*_wake could use something to indicate that they are looking for
log space in the specific queue. ex: xlog_reserveq_available()

2. All new functions expect a lock to be held on entry. Can be
explicitly specified in a comment.

3. Change the trace function names to reflect the names of the
function ?!

Otherwise patch looks good and works fine.

Chandra
------- end of comments ------
On Mon, 2011-11-28 at 03:17 -0500, Christoph Hellwig wrote:
> plain text document attachment (xfs-fix-log-race)
> Apply the scheme used in log_regrant_write_log_space to wake up any other
> threads waiting for log space before the newly added one to
> log_regrant_write_log_space as well, and factor the code into readable
> helpers.  For each of the queues we have add two helpers:
> 
>  - one to try to wake up all waiting threads.  This helper will also be
>    usable by xfs_log_move_tail once we remove the current opportunistic
>    wakeups in it.
>  - one to sleep on t_wait until enough log space is available, loosely
>    modelled after Linux waitqueues.
> 
> And use them to reimplement the guts of log_regrant_write_log_space and
> log_regrant_write_log_space.  These two function now use one and the same
> algorithm for waiting on log space instead of subtly different ones before,
> with an option to completely unify them in the near future.
> 
> Also move the filesystem shutdown handling to the common caller given
> that we had to touch it anyway.
> 
> Based on hard debugging and an earlier patch from
> Chandra Seetharaman <sekharan@us.ibm.com>.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_log.c   |  348 ++++++++++++++++++++++++++---------------------------
>  fs/xfs/xfs_trace.h |   12 -
>  2 files changed, 177 insertions(+), 183 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2011-11-20 16:29:49.356194023 +0100
> +++ xfs/fs/xfs/xfs_log.c	2011-11-20 16:46:33.440754431 +0100
> @@ -150,6 +150,117 @@ xlog_grant_add_space(
>  	} while (head_val != old);
>  }
> 
> +STATIC bool
> +xlog_reserveq_wake(
> +	struct log		*log,
> +	int			*free_bytes)
> +{
> +	struct xlog_ticket	*tic;
> +	int			need_bytes;
> +
> +	list_for_each_entry(tic, &log->l_reserveq, t_queue) {
> +		if (tic->t_flags & XLOG_TIC_PERM_RESERV)
> +			need_bytes = tic->t_unit_res * tic->t_cnt;
> +		else
> +			need_bytes = tic->t_unit_res;
> +
> +		if (*free_bytes < need_bytes)
> +			return false;
> +		*free_bytes -= need_bytes;
> +
> +		trace_xfs_log_grant_wake_up(log, tic);
> +		wake_up(&tic->t_wait);
> +	}
> +
> +	return true;
> +}
> +
> +STATIC bool
> +xlog_writeq_wake(
> +	struct log		*log,
> +	int			*free_bytes)
> +{
> +	struct xlog_ticket	*tic;
> +	int			need_bytes;
> +
> +	list_for_each_entry(tic, &log->l_writeq, t_queue) {
> +		ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
> +
> +		need_bytes = tic->t_unit_res;
> +
> +		if (*free_bytes < need_bytes)
> +			return false;
> +		*free_bytes -= need_bytes;
> +
> +		trace_xfs_log_regrant_write_wake_up(log, tic);
> +		wake_up(&tic->t_wait);
> +	}
> +
> +	return true;
> +}
> +
> +STATIC int
> +xlog_reserveq_wait(
> +	struct log		*log,
> +	struct xlog_ticket	*tic,
> +	int			need_bytes)
> +{
> +	list_add_tail(&tic->t_queue, &log->l_reserveq);
> +
> +	do {
> +		if (XLOG_FORCED_SHUTDOWN(log))
> +			goto shutdown;
> +		xlog_grant_push_ail(log, need_bytes);
> +
> +		XFS_STATS_INC(xs_sleep_logspace);
> +		trace_xfs_log_grant_sleep(log, tic);
> +
> +		xlog_wait(&tic->t_wait, &log->l_grant_reserve_lock);
> +		trace_xfs_log_grant_wake(log, tic);
> +
> +		spin_lock(&log->l_grant_reserve_lock);
> +		if (XLOG_FORCED_SHUTDOWN(log))
> +			goto shutdown;
> +	} while (xlog_space_left(log, &log->l_grant_reserve_head) < need_bytes);
> +
> +	list_del_init(&tic->t_queue);
> +	return 0;
> +shutdown:
> +	list_del_init(&tic->t_queue);
> +	return XFS_ERROR(EIO);
> +}
> +
> +STATIC int
> +xlog_writeq_wait(
> +	struct log		*log,
> +	struct xlog_ticket	*tic,
> +	int			need_bytes)
> +{
> +	list_add_tail(&tic->t_queue, &log->l_writeq);
> +
> +	do {
> +		if (XLOG_FORCED_SHUTDOWN(log))
> +			goto shutdown;
> +		xlog_grant_push_ail(log, need_bytes);
> +
> +		XFS_STATS_INC(xs_sleep_logspace);
> +		trace_xfs_log_regrant_write_sleep(log, tic);
> +
> +		xlog_wait(&tic->t_wait, &log->l_grant_write_lock);
> +		trace_xfs_log_regrant_write_wake(log, tic);
> +
> +		spin_lock(&log->l_grant_write_lock);
> +		if (XLOG_FORCED_SHUTDOWN(log))
> +			goto shutdown;
> +	} while (xlog_space_left(log, &log->l_grant_write_head) < need_bytes);
> +
> +	list_del_init(&tic->t_queue);
> +	return 0;
> +shutdown:
> +	list_del_init(&tic->t_queue);
> +	return XFS_ERROR(EIO);
> +}
> +
>  static void
>  xlog_tic_reset_res(xlog_ticket_t *tic)
>  {
> @@ -350,8 +461,19 @@ xfs_log_reserve(
>  		retval = xlog_grant_log_space(log, internal_ticket);
>  	}
> 
> +	if (unlikely(retval)) {
> +		/*
> +		 * If we are failing, make sure the ticket doesn't have any
> +		 * current reservations.  We don't want to add this back
> +		 * when the ticket/ transaction gets cancelled.
> +		 */
> +		internal_ticket->t_curr_res = 0;
> + 		/* ungrant will give back unit_res * t_cnt. */
> +		internal_ticket->t_cnt = 0;
> +	}
> +
>  	return retval;
> -}	/* xfs_log_reserve */
> +}
> 
> 
>  /*
> @@ -2481,8 +2603,8 @@ restart:
>  /*
>   * Atomically get the log space required for a log ticket.
>   *
> - * Once a ticket gets put onto the reserveq, it will only return after
> - * the needed reservation is satisfied.
> + * Once a ticket gets put onto the reserveq, it will only return after the
> + * needed reservation is satisfied.
>   *
>   * This function is structured so that it has a lock free fast path. This is
>   * necessary because every new transaction reservation will come through this
> @@ -2490,113 +2612,53 @@ restart:
>   * every pass.
>   *
>   * As tickets are only ever moved on and off the reserveq under the
> - * l_grant_reserve_lock, we only need to take that lock if we are going
> - * to add the ticket to the queue and sleep. We can avoid taking the lock if the
> - * ticket was never added to the reserveq because the t_queue list head will be
> - * empty and we hold the only reference to it so it can safely be checked
> - * unlocked.
> + * l_grant_reserve_lock, we only need to take that lock if we are going to add
> + * the ticket to the queue and sleep. We can avoid taking the lock if the ticket
> + * was never added to the reserveq because the t_queue list head will be empty
> + * and we hold the only reference to it so it can safely be checked unlocked.
>   */
>  STATIC int
> -xlog_grant_log_space(xlog_t	   *log,
> -		     xlog_ticket_t *tic)
> +xlog_grant_log_space(
> +	struct log		*log,
> +	struct xlog_ticket	*tic)
>  {
> -	int		 free_bytes;
> -	int		 need_bytes;
> +	int			free_bytes, need_bytes;
> +	int			error = 0;
> 
> -#ifdef DEBUG
> -	if (log->l_flags & XLOG_ACTIVE_RECOVERY)
> -		panic("grant Recovery problem");
> -#endif
> +	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
> 
>  	trace_xfs_log_grant_enter(log, tic);
> 
> +	/*
> +	 * If there are other waiters on the queue then give them a chance at
> +	 * logspace before us.  Wake up the first waiters, if we do not wake
> +	 * up all the waiters then go to sleep waiting for more free space,
> +	 * otherwise try to get some space for this transaction.
> +	 */
>  	need_bytes = tic->t_unit_res;
>  	if (tic->t_flags & XFS_LOG_PERM_RESERV)
>  		need_bytes *= tic->t_ocnt;
> -
> -	/* something is already sleeping; insert new transaction at end */
> -	if (!list_empty_careful(&log->l_reserveq)) {
> -		spin_lock(&log->l_grant_reserve_lock);
> -		/* recheck the queue now we are locked */
> -		if (list_empty(&log->l_reserveq)) {
> -			spin_unlock(&log->l_grant_reserve_lock);
> -			goto redo;
> -		}
> -		list_add_tail(&tic->t_queue, &log->l_reserveq);
> -
> -		trace_xfs_log_grant_sleep1(log, tic);
> -
> -		/*
> -		 * Gotta check this before going to sleep, while we're
> -		 * holding the grant lock.
> -		 */
> -		if (XLOG_FORCED_SHUTDOWN(log))
> -			goto error_return;
> -
> -		XFS_STATS_INC(xs_sleep_logspace);
> -		xlog_wait(&tic->t_wait, &log->l_grant_reserve_lock);
> -
> -		/*
> -		 * If we got an error, and the filesystem is shutting down,
> -		 * we'll catch it down below. So just continue...
> -		 */
> -		trace_xfs_log_grant_wake1(log, tic);
> -	}
> -
> -redo:
> -	if (XLOG_FORCED_SHUTDOWN(log))
> -		goto error_return_unlocked;
> -
>  	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
> -	if (free_bytes < need_bytes) {
> +	if (!list_empty_careful(&log->l_reserveq)) {
>  		spin_lock(&log->l_grant_reserve_lock);
> -		if (list_empty(&tic->t_queue))
> -			list_add_tail(&tic->t_queue, &log->l_reserveq);
> -
> -		trace_xfs_log_grant_sleep2(log, tic);
> -
> -		if (XLOG_FORCED_SHUTDOWN(log))
> -			goto error_return;
> -
> -		xlog_grant_push_ail(log, need_bytes);
> -
> -		XFS_STATS_INC(xs_sleep_logspace);
> -		xlog_wait(&tic->t_wait, &log->l_grant_reserve_lock);
> -
> -		trace_xfs_log_grant_wake2(log, tic);
> -		goto redo;
> -	}
> -
> -	if (!list_empty(&tic->t_queue)) {
> +		if (!xlog_reserveq_wake(log, &free_bytes) ||
> +		    free_bytes < need_bytes)
> +			error = xlog_reserveq_wait(log, tic, need_bytes);
> +		spin_unlock(&log->l_grant_reserve_lock);
> +	} else if (free_bytes < need_bytes) {
>  		spin_lock(&log->l_grant_reserve_lock);
> -		list_del_init(&tic->t_queue);
> +		error = xlog_reserveq_wait(log, tic, need_bytes);
>  		spin_unlock(&log->l_grant_reserve_lock);
>  	}
> +	if (error)
> +		return error;
> 
> -	/* we've got enough space */
>  	xlog_grant_add_space(log, &log->l_grant_reserve_head, need_bytes);
>  	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
>  	trace_xfs_log_grant_exit(log, tic);
>  	xlog_verify_grant_tail(log);
>  	return 0;
> -
> -error_return_unlocked:
> -	spin_lock(&log->l_grant_reserve_lock);
> -error_return:
> -	list_del_init(&tic->t_queue);
> -	spin_unlock(&log->l_grant_reserve_lock);
> -	trace_xfs_log_grant_error(log, tic);
> -
> -	/*
> -	 * If we are failing, make sure the ticket doesn't have any
> -	 * current reservations. We don't want to add this back when
> -	 * the ticket/transaction gets cancelled.
> -	 */
> -	tic->t_curr_res = 0;
> -	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
> -	return XFS_ERROR(EIO);
> -}	/* xlog_grant_log_space */
> -
> +}
> 
>  /*
>   * Replenish the byte reservation required by moving the grant write head.
> @@ -2605,10 +2667,12 @@ error_return:
>   * free fast path.
>   */
>  STATIC int
> -xlog_regrant_write_log_space(xlog_t	   *log,
> -			     xlog_ticket_t *tic)
> +xlog_regrant_write_log_space(
> +	struct log		*log,
> +	struct xlog_ticket	*tic)
>  {
> -	int		free_bytes, need_bytes;
> +	int			free_bytes, need_bytes;
> +	int			error = 0;
> 
>  	tic->t_curr_res = tic->t_unit_res;
>  	xlog_tic_reset_res(tic);
> @@ -2616,104 +2680,38 @@ xlog_regrant_write_log_space(xlog_t	   *
>  	if (tic->t_cnt > 0)
>  		return 0;
> 
> -#ifdef DEBUG
> -	if (log->l_flags & XLOG_ACTIVE_RECOVERY)
> -		panic("regrant Recovery problem");
> -#endif
> +	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
> 
>  	trace_xfs_log_regrant_write_enter(log, tic);
> -	if (XLOG_FORCED_SHUTDOWN(log))
> -		goto error_return_unlocked;
> 
> -	/* If there are other waiters on the queue then give them a
> -	 * chance at logspace before us. Wake up the first waiters,
> -	 * if we do not wake up all the waiters then go to sleep waiting
> -	 * for more free space, otherwise try to get some space for
> -	 * this transaction.
> +	/*
> +	 * If there are other waiters on the queue then give them a chance at
> +	 * logspace before us.  Wake up the first waiters, if we do not wake
> +	 * up all the waiters then go to sleep waiting for more free space,
> +	 * otherwise try to get some space for this transaction.
>  	 */
>  	need_bytes = tic->t_unit_res;
> -	if (!list_empty_careful(&log->l_writeq)) {
> -		struct xlog_ticket *ntic;
> -
> -		spin_lock(&log->l_grant_write_lock);
> -		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
> -		list_for_each_entry(ntic, &log->l_writeq, t_queue) {
> -			ASSERT(ntic->t_flags & XLOG_TIC_PERM_RESERV);
> -
> -			if (free_bytes < ntic->t_unit_res)
> -				break;
> -			free_bytes -= ntic->t_unit_res;
> -			wake_up(&ntic->t_wait);
> -		}
> -
> -		if (ntic != list_first_entry(&log->l_writeq,
> -						struct xlog_ticket, t_queue)) {
> -			if (list_empty(&tic->t_queue))
> -				list_add_tail(&tic->t_queue, &log->l_writeq);
> -			trace_xfs_log_regrant_write_sleep1(log, tic);
> -
> -			xlog_grant_push_ail(log, need_bytes);
> -
> -			XFS_STATS_INC(xs_sleep_logspace);
> -			xlog_wait(&tic->t_wait, &log->l_grant_write_lock);
> -			trace_xfs_log_regrant_write_wake1(log, tic);
> -		} else
> -			spin_unlock(&log->l_grant_write_lock);
> -	}
> -
> -redo:
> -	if (XLOG_FORCED_SHUTDOWN(log))
> -		goto error_return_unlocked;
> -
>  	free_bytes = xlog_space_left(log, &log->l_grant_write_head);
> -	if (free_bytes < need_bytes) {
> +	if (!list_empty_careful(&log->l_writeq)) {
>  		spin_lock(&log->l_grant_write_lock);
> -		if (list_empty(&tic->t_queue))
> -			list_add_tail(&tic->t_queue, &log->l_writeq);
> -
> -		if (XLOG_FORCED_SHUTDOWN(log))
> -			goto error_return;
> -
> -		xlog_grant_push_ail(log, need_bytes);
> -
> -		XFS_STATS_INC(xs_sleep_logspace);
> -		trace_xfs_log_regrant_write_sleep2(log, tic);
> -		xlog_wait(&tic->t_wait, &log->l_grant_write_lock);
> -
> -		trace_xfs_log_regrant_write_wake2(log, tic);
> -		goto redo;
> -	}
> -
> -	if (!list_empty(&tic->t_queue)) {
> +		if (!xlog_writeq_wake(log, &free_bytes) ||
> +		    free_bytes < need_bytes)
> +			error = xlog_writeq_wait(log, tic, need_bytes);
> +		spin_unlock(&log->l_grant_write_lock);
> +	} else if (free_bytes < need_bytes) {
>  		spin_lock(&log->l_grant_write_lock);
> -		list_del_init(&tic->t_queue);
> +		error = xlog_writeq_wait(log, tic, need_bytes);
>  		spin_unlock(&log->l_grant_write_lock);
>  	}
> 
> -	/* we've got enough space */
> +	if (error)
> +		return error;
> +
>  	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
>  	trace_xfs_log_regrant_write_exit(log, tic);
>  	xlog_verify_grant_tail(log);
>  	return 0;
> -
> -
> - error_return_unlocked:
> -	spin_lock(&log->l_grant_write_lock);
> - error_return:
> -	list_del_init(&tic->t_queue);
> -	spin_unlock(&log->l_grant_write_lock);
> -	trace_xfs_log_regrant_write_error(log, tic);
> -
> -	/*
> -	 * If we are failing, make sure the ticket doesn't have any
> -	 * current reservations. We don't want to add this back when
> -	 * the ticket/transaction gets cancelled.
> -	 */
> -	tic->t_curr_res = 0;
> -	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
> -	return XFS_ERROR(EIO);
> -}	/* xlog_regrant_write_log_space */
> -
> +}
> 
>  /* The first cnt-1 times through here we don't need to
>   * move the grant write head because the permanent
> Index: xfs/fs/xfs/xfs_trace.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_trace.h	2011-11-20 16:29:49.362860654 +0100
> +++ xfs/fs/xfs/xfs_trace.h	2011-11-20 16:34:23.954706395 +0100
> @@ -834,18 +834,14 @@ DEFINE_LOGGRANT_EVENT(xfs_log_umount_wri
>  DEFINE_LOGGRANT_EVENT(xfs_log_grant_enter);
>  DEFINE_LOGGRANT_EVENT(xfs_log_grant_exit);
>  DEFINE_LOGGRANT_EVENT(xfs_log_grant_error);
> -DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep1);
> -DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake1);
> -DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep2);
> -DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake2);
> +DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep);
> +DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake);
>  DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake_up);
>  DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
>  DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
>  DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
> -DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep1);
> -DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake1);
> -DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep2);
> -DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake2);
> +DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep);
> +DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake);
>  DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake_up);
>  DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
>  DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
