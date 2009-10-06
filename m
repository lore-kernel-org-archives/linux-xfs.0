Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96CcL6L060420 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 07:38:22 -0500
Message-ID: <4ACB3AC5.4010603@vlnb.net>
Date: Tue, 06 Oct 2009 16:40:37 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage in XFS
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-masters@oss.sgi.com
Cc: xfs@oss.sgi.com

Hello,

After upgrading to 2.6.31 with SCST testings I started seeing the 
following lockdep messages. I have not seen them in 2.6.29. Looks like 
it's something recently introduced.

During the tests there was only one file used on XFS. It's a 5GB virtual 
device image. No SCST patches touch any I/O or memory management code.

Vlad

[ 4030.120972] =================================
[ 4030.121815] [ INFO: inconsistent lock state ]
[ 4030.121815] 2.6.31-scst-dbg #3
[ 4030.121815] ---------------------------------
[ 4030.121815] inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
[ 4030.121815] kswapd0/292 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 4030.121815]  (&(&ip->i_iolock)->mr_lock){++++-+}, at: [<f8fbef54>] 
xfs_ilock+0x98/0x9f [xfs]
[ 4030.121815] {RECLAIM_FS-ON-R} state was registered at:
[ 4030.121815]   [<781707fb>] mark_held_locks+0x6a/0x9a
[ 4030.121815]   [<781708f5>] lockdep_trace_alloc+0xca/0xda
[ 4030.121815]   [<781c779e>] __alloc_pages_nodemask+0x8c/0x5db
[ 4030.121815]   [<781ca8db>] __do_page_cache_readahead+0xf8/0x1df
[ 4030.121815]   [<781ca9f7>] ra_submit+0x35/0x53
[ 4030.121815]   [<781cabcd>] ondemand_readahead+0x99/0x209
[ 4030.121815]   [<781cae50>] page_cache_sync_readahead+0x43/0x5c
[ 4030.121815]   [<781c2285>] generic_file_aio_read+0x3ed/0x67a
[ 4030.121815]   [<f8fec082>] xfs_read+0x13b/0x2b9 [xfs]
[ 4030.121815]   [<f8fe75c4>] xfs_file_aio_read+0x74/0xa0 [xfs]
[ 4030.121815]   [<f878074d>] do_sync_readv_writev+0xe8/0x153 [scst_vdisk]
[ 4030.121815]   [<f8784da4>] vdisk_do_job+0xd3e/0x1acf [scst_vdisk]
[ 4030.121815]   [<f8ee9939>] scst_do_real_exec+0xfe/0x62c [scst]
[ 4030.121815]   [<f8eea059>] scst_send_for_exec+0x1f2/0x710 [scst]
[ 4030.121815]   [<f8eec1d5>] scst_process_active_cmd+0x35d/0x1907 [scst]
[ 4030.121815]   [<f8eed809>] scst_do_job_active+0x8a/0x15d [scst]
[ 4030.121815]   [<f8eedaa3>] scst_cmd_thread+0xe8/0x29d [scst]
[ 4030.121815]   [<7815ac79>] kthread+0x84/0x8d
[ 4030.121815]   [<78103f57>] kernel_thread_helper+0x7/0x10
[ 4030.121815]   [<ffffffff>] 0xffffffff
[ 4030.121815] irq event stamp: 534933
[ 4030.121815] hardirqs last  enabled at (534933): [<7849b83d>] 
_spin_unlock_irqrestore+0x73/0x90
[ 4030.121815] hardirqs last disabled at (534932): [<781927c8>] 
call_rcu+0x2c/0x7d
[ 4030.121815] softirqs last  enabled at (534926): [<78147b28>] 
__do_softirq+0x1cf/0x20c
[ 4030.121815] softirqs last disabled at (534921): [<78105c5c>] 
do_softirq+0xaa/0xee
[ 4030.121815]
[ 4030.121815] other info that might help us debug this:
[ 4030.121815] 2 locks held by kswapd0/292:
[ 4030.121815]  #0:  (shrinker_rwsem){++++..}, at: [<781cd42e>] 
shrink_slab+0x31/0x1b8
[ 4030.121815]  #1:  (iprune_mutex){+.+.-.}, at: [<7820a351>] 
shrink_icache_memory+0x7a/0x274
[ 4030.121815]
[ 4030.121815] stack backtrace:
[ 4030.121815] Pid: 292, comm: kswapd0 Not tainted 2.6.31-scst-dbg #3
[ 4030.121815] Call Trace:
[ 4030.121815]  [<78497768>] ? printk+0x28/0x40
[ 4030.121815]  [<7816f8b9>] print_usage_bug+0x169/0x16e
[ 4030.121815]  [<781705d4>] mark_lock+0x1f6/0x3b3
[ 4030.121815]  [<7816fcbb>] ? check_usage_forwards+0x0/0xb0
[ 4030.121815]  [<78171876>] __lock_acquire+0x37d/0x102d
[ 4030.121815]  [<781707fb>] ? mark_held_locks+0x6a/0x9a
[ 4030.121815]  [<781033a7>] ? restore_all_notrace+0x0/0x18
[ 4030.121815]  [<f8fbef54>] ? xfs_ilock+0x98/0x9f [xfs]
[ 4030.121815]  [<7849b83d>] ? _spin_unlock_irqrestore+0x73/0x90
[ 4030.121815]  [<78170af9>] ? trace_hardirqs_on_caller+0x13a/0x188
[ 4030.121815]  [<f8fbef54>] ? xfs_ilock+0x98/0x9f [xfs]
[ 4030.121815]  [<7817260e>] lock_acquire+0xe8/0x127
[ 4030.121815]  [<f8fbef54>] ? xfs_ilock+0x98/0x9f [xfs]
[ 4030.121815]  [<7815fd01>] down_write_nested+0x58/0xa5
[ 4030.121815]  [<f8fbef54>] ? xfs_ilock+0x98/0x9f [xfs]
[ 4030.121815]  [<f8fbef54>] xfs_ilock+0x98/0x9f [xfs]
[ 4030.121815]  [<f8fbf12f>] xfs_ireclaim+0xa2/0xd5 [xfs]
[ 4030.121815]  [<f8fee9bc>] xfs_reclaim_inode+0xe6/0x150 [xfs]
[ 4030.121815]  [<f8fdd4cf>] xfs_reclaim+0xb2/0xb9 [xfs]
[ 4030.121815]  [<f8fecc4e>] xfs_fs_destroy_inode+0x3e/0x76 [xfs]
[ 4030.121815]  [<7820a100>] ? __destroy_inode+0x2b/0xa5
[ 4030.121815]  [<7820a1ae>] destroy_inode+0x34/0x5a
[ 4030.121815]  [<7820a26b>] dispose_list+0x97/0x103
[ 4030.121815]  [<7820a4ef>] shrink_icache_memory+0x218/0x274
[ 4030.121815]  [<781cd543>] shrink_slab+0x146/0x1b8
[ 4030.121815]  [<781cf248>] kswapd+0x501/0x625
[ 4030.121815]  [<781cc7ed>] ? isolate_pages_global+0x0/0x1fa
[ 4030.121815]  [<7815b03d>] ? autoremove_wake_function+0x0/0x5b
[ 4030.121815]  [<781ced47>] ? kswapd+0x0/0x625
[ 4030.121815]  [<7815ac79>] kthread+0x84/0x8d
[ 4030.121815]  [<7815abf5>] ? kthread+0x0/0x8d
[ 4030.121815]  [<78103f57>] kernel_thread_helper+0x7/0x10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
