Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:27343 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725829AbeJYH10 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Oct 2018 03:27:26 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gFS5W-0006J4-V6
        for linux-xfs@vger.kernel.org; Thu, 25 Oct 2018 09:57:19 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gFS5W-0005D2-U0
        for linux-xfs@vger.kernel.org; Thu, 25 Oct 2018 09:57:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] xfs: move xfs_dir2_addname()
Date: Thu, 25 Oct 2018 09:57:12 +1100
Message-Id: <20181024225716.19459-2-david@fromorbit.com>
In-Reply-To: <20181024225716.19459-1-david@fromorbit.com>
References: <20181024225716.19459-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This gets rid of the need for a forward  declaration of the static
function xfs_dir2_addname_int() and readies the code for factoring
of xfs_dir2_addname_int().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 140 +++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index f1bb3434f51c..3661988906b0 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -34,8 +34,6 @@ static void xfs_dir2_leafn_rebalance(xfs_da_state_t *state,
 static int xfs_dir2_leafn_remove(xfs_da_args_t *args, struct xfs_buf *bp,
 				 int index, xfs_da_state_blk_t *dblk,
 				 int *rval);
-static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
-				     xfs_da_state_blk_t *fblk);
 
 /*
  * Check internal consistency of a leafn block.
@@ -1613,75 +1611,6 @@ xfs_dir2_leafn_unbalance(
 	xfs_dir3_leaf_check(dp, drop_blk->bp);
 }
 
-/*
- * Top-level node form directory addname routine.
- */
-int						/* error */
-xfs_dir2_node_addname(
-	xfs_da_args_t		*args)		/* operation arguments */
-{
-	xfs_da_state_blk_t	*blk;		/* leaf block for insert */
-	int			error;		/* error return value */
-	int			rval;		/* sub-return value */
-	xfs_da_state_t		*state;		/* btree cursor */
-
-	trace_xfs_dir2_node_addname(args);
-
-	/*
-	 * Allocate and initialize the state (btree cursor).
-	 */
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = args->dp->i_mount;
-	/*
-	 * Look up the name.  We're not supposed to find it, but
-	 * this gives us the insertion point.
-	 */
-	error = xfs_da3_node_lookup_int(state, &rval);
-	if (error)
-		rval = error;
-	if (rval != -ENOENT) {
-		goto done;
-	}
-	/*
-	 * Add the data entry to a data block.
-	 * Extravalid is set to a freeblock found by lookup.
-	 */
-	rval = xfs_dir2_node_addname_int(args,
-		state->extravalid ? &state->extrablk : NULL);
-	if (rval) {
-		goto done;
-	}
-	blk = &state->path.blk[state->path.active - 1];
-	ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
-	/*
-	 * Add the new leaf entry.
-	 */
-	rval = xfs_dir2_leafn_add(blk->bp, args, blk->index);
-	if (rval == 0) {
-		/*
-		 * It worked, fix the hash values up the btree.
-		 */
-		if (!(args->op_flags & XFS_DA_OP_JUSTCHECK))
-			xfs_da3_fixhashpath(state, &state->path);
-	} else {
-		/*
-		 * It didn't work, we need to split the leaf block.
-		 */
-		if (args->total == 0) {
-			ASSERT(rval == -ENOSPC);
-			goto done;
-		}
-		/*
-		 * Split the leaf block and insert the new entry.
-		 */
-		rval = xfs_da3_split(state);
-	}
-done:
-	xfs_da_state_free(state);
-	return rval;
-}
-
 /*
  * Add the data entry for a node-format directory name addition.
  * The leaf entry is added in xfs_dir2_leafn_add.
@@ -2059,6 +1988,75 @@ xfs_dir2_node_addname_int(
 	return 0;
 }
 
+/*
+ * Top-level node form directory addname routine.
+ */
+int						/* error */
+xfs_dir2_node_addname(
+	xfs_da_args_t		*args)		/* operation arguments */
+{
+	xfs_da_state_blk_t	*blk;		/* leaf block for insert */
+	int			error;		/* error return value */
+	int			rval;		/* sub-return value */
+	xfs_da_state_t		*state;		/* btree cursor */
+
+	trace_xfs_dir2_node_addname(args);
+
+	/*
+	 * Allocate and initialize the state (btree cursor).
+	 */
+	state = xfs_da_state_alloc();
+	state->args = args;
+	state->mp = args->dp->i_mount;
+	/*
+	 * Look up the name.  We're not supposed to find it, but
+	 * this gives us the insertion point.
+	 */
+	error = xfs_da3_node_lookup_int(state, &rval);
+	if (error)
+		rval = error;
+	if (rval != -ENOENT) {
+		goto done;
+	}
+	/*
+	 * Add the data entry to a data block.
+	 * Extravalid is set to a freeblock found by lookup.
+	 */
+	rval = xfs_dir2_node_addname_int(args,
+		state->extravalid ? &state->extrablk : NULL);
+	if (rval) {
+		goto done;
+	}
+	blk = &state->path.blk[state->path.active - 1];
+	ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
+	/*
+	 * Add the new leaf entry.
+	 */
+	rval = xfs_dir2_leafn_add(blk->bp, args, blk->index);
+	if (rval == 0) {
+		/*
+		 * It worked, fix the hash values up the btree.
+		 */
+		if (!(args->op_flags & XFS_DA_OP_JUSTCHECK))
+			xfs_da3_fixhashpath(state, &state->path);
+	} else {
+		/*
+		 * It didn't work, we need to split the leaf block.
+		 */
+		if (args->total == 0) {
+			ASSERT(rval == -ENOSPC);
+			goto done;
+		}
+		/*
+		 * Split the leaf block and insert the new entry.
+		 */
+		rval = xfs_da3_split(state);
+	}
+done:
+	xfs_da_state_free(state);
+	return rval;
+}
+
 /*
  * Lookup an entry in a node-format directory.
  * All the real work happens in xfs_da3_node_lookup_int.
-- 
2.19.1
