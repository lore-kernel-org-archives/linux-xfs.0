Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 138E57F62
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 02:05:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2C4A30406B
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 00:05:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dkBtxQsdN4AII5k3 for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 00:05:40 -0700 (PDT)
Date: Tue, 2 Apr 2013 18:05:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
	xfstests case #78]
Message-ID: <20130402070537.GP6369@dastard>
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
	<247719576.438259.1364882929749.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <247719576.438259.1364882929749.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: axboe@kernel.dk, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

[Added jens Axboe to CC]

On Tue, Apr 02, 2013 at 02:08:49AM -0400, CAI Qian wrote:
> Saw on almost all the servers range from x64, ppc64 and s390x with kernel
> 3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks like
> something new broke this. Log is here with sysrq debug info.
> http://people.redhat.com/qcai/stable/log

Has nothing to do with XFS:

[34762.105676] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[34762.152871] systemd-udevd   D ffff88030bc94440     0  4391    412 0x00000084 
[34762.196660]  ffff8801134d9a98 0000000000000082 ffff880303e09ac0 ffff8801134d9fd8 
[34762.240512]  ffff8801134d9fd8 ffff8801134d9fd8 ffff880304f98000 ffff880303e09ac0 
[34762.287047]  ffff8802936c1ac0 ffff88060521f998 ffff88060521f99c ffff880303e09ac0 
[34762.331446] Call Trace: 
[34762.345444]  [<ffffffff816274a9>] schedule+0x29/0x70 
[34762.373908]  [<ffffffff8162777e>] schedule_preempt_disabled+0xe/0x10 
[34762.411394]  [<ffffffff81625ae3>] __mutex_lock_slowpath+0xc3/0x140 
[34762.447597]  [<ffffffff8162561a>] mutex_lock+0x2a/0x50 
[34762.476785]  [<ffffffff811daddb>] __blkdev_get+0x6b/0x4b0 
[34762.508839]  [<ffffffff812a619a>] ? selinux_file_alloc_security+0x4a/0x80 
[34762.546436]  [<ffffffff811db3bd>] blkdev_get+0x19d/0x2e0 
[34762.580977]  [<ffffffff812a18fa>] ? inode_has_perm.isra.31.constprop.61+0x2a/0x30 
[34762.624346]  [<ffffffff811db55f>] blkdev_open+0x5f/0x90 
[34762.656318]  [<ffffffff811a00bf>] do_dentry_open+0x20f/0x2c0 
[34762.689762]  [<ffffffff811db500>] ? blkdev_get+0x2e0/0x2e0 
[34762.722221]  [<ffffffff811a01a5>] finish_open+0x35/0x50 
[34762.754363]  [<ffffffff811b082e>] do_last+0x6de/0xde0 
[34762.783808]  [<ffffffff811ad378>] ? inode_permission+0x18/0x50 
[34762.819265]  [<ffffffff811ad428>] ? link_path_walk+0x78/0x880 
[34762.853700]  [<ffffffff812a619a>] ? selinux_file_alloc_security+0x4a/0x80 
[34762.892881]  [<ffffffff811b0fe7>] path_openat+0xb7/0x4b0 
[34762.923621]  [<ffffffff811ad0e0>] ? getname_flags.part.33+0x30/0x150 
[34762.960839]  [<ffffffff811b16a1>] do_filp_open+0x41/0xa0 
[34762.992114]  [<ffffffff811bddc2>] ? __alloc_fd+0x42/0x110 
[34763.023342]  [<ffffffff811a14f4>] do_sys_open+0xf4/0x1e0 
[34763.054129]  [<ffffffff811a1601>] sys_open+0x21/0x30 
[34763.082134]  [<ffffffff81630d59>] system_call_fastpath+0x16/0x1b 


And:

[34763.116218] INFO: task umount:4421 blocked for more than 120 seconds. 
[34763.153670] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[34763.200321] umount          D ffff88030bcb4440     0  4421    452 0x00000080 
[34763.242026]  ffff8801134fbcb8 0000000000000082 ffff8802936c1ac0 ffff8801134fbfd8 
[34763.287320]  ffff8801134fbfd8 ffff8801134fbfd8 ffff8803069d0000 ffff8802936c1ac0 
[34763.330722]  ffff8802936c1ac0 ffff88060521f998 ffff88060521f99c ffff8802936c1ac0 
[34763.374428] Call Trace: 
[34763.388977]  [<ffffffff816274a9>] schedule+0x29/0x70 
[34763.419164]  [<ffffffff8162777e>] schedule_preempt_disabled+0xe/0x10 
[34763.456279]  [<ffffffff81625ae3>] __mutex_lock_slowpath+0xc3/0x140 
[34763.492474]  [<ffffffff8162561a>] mutex_lock+0x2a/0x50 
[34763.520840]  [<ffffffff81417da5>] loop_clr_fd+0x285/0x480 
[34763.552050]  [<ffffffff81418800>] lo_release+0x70/0x80 
[34763.580787]  [<ffffffff811dabac>] __blkdev_put+0x17c/0x1d0 
[34763.612479]  [<ffffffff811dac57>] blkdev_put+0x57/0x140 
[34763.641557]  [<ffffffff811a409d>] kill_block_super+0x4d/0x80 
[34763.674257]  [<ffffffff811a4467>] deactivate_locked_super+0x57/0x80 
[34763.708755]  [<ffffffff811a4fee>] deactivate_super+0x4e/0x70 
[34763.742906]  [<ffffffff811bfbb7>] mntput_no_expire+0xd7/0x130 
[34763.776872]  [<ffffffff811c0a9c>] sys_umount+0x9c/0x3c0 
[34763.811819]  [<ffffffff81630d59>] system_call_fastpath+0x16/0x1b 


It's clearly a loopback device problem, stuck on the
bdev->bd_inode->i_mutex. And there's changesin the loop device
teardown since 3.9-rc4:

$ glo v3.9-rc4..HEAD -- drivers/block/loop.c  
c1681bf loop: prevent bdev freeing while device in use
8761a3d loop: cleanup partitions when detaching loop device
183cfb5 loop: fix error return code in loop_add()
$

So this looks like someone hasn't been testing their loopback
driver changes properly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
