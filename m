Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2L1Xeqb174401 for <xfs@oss.sgi.com>; Sun, 20 Mar 2011 20:33:45 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 479F013E88FE
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2011 18:36:28 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id Wrxcnxcc4vcdu0Sp
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2011 18:36:28 -0700 (PDT)
Received: by fxm11 with SMTP id 11so5146520fxm.26
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2011 18:36:27 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 21 Mar 2011 04:34:46 +0300
Message-ID: <AANLkTincs+MyYf+2tt2Y3LMQdmF8PUAxKMxMXuKB72hZ@mail.gmail.com>
Subject: 2.6.39-rc0: xfs: kernel BUG at mm/page_alloc.c:738
From: Alexander Beregalov <a.beregalov@gmail.com>
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
To: xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi

Steps to reproduce:
run xfs_fsr on xfs device

arch is x86 UP, kernel is 2.6.38-06507-ga952baa

kernel BUG at mm/page_alloc.c:738!
invalid opcode: 0000 [#1]
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
Modules linked in: hwmon_vid sata_sil i2c_nforce2

Pid: 1770, comm: xfs_fsr Not tainted 2.6.38-06507-ga952baa #1
/NF7-S/NF7,NF7-V (nVidia-nForce2)
EIP: 0060:[<c1077348>] EFLAGS: 00010002 CPU: 0
EIP is at __rmqueue+0x378/0x380
EAX: 00000001 EBX: c163393c ECX: 00000000 EDX: c1633240
ESI: f7782a20 EDI: 00000001 EBP: f57b9c58 ESP: f57b9c20
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process xfs_fsr (pid: 1770, ti=f57b8000 task=f5ae65e0 task.ti=f57b8000)
Stack:
 00000046 000000b0 00000000 c16338e4 c16338f4 00000000 00000002 00000010
 c16338c0 f7782a00 00000001 f77829e0 f77829f8 f77829f8 f57b9cc8 c107874f
 00000002 00000041 00000000 ffffffff 00000002 00000001 f6bdbfc4 00000007
Call Trace:
 [<c107874f>] get_page_from_freelist+0x30f/0x4a0
 [<c10789dd>] __alloc_pages_nodemask+0xfd/0x620
 [<c1047a9d>] ? sched_clock_cpu+0x7d/0xf0
 [<c10518eb>] ? trace_hardirqs_off+0xb/0x10
 [<c107a7ab>] ? __do_page_cache_readahead+0x9b/0x200
 [<c107a820>] __do_page_cache_readahead+0x110/0x200
 [<c107a7ab>] ? __do_page_cache_readahead+0x9b/0x200
 [<c107ab11>] ra_submit+0x21/0x30
 [<c107ac71>] ondemand_readahead+0x151/0x280
 [<c107ae16>] page_cache_async_readahead+0x76/0xb0
 [<c1073f66>] generic_file_aio_read+0x4f6/0x740
 [<c11aca91>] xfs_file_aio_read+0x141/0x260
 [<c1047a9d>] ? sched_clock_cpu+0x7d/0xf0
 [<c109da0c>] do_sync_read+0x9c/0xd0
 [<c10573c6>] ? lock_release_non_nested+0x316/0x350
 [<c1086d0a>] ? might_fault+0x4a/0xa0
 [<c109e127>] vfs_read+0x97/0x130
 [<c11e0685>] ? copy_to_user+0x45/0x50
 [<c109d970>] ? do_sync_read+0x0/0xd0
 [<c109e1fd>] sys_read+0x3d/0x70
 [<c136eb50>] sysenter_do_call+0x12/0x36
Code: 4d e8 29 f8 c1 e0 02 8d 5c 01 50 8d 44 30 50 03 45 e8 8b 0a 83
c2 2c 39 c1 0f 85 ef fc ff ff eb ca 85 c9 0f 94 c2 e9 b2 fd ff ff <0f>
0b 0f 0b 0f 0b 66 90 55 89 e5 57 56 53 89 c3 8d 40 08 83 ec
EIP: [<c1077348>] __rmqueue+0x378/0x380 SS:ESP 0068:f57b9c20
---[ end trace 193bca4ca45cfe0f ]---
BUG: sleeping function called from invalid context at kernel/rwsem.c:21
in_atomic(): 0, irqs_disabled(): 1, pid: 1770, name: xfs_fsr
INFO: lockdep is turned off.
irq event stamp: 37110
hardirqs last  enabled at (37109): [<c10786dd>]
get_page_from_freelist+0x29d/0x4a0
hardirqs last disabled at (37110): [<c10784ff>]
get_page_from_freelist+0xbf/0x4a0
softirqs last  enabled at (35144): [<c1030031>] __do_softirq+0xc1/0x110
softirqs last disabled at (35137): [<c1003986>] do_softirq+0x86/0xd0
Pid: 1770, comm: xfs_fsr Tainted: G      D     2.6.38-06507-ga952baa #1
Call Trace:
 [<c1003986>] ? do_softirq+0x86/0xd0
 [<c1021421>] __might_sleep+0xd1/0x100
 [<c13686ce>] down_read+0x1e/0x90
 [<c10518eb>] ? trace_hardirqs_off+0xb/0x10
 [<c1369b57>] ? _raw_spin_unlock_irqrestore+0x47/0x50
 [<c102c75b>] exit_mm+0x2b/0xf0
 [<c102dd90>] do_exit+0xd0/0x6c0
 [<c102c51f>] ? kmsg_dump+0xdf/0x110
 [<c102c49b>] ? kmsg_dump+0x5b/0x110
 [<c136aa1c>] oops_end+0x6c/0x90
 [<c10049cf>] die+0x4f/0x70
 [<c136a27e>] do_trap+0x8e/0xc0
 [<c1002c40>] ? do_invalid_op+0x0/0xa0
 [<c1002cc6>] do_invalid_op+0x86/0xa0
 [<c1077348>] ? __rmqueue+0x378/0x380
 [<c1055b51>] ? __lock_acquire+0x441/0x19a0
 [<c1047882>] ? sched_clock_local.clone.1+0x42/0x1a0
 [<c11dff64>] ? trace_hardirqs_off_thunk+0xc/0x18
 [<c136a041>] error_code+0x5d/0x64
 [<c1002c40>] ? do_invalid_op+0x0/0xa0
 [<c1077348>] ? __rmqueue+0x378/0x380
 [<c107874f>] get_page_from_freelist+0x30f/0x4a0
 [<c10789dd>] __alloc_pages_nodemask+0xfd/0x620
 [<c1047a9d>] ? sched_clock_cpu+0x7d/0xf0
 [<c10518eb>] ? trace_hardirqs_off+0xb/0x10
 [<c107a7ab>] ? __do_page_cache_readahead+0x9b/0x200
 [<c107a820>] __do_page_cache_readahead+0x110/0x200
 [<c107a7ab>] ? __do_page_cache_readahead+0x9b/0x200
 [<c107ab11>] ra_submit+0x21/0x30
 [<c107ac71>] ondemand_readahead+0x151/0x280
 [<c107ae16>] page_cache_async_readahead+0x76/0xb0
 [<c1073f66>] generic_file_aio_read+0x4f6/0x740
 [<c11aca91>] xfs_file_aio_read+0x141/0x260
 [<c1047a9d>] ? sched_clock_cpu+0x7d/0xf0
 [<c109da0c>] do_sync_read+0x9c/0xd0
 [<c10573c6>] ? lock_release_non_nested+0x316/0x350
 [<c1086d0a>] ? might_fault+0x4a/0xa0
 [<c109e127>] vfs_read+0x97/0x130
 [<c11e0685>] ? copy_to_user+0x45/0x50
 [<c109d970>] ? do_sync_read+0x0/0xd0
 [<c109e1fd>] sys_read+0x3d/0x70
 [<c136eb50>] sysenter_do_call+0x12/0x36
BUG: spinlock lockup on CPU#0, xfs_fsr/1770, c16338e4
Pid: 1770, comm: xfs_fsr Tainted: G      D     2.6.38-06507-ga952baa #1
Call Trace:
 [<c1366a0f>] ? printk+0x18/0x21
 [<c11ee7e3>] do_raw_spin_lock+0x113/0x120
 [<c1369262>] _raw_spin_lock+0x52/0x70
 [<c10777ad>] ? free_pcppages_bulk+0x1d/0x310
 [<c10777ad>] free_pcppages_bulk+0x1d/0x310
 [<c13693db>] ? _raw_spin_lock_irqsave+0x6b/0x80
 [<c107af5d>] ? __page_cache_release+0x4d/0x100
 [<c10782cf>] free_hot_cold_page+0x11f/0x180
 [<c107b044>] __put_single_page+0x14/0x20
 [<c107b1e5>] put_page+0x35/0x50
 [<c10936dd>] free_page_and_swap_cache+0x1d/0x50
 [<c1088963>] unmap_vmas+0x343/0x4e0
 [<c1369b02>] ? _raw_spin_unlock_irq+0x22/0x30
 [<c108db1f>] exit_mmap+0x9f/0x110
 [<c1028bdc>] mmput+0x4c/0xc0
 [<c102c802>] exit_mm+0xd2/0xf0
 [<c102dd90>] do_exit+0xd0/0x6c0
 [<c102c51f>] ? kmsg_dump+0xdf/0x110
 [<c102c49b>] ? kmsg_dump+0x5b/0x110
 [<c136aa1c>] oops_end+0x6c/0x90
 [<c10049cf>] die+0x4f/0x70
 [<c136a27e>] do_trap+0x8e/0xc0
 [<c1002c40>] ? do_invalid_op+0x0/0xa0
 [<c1002cc6>] do_invalid_op+0x86/0xa0
 [<c1077348>] ? __rmqueue+0x378/0x380
 [<c1055b51>] ? __lock_acquire+0x441/0x19a0
 [<c1047882>] ? sched_clock_local.clone.1+0x42/0x1a0
 [<c11dff64>] ? trace_hardirqs_off_thunk+0xc/0x18
 [<c136a041>] error_code+0x5d/0x64
 [<c1002c40>] ? do_invalid_op+0x0/0xa0
 [<c1077348>] ? __rmqueue+0x378/0x380
 [<c107874f>] get_page_from_freelist+0x30f/0x4a0
 [<c10789dd>] __alloc_pages_nodemask+0xfd/0x620
 [<c1047a9d>] ? sched_clock_cpu+0x7d/0xf0
 [<c10518eb>] ? trace_hardirqs_off+0xb/0x10
 [<c107a7ab>] ? __do_page_cache_readahead+0x9b/0x200
 [<c107a820>] __do_page_cache_readahead+0x110/0x200
 [<c107a7ab>] ? __do_page_cache_readahead+0x9b/0x200
 [<c107ab11>] ra_submit+0x21/0x30
 [<c107ac71>] ondemand_readahead+0x151/0x280
 [<c107ae16>] page_cache_async_readahead+0x76/0xb0
 [<c1073f66>] generic_file_aio_read+0x4f6/0x740
 [<c11aca91>] xfs_file_aio_read+0x141/0x260
 [<c1047a9d>] ? sched_clock_cpu+0x7d/0xf0
 [<c109da0c>] do_sync_read+0x9c/0xd0
 [<c10573c6>] ? lock_release_non_nested+0x316/0x350
 [<c1086d0a>] ? might_fault+0x4a/0xa0
 [<c109e127>] vfs_read+0x97/0x130
 [<c11e0685>] ? copy_to_user+0x45/0x50
 [<c109d970>] ? do_sync_read+0x0/0xd0
 [<c109e1fd>] sys_read+0x3d/0x70
 [<c136eb50>] sysenter_do_call+0x12/0x36

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
