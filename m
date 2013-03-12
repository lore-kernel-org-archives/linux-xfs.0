Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 965707F59
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 13:46:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 05138AC002
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 11:46:28 -0700 (PDT)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
	[209.85.217.170]) by cuda.sgi.com with ESMTP id
	BGUJ8sa3aKsm4GWE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 11:46:27 -0700 (PDT)
Received: by mail-lb0-f170.google.com with SMTP id ge1so256124lbb.15
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 11:46:25 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 12 Mar 2013 14:46:25 -0400
Message-ID: <CAJzLF9nAQvXCRoNqVw7jiTqmNugau_nK9KTT1ChsrwAv502gTA@mail.gmail.com>
Subject: xfstests #111 + XFS debug = infinite-loop oops
From: "Michael L. Semon" <mlsemon35@gmail.com>
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
To: xfs@oss.sgi.com

Hi!  I was running xfstests #111 under the following conditions...

(*) zeroed partitions, and
(*) a fresh mkfs.xfs for each file system, and

(1) CONFIG_XFS_DEBUG used, rtdev used, external logdev used, or
(2) CONFIG_XFS_DEBUG used, external logdev used, or
(3) CONFIG_XFS_DEBUG used, all internal, mkfs.xfs called with no options

...and I get a trace like the one below (from (3)).  The trace is from
kernel 3.9.0-rc2 on an old Pentium III, using a normal VGA console on
the test PC, captured by another PC over serial cable.  The trace is
part of an infinite loop that becomes finite only if I rip out the
console and VGA entirely.  Overall, more is in play here than just
XFS, but I don't know to whom I should write.  [A relevant question
for which I don't know the answer:  Are there critical sections where
you should not use assertions or call BUG() in debug code?]  Something
in XFS debug is fighting the console/VGA/framebuffer system, and I
don't know where to go from here.

You'll know you've reproduced this one because you'll need the power
button to shut the PC off, so be careful.

This is crash report; no fix is requested.  I'm using the simple
workarounds "don't run xfstests #111 with XFS debugging enabled" and
"Backups!  Backups!  Backups!"   All is well.

Thanks!

Michael

