Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4006F7F67
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 08:47:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 227BB8F8084
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 06:47:03 -0700 (PDT)
Received: from mail-gg0-f178.google.com (mail-gg0-f178.google.com
	[209.85.161.178]) by cuda.sgi.com with ESMTP id
	hNC2FTaztTSmGM1w (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Apr 2013 06:46:59 -0700 (PDT)
Received: by mail-gg0-f178.google.com with SMTP id e5so45986ggh.37
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 06:46:59 -0700 (PDT)
Message-ID: <51656D47.9010806@gmail.com>
Date: Wed, 10 Apr 2013 09:46:47 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: New xfstests generic/308 causes XFS hang (high CPU use), at least
	on 32-bit
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi!  On my 32-bit Pentium III PC, xfstests generic/308 uses xfs_io, and 
that xfs_io hangs the XFS file system without causing a crash.  In other 
words, the FS cannot be umounted, xfs_io can't be killed, and shutdown 
is handled by magic SysRq keys.  In this time, there is about 90% CPU 
usage from xfs_io (top) but zero disk I/O (iostat).

The PC uses kernel 3.8-rc4 + Dave's CRC v4 patches + J. Liu's bitness patch.

In lieu of an oops or error message--can't get one, can't find one--I've 
tried some different things.  An attempt to work through the SysRq keys 
seemed to yield some clues.  However, it seemed better to come back with 
tracers running and run the test again, so tracers are before the SysRq 
section, after my closing.  The SysRq-induced crash is at the very end.

BTW, For a "write to huge offset" test, I'm surprised that generic/308 
ran on a bare partition instead of on a loopback device.

Thanks!

Michael

=== TRACE: `cat /sys/kernel/debug/tracing/trace_pipe`

<...>-363   [000] ...1  1083.623178: xfs_getattr: dev 8:1 ino 0x102d424
<...>-363   [000] ...1  1083.624885: xfs_ilock: dev 8:1 ino 0x839d91 
flags ILOCK_SHARED caller return_to_handler
<...>-363   [000] ...1  1083.624904: xfs_iunlock: dev 8:1 ino 0x839d91 
flags ILOCK_SHARED caller return_to_handler
<...>-363   [000] ...1  1083.624922: xfs_ilock: dev 8:1 ino 0xb83901 
flags ILOCK_SHARED caller return_to_handler
<...>-363   [000] ...1  1083.624933: xfs_iunlock: dev 8:1 ino 0xb83901 
flags ILOCK_SHARED caller return_to_handler
<...>-363   [000] ...1  1083.624950: xfs_ilock: dev 8:1 ino 0x102d439 
flags ILOCK_SHARED caller return_to_handler
<...>-363   [000] ...1  1083.624961: xfs_iunlock: dev 8:1 ino 0x102d439 
flags ILOCK_SHARED caller return_to_handler
<...>-361   [000] ...1  1083.629648: xfs_readlink: dev 8:1 ino 0x100e96
<...>-361   [000] ...1  1083.629656: xfs_ilock: dev 8:1 ino 0x100e96 
flags ILOCK_SHARED caller return_to_handler
<...>-361   [000] ...1  1083.629663: xfs_iunlock: dev 8:1 ino 0x100e96 
flags ILOCK_SHARED caller return_to_handler
<...>-365   [000] ...1  1083.643594: xfs_getattr: dev 8:8 ino 0xfb4c0
<...>-365   [000] ...1  1083.643642: xfs_getattr: dev 8:8 ino 0xfb4c0
CPU:0 [LOST 34086 EVENTS]
xfs_io-831   [000] ...1  1097.066232: xfs_writepage: dev 8:11 ino 0x5d4b 
pgoff 0xfffff000 size 0xfffffffffff offset 0 delalloc 1 unwritten 0
xfs_io-831   [000] ...1  1097.066253: xfs_writepage: dev 8:11 ino 0x5d4b 
pgoff 0xfffff000 size 0xfffffffffff offset 0 delalloc 1 unwritten 0
xfs_io-831   [000] ...1  1097.066274: xfs_writepage: dev 8:11 ino 0x5d4b 
pgoff 0xfffff000 size 0xfffffffffff offset 0 delalloc 1 unwritten 0
xfs_io-831   [000] ...1  1097.066295: xfs_writepage: dev 8:11 ino 0x5d4b 
pgoff 0xfffff000 size 0xfffffffffff offset 0 delalloc 1 unwritten 0
xfs_io-831   [000] ...1  1097.066316: xfs_writepage: dev 8:11 ino 0x5d4b 
pgoff 0xfffff000 size 0xfffffffffff offset 0 delalloc 1 unwritten 0

=== MOSTLY-FAILED SHUTDOWN SESSION: `./check generic/308` and afermath

XFS (sda11): Mounting Filesystem
XFS (sda11): Ending clean mount
generic/308	^CSysRq : Terminate All Tasks

[At this point, attempts to kill xfs_io and umount the FS both failed.]

[This is the attempted SysRq-w capture...]
SysRq : Show Blocked State
   task                PC stack   pid father

SysRq : Show Regs
Pid: 5882, comm: xfs_io Not tainted 3.9.0-rc4+ #7
EIP: 0060:[<c1063cd6>] EFLAGS: 00000246 CPU: 0
EIP is at write_cache_pages+0x196/0x380
EAX: 00000000 EBX: d7df98e0 ECX: 00000000 EDX: d7df98e0
ESI: 00000000 EDI: c1062760 EBP: cc1c9ea8 ESP: cc1c9e10
  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 093ae008 CR3: 0b9c6000 CR4: 00000790
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process xfs_io (pid: 5882, ti=d7406000 task=cc1b1650 task.ti=cc1c8000)
Stack:
  00000002 0000000e 000000f1 00000001 00000001 00000002 c1062760 00000000
  cc1c9ee8 ffffffff 00000000 00000001 cc1c9e7c c105c1b0 c106fe58 ffffffff
  ce81d9b0 00000000 00000000 00000001 00000000 d7df98e0 d7df54c0 00000000
Call Trace:
  [<c1062760>] ? global_dirtyable_memory+0x40/0x40
  [<c105c1b0>] ? filemap_fault+0x60/0x370
  [<c106fe58>] ? anon_vma_interval_tree_insert+0x78/0x80
  [<c105bd82>] ? unlock_page+0x42/0x50
  [<c1070fff>] ? __do_fault+0x16f/0x3a0
  [<c1063eef>] generic_writepages+0x2f/0x50
  [<c10d8431>] xfs_vm_writepages+0x11/0x20
  [<c1063f25>] do_writepages+0x15/0x40
  [<c105b5a2>] __filemap_fdatawrite_range+0x72/0x80
  [<c105bb55>] filemap_write_and_wait_range.part.33+0x35/0x70
  [<c105bbbe>] filemap_write_and_wait_range+0x2e/0x40
  [<c10df492>] xfs_file_fsync+0x42/0x1a0
  [<c10df450>] ? xfs_dir_fsync+0xc0/0xc0
  [<c10aa60f>] vfs_fsync+0x2f/0x50
  [<c10aa659>] do_fsync+0x29/0x50
  [<c10aa68d>] sys_fsync+0xd/0x10
  [<c130751f>] sysenter_do_call+0x12/0x26
Code: c4 8b 03 f6 c4 20 75 ad 8b 03 f6 c4 20 0f 85 cc 00 00 00 89 d8 e8 
db fd ff ff 85 c0 74 a7 8b 4d 08 89 d8 8b 55 88 8b 7d 80 ff d7 <85> c0 
89 45 84 0f 85 b3 01 00 00 8b 4d 88 c7 45 84 00 00 00 00
CPU#0: active:     0000000000000000
CPU#0:   gen-PMC0 ctrl:  0000000000000000
CPU#0:   gen-PMC0 count: 00002d000000ffff
CPU#0:   gen-PMC0 left:  0000000000000000
CPU#0:   gen-PMC1 ctrl:  0000000000000000
CPU#0:   gen-PMC1 count: 00002d0000000000
CPU#0:   gen-PMC1 left:  0000000000000000

SysRq : Show State
   task                PC stack   pid father
init            S d7447ab8     0     1      0 0x00000000
  d7447ad8 00000086 00000001 d7447ab8 c1135386 00000000 d7444000 d7447b00
  c13def24 c13de2f8 d7447aa8 c119fe48 d7447b00 c13de2ec 00000000 d7447ae0
  00000282 d7447b78 004c4b3d 00000000 ed878fb6 00003e56 00000282 ed878fb6
Call Trace:
  [<c1135386>] ? xfs_iext_bno_to_ext+0x86/0x170
  [<c119fe48>] ? timerqueue_add+0x58/0xc0
  [<c130604d>] schedule+0x1d/0x50
  [<c130594c>] schedule_hrtimeout_range_clock+0xbc/0x160
  [<c1039120>] ? __hrtimer_init+0x120/0x120
  [<c1305a02>] schedule_hrtimeout_range+0x12/0x20
  [<c10959a9>] poll_schedule_timeout+0x29/0x60
  [<c1095f1d>] do_select+0x4bd/0x5b0
  [<c1095750>] ? poll_select_copy_remaining+0x110/0x110
  [<c103f01e>] ? sched_clock_local.constprop.3+0x3e/0x150
  [<c103fc09>] ? __enqueue_entity.constprop.51+0x69/0x70
  [<c1040407>] ? check_preempt_wakeup+0xc7/0x160
  [<c103d9cc>] ? check_preempt_curr+0x6c/0x80
  [<c103daea>] ? wake_up_process+0x1a/0x30
  [<c1031219>] ? wake_up_worker+0x19/0x20
  [<c1031624>] ? insert_work+0x44/0x60
  [<c1031b08>] ? __queue_work+0x68/0x170
  [<c108f0f6>] ? lookup_fast+0xa6/0x290
  [<c11a4090>] ? _copy_from_user+0x30/0xa0
  [<c10961ba>] core_sys_select+0x1aa/0x620
  [<c108e968>] ? final_putname+0x18/0x40
  [<c1090a6a>] ? user_path_at_empty+0x4a/0x80
  [<c11a3c7d>] ? __copy_to_user_ll+0x5d/0x70
  [<c11a404c>] ? copy_to_user+0x2c/0x40
  [<c108a512>] ? cp_new_stat64+0xf2/0x110
  [<c1042249>] ? ktime_get_ts+0x39/0xf0
  [<c1095a3e>] ? poll_select_set_timeout+0x5e/0x80
  [<c10966ba>] sys_select+0x8a/0xd0
  [<c130751f>] sysenter_do_call+0x12/0x26
kthreadd        S c103d9cc     0     2      0 0x00000000
  d7449f90 00000046 d7449f40 c103d9cc cc1b1cb0 00000000 d7444330 d7449f50
  00000296 00000000 cc1b1cb0 d7449f84 c101e6f3 00000000 cc162440 00000000
  0000171b 00800711 00000000 0000007b 0000007b c1036560 d7444330 d7444330
Call Trace:
  [<c103d9cc>] ? check_preempt_curr+0x6c/0x80
  [<c101e6f3>] ? do_fork+0xc3/0x220
  [<c1036560>] ? __kthread_parkme+0x60/0x60
  [<c130604d>] schedule+0x1d/0x50
  [<c1036985>] kthreadd+0xa5/0xb0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c10368e0>] ? kthread_stop+0x60/0x60
