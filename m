Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59989 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754474AbdKCOqm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:46:42 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdF3-000268-DA
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:46:41 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/21] xfs: remove the nr_extents argument to xfs_iext_insert
Date: Fri,  3 Nov 2017 17:45:36 +0300
Message-Id: <20171103144539.2187-19-hch@lst.de>
In-Reply-To: <20171103144539.2187-1-hch@lst.de>
References: <20171103144539.2187-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We only have two places that insert 2 extents at the same time, so unroll
the loop there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 31 ++++++++++++++++---------------
 fs/xfs/libxfs/xfs_iext_tree.c  | 31 ++++++++-----------------------
 fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
 4 files changed, 26 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7d96e4d9fc91..c12620f57de5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -901,7 +901,7 @@ xfs_bmap_local_to_extents(
 	rec.br_blockcount = 1;
 	rec.br_state = XFS_EXT_NORM;
 	xfs_iext_first(ifp, &icur);
-	xfs_iext_insert(ip, &icur, 1, &rec, 0);
+	xfs_iext_insert(ip, &icur, &rec, 0);
 
 	XFS_IFORK_NEXT_SET(ip, whichfork, 1);
 	ip->i_d.di_nblocks = 1;
@@ -1268,7 +1268,7 @@ xfs_iread_extents(
 				goto out_brelse;
 			}
 			xfs_bmbt_disk_get_all(frp, &new);
-			xfs_iext_insert(ip, &icur, 1, &new, state);
+			xfs_iext_insert(ip, &icur, &new, state);
 			trace_xfs_read_extent(ip, &icur, state, _THIS_IP_);
 			xfs_iext_next(ifp, &icur);
 		}
