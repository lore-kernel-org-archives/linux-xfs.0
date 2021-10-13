Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920FDC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 09:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A1D660EDF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 09:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbhJMJxo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 05:53:44 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52638 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238945AbhJMJxo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 05:53:44 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5B285201CA;
        Wed, 13 Oct 2021 09:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634118700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oRbO9y4IVv08xUAYCwf8PSf7iV+tEDafxLGCjEVSp14=;
        b=qI7GUEFMGHxbaU9zoAXsUf8r11++eLiJsYzSVkRiXbO24XRdauDH1uNjMjc2s3PsY+oe7f
        0zF0/bc87G0qshmEBDB8Pgg1VXoYezE2fQf6b3pfvzlaSWK/0od4e+iEZ/KgAd7KUFN395
        BsTbvMbG402JtvXKZEYpGJgqkw5g2FA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634118700;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oRbO9y4IVv08xUAYCwf8PSf7iV+tEDafxLGCjEVSp14=;
        b=mm6F/aCmm849gS7xHEOZ69wGJvJQCHeBUgyxC50gleu/n69+Mu++YoRYXFJBrFwwFk7FKd
        95CoB24gZWptftBw==
Received: from quack2.suse.cz (unknown [10.100.224.230])
        by relay2.suse.de (Postfix) with ESMTP id 4DAEEA3B87;
        Wed, 13 Oct 2021 09:51:40 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 2BD251E11B6; Wed, 13 Oct 2021 11:51:39 +0200 (CEST)
Date:   Wed, 13 Oct 2021 11:51:39 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: Performance regression with async inode inactivation
Message-ID: <20211013095139.GC19200@quack2.suse.cz>
References: <20211004100653.GD2255@quack2.suse.cz>
 <20211004211508.GB54211@dread.disaster.area>
 <20211005081157.GA24625@quack2.suse.cz>
 <20211005212608.GC54211@dread.disaster.area>
 <20211006181001.GA4182@quack2.suse.cz>
 <20211006215851.GD54211@dread.disaster.area>
 <20211007120357.GD12712@quack2.suse.cz>
 <20211007234430.GH54211@dread.disaster.area>
 <20211012134255.GA19200@quack2.suse.cz>
 <20211012212339.GQ2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012212339.GQ2361455@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed 13-10-21 08:23:39, Dave Chinner wrote:
> On Tue, Oct 12, 2021 at 03:42:55PM +0200, Jan Kara wrote:
> > On Fri 08-10-21 10:44:30, Dave Chinner wrote:
> > > Remove the fsync and we do have a real world workload - temporary
> > > files for compiles, etc. Then everything should mostly get logged
> > > in the same CIL context because all transactions are run
> > > asynchronously and aggregate in memory until the CIL is full and
> > > checkpoints itself. Hence log writes shouldn't change very much at
> > > all for such workloads.
> > 
> > OK, that makes sense. Thanks for explanation. So to verify your theory,
> > I've removed fsync(2) from the test program. So now it is pure create,
> > write, unlink workload. Results of "stress-unlink 48 /mnt", now for 5000
> > loops of create-unlink to increase runtime (but the workload does barely
> > any writes so it should not matter wrt log):
> > 
> > default mkfs params:
> > 	AVG	STDDEV
> > before	2.0380	0.1597
> > after	2.7356	0.4712
> > 
> > agcount=96, log size 512M
> > 	AVG	STDDEV
> > before	1.0610	0.0227
> > after	1.2508	0.0218
> > 
> > So still notable regression with the async inactivation. With default mkfs
> > params we'd need more runs to get more reliable results (note the rather
> > high standard deviation) but with high AG count results show pretty stable
> > 20% regression - so let's have a look at that.
> > 
> > Looking at xfs stats there are barely any differences between before &
> > after - 'after' writes a bit more to the log but it is ~1.5 MB over the
> > whole benchmark run, altogether spending some 8ms doing IO so that's not
> > it. Generally the workload seems to be CPU / memory bound now (it does
> > barely any IO). Perf shows we are heavily contending on some spinlock in
> > xfs_cil_commit() - I presume this is a xc_cil_lock.
> 
> Yes, and I have patches that fix this. It got reverted a before
> release because it exposed a bunch of underlying zero-fay bugs in
> the log code, and I haven't had time to run it through the review
> cycle again even though it's pretty much unchanged from commits
> 26-39 in this series:
> 
> https://lore.kernel.org/linux-xfs/20210603052240.171998-1-david@fromorbit.com/
> 
> The profiles in this patch demonstrate the problem and the fix:
> 
> https://lore.kernel.org/linux-xfs/20210603052240.171998-35-david@fromorbit.com/
> 
> I did all my perf testing of inode inactivation with the CIL
> scalability patches also installed, because deferred inode
> inactivation only made contention on the CIL lock worse in my perf
> tests. We simply can't evaluate the benefit of a change when the
> system is easily driven into catastrophic lock breakdown by user
> level operational concurrency.
> 
> IOWs, the CIL lock is the global limiting factor for async
> transaction commit rates on large CPU count machines, and things
> that remove bottlenecks in higher layers often just increase
> contention on this lock and drive it into breakdown. That makes perf
> go backwards, not forwards, and it's not the fault of the high level
> change being made. That doesn't make the high level change wrong, it
> just means we need to peel the onion further before the improvements
> are fully realised.

