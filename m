Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17048 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754065AbcKQRgr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2016 12:36:47 -0500
Date: Thu, 17 Nov 2016 09:36:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [BUG] dd doesn't return on ENOSPC and hang when fulfilling
 rmapbt XFS
Message-ID: <20161117173639.GJ16813@birch.djwong.org>
References: <20161117163515.GB27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161117163515.GB27776@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 18, 2016 at 12:35:15AM +0800, Eryu Guan wrote:
> Hi all,
> 
> I hit a test hang in generic/224 when testing rmapbt enabled XFS on a
> host that has non-zero sunit/swidth reported from underlying device. And
> I simplified the reproducer to the following script, and the hang can be
> reproduced on any host now.
> 
> -----
> #!/bin/bash
> 
> dev=/dev/sda5
> mnt=/mnt/xfs
> 
> mkfs -t xfs -m rmapbt=1 -d agcount=8,size=1g -f $dev

Hm.  I formatted with:
mkfs.xfs -m rmapbt=1 -d sunit=4096,swidth=40960 -f /dev/sdf

(made up sunit numbers just to see how whacky it could get)

and got a different hang instead.  It looks like we are unable to
allocate any blocks to the bmbt and various things blow up from
there.  Will go retry with tracepoints on to see if we're running
out of AG reservation or if we're really out of disk blocks or what.

Crash message attached at the end.

--D

> mount $dev $mnt
> xfs_io -x -c "resblks 4" $mnt
> 
> dd if=/dev/zero of=/mnt/xfs/testfile
> 
> echo "dd should return and report ENOSPC"
> -----
> 
> sysrq-w output:
> sysrq: SysRq : Show Blocked State
>   task                        PC stack   pid father
> dd              D    0  2504   2491 0x00000080
>  ffff88021077dd00 0000000000000000 ffff88021623be40 ffff88021fd99300
>  ffff8802107467c0 ffffc900019dbc18 ffffffff816e2cf5 ffff88020fa8ce90
>  ffffc900019dbc40 0000000000000286 ffff8802107467c0 ffff88020fa8ce90
> Call Trace:
>  [<ffffffff816e2cf5>] ? __schedule+0x195/0x630
>  [<ffffffff816e31c6>] schedule+0x36/0x80
>  [<ffffffff812534b4>] wb_wait_for_completion+0x64/0x90
>  [<ffffffff810d2910>] ? prepare_to_wait_event+0xf0/0xf0
>  [<ffffffff81255b3d>] sync_inodes_sb+0xad/0x290
>  [<ffffffff81288bc0>] ? iomap_write_end+0x80/0x80
>  [<ffffffff8128922c>] ? iomap_apply+0x6c/0x130
>  [<ffffffffa014c2a8>] xfs_flush_inodes+0x28/0x40 [xfs]
>  [<ffffffffa013370b>] xfs_file_buffered_aio_write+0x18b/0x280 [xfs]
>  [<ffffffffa0133890>] xfs_file_write_iter+0x90/0x130 [xfs]
>  [<ffffffff81226b52>] __vfs_write+0xe2/0x140
>  [<ffffffff812279d2>] vfs_write+0xb2/0x1b0
>  [<ffffffff81003510>] ? syscall_trace_enter+0x1d0/0x2b0
>  [<ffffffff81228e25>] SyS_write+0x55/0xc0
>  [<ffffffff81003a47>] do_syscall_64+0x67/0x180
>  [<ffffffff816e796b>] entry_SYSCALL64_slow_path+0x25/0x25
> 
> I tested on 4.9-rc5 kernel, for-next branch from linux-xfs tree and
> latest djwong-devel branch from Darrick's tree.
> 
> If you need more information please let me know.
> 
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


