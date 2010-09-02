Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o82BSkYR201684 for <xfs@oss.sgi.com>; Thu, 2 Sep 2010 06:28:46 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88CE8D7A0F3
	for <xfs@oss.sgi.com>; Thu,  2 Sep 2010 04:40:03 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	k17jxtQy72paW2lE for <xfs@oss.sgi.com>;
	Thu, 02 Sep 2010 04:40:03 -0700 (PDT)
Date: Thu, 2 Sep 2010 21:29:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
Message-ID: <20100902112920.GZ705@dastard>
References: <201009010130.41500@zmi.at> <20100901000631.GO705@dastard>
	<201009010222.57350@zmi.at> <20100901031954.GP705@dastard>
	<4C7DD99F.7000401@hardwarefreak.com> <20100901064439.GR705@dastard>
	<4C7F3823.1040404@hardwarefreak.com> <20100902070108.GY705@dastard>
	<4C7F6357.7010007@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C7F6357.7010007@hardwarefreak.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 02, 2010 at 03:41:59AM -0500, Stan Hoeppner wrote:
> Dave Chinner put forth on 9/2/2010 2:01 AM:
> 
> > No, that's definitely not the case. A different kernel in the 
> > same 8p VM, 12x2TB SAS storage, w/ 4 threads, mount options "logbsize=262144"
> > 
> > FSUse%        Count         Size    Files/sec     App Overhead
> >      0       800000            0      39554.2          7590355
> > 
> > 4 threads with mount options "logbsize=262144,delaylog"
> > 
> > FSUse%        Count         Size    Files/sec     App Overhead
> >      0       800000            0      67269.7          5697246
> 
> What happens when you bump each of these to 8 threads, 1 per core?  If

FSUse%        Count         Size    Files/sec     App Overhead
     0      1600000            0     127979.3         13156823

So, 1 thread does 19k files/s, 2 thread does 37k files/s, 4 gets
67k, and 8 gets 128k. I'd say that's almost linear scaling and CPU
bound at each load point ;)

> the test consumes all cpus/cores, what instrumentation are you viewing
> that tells you the cpu utilization _isn't_ due to memory b/w starvation?

1) profiling like 'perf top' or oprofile, using hardware counters to
profile on cpu cycles, l1/l2 cache misses, etc

2) the delayed logging code uses significantly more memory bandwidth
than the original code because it copies changed information twice
(instead of once) before it is written to disk. Given that single
threaded performance of delayed logging is identical to the original
code and scalability from 1 to 8 cores is almost linear, it cannot
be memory bandwidth bound....

The code might be memory _latency_ bound (i.e on cache misses), but
it is certainly not stressing pure memory bandwidth.

> A modern 64 bit 2 GHz core from AMD or Intel has an L1 instruction issue
> rate of 8 bytes/cycle * 2,000 MHz = 16,000 MB/s = 16 GB/s per core.  An
> 8 core machine would therefore have an instruction issue rate of 8 * 16
> GB/s = 128 GB/s.  A modern dual socket system is going to top out at
> 24-48 GB/s, well short of the instruction issue rate.  Now, this doesn't
> even take the b/w of data load/store operations into account, but I'm
> guessing the data size per directory operation is smaller than the total
> instruction sequence, which operates on the same variable(s).
> 
> So, if the CPUs are pegging, and we're not running out of memory b/w,
> then this would lead me to believe that the hot kernel code, core
> fs_mark code and the filesystem data are fully, or near fully, contained
> in level 2 and 3 CPU caches.  Is this correct, more or less?

Probably.

However (and it is a big however!), I generally don't care to
analyse performance at this level because it's getting into
micro-optimisation territory. Sure, it will get you a few percent
here and there, but then you lose focus on improving the algorithms.
An algorithmic change can provide an order of magnitude improvement,
not a few percent. The delayed logging code is a clear example of
that.

Another example - perf top shows this on the above 8p load on
a plain 2.6.36-rc3 kernel (and it gets about 40k files/s):

           426043.00 27.4% _xfs_buf_find
            87491.00  5.6% __ticket_spin_lock
            67204.00  4.3% xfs_dir2_node_addname
            60434.00  3.9% dso__find_symbol
            48407.00  3.1% kmem_cache_alloc
            37006.00  2.4% __d_lookup
            31625.00  2.0% xfs_trans_buf_item_match
            20036.00  1.3% xfs_log_commit_cil
            18728.00  1.2% _raw_spin_unlock_irqrestore
            18428.00  1.2% __memset
            18001.00  1.2% __memcpy
            17781.00  1.1% xfs_da_do_buf
            17732.00  1.1% xfs_iflush_cluster
            16831.00  1.1% kmem_cache_free
            14836.00  1.0% __kmalloc

It is clear that buffer lookup is consuming the most CPU of any
operation. Why? Because the buffer hash table is too small. I've
already posted patches for a short term solution (increase the size
of the hash table) and the above 127k files/s result is using that
patch. hence it is clear that the micro-optimisation works, but at
the cost of 16x increase in memory usage for the hash table. And
that still isn't really large enough, because now the load is
already pushing the limits of the enlarged hash table.

As Christoph has already suggested, the correct way to fix the
problem is to change the caching algorithm to something that is
self-scaling (e.g. a rb-tree or a btree). That will keep memory
usage low on small filesystems, yet scale efficiently to large
numbers of buffers, something a hash cannot easily do.

IOWs, an algorithmic change will solve the problem far better for
more situations than the micro-optimisation of tweaking the hash
sizes. Reduced to the simplest argument, scalability is all
about choosing the right algorithm so you don't have to care about
minute details to obtain the performance you require.

> I'll have to dig around.  I've never even looked for the archives for
> this list.  It's hopefully mirrored in the usual places.
> 
> Out of curiosity, have you ever run into memory b/w starvation before
> peaking all CPUs while running this test? 

No. Last time I ran out of bandwidth doing an IO workloads was doing
6-7GB/s of buffered writes to disk on a 24p ia64 Altix. The disk
subsystem could handle 11GB/s, we got 10GB/s with direct IO, but
buffered IO was limited by the cross-sectional memory bandwidth of
the machine (25GB/s) because of the extra copy buffered IO
requires....

> I could see that maybe
> occurring with dual 1GHz+ P3 class systems with their smallish caches
> and lowly single channel PC100, back before the switch to DDR memory,
> but those machines were probably gone before XFS was open sourced, IIRC,
> so you may not have had the pleasure (if you could call it that).

The ratio between CPU cycles and memory bandwidth really hasn't
changed much since then. The CPUs weren't powerful enough then,
either, to run enough metadata ops to get near memory bandwidth
limits...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
