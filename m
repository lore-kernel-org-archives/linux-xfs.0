Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751442AbdJXTr4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Oct 2017 15:47:56 -0400
Date: Tue, 24 Oct 2017 15:47:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: drain the buffer LRU on mount
Message-ID: <20171024194753.GE56184@bfoster.bfoster>
References: <20171023144646.50107-1-bfoster@redhat.com>
 <20171023144646.50107-4-bfoster@redhat.com>
 <20171023163940.GE5483@magnolia>
 <20171023165416.GD45316@bfoster.bfoster>
 <20171024002334.GK5483@magnolia>
 <20171024140606.GD56184@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171024140606.GD56184@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2017 at 10:06:06AM -0400, Brian Foster wrote:
> On Mon, Oct 23, 2017 at 05:23:34PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 23, 2017 at 12:54:17PM -0400, Brian Foster wrote:
> > > On Mon, Oct 23, 2017 at 09:39:40AM -0700, Darrick J. Wong wrote:
> > > > On Mon, Oct 23, 2017 at 10:46:45AM -0400, Brian Foster wrote:
> > > > > Log recovery of v4 filesystems does not use buffer verifiers because
> > > > > log recovery historically can result in transient buffer corruption
> > > > > when target buffers might be ahead of the log after a crash. v5
> > > > > filesystems work around this problem with metadata LSN ordering.
> > > > > 
> > > > > While the log recovery behavior is necessary on v4 supers, it
> > > > > currently can result in leaving buffers around in the LRU without
> > > > > verifiers attached for a significant amount of time. This can lead
> > > > > to use of unverified buffers while the filesystem is in active use,
> > > > > long after recovery has completed.
> > > > > 
> > > > > To address this problem and provide a more consistent clean,
> > > > > post-mount buffer cache state, update the log mount sequence to
> > > > > unconditionally drain all buffers from the LRU as a final step.
> > > > > 
> > > > > Reported-by: Darrick Wong <darrick.wong@oracle.com>
> > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > ---
> > > > >  fs/xfs/xfs_log.c | 13 +++++++++++++
> > > > >  1 file changed, 13 insertions(+)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > > > index dc95a49..e282fd8 100644
> > > > > --- a/fs/xfs/xfs_log.c
> > > > > +++ b/fs/xfs/xfs_log.c
> > > > > @@ -744,6 +744,7 @@ xfs_log_mount_finish(
> > > > >  {
> > > > >  	int	error = 0;
> > > > >  	bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
> > > > > +	bool	recovered = mp->m_log->l_flags & XLOG_RECOVERY_NEEDED;
> > > > >  
> > > > >  	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> > > > >  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> > > > > @@ -780,6 +781,18 @@ xfs_log_mount_finish(
> > > > >  	mp->m_super->s_flags &= ~MS_ACTIVE;
> > > > >  	evict_inodes(mp->m_super);
> > > > >  
> > > > > +	/*
> > > > > +	 * Drain the buffer LRU after log recovery. This is required for v4
> > > > > +	 * filesystems to avoid leaving around buffers with NULL verifier ops,
> > > > > +	 * but we do it unconditionally to make sure we're always in a clean
> > > > > +	 * cache state after mount.
> > > > > +	 */
> > > > > +	if (recovered) {
> > > > 
> > > > if (recovered && !error) { ?
> > > > 
> > > > I observed that running xfs/376 on an rmap filesystem fails when it
> > > > tries to fuzz the high bit of u3.bmx[0].startoff.  That triggers an
> > > > incorrect freeing of what is now a post-eof extent.  The corresponding
> > > > rmap free operation fails after the RUI has been logged and shuts down
> > > > the filesystem, so a subsequent log recovery attempt also fails when it
> > > > tries to remove an rmap that doesn't exist.  If we then try to force the
> > > > log we end up deadlocked somehwere... though if we /don't/ then memory
> > > > gets corrupted and the kernel blows up anyway. :(
> > > > 
> > > 
> > > Interesting... do you have a stack trace? I'm curious why forcing the
> > > log would hang here and not in the subsequent log force in
> > > xfs_log_unmount() -> xfs_log_quiesce().
> > 
> ...
> > ...after which I see this once before the system totally hangs:
> > 
> > [ 5405.641103] INFO: task mount:28033 blocked for more than 60 seconds.
> > [ 5405.643982]       Tainted: G        W       4.14.0-rc6-xfsx #1
> > [ 5405.646067] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [ 5405.650068] mount           D12768 28033  27973 0x80000000
> > [ 5405.655505] Call Trace:
> > [ 5405.657210]  ? __schedule+0x40d/0xb20
> > [ 5405.658865]  schedule+0x40/0x90
> > [ 5405.661340]  xfs_ail_push_all_sync+0xa4/0xe0 [xfs]
> > [ 5405.664348]  ? remove_wait_queue+0x60/0x60
> > [ 5405.668815]  xfs_log_mount_finish+0xc7/0x110 [xfs]
> > [ 5405.671736]  xfs_mountfs+0x68f/0xaf0 [xfs]
> > [ 5405.674645]  xfs_fs_fill_super+0x4d7/0x630 [xfs]
> > [ 5405.677673]  ? xfs_finish_flags+0x150/0x150 [xfs]
> > [ 5405.679966]  mount_bdev+0x178/0x1b0
> > [ 5405.681300]  mount_fs+0xf/0x80
> > [ 5405.682426]  vfs_kern_mount+0x62/0x160
> > [ 5405.683712]  do_mount+0x1b1/0xd50
> > [ 5405.687634]  ? rcu_read_lock_sched_held+0x3f/0x70
> > [ 5405.688453]  SyS_mount+0x85/0xd0
> > [ 5405.689033]  entry_SYSCALL_64_fastpath+0x1f/0xbe
> > [ 5405.689955] RIP: 0033:0x7f0226c72b5a
> > [ 5405.690533] RSP: 002b:00007fff9ddea318 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> > [ 5405.692074] RAX: ffffffffffffffda RBX: 00007f0226f6b63a RCX: 00007f0226c72b5a
> > [ 5405.695604] RDX: 0000000001a3b2d0 RSI: 0000000001a3b310 RDI: 0000000001a3b2f0
> > [ 5405.696566] RBP: 0000000001a3b120 R08: 0000000001a3b270 R09: 0000000000000012
> > [ 5405.699583] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 00007f022717b83c
> > [ 5405.700465] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000005
> > [ 5405.702569] 
> > [ 5405.702569] Showing all locks held in the system:
> > [ 5405.703485] 1 lock held by khungtaskd/37:
> > [ 5405.704095]  #0:  (tasklist_lock){.+.+}, at: [<ffffffff810dfbf7>] debug_show_all_locks+0x37/0x190
> > [ 5405.705342] 2 locks held by agetty/810:
> > [ 5405.705845]  #0:  (&tty->ldisc_sem){++++}, at: [<ffffffff813fecf4>] tty_ldisc_ref_wait+0x24/0x50
> > [ 5405.706934]  #1:  (&ldata->atomic_read_lock){+.+.}, at: [<ffffffff813fd034>] n_tty_read+0xc4/0x880
> > [ 5405.708030] 1 lock held by in:imklog/864:
> > [ 5405.708534]  #0:  (&f->f_pos_lock){+.+.}, at: [<ffffffff8125d8d8>] __fdget_pos+0x48/0x60
> > [ 5405.709572] 1 lock held by mount/28033:
> > [ 5405.710112]  #0:  (&type->s_umount_key#45/1){+.+.}, at: [<ffffffff8123c993>] sget_userns+0x303/0x4f0
> > [ 5405.711210] 
> > [ 5405.711408] =============================================
> > [ 5405.711408] 
> > 
> 
> Thanks. Hmm, when I run xfs/376 on the djwong-devel xfs I see a bunch of
> mm/usercopy.c BUG()s and what looks like a mount hang during quotacheck,
> but it's blocked down in the block layer in io_schedule() attempting a
> readahead. I'm not terribly surprised by the lockup after all the BUG()
> invocations, but what I'm seeing doesn't appear to be similar to what
> you reproduce or related to the AIL in any way.
> 
> I assume this mount behavior repeats after the test completes. If so,
> could you grab a metadump of the fs?
> 

Ok, I can reproduce the problem now that I have the metadump. The AIL
push hangs because there's a pinned EFI sitting on the AIL. The reason
the subsequent push succeeds is because we cancel the recovery (which
cancels the intents) before we get to that point. Given that, I agree
that it makes sense to check for an error here. Thanks!

Brian

> Brian
> 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > > --D
> > > > 
> > > > > +		xfs_log_force(mp, XFS_LOG_SYNC);
> > > > > +		xfs_ail_push_all_sync(mp->m_ail);
> > > > > +	}
> > > > > +	xfs_wait_buftarg(mp->m_ddev_targp);
> > > > > +
> > > > >  	if (readonly)
> > > > >  		mp->m_flags |= XFS_MOUNT_RDONLY;
> > > > >  
> > > > > -- 
> > > > > 2.9.5
> > > > > 
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
