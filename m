Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A4BC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 22:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbiBAWAa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 17:00:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39158 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbiBAWAa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 17:00:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B626160C09;
        Tue,  1 Feb 2022 22:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28652C340EC;
        Tue,  1 Feb 2022 22:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643752829;
        bh=egskwNSSdKdn+sOWw8MiLB+1OslmVahQ/GbjW1qoiy0=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=LwaL/Z160ZzxCDffS3Km90fWggzAYf4VU0keO9l49qI6y9q+WyNR+/M7MTmWMZJOV
         cSY1IPny6jxCsQOO5STFuZ6B319IcEap4sXlBJY7MY6hX4+Nb2COfUzc41scD6pZkW
         rD+7Hb6xcY0+g1RXO6zWaGk+ByqC+B0+3wVNTqKKJXEKMWl/6ynPcCrQ+Pto+/AvFq
         9NjH+CDUHZ+ay0d48PUoj58MYqn2GP3EaZsBEku/n70zgJVUUNsKXIEWw6E/dFFZkJ
         J1Q0zjOsklzSVKIWPr5fL5uFBMZtjf3m37/wzij0A2F1ZneqwLu3FtMWn28k6FPX/K
         F/kgAFpnaGcQw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id B306B5C0326; Tue,  1 Feb 2022 14:00:28 -0800 (PST)
Date:   Tue, 1 Feb 2022 14:00:28 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220201220028.GH4285@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
 <YfBBzHascwVnefYY@bfoster>
 <20220125224551.GQ59729@dread.disaster.area>
 <YfIdVq6R6xEWxy0K@zeniv-ca.linux.org.uk>
 <20220127052609.GR59729@dread.disaster.area>
 <YfLsBdPBSsyPFgHJ@bfoster>
 <20220128213911.GO4285@paulmck-ThinkPad-P17-Gen-1>
 <Yffioz+t9cjZbIBv@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yffioz+t9cjZbIBv@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 31, 2022 at 08:22:43AM -0500, Brian Foster wrote:
> On Fri, Jan 28, 2022 at 01:39:11PM -0800, Paul E. McKenney wrote:
> > On Thu, Jan 27, 2022 at 02:01:25PM -0500, Brian Foster wrote:
> > > On Thu, Jan 27, 2022 at 04:26:09PM +1100, Dave Chinner wrote:
> > > > On Thu, Jan 27, 2022 at 04:19:34AM +0000, Al Viro wrote:
> > > > > On Wed, Jan 26, 2022 at 09:45:51AM +1100, Dave Chinner wrote:
> > > > > 
> > > > > > Right, background inactivation does not improve performance - it's
> > > > > > necessary to get the transactions out of the evict() path. All we
> > > > > > wanted was to ensure that there were no performance degradations as
> > > > > > a result of background inactivation, not that it was faster.
> > > > > > 
> > > > > > If you want to confirm that there is an increase in cold cache
> > > > > > access when the batch size is increased, cpu profiles with 'perf
> > > > > > top'/'perf record/report' and CPU cache performance metric reporting
> > > > > > via 'perf stat -dddd' are your friend. See elsewhere in the thread
> > > > > > where I mention those things to Paul.
> > > > > 
> > > > > Dave, do you see a plausible way to eventually drop Ian's bandaid?
> > > > > I'm not asking for that to happen this cycle and for backports Ian's
> > > > > patch is obviously fine.
> > > > 
> > > > Yes, but not in the near term.
> > > > 
> > > > > What I really want to avoid is the situation when we are stuck with
> > > > > keeping that bandaid in fs/namei.c, since all ways to avoid seeing
> > > > > reused inodes would hurt XFS too badly.  And the benchmarks in this
> > > > > thread do look like that.
> > > > 
> > > > The simplest way I think is to have the XFS inode allocation track
> > > > "busy inodes" in the same way we track "busy extents". A busy extent
> > > > is an extent that has been freed by the user, but is not yet marked
> > > > free in the journal/on disk. If we try to reallocate that busy
> > > > extent, we either select a different free extent to allocate, or if
> > > > we can't find any we force the journal to disk, wait for it to
> > > > complete (hence unbusying the extents) and retry the allocation
> > > > again.
> > > > 
> > > > We can do something similar for inode allocation - it's actually a
> > > > lockless tag lookup on the radix tree entry for the candidate inode
> > > > number. If we find the reclaimable radix tree tag set, the we select
> > > > a different inode. If we can't allocate a new inode, then we kick
> > > > synchronize_rcu() and retry the allocation, allowing inodes to be
> > > > recycled this time.
> > > 
> > > I'm starting to poke around this area since it's become clear that the
> > > currently proposed scheme just involves too much latency (unless Paul
> > > chimes in with his expedited grace period variant, at which point I will
> > > revisit) in the fast allocation/recycle path. ISTM so far that a simple
> > > "skip inodes in the radix tree, sync rcu if unsuccessful" algorithm will
> > > have pretty much the same pattern of behavior as this patch: one
> > > synchronize_rcu() per batch.
> > 
> > Apologies for being slow, but there have been some distractions.
> > One of the distractions was trying to put together atheoretically
> > attractive but massively overcomplicated implementation of
> > poll_state_synchronize_rcu_expedited().  It currently looks like a
> > somewhat suboptimal but much simpler approach is available.  This
> > assumes that XFS is not in the picture until after both the scheduler
> > and workqueues are operational.
> > 
> 
> No worries.. I don't think that would be a roadblock for us. ;)
> 
> > And yes, the complicated version might prove necessary, but let's
> > see if this whole thing is even useful first.  ;-)
> > 
> 
> Indeed. This patch only really requires a single poll/sync pair of
> calls, so assuming the expedited grace period usage plays nice enough
> with typical !expedited usage elsewhere in the kernel for some basic
> tests, it would be fairly trivial to port this over and at least get an
> idea of what the worst case behavior might be with expedited grace
> periods, whether it satisfies the existing latency requirements, etc.
> 
> Brian
> 
> > In the meantime, if you want to look at an extremely unbaked view,
> > here you go:
> > 
> > https://docs.google.com/document/d/1RNKWW9jQyfjxw2E8dsXVTdvZYh0HnYeSHDKog9jhdN8/edit?usp=sharing

