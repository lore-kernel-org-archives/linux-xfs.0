Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B54927CBF
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 05:23:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 34B58AC005
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 03:23:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	C3tkyeGraVDIJIEV for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 03:23:35 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UmiDE-00017Y-KL
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:32 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UmiD4-000671-67
	for xfs@oss.sgi.com; Wed, 12 Jun 2013 20:23:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 26/27] xfs: minor cleanups
Date: Wed, 12 Jun 2013 20:22:46 +1000
Message-Id: <1371032567-21772-27-git-send-email-david@fromorbit.com>
In-Reply-To: <1371032567-21772-1-git-send-email-david@fromorbit.com>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
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

These come from syncing the shared userspace and kernel code. Small
whitespace and trivial cleanups.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_leaf.c   |   12 ------------
 fs/xfs/xfs_attr_remote.c |    8 +-------
 fs/xfs/xfs_bmap_btree.c  |    4 +---
 fs/xfs/xfs_inode.c       |    4 ++--
 4 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index a7fdd0d..18aada8 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -79,16 +79,6 @@ STATIC int xfs_attr3_leaf_figure_balance(xfs_da_state_t *state,
 			int *number_usedbytes_in_blk1);
 
 /*
- * Routines used for shrinking the Btree.
- */
-STATIC int xfs_attr3_node_inactive(xfs_trans_t **trans, xfs_inode_t *dp,
-				  struct xfs_buf *bp, int level);
-STATIC int xfs_attr3_leaf_inactive(xfs_trans_t **trans, xfs_inode_t *dp,
-				  struct xfs_buf *bp);
-STATIC int xfs_attr3_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
-				   xfs_dablk_t blkno, int blkcnt);
-
-/*
  * Utility routines.
  */
 STATIC void xfs_attr3_leaf_moveents(struct xfs_attr_leafblock *src_leaf,
@@ -1307,7 +1297,6 @@ xfs_attr3_leaf_compact(
 	ichdr_dst->freemap[0].size = ichdr_dst->firstused -
 						ichdr_dst->freemap[0].base;
 
-
 	/* write the header back to initialise the underlying buffer */
 	xfs_attr3_leaf_hdr_to_disk(leaf_dst, ichdr_dst);
 
@@ -2712,4 +2701,3 @@ xfs_attr3_leaf_flipflags(
 
 	return error;
 }
-
diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index 39a59ea..fed6d78 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -250,7 +250,7 @@ xfs_attr_rmtval_copyout(
 		int hdr_size = 0;
 		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, XFS_LBSIZE(mp));
 
-		byte_cnt = min_t(int, *valuelen, byte_cnt);
+		byte_cnt = min(*valuelen, byte_cnt);
 
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			if (!xfs_attr3_rmt_hdr_ok(mp, src, ino, *offset,
@@ -544,11 +544,6 @@ xfs_attr_rmtval_remove(
 
 	/*
 	 * Roll through the "value", invalidating the attribute value's blocks.
-	 * Note that args->rmtblkcnt is the minimum number of data blocks we'll
-	 * see for a CRC enabled remote attribute. Each extent will have a
-	 * header, and so we may have more blocks than we realise here.  If we
-	 * fail to map the blocks correctly, we'll have problems with the buffer
-	 * lookups.
 	 */
 	lblkno = args->rmtblkno;
 	blkcnt = args->rmtblkcnt;
@@ -629,4 +624,3 @@ xfs_attr_rmtval_remove(
 	}
 	return(0);
 }
-
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 0c61a22..843ff45 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -722,7 +722,7 @@ xfs_bmbt_key_diff(
 				      cur->bc_rec.b.br_startoff;
 }
 
-static int
+static bool
 xfs_bmbt_verify(
 	struct xfs_buf		*bp)
 {
@@ -775,7 +775,6 @@ xfs_bmbt_verify(
 		return false;
 
 	return true;
-
 }
 
 static void
@@ -789,7 +788,6 @@ xfs_bmbt_read_verify(
 				     bp->b_target->bt_mount, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
-
 }
 
 static void
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e724464..111ebf4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1192,8 +1192,8 @@ xfs_iextents_copy(
 		}
 
 		/* Translate to on disk format */
-		put_unaligned(cpu_to_be64(ep->l0), &dp->l0);
-		put_unaligned(cpu_to_be64(ep->l1), &dp->l1);
+		put_unaligned_be64(ep->l0, &dp->l0);
+		put_unaligned_be64(ep->l1, &dp->l1);
 		dp++;
 		copied++;
 	}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
