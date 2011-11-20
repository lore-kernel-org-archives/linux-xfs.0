Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAK8MgFl138132 for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 02:22:42 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B86161DBE77A
	for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 00:22:39 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	s0POrQFarEqkVADb for <xfs@oss.sgi.com>;
	Sun, 20 Nov 2011 00:22:39 -0800 (PST)
Date: Sun, 20 Nov 2011 19:22:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Remove the entries from the queue while waking them
	up.
Message-ID: <20111120082235.GN7046@dastard>
References: <1321644054.2201.80.camel@chandra-lucid.austin.ibm.com>
	<20111119181929.GA25739@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111119181929.GA25739@infradead.org>
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, XFS Mailing List <xfs@oss.sgi.com>

On Sat, Nov 19, 2011 at 01:19:29PM -0500, Christoph Hellwig wrote:
> Thanks a lot for tracking this issue down!
> 
> Unfortunately I don't think the fix is entirely safe.  If we remove
> the ticket from the list before the wakeup we have to assume no one
> else ever wakes up a process waiting for log space.  In Linux that
> generally isn't a safe assumption - e.g. higher level code could have
> added itself to another waitqueue before calling into this code (

But doing that would be a bug in the higher level code, yes? You are
only supposed to add yourself to a wait queue just before changing
the task state and sleeping, not just before execute something that
is likely to block and sleep and use waitqueues itself (like a
filesystem transaction) ....

> possibly even outside the XFS code) and now getting a wake up, or
> other bits of the kernel could have all kinds of reasons to wake
> this process up.

Signals are the only ones I can think of that are likely to occur
while waiting on a private wait queue. However, that is likely to
occur, so I agree that the waiting context needs to do the queue
removal, not the waker.

> Below is patch I hacked up on the airplane today - it makes sure
> we always wake other waiters on the log space queues first before
> adding a new process and should have the same effect.  Can you
> test if this also fixes the 234 hang for you?

A few comments....

> 
> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: xfs: fix and cleanup logspace waiter lists
> 
> Apply the scheme used in log_regrant_write_log_space to wake up any
> other threads waiting for log space before the newly added one to
> log_regrant_write_log_space as well, and factor the code into
> readable helpers.  For each of the queues we have:
> 
>  - one helper to wake up all waiting threads, and return if we
>    succeeded into doing that.  These helpers will also be usable
>    by xfs_log_move_tail once we remove the current opportunistic
>    wakeups in it.
>  - one helper to sleep on t_wait until enough log space is available,
>    which is modelled after the Linux waitqueue model.
>  
> and rewrite log_regrant_write_log_space and log_regrant_write_log_space
> around these helpers, including comments documenting what is going on.
> These two function now use one and the same algorithm for waiting
> on log space instead of subtly different ones before.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/linux-2.6/xfs_trace.h |   12 -
>  fs/xfs/xfs_log.c             |  329 +++++++++++++++++++++----------------------
>  2 files changed, 170 insertions(+), 171 deletions(-)
> 
> Index: linux-2.6/fs/xfs/xfs_log.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_log.c	2011-11-19 15:51:55.689999172 +0100
> +++ linux-2.6/fs/xfs/xfs_log.c	2011-11-19 16:57:07.226659537 +0100
> @@ -670,6 +670,52 @@ xfs_log_write(
>  	return error;
>  }
>  
> +STATIC bool
> +xlog_wake_writeq(
> +	struct log		*log,
> +	int			free_bytes)
> +{
> +	struct xlog_ticket	*tic;
> +
> +	list_for_each_entry(tic, &log->l_writeq, t_queue) {
> +		ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
> +
> +		if (free_bytes < tic->t_unit_res)
> +			return false;
> +		free_bytes -= tic->t_unit_res;
> +
> +		trace_xfs_log_regrant_write_wake_up(log, tic);
> +		wake_up(&tic->t_wait);
> +	}
> +
> +	return true;
> +}
> +
> +STATIC bool
> +xlog_wake_reserveq(
> +	struct log		*log,
> +	int			free_bytes)
> +{
> +	struct xlog_ticket	*tic;
> +	int			need_bytes;
> +
> +	list_for_each_entry(tic, &log->l_reserveq, t_queue) {
> +		if (tic->t_flags & XLOG_TIC_PERM_RESERV)
> +			need_bytes = tic->t_unit_res*tic->t_cnt;
> +		else
> +			need_bytes = tic->t_unit_res;
> +
> +		if (free_bytes < need_bytes)
> +			return false;
> +		free_bytes -= tic->t_unit_res;
> +
> +		trace_xfs_log_grant_wake_up(log, tic);
> +		wake_up(&tic->t_wait);
> +	}
> +
> +	return true;
> +}

Be nice to factor these into a single function - they do exactly the
same thing except for the queue they walk and the need_bytes
calculation.

> +
>  void
>  xfs_log_move_tail(xfs_mount_t	*mp,
>  		  xfs_lsn_t	tail_lsn)

Also, wouldn't it be a good idea to use these helpers in
xfs_log_move_tail() and remove the code duplication from there as
well? i.e. the four places we do this open coded wakeup walk could
be replaced with a single implementation....

> @@ -2492,11 +2538,42 @@ restart:
>  	return 0;
>  }	/* xlog_state_get_iclog_space */
>  
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

Same with this function and xlog_writeq_wait - they are identical
code just operating on a different grant head. If we had

struct xlog_grant_head {
	spinlock_t	lock;
	struct list_head queue;
	atomic64_t	head;
};

Rather than the current open-coded definitions, then this could all
share the same code rather than continuing to duplicate it. If we've
got to restructure the code to fix the bug, it makes sense to me to
remove the code duplication as well...

> +
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
> @@ -2504,113 +2581,94 @@ restart:
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
.....
>  	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
> -	if (free_bytes < need_bytes) {
> +	if (!list_empty_careful(&log->l_reserveq)) {
>  		spin_lock(&log->l_grant_reserve_lock);
.....
> +		if (!xlog_wake_reserveq(log, free_bytes))
> +			error = xlog_reserveq_wait(log, tic, need_bytes);
> +		spin_unlock(&log->l_grant_reserve_lock);
> +	} else if (free_bytes < need_bytes) {
>  		spin_lock(&log->l_grant_reserve_lock);
> -		list_del_init(&tic->t_queue);
> +		error = xlog_reserveq_wait(log, tic, need_bytes);
>  		spin_unlock(&log->l_grant_reserve_lock);
>  	}

I don't think this logic is quite correct. When we have a waiter on
the queue, we try to wake all the waiters before sleeping if that
did not succeed. If we woke everyone, we allow this process to
continue. The problem is that we don't check to see if there is
space remaining for this process to continue after doing all the
wakeups.

i.e. if need_bytes = 10000 and free_bytes = 50000, and the waiters
on the queue total 45000 bytes, then we fall through with free_bytes
= 5000 and need_bytes = 10000. In that case, we should have gone to
sleep because we are 5000 bytes short of our required space but we
don't and potentially deadlock due to oversubscribing the log space.

IOWs, xlog_wake_reserveq() needs to return the amount of remaining
free space after the wakeups so we can then run the if (free_bytes <
need_bytes) check unconditionally....

.....

>   */
>  STATIC int
> -xlog_regrant_write_log_space(xlog_t	   *log,
> -			     xlog_ticket_t *tic)
> +xlog_regrant_write_log_space(
> +	struct log		*log,
> +	struct xlog_ticket	*tic)

Ditto for the write grant head manipulations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
