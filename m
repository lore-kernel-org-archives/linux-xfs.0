Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 629FCC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 23:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BBFC6128C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 23:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhJGXq2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 19:46:28 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60628 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233854AbhJGXq2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Oct 2021 19:46:28 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 28982884BC6;
        Fri,  8 Oct 2021 10:44:31 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mYd3u-003g0R-TR; Fri, 08 Oct 2021 10:44:30 +1100
Date:   Fri, 8 Oct 2021 10:44:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: Performance regression with async inode inactivation
Message-ID: <20211007234430.GH54211@dread.disaster.area>
References: <20211004100653.GD2255@quack2.suse.cz>
 <20211004211508.GB54211@dread.disaster.area>
 <20211005081157.GA24625@quack2.suse.cz>
 <20211005212608.GC54211@dread.disaster.area>
 <20211006181001.GA4182@quack2.suse.cz>
 <20211006215851.GD54211@dread.disaster.area>
 <20211007120357.GD12712@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007120357.GD12712@quack2.suse.cz>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=615f8660
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=7-415B0cAAAA:8
        a=bbVRqeLnWSvzABbziioA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 07, 2021 at 02:03:57PM +0200, Jan Kara wrote:
> On Thu 07-10-21 08:58:51, Dave Chinner wrote:
> > On Wed, Oct 06, 2021 at 08:10:01PM +0200, Jan Kara wrote:
> > Hmmm, I didn't see this at first.  What's the filesystem layout
> > (xfs_info) and the CLI for the test that you ran? How many CPUs was
> > the test run on?
> 
> The machine has 24 cores, each core has 2 SMT siblings, so 48 logical CPUs.
> That's why I've run stress-unlink with 48 processes.
> 
> xfs_info is:
> 
> meta-data=/dev/sdb1              isize=512    agcount=4, agsize=29303104 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=0, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=117212416, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=57232, version=2

OK, default log is ~230MB, fs size is ~400GB?

> > But to point out that this isn't perfect for everything, if I run
> > the same test with 1000 processes on that config, it takes 6.2s,
> > writes 400MB to the log and flushes 153,000 inode clusters. We're
> > back to not having enough log space for the workload. Bumping out to
> > agcount=67 (2x CPU count) and max log size(2GB) results in runtime
> > of 3.5s (largely linear from the 100 process count), no inode
> > writeback and only 200MB of log throughput.
> > 
> > So, yeah, I suspect that if you change the mkfs parameters for the
> > reaim tests to have more AGs and significantly increased log space
> > over the defaults, the regression should disappear...
> > 
> > Can you run these experiments with reaim on your test machines and
> > see if they are influenced by filesystem level concurrency
> > parameters like AG count and log size as these tests suggest?
> 
> Thanks for the detailed analysis and suggestions. So here are some numbers
> from my end. First, note that I've bumped number of unlinks each process
> does from 100 to 1000 so that runtime on the test machine gets above 1s to
> avoid some random noise. The relative slowdown (25%) didn't change (I did
> it already yesterday but sent stress-unlink version without bumped up loop
> count). Exact time to complete of stress-unlink are (from 5 runs):
> 
> (default mkfs params - agcount=4, logsize=223MB)
> 	AVG	STDDEV
> before	2.7952	0.022886
> after		3.4746	0.025303
> 
> I did also runs with increased AG count (to 96) and log size (to 512 MB).
> The results are somewhat surprising:
> 
> (agcount=96, logsize=512MB)
> 	AVG	STDDEV
> before	3.1340	0.044168
> after		3.3612	0.048412

You bumped the log size to 512MB, but then bumped the amount of work
by a factor of 10....

> So the change did somewhat help the case with deferred inactivation however
> it significantly hurt the kernel before deferred inactivation. Overall we
> are still far from original performance. 
> 
> I had a look at xfs stats (full stats are attached for 4 different configs
> - (before / after) * (defaults / high ag count)) and logging stats are
> clearly different:
> 
> defaults-before:
> log 4700 157590 0 48585 71854

Fits in < 75% of log space, so will not be pushing out metadata at
all during the test.

> defaults-after:
> log 10293 536643 6 48007 53762

Overwrites the log 2.5x, so limited by metadata writeback speed for
most of the test.

> highag-before:
> log 5933 233065 0 48000 58240

Yup, workload is spread across 16x more AGs and AG metadata, so I'd
expect to see such an increase in log throuhgput. But with a larger
log, this won't be tail-pushing...

> highag-after:
> log 6789 303249 0 48155 53795

And this is also under the tail-pushing threshold, so really the
only difference in perf here comes from writing more metadata to
the log.

