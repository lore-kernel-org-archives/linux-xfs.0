Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBJMBhFf100925
	for <linux-xfs@oss.sgi.com>; Mon, 19 Dec 2011 16:11:43 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rShHdgTwMC3EUpCG for <linux-xfs@oss.sgi.com>;
	Mon, 19 Dec 2011 14:11:40 -0800 (PST)
Date: Tue, 20 Dec 2011 09:11:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bug in fs/xfs/xfs_aops.c:959! (kernel 3.1.5)
Message-ID: <20111219221137.GR23662@dastard>
References: <jcn0ip$hsk$1@dough.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <jcn0ip$hsk$1@dough.gmane.org>
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
To: Jeremy Sanders <jeremy@jeremysanders.net>
Cc: linux-xfs@oss.sgi.com

On Mon, Dec 19, 2011 at 09:36:24AM +0000, Jeremy Sanders wrote:
> Hello - this was just produced in kernel 3.1.5 (Fedora 16, x86-64, 
> kernel-3.1.5-1.fc16.x86_64).
> 
> Jeremy
> 
> 
> Dec 19 00:56:06 xback2 kernel: [374538.665353] ------------[ cut here ]------------

There was a line above this about an assert failure? What was it?

> Dec 19 00:56:06 xback2 kernel: [374538.665431] kernel BUG at 
> fs/xfs/xfs_aops.c:959!
> Dec 19 00:56:06 xback2 kernel: [374538.665504] invalid opcode: 0000 [#1] SMP 
> Dec 19 00:56:06 xback2 kernel: [374538.665578] CPU 1 
> Dec 19 00:56:06 xback2 kernel: [374538.665581] Modules linked in: btrfs 
.....
Pid: 22689, comm: flush-9:0 Not tainted 3.1.5-1.fc16.x86_64 #1 WinFast C51GM03/C51MCP51
RIP: 0010: [<ffffffffa02ec7e2>]  [<ffffffffa02ec7e2>] xfs_vm_writepage+0x4c2/0x4f0 [xfs]

 [<ffffffff8111dec7>] __writepage+0x17/0x40
 [<ffffffff8111e32d>] write_cache_pages+0x20d/0x460
 [<ffffffff8111e5ca>] generic_writepages+0x4a/0x70
 [<ffffffffa02eb8fd>] xfs_vm_writepages+0x4d/0x60 [xfs]
 [<ffffffff8111f8d1>] do_writepages+0x21/0x40
 [<ffffffff81198af9>] writeback_single_inode+0x149/0x3e0
 [<ffffffff81198f30>] writeback_sb_inodes+0x1a0/0x240
 [<ffffffff8119906e>] __writeback_inodes_wb+0x9e/0xd0
 [<ffffffff8119a25b>] wb_writeback+0x25b/0x340
 [<ffffffff8119a7b3>] wb_do_writeback+0x1c3/0x200
 [<ffffffff8119a873>] bdi_writeback_thread+0x83/0x2a0
 [<ffffffff8108ddbc>] kthread+0x8c/0xa0
 [<ffffffff815d9974>] kernel_thread_helper+0x4/0x10

If it tripped the assert I think it did, it looks like the system
was trying to do write IO into a hole in the file. What workload
were you running, and what are the details of your machine + storage
config?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
