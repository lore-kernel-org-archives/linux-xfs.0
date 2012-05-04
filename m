Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q44LtNaZ094652 for <xfs@oss.sgi.com>; Fri, 4 May 2012 16:55:23 -0500
Received: from mail-qa0-f46.google.com (mail-qa0-f46.google.com
	[209.85.216.46]) by cuda.sgi.com with ESMTP id j72P5VaAZli2hqgo
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 May 2012 14:55:22 -0700 (PDT)
Received: by qadb17 with SMTP id b17so1660676qad.5
	for <xfs@oss.sgi.com>; Fri, 04 May 2012 14:55:21 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 4 May 2012 17:55:21 -0400
Message-ID: <CAH4wwdHb0=9UtTiwz-fAYovXGO6J8soda31S+dgCGNKBA3j5sw@mail.gmail.com>
Subject: deadlock below xfs_ialloc, when radix_tree_preload goes into reclaim?
From: Peter Watkins <treestem@gmail.com>
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
To: xfs@oss.sgi.com

Greetings,

Anyone seen a deadlock like the one below? It's a 17TB system with 32
bit inodes and it's doing lots of inode allocations at the same time.
So you might consider it a stress test for inode alloc activity on a
single AG.

xfs_ialloc called xfs_dialloc and got the agi header buf, then it
called xfs_iget which went into reclaim during radix_tree_preload.
While trying to shrink the inode cache, xfs_iunlink_remove tries to
get the same agi header buf.

With 64 bit inodes you'd be less likely to hit this path, but it's
still possible, no?

Should this call to radix_tree_preload use GFP_NOFS? The code base is
old, but the same elements of the deadlock still seem to be there in
the upstream code ... though I may be missing something there.

Oh, some caveats: yes, it's an ancient 2.6.27 kernel, no I don't have
a handy reproducer (I could try to create one), and yes I really am
trying to switch to 64b inodes.

-Peter



 #0 [ffff88021bc030c8] schedule at ffffffff804fa2ee
 #1 [ffff88021bc03170] schedule_timeout at ffffffff804faddb
 #2 [ffff88021bc031e0] __down at ffffffff804fb9b1
 #3 [ffff88021bc03230] down at ffffffff80265cab
 #4 [ffff88021bc03250] xfs_buf_lock at ffffffffa04cbd98
 #5 [ffff88021bc03270] _xfs_buf_find at ffffffffa04cbed4
 #6 [ffff88021bc032c0] xfs_buf_get_flags at ffffffffa04cd642
 #7 [ffff88021bc03300] xfs_buf_read_flags at ffffffffa04cd76b
 #8 [ffff88021bc03320] xfs_trans_read_buf at ffffffffa04c186f
 #9 [ffff88021bc03370] xfs_iunlink_remove at ffffffffa04aa809
 <=== wants agi buffer for lock ordering
#10 [ffff88021bc03410] xfs_ifree at ffffffffa04aab27
#11 [ffff88021bc03470] xfs_inactive at ffffffffa04c5653
#12 [ffff88021bc034c0] xfs_fs_clear_inode at ffffffffa04d48c8
#13 [ffff88021bc034f0] clear_inode at ffffffff802f26f5
#14 [ffff88021bc03510] generic_delete_inode at ffffffff802f2d1f
#15 [ffff88021bc03540] generic_drop_inode at ffffffff802f2e47
#16 [ffff88021bc03560] iput at ffffffff802f2f6b
#18 [ffff88021bc035c0] clear_inode at ffffffff802f26f5
#19 [ffff88021bc035e0] dispose_list at ffffffff802f2780
#20 [ffff88021bc03620] shrink_icache_memory at ffffffff802f30a4
#21 [ffff88021bc03680] shrink_slab at ffffffff802adff7
#22 [ffff88021bc036d0] zone_reclaim at ffffffff802b0913
<=== uh oh, memory reclaim!
#23 [ffff88021bc03770] get_page_from_freelist at ffffffff802a8944
#24 [ffff88021bc03850] __alloc_pages_internal at ffffffff802a8e3d
#25 [ffff88021bc038d0] alloc_pages_current at ffffffff802cb2dd
#26 [ffff88021bc03900] new_slab at ffffffff802d2190
#27 [ffff88021bc03940] __slab_alloc at ffffffff802d27e2
#28 [ffff88021bc039a0] kmem_cache_alloc at ffffffff802d2cd4
#29 [ffff88021bc039e0] radix_tree_preload at ffffffff8039c5e1
 <=== should be GFP_NOFS instead of GFP_KERNEL ?
#30 [ffff88021bc03a10] xfs_iget_core at ffffffffa04a7b9b
#31 [ffff88021bc03a90] xfs_iget at ffffffffa04a80e0
#32 [ffff88021bc03af0] xfs_trans_iget at ffffffffa04c1f82
#33 [ffff88021bc03b40] xfs_ialloc at ffffffffa04a9132
 <=== calling ialloc after dialloc, holds buf_lock for agi header !
#34 [ffff88021bc03be0] xfs_dir_ialloc at ffffffffa04c28f5
#35 [ffff88021bc03ca0] xfs_create at ffffffffa04c5bdd
#36 [ffff88021bc03d70] xfs_vn_mknod at ffffffffa04d12d1
#37 [ffff88021bc03dd0] xfs_vn_create at ffffffffa04d13b0
#38 [ffff88021bc03de0] vfs_create at ffffffff802e6adb
#39 [ffff88021bc03e20] do_filp_open at ffffffff802e7123
#40 [ffff88021bc03eb0] expand_files at ffffffff802f4cf1
#41 [ffff88021bc03ef0] alloc_fd at ffffffff802f52f8
#42 [ffff88021bc03f30] do_sys_open at ffffffff802db5c8
#43 [ffff88021bc03f70] compat_sys_open at ffffffff80314caa

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
