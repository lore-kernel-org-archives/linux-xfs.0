Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C71D97CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 21:43:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A3CB304051
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 19:43:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Tv5045Ffw15Ab7vf for <xfs@oss.sgi.com>;
	Mon, 03 Jun 2013 19:43:33 -0700 (PDT)
Date: Tue, 4 Jun 2013 12:43:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Debunking myths about metadata CRC overhead
Message-ID: <20130604024329.GA29466@dastard>
References: <20130603074452.GZ29466@dastard>
 <20130603200052.GB863@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130603200052.GB863@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 03, 2013 at 03:00:53PM -0500, Geoffrey Wehrman wrote:
> On Mon, Jun 03, 2013 at 05:44:52PM +1000, Dave Chinner wrote:
> | Hi folks,
> | 
> | There has been some assertions made recently that metadata CRCs have
> | too much overhead to always be enabled.  So I'll run some quick
> | benchmarks to demonstrate the "too much overhead" assertions are
> | completely unfounded.
> 
> Thank you, much appreciated.
> 
> | fs_mark workload
> | ----------------
> ...
> | So the lock contention is variable - it's twice as high in this
> | short sample as the overall profile I measured above. It's also
> | pretty much all VFS cache LRU lock contention that is causing the
> | problems here. IOWs, the slowdowns are not related to the overhead
> | of CRC calculations; it's the change in memory access patterns that
> | are lowering the threshold of catastrophic lock contention that is
> | causing it. This VFS LRU problem is being fixed independently by the
> | generic numa-aware LRU list patchset I've been doing with Glauber
> | Costa.
> | 
> | Therefore, it is clear that the slowdown in this phase is not caused
> | by the overhead of CRCs, but that of lock contention elsewhere in
> | the kernel.  The unlink profiles show the same the thing as the walk
> | profiles - additional lock contention on the lookup phase of the
> | unlink walk.
> 
> I get it that the slowdown is not caused by the numerical operations to
> calculate the CRCs, but as a overall feature, I don't see how you can
> say that CRCs are not responsible for the slowdown.

I can trigger the VFS lock contention in a similar manner by running
a userspace application that memcpy()s a 128MB buffer repeatedly.
It's simply a case of increased memory bus traffic causing cacheline
bouncing that the lock contention causes to spiral out of control.

> If CRCs are
> introducing lock contention, it doesn't matter if that lock contention
> is in XFS code or elsewhere in the kernel, it is still a slowdown which
> can be attributed to the CRC feature.  Spin it as you like, it still
> appears to me that there's a huge impact on the walk and unlink phases
> from CRC calculations.

So by that logic, userspace memcpy() causes lock contention in the
VFS, and so therefore the problem is the userspace application, not
the kernel code. And the solution is not to run that userspace code.

Three words: Root Cause Analysis.

We've known about the VFS lock contention problem a lot longer than
we've had the CRC code has been running.  In case you hadn't been
keeping up with this stuff, here's a quick summary of the work I've
been doing with Glauber:

http://lwn.net/Articles/550463/
http://lwn.net/Articles/548092/

So, while CRCs might be a trigger that makes the system fall off the
cliff it is on the edge of, it is most certainly not a CRC problem,
it is not a problem we can solve by changing the CRC code and it is
not a problem we can solve by turning off CRCs.  IOWs, CRCs are not
the root cause of the degradation in performance.

> | ----
> | 
> | Dbench:
> ...
> | Well, now that's an interesting result, isn't it. CRC enabled
> | filesystems are 10% faster than non-crc filesystems. Again, let's
> | not take that number at face value, but ask ourselves why adding
> | CRCs improves performance (a.k.a. "know your benchmark")...
> | 
> | It's pretty obvious why - dbench uses xattrs and performance is
> | sensitive to how many attributes can be stored inline in the inode.
> | And CRCs increase the inode size to 512 bytes meaning attributes are
> | probably never out of line. So, let's make it an even playing field
> | and compare:
> 
> CRC filesystems default to 512 byte inodes?  I wasn't aware of that.

That's been the plan of record since 2008 as the increase in the size
of the inode code reduces 256 byte inodes to less literal area space
than attr=1 configurations.

> Sure, CRC filesystems are able to move more volume, but the metadata is
> half the density as it was before.  I'm not a dbench expert, so I have
> no idea what the ratio of metadata to data is here, so I really don't
> know what conclusions to draw from the dbench results.

So perhaps you should trust someone who is an expert to analyse the
results for you? :)

FYI, dbench is log IO bound, not metadata or data IO bound.
Performance drops with out-of-line attributes because attribute
block IO steals IOPS from the log IO and hence processes block for
longer in fsync and that lowers throughput and increases measured
latency. IOWs, the performance differential that inode sizes give
is all due to less IO being needed for attribute manipulations.


> What really bothers me is the default of 512 byte inodes for CRCs.  That
> means my inodes take up twice as much space on disk, and will require
> 2X the bandwidth to read from disk.

Metadata read IO is latency bound, not bandwidth bound.  The
increase in metadata IO bandwidth doesn't make any measurable
difference on a typical modern storage system.

> This will have significant impact
> on SGI's DMF managed filesystems.

You're concerned about bulkstat performance, then? Bulkstat will CRC
every inode it reads, so the increase in inode size is the least of
your worries....

But bulkstat scalability is an unrelated issue to the CRC work,
especially as bulkstat already needs application provided
parallelism to scale effectively.

> I know you don't care about SGI's
> DMF, but this will also have a significant performance impact on
> xfsdump, xfsrestore, and xfs_repair.  These performance benchmarks are
> just as important to me as dbench and compilebench.