And here is a version that passes moderate rcutorture testing.  So no
obvious bugs.  Probably a few non-obvious ones, though!  ;-)

This commit is on -rcu's "dev" branch along with this rcutorture
addition:

cd7bd64af59f ("EXP rcutorture: Test polled expedited grace-period primitives")

I will carry these in -rcu's "dev" branch until at least the upcoming
merge window, fixing bugs as and when they becom apparent.  If I don't
hear otherwise by that time, I will create a tag for it and leave
it behind.

The backport to v5.17-rc2 just requires removing:

	mutex_init(&rnp->boost_kthread_mutex);

From rcu_init_one().  This line is added by this -rcu commit:

02a50b09c31f ("rcu: Add mutex for rcu boost kthread spawning and affinity setting")

Please let me know how it goes!

							Thanx, Paul

------------------------------------------------------------------------

commit dd896a86aebc5b225ceee13fcf1375c7542a5e2d
Author: Paul E. McKenney <paulmck@kernel.org>
Date:   Mon Jan 31 16:55:52 2022 -0800

    EXP rcu: Add polled expedited grace-period primitives
    
    This is an experimental proof of concept of polled expedited grace-period
    functions.  These functions are get_state_synchronize_rcu_expedited(),
    start_poll_synchronize_rcu_expedited(), poll_state_synchronize_rcu_expedited(),
    and cond_synchronize_rcu_expedited(), which are similar to
    get_state_synchronize_rcu(), start_poll_synchronize_rcu(),
    poll_state_synchronize_rcu(), and cond_synchronize_rcu(), respectively.
    
    One limitation is that start_poll_synchronize_rcu_expedited() cannot
    be invoked before workqueues are initialized.
    
    Cc: Brian Foster <bfoster@redhat.com>
    Cc: Dave Chinner <david@fromorbit.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Ian Kent <raven@themaw.net>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 858f4d429946d..ca139b4b2d25f 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -23,6 +23,26 @@ static inline void cond_synchronize_rcu(unsigned long oldstate)
 	might_sleep();
 }
 
