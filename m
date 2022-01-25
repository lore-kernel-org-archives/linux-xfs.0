Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3820C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 14:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578962AbiAYOoN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jan 2022 09:44:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46226 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579893AbiAYOkp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jan 2022 09:40:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93301615F4;
        Tue, 25 Jan 2022 14:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D02C340E0;
        Tue, 25 Jan 2022 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643121645;
        bh=56FBDb7ypflZVLsO38MZpqlHMT6rQRfJ+LSM4LriV4c=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=T+yanODraZ7hEs/y5Y9ppC7xzelQYTmT3wlUzmAJrS4UxPm0HLImMs8wLhKrmPcv9
         e/1PN7anePI3CeRFAnRyi2wtpSuH4qTD9FMvzzsZmirvguvaZt4mVlBKbsCn9BGM8O
         N4H2QsLXQmOgCYUe60ZWFH73gUZlUvGL/1h3PXibE3EKi0sLwO+rerH/HeBz1mJebI
         Dmrf0gm49mlMuZVi3qYolO7z8mow7gfv+pWYmrETrAfnOuxSNxpmebUk9ISEb8mTV0
         iL6uFWwm/nmllcD5GeKD7Zgi/aVSuncPqkRvpwBhUi917gCc4M/WTuM+rYocVudZ/I
         er1wRynTUuO0w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id BE8E05C043B; Tue, 25 Jan 2022 06:40:44 -0800 (PST)
Date:   Tue, 25 Jan 2022 06:40:44 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220125144044.GM4285@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <Ye6/g+XMSyp9vYvY@bfoster>
 <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125003120.GO59729@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 25, 2022 at 11:31:20AM +1100, Dave Chinner wrote:
> On Mon, Jan 24, 2022 at 06:29:18PM -0500, Brian Foster wrote:
> > On Tue, Jan 25, 2022 at 09:08:53AM +1100, Dave Chinner wrote:
> > > > FYI, I modified my repeated alloc/free test to do some batching and form
> > > > it into something more able to measure the potential side effect / cost
> > > > of the grace period sync. The test is a single threaded, file alloc/free
> > > > loop using a variable per iteration batch size. The test runs for ~60s
> > > > and reports how many total files were allocated/freed in that period
> > > > with the specified batch size. Note that this particular test ran
> > > > without any background workload. Results are as follows:
> > > > 
> > > > 	files		baseline	test
> > > > 
> > > > 	1		38480		38437
> > > > 	4		126055		111080
> > > > 	8		218299		134469
> > > > 	16		306619		141968
> > > > 	32		397909		152267
> > > > 	64		418603		200875
> > > > 	128		469077		289365
> > > > 	256		684117		566016
> > > > 	512		931328		878933
> > > > 	1024		1126741		1118891
> > > 
> > > Can you post the test code, because 38,000 alloc/unlinks in 60s is
> > > extremely slow for a single tight open-unlink-close loop. I'd be
> > > expecting at least ~10,000 alloc/unlink iterations per second, not
> > > 650/second.
> > > 
> > 
> > Hm, Ok. My test was just a bash script doing a 'touch <files>; rm
> > <files>' loop. I know there was application overhead because if I
> > tweaked the script to open an fd directly rather than use touch, the
> > single file performance jumped up a bit, but it seemed to wash away as I
> > increased the file count so I kept running it with larger sizes. This
> > seems off so I'll port it over to C code and see how much the numbers
> > change.
> 
> Yeah, using touch/rm becomes fork/exec bound very quickly. You'll
> find that using "echo > <file>" is much faster than "touch <file>"
> because it runs a shell built-in operation without fork/exec
> overhead to create the file. But you can't play tricks like that to
> replace rm:
> 
> $ time for ((i=0;i<1000;i++)); do touch /mnt/scratch/foo; rm /mnt/scratch/foo ; done
> 
> real    0m2.653s
> user    0m0.910s
> sys     0m2.051s
> $ time for ((i=0;i<1000;i++)); do echo > /mnt/scratch/foo; rm /mnt/scratch/foo ; done
> 
> real    0m1.260s
> user    0m0.452s
> sys     0m0.913s
> $ time ./open-unlink 1000 /mnt/scratch/foo
> 
> real    0m0.037s
> user    0m0.001s
> sys     0m0.030s
> $
> 
> Note the difference in system time between the three operations -
> almost all the difference in system CPU time is the overhead of
> fork/exec to run the touch/rm binaries, not do the filesystem
> operations....
> 
> > > > That's just a test of a quick hack, however. Since there is no real
> > > > urgency to inactivate an unlinked inode (it has no potential users until
> > > > it's freed),
> > > 
> > > On the contrary, there is extreme urgency to inactivate inodes
> > > quickly.
> > > 
> > 
> > Ok, I think we're talking about slightly different things. What I mean
> > above is that if a task removes a file and goes off doing unrelated
> > $work, that inode will just sit on the percpu queue indefinitely. That's
> > fine, as there's no functional need for us to process it immediately
> > unless we're around -ENOSPC thresholds or some such that demand reclaim
> > of the inode.
> 
> Yup, an occasional unlink sitting around for a while on an unlinked
> list isn't going to cause a performance problem.  Indeed, such
> workloads are more likely to benefit from the reduced unlink()
> syscall overhead and won't even notice the increase in background
> CPU overhead for inactivation of those occasional inodes.
> 
> > It sounds like what you're talking about is specifically
> > the behavior/performance of sustained file removal (which is important
> > obviously), where apparently there is a notable degradation if the
> > queues become deep enough to push the inode batches out of CPU cache. So
> > that makes sense...
> 
> Yup, sustained bulk throughput is where cache residency really
> matters. And for unlink, sustained unlink workloads are quite
> common; they often are something people wait for on the command line
> or make up a performance critical component of a highly concurrent
> workload so it's pretty important to get this part right.
> 
> > > Darrick made the original assumption that we could delay
> > > inactivation indefinitely and so he allowed really deep queues of up
> > > to 64k deferred inactivations. But with queues this deep, we could
> > > never get that background inactivation code to perform anywhere near
> > > the original synchronous background inactivation code. e.g. I
> > > measured 60-70% performance degradataions on my scalability tests,
> > > and nothing stood out in the profiles until I started looking at
> > > CPU data cache misses.
> > > 
> > 
> > ... but could you elaborate on the scalability tests involved here so I
> > can get a better sense of it in practice and perhaps observe the impact
> > of changes in this path?
> 
> The same conconrrent fsmark create/traverse/unlink workloads I've
> been running for the past decade+ demonstrates it pretty simply. I
> also saw regressions with dbench (both op latency and throughput) as
> the clinet count (concurrency) increased, and with compilebench.  I
> didn't look much further because all the common benchmarks I ran
> showed perf degradations with arbitrary delays that went away with
> the current code we have.  ISTR that parts of aim7/reaim scalability
> workloads that the intel zero-day infrastructure runs are quite
> sensitive to background inactivation delays as well because that's a
> CPU bound workload and hence any reduction in cache residency
> results in a reduction of the number of concurrent jobs that can be
> run.

Curiosity and all that, but has this work produced any intuition on
the sensitivity of the performance/scalability to the delays?  As in
the effect of microseconds vs. tens of microsecond vs. hundreds of
microseconds?

							Thanx, Paul
