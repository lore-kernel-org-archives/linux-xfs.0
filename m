Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF747C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 11:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5F1720722
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 11:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgGALGv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 07:06:51 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:57519 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729952AbgGALGv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 07:06:51 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id DAA89D79267;
        Wed,  1 Jul 2020 21:06:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqaZg-00058G-Sg; Wed, 01 Jul 2020 21:06:44 +1000
Date:   Wed, 1 Jul 2020 21:06:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [Bug, sched, 5.8-rc2]: PREEMPT kernels crashing in
 check_preempt_wakeup() running fsx on XFS
Message-ID: <20200701110644.GT2005@dread.disaster.area>
References: <20200626004722.GF2005@dread.disaster.area>
 <20200626073345.GI4800@hirez.programming.kicks-ass.net>
 <20200626223254.GH2005@dread.disaster.area>
 <20200627183042.GK4817@hirez.programming.kicks-ass.net>
 <20200629235533.GL2005@dread.disaster.area>
 <20200630085732.GT4817@hirez.programming.kicks-ass.net>
 <20200701022646.GO2005@dread.disaster.area>
 <20200701080213.GF4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701080213.GF4817@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=o2n2Odqt-zTdAZooqwcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 10:02:13AM +0200, Peter Zijlstra wrote:
> On Wed, Jul 01, 2020 at 12:26:46PM +1000, Dave Chinner wrote:
> 
> > There's nothing like this in the scheduler code that I can find that
> > explains the expected overall ordering/serialisation mechanisms and
> > relationships used in the subsystem. Hence when I comes across
> > something that doesn't appear to make sense, there's nothign I can
> > refer to that would explain whether it is a bug or whether the
> > comment is wrong or whether I've just completely misunderstood what
> > the comment is referring to.
> > 
> > Put simply: the little details are great, but they aren't sufficient
> > by themselves to understand the relationships being maintained
> > between the various objects.
> 
> You're absolutely right, we lack that. As a very first draft / brain
> dump, I wrote the below, I'll try and polish it up and add to it over
> the next few days.

Excellent first pass, Peter. It explained a lot of little things I
was missing. :)

Comments in line below.

> 
> 
> ---
>  kernel/sched/core.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 75 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1d3d2d67f398..568f7ade9a09 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -77,6 +77,74 @@ __read_mostly int scheduler_running;
>   */
>  int sysctl_sched_rt_runtime = 950000;
>  
> +
> +/*
> + * Serialization rules:
> + *
> + * Lock order:
> + *
> + *   p->pi_lock
> + *     rq->lock
> + *       hrtimer_clock_base::cpu_base->lock

So these are accessed by the task_rq_lock() and rq_lock()
interfaces, right? And we take clock locks inside these because we
need to update timestamps/task clocks when tasks are first
scheduled?

What are all the rq_*pin_[un]lock() calls and how do they
factor into this?

> + *
> + *  rq1->lock
> + *    rq2->lock  where: &rq1 < &rq2
> + *

Ok, I'm guessing this is when task migration is being performed?

> + * Regular state:
> + *
> + * Normal scheduling state is serialized by rq->lock. __schedule() takes the
> + * local CPU's rq->lock, it optionally removes the task from the runqueue and
> + * always looks at the local rq data structures to find the most elegible task
> + * to run next.
> + *
> + * Task enqueue is also under rq->lock, possibly taken from another CPU.
> + * Wakeups from another LLC domain might use an IPI to transfer the enqueue
> + * to the local CPU to avoid bouncing the runqueue state around.

That's ttwu_queue_wakelist()?

I'm a little confused as to where ttwu_remote() fits into remote
wakeups, though. That piece of the puzzle hasn't dropped into place
yet...

> + * Task wakeup, specifically wakeups that involve migration, are horribly
> + * complicated to avoid having to take two rq->locks.
> + *
> + * Special state:
> + *
> + * p->state    <- TASK_*
> + * p->on_cpu   <- { 0, 1 }
> + * p->on_rq    <- { 0, 1 = TASK_ON_RQ_QUEUED, 2 = TASK_ON_RQ_MIGRATING }
> + * task_cpu(p) <- set_task_cpu()
> + *
> + * System-calls and anything external will use task_rq_lock() which acquires
> + * both p->lock and rq->lock. As a consequence things like p->cpus_ptr are
> + * stable while holding either lock.

OK. Might be worthwhile iterating the objects that have this "stable
with one lock, modified under both locks" structures...

> + *
> + * p->state is changed locklessly using set_current_state(),
> + * __set_current_state() or set_special_state(), see their respective comments.

/me goes code spelunking

Ok, so those comments talk about "using a barrier" to order p->state
changes against external logic to avoid wakeup races, not about how
they are ordered or used internally. 

But it also mentions that the barrier matches with a full barrier in
wake_up_state() and that calls straight into ttwu(). Ah, so that's
what this "CONDITION" is - it's the external wakeup checks!

        /*                                                                       
         * If we are going to wake up a thread waiting for CONDITION we          
         * need to ensure that CONDITION=1 done by the caller can not be         
         * reordered with p->state check below. This pairs with mb() in          
         * set_current_state() the waiting thread does.                          
         */                                                                      
        raw_spin_lock_irqsave(&p->pi_lock, flags);                               
        smp_mb__after_spinlock();                                                
        if (!(p->state & state))                                                 
                goto unlock;

My brain now connects this straight to well known task sleep/wakeup
code patterns, and this bit now makes a lot more sense....

> + * p->on_cpu is set by prepare_task() and cleared by finish_task() such that it
> + * will be set before p is scheduled-in and cleared after p is scheduled-out,
> + * both under rq->lock. Non-zero indicates the task is 'current' on it's CPU.
                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This. 1000x this. That's exactly the sort of basic, high level
relationship I've been unable to pull out of the code. Forest,
trees, all that jive. Lots of disconnected fragments fell into place
when I read that.

Thank you! :)

> + * p->on_rq is set by activate_task() and cleared by deactivate_task(), under
> + * rq->lock. Non-zero indicates the task is runnable, the special
> + * ON_RQ_MIGRATING state is used for migration without holding both rq->locks.
> + * It indicates task_cpu() is not stable, see *task_rq_lock().
> + *
> + * task_cpu(p) is changed by set_task_cpu(), the rules are intricate but basically:
> + *
> + *  - don't call set_task_cpu() on a blocked task

why? It's good to document the rule, but I haven't been able to find
an obvious explanation of why this rule exists....

> + *
> + *  - for try_to_wake_up(), called under p->pi_lock

What's the reason for it being under different locks if it's already
in runnable state? i.e. the lock that needs to be held is spelled
out on set_task_cpu():

        * The caller should hold either p->pi_lock or rq->lock, when changing
	*a task's CPU. ->pi_lock for waking tasks, rq->lock for runnable tasks.

But there's no explanation there or here of why the different locks
need to be used or how the two different situations don't
overlap/contend/race because they aren't holding the same locks. So
while I know rule exists, I don't understand the relationship
or logic that the rule emerges from.

> + *
> + *  - for migration called under rq->lock:
> + *    o move_queued_task()
> + *    o __migrate_swap_task()
> + *    o detach_task()
> + *
> + *  - for migration called under double_rq_lock():
> + *    o push_rt_task() / pull_rt_task()
> + *    o push_dl_task() / pull_dl_task()
> + *    o dl_task_offline_migration()

I've not dug deeply enough into the migration code in recent times
to be able to comment sanely on these...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
