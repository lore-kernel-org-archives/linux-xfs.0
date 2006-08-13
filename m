Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 Aug 2006 20:25:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7D3PTDW005710
	for <xfs@oss.sgi.com>; Sat, 12 Aug 2006 20:25:33 -0700
Message-ID: <44DE9B86.90006@sandeen.net>
Date: Sat, 12 Aug 2006 22:24:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS: possibly uninitialized variable use in fs/xfs/xfs_da_btree.c::xfs_da_node_lookup_int()
References: <200608122334.21901.jesper.juhl@gmail.com>
In-Reply-To: <200608122334.21901.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: xfs-masters@oss.sgi.com, nathans@sgi.com, xfs@oss.sgi.com

Jesper Juhl wrote:
> I suspect I may be completely wrong, and if that's the case I'd sure like 
> an explanation of where I went wrong along with the NACK for the patch.
> In case my understanding is in fact correct and the patch below makes sense,
> then kindly apply :-)
> 

Seems reasonable to me; I also can't see how it avoids using an uninitialized 
retval in all cases.  But I'm in over my head too, so don't take my word for it 
:).  I'll let the folks @sgi chime in...

FWIW seems like there's a lot of unnecessary endian flipping in there too; I 
haven't tested this but since it endian-flips the magic into blk->magic seems 
like it may as well use it:

Index: xfs-linux/xfs_da_btree.c
===================================================================
--- xfs-linux.orig/xfs_da_btree.c
+++ xfs-linux/xfs_da_btree.c
@@ -1079,14 +1079,14 @@ xfs_da_node_lookup_int(xfs_da_state_t *s
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
  			blk->hashval = 
be32_to_cpu(node->btree[be16_to_cpu(node->hdr.count)-1].hashval);
@@ -1133,10 +1133,10 @@ xfs_da_node_lookup_int(xfs_da_state_t *s
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
