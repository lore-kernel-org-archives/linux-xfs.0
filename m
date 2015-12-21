Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4EC3629E04
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 15:37:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E9088F8033
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 13:37:35 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4UerWLJubMpk0ZES for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 13:37:32 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aB88m-0000hu-E9
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 08:37:12 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aB88m-0002lT-D8
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 08:37:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/9] libxfs: directory node splitting does not have an extra
	block
Date: Tue, 22 Dec 2015 08:37:06 +1100
Message-Id: <1450733829-9319-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1450733829-9319-1-git-send-email-david@fromorbit.com>
References: <1450733829-9319-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

xfs_da3_split() has to handle all thre versions of the
directory/attribute btree structure. The attr tree is v1, the dir
tre is v2 or v3. The main difference between the v1 and v2/3 trees
is the way tree nodes are split - in the v1 tree we can require a
double split to occur because the object to be inserted may be
larger than the space made by splitting a leaf. In this case we need
to do a double split - one to split the full leaf, then another to
allocate an empty leaf block in the correct location for the new
entry.  This does not happen with dir (v2/v3) formats as the objects
being inserted are always guaranteed to fit into the new space in
the split blocks.

The problem is that when we are doing the first root split, there
can be three leaf blocks that need to be updated for an attr tree,
but there will ony ever be two blocks for the dir tree. The code,
however, expects that there will always be an extra block (i.e.
three blocks) that needs updating. When rebuilding broken
directories, xfs_repair trips over this condition in the directroy
code and SEGVs because state->extrablk.bp == NULL. i.e. there is no
extra block.

Indeed, for directories they *may* be an extra block on this buffer
pointer. However, it's guaranteed not to be a leaf block (i.e. a
directory data block) - the directory code only ever places hash
index or free space blocks in this pointer (as a cursor of
sorts), and so to use it as a directory data block will immediately
corrupt the directory. This manifests itself in repair as a
directory corruption in a repaired directory, leaving the directory
rebuild incomplete.

This is a dir v2 zero-day bug - it was in the initial dir v2 commit
that was made back in February 1998.

Fix this by making the update code aware of whether the extra block
is a valid node for linking into the tree, rather than asserting
(incorrectly) that the extra block must be valid. This brings the
code in line with xfs_da3_node_split() which, from the first dir v2
commit, handled the conditional extra block case correctly....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_da_btree.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index bf5fe21..58a0361 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -356,6 +356,7 @@ xfs_da3_split(
 	int			action = 0;
 	int			error;
 	int			i;
+	bool			use_extra = false;
 
 	trace_xfs_da_split(state->args);
 
@@ -395,6 +396,7 @@ xfs_da3_split(
 			 * Entry wouldn't fit, split the leaf again.
 			 */
 			state->extravalid = 1;
+			use_extra = true;
 			if (state->inleaf) {
 				state->extraafter = 0;	/* before newblk */
 				trace_xfs_attr_leaf_split_before(state->args);
@@ -454,8 +456,13 @@ xfs_da3_split(
 	/*
 	 * Update pointers to the node which used to be block 0 and
 	 * just got bumped because of the addition of a new root node.
-	 * There might be three blocks involved if a double split occurred,
-	 * and the original block 0 could be at any position in the list.
+	 * There might be three blocks involved if a double split occurred and
+	 * in this case use_extra will be set. This can only happen for attr
+	 * trees, as extrablk for dir trees can only contain data or free space
+	 * blocks, never leaf/node blocks.
+	 *
+	 * Note that the original block 0 could be at any position in the list
+	 * of blocks in the tree.
 	 *
 	 * Note: the magic numbers and sibling pointers are in the same
 	 * physical place for both v2 and v3 headers (by design). Hence it
@@ -464,31 +471,37 @@ xfs_da3_split(
 	 */
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
+		bp = NULL;
 		if (be32_to_cpu(node->hdr.info.forw) == addblk->blkno) {
 			bp = addblk->bp;
-		} else {
+		} else if (use_extra) {
 			ASSERT(state->extravalid);
 			bp = state->extrablk.bp;
 		}
-		node = bp->b_addr;
-		node->hdr.info.back = cpu_to_be32(oldblk->blkno);
-		xfs_trans_log_buf(state->args->trans, bp,
-		    XFS_DA_LOGRANGE(node, &node->hdr.info,
-		    sizeof(node->hdr.info)));
+		if (bp) {
+			node = bp->b_addr;
+			node->hdr.info.back = cpu_to_be32(oldblk->blkno);
+			xfs_trans_log_buf(state->args->trans, bp,
+					  XFS_DA_LOGRANGE(node, &node->hdr.info,
+					  sizeof(node->hdr.info)));
+		}
 	}
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
+		bp = NULL;
 		if (be32_to_cpu(node->hdr.info.back) == addblk->blkno) {
 			bp = addblk->bp;
 		} else {
 			ASSERT(state->extravalid);
 			bp = state->extrablk.bp;
 		}
-		node = bp->b_addr;
-		node->hdr.info.forw = cpu_to_be32(oldblk->blkno);
-		xfs_trans_log_buf(state->args->trans, bp,
-		    XFS_DA_LOGRANGE(node, &node->hdr.info,
-		    sizeof(node->hdr.info)));
+		if (bp) {
+			node = bp->b_addr;
+			node->hdr.info.forw = cpu_to_be32(oldblk->blkno);
+			xfs_trans_log_buf(state->args->trans, bp,
+					  XFS_DA_LOGRANGE(node, &node->hdr.info,
+					  sizeof(node->hdr.info)));
+		}
 	}
 	addblk->bp = NULL;
 	return 0;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
