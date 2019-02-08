Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f176.google.com ([209.85.160.176]:41780 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfBHPtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 10:49:31 -0500
Received: by mail-qt1-f176.google.com with SMTP id b15so4359501qto.8
        for <linux-xfs@vger.kernel.org>; Fri, 08 Feb 2019 07:49:29 -0800 (PST)
From: "Ricardo J. Barberis" <ricardo.barberis@gmail.com>
Subject: Re: Metadata CRC error detected at xfs_dquot_buf_read_verify
Date: Fri, 8 Feb 2019 12:49:24 -0300
References: <201902071309.38999.ricardo.barberis@gmail.com> <20190208131756.GD21317@bfoster>
In-Reply-To: <20190208131756.GD21317@bfoster>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Message-Id: <201902081249.24904.ricardo.barberis@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Linux-XFS list <linux-xfs@vger.kernel.org>

El Viernes 08/02/2019 a las 10:17, Brian Foster escribi=C3=B3:
> On Thu, Feb 07, 2019 at 01:09:38PM -0300, Ricardo J. Barberis wrote:
> > Hello list!
> >=20
> > I'm having a metadata corruption on an XFS filesystem, I googled the er=
ror but
> > didn't find anything about it.
> >=20
> > Background:
> >=20
> > One CentOS 7.6 box with 2 SSD disks and 3 SATA disks.
> > Those disks are synchorized via DRBD with 5 identical disks on another
> > identical box (for HA).
> > The SSDs form an LVM group with one VG and one LV.
> > This LV is then formatted with XFS and mounted with quotas enabled.
> > The SATA disks form another LVM group with one VG and one LV, also form=
atted
> > with XFS and mounted quotas enabled.
> >=20
> > Each pair of servers has keepalived to make sure only one of them puts =
the
> > DRBD resources as primary and can mount the LVs.
> >=20
> > Relevant extract from lsblk:
> > sdb              8:16   0 931,5G  0 disk
> > =E2=94=94=E2=94=80sdb1           8:17   0 931,5G  0 part
> >   =E2=94=94=E2=94=80drbd2      147:2    0 931,5G  0 disk
> >     =E2=94=94=E2=94=80VG2-home 253:4    0   1,8T  0 lvm  /home
> > sdc              8:32   0 894,3G  0 disk
> > =E2=94=94=E2=94=80sdc1           8:33   0 894,3G  0 part
> >   =E2=94=94=E2=94=80drbd3      147:3    0 894,2G  0 disk
> >     =E2=94=94=E2=94=80VG2-home 253:4    0   1,8T  0 lvm  /home
> > sdd              8:48   0 931,5G  0 disk
> > =E2=94=94=E2=94=80sdd1           8:49   0 931,5G  0 part
> >   =E2=94=94=E2=94=80drbd4      147:4    0 931,5G  0 disk
> >     =E2=94=94=E2=94=80VG3-mail 253:0    0   2,7T  0 lvm
> >       =E2=94=94=E2=94=80mail   253:5    0   2,7T  0 dm   /Mails
> > sde              8:64   0 931,5G  0 disk
> > =E2=94=94=E2=94=80sde1           8:65   0 931,5G  0 part
> >   =E2=94=94=E2=94=80drbd5      147:5    0 931,5G  0 disk
> >     =E2=94=94=E2=94=80VG3-mail 253:0    0   2,7T  0 lvm
> >       =E2=94=94=E2=94=80mail   253:5    0   2,7T  0 dm   /Mails
> > sdf              8:80   0 931,5G  0 disk
> > =E2=94=94=E2=94=80sdf1           8:81   0 931,5G  0 part
> >   =E2=94=94=E2=94=80drbd6      147:6    0 931,5G  0 disk
> >     =E2=94=94=E2=94=80VG3-mail 253:0    0   2,7T  0 lvm
> >       =E2=94=94=E2=94=80mail   253:5    0   2,7T  0 dm   /Mails
> >=20
> >=20
> > We have several pairs of servers with this same configuration, but on t=
his
> > particular pair of boxes we're getting metadata corruption only on the =
SSD LV
> > and quotas don't get accounted for, dmesg shows these errors on the pri=
mary box:
> >=20
>=20
> I assume there are different workloads between the two volumes as well,
> based on the naming above at least, and that dm-4 is the VG2-home volume
> above..?

Yes, that's correct.

> Either way, can you provide the xfs_info for the associated filesystem?

Sure thing:

[root@c142a ~] # xfs_info /home
meta-data=3D/dev/mapper/VG2-home   isize=3D512    agcount=3D32, agsize=3D14=
651136 blks
         =3D                       sectsz=3D4096  attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D0 spinodes=3D0
data     =3D                       bsize=3D4096   blocks=3D468830208, imaxp=
ct=3D5
         =3D                       sunit=3D256    swidth=3D512 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
log      =3Dinternal               bsize=3D4096   blocks=3D228921, version=
=3D2
         =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

[root@c142a ~] # xfs_info /Mails
meta-data=3D/dev/mapper/mail       isize=3D512    agcount=3D32, agsize=3D22=
892288 blks
         =3D                       sectsz=3D4096  attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D0 spinodes=3D0
data     =3D                       bsize=3D4096   blocks=3D732546048, imaxp=
ct=3D5
         =3D                       sunit=3D256    swidth=3D768 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
log      =3Dinternal               bsize=3D4096   blocks=3D357688, version=
=3D2
         =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

=20
> > [root@c142a ~] # dmesg -T | grep XFS
> > [mi=C3=A9 feb  6 18:43:03 2019] SGI XFS with ACLs, security attributes,=
 no debug enabled
> > [mi=C3=A9 feb  6 18:43:03 2019] XFS (dm-4): Mounting V5 Filesystem
> > [mi=C3=A9 feb  6 18:43:03 2019] XFS (dm-4): Starting recovery (logdev: =
internal)
>=20
> What happened to require log recovery in the first place?

At that time c142b was acting as primary and crashed, so c142a took over.

We were having some issues with these two servers, power loss in a couple of
cases, and c142b crashed a few times also, we had to change power supplies =
and
RAM.

> > [mi=C3=A9 feb  6 18:43:04 2019] XFS (dm-4): Metadata CRC error detected=
 at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [mi=C3=A9 feb  6 18:43:04 2019] XFS (dm-4): Unmount and run xfs_repair
> > [mi=C3=A9 feb  6 18:43:04 2019] XFS (dm-4): First 64 bytes of corrupted=
 metadata buffer:
> > [mi=C3=A9 feb  6 18:43:04 2019] XFS (dm-4): metadata I/O error: block 0=
x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> > [mi=C3=A9 feb  6 18:43:04 2019] XFS (dm-4): log mount/recovery failed: =
error -117
> > [mi=C3=A9 feb  6 18:43:04 2019] XFS (dm-4): log mount failed
>=20
> So log recovery and the mount failed. Is this where you ran
> xfs_repair?

Yes, I was informed that c142b crashed and c142a didn't mount /home, xfs_re=
pair
complained about the log and had to use -L to "fix" it :(

> > [mi=C3=A9 feb  6 18:48:52 2019] XFS (dm-5): Mounting V5 Filesystem
> > [mi=C3=A9 feb  6 18:48:52 2019] XFS (dm-5): Ending clean mount
> > [mi=C3=A9 feb  6 18:48:59 2019] XFS (dm-5): Unmounting Filesystem
> > [mi=C3=A9 feb  6 18:57:25 2019] XFS (dm-4): Mounting V5 Filesystem
> > [mi=C3=A9 feb  6 18:57:25 2019] XFS (dm-4): Ending clean mount
> > [mi=C3=A9 feb  6 18:57:25 2019] XFS (dm-4): Quotacheck needed: Please w=
ait.
>=20
> Then the mount succeeds (repair presumably zapped the log), a quotacheck
> was required and before that even completes we run into the same issue.

Yes, it mounted fine but doing a "xfs_quota -x -c 'report /home -b'" trigge=
red the
error again.

> > [mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): Metadata CRC error detected=
 at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): Unmount and run xfs_repair
> > [mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): First 64 bytes of corrupted=
 metadata buffer:
> > [mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): Metadata CRC error detected=
 at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): Unmount and run xfs_repair
