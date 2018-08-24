Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:49247 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725266AbeHXECa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Aug 2018 00:02:30 -0400
Date: Fri, 24 Aug 2018 10:30:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: Use wake_q for waking up log space waiters
Message-ID: <20180824003017.GZ2234@dastard>
References: <1535041570-24102-1-git-send-email-longman@redhat.com>
 <1535041570-24102-3-git-send-email-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535041570-24102-3-git-send-email-longman@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Waiman Long <longman@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Thu, Aug 23, 2018 at 12:26:10PM -0400, Waiman Long wrote:
> Running the AIM7 fserver workload on a 2-socket 24-core 48-thread
> Broadwell system, it was found that there were severe spinlock contention
> in the XFS code. In particular, native_queued_spin_lock_slowpath()
> consumes 69.7% of cpu time. The xlog_grant_head_check() function call and
> its sub-function calls underneath it consumed 27.2% of the cpu time. This
> function tried to wake up tasks in the log space wait queue and then
> put itself into the wait queue if there is not enough log space left.

Interesting - I don't see the grant head reservation code in any of
my performance benchmark profiling, even when running at over a
million transactions/s on a 2-socket 32-core 64-thread skylake
system. I see other places in the transaction subsystem that are
hot (e.g the CIL context lock), but not the space reservations.

My initial suspect is that you have a tiny log on your test
filesystem, so it's permanently out of space and so always hitting
the slow path. Can you tell us what the storage is and it's
configuration? At minimum, I need to see the output of the xfs_info
command on your test filesystem. Fixing this may simply be using a
larger log on your benchmark systems.

FWIW, can you post the actual profile you are seeing in the commit
message? That helps us identify similar problems in the future, and
it lets us know what paths are leading to the transaction
reservation contention. i.e. this may not even be a problem with the
transaction reservation code itself.

> The process of waking up task can be time consuming and it is not
> really necessary to hold an XFS lock while doing the wakeups. So the
> xlog_grant_head_wake() function is modified to put the tasks to be waken
> up into a wake_q to be passed to wake_up_q() without holding the lock.

How does this impact on the strict FIFO queue behaviour the grant
queues currently have? The current code only wakes up enough waiters
to consume the newly available space and it queues new waiters to
the tail of the queue. If there ever is a spurious wakeup then the
waiter that was woken from the head remains there until the next
wakeup comes in. This is intentional - spurious wakeups are rare
enough we can ignore them because a) this is the slow path, and b)
correctness is far more important that performance in this path.
The fast path is already lockless, and we've already given up
peformance if we reach this slow path. hence we only care about
correctness in this path, not performance optimisation.

AFAICT the patch changes the spurious wakeup behaviour - it requeues
tasks to the tail of the queue if there wasn't space available when
they are woken, rather than leaving them as them at the head.  They
now have to wait for all the other reservations to make progress.
This breaks the guarantees of ordered forward progress the grant
queue provides permanent transaction reservations and hence opens us
up to log space deadlocks because those transactions can't move
their objects forward in the log to free up space in the log...

Also, I note that wake_q_add() assumes that the wake queue is a
local stack object and so not subject to concurrency - it explicitly
states this in the code. That's not the case here - the wake queue
is part of the grant head, and so is subject to extreme concurrency
that is tempered by a spin lock.  Does the wake_q code work
correctly (e.g. have all the necessary memory barriers, etc) when
it's not a local stack object and instead protected from concurrency
by a spin lock? At minimum, the wake_q infrastructure comments and
documentation need updating to accommodate this new use case that
wake queues are being used for.

> Corresponding changes are made in xlog_grant_head_wait() to dequeue the
> tasks from the wait queue after they are put into the wake_q. This avoids
> multiple wakeups of the same task from different log space waiters.

This doesn't generally doesn't happen because the space accounting
tends to prevent multiple wakeups. i.e. we only wake the tasks we
have reservation space for, and log space being made available tends
to arrive in discrete chunks (because IO is slow!) such that that
pending wakeups have already been processed before the next chunk of
available space comes in....

> Multiple wakeups seems to be a possibility in the existing code too.

Yes, but they are very rare and we don't really care about this in
the slow path. If you see lots of them, it's typically a sign of an
inappropriately configured filesystem for the workload being run. On
a correctly configured system, we should almost never use this slow
path....

> With the use of the wake_q, the cpu time used by
> native_queued_spin_lock_slowpath() dropped to 39.6%. However, the
> performance of the AIM7 fserver workload increased from 91,485.51
> jobs/min to 397,290.21 jobs/min which was more than 4X improvement.

I'm betting that you'll get that and a whole lot more simply by
increasing the log size and not running the slow path at all.

> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 48 +++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 37 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c3b610b..1402ad3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3,6 +3,8 @@

Where's the hunk context in your headers? You must be using a
non-standard git option here.

>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
>   */
> +#include <linux/sched/wake_q.h>

Linux kernel specific includes go in fs/xfs/xfs_linux.h, not
individual files.

