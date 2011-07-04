Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p64ANv3L139682 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 05:23:57 -0500
Received: from mail-fx0-f47.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B0974C3605
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 03:23:56 -0700 (PDT)
Received: from mail-fx0-f47.google.com (mail-fx0-f47.google.com
	[209.85.161.47]) by cuda.sgi.com with ESMTP id sZu7EqjfwUoRiotT
	for <xfs@oss.sgi.com>; Mon, 04 Jul 2011 03:23:56 -0700 (PDT)
Received: by fxg11 with SMTP id 11so5242794fxg.6
	for <xfs@oss.sgi.com>; Mon, 04 Jul 2011 03:23:55 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 4 Jul 2011 10:23:55 +0000
Message-ID: <CAP7pH7uVASQQ60PSBmKWonaOMPJP5fTthheFzjxgdHp5DUBuOw@mail.gmail.com>
Subject: Recovering XFS Partition of Type FAT16
From: Volkan YAZICI <volkan.yazici@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I have an XFS partition, which is

1) Mistakenly quick formatted as FAT16.
2) At first, I couldn't see in "fdisk -l" that it is set to FAT16,
instead of Linux. Hence, tried to fix it with xfs_recover. xfs_recover
returned 0, and mount operation succeeded; but mounted fs size
appeared as 20GB (despite it is 350GB) and almost every file was
missing.
3) Later, I set the type of /dev/sda1 (the only partition in /dev/sda)
to Linux, re-run xfs_recover, but nothing changed: Same fs size (20GB)
and same missing files.

I open the system with Knoppix, and below are the partition
diagnostics. I need urgent help to recover the files. I will be
really, really appreciated for any help! (If you need further
information, just drop me a mail.)


Best.


# fdisk -l

Disk /dev/sda: 320.1 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x447c435f

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1       38913   312568641   83  Linux


# mount | grep /dev/sda1
/dev/sda1 on /media/sda1 type xfs (rw,relatime,attr2,noquota)


# df -h | grep /dev/sda1
/dev/sda1              19G  4,2G   15G  23% /media/sda1

# xfs_info /mnt/sda1
meta-data=/dev/sda1              isize=256    agcount=4, agsize=1226963 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=4907849, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
