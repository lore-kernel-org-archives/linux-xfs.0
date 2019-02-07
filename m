Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f175.google.com ([209.85.222.175]:33184 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfBGQJp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Feb 2019 11:09:45 -0500
Received: by mail-qk1-f175.google.com with SMTP id x9so262100qkf.0
        for <linux-xfs@vger.kernel.org>; Thu, 07 Feb 2019 08:09:43 -0800 (PST)
Received: from hardy (zion.dattaweb.com. [200.58.112.191])
        by smtp.gmail.com with ESMTPSA id 12sm56283885qka.83.2019.02.07.08.09.41
        for <linux-xfs@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 07 Feb 2019 08:09:41 -0800 (PST)
From: "Ricardo J. Barberis" <ricardo.barberis@gmail.com>
Subject: Metadata CRC error detected at xfs_dquot_buf_read_verify
Date: Thu, 7 Feb 2019 13:09:38 -0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Message-Id: <201902071309.38999.ricardo.barberis@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS list <linux-xfs@vger.kernel.org>

Hello list!

I'm having a metadata corruption on an XFS filesystem, I googled the error =
but
didn't find anything about it.

Background:

One CentOS 7.6 box with 2 SSD disks and 3 SATA disks.
Those disks are synchorized via DRBD with 5 identical disks on another
identical box (for HA).
The SSDs form an LVM group with one VG and one LV.
This LV is then formatted with XFS and mounted with quotas enabled.
The SATA disks form another LVM group with one VG and one LV, also formatted
with XFS and mounted quotas enabled.

Each pair of servers has keepalived to make sure only one of them puts the
DRBD resources as primary and can mount the LVs.

Relevant extract from lsblk:
sdb              8:16   0 931,5G  0 disk
=E2=94=94=E2=94=80sdb1           8:17   0 931,5G  0 part
  =E2=94=94=E2=94=80drbd2      147:2    0 931,5G  0 disk
    =E2=94=94=E2=94=80VG2-home 253:4    0   1,8T  0 lvm  /home
sdc              8:32   0 894,3G  0 disk
=E2=94=94=E2=94=80sdc1           8:33   0 894,3G  0 part
  =E2=94=94=E2=94=80drbd3      147:3    0 894,2G  0 disk
    =E2=94=94=E2=94=80VG2-home 253:4    0   1,8T  0 lvm  /home
sdd              8:48   0 931,5G  0 disk
=E2=94=94=E2=94=80sdd1           8:49   0 931,5G  0 part
  =E2=94=94=E2=94=80drbd4      147:4    0 931,5G  0 disk
    =E2=94=94=E2=94=80VG3-mail 253:0    0   2,7T  0 lvm
      =E2=94=94=E2=94=80mail   253:5    0   2,7T  0 dm   /Mails
sde              8:64   0 931,5G  0 disk
=E2=94=94=E2=94=80sde1           8:65   0 931,5G  0 part
  =E2=94=94=E2=94=80drbd5      147:5    0 931,5G  0 disk
    =E2=94=94=E2=94=80VG3-mail 253:0    0   2,7T  0 lvm
      =E2=94=94=E2=94=80mail   253:5    0   2,7T  0 dm   /Mails
sdf              8:80   0 931,5G  0 disk
=E2=94=94=E2=94=80sdf1           8:81   0 931,5G  0 part
  =E2=94=94=E2=94=80drbd6      147:6    0 931,5G  0 disk
    =E2=94=94=E2=94=80VG3-mail 253:0    0   2,7T  0 lvm
      =E2=94=94=E2=94=80mail   253:5    0   2,7T  0 dm   /Mails


We have several pairs of servers with this same configuration, but on this
particular pair of boxes we're getting metadata corruption only on the SSD =
LV
and quotas don't get accounted for, dmesg shows these errors on the primary=
 box:

[root@c142a ~] # dmesg -T | grep XFS
[mi=C3=A9 feb  6 18:43:03 2019] SGI XFS with ACLs, security attributes, no =
debug enabled
[mi=C3=A9 feb  6 18:43:03 2019] XFS (dm-4): Mounting V5 Filesystem
[mi=C3=A9 feb  6 18:43:03 2019] XFS (dm-4): Starting recovery (logdev: inte=
rnal)
[mi=C3=A9 feb  6 18:43:04 2019] XFS (dm-4): Metadata CRC error detected at =
xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[mi=C3=A9 feb  6 18:43:04 2019] XFS (dm-4): Unmount and run xfs_repair
[mi=C3=A9 feb  6 18:43:04 2019] XFS (dm-4): First 64 bytes of corrupted met=
adata buffer:
[mi=C3=A9 feb  6 18:43:04 2019] XFS (dm-4): metadata I/O error: block 0x417=
0 ("xfs_trans_read_buf_map") error 74 numblks 8
[mi=C3=A9 feb  6 18:43:04 2019] XFS (dm-4): log mount/recovery failed: erro=
r -117
[mi=C3=A9 feb  6 18:43:04 2019] XFS (dm-4): log mount failed
[mi=C3=A9 feb  6 18:48:52 2019] XFS (dm-5): Mounting V5 Filesystem
[mi=C3=A9 feb  6 18:48:52 2019] XFS (dm-5): Ending clean mount
[mi=C3=A9 feb  6 18:48:59 2019] XFS (dm-5): Unmounting Filesystem
[mi=C3=A9 feb  6 18:57:25 2019] XFS (dm-4): Mounting V5 Filesystem
[mi=C3=A9 feb  6 18:57:25 2019] XFS (dm-4): Ending clean mount
[mi=C3=A9 feb  6 18:57:25 2019] XFS (dm-4): Quotacheck needed: Please wait.
[mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): Metadata CRC error detected at =
xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): Unmount and run xfs_repair
[mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): First 64 bytes of corrupted met=
adata buffer:
[mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): Metadata CRC error detected at =
xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): Unmount and run xfs_repair
[mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): First 64 bytes of corrupted met=
adata buffer:
[mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): metadata I/O error: block 0x417=
0 ("xfs_trans_read_buf_map") error 74 numblks 8
[mi=C3=A9 feb  6 18:57:52 2019] XFS (dm-4): Quotacheck: Done.
[mi=C3=A9 feb  6 18:58:13 2019] XFS (dm-4): Unmounting Filesystem
[mi=C3=A9 feb  6 18:58:15 2019] XFS (dm-4): Mounting V5 Filesystem
[mi=C3=A9 feb  6 18:58:15 2019] XFS (dm-4): Ending clean mount
[mi=C3=A9 feb  6 18:58:27 2019] XFS (dm-4): Unmounting Filesystem
[mi=C3=A9 feb  6 19:01:12 2019] XFS (dm-5): Mounting V5 Filesystem
[mi=C3=A9 feb  6 19:01:12 2019] XFS (dm-5): Ending clean mount
[mi=C3=A9 feb  6 19:01:12 2019] XFS (dm-4): Mounting V5 Filesystem
[mi=C3=A9 feb  6 19:01:12 2019] XFS (dm-4): Ending clean mount
[mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): Metadata CRC error detected at =
xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): Unmount and run xfs_repair
[mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): First 64 bytes of corrupted met=
adata buffer:
[mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): metadata I/O error: block 0x417=
0 ("xfs_trans_read_buf_map") error 74 numblks 8
[mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): Metadata CRC error detected at =
xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): Unmount and run xfs_repair
[mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): First 64 bytes of corrupted met=
adata buffer:
[mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): metadata I/O error: block 0x417=
0 ("xfs_trans_read_buf_map") error 74 numblks 8


