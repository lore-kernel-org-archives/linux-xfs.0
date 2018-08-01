Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f181.google.com ([209.85.208.181]:42786 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732969AbeHADPz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 23:15:55 -0400
Received: by mail-lj1-f181.google.com with SMTP id f1-v6so15390922ljc.9
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 18:32:52 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 31 Jul 2018 19:32:50 -0600
Message-ID: <CAJCQCtQpeQ_z9gMHhnhSvzJed4HfT=pxpORTTNjJQUogvVjLgA@mail.gmail.com>
Subject: agcount 33 by default for a single HDD?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>

This seems suboptimal. Basically this is a 750G thin volume. I don't
have a plain partition on a device handy to try this out but I'm
pretty certain the default is 4 AG's in that case, so I'm confused why
by default 33 AGs are created on a thin volume. The LVM volume group
is on a dmcrypt PV.


xfsprogs-4.15.1-1.fc28.x86_64
lvm2-2.02.177-5.fc28.x86_64
kernel-4.17.11-200.fc28.x86_64




[chris@f28s ~]$ sudo lvdisplay 4vg/nukeit
  --- Logical volume ---
  LV Path                /dev/4vg/nukeit
  LV Name                nukeit
  VG Name                4vg
  LV UUID                T21akN-RZeV-CfpZ-br70-6A1e-IkFI-VYOhNj
  LV Write Access        read/write
  LV Creation host, time f28s.local, 2018-07-31 19:28:21 -0600
  LV Pool name           4pool
  LV Status              available
  # open                 0
  LV Size                750.00 GiB
  Mapped size            0.00%
  Current LE             192000
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:10

[chris@f28s ~]$ sudo mkfs.xfs /dev/mapper/4vg-nukeit
meta-data=/dev/mapper/4vg-nukeit isize=512    agcount=33, agsize=6143872 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0,
rmapbt=0, reflink=0
data     =                       bsize=4096   blocks=196608000, imaxpct=25
         =                       sunit=128    swidth=1024 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=96000, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[chris@f28s ~]$


-- 
Chris Murphy
