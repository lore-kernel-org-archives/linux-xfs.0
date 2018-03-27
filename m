Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:44727 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751859AbeC0G57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 02:57:59 -0400
Date: Tue, 27 Mar 2018 17:57:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH V2] fs: don't scan the inode cache before SB_BORN is set
Message-ID: <20180327065756.GO18129@dastard>
References: <20180326043503.17828-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326043503.17828-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>

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

That is done by checking the SB_BORN flag in super_cache_count.  In
general, this flag is not set until ->fs_mount() completes
successfully, so the VFS assumes that it is set after the filesystem
setup has completed. This matches the trylock_super() behaviour
which will not let super_cache_scan() run if SB_BORN is not set, and
hence will not allow the superblock shrinker from entering the
filesystem while it is being set up.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
Version 2:
- convert to use SB_BORN, not SB_ACTIVE
- add memory barriers
- rework comment in super_cache_count()

---
 fs/super.c         | 28 ++++++++++++++++++++++------
 fs/xfs/xfs_super.c | 11 +++++++++++
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 672538ca9831..ae886b2b5c51 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -120,13 +120,23 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 	sb = container_of(shrink, struct super_block, s_shrink);
 
 	/*
-	 * Don't call trylock_super as it is a potential
-	 * scalability bottleneck. The counts could get updated
-	 * between super_cache_count and super_cache_scan anyway.
-	 * Call to super_cache_count with shrinker_rwsem held
-	 * ensures the safety of call to list_lru_shrink_count() and
-	 * s_op->nr_cached_objects().
+	 * We don't call trylock_super() here as it is a scalability bottleneck,
+	 * so we're exposed to partial setup state. The shrinker rwsem does not
+	 * protect filesystem operations backing list_lru_shrink_count() or
+	 * s_op->nr_cached_objects(). Counts can change between
+	 * super_cache_count and super_cache_scan, so we really don't need locks
+	 * here.
+	 *
+	 * However, if we are currently mounting the superblock, the underlying
+	 * filesystem might be in a state of partial construction and hence it
+	 * is dangerous to access it.  trylock_super() uses a SB_BORN check to
+	 * avoid this situation, so do the same here. The memory barrier is
+	 * matched with the one in mount_fs() as we don't hold locks here.
 	 */
+	smp_rmb();
+	if (!(sb->s_flags & SB_BORN))
+		return 0;
+
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
@@ -1227,7 +1237,13 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 	sb = root->d_sb;
 	BUG_ON(!sb);
 	WARN_ON(!sb->s_bdi);
+
+	/*
+	 * Write barrier is for super_cache_count() to ensure it does not run
+	 * until after the superblock is fully set up.
+	 */
 	sb->s_flags |= SB_BORN;
+	smp_wmb();
 
 	error = security_sb_kern_mount(sb, flags, secdata);
 	if (error)
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
Dave Chinner
david@fromorbit.com
