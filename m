Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FE8C77B73
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 19:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjEBTOs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 15:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjEBTOr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 15:14:47 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0DB1BFD
        for <linux-xfs@vger.kernel.org>; Tue,  2 May 2023 12:14:46 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b5465fb99so3369144b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 May 2023 12:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oobak.org; s=ghs; t=1683054885; x=1685646885;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tFPN6hxXUMyMwq6L24Jf0AYd4LQqqg8tgramh3JJcSg=;
        b=EaF7ghswmgHR/WQxsZSzH9W2tPeONShJL0XO6l8ujHdX0hW+n62C9WNR+F/3CCVFB1
         NcacKDNgEvL5X/KvVGHxJoBp8SRlgkwauuKfwfSLsIo2C1bZFyhkPq6Djz5EK3d/5NhG
         vALcmF0MDEQEDfxesPVwa93uskuuhP24EQQmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683054885; x=1685646885;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tFPN6hxXUMyMwq6L24Jf0AYd4LQqqg8tgramh3JJcSg=;
        b=NmfNR0KokIe9AahnLLm4ClBwaZcrZSt3soRiyjlFlTeTjV9qt1w9XzS5Lhrc+D576d
         wLv02Vcvsc4KsXrNxWz+12kFz2jWaP4jIkzYczhO1lI595faB+lOn4d5R+c+DlsUUkLy
         qFlwgzoC23S0Sa0s6XVHFnX3qh+qPhTQLyWFrryKwkuRUhdOZLvnZ4p5gQlPsdk+sgnY
         vhzjZ3x7JPdinFHV4em4hNFOFk4iRFw4PgnFpmK3L2G5xJgVfoByWzLJUY7xKKA4YUrF
         xxJa9yKRya6gL8MV0zLhm89GgPtwFYOuQdxrdsitIjU2gH4eWneAapopqHEoaz/M2k2n
         9DoA==
X-Gm-Message-State: AC+VfDySmlxgHk3mevkdTmbs9thR8rd6XqbzVZstOt3uWoUxGslreUVZ
        9LYqrssHQYdTrjUPufKQG71U/r0sFFMCk/k2Pi1fDtdXB00bLpPF9Kw=
X-Google-Smtp-Source: ACHHUZ6xpDwhLbVe2nHKDRyfKv+69xINVFH4KDZVrj1eZ79nG5QMLaCn7ViEH2oEH6KO644liMoq++ECtXBZeCwwQ48=
X-Received: by 2002:a05:6a00:cd6:b0:63d:6744:8caf with SMTP id
 b22-20020a056a000cd600b0063d67448cafmr26680302pfv.26.1683054885010; Tue, 02
 May 2023 12:14:45 -0700 (PDT)
MIME-Version: 1.0
From:   Mike Pastore <mike@oobak.org>
Date:   Tue, 2 May 2023 14:14:34 -0500
Message-ID: <CAP_NaWaozOVBoJXtuXTRUWsbmGV4FQUbSPvOPHmuTO7F_FdA4g@mail.gmail.com>
Subject: Corruption of in-memory data (0x8) detected at xfs_defer_finish_noroll
 on kernel 6.3
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I was playing around with some blockchain projects yesterday and had
some curious crashes while syncing blockchain databases on XFS
filesystems under kernel 6.3.

  * kernel 6.3.0 and 6.3.1 (ubuntu mainline)
  * w/ and w/o the discard mount flag
  * w/ and w/o -m crc=3D0
  * ironfish (nodejs) and ergo (jvm)

The hardware is as follows:

  * Asus PRIME H670-PLUS D4
  * Intel Core i5-12400
  * 32GB DDR4-3200 Non-ECC UDIMM

In all cases the filesystems were newly-created under kernel 6.3 on an
LVM2 stripe and mounted with the noatime flag. Here is the output of
the mkfs.xfs command (after reverting back to 6.2.14=E2=80=94which I realiz=
e
may not be the most helpful thing, but here it is anyway):

$ sudo lvremove -f vgtethys/ironfish
$ sudo lvcreate -n ironfish-L 10G -i2 vgtethys /dev/nvme[12]n1p3
  Using default stripesize 64.00 KiB.
  Logical volume "ironfish" created.
