Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAT04deJ229747 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 18:04:39 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	571rMm5FdGRaS4CV (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 16:06:56 -0800 (PST)
Date: Wed, 28 Nov 2012 19:06:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: byte range granularity for XFS_IOC_ZERO_RANGE
Message-ID: <20121129000655.GA6673@infradead.org>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
	<1354068063-1692-3-git-send-email-david@fromorbit.com>
	<20121128133305.GA7426@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121128133305.GA7426@infradead.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Actually this seems to trip up an assert in xfstests 290 for me:

290 0s ...[   45.997814] XFS: Assertion failed: offset + len <= start_boundary || offset == start_boundary, file: fs/xfs/xfs_vnodeops.c, line: 2153
[   46.000534] ------------[ cut here ]------------
[   46.001523] kernel BUG at fs/xfs/xfs_message.c:100!
[   46.002517] invalid opcode: 0000 [#1] SMP 
[   46.003614] Modules linked in:
[   46.003797] CPU 0 
[   46.003797] Pid: 4026, comm: xfs_io Not tainted 3.7.0-rc1+ #513 Bochs Bochs
[   46.003797] RIP: 0010:[<ffffffff8145f5fd>]  [<ffffffff8145f5fd>] assfail+0x1d/0x20
[   46.003797] RSP: 0018:ffff88005961dc28  EFLAGS: 00010292
[   46.003797] RAX: 000000000000007a RBX: 0000000000000fff RCX: 0000000000000006
[   46.003797] RDX: 0000000000000006 RSI: ffff88005658e710 RDI: ffff88005658e080
[   46.003797] RBP: ffff88005961dc28 R08: 0000000000000000 R09: 0000000000000000
[   46.003797] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000001000
[   46.003797] R13: 0000000000001000 R14: ffff88005b3de640 R15: 0000000000001fff
[   46.003797] FS:  0000000000000000(0000) GS:ffff88005d800000(0063) knlGS:00000000f76198d0
[   46.003797] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[   46.003797] CR2: 00000000f7780000 CR3: 0000000059f61000 CR4: 00000000000006f0
[   46.003797] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   46.003797] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   46.003797] Process xfs_io (pid: 4026, threadinfo ffff88005961c000, task ffff88005658e080)
[   46.003797] Stack:
[   46.003797]  ffff88005961dc88 ffffffff81467bcb ffff88005964b800 0000000000000000
[   46.003797]  0000000000001000 0000000000000000 ffffffff811a2a33 ffff88005b3de640
[   46.003797]  0000000000000000 0000000000000fff 0000000000002000 ffff880059f14800
[   46.003797] Call Trace:
[   46.003797]  [<ffffffff81467bcb>] xfs_zero_file_space+0xdb/0x1c0
[   46.003797]  [<ffffffff811a2a33>] ? mnt_want_write_file+0x23/0x50
[   46.003797]  [<ffffffff81467e11>] xfs_change_file_space+0x161/0x390
[   46.003797]  [<ffffffff811a1aad>] ? mnt_clone_write+0xd/0x40
[   46.003797]  [<ffffffff811a29fc>] ? __mnt_want_write_file+0x3c/0x50
[   46.003797]  [<ffffffff8145914c>] xfs_ioc_space+0xbc/0x120
[   46.003797]  [<ffffffff8115ec6e>] ? might_fault+0x4e/0xa0
[   46.003797]  [<ffffffff814dd85c>] xfs_file_compat_ioctl+0x4dc/0x6d0
[   46.003797]  [<ffffffff8119e6ca>] ? fget_light+0x3da/0x4d0
[   46.003797]  [<ffffffff811d72c7>] compat_sys_ioctl+0x97/0x14c0
[   46.003797]  [<ffffffff8115ec6e>] ? might_fault+0x4e/0xa0
[   46.003797]  [<ffffffff8115ecb7>] ? might_fault+0x97/0xa0
[   46.003797]  [<ffffffff8115ec6e>] ? might_fault+0x4e/0xa0
[   46.003797]  [<ffffffff816f661d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   46.003797]  [<ffffffff81b883e1>] sysenter_dispatch+0x7/0x23
[   46.003797]  [<ffffffff816f65de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   46.003797] Code: ff ff 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 f1 41 89 d0 48 89 e5 48 89 fa 48 c7 c6 78 2f f4 81 31 ff 31 c0 e8 a3 fc ff ff <0f> 0b 90 55 48 63 f6 49 89 f9 48 89 e5 48 83 ec 10 41 b8 01 00 
[   46.003797] RIP  [<ffffffff8145f5fd>] assfail+0x1d/0x20
[   46.003797]  RSP <ffff88005961dc28>
[   46.080287] ---[ end trace 512c2106b365194f ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
