Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2T1mWYV197468
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 20:48:32 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 295B0384D77
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 18:51:41 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	6ohpKJ7tZwBMXHQ7 for <linux-xfs@oss.sgi.com>;
	Mon, 28 Mar 2011 18:51:41 -0700 (PDT)
Date: Tue, 29 Mar 2011 12:51:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110329015137.GD3008@dastard>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
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
To: Sean Noonan <Sean.Noonan@twosigma.com>
Cc: Trammell Hudson <Trammell.Hudson@twosigma.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, Christoph Hellwig <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>, 'Michel Lespinasse' <walken@google.com>

On Mon, Mar 28, 2011 at 05:34:09PM -0400, Sean Noonan wrote:
> > Could you test if you see the deadlock before
> > 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272 without MAP_POPULATE ?
> 
> Built and tested 72ddc8f72270758951ccefb7d190f364d20215ab.
> Confirmed that the original bug does not present in this version.
> Confirmed that removing MAP_POPULATE does cause the deadlock to occur.
> 
> Here is the stack of the test:
> # cat /proc/3846/stack
> [<ffffffff812e8a64>] call_rwsem_down_read_failed+0x14/0x30
> [<ffffffff81271c1d>] xfs_ilock+0x9d/0x110
> [<ffffffff81271cae>] xfs_ilock_map_shared+0x1e/0x50
> [<ffffffff81294985>] __xfs_get_blocks+0xc5/0x4e0
> [<ffffffff81294dcc>] xfs_get_blocks+0xc/0x10
> [<ffffffff811322c2>] do_mpage_readpage+0x462/0x660
> [<ffffffff8113250a>] mpage_readpage+0x4a/0x60
> [<ffffffff81295433>] xfs_vm_readpage+0x13/0x20
> [<ffffffff810bb850>] filemap_fault+0x2d0/0x4e0
> [<ffffffff810d8680>] __do_fault+0x50/0x510
> [<ffffffff810da542>] handle_mm_fault+0x1a2/0xe60
> [<ffffffff8102a466>] do_page_fault+0x146/0x440
> [<ffffffff8164e6cf>] page_fault+0x1f/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff

Something else is holding the inode locked here.

> xfssyncd is stuck in D state.
> # cat /proc/2484/stack
> [<ffffffff8106ee1c>] down+0x3c/0x50
> [<ffffffff81297802>] xfs_buf_lock+0x72/0x170
> [<ffffffff8128762d>] xfs_getsb+0x1d/0x50
> [<ffffffff8128e6af>] xfs_trans_getsb+0x5f/0x150
> [<ffffffff8128821e>] xfs_mod_sb+0x4e/0xe0
> [<ffffffff8126e4ea>] xfs_fs_log_dummy+0x5a/0xb0
> [<ffffffff812a2a13>] xfs_sync_worker+0x83/0x90
> [<ffffffff812a28e2>] xfssyncd+0x172/0x220
> [<ffffffff81069576>] kthread+0x96/0xa0
> [<ffffffff81003354>] kernel_thread_helper+0x4/0x10
> [<ffffffffffffffff>] 0xffffffffffffffff

And this is indicating that something else is holding the superblock
locked here. IOWs, whatever thread is having trouble with memory
allocation is causing these threads to block and so they can be
ignored. What's the stack trace of the thread that is throwing the
"I can't allocating a page" errors?

As it is, the question I'd really like answered is how a machine with
48GB RAM can possibly be short of memory when running mmap() on a
16GB file.  The error that XFS is throwing indicates that the
machine cannot allocate a single page of memory, so where has all
your memory gone, and why hasn't the OOM killer been let off the
leash?  What is consuming the other 32GB of RAM or preventing it
from being allocated? 

Also, I was unable to reproduce this at all on a machine with only
2GB of RAM, regardless of the kernel version and/or MAP_POPULATE, so
I'm left to wonder what is special about your test system...

Perhaps the output of xfs_bmap -vvp <file> after a successful vs
deadlocked run would be instructive....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
