Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Feb 2008 22:56:14 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1I6u8Vi030999
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 22:56:11 -0800
Received: from mail.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50327E4C46C
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 22:56:33 -0800 (PST)
Received: from mail.upjs.sk (ns.upjs.sk [158.197.16.31]) by cuda.sgi.com with ESMTP id p5uxmlPs48oYxX36 for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 22:56:33 -0800 (PST)
Date: Mon, 18 Feb 2008 07:56:01 +0100
From: ja@mail.upjs.sk
Subject: Re: Differences in mkfs.xfs and xfs_info output.
Message-ID: <20080218065601.GA26506@mail.upjs.sk>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk> <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk> <20080217230645.GY155407@sgi.com> <Pine.LNX.4.63.0802180113560.4514@alienAngel.home.sk> <20080218020704.GD155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218020704.GD155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Mon, Feb 18, 2008 at 01:07:04PM +1100, David Chinner wrote:

> It is clear that it is dropping by 1024 blocks per mount/unmount
> sequence. That sounds like the reserved space for transactions at
> ENOSPC not being put back in before the superblock is finally
> written to disk on unmount. The reserved space defaults to 1024
> blocks. Does your kernel tree have this code
> in it in xfs_unmountfs():

Yes. I have the same code in xfs_mount.c.
In CVS/Entry I have 
/xfs_mount.c/1.417/Tue Feb  5 07:16:21 2008/-ko/

> FWIW, i wonder if it has something to do with your /dev/loop0
> setup. How have you set this up? Using a raw file and using
> it for mkfs/mount/unmount/check does not show the problem:

No, I restored filesystems on real partition (device mapper) with the same
result.

> If you run your test on a similar setup, do you see the problem
> still?

Yes.

# losetup -d /dev/loop0
# /root/mkfs.xfs -f -d name=test
meta-data=test                   isize=256    agcount=4, agsize=64000 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=256000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# xfs_check -f ./test 
# mount -o loop test /mnt/usb
# umount /mnt/usb
# xfs_check -f ./test
sb_fdblocks 253756, counted 254780

Cheers,
 
jan