XFS: Assertion failed: args.fsbno != NULLFSBLOCK, file: /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/libxfs/xfs_bmap.c, line: 789
------------[ cut here ]------------
WARNING: CPU: 1 PID: 104 at /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_message.c:113 assfail+0x31/0x40 [xfs]
Modules linked in: xfs libcrc32c dax_pmem dax nd_pmem sch_fq_codel af_packet
CPU: 1 PID: 104 Comm: kworker/u8:6 Not tainted 4.9.0-rc5-xfsx #41
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
Workqueue: writeback wb_workfn (flush-8:80)
 ffffc9000083b398 ffffffff81340643 0000000000000000 0000000000000000
 ffffc9000083b3d8 ffffffff8108690b 000000710083b3f8 ffff88006be0a080
 ffffc9000083b838 ffff88006d437000 0000000000000001 ffff88006e407350
Call Trace:
 [<ffffffff81340643>] dump_stack+0x85/0xc2
 [<ffffffff8108690b>] __warn+0xcb/0xf0
 [<ffffffff810869fd>] warn_slowpath_null+0x1d/0x20
 [<ffffffffa00e8971>] assfail+0x31/0x40 [xfs]
 [<ffffffffa0062df5>] xfs_bmap_extents_to_btree+0x235/0x780 [xfs]
 [<ffffffffa0066a91>] xfs_bmap_add_extent_delay_real+0x1af1/0x1ce0 [xfs]
 [<ffffffffa009eb0c>] ? xfs_iext_bno_to_ext+0x8c/0x170 [xfs]
 [<ffffffffa006d06f>] xfs_bmapi_write+0xb6f/0x1180 [xfs]
 [<ffffffff810e016d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa00dda24>] xfs_iomap_write_allocate+0x184/0x360 [xfs]
 [<ffffffffa00b9baf>] xfs_map_blocks+0x34f/0x4e0 [xfs]
 [<ffffffffa00ba920>] xfs_do_writepage+0x310/0x840 [xfs]
 [<ffffffff811abc91>] write_cache_pages+0x251/0x640
 [<ffffffffa00ba610>] ? xfs_aops_discard_page+0x140/0x140 [xfs]
 [<ffffffffa00ba043>] xfs_vm_writepages+0xa3/0xe0 [xfs]
 [<ffffffff811acb81>] do_writepages+0x21/0x30
 [<ffffffff81252031>] __writeback_single_inode+0x61/0x800
 [<ffffffff81252cf7>] writeback_sb_inodes+0x297/0x5e0
 [<ffffffff8125329c>] wb_writeback+0xfc/0x5c0
 [<ffffffff81255e8b>] wb_workfn+0x11b/0x680
 [<ffffffff810a62d8>] process_one_work+0x1f8/0x750
 [<ffffffff810a6259>] ? process_one_work+0x179/0x750
 [<ffffffff810a687b>] worker_thread+0x4b/0x4f0
 [<ffffffff810a6830>] ? process_one_work+0x750/0x750
 [<ffffffff810ad3c2>] kthread+0x102/0x120
 [<ffffffff810ad2c0>] ? kthread_park+0x60/0x60
 [<ffffffff8168243a>] ret_from_fork+0x2a/0x40
---[ end trace a2c2fccec3607587 ]---
XFS: Assertion failed: fsbno != NULLFSBLOCK, file: /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/libxfs/xfs_btree.c, line: 662
------------[ cut here ]------------
WARNING: CPU: 1 PID: 104 at /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_message.c:113 assfail+0x31/0x40 [xfs]
Modules linked in: xfs libcrc32c dax_pmem dax nd_pmem sch_fq_codel af_packet
CPU: 1 PID: 104 Comm: kworker/u8:6 Tainted: G        W       4.9.0-rc5-xfsx #41
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
Workqueue: writeback wb_workfn (flush-8:80)
 ffffc9000083b358 ffffffff81340643 0000000000000000 0000000000000000
 ffffc9000083b398 ffffffff8108690b 000000710083b3b8 ffffffffffffffff
 ffff88006e407350 0000000000000000 ffff88006d437000 ffff88006e407350