$ sudo mkfs.xfs -m crc=3D0 -m uuid=3Db4725d43-a12d-42df-981a-346af2809fad
-s size=3D4096 /dev/vgtethys/ironfish
meta-data=3D/dev/vgtethys/ironfish isize=3D256    agcount=3D16, agsize=3D16=
3824 blks
         =3D                       sectsz=3D4096  attr=3D2, projid32bit=3D1
         =3D                       crc=3D0        finobt=3D0, sparse=3D0, r=
mapbt=3D0
         =3D                       reflink=3D0    bigtime=3D0 inobtcount=3D=
0
data     =3D                       bsize=3D4096   blocks=3D2621184, imaxpct=
=3D25
         =3D                       sunit=3D16     swidth=3D32 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D2560, version=3D=
2
         =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
Discarding blocks...Done.

The applications crash with I/O errors. Here's what I see in dmesg:

May 01 18:56:59 tethys kernel: XFS (dm-28): Internal error bno + len >
gtbno at line 1908 of file fs/xfs/libxfs/xfs_alloc.c.  Caller
xfs_free_ag_extent+0x14e/0x950 [xfs]
May 01 18:56:59 tethys kernel: CPU: 2 PID: 48657 Comm: node Tainted: P
          OE      6.3.1-060301-generic #202304302031
May 01 18:56:59 tethys kernel: Hardware name: ASUS System Product
Name/PRIME H670-PLUS D4, BIOS 2014 10/14/2022
May 01 18:56:59 tethys kernel: Call Trace:
May 01 18:56:59 tethys kernel:  <TASK>
May 01 18:56:59 tethys kernel:  dump_stack_lvl+0x48/0x70
May 01 18:56:59 tethys kernel:  dump_stack+0x10/0x20
May 01 18:56:59 tethys kernel:  xfs_corruption_error+0x9e/0xb0 [xfs]
May 01 18:56:59 tethys kernel:  ? xfs_free_ag_extent+0x14e/0x950 [xfs]
May 01 18:56:59 tethys kernel:  xfs_free_ag_extent+0x17c/0x950 [xfs]
May 01 18:56:59 tethys kernel:  ? xfs_free_ag_extent+0x14e/0x950 [xfs]
May 01 18:56:59 tethys kernel:  __xfs_free_extent+0xee/0x1e0 [xfs]
May 01 18:56:59 tethys kernel:  xfs_trans_free_extent+0xad/0x1a0 [xfs]
May 01 18:56:59 tethys kernel:  xfs_extent_free_finish_item+0x14/0x40 [xfs]
May 01 18:56:59 tethys kernel:  xfs_defer_finish_one+0xd9/0x280 [xfs]
May 01 18:56:59 tethys kernel:  xfs_defer_finish_noroll+0xab/0x280 [xfs]
May 01 18:56:59 tethys kernel:  xfs_defer_finish+0x16/0x80 [xfs]
May 01 18:56:59 tethys kernel:  xfs_itruncate_extents_flags+0xe3/0x270 [xfs=
]
May 01 18:56:59 tethys kernel:  xfs_free_eofblocks+0xe3/0x130 [xfs]
May 01 18:56:59 tethys kernel:  xfs_release+0x153/0x190 [xfs]
May 01 18:56:59 tethys kernel:  xfs_file_release+0x15/0x20 [xfs]
May 01 18:56:59 tethys kernel:  __fput+0x95/0x270
May 01 18:56:59 tethys kernel:  ____fput+0xe/0x20
May 01 18:56:59 tethys kernel:  task_work_run+0x5e/0xa0
May 01 18:56:59 tethys kernel:  exit_to_user_mode_loop+0x136/0x160
May 01 18:56:59 tethys kernel:  exit_to_user_mode_prepare+0xff/0x110
May 01 18:56:59 tethys kernel:  syscall_exit_to_user_mode+0x1b/0x50
May 01 18:56:59 tethys kernel:  do_syscall_64+0x67/0x90
May 01 18:56:59 tethys kernel:  ? syscall_exit_to_user_mode+0x44/0x50
May 01 18:56:59 tethys kernel:  ? do_syscall_64+0x67/0x90
May 01 18:56:59 tethys kernel:  entry_SYSCALL_64_after_hwframe+0x72/0xdc
May 01 18:56:59 tethys kernel: RIP: 0033:0x7f8fce72c6a7
May 01 18:56:59 tethys kernel: Code: 44 00 00 48 8b 15 e9 d7 0d 00 f7
d8 64 89 02 b8 ff ff ff ff eb bc 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
00 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 >
May 01 18:56:59 tethys kernel: RSP: 002b:00007f8fb2a67a78 EFLAGS:
00000202 ORIG_RAX: 0000000000000003
May 01 18:56:59 tethys kernel: RAX: 0000000000000000 RBX:
00007f8f98019420 RCX: 00007f8fce72c6a7
May 01 18:56:59 tethys kernel: RDX: 00007f8fce806880 RSI:
00007f8f982a9b40 RDI: 000000000000004c
May 01 18:56:59 tethys kernel: RBP: 0000000000000000 R08:
0000000000000000 R09: 00007f8fc02c5520
May 01 18:56:59 tethys kernel: R10: 0000000000000064 R11:
0000000000000202 R12: 00007f8fce807480
May 01 18:56:59 tethys kernel: R13: 0000000000006be1 R14:
0000000000000019 R15: 00007f8f980a8b50
May 01 18:56:59 tethys kernel:  </TASK>
May 01 18:56:59 tethys kernel: XFS (dm-28): Corruption detected.
Unmount and run xfs_repair
May 01 18:56:59 tethys kernel: XFS (dm-28): Corruption of in-memory
data (0x8) detected at xfs_defer_finish_noroll+0x130/0x280 [xfs]
(fs/xfs/libxfs/xfs_defer.c:573).  Shutting down filesystem.
May 01 18:56:59 tethys kernel: XFS (dm-28): Please unmount the
filesystem and rectify the problem(s)

