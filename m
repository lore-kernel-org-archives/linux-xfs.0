Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE93C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 13:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381387AbiBGN64 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 08:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386994AbiBGNaM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 08:30:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8B99C0401C4
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 05:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644240609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3mcpFuC+m+0szLTypgu2TdtXe1iuzj0uKItGCv6OD3U=;
        b=IojLwrfp6U/nBY6blU4jJQ5UvdwLIYVOQVdzVLP3Fgmbx1DlkrXYzTDgcbqOq38EKKh+ZR
        Lwj53RDwaYV2xUzQjV3yRXCEABQ+fEaPbDRCINcHpckVTsmLjpXIPFQYv+QoYjgbqIp7RY
        mNP1fFvVuJU059OB+FbyK9BsI/sMAvQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-MYWUOxq8PEmuC-q5H7NBUw-1; Mon, 07 Feb 2022 08:30:08 -0500
X-MC-Unique: MYWUOxq8PEmuC-q5H7NBUw-1
Received: by mail-qt1-f199.google.com with SMTP id x5-20020ac84d45000000b002cf826b1a18so11052017qtv.2
        for <linux-xfs@vger.kernel.org>; Mon, 07 Feb 2022 05:30:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3mcpFuC+m+0szLTypgu2TdtXe1iuzj0uKItGCv6OD3U=;
        b=ceu0xWYbcAO+wz5mGeMVRFNyzqq0Lr9GmroqXBjKyB+UpQfH+q5ZQx+8lrLJ6LmSWx
         +yr/IQ+YQvzlgaweJVwdVzho1D5jMCUDzqMTTWk5J2HjaaSCwDb4W8a+0kyFdAAtby/W
         AqWx6ZQ0eVu0YTOh7vb6XFs49/hwehPpAW7Lo+Lh+Nyb4tElRYcKrc/q3Zfx4dh+69vg
         WGbR4VqtzzHyTzviLmRGcJiAx0MYjHR9FxcsPPuZEVn5gjcVb+/up24ntP8sLVt/qHVK
         fVDMi1/mAblPctx7ECS5mKr/cXn0CI53C74xlvA4A/yw0XX0UFKmLr5yt/f7ofRHnNl7
         rf8A==
X-Gm-Message-State: AOAM533QAGrhcMK4wJkUcgHCU85Z2nJ6iFxcaz7MQmfuJr92l0saCtg5
        qHLoUJhesW7bBfPGK3iOwox8aLCD4RbrSagx9zdXPeHllej44EY+V+EelXs7eAR06zC0cGB4Q7r
        uIQk81BJ3/O6egGVKCtca
X-Received: by 2002:a05:622a:1303:: with SMTP id v3mr7846520qtk.294.1644240606743;
        Mon, 07 Feb 2022 05:30:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx36B8ezQnN7qpye/NrkKVOhlwo0Dwh6W9MUDOXZQptoI8hEl5Gn5T241EHG18XgSml8fJ5mg==
X-Received: by 2002:a05:622a:1303:: with SMTP id v3mr7846494qtk.294.1644240606285;
        Mon, 07 Feb 2022 05:30:06 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id y20sm4320895qtw.28.2022.02.07.05.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 05:30:05 -0800 (PST)
Date:   Mon, 7 Feb 2022 08:30:03 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <YgEe21z+WUvpQa0N@bfoster>
References: <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
 <YfBBzHascwVnefYY@bfoster>
 <20220125224551.GQ59729@dread.disaster.area>
 <YfIdVq6R6xEWxy0K@zeniv-ca.linux.org.uk>
 <20220127052609.GR59729@dread.disaster.area>
 <YfLsBdPBSsyPFgHJ@bfoster>
 <20220128213911.GO4285@paulmck-ThinkPad-P17-Gen-1>
 <Yffioz+t9cjZbIBv@bfoster>
 <20220201220028.GH4285@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201220028.GH4285@paulmck-ThinkPad-P17-Gen-1>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 01, 2022 at 02:00:28PM -0800, Paul E. McKenney wrote:
