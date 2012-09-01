Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q81N3afK194298 for <xfs@oss.sgi.com>; Sat, 1 Sep 2012 18:03:36 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	V1ZjfUzAbiB0W6CH (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 01 Sep 2012 16:04:30 -0700 (PDT)
Date: Sat, 1 Sep 2012 19:04:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs sb_internal#2 lockdep splat
Message-ID: <20120901230425.GA6896@infradead.org>
References: <alpine.DEB.2.00.1208311318140.19947@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1208311318140.19947@cobra.newdream.net>
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
To: Sage Weil <sage@inktank.com>, Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

I've had some time to look at this issue and it seems to be due to the
brand new filesystem freezing code in the VFS which (ab-)uses lockdep
in a creative way.

In short the XFS code to flush pending delalloc data when running into
ENOSPC conditions.  I don't understand the fsfreeze code and its usage
of lockdep enough to confirm if the warning is correct, but Dave has
patches to rip this code path out in the current from and replace it
with the VM layer code used by ext4 and btrfs.  I suspect that should
sort out this issue.


On Fri, Aug 31, 2012 at 01:18:34PM -0700, Sage Weil wrote:
> This may be old news, but:
> 
> [23405.556763] ======================================================
> [23405.584315] [ INFO: possible circular locking dependency detected ]
> [23405.611861] 3.6.0-rc2-ceph-00143-g995fc06 #1 Not tainted
> [23405.638127] -------------------------------------------------------
> [23405.638129] fill2/7976 is trying to acquire lock:
> [23405.638139]  ((&mp->m_flush_work)){+.+.+.}, at: [<ffffffff81072060>] wait_on_work+0x0/0x160
> [23405.638140] 
> [23405.638140] but task is already holding lock:
> [23405.638174]  (sb_internal#2){.+.+.+}, at: [<ffffffffa03afe5d>] xfs_trans_alloc+0x2d/0x50 [xfs]
> [23405.638175] 
> [23405.638175] which lock already depends on the new lock.
> [23405.638175] 
> [23405.638175] 
> [23405.638175] the existing dependency chain (in reverse order) is:
> [23405.638179] 
> [23405.638179] -> #1 (sb_internal#2){.+.+.+}:
> [23405.638183]        [<ffffffff810b2c82>] lock_acquire+0xa2/0x140
> [23405.638186]        [<ffffffff816318eb>] mutex_lock_nested+0x4b/0x320
> [23405.638210]        [<ffffffffa03aee89>] xfs_icsb_modify_counters+0x119/0x1b0 [xfs]
> [23405.638228]        [<ffffffffa0363346>] xfs_reserve_blocks+0x96/0x170 [xfs]
> [23405.638252]        [<ffffffffa03aec75>] xfs_unmountfs+0x95/0x190 [xfs]
> [23405.638268]        [<ffffffffa036cd95>] xfs_fs_put_super+0x25/0x70 [xfs]
> [23405.638273]        [<ffffffff8117de12>] generic_shutdown_super+0x62/0xf0
> [23405.638276]        [<ffffffff8117ded0>] kill_block_super+0x30/0x80
> [23405.638279]        [<ffffffff8117e1a5>] deactivate_locked_super+0x45/0x70
> [23405.638283]        [<ffffffff8117ee4e>] deactivate_super+0x4e/0x70
> [23405.638287]        [<ffffffff8119b1d6>] mntput_no_expire+0x106/0x160
> [23405.638289]        [<ffffffff8119c1fe>] sys_umount+0x6e/0x3b0
> [23405.638293]        [<ffffffff8163d569>] system_call_fastpath+0x16/0x1b
> [23405.638296] 
> [23405.638296] -> #0 ((&mp->m_flush_work)){+.+.+.}:
> [23405.638298]        [<ffffffff810b25e8>] __lock_acquire+0x1ac8/0x1b90
> [23405.638301]        [<ffffffff810b2c82>] lock_acquire+0xa2/0x140
> [23405.638304]        [<ffffffff810720a1>] wait_on_work+0x41/0x160
> [23405.638307]        [<ffffffff81072203>] flush_work_sync+0x43/0x90
> [23405.638323]        [<ffffffffa036ec7f>] xfs_flush_inodes+0x2f/0x40 [xfs]
> [23405.638341]        [<ffffffffa0371d2e>] xfs_create+0x3be/0x640 [xfs]
> [23405.638357]        [<ffffffffa036888f>] xfs_vn_mknod+0x8f/0x1c0 [xfs]
> [23405.638372]        [<ffffffffa03689f3>] xfs_vn_create+0x13/0x20 [xfs]
> [23405.638375]        [<ffffffff8118aeb5>] vfs_create+0xb5/0x120
> [23405.638378]        [<ffffffff8118bcc0>] do_last+0xda0/0xf00
> [23405.638380]        [<ffffffff8118bed3>] path_openat+0xb3/0x4c0
> [23405.638383]        [<ffffffff8118c6f2>] do_filp_open+0x42/0xa0
> [23405.638386]        [<ffffffff8117b040>] do_sys_open+0x100/0x1e0
> [23405.638389]        [<ffffffff8117b141>] sys_open+0x21/0x30
> [23405.638391]        [<ffffffff8163d569>] system_call_fastpath+0x16/0x1b
> [23405.638392] 
> [23405.638392] other info that might help us debug this:
> [23405.638392] 
> [23405.638393]  Possible unsafe locking scenario:
> [23405.638393] 
> [23405.638394]        CPU0                    CPU1
> [23405.638394]        ----                    ----
> [23405.638396]   lock(sb_internal#2);
> [23405.638398]                                lock((&mp->m_flush_work));
> [23405.638400]                                lock(sb_internal#2);
> [23405.638402]   lock((&mp->m_flush_work));
> [23405.638402] 
> [23405.638402]  *** DEADLOCK ***
> [23405.638402] 
> [23405.638404] 3 locks held by fill2/7976:
> [23405.638409]  #0:  (sb_writers#14){.+.+.+}, at: [<ffffffff8119b5b4>] mnt_want_write+0x24/0x50
> [23405.638414]  #1:  (&type->i_mutex_dir_key#9){+.+.+.}, at: [<ffffffff8118b22b>] do_last+0x30b/0xf00
> [23405.638440]  #2:  (sb_internal#2){.+.+.+}, at: [<ffffffffa03afe5d>] xfs_trans_alloc+0x2d/0x50 [xfs]
> [23405.638441] 
> [23405.638441] stack backtrace:
> [23405.638443] Pid: 7976, comm: fill2 Not tainted 3.6.0-rc2-ceph-00143-g995fc06 #1
> [23405.638444] Call Trace:
> [23405.638448]  [<ffffffff8162a77c>] print_circular_bug+0x1fb/0x20c
> [23405.638451]  [<ffffffff810b25e8>] __lock_acquire+0x1ac8/0x1b90
> [23405.638455]  [<ffffffff81050500>] ? __mmdrop+0x60/0x90
> [23405.638459]  [<ffffffff8108494a>] ? finish_task_switch+0x10a/0x110
> [23405.638463]  [<ffffffff81072060>] ? busy_worker_rebind_fn+0x100/0x100
> [23405.638465]  [<ffffffff810b2c82>] lock_acquire+0xa2/0x140
> [23405.638468]  [<ffffffff81072060>] ? busy_worker_rebind_fn+0x100/0x100
> [23405.638472]  [<ffffffff81634c30>] ? _raw_spin_unlock_irq+0x30/0x40
> [23405.638475]  [<ffffffff810720a1>] wait_on_work+0x41/0x160
> [23405.638477]  [<ffffffff81072060>] ? busy_worker_rebind_fn+0x100/0x100
> [23405.638480]  [<ffffffff810710a8>] ? start_flush_work+0x108/0x180
> [23405.638483]  [<ffffffff81634e5f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
> [23405.638486]  [<ffffffff81072203>] flush_work_sync+0x43/0x90
> [23405.638488]  [<ffffffff810b379d>] ? trace_hardirqs_on+0xd/0x10
> [23405.638491]  [<ffffffff810706c4>] ? __queue_work+0xe4/0x3b0
> [23405.638509]  [<ffffffffa036ec7f>] xfs_flush_inodes+0x2f/0x40 [xfs]
> [23405.638527]  [<ffffffffa0371d2e>] xfs_create+0x3be/0x640 [xfs]
> [23405.638529]  [<ffffffff81192254>] ? d_rehash+0x24/0x40
> [23405.638545]  [<ffffffffa036888f>] xfs_vn_mknod+0x8f/0x1c0 [xfs]
> [23405.638561]  [<ffffffffa03689f3>] xfs_vn_create+0x13/0x20 [xfs]
> [23405.638564]  [<ffffffff8118aeb5>] vfs_create+0xb5/0x120
> [23405.638567]  [<ffffffff8118bcc0>] do_last+0xda0/0xf00
> [23405.638570]  [<ffffffff8118bed3>] path_openat+0xb3/0x4c0
> [23405.638573]  [<ffffffff8118c6f2>] do_filp_open+0x42/0xa0
> [23405.638577]  [<ffffffff8132babd>] ? do_raw_spin_unlock+0x5d/0xb0
> [23405.638579]  [<ffffffff81634c6b>] ? _raw_spin_unlock+0x2b/0x40
> [23405.638582]  [<ffffffff81199a22>] ? alloc_fd+0xd2/0x120
> [23405.638585]  [<ffffffff8117b040>] do_sys_open+0x100/0x1e0
> [23405.638588]  [<ffffffff8117b141>] sys_open+0x21/0x30
> [23405.638590]  [<ffffffff8163d569>] system_call_fastpath+0x16/0x1b
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
