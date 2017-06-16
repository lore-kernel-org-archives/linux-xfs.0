Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34134 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752671AbdFPLvy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 07:51:54 -0400
Date: Fri, 16 Jun 2017 07:51:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: free uncommitted transactions during log recovery
Message-ID: <20170616115147.GA11636@bfoster.bfoster>
References: <1497029889-12299-1-git-send-email-bfoster@redhat.com>
 <20170615170757.GZ4530@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170615170757.GZ4530@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2017 at 10:07:57AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 09, 2017 at 01:38:09PM -0400, Brian Foster wrote:
> > Log recovery allocates in-core transaction and member item data
> > structures on-demand as it processes the on-disk log. Transactions
> > are allocated on first encounter on-disk and stored in a hash table
> > structure where they are easily accessible for subsequent lookups.
> > Transaction items are also allocated on demand and are attached to
> > the associated transactions.
> > 
> > When a commit record is encountered in the log, the transaction is
> > committed to the fs and the in-core structures are freed. If a
> > filesystem crashes or shuts down before all in-core log buffers are
> > flushed to the log, however, not all transactions may have commit
> > records in the log. As expected, the modifications in such an
> > incomplete transaction are not replayed to the fs. The in-core data
> > structures for the partial transaction are never freed, however,
> > resulting in a memory leak.
> > 
> > Update xlog_do_recovery_pass() to walk the hash table of transaction
> > lists as the last step before it goes out of scope and free any
> > transactions that may remain on the lists. This prevents a memory
> > leak of partial transactions in the log.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > FYI, I suspect this has been a problem for a while and and rare/harmless
> > enough that this can target 4.13.
> > 
> > Brian
> > 
> >  fs/xfs/xfs_log_recover.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 4a98762..37b34c5 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -5224,6 +5224,7 @@ xlog_do_recovery_pass(
> >  	int			error2 = 0;
> >  	int			bblks, split_bblks;
> >  	int			hblks, split_hblks, wrapped_hblks;
> > +	int			i;
> >  	struct hlist_head	rhash[XLOG_RHASH_SIZE];
> >  	LIST_HEAD		(buffer_list);
> >  
> > @@ -5466,6 +5467,19 @@ xlog_do_recovery_pass(
> >  	if (error && first_bad)
> >  		*first_bad = rhead_blk;
> >  
> > +	/*
> > +	 * Transactions are freed at commit time but transactions without commit
> > +	 * records on disk are never committed. Free any that may be left in the
> > +	 * hash table.
> > +	 */
> > +	for (i = 0; i < XLOG_RHASH_SIZE; i++) {
> > +		struct hlist_node	*tmp;
> > +		struct xlog_recover	*trans;
> > +
> > +		hlist_for_each_entry_safe(trans, tmp, &rhash[i], r_list)
> > +			xlog_recover_free_trans(trans);
> > +	}
> 
> Hmm, I just got the following crash in xfs/051:
> 
> [  131.456722] XFS (dm-0): Mounting V5 Filesystem
> [  131.462826] XFS (dm-0): Delaying log recovery for 10 seconds.
> [  141.532271] XFS (dm-0): Starting recovery (logdev: internal)
> [  141.534418] XFS (dm-0): metadata I/O error: block 0x182e70 ("xlog_bread_noalign") error 5 numblks 8
> [  141.539561] general protection fault: 0000 [#1] PREEMPT SMP

FWIW, it looks like the problem is that the rhash array of hlist_head's
is never actually initialized properly. xfs/051 tests the case where log
recovery fails, we end up in the new freeing code without having added
any transactions, and the attempted hash list traversals are what
actually cause the oops.

I've updated the patch to initialize rhash[] at the top of the function
and it seems to have resolved that problem. I also noticed that
transaction removal from the hash lists is inconsistent. We remove the
transaction when it is committed, but it's also possible to free it from
xlog_recovery_process_trans() in the error case without having it
removed it. Therefore, I've also updated the patch to make
xlog_recover_free_trans() remove the transaction first to prevent any
double-free vectors and changed list_del() to hlist_del_init() to
preserve existing commit behavior.

I'll post v2 once I get through some more testing..

Brian

> [  141.542236] Dumping ftrace buffer:
> [  141.542972]    (ftrace buffer empty)
> [  141.543083] Modules linked in: xfs dm_flakey libcrc32c dax_pmem device_dax nd_pmem binfmt_misc nfsd auth_rpcgss sch_fq_codel af_packet [last unloaded: xfs]
> [  141.543083] CPU: 1 PID: 3246 Comm: mount Not tainted 4.12.0-rc5-dgc #1
> [  141.543083] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [  141.543083] task: ffff88006e0ca900 task.stack: ffffc90001d70000
> [  141.543083] RIP: 0010:xlog_recover_free_trans+0x1d/0xb0 [xfs]
> [  141.543083] RSP: 0018:ffffc90001d73b30 EFLAGS: 00010286
> [  141.543083] RAX: ffffc90001d73bc0 RBX: 00000000fffffffb RCX: ffffc90001d73bc0
> [  141.543083] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ffff8800756ae800
> [  141.543083] RBP: ffffc90001d73b58 R08: 0000000000000001 R09: 0000000000000000
> [  141.543083] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800756ae830
> [  141.543083] R13: ffff8800756ae800 R14: ffffc90001d73bd0 R15: 206b636f6c62203a
> [  141.543083] FS:  00007fe28e0d6840(0000) GS:ffff88007f200000(0000) knlGS:0000000000000000
> [  141.543083] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  141.543083] CR2: 00007fe28d6a0cf9 CR3: 000000007b3de000 CR4: 00000000001406e0
> [  141.543083] Call Trace:
> [  141.543083]  xlog_do_recovery_pass+0x3ec/0x740 [xfs]
> [  141.543083]  ? rcu_read_lock_sched_held+0x72/0x80
> [  141.543083]  ? __kmalloc+0x26c/0x2d0
> [  141.543083]  ? kmem_alloc+0x81/0x100 [xfs]
> [  141.543083]  ? kmem_alloc+0x81/0x100 [xfs]
> [  141.543083]  xlog_do_log_recovery+0x70/0x150 [xfs]
> [  141.543083]  xlog_do_recover+0x1b/0x170 [xfs]
> [  141.543083]  xlog_recover+0xa2/0x130 [xfs]
> [  141.543083]  xfs_log_mount+0xdb/0x2e0 [xfs]
> [  141.543083]  xfs_mountfs+0x579/0xad0 [xfs]
> [  141.543083]  xfs_fs_fill_super+0x483/0x610 [xfs]
> [  141.543083]  mount_bdev+0x180/0x1b0
> [  141.543083]  ? xfs_finish_flags+0x150/0x150 [xfs]
> [  141.543083]  xfs_fs_mount+0x15/0x20 [xfs]
> [  141.543083]  mount_fs+0x14/0x80
> [  141.543083]  vfs_kern_mount+0x67/0x150
> [  141.543083]  do_mount+0x195/0xd10
> [  141.543083]  ? _copy_from_user+0x47/0x80
> [  141.543083]  ? memdup_user+0x60/0x90
> [  141.543083]  SyS_mount+0x95/0xe0
> [  141.543083]  entry_SYSCALL_64_fastpath+0x1f/0xbe
> [  141.543083] RIP: 0033:0x7fe28d9b7faa
> [  141.543083] RSP: 002b:00007ffe9168f628 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> [  141.543083] RAX: ffffffffffffffda RBX: 00007fe28dcb063a RCX: 00007fe28d9b7faa
> [  141.543083] RDX: 0000000001ab2240 RSI: 0000000001ab2280 RDI: 0000000001ab2260
> [  141.543083] RBP: 0000000001ab2120 R08: 0000000000000000 R09: 0000000000000012
> [  141.543083] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 00007fe28dec083c
> [  141.543083] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000003
> [  141.543083] Code: 5d c3 31 c0 c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 4c 8d 67 30 53 4c 8b 7f 30 49 89 fd <49> 8b 1f 4d 39 e7 48 89 d8 74 6f 49 8b 57 08 45 31 f6 48 89 50 
> [  141.543083] RIP: xlog_recover_free_trans+0x1d/0xb0 [xfs] RSP: ffffc90001d73b30
> [  141.591289] ---[ end trace b3d5b2775a86318f ]---
> 
> FWIW I was testing 4.13 for-next with the following xfstest config:
> 
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 birch-mtr0 4.12.0-rc5-dgc
> MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1, -i sparse=1, /dev/pmem1
> MOUNT_OPTIONS -- /dev/pmem1 /opt
> 
> --D
> 
> > +
> >  	return error ? error : error2;
> >  }
> >  
> > -- 
> > 2.7.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