> +
>  #include "xfs.h"
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
> @@ -221,19 +223,21 @@
>  xlog_grant_head_wake(
>  	struct xlog		*log,
>  	struct xlog_grant_head	*head,
> -	int			*free_bytes)
> +	int			*free_bytes,
> +	struct wake_q_head	*wakeq)
>  {
> -	struct xlog_ticket	*tic;
> +	struct xlog_ticket	*tic, *next;
>  	int			need_bytes;
>  
> -	list_for_each_entry(tic, &head->waiters, t_queue) {
> +	list_for_each_entry_safe(tic, next, &head->waiters, t_queue) {
>  		need_bytes = xlog_ticket_reservation(log, head, tic);
>  		if (*free_bytes < need_bytes)
>  			return false;
>  
>  		*free_bytes -= need_bytes;
>  		trace_xfs_log_grant_wake_up(log, tic);
> -		wake_up_process(tic->t_task);
> +		wake_q_add(wakeq, tic->t_task);
> +		list_del_init(&tic->t_queue);
>  	}

Why do you need to delete the ticket from the queue here? This leads
to landmines and incorrect non-FIFO behaviour...

>  	return true;
> @@ -247,13 +251,14 @@
>  	int			need_bytes) __releases(&head->lock)
>  					    __acquires(&head->lock)
>  {
> -	list_add_tail(&tic->t_queue, &head->waiters);
> -
>  	do {
> +		list_add_tail(&tic->t_queue, &head->waiters);
> +

.... here. This is a potential list corruption landmine because this
function now has unbalanced list add and removal contexts. IOWs, we
can't restart this loop without first having guaranteed the ticket
is not already on the ticket queue. You need to document constraints
like this in comments and explain what code needs to guarantee those
constraints are met. [Because, as I noted at the end, you got this
wrong for xlog_grant_head_wake_all()]

To maintian FIFO behaviour, the ticket needs to be left at the head
of the grant head wait queue until it has space available to make
progress, not get removed and requeued to the tail. Spurious wake
ups are irrelevant here - forwards progress (i.e. correctness)
requires FIFO ticket ordering behaviour be maintained.

>  		if (XLOG_FORCED_SHUTDOWN(log))
>  			goto shutdown;
>  		xlog_grant_push_ail(log, need_bytes);

This push is needed to make the necessary space we are waiting on
available in the log. Hence leaving it out of the loop you put
below will cause the journal to get stuck in the spurious wakeup
loop below and be unable to make progress. This will lead to
filesystem hangs.

>  
> +sleep:
>  		__set_current_state(TASK_UNINTERRUPTIBLE);
>  		spin_unlock(&head->lock);
>  
> @@ -264,11 +269,18 @@
>  		trace_xfs_log_grant_wake(log, tic);
>  
>  		spin_lock(&head->lock);
> +
> +		/*
> +		 * The current task should have been dequeued from the
> +		 * list before it is waken up.
> +		 */
> +		if (unlikely(!list_empty(&tic->t_queue)))
> +			goto sleep;

That's a new nested loop. Please implement it as a loop.

> +
>  		if (XLOG_FORCED_SHUTDOWN(log))
>  			goto shutdown;

This is buggy  - i will lead to hangs if the filesystem is shut
down and there is a spurious wakeup that triggers this to go back to
sleep.
The shutdown check needs to break the sleep loop.

>  	} while (xlog_space_left(log, &head->grant) < need_bytes);
>  
> -	list_del_init(&tic->t_queue);
>  	return 0;
>  shutdown:
>  	list_del_init(&tic->t_queue);
> @@ -301,6 +313,7 @@
>  {
>  	int			free_bytes;
>  	int			error = 0;
> +	DEFINE_WAKE_Q(wakeq);
>  
>  	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
>  
> @@ -313,9 +326,16 @@
>  	*need_bytes = xlog_ticket_reservation(log, head, tic);
>  	free_bytes = xlog_space_left(log, &head->grant);
>  	if (!list_empty_careful(&head->waiters)) {
> +		bool wake_all;
> +
>  		spin_lock(&head->lock);
> -		if (!xlog_grant_head_wake(log, head, &free_bytes) ||
> -		    free_bytes < *need_bytes) {
> +		wake_all = xlog_grant_head_wake(log, head, &free_bytes, &wakeq);
> +		if (!wake_q_empty(&wakeq)) {
> +			spin_unlock(&head->lock);
> +			wake_up_q(&wakeq);
> +			spin_lock(&head->lock);
> +		}
> +		if (!wake_all || free_bytes < *need_bytes) {
>  			error = xlog_grant_head_wait(log, head, tic,
>  						     *need_bytes);
>  		}

That's racy. You can't drop the spin lock between
xlog_grant_head_wake() and xlog_grant_head_wait(), because
free_bytes is only valid while while the spinlock is held.  Same for
the "wake_all" variable you added. i..e. while waking up the
waiters, we could have run out of space again and had more tasks
queued, or had the AIL tail move and now have space available.
Either way, we can do the wrong thing because we dropped the lock
and free_bytes and wake_all are now stale and potentially incorrect.

> @@ -1068,6 +1088,7 @@
>  {
>  	struct xlog		*log = mp->m_log;
>  	int			free_bytes;
> +	DEFINE_WAKE_Q(wakeq);
>  
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return;
> @@ -1077,8 +1098,11 @@
>  
>  		spin_lock(&log->l_write_head.lock);
>  		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
> -		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes);
> +		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes,
> +				     &wakeq);
>  		spin_unlock(&log->l_write_head.lock);
> +		wake_up_q(&wakeq);
> +		wake_q_init(&wakeq);

That's another landmine. Just define the wakeq in the context where
it is used rather than use a function wide variable that requires
reinitialisation.

>  	}
>  
>  	if (!list_empty_careful(&log->l_reserve_head.waiters)) {
> @@ -1086,8 +1110,10 @@
>  
>  		spin_lock(&log->l_reserve_head.lock);
>  		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
> -		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes);
> +		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes,
> +				     &wakeq);
>  		spin_unlock(&log->l_reserve_head.lock);
> +		wake_up_q(&wakeq);
>  	}
>  }

Ok, what about xlog_grant_head_wake_all()? You didn't convert that
to use wake queues, and so that won't remove tickets for the grant
head waiter list, and so those tasks will never get out of the new
inner loop you added to xlog_grant_head_wait(). That means
filesystem shutdowns will just hang the filesystem and leave it
unmountable. Did you run this through fstests?

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com
