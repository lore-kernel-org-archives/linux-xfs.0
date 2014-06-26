Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BC52F7F83
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 13:20:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 78B5A8F8070
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 11:20:10 -0700 (PDT)
Received: from mail-qg0-f43.google.com (mail-qg0-f43.google.com
	[209.85.192.43]) by cuda.sgi.com with ESMTP id EXkzpl4EVDiWtVoq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 Jun 2014 11:20:06 -0700 (PDT)
Received: by mail-qg0-f43.google.com with SMTP id z60so3453296qgd.30
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 11:20:06 -0700 (PDT)
From: Jeff Layton <jeff.layton@primarydata.com>
Date: Thu, 26 Jun 2014 14:20:04 -0400
Subject: xfs: possible irq lock inversion dependency detected
Message-ID: <20140626142004.31b981dc@tlielax.poochiereds.net>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

While testing some knfsd patches on XFS today, I got this lockdep
splatter. The kernel is a stock -rc2 kernel with a pile of knfsd
patches on top. There are a couple of others in other areas, but
nothing that would affect this.

Nothing crashed or seems to be hung, so I'm not sure if it's a real
problem or not...

----------------------------[snip]-------------------------

[ 1136.235445] =========================================================
[ 1136.236081] [ INFO: possible irq lock inversion dependency detected ]
[ 1136.236081] 3.16.0-rc2.jlayton.2+ #9 Tainted: G           OE
[ 1136.236081] ---------------------------------------------------------
[ 1136.236081] kswapd0/53 just changed the state of lock:
[ 1136.236081]  (&xfs_dir_ilock_class){++++-+}, at: [<ffffffffa035e1a5>] xfs_ilock+0xd5/0x1c0 [xfs]
[ 1136.236081] but this lock took another, RECLAIM_FS-unsafe lock in the past:
[ 1136.236081]  (&mm->mmap_sem){++++++}

and interrupts could create inverse lock ordering between them.

[ 1136.236081] 
other info that might help us debug this:
[ 1136.236081]  Possible interrupt unsafe locking scenario:

[ 1136.236081]        CPU0                    CPU1
[ 1136.236081]        ----                    ----
[ 1136.236081]   lock(&mm->mmap_sem);
[ 1136.236081]                                local_irq_disable();
[ 1136.236081]                                lock(&xfs_dir_ilock_class);
[ 1136.236081]                                lock(&mm->mmap_sem);
[ 1136.236081]   <Interrupt>
[ 1136.236081]     lock(&xfs_dir_ilock_class);
[ 1136.236081] 
 *** DEADLOCK ***

