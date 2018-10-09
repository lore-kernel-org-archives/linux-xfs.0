Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43864 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbeJILeg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Oct 2018 07:34:36 -0400
Subject: [PATCH 1/3] xfs: xrep_findroot_block should reject root blocks with
 siblings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 08 Oct 2018 21:19:35 -0700
Message-ID: <153905877511.10127.11218753138146239883.stgit@magnolia>
In-Reply-To: <153905876877.10127.12478254551500076698.stgit@magnolia>
References: <153905876877.10127.12478254551500076698.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

In xrep_findroot_block, if we find a candidate root block with sibling
pointers or sibling blocks on the same tree level, we should not return
that block as a tree root because root blocks cannot have siblings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/scrub/repair.c |   61 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 9f08dd9bf1d5..63786341ac2a 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -692,12 +692,13 @@ xrep_findroot_block(
 	struct xrep_find_ag_btree	*fab,
 	uint64_t			owner,
 	xfs_agblock_t			agbno,
-	bool				*found_it)
+	bool				*done_with_block)
 {
 	struct xfs_mount		*mp = ri->sc->mp;
 	struct xfs_buf			*bp;
 	struct xfs_btree_block		*btblock;
 	xfs_daddr_t			daddr;
+	int				block_level;
 	int				error;
 
 	daddr = XFS_AGB_TO_DADDR(mp, ri->sc->sa.agno, agbno);
@@ -735,18 +736,52 @@ xrep_findroot_block(
 		goto out;
 	bp->b_ops = fab->buf_ops;
 
-	/* Ignore this block if it's lower in the tree than we've seen. */
-	if (fab->root != NULLAGBLOCK &&
-	    xfs_btree_get_level(btblock) < fab->height)
-		goto out;
-
 	/* Make sure we pass the verifiers. */
 	bp->b_ops->verify_read(bp);
 	if (bp->b_error)
 		goto out;
-	fab->root = agbno;
-	fab->height = xfs_btree_get_level(btblock) + 1;
-	*found_it = true;
+
+	/*
+	 * This block passes the magic/uuid and verifier tests for this btree
+	 * type.  We don't need the caller to try the other tree types.
+	 */
+	*done_with_block = true;
+
+	/*
+	 * Compare this btree block's level to the height of the current
+	 * candidate root block.
+	 *
+	 * If the level matches the root we found previously, throw away both
+	 * blocks because there can't be two candidate roots.
+	 *
+	 * If level is lower in the tree than the root we found previously,
+	 * ignore this block.
+	 */
+	block_level = xfs_btree_get_level(btblock);
+	if (block_level + 1 == fab->height) {
+		fab->root = NULLAGBLOCK;
+		goto out;
+	} else if (block_level < fab->height) {
+		goto out;
+	}
+
+	/*
+	 * This is the highest block in the tree that we've found so far.
+	 * Update the btree height to reflect what we've learned from this
+	 * block.
+	 */
+	fab->height = block_level + 1;
+
+	/*
+	 * If this block doesn't have sibling pointers, then it's the new root
+	 * block candidate.  Otherwise, the root will be found farther up the
+	 * tree.
+	 */
+	if (btblock->bb_u.s.bb_leftsib == cpu_to_be32(NULLAGBLOCK) &&
+	    btblock->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK))
+		fab->root = agbno;
+	else
+		fab->root = NULLAGBLOCK;
 
 	trace_xrep_findroot_block(mp, ri->sc->sa.agno, agbno,
 			be32_to_cpu(btblock->bb_magic), fab->height - 1);
@@ -768,7 +803,7 @@ xrep_findroot_rmap(
 	struct xrep_findroot		*ri = priv;
 	struct xrep_find_ag_btree	*fab;
 	xfs_agblock_t			b;
-	bool				found_it;
+	bool				done;
 	int				error = 0;
 
 	/* Ignore anything that isn't AG metadata. */
@@ -777,16 +812,16 @@ xrep_findroot_rmap(
 
 	/* Otherwise scan each block + btree type. */
 	for (b = 0; b < rec->rm_blockcount; b++) {
-		found_it = false;
+		done = false;
 		for (fab = ri->btree_info; fab->buf_ops; fab++) {
 			if (rec->rm_owner != fab->rmap_owner)
 				continue;
 			error = xrep_findroot_block(ri, fab,
 					rec->rm_owner, rec->rm_startblock + b,
-					&found_it);
+					&done);
 			if (error)
 				return error;
-			if (found_it)
+			if (done)
 				break;
 		}
 	}