ksoftirqd/0     S c144a190     0     3      2 0x00000000
  d744bf54 00000046 c1029991 c144a190 c1449f90 00000004 d7444660 d744bf00
  00000001 00000046 00000000 d744bf50 c10253e7 c1307990 d7402420 00000000
  d7444660 c13dcb00 d7444660 04208040 0137e61f 00000001 00000100 d7402420
Call Trace:
  [<c1029991>] ? run_timer_softirq+0x131/0x190
  [<c10253e7>] ? __do_softirq+0xd7/0x140
  [<c1307990>] ? common_interrupt+0x30/0x35
  [<c130604d>] schedule+0x1d/0x50
  [<c103cd3a>] smpboot_thread_fn+0xca/0x120
  [<c103cc70>] ? lg_global_unlock+0x10/0x10
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
kworker/0:0H    S c1317fc0     0     5      2 0x00000000
  d7453f40 00000046 d7513b40 c1317fc0 d7453ef8 00000000 d7444cc0 00000000
  d7513b98 d7453f10 c10dbdc6 00000001 d740f900 d7513b98 c13ddf64 d7453f48
  c1031808 d7453f24 c10315cf c13ddf70 d7453f48 c10325d1 c13de0c0 00000000
Call Trace:
  [<c10dbdc6>] ? xfs_buf_iodone_work+0x86/0xd0
  [<c1031808>] ? process_one_work+0x138/0x2e0
  [<c10315cf>] ? start_worker+0x1f/0x30
  [<c10325d1>] ? manage_workers+0x211/0x2b0
  [<c130604d>] schedule+0x1d/0x50
  [<c10327d8>] worker_thread+0x168/0x300
  [<c1032670>] ? manage_workers+0x2b0/0x2b0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
kworker/u:0     S d7401f80     0     6      2 0x00000000
  d7459f40 00000046 0000802a d7401f80 d7459efc 00000000 d7444ff0 d751e000
  00000000 c144aa00 d7459f08 d75383c0 d7eaa700 d7401100 d7459f24 d74561c4
  00000003 c144aa00 d75383c0 c144aa00 d7459f48 c10325d1 c144ab5c 00000000
Call Trace:
  [<c10325d1>] ? manage_workers+0x211/0x2b0
  [<c130604d>] schedule+0x1d/0x50
  [<c10327d8>] worker_thread+0x168/0x300
  [<c1032670>] ? manage_workers+0x2b0/0x2b0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
kworker/u:0H    S d744402c     0     7      2 0x00000000
  d745bf40 00000046 c13de620 d744402c d745bf00 00000000 d7445320 00000000
  3b9955db 00000000 d7444330 d745bf6c c1305dc8 d745bf1c c103d9cc d7444000
  00000004 d7445320 d745bf30 00000096 d7447e94 d7447ec4 00000000 d745bf38
