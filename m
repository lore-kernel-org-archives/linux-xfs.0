Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9FC0AgS103560
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 07:00:15 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA4401475DA1
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 05:07:46 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id BxuzHjCoLgwObHAa for <linux-xfs@oss.sgi.com>;
	Sat, 15 Oct 2011 05:07:46 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RF2uN-0004J5-GI
	for linux-xfs@oss.sgi.com; Sat, 15 Oct 2011 14:00:07 +0200
Received: from r1.spray.net.pl ([83.143.40.194])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 14:00:07 +0200
Received: from gmane by r1.spray.net.pl with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 14:00:07 +0200
From: Marcin M <gmane@mejor.pl>
Subject: tasks hangs in D state while writing to xfs
Date: Sat, 15 Oct 2011 13:54:15 +0200
Message-ID: <j7bs98$5bs$1@dough.gmane.org>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Hello!
I've noticed strange problem with xfs. I've created filesystem with
blocksize=3D1024 and log as small as it possible. Next i'm copying files
using rsync, after sometime rsync hangs in D state. So i can't kill it,
i've got to reboot hosts. In dmesg i'm getting such messages:
[ 1320.535833] INFO: task flush-8:0:1173 blocked for more than 120 seconds.
[ 1320.535834] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1320.535836] flush-8:0       D 0000000000000000     0  1173      2
0x00000000
[ 1320.535838]  ffff88001e1a0000 0000000000000046 ffff880000000000
0000000000000000
[ 1320.535841]  ffff88001ed14a40 000000000000cd80 ffff88001e1a03f0
ffffffff81030fa0
[ 1320.535843]  000000000000cd80 ffff88001e1a03f0 ffff88001e1a03f0
000000000000cd80
[ 1320.535845] Call Trace:
[ 1320.535847]  [<ffffffff81030fa0>] ? check_preempt_wakeup+0x140/0x140
[ 1320.535854]  [<ffffffffa006dd3b>] ?
xfs_bmap_search_multi_extents+0xab/0x120 [xfs]
[ 1320.535860]  [<ffffffffa006def8>] ?
xfs_bmap_search_extents+0x68/0x100 [xfs]
[ 1320.535868]  [<ffffffffa009ae2b>] ? xlog_grant_log_space+0x16b/0x340
[xfs]
[ 1320.535874]  [<ffffffffa00af6c2>] ? kmem_zone_zalloc+0x32/0x50 [xfs]
[ 1320.535876]  [<ffffffff81036ef0>] ? try_to_wake_up+0x280/0x280
[ 1320.535884]  [<ffffffffa00a83bb>] ? xfs_trans_reserve+0x9b/0x200 [xfs]
[ 1320.535891]  [<ffffffffa00a8237>] ? xfs_trans_alloc+0x97/0xb0 [xfs]
[ 1320.535898]  [<ffffffffa0097c3b>] ?
xfs_iomap_write_allocate+0x20b/0x320 [xfs]
[ 1320.535907]  [<ffffffffa00b021f>] ? xfs_map_blocks+0x18f/0x1c0 [xfs]
[ 1320.535914]  [<ffffffffa00b13fe>] ? xfs_vm_writepage+0x1ae/0x4a0 [xfs]
[ 1320.535916]  [<ffffffff8109c797>] ? __writepage+0x17/0x40
[ 1320.535918]  [<ffffffff8109ceaa>] ? write_cache_pages+0x1ca/0x400
[ 1320.535920]  [<ffffffff8109c780>] ? set_page_dirty+0x80/0x80
[ 1320.535922]  [<ffffffff8109d128>] ? generic_writepages+0x48/0x80
[ 1320.535926]  [<ffffffff81105c82>] ? writeback_single_inode+0x102/0x260
[ 1320.535928]  [<ffffffff81106056>] ? writeback_sb_inodes+0xf6/0x1a0
[ 1320.535930]  [<ffffffff81106aeb>] ? writeback_inodes_wb+0x8b/0x140
[ 1320.535932]  [<ffffffff81106e23>] ? wb_writeback+0x283/0x2f0
[ 1320.535935]  [<ffffffff81106f24>] ? wb_do_writeback+0x94/0x1e0
[ 1320.535938]  [<ffffffff810496a0>] ? run_timer_softirq+0x240/0x240
[ 1320.535940]  [<ffffffff811070f2>] ? bdi_writeback_thread+0x82/0x150
[ 1320.535942]  [<ffffffff81107070>] ? wb_do_writeback+0x1e0/0x1e0
[ 1320.535944]  [<ffffffff81107070>] ? wb_do_writeback+0x1e0/0x1e0
[ 1320.535946]  [<ffffffff8105b7d2>] ? kthread+0xa2/0xb0
[ 1320.535948]  [<ffffffff81353919>] ? kernel_thread_helper+0x9/0x20
[ 1320.535950]  [<ffffffff813522ea>] ? retint_restore_args+0x6/0xd
[ 1320.535952]  [<ffffffff8105b730>] ? kthread_worker_fn+0x140/0x140
[ 1320.535954]  [<ffffffff81353910>] ? gs_change+0x1b/0x1b