We tried xfs_repair but it doesn't seem to fix it.

We then promoted the secondary and tried xfs_repair there, fearing some mem=
ory
issues on the primary, but the result is the same:

[root@c142b ~] # dmesg -T | grep XFS
[jue ene 31 19:14:12 2019] SGI XFS with ACLs, security attributes, no debug=
 enabled
[jue ene 31 19:14:12 2019] XFS (dm-4): Mounting V5 Filesystem
[jue ene 31 19:14:12 2019] XFS (dm-4): Ending clean mount
[jue ene 31 19:22:20 2019] XFS (dm-4): Unmounting Filesystem
[jue ene 31 19:23:24 2019] XFS (dm-5): Mounting V5 Filesystem
[jue ene 31 19:23:24 2019] XFS (dm-5): Ending clean mount
[jue ene 31 19:23:24 2019] XFS (dm-4): Mounting V5 Filesystem
[jue ene 31 19:23:24 2019] XFS (dm-4): Ending clean mount
[jue ene 31 19:25:21 2019] XFS (dm-4): Unmounting Filesystem
[jue ene 31 19:26:14 2019] XFS (dm-4): Mounting V5 Filesystem
[jue ene 31 19:26:14 2019] XFS (dm-4): Ending clean mount
[jue ene 31 19:26:14 2019] XFS (dm-4): Quotacheck needed: Please wait.
[jue ene 31 19:26:14 2019] XFS (dm-4): Metadata CRC error detected at xfs_d=
quot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[jue ene 31 19:26:14 2019] XFS (dm-4): Unmount and run xfs_repair
[jue ene 31 19:26:14 2019] XFS (dm-4): First 64 bytes of corrupted metadata=
 buffer:
