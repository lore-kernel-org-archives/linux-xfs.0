Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A940CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 13:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9271760555
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 13:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbhJLNpS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 09:45:18 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:56016 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237167AbhJLNo6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Oct 2021 09:44:58 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 02F41200B0;
        Tue, 12 Oct 2021 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634046176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N05wRye02vJ3NUfIfG+F3FxTOH4rnUb84VawsDpuvN4=;
        b=wmi4VhTeXpcEh9HbOSwf+pLBDo6+GKAqh4/zBD3j4SJ2RwoW64Cgq1gddZd3nocKf3pqVl
        mqB3nmbCG8e+Hm2Ia13oBIBeAfKAR/awuDuoXysF2YNsOfp864RrYlNqVO2BKf1NxhnEmv
        z1HArl6ucjf6Ze5u43cw1GM/bjE3YVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634046176;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N05wRye02vJ3NUfIfG+F3FxTOH4rnUb84VawsDpuvN4=;
        b=vw6SptuDntFELtTCoYUAu1LGSSWRaiJ9gVHqfFwUr0RJmDItrS3kVX1R/V/Zj8uNbNNff8
        bL9O3zLl7X3l6oBw==
Received: from quack2.suse.cz (unknown [10.100.224.230])
        by relay2.suse.de (Postfix) with ESMTP id EAAECA3BC9;
        Tue, 12 Oct 2021 13:42:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D0AD01E0BCB; Tue, 12 Oct 2021 15:42:55 +0200 (CEST)
Date:   Tue, 12 Oct 2021 15:42:55 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: Performance regression with async inode inactivation
Message-ID: <20211012134255.GA19200@quack2.suse.cz>
References: <20211004100653.GD2255@quack2.suse.cz>
 <20211004211508.GB54211@dread.disaster.area>
 <20211005081157.GA24625@quack2.suse.cz>
 <20211005212608.GC54211@dread.disaster.area>
 <20211006181001.GA4182@quack2.suse.cz>
 <20211006215851.GD54211@dread.disaster.area>
 <20211007120357.GD12712@quack2.suse.cz>
 <20211007234430.GH54211@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007234430.GH54211@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri 08-10-21 10:44:30, Dave Chinner wrote:
> On Thu, Oct 07, 2021 at 02:03:57PM +0200, Jan Kara wrote:
> > On Thu 07-10-21 08:58:51, Dave Chinner wrote:
> > > On Wed, Oct 06, 2021 at 08:10:01PM +0200, Jan Kara wrote:
> > > Hmmm, I didn't see this at first.  What's the filesystem layout
> > > (xfs_info) and the CLI for the test that you ran? How many CPUs was
> > > the test run on?
> > 
> > The machine has 24 cores, each core has 2 SMT siblings, so 48 logical CPUs.
> > That's why I've run stress-unlink with 48 processes.
> > 
> > xfs_info is:
> > 
> > meta-data=/dev/sdb1              isize=512    agcount=4, agsize=29303104 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=0, rmapbt=0
> >          =                       reflink=0
> > data     =                       bsize=4096   blocks=117212416, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=57232, version=2
> 
> OK, default log is ~230MB, fs size is ~400GB?

Yep.

<snip log analysis>