+static inline unsigned long get_state_synchronize_rcu_expedited(void)
+{
+	return get_state_synchronize_rcu();
+}
+
+static inline unsigned long start_poll_synchronize_rcu_expedited(void)
+{
+	return start_poll_synchronize_rcu();
+}
+
+static inline bool poll_state_synchronize_rcu_expedited(unsigned long oldstate)
+{
+	return poll_state_synchronize_rcu(oldstate);
+}
+
+static inline void cond_synchronize_rcu_expedited(unsigned long oldstate)
+{
+	cond_synchronize_rcu(oldstate);
+}
+
 extern void rcu_barrier(void);
 
 static inline void synchronize_rcu_expedited(void)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 76665db179fa1..eb774e9be21bf 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -40,6 +40,10 @@ bool rcu_eqs_special_set(int cpu);
 void rcu_momentary_dyntick_idle(void);
 void kfree_rcu_scheduler_running(void);
 bool rcu_gp_might_be_stalled(void);
+unsigned long get_state_synchronize_rcu_expedited(void);
+unsigned long start_poll_synchronize_rcu_expedited(void);
+bool poll_state_synchronize_rcu_expedited(unsigned long oldstate);
+void cond_synchronize_rcu_expedited(unsigned long oldstate);
 unsigned long get_state_synchronize_rcu(void);
 unsigned long start_poll_synchronize_rcu(void);
 bool poll_state_synchronize_rcu(unsigned long oldstate);
diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 24b5f2c2de87b..5b61cf20c91e9 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -23,6 +23,13 @@
 #define RCU_SEQ_CTR_SHIFT	2
 #define RCU_SEQ_STATE_MASK	((1 << RCU_SEQ_CTR_SHIFT) - 1)
 
