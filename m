Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 704E08141
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:27:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 63E5230408C
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 16:27:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id CdnrK5JkLlG8gwtq for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 16:26:30 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 05/14] libxfs: fix memory leak in xfs_dir2_node_removename
Date: Tue,  8 Apr 2014 18:24:55 -0500
Message-Id: <1396999504-13769-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
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

Cross-port of kernel commit 3a8c9208

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/xfs_dir2_node.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 3256756..3737e4e 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -2088,12 +2088,12 @@ xfs_dir2_node_lookup(
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
 
@@ -2105,19 +2105,18 @@ xfs_dir2_node_removename(
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
@@ -2128,7 +2127,7 @@ xfs_dir2_node_removename(
 	error = xfs_dir2_leafn_remove(args, blk->bp, blk->index,
 		&state->extrablk, &rval);
 	if (error)
-		return error;
+		goto out_free;
 	/*
 	 * Fix the hash values up the btree.
 	 */
@@ -2143,6 +2142,7 @@ xfs_dir2_node_removename(
 	 */
 	if (!error)
 		error = xfs_dir2_node_to_leaf(state);
+out_free:
 	xfs_da_state_free(state);
 	return error;
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