Call Trace:
  [<c1305dc8>] ? __schedule+0x188/0x3f0
  [<c103d9cc>] ? check_preempt_curr+0x6c/0x80
  [<c130604d>] schedule+0x1d/0x50
  [<c10327d8>] worker_thread+0x168/0x300
  [<c1032670>] ? manage_workers+0x2b0/0x2b0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
khelper         S 0000038b     0     8      2 0x00000000
  d7461f38 00000046 c1040007 0000038b 00000000 00000000 d7445650 00000000
  d7461f0c c10400e0 c13de620 d744567c d7445650 c13de620 c130c740 00000000
  d7461f24 c103d20d 00000000 d7445650 d7445650 ffffffec d7461f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
kdevtmpfs       S c103d9cc     0     9      2 0x00000000
  d7463edc 00000046 d7463e8c c103d9cc d76bfcb0 00000004 d7445980 d7463ea0
  00000092 d6d85c64 d6d85c88 00000000 d7463ea8 c103daab d7463ed0 c103d0e7
  00000000 00000000 d6d85c94 00000003 00000001 00000296 d6d85c8c 00000000
Call Trace:
  [<c103d9cc>] ? check_preempt_curr+0x6c/0x80
  [<c103daab>] ? default_wake_function+0xb/0x10
  [<c103d0e7>] ? __wake_up_common+0x47/0x70
  [<c130604d>] schedule+0x1d/0x50
  [<c120b234>] devtmpfsd+0x2b4/0x2d0
  [<c103daab>] ? default_wake_function+0xb/0x10
  [<c120af80>] ? handle_remove+0x270/0x270
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
bdi-default     S 00000000     0    10      2 0x00000000
  d7465ee8 00000046 c13de620 00000000 00000002 00000000 d7445cb0 73cbeb43
  e7585fd1 0000127b d7445cdc 73cc1279 00003da4 d7465ecc c1040007 00002736
  00000000 c103fc09 0000127b ca636990 d7445cb0 ca6369bc ca636990 c1449780
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c103fc09>] ? __enqueue_entity.constprop.51+0x69/0x70
  [<c130604d>] schedule+0x1d/0x50
  [<c13051cd>] schedule_timeout+0x9d/0x110
  [<c1029680>] ? __internal_add_timer+0xc0/0xc0
  [<c106c753>] bdi_forker_thread+0x263/0x360
  [<c10a6a90>] ? wb_do_writeback+0x1b0/0x1b0
  [<c106c4f0>] ? bdi_sched_wait+0x10/0x10
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
kblockd         S 0000065a     0    11      2 0x00000000
  d7487f38 00000046 c1040007 0000065a 00000000 00000000 d7484000 00000000
  d7487f0c c10400e0 c13de620 d748402c d7484000 c13de620 c130c740 00000000
  d7487f24 c103d20d 00000000 d7484000 d7484000 ffffffec d7487f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
ata_sff         S 00000359     0    12      2 0x00000000
  d74a5f38 00000046 c1040007 00000359 00000000 00000000 d7484330 00000000
  d74a5f0c c10400e0 c13de620 d748435c d7484330 c13de620 c130c740 00000000
  d74a5f24 c103d20d 00000000 d7484330 d7484330 ffffffec d74a5f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
khubd           S d74a3ea6     0    13      2 0x00000000
  d74a7ed8 00000046 c74b5cd0 d74a3ea6 c123e49b 00000000 d7484660 1a29e84a
  00000003 c13de620 00000000 00000002 d74a7ec8 c103f01e 0fb29a2c 0cd6fd2c
  00000000 0d04cc62 00000000 d7484660 00000400 c13de67c d74a7edc d7444034
Call Trace:
  [<c123e49b>] ? hub_port_status+0xab/0x100
  [<c103f01e>] ? sched_clock_local.constprop.3+0x3e/0x150
  [<c130604d>] schedule+0x1d/0x50
  [<c1242370>] hub_thread+0xdf0/0xf50
  [<c103ff19>] ? pick_next_task_fair+0xd9/0x160
  [<c1305dc8>] ? __schedule+0x188/0x3f0
  [<c103d9cc>] ? check_preempt_curr+0x6c/0x80
  [<c103daab>] ? default_wake_function+0xb/0x10
  [<c1036e10>] ? abort_exclusive_wait+0x60/0x60
  [<c1241580>] ? usb_reset_device+0x5c0/0x5c0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
kswapd0         S 00000000     0    16      2 0x00000000
  d74f5ee4 00000046 00000000 00000000 00000001 00000004 d7484cc0 d74f5eb0
  c105fcc5 00000001 00000000 0000037a c13f4888 00000000 d74f5ec8 c10663ca
  00000001 00000000 c13f4888 00000001 d74f5eec c1066477 00000001 00000000
Call Trace:
  [<c105fcc5>] ? zone_watermark_ok_safe+0x35/0x40
  [<c10663ca>] ? zone_balanced+0x2a/0x70
  [<c1066477>] ? pgdat_balanced+0x67/0xc0
  [<c130604d>] schedule+0x1d/0x50
  [<c1068c7a>] kswapd+0x69a/0x6b0
  [<c1036e10>] ? abort_exclusive_wait+0x60/0x60
  [<c10685e0>] ? try_to_free_pages+0x5e0/0x5e0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
fsnotify_mark   S 00000000     0    17      2 0x00000000
  d7515f34 00000046 00000000 00000000 00000000 00000004 d7484ff0 8020000b
  00000008 00400011 d6fba04c d7515f4c d6fba000 d7e9f740 d7401400 d6fb9e40
  d7e9f720 d7401380 d7515f28 c1082bc8 d7e9f720 d6fb9e40 d7515f1c d7515f4c
Call Trace:
  [<c1082bc8>] ? kmem_cache_free+0x98/0xb0
  [<c130604d>] schedule+0x1d/0x50
  [<c10ba347>] fsnotify_mark_destroy+0xe7/0x120
  [<c1036e10>] ? abort_exclusive_wait+0x60/0x60
  [<c10ba260>] ? fsnotify_put_mark.part.2+0x20/0x20
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfsalloc        S 00000595     0    18      2 0x00000000
  d7517f38 00000046 c1040007 00000595 00000000 00000000 d7485320 00000000
  d7517f0c c10400e0 c13de620 d748534c d7485320 c13de620 c130c740 00000000
  d7517f24 c103d20d 00000000 d7485320 d7485320 ffffffec d7517f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs_mru_cache   S 00000240     0    19      2 0x00000000
  d7519f38 00000046 c1040007 00000240 00000000 00000000 d7485650 00000000
  d7519f0c c10400e0 c13de620 d748567c d7485650 c13de620 c130c740 00000000
  d7519f24 c103d20d 00000000 d7485650 d7485650 ffffffec d7519f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfslogd         S 00000269     0    20      2 0x00000000
  d751bf38 00000046 c1040007 00000269 00000000 00000000 d7485980 00000000
  d751bf0c c10400e0 c13de620 d74859ac d7485980 c13de620 c130c740 00000000
  d751bf24 c103d20d 00000000 d7485980 d7485980 ffffffec d751bf40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
