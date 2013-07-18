Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 862467F37
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 06:29:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 115D8AC001
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 04:29:46 -0700 (PDT)
Received: from smtprelay03.ispgateway.de (smtprelay03.ispgateway.de
	[80.67.18.15]) by cuda.sgi.com with ESMTP id IeR1X6xjBsYJcGgk
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Jul 2013 04:29:41 -0700 (PDT)
Date: Thu, 18 Jul 2013 13:29:39 +0200
From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs
	cleaning
Message-ID: <20130718112938.GB8090@EIS>
References: <20130718110437.GA8090@EIS>
 <20130718111306.GB13468@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130718111306.GB13468@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 18, 2013 at 09:13:06PM +1000, Dave Chinner wrote:
> What's in dmesg?

I forgot to check. *blush*

[ 8004.578647] ffff8801d16f5000: 58 46 53 42 00 00 10 00 00 00 00 00 1f 40 00 00  XFSB.........@..
[ 8004.578652] ffff8801d16f5010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[ 8004.578654] ffff8801d16f5020: cb fe 0d 27 44 d9 43 67 85 17 0a 28 35 68 0e f2  ...'D.Cg...(5h..
[ 8004.578656] ffff8801d16f5030: 00 00 00 00 04 00 00 07 00 00 00 00 00 00 00 c0  ................
[ 8004.578660] XFS (dm-19): Internal error xfs_sb_read_verify at line 730 of file fs/xfs/xfs_mount.c.  Caller 0xffffffff811e99bd

[ 8004.578663] CPU: 1 PID: 80 Comm: kworker/1:1H Not tainted 3.10.1 #1
[ 8004.578665] Hardware name:                  /DP35DP, BIOS DPP3510J.86A.0572.2009.0715.2346 07/15/2009
[ 8004.578671] Workqueue: xfslogd xfs_buf_iodone_work
[ 8004.578674]  ffffffff81655f86 0000000000000072 ffffffff811eb542 ffffffff811e99bd
[ 8004.578677]  ffff8802000002da ffff8802312be5fd ffff8801c67f4a80 0000000000000075
[ 8004.578680]  ffff88021c04f800 0000000000001000 ffffffff8123764c ffffffff811e99bd
[ 8004.578683] Call Trace:
[ 8004.578688]  [<ffffffff81655f86>] ? dump_stack+0xd/0x17
[ 8004.578692]  [<ffffffff811eb542>] ? xfs_corruption_error+0x62/0x90
[ 8004.578700]  [<ffffffff811e99bd>] ? xfs_buf_iodone_work+0x8d/0xb0
[ 8004.578702]  [<ffffffff8123764c>] ? xfs_sb_read_verify+0x11c/0x130
[ 8004.578704]  [<ffffffff811e99bd>] ? xfs_buf_iodone_work+0x8d/0xb0
[ 8004.578706]  [<ffffffff811e99bd>] ? xfs_buf_iodone_work+0x8d/0xb0
[ 8004.578709]  [<ffffffff81087e2a>] ? process_one_work+0x13a/0x3b0
[ 8004.578711]  [<ffffffff81088b96>] ? worker_thread+0x116/0x370
[ 8004.578713]  [<ffffffff81088a80>] ? manage_workers.isra.29+0x290/0x290
[ 8004.578715]  [<ffffffff8108e5c3>] ? kthread+0xb3/0xc0
[ 8004.578718]  [<ffffffff81090000>] ? posix_cpu_timer_set+0xf0/0x300
[ 8004.578719]  [<ffffffff8108e510>] ? kthread_create_on_node+0x120/0x120
[ 8004.578722]  [<ffffffff8165ce2c>] ? ret_from_fork+0x7c/0xb0
[ 8004.578724]  [<ffffffff8108e510>] ? kthread_create_on_node+0x120/0x120
[ 8004.578725] XFS (dm-19): Corruption detected. Unmount and run xfs_repair
[ 8004.578731] XFS (dm-19): metadata I/O error: block 0x4e200000 ("xfs_trans_read_buf_map") error 117 numblks 8
[ 8004.578734] XFS (dm-19): error 117 reading secondary superblock for ag 5

> So it looks like it got to AG 5 and failed for some reason....

Thanks for your quick reply!

I'm also getting panics for other XFS filesystems which I didn't even grow 
nor touch in any other way:

