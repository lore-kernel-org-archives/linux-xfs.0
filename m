Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49124 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfDWUou (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 16:44:50 -0400
Date: Tue, 23 Apr 2019 13:44:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: RFC: what to do when trans_roll fails and we bheld buffers?
 (crash in xfs/141)
Message-ID: <20190423204433.GA178290@magnolia>
References: <20190423164947.GK4676@magnolia>
 <20190423180813.GC10224@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423180813.GC10224@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Allison Collins <allison.henderson@oracle.com>

On Tue, Apr 23, 2019 at 02:08:16PM -0400, Brian Foster wrote:
> On Tue, Apr 23, 2019 at 09:49:47AM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > I saw a crash in xfs/141 last night while testing xfs for-next on a V4
> > filesystem.  I think the problem here is that:
> > 
> >  1. xfs_attr_set calls xfs_attr_set_args.
> > 
> >  2. xfs_attr_set_args calls xfs_attr_shortform_to_leaf and sets @leaf_bp.
> > 
> >  3. _set_args calls xfs_defer_finish.
> > 
> >  4. xfs_defer_finish calls xfs_defer_trans_roll calls xfs_trans_roll.
> > 
> >  5. xfs_trans_roll sets @args.trans to the new transaction created by
> >     xfs_trans_dup.
> > 
> >  6. xfs_trans_roll calls __xfs_trans_commit on the old transaction and
> >     fails because we injected a log error.
> > 
> >  7. _trans_roll passes the error code up to _defer_finish.
> > 
> >  8. _defer_finish passes the error code up to _attr_set without joining
> >     anything (in particular leaf_bp which we bhold'd so that we would
> >     retain the buffer lock) to the new transaction.  Note that
> >     @args.trans is still set to the new transaction; nobody's cancelled it.
> > 
> >  8. xfs_attr_set tries to bail out through out_release_leaf.  The
> >     leaf_bp is non-null and args.trans is non-null, so we call
> >     xfs_trans_brelse to release leaf_bp from args.trans
> > 
> >  9. leaf_bp isn't joined to any transaction at all, but we passed in a
> >     non-null args.trans so _trans_brelse hits the "bp->b_transp == tp"
> >     assert and then crashes trying to assert on the buffer log item
> >     which is null because leaf_bp isn't joined to any transaction.
> > 
> > I think the underlying problem here is that we haven't precisely defined
> > what's supposed to happen when the _trans_roll in _defer_trans_roll
> > errors out.  Looking at the three callers of trans_bhold (attr setting,
> > allocating disk space for a new dquot, and online repair) the handling
> > of this situation is not consistent.
> > 
> > (Embarassingly, the first of those three was RVB'd by me and the latter
> > two were written by me :P)
> > 
> > Should we attach the bholded buffers to the new transaction even if the
> > old transaction failed to commit so that callers can xfs_trans_brelse
> > the buffer and it all works out (like what the attr code does)?
> > 
> > Or should we cancel the new transaction and set *tpp to NULL, which will
> > also solve this problem for the attr case since args.trans will be null
> > after the old commit fails?  But then we run into the problem that now
> > every caller has to be prepared to deal with the transaction being null
> > if something went wrong.  All of those callers ought to be calling
> > xfs_trans_cancel if that's the case, so we might be able to get away
> > with adding a if (!tp) return; at the top of that function.
> > 
> > Or are the callers of _defer_finish/_trans_roll simply supposed to know
> > that the buffer might not be joined if the roll fails and deal with it
> > appropriately?
> > 
> > Extra complication: if the rolling succeeds but one of the
> > defer_ops->finish_item() calls fails then the buffer /will/ be joined to
> > the transaction being passed out.
> > 
> > I /think/ the easiest answer here is that we ought to join the buffers
> > to the new transaction even if committing the old one fails.  I also
> > suspect the out_release code in xrep_roll_ag_trans is wrong, but that's
> > my problem to fix. :)
> > 
> 
> That seems like the most simple and predictable approach to me. Then the
> caller doesn't care whether it has the original transaction or a new
> one, it just needs to unwind its actions and cancel the tx in the event
> of an error.

<nod> I think it's the most straightforward option, but wanted to hear
someone else echo that.  Or tell me I'm a few cards short of a deck. :)

> BTW, a couple other things that look potentially suspicious in this same
> codepath:
> 
> 1.) If the referenced xfs_defer_finish() call succeeds and the
> subsequent xfs_trans_roll_inode() fails similarly, it looks like we can
> end up in a similar unowned buffer state in the caller.

