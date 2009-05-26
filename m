Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4Q9pAn2134865 for <xfs@oss.sgi.com>; Tue, 26 May 2009 04:51:10 -0500
Received: from atlas.fiton.is (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9770B10007F6
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 02:57:11 -0700 (PDT)
Received: from atlas.fiton.is (atlas.fiton.is [62.145.135.105]) by
	cuda.sgi.com with ESMTP id 1g1L5MW98RGIwCdC for
	<xfs@oss.sgi.com>; Tue, 26 May 2009 02:57:11 -0700 (PDT)
Received: from localhost ([127.0.0.1]) by atlas.fiton.is
	(using TLSv1/SSLv3 with cipher AES128-SHA (128 bits))
	for xfs@oss.sgi.com; Tue, 26 May 2009 09:52:03 +0000
Message-Id: <BC442FE9-64FC-4F3C-A5AA-25C890AABD3C@fiton.is>
From: =?ISO-8859-1?Q?Svavar_=D6rn_Eysteinsson?= <svavar@fiton.is>
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Incorrect Free Space / xfs_growfs on RAID5 Volume ?
Date: Tue, 26 May 2009 09:51:20 +0000
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all.

I=92m hoping that someone can help me out here, regarding growing a XFS  =

filesystem
on a Adaptec RAID controller with RAID5 setup.

First of all, this is my setup :

Fedora Core 6.
Kernel : 2.6.27
(stock Fedora Core 6 xfsprogs)
Adaptec SATA Raid Controller 2820SA ( 8 port )


For 2 years now, I had running a RAID5 setup with 4x 500GB SATA disks
as one logical drive. That drive would have been /dev/sdb.
I made an xfs filesystem out of it and it gave me about 1.8 TB of  =

usable data space.

No problems so far, nothing.

I recently added the 5th disks in the RAID5 setup, and reconfigured  =

(Online Expansion)
with the Adaptec Storage Manager.
So the Adaptec SM tells me that I have 2.274 TB of space.
Parity space is : 465.626 GB and the Stripe size is 256K.

Well, the RAID controller setup is done. So I headed out to the fdisk  =

section.

I deleted the /dev/sdb1 partition and made a new one right ahead.

(see below)

Partition number (1-4): 1
First cylinder (1-303916, default 1): 1
Last cylinder or +size or +sizeM or +sizeK (1-267349, default 267349):  =

267349

Disk /dev/sdb: 2499.7 GB, 2499794698240 bytes
255 heads, 63 sectors/track, 303916 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1      267349  2147480811   83  Linux


I issued a =93w=94 command to write to the partition table and exited fdisk.

Mounted the /dev/sdb1 partition as /raid-data.


Did grow the XFS filesystem with xfs_growfs /raid-data




Now the strange part. When I issue =93df -h=94 command it shows much smaller
disk space added then it should have.





(see below)

Filesystem            Size  Used Avail Use% Mounted on
/dev/sda3             269G  181G   75G  71% /
/dev/sda1             244M   20M  211M   9% /boot
tmpfs                1013M     0 1013M   0% /dev/shm
/dev/sdb1             2.0T  1.9T  191G  91% /raid-data

Using a =93non -h=94 df command shows me :


Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda3            281636376 189165420  77933740  71% /
/dev/sda1               248895     20331    215714   9% /boot
tmpfs                  1036736         0   1036736   0% /dev/shm
/dev/sdb1            2147349736 1948095012 199254724  91% /raid-data



Any ideas? This is not acceptable as I inserted 500GB as additional  =

space
to the RAID5 group and don=92t have all of it. :(

So I checked the fragmentation with xfs_db and it told me
that the volume was having a 36.7% fragmentation.

I was going to issue a xfs_fsr but the system couldn=92t find that  =

command.
Great.

I removed the stock xfsprogs rpm version, downloaded the newest
xfsprogs source (xfsprogs-3.0.1). Build=92it, installed it and issued
the xfs_fsr on the volume.

Nothing changed on the free space thing, It=92s totally the same.


Filesystem            Size  Used Avail Use% Mounted on
/dev/sda3             269G  181G   75G  71% /
/dev/sda1             244M   20M  211M   9% /boot
tmpfs                1013M     0 1013M   0% /dev/shm
/dev/sdb1             2.0T  1.9T  191G  91% /raid-data





I then decided to use the xfs_growfs with the newest version(that is  =

the version I
downloaded, configured and installed) on the volume.

Nothing happens, as the xfs_growfs says :

# xfs_growfs -d /raid-data
meta-data=3D/dev/sdb1              isize=3D256    agcount=3D36,  =

agsize=3D15257482 blks
          =3D                       sectsz=3D512   attr=3D0
data     =3D                       bsize=3D4096   blocks=3D536870202,  =

imaxpct=3D25
          =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D1
          =3D                       sectsz=3D512   sunit=3D0 blks, lazy- =

count=3D0
realtime =3Dnone                   extsz=3D65536  blocks=3D0, rtextents=3D0
data size unchanged, skipping



So I really need some advice or help about this situation.
Did I do anything wrong ?

Is the metadata, and or log data on the xfs volume taking all the  =

remain space
so I only get about 191GB free for data after the insert of 500GB disk ?


Thanks all.

Best regards,

Svavar - Reykjavik / Iceland


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
