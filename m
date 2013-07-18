Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E9707F3F
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 07:45:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D007F30404E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 05:45:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	SgrlNljSvrJMfbVy for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 05:45:54 -0700 (PDT)
Date: Thu, 18 Jul 2013 22:45:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs
	cleaning
Message-ID: <20130718124511.GC13468@dastard>
References: <20130718110437.GA8090@EIS> <20130718111306.GB13468@dastard>
	<20130718112938.GB8090@EIS>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130718112938.GB8090@EIS>
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

On Thu, Jul 18, 2013 at 01:29:39PM +0200, Andreas Klauer wrote:
> On Thu, Jul 18, 2013 at 09:13:06PM +1000, Dave Chinner wrote:
> > What's in dmesg?
> 
> I forgot to check. *blush*
> 
> [ 8004.578647] ffff8801d16f5000: 58 46 53 42 00 00 10 00 00 00 00 00 1f 40 00 00  XFSB.........@..
> [ 8004.578652] ffff8801d16f5010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [ 8004.578654] ffff8801d16f5020: cb fe 0d 27 44 d9 43 67 85 17 0a 28 35 68 0e f2  ...'D.Cg...(5h..
> [ 8004.578656] ffff8801d16f5030: 00 00 00 00 04 00 00 07 00 00 00 00 00 00 00 c0  ................
> [ 8004.578660] XFS (dm-19): Internal error xfs_sb_read_verify at line 730 of file fs/xfs/xfs_mount.c.  Caller 0xffffffff811e99bd
> 
> [ 8004.578663] CPU: 1 PID: 80 Comm: kworker/1:1H Not tainted 3.10.1 #1
> [ 8004.578665] Hardware name:                  /DP35DP, BIOS DPP3510J.86A.0572.2009.0715.2346 07/15/2009
> [ 8004.578671] Workqueue: xfslogd xfs_buf_iodone_work
> [ 8004.578674]  ffffffff81655f86 0000000000000072 ffffffff811eb542 ffffffff811e99bd
> [ 8004.578677]  ffff8802000002da ffff8802312be5fd ffff8801c67f4a80 0000000000000075
> [ 8004.578680]  ffff88021c04f800 0000000000001000 ffffffff8123764c ffffffff811e99bd
> [ 8004.578683] Call Trace:
> [ 8004.578688]  [<ffffffff81655f86>] ? dump_stack+0xd/0x17
> [ 8004.578692]  [<ffffffff811eb542>] ? xfs_corruption_error+0x62/0x90
> [ 8004.578700]  [<ffffffff811e99bd>] ? xfs_buf_iodone_work+0x8d/0xb0
> [ 8004.578702]  [<ffffffff8123764c>] ? xfs_sb_read_verify+0x11c/0x130
> [ 8004.578704]  [<ffffffff811e99bd>] ? xfs_buf_iodone_work+0x8d/0xb0
> [ 8004.578706]  [<ffffffff811e99bd>] ? xfs_buf_iodone_work+0x8d/0xb0
> [ 8004.578709]  [<ffffffff81087e2a>] ? process_one_work+0x13a/0x3b0
> [ 8004.578711]  [<ffffffff81088b96>] ? worker_thread+0x116/0x370
> [ 8004.578713]  [<ffffffff81088a80>] ? manage_workers.isra.29+0x290/0x290
> [ 8004.578715]  [<ffffffff8108e5c3>] ? kthread+0xb3/0xc0
> [ 8004.578718]  [<ffffffff81090000>] ? posix_cpu_timer_set+0xf0/0x300
> [ 8004.578719]  [<ffffffff8108e510>] ? kthread_create_on_node+0x120/0x120
> [ 8004.578722]  [<ffffffff8165ce2c>] ? ret_from_fork+0x7c/0xb0
> [ 8004.578724]  [<ffffffff8108e510>] ? kthread_create_on_node+0x120/0x120
> [ 8004.578725] XFS (dm-19): Corruption detected. Unmount and run xfs_repair
> [ 8004.578731] XFS (dm-19): metadata I/O error: block 0x4e200000 ("xfs_trans_read_buf_map") error 117 numblks 8
> [ 8004.578734] XFS (dm-19): error 117 reading secondary superblock for ag 5
> 
> > So it looks like it got to AG 5 and failed for some reason....

Ok, so the problem is as expected - the secondary superblock in AG 5
is not verifying correctly. Can you run:

# xfs_db -r -c "sb 0" -c p -c "sb 5" -c p <dev>

And post the output?

> Thanks for your quick reply!
> 
> I'm also getting panics for other XFS filesystems which I didn't even grow 
> nor touch in any other way:
> 
> [ 8920.597875] XFS (dm-16): xfs_iread: validation failed for inode 275419712 failed
> [ 8920.597880] ffff88014e46a000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> [ 8920.597881] ffff88014e46a010: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> [ 8920.597883] ffff88014e46a020: ff ff ff ff 00 00 00 00 45 30 45 07 00 00 00 00  ........E0E.....
> [ 8920.597884] ffff88014e46a030: 4d d5 25 2c 32 a7 01 56 00 00 00 00 00 00 21 01  M.%,2..V......!.
> [ 8920.597886] XFS (dm-16): Internal error xfs_iread at line 1062 of file fs/xfs/xfs_inode.c.  Caller 0xffffffff811f0b1e

Yup, that's a real corruption. Something has trashed a location
where inodes should be on disk.

> That's odd since before 3.10.1 kernel I was using 3.10 and nothing 
> like this ever happened. Should I downgrade the kernel?

There shouldn't be any XFS changes between 3.10.0 and 3.10.1, so I'm
not sure that's your problem. It looks to me like there's
pre-existing corruption on disk, and 3.10 is simply finding it. Have
you recently upgraded from an older kernel (i.e. older than 3.9)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