Call Trace:
 [<ffffffff81340643>] dump_stack+0x85/0xc2
 [<ffffffff8108690b>] __warn+0xcb/0xf0
 [<ffffffff810869fd>] warn_slowpath_null+0x1d/0x20
 [<ffffffffa00e8971>] assfail+0x31/0x40 [xfs]
 [<ffffffffa007602e>] xfs_btree_get_bufl+0x3e/0xb0 [xfs]
 [<ffffffffa0062e8e>] xfs_bmap_extents_to_btree+0x2ce/0x780 [xfs]
 [<ffffffffa0066a91>] xfs_bmap_add_extent_delay_real+0x1af1/0x1ce0 [xfs]
 [<ffffffffa009eb0c>] ? xfs_iext_bno_to_ext+0x8c/0x170 [xfs]
 [<ffffffffa006d06f>] xfs_bmapi_write+0xb6f/0x1180 [xfs]
 [<ffffffff810e016d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa00dda24>] xfs_iomap_write_allocate+0x184/0x360 [xfs]
 [<ffffffffa00b9baf>] xfs_map_blocks+0x34f/0x4e0 [xfs]
 [<ffffffffa00ba920>] xfs_do_writepage+0x310/0x840 [xfs]
 [<ffffffff811abc91>] write_cache_pages+0x251/0x640
 [<ffffffffa00ba610>] ? xfs_aops_discard_page+0x140/0x140 [xfs]
 [<ffffffffa00ba043>] xfs_vm_writepages+0xa3/0xe0 [xfs]
 [<ffffffff811acb81>] do_writepages+0x21/0x30
 [<ffffffff81252031>] __writeback_single_inode+0x61/0x800
 [<ffffffff81252cf7>] writeback_sb_inodes+0x297/0x5e0
 [<ffffffff8125329c>] wb_writeback+0xfc/0x5c0
 [<ffffffff81255e8b>] wb_workfn+0x11b/0x680
 [<ffffffff810a62d8>] process_one_work+0x1f8/0x750
 [<ffffffff810a6259>] ? process_one_work+0x179/0x750
 [<ffffffff810a687b>] worker_thread+0x4b/0x4f0
 [<ffffffff810a6830>] ? process_one_work+0x750/0x750
 [<ffffffff810ad3c2>] kthread+0x102/0x120
 [<ffffffff810ad2c0>] ? kthread_park+0x60/0x60
 [<ffffffff8168243a>] ret_from_fork+0x2a/0x40
---[ end trace a2c2fccec3607588 ]---
XFS (sdf): _xfs_buf_find: Block out of range: block 0x600000001fff8, EOFS 0x300000 
------------[ cut here ]------------
WARNING: CPU: 1 PID: 104 at /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_buf.c:520 _xfs_buf_find+0x448/0x4c0 [xfs]
Modules linked in: xfs libcrc32c dax_pmem dax nd_pmem sch_fq_codel af_packetCPU: 1 PID: 104 Comm: kworker/u8:6 Tainted: G        W       4.9.0-rc5-xfsx #41
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
Workqueue: writeback wb_workfn (flush-8:80)
 ffffc9000083b288 ffffffff81340643 0000000000000000 0000000000000000
 ffffc9000083b2c8 ffffffff8108690b 000002080083b2e8 0000000000000008
 ffff88006e72a400 000600000001fff8 ffffc9000083b3c8 0000000000000001