Sure. But the changes for SDM (self describing metadata) are not
introducing any new performance problems we don't already have. I'm
perfectly OK with that, and it's pretty clear that correcting any
such issues are not related to the implementation of SDM.

> | Compilebench
> | 
> | Testing the same filesystems with 512 byte inodes as for dbench:
> | 
> | $ ./compilebench -D /mnt/scratch
> | using working directory /mnt/scratch, 30 intial dirs 100 runs
> | .....
> | 
> | test				no CRCs		CRCs
> | 			runs	avg		avg
> | ==========================================================================
> | intial create		30	92.12 MB/s	90.24 MB/s
> | create			14	61.91 MB/s	61.13 MB/s
> | patch			15	41.04 MB/s	38.00 MB/s
> | compile			14	278.74 MB/s	262.00 MB/s
> | clean			10	1355.30 MB/s	1296.17 MB/s
> | read tree		11	25.68 MB/s	25.40 MB/s
> | read compiled tree	4	48.74 MB/s	48.65 MB/s
> | delete tree		10	2.97 seconds	3.05 seconds
> | delete compiled tree	4	2.96 seconds	3.05 seconds
> | stat tree		11	1.33 seconds	1.36 seconds
> | stat compiled tree	7	1.86 seconds	1.64 seconds
> | 
> | The numbers are so close that the differences are in the noise, and
> | the CRC overhead doesn't even show up in the ">1% usage" section
> | of the profile output.
> 
> What really surprises me in these results is the hit that the compile
> phase takes.  That is a 6% performance drop in an area where I expect
> the CRCs to have limited effect.  To me, the results show a rather
> consistent performance drop of up to 6%, and is sufficient to support my
> assertion that the CRCs overhead may outweigh the benefits.

You're making an assumption that 6% is actually meaningful. It's
not.  Here's the raw numbers for that phase throughout the
benchmark:

compile dir kernel-7 691MB in 1.98 seconds (349.29 MB/s)
compile dir kernel-14 680MB in 2.67 seconds (254.92 MB/s)
compile dir kernel-2 680MB in 1.81 seconds (376.04 MB/s)
compile dir kernel-2 691MB in 1.94 seconds (356.49 MB/s)
compile dir kernel-7 691MB in 2.16 seconds (320.18 MB/s)
compile dir kernel-2 691MB in 1.97 seconds (351.06 MB/s)
compile dir kernel-26 680MB in 3.13 seconds (217.46 MB/s)
compile dir kernel-14 691MB in 3.03 seconds (228.25 MB/s)
compile dir kernel-70151 691MB in 3.38 seconds (204.61 MB/s)
compile dir kernel-27 691MB in 4.14 seconds (167.05 MB/s)
compile dir kernel-18 680MB in 2.72 seconds (250.23 MB/s)
compile dir kernel-2 691MB in 2.25 seconds (307.38 MB/s)
compile dir kernel-17 680MB in 2.83 seconds (240.51 MB/s)

So, to summaries the numbers for the compile phase we have:

	min:	167.05 MB/s
	max:	376.04 MB/s
	avg:	262.00 MB/s
	stddev: 65 MB/s (25%!)

So, that difference of 16MB/s from run to run is well within the
standard deviation of the results of that phase. I just did another
run on a CRC enabled filesystem:

compile total runs 14 avg 291.30 MB/s (user 0.13s sys 0.77s)

Which is still within a single stddev of the above number and hence
is not significant. IOWs, there's a lot of variability within any
specific phase from run to run in this benchmark and for this phase
a 6% difference is well within the noise.

Like I said - I use benchmarks that I understand. If I say that the
differences are "in the noise" I really do mean that they are "in
the noise". I don't play games with numbers - benchmarketing is one
of my pet peeves and it's something I do not do out of principle.

> Do I want to take a 5% performance hit in filesystem performance
> and double the size of my inodes for an unproved feature?  I am
> still unconvinced that CRCs are a feature that I want to use.
> Others may see enough benefit in CRCs to accept the performance
> hit.  All I want is to ensure that I the option going forward to
> chose not to use CRCs without sacrificing other features
> introduced XFS.

If you don't want to take the performance hit of SDM, the don't use
it. You have that choice right now - either choose performance (v4
superblocks) or reliability (v5 superblocks) at mkfs time.

If new features are introduced that you want that are dependent on
v5 superblocks and you want to stick with v4 superblocks for
performance reasons, then you have to make a hard choice unless you
address your concerns about v5 superblocks. Indeed, none of the
performance issues you've mentioned are unsolvable problems - you
just have to identify them and fix them before your customers need
v5 superblocks.

IOWs, you need to quantify the specific performance degradations you
are concerned about and help fix them. We may have different
priorities and goals, but that doesn't stop us from both being able
to help each reach our goals. But any such discussion about
performance and problem areas needs to be based on quantified
information, not handwaving.

Geoffrey, can you start by identifying and quantifying two things on
current top-of-tree kernels?

	1. exactly where the problems with larger inodes are (on v4
	   superblocks)
	2. workloads you care about where SDM significantly impacts
	   performance (i.e. v4 vs v5 superblocks)

We can discuss each case you raise on their merits and determine
whether they need to be addressed and, if so, how to address them.
But we need quantified data to make any progress here.

In the mean time, you can just use v4 superblocks like you currently
do, but when the time comes to switch to v5 superblocks we will have
corrected the identified problems and performance will not be an
issue that you need to be concerned about.

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
