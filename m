Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 061697F4E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 06:04:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA4B9304051
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 04:04:40 -0700 (PDT)
Received: from smtprelay05.ispgateway.de (smtprelay05.ispgateway.de
	[80.67.31.100]) by cuda.sgi.com with ESMTP id DdylbEjWq1isv07l
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Jul 2013 04:04:39 -0700 (PDT)
Received: from [217.229.2.200] (helo=localhost)
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.68) (envelope-from <Andreas.Klauer@metamorpher.de>)
	id 1Uzm0j-0001fW-FK
	for xfs@oss.sgi.com; Thu, 18 Jul 2013 13:04:37 +0200
Date: Thu, 18 Jul 2013 13:04:37 +0200
From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs
	cleaning
Message-ID: <20130718110437.GA8090@EIS>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi,

having some problems growing XFS, using Linux 3.10.1 x86_64, xfsprogs 3.1.11.

The filesystem is on LVM, and I made the volume larger. I did this several 
times before and it never causes any issue.

This time, trying to grow the filesystem failed and it seemed corrupt. 
xfs_repair restored its original size somehow (even though shrinking is 
not supposed to be possible?). Unfortunately I did not save the output 
of the commands the first time around, but the issue is reproducable 
in its current state.

If anyone could tell me what I'm doing wrong?

# mount
> /dev/mapper/lvm-xfs on /mnt/xfs type xfs (rw)

# df -h
> /dev/mapper/lvm-xfs          2.0T  1.9T  102G  95% /mnt/xfs

# blockdev --getsize64 /dev/lvm/xfs
> 2306397437952

# xfs_info /mnt/xfs
> meta-data=/dev/mapper/lvm-xfs    isize=256    agcount=16, agsize=32768000 blks
>          =                       sectsz=4096  attr=2
> data     =                       bsize=4096   blocks=524288000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

# xfs_growfs /mnt/xfs
> meta-data=/dev/mapper/lvm-xfs    isize=256    agcount=16, agsize=32768000 blks
>          =                       sectsz=4096  attr=2
> data     =                       bsize=4096   blocks=524288000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning
> data blocks changed from 524288000 to 563085312

# umount /mnt/xfs
# mount /dev/lvm/xfs /mnt/xfs

# df -h
> /dev/mapper/lvm-xfs          2.1T  1.9T  250G  89% /mnt/xfs

# xfs_info /mnt/xfs
> meta-data=/dev/mapper/lvm-xfs    isize=256    agcount=18, agsize=32768000 blks
>          =                       sectsz=4096  attr=2
> data     =                       bsize=4096   blocks=563085312, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

# umount /mnt/xfs

# xfs_repair -v /dev/lvm/xfs
> Phase 1 - find and verify superblock...
> writing modified primary superblock
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> primary/secondary superblock 4 conflict - AG superblock geometry info conflicts with filesystem geometry
> reset bad sb for ag 4
> primary/secondary superblock 2 conflict - AG superblock geometry info conflicts with filesystem geometry
> reset bad sb for ag 2
> primary/secondary superblock 1 conflict - AG superblock geometry info conflicts with filesystem geometry
> reset bad sb for ag 1
> primary/secondary superblock 3 conflict - AG superblock geometry info conflicts with filesystem geometry
> reset bad sb for ag 3
> sb_icount 0, counted 8704
> sb_ifree 0, counted 854
> sb_fdblocks 0, counted 26540703
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done

# mount /dev/lvm/xfs /mnt/xfs

# df -h
> /dev/mapper/lvm-xfs          2.0T  1.9T  102G  95% /mnt/xfs

# xfs_growfs /mnt/xfs
> meta-data=/dev/mapper/lvm-xfs    isize=256    agcount=16, agsize=32768000 blks
>          =                       sectsz=4096  attr=2
> data     =                       bsize=4096   blocks=524288000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning
> data blocks changed from 524288000 to 563085312
 
Back to square one and rinse and repeat.

1) What does "XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning" mean?

2) Should I reformat or any way to repair/grow properly?   

Thanks
Andreas Klauer

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
