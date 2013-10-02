Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6519C7F9C
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 08:24:46 -0500 (CDT)
Received: from eagdhcp-232-155.americas.sgi.com
	(eagdhcp-232-155.americas.sgi.com [128.162.232.155])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E60F1AC005
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 06:24:42 -0700 (PDT)
Received: from eagdhcp-232-155.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-155.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r92DOgZb002407
	for <xfs@oss.sgi.com>; Wed, 2 Oct 2013 08:24:42 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-155.americas.sgi.com)
Message-Id: <20131002125409.826742020@sgi.com>
Date: Wed, 02 Oct 2013 07:51:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 1/2] xfs: fix memory leak in xfs_dir2_node_removename
References: <20131002125110.745269864@sgi.com>
Content-Disposition: inline;
	filename=xfs-fix-leak-in-xfs_dir2_node_removename.patch
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

Found by Coverity in userspace same patch applies there also.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 v2 corrected bad return code as pointed out by Roger Willcocks.

 fs/xfs/xfs_dir2_node.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

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
 
@@ -2132,9 +2132,10 @@ xfs_dir2_node_removename(
 	 * Didn't find it, upper layer screwed up.
 	 */
 	if (rval != EEXIST) {
-		xfs_da_state_free(state);
-		return rval;
+		error = rval;
+		goto done;
 	}
+
 	blk = &state->path.blk[state->path.active - 1];
 	ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
 	ASSERT(state->extravalid);
@@ -2145,7 +2146,7 @@ xfs_dir2_node_removename(
 	error = xfs_dir2_leafn_remove(args, blk->bp, blk->index,
 		&state->extrablk, &rval);
 	if (error)
-		return error;
+		goto done;
 	/*
 	 * Fix the hash values up the btree.
 	 */
@@ -2160,6 +2161,7 @@ xfs_dir2_node_removename(
 	 */
 	if (!error)
 		error = xfs_dir2_node_to_leaf(state);
+done:
 	xfs_da_state_free(state);
 	return error;
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
