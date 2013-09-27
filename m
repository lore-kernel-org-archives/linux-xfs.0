Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B3FD47F53
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 08:04:05 -0500 (CDT)
Received: from eagdhcp-232-140.americas.sgi.com
	(eagdhcp-232-140.americas.sgi.com [128.162.232.140])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 921F58F8040
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 06:04:02 -0700 (PDT)
Received: from eagdhcp-232-140.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-140.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r8RD42Xs002726
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 08:04:02 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-140.americas.sgi.com)
Message-Id: <20130927130140.640252809@sgi.com>
Date: Fri, 27 Sep 2013 08:01:31 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: fix memory leak in xfs_dir2_node_removename
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

Free the memory pointed to by state before returning on error from 
xfs_dir2_node_removename.c

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
Found by Coverity (134681) in userspace, same patch applies there
also.

 fs/xfs/xfs_dir2_node.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: b/fs/xfs/xfs_dir2_node.c
===================================================================
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -2131,10 +2131,9 @@ xfs_dir2_node_removename(
 	/*
 	 * Didn't find it, upper layer screwed up.
 	 */
-	if (rval != EEXIST) {
-		xfs_da_state_free(state);
-		return rval;
-	}
+	if (rval != EEXIST)
+		goto done;
+
 	blk = &state->path.blk[state->path.active - 1];
 	ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
 	ASSERT(state->extravalid);
@@ -2145,7 +2144,7 @@ xfs_dir2_node_removename(
 	error = xfs_dir2_leafn_remove(args, blk->bp, blk->index,
 		&state->extrablk, &rval);
 	if (error)
-		return error;
+		goto done;
 	/*
 	 * Fix the hash values up the btree.
 	 */
@@ -2160,6 +2159,7 @@ xfs_dir2_node_removename(
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
