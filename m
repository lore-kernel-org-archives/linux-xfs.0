Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41917 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754771AbdAETNW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2017 14:13:22 -0500
Date: Thu, 5 Jan 2017 11:13:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [BUG] xfs.mkfs recognizes wrong disk size
Message-ID: <20170105191316.GD17846@birch.djwong.org>
References: <CABPa+v3fgLjBo2CLBXxg8xE3D5tWdjk2C3gM2o1-xEFT45_Rkg@mail.gmail.com>
 <de4f0e6b-bd01-5bf5-42f6-ca2562c564cb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de4f0e6b-bd01-5bf5-42f6-ca2562c564cb@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Xingbo Wu <wuxb45@gmail.com>, linux-xfs@vger.kernel.org

On Thu, Jan 05, 2017 at 12:58:23PM -0600, Eric Sandeen wrote:
> On 1/5/17 12:02 PM, Xingbo Wu wrote:
> > /dev/sdf is a 3TB hard drive.
> > It has 2930266584 blocks, as reported in `badblocks -wsv /dev/sdf`:
> > Checking for bad blocks in read-write mode
> > From block 0 to 2930266583
>
> 2930266583 x 1024 == 3000592980992
> 
> I'd rather see what /proc/partitions and/or blockdev says about it...

>From the badblocks manpage,

"-b block_size: Specify the size of blocks in bytes.  The default is 1024."

(So far so good.)

> > However mkfs.xfs reports a larger block count:
> > `sudo mkfs.xfs /dev/sdf`:
> > meta-data=/dev/sdf               isize=512    agcount=4, agsize=183141662 blks
> >          =                       sectsz=4096  attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=0, rmapbt=0
> > data     =                       bsize=4096   blocks=732566646, imaxpct=5
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal log           bsize=4096   blocks=357698, version=2
> >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 732566646 x 4k blocks == 3000592982016 bytes
> 
> Ok, that is 1024 bytes bigger.  But the weird thing is that
> mkfs.xfs actually writes the last block, and fails if that fails.
> 
> So let's start with what /proc/partitions says, as well as
> 
> # blkdev --getsize --getsize64 /dev/sdf
> 
> -Eric
> 
> > It later leads to IO error:
> > `dmesg`:
> > [1807875.741674] blk_update_request: I/O error, dev sdf, sector 2930266664
> > [1807875.741732] blk_update_request: I/O error, dev sdf, sector 2930266664

The kernel complains about "sector 2930266664", which is in 512-byte blocks.

2930266664 * 512 = 1500296531968, or halfway across your 3TB disk.

Makes sense since the log generally ends up halfway across the disk.
Not sure if there's any output before 1807875.741674 but this sort of
looks like a disk error or something?

--D

> > [1807875.742306] XFS (sdf): metadata I/O error: block 0xaea85228
> > ("xlog_iodone") error 5 numblks 64
> > [1807875.742369] XFS (sdf): xfs_do_force_shutdown(0x2) called from
> > line 1200 of file fs/xfs/xfs_log.c.  Return address =
> > 0xffffffffa024090c
> > [1807875.742381] XFS (sdf): Log I/O Error Detected.  Shutting down filesystem
> > [1807875.742416] XFS (sdf): xfs_log_force: error -5 returned.
> > [1807875.742426] XFS (sdf): Please umount the filesystem and rectify
> > the problem(s)
> > [1807881.868117] XFS (sdf): xfs_log_force: error -5 returned.
> > [1807910.701836] XFS (sdf): xfs_log_force: error -5 returned.
> > [1807910.701841] XFS (sdf): Unmounting Filesystem
> > [1807910.701854] XFS (sdf): xfs_log_force: error -5 returned.
> > [1807910.701866] XFS (sdf): xfs_log_force: error -5 returned.
> > 
> > 
> > 
> > The hard drive information:
> > Model Family:     Seagate Barracuda 7200.14 (AF)
> > Device Model:     ST3000DM001-9YN166
> > Serial Number:    W1F03GXY
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