OK, understood.

> > This actually happens
> > both before and after, but we seem to spend some more time there with async
> > inactivation. Likely this is related to work being done from worker
> > threads. Perf stats for comparison:
> > 
> > before
> >          51,135.08 msec cpu-clock                 #   47.894 CPUs utilized          
> >              4,699      context-switches          #    0.092 K/sec                  
> >                382      cpu-migrations            #    0.007 K/sec                  
> >              1,228      page-faults               #    0.024 K/sec                  
> >    128,884,972,351      cycles                    #    2.520 GHz                    
> >     38,517,767,839      instructions              #    0.30  insn per cycle         
> >      8,337,611,468      branches                  #  163.051 M/sec                  
> >         39,749,736      branch-misses             #    0.48% of all branches        
> >         25,225,109      cache-misses                                                
> > 
> >        1.067666170 seconds time elapsed
> > 
> > after
> >          65,353.43 msec cpu-clock                 #   47.894 CPUs utilized          
> >             43,737      context-switches          #    0.669 K/sec                  
> >              1,824      cpu-migrations            #    0.028 K/sec                  
> >              1,953      page-faults               #    0.030 K/sec                  
> >    155,144,150,867      cycles                    #    2.374 GHz                    
> >     45,280,145,337      instructions              #    0.29  insn per cycle         
> >     10,027,567,384      branches                  #  153.436 M/sec                  
> >         39,554,691      branch-misses             #    0.39% of all branches        
> >         30,203,567      cache-misses                                                
> > 
> >        1.364539400 seconds time elapsed
> > 
> > So we can see huge increase in context-switches, notable increase in
> > cache-misses, decrease in cycles/s so perhaps we are bouncing cache more?
> > Anyway I guess this is kind of expected due to the nature of async
> > inactivation, I just wanted to highlight that there are regressions without
> > fsync in the game as well.
> 
> Context switches are largely noise - they are most likely just AGI
> locks being bounced a bit more. It's the spinlock contention that is
> the likely issue here. For example, on my 32p machine with vanilla
> 5.15-rc4 with a fsync-less, 5000 iteration test run:
> 
> $ sudo perf_5.9 stat ./stress-unlink 32 /mnt/scratch
> Processes started.
> 1.290
> 
>  Performance counter stats for './stress-unlink 32 /mnt/scratch':
> 
>          16,856.61 msec task-clock                #   12.595 CPUs utilized          
>             48,297      context-switches          #    0.003 M/sec                  
>              4,219      cpu-migrations            #    0.250 K/sec                  
>              1,373      page-faults               #    0.081 K/sec                  
>     39,254,798,526      cycles                    #    2.329 GHz                    
>     16,460,808,349      instructions              #    0.42  insn per cycle         
>      3,475,251,228      branches                  #  206.166 M/sec                  
>         12,129,889      branch-misses             #    0.35% of all branches        
> 
>        1.338312347 seconds time elapsed
> 
>        0.186554000 seconds user
>       17.247176000 seconds sys
> 
> And with 5.15-rc4 + CIL scalability:
> 
> $ sudo perf_5.9 stat ./stress-unlink 32 /mnt/scratch
> Processes started.
> 0.894
> 
>  Performance counter stats for './stress-unlink 32 /mnt/scratch':
> 
>          12,917.93 msec task-clock                #   13.805 CPUs utilized
>             39,680      context-switches          #    0.003 M/sec
>              2,737      cpu-migrations            #    0.212 K/sec
>              1,402      page-faults               #    0.109 K/sec
>     30,920,293,752      cycles                    #    2.394 GHz
>     14,472,067,501      instructions              #    0.47  insn per cycle
>      2,700,978,247      branches                  #  209.087 M/sec
>          9,287,754      branch-misses             #    0.34% of all branches
> 
>        0.935710173 seconds time elapsed
> 
>        0.192467000 seconds user
>       13.245977000 seconds sys
> 
> Runtime of the fsync-less, 5,000 iteration version drops from 1.29s
> to 0.89s, IPC goes up, branches and branch-misses go down, context
> switches only go down slightly, etc. IOWs, when you take away the
> CIL lock contention, we get back all that perf loss and then some...