And here's what I see in dmesg after rebooting and attempting to mount
the filesystem to replay the log:

May 01 21:34:15 tethys kernel: XFS (dm-35): Metadata corruption
detected at xfs_inode_buf_verify+0x168/0x190 [xfs], xfs_inode block
0x1405a0 xfs_inode_buf_verify
May 01 21:34:15 tethys kernel: XFS (dm-35): Unmount and run xfs_repair
May 01 21:34:15 tethys kernel: XFS (dm-35): First 128 bytes of
corrupted metadata buffer:
May 01 21:34:15 tethys kernel: 00000000: 5b 40 e2 3a ae 52 a0 7a 17 1d
5a f6 f0 de 4c 62  [@.:.R.z..Z...Lb
May 01 21:34:15 tethys kernel: 00000010: d6 31 8b 51 ca 6e ad a2 7e f5
18 65 6e 8a 41 3f  .1.Q.n..~..en.A?
May 01 21:34:15 tethys kernel: 00000020: 68 b5 02 16 2c 84 5d 33 ac 46
fc c9 da 93 af 3f  h...,.]3.F.....?
May 01 21:34:15 tethys kernel: 00000030: a0 3e b7 9c b4 99 5a 45 8c 2f
13 ed bb 07 57 e1  .>....ZE./....W.
May 01 21:34:15 tethys kernel: 00000040: bc 96 aa d7 00 2a 81 65 e6 3b
86 9d b5 0a 63 bd  .....*.e.;....c.
May 01 21:34:15 tethys kernel: 00000050: 38 e5 63 1a 09 42 36 4c b8 e8
7c 92 73 01 04 da  8.c..B6L..|.s...
May 01 21:34:15 tethys kernel: 00000060: 27 df 43 92 b1 ad ba ec 7a 02
3f 8e 84 3a bb cc  '.C.....z.?..:..
May 01 21:34:15 tethys kernel: 00000070: 39 06 74 d1 8b 04 b7 f2 62 c1
c4 f0 3c 5c 54 4f  9.t.....b...<\TO
May 01 21:34:15 tethys kernel: XFS (dm-35): metadata I/O error in
"xlog_recover_items_pass2+0x56/0xf0 [xfs]" at daddr 0x1405a0 len 32
error 117
May 01 21:34:15 tethys kernel: XFS (dm-35): log mount/recovery failed:
error -117
May 01 21:34:15 tethys kernel: XFS (dm-35): log mount failed

Blockchain projects tend to generate pathological filesystem loads;
the sustained random write activity and constant (re)allocations must
be pushing on some soft spot here. Reverting to kernel 6.2.14 and
recreating the filesystems seems to have resolved the issue=E2=80=94so far,=
 at
least=E2=80=94but obviously this is less than ideal. If someone would be
willing to provide a targeted listed of desired artifacts I'd be happy
to boot back into kernel 6.3.1 to reproduce the issue and collect
them. Alternatively I can try to eliminate some variables (like LVM2,
potential hardware instabilities, etc.) and provide step-by-step
directions for reproducing the issue on another machine.

Thank you,

Mike
