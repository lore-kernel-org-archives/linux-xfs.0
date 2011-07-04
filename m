Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p64CnBVM146898 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 07:49:11 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 619CD1678A95
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 05:49:09 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bxvROI2PhaEIi0ZN for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2011 05:49:09 -0700 (PDT)
Date: Mon, 4 Jul 2011 22:49:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Recovering XFS Partition of Type FAT16
Message-ID: <20110704124906.GY561@dastard>
References: <CAP7pH7uVASQQ60PSBmKWonaOMPJP5fTthheFzjxgdHp5DUBuOw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAP7pH7uVASQQ60PSBmKWonaOMPJP5fTthheFzjxgdHp5DUBuOw@mail.gmail.com>
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
To: Volkan YAZICI <volkan.yazici@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 04, 2011 at 10:23:55AM +0000, Volkan YAZICI wrote:
> Hi,
> 
> I have an XFS partition, which is
> 
> 1) Mistakenly quick formatted as FAT16.
> 2) At first, I couldn't see in "fdisk -l" that it is set to FAT16,
> instead of Linux. Hence, tried to fix it with xfs_recover. xfs_recover
> returned 0, and mount operation succeeded; but mounted fs size
> appeared as 20GB (despite it is 350GB) and almost every file was
> missing.
> 3) Later, I set the type of /dev/sda1 (the only partition in /dev/sda)
> to Linux, re-run xfs_recover, but nothing changed: Same fs size (20GB)
> and same missing files.

What is this xfs_recover tool you speak of? I've never heard of it,
I can't find any direct links to it in google (only forum posts from
years ago about how great it is) so I have no idea what you've done to
your filesystem...

> I open the system with Knoppix, and below are the partition
> diagnostics. I need urgent help to recover the files. I will be
> really, really appreciated for any help! (If you need further
> information, just drop me a mail.)
> 
> 
> Best.
> 
> 
> # fdisk -l
> 
> Disk /dev/sda: 320.1 GB, 320072933376 bytes
> 255 heads, 63 sectors/track, 38913 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x447c435f
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *           1       38913   312568641   83  Linux
> 
> 
> # mount | grep /dev/sda1
> /dev/sda1 on /media/sda1 type xfs (rw,relatime,attr2,noquota)
> 
> 
> # df -h | grep /dev/sda1
> /dev/sda1              19G  4,2G   15G  23% /media/sda1
> 
> # xfs_info /mnt/sda1
> meta-data=/dev/sda1              isize=256    agcount=4, agsize=1226963 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=4907849, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

That looks like a newly made 20GB XFS filesystem, not the result of
repairing a 350GB filesystem...

If I were you, I'd be restoring from backups. You do have backups,
right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