> > [mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): First 64 bytes of corrupted=
 metadata buffer:
> > [mi=C3=A9 feb  6 18:57:26 2019] XFS (dm-4): metadata I/O error: block 0=
x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> > [mi=C3=A9 feb  6 18:57:52 2019] XFS (dm-4): Quotacheck: Done.
> > [mi=C3=A9 feb  6 18:58:13 2019] XFS (dm-4): Unmounting Filesystem
> > [mi=C3=A9 feb  6 18:58:15 2019] XFS (dm-4): Mounting V5 Filesystem
> > [mi=C3=A9 feb  6 18:58:15 2019] XFS (dm-4): Ending clean mount
> > [mi=C3=A9 feb  6 18:58:27 2019] XFS (dm-4): Unmounting Filesystem
> > [mi=C3=A9 feb  6 19:01:12 2019] XFS (dm-5): Mounting V5 Filesystem
> > [mi=C3=A9 feb  6 19:01:12 2019] XFS (dm-5): Ending clean mount
> > [mi=C3=A9 feb  6 19:01:12 2019] XFS (dm-4): Mounting V5 Filesystem
> > [mi=C3=A9 feb  6 19:01:12 2019] XFS (dm-4): Ending clean mount
> > [mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): Metadata CRC error detected=
 at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): Unmount and run xfs_repair
