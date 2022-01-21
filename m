Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70AAC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 10:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379955AbiAUKUi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 05:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379975AbiAUKUf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 05:20:35 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6053DC06173F
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jan 2022 02:20:35 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id y192so1883305vkc.8
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jan 2022 02:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xc60qWdmYkDcmqCepJSEgw8PLIa0merprBFuDOJts7k=;
        b=OYEe9BgniFj9zA5VFJqqOYmJJ1xEoaeSGsyzLdiPo6u0NflaySG4Q2Q46iPF4FKE6+
         2n1QpOJiILQrjv1jzAqD7U/mHb1AORjYk/0jfkuGb2U6aKEBen2r991+6f8plQMF7lN7
         R6sK2kwIoZo3YKO9HCExkhMfSknqWsBkQ2II9lfgTzrvzQHtNHXNqWX777oL7915v6ME
         VsQKCE0oW5Jfpmrx1OtGkFt+YiJEl4GCZrNZEWzDF7U7f+JsP6MfABRKV1tm9OOgob+X
         8zxLksMwJGuIR09PXwa4RWQjx4+/EJ5WwCEBb1lL1nN6YM23tkyCDjHiKRoRq91v1RPg
         MPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xc60qWdmYkDcmqCepJSEgw8PLIa0merprBFuDOJts7k=;
        b=J8T2X6L8XePHX0YpxDpg/K4aAekb2VljLqjOV87GrFaDuR2RGEw7s9tx6KunRmvDM+
         sgInZBTiK8Bo9yQBfiL62suzyhy1RTC7gQmULGGBGQXfuqSt0bHCXI0uZQc0s+LfyiMB
         ldhF+Da9ACo0q3NgZTL2PvOsPw2XXCNFp6g3t6TTIIQIYp5QLyy5xSuuSp8l0OeZi7rr
         RW/A4BClsQDGz5koW7KDohpH3097L1v2tgYzrzpL3VDZcbUgDXOSEV8ZR5K26qok/EI3
         qvcdbIAdF6jMMw4sZDYNe+aAWPJh8eYNd+FWDNdO5o75Nsixjuo42fGmXR5ELsHNgCYC
         ftqQ==
X-Gm-Message-State: AOAM533S2dddusvdv8Q78LzUK1+p/YBI7eMCnwSQMQb8odPjnxdh0Y9J
        4FeWFTSWIY8FUVV1W/oHYyoQ6zEBXD019lF7tH1yvTSvxtihguK4MqGtCkgVy5mO/IR5IaldKV+
        qXAmNMxQOaXIWWqN12B40Z9sEeg503vxZoKl/GOw=
X-Google-Smtp-Source: ABdhPJxsU7WoDrzdWVPq2kcRV0Waoqs0yeb/sYDOXLRrYiiMFcxB3w7lJQ4us8XU0F2yD7/8ysTwNGs5yCEvPWWTKpU=
X-Received: by 2002:a05:6122:8c6:: with SMTP id 6mr1310834vkg.5.1642760434439;
 Fri, 21 Jan 2022 02:20:34 -0800 (PST)
MIME-Version: 1.0
References: <CAG2S0o-wJc-2_wm=35mE5Lt0e4idXwb3g5ezc9=LdWrLHfRM_Q@mail.gmail.com>
 <20220120180228.GE13514@magnolia>
In-Reply-To: <20220120180228.GE13514@magnolia>
From:   Andrea Tomassetti <andrea.tomassetti@devo.com>
Date:   Fri, 21 Jan 2022 11:20:23 +0100
Message-ID: <CAG2S0o8GZCa0jYuryr7q+woEnjSZJDxton5xnSpNDp4fWH-WgA@mail.gmail.com>
Subject: Re: xfs/311 test pass but leave block device unusable
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 20, 2022 at 7:02 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> [cc xfs list]
>
> On Thu, Jan 20, 2022 at 12:04:47PM +0100, Andrea Tomassetti wrote:
> > Hi all,
> > I was using the (x)fstest utility on the Kernel 5.11 to try to
> > reproduce some xfs-related issues:
> >   INFO: task xfs-conv/dm-3:1360 blocked for more than 120 seconds.
> >   Workqueue: xfs-conv/dm-3 xfs_end_io [xfs]
> >    Call Trace:
> >     __schedule+0x44c/0x8a0
> >     schedule+0x4f/0xc0
> >     xlog_grant_head_wait+0xb5/0x1a0 [xfs]
> >     xlog_grant_head_check+0xe1/0x100 [xfs]
>
> Threads are stuck waiting for log space; can you post the full dmesg?
> And the xfs_info output of the test device?
>

I think I maybe didn't expose correctly the problems. I mentioned two
separated issues:
  1. The thread stuck problem, to which the dmesg refers to. It is
happening to us in production and we're trying to replicate it in a
test environment but without any success at the moment.
  2. While I was using xfstests, in the hope it could replicate the