Call Trace:
 [<ffffffff81340643>] dump_stack+0x85/0xc2
 [<ffffffff8108690b>] __warn+0xcb/0xf0
 [<ffffffff810869fd>] warn_slowpath_null+0x1d/0x20
 [<ffffffffa00c49e8>] _xfs_buf_find+0x448/0x4c0 [xfs]
 [<ffffffffa00c4e5a>] xfs_buf_get_map+0x2a/0x400 [xfs]
 [<ffffffffa0126692>] xfs_trans_get_buf_map+0x222/0x3f0 [xfs]
 [<ffffffffa0076089>] xfs_btree_get_bufl+0x99/0xb0 [xfs]
 [<ffffffffa0062e8e>] xfs_bmap_extents_to_btree+0x2ce/0x780 [xfs]
 [<ffffffffa0066a91>] xfs_bmap_add_extent_delay_real+0x1af1/0x1ce0 [xfs]
 [<ffffffffa009eb0c>] ? xfs_iext_bno_to_ext+0x8c/0x170 [xfs]
 [<ffffffffa006d06f>] xfs_bmapi_write+0xb6f/0x1180 [xfs]
 [<ffffffff810e016d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa00dda24>] xfs_iomap_write_allocate+0x184/0x360 [xfs]
 [<ffffffffa00b9baf>] xfs_map_blocks+0x34f/0x4e0 [xfs]
 [<ffffffffa00ba920>] xfs_do_writepage+0x310/0x840 [xfs]
 [<ffffffff811abc91>] write_cache_pages+0x251/0x640
 [<ffffffffa00ba610>] ? xfs_aops_discard_page+0x140/0x140 [xfs]
 [<ffffffffa00ba043>] xfs_vm_writepages+0xa3/0xe0 [xfs]
 [<ffffffff811acb81>] do_writepages+0x21/0x30
 [<ffffffff81252031>] __writeback_single_inode+0x61/0x800
 [<ffffffff81252cf7>] writeback_sb_inodes+0x297/0x5e0
 [<ffffffff8125329c>] wb_writeback+0xfc/0x5c0
 [<ffffffff81255e8b>] wb_workfn+0x11b/0x680
 [<ffffffff810a62d8>] process_one_work+0x1f8/0x750
 [<ffffffff810a6259>] ? process_one_work+0x179/0x750
 [<ffffffff810a687b>] worker_thread+0x4b/0x4f0
 [<ffffffff810a6830>] ? process_one_work+0x750/0x750
 [<ffffffff810ad3c2>] kthread+0x102/0x120
 [<ffffffff810ad2c0>] ? kthread_park+0x60/0x60
 [<ffffffff8168243a>] ret_from_fork+0x2a/0x40
---[ end trace a2c2fccec3607589 ]---
XFS (sdf): _xfs_buf_find: Block out of range: block 0x600000001fff8, EOFS 0x300000 
------------[ cut here ]------------
WARNING: CPU: 1 PID: 104 at /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_buf.c:520 _xfs_buf_find+0x448/0x4c0 [xfs]
Modules linked in: xfs libcrc32c dax_pmem dax nd_pmem sch_fq_codel af_packet
CPU: 1 PID: 104 Comm: kworker/u8:6 Tainted: G        W       4.9.0-rc5-xfsx #41
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
Workqueue: writeback wb_workfn (flush-8:80)
 ffffc9000083b288 ffffffff81340643 0000000000000000 0000000000000000
 ffffc9000083b2c8 ffffffff8108690b 000002080083b2e8 0000000000000008
 ffff88006e72a400 000600000001fff8 ffffc9000083b3c8 0000000000000001
Call Trace:
 [<ffffffff81340643>] dump_stack+0x85/0xc2
 [<ffffffff8108690b>] __warn+0xcb/0xf0
 [<ffffffff810869fd>] warn_slowpath_null+0x1d/0x20
 [<ffffffffa00c49e8>] _xfs_buf_find+0x448/0x4c0 [xfs]
 [<ffffffffa00c5011>] xfs_buf_get_map+0x1e1/0x400 [xfs]
 [<ffffffffa0126692>] xfs_trans_get_buf_map+0x222/0x3f0 [xfs]
 [<ffffffffa0076089>] xfs_btree_get_bufl+0x99/0xb0 [xfs]
 [<ffffffffa0062e8e>] xfs_bmap_extents_to_btree+0x2ce/0x780 [xfs]
 [<ffffffffa0066a91>] xfs_bmap_add_extent_delay_real+0x1af1/0x1ce0 [xfs]
 [<ffffffffa009eb0c>] ? xfs_iext_bno_to_ext+0x8c/0x170 [xfs]
 [<ffffffffa006d06f>] xfs_bmapi_write+0xb6f/0x1180 [xfs]
 [<ffffffff810e016d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa00dda24>] xfs_iomap_write_allocate+0x184/0x360 [xfs]
 [<ffffffffa00b9baf>] xfs_map_blocks+0x34f/0x4e0 [xfs]
 [<ffffffffa00ba920>] xfs_do_writepage+0x310/0x840 [xfs]
 [<ffffffff811abc91>] write_cache_pages+0x251/0x640
 [<ffffffffa00ba610>] ? xfs_aops_discard_page+0x140/0x140 [xfs]
 [<ffffffffa00ba043>] xfs_vm_writepages+0xa3/0xe0 [xfs]
 [<ffffffff811acb81>] do_writepages+0x21/0x30
 [<ffffffff81252031>] __writeback_single_inode+0x61/0x800
 [<ffffffff81252cf7>] writeback_sb_inodes+0x297/0x5e0
 [<ffffffff8125329c>] wb_writeback+0xfc/0x5c0
 [<ffffffff81255e8b>] wb_workfn+0x11b/0x680
 [<ffffffff810a62d8>] process_one_work+0x1f8/0x750
 [<ffffffff810a6259>] ? process_one_work+0x179/0x750
 [<ffffffff810a687b>] worker_thread+0x4b/0x4f0
 [<ffffffff810a6830>] ? process_one_work+0x750/0x750
 [<ffffffff810ad3c2>] kthread+0x102/0x120
 [<ffffffff810ad2c0>] ? kthread_park+0x60/0x60
 [<ffffffff8168243a>] ret_from_fork+0x2a/0x40
