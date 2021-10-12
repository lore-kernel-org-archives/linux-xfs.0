Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C83C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 21:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C742E600D3
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 21:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhJLVZq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:25:46 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57516 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233221AbhJLVZp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Oct 2021 17:25:45 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8CD6D58BF7A;
        Wed, 13 Oct 2021 08:23:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1maPFL-005WfB-Ov; Wed, 13 Oct 2021 08:23:39 +1100
Date:   Wed, 13 Oct 2021 08:23:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: Performance regression with async inode inactivation
Message-ID: <20211012212339.GQ2361455@dread.disaster.area>
References: <20211004100653.GD2255@quack2.suse.cz>
 <20211004211508.GB54211@dread.disaster.area>
 <20211005081157.GA24625@quack2.suse.cz>
 <20211005212608.GC54211@dread.disaster.area>
 <20211006181001.GA4182@quack2.suse.cz>
 <20211006215851.GD54211@dread.disaster.area>
 <20211007120357.GD12712@quack2.suse.cz>
 <20211007234430.GH54211@dread.disaster.area>
 <20211012134255.GA19200@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012134255.GA19200@quack2.suse.cz>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6165fcdd
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=i4azn5I5Urys164L3QUA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 03:42:55PM +0200, Jan Kara wrote:
> On Fri 08-10-21 10:44:30, Dave Chinner wrote:
> > On Thu, Oct 07, 2021 at 02:03:57PM +0200, Jan Kara wrote:
> > > On Thu 07-10-21 08:58:51, Dave Chinner wrote:
> > > > On Wed, Oct 06, 2021 at 08:10:01PM +0200, Jan Kara wrote:
> > > > Hmmm, I didn't see this at first.  What's the filesystem layout
> > > > (xfs_info) and the CLI for the test that you ran? How many CPUs was
> > > > the test run on?
> > > 
> > > The machine has 24 cores, each core has 2 SMT siblings, so 48 logical CPUs.
> > > That's why I've run stress-unlink with 48 processes.
> > > 
> > > xfs_info is:
> > > 
> > > meta-data=/dev/sdb1              isize=512    agcount=4, agsize=29303104 blks
> > >          =                       sectsz=512   attr=2, projid32bit=1
> > >          =                       crc=1        finobt=1, sparse=0, rmapbt=0
> > >          =                       reflink=0
> > > data     =                       bsize=4096   blocks=117212416, imaxpct=25
> > >          =                       sunit=0      swidth=0 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > > log      =internal log           bsize=4096   blocks=57232, version=2
> > 
> > OK, default log is ~230MB, fs size is ~400GB?
> 
> Yep.
> 
> <snip log analysis>
> 
> > > We can see big differences in the amount of log writes as well as logged
> > > blocks. defaults-before logged 76 MB, defaults-after logged 262 MB,
> > > highag-before logged 113 MB, highag-after logged 148 MB. Given data writes
> > > for this test are 750 MB (16k * 48 processes * 1000 loops), the difference
> > > of 186 MB of log IO matches well with the observed difference in the amount
> > > of writes in block traces.
> > > 
> > > I'm not sure why the amount of logged blocks differs so much.
> > 
> > fsync() interactions.
> > 
> > On the original code, the two unlink transactions are temporally
> > adjacent as both are in unlinkat() syscall context.  One is directly
> > run by the syscall, the other in task_run context at syscall exit
> > when processing the last reference of the file being dropped.
> > 
> > In general, that means the objects modified (inode cluster, AGI,
> > inode, etc) are captured by the same CIL context and so aggregate in
> > memory as a single change (essentially log dedupe). Then the next
> > fsync() from some other context runs, pushing the CIL to disk and
> > we only log those objects modified in unlink to the journal once.
> > 
> > With deferred activation, the two phases of unlink are temporally
> > decoupled. We get a bunch of inodes running the first phase in
> > unlink() context, but the second phase is run later in a tight loop
> > from workqueue context. But this means that fsync()s occur between
> > the two pahses, and hence the objects modified in the two phases of
> > unlink are modified in two separate CIL contexts. Hence they get
> > written to the log twice.
> > 
> > Depending on the way things work out, deferred inactivation also
> > results in longer unlinked inode chains, resulting in more objects
> > being logged per unlink than without deferred inactivation, as the
> > inodes are added to the unlink chain and then immediately removed
> > before any others are added. Hence deferred inode inactivation will
> > increase the amount written to the log per unlink if the two phases
> > of unlink as split across journal checkpoints.
> > 
> > IOWs, an increase in log writes for open-write-fsync-close-unlink
> > workloads is not unexpected. But this workload isn't really a real
> > world workload in any way - we generally don't do data integrity
> > writes only to immediately throw the data away. :/
> > 
> > Remove the fsync and we do have a real world workload - temporary
> > files for compiles, etc. Then everything should mostly get logged
> > in the same CIL context because all transactions are run
> > asynchronously and aggregate in memory until the CIL is full and
> > checkpoints itself. Hence log writes shouldn't change very much at
> > all for such workloads.
> 
> OK, that makes sense. Thanks for explanation. So to verify your theory,
> I've removed fsync(2) from the test program. So now it is pure create,
> write, unlink workload. Results of "stress-unlink 48 /mnt", now for 5000
> loops of create-unlink to increase runtime (but the workload does barely
> any writes so it should not matter wrt log):
> 
> default mkfs params:
> 	AVG	STDDEV
> before	2.0380	0.1597
> after	2.7356	0.4712
> 
> agcount=96, log size 512M
> 	AVG	STDDEV
> before	1.0610	0.0227
> after	1.2508	0.0218
> 
> So still notable regression with the async inactivation. With default mkfs
> params we'd need more runs to get more reliable results (note the rather
> high standard deviation) but with high AG count results show pretty stable
> 20% regression - so let's have a look at that.
> 
> Looking at xfs stats there are barely any differences between before &
> after - 'after' writes a bit more to the log but it is ~1.5 MB over the
> whole benchmark run, altogether spending some 8ms doing IO so that's not
> it. Generally the workload seems to be CPU / memory bound now (it does
> barely any IO). Perf shows we are heavily contending on some spinlock in
> xfs_cil_commit() - I presume this is a xc_cil_lock.