problem, I stepped into the buggy behaviour of the test n. 311. And I
wanted to report this to you (and maybe get some advice on the
production's problem that is affecting us)

I hope I made myself clear, sorry for the misunderstanding.

Here the full dmesg, about the production's issue:

  [Thu Dec 23 17:13:56 2021] INFO: task xfs-conv/dm-3:1360 blocked for
more than 120 seconds.
  [Thu Dec 23 17:13:56 2021]       Not tainted 5.11.0-1020-aws
#21~20.04.2-Ubuntu
  [Thu Dec 23 17:13:56 2021] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [Thu Dec 23 17:13:56 2021] task:xfs-conv/dm-3   state:D stack:    0
pid: 1360 ppid:     2 flags:0x00004000
  [Thu Dec 23 17:13:56 2021] Workqueue: xfs-conv/dm-3 xfs_end_io [xfs]
  [Thu Dec 23 17:13:56 2021] Call Trace:
  [Thu Dec 23 17:13:56 2021]  __schedule+0x44c/0x8a0
  [Thu Dec 23 17:13:56 2021]  schedule+0x4f/0xc0
  [Thu Dec 23 17:13:56 2021]  xlog_grant_head_wait+0xb5/0x1a0 [xfs]
  [Thu Dec 23 17:13:56 2021]  xlog_grant_head_check+0xe1/0x100 [xfs]
  [Thu Dec 23 17:13:56 2021]  xfs_log_reserve+0xc2/0x1c0 [xfs]
  [Thu Dec 23 17:13:56 2021]  xfs_trans_reserve+0x1ca/0x210 [xfs]
  [Thu Dec 23 17:13:56 2021]  xfs_trans_alloc+0xd7/0x190 [xfs]
  [Thu Dec 23 17:13:56 2021]  xfs_iomap_write_unwritten+0x125/0x2e0 [xfs]
  [Thu Dec 23 17:13:56 2021]  xfs_end_ioend+0xdb/0x120 [xfs]
  [Thu Dec 23 17:13:56 2021]  xfs_end_io+0xb7/0xe0 [xfs]
  [Thu Dec 23 17:13:56 2021]  process_one_work+0x220/0x3c0
  [Thu Dec 23 17:13:56 2021]  rescuer_thread+0x2ca/0x3b0
  [Thu Dec 23 17:13:56 2021]  ? worker_thread+0x3f0/0x3f0
  [Thu Dec 23 17:13:56 2021]  kthread+0x12b/0x150
  [Thu Dec 23 17:13:56 2021]  ? set_kthread_struct+0x40/0x40
  [Thu Dec 23 17:13:56 2021]  ret_from_fork+0x22/0x30

> > When I realized that xfs test n. 311 was passing correctly but every
> > further attempt to use the block device (e.g. mount it) was failing.
> > The issue is reproducible after reboot.
> >
> > Test passed:
> >   ./check xfs/311
> >   FSTYP         -- xfs (non-debug)
> >   PLATFORM      -- Linux/x86_64 test 5.11.0-1021-aws
> > #22~20.04.2-Ubuntu SMP Wed Oct 27 21:27:13 UTC 2021
> >   MKFS_OPTIONS  -- -f /dev/xvdz
> >   MOUNT_OPTIONS -- /dev/xvdz /home/test/z
> >
> >   xfs/311 25s ...  25s
> >   Ran: xfs/311
> >   Passed all 1 tests
> >
> > Fail:
> >   # mount /dev/xvdz /home/test/z/
> >     mount: /home/test/z: /dev/xvdz already mounted or mount point busy.
> >     [ 2222.028417] /dev/xvdz: Can't open blockdev
> >
> > lsof does not show anything that is using either /dev/xvdz or /home/tes=
t/z
> >
> > Any idea why is this happening?
>
> xfs-conv handles unwritten extent conversion after writeback, so I would
> speculate (without dmesg data) that everyone got wedged trying to start
> a transaction, and the log is blocked up for whatever reason.
>

I run the test xfs/311 with the Kernel v5.13 and the behaviour is the
same as with the 5.11: after running it the disk becomes unusable.

Trying to rerun the test, after the first successful run, leads to:

  FSTYP         -- xfs (non-debug)
  PLATFORM      -- Linux/x86_64 test 5.11.0-1021-aws
#22~20.04.2-Ubuntu SMP Wed Oct 27 21:27:13 UTC 2021
  MKFS_OPTIONS  -- -f /dev/xvdz
  MOUNT_OPTIONS -- /dev/xvdz /home/test/z

  our local _scratch_mkfs routine ...
  mkfs.xfs: cannot open /dev/xvdz: Device or resource busy
  check: failed to mkfs $SCRATCH_DEV using specified options
  Interrupted!
  Passed all 0 tests

with no errors in dmesg.

xfs_info /dev/xvdz
meta-data=3D/dev/xvdz              isize=3D512    agcount=3D4, agsize=3D327=
68000 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D0
         =3D                       reflink=3D1
data     =3D                       bsize=3D4096   blocks=3D131072000, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D64000, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

> > The `xlog_grant_head_wait` race issue has been resolved in a later
> > Kernel version, am I right?
>
> Beats me.
>
> > Best regards,
> > Andrea
> >
> > --
> >
> >
> >
> >
> >
> >
> >
> > The contents of this email are confidential. If the reader of this
>
> Not anymore they aren't.
>
> --D
>
> > message is not the intended recipient, you are hereby notified that any
> > dissemination, distribution or copying of this communication is strictl=
y
> > prohibited. If you have received this communication in error, please no=
tify
> > us immediately by replying to this message and deleting it from your
> > computer. Thank you. Devo, Inc; arco@devo.com <mailto:arco@devo.com>;
> > Calle Est=C3=A9banez Calder=C3=B3n 3-5, 5th Floor. Madrid, Spain 28020
> >

--=20







The contents of this email are confidential. If the reader of this=20
message is not the intended recipient, you are hereby notified that any=20
dissemination, distribution or copying of this communication is strictly=20
prohibited. If you have received this communication in error, please notify=
=20
us immediately by replying to this message and deleting it from your=20
computer. Thank you.=C2=A0Devo, Inc; arco@devo.com <mailto:arco@devo.com>;=
=C2=A0=C2=A0
Calle Est=C3=A9banez Calder=C3=B3n 3-5, 5th Floor. Madrid, Spain 28020

