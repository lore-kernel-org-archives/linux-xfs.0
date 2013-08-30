Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 922107F53
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 21:09:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 81B9D30404E
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 19:09:00 -0700 (PDT)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id uxYmIari5FZBLqTC
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Aug 2013 19:08:55 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: higher agcount on LVM2 thinp volumes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <521FF8F4.9040009@hardwarefreak.com>
Date: Thu, 29 Aug 2013 20:08:25 -0600
Message-Id: <DD759368-581C-4C94-BC5E-E6EC3A83FC61@colorremedies.com>
References: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
	<521FF8F4.9040009@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com


On Aug 29, 2013, at 7:44 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
> More information would be helpful, specifically WRT the device stack
> underlying mkfs.xfs.  I.e. we need to know more about the LVM configuration.
> 
> See:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Summary: laptop, one HDD, one 402GB partition is made into a PV, one VG is created with that PV and is the only VG on the system, one 400GB logical volume pool is created, one 100GB virtual sized logical volume is created from the thin pool.


Linux f19s.local 3.10.9-200.fc19.x86_64 #1 SMP Wed Aug 21 19:27:58 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

xfsprogs-3.1.10-2.fc19.x86_64
lvm2-2.02.98-12.fc19.x86_64
DMI: Apple Inc. MacBookPro4,1/Mac-F42C89C8
WDC WD5000BEVT-22ZAT0

[root@f19s ~]# gdisk -l /dev/sda
GPT fdisk (gdisk) version 0.8.7

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sda: 976773168 sectors, 465.8 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): CB8CACD3-0BDB-46E0-AD6A-D7F99915EA2D
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 976773134
Partitions will be aligned on 8-sector boundaries
Total free space is 478 sectors (239.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1              40          409639   200.0 MiB   EF00  EFI System Partition
   2          409640        49237767   23.3 GiB    AF00  Mac
   3        49237768        50507303   619.9 MiB   AB00  Recovery HD
   4        50507776        50712575   100.0 MiB   AF00  fedoraEFI
   5        50712576        67096575   7.8 GiB     8200  swap
   6        67096576       133308415   31.6 GiB    8300  fedoraroot
   7       133308416       976773134   402.2 GiB   8E00  LVM2

[root@f19s ~]# pvs
  PV         VG   Fmt  Attr PSize   PFree  
  /dev/sda7  vg1  lvm2 a--  402.19g 188.00m

[root@f19s ~]# lvdisplay
  --- Logical volume ---
  LV Name                thinp
  VG Name                vg1
  LV UUID                mKI9dj-1CsO-Ke7e-JcMM-NUDH-MpOD-yMl8Da
  LV Write Access        read/write
  LV Creation host, time f19s.local, 2013-08-29 00:14:38 -0600
  LV Pool transaction ID 1
  LV Pool metadata       thinp_tmeta
  LV Pool data           thinp_tdata
  LV Pool chunk size     4.00 MiB
  LV Zero new blocks     yes
  LV Status              available
  # open                 0
  LV Size                402.00 GiB
  Allocated pool data    0.95%
  Allocated metadata     1.12%
  Current LE             102912
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:3
   
  --- Logical volume ---
  LV Path                /dev/vg1/data
  LV Name                data
  VG Name                vg1
  LV UUID                yL0g16-qjUq-20MJ-Fu3I-q5AH-H8ed-LOhNwS
  LV Write Access        read/write
  LV Creation host, time f19s.local, 2013-08-29 00:15:49 -0600
  LV Pool name           thinp
  LV Status              available
  # open                 0
  LV Size                100.00 GiB
  Mapped size            3.83%
  Current LE             25600
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:4


Commands to create the thinp volume:

[root@f19s ~]# pvcreate /dev/sda7
  Physical volume "/dev/sda7" successfully created
[root@f19s ~]# vgcreate vg1 /dev/sda7
  Volume group "vg1" successfully created
[root@f19s ~]# lvcreate -L 400G --type thin-pool --thinpool thinp vg1
  device-mapper: remove ioctl on  failed: Device or resource busy
  Logical volume "thinp" created
[root@f19s ~]# lvcreate -V 100G -T vg1/thinp --name data
  Logical volume "data" created
[root@f19s ~]# mkfs.xfs /dev/vg1/data
meta-data=/dev/vg1/data          isize=256    agcount=16, agsize=1638400 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=26214400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


Whereas if I mkfs.xfs on /dev/sda7, or if I create a regular LV rather than a thinp volume, agcount is 4. It doesn't matter whether I create the thinp with the chunk option set to default (as above) or 1MB or 4MB.


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
