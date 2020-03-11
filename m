Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1D9C0044D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 23:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E7132074B
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 23:11:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngKOb1PD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgCKXLj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 19:11:39 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45727 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCKXLj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 19:11:39 -0400
Received: by mail-ot1-f66.google.com with SMTP id f21so4017641otp.12
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 16:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NHL2OSQiVzaHEiMQ5e4sp6PJSyHFnYwZ+Fyr8tL53Fc=;
        b=ngKOb1PDIsOu51/kj/9SINcXc75je9Ogsybl2j0Dgt2sfIt4A94OLPff/dNO5jb9fd
         twGPRoSYWJ07Nh2g9kTD+GIN2HghTxY9vhWIUndO7C7IJZLyi+clVblv/ZFOt4txERAT
         fuCGRnhLczvGFnbJMDteu2JdfLKGKLIw7c9JY91YArhHdqp8BvSiBkdrS50b4XEvQPWw
         IgE84fkEVfgg7hf2Akw2y8Clm8ZOguqhWn8yZsXahnP6XuCRRuPc59n8yHmizFW3p6g2
         uyTzHTtWSWFcHPzkLYfIG8z9NLAwy9zFdV8PYoTcu5++9U4O1RSkFvhSL9geXWVl6Kcf
         iGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NHL2OSQiVzaHEiMQ5e4sp6PJSyHFnYwZ+Fyr8tL53Fc=;
        b=lfXAGiHFet+fVo+MW6Iq6mkqB9oCvhZasqmc4teQ6PsmUgnKZYDbMTxuYfRi14zUci
         2SwtxWB++PzRu9w9q11Bi//4ax/1igQGm0Pf8QqhQiWigRSx6aZyWttdYe56qGPmP/zI
         aFirAEygwpLLxc29mLUSyDHaSsB9wifBbvzgTsSIPwCBlebKfJpB3DWiyv2y7dl4GP3d
         qSIWnPZzpW+mxVfa9ZveKMav01M+G97Bnt4q1IxNZMLYGBn+XaHc1r+9Rbjoc3x0macY
         11JMHRMfQndrh/yF0JVZ3rVsRHnF4pU2LSW8knCJn+WeotW5pYdRnjYwOM33Fw6Cu3vd
         5c9w==
X-Gm-Message-State: ANhLgQ2+BMgdmz7KIegO/dzIpVOsedMJDyXMLivir9RWSxYwEViw7QUU
        bIGy711QwYFeAi8N81Ohs3K+WpWol5gJxxANA4UAQF2SJgM=
X-Google-Smtp-Source: ADFU+vuey8ZVdGLG2/vXiqsub2xi0JeETmqoOV8dcQqsyhJ7Bl6rwK1Uha6XAJ+1wkaVOGq1HcVb7diBIMuCoBG8t6w=
X-Received: by 2002:a9d:77c3:: with SMTP id w3mr3914746otl.245.1583968297890;
 Wed, 11 Mar 2020 16:11:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAHgh4_+15tc6ekqBRHqZrdDmVSfUmMpOGyg_9kWYQ7XOs7D+eQ@mail.gmail.com>
 <CAHgh4_+p0okyt3kC=6HOZb6dr8o3dxqQARoFB-LkR9x-tGuvSA@mail.gmail.com>
 <20200308222646.GL10776@dread.disaster.area> <CAHgh4_K_01dS2Z-2QwR2dc5ZDz9J2+tG6W-paOeneUa6G_h9Kw@mail.gmail.com>
In-Reply-To: <CAHgh4_K_01dS2Z-2QwR2dc5ZDz9J2+tG6W-paOeneUa6G_h9Kw@mail.gmail.com>
From:   Bart Brashers <bart.brashers@gmail.com>
Date:   Wed, 11 Mar 2020 16:11:27 -0700
Message-ID: <CAHgh4_KpizhD+V59+nV_Tr1W5i4N+yeSKQL9Sq6E5BwyWyr_aA@mail.gmail.com>
Subject: Re: mount before xfs_repair hangs
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After working fine for 2 days, it happened again. Drives went offline
for no apparent reason, and a logicaldevice (as arcconf calls them)
failed. arcconf listed the hard drives as all online by the time I had
logged on.

The server connected to the JBOD had rebooted by the time I noticed the problem.

There are two xfs filesystems on this server. I can mount one of them,
and ran xfs_repair on it.

I first tried mounting the other read-only,no-recovery. That worked.
Trying to mount normally hangs. I see in ps aux | grep mount that it's
not using CPU. Here's the mount command I gave:

mount -t xfs -o inode64,logdev=/dev/md/nvme2 /dev/volgrp4TB/lvol4TB
/export/lvol4TB/

I did an echo w > /proc/sysrc-trigger while I was watching the
console, it said "SysRq : Show Blocked State". Here's what the output
of dmesg looks like, starting with that line. Then it gives blocks
about what's happening on each CPU, some of which mention "xfs".