[ 1136.236081] 3 locks held by kswapd0/53:
[ 1136.236081]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff811d0e9f>] shrink_slab+0x3f/0x180
[ 1136.236081]  #1:  (&type->s_umount_key#50){.+.+.+}, at: [<ffffffff81244224>] grab_super_passive+0x44/0x90
[ 1136.236081]  #2:  (&pag->pag_ici_reclaim_lock){+.+...}, at: [<ffffffffa0310437>] xfs_reclaim_inodes_ag+0xc7/0x510 [xfs]
[ 1136.236081] 
the shortest dependencies between 2nd lock and 1st lock:
[ 1136.236081]  -> (&mm->mmap_sem){++++++} ops: 503241 {
[ 1136.236081]     HARDIRQ-ON-W at:
[ 1136.236081]                       [<ffffffff810fd5d0>] __lock_acquire+0x670/0x1ca0
[ 1136.236081]                       [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]                       [<ffffffff817f864e>] down_write+0x4e/0xc0
[ 1136.236081]                       [<ffffffff812485e8>] do_execve_common.isra.25+0x418/0x8f0
[ 1136.236081]                       [<ffffffff81248ad8>] do_execve+0x18/0x20
[ 1136.236081]                       [<ffffffff8100202b>] run_init_process+0x2b/0x30
[ 1136.236081]                       [<ffffffff817e0522>] kernel_init+0x42/0xf0
[ 1136.236081]                       [<ffffffff817fa8fc>] ret_from_fork+0x7c/0xb0
[ 1136.236081]     HARDIRQ-ON-R at:
[ 1136.236081]                       [<ffffffff810fd4ba>] __lock_acquire+0x55a/0x1ca0
[ 1136.236081]                       [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]                       [<ffffffff811ea5ec>] might_fault+0x8c/0xb0
[ 1136.236081]                       [<ffffffff813e1d47>] __clear_user+0x17/0x60
[ 1136.236081]                       [<ffffffff813e1dbf>] clear_user+0x2f/0x40
[ 1136.236081]                       [<ffffffff817ef0c1>] padzero+0x23/0x30
[ 1136.236081]                       [<ffffffff812a0ffe>] load_elf_binary+0x9ee/0x18e0
[ 1136.236081]                       [<ffffffff812474d4>] search_binary_handler+0x94/0x1b0
[ 1136.236081]                       [<ffffffff81248841>] do_execve_common.isra.25+0x671/0x8f0
[ 1136.236081]                       [<ffffffff81248ad8>] do_execve+0x18/0x20
[ 1136.236081]                       [<ffffffff8100202b>] run_init_process+0x2b/0x30
[ 1136.236081]                       [<ffffffff817e0522>] kernel_init+0x42/0xf0
[ 1136.236081]                       [<ffffffff817fa8fc>] ret_from_fork+0x7c/0xb0
[ 1136.236081]     SOFTIRQ-ON-W at:
[ 1136.236081]                       [<ffffffff810fd4eb>] __lock_acquire+0x58b/0x1ca0
[ 1136.236081]                       [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]                       [<ffffffff817f864e>] down_write+0x4e/0xc0
[ 1136.236081]                       [<ffffffff812485e8>] do_execve_common.isra.25+0x418/0x8f0
[ 1136.236081]                       [<ffffffff81248ad8>] do_execve+0x18/0x20
[ 1136.236081]                       [<ffffffff8100202b>] run_init_process+0x2b/0x30
[ 1136.236081]                       [<ffffffff817e0522>] kernel_init+0x42/0xf0
[ 1136.236081]                       [<ffffffff817fa8fc>] ret_from_fork+0x7c/0xb0
[ 1136.236081]     SOFTIRQ-ON-R at:
[ 1136.236081]                       [<ffffffff810fd4eb>] __lock_acquire+0x58b/0x1ca0
[ 1136.236081]                       [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]                       [<ffffffff811ea5ec>] might_fault+0x8c/0xb0
[ 1136.236081]                       [<ffffffff813e1d47>] __clear_user+0x17/0x60
[ 1136.236081]                       [<ffffffff813e1dbf>] clear_user+0x2f/0x40
[ 1136.236081]                       [<ffffffff817ef0c1>] padzero+0x23/0x30
[ 1136.236081]                       [<ffffffff812a0ffe>] load_elf_binary+0x9ee/0x18e0
[ 1136.236081]                       [<ffffffff812474d4>] search_binary_handler+0x94/0x1b0
[ 1136.236081]                       [<ffffffff81248841>] do_execve_common.isra.25+0x671/0x8f0
[ 1136.236081]                       [<ffffffff81248ad8>] do_execve+0x18/0x20
[ 1136.236081]                       [<ffffffff8100202b>] run_init_process+0x2b/0x30
[ 1136.236081]                       [<ffffffff817e0522>] kernel_init+0x42/0xf0
[ 1136.236081]                       [<ffffffff817fa8fc>] ret_from_fork+0x7c/0xb0
[ 1136.236081]     RECLAIM_FS-ON-W at:
[ 1136.236081]                          [<ffffffff810fc9b5>] mark_held_locks+0x75/0xa0
[ 1136.236081]                          [<ffffffff810ffdea>] lockdep_trace_alloc+0x7a/0xe0
[ 1136.236081]                          [<ffffffff811c6560>] __alloc_pages_nodemask+0xa0/0xcd0
[ 1136.236081]                          [<ffffffff8120f33a>] alloc_pages_current+0x11a/0x1f0
[ 1136.236081]                          [<ffffffff810686c7>] pte_alloc_one+0x17/0x80
[ 1136.236081]                          [<ffffffff811eb493>] __pte_alloc+0x23/0x180
[ 1136.236081]                          [<ffffffff811f7eea>] move_page_tables+0x58a/0x730
[ 1136.236081]                          [<ffffffff8124662c>] shift_arg_pages+0xcc/0x1e0
[ 1136.236081]                          [<ffffffff8124694b>] setup_arg_pages+0x20b/0x240
[ 1136.236081]                          [<ffffffff812a0a3e>] load_elf_binary+0x42e/0x18e0
[ 1136.236081]                          [<ffffffff812474d4>] search_binary_handler+0x94/0x1b0
[ 1136.236081]                          [<ffffffff81248841>] do_execve_common.isra.25+0x671/0x8f0
[ 1136.236081]                          [<ffffffff81248ad8>] do_execve+0x18/0x20
[ 1136.236081]                          [<ffffffff8100202b>] run_init_process+0x2b/0x30
[ 1136.236081]                          [<ffffffff817e0522>] kernel_init+0x42/0xf0
[ 1136.236081]                          [<ffffffff817fa8fc>] ret_from_fork+0x7c/0xb0
[ 1136.236081]     RECLAIM_FS-ON-R at:
[ 1136.236081]                          [<ffffffff810fc9b5>] mark_held_locks+0x75/0xa0
[ 1136.236081]                          [<ffffffff810ffdea>] lockdep_trace_alloc+0x7a/0xe0
[ 1136.236081]                          [<ffffffff811c6560>] __alloc_pages_nodemask+0xa0/0xcd0
[ 1136.236081]                          [<ffffffff8120f33a>] alloc_pages_current+0x11a/0x1f0
[ 1136.236081]                          [<ffffffff811edc94>] __pmd_alloc+0x24/0x1c0
[ 1136.236081]                          [<ffffffff811ef779>] handle_mm_fault+0xf19/0x10d0
[ 1136.236081]                          [<ffffffff810633d1>] __do_page_fault+0x201/0x5f0
[ 1136.236081]                          [<ffffffff81063827>] trace_do_page_fault+0x37/0x230
[ 1136.236081]                          [<ffffffff8105ed88>] do_async_page_fault+0x28/0xa0
[ 1136.236081]                          [<ffffffff817fcae8>] async_page_fault+0x28/0x30
[ 1136.236081]                          [<ffffffff813e1dbf>] clear_user+0x2f/0x40
[ 1136.236081]                          [<ffffffff817ef0c1>] padzero+0x23/0x30
[ 1136.236081]                          [<ffffffff812a0ffe>] load_elf_binary+0x9ee/0x18e0
[ 1136.236081]                          [<ffffffff812474d4>] search_binary_handler+0x94/0x1b0
[ 1136.236081]                          [<ffffffff81248841>] do_execve_common.isra.25+0x671/0x8f0
[ 1136.236081]                          [<ffffffff81248ad8>] do_execve+0x18/0x20
[ 1136.236081]                          [<ffffffff8100202b>] run_init_process+0x2b/0x30
[ 1136.236081]                          [<ffffffff817e0522>] kernel_init+0x42/0xf0
[ 1136.236081]                          [<ffffffff817fa8fc>] ret_from_fork+0x7c/0xb0
[ 1136.236081]     INITIAL USE at:
[ 1136.236081]                      [<ffffffff810fd26a>] __lock_acquire+0x30a/0x1ca0
[ 1136.236081]                      [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]                      [<ffffffff817f864e>] down_write+0x4e/0xc0
[ 1136.236081]                      [<ffffffff812485e8>] do_execve_common.isra.25+0x418/0x8f0
[ 1136.236081]                      [<ffffffff81248ad8>] do_execve+0x18/0x20
[ 1136.236081]                      [<ffffffff8100202b>] run_init_process+0x2b/0x30
[ 1136.236081]                      [<ffffffff817e0522>] kernel_init+0x42/0xf0
[ 1136.236081]                      [<ffffffff817fa8fc>] ret_from_fork+0x7c/0xb0
[ 1136.236081]   }
[ 1136.236081]   ... key      at: [<ffffffff823ff490>] __key.51205+0x0/0x8
[ 1136.236081]   ... acquired at:
[ 1136.236081]    [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]    [<ffffffff811ea5ec>] might_fault+0x8c/0xb0
[ 1136.236081]    [<ffffffff81256001>] filldir+0x91/0x120
[ 1136.236081]    [<ffffffffa03084e8>] xfs_dir2_sf_getdents.isra.11+0x208/0x270 [xfs]
[ 1136.236081]    [<ffffffffa03089b6>] xfs_readdir+0x1e6/0x250 [xfs]
[ 1136.236081]    [<ffffffffa030b03b>] xfs_file_readdir+0x2b/0x40 [xfs]
[ 1136.236081]    [<ffffffff81255dee>] iterate_dir+0xae/0x140
[ 1136.236081]    [<ffffffff8125630a>] SyS_getdents+0x9a/0x130
[ 1136.236081]    [<ffffffff817fa9a9>] system_call_fastpath+0x16/0x1b

