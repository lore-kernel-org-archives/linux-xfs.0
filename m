Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7B7Lr6W110668 for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 02:22:10 -0500
Received: from intranet.easterngraphics.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B12B93AD866
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 00:22:07 -0700 (PDT)
Received: from intranet.easterngraphics.com (intranet.easterngraphics.com
	[62.80.28.49]) by cuda.sgi.com with ESMTP id P3PjSG0tpEovjAWF
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 00:22:07 -0700 (PDT)
From: Christian Fischer <Christian.Fischer@easterngraphics.com>
Subject: xfs crash, kernel 2.6.29
Date: Tue, 11 Aug 2009 09:21:50 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908110921.50752.Christian.Fischer@easterngraphics.com>
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
To: xfs@oss.sgi.com
Cc: Andrew Lyon <andrew.lyon@gmail.com>, Eric Sandeen <sandeen@sandeen.net>

We had a new crash yesterday, server uptime maybe 20 hours.

This is 2.6.29-xen-r4 from 
http://code.google.com/p/gentoo-xen-kernel/downloads/list

@Eric/Andrew: do we have a xfs or a xen patches problem?

Christian




------------[ cut here ]------------
Kernel BUG at ffffffff8045281d [verbose debug info unavailable]
invalid opcode: 0000 [#1] SMP
last sysfs 
file: /sys/devices/xen/pci-0/pci0000:00/0000:00:00.0/host3/target3:0:6/3:0:6:0/rev
CPU 3
Modules linked in: nfsd
Pid: 227, comm: kswapd0 Not tainted 2.6.29-xen-r4 #13
RIP: e030:[<ffffffff8045281d>]  [<ffffffff8045281d>] 
radix_tree_tag_set+0x9d/0xb0
RSP: e02b:ffff8800ff97bce0  EFLAGS: 00010246
RAX: 000000000000002d RBX: 0000000000000000 RCX: ffff8800c13ceba8
RDX: 0000000000000000 RSI: 000000000022df71 RDI: ffff8800fe866e40
RBP: ffff8800fe866e00 R08: 000000000000002d R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000003 R12: ffff8800fec59c00
R13: ffff8800067f7938 R14: 0000000000000080 R15: 000000000004828f
FS:  00007f0617e8e6f0(0000) GS:ffff8800010061c0(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f187e14a110 CR3: 00000000fdcbd000 CR4: 0000000000002620
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kswapd0 (pid: 227, threadinfo ffff8800ff97a000, task ffff8800ffb50540)
Stack:
ffff8800067f7840 ffffffff80422100 000000000004828f ffff8800067f7840
ffff8800067f79c0 ffff8800ff97bd80 0000000000000012 ffffffff8041229b
ffff8800067f79c0 ffff8800067f79c0 ffff8800067f79c0 ffffffff80421146
Call Trace:
[<ffffffff80422100>] ? xfs_inode_set_reclaim_tag+0x80/0xd0
[<ffffffff8041229b>] ? xfs_reclaim+0x6b/0xe0
[<ffffffff80421146>] ? xfs_fs_destroy_inode+0x36/0x60
[<ffffffff802a8c12>] ? dispose_list+0xa2/0x150
[<ffffffff802a8e9f>] ? shrink_icache_memory+0x1df/0x310
[<ffffffff8026da44>] ? shrink_slab+0x124/0x180
[<ffffffff8026e24d>] ? kswapd+0x3bd/0x600
[<ffffffff8026b700>] ? isolate_pages_global+0x0/0x280
[<ffffffff80245670>] ? autoremove_wake_function+0x0/0x30
[<ffffffff802242fb>] ? __wake_up_common+0x5b/0x90
[<ffffffff8026de90>] ? kswapd+0x0/0x600
[<ffffffff802451eb>] ? kthread+0x4b/0x80
[<ffffffff8020b66a>] ? child_rip+0xa/0x20
[<ffffffff802451a0>] ? kthread+0x0/0x80
[<ffffffff8020b660>] ? child_rip+0x0/0x20
Code: 18 4d 85 d2 74 25 41 ff cb 75 c4 4d 85 d2 74 16 8b 47 04 8d 4b 15 ba 01 
00 00 00 d3 e2 85 d0 75 05 09 d0 89 47 04 5b 4c 89 d0 c3 <0f> 0b eb fe 0f 0b 
eb fe 66 66 2e 0f 1f 84 00 00 00 00 00 41 57
RIP  [<ffffffff8045281d>] radix_tree_tag_set+0x9d/0xb0
RSP <ffff8800ff97bce0>
---[ end trace 48e7c392f10d019e ]---
Aug 10 17:23:35 ganges ------------[ cut here ]------------
Aug 10 17:23:35 ganges Kernel BUG at ffffffff8045281d [verbose debug info 
unavailable]
Aug 10 17:23:35 ganges invalid opcode: 0000 [#1] SMP
Aug 10 17:23:35 ganges last sysfs 
file: /sys/devices/xen/pci-0/pci0000:00/0000:00:00.0/host3/target3:0:6/3:0:6:0/rev
Aug 10 17:23:35 ganges CPU 3
Aug 10 17:23:35 ganges Modules linked in: nfsd
Aug 10 17:23:35 ganges Pid: 227, comm: kswapd0 Not tainted 2.6.29-xen-r4 #13
Aug 10 17:23:35 ganges RIP: e030:[<ffffffff8045281d>]  [<ffffffff8045281d>] 
radix_tree_tag_set+0x9d/0xb0
Aug 10 17:23:35 ganges RSP: e02b:ffff8800ff97bce0  EFLAGS: 00010246
Aug 10 17:23:35 ganges RAX: 000000000000002d RBX: 0000000000000000 RCX: 
ffff8800c13ceba8
Aug 10 17:23:35 ganges RDX: 0000000000000000 RSI: 000000000022df71 RDI: 
ffff8800fe866e40
Aug 10 17:23:35 ganges RBP: ffff8800fe866e00 R08: 000000000000002d R09: 
000000000000000c
Aug 10 17:23:35 ganges R10: 0000000000000000 R11: 0000000000000003 R12: 
ffff8800fec59c00
Aug 10 17:23:35 ganges R13: ffff8800067f7938 R14: 0000000000000080 R15: 
000000000004828f
Aug 10 17:23:35 ganges FS:  00007f0617e8e6f0(0000) GS:ffff8800010061c0(0000) 
knlGS:0000000000000000
Aug 10 17:23:35 ganges CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 10 17:23:35 ganges CR2: 00007f187e14a110 CR3: 00000000fdcbd000 CR4: 
0000000000002620
Aug 10 17:23:35 ganges DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
Aug 10 17:23:35 ganges DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
Aug 10 17:23:35 ganges Process kswapd0 (pid: 227, threadinfo ffff8800ff97a000, 
task ffff8800ffb50540)
Aug 10 17:23:35 ganges Stack:
Aug 10 17:23:35 ganges ffff8800067f7840 ffffffff80422100 000000000004828f 
ffff8800067f7840
Aug 10 17:23:35 ganges ffff8800067f79c0 ffff8800ff97bd80 0000000000000012 
ffffffff8041229b
Aug 10 17:23:35 ganges ffff8800067f79c0 ffff8800067f79c0 ffff8800067f79c0 
ffffffff80421146
Aug 10 17:23:35 ganges Call Trace:
Aug 10 17:23:35 ganges [<ffffffff80422100>] ? 
xfs_inode_set_reclaim_tag+0x80/0xd0
Aug 10 17:23:35 ganges [<ffffffff8041229b>] ? xfs_reclaim+0x6b/0xe0
Aug 10 17:23:35 ganges [<ffffffff80421146>] ? xfs_fs_destroy_inode+0x36/0x60
Aug 10 17:23:35 ganges [<ffffffff802a8c12>] ? dispose_list+0xa2/0x150
Aug 10 17:23:35 ganges [<ffffffff802a8e9f>] ? shrink_icache_memory+0x1df/0x310
Aug 10 17:23:35 ganges [<ffffffff8026da44>] ? shrink_slab+0x124/0x180
Aug 10 17:23:35 ganges [<ffffffff8026e24d>] ? kswapd+0x3bd/0x600
Aug 10 17:23:35 ganges [<ffffffff8026b700>] ? isolate_pages_global+0x0/0x280
Aug 10 17:23:35 ganges [<ffffffff80245670>] ? 
autoremove_wake_function+0x0/0x30
Aug 10 17:23:35 ganges [<ffffffff802242fb>] ? __wake_up_common+0x5b/0x90
Aug 10 17:23:35 ganges [<ffffffff8026de90>] ? kswapd+0x0/0x600
Aug 10 17:23:35 ganges [<ffffffff802451eb>] ? kthread+0x4b/0x80
Aug 10 17:23:35 ganges [<ffffffff8020b66a>] ? child_rip+0xa/0x20
Aug 10 17:23:35 ganges [<ffffffff802451a0>] ? kthread+0x0/0x80
Aug 10 17:23:35 ganges [<ffffffff8020b660>] ? child_rip+0x0/0x20
Aug 10 17:23:35 ganges Code: 18 4d 85 d2 74 25 41 ff cb 75 c4 4d 85 d2 74 16 
8b 47 04 8d 4b 15 ba 01 00 00 00 d3 e2 85 d0 75 05 09 d0 89 47 04 5b 4c 89 d0 
c3 <0f> 0b eb fe 0f 0b eb fe 66 66 2e 0f 1f 84 00 00 00 00 00 41 57
Aug 10 17:23:35 ganges RIP  [<ffffffff8045281d>] radix_tree_tag_set+0x9d/0xb0
Aug 10 17:23:35 ganges RSP <ffff8800ff97bce0>
Aug 10 17:23:35 ganges ---[ end trace 48e7c392f10d019e ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
