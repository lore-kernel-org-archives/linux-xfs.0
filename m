Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46295 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754474AbdKCOqp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:46:45 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdF6-00026U-Jn
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:46:45 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/21] xfs: remove the nr_extents argument to xfs_iext_remove
Date: Fri,  3 Nov 2017 17:45:37 +0300
Message-Id: <20171103144539.2187-20-hch@lst.de>
In-Reply-To: <20171103144539.2187-1-hch@lst.de>
References: <20171103144539.2187-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We only have two places that remove 2 extents at the same time, so unroll
the loop there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 26 ++++++++++++++------------
 fs/xfs/libxfs/xfs_iext_tree.c  | 30 ++++++++----------------------
 fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
 3 files changed, 23 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c12620f57de5..57c974fea3a9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1645,7 +1645,8 @@ xfs_bmap_add_extent_delay_real(
 		 */
 		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
 
-		xfs_iext_remove(bma->ip, &bma->icur, 2, state);
+		xfs_iext_remove(bma->ip, &bma->icur, state);
+		xfs_iext_remove(bma->ip, &bma->icur, state);
 		xfs_iext_prev(ifp, &bma->icur);
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &LEFT);
 		(*nextents)--;
@@ -1680,7 +1681,7 @@ xfs_bmap_add_extent_delay_real(
 		old = LEFT;
 		LEFT.br_blockcount += PREV.br_blockcount;
 
-		xfs_iext_remove(bma->ip, &bma->icur, 1, state);
+		xfs_iext_remove(bma->ip, &bma->icur, state);
 		xfs_iext_prev(ifp, &bma->icur);
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &LEFT);
 
@@ -1707,7 +1708,7 @@ xfs_bmap_add_extent_delay_real(
 		PREV.br_blockcount += RIGHT.br_blockcount;
 
 		xfs_iext_next(ifp, &bma->icur);
-		xfs_iext_remove(bma->ip, &bma->icur, 1, state);
+		xfs_iext_remove(bma->ip, &bma->icur, state);
 		xfs_iext_prev(ifp, &bma->icur);
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
 
@@ -2144,7 +2145,8 @@ xfs_bmap_add_extent_unwritten_real(
 		 */
 		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
 
-		xfs_iext_remove(ip, icur, 2, state);
+		xfs_iext_remove(ip, icur, state);
+		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
 		xfs_iext_update_extent(ip, state, icur, &LEFT);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
@@ -2182,7 +2184,7 @@ xfs_bmap_add_extent_unwritten_real(
 		 */
 		LEFT.br_blockcount += PREV.br_blockcount;
 
-		xfs_iext_remove(ip, icur, 1, state);
+		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
 		xfs_iext_update_extent(ip, state, icur, &LEFT);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
@@ -2216,7 +2218,7 @@ xfs_bmap_add_extent_unwritten_real(
 		PREV.br_state = new->br_state;
 
 		xfs_iext_next(ifp, icur);
-		xfs_iext_remove(ip, icur, 1, state);
+		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
 		xfs_iext_update_extent(ip, state, icur, &PREV);
 
@@ -2583,7 +2585,7 @@ xfs_bmap_add_extent_hole_delay(
 		left.br_startblock = nullstartblock(newlen);
 		left.br_blockcount = temp;
 
-		xfs_iext_remove(ip, icur, 1, state);
+		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
 		xfs_iext_update_extent(ip, state, icur, &left);
 		break;
@@ -2728,7 +2730,7 @@ xfs_bmap_add_extent_hole_real(
 		 */
 		left.br_blockcount += new->br_blockcount + right.br_blockcount;
 
-		xfs_iext_remove(ip, icur, 1, state);
+		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
 		xfs_iext_update_extent(ip, state, icur, &left);
 
@@ -4686,7 +4688,7 @@ xfs_bmap_del_extent_delay(
 		/*
 		 * Matches the whole extent.  Delete the entry.
 		 */
-		xfs_iext_remove(ip, icur, 1, state);
+		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
 		break;
 	case BMAP_LEFT_FILLING:
@@ -4787,7 +4789,7 @@ xfs_bmap_del_extent_cow(
 		/*
 		 * Matches the whole extent.  Delete the entry.
 		 */
-		xfs_iext_remove(ip, icur, 1, state);
+		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
 		break;
 	case BMAP_LEFT_FILLING:
@@ -4927,7 +4929,7 @@ xfs_bmap_del_extent_real(
 		/*
 		 * Matches the whole extent.  Delete the entry.
 		 */
-		xfs_iext_remove(ip, icur, 1, state);
+		xfs_iext_remove(ip, icur, state);
 		xfs_iext_prev(ifp, icur);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
@@ -5553,7 +5555,7 @@ xfs_bmse_merge(
 		return error;
 
 done:
-	xfs_iext_remove(ip, icur, 1, 0);
+	xfs_iext_remove(ip, icur, 0);
 	xfs_iext_prev(XFS_IFORK_PTR(ip, whichfork), icur);
 	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork), icur,
 			&new);
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index da3b6d727748..a35c4e51fedc 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -818,15 +818,19 @@ xfs_iext_free_last_leaf(
 	kmem_free(ifp->if_u1.if_root);
 }
 
-static void
-__xfs_iext_remove(
-	struct xfs_ifork	*ifp,
-	struct xfs_iext_cursor	*cur)
+void
+xfs_iext_remove(
+	struct xfs_inode	*ip,
+	struct xfs_iext_cursor	*cur,
+	int			state)
 {
+	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
 	struct xfs_iext_leaf	*leaf = cur->leaf;
 	xfs_fileoff_t		offset = xfs_iext_leaf_key(leaf, 0);
 	int			i, nr_entries;
 
+	trace_xfs_iext_remove(ip, cur, state, _RET_IP_);
+
 	ASSERT(ifp->if_height > 0);
 	ASSERT(ifp->if_u1.if_root != NULL);
 	ASSERT(xfs_iext_valid(ifp, cur));
@@ -858,24 +862,6 @@ __xfs_iext_remove(
 		xfs_iext_free_last_leaf(ifp);
 }
 
-void
-xfs_iext_remove(
-	struct xfs_inode	*ip,
-	struct xfs_iext_cursor	*cur,
-	int			nr_extents,
-	int			state)
-{
-	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
-	int			i;
-
-	ASSERT(nr_extents > 0);
-
-	for (i = 0; i < nr_extents; i++) {
-		trace_xfs_iext_remove(ip, cur, state, _RET_IP_);
-		__xfs_iext_remove(ifp, cur);
-	}
-}
-
 /*
  * Lookup the extent covering bno.
  *
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 4859db42fef8..98e46c6666a5 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -116,7 +116,7 @@ xfs_extnum_t	xfs_iext_count(struct xfs_ifork *ifp);
 void		xfs_iext_insert(struct xfs_inode *, struct xfs_iext_cursor *cur,
 			struct xfs_bmbt_irec *, int);
 void		xfs_iext_remove(struct xfs_inode *, struct xfs_iext_cursor *,
-			int, int);
+			int);
 void		xfs_iext_destroy(struct xfs_ifork *);
 
 bool		xfs_iext_lookup_extent(struct xfs_inode *ip,
-- 
2.14.2

