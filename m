Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BB4C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 13:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCBF3207D0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 13:42:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hpwC4lGN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgGANmt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 09:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgGANmt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 09:42:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE24C08C5C1;
        Wed,  1 Jul 2020 06:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cjaRkySnn9zjM8R5vpCGyC7siTFkzFNdHqFzmgptOqw=; b=hpwC4lGNZpBz5bv8A1ATMu3yKV
        PLVdYtUCPUFcGewCrQR2AvKlGS9dfwNaoukHQ4hFCqr2dUYCu3JU9OJ4mpPDj4BJPFn+Z++pe4xmt
        a6RJLbV9CwJ5NplzztqrfFyqGPk4NY26/p3ncG7cIzHppIzGihEPdECxIRCK/P82Qc3ttcziDQqXA
        Dh+PHcP8kmL0JSaiLf3PT9xmdVPGP/B2JmWiL6A+7gIZ3vl1wRtWasiel4eoj1sG5zcUWysIFxcdr
        NAD6gpo8PZTPz9pA++9QqG8rIV/M2RP5aCTalcHjaOZcKlz0RCcqraZiRX9owxkiOHDKW7xqxNQqq
        9K3a4//A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqd0f-0006rl-37; Wed, 01 Jul 2020 13:42:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 283B3302753;
        Wed,  1 Jul 2020 15:42:44 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0FB79203CDC4F; Wed,  1 Jul 2020 15:42:44 +0200 (CEST)
Date:   Wed, 1 Jul 2020 15:42:44 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [Bug, sched, 5.8-rc2]: PREEMPT kernels crashing in
 check_preempt_wakeup() running fsx on XFS
Message-ID: <20200701134244.GG4817@hirez.programming.kicks-ass.net>
References: <20200626004722.GF2005@dread.disaster.area>
 <20200626073345.GI4800@hirez.programming.kicks-ass.net>
 <20200626223254.GH2005@dread.disaster.area>
 <20200627183042.GK4817@hirez.programming.kicks-ass.net>
 <20200629235533.GL2005@dread.disaster.area>
 <20200630085732.GT4817@hirez.programming.kicks-ass.net>
 <20200701022646.GO2005@dread.disaster.area>
 <20200701080213.GF4817@hirez.programming.kicks-ass.net>
 <20200701110644.GT2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701110644.GT2005@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 09:06:44PM +1000, Dave Chinner wrote:

> > +/*
> > + * Serialization rules:
> > + *
> > + * Lock order:
> > + *
> > + *   p->pi_lock
> > + *     rq->lock
> > + *       hrtimer_clock_base::cpu_base->lock
> 
> So these are accessed by the task_rq_lock() and rq_lock()
> interfaces, right? And we take clock locks inside these because we
> need to update timestamps/task clocks when tasks are first
> scheduled?

That's the hrtimer_start(), which we use for bandwidth control.
sched_clock() is lockless.

> What are all the rq_*pin_[un]lock() calls and how do they
> factor into this?

Ah, that's a lockdep annotation to ensure the rq->lock doesn't get
unlocked by accident. We've had a bunch of races over the years where
code accidentally unlocked rq->lock.

Basically lockdep_pin_lock() allows you to 'pin' the lock and it will
return a cookie. Any unlock of a pinned lock will generate a warning.
lockdep_unpin_lock() requires the previously provided cookie, or again
it will complain.

Not sure where to put words on that, but I'll find something.

> > + *
> > + *  rq1->lock
> > + *    rq2->lock  where: &rq1 < &rq2
> > + *
> 
> Ok, I'm guessing this is when task migration is being performed?

Yeah.

> > + * Regular state:
> > + *
> > + * Normal scheduling state is serialized by rq->lock. __schedule() takes the
> > + * local CPU's rq->lock, it optionally removes the task from the runqueue and
> > + * always looks at the local rq data structures to find the most elegible task
> > + * to run next.
> > + *
> > + * Task enqueue is also under rq->lock, possibly taken from another CPU.
> > + * Wakeups from another LLC domain might use an IPI to transfer the enqueue
> > + * to the local CPU to avoid bouncing the runqueue state around.
> 
> That's ttwu_queue_wakelist()?

Yes, added a reference to that.

> I'm a little confused as to where ttwu_remote() fits into remote
> wakeups, though. That piece of the puzzle hasn't dropped into place
> yet...

Ah, so try_to_wake_up() is about another task/context changing our
p->state.

Assume:

  for (;;) {
	set_current_task(TASK_UNINTERRUPTIBLE)

	if (COND)
		break;

	schedule();
  }
  __set_current_task(TASK_RUNNING);

Now, suppose another CPU/IRQ/etc.. does a wakeup between
set_current_task() and schedule(). At that point our @p is still a
running/runnable task, ttwu_remote() deals with this case.

I'll improve the ttwu_remote() comment.

> > + * Task wakeup, specifically wakeups that involve migration, are horribly
> > + * complicated to avoid having to take two rq->locks.
> > + *
> > + * Special state:
> > + *
> > + * p->state    <- TASK_*
> > + * p->on_cpu   <- { 0, 1 }
> > + * p->on_rq    <- { 0, 1 = TASK_ON_RQ_QUEUED, 2 = TASK_ON_RQ_MIGRATING }
> > + * task_cpu(p) <- set_task_cpu()
> > + *
> > + * System-calls and anything external will use task_rq_lock() which acquires
> > + * both p->lock and rq->lock. As a consequence things like p->cpus_ptr are
> > + * stable while holding either lock.
> 
> OK. Might be worthwhile iterating the objects that have this "stable
> with one lock, modified under both locks" structures...

Agreed, that was on the todo list. I called out p->cpus_ptr because
that's directly used in the ttwu() code, but there's more. I'll dig them
all out.

> > + *
> > + * p->state is changed locklessly using set_current_state(),
> > + * __set_current_state() or set_special_state(), see their respective comments.
> 
> /me goes code spelunking
> 
> Ok, so those comments talk about "using a barrier" to order p->state
> changes against external logic to avoid wakeup races, not about how
> they are ordered or used internally.

Correct. Although we also make internal use of these memory barriers, us
being frugal folk :-) You'll find it referenced in the ttwu() ordering
comments, also some architectural code (switch_to()) relies on it.

> But it also mentions that the barrier matches with a full barrier in
> wake_up_state() and that calls straight into ttwu(). Ah, so that's
> what this "CONDITION" is - it's the external wakeup checks!
>
>         /*
>          * If we are going to wake up a thread waiting for CONDITION we
>          * need to ensure that CONDITION=1 done by the caller can not be
>          * reordered with p->state check below. This pairs with mb() in
>          * set_current_state() the waiting thread does.
>          */
>         raw_spin_lock_irqsave(&p->pi_lock, flags);
>         smp_mb__after_spinlock();
>         if (!(p->state & state))
>                 goto unlock;
> 
> My brain now connects this straight to well known task sleep/wakeup
> code patterns, and this bit now makes a lot more sense....

Just so, I'll see if I can make the comments with
set_current_state()/try_to_wake_up()/__schedule() more consistent with
one another. They're all trying to describe much the same as they
co-operate to make that sleep/wakeup pattern work.

> > + * p->on_rq is set by activate_task() and cleared by deactivate_task(), under
> > + * rq->lock. Non-zero indicates the task is runnable, the special
> > + * ON_RQ_MIGRATING state is used for migration without holding both rq->locks.
> > + * It indicates task_cpu() is not stable, see *task_rq_lock().
> > + *
> > + * task_cpu(p) is changed by set_task_cpu(), the rules are intricate but basically:
> > + *
> > + *  - don't call set_task_cpu() on a blocked task
> 
> why? It's good to document the rule, but I haven't been able to find
> an obvious explanation of why this rule exists....

Ah, I forgot if there was a techinical reason for it, but the conceptual
reason is that if a task isn't running, it's CPU assignment is
irrelevant, it doesn't matter what CPU you're not running on.

So I created rules where we only care about the CPU assignment for
runnable tasks. I'll add this.

(it makes hotplug easier, we don't have to even care if the cpu
assignment is even possible)

> > + *
> > + *  - for try_to_wake_up(), called under p->pi_lock
> 
> What's the reason for it being under different locks if it's already
> in runnable state? i.e. the lock that needs to be held is spelled
> out on set_task_cpu():
> 
>         * The caller should hold either p->pi_lock or rq->lock, when changing
> 	*a task's CPU. ->pi_lock for waking tasks, rq->lock for runnable tasks.
> 
> But there's no explanation there or here of why the different locks
> need to be used or how the two different situations don't
> overlap/contend/race because they aren't holding the same locks. So
> while I know rule exists, I don't understand the relationship
> or logic that the rule emerges from.

There's a hint here:

+ * Task wakeup, specifically wakeups that involve migration, are horribly
+ * complicated to avoid having to take two rq->locks.

So ttwu() used to first acquire the 'old' rq->lock, then do
CPU-selection and if new-cpu != old-cpu (a fairly common case) do
set_task_cpu(), drop the old rq->lock, acquire new rq->lock and do the
enqueue. Or something along those lines.

It was found that the initial rq->lock in case of migration added
significantly to the rq->lock contention for a number of workloads, so
we made things complicated...

I'll go explain it better.

Thanks Dave!
