Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100C2C0044D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 23:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0266920759
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 23:27:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lsbs+XWA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731417AbgCKX1l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 19:27:41 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46003 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731392AbgCKX1l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 19:27:41 -0400
Received: by mail-ot1-f67.google.com with SMTP id f21so4054810otp.12
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 16:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ECEm6PwAjXixK8atOkg24YJzLP2w4+WIJGwQmQuMMg=;
        b=Lsbs+XWArJC4rThUAgv/uL6QuekggTLnx8clNIkdMVpfNUEtjCZDQsVE5yjtheskMt
         Chs8MTBfyfuuc9sQW64Xds7FOh+MMQ82EpeCfCqnXcKS55fOqkiWr7P6mXWFvdHytUjq
         RYxczh/z8l81ThvFerhxWfAeH0n5OFohxBu2UFDVG0qI+SN4vy6ZhICgWuj1avTJ0QnD
         uI+xoXAoQTntDRWAir7z7saT/5mm+r9k3j6oCEnIN/JoP45Qeoc0OPHckr81FP5s6ULX
         QB9yfdWZV63wwF8bXPvnfXXR5FM2uvT4Xvi3U9/tvhItyvEn/gpRW/WTd6rtRDDIc/so
         DuLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ECEm6PwAjXixK8atOkg24YJzLP2w4+WIJGwQmQuMMg=;
        b=MJJnr/xsu32brCOedEA+rRMEBQC3/rX/90UfET7EuKF3N992n1pJ41zZpZGjTk68Cr
         YJp3R6Ho1pOfZoIYMyB9LMv+acJwuNmqfb7BDlInysPKkKf++CdDA0cTxErK1nGc9Bh9
         hR5Zzil9XYNdScJKg9dmPUuuTcQFIj40zNOIsGrHq8tqHFq+qnegFgbPoV+iwDJi7aFR
         wpwgf/p4zWVrfzbgSW0NZ7GXWi7sD8EpjelG4I0P2Mvy/fLuO1m59vy20+iwpTUhNeDo
         EaervUVRUzzr8XAzi+7yYagr5BEBIQDTchd4TIBszS9rYaPpw91/XYc4of7bJ2LSyjh8
         8fZw==
X-Gm-Message-State: ANhLgQ0WLSdG3ewG3YG1/q4Y5RpVwMahGP9xIwe0SXoCRBKx4pBHouVq
        VzOo/Y2d3J6Chof2+rUCoqtSXtFup1OO8d2rDyspRxKn
X-Google-Smtp-Source: ADFU+vuIMQr6ibgV+AlkPT0HZOg78t0qLGpGzQOGzp17g9GZY6UMifJCnHLYPtijP8JPrKUpPC5g50TbycAneXtXWJM=
X-Received: by 2002:a9d:63d2:: with SMTP id e18mr4135359otl.277.1583969258694;
 Wed, 11 Mar 2020 16:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAHgh4_+15tc6ekqBRHqZrdDmVSfUmMpOGyg_9kWYQ7XOs7D+eQ@mail.gmail.com>
 <CAHgh4_+p0okyt3kC=6HOZb6dr8o3dxqQARoFB-LkR9x-tGuvSA@mail.gmail.com>
 <20200308222646.GL10776@dread.disaster.area> <CAHgh4_K_01dS2Z-2QwR2dc5ZDz9J2+tG6W-paOeneUa6G_h9Kw@mail.gmail.com>
 <CAHgh4_KpizhD+V59+nV_Tr1W5i4N+yeSKQL9Sq6E5BwyWyr_aA@mail.gmail.com> <20200311232510.GG10776@dread.disaster.area>
In-Reply-To: <20200311232510.GG10776@dread.disaster.area>
From:   Bart Brashers <bart.brashers@gmail.com>
Date:   Wed, 11 Mar 2020 16:27:27 -0700
Message-ID: <CAHgh4_JXKSRbpC4zQfkfJDj6K9oeyLHb1SaeOfk2AXq0-QkU1Q@mail.gmail.com>
Subject: Re: mount before xfs_repair hangs
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When this happened over the weekend, I left the mount running from
10pm till 7am, with no apparent progress.

That implies the HW raid controller card gets in some sort of hung
state, doesn't it?

Bart