It looks it's reproducible problem on my host. Now i'm using kernel
3.0.4-hardened-r5 but this happens with older kernels too. I did echo
"t" >/proc/sysrq and i got:
[...]
[ 3038.290721] xfsbufd/sda11   S ffff88001ecf6180     0  3892      2
0x00000000
[ 3038.290721]  ffff880019562880 0000000000000046 0000000003b4ceaf
ffff880000000001
[ 3038.290721]  ffff88001e33af40 000000000000cd80 ffff880019562c70
ffffffff81030fa0
[ 3038.290721]  000000000000cd80 ffff880019562c70 ffff880019562c70
000000000000cd80
[ 3038.290721] Call Trace:
[ 3038.290721]  [<ffffffff81030fa0>] ? check_preempt_wakeup+0x140/0x140
[ 3038.290721]  [<ffffffff8123b37c>] ? sd_prep_fn+0x15c/0xac0
[ 3038.290721]  [<ffffffff811ab8f4>] ? blk_peek_request+0xb4/0x1f0
[ 3038.290721]  [<ffffffff813506a2>] ? schedule_timeout+0x152/0x230
[ 3038.290721]  [<ffffffff810496a0>] ? run_timer_softirq+0x240/0x240
[ 3038.290721]  [<ffffffffa00b3c0f>] ? xfsbufd+0x8f/0x120 [xfs]
[ 3038.290721]  [<ffffffffa00b3b80>] ? xfs_bdstrat_cb+0x60/0x60 [xfs]
[ 3038.290721]  [<ffffffffa00b3b80>] ? xfs_bdstrat_cb+0x60/0x60 [xfs]
[ 3038.290721]  [<ffffffff8105b7d2>] ? kthread+0xa2/0xb0
[ 3038.290721]  [<ffffffff81353919>] ? kernel_thread_helper+0x9/0x20
[ 3038.290721]  [<ffffffff813522ea>] ? retint_restore_args+0x6/0xd
[ 3038.290721]  [<ffffffff8105b730>] ? kthread_worker_fn+0x140/0x140
[ 3038.290721]  [<ffffffff81353910>] ? gs_change+0x1b/0x1b
[ 3038.290721] rsync           D 0000000000000000     0  3957      1
0x00000004
[ 3038.290721]  ffff880019559440 0000000000000086 0000000000000400
0000000000000000
[ 3038.290721]  ffff88001820b600 000000000000cd80 ffff880019559830
ffffffff81030fa0
[ 3038.290721]  000000000000cd80 ffff880019559830 ffff880019559830
000000000000cd80
[ 3038.290721] Call Trace:
[ 3038.290721]  [<ffffffff81030fa0>] ? check_preempt_wakeup+0x140/0x140
[ 3038.290721]  [<ffffffff8109d304>] ? account_page_dirtied+0x74/0xa0
[ 3038.290721]  [<ffffffff81110e99>] ?
__block_commit_write.clone.17+0xa9/0xf0
[ 3038.290721]  [<ffffffffa009aef6>] ? xlog_grant_log_space+0x236/0x340
[xfs]
[ 3038.290721]  [<ffffffff81036ef0>] ? try_to_wake_up+0x280/0x280
[ 3038.290721]  [<ffffffffa00a83bb>] ? xfs_trans_reserve+0x9b/0x200 [xfs]
[ 3038.290721]  [<ffffffffa00a8237>] ? xfs_trans_alloc+0x97/0xb0 [xfs]
[ 3038.290721]  [<ffffffffa00a6b46>] ? xfs_rename+0x156/0x710 [xfs]
[ 3038.290721]  [<ffffffff810e9f21>] ? complete_walk+0x71/0x120
[ 3038.290721]  [<ffffffffa00badd0>] ? xfs_vn_rename+0x60/0x70 [xfs]
[ 3038.290721]  [<ffffffff810eb696>] ? vfs_rename+0x3c6/0x410
[ 3038.290721]  [<ffffffff810f822e>] ? d_lookup+0x2e/0x60
[ 3038.290721]  [<ffffffff810e994b>] ? __lookup_hash+0xab/0x1c0
[ 3038.290721]  [<ffffffff810ef406>] ? sys_renameat+0x286/0x2e0
[ 3038.290721]  [<ffffffffa0090c2b>] ? xfs_iunlock+0x4b/0xa0 [xfs]
[ 3038.290721]  [<ffffffffa00ac9f9>] ? xfs_setattr+0x3d9/0x7c0 [xfs]
[ 3038.290721]  [<ffffffff810fb30c>] ? notify_change+0x27c/0x3a0
[ 3038.290721]  [<ffffffff810f60ab>] ? dput+0x3b/0x190
[ 3038.290721]  [<ffffffff81352a79>] ? system_call_fastpath+0x16/0x1b
[ 3038.290721]  [<ffffffff81352a17>] ? system_call_after_swapgs+0x17/0x63
[ 3038.290721]  [<ffffffff81352a17>] ? system_call_after_swapgs+0x17/0x63
3038.290721]  [<ffffffff81352a17>] ? system_call_after_swapgs+0x17/0x63

If i can do some more debug pleas let me know, i'll prepare it.
Thanks for help.
Marcin Miros=B3aw

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