> We can see big differences in the amount of log writes as well as logged
> blocks. defaults-before logged 76 MB, defaults-after logged 262 MB,
> highag-before logged 113 MB, highag-after logged 148 MB. Given data writes
> for this test are 750 MB (16k * 48 processes * 1000 loops), the difference
> of 186 MB of log IO matches well with the observed difference in the amount
> of writes in block traces.
> 
> I'm not sure why the amount of logged blocks differs so much.

fsync() interactions.

On the original code, the two unlink transactions are temporally
adjacent as both are in unlinkat() syscall context.  One is directly
run by the syscall, the other in task_run context at syscall exit
when processing the last reference of the file being dropped.

In general, that means the objects modified (inode cluster, AGI,
inode, etc) are captured by the same CIL context and so aggregate in
memory as a single change (essentially log dedupe). Then the next
fsync() from some other context runs, pushing the CIL to disk and
we only log those objects modified in unlink to the journal once.

With deferred activation, the two phases of unlink are temporally
decoupled. We get a bunch of inodes running the first phase in
unlink() context, but the second phase is run later in a tight loop
from workqueue context. But this means that fsync()s occur between
the two pahses, and hence the objects modified in the two phases of
unlink are modified in two separate CIL contexts. Hence they get
written to the log twice.

Depending on the way things work out, deferred inactivation also
results in longer unlinked inode chains, resulting in more objects
being logged per unlink than without deferred inactivation, as the
inodes are added to the unlink chain and then immediately removed
before any others are added. Hence deferred inode inactivation will
increase the amount written to the log per unlink if the two phases
of unlink as split across journal checkpoints.

IOWs, an increase in log writes for open-write-fsync-close-unlink
workloads is not unexpected. But this workload isn't really a real
world workload in any way - we generally don't do data integrity
writes only to immediately throw the data away. :/

Remove the fsync and we do have a real world workload - temporary
files for compiles, etc. Then everything should mostly get logged
in the same CIL context because all transactions are run
asynchronously and aggregate in memory until the CIL is full and
checkpoints itself. Hence log writes shouldn't change very much at
all for such workloads.

> I didn't find
> big difference between various configs in push_ail stats.  However I did
> find notable differences in various btree stats:
> 
> defaults-before:
> abtb2 99580 228864 15129 15129 0 0 0 0 0 0 0 0 0 0 49616
> abtc2 229903 464130 96526 96526 0 0 0 0 0 0 0 0 0 0 299055
> ibt2 96099 96096 3 3 0 0 0 0 0 0 0 0 0 0 0
> fibt2 96099 96096 3 3 0 0 0 0 0 0 0 0 0 0 0
> 
> defaults-after:
> abtb2 95532 400144 36596 36441 0 0 0 0 0 0 0 0 0 0 1421782
> abtc2 157421 667273 61135 60980 0 0 0 0 0 0 0 0 0 0 1935106
> ibt2 95420 220423 51 34 0 0 0 0 0 0 0 0 0 0 1
> fibt2 131505 230219 7708 7691 0 0 0 0 0 0 0 0 0 0 40470

Yup, the change in the finobt is indicative of slight changes in
order of allocate/free of inodes. We're tracking a more free
inode records because we aren't doing purely sequential inode
allocation and freeing due to AGI contention managing the unlinked
inode chain.

IOWs, we've previously hyper-optimised create-unlink workloads to
aggressively reuse inodes, and that resulted in rapid reuse of
the unlinked inodes. That still happens, but deferred inactivation
increases the pool of free inodes that is being cycled over by this
workload. This reflects the per-ag contention occurring in this
limited fs config - we're getting larger batches of unlinked inodes
being chained on the AGs and so when they are freed we see more
inodes being added to the finobt and then reallocated from there.

I have plans to further decouple the unlinked AGI chain updates
between the two phases of unlink that will help address this, but
that is future work and not ready to go yet.

> highag-before:
> abtb2 120143 240191 24047 24047 0 0 0 0 0 0 0 0 0 0 0
> abtc2 288334 456240 120143 120143 0 0 0 0 0 0 0 0 0 0 24051
> ibt2 96143 96096 47 47 0 0 0 0 0 0 0 0 0 0 0
> fibt2 96143 96096 47 47 0 0 0 0 0 0 0 0 0 0 0
> 
> highag-after:
> abtb2 96903 205361 20137 20117 0 0 0 0 0 0 0 0 0 0 101850
> abtc2 211742 433347 81617 81597 0 0 0 0 0 0 0 0 0 0 274068
> ibt2 96083 96035 48 47 0 0 0 0 0 0 0 0 0 0 0
> fibt2 96083 96035 48 47 0 0 0 0 0 0 0 0 0 0 0

With this, we have no AGI contention to speak of between the two
phases of unlink, so unlinked inode chains remain very short in both
cases and so we don't see any change to finobt residency.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
