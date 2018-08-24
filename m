Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726896AbeHYBbJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Aug 2018 21:31:09 -0400
Subject: Re: [PATCH 2/2] xfs: Use wake_q for waking up log space waiters
References: <1535041570-24102-1-git-send-email-longman@redhat.com>
 <1535041570-24102-3-git-send-email-longman@redhat.com>
 <20180824003017.GZ2234@dastard>
From: Waiman Long <longman@redhat.com>
Message-ID: <bbdaf330-ce6b-bc53-eb97-93b34359bd3d@redhat.com>
Date: Fri, 24 Aug 2018 17:54:39 -0400
MIME-Version: 1.0
In-Reply-To: <20180824003017.GZ2234@dastard>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On 08/23/2018 08:30 PM, Dave Chinner wrote:
> On Thu, Aug 23, 2018 at 12:26:10PM -0400, Waiman Long wrote:
>> Running the AIM7 fserver workload on a 2-socket 24-core 48-thread
>> Broadwell system, it was found that there were severe spinlock contention
>> in the XFS code. In particular, native_queued_spin_lock_slowpath()
>> consumes 69.7% of cpu time. The xlog_grant_head_check() function call and
>> its sub-function calls underneath it consumed 27.2% of the cpu time. This
>> function tried to wake up tasks in the log space wait queue and then
>> put itself into the wait queue if there is not enough log space left.
> Interesting - I don't see the grant head reservation code in any of
> my performance benchmark profiling, even when running at over a
> million transactions/s on a 2-socket 32-core 64-thread skylake
> system. I see other places in the transaction subsystem that are
> hot (e.g the CIL context lock), but not the space reservations.
>
> My initial suspect is that you have a tiny log on your test
> filesystem, so it's permanently out of space and so always hitting
> the slow path. Can you tell us what the storage is and it's
> configuration? At minimum, I need to see the output of the xfs_info
> command on your test filesystem. Fixing this may simply be using a
> larger log on your benchmark systems.

You are right. The XFS filesystem was created on a small ramfs device
and so the disk space was tiny. The microbenchmark that I used exposes
some extreme cases that may not be normally observed.

> FWIW, can you post the actual profile you are seeing in the commit
> message? That helps us identify similar problems in the future, and
> it lets us know what paths are leading to the transaction
> reservation contention. i.e. this may not even be a problem with the
> transaction reservation code itself.

Those were part of the perf trace that I marked down:

Before patch:

+   69.69%    69.17%  reaim            [kernel.vmlinux]            [k]
native_queued_spin_lock_
-   54.48%     0.01%  reaim            [kernel.vmlinux]            [k]
do_sys_open
   - 54.46% do_sys_open
      - 54.35% do_filp_open
         - 54.34% path_openat
            - 42.18% do_truncate
               - 42.17% notify_change
                  - 42.12% xfs_vn_setattr
                     - 42.09% xfs_setattr_size
                        - 42.08% xfs_setattr_nonsize
                           - 27.31% xfs_trans_alloc
                              - 27.28% xfs_trans_reserve
                                 - xfs_log_reserve
                                    - 27.20% xlog_grant_head_check
                                       + 13.79% queued_spin_lock_slowpath
                                       + 12.95% xlog_grant_head_wait
                           + 14.72% __xfs_trans_commit
            - 8.90% xfs_generic_create
               - 5.81% security_inode_init_security
                  - 5.72% xfs_initxattrs
                     - xfs_attr_set
                        - 2.90% xfs_bmap_add_attrfork
                           + 1.88% xfs_trans_alloc
                           + 1.02% __xfs_trans_commit
                        + 1.78% xfs_trans_alloc
                        + 1.01% __xfs_trans_commit
               + 3.08% xfs_create
            + 2.62% down_write

1500    99.36    3982.81 351.51  91485.51   60.99      15.87    20.05    79

After patch:

