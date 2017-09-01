Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19389 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbdIAP6D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 11:58:03 -0400
Date: Fri, 1 Sep 2017 08:57:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: ASSERT should always evaluate its parameter
Message-ID: <20170901155733.GA3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>

Ensure that ASSERT evalulates its expression argument so that we don't
get a ton of compiler warnings in non-warn non-debug mode.  Fix up
everything that breaks as a result.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c      |    2 +-
 fs/xfs/libxfs/xfs_dir2_node.c |    2 --
 fs/xfs/xfs_inode.c            |    8 ++++++++
 fs/xfs/xfs_linux.h            |    3 ++-
 fs/xfs/xfs_trans.c            |    2 ++
 5 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9558f5e..883a626 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -579,7 +579,7 @@ xfs_bmap_validate_ret(
 
 #else
 #define xfs_bmap_check_leaf_extents(cur, ip, whichfork)		do { } while (0)
-#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)
+#define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)	((void)0)
 #endif /* DEBUG */
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 682e2bf..e57a80b 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1005,9 +1005,7 @@ xfs_dir2_leafn_rebalance(
 	xfs_dir2_leaf_t		*leaf1;		/* first leaf structure */
 	xfs_dir2_leaf_t		*leaf2;		/* second leaf structure */
 	int			mid;		/* midpoint leaf index */
-#if defined(DEBUG) || defined(XFS_WARN)
 	int			oldstale;	/* old count of stale leaves */
-#endif
 	int			oldsum;		/* old total leaf count */
 	int			swap;		/* swapped leaf blocks */
 	struct xfs_dir2_leaf_entry *ents1;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5599dda..0eaf1f1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -382,6 +382,14 @@ xfs_isilocked(
 	ASSERT(0);
 	return 0;
 }
+#else
+int
+xfs_isilocked(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
+{
+	return 0;
+}
 #endif
 
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index c19c999..7c69f08 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -260,7 +260,8 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 
 #else	/* !DEBUG && !XFS_WARN */
 
-#define ASSERT(expr)	((void)0)
+#define ASSERT(expr)	\
+	(likely(expr) ? (void)0 : (void)0)
 
 #ifndef STATIC
 # define STATIC static noinline
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index a87f657..45e30ba 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -421,9 +421,11 @@ xfs_trans_apply_sb_deltas(
 	/*
 	 * Check that superblock mods match the mods made to AGF counters.
 	 */
+#if defined(DEBUG) || defined(XFS_WARN)
 	ASSERT((tp->t_fdblocks_delta + tp->t_res_fdblocks_delta) ==
 	       (tp->t_ag_freeblks_delta + tp->t_ag_flist_delta +
 		tp->t_ag_btree_delta));
+#endif
 
 	/*
 	 * Only update the superblock counters if we are logging them
