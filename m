Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DD4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Feb 2022 19:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245521AbiBQTxG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:53:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiBQTxD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Feb 2022 14:53:03 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A81013195F
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 11:52:47 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id s203-20020a4a3bd4000000b003191c2dcbe8so861903oos.9
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 11:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=vhIMbpsO4KV+NoGiNi+kBgXcb6F2SHz25M2J2WhmKQ8=;
        b=YfiNrSRFUzi5MD9Q8jRTGXrxBWW1M03jE7IWFieCmZ0JNVJejN/SYslCJIaiQwdjbb
         JdKpQLuHlTr5GhvBYR9UovZ4FtQ7YRUHZPkmah+XIQLH9MhAZQq9W2ikzIxGnXrkgH4w
         XzEwN9+awdBC8BM00hc7goTSXlk5fceHqlbbs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=vhIMbpsO4KV+NoGiNi+kBgXcb6F2SHz25M2J2WhmKQ8=;
        b=nOGU3gj9jotmgQ1yLoVzPpGFryW9N+F6SYb8WEUIR1JtUBQ2PVpiXfTV/8sfFDvDp1
         jznfty94SfRqzMg02KPQUxhg8MdolNsLQghV2WGSqqMtGkq1rfyGIIu1h8HRS1vOCRDd
         R4sxm0pHqIkwR6xMD7MTJVl8HlTlWJ3WLo+FCJaPgvDSf4Q040xlyFsiJ0v4EQRx9Yrb
         ROpS7+mUcADm+p3z9cXLHjicOlXKRJqMZDkwVKuhYBlzbI6KfFDJ/M8kkTSoN+04E07t
         sarIRU+RyC4gOE7vippkIf7PnXaAUZ2c5TG238V22VT+PntYqO5dOa5I/4VJ3UdX7FdN
         /wLw==
X-Gm-Message-State: AOAM532w4guQVBsNPW37f7kpmpP4J5dOpzfjNFU1M1Kk7GQCCq003o0H
        5oo7ZUPbfdu52XLByuqDLHIyKchbhDtu7UUfE2dnX5ynxxfBfw==
X-Google-Smtp-Source: ABdhPJwLFKc82TcVj8IgF0nfEy/9Y/EVOwWFHI/PzVP6V0c1MusjfP7v6AxK9t9kvyItmKKcnkqroc0EaQs35lJ2B6w=
X-Received: by 2002:a05:6871:4082:b0:d2:c693:b8be with SMTP id
 kz2-20020a056871408200b000d2c693b8bemr1679363oab.282.1645127567194; Thu, 17
 Feb 2022 11:52:47 -0800 (PST)
MIME-Version: 1.0
From:   Manish Adkar <madkar@cs.stonybrook.edu>
Date:   Thu, 17 Feb 2022 11:52:36 -0800
Message-ID: <CAOfCjwOsS+qLc2JsKSohSFc2Uif0tWKG-e3zHj=+jBAa9cKj5Q@mail.gmail.com>
Subject: "No space left on device" issue
To:     linux-xfs@vger.kernel.org
Cc:     Erez Zadok <ezk@fsl.cs.sunysb.edu>,
        Yifei Liu <yifeliu@cs.stonybrook.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

We have a 16 MB XFS test partition with both plenty of free space
and inodes (419 out of 424), but we=E2=80=99re still getting the error "No
space left on device" when trying to create new files (After the
free space reaches 184320 bytes). It can then only edit and append
any existing files. (There are good reasons why we want to avoid a
larger partition.)

Mount options:

# mount |grep xfs
/dev/ram1 on /mnt/test-xfs type xfs (rw,noatime,attr2,inode64,
logbufs=3D8,logbsize=3D32k,noquota)

Here, the filesystem is already mounted with the inode64 option.

Used disk space:

# df /dev/ram1
Filesystem     1K-blocks  Used Available Use% Mounted on
/dev/ram1          11500 11320       180  99% /mnt/test-xfs

Used inodes:

# df -i /dev/ram1
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/ram1         424     5   419    2% /mnt/test-xfs

xfs info:

# xfs_info /dev/ram1
meta-data=3D/dev/ram1      isize=3D512    agcount=3D1, agsize=3D4096 blks
         =3D               sectsz=3D4096  attr=3D2, projid32bit=3D1
         =3D               crc=3D1        finobt=3D1, sparse=3D1, rmapbt=3D=
0
         =3D               reflink=3D1    bigtime=3D0
data     =3D               bsize=3D4096   blocks=3D4096, imaxpct=3D25
         =3D               sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2      bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log   bsize=3D4096   blocks=3D1221, version=3D2
         =3D               sectsz=3D4096  sunit=3D1 blks, lazy-count=3D1
realtime =3Dnone           extsz=3D4096   blocks=3D0, rtextents=3D0

In the below =E2=80=9Cfreesp=E2=80=9D output, we can see that there are ple=
nty of
contiguous blocks for inode cluster allocation and hence the disk
is not fragmented.

# xfs_db -r -c "freesp -s -a 0" /dev/ram1
   from      to extents  blocks    pct
      1       1       4       4   1.44
      4       7       1       6   2.16
    256     511       1     268  96.40
total free extents 6
total free blocks 278
average free extent size 46.3333

I came across an email thread from the linux-xfs mailing list that
described a similar issue. It mentioned, inodes are allocated in
contiguous chunks of 64. Here, in this case, 1 inode takes 512 bytes
of space and 1 block has 4096 bytes capacity. Hence there would be 8
inodes per block (4096 / 512). Now, to allocate 64 inodes, 8 blocks
would be needed (64 / 8). Looking at the above =E2=80=9Cfreesp=E2=80=9D out=
put, we
can see there are 8 contiguous blocks available so the issue must not
be a fragmentation one. But the thread suggests, the allocation has
an alignment requirement, and here, the blocks must be aligned to an
8 block boundary. To look for that,

# xfs_db -r -c "freesp -s -a 0 -A 8" /dev/ram1
   from      to extents  blocks    pct
      1       1       1       1 100.00
total free extents 1
total free blocks 1
average free extent size 1

Here we can see that there is just one single block that is aligned
to the 8 block boundary. Hence, this could be a fragmentation issue.
My concern is that, is my understanding and calculations
(64 / (4096 / 512)) correct about the 8-block boundary? I also tried
this

# xfs_db -r -c "freesp -s -a 0 -A 32" /dev/ram1
   from      to extents  blocks    pct
total free extents 0
total free blocks 0
average free extent size -nan

And this also suggests that there are no such required blocks.

I also saw the suggestion given in this thread to avoid this issue.
It mentions that enabling =E2=80=9Csparse=E2=80=9D inode allocations will h=
elp
resolve this issue. But here =E2=80=9Csparse=E2=80=9D inode allocation is e=
nabled by
default. So probably there is another resolution to this problem.
Can you help?