-   41.68%     0.07%  reaim  [kernel.vmlinux] [k] do_sys_open
   - 41.62% do_sys_open
      - 41.23% do_filp_open
         - 41.20% path_openat
            - 30.32% do_truncate
               - 30.27% notify_change
                  - 30.06% xfs_vn_setattr
                     - 29.90% xfs_setattr_size
                        - 29.88% xfs_setattr_nonsize
                           - 20.61% xfs_trans_alloc
                              - 20.46% xfs_trans_reserve
                                 - 20.43% xfs_log_reserve
                                    - 19.96% xlog_grant_head_check
                                       + 10.24% queued_spin_lock_slowpath
                                       + 9.04% xlog_grant_head_wait
                           + 9.06% __xfs_trans_commit
            - 7.16% xfs_generic_create
               + 4.27% security_inode_init_security
               + 2.87% xfs_create
            + 1.44% down_write
+   39.59%    38.98%  reaim  [kernel.vmlinux] [k] native_queued_spin_lock

1500    22.88    414.82  365.48  397290.21  264.86     3.40     18.41    81

>> The process of waking up task can be time consuming and it is not
>> really necessary to hold an XFS lock while doing the wakeups. So the
>> xlog_grant_head_wake() function is modified to put the tasks to be waken
>> up into a wake_q to be passed to wake_up_q() without holding the lock.
> How does this impact on the strict FIFO queue behaviour the grant
> queues currently have? The current code only wakes up enough waiters
> to consume the newly available space and it queues new waiters to
> the tail of the queue. If there ever is a spurious wakeup then the
> waiter that was woken from the head remains there until the next
> wakeup comes in. This is intentional - spurious wakeups are rare
> enough we can ignore them because a) this is the slow path, and b)
> correctness is far more important that performance in this path.
> The fast path is already lockless, and we've already given up
> peformance if we reach this slow path. hence we only care about
> correctness in this path, not performance optimisation.

A spurious wakeup shouldn't change the behavior as the waiter should
find that it is still being queued (list not empty) and so will sleep
again. However, if the waiter is rightfully waken but find that there is
not enough log space somehow, it will put itself back to the end of the
queue. That is a change in behavior that I think could be an issue.

I am just wondering why the code doesn't reserve the actual log space at
the time a task is being waken. Instead, it has to try to get it itself
after being waken.

Also I think the current code allows consecutive waiters to come in and
wake up the same set of tasks again and again. That may be where a part
of the performance slowdown come from.

>
> AFAICT the patch changes the spurious wakeup behaviour - it requeues
> tasks to the tail of the queue if there wasn't space available when
> they are woken, rather than leaving them as them at the head.  They
> now have to wait for all the other reservations to make progress.
> This breaks the guarantees of ordered forward progress the grant
> queue provides permanent transaction reservations and hence opens us
> up to log space deadlocks because those transactions can't move
> their objects forward in the log to free up space in the log...

As I said above, spurious wakeup shouldn't cause problem. However,
consecutive waiters will probably wake up more tasks than there is log
space available. In this case, some of the tasks will be put back to the
queue. Maybe a counter to record the log space temporarily reserved for
the waken-up task can help to prevent over-subscription.
 
>
> Also, I note that wake_q_add() assumes that the wake queue is a
> local stack object and so not subject to concurrency - it explicitly
> states this in the code. That's not the case here - the wake queue
> is part of the grant head, and so is subject to extreme concurrency
> that is tempered by a spin lock.  Does the wake_q code work
> correctly (e.g. have all the necessary memory barriers, etc) when
> it's not a local stack object and instead protected from concurrency
> by a spin lock? At minimum, the wake_q infrastructure comments and
> documentation need updating to accommodate this new use case that
> wake queues are being used for.

The wake_q should work correctly as it is used by mutexes and rwsems. We
will see a lot of problem reports if that is not the case.

>> Corresponding changes are made in xlog_grant_head_wait() to dequeue the
>> tasks from the wait queue after they are put into the wake_q. This avoids
>> multiple wakeups of the same task from different log space waiters.
> This doesn't generally doesn't happen because the space accounting
> tends to prevent multiple wakeups. i.e. we only wake the tasks we
> have reservation space for, and log space being made available tends
> to arrive in discrete chunks (because IO is slow!) such that that
> pending wakeups have already been processed before the next chunk of
> available space comes in....
>
>> Multiple wakeups seems to be a possibility in the existing code too.
> Yes, but they are very rare and we don't really care about this in
> the slow path. If you see lots of them, it's typically a sign of an
> inappropriately configured filesystem for the workload being run. On
> a correctly configured system, we should almost never use this slow
> path....
>
>> With the use of the wake_q, the cpu time used by
>> native_queued_spin_lock_slowpath() dropped to 39.6%. However, the
>> performance of the AIM7 fserver workload increased from 91,485.51
>> jobs/min to 397,290.21 jobs/min which was more than 4X improvement.
> I'm betting that you'll get that and a whole lot more simply by
> increasing the log size and not running the slow path at all.