Yes, and I have patches that fix this. It got reverted a before
release because it exposed a bunch of underlying zero-fay bugs in
the log code, and I haven't had time to run it through the review
cycle again even though it's pretty much unchanged from commits
26-39 in this series:

https://lore.kernel.org/linux-xfs/20210603052240.171998-1-david@fromorbit.com/

The profiles in this patch demonstrate the problem and the fix:

https://lore.kernel.org/linux-xfs/20210603052240.171998-35-david@fromorbit.com/

I did all my perf testing of inode inactivation with the CIL
scalability patches also installed, because deferred inode
inactivation only made contention on the CIL lock worse in my perf
tests. We simply can't evaluate the benefit of a change when the
system is easily driven into catastrophic lock breakdown by user
level operational concurrency.

IOWs, the CIL lock is the global limiting factor for async
transaction commit rates on large CPU count machines, and things
that remove bottlenecks in higher layers often just increase
contention on this lock and drive it into breakdown. That makes perf
go backwards, not forwards, and it's not the fault of the high level
change being made. That doesn't make the high level change wrong, it
just means we need to peel the onion further before the improvements
are fully realised.

> This actually happens
> both before and after, but we seem to spend some more time there with async
> inactivation. Likely this is related to work being done from worker
> threads. Perf stats for comparison:
> 
> before
>          51,135.08 msec cpu-clock                 #   47.894 CPUs utilized          
>              4,699      context-switches          #    0.092 K/sec                  
>                382      cpu-migrations            #    0.007 K/sec                  
>              1,228      page-faults               #    0.024 K/sec                  
>    128,884,972,351      cycles                    #    2.520 GHz                    
>     38,517,767,839      instructions              #    0.30  insn per cycle         
>      8,337,611,468      branches                  #  163.051 M/sec                  
>         39,749,736      branch-misses             #    0.48% of all branches        
>         25,225,109      cache-misses                                                
> 
>        1.067666170 seconds time elapsed
> 
> after
>          65,353.43 msec cpu-clock                 #   47.894 CPUs utilized          
>             43,737      context-switches          #    0.669 K/sec                  
>              1,824      cpu-migrations            #    0.028 K/sec                  
>              1,953      page-faults               #    0.030 K/sec                  
>    155,144,150,867      cycles                    #    2.374 GHz                    
>     45,280,145,337      instructions              #    0.29  insn per cycle         
>     10,027,567,384      branches                  #  153.436 M/sec                  
>         39,554,691      branch-misses             #    0.39% of all branches        
>         30,203,567      cache-misses                                                
> 
>        1.364539400 seconds time elapsed
> 
> So we can see huge increase in context-switches, notable increase in
> cache-misses, decrease in cycles/s so perhaps we are bouncing cache more?
> Anyway I guess this is kind of expected due to the nature of async
> inactivation, I just wanted to highlight that there are regressions without
> fsync in the game as well.

