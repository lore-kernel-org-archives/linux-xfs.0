Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 60A9B7F3F
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 14:34:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F3799AC004
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 12:34:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zTGoDAtu4r6N5foG for <xfs@oss.sgi.com>;
	Wed, 09 Sep 2015 12:34:16 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 07/13] xfs_repair: Remove BUF_PTR from attr_repair.c
Date: Wed,  9 Sep 2015 14:34:05 -0500
Message-Id: <1441827251-13128-8-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
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

The BUF_PTR macro was removed from kernelspace a while ago
(6292604 xfs: Remove the macro XFS_BUF_PTR) but it lives
on in some parts of xfsprogs.  dir2.c doesn't use it,
but similar code in attr_repair.c does.  remove it from
attr_repair.c to converge the code.

Remove a related but unnecessary cast from a *void b_addr
in dir2.c while we're at it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/attr_repair.c |   12 ++++++------
 repair/dir2.c        |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index fe81df4..5ae2356 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -188,7 +188,7 @@ traverse_int_dablock(xfs_mount_t	*mp,
 			goto error_out;
 		}
 
-		node = (xfs_da_intnode_t *)XFS_BUF_PTR(bp);
+		node = bp->b_addr;
 		btree = M_DIROPS(mp)->node_tree_p(node);
 		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
 
@@ -335,7 +335,7 @@ verify_final_da_path(xfs_mount_t	*mp,
 	 * in the block which should be the final (rightmost) entry
 	 */
 	entry = cursor->level[this_level].index;
-	node = (xfs_da_intnode_t *)XFS_BUF_PTR(cursor->level[this_level].bp);
+	node = cursor->level[this_level].bp->b_addr;
 	btree = M_DIROPS(mp)->node_tree_p(node);
 	M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
 
@@ -513,7 +513,7 @@ verify_da_path(xfs_mount_t	*mp,
 	 * should be processed now in this level.
 	 */
 	entry = cursor->level[this_level].index;
-	node = (xfs_da_intnode_t *)XFS_BUF_PTR(cursor->level[this_level].bp);
+	node = cursor->level[this_level].bp->b_addr;
 	btree = M_DIROPS(mp)->node_tree_p(node);
 	M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
 
@@ -571,7 +571,7 @@ _("can't get map info for block %u of directory inode %" PRIu64 "\n"),
 			return(1);
 		}
 
-		newnode = (xfs_da_intnode_t *)XFS_BUF_PTR(bp);
+		newnode = bp->b_addr;
 		btree = M_DIROPS(mp)->node_tree_p(newnode);
 		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, newnode);
 
@@ -1040,7 +1040,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 		ASSERT(mp->m_sb.sb_blocksize == XFS_BUF_COUNT(bp));
 
 		length = MIN(XFS_BUF_COUNT(bp) - hdrsize, valuelen - amountdone);
-		memmove(value, XFS_BUF_PTR(bp) + hdrsize, length);
+		memmove(value, bp->b_addr + hdrsize, length);
 		amountdone += length;
 		value += length;
 		i++;
@@ -1620,7 +1620,7 @@ process_longform_attr(
 	}
 
 	/* verify leaf block */
-	leaf = (xfs_attr_leafblock_t *)XFS_BUF_PTR(bp);
+	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 
 	/* check sibling pointers in leaf block or root block 0 before
diff --git a/repair/dir2.c b/repair/dir2.c
index d9bd5fc..9398df5 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -347,7 +347,7 @@ verify_final_dir2_path(xfs_mount_t	*mp,
 	 * in the block which should be the final (rightmost) entry
 	 */
 	entry = cursor->level[this_level].index;
-	node = (xfs_da_intnode_t *)(cursor->level[this_level].bp->b_addr);
+	node = cursor->level[this_level].bp->b_addr;
 	btree = M_DIROPS(mp)->node_tree_p(node);
 	M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
