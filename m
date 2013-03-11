Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A1357F37
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 16:57:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 42761304067
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 14:57:03 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 1JDoX88LZJsGtXKM for
	<xfs@oss.sgi.com>; Mon, 11 Mar 2013 14:57:02 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Maximum file system size of XFS?
Date: Mon, 11 Mar 2013 22:57:00 +0100
References: <20130309215121.0e614ef8@thinky>
	<201303112245.40522.Martin@lichtvoll.de>
	(sfid-20130311_224628_172977_9582C9EE)
In-Reply-To: <201303112245.40522.Martin@lichtvoll.de>
MIME-Version: 1.0
Message-Id: <201303112257.00798.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Pascal <pa5ca1@gmx.de>

Am Montag, 11. M=E4rz 2013 schrieb Martin Steigerwald:
> 2) Create a insanely big sparse file
> =

> merkaba:~> truncate -s1E /mnt/zeit/evenmorecrazy.img
> merkaba:~> ls -lh /mnt/zeit/evenmorecrazy.img
> -rw-r--r-- 1 root root 1,0E M=E4r 11 22:37 /mnt/zeit/evenmorecrazy.img
> =

> (No, this won=B4t work with Ext4.)

Okay, you can=B4t go beyond 8 EiB for a single file which is about what I h=
ave =

read somewhere:

merkaba:/mnt/zeit> ls -lh
insgesamt 0
-rw-r--r-- 1 root root 1,0E M=E4r 11 22:37 evenmorecrazy.img
merkaba:/mnt/zeit> truncate -s2E /mnt/zeit/evenmorecrazy.img
merkaba:/mnt/zeit> truncate -s3E /mnt/zeit/evenmorecrazy.img
merkaba:/mnt/zeit> truncate -s4E /mnt/zeit/evenmorecrazy.img
merkaba:/mnt/zeit> truncate -s5E /mnt/zeit/evenmorecrazy.img
merkaba:/mnt/zeit> truncate -s6E /mnt/zeit/evenmorecrazy.img
merkaba:/mnt/zeit> truncate -s7E /mnt/zeit/evenmorecrazy.img
merkaba:/mnt/zeit> LANG=3DC truncate -s8E /mnt/zeit/evenmorecrazy.img
truncate: invalid number '8E': Value too large for defined data type
merkaba:/mnt/zeit#1> ls -lh  =

insgesamt 0
-rw-r--r-- 1 root root 7,0E M=E4r 11 22:49 evenmorecrazy.img

So so tests stops there, until you concatenate two of those files with LVM =

or SoftRAID 0 (if that works). Like this (I just had to try it):


merkaba:/mnt/zeit> ls -lh                                           =

insgesamt 0
-rw-r--r-- 1 root root 7,0E M=E4r 11 22:49 evenmorecrazy.img
-rw-r--r-- 1 root root 7,0E M=E4r 11 22:52 evenmorecrazy.img2
merkaba:/mnt/zeit> losetup /dev/loop0 evenmorecrazy.img
merkaba:/mnt/zeit> losetup /dev/loop1 evenmorecrazy.img2

merkaba:/mnt/zeit#5> pvcreate /dev/loop0       =

  Physical volume "/dev/loop0" successfully created
merkaba:/mnt/zeit> pvcreate /dev/loop1
  Physical volume "/dev/loop1" successfully created
merkaba:/mnt/zeit> vgcreate justinsane /dev/loop0 /dev/loop1
  PV /dev/loop0 too large for extent size 4,00 MiB.
  Format-specific setup of physical volume '/dev/loop0' failed.
  Unable to add physical volume '/dev/loop0' to volume group 'justinsane'.


merkaba:/mnt/zeit#5> vgcreate --physicalextentsize 16M  justinsane =

/dev/loop0 /dev/loop1
  PV /dev/loop0 too large for extent size 16,00 MiB.
  Format-specific setup of physical volume '/dev/loop0' failed.
  Unable to add physical volume '/dev/loop0' to volume group 'justinsane'.

merkaba:/mnt/zeit#5> vgcreate --physicalextentsize 128M  justinsane =

/dev/loop0 /dev/loop1
  PV /dev/loop0 too large for extent size 128,00 MiB.
  Format-specific setup of physical volume '/dev/loop0' failed.
  Unable to add physical volume '/dev/loop0' to volume group 'justinsane'.

merkaba:/mnt/zeit#5> vgcreate --physicalextentsize 1G  justinsane /dev/loop=
0 =

/dev/loop1
  PV /dev/loop0 too large for extent size 1,00 GiB.
  Format-specific setup of physical volume '/dev/loop0' failed.
  Unable to add physical volume '/dev/loop0' to volume group 'justinsane'.

merkaba:/mnt/zeit#5> vgcreate --physicalextentsize 4G  justinsane /dev/loop=
0 =

/dev/loop1
  Volume group "justinsane" successfully created

merkaba:/mnt/zeit> vgs                                                     =
          =

  VG         #PV #LV #SN Attr   VSize   VFree =

  justinsane   2   0   0 wz--n-  14,00e 14,00e
  merkaba      1   4   0 wz--n- 278,99g  4,85g
merkaba:/mnt/zeit>

merkaba:/mnt/zeit> vgdisplay justinsane
  --- Volume group ---
  VG Name               justinsane
  System ID             =

  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               14,00 EiB
  PE Size               4,00 GiB
  Total PE              3758096382
  Alloc PE / Size       0 / 0   =

  Free  PE / Size       3758096382 / 14,00 EiB
  VG UUID               z8JP5s-lfRw-uKo8-DXAP-XWGe-aKra-xug9Nn


Enough insanity for today :)

I won=B4t mkfs.xfs on it, the 20 GiB of the just filesystem wouldn=B4t be =

enough.

Thanks,
-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
