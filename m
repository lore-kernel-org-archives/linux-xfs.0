Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 201327F3F
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 16:21:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF96CAC001
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 14:21:19 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zMIOGKTUdjbhmtQd for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 14:21:18 -0800 (PST)
Date: Thu, 19 Dec 2013 09:21:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS blocked task in xlog_cil_force_lsn
Message-ID: <20131218222114.GO31386@dastard>
References: <52B102FF.8040404@pzystorm.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52B102FF.8040404@pzystorm.de>
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
To: Kevin Richter <xfs@pzystorm.de>
Cc: xfs@oss.sgi.com

On Wed, Dec 18, 2013 at 03:05:51AM +0100, Kevin Richter wrote:
> Hi,
> 
> around April 2012 there was a similar thread on this list which I have
> found via Google, so my mail topic is the same.
> 
> I have a RAID6 array with 5 disks (each 2TB, net: 6TB). While copying
> under heavy load there are always these blocks. At the bottom of this
> message I have included some line from the syslog.
> 
> Even a reboot is now not possible anymore, because the whole system
> hangs while executing the "sync" command in one of the shutdown scripts.

Of course it will hang - it's waiting for the filesystem to make
progress, and clearly it isn't....

> 
> So... first I have thought that my disks are faulty.
> But with smartmontools I have started a short and a long test on all of
> the 5 disks: no errors
> 
> Then I have even recreated the whole array, but no improvement.
> 
> Details about my server: 3.2.0-57-generic, Ubuntu 12.04.3 LTS

Oh, that's quite old. I'd suggest upgrading to a much more recent
kernel as we've fixed lots of issues in this area since then.

> >  kswapd0         D ffffffff81806240     0    51      2 0x00000000
> >   ffff8804658099f0 0000000000000046 ffff880465809a74 ffff880465809a78
> >   ffff880465809fd8 ffff880465809fd8 ffff880465809fd8 00000000000137c0
> >   ffff880465dd1700 ffff880465818000 0000000000000000 ffff88046175aa28
> >  Call Trace:
> >   [<ffffffff8165f62f>] schedule+0x3f/0x60
> >   [<ffffffff81660437>] __mutex_lock_slowpath+0xd7/0x150
> >   [<ffffffff8166004a>] mutex_lock+0x2a/0x50
> >   [<ffffffffa029dcf8>] xfs_reclaim_inodes_ag+0x2d8/0x3a0 [xfs]

So, reclaim is stalled, meaning there there's other threads blocked
reclaiming inodes....

> >  INFO: task kswapd1:52 blocked for more than 120 seconds.
> >  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >  kswapd1         D 0000000000000007     0    52      2 0x00000000
> >   ffff88046580b840 0000000000000046 0000000000000001 00000000ffffffff
> >   ffff88046580bfd8 ffff88046580bfd8 ffff88046580bfd8 00000000000137c0
> >   ffff880865e8ae00 ffff880465819700 ffff88046580b830 0000000000000004
> >  Call Trace:
> >   [<ffffffff8165f62f>] schedule+0x3f/0x60
> >   [<ffffffffa02e4d17>] xlog_cil_force_lsn+0xf7/0x120 [xfs]
> >   [<ffffffffa02e3367>] _xfs_log_force_lsn+0x57/0x2e0 [xfs]
> >   [<ffffffffa02e3608>] xfs_log_force_lsn+0x18/0x40 [xfs]
> >   [<ffffffffa02cfdd4>] xfs_iunpin_nowait+0x44/0xb0 [xfs]
> >   [<ffffffffa02d1c65>] xfs_iunpin_wait+0x35/0xb0 [xfs]
> >   [<ffffffffa029cf72>] xfs_reclaim_inode+0xb2/0x2a0 [xfs]

Yup, there's the stalled reclaim, waiting on a log force in progress
to complete.

> > Dec 18 02:19:19 kernel: [390470.199017] INFO: task xfsaild/dm-0:19192 blocked for more than 120 seconds.
> > Dec 18 02:19:19 kernel: [390470.199828] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Dec 18 02:19:19 kernel: [390470.200262] xfsaild/dm-0    D 0000000000000001     0 19192      2 0x00000000
> > Dec 18 02:19:19 kernel: [390470.200268]  ffff88084e847a60 0000000000000046 ffff88046454d500 0000000000000000
> > Dec 18 02:19:19 kernel: [390470.200274]  ffff88084e847fd8 ffff88084e847fd8 ffff88084e847fd8 00000000000137c0
> > Dec 18 02:19:19 kernel: [390470.200281]  ffff88045fdd0000 ffff880461b1dc00 ffff88084e847a50 ffff88085f47d080
> > Dec 18 02:19:19 kernel: [390470.200288] Call Trace:
> > Dec 18 02:19:19 kernel: [390470.200293]  [<ffffffff8165f62f>] schedule+0x3f/0x60
> > Dec 18 02:19:19 kernel: [390470.200323]  [<ffffffffa02e25da>] xlog_state_get_iclog_space+0xea/0x2e0 [xfs]
> > Dec 18 02:19:19 kernel: [390470.200330]  [<ffffffff810608e0>] ? try_to_wake_up+0x200/0x200
> > Dec 18 02:19:19 kernel: [390470.200358]  [<ffffffffa02e2b99>] xlog_write+0xe9/0x400 [xfs]
> > Dec 18 02:19:19 kernel: [390470.200382]  [<ffffffffa02a2877>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
> > Dec 18 02:19:19 kernel: [390470.200410]  [<ffffffffa02e440c>] xlog_cil_push+0x20c/0x380 [xfs]
> > Dec 18 02:19:19 kernel: [390470.200438]  [<ffffffffa02e4d2e>] xlog_cil_force_lsn+0x10e/0x120 [xfs]
> > Dec 18 02:19:19 kernel: [390470.200446]  [<ffffffff810136e5>] ? __switch_to+0xf5/0x360
> > Dec 18 02:19:19 kernel: [390470.200473]  [<ffffffffa02e3098>] _xfs_log_force+0x68/0x2a0 [xfs]
> > Dec 18 02:19:19 kernel: [390470.200481]  [<ffffffff81078cb2>] ? try_to_del_timer_sync+0x92/0x130
> > Dec 18 02:19:19 kernel: [390470.200507]  [<ffffffffa02e32e8>] xfs_log_force+0x18/0x40 [xfs]
> > Dec 18 02:19:19 kernel: [390470.200535]  [<ffffffffa02e7743>] xfsaild_push+0x213/0x680 [xfs]
> > Dec 18 02:19:19 kernel: [390470.200540]  [<ffffffff8165fb45>] ? schedule_timeout+0x175/0x320
> > Dec 18 02:19:19 kernel: [390470.200568]  [<ffffffffa02e7c12>] xfsaild+0x62/0xc0 [xfs]

And there's the log force that is in progress, and that is waiting
on log buffer space to become available to finish the log force.
That's waiting on IO completion to occur.

IOWs, There's nothing that points directly at an XFS issue here.
There might be a problem, but it's just as likely a hardware or IO
path bug that is preventing an IO completion from occurring and that
is what XFS is getting hung up on....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
