Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3E55Ucr232452 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 00:05:30 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86171BC7972
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2011 22:08:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mjYwnPDYGPuiSG81 for <xfs@oss.sgi.com>;
	Wed, 13 Apr 2011 22:08:49 -0700 (PDT)
Date: Thu, 14 Apr 2011 15:08:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: kick inode writeback when low on memory
Message-ID: <20110414050846.GJ21395@dastard>
References: <1302157196-1988-1-git-send-email-david@fromorbit.com>
	<1302157196-1988-3-git-send-email-david@fromorbit.com>
	<1302726822.2023.128.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302726822.2023.128.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 13, 2011 at 03:33:42PM -0500, Alex Elder wrote:
> On Thu, 2011-04-07 at 16:19 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When the inode cache shrinker runs, we may have lots of dirty inodes queued up
> > in the VFS dirty queues that have not been expired. The typical case for this
> > with XFS is atime updates. The result is that a highly concurrent workload that
> > copies files and then later reads them (say to verify checksums) dirties all
> > the inodes again, even when relatime is used.
> > 
> > In a constrained memory environment, this results in a large number of dirty
> > inodes using all of available memory and memory reclaim being unable to free
> > them as dirty inodes areconsidered active. This problem was uncovered by Chris
> > Mason during recent low memory stress testing.
> > 
> > The fix is to trigger VFS level writeback from the XFS inode cache shrinker if
> > there isn't already writeback in progress. This ensures that when we enter a
> > low memory situation we start cleaning inodes (via the flusher thread) on the
> > filesystem immediately, thereby making it more likely that we will be able to
> > evict those dirty inodes from the VFS in the near future.
> > 
> > The mechanism is not perfect - it only acts on the current filesystem, so if
> > all the dirty inodes are on a different filesystem it won't help. However, it
> > seems to be a valid assumption is that the filesystem with lots of dirty inodes
> > is going to have the shrinker called very soon after the memory shortage
> > begins, so this shouldn't be an issue.
> > 
> > The other flaw is that there is no guarantee that the flusher thread will make
> > progress fast enough to clean the dirty inodes so they can be reclaimed in the
> > near future. However, this mechanism does improve the resilience of the
> > filesystem under the test conditions - instead of reliably triggering the OOM
> > killer 20 minutes into the stress test, it took more than 6 hours before it
> > happened.
> > 
> > This small addition definitely improves the low memory resilience of XFS on
> > this type of workload, and best of all it has no impact on performance when
> > memory is not constrained.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks good to me.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>

Unfortunately, we simply can't take the s_umount lock in reclaim
context. So further hackery is going to be required here - I think
that writeback_inodes_sb_nr_if_idle() need to use trylocks. if the
s_umount lock is taken in write mode, then it's pretty certain that
the sb is busy....