Context switches are largely noise - they are most likely just AGI
locks being bounced a bit more. It's the spinlock contention that is
the likely issue here. For example, on my 32p machine with vanilla
5.15-rc4 with a fsync-less, 5000 iteration test run:

$ sudo perf_5.9 stat ./stress-unlink 32 /mnt/scratch
Processes started.
1.290

 Performance counter stats for './stress-unlink 32 /mnt/scratch':

         16,856.61 msec task-clock                #   12.595 CPUs utilized          
            48,297      context-switches          #    0.003 M/sec                  
             4,219      cpu-migrations            #    0.250 K/sec                  
             1,373      page-faults               #    0.081 K/sec                  
    39,254,798,526      cycles                    #    2.329 GHz                    
    16,460,808,349      instructions              #    0.42  insn per cycle         
     3,475,251,228      branches                  #  206.166 M/sec                  
        12,129,889      branch-misses             #    0.35% of all branches        

       1.338312347 seconds time elapsed

       0.186554000 seconds user
      17.247176000 seconds sys

And with 5.15-rc4 + CIL scalability:

$ sudo perf_5.9 stat ./stress-unlink 32 /mnt/scratch
Processes started.
0.894

 Performance counter stats for './stress-unlink 32 /mnt/scratch':

         12,917.93 msec task-clock                #   13.805 CPUs utilized
            39,680      context-switches          #    0.003 M/sec
             2,737      cpu-migrations            #    0.212 K/sec
             1,402      page-faults               #    0.109 K/sec
    30,920,293,752      cycles                    #    2.394 GHz
    14,472,067,501      instructions              #    0.47  insn per cycle
     2,700,978,247      branches                  #  209.087 M/sec
         9,287,754      branch-misses             #    0.34% of all branches

       0.935710173 seconds time elapsed

       0.192467000 seconds user
      13.245977000 seconds sys

Runtime of the fsync-less, 5,000 iteration version drops from 1.29s
to 0.89s, IPC goes up, branches and branch-misses go down, context
switches only go down slightly, etc. IOWs, when you take away the
CIL lock contention, we get back all that perf loss and then some...

FWIW, let's really hammer it for a long while. Vanilla 5.14-rc4:

$ sudo perf_5.9 stat ./stress-unlink 1000 /mnt/scratch
Processes started.
38.881

 Performance counter stats for './stress-unlink 1000 /mnt/scratch':

        733,741.06 msec task-clock                #   16.004 CPUs utilized          
        13,131,968      context-switches          #    0.018 M/sec                  
         1,302,636      cpu-migrations            #    0.002 M/sec                  
            40,720      page-faults               #    0.055 K/sec                  
 1,195,192,185,398      cycles                    #    1.629 GHz                    
   643,382,890,656      instructions              #    0.54  insn per cycle         
   129,065,409,600      branches                  #  175.900 M/sec                  
       768,146,988      branch-misses             #    0.60% of all branches        

      45.847750477 seconds time elapsed

      11.194020000 seconds user
     758.762376000 seconds sys

And the transaction rate is pinned at 800,000/s for the entire test.
We're running at the limit of the CIL lock here.

With CIL scalbility patchset:

$ sudo perf_5.9 stat ./stress-unlink 1000 /mnt/scratch
Processes started.
28.263

 Performance counter stats for './stress-unlink 1000 /mnt/scratch':

        450,547.80 msec task-clock                #   15.038 CPUs utilized          
         5,949,268      context-switches          #    0.013 M/sec                  
           868,887      cpu-migrations            #    0.002 M/sec                  
            41,570      page-faults               #    0.092 K/sec                  
   836,933,822,425      cycles                    #    1.858 GHz                    
   536,132,522,275      instructions              #    0.64  insn per cycle         
    99,264,579,180      branches                  #  220.320 M/sec                  
       506,921,132      branch-misses             #    0.51% of all branches        

      29.961492616 seconds time elapsed

       7.796758000 seconds user
     471.990545000 seconds sys


30% reduction in runtime because the transaction rate is now
running at 1.1M/s. Improvements in code execution across the board
here, so the problem clearly isn't the deferred inode inactivation.

IOWs, I'm largely not concerned about the high CPU count perf
regressions that we are seeing from log code these days - the fix is
largely ready, it's just lacking in available engineering time to get
it over the line and merged right now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
