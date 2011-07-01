Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k7LI056086 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77FD74669F
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	APNiWPNBHQb2Azzo for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:06 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIX-0001yI-Rs
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:05 +0000
Message-Id: <20110701094605.827598983@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 17/27] xfs: kill struct xfs_dir2_block
References: <20110701094321.936534538@bombadil.infradead.org>
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
--- xfs.orig/fs/xfs/xfs_dir2_block.h	2011-06-30 09:38:36.596734195 +0200
+++ xfs/fs/xfs/xfs_dir2_block.h	2011-06-30 09:38:38.116734176 +0200
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
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2011-06-30 09:38:36.586734196 +0200
+++ xfs/fs/xfs/xfs_dir2_block.c	2011-06-30 09:38:38.120067509 +0200
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
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2011-06-30 09:38:36.590067529 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.c	2011-06-30 09:38:38.123400842 +0200
@@ -226,7 +226,7 @@ xfs_dir2_block_to_sf(
 	int			size,		/* shortform directory size */
 	xfs_dir2_sf_hdr_t	*sfhp)		/* shortform directory hdr */
 {
-	xfs_dir2_block_t	*block;		/* block structure */
+	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	xfs_dir2_block_tail_t	*btp;		/* block tail pointer */
 	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
 	xfs_inode_t		*dp;		/* incore directory inode */
@@ -248,8 +248,8 @@ xfs_dir2_block_to_sf(
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
@@ -277,8 +277,8 @@ xfs_dir2_block_to_sf(
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
@@ -314,7 +314,7 @@ xfs_dir2_block_to_sf(
 			sfep->namelen = dep->namelen;
 			xfs_dir2_sf_put_offset(sfep,
 				(xfs_dir2_data_aoff_t)
-				((char *)dep - (char *)block));
+				((char *)dep - (char *)hdr));
 			memcpy(sfep->name, dep->name, dep->namelen);
 			xfs_dir2_sfe_put_ino(sfp, sfep,
 					     be64_to_cpu(dep->inumber));
@@ -327,7 +327,7 @@ xfs_dir2_block_to_sf(
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