[ 1136.236081] -> (&xfs_dir_ilock_class){++++-+} ops: 130281 {
[ 1136.236081]    HARDIRQ-ON-W at:
[ 1136.236081]                     [<ffffffff810fd5d0>] __lock_acquire+0x670/0x1ca0
[ 1136.236081]                     [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]                     [<ffffffff810f8494>] down_write_nested+0x54/0xd0
[ 1136.236081]                     [<ffffffffa035e1a5>] xfs_ilock+0xd5/0x1c0 [xfs]
[ 1136.236081]                     [<ffffffffa0317df5>] xfs_setattr_nonsize+0x225/0x630 [xfs]
[ 1136.236081]                     [<ffffffffa03186a9>] xfs_vn_setattr+0x29/0x70 [xfs]
[ 1136.236081]                     [<ffffffff81260d31>] notify_change+0x241/0x390
[ 1136.236081]                     [<ffffffff8123d6c6>] chmod_common+0x96/0x150
[ 1136.236081]                     [<ffffffff8123efc7>] SyS_fchmodat+0x57/0xc0
[ 1136.236081]                     [<ffffffff817fa9a9>] system_call_fastpath+0x16/0x1b
[ 1136.236081]    HARDIRQ-ON-R at:
[ 1136.236081]                     [<ffffffff810fd4ba>] __lock_acquire+0x55a/0x1ca0
[ 1136.236081]                     [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]                     [<ffffffff810f83f7>] down_read_nested+0x57/0xa0
[ 1136.236081]                     [<ffffffffa035e1c2>] xfs_ilock+0xf2/0x1c0 [xfs]
[ 1136.236081]                     [<ffffffffa035e2af>] xfs_ilock_data_map_shared+0x1f/0x40 [xfs]
[ 1136.236081]                     [<ffffffffa035f918>] xfs_lookup+0x108/0x1f0 [xfs]
[ 1136.236081]                     [<ffffffffa0316fbb>] xfs_vn_lookup+0x7b/0xd0 [xfs]
[ 1136.236081]                     [<ffffffff8124a8dd>] lookup_real+0x1d/0x50
[ 1136.236081]                     [<ffffffff8124b092>] __lookup_hash+0x42/0x60
[ 1136.236081]                     [<ffffffff8124ef5e>] lookup_one_len+0xee/0x140
[ 1136.236081]                     [<ffffffffa018f763>] nfsd_lookup_dentry+0x133/0x4c0 [nfsd]
[ 1136.236081]                     [<ffffffffa018fb79>] nfsd_lookup+0x89/0x150 [nfsd]
[ 1136.236081]                     [<ffffffffa019dc6a>] nfsd4_lookup+0x1a/0x20 [nfsd]
[ 1136.236081]                     [<ffffffffa01a0507>] nfsd4_proc_compound+0x4e7/0x800 [nfsd]
[ 1136.236081]                     [<ffffffffa0189edb>] nfsd_dispatch+0xbb/0x200 [nfsd]
[ 1136.236081]                     [<ffffffffa0100ba3>] svc_process_common+0x453/0x6f0 [sunrpc]
[ 1136.236081]                     [<ffffffffa0100f47>] svc_process+0x107/0x170 [sunrpc]
[ 1136.236081]                     [<ffffffffa0189263>] nfsd+0xe3/0x170 [nfsd]
[ 1136.236081]                     [<ffffffff810c710f>] kthread+0xff/0x120
[ 1136.236081]                     [<ffffffff817fa8fc>] ret_from_fork+0x7c/0xb0
[ 1136.236081]    SOFTIRQ-ON-W at:
[ 1136.236081]                     [<ffffffff810fd4eb>] __lock_acquire+0x58b/0x1ca0
[ 1136.236081]                     [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]                     [<ffffffff810f8494>] down_write_nested+0x54/0xd0
[ 1136.236081]                     [<ffffffffa035e1a5>] xfs_ilock+0xd5/0x1c0 [xfs]
[ 1136.236081]                     [<ffffffffa0317df5>] xfs_setattr_nonsize+0x225/0x630 [xfs]
[ 1136.236081]                     [<ffffffffa03186a9>] xfs_vn_setattr+0x29/0x70 [xfs]
[ 1136.236081]                     [<ffffffff81260d31>] notify_change+0x241/0x390
[ 1136.236081]                     [<ffffffff8123d6c6>] chmod_common+0x96/0x150
[ 1136.236081]                     [<ffffffff8123efc7>] SyS_fchmodat+0x57/0xc0
[ 1136.236081]                     [<ffffffff817fa9a9>] system_call_fastpath+0x16/0x1b
[ 1136.236081]    SOFTIRQ-ON-R at:
[ 1136.236081]                     [<ffffffff810fd4eb>] __lock_acquire+0x58b/0x1ca0
[ 1136.236081]                     [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]                     [<ffffffff810f83f7>] down_read_nested+0x57/0xa0
[ 1136.236081]                     [<ffffffffa035e1c2>] xfs_ilock+0xf2/0x1c0 [xfs]
[ 1136.236081]                     [<ffffffffa035e2af>] xfs_ilock_data_map_shared+0x1f/0x40 [xfs]
[ 1136.236081]                     [<ffffffffa035f918>] xfs_lookup+0x108/0x1f0 [xfs]
[ 1136.236081]                     [<ffffffffa0316fbb>] xfs_vn_lookup+0x7b/0xd0 [xfs]
[ 1136.236081]                     [<ffffffff8124a8dd>] lookup_real+0x1d/0x50
[ 1136.236081]                     [<ffffffff8124b092>] __lookup_hash+0x42/0x60
[ 1136.236081]                     [<ffffffff8124ef5e>] lookup_one_len+0xee/0x140
[ 1136.236081]                     [<ffffffffa018f763>] nfsd_lookup_dentry+0x133/0x4c0 [nfsd]
[ 1136.236081]                     [<ffffffffa018fb79>] nfsd_lookup+0x89/0x150 [nfsd]
[ 1136.236081]                     [<ffffffffa019dc6a>] nfsd4_lookup+0x1a/0x20 [nfsd]
[ 1136.236081]                     [<ffffffffa01a0507>] nfsd4_proc_compound+0x4e7/0x800 [nfsd]
[ 1136.236081]                     [<ffffffffa0189edb>] nfsd_dispatch+0xbb/0x200 [nfsd]
[ 1136.236081]                     [<ffffffffa0100ba3>] svc_process_common+0x453/0x6f0 [sunrpc]
[ 1136.236081]                     [<ffffffffa0100f47>] svc_process+0x107/0x170 [sunrpc]
[ 1136.236081]                     [<ffffffffa0189263>] nfsd+0xe3/0x170 [nfsd]
[ 1136.236081]                     [<ffffffff810c710f>] kthread+0xff/0x120
[ 1136.236081]                     [<ffffffff817fa8fc>] ret_from_fork+0x7c/0xb0
[ 1136.236081]    IN-RECLAIM_FS-W at:
[ 1136.236081]                        [<ffffffff810fd44c>] __lock_acquire+0x4ec/0x1ca0
[ 1136.236081]                        [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]                        [<ffffffff810f8494>] down_write_nested+0x54/0xd0
[ 1136.236081]                        [<ffffffffa035e1a5>] xfs_ilock+0xd5/0x1c0 [xfs]
[ 1136.236081]                        [<ffffffffa0310125>] xfs_reclaim_inode+0x115/0x360 [xfs]
[ 1136.236081]                        [<ffffffffa0310657>] xfs_reclaim_inodes_ag+0x2e7/0x510 [xfs]
[ 1136.236081]                        [<ffffffffa0311aa3>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
[ 1136.236081]                        [<ffffffffa031d615>] xfs_fs_free_cached_objects+0x15/0x20 [xfs]
[ 1136.236081]                        [<ffffffff812443dc>] super_cache_scan+0x16c/0x180
[ 1136.236081]                        [<ffffffff811d0b4b>] shrink_slab_node+0x14b/0x430
[ 1136.236081]                        [<ffffffff811d0eee>] shrink_slab+0x8e/0x180
[ 1136.236081]                        [<ffffffff811d3ddd>] kswapd_shrink_zone+0x14d/0x1f0
[ 1136.236081]                        [<ffffffff811d54b1>] balance_pgdat+0x2e1/0x4a0
[ 1136.236081]                        [<ffffffff811d5821>] kswapd+0x1b1/0x640
[ 1136.236081]                        [<ffffffff810c710f>] kthread+0xff/0x120
[ 1136.236081]                        [<ffffffff817fa8fc>] ret_from_fork+0x7c/0xb0
[ 1136.236081]    RECLAIM_FS-ON-R at:
[ 1136.236081]                        [<ffffffff810fc9b5>] mark_held_locks+0x75/0xa0
[ 1136.236081]                        [<ffffffff810ffdea>] lockdep_trace_alloc+0x7a/0xe0
[ 1136.236081]                        [<ffffffff811c6560>] __alloc_pages_nodemask+0xa0/0xcd0
[ 1136.236081]                        [<ffffffff81211995>] alloc_pages_vma+0x105/0x1d0
[ 1136.236081]                        [<ffffffff811ef544>] handle_mm_fault+0xce4/0x10d0
[ 1136.236081]                        [<ffffffff810633d1>] __do_page_fault+0x201/0x5f0
[ 1136.236081]                        [<ffffffff81063827>] trace_do_page_fault+0x37/0x230
[ 1136.236081]                        [<ffffffff8105ed88>] do_async_page_fault+0x28/0xa0
[ 1136.236081]                        [<ffffffff817fcae8>] async_page_fault+0x28/0x30
[ 1136.236081]                        [<ffffffffa030870e>] xfs_dir2_block_getdents.isra.12+0x1be/0x220 [xfs]
[ 1136.236081]                        [<ffffffffa030896f>] xfs_readdir+0x19f/0x250 [xfs]
[ 1136.236081]                        [<ffffffffa030b03b>] xfs_file_readdir+0x2b/0x40 [xfs]
[ 1136.236081]                        [<ffffffff81255dee>] iterate_dir+0xae/0x140
[ 1136.236081]                        [<ffffffff8125630a>] SyS_getdents+0x9a/0x130
[ 1136.236081]                        [<ffffffff817fa9a9>] system_call_fastpath+0x16/0x1b
[ 1136.236081]    INITIAL USE at:
[ 1136.236081]                    [<ffffffff810fd26a>] __lock_acquire+0x30a/0x1ca0
[ 1136.236081]                    [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]                    [<ffffffff810f8494>] down_write_nested+0x54/0xd0
[ 1136.236081]                    [<ffffffffa035e1a5>] xfs_ilock+0xd5/0x1c0 [xfs]
[ 1136.236081]                    [<ffffffffa0317df5>] xfs_setattr_nonsize+0x225/0x630 [xfs]
[ 1136.236081]                    [<ffffffffa03186a9>] xfs_vn_setattr+0x29/0x70 [xfs]
[ 1136.236081]                    [<ffffffff81260d31>] notify_change+0x241/0x390
[ 1136.236081]                    [<ffffffff8123d6c6>] chmod_common+0x96/0x150
[ 1136.236081]                    [<ffffffff8123efc7>] SyS_fchmodat+0x57/0xc0
[ 1136.236081]                    [<ffffffff817fa9a9>] system_call_fastpath+0x16/0x1b
[ 1136.236081]  }
[ 1136.236081]  ... key      at: [<ffffffffa03bcc68>] xfs_dir_ilock_class+0x0/0xfffffffffffcf398 [xfs]
[ 1136.236081]  ... acquired at:
[ 1136.236081]    [<ffffffff810fbfca>] check_usage_forwards+0x16a/0x180
[ 1136.236081]    [<ffffffff810fc837>] mark_lock+0x1a7/0x2b0
[ 1136.236081]    [<ffffffff810fd44c>] __lock_acquire+0x4ec/0x1ca0
[ 1136.236081]    [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]    [<ffffffff810f8494>] down_write_nested+0x54/0xd0
[ 1136.236081]    [<ffffffffa035e1a5>] xfs_ilock+0xd5/0x1c0 [xfs]
[ 1136.236081]    [<ffffffffa0310125>] xfs_reclaim_inode+0x115/0x360 [xfs]
[ 1136.236081]    [<ffffffffa0310657>] xfs_reclaim_inodes_ag+0x2e7/0x510 [xfs]
[ 1136.236081]    [<ffffffffa0311aa3>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
[ 1136.236081]    [<ffffffffa031d615>] xfs_fs_free_cached_objects+0x15/0x20 [xfs]
[ 1136.236081]    [<ffffffff812443dc>] super_cache_scan+0x16c/0x180
[ 1136.236081]    [<ffffffff811d0b4b>] shrink_slab_node+0x14b/0x430
[ 1136.236081]    [<ffffffff811d0eee>] shrink_slab+0x8e/0x180
[ 1136.236081]    [<ffffffff811d3ddd>] kswapd_shrink_zone+0x14d/0x1f0
[ 1136.236081]    [<ffffffff811d54b1>] balance_pgdat+0x2e1/0x4a0
[ 1136.236081]    [<ffffffff811d5821>] kswapd+0x1b1/0x640
[ 1136.236081]    [<ffffffff810c710f>] kthread+0xff/0x120
[ 1136.236081]    [<ffffffff817fa8fc>] ret_from_fork+0x7c/0xb0

[ 1136.236081] 
stack backtrace:
[ 1136.236081] CPU: 2 PID: 53 Comm: kswapd0 Tainted: G           OE 3.16.0-rc2.jlayton.2+ #9
[ 1136.236081] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1136.236081]  0000000000000000 0000000044b6ed70 ffff8801186fb5e8 ffffffff817f06ad
[ 1136.236081]  ffffffff82fbb100 ffff8801186fb628 ffffffff817eb75c ffffffff81c62438
[ 1136.236081]  0000000000000000 ffff8801186f0c10 ffff8801186f0000 ffffffff81c62438
[ 1136.236081] Call Trace:
[ 1136.236081]  [<ffffffff817f06ad>] dump_stack+0x4d/0x66
[ 1136.236081]  [<ffffffff817eb75c>] print_irq_inversion_bug.part.42+0x1ac/0x1b8
[ 1136.236081]  [<ffffffff810fbfca>] check_usage_forwards+0x16a/0x180
[ 1136.236081]  [<ffffffff810fbe60>] ? check_usage_backwards+0x180/0x180
[ 1136.236081]  [<ffffffff810fc837>] mark_lock+0x1a7/0x2b0
[ 1136.236081]  [<ffffffff810fd44c>] __lock_acquire+0x4ec/0x1ca0
[ 1136.236081]  [<ffffffff810fcae5>] ? trace_hardirqs_on_caller+0x105/0x1d0
[ 1136.236081]  [<ffffffff810fcbbd>] ? trace_hardirqs_on+0xd/0x10
[ 1136.236081]  [<ffffffff810ff3f2>] lock_acquire+0xa2/0x1d0
[ 1136.236081]  [<ffffffffa035e1a5>] ? xfs_ilock+0xd5/0x1c0 [xfs]
[ 1136.236081]  [<ffffffffa0310125>] ? xfs_reclaim_inode+0x115/0x360 [xfs]
[ 1136.236081]  [<ffffffff810f8494>] down_write_nested+0x54/0xd0
[ 1136.236081]  [<ffffffffa035e1a5>] ? xfs_ilock+0xd5/0x1c0 [xfs]
[ 1136.236081]  [<ffffffffa035e1a5>] xfs_ilock+0xd5/0x1c0 [xfs]
[ 1136.236081]  [<ffffffffa0310125>] xfs_reclaim_inode+0x115/0x360 [xfs]
[ 1136.236081]  [<ffffffffa0310657>] xfs_reclaim_inodes_ag+0x2e7/0x510 [xfs]
[ 1136.236081]  [<ffffffffa0310468>] ? xfs_reclaim_inodes_ag+0xf8/0x510 [xfs]
[ 1136.236081]  [<ffffffff810fc9b5>] ? mark_held_locks+0x75/0xa0
[ 1136.236081]  [<ffffffff817f9ba6>] ? _raw_spin_unlock_irqrestore+0x36/0x70
[ 1136.236081]  [<ffffffff810fcae5>] ? trace_hardirqs_on_caller+0x105/0x1d0
[ 1136.236081]  [<ffffffff810fcbbd>] ? trace_hardirqs_on+0xd/0x10
[ 1136.236081]  [<ffffffff810dbad3>] ? try_to_wake_up+0x103/0x3e0
[ 1136.236081]  [<ffffffff810dbdd3>] ? wake_up_process+0x23/0x40
[ 1136.236081]  [<ffffffffa0311aa3>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
[ 1136.236081]  [<ffffffffa031d615>] xfs_fs_free_cached_objects+0x15/0x20 [xfs]
[ 1136.236081]  [<ffffffff812443dc>] super_cache_scan+0x16c/0x180
[ 1136.236081]  [<ffffffff811d0b4b>] shrink_slab_node+0x14b/0x430
[ 1136.236081]  [<ffffffff811d0e9f>] ? shrink_slab+0x3f/0x180
[ 1136.236081]  [<ffffffff811d0eee>] shrink_slab+0x8e/0x180
[ 1136.236081]  [<ffffffff811d3ddd>] kswapd_shrink_zone+0x14d/0x1f0
[ 1136.236081]  [<ffffffff811d54b1>] balance_pgdat+0x2e1/0x4a0
[ 1136.236081]  [<ffffffff811d5821>] kswapd+0x1b1/0x640
[ 1136.236081]  [<ffffffff810f2f20>] ? abort_exclusive_wait+0xb0/0xb0
[ 1136.236081]  [<ffffffff811d5670>] ? balance_pgdat+0x4a0/0x4a0
[ 1136.236081]  [<ffffffff810c710f>] kthread+0xff/0x120
[ 1136.236081]  [<ffffffff810c7010>] ? insert_kthread_work+0x80/0x80
[ 1136.236081]  [<ffffffff817fa8fc>] ret_from_fork+0x7c/0xb0
[ 1136.236081]  [<ffffffff810c7010>] ? insert_kthread_work+0x80/0x80


-- 
Jeff Layton <jlayton@primarydata.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
