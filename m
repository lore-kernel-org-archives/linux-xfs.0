Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Feb 2008 18:07:00 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1I26oKU010683
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 18:06:54 -0800
Date: Mon, 18 Feb 2008 13:07:04 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
Message-ID: <20080218020704.GD155407@sgi.com>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk> <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk> <20080217230645.GY155407@sgi.com> <Pine.LNX.4.63.0802180113560.4514@alienAngel.home.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0802180113560.4514@alienAngel.home.sk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Derfinak <ja@mail.upjs.sk>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Mon, Feb 18, 2008 at 01:17:21AM +0100, Jan Derfinak wrote:
> On Mon, 18 Feb 2008, David Chinner wrote:
> 
> > Is this reproducable with simple tests? e.g. mkfs, mount, unmount
> > check? or doing some simple things like creating some files
> 
> One more test (no FS activity, only mount, umount sequence):
> # /root/mkfs.xfs -f /dev/loop0
> meta-data=/dev/loop0             isize=256    agcount=4, agsize=64000 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=256000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096  
> log      =internal log           bsize=4096   blocks=1200, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> # xfs_check /dev/loop0
> # mount /dev/loop0 /mnt/usb
> # umount /mnt/usb
> # xfs_check /dev/loop0
> sb_fdblocks 253756, counted 254780
> # mount /dev/loop0 /mnt/usb
> # umount /mnt/usb
> # xfs_check /dev/loop0
> sb_fdblocks 252732, counted 254780

It is clear that it is dropping by 1024 blocks per mount/unmount
sequence. That sounds like the reserved space for transactions at
ENOSPC not being put back in before the superblock is finally
written to disk on unmount. The reserved space defaults to 1024
blocks. Does your kernel tree have this code
in it in xfs_unmountfs():

   1272         /*
   1273          * Unreserve any blocks we have so that when we unmount we don't account
   1274          * the reserved free space as used. This is really only necessary for
   1275          * lazy superblock counting because it trusts the incore superblock
   1276          * counters to be aboslutely correct on clean unmount.
   1277          *
   1278          * We don't bother correcting this elsewhere for lazy superblock
   1279          * counting because on mount of an unclean filesystem we reconstruct the
   1280          * correct counter value and this is irrelevant.
   1281          *
   1282          * For non-lazy counter filesystems, this doesn't matter at all because
   1283          * we only every apply deltas to the superblock and hence the incore
   1284          * value does not matter....
   1285          */
   1286         resblks = 0;
   1287         xfs_reserve_blocks(mp, &resblks, NULL);


FWIW, i wonder if it has something to do with your /dev/loop0
setup. How have you set this up? Using a raw file and using
it for mkfs/mount/unmount/check does not show the problem:

$ sudo mkfs.xfs -d name=fs_file
meta-data=fs_file                isize=256    agcount=4, agsize=655424 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2621696, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo xfs_check -f ./fs_file
$ sudo mount -o loop fs_file /mnt/fred
$ sudo umount /mnt/fred
$ sudo xfs_check -f ./fs_file
$ sudo mount -o loop fs_file /mnt/fred
$ sudo umount /mnt/fred
$ sudo xfs_check -f ./fs_file
$

If you run your test on a similar setup, do you see the problem
still?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
