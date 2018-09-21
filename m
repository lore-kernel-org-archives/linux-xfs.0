Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41477 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728100AbeIUSnG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Sep 2018 14:43:06 -0400
Received: by mail-ed1-f66.google.com with SMTP id f38-v6so10635484edd.8
        for <linux-xfs@vger.kernel.org>; Fri, 21 Sep 2018 05:54:19 -0700 (PDT)
MIME-Version: 1.0
References: <CA+1E3r+crZ6suDtTheOysm_dzZ2FeU=z4R-aQQw7etk1yuxOLQ@mail.gmail.com>
 <20180910235827.GD5631@dastard> <CA+1E3r+Lggw9JJymdhoyzkqQfqGETZE=R=WG09s7FOhY3Snb5g@mail.gmail.com>
 <20180912004259.GJ5631@dastard> <CA+1E3r+gd57nOv=S0gjrbU8df2qXa67njPP=KK1oPqLmsO5thQ@mail.gmail.com>
 <20180917025601.GE16550@dastard> <20180921002336.GO27618@dastard>
In-Reply-To: <20180921002336.GO27618@dastard>
From: Joshi <joshiiitr@gmail.com>
Date: Fri, 21 Sep 2018 18:24:07 +0530
Message-ID: <CA+1E3rJ5d9ie8z79ph-71P-w1hSiR1Rdz7vAugv0vELF=sb5aA@mail.gmail.com>
Subject: Re: Strange behavior with log IO fake-completions
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org

I added some timing measurement code and obtained data for "dd" sync
requests (dd if=/dev/zero of=/mnt/f1 bs=4k count=1000 oflag=sync).
Let me define these times -
T1= xfs_log_force_lsn time (loosely, this is overall time to complete
one fsync request)
And within xfs_log_foce_lsn , these were added -
T2 = xlog_cil_force_lsn time
T3 = xlog_wait time for ic_force_wait
Last one is this -
T4 =  Time elapsed between issuing wake-up on ic_force_wait (during
completion) and thread waiting on ic_force_wait (dd in this case)
resumed execution
Basically T1 = T2+T3 +some_more, and T3 = T4 + some_more.

Here is the data for 1 dd-sync request (trend remains mostly same for
all requests) -
Base case: T1= 37096,  T2=11070,  T3=19130,  T4=2410
FC case:    T1= 101206, T2=47150, T3=45443,  T4=29483

T4 in fake-completion case seemed particularly odd to me. "dd" took so
much time to resume even after wake up was issued on ic_force_wait!
Looks like fast log completion is making xfs wait queues behave odd.
I changed all log wait queues (ic_force_wait, ic_write_wait, and
xc_commit_wait) into completion variables (despite knowing that it is
also implemented using wait_queue).
And it brought down the value of T4.
Overall numbers with iozone/varmail look like this -

Iozone(48 cpus)
Threads       Base           FC
1                149149.2    151444.5
2                251794.5     255033.1
Varmail (48 cpus)
Threads      Base          FC
1                 61500.9     62396.4
2                 102834.9   103080.1

However, base case numbers also got improved. Earlier base numbers
were comparatively very low with 48 cpus.

Thanks,
On Fri, Sep 21, 2018 at 5:53 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Sep 17, 2018 at 12:56:01PM +1000, Dave Chinner wrote:
> > On Fri, Sep 14, 2018 at 05:21:43PM +0530, Joshi wrote:
> > > > Now, your other "unexpected" result - lets use affinity to confine
> > > > everything to one CPU:
> > > >
> > > > fsync proc              CIL             IO-complete     log
> > > > xfs_log_force_lsn
> > > >   <wait for CIL>
> > > >                         xlog_write()
> > > >                         <queue to log>
> > > >                         wake CIL waiters
> > > >                                                         xlog_iodone()
> > > >                                                         wake iclogbug waiters
> > > > log force done
> > > >
> > > > Note the difference? The log work can't start until the CIL work has
> > > > completed because it's constrained to the same CPU, so it doesn't
> > > > cause any contention with the finalising of the CIL push and waking
> > > > waiters.
> > >
> > > "Log work can't start" part does not sound very good either. It needed
> > > to be done anyway before task waiting for fsync is woken.
> >
> > I'm beginning to think you don't really understand how logging in
> > XFS works.  If you want to improve the logging subsystem, it would
> > be a good idea for you to read and understand this document so you
> > have some idea of how the data that is written to the log gets
> > there and what happens to it after it's in the log.
> >
> > Documentation/filesystems/xfs-delayed-logging-design.txt
>
> It occurred to me yesterday that looking at the journal in a
> different way might help explain how it all works.
>
> Instead of looking at it as an IO engine, think of how an
> out-of-order CPU is designed to be made up of multiple stages in a
> pipeline - each stage does a small piece of work that it passes on
> to the next stage to process. Individual operation progresses serially
> through the pipeline, but, each stage of the pipeline can be
> operating on a different operation. Hence we can have multiple
> operations in flight at once, and the operations can also be run
> out of order as dynamical stage completion scheduling dictates.
> However, from a high level everything appears to complete in order
> because of re-ordering stages put everythign in order once the
> indiivdual operations have been executed.
>
> Similarly, the XFS journalling subsystem is an out of order,
> multi-stage pipeline with a post-IO re-ordering stage to ensure the
> end result is that individual operations always appear to complete
> in order.  Indeed, what ends up on disk in the journal is not in
> order, so one of the things that log recovery does is rebuild the
> state necessarily to reorder operations correctly before replay so
> that, again, it appears like everything occurred in the order that
> the transactions were committed to the journal.
>
> So perhaps looking at it as a multi-stage pipeline might also help
> explain why fake-completion changes the behaviour in unpredictable
> ways. i.e. it basically chops out stages of the pipeline, changing
> the length of the pipeline and the order in which stages of the
> pipleine are executed.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Joshi
