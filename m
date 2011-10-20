Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9KMgKTv030431 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 17:42:20 -0500
Received: from peace.netnation.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7D751E13A4
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 15:42:17 -0700 (PDT)
Received: from peace.netnation.com (peace.netnation.com [204.174.223.2]) by
	cuda.sgi.com with ESMTP id tQmPAUEZfNWlUksC for
	<xfs@oss.sgi.com>; Thu, 20 Oct 2011 15:42:17 -0700 (PDT)
Date: Thu, 20 Oct 2011 15:42:14 -0700
From: Simon Kirby <sim@hostway.ca>
Subject: XFS read hangs in 3.1-rc10
Message-ID: <20111020224214.GC22772@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hello!

We're seeing a big problem with read latency in 3.1-rc10 and 3.1-rc7
when compared with 2.6.36, to the point that the hung task detector is
spitting out traces when set to 30 seconds. At first, we noticed this on
SATA disks on a PERC5 controller and figured it was just really bad RAID
latency, but it also seems to be happening on an SSD box.

This is kind of a pain to debug since running "ps" also seems to cause
reclaim from fork() which hits a lock held by the rest of the blocked
stuff, so I wrote some hacky tools that do it without allocating (much)
memory or forking: http://0x.ca/sim/ref/tools/

watch_utilization: full-screen iostat/vmstat type output
pstack: full-screen "ps -eo pid,cmd,stat | grep D" with stack trace

kswapd has a stack trace like this (and is almost always in D state),
from cat /proc/`pidof kswapd0`/stack:

[<ffffffff8126f205>] xfs_reclaim_inode+0x85/0x2b0
[<ffffffff8126f5b0>] xfs_reclaim_inodes_ag+0x180/0x2f0
[<ffffffff8126f74e>] xfs_reclaim_inodes_nr+0x2e/0x40
[<ffffffff8126ccf0>] xfs_fs_free_cached_objects+0x10/0x20
[<ffffffff81119a70>] prune_super+0x110/0x1b0
[<ffffffff810e4fa5>] shrink_slab+0x1e5/0x2a0
[<ffffffff810e5821>] kswapd+0x7c1/0xba0
[<ffffffff8107ada6>] kthread+0x96/0xb0
[<ffffffff816c0474>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff

All of the other processes that get stuck have this stack:

[<ffffffff81080587>] down+0x47/0x50
[<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
[<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
[<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
[<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
[<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
[<ffffffff8129e161>] xfs_read_agi+0x71/0x100
[<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
[<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
[<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
[<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
[<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
[<ffffffff8127390a>] xfs_create+0x46a/0x600
[<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
[<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
[<ffffffff81124c99>] vfs_create+0x99/0xd0
[<ffffffff8112635b>] do_last+0x69b/0x810
[<ffffffff8112659f>] path_openat+0xcf/0x3f0
[<ffffffff811269d3>] do_filp_open+0x43/0xa0
[<ffffffff81115202>] do_sys_open+0x152/0x1f0
[<ffffffff811152cb>] sys_open+0x1b/0x20
[<ffffffff816be392>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

By the way, xfs_reclaim_inode+0x85 (133) disassembles as:

   0xffffffff8128d4dd <+77>:    nopl   (%rax)
   0xffffffff8128d4e0 <+80>:    mov    $0x4,%esi
   0xffffffff8128d4e5 <+85>:    mov    %r12,%rdi
   0xffffffff8128d4e8 <+88>:    callq  0xffffffff812831c0 <xfs_ilock>
   0xffffffff8128d4ed <+93>:    mov    %r15,%rdi
   0xffffffff8128d4f0 <+96>:    callq  0xffffffff8104c810 <try_wait_for_completion>
   0xffffffff8128d4f5 <+101>:   test   %al,%al
   0xffffffff8128d4f7 <+103>:   jne    0xffffffff8128d515 <xfs_reclaim_inode+133>
   0xffffffff8128d4f9 <+105>:   test   %r14d,%r14d
   0xffffffff8128d4fc <+108>:   nopl   0x0(%rax)
   0xffffffff8128d500 <+112>:   je     0xffffffff8128d6d8 <xfs_reclaim_inode+584>
   0xffffffff8128d506 <+118>:   mov    %r15,%rdi
   0xffffffff8128d509 <+121>:   nopl   0x0(%rax)
   0xffffffff8128d510 <+128>:   callq  0xffffffff816f1bb0 <wait_for_completion>
   0xffffffff8128d515 <+133>:   mov    -0x40(%rbp),%rdi
   0xffffffff8128d519 <+137>:   callq  0xffffffff81146e10 <is_bad_inode>
   0xffffffff8128d51e <+142>:   test   %eax,%eax

...So the next function is wait_for_completion(), which is marked
__sched and thus doesn't show up in the trace.

When the clog happens, "iostat -x -k 1" shows no reads from the XFS
devices, though writes keep happening. "vmstat 1" matches. I tried
switching schedulers from CFQ to deadline -- no difference. Queue depth
is empty on the devices and nothing is actually clogged up at the device
-- it's not actually plugged at the controller or disk. I did a sysreq-w
while this was happening. About 10 seconds later, everything unclogs and
continues. Sysreq-W output below. I poked around at the various XFS
tracepoints in /sys/kernel/debug/tracing/events/xfs, but I'm not sure
which tracepoints to use and many of them scroll too fast to see
anything. Any suggestions?

Simon-

SysRq : Show Blocked State
  task                        PC stack   pid father
kswapd0         D ffff88022fc52940     0   543      2 0x00000000
 ffff8802261f1940 0000000000000046 ffff8802261f0010 ffff880226b5ac80
 0000000000012940 ffff8802261f1fd8 ffff8802261f1fd8 0000000000012940
 0000000000000001 ffff880226b5ac80 ffff8801e0831640 ffff880226b5b000
Call Trace:
 [<ffffffff816b482a>] ? schedule+0x3a/0x60
 [<ffffffff8111167e>] ? __slab_free+0x1fe/0x320
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff816b3bae>] wait_for_common+0xee/0x180
 [<ffffffff81050490>] ? try_to_wake_up+0x270/0x270
 [<ffffffff810aa980>] ? call_rcu_sched+0x10/0x20
 [<ffffffff816b3ce8>] wait_for_completion+0x18/0x20
 [<ffffffff8126f205>] xfs_reclaim_inode+0x85/0x2b0
 [<ffffffff8137663b>] ? radix_tree_gang_lookup_tag+0xab/0x120
 [<ffffffff8126f5b0>] xfs_reclaim_inodes_ag+0x180/0x2f0
 [<ffffffff8126f74e>] xfs_reclaim_inodes_nr+0x2e/0x40
 [<ffffffff8126ccf0>] xfs_fs_free_cached_objects+0x10/0x20
 [<ffffffff81119a70>] prune_super+0x110/0x1b0
 [<ffffffff810e4fa5>] shrink_slab+0x1e5/0x2a0
 [<ffffffff810e5821>] kswapd+0x7c1/0xba0
 [<ffffffff8105049d>] ? default_wake_function+0xd/0x10
 [<ffffffff8107b2c0>] ? wake_up_bit+0x40/0x40
 [<ffffffff810e5060>] ? shrink_slab+0x2a0/0x2a0
 [<ffffffff8107ada6>] kthread+0x96/0xb0
 [<ffffffff816c0474>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107ad10>] ? kthread_worker_fn+0x190/0x190
 [<ffffffff816c0470>] ? gs_change+0x13/0x13
pop3            D ffff88022fcd2940     0  4189   4182 0x00000000
 ffff880226a8fa18 0000000000000082 ffff880226a8e010 ffff8802253a0000
 0000000000012940 ffff880226a8ffd8 ffff880226a8ffd8 0000000000012940
 0000000000000003 ffff8802253a0000 ffff880226949640 ffff8802253a0380
Call Trace:
 [<ffffffff81371163>] ? cpumask_next_and+0x23/0x40
 [<ffffffff810498ca>] ? select_task_rq_fair+0x5aa/0xb30
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff812a3f58>] xfs_iunlink+0x48/0x150
 [<ffffffff8105f1a2>] ? current_fs_time+0x22/0x30
 [<ffffffff812b8ccd>] ? xfs_trans_ichgtime+0x1d/0xb0
 [<ffffffff81271246>] xfs_droplink+0x56/0x70
 [<ffffffff812731fd>] xfs_remove+0x2bd/0x3a0
 [<ffffffff81269c73>] xfs_vn_unlink+0x43/0x90
 [<ffffffff811250d1>] vfs_unlink+0x91/0x110
 [<ffffffff81125313>] do_unlinkat+0x1c3/0x1e0
 [<ffffffff8111b831>] ? sys_newstat+0x31/0x50
 [<ffffffff81125341>] sys_unlink+0x11/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
pop3            D ffff88022fc12940     0  4190   4182 0x00000000
 ffff880225475648 0000000000000082 ffff880225474010 ffff8802253a5900
 0000000000012940 ffff880225475fd8 ffff880225475fd8 0000000000012940
 0000000000000000 ffff8802253a5900 ffffffff819b3020 ffff8802253a5c80
Call Trace:
 [<ffffffff810d56e1>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff812a1181>] ? xfs_iext_bno_to_ext+0x91/0x180
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff815e14f3>] ? dev_queue_xmit+0x153/0x5b0
 [<ffffffff810d6e2a>] ? zone_watermark_ok+0x1a/0x20
 [<ffffffff813758a6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
pop3            D ffff88022fc12940     0  4191   4182 0x00000000
 ffff880225e29648 0000000000000086 ffff880225e28010 ffff880226b09640
 0000000000012940 ffff880225e29fd8 ffff880225e29fd8 0000000000012940
 0000000000000000 ffff880226b09640 ffffffff819b3020 ffff880226b099c0
Call Trace:
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff81111fde>] ? kmem_cache_alloc+0xee/0x100
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff810d56e1>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff81265482>] ? xfs_iunlock+0xc2/0x130
 [<ffffffff8125c201>] ? __xfs_get_blocks+0x411/0x4a0
 [<ffffffff813758a6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
pop3            D ffff88022fc12940     0  4192   4182 0x00000000
 ffff880224071648 0000000000000086 ffff880224070010 ffff880226b0c2c0
 0000000000012940 ffff880224071fd8 ffff880224071fd8 0000000000012940
 0000000000000000 ffff880226b0c2c0 ffffffff819b3020 ffff880226b0c640
Call Trace:
 [<ffffffff812a1181>] ? xfs_iext_bno_to_ext+0x91/0x180
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff816b4f6b>] ? __wait_on_bit+0x7b/0x90
 [<ffffffff813758a6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
pop3            D ffff88022fc12940     0  4193   4182 0x00000000
 ffff8802255db648 0000000000000082 ffff8802255da010 ffff8802261c42c0
 0000000000012940 ffff8802255dbfd8 ffff8802255dbfd8 0000000000012940
 0000000000000000 ffff8802261c42c0 ffffffff819b3020 ffff8802261c4640
Call Trace:
 [<ffffffff810d56e1>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff81265482>] ? xfs_iunlock+0xc2/0x130
 [<ffffffff8125c201>] ? __xfs_get_blocks+0x411/0x4a0
 [<ffffffff813758a6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
pop3            D ffff88022fcd2940     0  4194   4182 0x00000000
 ffff880224121648 0000000000000086 ffff880224120010 ffff880226249640
 0000000000012940 ffff880224121fd8 ffff880224121fd8 0000000000012940
 0000000000000003 ffff880226249640 ffff880226949640 ffff8802262499c0
Call Trace:
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff81111fde>] ? kmem_cache_alloc+0xee/0x100
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff810d56e1>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff81375790>] ? prop_norm_single+0x80/0xd0
 [<ffffffff813758a6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
pop3            D ffff88022fc12940     0  4195   4182 0x00000000
 ffff880224141648 0000000000000082 ffff880224140010 ffff8802260d0000
 0000000000012940 ffff880224141fd8 ffff880224141fd8 0000000000012940
 0000000000000000 ffff8802260d0000 ffffffff819b3020 ffff8802260d0380
Call Trace:
 [<ffffffff812a1181>] ? xfs_iext_bno_to_ext+0x91/0x180
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff81265482>] ? xfs_iunlock+0xc2/0x130
 [<ffffffff8125c201>] ? __xfs_get_blocks+0x411/0x4a0
 [<ffffffff813758a6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
pop3            D ffff88022fc12940     0  4196   4182 0x00000000
 ffff880224143648 0000000000000086 ffff880224142010 ffff8802260d5900
 0000000000012940 ffff880224143fd8 ffff880224143fd8 0000000000012940
 0000000000000000 ffff8802260d5900 ffffffff819b3020 ffff8802260d5c80
Call Trace:
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff81111fde>] ? kmem_cache_alloc+0xee/0x100
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff810d56e1>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff8168a5b6>] ? vlan_dev_hard_start_xmit+0x76/0xe0
 [<ffffffff815e10f8>] ? dev_hard_start_xmit+0x418/0x6c0
 [<ffffffff813758a6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
lmtp            D ffff88022fc92940     0  4205   4182 0x00000000
 ffff88022433f648 0000000000000086 ffff88022433e010 ffff880225481640
 0000000000012940 ffff88022433ffd8 ffff88022433ffd8 0000000000012940
 0000000000000002 ffff880225481640 ffff880226929640 ffff8802254819c0
Call Trace:
 [<ffffffff8128ad9d>] ? xfs_bmbt_get_startoff+0xd/0x20
 [<ffffffff812a1181>] ? xfs_iext_bno_to_ext+0x91/0x180
 [<ffffffff81111fde>] ? kmem_cache_alloc+0xee/0x100
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff81265482>] ? xfs_iunlock+0xc2/0x130
 [<ffffffff8125c201>] ? __xfs_get_blocks+0x411/0x4a0
 [<ffffffff81011815>] ? __switch_to+0x1a5/0x340
 [<ffffffff813758a6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
lmtp            D ffff88022fc12940     0  4206   4182 0x00000000
 ffff88022435f648 0000000000000086 ffff88022435e010 ffff880225482c80
 0000000000012940 ffff88022435ffd8 ffff88022435ffd8 0000000000012940
 0000000000000000 ffff880225482c80 ffffffff819b3020 ffff880225483000
Call Trace:
 [<ffffffff8128ad56>] ? xfs_bmbt_get_all+0x16/0x20
 [<ffffffff812a1181>] ? xfs_iext_bno_to_ext+0x91/0x180
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff81265482>] ? xfs_iunlock+0xc2/0x130
 [<ffffffff8125c201>] ? __xfs_get_blocks+0x411/0x4a0
 [<ffffffff813758a6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
lmtp            D ffff88022fcd2940     0  4207   4182 0x00000000
 ffff880224361648 0000000000000082 ffff880224360010 ffff8802261e9640
 0000000000012940 ffff880224361fd8 ffff880224361fd8 0000000000012940
 0000000000000003 ffff8802261e9640 ffff8802261c42c0 ffff8802261e99c0
Call Trace:
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff812a1181>] ? xfs_iext_bno_to_ext+0x91/0x180
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff81265482>] ? xfs_iunlock+0xc2/0x130
 [<ffffffff8125c201>] ? __xfs_get_blocks+0x411/0x4a0
 [<ffffffff81011815>] ? __switch_to+0x1a5/0x340
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
lmtp            D ffff88022fcd2940     0  4208   4182 0x00000000
 ffff880224383648 0000000000000086 ffff880224382010 ffff880226a7c2c0
 0000000000012940 ffff880224383fd8 ffff880224383fd8 0000000000012940
 0000000000000003 ffff880226a7c2c0 ffff8802260d0000 ffff880226a7c640
Call Trace:
 [<ffffffff812a1181>] ? xfs_iext_bno_to_ext+0x91/0x180
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff810d56e1>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff81111f65>] ? kmem_cache_alloc+0x75/0x100
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff812654ca>] ? xfs_iunlock+0x10a/0x130
 [<ffffffff8125c201>] ? __xfs_get_blocks+0x411/0x4a0
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
lmtp            D ffff88022fc52940     0  4209   4182 0x00000000
 ffff8802243a3648 0000000000000086 ffff8802243a2010 ffff880224035900
 0000000000012940 ffff8802243a3fd8 ffff8802243a3fd8 0000000000012940
 0000000000000001 ffff880224035900 ffff880226911640 ffff880224035c80
Call Trace:
 [<ffffffff8128ad56>] ? xfs_bmbt_get_all+0x16/0x20
 [<ffffffff812a1181>] ? xfs_iext_bno_to_ext+0x91/0x180
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff812654ca>] ? xfs_iunlock+0x10a/0x130
 [<ffffffff8125c250>] ? __xfs_get_blocks+0x460/0x4a0
 [<ffffffff813758a6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
lmtp            D ffff88022fc52940     0  4210   4182 0x00000000
 ffff8802243c5648 0000000000000082 ffff8802243c4010 ffff8802243c8000
 0000000000012940 ffff8802243c5fd8 ffff8802243c5fd8 0000000000012940
 0000000000000001 ffff8802243c8000 ffff880226911640 ffff8802243c8380
Call Trace:
 [<ffffffff8104beef>] ? set_next_entity+0xaf/0xd0
 [<ffffffff812a1e7c>] ? xfs_iext_insert+0xbc/0xe0
 [<ffffffff81285f3d>] ? xfs_bmap_add_extent+0xad/0x390
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff813758a6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
lmtp            D ffff88022fc12940     0  4211   4182 0x00000000
 ffff8802243c7648 0000000000000082 ffff8802243c6010 ffff8802243c9640
 0000000000012940 ffff8802243c7fd8 ffff8802243c7fd8 0000000000012940
 0000000000000000 ffff8802243c9640 ffffffff819b3020 ffff8802243c99c0
Call Trace:
 [<ffffffff810d56e1>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff810d56e1>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff810d56e1>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff810d57f0>] ? mempool_alloc+0x60/0x140
 [<ffffffff81111f65>] ? kmem_cache_alloc+0x75/0x100
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff81265482>] ? xfs_iunlock+0xc2/0x130
 [<ffffffff8125c201>] ? __xfs_get_blocks+0x411/0x4a0
 [<ffffffff813758a6>] ? __prop_inc_single+0x46/0x60
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
lmtp            D ffff88022fc12940     0  4212   4182 0x00000000
 ffff8802243f3948 0000000000000082 ffff8802243f2010 ffff8802243cac80
 0000000000012940 ffff8802243f3fd8 ffff8802243f3fd8 0000000000012940
 0000000000000000 ffff8802243cac80 ffffffff819b3020 ffff8802243cb000
Call Trace:
 [<ffffffff810695f6>] ? lock_timer_base+0x36/0x70
 [<ffffffff81069a78>] ? try_to_del_timer_sync+0xa8/0xd0
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4c62>] schedule_timeout+0x192/0x280
 [<ffffffff81069c60>] ? del_timer+0xd0/0xd0
 [<ffffffff816b4d69>] schedule_timeout_uninterruptible+0x19/0x20
 [<ffffffff81265b56>] xfs_iget+0x176/0x670
 [<ffffffff812a33aa>] xfs_ialloc+0x9a/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
imap            D ffff88022fc52940     0  4215   4182 0x00000000
 ffff88022043d648 0000000000000082 ffff88022043c010 ffff880225042c80
 0000000000012940 ffff88022043dfd8 ffff88022043dfd8 0000000000012940
 0000000000000001 ffff880225042c80 ffff880226911640 ffff880225043000
Call Trace:
 [<ffffffff812a1181>] ? xfs_iext_bno_to_ext+0x91/0x180
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff81047ff0>] ? update_curr+0x100/0x1a0
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
imap            D ffff88022fcd2940     0  4216   4182 0x00000000
 ffff88022045f648 0000000000000082 ffff88022045e010 ffff880220460000
 0000000000012940 ffff88022045ffd8 ffff88022045ffd8 0000000000012940
 0000000000000003 ffff880220460000 ffff880226949640 ffff880220460380
Call Trace:
 [<ffffffff812a1181>] ? xfs_iext_bno_to_ext+0x91/0x180
 [<ffffffff812a1e7c>] ? xfs_iext_insert+0xbc/0xe0
 [<ffffffff81285f3d>] ? xfs_bmap_add_extent+0xad/0x390
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff81371163>] ? cpumask_next_and+0x23/0x40
 [<ffffffff812acb44>] ? xfs_perag_get+0x34/0xb0
 [<ffffffff81265eef>] ? xfs_iget+0x50f/0x670
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff811228ba>] ? inode_permission+0x7a/0xd0
 [<ffffffff81121bd7>] ? do_lookup+0xf7/0x3a0
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b
doveadm         D ffff88022fc12940     0 12727  11474 0x00000000
 ffff880002ce5648 0000000000000082 ffff880002ce4010 ffff880218b30000
 0000000000012940 ffff880002ce5fd8 ffff880002ce5fd8 0000000000012940
 0000000000000000 ffff880218b30000 ffffffff819b3020 ffff880218b30380
Call Trace:
 [<ffffffff812a1181>] ? xfs_iext_bno_to_ext+0x91/0x180
 [<ffffffff8114959b>] ? bvec_alloc_bs+0x6b/0x110
 [<ffffffff816b482a>] schedule+0x3a/0x60
 [<ffffffff816b4ced>] schedule_timeout+0x21d/0x280
 [<ffffffff816b5cc0>] __down+0x70/0xb0
 [<ffffffff812603ad>] ? _xfs_buf_find+0x16d/0x270
 [<ffffffff81080587>] down+0x47/0x50
 [<ffffffff8125e816>] xfs_buf_lock+0x66/0xd0
 [<ffffffff812603ad>] _xfs_buf_find+0x16d/0x270
 [<ffffffff81274c37>] ? kmem_zone_alloc+0x77/0xe0
 [<ffffffff81260517>] xfs_buf_get+0x67/0x1a0
 [<ffffffff8126067a>] xfs_buf_read+0x2a/0x120
 [<ffffffff812b876f>] xfs_trans_read_buf+0x28f/0x3f0
 [<ffffffff8129e161>] xfs_read_agi+0x71/0x100
 [<ffffffff81111fde>] ? kmem_cache_alloc+0xee/0x100
 [<ffffffff8129e219>] xfs_ialloc_read_agi+0x29/0xa0
 [<ffffffff8129e59b>] xfs_ialloc_ag_select+0x1db/0x2a0
 [<ffffffff8129fc95>] xfs_dialloc+0x415/0x8c0
 [<ffffffff810b8215>] ? tracing_record_cmdline+0x35/0x110
 [<ffffffff816b4385>] ? __schedule+0x585/0x950
 [<ffffffff8112da50>] ? dput+0x40/0x320
 [<ffffffff812a336c>] xfs_ialloc+0x5c/0x710
 [<ffffffff812b381f>] ? xlog_grant_log_space+0x24f/0x530
 [<ffffffff81274cd5>] ? kmem_zone_zalloc+0x35/0x50
 [<ffffffff812712d5>] xfs_dir_ialloc+0x75/0x290
 [<ffffffff812afa39>] ? xfs_trans_reserve+0x99/0x210
 [<ffffffff8127390a>] xfs_create+0x46a/0x600
 [<ffffffff8112b66f>] ? d_instantiate+0x5f/0x70
 [<ffffffff81269a7a>] xfs_vn_mknod+0x7a/0x130
 [<ffffffff81269b4b>] xfs_vn_create+0xb/0x10
 [<ffffffff81124c99>] vfs_create+0x99/0xd0
 [<ffffffff8112635b>] do_last+0x69b/0x810
 [<ffffffff8112659f>] path_openat+0xcf/0x3f0
 [<ffffffff8112401d>] ? user_path_at+0x8d/0xb0
 [<ffffffff811269d3>] do_filp_open+0x43/0xa0
 [<ffffffff81131d2a>] ? alloc_fd+0x4a/0x140
 [<ffffffff81115202>] do_sys_open+0x152/0x1f0
 [<ffffffff811152cb>] sys_open+0x1b/0x20
 [<ffffffff816be392>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