crypto          S 00000240     0    21      2 0x00000000
  d751df38 00000046 c1040007 00000240 00000000 00000000 d7485cb0 00000000
  d751df0c c10400e0 c13de620 d7485cdc d7485cb0 c13de620 c130c740 00000000
  d751df24 c103d20d 00000000 d7485cb0 d7485cb0 ffffffec d751df40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
scsi_eh_0       S 00000000     0    30      2 0x00000000
  d754df2c 00000046 00000086 00000000 00000000 00000004 d751f650 d754df10
  00000246 00000000 d754df10 00000282 00000282 d75461f4 00000246 d7544000
  00000001 d74d9444 00000003 00000246 00000286 00000000 00000246 d74d9400
Call Trace:
  [<c130604d>] schedule+0x1d/0x50
  [<c1214cab>] scsi_error_handler+0x3b/0x3b0
  [<c1214c70>] ? scsi_eh_ready_devs+0x650/0x650
  [<c1214c70>] ? scsi_eh_ready_devs+0x650/0x650
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
scsi_eh_1       S 00000000     0    31      2 0x00000000
  d754ff2c 00000046 00000086 00000000 00000000 00000004 d751f320 d754ff10
  00000246 00000000 d754ff10 00000282 00000282 d754a1f4 00000246 d7548000
  00000001 d74d9844 00000003 00000246 00000286 00000000 00000246 d74d9800
Call Trace:
  [<c130604d>] schedule+0x1d/0x50
  [<c1214cab>] scsi_error_handler+0x3b/0x3b0
  [<c1214c70>] ? scsi_eh_ready_devs+0x650/0x650
  [<c1214c70>] ? scsi_eh_ready_devs+0x650/0x650
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
kworker/u:1     S c103bcdb     0    32      2 0x00000000
  d7553f40 00000046 d7553f10 c103bcdb 00000000 00000000 d751eff0 d751e000
  d753ff50 c144aa00 d7553f08 c1449780 c144aa24 d7553f18 c10296a5 c144aa24
  00000200 d7553f34 00000082 00000000 00000082 c144aa00 00000000 00000001
Call Trace:
  [<c103bcdb>] ? async_run_entry_fn+0x9b/0x130
  [<c10296a5>] ? internal_add_timer+0x15/0x40
  [<c130604d>] schedule+0x1d/0x50
  [<c10327d8>] worker_thread+0x168/0x300
  [<c1032670>] ? manage_workers+0x2b0/0x2b0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
kpsmoused       S 0000051f     0    34      2 0x00000000
  d7557f38 00000046 c1040007 0000051f 00000000 00000000 d751e990 00000000
  d7557f0c c10400e0 c13de620 d751e9bc d751e990 c13de620 c130c740 00000000
  d7557f24 c103d20d 00000000 d751e990 d751e990 ffffffec d7557f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
deferwq         S 000003c2     0    36      2 0x00000000
  d755bf38 00000046 c1040007 000003c2 00000000 00000000 d751e330 00000000
  d755bf0c c10400e0 c13de620 d751e35c d751e330 c13de620 c130c740 00000000
  d755bf24 c103d20d 00000000 d751e330 d751e330 ffffffec d755bf40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-data/sda1   S 00000000     0    40      2 0x00000000
  d758df38 00000046 c105e88b 00000000 00000000 00000000 d75b6000 c10d862e
  d5371974 d5371948 d758df08 c10d8901 d75757e0 d5371974 c13ddde0 d758df40
  c1031808 c103d20d 00000000 d75b6000 d75b6000 ffffffec d758df40 00000000
Call Trace:
  [<c105e88b>] ? mempool_free+0x2b/0x60
  [<c10d862e>] ? xfs_destroy_ioend+0x5e/0x70
  [<c10d8901>] ? xfs_end_io+0x31/0x100
  [<c1031808>] ? process_one_work+0x138/0x2e0
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-conv/sda1   S 00000268     0    41      2 0x00000000
  d758ff38 00000046 c1040007 00000268 00000000 00000000 d75b6330 00000000
  d758ff0c c10400e0 c13de620 d75b635c d75b6330 c13de620 c130c740 00000000
  d758ff24 c103d20d 00000000 d75b6330 d75b6330 ffffffec d758ff40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-cil/sda1    S 00000261     0    42      2 0x00000000
  d7591f38 00000046 c1040007 00000261 00000000 00000000 d75b6660 00000000
  d7591f0c c10400e0 c13de620 d75b668c d75b6660 c13de620 c130c740 00000000
  d7591f24 c103d20d 00000000 d75b6660 d75b6660 ffffffec d7591f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
kworker/0:1H    S c13ddf64     0    43      2 0x00000000
  d7593f40 00000046 d7513b40 c13ddf64 d7593eec 00000000 d75b6990 c114b8c8
  d7513b98 d7593f10 c10dbd8b c118aac8 d7575c00 d7513b98 c13ddf64 d7593f48
  c1031808 c13ddf64 d7575c00 d7593f74 d75b6990 d75b007b c130007b 00000000
Call Trace:
  [<c114b8c8>] ? xfs_buf_iodone_callbacks+0x38/0xf0
  [<c10dbd8b>] ? xfs_buf_iodone_work+0x4b/0xd0
  [<c118aac8>] ? __blk_run_queue+0x28/0x40
  [<c1031808>] ? process_one_work+0x138/0x2e0
  [<c130007b>] ? kernel_init+0x5b/0x160
  [<c130604d>] schedule+0x1d/0x50
  [<c10327d8>] worker_thread+0x168/0x300
  [<c1032670>] ? manage_workers+0x2b0/0x2b0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfsaild/sda1    S d75d3ec0     0    44      2 0x00000000
  d75d3f20 00000046 d75d3eb8 d75d3ec0 d75d3ec0 00000000 d75b6cc0 c1449780
  0137a4d2 d75d3f00 c1449780 d75d3ee8 0137a4d2 d75d3f28 c13051d4 d7538f94
  d75d3f20 0137a4c3 00000282 00000000 00200200 0137a4d2 c1449780 c1029680
Call Trace:
  [<c13051d4>] ? schedule_timeout+0xa4/0x110
  [<c1029680>] ? __internal_add_timer+0xc0/0xc0
  [<c130604d>] schedule+0x1d/0x50
  [<c114d679>] xfsaild+0x309/0x370
  [<c114d370>] ? xfs_trans_ail_cursor_first+0xa0/0xa0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-data/sda2   S 0000065a     0    64      2 0x00000000
  d773df38 00000046 c1040007 0000065a 00000000 00000000 d75b7980 00000000
  d773df0c c10400e0 c13de620 d75b79ac d75b7980 c13de620 c130c740 00000000
  d773df24 c103d20d 00000000 d75b7980 d75b7980 ffffffec d773df40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-conv/sda2   S 0000024b     0    65      2 0x00000000
  d6d95f38 00000046 c1040007 0000024b 00000000 00000000 d75b7cb0 00000000
  d6d95f0c c10400e0 c13de620 d75b7cdc d75b7cb0 c13de620 c130c740 00000000
  d6d95f24 c103d20d 00000000 d75b7cb0 d75b7cb0 ffffffec d6d95f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-cil/sda2    S 0000025e     0    66      2 0x00000000
  d6d99f38 00000046 c1040007 0000025e 00000000 00000000 d6d96000 00000000
  d6d99f0c c10400e0 c13de620 d6d9602c d6d96000 c13de620 c130c740 00000000
  d6d99f24 c103d20d 00000000 d6d96000 d6d96000 ffffffec d6d99f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfsaild/sda2    S d6de9ec0     0    67      2 0x00000000
  d6de9f20 00000046 d6de9eb8 d6de9ec0 d6de9ec0 00000000 d6d96330 c1449780
  0136d536 d6de9f00 c1449780 d6de9ee8 0136d536 d6de9f28 c13051d4 d75c4c94
  d6de9f20 0136d527 00000282 00000000 00200200 0136d536 c1449780 c1029680
