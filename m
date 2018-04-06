Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52524 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbeDFQNy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Apr 2018 12:13:54 -0400
Date: Fri, 6 Apr 2018 09:13:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: reset xfs_inode struct on reclaim in debug mode
Message-ID: <20180406161348.GG7500@magnolia>
References: <20180405121147.60897-1-bfoster@redhat.com>
 <20180405211437.GD23861@dastard>
 <20180406132806.GA5189@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180406132806.GA5189@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Fri, Apr 06, 2018 at 09:28:07AM -0400, Brian Foster wrote:
> On Fri, Apr 06, 2018 at 07:14:37AM +1000, Dave Chinner wrote:
> > On Thu, Apr 05, 2018 at 08:11:46AM -0400, Brian Foster wrote:
> > > A test case to reproduce a filestream/MRU use-after-free of a
> > > reclaimed inode requires bits (e.g., ip->i_mount) of the inode to be
> > > reset/reused once the inode memory is freed. This normally only
> > > occurs when a new page is cycled into the zone, however.
> > > 
> > > Perform the "one-time" inode init immediately prior to freeing
> > > inodes when in DEBUG mode. This will zero the inode, init the low
> > > level structures (locks, lists, etc.) and otherwise ensure each
> > > inode is in a purely uninitialized state while sitting in the zone
> > > as free memory.
> > 
> > Does KASAN catch this use-after-free? i.e. Given that people
> > regularly run fstests with KASAN enabled, do we need to change the
> > code for the test to trigger detection?
> > 
> 
> I had tried with page poisoning without much luck, I suspect because my
> test doesn't involve cycling pages in and out of the kmem cache. I
> hadn't tried with KASAN though. I just gave it a try with my current
> test and it looks like it detected it[1]. I guess KASAN is doing some
> kind of higher level/out-of-band tracking of slab/cache objects that
> allows this to work.
> 
> So perhaps we don't need this patch after all... I'll just document in
> the test that KASAN may be necessary to reproduce the problem.
> 
> Brian
> 
> [1] KASAN splat:
> 
> [   66.389454] BUG: KASAN: use-after-free in xfs_fstrm_free_func+0x33/0x1b0 [xfs]
> [   66.390432] Read of size 8 at addr ffff8800b02dde40 by task rmdir/1939
> [   66.391268] 
> [   66.391470] CPU: 2 PID: 1939 Comm: rmdir Not tainted 4.16.0-rc5 #111
> [   66.392228] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011

Yay!  This'll make for a nice juicy commit log. :)

Ok, so at this point this series consists of Christoph's replacement for
patch 2, and a revision of this patch to memzero/init_once?

Hm, I wonder if there's a way to tell from sysfs if kasan is enabled.

--D