> On Mon, Jan 31, 2022 at 08:22:43AM -0500, Brian Foster wrote:
> > On Fri, Jan 28, 2022 at 01:39:11PM -0800, Paul E. McKenney wrote:
> > > On Thu, Jan 27, 2022 at 02:01:25PM -0500, Brian Foster wrote:
> > > > On Thu, Jan 27, 2022 at 04:26:09PM +1100, Dave Chinner wrote:
> > > > > On Thu, Jan 27, 2022 at 04:19:34AM +0000, Al Viro wrote:
> > > > > > On Wed, Jan 26, 2022 at 09:45:51AM +1100, Dave Chinner wrote:
> > > > > > 
> > > > > > > Right, background inactivation does not improve performance - it's
> > > > > > > necessary to get the transactions out of the evict() path. All we
> > > > > > > wanted was to ensure that there were no performance degradations as
> > > > > > > a result of background inactivation, not that it was faster.
> > > > > > > 
> > > > > > > If you want to confirm that there is an increase in cold cache
> > > > > > > access when the batch size is increased, cpu profiles with 'perf
> > > > > > > top'/'perf record/report' and CPU cache performance metric reporting
> > > > > > > via 'perf stat -dddd' are your friend. See elsewhere in the thread
> > > > > > > where I mention those things to Paul.
> > > > > > 
> > > > > > Dave, do you see a plausible way to eventually drop Ian's bandaid?
> > > > > > I'm not asking for that to happen this cycle and for backports Ian's
> > > > > > patch is obviously fine.
> > > > > 
> > > > > Yes, but not in the near term.
> > > > > 
> > > > > > What I really want to avoid is the situation when we are stuck with
> > > > > > keeping that bandaid in fs/namei.c, since all ways to avoid seeing
> > > > > > reused inodes would hurt XFS too badly.  And the benchmarks in this
> > > > > > thread do look like that.
> > > > > 
> > > > > The simplest way I think is to have the XFS inode allocation track
> > > > > "busy inodes" in the same way we track "busy extents". A busy extent
> > > > > is an extent that has been freed by the user, but is not yet marked
> > > > > free in the journal/on disk. If we try to reallocate that busy
> > > > > extent, we either select a different free extent to allocate, or if
> > > > > we can't find any we force the journal to disk, wait for it to
> > > > > complete (hence unbusying the extents) and retry the allocation
> > > > > again.
> > > > > 
> > > > > We can do something similar for inode allocation - it's actually a
> > > > > lockless tag lookup on the radix tree entry for the candidate inode
> > > > > number. If we find the reclaimable radix tree tag set, the we select
> > > > > a different inode. If we can't allocate a new inode, then we kick
> > > > > synchronize_rcu() and retry the allocation, allowing inodes to be
> > > > > recycled this time.
> > > > 
> > > > I'm starting to poke around this area since it's become clear that the
> > > > currently proposed scheme just involves too much latency (unless Paul
> > > > chimes in with his expedited grace period variant, at which point I will
> > > > revisit) in the fast allocation/recycle path. ISTM so far that a simple
> > > > "skip inodes in the radix tree, sync rcu if unsuccessful" algorithm will
> > > > have pretty much the same pattern of behavior as this patch: one
> > > > synchronize_rcu() per batch.
> > > 
> > > Apologies for being slow, but there have been some distractions.
> > > One of the distractions was trying to put together atheoretically
> > > attractive but massively overcomplicated implementation of
> > > poll_state_synchronize_rcu_expedited().  It currently looks like a
> > > somewhat suboptimal but much simpler approach is available.  This
> > > assumes that XFS is not in the picture until after both the scheduler
> > > and workqueues are operational.
> > > 
> > 
> > No worries.. I don't think that would be a roadblock for us. ;)
> > 
> > > And yes, the complicated version might prove necessary, but let's
> > > see if this whole thing is even useful first.  ;-)
> > > 
> > 
> > Indeed. This patch only really requires a single poll/sync pair of
> > calls, so assuming the expedited grace period usage plays nice enough
> > with typical !expedited usage elsewhere in the kernel for some basic
> > tests, it would be fairly trivial to port this over and at least get an
> > idea of what the worst case behavior might be with expedited grace
> > periods, whether it satisfies the existing latency requirements, etc.
> > 
> > Brian
> > 
> > > In the meantime, if you want to look at an extremely unbaked view,
> > > here you go:
> > > 
> > > https://docs.google.com/document/d/1RNKWW9jQyfjxw2E8dsXVTdvZYh0HnYeSHDKog9jhdN8/edit?usp=sharing
> 
> And here is a version that passes moderate rcutorture testing.  So no
> obvious bugs.  Probably a few non-obvious ones, though!  ;-)
> 
> This commit is on -rcu's "dev" branch along with this rcutorture
> addition:
> 
> cd7bd64af59f ("EXP rcutorture: Test polled expedited grace-period primitives")
> 
> I will carry these in -rcu's "dev" branch until at least the upcoming
> merge window, fixing bugs as and when they becom apparent.  If I don't
> hear otherwise by that time, I will create a tag for it and leave
> it behind.
> 
> The backport to v5.17-rc2 just requires removing:
> 
> 	mutex_init(&rnp->boost_kthread_mutex);
> 
> From rcu_init_one().  This line is added by this -rcu commit:
> 
> 02a50b09c31f ("rcu: Add mutex for rcu boost kthread spawning and affinity setting")
> 
> Please let me know how it goes!
> 

