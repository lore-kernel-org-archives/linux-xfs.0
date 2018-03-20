Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32212 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751390AbeCTFA2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 01:00:28 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1ey9Nm-0001tJ-Gd
        for linux-xfs@vger.kernel.org; Tue, 20 Mar 2018 16:00:22 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90_1)
        (envelope-from <david@fromorbit.com>)
        id 1ey9Nm-0000JF-FZ
        for linux-xfs@vger.kernel.org; Tue, 20 Mar 2018 16:00:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: don't shrink the inode cache until after setup completes
Date: Tue, 20 Mar 2018 16:00:21 +1100
Message-Id: <20180320050021.982-3-david@fromorbit.com>
In-Reply-To: <20180320050021.982-1-david@fromorbit.com>
References: <20180320050021.982-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We recently came across an oops on a 4.14 kernel in
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

Setting sb->s_fs_info to NULL in this case won't solve the problem;
we'll still crash on a null pointer in xfs_reclaim_inodes_count().
The problem is that the superblock shrinker is running before the
filesystem structures it depends on have been fully set up. i.e.
the shrinker is registered in sget(), before ->fill_super() has been
called, and the shrinker can call into the filesystem before
fill_super() does it's setup work.

The twist here is that we need the sb shrinker to run in the XFS
mount process because of the memory pressure that log recovery and
quota check can create. Hence we need to prevent the indoe cache
scanning from occurring until after we've set up the per-ag
structures and caches that it depends on. We also need to ensure
that we clear the flag and sb->s_fs_info on failure so that we
can do the right thing in all cases in xfs_reclaim_inodes_count().

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c | 2 ++
 fs/xfs/xfs_mount.h | 1 +
 fs/xfs/xfs_super.c | 9 +++++++++
 3 files changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6f5a5e6764d8..35a263c90fc0 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -155,6 +155,7 @@ xfs_free_perag(
 	xfs_agnumber_t	agno;
 	struct xfs_perag *pag;
 
+	mp->m_flags &= ~XFS_MOUNT_PERAG_DONE;
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		spin_lock(&mp->m_perag_lock);
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
@@ -244,6 +245,7 @@ xfs_initialize_perag(
 		*maxagi = index;
 
 	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
+	mp->m_flags |= XFS_MOUNT_PERAG_DONE;
 	return 0;
 
 out_hash_destroy:
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1808f56decaa..3cf7309b615d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -239,6 +239,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
 						   allocator */
 #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
+#define XFS_MOUNT_PERAG_DONE	(1ULL << 26)	/* perag icache init done */
 
 #define XFS_MOUNT_DAX		(1ULL << 62)	/* TEST ONLY! */
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ee26437dc567..d3283e8c2ce2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1755,6 +1755,7 @@ xfs_fs_fill_super(
  out_close_devices:
 	xfs_close_devices(mp);
  out_free_fsname:
+	sb->s_fs_info = NULL;
 	xfs_free_fsname(mp);
 	kfree(mp);
  out:
@@ -1800,6 +1801,14 @@ xfs_fs_nr_cached_objects(
 	struct super_block	*sb,
 	struct shrink_control	*sc)
 {
+	/*
+	 * Don't do anything until the filesystem is fully set up, or in the
+	 * process of being torn down due to a mount failure.
+	 */
+	if (!sb->s_fs_info)
+		return 0;
+	if (!(XFS_M(sb)->m_flags & XFS_MOUNT_PERAG_DONE))
+		return 0;
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
 
-- 
2.16.1