> [   66.392925] Call Trace:
> [   66.393243]  dump_stack+0x85/0xc0
> [   66.393683]  print_address_description+0x65/0x270
> [   66.394190]  kasan_report+0x253/0x380
> [   66.394681]  ? xfs_fstrm_free_func+0x33/0x1b0 [xfs]
> [   66.395352]  xfs_fstrm_free_func+0x33/0x1b0 [xfs]
> [   66.395987]  xfs_remove+0x60a/0x670 [xfs]
> [   66.396567]  ? xfs_iunpin_wait+0x30/0x30 [xfs]
> [   66.397077]  ? lock_acquire+0xc0/0x220
> [   66.397463]  ? d_walk+0x1b3/0x580
> [   66.397803]  ? do_raw_spin_unlock+0x8c/0x120
> [   66.398353]  xfs_vn_unlink+0xac/0x130 [xfs]
> [   66.398915]  ? xfs_vn_rename+0x230/0x230 [xfs]
> [   66.399369]  vfs_rmdir+0x12a/0x1e0
> [   66.399736]  do_rmdir+0x258/0x2c0
> [   66.400159]  ? user_path_create+0x30/0x30
> [   66.400622]  ? up_read+0x17/0x30
> [   66.400941]  ? __do_page_fault+0x64a/0x710
> [   66.401385]  ? mark_held_locks+0x1b/0xa0
> [   66.401766]  ? mark_held_locks+0x1b/0xa0
> [   66.402181]  ? do_syscall_64+0x39/0x310
> [   66.402592]  ? SyS_mkdir+0x170/0x170
> [   66.402938]  do_syscall_64+0xf1/0x310
> [   66.403352]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> [   66.403920] RIP: 0033:0x7fad1a8f4ec7
> [   66.404327] RSP: 002b:00007fffb10c8ca8 EFLAGS: 00000246 ORIG_RAX: 0000000000000054
> [   66.405173] RAX: ffffffffffffffda RBX: 00007fffb10cab1b RCX: 00007fad1a8f4ec7
> [   66.405864] RDX: 00007fad1abc4000 RSI: 0000000000000001 RDI: 00007fffb10cab1b
> [   66.406592] RBP: 00007fffb10c8dd8 R08: 0000000000000000 R09: 0000000000000000
> [   66.407332] R10: 0000564cf39f0010 R11: 0000000000000246 R12: 0000000000000002
> [   66.408090] R13: 00007fad1abc1344 R14: 0000000000000000 R15: 0000000000000000
> [   66.408819] 
> [   66.408977] Allocated by task 1929:
> [   66.409340]  kasan_kmalloc+0xa0/0xd0
> [   66.409732]  kmem_cache_alloc+0xe8/0x2e0
> [   66.410250]  kmem_zone_alloc+0x5e/0xf0 [xfs]
> [   66.410808]  xfs_inode_alloc+0x2d/0x2b0 [xfs]
> [   66.411358]  xfs_iget+0x616/0x1740 [xfs]
> [   66.411860]  xfs_ialloc+0x18b/0xb10 [xfs]
> [   66.412423]  xfs_dir_ialloc+0x21e/0x3f0 [xfs]
> [   66.413032]  xfs_create+0x7b4/0xb60 [xfs]
> [   66.413608]  xfs_generic_create+0x303/0x3f0 [xfs]
> [   66.414127]  vfs_mkdir+0x1d2/0x2e0
> [   66.414465]  SyS_mkdir+0xda/0x170
> [   66.414790]  do_syscall_64+0xf1/0x310
> [   66.415141]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> [   66.415636] 
> [   66.415790] Freed by task 0:
> [   66.416070]  __kasan_slab_free+0x136/0x180
> [   66.416467]  kmem_cache_free+0xc9/0x340
> [   66.416839]  rcu_process_callbacks+0x2ef/0x9c0
> [   66.417262]  __do_softirq+0x11a/0x5b9
> [   66.417654] 
> [   66.417878] The buggy address belongs to the object at ffff8800b02dde40
> [   66.417878]  which belongs to the cache xfs_inode of size 1696
> [   66.419219] The buggy address is located 0 bytes inside of
> [   66.419219]  1696-byte region [ffff8800b02dde40, ffff8800b02de4e0)
> [   66.420437] The buggy address belongs to the page:
> [   66.420948] page:ffffea0002c0b600 count:1 mapcount:0 mapping:0000000000000000 index:0x0 compound_mapcount: 0
> [   66.422024] flags: 0xfffffc0008100(slab|head)
> [   66.422466] raw: 000fffffc0008100 0000000000000000 0000000000000000 0000000180110011
> [   66.423223] raw: dead000000000100 dead000000000200 ffff8800c5207480 0000000000000000
> [   66.424013] page dumped because: kasan: bad access detected
> [   66.424602] 
> [   66.424895] Memory state around the buggy address:
> [   66.425369]  ffff8800b02ddd00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   66.426070]  ffff8800b02ddd80: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
> [   66.426815] >ffff8800b02dde00: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
> [   66.427632]                                            ^
> [   66.428213]  ffff8800b02dde80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [   66.428989]  ffff8800b02ddf00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [   66.429750] ==================================================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
