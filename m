Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47486 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755962AbeAIHJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 02:09:19 -0500
Date: Mon, 8 Jan 2018 23:09:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 6/8] fsstress: implement the clonerange/deduperange
 ioctls
Message-ID: <20180109070912.GC5606@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314503583.18893.15475795025536691678.stgit@magnolia>
 <20171215020731.GM6896@magnolia>
 <20180103084801.GX5123@eguan.usersys.redhat.com>
 <20180103171211.GB16402@magnolia>
 <20180105043549.GF5123@eguan.usersys.redhat.com>
 <20180105045410.GB10266@magnolia>
 <20180106014654.GB5606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180106014654.GB5606@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Jan 05, 2018 at 05:46:54PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 04, 2018 at 08:54:10PM -0800, Darrick J. Wong wrote:
> > On Fri, Jan 05, 2018 at 12:35:49PM +0800, Eryu Guan wrote:
> > > On Wed, Jan 03, 2018 at 09:12:11AM -0800, Darrick J. Wong wrote:
> > > > On Wed, Jan 03, 2018 at 04:48:01PM +0800, Eryu Guan wrote:
> > > > > On Thu, Dec 14, 2017 at 06:07:31PM -0800, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > 
> > > > > > Mix it up a bit by reflinking and deduping data blocks when possible.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > This looks fine overall, but I noticed a soft lockup bug in generic/083
> > > > > and generic/269 (both test exercise ENOSPC behavior), test config is
> > > > > reflink+rmapbt XFS with 4k block size. Not sure if the soft lockup is
> > > > > related to the clonerange/deduperange ops in fsstress yet, will confirm
> > > > > without clone/dedupe ops.
> > > 
> > > More testings showed that this may have something to do with the
> > > deduperange operations. (I was testing with Fedora rawhide with
> > > v4.15-rc5 kernel, I didn't see hang nor soft lockup with my RHEL7 base
> > > host, because there's no FIDEDUPERANGE defined there).
> > > 
> > > I reverted the whole clonerange/deduperange support and retested for two
> > > rounds of full '-g auto' run without hitting any hang or soft lockup.
> > > Then I commented out the deduperange ops and left clonerange ops there,
> > > no hang/lockup either. At last I commented out the clonerange ops but
> > > left deduperange ops there, I hit a different hang in generic/270 (still
> > > a ENOSPC test). I pasted partial sysrq-w output here, if full output is
> > > needed please let me know.
> > > 
> > > [79200.901901] 14266.fsstress. D12200 14533  14460 0x00000000
> > > [79200.902419] Call Trace:
> > > [79200.902655]  ? __schedule+0x2e3/0xb90
> > > [79200.902969]  ? _raw_spin_unlock_irqrestore+0x32/0x60
> > > [79200.903442]  schedule+0x2f/0x90   
> > > [79200.903727]  schedule_timeout+0x1dd/0x540
> > > [79200.904114]  ? __next_timer_interrupt+0xc0/0xc0
> > > [79200.904535]  xfs_inode_ag_walk.isra.12+0x3cc/0x670 [xfs]
> > > [79200.905009]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
> > > [79200.905563]  ? kvm_clock_read+0x21/0x30
> > > [79200.905891]  ? sched_clock+0x5/0x10
> > > [79200.906243]  ? sched_clock_local+0x12/0x80
> > > [79200.906598]  ? kvm_clock_read+0x21/0x30
> > > [79200.906920]  ? sched_clock+0x5/0x10
> > > [79200.907273]  ? sched_clock_local+0x12/0x80
> > > [79200.907636]  ? __lock_is_held+0x59/0xa0
> > > [79200.907988]  ? xfs_inode_ag_iterator_tag+0x46/0xb0 [xfs]
> > > [79200.908497]  ? rcu_read_lock_sched_held+0x6b/0x80
> > > [79200.908926]  ? xfs_perag_get_tag+0x28b/0x2f0 [xfs]
> > > [79200.909416]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
> > > [79200.909922]  xfs_inode_ag_iterator_tag+0x73/0xb0 [xfs]
> > > [79200.910446]  xfs_file_buffered_aio_write+0x348/0x370 [xfs]
> > > [79200.910948]  xfs_file_write_iter+0x99/0x140 [xfs]
> > > [79200.911400]  __vfs_write+0xfc/0x170
> > > [79200.911726]  vfs_write+0xc1/0x1b0
> > > [79200.912063]  SyS_write+0x55/0xc0
> > > [79200.912347]  entry_SYSCALL_64_fastpath+0x1f/0x96
> > > 
> > > Seems other hangning fsstress processes were all waiting for io
> > > completion of writeback (sleeping in wb_wait_for_completion).
> > 
> > Hmm, I'll badger it some more, though I did see:
> > 
> > [ 4349.832516] XFS: Assertion failed: xfs_is_reflink_inode(ip), file: /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_reflink.c, line: 651
> > [ 4349.847730] WARNING: CPU: 3 PID: 3600 at /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_message.c:116 assfail+0x2e/0x60 [xfs]
> > [ 4349.849142] Modules linked in: xfs libcrc32c dm_snapshot dm_bufio dax_pmem device_dax nd_pmem sch_fq_codel af_packet [last unloaded: xfs]
> > [ 4349.850603] CPU: 3 PID: 3600 Comm: fsstress Not tainted 4.15.0-rc6-xfsx #9
> > [ 4349.851417] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
> > [ 4349.852594] RIP: 0010:assfail+0x2e/0x60 [xfs]
> > [ 4349.853156] RSP: 0018:ffffc90002d97a80 EFLAGS: 00010246
> > [ 4349.853785] RAX: 00000000ffffffea RBX: 0000000000000000 RCX: 0000000000000001
> > [ 4349.854621] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa0270585
> > [ 4349.855457] RBP: ffff88001d41d100 R08: 0000000000000000 R09: 0000000000000000
> > [ 4349.856296] R10: ffffc90002d97a28 R11: f000000000000000 R12: 0000000000000000
> > [ 4349.857142] R13: ffffffffffffffff R14: 0000000000000000 R15: 0000000000000008
> > [ 4349.857969] FS:  00007f0712dc8700(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
> > [ 4349.858918] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 4349.859596] CR2: 00007f0711e7e008 CR3: 0000000004265001 CR4: 00000000001606e0
> > [ 4349.860462] Call Trace:
> > [ 4349.860860]  xfs_reflink_cancel_cow_range+0x3f6/0x650 [xfs]
> > [ 4349.861596]  ? down_write_nested+0x94/0xb0
> > [ 4349.862165]  ? xfs_ilock+0x2ac/0x450 [xfs]
> > [ 4349.862719]  xfs_inode_free_cowblocks+0x38e/0x620 [xfs]
> > [ 4349.863376]  xfs_inode_ag_walk+0x327/0xc30 [xfs]
> > [ 4349.863972]  ? xfs_inode_free_eofblocks+0x580/0x580 [xfs]
> > [ 4349.864600]  ? try_to_wake_up+0x30/0x560
> > [ 4349.865105]  ? _raw_spin_unlock_irqrestore+0x46/0x70
> > [ 4349.865667]  ? try_to_wake_up+0x49/0x560
> > [ 4349.866159]  ? radix_tree_gang_lookup_tag+0xf4/0x150
> > [ 4349.866795]  ? xfs_inode_free_eofblocks+0x580/0x580 [xfs]
> > [ 4349.867438]  ? xfs_perag_get_tag+0x205/0x470 [xfs]
> > [ 4349.868042]  ? xfs_perag_put+0x15f/0x2e0 [xfs]
> > [ 4349.868573]  ? xfs_inode_free_eofblocks+0x580/0x580 [xfs]
> > [ 4349.869243]  xfs_inode_ag_iterator_tag+0x65/0xa0 [xfs]
> > [ 4349.869876]  xfs_file_buffered_aio_write+0x203/0x5b0 [xfs]
> > [ 4349.870575]  xfs_file_write_iter+0x298/0x4f0 [xfs]
> > [ 4349.871164]  __vfs_write+0x130/0x1a0
> > [ 4349.871585]  vfs_write+0xc8/0x1c0
> > [ 4349.872001]  SyS_write+0x45/0xa0
> > [ 4349.872394]  entry_SYSCALL_64_fastpath+0x1f/0x96
> > [ 4349.872950] RIP: 0033:0x7f071259c4a0
> > [ 4349.873377] RSP: 002b:00007ffea07c4588 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > [ 4349.874226] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f071259c4a0
> > [ 4349.875066] RDX: 000000000000aebc RSI: 000000000111b260 RDI: 0000000000000003
> > [ 4349.875866] RBP: 0000000000000001 R08: 000000000000006e R09: 0000000000000004
> > [ 4349.876658] R10: 00007f0712586b78 R11: 0000000000000246 R12: 00000000000007a9
> > [ 4349.877433] R13: 0000000000000003 R14: 00000000001c6200 R15: 000000000001e000
> > [ 4349.878273] Code: 00 00 53 48 89 f1 41 89 d0 48 c7 c6 18 3e 28 a0 48 89 fa 31 ff e8 63 fa ff ff 0f b6 1d 28 44 29 00 80 fb 01 77 09 83 e3 01 75 15 <0f> ff 5b c3 0f b6 f3 48 c7 c7 90 bd 3d a0 e8 3f 13 1c e1 eb e6 
> > [ 4349.880399] ---[ end trace 1e05700f283b7cc1 ]---
> 
> Ok so I think this is just an assert that doesn't belong.
> 
> > So maybe I need to take a closer look at all this machinery tomorrow...
> 
> It would seem that writeback is wedging up when it tries to allocate blocks
> to fill a delalloc(?) extent, but at that point the filesystem is totally
> out of space (zero free blocks) and the whole thing dies.  Hm.  Will take
> a further look next week.

Nothing is ever simple in XFS, is it...

This is actually two problems -- the first is that the while (bno < end
&& n < *nmap) loop in xfs_bmapi_write somehow becomes an infinite loop
when ... I guess eof is true prior to entering the loop?  So we never
advance bno past end, and stuck become we.

The second problem is that for whatever reason the free blocks counter
can dip negative(!) and if it does this for too long(?) then transaction
allocation thinks that we have a large positive number of blocks(??) but
there's nothing in the bnobt to feed it and so kablooie?  Or maybe this
is just some xfs_ag_resv insanity(???) (bfoster was asking about that
earlier).

So, uh... yeah.  It's 11pm, I'm going to bed, will take it up in the
morning.

--D

> --D
> 
> FWIW I also saw these oddballs fly by on one of the g/269 runs:
> 
> (I'm merely recording these here to leave a breadcrumb trail so I can pick
> this up again on Monday.  I think these are all related to the fs being
> totally out of space.)
> 
> [  350.205699] XFS: Assertion failed: type != XFS_IO_COW, file: /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_aops.c, line: 393
> [  350.207092] WARNING: CPU: 2 PID: 105 at /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_message.c:116 assfail+0x2e/0x60 [xfs]
> [  350.208224] Modules linked in: xfs libcrc32c dax_pmem device_dax nd_pmem sch_fq_codel af_packet [last unloaded: xfs]
> [  350.209219] CPU: 2 PID: 105 Comm: kworker/u10:2 Not tainted 4.15.0-rc6-xfsx #5
> [  350.209959] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
> [  350.210902] Workqueue: writeback wb_workfn (flush-259:4)
> [  350.211489] RIP: 0010:assfail+0x2e/0x60 [xfs]
> [  350.211947] RSP: 0018:ffffc9000088f8b8 EFLAGS: 00010246
> [  350.212512] RAX: 00000000ffffffea RBX: 0000000000000000 RCX: 0000000000000001
> [  350.213276] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa06155b5
> [  350.214072] RBP: 0000000000001000 R08: 0000000000000000 R09: 0000000000000000
> [  350.214836] R10: 0000000000000000 R11: f000000000000000 R12: 00000000000b3000
> [  350.215565] R13: 0000000000000004 R14: ffff88005d2ee540 R15: ffffc9000088fb28
> [  350.216328] FS:  0000000000000000(0000) GS:ffff88007f200000(0000) knlGS:0000000000000000
> [  350.217172] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  350.217849] CR2: 00007f6a9b021000 CR3: 0000000002011002 CR4: 00000000001606e0
> [  350.218675] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  350.219528] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  350.220389] Call Trace:
> [  350.220748]  xfs_map_blocks+0x479/0x8e0 [xfs]
> [  350.221310]  xfs_do_writepage+0x2f8/0xe30 [xfs]
> [  350.221870]  write_cache_pages+0x20c/0x530
> [  350.222381]  ? xfs_add_to_ioend+0x6d0/0x6d0 [xfs]
> [  350.222950]  xfs_vm_writepages+0x7f/0x170 [xfs]
> [  350.223550]  do_writepages+0x17/0x70
> [  350.224051]  __writeback_single_inode+0x59/0x7e0
> [  350.224662]  writeback_sb_inodes+0x283/0x550
> [  350.225172]  wb_writeback+0x112/0x5c0
> [  350.225623]  ? wb_workfn+0x128/0x740
> [  350.226053]  wb_workfn+0x128/0x740
> [  350.226485]  ? lock_acquire+0xab/0x200
> [  350.226941]  ? lock_acquire+0xab/0x200
> [  350.227380]  ? process_one_work+0x17e/0x680
> [  350.227875]  process_one_work+0x1fb/0x680
> [  350.228409]  worker_thread+0x4d/0x3e0
> [  350.228849]  kthread+0x103/0x140
> [  350.229249]  ? process_one_work+0x680/0x680
> [  350.229751]  ? kthread_delayed_work_timer_fn+0x90/0x90
> [  350.230358]  ret_from_fork+0x24/0x30
> [  350.230789] Code: 00 00 53 48 89 f1 41 89 d0 48 c7 c6 d8 8e 62 a0 48 89 fa 31 ff e8 63 fa ff ff 0f b6 1d 88 50 29 00 80 fb 01 77 09 83 e3 01 75 15 <0f> ff 5b c3 0f b6 f3 48 c7 c7 70 0d 78 a0 e8 df ce e1 e0 eb e6 
> [  350.232932] ---[ end trace 7e48cbbf0d68bb48 ]---
> [  351.713383] XFS (pmem4): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
> [  359.565227] XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_trans.c, line: 353
> [  359.585681] WARNING: CPU: 3 PID: 14462 at /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_message.c:116 assfail+0x2e/0x60 [xfs]
> [  359.591910] Modules linked in: xfs libcrc32c dax_pmem device_dax nd_pmem sch_fq_codel af_packet [last unloaded: xfs]
> [  359.594521] CPU: 3 PID: 14462 Comm: fsstress Tainted: G        W        4.15.0-rc6-xfsx #5
> [  359.595988] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
> [  359.596946] RIP: 0010:assfail+0x2e/0x60 [xfs]
> [  359.597385] RSP: 0018:ffffc9000280b708 EFLAGS: 00010246
> [  359.597927] RAX: 00000000ffffffea RBX: 0000000000000000 RCX: 0000000000000001
> [  359.598661] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa06155b5
> [  359.599388] RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
> [  359.600200] R10: 0000000000000000 R11: f000000000000000 R12: ffffffffffffffee
> [  359.601005] R13: ffff8800390ec000 R14: ffffc9000280b840 R15: ffff8800390ec000
> [  359.601777] FS:  00007f6a9b033700(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
> [  359.602725] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  359.603374] CR2: 0000000000815b88 CR3: 000000003d1e5001 CR4: 00000000001606e0
> [  359.604154] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  359.604995] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  359.605814] Call Trace:
> [  359.606081]  xfs_trans_mod_sb+0x44c/0x5e0 [xfs]
> [  359.606656]  xfs_alloc_ag_vextent+0x169/0x580 [xfs]
> [  359.607263]  xfs_alloc_vextent+0xb1b/0x19c0 [xfs]
> [  359.607849]  ? xfs_bmap_longest_free_extent+0x6c/0x120 [xfs]
> [  359.608710]  ? xfs_bmap_btalloc_nullfb+0x9e/0x190 [xfs]
> [  359.609504]  xfs_bmap_btalloc+0x2c1/0xe60 [xfs]
> [  359.610599]  xfs_bmapi_write+0x641/0x1d70 [xfs]
> [  359.611993]  xfs_iomap_write_unwritten+0x246/0x690 [xfs]
> [  359.612991]  iomap_dio_complete+0x43/0x100
> [  359.613414]  iomap_dio_rw+0x358/0x380
> [  359.613834]  ? xfs_file_dio_aio_write+0x184/0x7a0 [xfs]
> [  359.614385]  xfs_file_dio_aio_write+0x184/0x7a0 [xfs]
> [  359.614919]  ? lock_acquire+0xab/0x200
> [  359.615342]  xfs_file_write_iter+0x16c/0x4f0 [xfs]
> [  359.615842]  aio_write+0x129/0x1b0
> [  359.616207]  ? lock_acquire+0xab/0x200
> [  359.616615]  ? __might_fault+0x36/0x80
> [  359.617020]  ? do_io_submit+0x40e/0x8c0
> [  359.617437]  do_io_submit+0x40e/0x8c0
> [  359.617841]  ? entry_SYSCALL_64_fastpath+0x1f/0x96
> [  359.618354]  entry_SYSCALL_64_fastpath+0x1f/0x96
> [  359.618861] RIP: 0033:0x7f6a9aa14697
> [  359.619222] RSP: 002b:00007ffef5888f58 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
> [  359.619936] RAX: ffffffffffffffda RBX: 0000000000000473 RCX: 00007f6a9aa14697
> [  359.620550] RDX: 00007ffef5888f80 RSI: 0000000000000001 RDI: 00007f6a9b03b000
> [  359.621289] RBP: 0000000000184000 R08: 00007f6a9a7f1bf8 R09: 0000000000000000
> [  359.622057] R10: 00007f6a9a7f1b78 R11: 0000000000000246 R12: 0000000000000000
> [  359.622832] R13: 7fffffffffffffff R14: 0000000000000003 R15: 0000000000000004
> [  359.623664] Code: 00 00 53 48 89 f1 41 89 d0 48 c7 c6 d8 8e 62 a0 48 89 fa 31 ff e8 63 fa ff ff 0f b6 1d 88 50 29 00 80 fb 01 77 09 83 e3 01 75 15 <0f> ff 5b c3 0f b6 f3 48 c7 c7 70 0d 78 a0 e8 df ce e1 e0 eb e6 
> [  359.625557] ---[ end trace 7e48cbbf0d68bb49 ]---
> <snip>
> [  361.250280] XFS: Assertion failed: pathlen == 0, file: /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_symlink.c, line: 346
> [  361.255275] WARNING: CPU: 2 PID: 14534 at /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_message.c:116 assfail+0x2e/0x60 [xfs]
> [  361.256421] Modules linked in: xfs libcrc32c dax_pmem device_dax nd_pmem sch_fq_codel af_packet [last unloaded: xfs]
> [  361.257417] CPU: 2 PID: 14534 Comm: fsstress Tainted: G        W        4.15.0-rc6-xfsx #5
> [  361.258269] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
> [  361.259250] RIP: 0010:assfail+0x2e/0x60 [xfs]
> [  361.259746] RSP: 0018:ffffc90002a4fd00 EFLAGS: 00010246
> [  361.260481] RAX: 00000000ffffffea RBX: 0000000000000000 RCX: 0000000000000001
> [  361.261374] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa06155b5
> [  361.262111] RBP: ffff880055db5e80 R08: 0000000000000000 R09: 0000000000000000
> [  361.262790] R10: ffffc90002a4fc40 R11: f000000000000000 R12: ffff8800390ec000
> [  361.263453] R13: 00000000000001b1 R14: ffffc90002a4fea8 R15: 0000000000000024
> [  361.264122] FS:  00007f6a9b033700(0000) GS:ffff88007f200000(0000) knlGS:0000000000000000
> [  361.264868] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  361.265409] CR2: 00007f6a9b030000 CR3: 0000000022460001 CR4: 00000000001606e0
> [  361.266074] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  361.266734] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  361.267395] Call Trace:
> [  361.267684]  xfs_symlink+0xd1b/0x11d0 [xfs]
> [  361.268081]  ? lock_acquire+0xab/0x200
> [  361.268466]  ? __d_rehash+0x82/0xd0
> [  361.268814]  ? _raw_spin_unlock+0x2e/0x50
> [  361.269221]  xfs_vn_symlink+0x9a/0x1f0 [xfs]
> [  361.269636]  vfs_symlink+0x83/0xd0
> [  361.269954]  SyS_symlink+0x7e/0xd0
> [  361.270273]  entry_SYSCALL_64_fastpath+0x1f/0x96
> [  361.270708] RIP: 0033:0x7f6a9a525997
> [  361.271049] RSP: 002b:00007ffef5889338 EFLAGS: 00000206 ORIG_RAX: 0000000000000058
> [  361.271729] RAX: ffffffffffffffda RBX: 0000000000000387 RCX: 00007f6a9a525997
> [  361.272380] RDX: 0000000000000064 RSI: 00000000007cc160 RDI: 00000000007d04c0
> [  361.273016] RBP: 0000000000000009 R08: 00007f6a9a7f2308 R09: 0000000000000003
> [  361.273659] R10: 0000000000000000 R11: 0000000000000206 R12: 00000000000e4000
> [  361.274300] R13: 0000000000000003 R14: 000000000000f000 R15: 0000000000000016
> [  361.274939] Code: 00 00 53 48 89 f1 41 89 d0 48 c7 c6 d8 8e 62 a0 48 89 fa 31 ff e8 63 fa ff ff 0f b6 1d 88 50 29 00 80 fb 01 77 09 83 e3 01 75 15 <0f> ff 5b c3 0f b6 f3 48 c7 c7 70 0d 78 a0 e8 df ce e1 e0 eb e6 
> [  361.276610] ---[ end trace 7e48cbbf0d68bb59 ]---
> [  361.280551] XFS: Assertion failed: error != -ENOSPC, file: /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_inode.c, line: 1223
> [  361.284186] WARNING: CPU: 0 PID: 14473 at /storage/home/djwong/cdev/work/linux-xfs/fs/xfs/xfs_message.c:116 assfail+0x2e/0x60 [xfs]
> [  361.285483] Modules linked in: xfs libcrc32c dax_pmem device_dax nd_pmem sch_fq_codel af_packet [last unloaded: xfs]
> [  361.286912] CPU: 0 PID: 14473 Comm: fsstress Tainted: G        W        4.15.0-rc6-xfsx #5
> [  361.288140] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
> [  361.289029] RIP: 0010:assfail+0x2e/0x60 [xfs]
> [  361.289466] RSP: 0018:ffffc90002863d58 EFLAGS: 00010246
> [  361.289959] RAX: 00000000ffffffea RBX: 0000000000000000 RCX: 0000000000000001
> [  361.290705] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa06155b5
> [  361.291432] RBP: 00000000ffffffe4 R08: 0000000000000000 R09: 0000000000000000
> [  361.292198] R10: 0000000000000000 R11: f000000000000000 R12: ffff880030023600
> [  361.292944] R13: ffffc90002863e98 R14: 0000000000000025 R15: 0000000000000000
> [  361.293789] FS:  00007f6a9b033700(0000) GS:ffff88003ea00000(0000) knlGS:0000000000000000
> [  361.294562] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  361.295118] CR2: 00007fcea800f0b8 CR3: 000000003d4a2004 CR4: 00000000001606f0
> [  361.295797] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  361.296566] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  361.297253] Call Trace:
> [  361.297609]  xfs_create+0x82a/0xd10 [xfs]
> [  361.298014]  ? get_cached_acl+0xca/0x1e0
> [  361.298437]  xfs_generic_create+0x220/0x360 [xfs]
> [  361.298905]  vfs_mknod+0xa9/0x100
> [  361.299245]  SyS_mknod+0x1a3/0x1f0
> [  361.299584]  entry_SYSCALL_64_fastpath+0x1f/0x96
> [  361.300047] RIP: 0033:0x7f6a9a523cad
> [  361.300410] RSP: 002b:00007ffef5889338 EFLAGS: 00000246 ORIG_RAX: 0000000000000085
> [  361.301117] RAX: ffffffffffffffda RBX: 00000000000003e6 RCX: 00007f6a9a523cad
> [  361.301887] RDX: 0000000000000000 RSI: 0000000000002124 RDI: 00000000007db300
> [  361.302569] RBP: 00000000000db000 R08: 00000000007db300 R09: 0000000000000002
> [  361.303344] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000d000
> [  361.304120] R13: 7fffffffffffffff R14: 0000000000000003 R15: 0000000000000004
> [  361.304912] Code: 00 00 53 48 89 f1 41 89 d0 48 c7 c6 d8 8e 62 a0 48 89 fa 31 ff e8 63 fa ff ff 0f b6 1d 88 50 29 00 80 fb 01 77 09 83 e3 01 75 15 <0f> ff 5b c3 0f b6 f3 48 c7 c7 70 0d 78 a0 e8 df ce e1 e0 eb e6 
> [  361.306797] ---[ end trace 7e48cbbf0d68bb5a ]---
> 
> 
> > > 
> > > > > 
> > > > > [12968.100008] watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [fsstress:6903]
> > > > > [12968.100038] Modules linked in: loop dm_flakey xfs ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw iptable_security ebtable_filter ebtables ip6table_filter ip6_tables sunrpc 8139too 8139cp i2c_piix4 joydev mii pcspkr virtio_balloon virtio_pci serio_raw virtio_ring virtio floppy ata_generic pata_acpi
> > > > > [12968.104043] irq event stamp: 23222196
> > > > > [12968.104043] hardirqs last  enabled at (23222195): [<000000007d0c2e75>] restore_regs_and_return_to_kernel+0x0/0x2e
> > > > > [12968.105111] hardirqs last disabled at (23222196): [<000000008f80dc57>] apic_timer_interrupt+0xa7/0xc0
> > > > > [12968.105111] softirqs last  enabled at (877594): [<0000000034c53d5e>] __do_softirq+0x392/0x502
> > > > > [12968.105111] softirqs last disabled at (877585): [<000000003f4d9e0b>] irq_exit+0x102/0x110
> > > > > [12968.105111] CPU: 2 PID: 6903 Comm: fsstress Tainted: G        W    L   4.15.0-rc5 #10
> > > > > [12968.105111] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> > > > > [12968.108043] RIP: 0010:xfs_bmapi_update_map+0xc/0xc0 [xfs]
> > > > 
> > > > Hmmm, I haven't seen such a hang; I wonder if we're doing something
> > > > we shouldn't be doing and looping in bmapi_write.  In any case it's
> > > > a bug with xfs, not fsstress.
> > > 
> > > Agreed, I'm planning to pull this patch in this week's update, with the
> > > following fix
> > > 
> > > - inode_info(inoinfo2, sizeof(inoinfo2), &stat2, v1);
> > > + inode_info(inoinfo2, sizeof(inoinfo2), &stat2, v2);
> > > 
> > > Also I'd follow Dave's suggestion on xfs/068 fix, move the
> > > FSSTRESS_AVOID handling to common/dump on commit. Please let me know if
> > > you have a different plan now.
> > 
> > I was just gonna go back to amending only xfs/068 to turn off clone/dedupe.
> > 
> > --D
> > 
> > > Thanks,
> > > Eryu
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