> > We can see big differences in the amount of log writes as well as logged
> > blocks. defaults-before logged 76 MB, defaults-after logged 262 MB,
> > highag-before logged 113 MB, highag-after logged 148 MB. Given data writes
> > for this test are 750 MB (16k * 48 processes * 1000 loops), the difference
> > of 186 MB of log IO matches well with the observed difference in the amount
> > of writes in block traces.
> > 
> > I'm not sure why the amount of logged blocks differs so much.
> 
> fsync() interactions.
> 
> On the original code, the two unlink transactions are temporally
> adjacent as both are in unlinkat() syscall context.  One is directly
> run by the syscall, the other in task_run context at syscall exit
> when processing the last reference of the file being dropped.
> 
> In general, that means the objects modified (inode cluster, AGI,
> inode, etc) are captured by the same CIL context and so aggregate in
> memory as a single change (essentially log dedupe). Then the next
> fsync() from some other context runs, pushing the CIL to disk and
> we only log those objects modified in unlink to the journal once.
> 
> With deferred activation, the two phases of unlink are temporally
> decoupled. We get a bunch of inodes running the first phase in
> unlink() context, but the second phase is run later in a tight loop
> from workqueue context. But this means that fsync()s occur between
> the two pahses, and hence the objects modified in the two phases of
> unlink are modified in two separate CIL contexts. Hence they get
> written to the log twice.
> 
> Depending on the way things work out, deferred inactivation also
> results in longer unlinked inode chains, resulting in more objects
> being logged per unlink than without deferred inactivation, as the
> inodes are added to the unlink chain and then immediately removed
> before any others are added. Hence deferred inode inactivation will
> increase the amount written to the log per unlink if the two phases
> of unlink as split across journal checkpoints.
> 
> IOWs, an increase in log writes for open-write-fsync-close-unlink
> workloads is not unexpected. But this workload isn't really a real
> world workload in any way - we generally don't do data integrity
> writes only to immediately throw the data away. :/
> 
> Remove the fsync and we do have a real world workload - temporary
> files for compiles, etc. Then everything should mostly get logged
> in the same CIL context because all transactions are run
> asynchronously and aggregate in memory until the CIL is full and
> checkpoints itself. Hence log writes shouldn't change very much at
> all for such workloads.

OK, that makes sense. Thanks for explanation. So to verify your theory,
I've removed fsync(2) from the test program. So now it is pure create,
write, unlink workload. Results of "stress-unlink 48 /mnt", now for 5000
loops of create-unlink to increase runtime (but the workload does barely
any writes so it should not matter wrt log):

default mkfs params:
	AVG	STDDEV
before	2.0380	0.1597
after	2.7356	0.4712

agcount=96, log size 512M
	AVG	STDDEV
before	1.0610	0.0227
after	1.2508	0.0218

So still notable regression with the async inactivation. With default mkfs
params we'd need more runs to get more reliable results (note the rather
high standard deviation) but with high AG count results show pretty stable
20% regression - so let's have a look at that.

Looking at xfs stats there are barely any differences between before &
after - 'after' writes a bit more to the log but it is ~1.5 MB over the
whole benchmark run, altogether spending some 8ms doing IO so that's not
it. Generally the workload seems to be CPU / memory bound now (it does
barely any IO). Perf shows we are heavily contending on some spinlock in
xfs_cil_commit() - I presume this is a xc_cil_lock. This actually happens
both before and after, but we seem to spend some more time there with async
inactivation. Likely this is related to work being done from worker
threads. Perf stats for comparison:

before
         51,135.08 msec cpu-clock                 #   47.894 CPUs utilized          
             4,699      context-switches          #    0.092 K/sec                  
               382      cpu-migrations            #    0.007 K/sec                  
             1,228      page-faults               #    0.024 K/sec                  
   128,884,972,351      cycles                    #    2.520 GHz                    
    38,517,767,839      instructions              #    0.30  insn per cycle         
     8,337,611,468      branches                  #  163.051 M/sec                  
        39,749,736      branch-misses             #    0.48% of all branches        
        25,225,109      cache-misses                                                

       1.067666170 seconds time elapsed

after
         65,353.43 msec cpu-clock                 #   47.894 CPUs utilized          
            43,737      context-switches          #    0.669 K/sec                  
             1,824      cpu-migrations            #    0.028 K/sec                  
             1,953      page-faults               #    0.030 K/sec                  
   155,144,150,867      cycles                    #    2.374 GHz                    
    45,280,145,337      instructions              #    0.29  insn per cycle         
    10,027,567,384      branches                  #  153.436 M/sec                  
        39,554,691      branch-misses             #    0.39% of all branches        
        30,203,567      cache-misses                                                

       1.364539400 seconds time elapsed

So we can see huge increase in context-switches, notable increase in
cache-misses, decrease in cycles/s so perhaps we are bouncing cache more?
Anyway I guess this is kind of expected due to the nature of async
inactivation, I just wanted to highlight that there are regressions without
fsync in the game as well.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