[  228.927915] SysRq : Show Blocked State
[  228.928525]   task                        PC stack   pid father
[  228.928605] mount           D ffff96f79a553150     0 11341  11254 0x00000080
[  228.928609] Call Trace:
[  228.928617]  [<ffffffffb0b7f1c9>] schedule+0x29/0x70
[  228.928624]  [<ffffffffb0b7cb51>] schedule_timeout+0x221/0x2d0
[  228.928626]  [<ffffffffb0b7f57d>] wait_for_completion+0xfd/0x140
[  228.928633]  [<ffffffffb04da0b0>] ? wake_up_state+0x20/0x20
[  228.928667]  [<ffffffffc04c599e>] ? xfs_buf_delwri_submit+0x5e/0xf0 [xfs]
[  228.928682]  [<ffffffffc04c3217>] xfs_buf_iowait+0x27/0xb0 [xfs]
[  228.928696]  [<ffffffffc04c599e>] xfs_buf_delwri_submit+0x5e/0xf0 [xfs]
[  228.928712]  [<ffffffffc04f2a9e>] xlog_do_recovery_pass+0x3ae/0x6e0 [xfs]
[  228.928727]  [<ffffffffc04f2e59>] xlog_do_log_recovery+0x89/0xd0 [xfs]
[  228.928742]  [<ffffffffc04f2ed1>] xlog_do_recover+0x31/0x180 [xfs]
[  228.928758]  [<ffffffffc04f3fef>] xlog_recover+0xbf/0x190 [xfs]
[  228.928772]  [<ffffffffc04e658f>] xfs_log_mount+0xff/0x310 [xfs]
[  228.928801]  [<ffffffffc04dd1b0>] xfs_mountfs+0x520/0x8e0 [xfs]
[  228.928814]  [<ffffffffc04e02a0>] xfs_fs_fill_super+0x410/0x550 [xfs]
[  228.928818]  [<ffffffffb064c893>] mount_bdev+0x1b3/0x1f0
[  228.928831]  [<ffffffffc04dfe90>] ?
xfs_test_remount_options.isra.12+0x70/0x70 [xfs]
[  228.928842]  [<ffffffffc04deaa5>] xfs_fs_mount+0x15/0x20 [xfs]
[  228.928845]  [<ffffffffb064d1fe>] mount_fs+0x3e/0x1b0
[  228.928850]  [<ffffffffb066b377>] vfs_kern_mount+0x67/0x110
[  228.928852]  [<ffffffffb066dacf>] do_mount+0x1ef/0xce0
[  228.928855]  [<ffffffffb064521a>] ? __check_object_size+0x1ca/0x250
[  228.928858]  [<ffffffffb062368c>] ? kmem_cache_alloc_trace+0x3c/0x200
[  228.928860]  [<ffffffffb066e903>] SyS_mount+0x83/0xd0
[  228.928863]  [<ffffffffb0b8bede>] system_call_fastpath+0x25/0x2a
[  228.928884] Sched Debug Version: v0.11, 3.10.0-1062.el7.x86_64 #1
[  228.928886] ktime                                   : 228605.351961
[  228.928887] sched_clk                               : 228928.883526
[  228.928888] cpu_clk                                 : 228928.883743
[  228.928889] jiffies                                 : 4294895902
[  228.928891] sched_clock_stable()                    : 1

[  228.928893] sysctl_sched
[  228.928894]   .sysctl_sched_latency                    : 24.000000
[  228.928896]   .sysctl_sched_min_granularity            : 10.000000
[  228.928897]   .sysctl_sched_wakeup_granularity         : 15.000000
[  228.928898]   .sysctl_sched_child_runs_first           : 0
[  228.928899]   .sysctl_sched_features                   : 56955
[  228.928900]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)

Every 120 seconds, it adds to dmesg:

[  241.320468] INFO: task mount:11341 blocked for more than 120 seconds.
[  241.321253] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  241.321862] mount           D ffff96f79a553150     0 11341  11254 0x00000080
[  241.321866] Call Trace:
[  241.321873]  [<ffffffffb0b7f1c9>] schedule+0x29/0x70
[  241.321879]  [<ffffffffb0b7cb51>] schedule_timeout+0x221/0x2d0
[  241.321881]  [<ffffffffb0b7f57d>] wait_for_completion+0xfd/0x140
[  241.321887]  [<ffffffffb04da0b0>] ? wake_up_state+0x20/0x20
[  241.321931]  [<ffffffffc04c599e>] ? xfs_buf_delwri_submit+0x5e/0xf0 [xfs]
[  241.321945]  [<ffffffffc04c3217>] xfs_buf_iowait+0x27/0xb0 [xfs]
[  241.321962]  [<ffffffffc04c599e>] xfs_buf_delwri_submit+0x5e/0xf0 [xfs]
[  241.321976]  [<ffffffffc04f2a9e>] xlog_do_recovery_pass+0x3ae/0x6e0 [xfs]
[  241.321990]  [<ffffffffc04f2e59>] xlog_do_log_recovery+0x89/0xd0 [xfs]
[  241.322003]  [<ffffffffc04f2ed1>] xlog_do_recover+0x31/0x180 [xfs]
[  241.322017]  [<ffffffffc04f3fef>] xlog_recover+0xbf/0x190 [xfs]
[  241.322030]  [<ffffffffc04e658f>] xfs_log_mount+0xff/0x310 [xfs]
[  241.322043]  [<ffffffffc04dd1b0>] xfs_mountfs+0x520/0x8e0 [xfs]
[  241.322057]  [<ffffffffc04e02a0>] xfs_fs_fill_super+0x410/0x550 [xfs]
[  241.322064]  [<ffffffffb064c893>] mount_bdev+0x1b3/0x1f0
[  241.322077]  [<ffffffffc04dfe90>] ?
xfs_test_remount_options.isra.12+0x70/0x70 [xfs]
[  241.322090]  [<ffffffffc04deaa5>] xfs_fs_mount+0x15/0x20 [xfs]
[  241.322092]  [<ffffffffb064d1fe>] mount_fs+0x3e/0x1b0
[  241.322095]  [<ffffffffb066b377>] vfs_kern_mount+0x67/0x110
[  241.322097]  [<ffffffffb066dacf>] do_mount+0x1ef/0xce0
[  241.322099]  [<ffffffffb064521a>] ? __check_object_size+0x1ca/0x250
[  241.322102]  [<ffffffffb062368c>] ? kmem_cache_alloc_trace+0x3c/0x200
[  241.322104]  [<ffffffffb066e903>] SyS_mount+0x83/0xd0
[  241.322107]  [<ffffffffb0b8bede>] system_call_fastpath+0x25/0x2a

Can anyone suggest what is causing mount to hang?

Bart

On Sun, Mar 8, 2020 at 6:32 PM Bart Brashers <bart.brashers@gmail.com> wrote:
>
> Thanks Dave!
>
> We had what I think was a power fluctuation, and several more drives
> went offline in my JBOD. I had to power-cycle the JBOD to make them
> show "online" again. I unmounted the arrays first, though.
>
> After doing the "echo w > /proc/sysrq-trigger" I was able to mount the
> problematic filesystem directly, no having to read dmesg output. If
> that was due to the power cycling and forcing logicalvolumes to be
> "optimal" (online) again, I don't know.
>
> I was able to run xfs_repair on both filesystems, and have tons of
> files in lost+found to parse now, but at least I have most of my data
> back.
>
> Thanks!
>
> Bart
>
>
> Bart
> ---
> Bart Brashers
> 3039 NW 62nd St
> Seattle WA 98107
> 206-789-1120 Home
> 425-412-1812 Work
> 206-550-2606 Mobile
>
>
> On Sun, Mar 8, 2020 at 3:26 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Sun, Mar 08, 2020 at 12:43:29PM -0700, Bart Brashers wrote:
> > > An update:
> > >
> > > Mounting the degraded xfs filesystem still hangs, so I can't replay
> > > the journal, so I don't yet want to run xfs_repair.
> >
> > echo w > /proc/sysrq-trigger
> >
> > and dump demsg to find where it is hung. If it is not hung and is
> > instead stuck in a loop, use 'echo l > /proc/sysrq-trigger'.
> >
> > > I can mount the degraded xfs filesystem like this:
> > >
> > > $ mount -t xfs -o ro,norecovery,inode64,logdev=/dev/md/nvme2
> > > /dev/volgrp4TB/lvol4TB /export/lvol4TB/
> > >
> > > If I do a "du" on the contents, I see 3822 files with either
> > > "Structure needs cleaning" or "No such file or directory".
> >
> > TO be expected - you mounted an inconsistent filesystem image and
> > it's falling off the end of structures that are incomplete and
> > require recovery to make consistent.
> >
> > > Is what I mounted what I would get if I used the xfs_repair -L option,
> > > and discarded the journal? Or would there be more corruption, e.g. to
> > > the directory structure?
> >
> > Maybe. Maybe more, maybe less. Maybe.
> >
> > > Some of the instances of "No such file or directory" are for files
> > > that are not in their correct directory - I can tell by the filetype
> > > and the directory name. Does that by itself imply directory
> > > corruption?
> >
> > Maybe.
> >
> > It also may imply log recovery has not been run and so things
> > like renames are not complete on disk, and recvoery would fix that.
> >
> > But keep in mind your array had a triple disk failure, so there is
> > going to be -something- lost and not recoverable. That may well be
> > in the journal, at which point repair is your only option...
> >
> > > At this point, can I do a backup, either using rsync or xfsdump or
> > > xfs_copy?
> >
> > Do it any way you want.
> >
> > > I have a separate RAID array on the same server where I
> > > could put the 7.8 TB of data, though the destination already has data
> > > on it - so I don't think xfs_copy is right. Is xfsdump to a directory
> > > faster/better than rsync? Or would it be best to use something like
> > >
> > > $ tar cf - /export/lvol4TB/directory | (cd /export/lvol6TB/ ; tar xfp -)
> >
> > Do it how ever you are confident the data gets copied reliably in
> > the face of filesystem traversal errors.
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
