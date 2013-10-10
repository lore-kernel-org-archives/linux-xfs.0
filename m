Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 54B4C7F50
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 20:41:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 357CD304051
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 18:41:23 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [143.182.124.21]) by
	cuda.sgi.com with ESMTP id 39B4t6X74k1lH2KC for
	<xfs@oss.sgi.com>; Wed, 09 Oct 2013 18:41:21 -0700 (PDT)
Date: Thu, 10 Oct 2013 09:41:17 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
	pointer dereference at 00000003
Message-ID: <20131010014117.GA6017@localhost>
References: <20131009073910.GA387@localhost>
	<20131010005900.GE2025@devil.localdomain>
	<20131010011640.GA5726@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131010011640.GA5726@localhost>
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
To: Dave Chinner <dchinner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 10, 2013 at 09:16:40AM +0800, Fengguang Wu wrote:
> On Thu, Oct 10, 2013 at 11:59:00AM +1100, Dave Chinner wrote:
> > [add xfs@oss.sgi.com to cc]
> 
> Thanks.
> 
> To help debug the problem, I searched XFS in my tests' oops database
> and find one kernel that failed 4 times (out of 12 total boots) with
> basically the same error:
> 
>       4 BUG: sleeping function called from invalid context at kernel/workqueue.c:2810
>       1 WARNING: CPU: 1 PID: 372 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
>       1 WARNING: CPU: 1 PID: 360 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
>       1 WARNING: CPU: 0 PID: 381 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
>       1 WARNING: CPU: 0 PID: 361 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()

And some other messages in an older kernel:

[   39.004416] F2FS-fs (nbd2): unable to read second superblock
[   39.005088] XFS: Assertion failed: read && bp->b_ops, file: fs/xfs/xfs_buf.c, line: 1036
[   39.005089] ------------[ cut here ]------------
[   39.005096] WARNING: CPU: 1 PID: 20 at fs/xfs/xfs_message.c:100 asswarn+0x33/0x40()
[   39.005099] CPU: 1 PID: 20 Comm: kworker/1:0H Not tainted 3.11.0-rc1-00667-gf70eb07 #64
[   39.005100] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   39.005106] Workqueue: xfslogd xfs_buf_iodone_work
[   39.005110]  0000000000000009 ffff88000ed91ce0 ffffffff824044a1 0000000000000000
[   39.005113]  ffff88000ed91d18 ffffffff8109a0a8 ffff880007d6cea8 ffff880007d6cd80
[   39.005116]  0000000000000000 0000000000000000 0000000000000060 ffff88000ed91d28
[   39.005116] Call Trace:
[   39.005122]  [<ffffffff824044a1>] dump_stack+0x4e/0x82
[   39.005126]  [<ffffffff8109a0a8>] warn_slowpath_common+0x78/0xa0
[   39.005129]  [<ffffffff8109a1ba>] warn_slowpath_null+0x1a/0x20
[   39.005131]  [<ffffffff813e70d3>] asswarn+0x33/0x40
[   39.005134]  [<ffffffff813d0f82>] xfs_buf_iodone_work+0x92/0x200
[   39.005138]  [<ffffffff810bbdfa>] process_one_work+0x1fa/0x6f0
[   39.005141]  [<ffffffff810bbd98>] ? process_one_work+0x198/0x6f0
[   39.005144]  [<ffffffff810bc40d>] worker_thread+0x11d/0x3a0
[   39.005146]  [<ffffffff810bc2f0>] ? process_one_work+0x6f0/0x6f0
[   39.005149]  [<ffffffff810c80dd>] kthread+0xed/0x100
[   39.005153]  [<ffffffff8110391d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[   39.005156]  [<ffffffff810c7ff0>] ? insert_kthread_work+0x80/0x80
[   39.005159]  [<ffffffff82418efc>] ret_from_fork+0x7c/0xb0
[   39.005162]  [<ffffffff810c7ff0>] ? insert_kthread_work+0x80/0x80
[   39.005164] ---[ end trace be5b205ae29d07cd ]---
[   39.028229] block nbd6: Attempted send on closed socket
[   39.028988] block nbd6: Attempted send on closed socket
[   39.029109] block nbd6: Attempted send on closed socket

[   41.550438] block nbd7: Attempted send on closed socket
[   41.550471] ------------[ cut here ]------------
[   41.550476] WARNING: CPU: 1 PID: 878 at lib/list_debug.c:33 __list_add+0xac/0xc0()
[   41.550478] list_add corruption. prev->next should be next (ffff88000f3d7360), but was           (null). (prev=ffff880008786a30).
[   41.550481] CPU: 1 PID: 878 Comm: mount Not tainted 3.11.0-rc1-00667-gf70eb07 #64
[   41.550482] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   41.550485]  0000000000000009 ffff880007d6fb08 ffffffff824044a1 ffff880007d6fb50
[   41.550488]  ffff880007d6fb40 ffffffff8109a0a8 ffff880007c6b530 ffff88000f3d7360
[   41.550491]  ffff880008786a30 0000000000000007 0000000000000000 ffff880007d6fba0
[   41.550491] Call Trace:
[   41.550499]  [<ffffffff824044a1>] dump_stack+0x4e/0x82
[   41.550503]  [<ffffffff8109a0a8>] warn_slowpath_common+0x78/0xa0
[   41.550505]  [<ffffffff8109a14c>] warn_slowpath_fmt+0x4c/0x50
[   41.550509]  [<ffffffff81101359>] ? get_lock_stats+0x19/0x60
[   41.550511]  [<ffffffff8163434c>] __list_add+0xac/0xc0
[   41.550515]  [<ffffffff810ba453>] insert_work+0x43/0xa0
[   41.550518]  [<ffffffff810bb22b>] __queue_work+0x11b/0x510
[   41.550520]  [<ffffffff810bb936>] queue_work_on+0x96/0xa0
[   41.550526]  [<ffffffff813d2096>] ? _xfs_buf_ioend.constprop.15+0x26/0x30
[   41.550529]  [<ffffffff813d1f6c>] xfs_buf_ioend+0x15c/0x260
[   41.550531]  [<ffffffff813d2f92>] ? xfsbdstrat+0x22/0x170
[   41.550534]  [<ffffffff813d2096>] _xfs_buf_ioend.constprop.15+0x26/0x30
[   41.550537]  [<ffffffff813d2873>] xfs_buf_iorequest+0x73/0x1a0
[   41.550539]  [<ffffffff813d2f92>] xfsbdstrat+0x22/0x170
[   41.550542]  [<ffffffff813d3832>] xfs_buf_read_uncached+0x72/0xa0
[   41.550546]  [<ffffffff81445846>] xfs_readsb+0x176/0x250
[   41.550550]  [<ffffffff813ea2da>] xfs_fs_fill_super+0x24a/0x3a0
[   41.550553]  [<ffffffff811b9f40>] mount_bdev+0x1c0/0x200
[   41.550556]  [<ffffffff813ea090>] ? xfs_parseargs+0xc10/0xc10
[   41.550559]  [<ffffffff81101ff6>] ? lock_release_holdtime.part.29+0xe6/0x160
[   41.550561]  [<ffffffff813e84f5>] xfs_fs_mount+0x15/0x20
[   41.550563]  [<ffffffff811ba199>] mount_fs+0x39/0x1b0
[   41.550567]  [<ffffffff81190980>] ? __alloc_percpu+0x10/0x20
[   41.550571]  [<ffffffff811d8ff3>] vfs_kern_mount+0x63/0xf0
[   41.550574]  [<ffffffff811da85e>] do_mount+0x23e/0xa20
[   41.550577]  [<ffffffff8118bcbb>] ? strndup_user+0x4b/0x60
[   41.550579]  [<ffffffff811db0c3>] SyS_mount+0x83/0xc0
[   41.550583]  [<ffffffff824191d0>] tracesys+0xdd/0xe2
[   41.550584] ---[ end trace 5193f938804cbcca ]---
[   41.550820] block nbd15: Attempted send on closed socket

