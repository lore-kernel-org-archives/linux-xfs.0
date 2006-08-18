Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Aug 2006 02:55:55 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7I9teDW016951
	for <xfs@oss.sgi.com>; Fri, 18 Aug 2006 02:55:41 -0700
Date: Fri, 18 Aug 2006 05:55:06 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: raid5 grow problem
In-Reply-To: <7de068fd0608170730s75afb310g58e6c5fd07202ef@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0608180551060.16805@p34.internal.lan>
References: <7de068fd0608161815yc34ec6bl886fa637691ee5f8@mail.gmail.com>
 <7de068fd0608170223g2009962chc222233c70ee9317@mail.gmail.com>
 <Pine.LNX.4.64.0608170847390.9352@p34.internal.lan>
 <7de068fd0608170730s75afb310g58e6c5fd07202ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1292466206-1155894906=:16805"
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?GB2312?B?yubQxw==?= <xshu2006@gmail.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1292466206-1155894906=:16805
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Adding XFS mailing list to this e-mail to show that the grow for xfs=20
worked.

On Thu, 17 Aug 2006, =CA=E6=D0=C7 wrote:

>> I've only tried growing a RAID5, which was the only RAID that I remember
>> being supported (to grow) in the kernel, I am not sure if its posible to
> i know this,but how you grow your raid5,what's your mdadm version?
> need anyother configure before creat md & use mdadm -G ..to grow?
>> grow other types of RAID arrays.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

0) Compile your kernel with experimental raid5 re-sizing support.
1) Add a spare to the RAID5.
2) Grow the array.

Like this:

p34:~# mdadm --create /dev/md3 /dev/hda1 /dev/hde1 /dev/sdc1 --level=3D5=20
--raid-disks=3D3
mdadm: array /dev/md3 started.
p34:~# mdadm -D /dev/md3
/dev/md3:
         Version : 00.90.03
   Creation Time : Fri Jul  7 15:44:24 2006
      Raid Level : raid5
      Array Size : 781417472 (745.22 GiB 800.17 GB)
     Device Size : 390708736 (372.61 GiB 400.09 GB)
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 3
     Persistence : Superblock is persistent

     Update Time : Fri Jul  7 15:44:24 2006
           State : clean, degraded, recovering
  Active Devices : 2
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

  Rebuild Status : 0% complete

            UUID : cf7a7488:64c04921:b8dfe47c:6c785fa1
          Events : 0.1

     Number   Major   Minor   RaidDevice State
        0       3        1        0      active sync   /dev/hda1
        1      33        1        1      active sync   /dev/hde1
        3       8       33        2      spare rebuilding   /dev/sdc1
p34:~#

p34:~# df -h | grep /raid5
/dev/md3              746G   80M  746G   1% /raid5
p34:~# umount /dev/md3
p34:~# mdadm -D /dev/md3
/dev/md3:
         Version : 00.90.03
   Creation Time : Fri Jul  7 15:44:24 2006
      Raid Level : raid5
      Array Size : 781417472 (745.22 GiB 800.17 GB)
     Device Size : 390708736 (372.61 GiB 400.09 GB)
    Raid Devices : 3
   Total Devices : 4
Preferred Minor : 3
     Persistence : Superblock is persistent

     Update Time : Fri Jul  7 18:25:29 2006
           State : clean
  Active Devices : 3
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : cf7a7488:64c04921:b8dfe47c:6c785fa1
          Events : 0.26

     Number   Major   Minor   RaidDevice State
        0       3        1        0      active sync   /dev/hda1
        1      33        1        1      active sync   /dev/hde1
        2       8       33        2      active sync   /dev/sdc1

        3      22        1        -      spare   /dev/hdc1

p34:~# mdadm /dev/md3 --grow --raid-disks=3D4
mdadm: Need to backup 384K of critical section..
mdadm: ... critical section passed.
p34:~# cat /proc/mdstat
Personalities : [raid1] [raid5] [raid4]
md1 : active raid1 sdb2[1] sda2[0]
       136448 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
       70268224 blocks [2/2] [UU]

md3 : active raid5 hdc1[3] sdc1[2] hde1[1] hda1[0]
       781417472 blocks super 0.91 level 5, 64k chunk, algorithm 2 [4/4]=20
[UUUU]
       [>....................]  reshape =3D  0.0% (85120/390708736)=20
finish=3D840.5min speed=3D7738K/sec

md0 : active raid1 sdb1[1] sda1[0]
       2200768 blocks [2/2] [UU]

unused devices: <none>
p34:~# cat /proc/mdstat
Personalities : [raid1] [raid5] [raid4]
md1 : active raid1 sdb2[1] sda2[0]
       136448 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
       70268224 blocks [2/2] [UU]

md3 : active raid5 hdc1[3] sdc1[2] hde1[1] hda1[0]
       781417472 blocks super 0.91 level 5, 64k chunk, algorithm 2 [4/4]=20
[UUUU]
       [>....................]  reshape =3D  0.0% (286284/390708736)=20
finish=3D779.8min speed=3D8342K/sec

md0 : active raid1 sdb1[1] sda1[0]
       2200768 blocks [2/2] [UU]

unused devices: <none>
p34:~#

p34:~# mount /raid5

p34:~# xfs_growfs /raid5
meta-data=3D/dev/md3               isize=3D256    agcount=3D32, agsize=3D61=
04816=20
blks
          =3D                       sectsz=3D4096  attr=3D0
data     =3D                       bsize=3D4096   blocks=3D195354112, imaxp=
ct=3D25
          =3D                       sunit=3D16     swidth=3D48 blks, unwrit=
ten=3D1
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D2
          =3D                       sectsz=3D4096  sunit=3D1 blks
realtime =3Dnone                   extsz=3D196608 blocks=3D0, rtextents=3D0
data blocks changed from 195354112 to 195354368
p34:~#

p34:~# umount /raid5

p34:~# mount /raid5
p34:~# df -h
/dev/md3              746G   80M  746G   1% /raid5
p34:~#


---1463747160-1292466206-1155894906=:16805--
