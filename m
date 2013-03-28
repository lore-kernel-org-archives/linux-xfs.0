Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F1247F50
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 00:18:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ECB0F8F8084
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 22:18:26 -0700 (PDT)
Received: from mail-ve0-f178.google.com (mail-ve0-f178.google.com
	[209.85.128.178]) by cuda.sgi.com with ESMTP id
	SbJiXmjfbD2DXdwB (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Mar 2013 22:18:25 -0700 (PDT)
Received: by mail-ve0-f178.google.com with SMTP id db10so3735798veb.9
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 22:18:24 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 28 Mar 2013 01:18:24 -0400
Message-ID: <CAJzLF9nPt9aOrH+Dj12b5os74XT8ke9g4G=DA9xgR0AyehvaBA@mail.gmail.com>
Subject: oops from deliberate block trashing (of course!)
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

Hi!  This report was requested by Dave because I was praising
xfs_repair and didn't fully describe the problem that xfs_repair was
repairing.  Blame me if this is a bad bug report or a matter of XFS
just doing its job.

I'm trying to come up with a fair FS-agnostic test to corrupt bytes
and see how file systems and recovery tools respond after that.  The
goal was to spare the first 4 MB of a filled, unmounted partition,
then write an ASCII 'f' at 10240 random locations for the rest of the
way.  The beginning was spared for the benefit of file systems like
btrfs (non-RAID mode) and JFS that seem frail there.

XFS did not like this test, and the FIRST OOPS section reflects this.
For this test, xfs_repair solved all major issues.

Dave suggested that I try the xfs_db "blocktrash" command, and wow!
It led to the SECOND OOPS section of this report, which seems to share
some attributes with the FIRST OOPS section.  xfs_repair didn't make
it long enough to fix any issues.  In the future, I'll start small and
not think, "Wonder what will happen if I do this?"  blocktrash rocks.

Anyway, this is for information purposes only.  None of my production
PCs are affected by this.  However, for reasons due to my ability to
stumble around and do the wrong thing, this interests me.

My original data is gone--lost in an effort to learn to make an
xfs_repair-able snapshot and keep the corrupted data unchanged--but
I'll be happy to generate another test case.  Reproducibility seems to
be 100%.

Basic kernel stuff:  The kernel is from last Friday's git pull of the
SGI source, plus Dave's CRC patches, plus Jeff (Jie?) Liu's bitness
patch, running on an old 32-bit Pentium III PC.  It's slowly being
returned to being a normal PC with a VGA console, so there's a little
more non-XFS stuff in the oopses lately.  XFS debugging is on.

Thanks for reading!

Michael

==== FIRST OOPS: overwrite full XFS partition with ASCII 'f' (0x66)
byte at random locations...

mount partition, cd to mountpoint, and run `find . -type f | wc -l`:

XFS (sdb2): Mounting Filesystem
XFS (sdb2): Ending clean mount
XFS: Assertion failed: fs_is_ok, file: fs/xfs/xfs_dir2_data.c, line: 169
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:100!
invalid opcode: 0000 [#1]
Pid: 97, comm: kworker/0:1H Not tainted 3.9.0-rc1+ #1
EIP: 0060:[<c127fb4c>] EFLAGS: 00010286 CPU: 0
EIP is at assfail+0x2c/0x30
EAX: 00000048 EBX: 00000012 ECX: 00000000 EDX: c18c5e84
ESI: 00000012 EDI: c2f1b168 EBP: ded57e20 ESP: ded57e0c
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 0911029c CR3: 065aa000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process kworker/0:1H (pid: 97, ti=ded56000 task=ded030c0 task.ti=ded56000)
Stack:
 00000000 c18485b4 c1833d86 c1835769 000000a9 ded57e70 c12b9f20 c105ffe8
 0025effc 00000000 0000000f c2f1b000 c2f1bf68 c2f1bff8 c2f1b168 0000002d
 00000006 c6500800 c2f1b004 c2f1bf68 c2f1b171 0000000d c1c2f400 c2f1b000
Call Trace:
 [<c12b9f20>] __xfs_dir3_data_check+0x5e0/0x710
 [<c105ffe8>] ? update_curr.constprop.41+0xa8/0x180
 [<c12b7289>] xfs_dir3_block_verify+0x89/0xa0
 [<c105baba>] ? dequeue_task+0x8a/0xb0
 [<c12b7526>] xfs_dir3_block_read_verify+0x36/0xe0
 [<c105bba8>] ? finish_task_switch.constprop.83+0x48/0xa0
 [<c16c6e02>] ? __schedule+0x292/0x5b0
 [<c12ba36a>] xfs_dir3_data_reada_verify+0x8a/0xa0
 [<c126e0af>] xfs_buf_iodone_work+0x9f/0xd0
 [<c104a324>] process_one_work+0x114/0x350
 [<c104af7c>] worker_thread+0xec/0x350
 [<c104ae90>] ? manage_workers+0x2d0/0x2d0
 [<c10519f3>] kthread+0x93/0xa0
 [<c16c90f7>] ret_from_kernel_thread+0x1b/0x28
 [<c1051960>] ? insert_kthread_work+0x40/0x40
Code: 89 e5 83 ec 14 3e 8d 74 26 00 89 54 24 0c ba b4 85 84 c1 89 4c
24 10 89 44 24 08 89 54 24 04 c7 04 24 00 00 00 00 e8 d4 fd ff ff <0f>
0b 66 90 55 89 e5 83 ec 14 3e 8d 74 26 00 b9 01 00 00 00 89
EIP: [<c127fb4c>] assfail+0x2c/0x30 SS:ESP 0068:ded57e0c
---[ end trace e0e41bd9b0846f3e ]---
BUG: unable to handle kernel paging request at ffffffe0
IP: [<c1051a7f>] kthread_data+0xf/0x20
*pde = 0198d067 *pte = 00000000
Oops: 0000 [#2]
Pid: 97, comm: kworker/0:1H Tainted: G      D      3.9.0-rc1+ #1
EIP: 0060:[<c1051a7f>] EFLAGS: 00010046 CPU: 0
EIP is at kthread_data+0xf/0x20
EAX: 00000000 EBX: 00000000 ECX: ffd23940 EDX: 00000000
ESI: ded030c0 EDI: ded030c0 EBP: ded57c20 ESP: ded57c18
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 8005003b CR2: ffffffe0 CR3: 065aa000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process kworker/0:1H (pid: 97, ti=ded56000 task=ded030c0 task.ti=ded56000)
Stack:
 c104b250 00000000 ded57c98 c16c6f01 c107845f c18d1ce8 ded32c40 ded030c0
 00000000 ded57c48 ded56000 ded030c0 decea4c0 df57d980 df40c000 ded57c6c
 00000286 c18d1ce8 ded030c0 df57d980 ded030c0 ded57c78 c107913c c18d1cec
Call Trace:
 [<c104b250>] ? wq_worker_sleeping+0x10/0x60
 [<c16c6f01>] __schedule+0x391/0x5b0
 [<c107845f>] ? __call_rcu.isra.9+0x5f/0x70
 [<c107913c>] ? call_rcu_sched+0x1c/0x20
 [<c10357e0>] ? release_task+0x1d0/0x310
 [<c16c7142>] schedule+0x22/0x60
 [<c1036ade>] do_exit+0x53e/0x7d0
 [<c16c0ffc>] ? printk+0x3d/0x3f
 [<c1005239>] oops_end+0x79/0xa0
 [<c100539a>] die+0x4a/0x70
 [<c1002a95>] do_trap+0x55/0xb0
 [<c1002c90>] ? do_bounds+0x80/0x80
 [<c1002d1c>] do_invalid_op+0x8c/0xb0
 [<c127fb4c>] ? assfail+0x2c/0x30
 [<c10338c9>] ? vprintk_emit+0x149/0x490
 [<c143f798>] ? trace_hardirqs_off_thunk+0xc/0x14
 [<c16c8eea>] error_code+0x6a/0x70
 [<c1270000>] ? xfs_swapext+0x870/0x8a0
 [<c127fb4c>] ? assfail+0x2c/0x30
 [<c12b9f20>] __xfs_dir3_data_check+0x5e0/0x710
 [<c105ffe8>] ? update_curr.constprop.41+0xa8/0x180
 [<c12b7289>] xfs_dir3_block_verify+0x89/0xa0
 [<c105baba>] ? dequeue_task+0x8a/0xb0
 [<c12b7526>] xfs_dir3_block_read_verify+0x36/0xe0
 [<c105bba8>] ? finish_task_switch.constprop.83+0x48/0xa0
 [<c16c6e02>] ? __schedule+0x292/0x5b0
 [<c12ba36a>] xfs_dir3_data_reada_verify+0x8a/0xa0
 [<c126e0af>] xfs_buf_iodone_work+0x9f/0xd0
 [<c104a324>] process_one_work+0x114/0x350
 [<c104af7c>] worker_thread+0xec/0x350
 [<c104ae90>] ? manage_workers+0x2d0/0x2d0
 [<c10519f3>] kthread+0x93/0xa0
 [<c16c90f7>] ret_from_kernel_thread+0x1b/0x28
 [<c1051960>] ? insert_kthread_work+0x40/0x40
Code: 8b 80 24 02 00 00 5d 8b 50 d8 d1 ea 88 d0 24 01 c3 8d 74 26 00
8d bc 27 00 00 00 00 55 89 e5 3e 8d 74 26 00 8b 80 24 02 00 00 5d <8b>
40 e0 c3 8d b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 3e
EIP: [<c1051a7f>] kthread_data+0xf/0x20 SS:ESP 0068:ded57c18
CR2: 00000000ffffffe0
---[ end trace e0e41bd9b0846f3f ]---
Fixing recursive fault but reboot is needed!

==== SECOND OOPS: xfs_db blocktrash test

root@oldsvrhw:~# xfs_db -x /dev/sdb2
xfs_db> blockget
xfs_db> blocktrash -n 10240 -s 755366564 -3 -x 1 -y 16
blocktrash: 0/17856 inode block 6 bits starting 423:0 randomized
[lots of blocktrash stuff removed but still available]
blocktrash: 3/25387 dir block 2 bits starting 1999:1 randomized
xfs_db> quit
root@oldsvrhw:~# mount /dev/sdb2 /mnt/hole-test/
root@oldsvrhw:~# cd /mnt/hole-test/
root@oldsvrhw:/mnt/hole-test# find . -type f

XFS (sdb2): Mounting Filesystem
XFS (sdb2): Ending clean mount
XFS (sdb2): Invalid inode number 0x40000000800084
XFS (sdb2): Internal error xfs_dir_ino_validate at line 160 of file
fs/xfs/xfs_dir2.c.  Caller 0xc12b9d0d

Pid: 97, comm: kworker/0:1H Not tainted 3.9.0-rc1+ #1
Call Trace:
 [<c1270cbb>] xfs_error_report+0x4b/0x50
 [<c12b9d0d>] ? __xfs_dir3_data_check+0x3cd/0x710
 [<c12b6326>] xfs_dir_ino_validate+0xb6/0x180
 [<c12b9d0d>] ? __xfs_dir3_data_check+0x3cd/0x710
 [<c12b9d0d>] __xfs_dir3_data_check+0x3cd/0x710
 [<c105ffe8>] ? update_curr.constprop.41+0xa8/0x180
 [<c12b7289>] xfs_dir3_block_verify+0x89/0xa0
 [<c105baba>] ? dequeue_task+0x8a/0xb0
 [<c19530c0>] ? setup_local_APIC+0x202/0x369
 [<c12b7526>] xfs_dir3_block_read_verify+0x36/0xe0
 [<c105bba8>] ? finish_task_switch.constprop.83+0x48/0xa0
 [<c16c6e02>] ? __schedule+0x292/0x5b0
 [<c12ba36a>] xfs_dir3_data_reada_verify+0x8a/0xa0
 [<c126e0af>] xfs_buf_iodone_work+0x9f/0xd0
 [<c104a324>] process_one_work+0x114/0x350
 [<c104af7c>] worker_thread+0xec/0x350
 [<c104ae90>] ? manage_workers+0x2d0/0x2d0
 [<c10519f3>] kthread+0x93/0xa0
 [<c16c90f7>] ret_from_kernel_thread+0x1b/0x28
 [<c1051960>] ? insert_kthread_work+0x40/0x40
XFS: Assertion failed: fs_is_ok, file: fs/xfs/xfs_dir2_data.c, line: 150
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:100!
invalid opcode: 0000 [#1]
Pid: 97, comm: kworker/0:1H Not tainted 3.9.0-rc1+ #1
EIP: 0060:[<c127fb4c>] EFLAGS: 00010286 CPU: 0
EIP is at assfail+0x2c/0x30
EAX: 00000048 EBX: 0000000a ECX: c18c61e8 EDX: 000001bd
ESI: 00000096 EDI: d5174088 EBP: ded57e20 ESP: ded57e0c
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 08d37000 CR3: 1ea17000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process kworker/0:1H (pid: 97, ti=ded56000 task=dec69860 task.ti=ded56000)
Stack:
 00000000 c18485b4 c1833d86 c1835769 00000096 ded57e70 c12b9d2e c105ffe8
 00171496 00000000 00000005 d5174000 d5174f80 d5174ff8 d5174068 0000000d
 00000006 dcd06000 d5174004 d5174f80 d5174071 0000000f dc4e4400 d5174000
Call Trace:
 [<c12b9d2e>] __xfs_dir3_data_check+0x3ee/0x710
 [<c105ffe8>] ? update_curr.constprop.41+0xa8/0x180
 [<c12b7289>] xfs_dir3_block_verify+0x89/0xa0
 [<c105baba>] ? dequeue_task+0x8a/0xb0
 [<c19530c0>] ? setup_local_APIC+0x202/0x369
 [<c12b7526>] xfs_dir3_block_read_verify+0x36/0xe0
 [<c105bba8>] ? finish_task_switch.constprop.83+0x48/0xa0
 [<c16c6e02>] ? __schedule+0x292/0x5b0
 [<c12ba36a>] xfs_dir3_data_reada_verify+0x8a/0xa0
 [<c126e0af>] xfs_buf_iodone_work+0x9f/0xd0
 [<c104a324>] process_one_work+0x114/0x350
 [<c104af7c>] worker_thread+0xec/0x350
 [<c104ae90>] ? manage_workers+0x2d0/0x2d0
 [<c10519f3>] kthread+0x93/0xa0
 [<c16c90f7>] ret_from_kernel_thread+0x1b/0x28
 [<c1051960>] ? insert_kthread_work+0x40/0x40
Code: 89 e5 83 ec 14 3e 8d 74 26 00 89 54 24 0c ba b4 85 84 c1 89 4c
24 10 89 44 24 08 89 54 24 04 c7 04 24 00 00 00 00 e8 d4 fd ff ff <0f>
0b 66 90 55 89 e5 83 ec 14 3e 8d 74 26 00 b9 01 00 00 00 89
EIP: [<c127fb4c>] assfail+0x2c/0x30 SS:ESP 0068:ded57e0c
---[ end trace 91373c1397d75306 ]---
BUG: unable to handle kernel paging request at ffffffe0
IP: [<c1051a7f>] kthread_data+0xf/0x20
*pde = 0198d067 *pte = 00000000
Oops: 0000 [#2]
Pid: 97, comm: kworker/0:1H Tainted: G      D      3.9.0-rc1+ #1
EIP: 0060:[<c1051a7f>] EFLAGS: 00010046 CPU: 0
EIP is at kthread_data+0xf/0x20
EAX: 00000000 EBX: 00000000 ECX: ffd23940 EDX: 00000000
ESI: dec69860 EDI: dec69860 EBP: ded57c20 ESP: ded57c18
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 8005003b CR2: ffffffe0 CR3: 1ea17000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process kworker/0:1H (pid: 97, ti=ded56000 task=dec69860 task.ti=ded56000)
Stack:
 c104b250 00000000 ded57c98 c16c6f01 c107845f c18d1ce8 ded3ec40 dec69860
 00000000 ded57c48 ded56000 dec69860 decf24c0 df57d980 df40c000 ded57c6c
 00000286 c18d1ce8 dec69860 df57d980 dec69860 ded57c78 c107913c c18d1cec
Call Trace:
 [<c104b250>] ? wq_worker_sleeping+0x10/0x60
 [<c16c6f01>] __schedule+0x391/0x5b0
 [<c107845f>] ? __call_rcu.isra.9+0x5f/0x70
 [<c107913c>] ? call_rcu_sched+0x1c/0x20
 [<c10357e0>] ? release_task+0x1d0/0x310
 [<c16c7142>] schedule+0x22/0x60
 [<c1036ade>] do_exit+0x53e/0x7d0
 [<c16c0ffc>] ? printk+0x3d/0x3f
 [<c1005239>] oops_end+0x79/0xa0
 [<c100539a>] die+0x4a/0x70
 [<c1002a95>] do_trap+0x55/0xb0
 [<c1002c90>] ? do_bounds+0x80/0x80
 [<c1002d1c>] do_invalid_op+0x8c/0xb0
 [<c127fb4c>] ? assfail+0x2c/0x30
 [<c10338c9>] ? vprintk_emit+0x149/0x490
 [<c143f798>] ? trace_hardirqs_off_thunk+0xc/0x14
 [<c16c8eea>] error_code+0x6a/0x70
 [<c1270000>] ? xfs_swapext+0x870/0x8a0
 [<c127fb4c>] ? assfail+0x2c/0x30
 [<c12b9d2e>] __xfs_dir3_data_check+0x3ee/0x710
 [<c105ffe8>] ? update_curr.constprop.41+0xa8/0x180
 [<c12b7289>] xfs_dir3_block_verify+0x89/0xa0
 [<c105baba>] ? dequeue_task+0x8a/0xb0
 [<c19530c0>] ? setup_local_APIC+0x202/0x369
 [<c12b7526>] xfs_dir3_block_read_verify+0x36/0xe0
 [<c105bba8>] ? finish_task_switch.constprop.83+0x48/0xa0
 [<c16c6e02>] ? __schedule+0x292/0x5b0
 [<c12ba36a>] xfs_dir3_data_reada_verify+0x8a/0xa0
 [<c126e0af>] xfs_buf_iodone_work+0x9f/0xd0
 [<c104a324>] process_one_work+0x114/0x350
 [<c104af7c>] worker_thread+0xec/0x350
 [<c104ae90>] ? manage_workers+0x2d0/0x2d0
 [<c10519f3>] kthread+0x93/0xa0
 [<c16c90f7>] ret_from_kernel_thread+0x1b/0x28
 [<c1051960>] ? insert_kthread_work+0x40/0x40
Code: 8b 80 24 02 00 00 5d 8b 50 d8 d1 ea 88 d0 24 01 c3 8d 74 26 00
8d bc 27 00 00 00 00 55 89 e5 3e 8d 74 26 00 8b 80 24 02 00 00 5d <8b>
40 e0 c3 8d b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 3e
EIP: [<c1051a7f>] kthread_data+0xf/0x20 SS:ESP 0068:ded57c18
CR2: 00000000ffffffe0
---[ end trace 91373c1397d75307 ]---
Fixing recursive fault but reboot is needed!
BUG: spinlock lockup suspected on CPU#0, kworker/0:1H/97
 lock: runqueues+0x0/0x490, .magic: dead4ead, .owner: kworker/0:1H/97,
.owner_cpu: 0
Pid: 97, comm: kworker/0:1H Tainted: G      D      3.9.0-rc1+ #1
Call Trace:
 [<c16c4833>] spin_dump+0x90/0x97
 [<c14472b2>] do_raw_spin_lock+0xb2/0x100
 [<c16c860c>] _raw_spin_lock_irq+0x1c/0x20
 [<c16c6bd5>] __schedule+0x65/0x5b0
 [<c1033982>] ? vprintk_emit+0x202/0x490
 [<c16c0ffc>] ? printk+0x3d/0x3f
 [<c16c7142>] schedule+0x22/0x60
 [<c1036d67>] do_exit+0x7c7/0x7d0
 [<c16c0ffc>] ? printk+0x3d/0x3f
 [<c10310ff>] ? print_oops_end_marker+0x2f/0x40
 [<c1005239>] oops_end+0x79/0xa0
 [<c16c0910>] no_context+0x17e/0x186
 [<c16c0a55>] __bad_area_nosemaphore+0x13d/0x145
 [<c105ffe8>] ? update_curr.constprop.41+0xa8/0x180
 [<c1020a80>] ? vmalloc_sync_all+0x120/0x120
 [<c16c0a74>] bad_area_nosemaphore+0x17/0x19
 [<c10205c5>] __do_page_fault+0xa5/0x440
 [<c105fa39>] ? __enqueue_entity.constprop.44+0x69/0x70
 [<c10601dd>] ? enqueue_task_fair+0x11d/0x460
 [<c105cf6d>] ? check_preempt_curr+0x7d/0xa0
 [<c105cfbb>] ? ttwu_do_wakeup.constprop.89+0x2b/0x70
 [<c1020a80>] ? vmalloc_sync_all+0x120/0x120
 [<c1020a8d>] do_page_fault+0xd/0x10
 [<c16c8eea>] error_code+0x6a/0x70
 [<c1051a7f>] ? kthread_data+0xf/0x20
 [<c104b250>] ? wq_worker_sleeping+0x10/0x60
 [<c16c6f01>] __schedule+0x391/0x5b0
 [<c107845f>] ? __call_rcu.isra.9+0x5f/0x70
 [<c107913c>] ? call_rcu_sched+0x1c/0x20
 [<c10357e0>] ? release_task+0x1d0/0x310
 [<c16c7142>] schedule+0x22/0x60
 [<c1036ade>] do_exit+0x53e/0x7d0
 [<c16c0ffc>] ? printk+0x3d/0x3f
 [<c1005239>] oops_end+0x79/0xa0
 [<c100539a>] die+0x4a/0x70
 [<c1002a95>] do_trap+0x55/0xb0
 [<c1002c90>] ? do_bounds+0x80/0x80
 [<c1002d1c>] do_invalid_op+0x8c/0xb0
 [<c127fb4c>] ? assfail+0x2c/0x30
 [<c10338c9>] ? vprintk_emit+0x149/0x490
 [<c143f798>] ? trace_hardirqs_off_thunk+0xc/0x14
 [<c16c8eea>] error_code+0x6a/0x70
 [<c1270000>] ? xfs_swapext+0x870/0x8a0
 [<c127fb4c>] ? assfail+0x2c/0x30
 [<c12b9d2e>] __xfs_dir3_data_check+0x3ee/0x710
 [<c105ffe8>] ? update_curr.constprop.41+0xa8/0x180
 [<c12b7289>] xfs_dir3_block_verify+0x89/0xa0
 [<c105baba>] ? dequeue_task+0x8a/0xb0
 [<c19530c0>] ? setup_local_APIC+0x202/0x369
 [<c12b7526>] xfs_dir3_block_read_verify+0x36/0xe0
 [<c105bba8>] ? finish_task_switch.constprop.83+0x48/0xa0
 [<c16c6e02>] ? __schedule+0x292/0x5b0
 [<c12ba36a>] xfs_dir3_data_reada_verify+0x8a/0xa0
 [<c126e0af>] xfs_buf_iodone_work+0x9f/0xd0
 [<c104a324>] process_one_work+0x114/0x350
 [<c104af7c>] worker_thread+0xec/0x350
 [<c104ae90>] ? manage_workers+0x2d0/0x2d0
 [<c10519f3>] kthread+0x93/0xa0
 [<c16c90f7>] ret_from_kernel_thread+0x1b/0x28
 [<c1051960>] ? insert_kthread_work+0x40/0x40
BUG: unable to handle kernel paging request at ffffffe0
IP: [<c1051a7f>] kthread_data+0xf/0x20
*pde = 0198d067 *pte = 00000000
Oops: 0000 [#3]
Pid: 97, comm: kworker/0:1H Tainted: G      D      3.9.0-rc1+ #1
EIP: 0060:[<c1051a7f>] EFLAGS: 00010046 CPU: 0
EIP is at kthread_data+0xf/0x20
EAX: 00000000 EBX: 00000000 ECX: ffd23940 EDX: 00000000
ESI: dec69860 EDI: dec69860 EBP: ded579fc ESP: ded579f4
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 8005003b CR2: ffffffe0 CR3: 1ea17000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process kworker/0:1H (pid: 97, ti=ded56000 task=dec69860 task.ti=ded56000)
Stack:
 c104b250 00000000 ded57a74 c16c6f01 00000000 00000000 0000021d dec69860
 00000000 00000006 ded56000 dec69860 c1033982 00000000 00000000 00000000
 00000000 c19964c2 0000002c 00000024 c19964c2 00000000 00000046 00000009
Call Trace:
 [<c104b250>] ? wq_worker_sleeping+0x10/0x60
 [<c16c6f01>] __schedule+0x391/0x5b0
 [<c1033982>] ? vprintk_emit+0x202/0x490
 [<c16c0ffc>] ? printk+0x3d/0x3f
 [<c16c7142>] schedule+0x22/0x60
 [<c1036d67>] do_exit+0x7c7/0x7d0
 [<c16c0ffc>] ? printk+0x3d/0x3f
 [<c10310ff>] ? print_oops_end_marker+0x2f/0x40
 [<c1005239>] oops_end+0x79/0xa0
 [<c16c0910>] no_context+0x17e/0x186
 [<c16c0a55>] __bad_area_nosemaphore+0x13d/0x145
 [<c105ffe8>] ? update_curr.constprop.41+0xa8/0x180
 [<c1020a80>] ? vmalloc_sync_all+0x120/0x120
 [<c16c0a74>] bad_area_nosemaphore+0x17/0x19
 [<c10205c5>] __do_page_fault+0xa5/0x440
 [<c105fa39>] ? __enqueue_entity.constprop.44+0x69/0x70
 [<c10601dd>] ? enqueue_task_fair+0x11d/0x460
 [<c105cf6d>] ? check_preempt_curr+0x7d/0xa0
 [<c105cfbb>] ? ttwu_do_wakeup.constprop.89+0x2b/0x70
 [<c1020a80>] ? vmalloc_sync_all+0x120/0x120
 [<c1020a8d>] do_page_fault+0xd/0x10
 [<c16c8eea>] error_code+0x6a/0x70
 [<c1051a7f>] ? kthread_data+0xf/0x20
 [<c104b250>] ? wq_worker_sleeping+0x10/0x60
 [<c16c6f01>] __schedule+0x391/0x5b0
 [<c107845f>] ? __call_rcu.isra.9+0x5f/0x70
 [<c107913c>] ? call_rcu_sched+0x1c/0x20
 [<c10357e0>] ? release_task+0x1d0/0x310
 [<c16c7142>] schedule+0x22/0x60
 [<c1036ade>] do_exit+0x53e/0x7d0
 [<c16c0ffc>] ? printk+0x3d/0x3f
 [<c1005239>] oops_end+0x79/0xa0
 [<c100539a>] die+0x4a/0x70
 [<c1002a95>] do_trap+0x55/0xb0
 [<c1002c90>] ? do_bounds+0x80/0x80
 [<c1002d1c>] do_invalid_op+0x8c/0xb0
 [<c127fb4c>] ? assfail+0x2c/0x30
 [<c10338c9>] ? vprintk_emit+0x149/0x490
 [<c143f798>] ? trace_hardirqs_off_thunk+0xc/0x14
 [<c16c8eea>] error_code+0x6a/0x70
 [<c1270000>] ? xfs_swapext+0x870/0x8a0
 [<c127fb4c>] ? assfail+0x2c/0x30
 [<c12b9d2e>] __xfs_dir3_data_check+0x3ee/0x710
 [<c105ffe8>] ? update_curr.constprop.41+0xa8/0x180
 [<c12b7289>] xfs_dir3_block_verify+0x89/0xa0
 [<c105baba>] ? dequeue_task+0x8a/0xb0
 [<c19530c0>] ? setup_local_APIC+0x202/0x369
 [<c12b7526>] xfs_dir3_block_read_verify+0x36/0xe0
 [<c105bba8>] ? finish_task_switch.constprop.83+0x48/0xa0
 [<c16c6e02>] ? __schedule+0x292/0x5b0
 [<c12ba36a>] xfs_dir3_data_reada_verify+0x8a/0xa0
 [<c126e0af>] xfs_buf_iodone_work+0x9f/0xd0
 [<c104a324>] process_one_work+0x114/0x350
 [<c104af7c>] worker_thread+0xec/0x350
 [<c104ae90>] ? manage_workers+0x2d0/0x2d0
 [<c10519f3>] kthread+0x93/0xa0
 [<c16c90f7>] ret_from_kernel_thread+0x1b/0x28
 [<c1051960>] ? insert_kthread_work+0x40/0x40
Code: 8b 80 24 02 00 00 5d 8b 50 d8 d1 ea 88 d0 24 01 c3 8d 74 26 00
8d bc 27 00 00 00 00 55 89 e5 3e 8d 74 26 00 8b 80 24 02 00 00 5d <8b>
40 e0 c3 8d b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 3e
EIP: [<c1051a7f>] kthread_data+0xf/0x20 SS:ESP 0068:ded579f4
CR2: 00000000ffffffe0
---[ end trace 91373c1397d75308 ]---
Fixing recursive fault but reboot is needed!
BUG: spinlock lockup suspected on CPU#0, kworker/0:1H/97

[...and so on and so forth, but it wasn't an infinite-scrolling oops,
just something that seemed to add a message every now and then...]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