Yep.  I think the bjoin has to go before the "if (error) return error;".

> 2.) If we do end up returning to xfs_attr_set_args() with the buffer
> held to the transaction, ISTM it's likely dirty and thus
> xfs_trans_brelse() may not actually do anything with respect to the
> buffer hold. This seems like a potential buffer lock/ref leak vector.

Hm.  I thought we joined and logged the buffer to the first transaction,
which should clear the dirty state when the transaction commits (or
doesn't)?  Then we add the held buffer to the new transaction, but it's
clean, so it should just release...?  Maybe I need to add an error
injection knob to make rolling fail to see what happens...

> A quick look at xfs_buf_item_unlock() suggests we don't drop the hold in
> the abort case, but I could have missed something. If not, perhaps we'd
> also need to make sure we release the hold before we return from
> xfs_attr_set_args().

We don't?  I would have thought:

	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);

would do that?  <shrug> Maybe I'm confused.

> Hmm, looking around a bit more outside of this attr case I see code like
> the following in xfs_dquot_disk_alloc():
> 
> 	...
>         xfs_trans_bhold(tp, bp);
>         error = xfs_defer_finish(tpp);
>         tp = *tpp;
>         if (error) {
>                 xfs_buf_relse(bp);
>                 return error;
> 	}
> 	...
> 
> That code looks like it actually expects the unowned buf state on a
> failed finish as it explicitly releases it on error. Perhaps this is an
> argument for treating a failed xfs_defer_finish() like a failed commit
> and it is the responsibility of the caller to grok that (meaning the
> caller now owns the buf, not the tx). Then again, I'm not sure how the
> caller knows whether xfs_defer_finish() failed due to a tx roll (where

I don't think the caller has any good way of finding out, aside from
probing xfs_buf.b_transp == *tpp and there's a buffer log item and
XFS_BLI_HOLD is set, which is kind of gross...

bool xfs_buf_is_still_held_by_me_or_did_we_screw_up(xfs_buf_t *bp);

> we currently haven't re-held the buf) or something later in dfops
> processing (where we might have already re-held the buf), so that seems
> fishy too... :/

Yeah.  I think the error handling here (in quota) is simply wrong; that
ought to be "xfs_trans_brelse(*tpp, bp);" not a regular xfs_buf_relse.

--D

> 
> Brian
> 
> > --D
> > 
> > run fstests xfs/141 at 2019-04-23 00:01:13
> > XFS (sdc): Mounting V4 Filesystem
> > XFS (sdc): Ending clean mount
> > XFS (sdb): Mounting V4 Filesystem
> > XFS (sdb): Ending clean mount
> > XFS (sdb): Quotacheck needed: Please wait.
> > XFS (sdb): Quotacheck: Done.
> > XFS (sdb): Injecting error (false) at file fs/xfs/xfs_log.c, line 1924, on filesystem "sdb"
> > XFS (sdb): Intentionally corrupted log record at LSN 0x100000e0e. Shutdown imminent.
> > XFS (sdb): metadata I/O error in "xlog_iodone" at daddr 0x23762e len 64 error 0
> > XFS (sdb): xfs_do_force_shutdown(0x2) called from line 1272 of file fs/xfs/xfs_log.c. Return address = ffffffffa064e48b
> > XFS: Assertion failed: bp->b_transp == tp, file: fs/xfs/xfs_trans_buf.c, line: 385
> > potentially unexpected fatal signal 6.
> > CPU: 1 PID: 1154887 Comm: fsstress Tainted: G        W         5.1.0-rc5-djw #rc5
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
> > RIP: 0033:0x7fdb91cd9e97
> > Code: c2 b8 ea 00 00 00 0f 05 48 3d 00 f0 ff ff 77 3b 41 89 c0 41 ba 08 00 00 00 31 d2 4c 89 ce bf 02 00 00 00 b8 0e 00 00 00 0f 05 <48> 8b 8c 24 08 01 00 00 64 48 33 0c 25 28 00 00 00 44 89 c0 75 1f
> > RSP: 002b:00007ffdb0d0f080 EFLAGS: 00000246 ORIG_RAX: 000000000000000e
> > RAX: 0000000000000000 RBX: 0000000003aed64a RCX: 00007fdb91cd9e97
> > RDX: 0000000000000000 RSI: 00007ffdb0d0f080 RDI: 0000000000000002
> > RBP: 0000000000458923 R08: 0000000000000000 R09: 00007ffdb0d0f080
> > R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000005
> > R13: 000000000000031e R14: 00007ffdb0d0f3d0 R15: 000055d212696560
> > FS:  00007fdb928cdb80 GS:  0000000000000000
> > potentially unexpected fatal signal 6.
> > CPU: 1 PID: 1154888 Comm: fsstress Tainted: G        W         5.1.0-rc5-djw #rc5
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
> > RIP: 0033:0x7fdb91cd9e97
> > Code: c2 b8 ea 00 00 00 0f 05 48 3d 00 f0 ff ff 77 3b 41 89 c0 41 ba 08 00 00 00 31 d2 4c 89 ce bf 02 00 00 00 b8 0e 00 00 00 0f 05 <48> 8b 8c 24 08 01 00 00 64 48 33 0c 25 28 00 00 00 44 89 c0 75 1f
> > RSP: 002b:00007ffdb0d0eaf0 EFLAGS: 00000246 ORIG_RAX: 000000000000000e
> > RAX: 0000000000000000 RBX: 0000000000000005 RCX: 00007fdb91cd9e97
> > RDX: 0000000000000000 RSI: 00007ffdb0d0eaf0 RDI: 0000000000000002
> > RBP: 000055d2128a41c0 R08: 0000000000000000 R09: 00007ffdb0d0eaf0
> > R10: 0000000000000008 R11: 0000000000000246 R12: 000000000007a120
> > R13: 0000000051eb851f R14: 00007ffdb0d0f3d0 R15: 000055d21269ec60
> > FS:  00007fdb928cdb80 GS:  0000000000000000
> > XFS (sdb): Log I/O Error Detected. Shutting down filesystem
> > XFS (sdb): Please unmount the filesystem and rectify the problem(s)
> > WARNING: CPU: 0 PID: 1154885 at fs/xfs/xfs_message.c:104 assfail+0x27/0x2a [xfs]
> > Modules linked in: dm_snapshot xfs dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c ext2 ext4 mbcache jbd2 dm_flakey ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_net xt_set ip_set_hash_mac ip_set nfnetlink bfq mq_deadline ip6table_filter ip6_tables iptable_filter dax_pmem_compat device_dax dax_pmem_core nd_pmem sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
> > CPU: 0 PID: 1154885 Comm: fsstress Tainted: G        W         5.1.0-rc5-djw #rc5
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
> > RIP: 0010:assfail+0x27/0x2a [xfs]
> > Code: 0f 0b c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 50 7c 6a a0 48 89 fa 31 ff e8 a6 f8 ff ff 80 3d 45 94 0a 00 00 74 02 0f 0b <0f> 0b c3 48 8b b3 a8 02 00 00 48 c7 c7 e8 80 6a a0 c6 05 66 8f 0a
> > RSP: 0018:ffffc9000194bbb0 EFLAGS: 00010246
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa0699d13
> > RBP: ffff88803c45cb00 R08: 0000000000000000 R09: 0000000000000000
> > R10: 000000000000000a R11: f000000000000000 R12: ffff888060e41b80
> > R13: 0000000000000010 R14: 000000000000005d R15: 0000000000000000
> > FS:  00007fdb928cdb80(0000) GS:ffff88803e800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fdb9195c000 CR3: 00000000770bd000 CR4: 00000000000006b0
> > Call Trace:
> >  xfs_trans_brelse+0x185/0x210 [xfs]
> >  xfs_attr_set+0x2ce/0x300 [xfs]
> >  xfs_xattr_set+0x54/0xa0 [xfs]
> >  __vfs_setxattr+0x66/0x80
> >  __vfs_setxattr_noperm+0x54/0xf0
> >  vfs_setxattr+0x81/0xa0
> >  setxattr+0x146/0x1d0
> >  path_setxattr+0xd0/0xf0
> >  __x64_sys_setxattr+0x27/0x30
> >  do_syscall_64+0x50/0x160
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x7fdb91db6839
> > Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1f f6 2c 00 f7 d8 64 89 01 48
> > RSP: 002b:00007ffdb0d0f318 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
> > RAX: ffffffffffffffda RBX: 000000000000005d RCX: 00007fdb91db6839
> > RDX: 000055d212bd8b60 RSI: 00007ffdb0d0f360 RDI: 000055d212bf59f0
> > RBP: 0000000000000001 R08: 0000000000000001 R09: 00007ffdb0d0f3d0
> > R10: 000000000000005d R11: 0000000000000246 R12: 0000000000000001
> > R13: 000000000000031a R14: 00007ffdb0d0f360 R15: 000055d212bd8b60
> > irq event stamp: 0
> > hardirqs last  enabled at (0): [<0000000000000000>]           (null)
> > hardirqs last disabled at (0): [<ffffffff81057804>] copy_process+0x8d4/0x2220
> > softirqs last  enabled at (0): [<ffffffff81057804>] copy_process+0x8d4/0x2220
> > softirqs last disabled at (0): [<0000000000000000>]           (null)
> > ---[ end trace f2eeafdb05fd11a1 ]---
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
> > #PF error: [normal kernel read fault]
> > PGD 0 P4D 0 
> > Oops: 0000 [#1] PREEMPT SMP
> > CPU: 0 PID: 1154885 Comm: fsstress Tainted: G        W         5.1.0-rc5-djw #rc5
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
> > RIP: 0010:xfs_trans_brelse+0x48/0x210 [xfs]
> > Code: 85 4a 01 00 00 48 85 ed 0f 84 8a 00 00 00 66 66 66 66 90 65 8b 05 a8 85 9a 5f 89 c0 48 0f a3 05 06 d4 aa e1 0f 82 ee 00 00 00 <81> 7b 38 3c 12 00 00 0f 85 52 01 00 00 8b 83 a8 00 00 00 85 c0 0f
> > RSP: 0018:ffffc9000194bbb8 EFLAGS: 00010286
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: 0000000000000002 RSI: 000000000000000a RDI: ffffffffa0699d13
> > RBP: ffff88803c45cb00 R08: 0000000000000000 R09: 0000000000000000
> > R10: 000000000000000a R11: f000000000000000 R12: ffff888060e41b80
> > R13: 0000000000000010 R14: 000000000000005d R15: 0000000000000000
> > FS:  00007fdb928cdb80(0000) GS:ffff88803e800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000038 CR3: 00000000770bd000 CR4: 00000000000006b0
> > Call Trace:
> >  xfs_attr_set+0x2ce/0x300 [xfs]
> >  xfs_xattr_set+0x54/0xa0 [xfs]
> >  __vfs_setxattr+0x66/0x80
> >  __vfs_setxattr_noperm+0x54/0xf0
> >  vfs_setxattr+0x81/0xa0
> >  setxattr+0x146/0x1d0
> >  path_setxattr+0xd0/0xf0
> >  __x64_sys_setxattr+0x27/0x30
> >  do_syscall_64+0x50/0x160
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x7fdb91db6839
> > Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1f f6 2c 00 f7 d8 64 89 01 48
> > RSP: 002b:00007ffdb0d0f318 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
> > RAX: ffffffffffffffda RBX: 000000000000005d RCX: 00007fdb91db6839
> > RDX: 000055d212bd8b60 RSI: 00007ffdb0d0f360 RDI: 000055d212bf59f0
> > RBP: 0000000000000001 R08: 0000000000000001 R09: 00007ffdb0d0f3d0
> > R10: 000000000000005d R11: 0000000000000246 R12: 0000000000000001
> > R13: 000000000000031a R14: 00007ffdb0d0f360 R15: 000055d212bd8b60
> > Modules linked in: dm_snapshot xfs dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c ext2 ext4 mbcache jbd2 dm_flakey ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_net xt_set ip_set_hash_mac ip_set nfnetlink bfq mq_deadline ip6table_filter ip6_tables iptable_filter dax_pmem_compat device_dax dax_pmem_core nd_pmem sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
> > Dumping ftrace buffer:
> >    (ftrace buffer empty)
> > CR2: 0000000000000038
> > ---[ end trace f2eeafdb05fd11a2 ]---
> > RIP: 0010:xfs_trans_brelse+0x48/0x210 [xfs]
> > Code: 85 4a 01 00 00 48 85 ed 0f 84 8a 00 00 00 66 66 66 66 90 65 8b 05 a8 85 9a 5f 89 c0 48 0f a3 05 06 d4 aa e1 0f 82 ee 00 00 00 <81> 7b 38 3c 12 00 00 0f 85 52 01 00 00 8b 83 a8 00 00 00 85 c0 0f
> > RSP: 0018:ffffc9000194bbb8 EFLAGS: 00010286
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: 0000000000000002 RSI: 000000000000000a RDI: ffffffffa0699d13
> > RBP: ffff88803c45cb00 R08: 0000000000000000 R09: 0000000000000000
> > R10: 000000000000000a R11: f000000000000000 R12: ffff888060e41b80
> > R13: 0000000000000010 R14: 000000000000005d R15: 0000000000000000
> > FS:  00007fdb928cdb80(0000) GS:ffff88803e800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000038 CR3: 00000000770bd000 CR4: 00000000000006b0
> > 