[jue ene 31 19:26:14 2019] XFS (dm-4): Metadata CRC error detected at xfs_d=
quot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[jue ene 31 19:26:14 2019] XFS (dm-4): Unmount and run xfs_repair
[jue ene 31 19:26:14 2019] XFS (dm-4): First 64 bytes of corrupted metadata=
 buffer:
[jue ene 31 19:26:14 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("x=
fs_trans_read_buf_map") error 74 numblks 8
[jue ene 31 19:26:40 2019] XFS (dm-4): Quotacheck: Done.
[jue ene 31 19:34:31 2019] XFS (dm-5): Unmounting Filesystem
[jue ene 31 19:35:13 2019] XFS (dm-4): Unmounting Filesystem
[jue ene 31 19:46:33 2019] XFS (dm-5): Mounting V5 Filesystem
[jue ene 31 19:46:34 2019] XFS (dm-5): Ending clean mount
[jue ene 31 19:46:34 2019] XFS (dm-4): Mounting V5 Filesystem
[jue ene 31 19:46:34 2019] XFS (dm-4): Ending clean mount
[jue ene 31 19:47:18 2019] XFS (dm-4): Unmounting Filesystem
[jue ene 31 19:47:21 2019] XFS (dm-4): Mounting V5 Filesystem
[jue ene 31 19:47:21 2019] XFS (dm-4): Ending clean mount
[jue ene 31 19:47:29 2019] XFS (dm-4): Unmounting Filesystem
[jue ene 31 19:50:28 2019] XFS (dm-4): Mounting V5 Filesystem
[jue ene 31 19:50:28 2019] XFS (dm-4): Ending clean mount
[jue ene 31 19:50:28 2019] XFS (dm-4): Quotacheck needed: Please wait.
[jue ene 31 19:50:28 2019] XFS (dm-4): Metadata CRC error detected at xfs_d=
quot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[jue ene 31 19:50:28 2019] XFS (dm-4): Unmount and run xfs_repair
[jue ene 31 19:50:28 2019] XFS (dm-4): First 64 bytes of corrupted metadata=
 buffer:
[jue ene 31 19:50:28 2019] XFS (dm-4): Metadata CRC error detected at xfs_d=
quot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[jue ene 31 19:50:28 2019] XFS (dm-4): Unmount and run xfs_repair
[jue ene 31 19:50:28 2019] XFS (dm-4): First 64 bytes of corrupted metadata=
 buffer:
[jue ene 31 19:50:28 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("x=
fs_trans_read_buf_map") error 74 numblks 8
[jue ene 31 19:50:54 2019] XFS (dm-4): Quotacheck: Done.


This is a more complete extract of dmesg, where I noticed some context lines
that might be useful:

[Thu Feb  7 12:06:45 2019] XFS (dm-4): Metadata CRC error detected at xfs_d=
quot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[Thu Feb  7 12:06:45 2019] XFS (dm-4): Unmount and run xfs_repair
[Thu Feb  7 12:06:45 2019] XFS (dm-4): First 64 bytes of corrupted metadata=
 buffer:
[Thu Feb  7 12:06:45 2019] ffffa0002708a000: 44 51 01 01 00 00 d7 82 00 00 =
00 00 00 00 00 00  DQ..............
[Thu Feb  7 12:06:45 2019] ffffa0002708a010: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00  ................
[Thu Feb  7 12:06:45 2019] ffffa0002708a020: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00  ................
[Thu Feb  7 12:06:45 2019] ffffa0002708a030: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00  ................
[Thu Feb  7 12:06:45 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("x=
fs_trans_read_buf_map") error 74 numblks 8
[Thu Feb  7 12:06:45 2019] XFS (dm-4): Metadata CRC error detected at xfs_d=
quot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[Thu Feb  7 12:06:45 2019] XFS (dm-4): Unmount and run xfs_repair
[Thu Feb  7 12:06:45 2019] XFS (dm-4): First 64 bytes of corrupted metadata=
 buffer:
[Thu Feb  7 12:06:45 2019] ffffa003bdb3b000: 44 51 01 01 00 00 d7 82 00 00 =
00 00 00 00 00 00  DQ..............
[Thu Feb  7 12:06:45 2019] ffffa003bdb3b010: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00  ................
[Thu Feb  7 12:06:45 2019] ffffa003bdb3b020: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00  ................
[Thu Feb  7 12:06:45 2019] ffffa003bdb3b030: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00  ................
[Thu Feb  7 12:06:45 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("x=
fs_trans_read_buf_map") error 74 numblks 8
[Thu Feb  7 13:03:43 2019] XFS (dm-4): Metadata CRC error detected at xfs_d=
quot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[Thu Feb  7 13:03:43 2019] XFS (dm-4): Unmount and run xfs_repair
[Thu Feb  7 13:03:43 2019] XFS (dm-4): First 64 bytes of corrupted metadata=
 buffer:
[Thu Feb  7 13:03:43 2019] ffffa001427e8000: 44 51 01 01 00 00 d7 82 00 00 =
00 00 00 00 00 00  DQ..............
[Thu Feb  7 13:03:43 2019] ffffa001427e8010: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00  ................
[Thu Feb  7 13:03:43 2019] ffffa001427e8020: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00  ................
[Thu Feb  7 13:03:43 2019] ffffa001427e8030: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00  ................
[Thu Feb  7 13:03:43 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("x=
fs_trans_read_buf_map") error 74 numblks 8
[Thu Feb  7 13:03:43 2019] XFS (dm-4): Metadata CRC error detected at xfs_d=
quot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
[Thu Feb  7 13:03:43 2019] XFS (dm-4): Unmount and run xfs_repair
[Thu Feb  7 13:03:43 2019] XFS (dm-4): First 64 bytes of corrupted metadata=
 buffer:
[Thu Feb  7 13:03:43 2019] ffffa004a3ef1000: 44 51 01 01 00 00 d7 82 00 00 =
00 00 00 00 00 00  DQ..............
[Thu Feb  7 13:03:43 2019] ffffa004a3ef1010: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00  ................
[Thu Feb  7 13:03:43 2019] ffffa004a3ef1020: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00  ................
[Thu Feb  7 13:03:43 2019] ffffa004a3ef1030: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00  ................
[Thu Feb  7 13:03:43 2019] XFS (dm-4): metadata I/O error: block 0x4170 ("x=
fs_trans_read_buf_map") error 74 numblks 8


Is there anything else I can try?
Any more info needed?
Should I open a bug report instead?

I can compile a newr version of xfsprogs but I don't know if it'll help.


Thanks,
=2D-=20
Ricardo J. Barberis
Usuario Linux N=C2=BA 250625: http://counter.li.org/
Usuario LFS N=C2=BA 5121: http://www.linuxfromscratch.org/
Senior SysAdmin / IT Architect - www.DonWeb.com
