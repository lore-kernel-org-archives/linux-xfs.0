Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD4B87F4E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 06:13:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9D5DE304051
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 04:13:11 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VHG2o0CaooYGxGCR for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 04:13:09 -0700 (PDT)
Date: Thu, 18 Jul 2013 21:13:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs
	cleaning
Message-ID: <20130718111306.GB13468@dastard>
References: <20130718110437.GA8090@EIS>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130718110437.GA8090@EIS>
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
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: xfs@oss.sgi.com

On Thu, Jul 18, 2013 at 01:04:37PM +0200, Andreas Klauer wrote:
> Hi,
> 
> having some problems growing XFS, using Linux 3.10.1 x86_64, xfsprogs 3.1.11.
> 
> The filesystem is on LVM, and I made the volume larger. I did this several 
> times before and it never causes any issue.
> 
> This time, trying to grow the filesystem failed and it seemed corrupt. 
> xfs_repair restored its original size somehow (even though shrinking is 
> not supposed to be possible?). Unfortunately I did not save the output 
> of the commands the first time around, but the issue is reproducable 
> in its current state.
> 
> If anyone could tell me what I'm doing wrong?
> 
> # mount
> > /dev/mapper/lvm-xfs on /mnt/xfs type xfs (rw)
> 
> # df -h
> > /dev/mapper/lvm-xfs          2.0T  1.9T  102G  95% /mnt/xfs
> 
> # blockdev --getsize64 /dev/lvm/xfs
> > 2306397437952
> 
> # xfs_info /mnt/xfs
> > meta-data=/dev/mapper/lvm-xfs    isize=256    agcount=16, agsize=32768000 blks
> >          =                       sectsz=4096  attr=2
> > data     =                       bsize=4096   blocks=524288000, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=32768, version=2
> >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> # xfs_growfs /mnt/xfs
> > meta-data=/dev/mapper/lvm-xfs    isize=256    agcount=16, agsize=32768000 blks
> >          =                       sectsz=4096  attr=2
> > data     =                       bsize=4096   blocks=524288000, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=32768, version=2
> >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning
> > data blocks changed from 524288000 to 563085312

What's in dmesg?

> > Phase 2 - using internal log
> >         - zero log...
> >         - scan filesystem freespace and inode maps...
> > primary/secondary superblock 4 conflict - AG superblock geometry info conflicts with filesystem geometry
> > reset bad sb for ag 4
> > primary/secondary superblock 2 conflict - AG superblock geometry info conflicts with filesystem geometry
> > reset bad sb for ag 2
> > primary/secondary superblock 1 conflict - AG superblock geometry info conflicts with filesystem geometry
> > reset bad sb for ag 1
> > primary/secondary superblock 3 conflict - AG superblock geometry info conflicts with filesystem geometry
> > reset bad sb for ag 3
> > sb_icount 0, counted 8704
> > sb_ifree 0, counted 854
> > sb_fdblocks 0, counted 26540703

So it looks like it got to AG 5 and failed for some reason....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
