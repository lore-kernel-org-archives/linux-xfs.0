Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ECAB67F5D
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 22:33:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA224304032
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 20:33:05 -0700 (PDT)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	VFz9PlrlOymt3GzN for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 20:33:04 -0700 (PDT)
Date: Thu, 10 Oct 2013 11:33:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
	pointer dereference at 00000003
Message-ID: <20131010033300.GA12952@localhost>
References: <20131009073910.GA387@localhost>
	<20131010005900.GE2025@devil.localdomain>
	<20131010011640.GA5726@localhost> <20131010014117.GA6017@localhost>
	<20131010031515.GT4446@dastard> <20131010032637.GA12725@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131010032637.GA12725@localhost>
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

On Thu, Oct 10, 2013 at 11:26:37AM +0800, Fengguang Wu wrote:
> Dave,
> 
> > I note that you have CONFIG_SLUB=y, which means that the cache slabs
> > are shared with objects of other types. That means that the memory
> > corruption problem is likely to be caused by one of the other
> > filesystems that is probing the block device(s), not XFS.
> 
> Good to know that, it would easy to test then: just turn off every
> other filesystems. I'll try it right away.

Seems that we don't even need to do that. A dig through the oops
database and I find stack dumps from other FS.

This happens in the kernel with same kconfig and commit 3.12-rc1.

[   51.205369] block nbd1: Attempted send on closed socket
[   51.214126] BUG: unable to handle kernel NULL pointer dereference at 00000004
[   51.215640] IP: [<c10343fb>] pool_mayday_timeout+0x5f/0x9c
[   51.216262] *pdpt = 000000000ca90001 *pde = 0000000000000000 
[   51.216262] Oops: 0000 [#1] 
[   51.216262] CPU: 0 PID: 644 Comm: mount Not tainted 3.12.0-rc1 #2
[   51.216262] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   51.216262] task: ccffd7a0 ti: cca54000 task.ti: cca54000
[   51.216262] EIP: 0060:[<c10343fb>] EFLAGS: 00000046 CPU: 0
[   51.216262] EIP is at pool_mayday_timeout+0x5f/0x9c
[   51.216262] EAX: 00000000 EBX: c1a81d50 ECX: 00000000 EDX: 00000000
[   51.216262] ESI: cd0d303c EDI: cfff7054 EBP: cca55d2c ESP: cca55d18
[   51.216262]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   51.216262] CR0: 8005003b CR2: 00000004 CR3: 0ca0b000 CR4: 000006b0
[   51.216262] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   51.216262] DR6: 00000000 DR7: 00000000
[   51.216262] Stack:
[   51.216262]  c1a81d60 cd0d303c 00000100 c103439c cca55d58 cca55d3c c102cd96 c1ba4700
[   51.216262]  cca55d58 cca55d6c c102cf7e c1a81d50 c1ba5110 c1ba4f10 cca55d58 c103439c
[   51.216262]  cca55d58 cca55d58 00000001 c1ba4588 00000100 cca55d90 c1028f61 00000001
[   51.216262] Call Trace:
[   51.216262]  [<c103439c>] ? need_to_create_worker+0x32/0x32
[   51.216262]  [<c102cd96>] call_timer_fn.isra.39+0x16/0x60
[   51.216262]  [<c102cf7e>] run_timer_softirq+0x144/0x15e
[   51.216262]  [<c103439c>] ? need_to_create_worker+0x32/0x32
[   51.216262]  [<c1028f61>] __do_softirq+0x87/0x12b
[   51.216262]  [<c10290c4>] irq_exit+0x3a/0x48
[   51.216262]  [<c1002918>] do_IRQ+0x64/0x77
[   51.216262]  [<c175fbac>] common_interrupt+0x2c/0x31
[   51.216262]  [<c12188ee>] ? ocfs2_get_sector+0x14/0x1cd
[   51.216262]  [<c1218b72>] ocfs2_sb_probe+0xcb/0x7ca
[   51.216262]  [<c107bb1c>] ? bdi_lock_two+0x8/0x14
[   51.216262]  [<c12cfc11>] ? string.isra.4+0x26/0x89
[   51.216262]  [<c121a7ba>] ocfs2_fill_super+0x39/0xe84
[   51.216262]  [<c12d1000>] ? pointer.isra.15+0x23f/0x25b
[   51.216262]  [<c12c3660>] ? disk_name+0x20/0x65
[   51.216262]  [<c109d8f6>] mount_bdev+0x105/0x14d
[   51.216262]  [<c1092aaa>] ? slab_pre_alloc_hook.isra.66+0x1e/0x25
[   51.216262]  [<c1095353>] ? __kmalloc_track_caller+0xb8/0xe4
[   51.216262]  [<c10ae5da>] ? alloc_vfsmnt+0xdc/0xff
[   51.216262]  [<c1217173>] ocfs2_mount+0x10/0x12
[   51.216262]  [<c121a781>] ? ocfs2_handle_error+0xa2/0xa2
[   51.216262]  [<c109dad1>] mount_fs+0x55/0x123
[   51.216262]  [<c10aef24>] vfs_kern_mount+0x44/0xac
[   51.216262]  [<c10b030a>] do_mount+0x647/0x768
[   51.216262]  [<c107b043>] ? strndup_user+0x2c/0x3d
[   51.216262]  [<c10b049c>] SyS_mount+0x71/0xa0
[   51.216262]  [<c175f074>] syscall_call+0x7/0xb
[   51.216262] Code: 43 44 e8 7a 8c ff ff 58 5a 5b 5e 5f 5d c3 8b 43 10 8d 78 fc 8d 43 10 89 45 ec 8d 47 04 3b 45 ec 74 ca 89 f8 e8 44 f0 ff ff 89 c1 <8b> 50 04 83 7a 44 00 74 2c 8b 40 68 8d 71 68 39 f0 75 22 8b 72
[   51.216262] EIP: [<c10343fb>] pool_mayday_timeout+0x5f/0x9c SS:ESP 0068:cca55d18
[   51.216262] CR2: 0000000000000004
[   51.216262] ---[ end trace 267272283b2d7610 ]---
[   51.216262] Kernel panic - not syncing: Fatal exception in interrupt