[   38.738751] block nbd9: Attempted send on closed socket
[   38.738775] F2FS-fs (nbd9): unable to read first superblock
[   38.738852] block nbd9: Attempted send on closed socket
[   38.738875] F2FS-fs (nbd9): unable to read second superblock
 ffff8800001cbde0 ffffffff810b9ddf ffff8800081dfe18
[   38.740053]  ffff88000f1d3638 ffff88000f1d3240 ffff88000f1d3298 ffff8800000394c8
[   38.740053] Call Trace:
[   38.740053]  [<ffffffff824130ce>] ? mutex_unlock+0xe/0x10
[   38.740053]  [<ffffffff810b9ddf>] ? manage_workers.isra.28+0x1ef/0x2b0
[   38.740053]  [<ffffffff810bc40d>] worker_thread+0x11d/0x3a0
[   38.740053]  [<ffffffff810bc2f0>] ? process_one_work+0x6f0/0x6f0
[   38.740053]  [<ffffffff810c80dd>] kthread+0xed/0x100
[   38.740053]  [<ffffffff8110391d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[   38.740053]  [<ffffffff810c7ff0>] ? insert_kthread_work+0x80/0x80
[   38.740053]  [<ffffffff82418efc>] ret_from_fork+0x7c/0xb0
[   38.740053]  [<ffffffff810c7ff0>] ? insert_kthread_work+0x80/0x80
[   38.740053] Code: 57 41 56 41 55 45 31 ed 41 54 49 89 f4 53 48 89 fb 48 83 ec 48 48 8b 06 48 89 c2 30 d2 a8 04 48 8b 47 48 4c 0f 45 ea 48 89 45 a0 <49> 8b 45 08 48 c7 45 b0 00 00 00 00 48 c7 45 b8 00 00 00 00 44 
[   38.740053] RIP  [<ffffffff810bbc35>] process_one_work+0x35/0x6f0
[   38.740053]  RSP <ffff8800001cbd70>
[   38.740053] CR2: 0000000000000008
[   38.740053] ---[ end trace b1f41925f36484b0 ]---
[   38.740053] BUG: sleeping function called from invalid context at kernel/rwsem.c:20

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
