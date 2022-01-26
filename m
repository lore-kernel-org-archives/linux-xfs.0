Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B02C28CF5
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jan 2022 05:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbiAZF3P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jan 2022 00:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiAZF3N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jan 2022 00:29:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6707CC06161C;
        Tue, 25 Jan 2022 21:29:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F2DBB81A07;
        Wed, 26 Jan 2022 05:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B57C340E3;
        Wed, 26 Jan 2022 05:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643174950;
        bh=k1wjdP/PHUo0kqRLUFTB8gQQaP7TeQFK1K6ooRsTgAw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=qVXHnPNBOrG2rFrxV68iUf5Za8CrGOzNuc9qtn42OKsUkg5RrNxYmHi6kpaqbLLSN
         lvemQc5IUBqYVEWNp+UaRdK9ohkDY/Q/MNrWm57zF8i69zjJ6IyYD9GpWEzkW2YfL3
         WSTFfX0BaiTmWsSmhRzoTE9BeX5iliTndZxoQwqFIfpW3kXMTDVXMKsCnozxtl/0nS
         ZG3kS8JQ9I+1zMZjeT/VAZZdzB3froD3Xz+o6yxeuU+M+fQg9k+AgxBoU9KQkKNp/B
         EwMt6uzuqYdkY6TyEruG1/QWqbtvAK8nHaf1VsyAEgfcguUUazEC8qkLYaOf0nlit/
         ZBjawQLUYNsAA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id A88765C102F; Tue, 25 Jan 2022 21:29:10 -0800 (PST)
Date:   Tue, 25 Jan 2022 21:29:10 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220126052910.GX4285@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <Ye6/g+XMSyp9vYvY@bfoster>
 <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
 <20220125144044.GM4285@paulmck-ThinkPad-P17-Gen-1>
 <20220125223607.GP59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125223607.GP59729@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 26, 2022 at 09:36:07AM +1100, Dave Chinner wrote:
> On Tue, Jan 25, 2022 at 06:40:44AM -0800, Paul E. McKenney wrote:
> > On Tue, Jan 25, 2022 at 11:31:20AM +1100, Dave Chinner wrote:
> > > > Ok, I think we're talking about slightly different things. What I mean
> > > > above is that if a task removes a file and goes off doing unrelated
> > > > $work, that inode will just sit on the percpu queue indefinitely. That's
> > > > fine, as there's no functional need for us to process it immediately
> > > > unless we're around -ENOSPC thresholds or some such that demand reclaim
> > > > of the inode.
> > > 
> > > Yup, an occasional unlink sitting around for a while on an unlinked
> > > list isn't going to cause a performance problem.  Indeed, such
> > > workloads are more likely to benefit from the reduced unlink()
> > > syscall overhead and won't even notice the increase in background
> > > CPU overhead for inactivation of those occasional inodes.
> > > 
> > > > It sounds like what you're talking about is specifically
> > > > the behavior/performance of sustained file removal (which is important
> > > > obviously), where apparently there is a notable degradation if the
> > > > queues become deep enough to push the inode batches out of CPU cache. So
> > > > that makes sense...
> > > 
> > > Yup, sustained bulk throughput is where cache residency really
> > > matters. And for unlink, sustained unlink workloads are quite
> > > common; they often are something people wait for on the command line
> > > or make up a performance critical component of a highly concurrent
> > > workload so it's pretty important to get this part right.
> > > 
> > > > > Darrick made the original assumption that we could delay
> > > > > inactivation indefinitely and so he allowed really deep queues of up
> > > > > to 64k deferred inactivations. But with queues this deep, we could
> > > > > never get that background inactivation code to perform anywhere near
> > > > > the original synchronous background inactivation code. e.g. I
> > > > > measured 60-70% performance degradataions on my scalability tests,
> > > > > and nothing stood out in the profiles until I started looking at
> > > > > CPU data cache misses.
> > > > > 
> > > > 
> > > > ... but could you elaborate on the scalability tests involved here so I
> > > > can get a better sense of it in practice and perhaps observe the impact
> > > > of changes in this path?
> > > 
> > > The same conconrrent fsmark create/traverse/unlink workloads I've
> > > been running for the past decade+ demonstrates it pretty simply. I
> > > also saw regressions with dbench (both op latency and throughput) as
> > > the clinet count (concurrency) increased, and with compilebench.  I
> > > didn't look much further because all the common benchmarks I ran
> > > showed perf degradations with arbitrary delays that went away with
> > > the current code we have.  ISTR that parts of aim7/reaim scalability
> > > workloads that the intel zero-day infrastructure runs are quite
> > > sensitive to background inactivation delays as well because that's a
> > > CPU bound workload and hence any reduction in cache residency
> > > results in a reduction of the number of concurrent jobs that can be
> > > run.
> > 
> > Curiosity and all that, but has this work produced any intuition on
> > the sensitivity of the performance/scalability to the delays?  As in
> > the effect of microseconds vs. tens of microsecond vs. hundreds of
> > microseconds?
> 
> Some, yes.
> 
> The upper delay threshold where performance is measurably
> impacted is in the order of single digit milliseconds, not
> microseconds.
> 
> What I saw was that as the batch processing delay goes beyond ~5ms,
> IPC starts to fall. The CPU usage profile does not change shape, nor
> does the proportions of where CPU time is spent change. All I see if
> data cache misses go up substantially and IPC drop substantially. If
> I read my notes correctly, typical change from "fast" to "slow" in
> IPC was 0.82 to 0.39 and LLC-load-misses from 3% to 12%. The IPC
> degradation was all done by the time the background batch processing
> times were longer than a typical scheduler tick (10ms).
> 
> Now, I've been testing on Xeon CPUs with 36-76MB of l2-l3 caches, so
> there's a fair amount of data that these can hold. I expect that
> with smaller caches, the inflection point will be at smaller batch
> sizes rather than more. Hence while I could have used larger batches
> for background processing (e.g. 64-128 inodes rather than 32), I
> chose smaller batch sizes by default so that CPUs with smaller
> caches are less likely to be adversely affected by the batch size
> being too large. OTOH, I started to measure noticable degradation by
> batch sizes of 256 inodes on my machines, which is why the hard
> queue limit got set to 256 inodes.
> 
> Scaling the delay/batch size down towards single inode queuing also
> resulted in perf degradation. This was largely because of all the
> extra scheduling overhead that trying to switching between user task
> and kernel worker task for every inode entailed. Context switch rate
> went from a couple of thousand/sec to over 100,000/s for single
> inode batches, and performance went backwards in proportion with the
> amount of CPU then spent on context switches. It also lead to
> increases in buffer lock contention (hence context switches) as both
> user task and kworker try to access the same buffers...

Makes sense.  Never a guarantee of easy answers.  ;-)

If it would help, I could create expedited-grace-period counterparts
of get_state_synchronize_rcu(), start_poll_synchronize_rcu(),
poll_state_synchronize_rcu(), and cond_synchronize_rcu().  These would
provide sub-millisecond grace periods, in fact, sub-100-microsecond
grace periods on smaller systems.

Of course, nothing comes for free.  Although expedited grace periods
are way way cheaper than they used to be, they still IPI non-idle
non-nohz_full-userspace CPUs, which translates to roughly the CPU overhead
of a wakeup on each IPIed CPU.  And of course disruption to aggressive
non-nohz_full real-time applications.  Shorter latencies also translates
to fewer updates over which to amortize grace-period overhead.

But it should get well under your single-digit milliseconds of delay.

							Thanx, Paul