[    3.244964] block nbd1: Attempted send on closed socket
[    3.246243] block nbd1: Attempted send on closed socket
[    3.247508] (mount,661,0):ocfs2_get_sector:1861 ERROR: status = -5
[    3.248906] (mount,661,0):ocfs2_sb_probe:770 ERROR: status = -5
[    3.250269] (mount,661,0):ocfs2_fill_super:1038 ERROR: superblock probe failed!
[    3.252100] (mount,661,0):ocfs2_fill_super:1229 ERROR: status = -5
[    3.253569] BUG: unable to handle kernel NULL pointer dereference at 00000004
[    3.255322] IP: [<c1034850>] process_one_work+0x1a/0x1cc
[    3.256681] *pdpt = 000000000c950001 *pde = 0000000000000000 
[    3.256833] Oops: 0000 [#1] 
[    3.256833] CPU: 0 PID: 5 Comm: kworker/0:0H Not tainted 3.12.0-rc1 #2
[    3.256833] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.256833] task: cec44d80 ti: cec54000 task.ti: cec54000
[    3.256833] EIP: 0060:[<c1034850>] EFLAGS: 00010046 CPU: 0
[    3.256833] EIP is at process_one_work+0x1a/0x1cc
[    3.256833] EAX: 00000000 EBX: cec1b900 ECX: ccdf0700 EDX: ccdf0700
[    3.256833] ESI: ccdf0754 EDI: c1a81d50 EBP: cec55f44 ESP: cec55f2c
[    3.256833]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    3.256833] CR0: 8005003b CR2: 0000005c CR3: 0cfc5000 CR4: 000006b0
[    3.256833] Stack:
[    3.256833]  c1a81d50 00000000 c10345b0 cec1b900 cec1b918 cec1b918 cec55f54 c1034a1d
[    3.256833]  cec1b900 c1a81d50 cec55f70 c1034d3b cec44d80 c1a81d60 cec47eac cec1b900
[    3.256833]  c1034c02 cec55fac c10388f7 cec55f94 00000000 00000000 cec1b900 00000000
[    3.256833] Call Trace:
[    3.256833]  [<c10345b0>] ? manage_workers.isra.33+0x178/0x182
[    3.256833]  [<c1034a1d>] process_scheduled_works+0x1b/0x21
[    3.256833]  [<c1034d3b>] worker_thread+0x139/0x1bd
[    3.256833]  [<c1034c02>] ? rescuer_thread+0x1df/0x1df
[    3.256833]  [<c10388f7>] kthread+0x6d/0x72
[    3.256833]  [<c175f637>] ret_from_kernel_thread+0x1b/0x28
[    3.256833]  [<c103888a>] ? init_completion+0x1d/0x1d
[    3.256833] Code: 83 f8 10 74 04 f3 90 b2 f5 89 d0 59 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 0c 89 c3 89 d6 89 d0 e8 f3 eb ff ff 89 45 ec 8b 7b 24 <8b> 40 04 8b 80 80 00 00 00 c1 e8 05 83 e0 01 88 45 e8 f6 43 2c
[    3.256833] EIP: [<c1034850>] process_one_work+0x1a/0x1cc SS:ESP 0068:cec55f2c
[    3.256833] CR2: 0000000000000004
[    3.256833] ---[ end trace a45beaff7f786118 ]---
[    3.256833] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[    3.256833] in_atomic(): 1, irqs_disabled(): 1, pid: 5, name: kworker/0:0H

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
