Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TE3fFM104850 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 09:03:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B28DD1D7DD37
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 07:03:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	EQVcCp0vnoAsVE0R for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 07:03:40 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QbvMi-0008JC-3i
	for xfs@oss.sgi.com; Wed, 29 Jun 2011 14:03:40 +0000
Message-Id: <20110629140340.079801018@bombadil.infradead.org>
Date: Wed, 29 Jun 2011 10:01:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 18/27] xfs: kill struct xfs_dir2_block
References: <20110629140109.003209430@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_dir2_block_t
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Remove the confusing xfs_dir2_block structure.  It is supposed to describe
an XFS dir2 block format btree block, but due to the variable sized nature
of almost all elements in it it can't actuall do anything close to that
job.  In addition to accessing the fixed offset header structure it was
only used to get a pointer to the first dir or unused entry after it,
which can be trivially replaced by pointer arithmetics on the header
pointer.  For most users that is actually more natural anyway, as they
don't use a typed pointer but rather a character pointer for further
arithmetics.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dir2_block.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.h	2011-06-29 13:19:30.639066065 +0200
+++ xfs/fs/xfs/xfs_dir2_block.h	2011-06-29 13:22:03.604904045 +0200
@@ -19,10 +19,30 @@
 #define	__XFS_DIR2_BLOCK_H__
 
 /*
- * xfs_dir2_block.h
- * Directory version 2, single block format structures
+ * Directory version 2, single block format structures.
+ *
+ * The single block format looks like the following drawing on disk:
+ *
+ *    +-------------------------------------------------+
+ *    | xfs_dir2_data_hdr_t                             |
+ *    +-------------------------------------------------+
+ *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
+ *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
+ *    | xfs_dir2_data_entry_t OR xfs_dir2_data_unused_t |
+ *    | ...                                             |
+ *    +-------------------------------------------------+
+ *    | unused space                                    |
+ *    +-------------------------------------------------+
+ *    | ...                                             |
+ *    | xfs_dir2_leaf_entry_t                           |
+ *    | xfs_dir2_leaf_entry_t                           |
+ *    +-------------------------------------------------+
+ *    | xfs_dir2_block_tail_t                           |
+ *    +-------------------------------------------------+
+ *
+ * As all the entries are variable sized structures the accessors in this
+ * file and xfs_dir2_data.h need to be used to iterate over them.
  */
-
 struct uio;
 struct xfs_dabuf;
 struct xfs_da_args;
@@ -32,14 +52,6 @@ struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
 