Call Trace:
  [<c13051d4>] ? schedule_timeout+0xa4/0x110
  [<c1029680>] ? __internal_add_timer+0xc0/0xc0
  [<c130604d>] schedule+0x1d/0x50
  [<c114d679>] xfsaild+0x309/0x370
  [<c114d370>] ? xfs_trans_ail_cursor_first+0xa0/0xa0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-data/sda8   S 000003b5     0    68      2 0x00000000
  d6debf38 00000046 c1040007 000003b5 00000000 00000000 d6d96660 00000000
  d6debf0c c10400e0 c13de620 d6d9668c d6d96660 c13de620 c130c740 00000000
  d6debf24 c103d20d 00000000 d6d96660 d6d96660 ffffffec d6debf40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-conv/sda8   S 00000242     0    69      2 0x00000000
  d760bf38 00000046 c1040007 00000242 00000000 00000000 d6d96990 00000000
  d760bf0c c10400e0 c13de620 d6d969bc d6d96990 c13de620 c130c740 00000000
  d760bf24 c103d20d 00000000 d6d96990 d6d96990 ffffffec d760bf40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-cil/sda8    S 0000024a     0    70      2 0x00000000
  d6c65f38 00000046 c1040007 0000024a 00000000 00000000 d6d96cc0 00000000
  d6c65f0c c10400e0 c13de620 d6d96cec d6d96cc0 c13de620 c130c740 00000000
  d6c65f24 c103d20d 00000000 d6d96cc0 d6d96cc0 ffffffec d6c65f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfsaild/sda8    S d6c61ec0     0    71      2 0x00000000
  d6c61f20 00000046 d6c61eb8 d6c61ec0 d6c61ec0 00000000 d6d96ff0 c1449780
  013621d5 d6c61f00 c1449780 d6c61ee8 013621d5 d6c61f28 c13051d4 d76036f4
  d6c61f20 013621c6 00000282 00000000 00200200 013621d5 c1449780 c1029680
Call Trace:
  [<c13051d4>] ? schedule_timeout+0xa4/0x110
  [<c1029680>] ? __internal_add_timer+0xc0/0xc0
  [<c130604d>] schedule+0x1d/0x50
  [<c114d679>] xfsaild+0x309/0x370
  [<c114d370>] ? xfs_trans_ail_cursor_first+0xa0/0xa0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-data/sda5   S 00000408     0    80      2 0x00000000
  d6ed9f38 00000046 c1040007 00000408 00000000 00000000 d76becc0 00000000
  d6ed9f0c c10400e0 c13de620 d76becec d76becc0 c13de620 c130c740 00000000
  d6ed9f24 c103d20d 00000000 d76becc0 d76becc0 ffffffec d6ed9f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-conv/sda5   S 00000265     0    81      2 0x00000000
  d6e1ff38 00000046 c1040007 00000265 00000000 00000000 d76beff0 00000000
  d6e1ff0c c10400e0 c13de620 d76bf01c d76beff0 c13de620 c130c740 00000000
  d6e1ff24 c103d20d 00000000 d76beff0 d76beff0 ffffffec d6e1ff40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-cil/sda5    S 00000257     0    82      2 0x00000000
  d6807f38 00000046 c1040007 00000257 00000000 00000000 d76bf320 00000000
  d6807f0c c10400e0 c13de620 d76bf34c d76bf320 c13de620 c130c740 00000000
  d6807f24 c103d20d 00000000 d76bf320 d76bf320 ffffffec d6807f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfsaild/sda5    S c13de67c     0    83      2 0x00000000
  d6e19f20 00000046 00000400 c13de67c d6e19edc 00000000 d76bf650 c13de654
  d6e19ee4 c103f8f0 c13de620 d75b767c d6e19f00 c103ff19 526ac91f d6dca680
  526ac91f d6dca680 d75b7650 d6e19f6c c1305dc8 d6e19f1c c103d9cc d75b7650
Call Trace:
  [<c103f8f0>] ? __dequeue_entity+0x20/0x40
  [<c103ff19>] ? pick_next_task_fair+0xd9/0x160
  [<c1305dc8>] ? __schedule+0x188/0x3f0
  [<c103d9cc>] ? check_preempt_curr+0x6c/0x80
  [<c130604d>] schedule+0x1d/0x50
  [<c114d679>] xfsaild+0x309/0x370
  [<c103daab>] ? default_wake_function+0xb/0x10
  [<c114d370>] ? xfs_trans_ail_cursor_first+0xa0/0xa0
  [<c114d370>] ? xfs_trans_ail_cursor_first+0xa0/0xa0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
kworker/0:6     S cfa77ba0     0  8183      2 0x00000000
  cba11f40 00000046 00000004 cfa77ba0 00000000 00000000 d3f7e990 cfa77ba0
  c13e7030 c13ddde0 cba11f10 c11f83b0 cfa77ba0 c13e7030 c13ddde0 cba11f48
  c1031808 c13ddde0 c7ca92a0 c13ddde0 cba11f48 c10325d1 c13ddf3c 00000000
Call Trace:
  [<c11f83b0>] ? console_callback+0x90/0x140
  [<c1031808>] ? process_one_work+0x138/0x2e0
  [<c10325d1>] ? manage_workers+0x211/0x2b0
  [<c130604d>] schedule+0x1d/0x50
  [<c10327d8>] worker_thread+0x168/0x300
  [<c1032670>] ? manage_workers+0x2b0/0x2b0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
kworker/0:0     S c2059240     0 29212      2 0x00000000
  c14a9f40 00000046 00000004 c2059240 00000000 00000000 ca637320 c2059240
  c13e7030 c13ddde0 c14a9f10 c11f83b0 c2059240 c13e7030 c13ddde0 c14a9f48
  c1031808 c13ddde0 d6d17720 c13ddde0 c14a9f48 c10325d1 c13ddf3c 00000000
Call Trace:
  [<c11f83b0>] ? console_callback+0x90/0x140
  [<c1031808>] ? process_one_work+0x138/0x2e0
  [<c10325d1>] ? manage_workers+0x211/0x2b0
  [<c130604d>] schedule+0x1d/0x50
  [<c10327d8>] worker_thread+0x168/0x300
  [<c1032670>] ? manage_workers+0x2b0/0x2b0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