+/*
+ * Low-order bit definitions for polled grace-period APIs.
+ */
+#define RCU_GET_STATE_FROM_EXPEDITED	0x1
+#define RCU_GET_STATE_USE_NORMAL	0x2
+#define RCU_GET_STATE_BAD_FOR_NORMAL	(RCU_GET_STATE_FROM_EXPEDITED | RCU_GET_STATE_USE_NORMAL)
+
 /*
  * Return the counter portion of a sequence number previously returned
  * by rcu_seq_snap() or rcu_seq_current().
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index e6ad532cffe78..5de36abcd7da1 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3871,7 +3871,8 @@ EXPORT_SYMBOL_GPL(start_poll_synchronize_rcu);
  */
 bool poll_state_synchronize_rcu(unsigned long oldstate)
 {
-	if (rcu_seq_done(&rcu_state.gp_seq, oldstate)) {
+	if (rcu_seq_done(&rcu_state.gp_seq, oldstate) &&
+	    !WARN_ON_ONCE(oldstate & RCU_GET_STATE_BAD_FOR_NORMAL)) {
 		smp_mb(); /* Ensure GP ends before subsequent accesses. */
 		return true;
 	}
@@ -3900,7 +3901,8 @@ EXPORT_SYMBOL_GPL(poll_state_synchronize_rcu);
  */
 void cond_synchronize_rcu(unsigned long oldstate)
 {
-	if (!poll_state_synchronize_rcu(oldstate))
+	if (!poll_state_synchronize_rcu(oldstate) &&
+	    !WARN_ON_ONCE(oldstate & RCU_GET_STATE_BAD_FOR_NORMAL))
 		synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(cond_synchronize_rcu);
@@ -4593,6 +4595,9 @@ static void __init rcu_init_one(void)
 			init_waitqueue_head(&rnp->exp_wq[3]);
 			spin_lock_init(&rnp->exp_lock);
 			mutex_init(&rnp->boost_kthread_mutex);
+			raw_spin_lock_init(&rnp->exp_poll_lock);
+			rnp->exp_seq_poll_rq = 0x1;
+			INIT_WORK(&rnp->exp_poll_wq, sync_rcu_do_polled_gp);
 		}
 	}
 
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 926673ebe355f..19fc9acce3ce2 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -128,6 +128,10 @@ struct rcu_node {
 	wait_queue_head_t exp_wq[4];
 	struct rcu_exp_work rew;
 	bool exp_need_flush;	/* Need to flush workitem? */
+	raw_spinlock_t exp_poll_lock;
+				/* Lock and data for polled expedited grace periods. */
+	unsigned long exp_seq_poll_rq;
+	struct work_struct exp_poll_wq;
 } ____cacheline_internodealigned_in_smp;
 
 /*
@@ -476,3 +480,6 @@ static void rcu_iw_handler(struct irq_work *iwp);
 static void check_cpu_stall(struct rcu_data *rdp);
 static void rcu_check_gp_start_stall(struct rcu_node *rnp, struct rcu_data *rdp,
 				     const unsigned long gpssdelay);
+
+/* Forward declarations for tree_exp.h. */
+static void sync_rcu_do_polled_gp(struct work_struct *wp);
diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index 1a45667402260..728896f374fee 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -871,3 +871,154 @@ void synchronize_rcu_expedited(void)
 		destroy_work_on_stack(&rew.rew_work);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
+
+/**
+ * get_state_synchronize_rcu_expedited - Snapshot current expedited RCU state
+ *
+ * Returns a cookie to pass to a call to cond_synchronize_rcu_expedited()
+ * or poll_state_synchronize_rcu_expedited(), allowing them to determine
+ * whether or not a full expedited grace period has elapsed in the meantime.
+ */
+unsigned long get_state_synchronize_rcu_expedited(void)
+{
+	if (rcu_gp_is_normal())
+	return get_state_synchronize_rcu() |
+	       RCU_GET_STATE_FROM_EXPEDITED | RCU_GET_STATE_USE_NORMAL;
+
+	// Any prior manipulation of RCU-protected data must happen
+	// before the load from ->expedited_sequence.
+	smp_mb();  /* ^^^ */
+	return rcu_exp_gp_seq_snap() | RCU_GET_STATE_FROM_EXPEDITED;
+}
+EXPORT_SYMBOL_GPL(get_state_synchronize_rcu_expedited);
+
+/*
+ * Ensure that start_poll_synchronize_rcu_expedited() has the expedited
+ * RCU grace periods that it needs.
+ */
+static void sync_rcu_do_polled_gp(struct work_struct *wp)
+{
+	unsigned long flags;
+	struct rcu_node *rnp = container_of(wp, struct rcu_node, exp_poll_wq);
+	unsigned long s;
+
+	raw_spin_lock_irqsave(&rnp->exp_poll_lock, flags);
+	s = rnp->exp_seq_poll_rq;
+	rnp->exp_seq_poll_rq |= 0x1;
+	raw_spin_unlock_irqrestore(&rnp->exp_poll_lock, flags);
+	if (s & 0x1)
+		return;
+	while (!sync_exp_work_done(s))
+		synchronize_rcu_expedited();
+	raw_spin_lock_irqsave(&rnp->exp_poll_lock, flags);
+	s = rnp->exp_seq_poll_rq;
+	if (!(s & 0x1) && !sync_exp_work_done(s))
+		queue_work(rcu_gp_wq, &rnp->exp_poll_wq);
+	else
+		rnp->exp_seq_poll_rq |= 0x1;
+	raw_spin_unlock_irqrestore(&rnp->exp_poll_lock, flags);
+}
+
+/**
+ * start_poll_synchronize_rcu_expedited - Snapshot current expedited RCU state and start grace period
+ *
+ * Returns a cookie to pass to a call to cond_synchronize_rcu_expedited()
+ * or poll_state_synchronize_rcu_expedited(), allowing them to determine
+ * whether or not a full expedited grace period has elapsed in the meantime.
+ * If the needed grace period is not already slated to start, initiates
+ * that grace period.
+ */
+
+unsigned long start_poll_synchronize_rcu_expedited(void)
+{
+	unsigned long flags;
+	struct rcu_data *rdp;
+	struct rcu_node *rnp;
+	unsigned long s;
+
+	if (rcu_gp_is_normal())
+		return start_poll_synchronize_rcu_expedited() |
+		       RCU_GET_STATE_FROM_EXPEDITED | RCU_GET_STATE_USE_NORMAL;
+
+	s = rcu_exp_gp_seq_snap();
+	rdp = per_cpu_ptr(&rcu_data, raw_smp_processor_id());
+	rnp = rdp->mynode;
+	raw_spin_lock_irqsave(&rnp->exp_poll_lock, flags);
+	if ((rnp->exp_seq_poll_rq & 0x1) || ULONG_CMP_LT(rnp->exp_seq_poll_rq, s)) {
+		rnp->exp_seq_poll_rq = s;
+		queue_work(rcu_gp_wq, &rnp->exp_poll_wq);
+	}
+	raw_spin_unlock_irqrestore(&rnp->exp_poll_lock, flags);
+
+	return s | RCU_GET_STATE_FROM_EXPEDITED;
+}
+EXPORT_SYMBOL_GPL(start_poll_synchronize_rcu_expedited);
+
+/**
+ * poll_state_synchronize_rcu_expedited - Conditionally wait for an expedited RCU grace period
+ *
+ * @oldstate: value from get_state_synchronize_rcu_expedited() or start_poll_synchronize_rcu_expedited()
+ *
+ * If a full expedited RCU grace period has elapsed since the earlier call
+ * from which oldstate was obtained, return @true, otherwise return @false.
+ * If @false is returned, it is the caller's responsibility to invoke
+ * this function later on until it does return @true.  Alternatively,
+ * the caller can explicitly wait for a grace period, for example, by
+ * passing @oldstate to cond_synchronize_rcu_expedited() or by directly
+ * invoking synchronize_rcu_expedited().
+ *
+ * Yes, this function does not take counter wrap into account.
+ * But counter wrap is harmless.  If the counter wraps, we have waited for
+ * more than 2 billion grace periods (and way more on a 64-bit system!).
+ * Those needing to keep oldstate values for very long time periods
+ * (several hours even on 32-bit systems) should check them occasionally
+ * and either refresh them or set a flag indicating that the grace period
+ * has completed.
+ *
+ * This function provides the same memory-ordering guarantees that would
+ * be provided by a synchronize_rcu_expedited() that was invoked at the
+ * call to the function that provided @oldstate, and that returned at the
+ * end of this function.
+ */
+bool poll_state_synchronize_rcu_expedited(unsigned long oldstate)
+{
+	WARN_ON_ONCE(!(oldstate & RCU_GET_STATE_FROM_EXPEDITED));
+	if (oldstate & RCU_GET_STATE_USE_NORMAL)
+		return poll_state_synchronize_rcu(oldstate & ~RCU_GET_STATE_BAD_FOR_NORMAL);
+	if (!rcu_exp_gp_seq_done(oldstate & ~RCU_SEQ_STATE_MASK))
+		return false;
+	smp_mb(); /* Ensure GP ends before subsequent accesses. */
+	return true;
+}
+EXPORT_SYMBOL_GPL(poll_state_synchronize_rcu_expedited);
+
+/**
+ * cond_synchronize_rcu_expedited - Conditionally wait for an expedited RCU grace period
+ *
+ * @oldstate: value from get_state_synchronize_rcu_expedited() or start_poll_synchronize_rcu_expedited()
+ *
+ * If a full expedited RCU grace period has elapsed since the earlier
+ * call from which oldstate was obtained, just return.  Otherwise, invoke
+ * synchronize_rcu_expedited() to wait for a full grace period.
+ *
+ * Yes, this function does not take counter wrap into account.  But
+ * counter wrap is harmless.  If the counter wraps, we have waited for
+ * more than 2 billion grace periods (and way more on a 64-bit system!),
+ * so waiting for one additional grace period should be just fine.
+ *
+ * This function provides the same memory-ordering guarantees that would
+ * be provided by a synchronize_rcu_expedited() that was invoked at the
+ * call to the function that provided @oldstate, and that returned at the
+ * end of this function.
+ */
+void cond_synchronize_rcu_expedited(unsigned long oldstate)
+{
+	WARN_ON_ONCE(!(oldstate & RCU_GET_STATE_FROM_EXPEDITED));
+	if (poll_state_synchronize_rcu_expedited(oldstate))
+		return;
+	if (oldstate & RCU_GET_STATE_USE_NORMAL)
+		synchronize_rcu_expedited();
+	else
+		synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(cond_synchronize_rcu_expedited);