> > [mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): First 64 bytes of corrupted=
 metadata buffer:
> > [mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): metadata I/O error: block 0=
x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> > [mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): Metadata CRC error detected=
 at xfs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): Unmount and run xfs_repair
> > [mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): First 64 bytes of corrupted=
 metadata buffer:
> > [mi=C3=A9 feb  6 19:03:08 2019] XFS (dm-4): metadata I/O error: block 0=
x4170 ("xfs_trans_read_buf_map") error 74 numblks 8
> >=20
> >=20
> > We tried xfs_repair but it doesn't seem to fix it.
> >=20
>=20
> Does xfs_repair find and fix anything? Please show the associated repair
> output.

Unfotunately I didn't save xfs_repair output, but I don't believe it fixed
anything other than the log that first time.

> > We then promoted the secondary and tried xfs_repair there, fearing some=
 memory
> > issues on the primary, but the result is the same:
> >=20
>=20
> I'm not terribly familiar with drbd. I assume this means the primary was
> offlined and the secondary onlined. IOW, these two filesystems are not
> ever simultaneously active, correct?

That's correct (drbd has an option to disable that behaviour if you want to=
 use it
with a clustered filesystem but it's off by default and we never use it).

> Brian


I see that below I pasted an older dmesg log I had, sorry for that.

> > [root@c142b ~] # dmesg -T | grep XFS
> > [jue ene 31 19:14:12 2019] SGI XFS with ACLs, security attributes, no d=
ebug enabled
> > [jue ene 31 19:14:12 2019] XFS (dm-4): Mounting V5 Filesystem
> > [jue ene 31 19:14:12 2019] XFS (dm-4): Ending clean mount
> > [jue ene 31 19:22:20 2019] XFS (dm-4): Unmounting Filesystem
> > [jue ene 31 19:23:24 2019] XFS (dm-5): Mounting V5 Filesystem
> > [jue ene 31 19:23:24 2019] XFS (dm-5): Ending clean mount
> > [jue ene 31 19:23:24 2019] XFS (dm-4): Mounting V5 Filesystem
> > [jue ene 31 19:23:24 2019] XFS (dm-4): Ending clean mount
> > [jue ene 31 19:25:21 2019] XFS (dm-4): Unmounting Filesystem
> > [jue ene 31 19:26:14 2019] XFS (dm-4): Mounting V5 Filesystem
> > [jue ene 31 19:26:14 2019] XFS (dm-4): Ending clean mount
> > [jue ene 31 19:26:14 2019] XFS (dm-4): Quotacheck needed: Please wait.
> > [jue ene 31 19:26:14 2019] XFS (dm-4): Metadata CRC error detected at x=
fs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [jue ene 31 19:26:14 2019] XFS (dm-4): Unmount and run xfs_repair
> > [jue ene 31 19:26:14 2019] XFS (dm-4): First 64 bytes of corrupted meta=
data buffer:
> > [jue ene 31 19:26:14 2019] XFS (dm-4): Metadata CRC error detected at x=
fs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [jue ene 31 19:26:14 2019] XFS (dm-4): Unmount and run xfs_repair
> > [jue ene 31 19:26:14 2019] XFS (dm-4): First 64 bytes of corrupted meta=
data buffer:
> > [jue ene 31 19:26:14 2019] XFS (dm-4): metadata I/O error: block 0x4170=
 ("xfs_trans_read_buf_map") error 74 numblks 8
