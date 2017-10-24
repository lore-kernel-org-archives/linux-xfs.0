Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36645 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdJXAXj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 20:23:39 -0400
Date: Mon, 23 Oct 2017 17:23:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] xfs: drain the buffer LRU on mount
Message-ID: <20171024002334.GK5483@magnolia>
References: <20171023144646.50107-1-bfoster@redhat.com>
 <20171023144646.50107-4-bfoster@redhat.com>
 <20171023163940.GE5483@magnolia>
 <20171023165416.GD45316@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171023165416.GD45316@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 23, 2017 at 12:54:17PM -0400, Brian Foster wrote:
> On Mon, Oct 23, 2017 at 09:39:40AM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 23, 2017 at 10:46:45AM -0400, Brian Foster wrote:
> > > Log recovery of v4 filesystems does not use buffer verifiers because
> > > log recovery historically can result in transient buffer corruption
> > > when target buffers might be ahead of the log after a crash. v5
> > > filesystems work around this problem with metadata LSN ordering.
> > > 
> > > While the log recovery behavior is necessary on v4 supers, it
> > > currently can result in leaving buffers around in the LRU without
> > > verifiers attached for a significant amount of time. This can lead
> > > to use of unverified buffers while the filesystem is in active use,
> > > long after recovery has completed.
> > > 
> > > To address this problem and provide a more consistent clean,
> > > post-mount buffer cache state, update the log mount sequence to
> > > unconditionally drain all buffers from the LRU as a final step.
> > > 
> > > Reported-by: Darrick Wong <darrick.wong@oracle.com>
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log.c | 13 +++++++++++++
> > >  1 file changed, 13 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index dc95a49..e282fd8 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -744,6 +744,7 @@ xfs_log_mount_finish(
> > >  {
> > >  	int	error = 0;
> > >  	bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
> > > +	bool	recovered = mp->m_log->l_flags & XLOG_RECOVERY_NEEDED;
> > >  
> > >  	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> > >  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> > > @@ -780,6 +781,18 @@ xfs_log_mount_finish(
> > >  	mp->m_super->s_flags &= ~MS_ACTIVE;
> > >  	evict_inodes(mp->m_super);
> > >  
> > > +	/*
> > > +	 * Drain the buffer LRU after log recovery. This is required for v4
> > > +	 * filesystems to avoid leaving around buffers with NULL verifier ops,
> > > +	 * but we do it unconditionally to make sure we're always in a clean
> > > +	 * cache state after mount.
> > > +	 */
> > > +	if (recovered) {
> > 
> > if (recovered && !error) { ?
> > 
> > I observed that running xfs/376 on an rmap filesystem fails when it
> > tries to fuzz the high bit of u3.bmx[0].startoff.  That triggers an
> > incorrect freeing of what is now a post-eof extent.  The corresponding
> > rmap free operation fails after the RUI has been logged and shuts down
> > the filesystem, so a subsequent log recovery attempt also fails when it
> > tries to remove an rmap that doesn't exist.  If we then try to force the
> > log we end up deadlocked somehwere... though if we /don't/ then memory
> > gets corrupted and the kernel blows up anyway. :(
> > 
> 
> Interesting... do you have a stack trace? I'm curious why forcing the
> log would hang here and not in the subsequent log force in
> xfs_log_unmount() -> xfs_log_quiesce().

The fs first shuts down at:

[ 5315.029897] XFS: Assertion failed: fs_is_ok, file: /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/libxfs/xfs_rmap.c, line: 506
[ 5315.031234] ------------[ cut here ]------------
[ 5315.031796] WARNING: CPU: 2 PID: 28021 at /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_message.c:116 assfail+0x25/0x30 [xfs]
[ 5315.033089] Modules linked in: xfs dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c dax_pmem nd_pmem device_dax sch_fq_codel af_packet [last unloaded: xfs]
[ 5315.035131] CPU: 2 PID: 28021 Comm: xfs_scrub Not tainted 4.14.0-rc6-xfsx #1
[ 5315.035914] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5315.036693] task: ffff880079b18000 task.stack: ffffc9000429c000
[ 5315.037330] RIP: 0010:assfail+0x25/0x30 [xfs]
[ 5315.037802] RSP: 0018:ffffc9000429fb60 EFLAGS: 00010246
[ 5315.038310] RAX: 00000000ffffffea RBX: 0000000000000000 RCX: 0000000000000001
[ 5315.038960] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa038197c
[ 5315.039609] RBP: ffffc9000429fc68 R08: 0000000000000000 R09: 0000000000000000
[ 5315.040264] R10: 0000000000000033 R11: f000000000000000 R12: 0000000000000032
[ 5315.040932] R13: ffff88006a86fc30 R14: 0000000000000000 R15: 0000000000000000
[ 5315.041649] FS:  00007f36ab489700(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
[ 5315.042444] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5315.042887] CR2: 00007f9c5c00b168 CR3: 00000000778e2006 CR4: 00000000001606e0
[ 5315.043533] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5315.044112] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 5315.044658] Call Trace:
[ 5315.044898]  xfs_rmap_unmap+0x678/0xef0 [xfs]
[ 5315.045405]  ? kmem_cache_alloc+0x25a/0x2d0
[ 5315.045937]  ? kmem_zone_alloc+0x83/0x100 [xfs]
[ 5315.046473]  xfs_rmap_finish_one+0x2d9/0x510 [xfs]
[ 5315.047012]  xfs_rmap_update_finish_item+0x39/0x60 [xfs]
[ 5315.047600]  xfs_defer_finish+0x175/0x810 [xfs]
[ 5315.048057]  ? xfs_rmap_update_finish_item+0x60/0x60 [xfs]
[ 5315.048659]  xfs_itruncate_extents+0x1ba/0x6b0 [xfs]
[ 5315.049211]  xfs_free_eofblocks+0x1aa/0x1f0 [xfs]
[ 5315.049799]  xfs_release+0x132/0x150 [xfs]
[ 5315.050298]  __fput+0xe1/0x1f0
[ 5315.050641]  task_work_run+0x79/0xb0
[ 5315.051030]  exit_to_usermode_loop+0x93/0xa0
[ 5315.051488]  syscall_return_slowpath+0xd7/0x100
[ 5315.051976]  entry_SYSCALL_64_fastpath+0xbc/0xbe
[ 5315.052460] RIP: 0033:0x7f36abda357d
[ 5315.052857] RSP: 002b:00007f36ab486710 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
[ 5315.053674] RAX: 0000000000000000 RBX: 00007ffe7a538e60 RCX: 00007f36abda357d
[ 5315.054407] RDX: 00007f36ab486730 RSI: 0000000000000000 RDI: 0000000000000006
[ 5315.055146] RBP: 00000000ffffffff R08: 0000000000000000 R09: 0000000000000003
[ 5315.055879] R10: 00007f36ab73f5f0 R11: 0000000000000293 R12: 0000000000000000
[ 5315.056614] R13: 0000000000fed270 R14: 0000000000000006 R15: 0000000000000106
[ 5315.057410] Code: ff ff 0f ff c3 90 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 40 0d 39 a0 48 89 fa 31 ff e8 74 fa ff ff 80 3d 39 1d 10 00 00 75 03 <0f> ff c3 0f 0b 66 0f 1f 44 00 00 0f 1f 44 00 00 48 63 f6 49 89 
[ 5315.059437] ---[ end trace db7a77e851c787d3 ]---
[ 5315.059961] XFS (pmem4): Internal error XFS_WANT_CORRUPTED_GOTO at line 506 of file /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/libxfs/xfs_rmap.c.  Caller xfs_rmap_finish_one+0x2d9/0x510 [xfs]
[ 5315.061794] CPU: 2 PID: 28021 Comm: xfs_scrub Tainted: G        W       4.14.0-rc6-xfsx #1
[ 5315.062667] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5315.063621] Call Trace:
[ 5315.063899]  dump_stack+0x7c/0xbe
[ 5315.064295]  xfs_rmap_unmap+0x5f2/0xef0 [xfs]
[ 5315.064771]  ? kmem_cache_alloc+0x25a/0x2d0
[ 5315.065255]  ? kmem_zone_alloc+0x83/0x100 [xfs]
[ 5315.065771]  xfs_rmap_finish_one+0x2d9/0x510 [xfs]
[ 5315.066312]  xfs_rmap_update_finish_item+0x39/0x60 [xfs]
[ 5315.066894]  xfs_defer_finish+0x175/0x810 [xfs]
[ 5315.067401]  ? xfs_rmap_update_finish_item+0x60/0x60 [xfs]
[ 5315.068007]  xfs_itruncate_extents+0x1ba/0x6b0 [xfs]
[ 5315.068562]  xfs_free_eofblocks+0x1aa/0x1f0 [xfs]
[ 5315.069095]  xfs_release+0x132/0x150 [xfs]
[ 5315.069534]  __fput+0xe1/0x1f0
[ 5315.069868]  task_work_run+0x79/0xb0
[ 5315.070267]  exit_to_usermode_loop+0x93/0xa0
[ 5315.070721]  syscall_return_slowpath+0xd7/0x100
[ 5315.071207]  entry_SYSCALL_64_fastpath+0xbc/0xbe
[ 5315.071701] RIP: 0033:0x7f36abda357d
[ 5315.072100] RSP: 002b:00007f36ab486710 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
[ 5315.072882] RAX: 0000000000000000 RBX: 00007ffe7a538e60 RCX: 00007f36abda357d
[ 5315.073659] RDX: 00007f36ab486730 RSI: 0000000000000000 RDI: 0000000000000006
[ 5315.074592] RBP: 00000000ffffffff R08: 0000000000000000 R09: 0000000000000003
[ 5315.075365] R10: 00007f36ab73f5f0 R11: 0000000000000293 R12: 0000000000000000
[ 5315.076028] R13: 0000000000fed270 R14: 0000000000000006 R15: 0000000000000106
[ 5315.076777] XFS (pmem4): xfs_do_force_shutdown(0x8) called from line 236 of file /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffa02c0d99
[ 5315.078952] XFS (pmem4): Corruption of in-memory data detected.  Shutting down filesystem
[ 5315.079673] XFS (pmem4): Please umount the filesystem and rectify the problem(s)
[ 5315.111140] XFS (pmem4): Unmounting Filesystem
[ 5315.111875] XFS (pmem4): xfs_qm_dquot_logitem_push: push error -5 on dqp ffff88002927d700
[ 5315.112549] XFS (pmem4): xfs_qm_dquot_logitem_push: push error -5 on dqp ffff88002a6185c0
[ 5315.116988] XFS (pmem4): xfs_qm_dquot_logitem_push: push error -5 on dqp ffff8800297bbc60
[ 5315.481036] XFS (pmem4): Starting recovery (logdev: internal)

Unsurprising, since we tried to remove a bmap that doesn't have a
corresponding rmap.  The log recovery fails in more or less the same
place:

[ 5315.474823] XFS (pmem4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
[ 5315.476510] XFS (pmem4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
[ 5315.477534] XFS (pmem4): Mounting V5 Filesystem
[ 5315.486778] XFS: Assertion failed: fs_is_ok, file: /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/libxfs/xfs_rmap.c, line: 506
[ 5315.493175] ------------[ cut here ]------------
[ 5315.495752] WARNING: CPU: 1 PID: 28033 at /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_message.c:116 assfail+0x25/0x30 [xfs]
[ 5315.498462] Modules linked in: xfs dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c dax_pmem nd_pmem device_dax sch_fq_codel af_packet [last unloaded: xfs]
[ 5315.503185] CPU: 1 PID: 28033 Comm: mount Tainted: G        W       4.14.0-rc6-xfsx #1
[ 5315.507455] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5315.512387] task: ffff880078420000 task.stack: ffffc9000429c000
[ 5315.523040] RIP: 0010:assfail+0x25/0x30 [xfs]
[ 5315.523722] RSP: 0018:ffffc9000429fa68 EFLAGS: 00010246
[ 5315.524149] RAX: 00000000ffffffea RBX: 0000000000000000 RCX: 0000000000000001
[ 5315.524855] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa038197c
[ 5315.525600] RBP: ffffc9000429fb70 R08: 0000000000000000 R09: 0000000000000000
[ 5315.526425] R10: 0000000000000033 R11: f000000000000000 R12: 0000000000000032
[ 5315.527225] R13: ffff88002dea55a0 R14: 0000000000000000 R15: 0000000000000000
[ 5315.527903] FS:  00007f0227391840(0000) GS:ffff88003ec00000(0000) knlGS:0000000000000000
[ 5315.528834] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5315.529453] CR2: 00007fff9dde8ff8 CR3: 0000000029752004 CR4: 00000000001606e0
[ 5315.530169] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5315.530877] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 5315.531583] Call Trace:
[ 5315.531887]  xfs_rmap_unmap+0x678/0xef0 [xfs]
[ 5315.532344]  ? kmem_cache_alloc+0x25a/0x2d0
[ 5315.532818]  ? kmem_zone_alloc+0x83/0x100 [xfs]
[ 5315.533368]  xfs_rmap_finish_one+0x2d9/0x510 [xfs]
[ 5315.533905]  xfs_trans_log_finish_rmap_update+0x36/0x50 [xfs]
[ 5315.534666]  xfs_rui_recover+0x22d/0x300 [xfs]
[ 5315.535307]  xlog_recover_process_intents+0x252/0x2d0 [xfs]
[ 5315.536124]  ? xlog_recover_finish+0x18/0xa0 [xfs]
[ 5315.536892]  xlog_recover_finish+0x18/0xa0 [xfs]
[ 5315.537660]  xfs_log_mount_finish+0x75/0x110 [xfs]
[ 5315.538343]  xfs_mountfs+0x68f/0xaf0 [xfs]
[ 5315.539012]  xfs_fs_fill_super+0x4d7/0x630 [xfs]
[ 5315.539696]  ? xfs_finish_flags+0x150/0x150 [xfs]
[ 5315.540330]  mount_bdev+0x178/0x1b0
[ 5315.540756]  mount_fs+0xf/0x80
[ 5315.541159]  vfs_kern_mount+0x62/0x160
[ 5315.541681]  do_mount+0x1b1/0xd50
[ 5315.542110]  ? rcu_read_lock_sched_held+0x3f/0x70
[ 5315.542683]  SyS_mount+0x85/0xd0
[ 5315.543072]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[ 5315.543560] RIP: 0033:0x7f0226c72b5a
[ 5315.543956] RSP: 002b:00007fff9ddea318 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[ 5315.544719] RAX: ffffffffffffffda RBX: 00007f0226f6b63a RCX: 00007f0226c72b5a
[ 5315.545456] RDX: 0000000001a3b2d0 RSI: 0000000001a3b310 RDI: 0000000001a3b2f0
[ 5315.546301] RBP: 0000000001a3b120 R08: 0000000001a3b270 R09: 0000000000000012
[ 5315.547043] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 00007f022717b83c
[ 5315.547944] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000005
[ 5315.548851] Code: ff ff 0f ff c3 90 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 40 0d 39 a0 48 89 fa 31 ff e8 74 fa ff ff 80 3d 39 1d 10 00 00 75 03 <0f> ff c3 0f 0b 66 0f 1f 44 00 00 0f 1f 44 00 00 48 63 f6 49 89 
[ 5315.551349] ---[ end trace db7a77e851c787d4 ]---
[ 5315.573832] XFS (pmem4): Internal error xfs_trans_cancel at line 1005 of file /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_trans.c.  Caller xfs_rui_recover+0x289/0x300 [xfs]
[ 5315.575692] CPU: 1 PID: 28033 Comm: mount Tainted: G        W       4.14.0-rc6-xfsx #1
[ 5315.576533] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
[ 5315.577607] Call Trace:
[ 5315.577905]  dump_stack+0x7c/0xbe
[ 5315.578306]  xfs_trans_cancel+0x119/0x140 [xfs]
[ 5315.578912]  xfs_rui_recover+0x289/0x300 [xfs]
[ 5315.579496]  xlog_recover_process_intents+0x252/0x2d0 [xfs]
[ 5315.580165]  ? xlog_recover_finish+0x18/0xa0 [xfs]
[ 5315.580737]  xlog_recover_finish+0x18/0xa0 [xfs]
[ 5315.581340]  xfs_log_mount_finish+0x75/0x110 [xfs]
[ 5315.581966]  xfs_mountfs+0x68f/0xaf0 [xfs]
[ 5315.582457]  xfs_fs_fill_super+0x4d7/0x630 [xfs]
[ 5315.582965]  ? xfs_finish_flags+0x150/0x150 [xfs]
[ 5315.583434]  mount_bdev+0x178/0x1b0
[ 5315.583795]  mount_fs+0xf/0x80
[ 5315.584121]  vfs_kern_mount+0x62/0x160
[ 5315.584517]  do_mount+0x1b1/0xd50
[ 5315.584876]  ? rcu_read_lock_sched_held+0x3f/0x70
[ 5315.585381]  SyS_mount+0x85/0xd0
[ 5315.585728]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[ 5315.586220] RIP: 0033:0x7f0226c72b5a
[ 5315.586608] RSP: 002b:00007fff9ddea318 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[ 5315.587389] RAX: ffffffffffffffda RBX: 00007f0226f6b63a RCX: 00007f0226c72b5a
[ 5315.588129] RDX: 0000000001a3b2d0 RSI: 0000000001a3b310 RDI: 0000000001a3b2f0
[ 5315.588860] RBP: 0000000001a3b120 R08: 0000000001a3b270 R09: 0000000000000012
[ 5315.589599] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 00007f022717b83c
[ 5315.590343] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000005
[ 5315.591139] XFS (pmem4): xfs_do_force_shutdown(0x8) called from line 1006 of file /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_trans.c.  Return address = 0xffffffffa032f1f2
[ 5315.593020] XFS (pmem4): Corruption of in-memory data detected.  Shutting down filesystem
[ 5315.593897] XFS (pmem4): Please umount the filesystem and rectify the problem(s)
[ 5315.594710] XFS (pmem4): Failed to recover intents

