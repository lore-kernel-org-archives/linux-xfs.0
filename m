Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 79F0E8048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:31:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3A8038F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:32 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id wp3KBSWNgTA0c4Wy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:30 -0700 (PDT)
Subject: [PATCH 006/145] xfs: make several functions static
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:31:23 -0700
Message-ID: <146612708305.16048.5855007801575308944.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

From: Eric Sandeen <sandeen@sandeen.net>

Al Viro noticed that xfs_lock_inodes should be static, and
that led to ... a few more.

These are just the easy ones, others require moving functions
higher in source files, so that's not done here to keep
this review simple.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_alloc.c     |    2 +-
 libxfs/xfs_alloc.h     |    7 -------
 libxfs/xfs_attr_leaf.h |    3 ---
 libxfs/xfs_rtbitmap.c  |    2 +-
 4 files changed, 2 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 28b3fb9..8520f31 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -80,7 +80,7 @@ xfs_alloc_lookup_ge(
  * Lookup the first record less than or equal to [bno, len]
  * in the btree given by cur.
  */
-int					/* error */
+static int				/* error */
 xfs_alloc_lookup_le(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 135eb3d..92a66ba 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -212,13 +212,6 @@ xfs_free_extent(
 	xfs_fsblock_t	bno,	/* starting block number of extent */
 	xfs_extlen_t	len);	/* length of extent */
 
-int					/* error */
-xfs_alloc_lookup_le(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_agblock_t		bno,	/* starting block of extent */
-	xfs_extlen_t		len,	/* length of extent */
-	int			*stat);	/* success/failure */
-
 int				/* error */
 xfs_alloc_lookup_ge(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 9d7e741..8ef420a 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -50,7 +50,6 @@ int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
-int	xfs_attr_shortform_list(struct xfs_attr_list_context *context);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
 void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
@@ -88,8 +87,6 @@ int	xfs_attr3_leaf_toosmall(struct xfs_da_state *state, int *retval);
 void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
 				       struct xfs_da_state_blk *drop_blk,
 				       struct xfs_da_state_blk *save_blk);
-int	xfs_attr3_root_inactive(struct xfs_trans **trans, struct xfs_inode *dp);
-
 /*
  * Utility routines.
  */
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 70ea975..36fe323 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -65,7 +65,7 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
  * Get a buffer for the bitmap or summary file block specified.
  * The buffer is returned read and locked.
  */
-int
+static int
 xfs_rtbuf_get(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