> > [jue ene 31 19:26:40 2019] XFS (dm-4): Quotacheck: Done.
> > [jue ene 31 19:34:31 2019] XFS (dm-5): Unmounting Filesystem
> > [jue ene 31 19:35:13 2019] XFS (dm-4): Unmounting Filesystem
> > [jue ene 31 19:46:33 2019] XFS (dm-5): Mounting V5 Filesystem
> > [jue ene 31 19:46:34 2019] XFS (dm-5): Ending clean mount
> > [jue ene 31 19:46:34 2019] XFS (dm-4): Mounting V5 Filesystem
> > [jue ene 31 19:46:34 2019] XFS (dm-4): Ending clean mount
> > [jue ene 31 19:47:18 2019] XFS (dm-4): Unmounting Filesystem
> > [jue ene 31 19:47:21 2019] XFS (dm-4): Mounting V5 Filesystem
> > [jue ene 31 19:47:21 2019] XFS (dm-4): Ending clean mount
> > [jue ene 31 19:47:29 2019] XFS (dm-4): Unmounting Filesystem
> > [jue ene 31 19:50:28 2019] XFS (dm-4): Mounting V5 Filesystem
> > [jue ene 31 19:50:28 2019] XFS (dm-4): Ending clean mount
> > [jue ene 31 19:50:28 2019] XFS (dm-4): Quotacheck needed: Please wait.
> > [jue ene 31 19:50:28 2019] XFS (dm-4): Metadata CRC error detected at x=
fs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [jue ene 31 19:50:28 2019] XFS (dm-4): Unmount and run xfs_repair
> > [jue ene 31 19:50:28 2019] XFS (dm-4): First 64 bytes of corrupted meta=
data buffer:
> > [jue ene 31 19:50:28 2019] XFS (dm-4): Metadata CRC error detected at x=
fs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [jue ene 31 19:50:28 2019] XFS (dm-4): Unmount and run xfs_repair
> > [jue ene 31 19:50:28 2019] XFS (dm-4): First 64 bytes of corrupted meta=
data buffer:
> > [jue ene 31 19:50:28 2019] XFS (dm-4): metadata I/O error: block 0x4170=
 ("xfs_trans_read_buf_map") error 74 numblks 8
> > [jue ene 31 19:50:54 2019] XFS (dm-4): Quotacheck: Done.
> >=20
> >=20
> > This is a more complete extract of dmesg, where I noticed some context =
lines
> > that might be useful:
> >=20
> > [Thu Feb  7 12:06:45 2019] XFS (dm-4): Metadata CRC error detected at x=
fs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [Thu Feb  7 12:06:45 2019] XFS (dm-4): Unmount and run xfs_repair
> > [Thu Feb  7 12:06:45 2019] XFS (dm-4): First 64 bytes of corrupted meta=
data buffer:
> > [Thu Feb  7 12:06:45 2019] ffffa0002708a000: 44 51 01 01 00 00 d7 82 00=
 00 00 00 00 00 00 00  DQ..............
