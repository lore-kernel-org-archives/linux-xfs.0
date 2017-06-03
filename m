Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48147 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751149AbdFCNTQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:19:16 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/25] xfs: support ability to wait on new inodes
Date: Sat,  3 Jun 2017 15:18:23 +0200
Message-Id: <20170603131836.26661-13-hch@lst.de>
In-Reply-To: <20170603131836.26661-1-hch@lst.de>
References: <20170603131836.26661-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Brian Foster <bfoster@redhat.com>

commit 756baca27fff3ecaeab9dbc7a5ee35a1d7bc0c7f upstream.

Inodes that are inserted into the perag tree but still under
construction are flagged with the XFS_INEW bit. Most contexts either
skip such inodes when they are encountered or have the ability to
handle them.

The runtime quotaoff sequence introduces a context that must wait
for construction of such inodes to correctly ensure that all dquots
in the fs are released. In anticipation of this, support the ability
to wait on new inodes. Wake the appropriate bit when XFS_INEW is
cleared.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c | 5 ++++-
 fs/xfs/xfs_inode.h  | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3fb1f3fb8efe..027cf8ba2235 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -368,14 +368,17 @@ xfs_iget_cache_hit(
 
 		error = xfs_reinit_inode(mp, inode);
 		if (error) {
+			bool wake;
 			/*
 			 * Re-initializing the inode failed, and we are in deep
 			 * trouble.  Try to re-add it to the reclaim list.
 			 */
 			rcu_read_lock();
 			spin_lock(&ip->i_flags_lock);
-
+			wake = !!__xfs_iflags_test(ip, XFS_INEW);
 			ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
+			if (wake)
+				wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
 			ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
 			trace_xfs_iget_reclaim_fail(ip);
 			goto out_error;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 71e8a81c91a3..c038f6eecc28 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -217,7 +217,8 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 #define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
 #define XFS_ISTALE		(1 << 1) /* inode has been staled */
 #define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
-#define XFS_INEW		(1 << 3) /* inode has just been allocated */
+#define __XFS_INEW_BIT		3	 /* inode has just been allocated */
+#define XFS_INEW		(1 << __XFS_INEW_BIT)
 #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
 #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
 #define __XFS_IFLOCK_BIT	7	 /* inode is being flushed right now */
@@ -467,6 +468,7 @@ static inline void xfs_finish_inode_setup(struct xfs_inode *ip)
 	xfs_iflags_clear(ip, XFS_INEW);
 	barrier();
 	unlock_new_inode(VFS_I(ip));
+	wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
 }
 
 static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
-- 
2.11.0

