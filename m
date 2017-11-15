Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:56867 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757328AbdKOXVB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 18:21:01 -0500
Received: by mail-ot0-f182.google.com with SMTP id j29so17613236oth.13
        for <linux-xfs@vger.kernel.org>; Wed, 15 Nov 2017 15:21:01 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 15 Nov 2017 16:20:59 -0700
Message-ID: <CAJCQCtR1eLc3n-19po0z8eF3tcmj6rxuPK6fcJft=swuCGSVwA@mail.gmail.com>
Subject: LVM thinp, mkfs "device is not properly aligned"
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>

# mkfs.xfs /dev/mapper/vg-timemachine
warning: device is not properly aligned /dev/mapper/vg-timemachine
Use -f to force usage of a misaligned device

kernel:  4.13.12-300.fc27.x86_64
xfsprogs-4.12.0-4.fc27.x86_64

Model Family:     Seagate Barracuda 2.5 5400
Device Model:     ST2000LM015-2E8174


Reproduce steps:

1. Partitioning of the physical device, partition 5 is the relevant one

# gdisk -l /dev/sda

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048       104859647   50.0 GiB    8300  fedoraroot
   2       104859648      2252343295   1024.0 GiB  FFFF  brick1
   3      2252343296      2252752895   200.0 MiB   EF00  EFI System
   4      2252752896      2254850047   1024.0 MiB  8300  fedoraboot
   5      2254850048      3907029134   787.8 GiB   8E00  Linux LVM


2. Make sda5 a pv, create a vg, just defaults here.

3. create thin pool, and virtual size LV

# lvcreate -T vg/thintastic -L 700G
# lvcreate -V 200G -T vg/thintastic -n timemachine

4. That gets me here:

# pvs
  PV         VG Fmt  Attr PSize    PFree
  /dev/sda5  vg lvm2 a--  <787.79g <83.62g

# vgs
  VG #PV #LV #SN Attr   VSize    VFree
  vg   1   3   0 wz--n- <787.79g <83.62g

# lvs
  LV          VG Attr       LSize   Pool       Origin Data%  Meta%
Move Log Cpy%Sync Convert
  cryptoswap  vg -wi-ao----   4.00g
  thintastic  vg twi-aotz-- 700.00g                   0.00   0.44
  timemachine vg Vwi-a-tz-- 200.00g thintastic        0.00


# blockdev --getss /dev/mapper/vg-timemachine
512
# blockdev --getpbsz /dev/mapper/vg-timemachine
4096
# blockdev --getalignoff /dev/mapper/vg-timemachine
512


$ lsblk -t

pretty version (expires in 1 month)
https://pastebin.mozilla.org/9072860

for the list archive:
NAME                      ALIGNMENT MIN-IO   OPT-IO PHY-SEC LOG-SEC
ROTA SCHED RQ-SIZE  RA WSAME
sda                               0   4096        0    4096     512
1 cfq       128 128    0B
=E2=94=9C=E2=94=80sda1                            0   4096        0    4096=
     512
1 cfq       128 128    0B
=E2=94=9C=E2=94=80sda2                            0   4096        0    4096=
     512
1 cfq       128 128    0B
=E2=94=82 =E2=94=94=E2=94=80brick1                      512   4096        0=
    4096     512
1           128 128    0B
=E2=94=9C=E2=94=80sda3                            0   4096        0    4096=
     512
1 cfq       128 128    0B
=E2=94=9C=E2=94=80sda4                            0   4096        0    4096=
     512
1 cfq       128 128    0B
=E2=94=94=E2=94=80sda5                            0   4096        0    4096=
     512
1 cfq       128 128    0B
  =E2=94=9C=E2=94=80vg-cryptoswap               512   4096        0    4096=
     512
1           128 128    0B
  =E2=94=82 =E2=94=94=E2=94=80swap                      512   4096        0=
    4096     512
1           128 128    0B
  =E2=94=9C=E2=94=80vg-thintastic_tmeta         512   4096        0    4096=
     512
1           128 128    0B
  =E2=94=82 =E2=94=94=E2=94=80vg-thintastic-tpool       512 524288   524288=
    4096     512
1           128 128    0B
  =E2=94=82   =E2=94=9C=E2=94=80vg-thintastic           512 524288   524288=
    4096     512
1           128 128    0B
  =E2=94=82   =E2=94=94=E2=94=80vg-timemachine          512 524288   524288=
    4096     512
1           128 128    0B
  =E2=94=94=E2=94=80vg-thintastic_tdata         512   4096        0    4096=
     512
1           128 128    0B
    =E2=94=94=E2=94=80vg-thintastic-tpool       512 524288   524288    4096=
     512
1           128 128    0B
      =E2=94=9C=E2=94=80vg-thintastic           512 524288   524288    4096=
     512
1           128 128    0B
      =E2=94=94=E2=94=80vg-timemachine          512 524288   524288    4096=
     512
1           128 128    0B



So I have no idea what mkfs.xfs is complaining about being unaligned.
If I go ahead and use -f:


# mkfs.xfs -f /dev/mapper/vg-timemachine
warning: device is not properly aligned /dev/mapper/vg-timemachine
meta-data=3D/dev/mapper/vg-timemachine isize=3D512    agcount=3D16,
agsize=3D3276672 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D0,
rmapbt=3D0, reflink=3D0
data     =3D                       bsize=3D4096   blocks=3D52426752, imaxpc=
t=3D25
         =3D                       sunit=3D128    swidth=3D128 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D25600, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D8 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
#



--=20
Chris Murphy
