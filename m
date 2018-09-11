Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f41.google.com ([209.85.208.41]:34478 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbeIKJIe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Sep 2018 05:08:34 -0400
Received: by mail-ed1-f41.google.com with SMTP id u1-v6so18152620eds.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Sep 2018 21:11:14 -0700 (PDT)
MIME-Version: 1.0
References: <CA+1E3r+crZ6suDtTheOysm_dzZ2FeU=z4R-aQQw7etk1yuxOLQ@mail.gmail.com>
 <20180910235827.GD5631@dastard>
In-Reply-To: <20180910235827.GD5631@dastard>
From: Joshi <joshiiitr@gmail.com>
Date: Tue, 11 Sep 2018 09:40:59 +0530
Message-ID: <CA+1E3r+Lggw9JJymdhoyzkqQfqGETZE=R=WG09s7FOhY3Snb5g@mail.gmail.com>
Subject: Re: Strange behavior with log IO fake-completions
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org

> > Test: iozone, single-thread, 1GiB file, 4K record, sync for each 4K (
> > '-eo' option).
> > Disk: 800GB NVMe disk. XFS based on 4.15, default options except log size = 184M
> > Machine: Intel Xeon E5-2690 @2.6 GHz, 2 NUMA nodes, 24 cpus each
> >
> > And results are :
> > ------------------------------------------------
> > baseline                log fake-completion
> > 109,845                 45,538
> > ------------------------------------------------
> > I wondered why fake-completion turned out to be ~50% slower!
> > May I know if anyone encountered this before, or knows why this can happen?
>
> You made all log IO submission/completion synchronous.
>
> https://marc.info/?l=linux-xfs&m=153532933529663&w=2
>
> > For fake-completion, I just tag all log IOs bufer-pointers (in
> > xlog_sync). And later in xfs_buf_submit, I just complete those tagged
> > log IOs without any real bio-formation (comment call to
> > _xfs_bio_ioapply). Hope this is correct/enough to do nothing!
>
> It'll work, but it's a pretty silly thing to do. See above.

Thank you very much, Dave. I feel things are somewhat different here
than other email-thread you pointed.
Only log IO was fake-completed, not that entire XFS volume was on
ramdisk. Underlying disk was NVMe, and I checked that no
merging/batching happened for log IO submissions in base case.
Completion count were same (as many as submitted) too.
Call that I disabled in base code (in xfs_buf_submit, for log IOs) is
_xfs_buf_ioapply. So only thing happened differently for log IO
submitter thread is that it executed bp-completion-handling-code
(xfs_buf_ioend_async). And that anyway pushes the processing to
worker. It still remains mostly async, I suppose. In original form, it
would have executed extra code to form/sent bio (possibility of
submission/completion merging, but that did not happen for this
workload), and completion would have come after some time say T.
I wondered about impact on XFS if this time T can be made very low by
underlying storage for certain IOs.
If underlying device/layers provide some sort of differentiated I/O
service enabling ultra-low-latency completion for certain IOs (flagged
as urgent), and one chooses log IO to take that low-latency path  -
won't we see same problem as shown by fake-completion?

Thanks,

On Tue, Sep 11, 2018 at 5:28 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Sep 10, 2018 at 11:37:45PM +0530, Joshi wrote:
> > Hi folks,
> > I wanted to check log IO speed impact during fsync-heavy workload.
> > To obtain theoretical maximum performance data, I did fake-completion
> > of all log IOs (i.e. log IO cost is made 0).
> >
> > Test: iozone, single-thread, 1GiB file, 4K record, sync for each 4K (
> > '-eo' option).
> > Disk: 800GB NVMe disk. XFS based on 4.15, default options except log size = 184M
> > Machine: Intel Xeon E5-2690 @2.6 GHz, 2 NUMA nodes, 24 cpus each
> >
> > And results are :
> > ------------------------------------------------
> > baseline                log fake-completion
> > 109,845                 45,538
> > ------------------------------------------------
> > I wondered why fake-completion turned out to be ~50% slower!
> > May I know if anyone encountered this before, or knows why this can happen?
>
> You made all log IO submission/completion synchronous.
>
> https://marc.info/?l=linux-xfs&m=153532933529663&w=2
>
> > For fake-completion, I just tag all log IOs bufer-pointers (in
> > xlog_sync). And later in xfs_buf_submit, I just complete those tagged
> > log IOs without any real bio-formation (comment call to
> > _xfs_bio_ioapply). Hope this is correct/enough to do nothing!
>
> It'll work, but it's a pretty silly thing to do. See above.
>
> > It seems to me that CPU count/frequency is playing a role here.
>
> Unlikely.
>
> > Above data was obtained with CPU frequency set to higher values. In
> > order to keep running CPU at nearly constant high frequency, I tried
> > things such as - performance governor, bios-based performance
> > settings, explicit setting of cpu scaling max frequency etc. However,
> > results did not differ much. Moreover frequency did not remain
> > constant/high.
> >
> > But when I used "affine/bind" option of iozone (-P option), iozone
> > runs on single cpu all the time, and I get to see expected result -
> > -------------------------------------------------------------
> > baseline (affine)         log fake-completion(affine)
> > 125,253                     163,367
> > -------------------------------------------------------------
>
> Yup, because now it forces the work that gets handed off to another
> workqueue (the CIL push workqueue) to also run on the same CPU
> rather than asynchronously on another CPU. The result is that you
> essentially force everything to run in a tight loop on a hot CPU
> cache. Hitting a hot cache can make code run much, much faster in
> microbenchmark situations like this, leading to optimisations that
> don't actually work in the real world where those same code paths
> never run confined to a single pre-primed, hot CPU cache.
>
> When you combine that with the fact that IOZone has a very well
> known susceptibility to CPU cache residency effects, it means the
> results are largely useless for comparison between different kernel
> builds. This is because small code changes can result in
> sufficiently large changes in kernel CPU cache footprint that it
> perturbs IOZone behaviour. We typically see variations of over
> +/-10% from IOZone just by running two kernels that have slightly
> different config parameters.
>
> IOWs, don't use IOZone for anything related to performance testing.
>
> > Also, during above episode, I felt the need to discover best way to
> > eliminate cpu frequency variations out of benchmarking. I'd be
> > thankful knowing about it.
>
> I've never bothered with tuning for affinity or CPU frequency
> scaling when perf testing. If you have to rely on such things to get
> optimal performance from your filesystem algorithms, you are doing
> it wrong.
>
> That is: a CPU running at near full utilisation will always be run
> at maximum frequency, hence if you have to tune CPU frequency to get
> decent performance your algorithm is limited by something that
> prevents full CPU utilisation, not CPU frequency.
>
> Similarly, if you have to use affinity to get decent performance,
> you're optimising for limited system utilisation rather than
> bein able to use all the resources in the machine effectively. The
> first goal of filesystem optimisation is to utilise every resource as
> efficiently as possible. Then people can constraint their workloads
> with affinity, containers, etc however they want without having to
> care about performance - it will never be worse than the performance
> at full resource utilisation.....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Joshi