[ 2226.939859] =================================
[ 2226.940026] [ INFO: inconsistent lock state ]
[ 2226.940026] 2.6.39-rc3-dgc+ #1162
[ 2226.940026] ---------------------------------
[ 2226.940026] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
[ 2226.940026] diff/23704 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 2226.940026]  (&type->s_umount_key#23){+++++?}, at: [<ffffffff81191bf0>] writeback_inodes_sb_nr_if_idle+0x50/0x80
[ 2226.940026] {RECLAIM_FS-ON-W} state was registered at:
[ 2226.940026]   [<ffffffff810c06a7>] mark_held_locks+0x67/0x90
[ 2226.940026]   [<ffffffff810c0796>] lockdep_trace_alloc+0xc6/0x100
[ 2226.940026]   [<ffffffff8115fec9>] kmem_cache_alloc+0x39/0x1e0
[ 2226.940026]   [<ffffffff814afce7>] kmem_zone_alloc+0x77/0xf0
[ 2226.940026]   [<ffffffff814afd7e>] kmem_zone_zalloc+0x1e/0x50
[ 2226.940026]   [<ffffffff814a5f51>] _xfs_trans_alloc+0x31/0x80
[ 2226.940026]   [<ffffffff814a1b74>] xfs_log_sbcount+0x84/0xf0
[ 2226.940026]   [<ffffffff814a26be>] xfs_unmountfs+0xde/0x1a0
[ 2226.940026]   [<ffffffff814bd466>] xfs_fs_put_super+0x46/0x80
[ 2226.940026]   [<ffffffff8116cb92>] generic_shutdown_super+0x72/0x100
[ 2226.940026]   [<ffffffff8116cc51>] kill_block_super+0x31/0x80
[ 2226.940026]   [<ffffffff8116d415>] deactivate_locked_super+0x45/0x60
[ 2226.940026]   [<ffffffff8116e10a>] deactivate_super+0x4a/0x70
[ 2226.940026]   [<ffffffff8118951c>] mntput_no_expire+0xec/0x140
[ 2226.940026]   [<ffffffff81189a08>] sys_umount+0x78/0x3c0
[ 2226.940026]   [<ffffffff81b76c82>] system_call_fastpath+0x16/0x1b
[ 2226.940026] irq event stamp: 2767751
[ 2226.940026] hardirqs last  enabled at (2767751): [<ffffffff810ee0b6>] __call_rcu+0xa6/0x190
[ 2226.940026] hardirqs last disabled at (2767750): [<ffffffff810ee05a>] __call_rcu+0x4a/0x190
[ 2226.940026] softirqs last  enabled at (2758484): [<ffffffff8108d1a3>] __do_softirq+0x143/0x220
[ 2226.940026] softirqs last disabled at (2758471): [<ffffffff81b77e9c>] call_softirq+0x1c/0x30
[ 2226.940026]
[ 2226.940026] other info that might help us debug this:
[ 2226.940026] 3 locks held by diff/23704:
[ 2226.940026]  #0:  (xfs_iolock_active){++++++}, at: [<ffffffff81487408>] xfs_ilock+0x138/0x190
[ 2226.940026]  #1:  (&mm->mmap_sem){++++++}, at: [<ffffffff81b7258b>] do_page_fault+0xeb/0x4f0
[ 2226.940026]  #2:  (shrinker_rwsem){++++..}, at: [<ffffffff8112cb6d>] shrink_slab+0x3d/0x1a0
[ 2226.940026]
[ 2226.940026] stack backtrace:
[ 2226.940026] Pid: 23704, comm: diff Not tainted 2.6.39-rc3-dgc+ #1162
[ 2226.940026] Call Trace:
[ 2226.940026]  [<ffffffff810bf5fa>] print_usage_bug+0x18a/0x190
[ 2226.940026]  [<ffffffff8104982f>] ? save_stack_trace+0x2f/0x50
[ 2226.940026]  [<ffffffff810bf770>] ? print_irq_inversion_bug+0x170/0x170
[ 2226.940026]  [<ffffffff810c055e>] mark_lock+0x35e/0x440
[ 2226.940026]  [<ffffffff810c1227>] __lock_acquire+0x447/0x14b0
[ 2226.940026]  [<ffffffff81065ed8>] ? pvclock_clocksource_read+0x58/0xd0
[ 2226.940026]  [<ffffffff814a84c8>] ? xfs_ail_push_all+0x78/0x80
[ 2226.940026]  [<ffffffff810650b9>] ? kvm_clock_read+0x19/0x20
[ 2226.940026]  [<ffffffff81042bc9>] ? sched_clock+0x9/0x10
[ 2226.940026]  [<ffffffff810aff15>] ? sched_clock_local+0x25/0x90
[ 2226.940026]  [<ffffffff810c2344>] lock_acquire+0xb4/0x140
[ 2226.940026]  [<ffffffff81191bf0>] ? writeback_inodes_sb_nr_if_idle+0x50/0x80
[ 2226.940026]  [<ffffffff81b76a16>] ? ftrace_call+0x5/0x2b
[ 2226.940026]  [<ffffffff81b6d731>] down_read+0x51/0xa0
[ 2226.940026]  [<ffffffff81191bf0>] ? writeback_inodes_sb_nr_if_idle+0x50/0x80
[ 2226.940026]  [<ffffffff81191bf0>] writeback_inodes_sb_nr_if_idle+0x50/0x80
[ 2226.940026]  [<ffffffff814bec18>] ? xfs_syncd_queue_reclaim+0x28/0xc0
[ 2226.940026]  [<ffffffff814c02e9>] xfs_reclaim_inode_shrink+0x99/0xc0
[ 2226.940026]  [<ffffffff8112cc67>] shrink_slab+0x137/0x1a0
[ 2226.940026]  [<ffffffff8112e40c>] do_try_to_free_pages+0x20c/0x440
[ 2226.940026]  [<ffffffff8112e7a2>] try_to_free_pages+0x92/0x130
[ 2226.940026]  [<ffffffff81124826>] __alloc_pages_nodemask+0x496/0x930
[ 2226.940026]  [<ffffffff810aff15>] ? sched_clock_local+0x25/0x90
[ 2226.940026]  [<ffffffff81b76a16>] ? ftrace_call+0x5/0x2b
[ 2226.940026]  [<ffffffff8115c169>] alloc_pages_vma+0x99/0x150
[ 2226.940026]  [<ffffffff811681b3>] do_huge_pmd_anonymous_page+0x143/0x380
[ 2226.940026]  [<ffffffff81b76a16>] ? ftrace_call+0x5/0x2b
[ 2226.940026]  [<ffffffff81141b26>] handle_mm_fault+0x136/0x290
[ 2226.940026]  [<ffffffff81b72601>] do_page_fault+0x161/0x4f0
[ 2226.940026]  [<ffffffff810b0038>] ? sched_clock_cpu+0xb8/0x110
[ 2226.940026]  [<ffffffff810c1116>] ? __lock_acquire+0x336/0x14b0
[ 2226.940026]  [<ffffffff811275b8>] ? __do_page_cache_readahead+0x208/0x2b0
[ 2226.940026]  [<ffffffff81065ed8>] ? pvclock_clocksource_read+0x58/0xd0
[ 2226.940026]  [<ffffffff816d527d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 2226.940026]  [<ffffffff81b6f265>] page_fault+0x25/0x30
[ 2226.940026]  [<ffffffff8111bed4>] ? file_read_actor+0x114/0x1d0
[ 2226.940026]  [<ffffffff8111bde1>] ? file_read_actor+0x21/0x1d0
[ 2226.940026]  [<ffffffff8111dfad>] generic_file_aio_read+0x35d/0x7b0
[ 2226.940026]  [<ffffffff814b769e>] xfs_file_aio_read+0x15e/0x2e0
[ 2226.940026]  [<ffffffff8116a4d0>] ? do_sync_write+0x120/0x120
[ 2226.940026]  [<ffffffff8116a5aa>] do_sync_read+0xda/0x120
[ 2226.940026]  [<ffffffff8169aeee>] ? security_file_permission+0x8e/0x90
[ 2226.940026]  [<ffffffff8116acdd>] vfs_read+0xcd/0x180
[ 2226.940026]  [<ffffffff8116ae94>] sys_read+0x54/0xa0
[ 2226.940026]  [<ffffffff81b76c82>] system_call_fastpath+0x16/0x1b

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