On Wed, Mar 11, 2020 at 4:25 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Mar 11, 2020 at 04:11:27PM -0700, Bart Brashers wrote:
> > After working fine for 2 days, it happened again. Drives went offline
> > for no apparent reason, and a logicaldevice (as arcconf calls them)
> > failed. arcconf listed the hard drives as all online by the time I had
> > logged on.
> >
> > The server connected to the JBOD had rebooted by the time I noticed the problem.
> >
> > There are two xfs filesystems on this server. I can mount one of them,
> > and ran xfs_repair on it.
> >
> > I first tried mounting the other read-only,no-recovery. That worked.
> > Trying to mount normally hangs. I see in ps aux | grep mount that it's
> > not using CPU. Here's the mount command I gave:
> >
> > mount -t xfs -o inode64,logdev=/dev/md/nvme2 /dev/volgrp4TB/lvol4TB
> > /export/lvol4TB/
> >
> > I did an echo w > /proc/sysrc-trigger while I was watching the
> > console, it said "SysRq : Show Blocked State". Here's what the output
> > of dmesg looks like, starting with that line. Then it gives blocks
> > about what's happening on each CPU, some of which mention "xfs".
> >
> > [  228.927915] SysRq : Show Blocked State
> > [  228.928525]   task                        PC stack   pid father
> > [  228.928605] mount           D ffff96f79a553150     0 11341  11254 0x00000080
> > [  228.928609] Call Trace:
> > [  228.928617]  [<ffffffffb0b7f1c9>] schedule+0x29/0x70
> > [  228.928624]  [<ffffffffb0b7cb51>] schedule_timeout+0x221/0x2d0
> > [  228.928626]  [<ffffffffb0b7f57d>] wait_for_completion+0xfd/0x140
> > [  228.928633]  [<ffffffffb04da0b0>] ? wake_up_state+0x20/0x20
> > [  228.928667]  [<ffffffffc04c599e>] ? xfs_buf_delwri_submit+0x5e/0xf0 [xfs]
> > [  228.928682]  [<ffffffffc04c3217>] xfs_buf_iowait+0x27/0xb0 [xfs]
> > [  228.928696]  [<ffffffffc04c599e>] xfs_buf_delwri_submit+0x5e/0xf0 [xfs]
> > [  228.928712]  [<ffffffffc04f2a9e>] xlog_do_recovery_pass+0x3ae/0x6e0 [xfs]
> > [  228.928727]  [<ffffffffc04f2e59>] xlog_do_log_recovery+0x89/0xd0 [xfs]
> > [  228.928742]  [<ffffffffc04f2ed1>] xlog_do_recover+0x31/0x180 [xfs]
> > [  228.928758]  [<ffffffffc04f3fef>] xlog_recover+0xbf/0x190 [xfs]
> > [  228.928772]  [<ffffffffc04e658f>] xfs_log_mount+0xff/0x310 [xfs]
> > [  228.928801]  [<ffffffffc04dd1b0>] xfs_mountfs+0x520/0x8e0 [xfs]
> > [  228.928814]  [<ffffffffc04e02a0>] xfs_fs_fill_super+0x410/0x550 [xfs]
> > [  228.928818]  [<ffffffffb064c893>] mount_bdev+0x1b3/0x1f0
> > [  228.928831]  [<ffffffffc04dfe90>] ?
> > xfs_test_remount_options.isra.12+0x70/0x70 [xfs]
> > [  228.928842]  [<ffffffffc04deaa5>] xfs_fs_mount+0x15/0x20 [xfs]
> > [  228.928845]  [<ffffffffb064d1fe>] mount_fs+0x3e/0x1b0
> > [  228.928850]  [<ffffffffb066b377>] vfs_kern_mount+0x67/0x110
> > [  228.928852]  [<ffffffffb066dacf>] do_mount+0x1ef/0xce0
> > [  228.928855]  [<ffffffffb064521a>] ? __check_object_size+0x1ca/0x250
> > [  228.928858]  [<ffffffffb062368c>] ? kmem_cache_alloc_trace+0x3c/0x200
> > [  228.928860]  [<ffffffffb066e903>] SyS_mount+0x83/0xd0
> > [  228.928863]  [<ffffffffb0b8bede>] system_call_fastpath+0x25/0x2a
>
> It's waiting for the metadata writes for recovered changes to
> complete. This implies the underlying device is either hung or it
> extremely slow. I'd suggest "extremely slow" because it's doing it's
> own internal rebuild and may well be blocking new writes until it
> has recovered the regions the new writes are being directed at...
>
> This all looks like HW raid controller problems, nothign to do with
> linux or the filesystem.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