> > [Thu Feb  7 12:06:45 2019] ffffa0002708a010: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00  ................
> > [Thu Feb  7 12:06:45 2019] ffffa0002708a020: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00  ................
> > [Thu Feb  7 12:06:45 2019] ffffa0002708a030: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00  ................
> > [Thu Feb  7 12:06:45 2019] XFS (dm-4): metadata I/O error: block 0x4170=
 ("xfs_trans_read_buf_map") error 74 numblks 8
> > [Thu Feb  7 12:06:45 2019] XFS (dm-4): Metadata CRC error detected at x=
fs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [Thu Feb  7 12:06:45 2019] XFS (dm-4): Unmount and run xfs_repair
> > [Thu Feb  7 12:06:45 2019] XFS (dm-4): First 64 bytes of corrupted meta=
data buffer:
> > [Thu Feb  7 12:06:45 2019] ffffa003bdb3b000: 44 51 01 01 00 00 d7 82 00=
 00 00 00 00 00 00 00  DQ..............
> > [Thu Feb  7 12:06:45 2019] ffffa003bdb3b010: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00  ................
> > [Thu Feb  7 12:06:45 2019] ffffa003bdb3b020: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00  ................
> > [Thu Feb  7 12:06:45 2019] ffffa003bdb3b030: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00  ................
> > [Thu Feb  7 12:06:45 2019] XFS (dm-4): metadata I/O error: block 0x4170=
 ("xfs_trans_read_buf_map") error 74 numblks 8
> > [Thu Feb  7 13:03:43 2019] XFS (dm-4): Metadata CRC error detected at x=
fs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [Thu Feb  7 13:03:43 2019] XFS (dm-4): Unmount and run xfs_repair
> > [Thu Feb  7 13:03:43 2019] XFS (dm-4): First 64 bytes of corrupted meta=
data buffer:
> > [Thu Feb  7 13:03:43 2019] ffffa001427e8000: 44 51 01 01 00 00 d7 82 00=
 00 00 00 00 00 00 00  DQ..............
> > [Thu Feb  7 13:03:43 2019] ffffa001427e8010: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00  ................
> > [Thu Feb  7 13:03:43 2019] ffffa001427e8020: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00  ................
> > [Thu Feb  7 13:03:43 2019] ffffa001427e8030: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00  ................
> > [Thu Feb  7 13:03:43 2019] XFS (dm-4): metadata I/O error: block 0x4170=
 ("xfs_trans_read_buf_map") error 74 numblks 8
> > [Thu Feb  7 13:03:43 2019] XFS (dm-4): Metadata CRC error detected at x=
fs_dquot_buf_read_verify+0x4f/0x90 [xfs], xfs_dquot block 0x4170
> > [Thu Feb  7 13:03:43 2019] XFS (dm-4): Unmount and run xfs_repair
> > [Thu Feb  7 13:03:43 2019] XFS (dm-4): First 64 bytes of corrupted meta=
data buffer:
> > [Thu Feb  7 13:03:43 2019] ffffa004a3ef1000: 44 51 01 01 00 00 d7 82 00=
 00 00 00 00 00 00 00  DQ..............
> > [Thu Feb  7 13:03:43 2019] ffffa004a3ef1010: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00  ................
> > [Thu Feb  7 13:03:43 2019] ffffa004a3ef1020: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00  ................
> > [Thu Feb  7 13:03:43 2019] ffffa004a3ef1030: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00  ................
> > [Thu Feb  7 13:03:43 2019] XFS (dm-4): metadata I/O error: block 0x4170=
 ("xfs_trans_read_buf_map") error 74 numblks 8
> >=20
> >=20
> > Is there anything else I can try?
> > Any more info needed?
> > Should I open a bug report instead?
> >=20
> > I can compile a newr version of xfsprogs but I don't know if it'll help.
> >=20
> >=20
> > Thanks,
=2D-=20
Ricardo J. Barberis
Usuario Linux N=C2=BA 250625: http://counter.li.org/
Usuario LFS N=C2=BA 5121: http://www.linuxfromscratch.org/
Senior SysAdmin / IT Architect - www.DonWeb.com