@@ -1824,7 +1824,7 @@ xfs_bmap_add_extent_delay_real(
 		PREV.br_blockcount = temp;
 		PREV.br_startblock = nullstartblock(da_new);
 		xfs_iext_next(ifp, &bma->icur);
-		xfs_iext_insert(bma->ip, &bma->icur, 1, &PREV, state);
+		xfs_iext_insert(bma->ip, &bma->icur, &PREV, state);
 		xfs_iext_prev(ifp, &bma->icur);
 		break;
 
@@ -1900,7 +1900,7 @@ xfs_bmap_add_extent_delay_real(
 
 		PREV.br_startblock = nullstartblock(da_new);
 		PREV.br_blockcount = temp;
-		xfs_iext_insert(bma->ip, &bma->icur, 1, &PREV, state);
+		xfs_iext_insert(bma->ip, &bma->icur, &PREV, state);
 		xfs_iext_next(ifp, &bma->icur);
 		break;
 
@@ -1946,9 +1946,9 @@ xfs_bmap_add_extent_delay_real(
 					PREV.br_blockcount));
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
 
-		/* insert LEFT (r[0]) and RIGHT (r[1]) at the same time */
 		xfs_iext_next(ifp, &bma->icur);
-		xfs_iext_insert(bma->ip, &bma->icur, 2, &LEFT, state);
+		xfs_iext_insert(bma->ip, &bma->icur, &RIGHT, state);
+		xfs_iext_insert(bma->ip, &bma->icur, &LEFT, state);
 		(*nextents)++;
 
 		if (bma->cur == NULL)
@@ -2312,7 +2312,7 @@ xfs_bmap_add_extent_unwritten_real(
 		PREV.br_blockcount -= new->br_blockcount;
 
 		xfs_iext_update_extent(ip, state, icur, &PREV);
-		xfs_iext_insert(ip, icur, 1, new, state);
+		xfs_iext_insert(ip, icur, new, state);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		if (cur == NULL)
@@ -2379,7 +2379,7 @@ xfs_bmap_add_extent_unwritten_real(
 
 		xfs_iext_update_extent(ip, state, icur, &PREV);
 		xfs_iext_next(ifp, icur);
-		xfs_iext_insert(ip, icur, 1, new, state);
+		xfs_iext_insert(ip, icur, new, state);
 
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
@@ -2422,7 +2422,8 @@ xfs_bmap_add_extent_unwritten_real(
 
 		xfs_iext_update_extent(ip, state, icur, &PREV);
 		xfs_iext_next(ifp, icur);
-		xfs_iext_insert(ip, icur, 2, &r[0], state);
+		xfs_iext_insert(ip, icur, &r[1], state);
+		xfs_iext_insert(ip, icur, &r[0], state);
 
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) + 2);
@@ -2630,7 +2631,7 @@ xfs_bmap_add_extent_hole_delay(
 		 * Insert a new entry.
 		 */
 		oldlen = newlen = 0;
-		xfs_iext_insert(ip, icur, 1, new, state);
+		xfs_iext_insert(ip, icur, new, state);
 		break;
 	}
 	if (oldlen != newlen) {
@@ -2814,7 +2815,7 @@ xfs_bmap_add_extent_hole_real(
 		 * real allocation.
 		 * Insert a new entry.
 		 */
-		xfs_iext_insert(ip, icur, 1, new, state);
+		xfs_iext_insert(ip, icur, new, state);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		if (cur == NULL) {
@@ -4737,7 +4738,7 @@ xfs_bmap_del_extent_delay(
 
 		xfs_iext_update_extent(ip, state, icur, got);
 		xfs_iext_next(ifp, icur);
-		xfs_iext_insert(ip, icur, 1, &new, state);
+		xfs_iext_insert(ip, icur, &new, state);
 
 		da_new = got_indlen + new_indlen - stolen;
 		del->br_blockcount -= stolen;
@@ -4818,7 +4819,7 @@ xfs_bmap_del_extent_cow(
 
 		xfs_iext_update_extent(ip, state, icur, got);
 		xfs_iext_next(ifp, icur);
-		xfs_iext_insert(ip, icur, 1, &new, state);
+		xfs_iext_insert(ip, icur, &new, state);
 		break;
 	}
 }
@@ -5031,7 +5032,7 @@ xfs_bmap_del_extent_real(
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		xfs_iext_next(ifp, icur);
-		xfs_iext_insert(ip, icur, 1, &new, state);
+		xfs_iext_insert(ip, icur, &new, state);
 		break;
 	}
 
@@ -5893,7 +5894,7 @@ xfs_bmap_split_extent_at(
 
 	/* Add new extent */
 	xfs_iext_next(ifp, &icur);
-	xfs_iext_insert(ip, &icur, 1, &new, 0);
+	xfs_iext_insert(ip, &icur, &new, 0);
 	XFS_IFORK_NEXT_SET(ip, whichfork,
 			   XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 8b6402d2d9b2..da3b6d727748 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -619,16 +619,20 @@ xfs_iext_realloc_root(
 	cur->leaf = new;
 }
 
-static void
-__xfs_iext_insert(
-	struct xfs_ifork	*ifp,
+void
+xfs_iext_insert(
+	struct xfs_inode	*ip,
 	struct xfs_iext_cursor	*cur,
-	struct xfs_bmbt_irec	*irec)
+	struct xfs_bmbt_irec	*irec,
+	int			state)
 {
+	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
 	xfs_fileoff_t		offset = irec->br_startoff;
 	struct xfs_iext_leaf	*new = NULL;
 	int			nr_entries, i;
 
+	trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
+
 	if (ifp->if_height == 0)
 		xfs_iext_alloc_root(ifp, cur);
 	else if (ifp->if_height == 1)
@@ -656,25 +660,6 @@ __xfs_iext_insert(
 		xfs_iext_insert_node(ifp, xfs_iext_leaf_key(new, 0), new, 2);
 }
 
-void
-xfs_iext_insert(
-	struct xfs_inode	*ip,
-	struct xfs_iext_cursor	*cur,
-	xfs_extnum_t		nr_extents,
-	struct xfs_bmbt_irec	*new,
-	int			state)
-{
-	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
-	int			i;
-
-	ASSERT(nr_extents > 0);
-
-	for (i = nr_extents - 1; i >= 0; i--) {
-		__xfs_iext_insert(ifp, cur, new + i);
-		trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
-	}
-}
-
 static struct xfs_iext_node *
 xfs_iext_rebalance_node(
 	struct xfs_iext_node	*parent,
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1839202133ba..71901ee2e35c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -362,7 +362,7 @@ xfs_iformat_extents(
 			}
 
 			xfs_bmbt_disk_get_all(dp, &new);
-			xfs_iext_insert(ip, &icur, 1, &new, state);
+			xfs_iext_insert(ip, &icur, &new, state);
 			trace_xfs_read_extent(ip, &icur, state, _THIS_IP_);
 			xfs_iext_next(ifp, &icur);
 		}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7fda248e32ab..4859db42fef8 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -114,7 +114,7 @@ void		xfs_init_local_fork(struct xfs_inode *, int, const void *, int);
 
 xfs_extnum_t	xfs_iext_count(struct xfs_ifork *ifp);
 void		xfs_iext_insert(struct xfs_inode *, struct xfs_iext_cursor *cur,
-			xfs_extnum_t, struct xfs_bmbt_irec *, int);
+			struct xfs_bmbt_irec *, int);
 void		xfs_iext_remove(struct xfs_inode *, struct xfs_iext_cursor *,
 			int, int);
 void		xfs_iext_destroy(struct xfs_ifork *);
-- 
2.14.2