...after which I see this once before the system totally hangs:

[ 5405.641103] INFO: task mount:28033 blocked for more than 60 seconds.
[ 5405.643982]       Tainted: G        W       4.14.0-rc6-xfsx #1
[ 5405.646067] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5405.650068] mount           D12768 28033  27973 0x80000000
[ 5405.655505] Call Trace:
[ 5405.657210]  ? __schedule+0x40d/0xb20
[ 5405.658865]  schedule+0x40/0x90
[ 5405.661340]  xfs_ail_push_all_sync+0xa4/0xe0 [xfs]
[ 5405.664348]  ? remove_wait_queue+0x60/0x60
[ 5405.668815]  xfs_log_mount_finish+0xc7/0x110 [xfs]
[ 5405.671736]  xfs_mountfs+0x68f/0xaf0 [xfs]
[ 5405.674645]  xfs_fs_fill_super+0x4d7/0x630 [xfs]
[ 5405.677673]  ? xfs_finish_flags+0x150/0x150 [xfs]
[ 5405.679966]  mount_bdev+0x178/0x1b0
[ 5405.681300]  mount_fs+0xf/0x80
[ 5405.682426]  vfs_kern_mount+0x62/0x160
[ 5405.683712]  do_mount+0x1b1/0xd50
[ 5405.687634]  ? rcu_read_lock_sched_held+0x3f/0x70
[ 5405.688453]  SyS_mount+0x85/0xd0
[ 5405.689033]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[ 5405.689955] RIP: 0033:0x7f0226c72b5a
[ 5405.690533] RSP: 002b:00007fff9ddea318 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[ 5405.692074] RAX: ffffffffffffffda RBX: 00007f0226f6b63a RCX: 00007f0226c72b5a
[ 5405.695604] RDX: 0000000001a3b2d0 RSI: 0000000001a3b310 RDI: 0000000001a3b2f0
[ 5405.696566] RBP: 0000000001a3b120 R08: 0000000001a3b270 R09: 0000000000000012
[ 5405.699583] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 00007f022717b83c
[ 5405.700465] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000005
[ 5405.702569] 
[ 5405.702569] Showing all locks held in the system:
[ 5405.703485] 1 lock held by khungtaskd/37:
[ 5405.704095]  #0:  (tasklist_lock){.+.+}, at: [<ffffffff810dfbf7>] debug_show_all_locks+0x37/0x190
[ 5405.705342] 2 locks held by agetty/810:
[ 5405.705845]  #0:  (&tty->ldisc_sem){++++}, at: [<ffffffff813fecf4>] tty_ldisc_ref_wait+0x24/0x50
[ 5405.706934]  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<ffffffff813fd034>] n_tty_read+0xc4/0x880
[ 5405.708030] 1 lock held by in:imklog/864:
[ 5405.708534]  #0:  (&f->f_pos_lock){+.+.}, at: [<ffffffff8125d8d8>] __fdget_pos+0x48/0x60
[ 5405.709572] 1 lock held by mount/28033:
[ 5405.710112]  #0:  (&type->s_umount_key#45/1){+.+.}, at: [<ffffffff8123c993>] sget_userns+0x303/0x4f0
[ 5405.711210] 
[ 5405.711408] =============================================
[ 5405.711408] 

--D

> 
> Brian
> 
> > --D
> > 
> > > +		xfs_log_force(mp, XFS_LOG_SYNC);
> > > +		xfs_ail_push_all_sync(mp->m_ail);
> > > +	}
> > > +	xfs_wait_buftarg(mp->m_ddev_targp);
> > > +
> > >  	if (readonly)
> > >  		mp->m_flags |= XFS_MOUNT_RDONLY;
> > >  
> > > -- 
> > > 2.9.5
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