[ 8920.597875] XFS (dm-16): xfs_iread: validation failed for inode 275419712 failed
[ 8920.597880] ffff88014e46a000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[ 8920.597881] ffff88014e46a010: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[ 8920.597883] ffff88014e46a020: ff ff ff ff 00 00 00 00 45 30 45 07 00 00 00 00  ........E0E.....
[ 8920.597884] ffff88014e46a030: 4d d5 25 2c 32 a7 01 56 00 00 00 00 00 00 21 01  M.%,2..V......!.
[ 8920.597886] XFS (dm-16): Internal error xfs_iread at line 1062 of file fs/xfs/xfs_inode.c.  Caller 0xffffffff811f0b1e

[ 8920.597889] CPU: 0 PID: 3913 Comm: dar Not tainted 3.10.1 #1
[ 8920.597890] Hardware name:                  /DP35DP, BIOS DPP3510J.86A.0572.2009.0715.2346 07/15/2009
[ 8920.597892]  ffffffff81655f86 000000000000006a ffffffff811eb542 ffffffff811f0b1e
[ 8920.597894]  0000000000000426 ffffffff81699314 0000000000000075 ffff880190bd30c0
[ 8920.597896]  ffff88021ccd9000 0000000000000000 ffffffff8122fe92 ffffffff811f0b1e
[ 8920.597898] Call Trace:
[ 8920.597903]  [<ffffffff81655f86>] ? dump_stack+0xd/0x17
[ 8920.597907]  [<ffffffff811eb542>] ? xfs_corruption_error+0x62/0x90
[ 8920.597910]  [<ffffffff811f0b1e>] ? xfs_iget+0x2de/0x5b0
[ 8920.597913]  [<ffffffff8122fe92>] ? xfs_iread+0xf2/0x2c0
[ 8920.597915]  [<ffffffff811f0b1e>] ? xfs_iget+0x2de/0x5b0
[ 8920.597917]  [<ffffffff811fcd2e>] ? kmem_zone_alloc+0x5e/0xe0
[ 8920.597919]  [<ffffffff811f0b1e>] ? xfs_iget+0x2de/0x5b0
[ 8920.597921]  [<ffffffff811fb557>] ? xfs_lookup+0xb7/0xe0
[ 8920.597923]  [<ffffffff811f5455>] ? xfs_vn_lookup+0x45/0x90
[ 8920.597926]  [<ffffffff81129c83>] ? lookup_dcache+0xa3/0xd0
[ 8920.597928]  [<ffffffff81129ae4>] ? lookup_real+0x14/0x50
[ 8920.597930]  [<ffffffff81129ce2>] ? __lookup_hash+0x32/0x50
[ 8920.597933]  [<ffffffff81654670>] ? lookup_slow+0x3c/0xa2
[ 8920.597935]  [<ffffffff8112c7d1>] ? path_lookupat+0x6c1/0x730
[ 8920.597938]  [<ffffffff810f2385>] ? pagevec_lru_move_fn+0xc5/0xe0
[ 8920.597940]  [<ffffffff810f1b30>] ? pagevec_lookup+0x20/0x20
[ 8920.597942]  [<ffffffff8112c86f>] ? filename_lookup+0x2f/0xd0
[ 8920.597944]  [<ffffffff8112b1b4>] ? getname_flags.part.50+0x84/0x130
[ 8920.597946]  [<ffffffff8112f812>] ? user_path_at_empty+0x92/0x120
[ 8920.597948]  [<ffffffff81124f07>] ? cp_new_stat+0x117/0x130
[ 8920.597950]  [<ffffffff81125110>] ? vfs_fstatat+0x40/0x90
[ 8920.597952]  [<ffffffff811251c2>] ? SYSC_newlstat+0x12/0x30
[ 8920.597955]  [<ffffffff8104462a>] ? syscall_trace_enter+0x1a/0x1f0
[ 8920.597958]  [<ffffffff8165d06c>] ? tracesys+0x7e/0xe2
[ 8920.597959]  [<ffffffff8165d0cb>] ? tracesys+0xdd/0xe2
[ 8920.597961] XFS (dm-16): Corruption detected. Unmount and run xfs_repair
[ 8941.762510] ffff880170014000: 58 46 53 42 00 00 10 00 00 00 00 00 1f 40 00 00  XFSB.........@..
[ 8941.762515] ffff880170014010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[ 8941.762517] ffff880170014020: cb fe 0d 27 44 d9 43 67 85 17 0a 28 35 68 0e f2  ...'D.Cg...(5h..
[ 8941.762519] ffff880170014030: 00 00 00 00 04 00 00 07 00 00 00 00 00 00 00 c0  ................


That's odd since before 3.10.1 kernel I was using 3.10 and nothing 
like this ever happened. Should I downgrade the kernel?

Regards
Andreas Klauer

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