[ 1399.347056] XFS (sda12): Corruption detected. Unmount and run xfs_repair
[ 1399.353815] XFS (sda12): bad inode magic/vsn daddr 64 #8 (magic=5858)
[ 1399.360277] XFS: Assertion failed: 0, file: fs/xfs/xfs_inode.c, line: 416
[ 1399.367112] ------------[ cut here ]------------
[ 1399.370409] kernel BUG at fs/xfs/xfs_message.c:100!
[ 1399.370409] invalid opcode: 0000 [#1]
[ 1399.370409] Pid: 42, comm: kworker/0:1H Not tainted 3.9.0-rc2 #5
[ 1399.370409] EIP: 0060:[<c10fbbc7>] EFLAGS: 00010296 CPU: 0
[ 1399.370409] EIP is at assfail+0x27/0x30
[ 1399.370409] EAX: 0000003d EBX: 00000008 ECX: 00000178 EDX: 00000000
[ 1399.370409] ESI: dd940800 EDI: d6a95780 EBP: df601eb8 ESP: df601ea4
[ 1399.370409]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 1399.370409] CR0: 8005003b CR2: b765c8c0 CR3: 16b20000 CR4: 000007d0
[ 1399.370409] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1399.370409] DR6: ffff0ff0 DR7: 00000400
[ 1399.370409] Process kworker/0:1H (pid: 42, ti=df600000
task=df5f8990 task.ti=df600000)
[ 1399.370409] Stack:
[ 1399.370409]  00000000 c1435d80 c1421860 c14312e2 000001a0 df601ef0
c113a418 d92c6000
[ 1399.370409]  c143be20 00000040 00000000 00000008 00005858 d92c61ac
00000020 d92c6000
[ 1399.370409]  d6a957d8 d6a95780 c148d364 df601ef8 c113a4c8 df601f0c
c10ec97f df5b9101
[ 1399.370409] Call Trace:
[ 1399.370409]  [<c113a418>] xfs_inode_buf_verify+0xe8/0x180
[ 1399.370409]  [<c113a4c8>] xfs_inode_buf_read_verify+0x8/0x10
[ 1399.370409]  [<c10ec97f>] xfs_buf_iodone_work+0x2f/0xa0
[ 1399.370409]  [<c10379eb>] process_one_work+0xdb/0x2e0
[ 1399.370409]  [<c1038798>] worker_thread+0xe8/0x2d0
[ 1399.370409]  [<c10386b0>] ? manage_workers+0x240/0x240
[ 1399.370409]  [<c103c4ce>] kthread+0x8e/0xa0
[ 1399.370409]  [<c137d157>] ret_from_kernel_thread+0x1b/0x28
[ 1399.370409]  [<c103c440>] ? __kthread_parkme+0x60/0x60
[ 1399.370409] Code: 00 00 00 00 55 89 e5 83 ec 14 89 54 24 0c ba 80
5d 43 c1 89 4c 24 10 89 44 24 08 89 54 24 04 c7 04 24 00 00 00 00 e8
d9 fd ff ff <0f> 0b 8d b4 26 00 00 00 00 55 b9 01 00 00 00 89 e5 83 ec
14 89
[ 1399.370409] EIP: [<c10fbbc7>] assfail+0x27/0x30 SS:ESP 0068:df601ea4
[ 1399.539190] ---[ end trace e84c0d20f4790af0 ]---
[ 1399.543926] BUG: unable to handle kernel paging request at fffffff0
[ 1399.547168] IP: [<c103c54a>] kthread_data+0xa/0x10
[ 1399.547168] *pde = 014ee067 *pte = 00000000
[ 1399.547168] Oops: 0000 [#2]
[ 1399.547168] Pid: 42, comm: kworker/0:1H Tainted: G      D      3.9.0-rc2 #5
[ 1399.547168] EIP: 0060:[<c103c54a>] EFLAGS: 00010046 CPU: 0
[ 1399.547168] EIP is at kthread_data+0xa/0x10
[ 1399.547168] EAX: 00000000 EBX: 00000000 ECX: c148da00 EDX: 00000000
[ 1399.547168] ESI: df5f8ae8 EDI: df5f8990 EBP: df601cac ESP: df601ca4
[ 1399.547168]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 1399.547168] CR0: 8005003b CR2: fffffff0 CR3: 16b20000 CR4: 000007d0
[ 1399.547168] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1399.547168] DR6: ffff0ff0 DR7: 00000400
[ 1399.547168] Process kworker/0:1H (pid: 42, ti=df600000
task=df5f8990 task.ti=df600000)
[ 1399.547168] Stack:
[ 1399.547168]  c1038a7b 00000000 df601d28 c137bada 00000001 00000000
df58d480 00000086
[ 1399.547168]  df5f89e4 00000008 00000000 df5f8990 df601cd8 131eec54
00000002 df58e900
[ 1399.547168]  dfeab180 df40a000 df601d04 c108cae9 dfeab180 df58e900
df5f8990 df5bd1e0
[ 1399.547168] Call Trace:
[ 1399.547168]  [<c1038a7b>] ? wq_worker_sleeping+0xb/0x50
[ 1399.547168]  [<c137bada>] __schedule+0x25a/0x430
[ 1399.547168]  [<c108cae9>] ? kmem_cache_free+0x99/0xb0
[ 1399.547168]  [<c1028b8e>] ? release_task+0x1ae/0x2e0
[ 1399.547168]  [<c137bccd>] schedule+0x1d/0x50
[ 1399.547168]  [<c1029b2c>] do_exit+0x3ac/0x730
[ 1399.547168]  [<c1378c8a>] ? printk+0x38/0x3a
[ 1399.547168]  [<c1004ec1>] oops_end+0x61/0x90
[ 1399.547168]  [<c1005025>] die+0x45/0x70
[ 1399.547168]  [<c10029c0>] do_trap+0x50/0xb0
[ 1399.547168]  [<c1002bc0>] ? do_bounds+0x80/0x80
[ 1399.547168]  [<c1002c47>] do_invalid_op+0x87/0xa0
[ 1399.547168]  [<c10fbbc7>] ? assfail+0x27/0x30
[ 1399.547168]  [<c1026f02>] ? vprintk_emit+0x112/0x3f0
[ 1399.547168]  [<c1378c8a>] ? printk+0x38/0x3a
[ 1399.547168]  [<c137cf49>] error_code+0x65/0x6c
[ 1399.547168]  [<c10f0000>] ? xfs_file_aio_read+0x40/0x280
[ 1399.547168]  [<c10fbbc7>] ? assfail+0x27/0x30
[ 1399.547168]  [<c113a418>] xfs_inode_buf_verify+0xe8/0x180
[ 1399.547168]  [<c113a4c8>] xfs_inode_buf_read_verify+0x8/0x10
[ 1399.547168]  [<c10ec97f>] xfs_buf_iodone_work+0x2f/0xa0
[ 1399.547168]  [<c10379eb>] process_one_work+0xdb/0x2e0
[ 1399.547168]  [<c1038798>] worker_thread+0xe8/0x2d0
[ 1399.547168]  [<c10386b0>] ? manage_workers+0x240/0x240
[ 1399.547168]  [<c103c4ce>] kthread+0x8e/0xa0
[ 1399.547168]  [<c137d157>] ret_from_kernel_thread+0x1b/0x28
[ 1399.547168]  [<c103c440>] ? __kthread_parkme+0x60/0x60
[ 1399.547168] Code: 00 55 85 c0 89 e5 74 03 c6 00 00 a1 a0 5d 48 c1
8b 80 2c 01 00 00 5d 8b 50 e8 d1 ea 88 d0 24 01 c3 55 8b 80 2c 01 00
00 89 e5 5d <8b> 40 f0 c3 66 90 55 a1 a0 5d 48 c1 8b 80 2c 01 00 00 89
e5 83
[ 1399.547168] EIP: [<c103c54a>] kthread_data+0xa/0x10 SS:ESP 0068:df601ca4
[ 1399.547168] CR2: 00000000fffffff0
[ 1399.547168] ---[ end trace e84c0d20f4790af1 ]---
[ 1399.547168] Fixing recursive fault but reboot is needed!
[ 1399.547168] BUG: unable to handle kernel paging request at fffffff0
[ 1399.547168] IP: [<c103c54a>] kthread_data+0xa/0x10
[ 1399.547168] *pde = 014ee067 *pte = 00000000
[ 1399.547168] Oops: 0000 [#3]
[ 1399.547168] Pid: 42, comm: kworker/0:1H Tainted: G      D      3.9.0-rc2 #5
[ 1399.547168] EIP: 0060:[<c103c54a>] EFLAGS: 00010046 CPU: 0
[ 1399.547168] EIP is at kthread_data+0xa/0x10
[ 1399.547168] EAX: 00000000 EBX: 00000000 ECX: c148da00 EDX: 00000000
[ 1399.547168] ESI: df5f8ae8 EDI: df5f8990 EBP: df601a8c ESP: df601a84
[ 1399.547168]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 1399.547168] CR0: 8005003b CR2: fffffff0 CR3: 16b20000 CR4: 000007d0
[ 1399.547168] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1399.547168] DR6: ffff0ff0 DR7: 00000400
[ 1399.547168] Process kworker/0:1H (pid: 42, ti=df600000
task=df5f8990 task.ti=df600000)
[ 1399.547168] Stack:
[ 1399.547168]  c1038a7b 00000009 df601b08 c137bada 00000000 00000006
00000000 000001c9
[ 1399.547168]  c14f6030 0000002c 00000000 df5f8990 df601ab8 00000046
00000000 00000000
[ 1399.547168]  00000000 00000000 c1506082 0000002c 000001c8 c1506082
00000000 00000046
[ 1399.547168] Call Trace:
[ 1399.547168]  [<c1038a7b>] ? wq_worker_sleeping+0xb/0x50
[ 1399.547168]  [<c137bada>] __schedule+0x25a/0x430
[ 1399.547168]  [<c1378c8a>] ? printk+0x38/0x3a
[ 1399.547168]  [<c137bccd>] schedule+0x1d/0x50
[ 1399.547168]  [<c1029e5c>] do_exit+0x6dc/0x730
[ 1399.547168]  [<c1378c8a>] ? printk+0x38/0x3a
[ 1399.547168]  [<c102521a>] ? print_oops_end_marker+0x2a/0x30
[ 1399.547168]  [<c1004ec1>] oops_end+0x61/0x90
[ 1399.547168]  [<c1378689>] no_context+0x179/0x181
[ 1399.547168]  [<c13787ad>] __bad_area_nosemaphore+0x11c/0x124
[ 1399.547168]  [<c1044eac>] ? sched_clock_local.constprop.3+0x3c/0x170
[ 1399.547168]  [<c101eae0>] ? vmalloc_sync_all+0xf0/0xf0
[ 1399.547168]  [<c13787c7>] bad_area_nosemaphore+0x12/0x14
[ 1399.547168]  [<c101e81c>] __do_page_fault+0x21c/0x3f0
[ 1399.547168]  [<c1045ac1>] ? __enqueue_entity.constprop.54+0x71/0x80
[ 1399.547168]  [<c10463a4>] ? enqueue_task_fair+0x84/0x130
[ 1399.547168]  [<c101eae0>] ? vmalloc_sync_all+0xf0/0xf0
[ 1399.547168]  [<c101eae8>] do_page_fault+0x8/0x10
[ 1399.547168]  [<c137cf49>] error_code+0x65/0x6c
[ 1399.547168]  [<c1040000>] ? hrtimer_nanosleep+0xe0/0x120
[ 1399.547168]  [<c103c54a>] ? kthread_data+0xa/0x10
[ 1399.547168]  [<c1038a7b>] ? wq_worker_sleeping+0xb/0x50
[ 1399.547168]  [<c137bada>] __schedule+0x25a/0x430
[ 1399.547168]  [<c108cae9>] ? kmem_cache_free+0x99/0xb0
[ 1399.547168]  [<c1028b8e>] ? release_task+0x1ae/0x2e0
[ 1399.547168]  [<c137bccd>] schedule+0x1d/0x50
[ 1399.547168]  [<c1029b2c>] do_exit+0x3ac/0x730
[ 1399.547168]  [<c1378c8a>] ? printk+0x38/0x3a
[ 1399.547168]  [<c1004ec1>] oops_end+0x61/0x90
[ 1399.547168]  [<c1005025>] die+0x45/0x70
[ 1399.547168]  [<c10029c0>] do_trap+0x50/0xb0
[ 1399.547168]  [<c1002bc0>] ? do_bounds+0x80/0x80
[ 1399.547168]  [<c1002c47>] do_invalid_op+0x87/0xa0
[ 1399.547168]  [<c10fbbc7>] ? assfail+0x27/0x30
[ 1399.547168]  [<c1026f02>] ? vprintk_emit+0x112/0x3f0
[ 1399.547168]  [<c1378c8a>] ? printk+0x38/0x3a
[ 1399.547168]  [<c137cf49>] error_code+0x65/0x6c
[ 1399.547168]  [<c10f0000>] ? xfs_file_aio_read+0x40/0x280
[ 1399.547168]  [<c10fbbc7>] ? assfail+0x27/0x30
[ 1399.547168]  [<c113a418>] xfs_inode_buf_verify+0xe8/0x180
[ 1399.547168]  [<c113a4c8>] xfs_inode_buf_read_verify+0x8/0x10
[ 1399.547168]  [<c10ec97f>] xfs_buf_iodone_work+0x2f/0xa0
[ 1399.547168]  [<c10379eb>] process_one_work+0xdb/0x2e0
[ 1399.547168]  [<c1038798>] worker_thread+0xe8/0x2d0
[ 1399.547168]  [<c10386b0>] ? manage_workers+0x240/0x240
[ 1399.547168]  [<c103c4ce>] kthread+0x8e/0xa0
[ 1399.547168]  [<c137d157>] ret_from_kernel_thread+0x1b/0x28
[ 1399.547168]  [<c103c440>] ? __kthread_parkme+0x60/0x60
[ 1399.547168] Code: 00 55 85 c0 89 e5 74 03 c6 00 00 a1 a0 5d 48 c1
8b 80 2c 01 00 00 5d 8b 50 e8 d1 ea 88 d0 24 01 c3 55 8b 80 2c 01 00
00 89 e5 5d <8b> 40 f0 c3 66 90 55 a1 a0 5d 48 c1 8b 80 2c 01 00 00 89
e5 83
[ 1399.547168] EIP: [<c103c54a>] kthread_data+0xa/0x10 SS:ESP 0068:df601a84
[ 1399.547168] CR2: 00000000fffffff0
[ 1399.547168] ---[ end trace e84c0d20f4790af2 ]---
[ 1399.547168] Fixing recursive fault but reboot is needed!
[ 1399.547168] BUG: unable to handle kernel paging request at fffffff0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
