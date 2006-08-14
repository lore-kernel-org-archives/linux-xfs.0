Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Aug 2006 22:57:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7E5v8DW011369
	for <xfs@oss.sgi.com>; Sun, 13 Aug 2006 22:57:19 -0700
Date: Mon, 14 Aug 2006 15:56:09 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: cleanup xfs_da_node_lookup_int (was Re: [PATCH] XFS: possibly uninitialized variable use in fs/xfs/xfs_da_btree.c::xfs_da_node_lookup_int())
Message-ID: <20060814155609.G2698880@wobbly.melbourne.sgi.com>
References: <200608122334.21901.jesper.juhl@gmail.com> <44DE9B86.90006@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44DE9B86.90006@sandeen.net>; from sandeen@sandeen.net on Sat, Aug 12, 2006 at 10:24:54PM -0500
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, xfs@oss.sgi.com

On Sat, Aug 12, 2006 at 10:24:54PM -0500, Eric Sandeen wrote:
> ...
> FWIW seems like there's a lot of unnecessary endian flipping in there too; I 
> haven't tested this but since it endian-flips the magic into blk->magic seems 
> like it may as well use it:

How's this look?

thanks.

--
Nathan


Index: xfs-linux/xfs_da_btree.c
===================================================================
--- xfs-linux.orig/xfs_da_btree.c	2006-08-14 15:34:20.623194000 +1000
+++ xfs-linux/xfs_da_btree.c	2006-08-14 15:42:07.198743750 +1000
@@ -1054,7 +1054,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *s
 	xfs_da_node_entry_t *btree;
 	xfs_dablk_t blkno;
 	int probe, span, max, error, retval;
-	xfs_dahash_t hashval;
+	xfs_dahash_t hashval, btreehashval;
 	xfs_da_args_t *args;
 
 	args = state->args;
@@ -1079,30 +1079,32 @@ xfs_da_node_lookup_int(xfs_da_state_t *s
 			return(error);
 		}
 		curr = blk->bp->data;
-		ASSERT(be16_to_cpu(curr->magic) == XFS_DA_NODE_MAGIC ||
-		       be16_to_cpu(curr->magic) == XFS_DIR2_LEAFN_MAGIC ||
-		       be16_to_cpu(curr->magic) == XFS_ATTR_LEAF_MAGIC);
+		blk->magic = be16_to_cpu(curr->magic);
+		ASSERT(blk->magic == XFS_DA_NODE_MAGIC ||
+		       blk->magic == XFS_DIR2_LEAFN_MAGIC ||
+		       blk->magic == XFS_ATTR_LEAF_MAGIC);
 
 		/*
 		 * Search an intermediate node for a match.
 		 */
-		blk->magic = be16_to_cpu(curr->magic);
 		if (blk->magic == XFS_DA_NODE_MAGIC) {
 			node = blk->bp->data;
-			blk->hashval = be32_to_cpu(node->btree[be16_to_cpu(node->hdr.count)-1].hashval);
+			max = be16_to_cpu(node->hdr.count);
+			btreehashval = node->btree[max-1].hashval;
+			blk->hashval = be32_to_cpu(btreehashval);
 
 			/*
 			 * Binary search.  (note: small blocks will skip loop)
 			 */
-			max = be16_to_cpu(node->hdr.count);
 			probe = span = max / 2;
 			hashval = args->hashval;
 			for (btree = &node->btree[probe]; span > 4;
 				   btree = &node->btree[probe]) {
 				span /= 2;
-				if (be32_to_cpu(btree->hashval) < hashval)
+				btreehashval = be32_to_cpu(btree->hashval);
+				if (btreehashval < hashval)
 					probe += span;
-				else if (be32_to_cpu(btree->hashval) > hashval)
+				else if (btreehashval > hashval)
 					probe -= span;
 				else
 					break;
@@ -1133,10 +1135,10 @@ xfs_da_node_lookup_int(xfs_da_state_t *s
 				blk->index = probe;
 				blkno = be32_to_cpu(btree->before);
 			}
-		} else if (be16_to_cpu(curr->magic) == XFS_ATTR_LEAF_MAGIC) {
+		} else if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
 			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
 			break;
-		} else if (be16_to_cpu(curr->magic) == XFS_DIR2_LEAFN_MAGIC) {
+		} else if (blk->magic == XFS_DIR2_LEAFN_MAGIC) {
 			blk->hashval = xfs_dir2_leafn_lasthash(blk->bp, NULL);
 			break;
 		}
@@ -1152,11 +1154,13 @@ xfs_da_node_lookup_int(xfs_da_state_t *s
 		if (blk->magic == XFS_DIR2_LEAFN_MAGIC) {
 			retval = xfs_dir2_leafn_lookup_int(blk->bp, args,
 							&blk->index, state);
-		}
-		else if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
+		} else if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
 			retval = xfs_attr_leaf_lookup_int(blk->bp, args);
 			blk->index = args->index;
 			args->blkno = blk->blkno;
+		} else {
+			ASSERT(0);
+			return XFS_ERROR(EFSCORRUPTED);
 		}
 		if (((retval == ENOENT) || (retval == ENOATTR)) &&
 		    (blk->hashval == args->hashval)) {
@@ -1166,8 +1170,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *s
 				return(error);
 			if (retval == 0) {
 				continue;
-			}
-			else if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
+			} else if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
 				/* path_shift() gives ENOENT */
 				retval = XFS_ERROR(ENOATTR);
 			}
