Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:46170 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753472AbeEJEjr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 00:39:47 -0400
Date: Thu, 10 May 2018 14:21:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v3] fs: don't scan the inode cache before SB_BORN is set
Message-ID: <20180510042132.GS23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>


From: Dave Chinner <dchinner@redhat.com>

We recently had an oops reported on a 4.14 kernel in
xfs_reclaim_inodes_count() where sb->s_fs_info pointed to garbage
and so the m_perag_tree lookup walked into lala land.

We found a mount in a failed state, blocked on the shrinker rwsem
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

However, we also saw another manifestation of the same problem - the
shrinker can fall off a bad pointer if it runs before the superblock
is fully set up - a use before initialisation problem. This
typically crashed somewhere in the radix tree manipulations in
this path:

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

The underlying problem is that the superblock shrinker is running
before the filesystem structures it depends on have been fully set
up. i.e.  the shrinker is registered in sget(), before
->fill_super() has been called, and the shrinker can call into the
filesystem before fill_super() does it's setup work.

Setting sb->s_fs_info to NULL on xfs_mount setup failure only solves
the use-after-free part of the problem - it doesn't solve the
use-before-initialisation part. To solve that we need to check the
SB_BORN flag in super_cache_count().

The SB_BORN flag is not set until ->fs_mount() completes
successfully and trylock_super() won't succeed until it is set.
Hence super_cache_scan() will not run until SB_BORN is set, so it
makes sense to not allow super_cache_scan to run and enter the
filesystem until it is set, too. This prevents the superblock
shrinker from entering the filesystem while it is being set up and
so avoids the use-before-initialisation issue.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
Version 3:
- change the memory barriers to protect the superblock data, not
  the SB_BORN flag.

Version 2:
- convert to use SB_BORN, not SB_ACTIVE
- add memory barriers
- rework comment in super_cache_count()

---
 fs/super.c         | 30 ++++++++++++++++++++++++------
 fs/xfs/xfs_super.c | 11 +++++++++++
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 122c402049a2..4b5b562176d0 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -121,13 +121,23 @@ static unsigned long super_cache_count(struct shrinker *shrink,
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
+	if (!(sb->s_flags & SB_BORN))
+		return 0;
+	smp_rmb();
+
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
@@ -1272,6 +1282,14 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 	sb = root->d_sb;
 	BUG_ON(!sb);
 	WARN_ON(!sb->s_bdi);
+
+	/*
+	 * Write barrier is for super_cache_count(). We place it before setting
+	 * SB_BORN as the data dependency between the two functions is the
+	 * superblock structure contents that we just set up, not the SB_BORN
+	 * flag.
+	 */
+	smp_wmb();
 	sb->s_flags |= SB_BORN;
 
 	error = security_sb_kern_mount(sb, flags, secdata);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a523eaeb3f29..005386f1499e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1772,6 +1772,8 @@ xfs_fs_fill_super(
  out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
+	sb->s_fs_info = NULL;
+	sb->s_op = NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
  out:
@@ -1798,6 +1800,9 @@ xfs_fs_put_super(
 	xfs_destroy_percpu_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
+
+	sb->s_fs_info = NULL;
+	sb->s_op = NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
 }
@@ -1817,6 +1822,12 @@ xfs_fs_nr_cached_objects(
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
 