flush-8:0       S d7520854     0  4243      2 0x00000000
  d6869f10 00000046 c108884e d7520854 c11993ab 00000000 ca636990 d75207dc
  000022f7 00000064 d6869ef4 c1062d18 d6869ee4 000022f7 00000000 00000001
  00000001 00000000 00000001 d75207dc d6869f10 c10a623d 000022f7 c1449780
Call Trace:
  [<c108884e>] ? drop_super+0xe/0x20
  [<c11993ab>] ? fprop_fraction_percpu+0x2b/0x90
  [<c1062d18>] ? bdi_dirty_limit+0x28/0xc0
  [<c10a623d>] ? over_bground_thresh+0x4d/0x70
  [<c130604d>] schedule+0x1d/0x50
  [<c13051cd>] schedule_timeout+0x9d/0x110
  [<c1029680>] ? __internal_add_timer+0xc0/0xc0
  [<c10a6b60>] bdi_writeback_thread+0xd0/0xf0
  [<c10a6a90>] ? wb_do_writeback+0x1b0/0x1b0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-data/sda11  S 000003c3     0  5705      2 0x00000000
  d2ef5f38 00000046 c1040007 000003c3 00000000 00000000 c1722990 00000000
  d2ef5f0c c10400e0 c13de620 c17229bc c1722990 c13de620 c130c740 00000000
  d2ef5f24 c103d20d 00000000 c1722990 c1722990 ffffffec d2ef5f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-conv/sda11  S 0000025a     0  5706      2 0x00000000
  d2f0df38 00000046 c1040007 0000025a 00000000 00000000 c1723cb0 00000000
  d2f0df0c c10400e0 c13de620 c1723cdc c1723cb0 c13de620 c130c740 00000000
  d2f0df24 c103d20d 00000000 c1723cb0 c1723cb0 ffffffec d2f0df40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs-cil/sda11   S 00000261     0  5707      2 0x00000000
  d6989f38 00000046 c1040007 00000261 00000000 00000000 c1722000 00000000
  d6989f0c c10400e0 c13de620 c172202c c1722000 c13de620 c130c740 00000000
  d6989f24 c103d20d 00000000 c1722000 c1722000 ffffffec d6989f40 00000293
Call Trace:
  [<c1040007>] ? update_curr.constprop.48+0x67/0xb0
  [<c10400e0>] ? enqueue_task_fair+0x90/0x130
  [<c103d20d>] ? enqueue_task+0x1d/0x50
  [<c130604d>] schedule+0x1d/0x50
  [<c1032061>] rescuer_thread+0x151/0x1f0
  [<c1031f10>] ? worker_maybe_bind_and_lock.isra.34+0x80/0x80
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfsaild/sda11   S d6f65ec0     0  5708      2 0x00000000
  d6f65f20 00000046 d6f65eb8 d6f65ec0 d6f65ec0 00000000 c1723980 c1449780
  01360292 d6f65f00 c1449780 d6f65ee8 01360292 d6f65f28 c13051d4 c7ca95d4
  d6f65f20 01360283 00000282 00000000 00200200 01360292 c1449780 c1029680
Call Trace:
  [<c13051d4>] ? schedule_timeout+0xa4/0x110
  [<c1029680>] ? __internal_add_timer+0xc0/0xc0
  [<c130604d>] schedule+0x1d/0x50
  [<c114d679>] xfsaild+0x309/0x370
  [<c114d370>] ? xfs_trans_ail_cursor_first+0xa0/0xa0
  [<c10365ee>] kthread+0x8e/0xa0
  [<c1307497>] ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
xfs_io          R running      0  5882      1 0x00000004
  cc1c9da0 c1003a78 00000031 00000001 00000000 cc1c9dcc c100390a cc1c9ddc
  00000000 00000120 00000001 00000100 cc1c9dd4 d7df98e0 ffffffff ce81d9b0
  cc1c9ea8 c1307990 d7df98e0 ffffffff 00000102 ffffffff ce81d9b0 cc1c9ea8
Call Trace:
  [<c1003a78>] ? handle_irq+0x18/0x90
  [<c100390a>] ? do_IRQ+0x3a/0xa0
  [<c1307990>] ? common_interrupt+0x30/0x35
  [<c1060000>] ? show_free_areas+0xe0/0x690
  [<c1063c47>] ? write_cache_pages+0x107/0x380
  [<c1062760>] ? global_dirtyable_memory+0x40/0x40
  [<c105c1b0>] ? filemap_fault+0x60/0x370
  [<c106fe58>] ? anon_vma_interval_tree_insert+0x78/0x80
  [<c105bd82>] ? unlock_page+0x42/0x50
  [<c1070fff>] ? __do_fault+0x16f/0x3a0
  [<c1063eef>] ? generic_writepages+0x2f/0x50
  [<c10d8431>] ? xfs_vm_writepages+0x11/0x20
  [<c1063f25>] ? do_writepages+0x15/0x40
  [<c105b5a2>] ? __filemap_fdatawrite_range+0x72/0x80
  [<c105bb55>] ? filemap_write_and_wait_range.part.33+0x35/0x70
  [<c105bbbe>] ? filemap_write_and_wait_range+0x2e/0x40
  [<c10df492>] ? xfs_file_fsync+0x42/0x1a0
  [<c10df450>] ? xfs_dir_fsync+0xc0/0xc0
  [<c10aa60f>] ? vfs_fsync+0x2f/0x50
  [<c10aa659>] ? do_fsync+0x29/0x50
  [<c10aa68d>] ? sys_fsync+0xd/0x10
  [<c130751f>] ? sysenter_do_call+0x12/0x26
agetty          S 00000000     0  5906      1 0x00000000
  d6e23e94 00000082 ffffffff 00000000 d6e23edc 00000004 cc1b0000 00000009
  d6e23eb4 d6e23e90 00000020 00000000 00000700 00000700 c00bf6e0 000000ff
  c00bf6d2 00000000 ca698400 00000007 d7608600 00000020 00000009 ffffff20
Call Trace:
  [<c130604d>] schedule+0x1d/0x50
  [<c13051fd>] schedule_timeout+0xcd/0x110
  [<c103307f>] ? flush_work+0x9f/0xe0
  [<c11e946c>] n_tty_read+0x1bc/0x600
  [<c103daa0>] ? try_to_wake_up+0x90/0x90
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e3824>] tty_read+0x64/0xb0
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e37c0>] ? do_tty_hangup+0x10/0x10
  [<c10869b7>] vfs_read+0x77/0x130
  [<c1086ce2>] sys_read+0x42/0x90
  [<c130751f>] sysenter_do_call+0x12/0x26
agetty          S 00000000     0  5907      1 0x00000000
  d6e5de94 00000082 ffffffff 00000000 d6e5dedc 00000004 cc1b0990 c108e6f4
  d6e5deb4 d6e5de90 00000020 00000000 00000700 00000700 d76e02a0 000000ff
  00000000 00000000 c2360800 00000007 d7608e00 00000020 ffffffff ffffff20
