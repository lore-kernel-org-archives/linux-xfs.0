Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:12998 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750761AbeCZEfG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Mar 2018 00:35:06 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] fs: don't scan the inode cache before SB_ACTIVE is set
Date: Mon, 26 Mar 2018 15:35:03 +1100
Message-Id: <20180326043503.17828-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We recently had an oops reported on a 4.14 kernel in
xfs_reclaim_inodes_count() where sb->s_fs_info pointed to garbage
and so the m_perag_tree lookup walked into lala land.

We found a mount in a failed state, blocked on teh shrinker rwsem
here:

mount_bdev()
  deactivate_locked_super()
    unregister_shrinker()

Essentially, the machine was under memory pressure when the mount
was being run, xfs_fs_fill_super() failed after allocating the
xfs_mount and attaching it to sb->s_fs_info. It then cleaned up and
freed the xfs_mount, but the sb->s_fs_info field still pointed to
the freed memory. Hence when the superblock shrinker then ran
it fell off the bad pointer.

This is reproduced by using the mount_delay sysfs control as added
in teh previous patch. It produces an oops down this path during the
stalled mount:

  radix_tree_gang_lookup_tag+0xc4/0x130
  xfs_perag_get_tag+0x37/0xf0
  xfs_reclaim_inodes_count+0x32/0x40
  xfs_fs_nr_cached_objects+0x11/0x20
  super_cache_count+0x35/0xc0
  shrink_slab.part.66+0xb1/0x370
  shrink_node+0x7e/0x1a0
  try_to_free_pages+0x199/0x470
  __alloc_pages_slowpath+0x3a1/0xd20
  __alloc_pages_nodemask+0x1c3/0x200
  cache_grow_begin+0x20b/0x2e0
  fallback_alloc+0x160/0x200
  kmem_cache_alloc+0x111/0x4e0

The problem is that the superblock shrinker is running before the
filesystem structures it depends on have been fully set up. i.e.
the shrinker is registered in sget(), before ->fill_super() has been
called, and the shrinker can call into the filesystem before
fill_super() does it's setup work.

Setting sb->s_fs_info to NULL on xfs_mount setup failure only solves
the use-after-free part of the problem - it doesn't solve the
use-before-initialisation part of the problem. Hence we need a more
robust solution.

That is done by checking the SB_ACTIVE flag in super_cache_count.
In general, this flag is not set until ->fill_super() completes
successfully, so the VFS assumes that it is set after the filesystem
setup has completed. It is also cleared before ->put_super is
called. This means we can use this flag to prevent the superblock
shrinker from entering the filesystem while it is being set up or
torn down, thereby completely avoiding the cases where the shrinker
would run on a filesystem of unknown state.

THere are some corner cases where filesystems set SB_ACTIVE
themselves during ->fill_super. This is done when they require
iput_final to put inodes on the LRU for caching during mount
(usually log recovery). This requires filesystems to have set up all
the state the need before they set the SB_ACTIVE flag themselves.
XFS does this, so there are no further changes necessary for the
XFS issue to be solved.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/super.c         | 25 +++++++++++++++++++------
 fs/xfs/xfs_super.c | 11 +++++++++++
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 672538ca9831..2e398e429f55 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -120,13 +120,26 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 	sb = container_of(shrink, struct super_block, s_shrink);
 
 	/*
-	 * Don't call trylock_super as it is a potential
-	 * scalability bottleneck. The counts could get updated
-	 * between super_cache_count and super_cache_scan anyway.
-	 * Call to super_cache_count with shrinker_rwsem held
-	 * ensures the safety of call to list_lru_shrink_count() and
-	 * s_op->nr_cached_objects().
+	 * If we are currently mounting or unmounting the superblock, the
+	 * underlying filesystem might be in a state of partial construction or
+	 * deconstructions, and hence it is dangerous to access it.
+	 *
+	 * We don't call trylock_super() as it has proven to be a scalability
+	 * bottleneck, and the shrinker rwsem does not protect filesystem
+	 * operations backing list_lru_shrink_count() or
+	 * s_op->nr_cached_objects() during filesystem setup or teardown.  The
+	 * counts could get updated between super_cache_count and
+	 * super_cache_scan anyway, so we really don't need locks here.
+	 *
+	 * Hence we need some other mechanism to avoid filesysetms during setup
+	 * and teardown. We can use the SB_ACTIVE flag for that - it is only set
+	 * after ->fill_super has set up the filesystem fully, and it is cleared
+	 * before ->put_super starts tearing it down.
+	 *
 	 */
+	if (!(sb->s_flags & SB_ACTIVE))
+		return 0;
+
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ee26437dc567..41ce7236f6ea 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1755,6 +1755,8 @@ xfs_fs_fill_super(
  out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
+	sb->s_fs_info = NULL;
+	sb->s_op = NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
  out:
@@ -1781,6 +1783,9 @@ xfs_fs_put_super(
 	xfs_destroy_percpu_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
+
+	sb->s_fs_info = NULL;
+	sb->s_op = NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
 }
@@ -1800,6 +1805,12 @@ xfs_fs_nr_cached_objects(
 	struct super_block	*sb,
 	struct shrink_control	*sc)
 {
+	/*
+	 * Don't do anything until the filesystem is fully set up, or in the
+	 * process of being torn down due to a mount failure.
+	 */
+	if (!sb->s_fs_info)
+		return 0;
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
 
-- 
2.16.1