---[ end trace a2c2fccec360758a ]---
BUG: unable to handle kernel NULL pointer dereference at 00000000000002a0
IP: [<ffffffffa0062e95>] xfs_bmap_extents_to_btree+0x2d5/0x780 [xfs]
PGD 76f16067 PUD 6f51c067 
PMD 0 
Oops: 0002 [#1] PREEMPT SMP
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in: xfs libcrc32c dax_pmem dax nd_pmem sch_fq_codel af_packet
CPU: 1 PID: 104 Comm: kworker/u8:6 Tainted: G        W       4.9.0-rc5-xfsx #41
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
Workqueue: writeback wb_workfn (flush-8:80)
task: ffff8800750f9680 task.stack: ffffc90000838000
RIP: 0010:[<ffffffffa0062e95>]  [<ffffffffa0062e95>] xfs_bmap_extents_to_btree+0x2d5/0x780 [xfs]
RSP: 0018:ffffc9000083b408  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff88006be0a080 RCX: 0000000000000002
RDX: 0000000000000000 RSI: ffffffff819e97f8 RDI: 0000000000000246
RBP: ffffc9000083b520 R08: ffffea0000f8b090 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc9000083b838
R13: ffff88006d437000 R14: 0000000000000001 R15: ffff88006e407350
FS:  0000000000000000(0000) GS:ffff88007f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000002a0 CR3: 000000006e42f000 CR4: 00000000001406e0
Stack:
 0000000000001003 ffffc90000000009 ffffc9000083b568 0000000000000001
 0000000000000000 ffffc9000083b770 ffff880074d8c780 ffff88006e6f2db0
 ffffc9000083b848 ffff88006be0a0c8 ffff88006e407350 ffff88006d437000
Call Trace:
 [<ffffffffa0066a91>] xfs_bmap_add_extent_delay_real+0x1af1/0x1ce0 [xfs]
 [<ffffffffa009eb0c>] ? xfs_iext_bno_to_ext+0x8c/0x170 [xfs]
 [<ffffffffa006d06f>] xfs_bmapi_write+0xb6f/0x1180 [xfs]
 [<ffffffff810e016d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa00dda24>] xfs_iomap_write_allocate+0x184/0x360 [xfs]
 [<ffffffffa00b9baf>] xfs_map_blocks+0x34f/0x4e0 [xfs]
 [<ffffffffa00ba920>] xfs_do_writepage+0x310/0x840 [xfs]
 [<ffffffff811abc91>] write_cache_pages+0x251/0x640
 [<ffffffffa00ba610>] ? xfs_aops_discard_page+0x140/0x140 [xfs]
 [<ffffffffa00ba043>] xfs_vm_writepages+0xa3/0xe0 [xfs]
 [<ffffffff811acb81>] do_writepages+0x21/0x30
 [<ffffffff81252031>] __writeback_single_inode+0x61/0x800
 [<ffffffff81252cf7>] writeback_sb_inodes+0x297/0x5e0
 [<ffffffff8125329c>] wb_writeback+0xfc/0x5c0
 [<ffffffff81255e8b>] wb_workfn+0x11b/0x680
 [<ffffffff810a62d8>] process_one_work+0x1f8/0x750
 [<ffffffff810a6259>] ? process_one_work+0x179/0x750
 [<ffffffff810a687b>] worker_thread+0x4b/0x4f0
 [<ffffffff810a6830>] ? process_one_work+0x750/0x750
 [<ffffffff810ad3c2>] kthread+0x102/0x120
 [<ffffffff810ad2c0>] ? kthread_park+0x60/0x60
 [<ffffffff8168243a>] ret_from_fork+0x2a/0x40
Code: 00 00 00 48 83 83 08 03 00 00 01 e8 06 a3 0c 00 31 c9 4c 89 fe 4c 89 ef 48 8b 95 60 ff ff ff e8 62 31 01 00 48 89 85 08 ff ff ff <48> c7 80 a0 02 00 00 50 c8 13 a0 48 8b 80 68 01 00 00 48 89 85 
RIP  [<ffffffffa0062e95>] xfs_bmap_extents_to_btree+0x2d5/0x780 [xfs]
 RSP <ffffc9000083b408>
CR2: 00000000000002a0
---[ end trace a2c2fccec360758b ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 104 at /storage/home/djwong/cdev/work/linux-xfs/kernel/exit.c:737 do_exit+0x4b/0xc40
Modules linked in: xfs libcrc32c dax_pmem dax nd_pmem sch_fq_codel af_packet
CPU: 1 PID: 104 Comm: kworker/u8:6 Tainted: G      D W       4.9.0-rc5-xfsx #41
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
 ffffc9000083be90 ffffffff81340643 0000000000000000 0000000000000000
 ffffc9000083bed0 ffffffff8108690b 000002e1819bf972 ffff8800750f9680
 0000000000000009 ffffc9000083b358 0000000000000002 000000000000000b
Call Trace:
 [<ffffffff81340643>] dump_stack+0x85/0xc2
 [<ffffffff8108690b>] __warn+0xcb/0xf0
 [<ffffffff810869fd>] warn_slowpath_null+0x1d/0x20
 [<ffffffff8108a99b>] do_exit+0x4b/0xc40
 [<ffffffff816836b7>] rewind_stack_do_exit+0x17/0x20
---[ end trace a2c2fccec360758c ]---
BUG: sleeping function called from invalid context at /storage/home/djwong/cdev/work/linux-xfs/include/linux/sched.h:3109
in_atomic(): 0, irqs_disabled(): 1, pid: 104, name: kworker/u8:6
INFO: lockdep is turned off.
irq event stamp: 403636
hardirqs last  enabled at (403635): [<ffffffff81205906>] kmem_cache_free+0x66/0x220
hardirqs last disabled at (403636): [<ffffffff81683489>] error_entry+0x69/0xc0
softirqs last  enabled at (403622): [<ffffffff81684c50>] __do_softirq+0x200/0x4bb
softirqs last disabled at (403615): [<ffffffff8108e979>] irq_exit+0xc9/0xd0
CPU: 1 PID: 104 Comm: kworker/u8:6 Tainted: G      D W       4.9.0-rc5-xfsx #41
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
Workqueue:  0xfffed4840f02c4f6 (�Ł��)
 ffffc9000083be58 ffffffff81340643 0000000000000000 ffff8800750f9680
 ffffc9000083be90 ffffffff810b4994 ffffffff819c0848 0000000000000c25
 0000000000000000 0000000000000002 000000000000000b ffffc9000083beb8
Call Trace:
 [<ffffffff81340643>] dump_stack+0x85/0xc2
 [<ffffffff810b4994>] ___might_sleep+0x174/0x260
 [<ffffffff810b4aca>] __might_sleep+0x4a/0x80
 [<ffffffff8109b1b4>] exit_signals+0x24/0x2c0
 [<ffffffff8108a9f4>] do_exit+0xa4/0xc40
 [<ffffffff816836b7>] rewind_stack_do_exit+0x17/0x20
