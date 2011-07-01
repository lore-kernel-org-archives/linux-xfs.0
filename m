Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k7C6056102 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24C3616748BB
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	TPL1GILr005EzEeD for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:06 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIY-0001zK-7n
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:06 +0000
Message-Id: <20110701094606.199361663@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 19/27] xfs: kill struct xfs_dir2_data
References: <20110701094321.936534538@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_dir2_data_t
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

Remove the confusing xfs_dir2_data structure.  It is supposed to describe
an XFS dir2 data btree block, but due to the variable sized nature of
almost all elements in it it can't actuall do anything close to that
job.  In addition to accessing the fixed offset header structure it was
only used to get a pointer to the first dir or unused entry after it,
which can be trivially replaced by pointer arithmetics on the header
pointer.  For most users that is actually more natural anyway, as they
don't use a typed pointer but rather a character pointer for further
arithmetics.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dir2_data.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_data.c	2011-06-30 09:38:40.133400821 +0200
+++ xfs/fs/xfs/xfs_dir2_data.c	2011-06-30 09:38:41.643400800 +0200
@@ -53,7 +53,6 @@ xfs_dir2_data_check(
 	xfs_dir2_data_free_t	*bf;		/* bestfree table */
 	xfs_dir2_block_tail_t	*btp=NULL;	/* block tail */
 	int			count;		/* count of entries found */
-	xfs_dir2_data_t		*d;		/* data block pointer */
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_data_entry_t	*dep;		/* data entry */
 	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
@@ -70,10 +69,9 @@ xfs_dir2_data_check(
 	struct xfs_name		name;
 
 	mp = dp->i_mount;
-	d = bp->data;
-	hdr = &d->hdr;
+	hdr = bp->data;
 	bf = hdr->bestfree;
-	p = (char *)d->u;
+	p = (char *)(hdr + 1);
 
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC)) {
 		btp = xfs_dir2_block_tail_p(mp, hdr);
@@ -336,7 +334,6 @@ xfs_dir2_data_freescan(
 	xfs_dir2_data_hdr_t	*hdr,		/* data block header */
 	int			*loghead)	/* out: log data header */
 {
-	xfs_dir2_data_t		*d = (xfs_dir2_data_t *)hdr;
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* active data entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused data entry */
@@ -355,7 +352,7 @@ xfs_dir2_data_freescan(
 	/*
 	 * Set up pointers.
 	 */
-	p = (char *)d->u;
+	p = (char *)(hdr + 1);
 	if (be32_to_cpu(hdr->magic) == XFS_DIR2_BLOCK_MAGIC) {
 		btp = xfs_dir2_block_tail_p(mp, hdr);
 		endp = (char *)xfs_dir2_block_leaf_p(btp);
@@ -398,7 +395,6 @@ xfs_dir2_data_init(
 	xfs_dabuf_t		**bpp)		/* output block buffer */
 {
 	xfs_dabuf_t		*bp;		/* block buffer */
-	xfs_dir2_data_t		*d;		/* pointer to block */
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry pointer */
@@ -424,8 +420,7 @@ xfs_dir2_data_init(
 	/*
 	 * Initialize the header.
 	 */
-	d = bp->data;
-	hdr = &d->hdr;
+	hdr = bp->data;
 	hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 	hdr->bestfree[0].offset = cpu_to_be16(sizeof(*hdr));
 	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
@@ -436,7 +431,7 @@ xfs_dir2_data_init(
 	/*
 	 * Set up an unused entry for the block's body.
 	 */
-	dup = &d->u[0].unused;
+	dup = (xfs_dir2_data_unused_t *)(hdr + 1);
 	dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 
 	t = mp->m_dirblksize - (uint)sizeof(*hdr);
Index: xfs/fs/xfs/xfs_dir2_data.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_data.h	2011-06-30 09:38:40.136734154 +0200
+++ xfs/fs/xfs/xfs_dir2_data.h	2011-06-30 09:38:41.646734133 +0200
@@ -20,6 +20,22 @@
 
 /*
  * Directory format 2, data block structures.
+ *
+ * A pure data block looks like the following drawing on disk:
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
+ *
+ * As all the entries are variable sized structures the accessors in this
+ * file need to be used to iterate over them.
  */
 
 struct xfs_dabuf;
@@ -103,23 +119,6 @@ typedef struct xfs_dir2_data_unused {
 	__be16			tag;		/* starting offset of us */
 } xfs_dir2_data_unused_t;
 
-typedef union {
-	xfs_dir2_data_entry_t	entry;
-	xfs_dir2_data_unused_t	unused;
-} xfs_dir2_data_union_t;
-
-/*
- * Generic data block structure, for xfs_db.
- */
-typedef struct xfs_dir2_data {
-	xfs_dir2_data_hdr_t	hdr;		/* magic XFS_DIR2_DATA_MAGIC */
-	xfs_dir2_data_union_t	u[1];
-} xfs_dir2_data_t;
-
-/*
- * Macros.
- */
-
 /*
  * Size of a data entry.
  */
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-06-30 09:38:40.140067486 +0200
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-06-30 09:38:41.646734133 +0200
@@ -785,7 +785,6 @@ xfs_dir2_leaf_getdents(
 	int			byteoff;	/* offset in current block */
 	xfs_dir2_db_t		curdb;		/* db for current block */
 	xfs_dir2_off_t		curoff;		/* current overall offset */
-	xfs_dir2_data_t		*data;		/* data block structure */
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_data_entry_t	*dep;		/* data entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry */
@@ -1044,13 +1043,12 @@ xfs_dir2_leaf_getdents(
 			else if (curoff > newoff)
 				ASSERT(xfs_dir2_byte_to_db(mp, curoff) ==
 				       curdb);
-			data = bp->data;
-			hdr = &data->hdr;
+			hdr = bp->data;
 			xfs_dir2_data_check(dp, bp);
 			/*
 			 * Find our position in the block.
 			 */
-			ptr = (char *)&data->u;
+			ptr = (char *)(hdr + 1);
 			byteoff = xfs_dir2_byte_to_off(mp, curoff);
 			/*
 			 * Skip past the header.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
