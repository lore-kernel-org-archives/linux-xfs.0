Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 17B177F50
	for <xfs@oss.sgi.com>; Sat,  5 Oct 2013 21:49:41 -0500 (CDT)
Received: from eagdhcp-232-165.americas.sgi.com
	(eagdhcp-232-165.americas.sgi.com [128.162.232.165])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8D689AC002
	for <xfs@oss.sgi.com>; Sat,  5 Oct 2013 19:49:40 -0700 (PDT)
Received: from eagdhcp-232-165.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-165.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r962ndIa002263
	for <xfs@oss.sgi.com>; Sat, 5 Oct 2013 21:49:39 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-165.americas.sgi.com)
Message-Id: <20131006024850.071924201@sgi.com>
Date: Sat, 05 Oct 2013 21:48:25 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v3] xfs: fix memory leak in xfs_dir2_node_removename
Content-Disposition: inline;
	filename=v3-xfs-fix-leak-in-xfs_dir2_node_removename.patch
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

Fix the leak of kernel memory in xfs_dir2_node_removename()
when xfs_dir2_leafn_remove() returns an error code.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 v3 change error logic and goto label names
 v2 corrected bad return code as pointed out by Roger Willcocks.
 Found by Coverity (134681) in userspace.

 fs/xfs/xfs_dir2_node.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: b/fs/xfs/xfs_dir2_node.c
===================================================================
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -2105,12 +2105,12 @@ xfs_dir2_node_lookup(
  */
 int						/* error */
 xfs_dir2_node_removename(
-	xfs_da_args_t		*args)		/* operation arguments */
+	struct xfs_da_args	*args)		/* operation arguments */
 {
-	xfs_da_state_blk_t	*blk;		/* leaf block */
+	struct xfs_da_state_blk	*blk;		/* leaf block */
 	int			error;		/* error return value */
 	int			rval;		/* operation return value */
-	xfs_da_state_t		*state;		/* btree cursor */
+	struct xfs_da_state	*state;		/* btree cursor */
 
 	trace_xfs_dir2_node_removename(args);
 
@@ -2122,19 +2122,18 @@ xfs_dir2_node_removename(
 	state->mp = args->dp->i_mount;
 	state->blocksize = state->mp->m_dirblksize;
 	state->node_ents = state->mp->m_dir_node_ents;
-	/*
-	 * Look up the entry we're deleting, set up the cursor.
-	 */
+
+	/* Look up the entry we're deleting, set up the cursor. */
 	error = xfs_da3_node_lookup_int(state, &rval);
 	if (error)
-		rval = error;
-	/*
-	 * Didn't find it, upper layer screwed up.
-	 */
+		goto out_free;
+
+	/* Didn't find it, upper layer screwed up. */
 	if (rval != EEXIST) {
-		xfs_da_state_free(state);
-		return rval;
+		error = rval;
+		goto out_free;
 	}
+
 	blk = &state->path.blk[state->path.active - 1];
 	ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
 	ASSERT(state->extravalid);
@@ -2145,7 +2144,7 @@ xfs_dir2_node_removename(
 	error = xfs_dir2_leafn_remove(args, blk->bp, blk->index,
 		&state->extrablk, &rval);
 	if (error)
-		return error;
+		goto out_free;
 	/*
 	 * Fix the hash values up the btree.
 	 */
@@ -2160,6 +2159,7 @@ xfs_dir2_node_removename(
 	 */
 	if (!error)
 		error = xfs_dir2_node_to_leaf(state);
+out_free:
 	xfs_da_state_free(state);
 	return error;
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