Call Trace:
  [<c108e6f4>] ? terminate_walk+0x24/0x60
  [<c130604d>] schedule+0x1d/0x50
  [<c13051fd>] schedule_timeout+0xcd/0x110
  [<c103307f>] ? flush_work+0x9f/0xe0
  [<c1090a6a>] ? user_path_at_empty+0x4a/0x80
  [<c11e946c>] n_tty_read+0x1bc/0x600
  [<c103daa0>] ? try_to_wake_up+0x90/0x90
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e3824>] tty_read+0x64/0xb0
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e37c0>] ? do_tty_hangup+0x10/0x10
  [<c10869b7>] vfs_read+0x77/0x130
  [<c1086ce2>] sys_read+0x42/0x90
  [<c130751f>] sysenter_do_call+0x12/0x26
agetty          S 00000000     0  5908      1 0x00000000
  ca6abe94 00000082 ffffffff 00000000 ca6abedc 00000004 d75b7650 c108e6f4
  ca6abeb4 ca6abe90 00000020 00000000 00000700 00000700 d76e42a0 000000ff
  00000000 00000000 d756b400 00000007 d6e53400 00000020 ffffffff ffffff20
Call Trace:
  [<c108e6f4>] ? terminate_walk+0x24/0x60
  [<c130604d>] schedule+0x1d/0x50
  [<c13051fd>] schedule_timeout+0xcd/0x110
  [<c103307f>] ? flush_work+0x9f/0xe0
  [<c1090a6a>] ? user_path_at_empty+0x4a/0x80
  [<c11e946c>] n_tty_read+0x1bc/0x600
  [<c103daa0>] ? try_to_wake_up+0x90/0x90
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e3824>] tty_read+0x64/0xb0
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e37c0>] ? do_tty_hangup+0x10/0x10
  [<c10869b7>] vfs_read+0x77/0x130
  [<c1086ce2>] sys_read+0x42/0x90
  [<c130751f>] sysenter_do_call+0x12/0x26
agetty          S 00000000     0  5909      1 0x00000000
  cd6e1e94 00000086 ffffffff 00000000 cd6e1edc 00000004 d75b6ff0 c108e6f4
  cd6e1eb4 cd6e1e90 00000020 00000000 00000700 00000700 d6dd12a0 000000ff
  00000000 00000000 c2361800 00000007 c2355c00 00000020 ffffffff ffffff20
Call Trace:
  [<c108e6f4>] ? terminate_walk+0x24/0x60
  [<c130604d>] schedule+0x1d/0x50
  [<c13051fd>] schedule_timeout+0xcd/0x110
  [<c103307f>] ? flush_work+0x9f/0xe0
  [<c1090a6a>] ? user_path_at_empty+0x4a/0x80
  [<c11e946c>] n_tty_read+0x1bc/0x600
  [<c103daa0>] ? try_to_wake_up+0x90/0x90
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e3824>] tty_read+0x64/0xb0
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e37c0>] ? do_tty_hangup+0x10/0x10
  [<c10869b7>] vfs_read+0x77/0x130
  [<c1086ce2>] sys_read+0x42/0x90
  [<c130751f>] sysenter_do_call+0x12/0x26
agetty          S 00000000     0  5910      1 0x00000000
  ca59be94 00000086 ffffffff 00000000 ca59bedc 00000004 d75b7320 c108e6f4
  ca59beb4 ca59be90 00000020 00000000 00000700 00000700 d6dd02a0 000000ff
  00000000 00000000 d6835800 00000007 d6e53a00 00000020 ffffffff ffffff20
Call Trace:
  [<c108e6f4>] ? terminate_walk+0x24/0x60
  [<c130604d>] schedule+0x1d/0x50
  [<c13051fd>] schedule_timeout+0xcd/0x110
  [<c103307f>] ? flush_work+0x9f/0xe0
  [<c1090a6a>] ? user_path_at_empty+0x4a/0x80
  [<c11e946c>] n_tty_read+0x1bc/0x600
  [<c103daa0>] ? try_to_wake_up+0x90/0x90
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e3824>] tty_read+0x64/0xb0
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e37c0>] ? do_tty_hangup+0x10/0x10
  [<c10869b7>] vfs_read+0x77/0x130
  [<c1086ce2>] sys_read+0x42/0x90
  [<c130751f>] sysenter_do_call+0x12/0x26
agetty          S 00000000     0  5911      1 0x00000000
  c282fe94 00000086 ffffffff 00000000 c282fedc 00000004 cc1b0cc0 c108e6f4
  c282feb4 c282fe90 00000020 00000000 00000700 00000700 d6dd72a0 000000ff
  00000000 00000000 d6835000 00000007 c2355e00 00000020 ffffffff ffffff20
Call Trace:
  [<c108e6f4>] ? terminate_walk+0x24/0x60
  [<c130604d>] schedule+0x1d/0x50
  [<c13051fd>] schedule_timeout+0xcd/0x110
  [<c103307f>] ? flush_work+0x9f/0xe0
  [<c1090a6a>] ? user_path_at_empty+0x4a/0x80
  [<c11e946c>] n_tty_read+0x1bc/0x600
  [<c103daa0>] ? try_to_wake_up+0x90/0x90
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e3824>] tty_read+0x64/0xb0
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e37c0>] ? do_tty_hangup+0x10/0x10
  [<c10869b7>] vfs_read+0x77/0x130
  [<c1086ce2>] sys_read+0x42/0x90
  [<c130751f>] sysenter_do_call+0x12/0x26
agetty          S 00000000     0  5912      1 0x00000000
  d6d67e94 00000086 ffffffff 00000000 d6d67edc 00000004 cc1b0ff0 c108e6f4
  d6d67eb4 d6d67e90 00000020 00000000 00000700 00000700 d683a2a0 000000ff
  00000000 00000000 d6fbcc00 00000007 d6e53200 00000020 ffffffff ffffff20
Call Trace:
  [<c108e6f4>] ? terminate_walk+0x24/0x60
  [<c130604d>] schedule+0x1d/0x50
  [<c13051fd>] schedule_timeout+0xcd/0x110
  [<c103307f>] ? flush_work+0x9f/0xe0
  [<c1090a6a>] ? user_path_at_empty+0x4a/0x80
  [<c11e946c>] n_tty_read+0x1bc/0x600
  [<c103daa0>] ? try_to_wake_up+0x90/0x90
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e3824>] tty_read+0x64/0xb0
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e37c0>] ? do_tty_hangup+0x10/0x10
  [<c10869b7>] vfs_read+0x77/0x130
  [<c1086ce2>] sys_read+0x42/0x90
  [<c130751f>] sysenter_do_call+0x12/0x26
agetty          S 00000000     0  5913      1 0x00000000
  d6e21e94 00000086 ffffffff 00000000 d6e21edc 00000004 cc1b1320 c108e6f4
  d6e21eb4 d6e21e90 00000020 00000000 00000700 00000700 d74162a0 000000ff
  00000000 00000000 d6834800 00000007 c2355a00 00000020 ffffffff ffffff20
