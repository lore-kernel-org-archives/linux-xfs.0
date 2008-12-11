Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBBIU0Pa000309 for <xfs@oss.sgi.com>; Thu, 11 Dec 2008 12:30:01 -0600
Date: Thu, 11 Dec 2008 19:29:55 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [xfs-masters] next-20081210: BUG: sleeping function called from
	invalid context at mm/slub.c:1619 (XFS)
Message-ID: <20081211182955.GB27952@lst.de>
References: <a4423d670812110210g50d66304pb0a7d96b3dde00c7@mail.gmail.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a4423d670812110210g50d66304pb0a7d96b3dde00c7@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: xfs-masters@oss.sgi.com, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Dec 11, 2008 at 01:10:23PM +0300, Alexander Beregalov wrote:
> BUG: sleeping function called from invalid context at mm/slub.c:1619
> in_atomic(): 1, irqs_disabled(): 0, pid: 8096, name: sh
> INFO: lockdep is turned off.
> Pid: 8096, comm: sh Tainted: G        W  2.6.28-rc7-next-20081210 #2
> Call Trace:
>  [<ffffffff80256e5a>] ? __debug_show_held_locks+0x1b/0x24
>  [<ffffffff8022fb55>] __might_sleep+0x120/0x122
>  [<ffffffff8029c526>] __kmalloc+0x70/0xfc
>  [<ffffffff803534d2>] kmem_alloc+0x75/0xd7
>  [<ffffffff803350ba>] xfs_fs_vcmn_err+0x46/0x94
>  [<ffffffff80335297>] xfs_fs_cmn_err+0x59/0x5e

xfs_fs_vcmn_err does a sleeping memory allocation under a spinlock,
nasty.  I have an idea that will get rid of the memory allocation
completely, I'll come back to you once I have hacked something up.

> Filesystem "sda2": xlog_space_left: head behind tail
>   tail_cycle = 1802201963, tail_bytes = -690563584
>   GH   cycle = 3078, GH   bytes = 69183384

This btw is a bug, too..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