Thanks Paul. I gave this a whirl with a ported variant of this patch on
top. There is definitely a notable improvement with the expedited grace
periods. A few quick runs of the same batched alloc/free test (i.e. 10
sample) I had run against the original version:

batch	baseline	baseline+bg	test	test+bg

1	889954		210075		552911	25540
4	879540		212740		575356	24624
8	924928		213568		496992	26080
16	922960		211504		518496	24592
32	844832		219744		524672	28608
64	579968		196544		358720	24128
128	667392		195840		397696	22400
256	624896		197888		376320	31232
512	572928		204800		382464	46080
1024	549888		174080		379904	73728
2048	522240		174080		350208	106496
4096	536576		167936		360448	131072

So this shows a major improvement in the case where the system is
otherwise idle. We still aren't quite at the baseline numbers, but
that's not really the goal here because those numbers are partly driven
by the fact that we unsafely reuse recently freed inodes in cases where
proper behavior would be to allocate new inode chunks for a period of
time. The core test numbers are much closer to the single threaded
allocation rate (55k-65k inodes/sec) on this setup, so that is quite
positive.

The "bg" variants are the same tests with 64 tasks doing unrelated
pathwalk listings on a kernel source tree (on separate storage)
concurrently in the background. The purpose of this was just to generate
background (rcu) activity in the form of pathname lookups and whatnot
and see how that impacts the results. This clearly affects both kernels,
but the test kernel drops down closer to numbers reminiscent of the
non-expedited grace period variant. Note that this impact seems to scale
with increased background workload. With a similar test running only 8
background tasks, the test kernel is pretty consistently in the
225k-250k (per 10s) range across the set of batch sizes. That's about
half the core test rate, so still not as terrible as the original
variant. ;)

In any event, this probably requires some thought/discussion (and more
testing) on whether this is considered an acceptable change or whether
we want to explore options to mitigate this further. I am still playing
with some ideas to potentially mitigate grace period latency, so it
might be worth seeing if anything useful falls out of that as well.
Thoughts appreciated...

Brian

> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> commit dd896a86aebc5b225ceee13fcf1375c7542a5e2d
> Author: Paul E. McKenney <paulmck@kernel.org>
> Date:   Mon Jan 31 16:55:52 2022 -0800
> 
>     EXP rcu: Add polled expedited grace-period primitives
>     
>     This is an experimental proof of concept of polled expedited grace-period
>     functions.  These functions are get_state_synchronize_rcu_expedited(),
>     start_poll_synchronize_rcu_expedited(), poll_state_synchronize_rcu_expedited(),
>     and cond_synchronize_rcu_expedited(), which are similar to
>     get_state_synchronize_rcu(), start_poll_synchronize_rcu(),
>     poll_state_synchronize_rcu(), and cond_synchronize_rcu(), respectively.
>     
>     One limitation is that start_poll_synchronize_rcu_expedited() cannot
>     be invoked before workqueues are initialized.
>     
>     Cc: Brian Foster <bfoster@redhat.com>
>     Cc: Dave Chinner <david@fromorbit.com>
>     Cc: Al Viro <viro@zeniv.linux.org.uk>
>     Cc: Ian Kent <raven@themaw.net>
>     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> 
> diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> index 858f4d429946d..ca139b4b2d25f 100644
> --- a/include/linux/rcutiny.h
> +++ b/include/linux/rcutiny.h
> @@ -23,6 +23,26 @@ static inline void cond_synchronize_rcu(unsigned long oldstate)
>  	might_sleep();
>  }
>  
> +static inline unsigned long get_state_synchronize_rcu_expedited(void)
> +{
> +	return get_state_synchronize_rcu();
> +}
> +
> +static inline unsigned long start_poll_synchronize_rcu_expedited(void)
> +{
> +	return start_poll_synchronize_rcu();
> +}
> +
> +static inline bool poll_state_synchronize_rcu_expedited(unsigned long oldstate)
> +{
> +	return poll_state_synchronize_rcu(oldstate);
> +}
> +
> +static inline void cond_synchronize_rcu_expedited(unsigned long oldstate)
> +{
> +	cond_synchronize_rcu(oldstate);
> +}
> +
>  extern void rcu_barrier(void);
>  
>  static inline void synchronize_rcu_expedited(void)
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 76665db179fa1..eb774e9be21bf 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -40,6 +40,10 @@ bool rcu_eqs_special_set(int cpu);
>  void rcu_momentary_dyntick_idle(void);
>  void kfree_rcu_scheduler_running(void);
>  bool rcu_gp_might_be_stalled(void);
> +unsigned long get_state_synchronize_rcu_expedited(void);
> +unsigned long start_poll_synchronize_rcu_expedited(void);
> +bool poll_state_synchronize_rcu_expedited(unsigned long oldstate);
> +void cond_synchronize_rcu_expedited(unsigned long oldstate);
>  unsigned long get_state_synchronize_rcu(void);
>  unsigned long start_poll_synchronize_rcu(void);
>  bool poll_state_synchronize_rcu(unsigned long oldstate);
> diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
> index 24b5f2c2de87b..5b61cf20c91e9 100644
> --- a/kernel/rcu/rcu.h
> +++ b/kernel/rcu/rcu.h
> @@ -23,6 +23,13 @@
>  #define RCU_SEQ_CTR_SHIFT	2
>  #define RCU_SEQ_STATE_MASK	((1 << RCU_SEQ_CTR_SHIFT) - 1)
>  
> +/*
> + * Low-order bit definitions for polled grace-period APIs.
> + */
> +#define RCU_GET_STATE_FROM_EXPEDITED	0x1
> +#define RCU_GET_STATE_USE_NORMAL	0x2
> +#define RCU_GET_STATE_BAD_FOR_NORMAL	(RCU_GET_STATE_FROM_EXPEDITED | RCU_GET_STATE_USE_NORMAL)
> +
>  /*
>   * Return the counter portion of a sequence number previously returned
>   * by rcu_seq_snap() or rcu_seq_current().
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index e6ad532cffe78..5de36abcd7da1 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -3871,7 +3871,8 @@ EXPORT_SYMBOL_GPL(start_poll_synchronize_rcu);
>   */
>  bool poll_state_synchronize_rcu(unsigned long oldstate)
>  {
> -	if (rcu_seq_done(&rcu_state.gp_seq, oldstate)) {
> +	if (rcu_seq_done(&rcu_state.gp_seq, oldstate) &&
> +	    !WARN_ON_ONCE(oldstate & RCU_GET_STATE_BAD_FOR_NORMAL)) {
>  		smp_mb(); /* Ensure GP ends before subsequent accesses. */
>  		return true;
>  	}
> @@ -3900,7 +3901,8 @@ EXPORT_SYMBOL_GPL(poll_state_synchronize_rcu);
>   */
>  void cond_synchronize_rcu(unsigned long oldstate)
>  {
> -	if (!poll_state_synchronize_rcu(oldstate))
> +	if (!poll_state_synchronize_rcu(oldstate) &&
> +	    !WARN_ON_ONCE(oldstate & RCU_GET_STATE_BAD_FOR_NORMAL))
>  		synchronize_rcu();
>  }
>  EXPORT_SYMBOL_GPL(cond_synchronize_rcu);
> @@ -4593,6 +4595,9 @@ static void __init rcu_init_one(void)
>  			init_waitqueue_head(&rnp->exp_wq[3]);
>  			spin_lock_init(&rnp->exp_lock);
>  			mutex_init(&rnp->boost_kthread_mutex);
> +			raw_spin_lock_init(&rnp->exp_poll_lock);
> +			rnp->exp_seq_poll_rq = 0x1;
> +			INIT_WORK(&rnp->exp_poll_wq, sync_rcu_do_polled_gp);
>  		}
>  	}
>  
> diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> index 926673ebe355f..19fc9acce3ce2 100644
> --- a/kernel/rcu/tree.h
> +++ b/kernel/rcu/tree.h
> @@ -128,6 +128,10 @@ struct rcu_node {
>  	wait_queue_head_t exp_wq[4];
>  	struct rcu_exp_work rew;
>  	bool exp_need_flush;	/* Need to flush workitem? */
> +	raw_spinlock_t exp_poll_lock;
> +				/* Lock and data for polled expedited grace periods. */
> +	unsigned long exp_seq_poll_rq;
> +	struct work_struct exp_poll_wq;
>  } ____cacheline_internodealigned_in_smp;
>  
>  /*
> @@ -476,3 +480,6 @@ static void rcu_iw_handler(struct irq_work *iwp);
>  static void check_cpu_stall(struct rcu_data *rdp);
>  static void rcu_check_gp_start_stall(struct rcu_node *rnp, struct rcu_data *rdp,
>  				     const unsigned long gpssdelay);
> +
> +/* Forward declarations for tree_exp.h. */
> +static void sync_rcu_do_polled_gp(struct work_struct *wp);
> diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
> index 1a45667402260..728896f374fee 100644
> --- a/kernel/rcu/tree_exp.h
> +++ b/kernel/rcu/tree_exp.h
> @@ -871,3 +871,154 @@ void synchronize_rcu_expedited(void)
>  		destroy_work_on_stack(&rew.rew_work);
>  }
>  EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
> +
> +/**
> + * get_state_synchronize_rcu_expedited - Snapshot current expedited RCU state
> + *
> + * Returns a cookie to pass to a call to cond_synchronize_rcu_expedited()
> + * or poll_state_synchronize_rcu_expedited(), allowing them to determine
> + * whether or not a full expedited grace period has elapsed in the meantime.
> + */
> +unsigned long get_state_synchronize_rcu_expedited(void)
> +{
> +	if (rcu_gp_is_normal())
> +	return get_state_synchronize_rcu() |
> +	       RCU_GET_STATE_FROM_EXPEDITED | RCU_GET_STATE_USE_NORMAL;
> +
> +	// Any prior manipulation of RCU-protected data must happen
> +	// before the load from ->expedited_sequence.
> +	smp_mb();  /* ^^^ */
> +	return rcu_exp_gp_seq_snap() | RCU_GET_STATE_FROM_EXPEDITED;
> +}
> +EXPORT_SYMBOL_GPL(get_state_synchronize_rcu_expedited);
> +
> +/*
> + * Ensure that start_poll_synchronize_rcu_expedited() has the expedited
> + * RCU grace periods that it needs.
> + */
> +static void sync_rcu_do_polled_gp(struct work_struct *wp)
> +{
> +	unsigned long flags;
> +	struct rcu_node *rnp = container_of(wp, struct rcu_node, exp_poll_wq);
> +	unsigned long s;
> +
> +	raw_spin_lock_irqsave(&rnp->exp_poll_lock, flags);
> +	s = rnp->exp_seq_poll_rq;
> +	rnp->exp_seq_poll_rq |= 0x1;
> +	raw_spin_unlock_irqrestore(&rnp->exp_poll_lock, flags);
> +	if (s & 0x1)
> +		return;
> +	while (!sync_exp_work_done(s))
> +		synchronize_rcu_expedited();
> +	raw_spin_lock_irqsave(&rnp->exp_poll_lock, flags);
> +	s = rnp->exp_seq_poll_rq;
> +	if (!(s & 0x1) && !sync_exp_work_done(s))
> +		queue_work(rcu_gp_wq, &rnp->exp_poll_wq);
> +	else
> +		rnp->exp_seq_poll_rq |= 0x1;
> +	raw_spin_unlock_irqrestore(&rnp->exp_poll_lock, flags);
> +}
> +
> +/**
> + * start_poll_synchronize_rcu_expedited - Snapshot current expedited RCU state and start grace period
> + *
> + * Returns a cookie to pass to a call to cond_synchronize_rcu_expedited()
> + * or poll_state_synchronize_rcu_expedited(), allowing them to determine
> + * whether or not a full expedited grace period has elapsed in the meantime.
> + * If the needed grace period is not already slated to start, initiates
> + * that grace period.
> + */
> +
> +unsigned long start_poll_synchronize_rcu_expedited(void)
> +{
> +	unsigned long flags;
> +	struct rcu_data *rdp;
> +	struct rcu_node *rnp;
> +	unsigned long s;
> +
> +	if (rcu_gp_is_normal())
> +		return start_poll_synchronize_rcu_expedited() |
> +		       RCU_GET_STATE_FROM_EXPEDITED | RCU_GET_STATE_USE_NORMAL;
> +
> +	s = rcu_exp_gp_seq_snap();
> +	rdp = per_cpu_ptr(&rcu_data, raw_smp_processor_id());
> +	rnp = rdp->mynode;
> +	raw_spin_lock_irqsave(&rnp->exp_poll_lock, flags);
> +	if ((rnp->exp_seq_poll_rq & 0x1) || ULONG_CMP_LT(rnp->exp_seq_poll_rq, s)) {
> +		rnp->exp_seq_poll_rq = s;
> +		queue_work(rcu_gp_wq, &rnp->exp_poll_wq);
> +	}
> +	raw_spin_unlock_irqrestore(&rnp->exp_poll_lock, flags);
> +
> +	return s | RCU_GET_STATE_FROM_EXPEDITED;
> +}
> +EXPORT_SYMBOL_GPL(start_poll_synchronize_rcu_expedited);
> +
> +/**
> + * poll_state_synchronize_rcu_expedited - Conditionally wait for an expedited RCU grace period
> + *
> + * @oldstate: value from get_state_synchronize_rcu_expedited() or start_poll_synchronize_rcu_expedited()
> + *
> + * If a full expedited RCU grace period has elapsed since the earlier call
> + * from which oldstate was obtained, return @true, otherwise return @false.
> + * If @false is returned, it is the caller's responsibility to invoke
> + * this function later on until it does return @true.  Alternatively,
> + * the caller can explicitly wait for a grace period, for example, by
> + * passing @oldstate to cond_synchronize_rcu_expedited() or by directly
> + * invoking synchronize_rcu_expedited().
> + *
> + * Yes, this function does not take counter wrap into account.
> + * But counter wrap is harmless.  If the counter wraps, we have waited for
> + * more than 2 billion grace periods (and way more on a 64-bit system!).
> + * Those needing to keep oldstate values for very long time periods
> + * (several hours even on 32-bit systems) should check them occasionally
> + * and either refresh them or set a flag indicating that the grace period
> + * has completed.
> + *
> + * This function provides the same memory-ordering guarantees that would
> + * be provided by a synchronize_rcu_expedited() that was invoked at the
> + * call to the function that provided @oldstate, and that returned at the
> + * end of this function.
> + */
> +bool poll_state_synchronize_rcu_expedited(unsigned long oldstate)
> +{
> +	WARN_ON_ONCE(!(oldstate & RCU_GET_STATE_FROM_EXPEDITED));
> +	if (oldstate & RCU_GET_STATE_USE_NORMAL)
> +		return poll_state_synchronize_rcu(oldstate & ~RCU_GET_STATE_BAD_FOR_NORMAL);
> +	if (!rcu_exp_gp_seq_done(oldstate & ~RCU_SEQ_STATE_MASK))
> +		return false;
> +	smp_mb(); /* Ensure GP ends before subsequent accesses. */
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(poll_state_synchronize_rcu_expedited);
> +
> +/**
> + * cond_synchronize_rcu_expedited - Conditionally wait for an expedited RCU grace period
> + *
> + * @oldstate: value from get_state_synchronize_rcu_expedited() or start_poll_synchronize_rcu_expedited()
> + *
> + * If a full expedited RCU grace period has elapsed since the earlier
> + * call from which oldstate was obtained, just return.  Otherwise, invoke
> + * synchronize_rcu_expedited() to wait for a full grace period.
> + *
> + * Yes, this function does not take counter wrap into account.  But
> + * counter wrap is harmless.  If the counter wraps, we have waited for
> + * more than 2 billion grace periods (and way more on a 64-bit system!),
> + * so waiting for one additional grace period should be just fine.
> + *
> + * This function provides the same memory-ordering guarantees that would
> + * be provided by a synchronize_rcu_expedited() that was invoked at the
> + * call to the function that provided @oldstate, and that returned at the
> + * end of this function.
> + */
> +void cond_synchronize_rcu_expedited(unsigned long oldstate)
> +{
> +	WARN_ON_ONCE(!(oldstate & RCU_GET_STATE_FROM_EXPEDITED));
> +	if (poll_state_synchronize_rcu_expedited(oldstate))
> +		return;
> +	if (oldstate & RCU_GET_STATE_USE_NORMAL)
> +		synchronize_rcu_expedited();
> +	else
> +		synchronize_rcu();
> +}
> +EXPORT_SYMBOL_GPL(cond_synchronize_rcu_expedited);
> 