Call Trace:
  [<c108e6f4>] ? terminate_walk+0x24/0x60
  [<c130604d>] schedule+0x1d/0x50
  [<c13051fd>] schedule_timeout+0xcd/0x110
  [<c103307f>] ? flush_work+0x9f/0xe0
  [<c1090a6a>] ? user_path_at_empty+0x4a/0x80
  [<c11e946c>] n_tty_read+0x1bc/0x600
  [<c103daa0>] ? try_to_wake_up+0x90/0x90
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e3824>] tty_read+0x64/0xb0
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e37c0>] ? do_tty_hangup+0x10/0x10
  [<c10869b7>] vfs_read+0x77/0x130
  [<c1086ce2>] sys_read+0x42/0x90
  [<c130751f>] sysenter_do_call+0x12/0x26
bash            S c1087ab5     0  5914      1 0x00000000
  d682be94 00000086 d682be3c c1087ab5 00000246 00000004 cc1b1980 00000001
  d682a000 00000046 00000000 d682be90 c10253e7 00000016 0001c200 00000000
  d682becc 00000004 00000000 d682be7c c119ca6a d682be84 00000096 00000034
Call Trace:
  [<c1087ab5>] ? file_free_rcu+0x25/0x30
  [<c10253e7>] ? __do_softirq+0xd7/0x140
  [<c119ca6a>] ? radix_tree_lookup+0xa/0x10
  [<c130604d>] schedule+0x1d/0x50
  [<c13051fd>] schedule_timeout+0xcd/0x110
  [<c103307f>] ? flush_work+0x9f/0xe0
  [<c11fab33>] ? __uart_start+0x43/0x50
  [<c11e946c>] n_tty_read+0x1bc/0x600
  [<c102551d>] ? irq_exit+0x2d/0x70
  [<c103daa0>] ? try_to_wake_up+0x90/0x90
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e3824>] tty_read+0x64/0xb0
  [<c11e92b0>] ? is_ignored+0x40/0x40
  [<c11e37c0>] ? do_tty_hangup+0x10/0x10
  [<c10869b7>] vfs_read+0x77/0x130
  [<c1086ce2>] sys_read+0x42/0x90
  [<c130751f>] sysenter_do_call+0x12/0x26

=== FORCED CRASH SECTION

SysRq : Emergency Sync
SysRq : Emergency Remount R/O
SysRq : Trigger a crash
BUG: unable to handle kernel NULL pointer dereference at   (null)
IP: [<c11ed9e2>] sysrq_handle_crash+0x12/0x20
*pde = 00000000
Oops: 0002 [#1]
Pid: 4243, comm: flush-8:0 Not tainted 3.9.0-rc4+ #7
EIP: 0060:[<c11ed9e2>] EFLAGS: 00010092 CPU: 0
EIP is at sysrq_handle_crash+0x12/0x20
EAX: 00000001 EBX: 00000001 ECX: 00000a31 EDX: c13e61d0
ESI: 00000092 EDI: 00000063 EBP: d7407e4c ESP: d7407e4c
  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 0b9c6000 CR4: 00000790
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process flush-8:0 (pid: 4243, ti=d7406000 task=ca636990 task.ti=d6868000)
Stack:
  d7407e70 c11edf63 c1391693 c13acacd c13e61d0 00000008 d753a400 0000002e
  c11edfb0 d7407e90 c11ee2c6 d3cd49f5 00000000 013de620 d7538548 d7538540
  c11edfb0 d7407eb8 c125cdac 00000001 d7538540 d753a400 d7538558 c13e6000
Call Trace:
  [<c11edf63>] __handle_sysrq+0xe3/0x130
  [<c11edfb0>] ? __handle_sysrq+0x130/0x130
  [<c11ee2c6>] sysrq_filter+0x316/0x320
  [<c11edfb0>] ? __handle_sysrq+0x130/0x130
  [<c125cdac>] input_to_handler+0x4c/0xe0
  [<c125d912>] input_pass_values.part.13+0x132/0x150
  [<c125eb2f>] input_handle_event+0x10f/0x550
  [<c125efa4>] input_event+0x34/0x40
  [<c1264f4d>] atkbd_interrupt+0x5cd/0x6a0
  [<c1042174>] ? ktime_get+0x54/0xf0
  [<c127d782>] ? pit_next_event+0x22/0x30
  [<c125a9a1>] serio_interrupt+0x21/0x50
  [<c125ade8>] i8042_interrupt+0x108/0x350
  [<c104cec8>] handle_irq_event_percpu+0x28/0x120
  [<c104ee80>] ? handle_simple_irq+0x60/0x60
  [<c104cfdc>] handle_irq_event+0x1c/0x30
  [<c104eecf>] handle_level_irq+0x4f/0x90
  <IRQ>
  [<c100390a>] ? do_IRQ+0x3a/0xa0
  [<c1307990>] ? common_interrupt+0x30/0x35
  [<c106007b>] ? show_free_areas+0x15b/0x690
  [<c10d9d05>] ? xfs_vm_writepage+0x65/0x680
  [<c105ca46>] ? find_get_pages_tag+0x96/0x100
  [<c1062760>] ? global_dirtyable_memory+0x40/0x40
  [<c106276b>] ? __writepage+0xb/0x30
  [<c1063cd6>] ? write_cache_pages+0x196/0x380
  [<c1062760>] ? global_dirtyable_memory+0x40/0x40
  [<c118aac8>] ? __blk_run_queue+0x28/0x40
  [<c103f01e>] ? sched_clock_local.constprop.3+0x3e/0x150
  [<c1063eef>] ? generic_writepages+0x2f/0x50
  [<c10d8431>] ? xfs_vm_writepages+0x11/0x20
  [<c1063f25>] ? do_writepages+0x15/0x40
  [<c10a5dec>] ? __writeback_single_inode+0x2c/0xe0
  [<c10a6017>] ? writeback_sb_inodes+0x177/0x2a0
  [<c10a6464>] ? wb_writeback+0xa4/0x1a0
  [<c10a6948>] ? wb_do_writeback+0x68/0x1b0
  [<c1029680>] ? __internal_add_timer+0xc0/0xc0
  [<c10a6ae1>] ? bdi_writeback_thread+0x51/0xf0
  [<c10a6a90>] ? wb_do_writeback+0x1b0/0x1b0
  [<c10365ee>] ? kthread+0x8e/0xa0
  [<c1307497>] ? ret_from_kernel_thread+0x1b/0x28
  [<c1036560>] ? __kthread_parkme+0x60/0x60
Code: ff ba 2a 00 00 00 b8 18 c5 38 c1 e8 79 17 e3 ff e9 a9 fe ff ff 66 
90 66 90 55 b8 01 00 00 00 89 e5 a3 8c 84 43 c1 0f ae f8 89 f6 <c6> 05 
00 00 00 00 01 5d c3 90 8d 74 26 00 55 89 e5 56 53 9c 5b
EIP: [<c11ed9e2>] sysrq_handle_crash+0x12/0x20 SS:ESP 0068:d7407e4c
CR2: 0000000000000000
---[ end trace 84b20633264cbfa8 ]---
Kernel panic - not syncing: Fatal exception in interrupt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
