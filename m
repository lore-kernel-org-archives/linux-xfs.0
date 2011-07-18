Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6IIEGwt115629 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 13:14:16 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201107181814.p6IIEAZm028909@stout.americas.sgi.com>
Date: Mon, 18 Jul 2011 13:14:09 -0500
Subject: xfs: encapsulate a block of debug code
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Pull into a helper function some debug-only code that validates a
xfs_da_blkinfo structure that's been read from disk.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_da_btree.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

Index: b/fs/xfs/xfs_da_btree.c
===================================================================
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -692,6 +692,24 @@ xfs_da_join(xfs_da_state_t *state)
 	return(error);
 }
 
+#ifdef	DEBUG
+static void
+xfs_da_blkinfo_validate(struct xfs_da_blkinfo *blkinfo, __u16 level)
+{
+	__be16	magic = blkinfo->magic;
+
+	if (level == 1) {
+		ASSERT(magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
+		       magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
+	} else
+		ASSERT(magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
+	ASSERT(!blkinfo->forw);
+	ASSERT(!blkinfo->back);
+}
+#else	/* !DEBUG */
+#define	xfs_da_blkinfo_validate(blkinfo, level)
+#endif	/* !DEBUG */
+
 /*
  * We have only one entry in the root.  Copy the only remaining child of
  * the old root to block 0 as the new root node.
@@ -700,8 +718,6 @@ STATIC int
 xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
 {
 	xfs_da_intnode_t *oldroot;
-	/* REFERENCED */
-	xfs_da_blkinfo_t *blkinfo;
 	xfs_da_args_t *args;
 	xfs_dablk_t child;
 	xfs_dabuf_t *bp;
@@ -732,15 +748,8 @@ xfs_da_root_join(xfs_da_state_t *state, 
 	if (error)
 		return(error);
 	ASSERT(bp != NULL);
-	blkinfo = bp->data;
-	if (be16_to_cpu(oldroot->hdr.level) == 1) {
-		ASSERT(blkinfo->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
-		       blkinfo->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	} else {
-		ASSERT(blkinfo->magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-	}
-	ASSERT(!blkinfo->forw);
-	ASSERT(!blkinfo->back);
+	xfs_da_blkinfo_validate(bp->data, be16_to_cpu(oldroot->hdr.level));
+
 	memcpy(root_blk->bp->data, bp->data, state->blocksize);
 	xfs_da_log_buf(args->trans, root_blk->bp, 0, state->blocksize - 1);
 	error = xfs_da_shrink_inode(args, child, bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