That is probably true.

>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>  fs/xfs/xfs_log.c | 48 +++++++++++++++++++++++++++++++++++++-----------
>>  1 file changed, 37 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index c3b610b..1402ad3 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -3,6 +3,8 @@
> Where's the hunk context in your headers? You must be using a
> non-standard git option here.

I am using a old git (1.8). I should probably upgrade to a newer one.

>>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>>   * All Rights Reserved.
>>   */
>> +#include <linux/sched/wake_q.h>
> Linux kernel specific includes go in fs/xfs/xfs_linux.h, not
> individual files.
>

OK

>> +
>>  #include "xfs.h"
>>  #include "xfs_fs.h"
>>  #include "xfs_shared.h"
>> @@ -221,19 +223,21 @@
>>  xlog_grant_head_wake(
>>  	struct xlog		*log,
>>  	struct xlog_grant_head	*head,
>> -	int			*free_bytes)
>> +	int			*free_bytes,
>> +	struct wake_q_head	*wakeq)
>>  {
>> -	struct xlog_ticket	*tic;
>> +	struct xlog_ticket	*tic, *next;
>>  	int			need_bytes;
>>  
>> -	list_for_each_entry(tic, &head->waiters, t_queue) {
>> +	list_for_each_entry_safe(tic, next, &head->waiters, t_queue) {
>>  		need_bytes = xlog_ticket_reservation(log, head, tic);
>>  		if (*free_bytes < need_bytes)
>>  			return false;
>>  
>>  		*free_bytes -= need_bytes;
>>  		trace_xfs_log_grant_wake_up(log, tic);
>> -		wake_up_process(tic->t_task);
>> +		wake_q_add(wakeq, tic->t_task);
>> +		list_del_init(&tic->t_queue);
>>  	}
> Why do you need to delete the ticket from the queue here? This leads
> to landmines and incorrect non-FIFO behaviour...

It is because the wake_q uses a field in the task structure for queuing.
So a task can only be in one wake_q at a time. Leaving the ticket in the
queue may cause the task to be put into multiple wake_q causing missed
wakeup, perhaps.
 
>>  	return true;
>> @@ -247,13 +251,14 @@
>>  	int			need_bytes) __releases(&head->lock)
>>  					    __acquires(&head->lock)
>>  {
>> -	list_add_tail(&tic->t_queue, &head->waiters);
>> -
>>  	do {
>> +		list_add_tail(&tic->t_queue, &head->waiters);
>> +
> .... here. This is a potential list corruption landmine because this
> function now has unbalanced list add and removal contexts. IOWs, we
> can't restart this loop without first having guaranteed the ticket
> is not already on the ticket queue. You need to document constraints
> like this in comments and explain what code needs to guarantee those
> constraints are met. [Because, as I noted at the end, you got this
> wrong for xlog_grant_head_wake_all()]

Yes, you are right. The xlog_grant_head_wake_all() need to be modified
as well.

>
> To maintian FIFO behaviour, the ticket needs to be left at the head
> of the grant head wait queue until it has space available to make
> progress, not get removed and requeued to the tail. Spurious wake
> ups are irrelevant here - forwards progress (i.e. correctness)
> requires FIFO ticket ordering behaviour be maintained.
>
>>  		if (XLOG_FORCED_SHUTDOWN(log))
>>  			goto shutdown;
>>  		xlog_grant_push_ail(log, need_bytes);
> This push is needed to make the necessary space we are waiting on
> available in the log. Hence leaving it out of the loop you put
> below will cause the journal to get stuck in the spurious wakeup
> loop below and be unable to make progress. This will lead to
> filesystem hangs.
>
>>  
>> +sleep:
>>  		__set_current_state(TASK_UNINTERRUPTIBLE);
>>  		spin_unlock(&head->lock);
>>  
>> @@ -264,11 +269,18 @@
>>  		trace_xfs_log_grant_wake(log, tic);
>>  
>>  		spin_lock(&head->lock);
>> +
>> +		/*
>> +		 * The current task should have been dequeued from the
>> +		 * list before it is waken up.
>> +		 */
>> +		if (unlikely(!list_empty(&tic->t_queue)))
>> +			goto sleep;
> That's a new nested loop. Please implement it as a loop.
>
>> +
>>  		if (XLOG_FORCED_SHUTDOWN(log))
>>  			goto shutdown;
> This is buggy  - i will lead to hangs if the filesystem is shut
> down and there is a spurious wakeup that triggers this to go back to
> sleep.
> The shutdown check needs to break the sleep loop.
>
>>  	} while (xlog_space_left(log, &head->grant) < need_bytes);
>>  
>> -	list_del_init(&tic->t_queue);
>>  	return 0;
>>  shutdown:
>>  	list_del_init(&tic->t_queue);
>> @@ -301,6 +313,7 @@
>>  {
>>  	int			free_bytes;
>>  	int			error = 0;
>> +	DEFINE_WAKE_Q(wakeq);
>>  
>>  	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
>>  
>> @@ -313,9 +326,16 @@
>>  	*need_bytes = xlog_ticket_reservation(log, head, tic);
>>  	free_bytes = xlog_space_left(log, &head->grant);
>>  	if (!list_empty_careful(&head->waiters)) {
>> +		bool wake_all;
>> +
>>  		spin_lock(&head->lock);
>> -		if (!xlog_grant_head_wake(log, head, &free_bytes) ||
>> -		    free_bytes < *need_bytes) {
>> +		wake_all = xlog_grant_head_wake(log, head, &free_bytes, &wakeq);
>> +		if (!wake_q_empty(&wakeq)) {
>> +			spin_unlock(&head->lock);
>> +			wake_up_q(&wakeq);
>> +			spin_lock(&head->lock);
>> +		}
>> +		if (!wake_all || free_bytes < *need_bytes) {
>>  			error = xlog_grant_head_wait(log, head, tic,
>>  						     *need_bytes);
>>  		}
> That's racy. You can't drop the spin lock between
> xlog_grant_head_wake() and xlog_grant_head_wait(), because
> free_bytes is only valid while while the spinlock is held.  Same for
> the "wake_all" variable you added. i..e. while waking up the
> waiters, we could have run out of space again and had more tasks
> queued, or had the AIL tail move and now have space available.
> Either way, we can do the wrong thing because we dropped the lock
> and free_bytes and wake_all are now stale and potentially incorrect.
>
>> @@ -1068,6 +1088,7 @@
>>  {
>>  	struct xlog		*log = mp->m_log;
>>  	int			free_bytes;
>> +	DEFINE_WAKE_Q(wakeq);
>>  
>>  	if (XLOG_FORCED_SHUTDOWN(log))
>>  		return;
>> @@ -1077,8 +1098,11 @@
>>  
>>  		spin_lock(&log->l_write_head.lock);
>>  		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
>> -		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes);
>> +		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes,
>> +				     &wakeq);
>>  		spin_unlock(&log->l_write_head.lock);
>> +		wake_up_q(&wakeq);
>> +		wake_q_init(&wakeq);
> That's another landmine. Just define the wakeq in the context where
> it is used rather than use a function wide variable that requires
> reinitialisation.
>
>>  	}
>>  
>>  	if (!list_empty_careful(&log->l_reserve_head.waiters)) {
>> @@ -1086,8 +1110,10 @@
>>  
>>  		spin_lock(&log->l_reserve_head.lock);
>>  		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
>> -		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes);
>> +		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes,
>> +				     &wakeq);
>>  		spin_unlock(&log->l_reserve_head.lock);
>> +		wake_up_q(&wakeq);
>>  	}
>>  }
> Ok, what about xlog_grant_head_wake_all()? You didn't convert that
> to use wake queues, and so that won't remove tickets for the grant
> head waiter list, and so those tasks will never get out of the new
> inner loop you added to xlog_grant_head_wait(). That means
> filesystem shutdowns will just hang the filesystem and leave it
> unmountable. Did you run this through fstests?
>
> Cheers,
>
> Dave

OK, I need more time to think about some of the questions that you
raise.  Thanks for reviewing the patch.

Cheers,
Longman
