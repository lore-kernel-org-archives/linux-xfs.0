Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5557C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 990D02073E
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Oj5TZiR5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgGAICX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgGAICW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:02:22 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E636DC061755;
        Wed,  1 Jul 2020 01:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LFQ7OF0jsuzQJlmTHO++UkKHV4et9XLuC6j8VsZvEzw=; b=Oj5TZiR5u9aBfKOyg1xp1X4bhD
        engC4zDewM2GmMUsT8iIFwB7eOoTKNDb+C27439ztCIUdVqooYpQbUUXAeN50rDUpidA07w6GcWWZ
        9rAzrdnVmFFSGjrTxssFjHSFOlKiXEk5jYGSMpegcR1ms+EqWxttqrvoUqbzkCR5q60ZnIqBb4j8E
        CfVMLMyEbiScLLayDkHvFR2pvCqHvFwV+Uz2AXsTOfppnxtAHOJIIMdrzjCxsr1eppRwFthuYD3Hc
        ZJ7BVayw7nCK9Y9hEaFRKSlSHS/lEgeI7Gm6K2gFaBbiSQDarKQDqvRxM3MJGcsOQ+xqfVBDrpgTw
        7xBhctXw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqXhB-0005fq-Id; Wed, 01 Jul 2020 08:02:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9D9E230015A;
        Wed,  1 Jul 2020 10:02:13 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8A1312006F895; Wed,  1 Jul 2020 10:02:13 +0200 (CEST)
Date:   Wed, 1 Jul 2020 10:02:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [Bug, sched, 5.8-rc2]: PREEMPT kernels crashing in
 check_preempt_wakeup() running fsx on XFS
Message-ID: <20200701080213.GF4817@hirez.programming.kicks-ass.net>
References: <20200626004722.GF2005@dread.disaster.area>
 <20200626073345.GI4800@hirez.programming.kicks-ass.net>
 <20200626223254.GH2005@dread.disaster.area>
 <20200627183042.GK4817@hirez.programming.kicks-ass.net>
 <20200629235533.GL2005@dread.disaster.area>
 <20200630085732.GT4817@hirez.programming.kicks-ass.net>
 <20200701022646.GO2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701022646.GO2005@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 12:26:46PM +1000, Dave Chinner wrote:

> There's nothing like this in the scheduler code that I can find that
> explains the expected overall ordering/serialisation mechanisms and
> relationships used in the subsystem. Hence when I comes across
> something that doesn't appear to make sense, there's nothign I can
> refer to that would explain whether it is a bug or whether the
> comment is wrong or whether I've just completely misunderstood what
> the comment is referring to.
> 
> Put simply: the little details are great, but they aren't sufficient
> by themselves to understand the relationships being maintained
> between the various objects.

You're absolutely right, we lack that. As a very first draft / brain
dump, I wrote the below, I'll try and polish it up and add to it over
the next few days.


---
 kernel/sched/core.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 75 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1d3d2d67f398..568f7ade9a09 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -77,6 +77,74 @@ __read_mostly int scheduler_running;
  */
 int sysctl_sched_rt_runtime = 950000;
 
+
+/*
+ * Serialization rules:
+ *
+ * Lock order:
+ *
+ *   p->pi_lock
+ *     rq->lock
+ *       hrtimer_clock_base::cpu_base->lock
+ *
+ *  rq1->lock
+ *    rq2->lock  where: &rq1 < &rq2
+ *
+ * Regular state:
+ *
+ * Normal scheduling state is serialized by rq->lock. __schedule() takes the
+ * local CPU's rq->lock, it optionally removes the task from the runqueue and
+ * always looks at the local rq data structures to find the most elegible task
+ * to run next.
+ *
+ * Task enqueue is also under rq->lock, possibly taken from another CPU.
+ * Wakeups from another LLC domain might use an IPI to transfer the enqueue
+ * to the local CPU to avoid bouncing the runqueue state around.
+ *
+ * Task wakeup, specifically wakeups that involve migration, are horribly
+ * complicated to avoid having to take two rq->locks.
+ *
+ * Special state:
+ *
+ * p->state    <- TASK_*
+ * p->on_cpu   <- { 0, 1 }
+ * p->on_rq    <- { 0, 1 = TASK_ON_RQ_QUEUED, 2 = TASK_ON_RQ_MIGRATING }
+ * task_cpu(p) <- set_task_cpu()
+ *
+ * System-calls and anything external will use task_rq_lock() which acquires
+ * both p->lock and rq->lock. As a consequence things like p->cpus_ptr are
+ * stable while holding either lock.
+ *
+ * p->state is changed locklessly using set_current_state(),
+ * __set_current_state() or set_special_state(), see their respective comments.
+ *
+ * p->on_cpu is set by prepare_task() and cleared by finish_task() such that it
+ * will be set before p is scheduled-in and cleared after p is scheduled-out,
+ * both under rq->lock. Non-zero indicates the task is 'current' on it's CPU.
+ *
+ * p->on_rq is set by activate_task() and cleared by deactivate_task(), under
+ * rq->lock. Non-zero indicates the task is runnable, the special
+ * ON_RQ_MIGRATING state is used for migration without holding both rq->locks.
+ * It indicates task_cpu() is not stable, see *task_rq_lock().
+ *
+ * task_cpu(p) is changed by set_task_cpu(), the rules are intricate but basically:
+ *
+ *  - don't call set_task_cpu() on a blocked task
+ *
+ *  - for try_to_wake_up(), called under p->pi_lock
+ *
+ *  - for migration called under rq->lock:
+ *    o move_queued_task()
+ *    o __migrate_swap_task()
+ *    o detach_task()
+ *
+ *  - for migration called under double_rq_lock():
+ *    o push_rt_task() / pull_rt_task()
+ *    o push_dl_task() / pull_dl_task()
+ *    o dl_task_offline_migration()
+ *
+ */
+
 /*
  * __task_rq_lock - lock the rq @p resides on.
  */
@@ -1466,8 +1534,7 @@ static struct rq *move_queued_task(struct rq *rq, struct rq_flags *rf,
 {
 	lockdep_assert_held(&rq->lock);
 
-	WRITE_ONCE(p->on_rq, TASK_ON_RQ_MIGRATING);
-	dequeue_task(rq, p, DEQUEUE_NOCLOCK);
+	deactivate_task(rq, p, DEQUEUE_NOCLOCK);
 	set_task_cpu(p, new_cpu);
 	rq_unlock(rq, rf);
 
@@ -1475,8 +1542,7 @@ static struct rq *move_queued_task(struct rq *rq, struct rq_flags *rf,
 
 	rq_lock(rq, rf);
 	BUG_ON(task_cpu(p) != new_cpu);
-	enqueue_task(rq, p, 0);
-	p->on_rq = TASK_ON_RQ_QUEUED;
+	activate_task(rq, p, 0);
 	check_preempt_curr(rq, p, 0);
 
 	return rq;
@@ -3134,8 +3200,12 @@ static inline void prepare_task(struct task_struct *next)
 	/*
 	 * Claim the task as running, we do this before switching to it
 	 * such that any running task will have this set.
+	 *
+	 * __schedule()'s rq->lock and smp_mb__after_spin_lock() orders this
+	 * store against prior state change of p, also see try_to_wake_up(),
+	 * specifically smp_load_acquire(&p->on_cpu).
 	 */
-	next->on_cpu = 1;
+	WRITE_ONCE(next->on_cpu, 1);
 #endif
 }
 
