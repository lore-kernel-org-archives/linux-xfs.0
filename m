Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:35165 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763252AbdAESad (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2017 13:30:33 -0500
Received: by mail-it0-f53.google.com with SMTP id c20so332740993itb.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jan 2017 10:30:33 -0800 (PST)
MIME-Version: 1.0
From: Xingbo Wu <wuxb45@gmail.com>
Date: Thu, 5 Jan 2017 12:02:01 -0600
Message-ID: <CABPa+v3fgLjBo2CLBXxg8xE3D5tWdjk2C3gM2o1-xEFT45_Rkg@mail.gmail.com>
Subject: [BUG] xfs.mkfs recognizes wrong disk size
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

/dev/sdf is a 3TB hard drive.
It has 2930266584 blocks, as reported in `badblocks -wsv /dev/sdf`:
Checking for bad blocks in read-write mode
>From block 0 to 2930266583

However mkfs.xfs reports a larger block count:
`sudo mkfs.xfs /dev/sdf`:
meta-data=3D/dev/sdf               isize=3D512    agcount=3D4, agsize=3D183=
141662 blks
         =3D                       sectsz=3D4096  attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D0, r=
mapbt=3D0
data     =3D                       bsize=3D4096   blocks=3D732566646, imaxp=
ct=3D5
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D357698, version=
=3D2
         =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

It later leads to IO error:
`dmesg`:
[1807875.741674] blk_update_request: I/O error, dev sdf, sector 2930266664
[1807875.741732] blk_update_request: I/O error, dev sdf, sector 2930266664
[1807875.742306] XFS (sdf): metadata I/O error: block 0xaea85228
("xlog_iodone") error 5 numblks 64
[1807875.742369] XFS (sdf): xfs_do_force_shutdown(0x2) called from
line 1200 of file fs/xfs/xfs_log.c.  Return address =3D
0xffffffffa024090c
[1807875.742381] XFS (sdf): Log I/O Error Detected.  Shutting down filesyst=
em
[1807875.742416] XFS (sdf): xfs_log_force: error -5 returned.
[1807875.742426] XFS (sdf): Please umount the filesystem and rectify
the problem(s)
[1807881.868117] XFS (sdf): xfs_log_force: error -5 returned.
[1807910.701836] XFS (sdf): xfs_log_force: error -5 returned.
[1807910.701841] XFS (sdf): Unmounting Filesystem
[1807910.701854] XFS (sdf): xfs_log_force: error -5 returned.
[1807910.701866] XFS (sdf): xfs_log_force: error -5 returned.



The hard drive information:
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST3000DM001-9YN166
Serial Number:    W1F03GXY

--=20

Regards,
        Wu, Xingbo (=E5=90=B4=E5=85=B4=E5=8D=9A)  <wuxb45@gmail.com>
