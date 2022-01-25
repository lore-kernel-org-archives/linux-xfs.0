Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EBFC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 02:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3417627AbiAYCKP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:10:15 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56982 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S3410981AbiAYAb2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 19:31:28 -0500
Received: from dread.disaster.area (pa49-179-45-11.pa.nsw.optusnet.com.au [49.179.45.11])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D14C410C30E1;
        Tue, 25 Jan 2022 11:31:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nC9k0-003qOb-Rk; Tue, 25 Jan 2022 11:31:20 +1100
Date:   Tue, 25 Jan 2022 11:31:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220125003120.GO59729@dread.disaster.area>
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <Ye6/g+XMSyp9vYvY@bfoster>
 <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye82TgBY0VmtTjMc@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61ef44db
        a=Eslsx4mF8WGvnV49LKizaA==:117 a=Eslsx4mF8WGvnV49LKizaA==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=Xbp24aNU5GC-INWE7skA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 24, 2022 at 06:29:18PM -0500, Brian Foster wrote:
> On Tue, Jan 25, 2022 at 09:08:53AM +1100, Dave Chinner wrote:
> > > FYI, I modified my repeated alloc/free test to do some batching and form
> > > it into something more able to measure the potential side effect / cost
> > > of the grace period sync. The test is a single threaded, file alloc/free
> > > loop using a variable per iteration batch size. The test runs for ~60s
> > > and reports how many total files were allocated/freed in that period
> > > with the specified batch size. Note that this particular test ran
> > > without any background workload. Results are as follows:
> > > 
> > > 	files		baseline	test
> > > 
> > > 	1		38480		38437
> > > 	4		126055		111080
> > > 	8		218299		134469
> > > 	16		306619		141968
> > > 	32		397909		152267
> > > 	64		418603		200875
> > > 	128		469077		289365
> > > 	256		684117		566016
> > > 	512		931328		878933
> > > 	1024		1126741		1118891
> > 
> > Can you post the test code, because 38,000 alloc/unlinks in 60s is
> > extremely slow for a single tight open-unlink-close loop. I'd be
> > expecting at least ~10,000 alloc/unlink iterations per second, not
> > 650/second.
> > 
> 
> Hm, Ok. My test was just a bash script doing a 'touch <files>; rm
> <files>' loop. I know there was application overhead because if I
> tweaked the script to open an fd directly rather than use touch, the
> single file performance jumped up a bit, but it seemed to wash away as I
> increased the file count so I kept running it with larger sizes. This
> seems off so I'll port it over to C code and see how much the numbers
> change.

Yeah, using touch/rm becomes fork/exec bound very quickly. You'll
find that using "echo > <file>" is much faster than "touch <file>"
because it runs a shell built-in operation without fork/exec
overhead to create the file. But you can't play tricks like that to
replace rm:

$ time for ((i=0;i<1000;i++)); do touch /mnt/scratch/foo; rm /mnt/scratch/foo ; done

real    0m2.653s
user    0m0.910s
sys     0m2.051s
$ time for ((i=0;i<1000;i++)); do echo > /mnt/scratch/foo; rm /mnt/scratch/foo ; done

real    0m1.260s
user    0m0.452s
sys     0m0.913s
$ time ./open-unlink 1000 /mnt/scratch/foo

real    0m0.037s
user    0m0.001s
sys     0m0.030s
$

Note the difference in system time between the three operations -
almost all the difference in system CPU time is the overhead of
fork/exec to run the touch/rm binaries, not do the filesystem
operations....

> > > That's just a test of a quick hack, however. Since there is no real
> > > urgency to inactivate an unlinked inode (it has no potential users until
> > > it's freed),
> > 
> > On the contrary, there is extreme urgency to inactivate inodes
> > quickly.
> > 
> 
> Ok, I think we're talking about slightly different things. What I mean
> above is that if a task removes a file and goes off doing unrelated
> $work, that inode will just sit on the percpu queue indefinitely. That's
> fine, as there's no functional need for us to process it immediately
> unless we're around -ENOSPC thresholds or some such that demand reclaim
> of the inode.

Yup, an occasional unlink sitting around for a while on an unlinked
list isn't going to cause a performance problem.  Indeed, such
workloads are more likely to benefit from the reduced unlink()
syscall overhead and won't even notice the increase in background
CPU overhead for inactivation of those occasional inodes.

> It sounds like what you're talking about is specifically
> the behavior/performance of sustained file removal (which is important
> obviously), where apparently there is a notable degradation if the
> queues become deep enough to push the inode batches out of CPU cache. So
> that makes sense...

Yup, sustained bulk throughput is where cache residency really
matters. And for unlink, sustained unlink workloads are quite
common; they often are something people wait for on the command line
or make up a performance critical component of a highly concurrent
workload so it's pretty important to get this part right.

> > Darrick made the original assumption that we could delay
> > inactivation indefinitely and so he allowed really deep queues of up
> > to 64k deferred inactivations. But with queues this deep, we could
> > never get that background inactivation code to perform anywhere near
> > the original synchronous background inactivation code. e.g. I
> > measured 60-70% performance degradataions on my scalability tests,
> > and nothing stood out in the profiles until I started looking at
> > CPU data cache misses.
> > 
> 
> ... but could you elaborate on the scalability tests involved here so I
> can get a better sense of it in practice and perhaps observe the impact
> of changes in this path?

The same conconrrent fsmark create/traverse/unlink workloads I've
been running for the past decade+ demonstrates it pretty simply. I
also saw regressions with dbench (both op latency and throughput) as
the clinet count (concurrency) increased, and with compilebench.  I
didn't look much further because all the common benchmarks I ran
showed perf degradations with arbitrary delays that went away with
the current code we have.  ISTR that parts of aim7/reaim scalability
workloads that the intel zero-day infrastructure runs are quite
sensitive to background inactivation delays as well because that's a
CPU bound workload and hence any reduction in cache residency
results in a reduction of the number of concurrent jobs that can be
run.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
