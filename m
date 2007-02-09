Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 09 Feb 2007 07:07:55 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l19F7km7024362
	for <xfs@oss.sgi.com>; Fri, 9 Feb 2007 07:07:47 -0800
Message-ID: <45CC8E3E.6090109@sandeen.net>
Date: Fri, 09 Feb 2007 09:07:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Inodes disappearing
References: <Pine.LNX.4.61.0702091345360.31955@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0702091345360.31955@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: xfs@oss.sgi.com

Jan Engelhardt wrote:
> Hello list,
> 
> 
> here's an interesting phenomena I am seeing:
> 
> # df -h
> /dev/hda3             215G  152G   63G  71% /sam224
> /dev/dm-0             233G  233G  350M 100% /sam250
> # df -i
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/hda3            112254144   33076 112221068    1% /sam224
> /dev/dm-0            1466272   35982 1430290    3% /sam250
> 
> How come that dm-0 has much less inodes despite the two volumes having 
> about the same size? It can't be because of isize=512, can it? (If at 
> all, I would expect an isize=512 volume to have less inodes than a 
> isize=256 one for the same number of blocks.)

xfs dynamically allocates inodes, up to a maximum percentage of disk 
space specified at mkfs time, changeable by growfs.  By default this is 
25%, and from output below that's what you have.  So the total inodes 
number from df is given by taking 25% of your data space, and 
calculating how many inodes would fit into that space.

Since your filesystems are roughly the same size, that means you started 
out with roughly the same amount of space available for inodes in each.

dm-0 has 256-byte inodes, hda3 has 512-byte inodes, which means for a 
given amount of space, you -can- fit more (256-byte) inodes into the 
filesystem on dm-0.

However, dm-0 is completely full, and there is very little space left 
for at all.  If you look at xfs_statvfs(); you'll see all these 
calculations that go into your answers above.

inodes which -could- be created based on free space:

         fakeinos = statp->f_bfree << sbp->sb_inopblog;

total inodes is min of (current + possible) and max inode nr:

         statp->f_files =
             MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);

... which is then limited by the configured max percentage:

         if (mp->m_maxicount)
	....
                         statp->f_files = min_t(typeof(statp->f_files),
                                                 statp->f_files,
                                                 mp->m_maxicount);


your free blocks is low, so you start with a low number for "fakeinos" 
and your final result reflects that.  You've used most of your potential 
inode space for data.

-Eric


>


> # xfs_info /dev/dm-0
> meta-data=/dev/disk/by-label/sam250 isize=256    agcount=16, agsize=3813429 blks         =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=61014864, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=29792, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=65536  blocks=0, rtextents=0
> 
> # xfs_info /dev/hda3
> meta-data=/dev/disk/by-label/sam224 isize=512    agcount=16, agsize=3507943 blks         =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=56127088, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=27405, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=65536  blocks=0, rtextents=0
> 
> 
> Jan
