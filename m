Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5C1IHRg159975 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 20:18:17 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZwnlHXJW3QiK4CD5 for <xfs@oss.sgi.com>;
	Mon, 11 Jun 2012 18:18:14 -0700 (PDT)
Date: Tue, 12 Jun 2012 11:18:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
Message-ID: <20120612011812.GK22848@dastard>
References: <4FD66513.2000108@xsnews.nl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD66513.2000108@xsnews.nl>
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
To: Matthew Whittaker-Williams <matthew@xsnews.nl>
Cc: xfs@oss.sgi.com

On Mon, Jun 11, 2012 at 11:37:23PM +0200, Matthew Whittaker-Williams wrote:
> Dear Developers,
> 
> We are running into some problems with xfs and the LSI 9265-8i Controller.
> 
> http://www.lsi.com/products/storagecomponents/Pages/MegaRAIDSAS9265-8i.aspx
> 
> When running high i/o on raid 6 array with this controller xfs
> freezes up and we get the following errors:
> 
> Linux sd69 3.4.1-custom #4 SMP Mon Jun 11 09:35:31 CEST 2012 x86_64
> GNU/Linux
> 
> [   62.911481] XFS (sda): Mounting Filesystem
> [   63.212456] XFS (sda): Starting recovery (logdev: internal)
> [   64.016420] XFS (sda): Ending recovery (logdev: internal)
> [   64.020549] XFS (sdb): Mounting Filesystem
> [   64.371207] XFS (sdb): Starting recovery (logdev: internal)
> [   65.265051] XFS (sdb): Ending recovery (logdev: internal)
> [ 6110.298886] INFO: task kworker/0:0:11244 blocked for more than
> 120 seconds.
> [ 6110.298942] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 6110.299000] kworker/0:0     D ffff8805ecf52880     0 11244      2
> 0x00000000
> [ 6110.299044]  ffff8805ecf52880 0000000000000046 0000000000000000
> ffffffff81613020
> [ 6110.299107]  00000000000132c0 ffff880582d65fd8 00000000000132c0
> ffff880582d65fd8
> [ 6110.299170]  00000000000132c0 ffff8805ecf52880 00000000000132c0
> ffff880582d64010
> [ 6110.299233] Call Trace:
> [ 6110.299266]  [<ffffffff8134d55a>] ? schedule_timeout+0x2d/0xd7
> [ 6110.299305]  [<ffffffff810f62f5>] ? kmem_cache_alloc+0x2a/0xee
> [ 6110.299358]  [<ffffffffa02cbff4>] ? kmem_zone_alloc+0x58/0x9e [xfs]
> [ 6110.299395]  [<ffffffff8134de6b>] ? __down_common+0x93/0xe4
> [ 6110.299443]  [<ffffffffa03062b0>] ? xfs_getsb+0x2f/0x5c [xfs]
> [ 6110.299480]  [<ffffffff81057994>] ? down+0x27/0x37
> [ 6110.299520]  [<ffffffffa02b81e7>] ? xfs_buf_lock+0x65/0xb2 [xfs]
> [ 6110.299568]  [<ffffffffa03062b0>] ? xfs_getsb+0x2f/0x5c [xfs]
> [ 6110.299613]  [<ffffffffa0312e3b>] ? xfs_trans_getsb+0xa5/0xf5 [xfs]
> [ 6110.299663]  [<ffffffffa0306c9a>] ? xfs_mod_sb+0x43/0x10f [xfs]
> [ 6110.299710]  [<ffffffffa02c70f6>] ? xfs_flush_inodes+0x23/0x23 [xfs]
> [ 6110.299755]  [<ffffffffa02bcd06>] ? xfs_fs_log_dummy+0x61/0x75 [xfs]
> [ 6110.299802]  [<ffffffffa0311978>] ? xfs_ail_min_lsn+0xd/0x2e [xfs]
> [ 6110.299849]  [<ffffffffa02c7133>] ? xfs_sync_worker+0x3d/0x60 [xfs]
> [ 6110.299888]  [<ffffffff812703b6>] ? powersave_bias_target+0x14b/0x14b
> [ 6110.299924]  [<ffffffff8104fa39>] ? process_one_work+0x1cd/0x2eb
> [ 6110.299960]  [<ffffffff8104fc85>] ? worker_thread+0x12e/0x249
> [ 6110.299993]  [<ffffffff8104fb57>] ? process_one_work+0x2eb/0x2eb
> [ 6110.300029]  [<ffffffff8104fb57>] ? process_one_work+0x2eb/0x2eb
> [ 6110.300064]  [<ffffffff8105356e>] ? kthread+0x81/0x89
> [ 6110.300098]  [<ffffffff813569a4>] ? kernel_thread_helper+0x4/0x10

That's pretty much a meaningless stack trace. Can you recompile your
kernel with frame pointers enabled so we can get a reliable stack
trace?

> Could you have a look into this issue?

We know there is a lurking problem that we've been trying to flush
out over the past couple of months. Do a search for hangs in
xlog_grant_log_space - we've found several problems in
the process, but there's still a remaining hang that is likely to be
the source of your problems.

> If you need any more information I am happy to provide it.

What workload are you running that triggers this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