Nice results!

> FWIW, let's really hammer it for a long while. Vanilla 5.14-rc4:
> 
> $ sudo perf_5.9 stat ./stress-unlink 1000 /mnt/scratch
> Processes started.
> 38.881
> 
>  Performance counter stats for './stress-unlink 1000 /mnt/scratch':
> 
>         733,741.06 msec task-clock                #   16.004 CPUs utilized          
>         13,131,968      context-switches          #    0.018 M/sec                  
>          1,302,636      cpu-migrations            #    0.002 M/sec                  
>             40,720      page-faults               #    0.055 K/sec                  
>  1,195,192,185,398      cycles                    #    1.629 GHz                    
>    643,382,890,656      instructions              #    0.54  insn per cycle         
>    129,065,409,600      branches                  #  175.900 M/sec                  
>        768,146,988      branch-misses             #    0.60% of all branches        
> 
>       45.847750477 seconds time elapsed
> 
>       11.194020000 seconds user
>      758.762376000 seconds sys
> 
> And the transaction rate is pinned at 800,000/s for the entire test.
> We're running at the limit of the CIL lock here.
> 
> With CIL scalbility patchset:
> 
> $ sudo perf_5.9 stat ./stress-unlink 1000 /mnt/scratch
> Processes started.
> 28.263
> 
>  Performance counter stats for './stress-unlink 1000 /mnt/scratch':
> 
>         450,547.80 msec task-clock                #   15.038 CPUs utilized          
>          5,949,268      context-switches          #    0.013 M/sec                  
>            868,887      cpu-migrations            #    0.002 M/sec                  
>             41,570      page-faults               #    0.092 K/sec                  
>    836,933,822,425      cycles                    #    1.858 GHz                    
>    536,132,522,275      instructions              #    0.64  insn per cycle         
>     99,264,579,180      branches                  #  220.320 M/sec                  
>        506,921,132      branch-misses             #    0.51% of all branches        
> 
>       29.961492616 seconds time elapsed
> 
>        7.796758000 seconds user
>      471.990545000 seconds sys
> 
> 
> 30% reduction in runtime because the transaction rate is now
> running at 1.1M/s. Improvements in code execution across the board
> here, so the problem clearly isn't the deferred inode inactivation.
> 
> IOWs, I'm largely not concerned about the high CPU count perf
> regressions that we are seeing from log code these days - the fix is
> largely ready, it's just lacking in available engineering time to get
> it over the line and merged right now...

OK, thanks for explanation!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
