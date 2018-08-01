Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f52.google.com ([209.85.167.52]:33450 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732974AbeHADox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 23:44:53 -0400
Received: by mail-lf1-f52.google.com with SMTP id u14-v6so12134453lfu.0
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 19:01:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQpeQ_z9gMHhnhSvzJed4HfT=pxpORTTNjJQUogvVjLgA@mail.gmail.com>
References: <CAJCQCtQpeQ_z9gMHhnhSvzJed4HfT=pxpORTTNjJQUogvVjLgA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 31 Jul 2018 20:01:42 -0600
Message-ID: <CAJCQCtQ_seiyOUGFK_CvjQCZ--ho1C8A1Wao0Nx4WTZOk682NQ@mail.gmail.com>
Subject: Re: agcount 33 by default for a single HDD?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 7:32 PM, Chris Murphy <lists@colorremedies.com> wrote:
> This seems suboptimal. Basically this is a 750G thin volume. I don't
> have a plain partition on a device handy to try this out but I'm
> pretty certain the default is 4 AG's in that case, so I'm confused why
> by default 33 AGs are created on a thin volume. The LVM volume group
> is on a dmcrypt PV.
>
>
> xfsprogs-4.15.1-1.fc28.x86_64
> lvm2-2.02.177-5.fc28.x86_64
> kernel-4.17.11-200.fc28.x86_64
>
>
>          =                       sunit=128    swidth=1024 blks

This also seems screwy for a single non-raid device. I wonder if
there's something goofy happening with device mapper that's giving the
wrong information to XFS.

I just built xfsprogs 4.17 from git and I get different unexpected results:


[chris@f28s mkfs]$ sudo ./mkfs.xfs -V
mkfs.xfs version 4.17.0
[chris@f28s mkfs]$ sudo ./mkfs.xfs /dev/mapper/4vg-nukeit
mkfs.xfs: Use the -f option to force overwrite.
[chris@f28s mkfs]$ sudo ./mkfs.xfs -f /dev/mapper/4vg-nukeit
meta-data=/dev/mapper/4vg-nukeit isize=512    agcount=4, agsize=49152000 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=196608000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=96000, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[chris@f28s mkfs]$



The agcount, sunit and swidth are what I expect, but sectsz=512 is
not. The device has a 4096 byte physical sector. And this is being
reported by 'lsblk' as a 4096 byte physical sector with 512 byte
logical sector (it is a 512e drive). The 4.15.0 Fedora built xfsprogs
got this right, but 4.17.0 as built is not.

:shrug:


-- 
Chris Murphy