-/*
- * The single block format is as follows:
- * xfs_dir2_data_hdr_t structure
- * xfs_dir2_data_entry_t and xfs_dir2_data_unused_t structures
- * xfs_dir2_leaf_entry_t structures
- * xfs_dir2_block_tail_t structure
- */
-
 #define	XFS_DIR2_BLOCK_MAGIC	0x58443242	/* XD2B: for one block dirs */
 
 typedef struct xfs_dir2_block_tail {
@@ -48,16 +60,6 @@ typedef struct xfs_dir2_block_tail {
 } xfs_dir2_block_tail_t;
 
 /*
- * Generic single-block structure, for xfs_db.
- */
-typedef struct xfs_dir2_block {
-	xfs_dir2_data_hdr_t	hdr;		/* magic XFS_DIR2_BLOCK_MAGIC */
-	xfs_dir2_data_union_t	u[1];
-	xfs_dir2_leaf_entry_t	leaf[1];
-	xfs_dir2_block_tail_t	tail;
-} xfs_dir2_block_t;
-
-/*
  * Pointer to the leaf header embedded in a data block (1-block format)
  */
 static inline xfs_dir2_block_tail_t *
Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2011-06-29 13:19:30.649066010 +0200
+++ xfs/fs/xfs/xfs_dir2_block.c	2011-06-29 13:19:45.908983340 +0200
@@ -437,7 +437,6 @@ xfs_dir2_block_getdents(
 	xfs_off_t		*offset,
 	filldir_t		filldir)
 {
-	xfs_dir2_block_t	*block;		/* directory block structure */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dabuf_t		*bp;		/* buffer for block */
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
@@ -471,14 +470,13 @@ xfs_dir2_block_getdents(
 	 * We'll skip entries before this.
 	 */
 	wantoff = xfs_dir2_dataptr_to_off(mp, *offset);
-	block = bp->data;
-	hdr = &block->hdr;
+	hdr = bp->data;
 	xfs_dir2_data_check(dp, bp);
 	/*
 	 * Set up values for the loop.
 	 */
 	btp = xfs_dir2_block_tail_p(mp, hdr);
-	ptr = (char *)block->u;
+	ptr = (char *)(hdr + 1);
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 
 	/*
@@ -1020,7 +1018,6 @@ xfs_dir2_sf_to_block(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
 	xfs_dir2_db_t		blkno;		/* dir-relative block # (0) */
-	xfs_dir2_block_t	*block;		/* block structure */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
 	xfs_dabuf_t		*bp;		/* block buffer */
@@ -1091,8 +1088,7 @@ xfs_dir2_sf_to_block(
 		kmem_free(sfp);
 		return error;
 	}
-	block = bp->data;
-	hdr = &block->hdr;
+	hdr = bp->data;
 	hdr->magic = cpu_to_be32(XFS_DIR2_BLOCK_MAGIC);
 	/*
 	 * Compute size of block "tail" area.
@@ -1103,7 +1099,7 @@ xfs_dir2_sf_to_block(
 	 * The whole thing is initialized to free by the init routine.
 	 * Say we're using the leaf and tail area.
 	 */
-	dup = (xfs_dir2_data_unused_t *)block->u;
+	dup = (xfs_dir2_data_unused_t *)(hdr + 1);
 	needlog = needscan = 0;
 	xfs_dir2_data_use_free(tp, bp, dup, mp->m_dirblksize - i, i, &needlog,
 		&needscan);
Index: xfs/fs/xfs/xfs_dir2_sf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2011-06-29 13:19:30.662399271 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.c	2011-06-29 13:19:45.912316655 +0200
@@ -230,7 +230,7 @@ xfs_dir2_block_to_sf(
 	int			size,		/* shortform directory size */
 	xfs_dir2_sf_hdr_t	*sfhp)		/* shortform directory hdr */
 {
-	xfs_dir2_block_t	*block;		/* block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_block_tail_t	*btp;		/* block tail pointer */
 	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
 	xfs_inode_t		*dp;		/* incore directory inode */
@@ -252,8 +252,8 @@ xfs_dir2_block_to_sf(
 	 * Make a copy of the block data, so we can shrink the inode
 	 * and add local data.
 	 */
-	block = kmem_alloc(mp->m_dirblksize, KM_SLEEP);
-	memcpy(block, bp->data, mp->m_dirblksize);
+	hdr = kmem_alloc(mp->m_dirblksize, KM_SLEEP);
+	memcpy(hdr, bp->data, mp->m_dirblksize);
 	logflags = XFS_ILOG_CORE;
 	if ((error = xfs_dir2_shrink_inode(args, mp->m_dirdatablk, bp))) {
 		ASSERT(error != ENOSPC);
@@ -281,8 +281,8 @@ xfs_dir2_block_to_sf(
 	/*
 	 * Set up to loop over the block's entries.
 	 */
-	btp = xfs_dir2_block_tail_p(mp, &block->hdr);
-	ptr = (char *)block->u;
+	btp = xfs_dir2_block_tail_p(mp, hdr);
+	ptr = (char *)(hdr + 1);
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	/*
@@ -318,7 +318,7 @@ xfs_dir2_block_to_sf(
 			sfep->namelen = dep->namelen;
 			xfs_dir2_sf_put_offset(sfep,
 				(xfs_dir2_data_aoff_t)
-				((char *)dep - (char *)block));
+				((char *)dep - (char *)hdr));
 			memcpy(sfep->name, dep->name, dep->namelen);
 			xfs_dir2_sfe_put_ino(sfp, sfep,
 					     be64_to_cpu(dep->inumber));
@@ -331,7 +331,7 @@ xfs_dir2_block_to_sf(
 	xfs_dir2_sf_check(args);
 out:
 	xfs_trans_log_inode(args->trans, dp, logflags);
-	kmem_free(block);
+	kmem_free(hdr);
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
