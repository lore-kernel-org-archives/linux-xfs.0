Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 11:23:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8OIMpYQ001263
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 11:22:52 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 968A247942D
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 11:24:07 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 6uYpySy72G5GefDO for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 11:24:07 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8OIO6IF000978
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 20:24:06 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8OIO6pY000976
	for xfs@oss.sgi.com; Wed, 24 Sep 2008 20:24:06 +0200
Date: Wed, 24 Sep 2008 20:24:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] generic btree patch for xfs-cmds
Message-ID: <20080924182406.GA899@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Update the shared kernel and userspace code to the latest version with
the generic btree implementation.  Contains one additional patch to move
the __KERNEL__ ifdefs around in xfs_btree.h over the current kernel
version, which is posted and waiting to be commited for the kernel.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/xfsprogs/include/xfs_btree.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_btree.h	2008-09-24 19:50:58.000000000 +0200
+++ xfs-cmds/xfsprogs/include/xfs_btree.h	2008-09-24 20:01:30.000000000 +0200
@@ -63,15 +63,10 @@ typedef struct xfs_btree_lblock {
 /*
  * Combined header and structure, used by common code.
  */
-typedef struct xfs_btree_hdr
-{
+typedef struct xfs_btree_block {
 	__be32		bb_magic;	/* magic number for block type */
 	__be16		bb_level;	/* 0 is a leaf */
 	__be16		bb_numrecs;	/* current # of data records */
-} xfs_btree_hdr_t;
-
-typedef struct xfs_btree_block {
-	xfs_btree_hdr_t	bb_h;		/* header */
 	union {
 		struct {
 			__be32		bb_leftsib;
@@ -85,6 +80,31 @@ typedef struct xfs_btree_block {
 } xfs_btree_block_t;
 
 /*
+ * Generic key, ptr and record wrapper structures.
+ *
+ * These are disk format structures, and are converted where necessary
+ * by the btree specific code that needs to interpret them.
+ */
+union xfs_btree_ptr {
+	__be32			s;	/* short form ptr */
+	__be64			l;	/* long form ptr */
+};
+
+union xfs_btree_key {
+	xfs_bmbt_key_t		bmbt;
+	xfs_bmdr_key_t		bmbr;	/* bmbt root block */
+	xfs_alloc_key_t		alloc;
+	xfs_inobt_key_t		inobt;
+};
+
+union xfs_btree_rec {
+	xfs_bmbt_rec_t		bmbt;
+	xfs_bmdr_rec_t		bmbr;	/* bmbt root block */
+	xfs_alloc_rec_t		alloc;
+	xfs_inobt_rec_t		inobt;
+};
+
+/*
  * For logging record fields.
  */
 #define	XFS_BB_MAGIC		0x01
@@ -96,16 +116,39 @@ typedef struct xfs_btree_block {
 #define	XFS_BB_ALL_BITS		((1 << XFS_BB_NUM_BITS) - 1)
 
 /*
- * Boolean to select which form of xfs_btree_block_t.bb_u to use.
- */
-#define	XFS_BTREE_LONG_PTRS(btnum)	((btnum) == XFS_BTNUM_BMAP)
-
-/*
  * Magic numbers for btree blocks.
  */
 extern const __uint32_t	xfs_magics[];
 
 /*
+ * Generic stats interface
+ */
+#define __XFS_BTREE_STATS_INC(type, stat) \
+	XFS_STATS_INC(xs_ ## type ## _2_ ## stat)
+#define XFS_BTREE_STATS_INC(cur, stat)  \
+do {    \
+	switch (cur->bc_btnum) {  \
+	case XFS_BTNUM_BNO: __XFS_BTREE_STATS_INC(abtb, stat); break;	\
+	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_INC(abtc, stat); break;	\
+	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(bmbt, stat); break;	\
+	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
+	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	}       \
+} while (0)
+
+#define __XFS_BTREE_STATS_ADD(type, stat, val) \
+	XFS_STATS_ADD(xs_ ## type ## _2_ ## stat, val)
+#define XFS_BTREE_STATS_ADD(cur, stat, val)  \
+do {    \
+	switch (cur->bc_btnum) {  \
+	case XFS_BTNUM_BNO: __XFS_BTREE_STATS_ADD(abtb, stat, val); break; \
+	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_ADD(abtc, stat, val); break; \
+	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_ADD(bmbt, stat, val); break; \
+	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
+	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	}       \
+} while (0)
+/*
  * Maximum and minimum records in a btree block.
  * Given block size, type prefix, and leaf flag (0 or 1).
  * The divisor below is equivalent to lf ? (e1) : (e2) but that produces
@@ -136,6 +179,96 @@ extern const __uint32_t	xfs_magics[];
 
 #define	XFS_BTREE_MAXLEVELS	8	/* max of all btrees */
 
+struct xfs_btree_ops {
+	/* size of the key and record structures */
+	size_t	key_len;
+	size_t	rec_len;
+
+	/* cursor operations */
+	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
+	void	(*update_cursor)(struct xfs_btree_cur *src,
+				 struct xfs_btree_cur *dst);
+
+	/* update btree root pointer */
+	void	(*set_root)(struct xfs_btree_cur *cur,
+				union xfs_btree_ptr *nptr, int level_change);
+	int	(*kill_root)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
+				int level, union xfs_btree_ptr *newroot);
+
+	/* block allocation / freeing */
+	int	(*alloc_block)(struct xfs_btree_cur *cur,
+			       union xfs_btree_ptr *start_bno,
+			       union xfs_btree_ptr *new_bno,
+			       int length, int *stat);
+	int	(*free_block)(struct xfs_btree_cur *cur, struct xfs_buf *bp);
+
+	/* update last record information */
+	void	(*update_lastrec)(struct xfs_btree_cur *cur,
+				  struct xfs_btree_block *block,
+				  union xfs_btree_rec *rec,
+				  int ptr, int reason);
+
+	/* records in block/level */
+	int	(*get_minrecs)(struct xfs_btree_cur *cur, int level);
+	int	(*get_maxrecs)(struct xfs_btree_cur *cur, int level);
+
+	/* records on disk.  Matter for the root in inode case. */
+	int	(*get_dmaxrecs)(struct xfs_btree_cur *cur, int level);
+
+	/* init values of btree structures */
+	void	(*init_key_from_rec)(union xfs_btree_key *key,
+				     union xfs_btree_rec *rec);
+	void	(*init_rec_from_key)(union xfs_btree_key *key,
+				     union xfs_btree_rec *rec);
+	void	(*init_rec_from_cur)(struct xfs_btree_cur *cur,
+				     union xfs_btree_rec *rec);
+	void	(*init_ptr_from_cur)(struct xfs_btree_cur *cur,
+				     union xfs_btree_ptr *ptr);
+
+	/* difference between key value and cursor value */
+	__int64_t (*key_diff)(struct xfs_btree_cur *cur,
+			      union xfs_btree_key *key);
+
+#ifdef DEBUG
+	/* check that k1 is lower than k2 */
+	int	(*keys_inorder)(struct xfs_btree_cur *cur,
+				union xfs_btree_key *k1,
+				union xfs_btree_key *k2);
+
+	/* check that r1 is lower than r2 */
+	int	(*recs_inorder)(struct xfs_btree_cur *cur,
+				union xfs_btree_rec *r1,
+				union xfs_btree_rec *r2);
+#endif
+
+	/* btree tracing */
+#ifdef XFS_BTREE_TRACE
+	void		(*trace_enter)(struct xfs_btree_cur *, const char *,
+				       char *, int, int, __psunsigned_t,
+				       __psunsigned_t, __psunsigned_t,
+				       __psunsigned_t, __psunsigned_t,
+				       __psunsigned_t, __psunsigned_t,
+				       __psunsigned_t, __psunsigned_t,
+				       __psunsigned_t, __psunsigned_t);
+	void		(*trace_cursor)(struct xfs_btree_cur *, __uint32_t *,
+					__uint64_t *, __uint64_t *);
+	void		(*trace_key)(struct xfs_btree_cur *,
+				     union xfs_btree_key *, __uint64_t *,
+				     __uint64_t *);
+	void		(*trace_record)(struct xfs_btree_cur *,
+					union xfs_btree_rec *, __uint64_t *,
+					__uint64_t *, __uint64_t *);
+#endif
+};
+
+/*
+ * Reasons for the update_lastrec method to be called.
+ */
+#define LASTREC_UPDATE	0
+#define LASTREC_INSREC	1
+#define LASTREC_DELREC	2
+
+
 /*
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
@@ -144,6 +277,8 @@ typedef struct xfs_btree_cur
 {
 	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
 	struct xfs_mount	*bc_mp;	/* file system mount struct */
+	const struct xfs_btree_ops *bc_ops;
+	uint			bc_flags; /* btree features - below */
 	union {
 		xfs_alloc_rec_incore_t	a;
 		xfs_bmbt_irec_t		b;
@@ -175,6 +310,12 @@ typedef struct xfs_btree_cur
 	}		bc_private;	/* per-btree type data */
 } xfs_btree_cur_t;
 
+/* cursor flags */
+#define XFS_BTREE_LONG_PTRS		(1<<0)	/* pointers are 64bits long */
+#define XFS_BTREE_ROOT_IN_INODE		(1<<1)	/* root may be variable size */
+#define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
+
+
 #define	XFS_BTREE_NOERROR	0
 #define	XFS_BTREE_ERROR		1
 
@@ -186,81 +327,35 @@ typedef struct xfs_btree_cur
 #define	XFS_BUF_TO_SBLOCK(bp)	((xfs_btree_sblock_t *)XFS_BUF_PTR(bp))
 
 
-#ifdef DEBUG
 /*
- * Debug routine: check that block header is ok.
+ * Check that long form block header is ok.
  */
-void
-xfs_btree_check_block(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_block_t	*block,	/* generic btree block pointer */
+int					/* error (0 or EFSCORRUPTED) */
+xfs_btree_check_lblock(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	struct xfs_btree_lblock	*block,	/* btree long form block pointer */
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp);	/* buffer containing block, if any */
 
 /*
- * Debug routine: check that keys are in the right order.
+ * Check that block header is ok.
  */
-void
-xfs_btree_check_key(
-	xfs_btnum_t		btnum,	/* btree identifier */
-	void			*ak1,	/* pointer to left (lower) key */
-	void			*ak2);	/* pointer to right (higher) key */
-
-/*
- * Debug routine: check that records are in the right order.
- */
-void
-xfs_btree_check_rec(
-	xfs_btnum_t		btnum,	/* btree identifier */
-	void			*ar1,	/* pointer to left (lower) record */
-	void			*ar2);	/* pointer to right (higher) record */
-#else
-#define	xfs_btree_check_block(a,b,c,d)
-#define	xfs_btree_check_key(a,b,c)
-#define	xfs_btree_check_rec(a,b,c)
-#endif	/* DEBUG */
-
-/*
- * Checking routine: check that long form block header is ok.
- */
-int					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_lblock(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_lblock_t	*block,	/* btree long form block pointer */
+int
+xfs_btree_check_block(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	struct xfs_btree_block	*block,	/* generic btree block pointer */
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp);	/* buffer containing block, if any */
 
 /*
- * Checking routine: check that (long) pointer is ok.
+ * Check that (long) pointer is ok.
  */
 int					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_lptr(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_dfsbno_t		ptr,	/* btree block disk address */
 	int			level);	/* btree block level */
 
-#define xfs_btree_check_lptr_disk(cur, ptr, level) \
-	xfs_btree_check_lptr(cur, be64_to_cpu(ptr), level)
-
-/*
- * Checking routine: check that short form block header is ok.
- */
-int					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_sblock(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_sblock_t	*block,	/* btree short form block pointer */
-	int			level,	/* level of the btree block */
-	struct xfs_buf		*bp);	/* buffer containing block */
-
-/*
- * Checking routine: check that (short) pointer is ok.
- */
-int					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_sptr(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agblock_t		ptr,	/* btree block disk address */
-	int			level);	/* btree block level */
-
 /*
  * Delete the btree cursor.
  */
@@ -279,15 +374,6 @@ xfs_btree_dup_cursor(
 	xfs_btree_cur_t		**ncur);/* output cursor */
 
 /*
- * Change the cursor to point to the first record in the current block
- * at the given level.  Other levels are unaffected.
- */
-int					/* success=1, failure=0 */
-xfs_btree_firstrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level);	/* level to change */
-
-/*
  * Get a buffer for the block, return it with no data read.
  * Long-form addressing.
  */
@@ -311,20 +397,6 @@ xfs_btree_get_bufs(
 	uint			lock);	/* lock flags for get_buf */
 
 /*
- * Allocate a new btree cursor.
- * The cursor is either for allocation (A) or bmap (B).
- */
-xfs_btree_cur_t *			/* new btree cursor */
-xfs_btree_init_cursor(
-	struct xfs_mount	*mp,	/* file system mount point */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	struct xfs_buf		*agbp,	/* (A only) buffer for agf structure */
-	xfs_agnumber_t		agno,	/* (A only) allocation group number */
-	xfs_btnum_t		btnum,	/* btree identifier */
-	struct xfs_inode	*ip,	/* (B only) inode owning the btree */
-	int			whichfork); /* (B only) data/attr fork */
-
-/*
  * Check for the cursor referring to the last block at the given level.
  */
 int					/* 1=is last block, 0=not last block */
@@ -333,15 +405,6 @@ xfs_btree_islastblock(
 	int			level);	/* level to check */
 
 /*
- * Change the cursor to point to the last record in the current block
- * at the given level.  Other levels are unaffected.
- */
-int					/* success=1, failure=0 */
-xfs_btree_lastrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level);	/* level to change */
-
-/*
  * Compute first and last byte offsets for the fields given.
  * Interprets the offsets table, which contains struct field offsets.
  */
@@ -402,37 +465,53 @@ xfs_btree_reada_bufs(
 	xfs_extlen_t		count);	/* count of filesystem blocks */
 
 /*
- * Read-ahead btree blocks, at the given level.
- * Bits in lr are set from XFS_BTCUR_{LEFT,RIGHT}RA.
+ * Set the buffer for level "lev" in the cursor to bp, releasing
+ * any previous buffer.
  */
-int					/* readahead block count */
-xfs_btree_readahead_core(
+void
+xfs_btree_setbuf(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			lev,	/* level in btree */
-	int			lr);	/* left/right bits */
+	struct xfs_buf		*bp);	/* new buffer to set */
 
-static inline int			/* readahead block count */
-xfs_btree_readahead(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			lev,	/* level in btree */
-	int			lr)	/* left/right bits */
-{
-	if ((cur->bc_ra[lev] | lr) == cur->bc_ra[lev])
-		return 0;
 
-	return xfs_btree_readahead_core(cur, lev, lr);
-}
+/*
+ * Common btree core entry points.
+ */
+int xfs_btree_increment(struct xfs_btree_cur *, int, int *);
+int xfs_btree_decrement(struct xfs_btree_cur *, int, int *);
+int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
+int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
+int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
+int xfs_btree_kill_iroot(struct xfs_btree_cur *);
+int xfs_btree_insert(struct xfs_btree_cur *, int *);
+int xfs_btree_delete(struct xfs_btree_cur *, int *);
+int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
 
+/*
+ * Internal btree helpers also used by xfs_bmap.c.
+ */
+void xfs_btree_log_block(struct xfs_btree_cur *, struct xfs_buf *, int);
+void xfs_btree_log_recs(struct xfs_btree_cur *, struct xfs_buf *, int, int);
 
 /*
- * Set the buffer for level "lev" in the cursor to bp, releasing
- * any previous buffer.
+ * Helpers.
  */
-void
-xfs_btree_setbuf(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			lev,	/* level in btree */
-	struct xfs_buf		*bp);	/* new buffer to set */
+static inline int xfs_btree_get_numrecs(struct xfs_btree_block *block)
+{
+	return be16_to_cpu(block->bb_numrecs);
+}
+
+static inline void xfs_btree_set_numrecs(struct xfs_btree_block *block,
+		__uint16_t numrecs)
+{
+	block->bb_numrecs = cpu_to_be16(numrecs);
+}
+
+static inline int xfs_btree_get_level(struct xfs_btree_block *block)
+{
+	return be16_to_cpu(block->bb_level);
+}
 
 
 /*
Index: xfs-cmds/xfsprogs/include/xfs_alloc_btree.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_alloc_btree.h	2008-09-24 19:50:58.000000000 +0200
+++ xfs-cmds/xfsprogs/include/xfs_alloc_btree.h	2008-09-24 20:01:15.000000000 +0200
@@ -94,62 +94,9 @@ typedef	struct xfs_btree_sblock xfs_allo
 #define	XFS_ALLOC_PTR_ADDR(bb,i,cur)	\
 	XFS_BTREE_PTR_ADDR(xfs_alloc, bb, i, XFS_ALLOC_BLOCK_MAXRECS(1, cur))
 
-/*
- * Decrement cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-extern int xfs_alloc_decrement(struct xfs_btree_cur *cur, int level, int *stat);
 
-/*
- * Delete the record pointed to by cur.
- * The cursor refers to the place where the record was (could be inserted)
- * when the operation returns.
- */
-extern int xfs_alloc_delete(struct xfs_btree_cur *cur, int *stat);
-
-/*
- * Get the data from the pointed-to record.
- */
-extern int xfs_alloc_get_rec(struct xfs_btree_cur *cur,	xfs_agblock_t *bno,
-				xfs_extlen_t *len, int *stat);
-
-/*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-extern int xfs_alloc_increment(struct xfs_btree_cur *cur, int level, int *stat);
-
-/*
- * Insert the current record at the point referenced by cur.
- * The cursor may be inconsistent on return if splits have been done.
- */
-extern int xfs_alloc_insert(struct xfs_btree_cur *cur, int *stat);
-
-/*
- * Lookup the record equal to [bno, len] in the btree given by cur.
- */
-extern int xfs_alloc_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-				xfs_extlen_t len, int *stat);
-
-/*
- * Lookup the first record greater than or equal to [bno, len]
- * in the btree given by cur.
- */
-extern int xfs_alloc_lookup_ge(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-				xfs_extlen_t len, int *stat);
-
-/*
- * Lookup the first record less than or equal to [bno, len]
- * in the btree given by cur.
- */
-extern int xfs_alloc_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-				xfs_extlen_t len, int *stat);
-
-/*
- * Update the record referred to by cur, to the value given by [bno, len].
- * This either works (return 0) or gets an EFSCORRUPTED error.
- */
-extern int xfs_alloc_update(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-				xfs_extlen_t len);
+extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
+		struct xfs_trans *, struct xfs_buf *,
+		xfs_agnumber_t, xfs_btnum_t);
 
 #endif	/* __XFS_ALLOC_BTREE_H__ */
Index: xfs-cmds/xfsprogs/include/xfs_ialloc_btree.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_ialloc_btree.h	2008-09-24 19:50:58.000000000 +0200
+++ xfs-cmds/xfsprogs/include/xfs_ialloc_btree.h	2008-09-24 20:01:15.000000000 +0200
@@ -116,63 +116,7 @@ typedef	struct xfs_btree_sblock xfs_inob
 	(XFS_BTREE_PTR_ADDR(xfs_inobt, bb, \
 				i, XFS_INOBT_BLOCK_MAXRECS(1, cur)))
 
-/*
- * Decrement cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-extern int xfs_inobt_decrement(struct xfs_btree_cur *cur, int level, int *stat);
-
-/*
- * Delete the record pointed to by cur.
- * The cursor refers to the place where the record was (could be inserted)
- * when the operation returns.
- */
-extern int xfs_inobt_delete(struct xfs_btree_cur *cur, int *stat);
-
-/*
- * Get the data from the pointed-to record.
- */
-extern int xfs_inobt_get_rec(struct xfs_btree_cur *cur, xfs_agino_t *ino,
-			     __int32_t *fcnt, xfs_inofree_t *free, int *stat);
-
-/*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-extern int xfs_inobt_increment(struct xfs_btree_cur *cur, int level, int *stat);
-
-/*
- * Insert the current record at the point referenced by cur.
- * The cursor may be inconsistent on return if splits have been done.
- */
-extern int xfs_inobt_insert(struct xfs_btree_cur *cur, int *stat);
-
-/*
- * Lookup the record equal to ino in the btree given by cur.
- */
-extern int xfs_inobt_lookup_eq(struct xfs_btree_cur *cur, xfs_agino_t ino,
-				__int32_t fcnt, xfs_inofree_t free, int *stat);
-
-/*
- * Lookup the first record greater than or equal to ino
- * in the btree given by cur.
- */
-extern int xfs_inobt_lookup_ge(struct xfs_btree_cur *cur, xfs_agino_t ino,
-				__int32_t fcnt,	xfs_inofree_t free, int *stat);
-
-/*
- * Lookup the first record less than or equal to ino
- * in the btree given by cur.
- */
-extern int xfs_inobt_lookup_le(struct xfs_btree_cur *cur, xfs_agino_t ino,
-				__int32_t fcnt,	xfs_inofree_t free, int *stat);
-
-/*
- * Update the record referred to by cur, to the value given
- * by [ino, fcnt, free].
- * This either works (return 0) or gets an EFSCORRUPTED error.
- */
-extern int xfs_inobt_update(struct xfs_btree_cur *cur, xfs_agino_t ino,
-				__int32_t fcnt, xfs_inofree_t free);
+extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
+		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);
 
 #endif	/* __XFS_IALLOC_BTREE_H__ */
Index: xfs-cmds/xfsprogs/include/xfs_bmap_btree.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_bmap_btree.h	2008-09-24 19:50:58.000000000 +0200
+++ xfs-cmds/xfsprogs/include/xfs_bmap_btree.h	2008-09-24 20:01:30.000000000 +0200
@@ -24,6 +24,7 @@ struct xfs_btree_cur;
 struct xfs_btree_lblock;
 struct xfs_mount;
 struct xfs_inode;
+struct xfs_trans;
 
 /*
  * Bmap root header, on-disk form only.
@@ -230,37 +231,11 @@ typedef struct xfs_btree_lblock xfs_bmbt
 	 be16_to_cpu((bb)->bb_numrecs) <= (mp)->m_bmap_dmxr[(level) != 0])
 
 
-#ifdef __KERNEL__
-
-#if defined(XFS_BMBT_TRACE)
-/*
- * Trace buffer entry types.
- */
-#define XFS_BMBT_KTRACE_ARGBI	1
-#define XFS_BMBT_KTRACE_ARGBII	2
-#define XFS_BMBT_KTRACE_ARGFFFI 3
-#define XFS_BMBT_KTRACE_ARGI	4
-#define XFS_BMBT_KTRACE_ARGIFK	5
-#define XFS_BMBT_KTRACE_ARGIFR	6
-#define XFS_BMBT_KTRACE_ARGIK	7
-#define XFS_BMBT_KTRACE_CUR	8
-
-#define XFS_BMBT_TRACE_SIZE	4096	/* size of global trace buffer */
-#define XFS_BMBT_KTRACE_SIZE	32	/* size of per-inode trace buffer */
-extern ktrace_t	*xfs_bmbt_trace_buf;
-#endif
-
-#endif	/* __KERNEL__ */
-
 /*
  * Prototypes for xfs_bmap.c to call.
  */
 extern void xfs_bmdr_to_bmbt(xfs_bmdr_block_t *, int, xfs_bmbt_block_t *, int);
-extern int xfs_bmbt_decrement(struct xfs_btree_cur *, int, int *);
-extern int xfs_bmbt_delete(struct xfs_btree_cur *, int *);
 extern void xfs_bmbt_get_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
-extern xfs_bmbt_block_t *xfs_bmbt_get_block(struct xfs_btree_cur *cur,
-						int, struct xfs_buf **bpp);
 extern xfs_filblks_t xfs_bmbt_get_blockcount(xfs_bmbt_rec_host_t *r);
 extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_host_t *r);
 extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_host_t *r);
@@ -270,22 +245,6 @@ extern void xfs_bmbt_disk_get_all(xfs_bm
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
 
-extern int xfs_bmbt_increment(struct xfs_btree_cur *, int, int *);
-extern int xfs_bmbt_insert(struct xfs_btree_cur *, int *);
-extern void xfs_bmbt_log_block(struct xfs_btree_cur *, struct xfs_buf *, int);
-extern void xfs_bmbt_log_recs(struct xfs_btree_cur *, struct xfs_buf *, int,
-				int);
-extern int xfs_bmbt_lookup_eq(struct xfs_btree_cur *, xfs_fileoff_t,
-				xfs_fsblock_t, xfs_filblks_t, int *);
-extern int xfs_bmbt_lookup_ge(struct xfs_btree_cur *, xfs_fileoff_t,
-				xfs_fsblock_t, xfs_filblks_t, int *);
-
-/*
- * Give the bmap btree a new root block.  Copy the old broot contents
- * down into a real block and make the broot point to it.
- */
-extern int xfs_bmbt_newroot(struct xfs_btree_cur *cur, int *lflags, int *stat);
-
 extern void xfs_bmbt_set_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
 extern void xfs_bmbt_set_allf(xfs_bmbt_rec_host_t *r, xfs_fileoff_t o,
 			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
@@ -299,8 +258,9 @@ extern void xfs_bmbt_disk_set_allf(xfs_b
 			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
 
 extern void xfs_bmbt_to_bmdr(xfs_bmbt_block_t *, int, xfs_bmdr_block_t *, int);
-extern int xfs_bmbt_update(struct xfs_btree_cur *, xfs_fileoff_t,
-				xfs_fsblock_t, xfs_filblks_t, xfs_exntst_t);
+
+extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
+		struct xfs_trans *, struct xfs_inode *, int);
 
 
 #endif	/* __XFS_BMAP_BTREE_H__ */
Index: xfs-cmds/xfsprogs/include/xfs_ialloc.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_ialloc.h	2008-09-24 19:50:58.000000000 +0200
+++ xfs-cmds/xfsprogs/include/xfs_ialloc.h	2008-09-24 20:01:15.000000000 +0200
@@ -153,4 +153,24 @@ xfs_ialloc_pagi_init(
 	struct xfs_trans *tp,		/* transaction pointer */
         xfs_agnumber_t  agno);		/* allocation group number */
 
+/*
+ * Lookup the first record greater than or equal to ino
+ * in the btree given by cur.
+ */
+int xfs_inobt_lookup_ge(struct xfs_btree_cur *cur, xfs_agino_t ino,
+		__int32_t fcnt,	xfs_inofree_t free, int *stat);
+
+/*
+ * Lookup the first record less than or equal to ino
+ * in the btree given by cur.
+ */
+int xfs_inobt_lookup_le(struct xfs_btree_cur *cur, xfs_agino_t ino,
+		__int32_t fcnt,	xfs_inofree_t free, int *stat);
+
+/*
+ * Get the data from the pointed-to record.
+ */
+extern int xfs_inobt_get_rec(struct xfs_btree_cur *cur, xfs_agino_t *ino,
+			     __int32_t *fcnt, xfs_inofree_t *free, int *stat);
+
 #endif	/* __XFS_IALLOC_H__ */
Index: xfs-cmds/xfsprogs/libxfs/xfs_alloc.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_alloc.c	2008-09-24 19:50:58.000000000 +0200
+++ xfs-cmds/xfsprogs/libxfs/xfs_alloc.c	2008-09-24 20:01:15.000000000 +0200
@@ -37,6 +37,92 @@ STATIC int xfs_alloc_ag_vextent_small(xf
  */
 
 /*
+ * Lookup the record equal to [bno, len] in the btree given by cur.
+ */
+STATIC int				/* error */
+xfs_alloc_lookup_eq(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.a.ar_startblock = bno;
+	cur->bc_rec.a.ar_blockcount = len;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
+}
+
+/*
+ * Lookup the first record greater than or equal to [bno, len]
+ * in the btree given by cur.
+ */
+STATIC int				/* error */
+xfs_alloc_lookup_ge(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.a.ar_startblock = bno;
+	cur->bc_rec.a.ar_blockcount = len;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
+}
+
+/*
+ * Lookup the first record less than or equal to [bno, len]
+ * in the btree given by cur.
+ */
+STATIC int				/* error */
+xfs_alloc_lookup_le(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.a.ar_startblock = bno;
+	cur->bc_rec.a.ar_blockcount = len;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+}
+
+/*
+ * Update the record referred to by cur to the value given
+ * by [bno, len].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int				/* error */
+xfs_alloc_update(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len)	/* length of extent */
+{
+	union xfs_btree_rec	rec;
+
+	rec.alloc.ar_startblock = cpu_to_be32(bno);
+	rec.alloc.ar_blockcount = cpu_to_be32(len);
+	return xfs_btree_update(cur, &rec);
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+STATIC int				/* error */
+xfs_alloc_get_rec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		*bno,	/* output: starting block of extent */
+	xfs_extlen_t		*len,	/* output: length of extent */
+	int			*stat)	/* output: success/failure */
+{
+	union xfs_btree_rec	*rec;
+	int			error;
+
+	error = xfs_btree_get_rec(cur, &rec, stat);
+	if (!error && *stat == 1) {
+		*bno = be32_to_cpu(rec->alloc.ar_startblock);
+		*len = be32_to_cpu(rec->alloc.ar_blockcount);
+	}
+	return error;
+}
+
+/*
  * Compute aligned version of the found extent.
  * Takes alignment and min length into account.
  */
@@ -280,7 +366,7 @@ xfs_alloc_fixup_trees(
 	/*
 	 * Delete the entry from the by-size btree.
 	 */
-	if ((error = xfs_alloc_delete(cnt_cur, &i)))
+	if ((error = xfs_btree_delete(cnt_cur, &i)))
 		return error;
 	XFS_WANT_CORRUPTED_RETURN(i == 1);
 	/*
@@ -290,7 +376,7 @@ xfs_alloc_fixup_trees(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno1, nflen1, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 0);
-		if ((error = xfs_alloc_insert(cnt_cur, &i)))
+		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	}
@@ -298,7 +384,7 @@ xfs_alloc_fixup_trees(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno2, nflen2, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 0);
-		if ((error = xfs_alloc_insert(cnt_cur, &i)))
+		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	}
@@ -309,7 +395,7 @@ xfs_alloc_fixup_trees(
 		/*
 		 * No remaining freespace, just delete the by-block tree entry.
 		 */
-		if ((error = xfs_alloc_delete(bno_cur, &i)))
+		if ((error = xfs_btree_delete(bno_cur, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	} else {
@@ -326,7 +412,7 @@ xfs_alloc_fixup_trees(
 		if ((error = xfs_alloc_lookup_eq(bno_cur, nfbno2, nflen2, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 0);
-		if ((error = xfs_alloc_insert(bno_cur, &i)))
+		if ((error = xfs_btree_insert(bno_cur, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	}
@@ -469,8 +555,8 @@ xfs_alloc_ag_vextent_exact(
 	/*
 	 * Allocate/initialize a cursor for the by-number freespace btree.
 	 */
-	bno_cur = xfs_btree_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_BNO, NULL, 0);
+	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_BNO);
 	/*
 	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
 	 * Look for the closest free block <= bno, it must contain bno
@@ -525,8 +611,8 @@ xfs_alloc_ag_vextent_exact(
 	 * We are allocating agbno for rlen [agbno .. end]
 	 * Allocate/initialize a cursor for the by-size btree.
 	 */
-	cnt_cur = xfs_btree_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT, NULL, 0);
+	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_CNT);
 	ASSERT(args->agbno + args->len <=
 		be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
@@ -588,8 +674,8 @@ xfs_alloc_ag_vextent_near(
 	/*
 	 * Get a cursor for the by-size btree.
 	 */
-	cnt_cur = xfs_btree_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT, NULL, 0);
+	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_CNT);
 	ltlen = 0;
 	bno_cur_lt = bno_cur_gt = NULL;
 	/*
@@ -647,7 +733,7 @@ xfs_alloc_ag_vextent_near(
 				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 				if (ltlen >= args->minlen)
 					break;
-				if ((error = xfs_alloc_increment(cnt_cur, 0, &i)))
+				if ((error = xfs_btree_increment(cnt_cur, 0, &i)))
 					goto error0;
 			} while (i);
 			ASSERT(ltlen >= args->minlen);
@@ -657,7 +743,7 @@ xfs_alloc_ag_vextent_near(
 		i = cnt_cur->bc_ptrs[0];
 		for (j = 1, blen = 0, bdiff = 0;
 		     !error && j && (blen < args->maxlen || bdiff > 0);
-		     error = xfs_alloc_increment(cnt_cur, 0, &j)) {
+		     error = xfs_btree_increment(cnt_cur, 0, &j)) {
 			/*
 			 * For each entry, decide if it's better than
 			 * the previous best entry.
@@ -715,8 +801,8 @@ xfs_alloc_ag_vextent_near(
 		/*
 		 * Set up a cursor for the by-bno tree.
 		 */
-		bno_cur_lt = xfs_btree_init_cursor(args->mp, args->tp,
-			args->agbp, args->agno, XFS_BTNUM_BNO, NULL, 0);
+		bno_cur_lt = xfs_allocbt_init_cursor(args->mp, args->tp,
+			args->agbp, args->agno, XFS_BTNUM_BNO);
 		/*
 		 * Fix up the btree entries.
 		 */
@@ -743,8 +829,8 @@ xfs_alloc_ag_vextent_near(
 	/*
 	 * Allocate and initialize the cursor for the leftward search.
 	 */
-	bno_cur_lt = xfs_btree_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_BNO, NULL, 0);
+	bno_cur_lt = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_BNO);
 	/*
 	 * Lookup <= bno to find the leftward search's starting point.
 	 */
@@ -767,7 +853,7 @@ xfs_alloc_ag_vextent_near(
 	 * Increment the cursor, so we will point at the entry just right
 	 * of the leftward entry if any, or to the leftmost entry.
 	 */
-	if ((error = xfs_alloc_increment(bno_cur_gt, 0, &i)))
+	if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
 		goto error0;
 	if (!i) {
 		/*
@@ -790,7 +876,7 @@ xfs_alloc_ag_vextent_near(
 					args->minlen, &ltbnoa, &ltlena);
 			if (ltlena >= args->minlen)
 				break;
-			if ((error = xfs_alloc_decrement(bno_cur_lt, 0, &i)))
+			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
 				goto error0;
 			if (!i) {
 				xfs_btree_del_cursor(bno_cur_lt,
@@ -806,7 +892,7 @@ xfs_alloc_ag_vextent_near(
 					args->minlen, &gtbnoa, &gtlena);
 			if (gtlena >= args->minlen)
 				break;
-			if ((error = xfs_alloc_increment(bno_cur_gt, 0, &i)))
+			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
 				goto error0;
 			if (!i) {
 				xfs_btree_del_cursor(bno_cur_gt,
@@ -895,7 +981,7 @@ xfs_alloc_ag_vextent_near(
 					/*
 					 * Fell off the right end.
 					 */
-					if ((error = xfs_alloc_increment(
+					if ((error = xfs_btree_increment(
 							bno_cur_gt, 0, &i)))
 						goto error0;
 					if (!i) {
@@ -991,7 +1077,7 @@ xfs_alloc_ag_vextent_near(
 					/*
 					 * Fell off the left end.
 					 */
-					if ((error = xfs_alloc_decrement(
+					if ((error = xfs_btree_decrement(
 							bno_cur_lt, 0, &i)))
 						goto error0;
 					if (!i) {
@@ -1096,8 +1182,8 @@ xfs_alloc_ag_vextent_size(
 	/*
 	 * Allocate and initialize a cursor for the by-size btree.
 	 */
-	cnt_cur = xfs_btree_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT, NULL, 0);
+	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_CNT);
 	bno_cur = NULL;
 	/*
 	 * Look for an entry >= maxlen+alignment-1 blocks.
@@ -1150,7 +1236,7 @@ xfs_alloc_ag_vextent_size(
 		bestflen = flen;
 		bestfbno = fbno;
 		for (;;) {
-			if ((error = xfs_alloc_decrement(cnt_cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cnt_cur, 0, &i)))
 				goto error0;
 			if (i == 0)
 				break;
@@ -1201,8 +1287,8 @@ xfs_alloc_ag_vextent_size(
 	/*
 	 * Allocate and initialize a cursor for the by-block tree.
 	 */
-	bno_cur = xfs_btree_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_BNO, NULL, 0);
+	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
+		args->agno, XFS_BTNUM_BNO);
 	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
 			rbno, rlen, XFSA_FIXUP_CNT_OK)))
 		goto error0;
@@ -1245,7 +1331,7 @@ xfs_alloc_ag_vextent_small(
 	xfs_extlen_t	flen;
 	int		i;
 
-	if ((error = xfs_alloc_decrement(ccur, 0, &i)))
+	if ((error = xfs_btree_decrement(ccur, 0, &i)))
 		goto error0;
 	if (i) {
 		if ((error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i)))
@@ -1344,8 +1430,7 @@ xfs_free_ag_extent(
 	/*
 	 * Allocate and initialize a cursor for the by-block btree.
 	 */
-	bno_cur = xfs_btree_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_BNO, NULL,
-		0);
+	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_BNO);
 	cnt_cur = NULL;
 	/*
 	 * Look for a neighboring block on the left (lower block numbers)
@@ -1378,7 +1463,7 @@ xfs_free_ag_extent(
 	 * Look for a neighboring block on the right (higher block numbers)
 	 * that is contiguous with this space.
 	 */
-	if ((error = xfs_alloc_increment(bno_cur, 0, &haveright)))
+	if ((error = xfs_btree_increment(bno_cur, 0, &haveright)))
 		goto error0;
 	if (haveright) {
 		/*
@@ -1404,8 +1489,7 @@ xfs_free_ag_extent(
 	/*
 	 * Now allocate and initialize a cursor for the by-size tree.
 	 */
-	cnt_cur = xfs_btree_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_CNT, NULL,
-		0);
+	cnt_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_CNT);
 	/*
 	 * Have both left and right contiguous neighbors.
 	 * Merge all three into a single free block.
@@ -1417,7 +1501,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_delete(cnt_cur, &i)))
+		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		/*
@@ -1426,19 +1510,19 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_delete(cnt_cur, &i)))
+		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		/*
 		 * Delete the old by-block entry for the right block.
 		 */
-		if ((error = xfs_alloc_delete(bno_cur, &i)))
+		if ((error = xfs_btree_delete(bno_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		/*
 		 * Move the by-block cursor back to the left neighbor.
 		 */
-		if ((error = xfs_alloc_decrement(bno_cur, 0, &i)))
+		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 #ifdef DEBUG
@@ -1477,14 +1561,14 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_delete(cnt_cur, &i)))
+		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		/*
 		 * Back up the by-block cursor to the left neighbor, and
 		 * update its length.
 		 */
-		if ((error = xfs_alloc_decrement(bno_cur, 0, &i)))
+		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		nbno = ltbno;
@@ -1503,7 +1587,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_delete(cnt_cur, &i)))
+		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		/*
@@ -1522,7 +1606,7 @@ xfs_free_ag_extent(
 	else {
 		nbno = bno;
 		nlen = len;
-		if ((error = xfs_alloc_insert(bno_cur, &i)))
+		if ((error = xfs_btree_insert(bno_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	}
@@ -1534,7 +1618,7 @@ xfs_free_ag_extent(
 	if ((error = xfs_alloc_lookup_eq(cnt_cur, nbno, nlen, &i)))
 		goto error0;
 	XFS_WANT_CORRUPTED_GOTO(i == 0, error0);
-	if ((error = xfs_alloc_insert(cnt_cur, &i)))
+	if ((error = xfs_btree_insert(cnt_cur, &i)))
 		goto error0;
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
Index: xfs-cmds/xfsprogs/libxfs/xfs_alloc_btree.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_alloc_btree.c	2008-09-24 19:50:58.000000000 +0200
+++ xfs-cmds/xfsprogs/libxfs/xfs_alloc_btree.c	2008-09-24 20:01:15.000000000 +0200
@@ -15,2180 +15,444 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-
-/*
- * Free space allocation for XFS.
- */
-
 #include <xfs.h>
 
-/*
- * Prototypes for internal functions.
- */
-
-STATIC void xfs_alloc_log_block(xfs_trans_t *, xfs_buf_t *, int);
-STATIC void xfs_alloc_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC void xfs_alloc_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC void xfs_alloc_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC int xfs_alloc_lshift(xfs_btree_cur_t *, int, int *);
-STATIC int xfs_alloc_newroot(xfs_btree_cur_t *, int *);
-STATIC int xfs_alloc_rshift(xfs_btree_cur_t *, int, int *);
-STATIC int xfs_alloc_split(xfs_btree_cur_t *, int, xfs_agblock_t *,
-		xfs_alloc_key_t *, xfs_btree_cur_t **, int *);
-STATIC int xfs_alloc_updkey(xfs_btree_cur_t *, xfs_alloc_key_t *, int);
-
-/*
- * Internal functions.
- */
-
-/*
- * Single level of the xfs_alloc_delete record deletion routine.
- * Delete record pointed to by cur/level.
- * Remove the record from its block then rebalance the tree.
- * Return 0 for error, 1 for done, 2 to go on to the next level.
- */
-STATIC int				/* error */
-xfs_alloc_delrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level removing record from */
-	int			*stat)	/* fail/done/go-on */
-{
-	xfs_agf_t		*agf;	/* allocation group freelist header */
-	xfs_alloc_block_t	*block;	/* btree block record/key lives in */
-	xfs_agblock_t		bno;	/* btree block number */
-	xfs_buf_t		*bp;	/* buffer for block */
-	int			error;	/* error return value */
-	int			i;	/* loop index */
-	xfs_alloc_key_t		key;	/* kp points here if block is level 0 */
-	xfs_agblock_t		lbno;	/* left block's block number */
-	xfs_buf_t		*lbp;	/* left block's buffer pointer */
-	xfs_alloc_block_t	*left;	/* left btree block */
-	xfs_alloc_key_t		*lkp=NULL;	/* left block key pointer */
-	xfs_alloc_ptr_t		*lpp=NULL;	/* left block address pointer */
-	int			lrecs=0;	/* number of records in left block */
-	xfs_alloc_rec_t		*lrp;	/* left block record pointer */
-	xfs_mount_t		*mp;	/* mount structure */
-	int			ptr;	/* index in btree block for this rec */
-	xfs_agblock_t		rbno;	/* right block's block number */
-	xfs_buf_t		*rbp;	/* right block's buffer pointer */
-	xfs_alloc_block_t	*right;	/* right btree block */
-	xfs_alloc_key_t		*rkp;	/* right block key pointer */
-	xfs_alloc_ptr_t		*rpp;	/* right block address pointer */
-	int			rrecs=0;	/* number of records in right block */
-	int			numrecs;
-	xfs_alloc_rec_t		*rrp;	/* right block record pointer */
-	xfs_btree_cur_t		*tcur;	/* temporary btree cursor */
-
-	/*
-	 * Get the index of the entry being deleted, check for nothing there.
-	 */
-	ptr = cur->bc_ptrs[level];
-	if (ptr == 0) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Get the buffer & block containing the record or key/ptr.
-	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-		return error;
-#endif
-	/*
-	 * Fail if we're off the end of the block.
-	 */
-	numrecs = be16_to_cpu(block->bb_numrecs);
-	if (ptr > numrecs) {
-		*stat = 0;
-		return 0;
-	}
-	XFS_STATS_INC(xs_abt_delrec);
-	/*
-	 * It's a nonleaf.  Excise the key and ptr being deleted, by
-	 * sliding the entries past them down one.
-	 * Log the changed areas of the block.
-	 */
-	if (level > 0) {
-		lkp = XFS_ALLOC_KEY_ADDR(block, 1, cur);
-		lpp = XFS_ALLOC_PTR_ADDR(block, 1, cur);
-#ifdef DEBUG
-		for (i = ptr; i < numrecs; i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(lpp[i]), level)))
-				return error;
-		}
-#endif
-		if (ptr < numrecs) {
-			memmove(&lkp[ptr - 1], &lkp[ptr],
-				(numrecs - ptr) * sizeof(*lkp));
-			memmove(&lpp[ptr - 1], &lpp[ptr],
-				(numrecs - ptr) * sizeof(*lpp));
-			xfs_alloc_log_ptrs(cur, bp, ptr, numrecs - 1);
-			xfs_alloc_log_keys(cur, bp, ptr, numrecs - 1);
-		}
-	}
-	/*
-	 * It's a leaf.  Excise the record being deleted, by sliding the
-	 * entries past it down one.  Log the changed areas of the block.
-	 */
-	else {
-		lrp = XFS_ALLOC_REC_ADDR(block, 1, cur);
-		if (ptr < numrecs) {
-			memmove(&lrp[ptr - 1], &lrp[ptr],
-				(numrecs - ptr) * sizeof(*lrp));
-			xfs_alloc_log_recs(cur, bp, ptr, numrecs - 1);
-		}
-		/*
-		 * If it's the first record in the block, we'll need a key
-		 * structure to pass up to the next level (updkey).
-		 */
-		if (ptr == 1) {
-			key.ar_startblock = lrp->ar_startblock;
-			key.ar_blockcount = lrp->ar_blockcount;
-			lkp = &key;
-		}
-	}
-	/*
-	 * Decrement and log the number of entries in the block.
-	 */
-	numrecs--;
-	block->bb_numrecs = cpu_to_be16(numrecs);
-	xfs_alloc_log_block(cur->bc_tp, bp, XFS_BB_NUMRECS);
-	/*
-	 * See if the longest free extent in the allocation group was
-	 * changed by this operation.  True if it's the by-size btree, and
-	 * this is the leaf level, and there is no right sibling block,
-	 * and this was the last record.
-	 */
-	agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-	mp = cur->bc_mp;
-
-	if (level == 0 &&
-	    cur->bc_btnum == XFS_BTNUM_CNT &&
-	    be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK &&
-	    ptr > numrecs) {
-		ASSERT(ptr == numrecs + 1);
-		/*
-		 * There are still records in the block.  Grab the size
-		 * from the last one.
-		 */
-		if (numrecs) {
-			rrp = XFS_ALLOC_REC_ADDR(block, numrecs, cur);
-			agf->agf_longest = rrp->ar_blockcount;
-		}
-		/*
-		 * No free extents left.
-		 */
-		else
-			agf->agf_longest = 0;
-		mp->m_perag[be32_to_cpu(agf->agf_seqno)].pagf_longest =
-			be32_to_cpu(agf->agf_longest);
-		xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp,
-			XFS_AGF_LONGEST);
-	}
-	/*
-	 * Is this the root level?  If so, we're almost done.
-	 */
-	if (level == cur->bc_nlevels - 1) {
-		/*
-		 * If this is the root level,
-		 * and there's only one entry left,
-		 * and it's NOT the leaf level,
-		 * then we can get rid of this level.
-		 */
-		if (numrecs == 1 && level > 0) {
-			/*
-			 * lpp is still set to the first pointer in the block.
-			 * Make it the new root of the btree.
-			 */
-			bno = be32_to_cpu(agf->agf_roots[cur->bc_btnum]);
-			agf->agf_roots[cur->bc_btnum] = *lpp;
-			be32_add_cpu(&agf->agf_levels[cur->bc_btnum], -1);
-			mp->m_perag[be32_to_cpu(agf->agf_seqno)].pagf_levels[cur->bc_btnum]--;
-			/*
-			 * Put this buffer/block on the ag's freelist.
-			 */
-			error = xfs_alloc_put_freelist(cur->bc_tp,
-					cur->bc_private.a.agbp, NULL, bno, 1);
-			if (error)
-				return error;
-			/*
-			 * Since blocks move to the free list without the
-			 * coordination used in xfs_bmap_finish, we can't allow
-			 * block to be available for reallocation and
-			 * non-transaction writing (user data) until we know
-			 * that the transaction that moved it to the free list
-			 * is permanently on disk. We track the blocks by
-			 * declaring these blocks as "busy"; the busy list is
-			 * maintained on a per-ag basis and each transaction
-			 * records which entries should be removed when the
-			 * iclog commits to disk. If a busy block is
-			 * allocated, the iclog is pushed up to the LSN
-			 * that freed the block.
-			 */
-			xfs_alloc_mark_busy(cur->bc_tp,
-				be32_to_cpu(agf->agf_seqno), bno, 1);
-
-			xfs_trans_agbtree_delta(cur->bc_tp, -1);
-			xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp,
-				XFS_AGF_ROOTS | XFS_AGF_LEVELS);
-			/*
-			 * Update the cursor so there's one fewer level.
-			 */
-			xfs_btree_setbuf(cur, level, NULL);
-			cur->bc_nlevels--;
-		} else if (level > 0 &&
-			   (error = xfs_alloc_decrement(cur, level, &i)))
-			return error;
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * If we deleted the leftmost entry in the block, update the
-	 * key values above us in the tree.
-	 */
-	if (ptr == 1 && (error = xfs_alloc_updkey(cur, lkp, level + 1)))
-		return error;
-	/*
-	 * If the number of records remaining in the block is at least
-	 * the minimum, we're done.
-	 */
-	if (numrecs >= XFS_ALLOC_BLOCK_MINRECS(level, cur)) {
-		if (level > 0 && (error = xfs_alloc_decrement(cur, level, &i)))
-			return error;
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * Otherwise, we have to move some records around to keep the
-	 * tree balanced.  Look at the left and right sibling blocks to
-	 * see if we can re-balance by moving only one record.
-	 */
-	rbno = be32_to_cpu(block->bb_rightsib);
-	lbno = be32_to_cpu(block->bb_leftsib);
-	bno = NULLAGBLOCK;
-	ASSERT(rbno != NULLAGBLOCK || lbno != NULLAGBLOCK);
-	/*
-	 * Duplicate the cursor so our btree manipulations here won't
-	 * disrupt the next level up.
-	 */
-	if ((error = xfs_btree_dup_cursor(cur, &tcur)))
-		return error;
-	/*
-	 * If there's a right sibling, see if it's ok to shift an entry
-	 * out of it.
-	 */
-	if (rbno != NULLAGBLOCK) {
-		/*
-		 * Move the temp cursor to the last entry in the next block.
-		 * Actually any entry but the first would suffice.
-		 */
-		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_increment(tcur, level, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		/*
-		 * Grab a pointer to the block.
-		 */
-		rbp = tcur->bc_bufs[level];
-		right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-			goto error0;
-#endif
-		/*
-		 * Grab the current block number, for future use.
-		 */
-		bno = be32_to_cpu(right->bb_leftsib);
-		/*
-		 * If right block is full enough so that removing one entry
-		 * won't make it too empty, and left-shifting an entry out
-		 * of right to us works, we're done.
-		 */
-		if (be16_to_cpu(right->bb_numrecs) - 1 >=
-		     XFS_ALLOC_BLOCK_MINRECS(level, cur)) {
-			if ((error = xfs_alloc_lshift(tcur, level, &i)))
-				goto error0;
-			if (i) {
-				ASSERT(be16_to_cpu(block->bb_numrecs) >=
-				       XFS_ALLOC_BLOCK_MINRECS(level, cur));
-				xfs_btree_del_cursor(tcur,
-						     XFS_BTREE_NOERROR);
-				if (level > 0 &&
-				    (error = xfs_alloc_decrement(cur, level,
-					    &i)))
-					return error;
-				*stat = 1;
-				return 0;
-			}
-		}
-		/*
-		 * Otherwise, grab the number of records in right for
-		 * future reference, and fix up the temp cursor to point
-		 * to our block again (last record).
-		 */
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		if (lbno != NULLAGBLOCK) {
-			i = xfs_btree_firstrec(tcur, level);
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			if ((error = xfs_alloc_decrement(tcur, level, &i)))
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		}
-	}
-	/*
-	 * If there's a left sibling, see if it's ok to shift an entry
-	 * out of it.
-	 */
-	if (lbno != NULLAGBLOCK) {
-		/*
-		 * Move the temp cursor to the first entry in the
-		 * previous block.
-		 */
-		i = xfs_btree_firstrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_decrement(tcur, level, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		xfs_btree_firstrec(tcur, level);
-		/*
-		 * Grab a pointer to the block.
-		 */
-		lbp = tcur->bc_bufs[level];
-		left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-			goto error0;
-#endif
-		/*
-		 * Grab the current block number, for future use.
-		 */
-		bno = be32_to_cpu(left->bb_rightsib);
-		/*
-		 * If left block is full enough so that removing one entry
-		 * won't make it too empty, and right-shifting an entry out
-		 * of left to us works, we're done.
-		 */
-		if (be16_to_cpu(left->bb_numrecs) - 1 >=
-		     XFS_ALLOC_BLOCK_MINRECS(level, cur)) {
-			if ((error = xfs_alloc_rshift(tcur, level, &i)))
-				goto error0;
-			if (i) {
-				ASSERT(be16_to_cpu(block->bb_numrecs) >=
-				       XFS_ALLOC_BLOCK_MINRECS(level, cur));
-				xfs_btree_del_cursor(tcur,
-						     XFS_BTREE_NOERROR);
-				if (level == 0)
-					cur->bc_ptrs[0]++;
-				*stat = 1;
-				return 0;
-			}
-		}
-		/*
-		 * Otherwise, grab the number of records in right for
-		 * future reference.
-		 */
-		lrecs = be16_to_cpu(left->bb_numrecs);
-	}
-	/*
-	 * Delete the temp cursor, we're done with it.
-	 */
-	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-	/*
-	 * If here, we need to do a join to keep the tree balanced.
-	 */
-	ASSERT(bno != NULLAGBLOCK);
-	/*
-	 * See if we can join with the left neighbor block.
-	 */
-	if (lbno != NULLAGBLOCK &&
-	    lrecs + numrecs <= XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
-		/*
-		 * Set "right" to be the starting block,
-		 * "left" to be the left neighbor.
-		 */
-		rbno = bno;
-		right = block;
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		rbp = bp;
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, lbno, 0, &lbp,
-				XFS_ALLOC_BTREE_REF)))
-			return error;
-		left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-		lrecs = be16_to_cpu(left->bb_numrecs);
-		if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-			return error;
-	}
-	/*
-	 * If that won't work, see if we can join with the right neighbor block.
-	 */
-	else if (rbno != NULLAGBLOCK &&
-		 rrecs + numrecs <= XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
-		/*
-		 * Set "left" to be the starting block,
-		 * "right" to be the right neighbor.
-		 */
-		lbno = bno;
-		left = block;
-		lrecs = be16_to_cpu(left->bb_numrecs);
-		lbp = bp;
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, rbno, 0, &rbp,
-				XFS_ALLOC_BTREE_REF)))
-			return error;
-		right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-			return error;
-	}
-	/*
-	 * Otherwise, we can't fix the imbalance.
-	 * Just return.  This is probably a logic error, but it's not fatal.
-	 */
-	else {
-		if (level > 0 && (error = xfs_alloc_decrement(cur, level, &i)))
-			return error;
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * We're now going to join "left" and "right" by moving all the stuff
-	 * in "right" to "left" and deleting "right".
-	 */
-	if (level > 0) {
-		/*
-		 * It's a non-leaf.  Move keys and pointers.
-		 */
-		lkp = XFS_ALLOC_KEY_ADDR(left, lrecs + 1, cur);
-		lpp = XFS_ALLOC_PTR_ADDR(left, lrecs + 1, cur);
-		rkp = XFS_ALLOC_KEY_ADDR(right, 1, cur);
-		rpp = XFS_ALLOC_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = 0; i < rrecs; i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i]), level)))
-				return error;
-		}
-#endif
-		memcpy(lkp, rkp, rrecs * sizeof(*lkp));
-		memcpy(lpp, rpp, rrecs * sizeof(*lpp));
-		xfs_alloc_log_keys(cur, lbp, lrecs + 1, lrecs + rrecs);
-		xfs_alloc_log_ptrs(cur, lbp, lrecs + 1, lrecs + rrecs);
-	} else {
-		/*
-		 * It's a leaf.  Move records.
-		 */
-		lrp = XFS_ALLOC_REC_ADDR(left, lrecs + 1, cur);
-		rrp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-		memcpy(lrp, rrp, rrecs * sizeof(*lrp));
-		xfs_alloc_log_recs(cur, lbp, lrecs + 1, lrecs + rrecs);
-	}
-	/*
-	 * If we joined with the left neighbor, set the buffer in the
-	 * cursor to the left block, and fix up the index.
-	 */
-	if (bp != lbp) {
-		xfs_btree_setbuf(cur, level, lbp);
-		cur->bc_ptrs[level] += lrecs;
-	}
-	/*
-	 * If we joined with the right neighbor and there's a level above
-	 * us, increment the cursor at that level.
-	 */
-	else if (level + 1 < cur->bc_nlevels &&
-		 (error = xfs_alloc_increment(cur, level + 1, &i)))
-		return error;
-	/*
-	 * Fix up the number of records in the surviving block.
-	 */
-	lrecs += rrecs;
-	left->bb_numrecs = cpu_to_be16(lrecs);
-	/*
-	 * Fix up the right block pointer in the surviving block, and log it.
-	 */
-	left->bb_rightsib = right->bb_rightsib;
-	xfs_alloc_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
-	/*
-	 * If there is a right sibling now, make it point to the
-	 * remaining block.
-	 */
-	if (be32_to_cpu(left->bb_rightsib) != NULLAGBLOCK) {
-		xfs_alloc_block_t	*rrblock;
-		xfs_buf_t		*rrbp;
-
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, be32_to_cpu(left->bb_rightsib), 0,
-				&rrbp, XFS_ALLOC_BTREE_REF)))
-			return error;
-		rrblock = XFS_BUF_TO_ALLOC_BLOCK(rrbp);
-		if ((error = xfs_btree_check_sblock(cur, rrblock, level, rrbp)))
-			return error;
-		rrblock->bb_leftsib = cpu_to_be32(lbno);
-		xfs_alloc_log_block(cur->bc_tp, rrbp, XFS_BB_LEFTSIB);
-	}
-	/*
-	 * Free the deleting block by putting it on the freelist.
-	 */
-	error = xfs_alloc_put_freelist(cur->bc_tp,
-					 cur->bc_private.a.agbp, NULL, rbno, 1);
-	if (error)
-		return error;
-	/*
-	 * Since blocks move to the free list without the coordination
-	 * used in xfs_bmap_finish, we can't allow block to be available
-	 * for reallocation and non-transaction writing (user data)
-	 * until we know that the transaction that moved it to the free
-	 * list is permanently on disk. We track the blocks by declaring
-	 * these blocks as "busy"; the busy list is maintained on a
-	 * per-ag basis and each transaction records which entries
-	 * should be removed when the iclog commits to disk. If a
-	 * busy block is allocated, the iclog is pushed up to the
-	 * LSN that freed the block.
-	 */
-	xfs_alloc_mark_busy(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
-	xfs_trans_agbtree_delta(cur->bc_tp, -1);
-
-	/*
-	 * Adjust the current level's cursor so that we're left referring
-	 * to the right node, after we're done.
-	 * If this leaves the ptr value 0 our caller will fix it up.
-	 */
-	if (level > 0)
-		cur->bc_ptrs[level]--;
-	/*
-	 * Return value means the next level up has something to do.
-	 */
-	*stat = 2;
-	return 0;
-
-error0:
-	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-	return error;
+STATIC struct xfs_btree_cur *
+xfs_allocbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_allocbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.a.agbp, cur->bc_private.a.agno,
+			cur->bc_btnum);
 }
 
-/*
- * Insert one record/level.  Return information to the caller
- * allowing the next level up to proceed if necessary.
- */
-STATIC int				/* error */
-xfs_alloc_insrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to insert record at */
-	xfs_agblock_t		*bnop,	/* i/o: block number inserted */
-	xfs_alloc_rec_t		*recp,	/* i/o: record data inserted */
-	xfs_btree_cur_t		**curp,	/* output: new cursor replacing cur */
-	int			*stat)	/* output: success/failure */
-{
-	xfs_agf_t		*agf;	/* allocation group freelist header */
-	xfs_alloc_block_t	*block;	/* btree block record/key lives in */
-	xfs_buf_t		*bp;	/* buffer for block */
-	int			error;	/* error return value */
-	int			i;	/* loop index */
-	xfs_alloc_key_t		key;	/* key value being inserted */
-	xfs_alloc_key_t		*kp;	/* pointer to btree keys */
-	xfs_agblock_t		nbno;	/* block number of allocated block */
-	xfs_btree_cur_t		*ncur;	/* new cursor to be used at next lvl */
-	xfs_alloc_key_t		nkey;	/* new key value, from split */
-	xfs_alloc_rec_t		nrec;	/* new record value, for caller */
-	int			numrecs;
-	int			optr;	/* old ptr value */
-	xfs_alloc_ptr_t		*pp;	/* pointer to btree addresses */
-	int			ptr;	/* index in btree block for this rec */
-	xfs_alloc_rec_t		*rp;	/* pointer to btree records */
-
-	ASSERT(be32_to_cpu(recp->ar_blockcount) > 0);
-
-	/*
-	 * GCC doesn't understand the (arguably complex) control flow in
-	 * this function and complains about uninitialized structure fields
-	 * without this.
-	 */
-	memset(&nrec, 0, sizeof(nrec));
-
-	/*
-	 * If we made it to the root level, allocate a new root block
-	 * and we're done.
-	 */
-	if (level >= cur->bc_nlevels) {
-		XFS_STATS_INC(xs_abt_insrec);
-		if ((error = xfs_alloc_newroot(cur, &i)))
-			return error;
-		*bnop = NULLAGBLOCK;
-		*stat = i;
-		return 0;
-	}
-	/*
-	 * Make a key out of the record data to be inserted, and save it.
-	 */
-	key.ar_startblock = recp->ar_startblock;
-	key.ar_blockcount = recp->ar_blockcount;
-	optr = ptr = cur->bc_ptrs[level];
-	/*
-	 * If we're off the left edge, return failure.
-	 */
-	if (ptr == 0) {
-		*stat = 0;
-		return 0;
-	}
-	XFS_STATS_INC(xs_abt_insrec);
-	/*
-	 * Get pointers to the btree buffer and block.
-	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-	numrecs = be16_to_cpu(block->bb_numrecs);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-		return error;
-	/*
-	 * Check that the new entry is being inserted in the right place.
-	 */
-	if (ptr <= numrecs) {
-		if (level == 0) {
-			rp = XFS_ALLOC_REC_ADDR(block, ptr, cur);
-			xfs_btree_check_rec(cur->bc_btnum, recp, rp);
-		} else {
-			kp = XFS_ALLOC_KEY_ADDR(block, ptr, cur);
-			xfs_btree_check_key(cur->bc_btnum, &key, kp);
-		}
-	}
-#endif
-	nbno = NULLAGBLOCK;
-	ncur = NULL;
-	/*
-	 * If the block is full, we can't insert the new entry until we
-	 * make the block un-full.
-	 */
-	if (numrecs == XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
-		/*
-		 * First, try shifting an entry to the right neighbor.
-		 */
-		if ((error = xfs_alloc_rshift(cur, level, &i)))
-			return error;
-		if (i) {
-			/* nothing */
-		}
-		/*
-		 * Next, try shifting an entry to the left neighbor.
-		 */
-		else {
-			if ((error = xfs_alloc_lshift(cur, level, &i)))
-				return error;
-			if (i)
-				optr = ptr = cur->bc_ptrs[level];
-			else {
-				/*
-				 * Next, try splitting the current block in
-				 * half. If this works we have to re-set our
-				 * variables because we could be in a
-				 * different block now.
-				 */
-				if ((error = xfs_alloc_split(cur, level, &nbno,
-						&nkey, &ncur, &i)))
-					return error;
-				if (i) {
-					bp = cur->bc_bufs[level];
-					block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-#ifdef DEBUG
-					if ((error =
-						xfs_btree_check_sblock(cur,
-							block, level, bp)))
-						return error;
-#endif
-					ptr = cur->bc_ptrs[level];
-					nrec.ar_startblock = nkey.ar_startblock;
-					nrec.ar_blockcount = nkey.ar_blockcount;
-				}
-				/*
-				 * Otherwise the insert fails.
-				 */
-				else {
-					*stat = 0;
-					return 0;
-				}
-			}
-		}
-	}
-	/*
-	 * At this point we know there's room for our new entry in the block
-	 * we're pointing at.
-	 */
-	numrecs = be16_to_cpu(block->bb_numrecs);
-	if (level > 0) {
-		/*
-		 * It's a non-leaf entry.  Make a hole for the new data
-		 * in the key and ptr regions of the block.
-		 */
-		kp = XFS_ALLOC_KEY_ADDR(block, 1, cur);
-		pp = XFS_ALLOC_PTR_ADDR(block, 1, cur);
-#ifdef DEBUG
-		for (i = numrecs; i >= ptr; i--) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(pp[i - 1]), level)))
-				return error;
-		}
-#endif
-		memmove(&kp[ptr], &kp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*kp));
-		memmove(&pp[ptr], &pp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*pp));
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sptr(cur, *bnop, level)))
-			return error;
-#endif
-		/*
-		 * Now stuff the new data in, bump numrecs and log the new data.
-		 */
-		kp[ptr - 1] = key;
-		pp[ptr - 1] = cpu_to_be32(*bnop);
-		numrecs++;
-		block->bb_numrecs = cpu_to_be16(numrecs);
-		xfs_alloc_log_keys(cur, bp, ptr, numrecs);
-		xfs_alloc_log_ptrs(cur, bp, ptr, numrecs);
-#ifdef DEBUG
-		if (ptr < numrecs)
-			xfs_btree_check_key(cur->bc_btnum, kp + ptr - 1,
-				kp + ptr);
-#endif
-	} else {
-		/*
-		 * It's a leaf entry.  Make a hole for the new record.
-		 */
-		rp = XFS_ALLOC_REC_ADDR(block, 1, cur);
-		memmove(&rp[ptr], &rp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*rp));
-		/*
-		 * Now stuff the new record in, bump numrecs
-		 * and log the new data.
-		 */
-		rp[ptr - 1] = *recp;
-		numrecs++;
-		block->bb_numrecs = cpu_to_be16(numrecs);
-		xfs_alloc_log_recs(cur, bp, ptr, numrecs);
-#ifdef DEBUG
-		if (ptr < numrecs)
-			xfs_btree_check_rec(cur->bc_btnum, rp + ptr - 1,
-				rp + ptr);
-#endif
-	}
-	/*
-	 * Log the new number of records in the btree header.
-	 */
-	xfs_alloc_log_block(cur->bc_tp, bp, XFS_BB_NUMRECS);
-	/*
-	 * If we inserted at the start of a block, update the parents' keys.
-	 */
-	if (optr == 1 && (error = xfs_alloc_updkey(cur, &key, level + 1)))
-		return error;
-	/*
-	 * Look to see if the longest extent in the allocation group
-	 * needs to be updated.
-	 */
-
-	agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-	if (level == 0 &&
-	    cur->bc_btnum == XFS_BTNUM_CNT &&
-	    be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK &&
-	    be32_to_cpu(recp->ar_blockcount) > be32_to_cpu(agf->agf_longest)) {
-		/*
-		 * If this is a leaf in the by-size btree and there
-		 * is no right sibling block and this block is bigger
-		 * than the previous longest block, update it.
-		 */
-		agf->agf_longest = recp->ar_blockcount;
-		cur->bc_mp->m_perag[be32_to_cpu(agf->agf_seqno)].pagf_longest
-			= be32_to_cpu(recp->ar_blockcount);
-		xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp,
-			XFS_AGF_LONGEST);
-	}
-	/*
-	 * Return the new block number, if any.
-	 * If there is one, give back a record value and a cursor too.
-	 */
-	*bnop = nbno;
-	if (nbno != NULLAGBLOCK) {
-		*recp = nrec;
-		*curp = ncur;
-	}
-	*stat = 1;
-	return 0;
-}
-
-/*
- * Log header fields from a btree block.
- */
 STATIC void
-xfs_alloc_log_block(
-	xfs_trans_t		*tp,	/* transaction pointer */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			fields)	/* mask of fields: XFS_BB_... */
+xfs_allocbt_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			inc)
 {
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	static const short	offsets[] = {	/* table of offsets */
-		offsetof(xfs_alloc_block_t, bb_magic),
-		offsetof(xfs_alloc_block_t, bb_level),
-		offsetof(xfs_alloc_block_t, bb_numrecs),
-		offsetof(xfs_alloc_block_t, bb_leftsib),
-		offsetof(xfs_alloc_block_t, bb_rightsib),
-		sizeof(xfs_alloc_block_t)
-	};
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	int			btnum = cur->bc_btnum;
 
-	xfs_btree_offsets(fields, offsets, XFS_BB_NUM_BITS, &first, &last);
-	xfs_trans_log_buf(tp, bp, first, last);
-}
+	ASSERT(ptr->s != 0);
 
-/*
- * Log keys from a btree block (nonleaf).
- */
-STATIC void
-xfs_alloc_log_keys(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			kfirst,	/* index of first key to log */
-	int			klast)	/* index of last key to log */
-{
-	xfs_alloc_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	xfs_alloc_key_t		*kp;	/* key pointer in btree block */
-	int			last;	/* last byte offset logged */
-
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-	kp = XFS_ALLOC_KEY_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
-}
+	agf->agf_roots[btnum] = ptr->s;
+	be32_add_cpu(&agf->agf_levels[btnum], inc);
+	cur->bc_mp->m_perag[seqno].pagf_levels[btnum] += inc;
 
-/*
- * Log block pointer fields from a btree block (nonleaf).
- */
-STATIC void
-xfs_alloc_log_ptrs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			pfirst,	/* index of first pointer to log */
-	int			plast)	/* index of last pointer to log */
-{
-	xfs_alloc_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	xfs_alloc_ptr_t		*pp;	/* block-pointer pointer in btree blk */
-
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-	pp = XFS_ALLOC_PTR_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
 
-/*
- * Log records from a btree block (leaf).
- */
-STATIC void
-xfs_alloc_log_recs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			rfirst,	/* index of first record to log */
-	int			rlast)	/* index of last record to log */
+STATIC int
+xfs_allocbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			length,
+	int			*stat)
 {
-	xfs_alloc_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	xfs_alloc_rec_t		*rp;	/* record pointer for btree block */
+	int			error;
+	xfs_agblock_t		bno;
 
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
 
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-	rp = XFS_ALLOC_REC_ADDR(block, 1, cur);
-#ifdef DEBUG
-	{
-		xfs_agf_t	*agf;
-		xfs_alloc_rec_t	*p;
-
-		agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-		for (p = &rp[rfirst - 1]; p <= &rp[rlast - 1]; p++)
-			ASSERT(be32_to_cpu(p->ar_startblock) +
-			       be32_to_cpu(p->ar_blockcount) <=
-			       be32_to_cpu(agf->agf_length));
-	}
-#endif
-	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
-}
-
-/*
- * Lookup the record.  The cursor is made to point to it, based on dir.
- * Return 0 if can't find any such record, 1 for success.
- */
-STATIC int				/* error */
-xfs_alloc_lookup(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_lookup_t		dir,	/* <=, ==, or >= */
-	int			*stat)	/* success/failure */
-{
-	xfs_agblock_t		agbno;	/* a.g. relative btree block number */
-	xfs_agnumber_t		agno;	/* allocation group number */
-	xfs_alloc_block_t	*block=NULL;	/* current btree block */
-	int			diff;	/* difference for the current key */
-	int			error;	/* error return value */
-	int			keyno=0;	/* current key number */
-	int			level;	/* level in the btree */
-	xfs_mount_t		*mp;	/* file system mount point */
-
-	XFS_STATS_INC(xs_abt_lookup);
-	/*
-	 * Get the allocation group header, and the root block number.
-	 */
-	mp = cur->bc_mp;
-
-	{
-		xfs_agf_t	*agf;	/* a.g. freespace header */
-
-		agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-		agno = be32_to_cpu(agf->agf_seqno);
-		agbno = be32_to_cpu(agf->agf_roots[cur->bc_btnum]);
-	}
-	/*
-	 * Iterate over each level in the btree, starting at the root.
-	 * For each level above the leaves, find the key we need, based
-	 * on the lookup record, then follow the corresponding block
-	 * pointer down to the next level.
-	 */
-	for (level = cur->bc_nlevels - 1, diff = 1; level >= 0; level--) {
-		xfs_buf_t	*bp;	/* buffer pointer for btree block */
-		xfs_daddr_t	d;	/* disk address of btree block */
-
-		/*
-		 * Get the disk address we're looking for.
-		 */
-		d = XFS_AGB_TO_DADDR(mp, agno, agbno);
-		/*
-		 * If the old buffer at this level is for a different block,
-		 * throw it away, otherwise just use it.
-		 */
-		bp = cur->bc_bufs[level];
-		if (bp && XFS_BUF_ADDR(bp) != d)
-			bp = NULL;
-		if (!bp) {
-			/*
-			 * Need to get a new buffer.  Read it, then
-			 * set it in the cursor, releasing the old one.
-			 */
-			if ((error = xfs_btree_read_bufs(mp, cur->bc_tp, agno,
-					agbno, 0, &bp, XFS_ALLOC_BTREE_REF)))
-				return error;
-			xfs_btree_setbuf(cur, level, bp);
-			/*
-			 * Point to the btree block, now that we have the buffer
-			 */
-			block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-			if ((error = xfs_btree_check_sblock(cur, block, level,
-					bp)))
-				return error;
-		} else
-			block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-		/*
-		 * If we already had a key match at a higher level, we know
-		 * we need to use the first entry in this block.
-		 */
-		if (diff == 0)
-			keyno = 1;
-		/*
-		 * Otherwise we need to search this block.  Do a binary search.
-		 */
-		else {
-			int		high;	/* high entry number */
-			xfs_alloc_key_t	*kkbase=NULL;/* base of keys in block */
-			xfs_alloc_rec_t	*krbase=NULL;/* base of records in block */
-			int		low;	/* low entry number */
-
-			/*
-			 * Get a pointer to keys or records.
-			 */
-			if (level > 0)
-				kkbase = XFS_ALLOC_KEY_ADDR(block, 1, cur);
-			else
-				krbase = XFS_ALLOC_REC_ADDR(block, 1, cur);
-			/*
-			 * Set low and high entry numbers, 1-based.
-			 */
-			low = 1;
-			if (!(high = be16_to_cpu(block->bb_numrecs))) {
-				/*
-				 * If the block is empty, the tree must
-				 * be an empty leaf.
-				 */
-				ASSERT(level == 0 && cur->bc_nlevels == 1);
-				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
-				*stat = 0;
-				return 0;
-			}
-			/*
-			 * Binary search the block.
-			 */
-			while (low <= high) {
-				xfs_extlen_t	blockcount;	/* key value */
-				xfs_agblock_t	startblock;	/* key value */
-
-				XFS_STATS_INC(xs_abt_compare);
-				/*
-				 * keyno is average of low and high.
-				 */
-				keyno = (low + high) >> 1;
-				/*
-				 * Get startblock & blockcount.
-				 */
-				if (level > 0) {
-					xfs_alloc_key_t	*kkp;
-
-					kkp = kkbase + keyno - 1;
-					startblock = be32_to_cpu(kkp->ar_startblock);
-					blockcount = be32_to_cpu(kkp->ar_blockcount);
-				} else {
-					xfs_alloc_rec_t	*krp;
-
-					krp = krbase + keyno - 1;
-					startblock = be32_to_cpu(krp->ar_startblock);
-					blockcount = be32_to_cpu(krp->ar_blockcount);
-				}
-				/*
-				 * Compute difference to get next direction.
-				 */
-				if (cur->bc_btnum == XFS_BTNUM_BNO)
-					diff = (int)startblock -
-					       (int)cur->bc_rec.a.ar_startblock;
-				else if (!(diff = (int)blockcount -
-					    (int)cur->bc_rec.a.ar_blockcount))
-					diff = (int)startblock -
-					    (int)cur->bc_rec.a.ar_startblock;
-				/*
-				 * Less than, move right.
-				 */
-				if (diff < 0)
-					low = keyno + 1;
-				/*
-				 * Greater than, move left.
-				 */
-				else if (diff > 0)
-					high = keyno - 1;
-				/*
-				 * Equal, we're done.
-				 */
-				else
-					break;
-			}
-		}
-		/*
-		 * If there are more levels, set up for the next level
-		 * by getting the block number and filling in the cursor.
-		 */
-		if (level > 0) {
-			/*
-			 * If we moved left, need the previous key number,
-			 * unless there isn't one.
-			 */
-			if (diff > 0 && --keyno < 1)
-				keyno = 1;
-			agbno = be32_to_cpu(*XFS_ALLOC_PTR_ADDR(block, keyno, cur));
-#ifdef DEBUG
-			if ((error = xfs_btree_check_sptr(cur, agbno, level)))
-				return error;
-#endif
-			cur->bc_ptrs[level] = keyno;
-		}
-	}
-	/*
-	 * Done with the search.
-	 * See if we need to adjust the results.
-	 */
-	if (dir != XFS_LOOKUP_LE && diff < 0) {
-		keyno++;
-		/*
-		 * If ge search and we went off the end of the block, but it's
-		 * not the last block, we're in the wrong block.
-		 */
-		if (dir == XFS_LOOKUP_GE &&
-		    keyno > be16_to_cpu(block->bb_numrecs) &&
-		    be32_to_cpu(block->bb_rightsib) != NULLAGBLOCK) {
-			int	i;
-
-			cur->bc_ptrs[0] = keyno;
-			if ((error = xfs_alloc_increment(cur, 0, &i)))
-				return error;
-			XFS_WANT_CORRUPTED_RETURN(i == 1);
-			*stat = 1;
-			return 0;
-		}
-	}
-	else if (dir == XFS_LOOKUP_LE && diff > 0)
-		keyno--;
-	cur->bc_ptrs[0] = keyno;
-	/*
-	 * Return if we succeeded or not.
-	 */
-	if (keyno == 0 || keyno > be16_to_cpu(block->bb_numrecs))
-		*stat = 0;
-	else
-		*stat = ((dir != XFS_LOOKUP_EQ) || (diff == 0));
-	return 0;
-}
-
-/*
- * Move 1 record left from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int				/* error */
-xfs_alloc_lshift(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to shift record on */
-	int			*stat)	/* success/failure */
-{
-	int			error;	/* error return value */
-#ifdef DEBUG
-	int			i;	/* loop index */
-#endif
-	xfs_alloc_key_t		key;	/* key value for leaf level upward */
-	xfs_buf_t		*lbp;	/* buffer for left neighbor block */
-	xfs_alloc_block_t	*left;	/* left neighbor btree block */
-	int			nrec;	/* new number of left block entries */
-	xfs_buf_t		*rbp;	/* buffer for right (current) block */
-	xfs_alloc_block_t	*right;	/* right (current) btree block */
-	xfs_alloc_key_t		*rkp=NULL;	/* key pointer for right block */
-	xfs_alloc_ptr_t		*rpp=NULL;	/* address pointer for right block */
-	xfs_alloc_rec_t		*rrp=NULL;	/* record pointer for right block */
-
-	/*
-	 * Set up variables for this block as "right".
-	 */
-	rbp = cur->bc_bufs[level];
-	right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-		return error;
-#endif
-	/*
-	 * If we've got no left sibling then we can't shift an entry left.
-	 */
-	if (be32_to_cpu(right->bb_leftsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * If the cursor entry is the one that would be moved, don't
-	 * do it... it's too complicated.
-	 */
-	if (cur->bc_ptrs[level] <= 1) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Set up the left neighbor as "left".
-	 */
-	if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agno, be32_to_cpu(right->bb_leftsib),
-			0, &lbp, XFS_ALLOC_BTREE_REF)))
-		return error;
-	left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-		return error;
-	/*
-	 * If it's full, it can't take another entry.
-	 */
-	if (be16_to_cpu(left->bb_numrecs) == XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
-		*stat = 0;
-		return 0;
-	}
-	nrec = be16_to_cpu(left->bb_numrecs) + 1;
-	/*
-	 * If non-leaf, copy a key and a ptr to the left block.
-	 */
-	if (level > 0) {
-		xfs_alloc_key_t	*lkp;	/* key pointer for left block */
-		xfs_alloc_ptr_t	*lpp;	/* address pointer for left block */
-
-		lkp = XFS_ALLOC_KEY_ADDR(left, nrec, cur);
-		rkp = XFS_ALLOC_KEY_ADDR(right, 1, cur);
-		*lkp = *rkp;
-		xfs_alloc_log_keys(cur, lbp, nrec, nrec);
-		lpp = XFS_ALLOC_PTR_ADDR(left, nrec, cur);
-		rpp = XFS_ALLOC_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(*rpp), level)))
-			return error;
-#endif
-		*lpp = *rpp;
-		xfs_alloc_log_ptrs(cur, lbp, nrec, nrec);
-		xfs_btree_check_key(cur->bc_btnum, lkp - 1, lkp);
-	}
-	/*
-	 * If leaf, copy a record to the left block.
-	 */
-	else {
-		xfs_alloc_rec_t	*lrp;	/* record pointer for left block */
-
-		lrp = XFS_ALLOC_REC_ADDR(left, nrec, cur);
-		rrp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-		*lrp = *rrp;
-		xfs_alloc_log_recs(cur, lbp, nrec, nrec);
-		xfs_btree_check_rec(cur->bc_btnum, lrp - 1, lrp);
-	}
-	/*
-	 * Bump and log left's numrecs, decrement and log right's numrecs.
-	 */
-	be16_add_cpu(&left->bb_numrecs, 1);
-	xfs_alloc_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-	be16_add_cpu(&right->bb_numrecs, -1);
-	xfs_alloc_log_block(cur->bc_tp, rbp, XFS_BB_NUMRECS);
-	/*
-	 * Slide the contents of right down one entry.
-	 */
-	if (level > 0) {
-#ifdef DEBUG
-		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i + 1]),
-					level)))
-				return error;
-		}
-#endif
-		memmove(rkp, rkp + 1, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memmove(rpp, rpp + 1, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-		xfs_alloc_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		xfs_alloc_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-	} else {
-		memmove(rrp, rrp + 1, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		xfs_alloc_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		key.ar_startblock = rrp->ar_startblock;
-		key.ar_blockcount = rrp->ar_blockcount;
-		rkp = &key;
-	}
-	/*
-	 * Update the parent key values of right.
-	 */
-	if ((error = xfs_alloc_updkey(cur, rkp, level + 1)))
-		return error;
-	/*
-	 * Slide the cursor value left one.
-	 */
-	cur->bc_ptrs[level]--;
-	*stat = 1;
-	return 0;
-}
-
-/*
- * Allocate a new root block, fill it in.
- */
-STATIC int				/* error */
-xfs_alloc_newroot(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			*stat)	/* success/failure */
-{
-	int			error;	/* error return value */
-	xfs_agblock_t		lbno;	/* left block number */
-	xfs_buf_t		*lbp;	/* left btree buffer */
-	xfs_alloc_block_t	*left;	/* left btree block */
-	xfs_mount_t		*mp;	/* mount structure */
-	xfs_agblock_t		nbno;	/* new block number */
-	xfs_buf_t		*nbp;	/* new (root) buffer */
-	xfs_alloc_block_t	*new;	/* new (root) btree block */
-	int			nptr;	/* new value for key index, 1 or 2 */
-	xfs_agblock_t		rbno;	/* right block number */
-	xfs_buf_t		*rbp;	/* right btree buffer */
-	xfs_alloc_block_t	*right;	/* right btree block */
-
-	mp = cur->bc_mp;
-
-	ASSERT(cur->bc_nlevels < XFS_AG_MAXLEVELS(mp));
-	/*
-	 * Get a buffer from the freelist blocks, for the new root.
-	 */
-	error = xfs_alloc_get_freelist(cur->bc_tp,
-					cur->bc_private.a.agbp, &nbno, 1);
-	if (error)
-		return error;
-	/*
-	 * None available, we fail.
-	 */
-	if (nbno == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	xfs_trans_agbtree_delta(cur->bc_tp, 1);
-	nbp = xfs_btree_get_bufs(mp, cur->bc_tp, cur->bc_private.a.agno, nbno,
-		0);
-	new = XFS_BUF_TO_ALLOC_BLOCK(nbp);
-	/*
-	 * Set the root data in the a.g. freespace structure.
-	 */
-	{
-		xfs_agf_t	*agf;	/* a.g. freespace header */
-		xfs_agnumber_t	seqno;
-
-		agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-		agf->agf_roots[cur->bc_btnum] = cpu_to_be32(nbno);
-		be32_add_cpu(&agf->agf_levels[cur->bc_btnum], 1);
-		seqno = be32_to_cpu(agf->agf_seqno);
-		mp->m_perag[seqno].pagf_levels[cur->bc_btnum]++;
-		xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp,
-			XFS_AGF_ROOTS | XFS_AGF_LEVELS);
-	}
-	/*
-	 * At the previous root level there are now two blocks: the old
-	 * root, and the new block generated when it was split.
-	 * We don't know which one the cursor is pointing at, so we
-	 * set up variables "left" and "right" for each case.
-	 */
-	lbp = cur->bc_bufs[cur->bc_nlevels - 1];
-	left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, left, cur->bc_nlevels - 1, lbp)))
-		return error;
-#endif
-	if (be32_to_cpu(left->bb_rightsib) != NULLAGBLOCK) {
-		/*
-		 * Our block is left, pick up the right block.
-		 */
-		lbno = XFS_DADDR_TO_AGBNO(mp, XFS_BUF_ADDR(lbp));
-		rbno = be32_to_cpu(left->bb_rightsib);
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, rbno, 0, &rbp,
-				XFS_ALLOC_BTREE_REF)))
-			return error;
-		right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-		if ((error = xfs_btree_check_sblock(cur, right,
-				cur->bc_nlevels - 1, rbp)))
-			return error;
-		nptr = 1;
-	} else {
-		/*
-		 * Our block is right, pick up the left block.
-		 */
-		rbp = lbp;
-		right = left;
-		rbno = XFS_DADDR_TO_AGBNO(mp, XFS_BUF_ADDR(rbp));
-		lbno = be32_to_cpu(right->bb_leftsib);
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.a.agno, lbno, 0, &lbp,
-				XFS_ALLOC_BTREE_REF)))
-			return error;
-		left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-		if ((error = xfs_btree_check_sblock(cur, left,
-				cur->bc_nlevels - 1, lbp)))
-			return error;
-		nptr = 2;
-	}
-	/*
-	 * Fill in the new block's btree header and log it.
-	 */
-	new->bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
-	new->bb_level = cpu_to_be16(cur->bc_nlevels);
-	new->bb_numrecs = cpu_to_be16(2);
-	new->bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-	new->bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-	xfs_alloc_log_block(cur->bc_tp, nbp, XFS_BB_ALL_BITS);
-	ASSERT(lbno != NULLAGBLOCK && rbno != NULLAGBLOCK);
-	/*
-	 * Fill in the key data in the new root.
-	 */
-	{
-		xfs_alloc_key_t		*kp;	/* btree key pointer */
-
-		kp = XFS_ALLOC_KEY_ADDR(new, 1, cur);
-		if (be16_to_cpu(left->bb_level) > 0) {
-			kp[0] = *XFS_ALLOC_KEY_ADDR(left, 1, cur);
-			kp[1] = *XFS_ALLOC_KEY_ADDR(right, 1, cur);
-		} else {
-			xfs_alloc_rec_t	*rp;	/* btree record pointer */
-
-			rp = XFS_ALLOC_REC_ADDR(left, 1, cur);
-			kp[0].ar_startblock = rp->ar_startblock;
-			kp[0].ar_blockcount = rp->ar_blockcount;
-			rp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-			kp[1].ar_startblock = rp->ar_startblock;
-			kp[1].ar_blockcount = rp->ar_blockcount;
-		}
-	}
-	xfs_alloc_log_keys(cur, nbp, 1, 2);
-	/*
-	 * Fill in the pointer data in the new root.
-	 */
-	{
-		xfs_alloc_ptr_t		*pp;	/* btree address pointer */
-
-		pp = XFS_ALLOC_PTR_ADDR(new, 1, cur);
-		pp[0] = cpu_to_be32(lbno);
-		pp[1] = cpu_to_be32(rbno);
-	}
-	xfs_alloc_log_ptrs(cur, nbp, 1, 2);
-	/*
-	 * Fix up the cursor.
-	 */
-	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
-	cur->bc_ptrs[cur->bc_nlevels] = nptr;
-	cur->bc_nlevels++;
-	*stat = 1;
-	return 0;
-}
-
-/*
- * Move 1 record right from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int				/* error */
-xfs_alloc_rshift(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to shift record on */
-	int			*stat)	/* success/failure */
-{
-	int			error;	/* error return value */
-	int			i;	/* loop index */
-	xfs_alloc_key_t		key;	/* key value for leaf level upward */
-	xfs_buf_t		*lbp;	/* buffer for left (current) block */
-	xfs_alloc_block_t	*left;	/* left (current) btree block */
-	xfs_buf_t		*rbp;	/* buffer for right neighbor block */
-	xfs_alloc_block_t	*right;	/* right neighbor btree block */
-	xfs_alloc_key_t		*rkp;	/* key pointer for right block */
-	xfs_btree_cur_t		*tcur;	/* temporary cursor */
-
-	/*
-	 * Set up variables for this block as "left".
-	 */
-	lbp = cur->bc_bufs[level];
-	left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
+	/* Allocate the new block from the freelist. If we can't, give up.  */
+	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
+				       &bno, 1);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 		return error;
-#endif
-	/*
-	 * If we've got no right sibling then we can't shift an entry right.
-	 */
-	if (be32_to_cpu(left->bb_rightsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * If the cursor entry is the one that would be moved, don't
-	 * do it... it's too complicated.
-	 */
-	if (cur->bc_ptrs[level] >= be16_to_cpu(left->bb_numrecs)) {
-		*stat = 0;
-		return 0;
 	}
-	/*
-	 * Set up the right neighbor as "right".
-	 */
-	if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agno, be32_to_cpu(left->bb_rightsib),
-			0, &rbp, XFS_ALLOC_BTREE_REF)))
-		return error;
-	right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-	if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-		return error;
-	/*
-	 * If it's full, it can't take another entry.
-	 */
-	if (be16_to_cpu(right->bb_numrecs) == XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
+
+	if (bno == NULLAGBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 		*stat = 0;
 		return 0;
 	}
-	/*
-	 * Make a hole at the start of the right neighbor block, then
-	 * copy the last left block entry to the hole.
-	 */
-	if (level > 0) {
-		xfs_alloc_key_t	*lkp;	/* key pointer for left block */
-		xfs_alloc_ptr_t	*lpp;	/* address pointer for left block */
-		xfs_alloc_ptr_t	*rpp;	/* address pointer for right block */
-
-		lkp = XFS_ALLOC_KEY_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		lpp = XFS_ALLOC_PTR_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rkp = XFS_ALLOC_KEY_ADDR(right, 1, cur);
-		rpp = XFS_ALLOC_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = be16_to_cpu(right->bb_numrecs) - 1; i >= 0; i--) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i]), level)))
-				return error;
-		}
-#endif
-		memmove(rkp + 1, rkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memmove(rpp + 1, rpp, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(*lpp), level)))
-			return error;
-#endif
-		*rkp = *lkp;
-		*rpp = *lpp;
-		xfs_alloc_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		xfs_alloc_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		xfs_btree_check_key(cur->bc_btnum, rkp, rkp + 1);
-	} else {
-		xfs_alloc_rec_t	*lrp;	/* record pointer for left block */
-		xfs_alloc_rec_t	*rrp;	/* record pointer for right block */
 
-		lrp = XFS_ALLOC_REC_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rrp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-		memmove(rrp + 1, rrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		*rrp = *lrp;
-		xfs_alloc_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		key.ar_startblock = rrp->ar_startblock;
-		key.ar_blockcount = rrp->ar_blockcount;
-		rkp = &key;
-		xfs_btree_check_rec(cur->bc_btnum, rrp, rrp + 1);
-	}
-	/*
-	 * Decrement and log left's numrecs, bump and log right's numrecs.
-	 */
-	be16_add_cpu(&left->bb_numrecs, -1);
-	xfs_alloc_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-	be16_add_cpu(&right->bb_numrecs, 1);
-	xfs_alloc_log_block(cur->bc_tp, rbp, XFS_BB_NUMRECS);
-	/*
-	 * Using a temporary cursor, update the parent key values of the
-	 * block on the right.
-	 */
-	if ((error = xfs_btree_dup_cursor(cur, &tcur)))
-		return error;
-	i = xfs_btree_lastrec(tcur, level);
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-	if ((error = xfs_alloc_increment(tcur, level, &i)) ||
-	    (error = xfs_alloc_updkey(tcur, rkp, level + 1)))
-		goto error0;
-	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+	xfs_trans_agbtree_delta(cur->bc_tp, 1);
+	new->s = cpu_to_be32(bno);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 	*stat = 1;
 	return 0;
-error0:
-	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-	return error;
 }
 
-/*
- * Split cur/level block in half.
- * Return new block number and its first record (to be inserted into parent).
- */
-STATIC int				/* error */
-xfs_alloc_split(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to split */
-	xfs_agblock_t		*bnop,	/* output: block number allocated */
-	xfs_alloc_key_t		*keyp,	/* output: first key of new block */
-	xfs_btree_cur_t		**curp,	/* output: new cursor */
-	int			*stat)	/* success/failure */
-{
-	int			error;	/* error return value */
-	int			i;	/* loop index/record number */
-	xfs_agblock_t		lbno;	/* left (current) block number */
-	xfs_buf_t		*lbp;	/* buffer for left block */
-	xfs_alloc_block_t	*left;	/* left (current) btree block */
-	xfs_agblock_t		rbno;	/* right (new) block number */
-	xfs_buf_t		*rbp;	/* buffer for right block */
-	xfs_alloc_block_t	*right;	/* right (new) btree block */
+STATIC int
+xfs_allocbt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agblock_t		bno;
+	int			error;
 
-	/*
-	 * Allocate the new block from the freelist.
-	 * If we can't do it, we're toast.  Give up.
-	 */
-	error = xfs_alloc_get_freelist(cur->bc_tp,
-					 cur->bc_private.a.agbp, &rbno, 1);
+	bno = XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(bp));
+	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
 	if (error)
 		return error;
-	if (rbno == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	xfs_trans_agbtree_delta(cur->bc_tp, 1);
-	rbp = xfs_btree_get_bufs(cur->bc_mp, cur->bc_tp, cur->bc_private.a.agno,
-		rbno, 0);
-	/*
-	 * Set up the new block as "right".
-	 */
-	right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-	/*
-	 * "Left" is the current (according to the cursor) block.
-	 */
-	lbp = cur->bc_bufs[level];
-	left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-		return error;
-#endif
-	/*
-	 * Fill in the btree header for the new block.
-	 */
-	right->bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
-	right->bb_level = left->bb_level;
-	right->bb_numrecs = cpu_to_be16(be16_to_cpu(left->bb_numrecs) / 2);
-	/*
-	 * Make sure that if there's an odd number of entries now, that
-	 * each new block will have the same number of entries.
-	 */
-	if ((be16_to_cpu(left->bb_numrecs) & 1) &&
-	    cur->bc_ptrs[level] <= be16_to_cpu(right->bb_numrecs) + 1)
-		be16_add_cpu(&right->bb_numrecs, 1);
-	i = be16_to_cpu(left->bb_numrecs) - be16_to_cpu(right->bb_numrecs) + 1;
-	/*
-	 * For non-leaf blocks, copy keys and addresses over to the new block.
-	 */
-	if (level > 0) {
-		xfs_alloc_key_t	*lkp;	/* left btree key pointer */
-		xfs_alloc_ptr_t	*lpp;	/* left btree address pointer */
-		xfs_alloc_key_t	*rkp;	/* right btree key pointer */
-		xfs_alloc_ptr_t	*rpp;	/* right btree address pointer */
-
-		lkp = XFS_ALLOC_KEY_ADDR(left, i, cur);
-		lpp = XFS_ALLOC_PTR_ADDR(left, i, cur);
-		rkp = XFS_ALLOC_KEY_ADDR(right, 1, cur);
-		rpp = XFS_ALLOC_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(lpp[i]), level)))
-				return error;
-		}
-#endif
-		memcpy(rkp, lkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memcpy(rpp, lpp, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-		xfs_alloc_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		xfs_alloc_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		*keyp = *rkp;
-	}
-	/*
-	 * For leaf blocks, copy records over to the new block.
-	 */
-	else {
-		xfs_alloc_rec_t	*lrp;	/* left btree record pointer */
-		xfs_alloc_rec_t	*rrp;	/* right btree record pointer */
-
-		lrp = XFS_ALLOC_REC_ADDR(left, i, cur);
-		rrp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-		memcpy(rrp, lrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		xfs_alloc_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		keyp->ar_startblock = rrp->ar_startblock;
-		keyp->ar_blockcount = rrp->ar_blockcount;
-	}
-	/*
-	 * Find the left block number by looking in the buffer.
-	 * Adjust numrecs, sibling pointers.
-	 */
-	lbno = XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(lbp));
-	be16_add_cpu(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
-	right->bb_rightsib = left->bb_rightsib;
-	left->bb_rightsib = cpu_to_be32(rbno);
-	right->bb_leftsib = cpu_to_be32(lbno);
-	xfs_alloc_log_block(cur->bc_tp, rbp, XFS_BB_ALL_BITS);
-	xfs_alloc_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
-	/*
-	 * If there's a block to the new block's right, make that block
-	 * point back to right instead of to left.
-	 */
-	if (be32_to_cpu(right->bb_rightsib) != NULLAGBLOCK) {
-		xfs_alloc_block_t	*rrblock;	/* rr btree block */
-		xfs_buf_t		*rrbp;		/* buffer for rrblock */
-
-		if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-				cur->bc_private.a.agno, be32_to_cpu(right->bb_rightsib), 0,
-				&rrbp, XFS_ALLOC_BTREE_REF)))
-			return error;
-		rrblock = XFS_BUF_TO_ALLOC_BLOCK(rrbp);
-		if ((error = xfs_btree_check_sblock(cur, rrblock, level, rrbp)))
-			return error;
-		rrblock->bb_leftsib = cpu_to_be32(rbno);
-		xfs_alloc_log_block(cur->bc_tp, rrbp, XFS_BB_LEFTSIB);
-	}
-	/*
-	 * If the cursor is really in the right block, move it there.
-	 * If it's just pointing past the last entry in left, then we'll
-	 * insert there, so don't change anything in that case.
-	 */
-	if (cur->bc_ptrs[level] > be16_to_cpu(left->bb_numrecs) + 1) {
-		xfs_btree_setbuf(cur, level, rbp);
-		cur->bc_ptrs[level] -= be16_to_cpu(left->bb_numrecs);
-	}
+
 	/*
-	 * If there are more levels, we'll need another cursor which refers to
-	 * the right block, no matter where this cursor was.
+	 * Since blocks move to the free list without the coordination used in
+	 * xfs_bmap_finish, we can't allow block to be available for
+	 * reallocation and non-transaction writing (user data) until we know
+	 * that the transaction that moved it to the free list is permanently
+	 * on disk. We track the blocks by declaring these blocks as "busy";
+	 * the busy list is maintained on a per-ag basis and each transaction
+	 * records which entries should be removed when the iclog commits to
+	 * disk. If a busy block is allocated, the iclog is pushed up to the
+	 * LSN that freed the block.
 	 */
-	if (level + 1 < cur->bc_nlevels) {
-		if ((error = xfs_btree_dup_cursor(cur, curp)))
-			return error;
-		(*curp)->bc_ptrs[level + 1]++;
-	}
-	*bnop = rbno;
-	*stat = 1;
+	xfs_alloc_mark_busy(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
+	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 	return 0;
 }
 
 /*
- * Update keys at all levels from here to the root along the cursor's path.
+ * Update the longest extent in the AGF
  */
-STATIC int				/* error */
-xfs_alloc_updkey(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_alloc_key_t		*keyp,	/* new key value to update to */
-	int			level)	/* starting level for update */
-{
-	int			ptr;	/* index of key in block */
+STATIC void
+xfs_allocbt_update_lastrec(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	union xfs_btree_rec	*rec,
+	int			ptr,
+	int			reason)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	__be32			len;
+	int			numrecs;
 
-	/*
-	 * Go up the tree from this level toward the root.
-	 * At each level, update the key value to the value input.
-	 * Stop when we reach a level where the cursor isn't pointing
-	 * at the first entry in the block.
-	 */
-	for (ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
-		xfs_alloc_block_t	*block;	/* btree block */
-		xfs_buf_t		*bp;	/* buffer for block */
-#ifdef DEBUG
-		int			error;	/* error return value */
-#endif
-		xfs_alloc_key_t		*kp;	/* ptr to btree block keys */
+	ASSERT(cur->bc_btnum == XFS_BTNUM_CNT);
 
-		bp = cur->bc_bufs[level];
-		block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-			return error;
-#endif
-		ptr = cur->bc_ptrs[level];
-		kp = XFS_ALLOC_KEY_ADDR(block, ptr, cur);
-		*kp = *keyp;
-		xfs_alloc_log_keys(cur, bp, ptr, ptr);
+	switch (reason) {
+	case LASTREC_UPDATE:
+		/*
+		 * If this is the last leaf block and it's the last record,
+		 * then update the size of the longest extent in the AG.
+		 */
+		if (ptr != xfs_btree_get_numrecs(block))
+			return;
+		len = rec->alloc.ar_blockcount;
+		break;
+	case LASTREC_INSREC:
+		if (be32_to_cpu(rec->alloc.ar_blockcount) <=
+		    be32_to_cpu(agf->agf_longest))
+			return;
+		len = rec->alloc.ar_blockcount;
+		break;
+	case LASTREC_DELREC:
+		numrecs = xfs_btree_get_numrecs(block);
+		if (ptr <= numrecs)
+			return;
+		ASSERT(ptr == numrecs + 1);
+
+		if (numrecs) {
+			xfs_alloc_rec_t *rrp;
+
+			rrp = XFS_ALLOC_REC_ADDR(block, numrecs, cur);
+			len = rrp->ar_blockcount;
+		} else {
+			len = 0;
+		}
+
+		break;
+	default:
+		ASSERT(0);
+		return;
 	}
-	return 0;
+
+	agf->agf_longest = len;
+	cur->bc_mp->m_perag[seqno].pagf_longest = be32_to_cpu(len);
+	xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp, XFS_AGF_LONGEST);
 }
 
-/*
- * Externally visible routines.
- */
+STATIC int
+xfs_allocbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_alloc_mnr[level != 0];
+}
 
-/*
- * Decrement cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int					/* error */
-xfs_alloc_decrement(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree, 0 is leaf */
-	int			*stat)	/* success/failure */
+STATIC int
+xfs_allocbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
 {
-	xfs_alloc_block_t	*block;	/* btree block */
-	int			error;	/* error return value */
-	int			lev;	/* btree level */
+	return cur->bc_mp->m_alloc_mxr[level != 0];
+}
 
-	ASSERT(level < cur->bc_nlevels);
-	/*
-	 * Read-ahead to the left at this level.
-	 */
-	xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
-	/*
-	 * Decrement the ptr at this level.  If we're still in the block
-	 * then we're done.
-	 */
-	if (--cur->bc_ptrs[level] > 0) {
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * Get a pointer to the btree block.
-	 */
-	block = XFS_BUF_TO_ALLOC_BLOCK(cur->bc_bufs[level]);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level,
-			cur->bc_bufs[level])))
-		return error;
-#endif
-	/*
-	 * If we just went off the left edge of the tree, return failure.
-	 */
-	if (be32_to_cpu(block->bb_leftsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * March up the tree decrementing pointers.
-	 * Stop when we don't go off the left edge of a block.
-	 */
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		if (--cur->bc_ptrs[lev] > 0)
-			break;
-		/*
-		 * Read-ahead the left block, we're going to read it
-		 * in the next loop.
-		 */
-		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
-	}
-	/*
-	 * If we went off the root then we are seriously confused.
-	 */
-	ASSERT(lev < cur->bc_nlevels);
-	/*
-	 * Now walk back down the tree, fixing up the cursor's buffer
-	 * pointers and key numbers.
-	 */
-	for (block = XFS_BUF_TO_ALLOC_BLOCK(cur->bc_bufs[lev]); lev > level; ) {
-		xfs_agblock_t	agbno;	/* block number of btree block */
-		xfs_buf_t	*bp;	/* buffer pointer for block */
-
-		agbno = be32_to_cpu(*XFS_ALLOC_PTR_ADDR(block, cur->bc_ptrs[lev], cur));
-		if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-				cur->bc_private.a.agno, agbno, 0, &bp,
-				XFS_ALLOC_BTREE_REF)))
-			return error;
-		lev--;
-		xfs_btree_setbuf(cur, lev, bp);
-		block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-		if ((error = xfs_btree_check_sblock(cur, block, lev, bp)))
-			return error;
-		cur->bc_ptrs[lev] = be16_to_cpu(block->bb_numrecs);
-	}
-	*stat = 1;
-	return 0;
+STATIC void
+xfs_allocbt_init_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(rec->alloc.ar_startblock != 0);
+
+	key->alloc.ar_startblock = rec->alloc.ar_startblock;
+	key->alloc.ar_blockcount = rec->alloc.ar_blockcount;
 }
 
-/*
- * Delete the record pointed to by cur.
- * The cursor refers to the place where the record was (could be inserted)
- * when the operation returns.
- */
-int					/* error */
-xfs_alloc_delete(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		*stat)		/* success/failure */
+STATIC void
+xfs_allocbt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
 {
-	int		error;		/* error return value */
-	int		i;		/* result code */
-	int		level;		/* btree level */
+	ASSERT(key->alloc.ar_startblock != 0);
 
-	/*
-	 * Go up the tree, starting at leaf level.
-	 * If 2 is returned then a join was done; go to the next level.
-	 * Otherwise we are done.
-	 */
-	for (level = 0, i = 2; i == 2; level++) {
-		if ((error = xfs_alloc_delrec(cur, level, &i)))
-			return error;
-	}
-	if (i == 0) {
-		for (level = 1; level < cur->bc_nlevels; level++) {
-			if (cur->bc_ptrs[level] == 0) {
-				if ((error = xfs_alloc_decrement(cur, level, &i)))
-					return error;
-				break;
-			}
-		}
-	}
-	*stat = i;
-	return 0;
+	rec->alloc.ar_startblock = key->alloc.ar_startblock;
+	rec->alloc.ar_blockcount = key->alloc.ar_blockcount;
 }
 
-/*
- * Get the data from the pointed-to record.
- */
-int					/* error */
-xfs_alloc_get_rec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agblock_t		*bno,	/* output: starting block of extent */
-	xfs_extlen_t		*len,	/* output: length of extent */
-	int			*stat)	/* output: success/failure */
+STATIC void
+xfs_allocbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
 {
-	xfs_alloc_block_t	*block;	/* btree block */
-#ifdef DEBUG
-	int			error;	/* error return value */
-#endif
-	int			ptr;	/* record number */
+	ASSERT(cur->bc_rec.a.ar_startblock != 0);
 
-	ptr = cur->bc_ptrs[0];
-	block = XFS_BUF_TO_ALLOC_BLOCK(cur->bc_bufs[0]);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, 0, cur->bc_bufs[0])))
-		return error;
-#endif
-	/*
-	 * Off the right end or left end, return failure.
-	 */
-	if (ptr > be16_to_cpu(block->bb_numrecs) || ptr <= 0) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Point to the record and extract its data.
-	 */
-	{
-		xfs_alloc_rec_t		*rec;	/* record data */
+	rec->alloc.ar_startblock = cpu_to_be32(cur->bc_rec.a.ar_startblock);
+	rec->alloc.ar_blockcount = cpu_to_be32(cur->bc_rec.a.ar_blockcount);
+}
 
-		rec = XFS_ALLOC_REC_ADDR(block, ptr, cur);
-		*bno = be32_to_cpu(rec->ar_startblock);
-		*len = be32_to_cpu(rec->ar_blockcount);
+STATIC void
+xfs_allocbt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+
+	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(agf->agf_roots[cur->bc_btnum] != 0);
+
+	ptr->s = agf->agf_roots[cur->bc_btnum];
+}
+
+STATIC __int64_t
+xfs_allocbt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	xfs_alloc_rec_incore_t	*rec = &cur->bc_rec.a;
+	xfs_alloc_key_t		*kp = &key->alloc;
+	__int64_t		diff;
+
+	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+		return (__int64_t)be32_to_cpu(kp->ar_startblock) -
+				rec->ar_startblock;
 	}
-	*stat = 1;
-	return 0;
+
+	diff = (__int64_t)be32_to_cpu(kp->ar_blockcount) - rec->ar_blockcount;
+	if (diff)
+		return diff;
+
+	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
-/*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int					/* error */
-xfs_alloc_increment(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree, 0 is leaf */
-	int			*stat)	/* success/failure */
+STATIC int
+xfs_allocbt_kill_root(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			level,
+	union xfs_btree_ptr	*newroot)
 {
-	xfs_alloc_block_t	*block;	/* btree block */
-	xfs_buf_t		*bp;	/* tree block buffer */
-	int			error;	/* error return value */
-	int			lev;	/* btree level */
+	int			error;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_STATS_INC(cur, killroot);
 
-	ASSERT(level < cur->bc_nlevels);
-	/*
-	 * Read-ahead to the right at this level.
-	 */
-	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
 	/*
-	 * Get a pointer to the btree block.
+	 * Update the root pointer, decreasing the level by 1 and then
+	 * free the old root.
 	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
+	xfs_allocbt_set_root(cur, newroot, -1);
+	error = xfs_allocbt_free_block(cur, bp);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 		return error;
-#endif
-	/*
-	 * Increment the ptr at this level.  If we're still in the block
-	 * then we're done.
-	 */
-	if (++cur->bc_ptrs[level] <= be16_to_cpu(block->bb_numrecs)) {
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * If we just went off the right edge of the tree, return failure.
-	 */
-	if (be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * March up the tree incrementing pointers.
-	 * Stop when we don't go off the right edge of a block.
-	 */
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		bp = cur->bc_bufs[lev];
-		block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, block, lev, bp)))
-			return error;
-#endif
-		if (++cur->bc_ptrs[lev] <= be16_to_cpu(block->bb_numrecs))
-			break;
-		/*
-		 * Read-ahead the right block, we're going to read it
-		 * in the next loop.
-		 */
-		xfs_btree_readahead(cur, lev, XFS_BTCUR_RIGHTRA);
-	}
-	/*
-	 * If we went off the root then we are seriously confused.
-	 */
-	ASSERT(lev < cur->bc_nlevels);
-	/*
-	 * Now walk back down the tree, fixing up the cursor's buffer
-	 * pointers and key numbers.
-	 */
-	for (bp = cur->bc_bufs[lev], block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-	     lev > level; ) {
-		xfs_agblock_t	agbno;	/* block number of btree block */
-
-		agbno = be32_to_cpu(*XFS_ALLOC_PTR_ADDR(block, cur->bc_ptrs[lev], cur));
-		if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-				cur->bc_private.a.agno, agbno, 0, &bp,
-				XFS_ALLOC_BTREE_REF)))
-			return error;
-		lev--;
-		xfs_btree_setbuf(cur, lev, bp);
-		block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-		if ((error = xfs_btree_check_sblock(cur, block, lev, bp)))
-			return error;
-		cur->bc_ptrs[lev] = 1;
 	}
-	*stat = 1;
+
+	XFS_BTREE_STATS_INC(cur, free);
+
+	xfs_btree_setbuf(cur, level, NULL);
+	cur->bc_nlevels--;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 	return 0;
 }
 
-/*
- * Insert the current record at the point referenced by cur.
- * The cursor may be inconsistent on return if splits have been done.
- */
-int					/* error */
-xfs_alloc_insert(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		*stat)		/* success/failure */
+#ifdef DEBUG
+STATIC int
+xfs_allocbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
 {
-	int		error;		/* error return value */
-	int		i;		/* result value, 0 for failure */
-	int		level;		/* current level number in btree */
-	xfs_agblock_t	nbno;		/* new block number (split result) */
-	xfs_btree_cur_t	*ncur;		/* new cursor (split result) */
-	xfs_alloc_rec_t	nrec;		/* record being inserted this level */
-	xfs_btree_cur_t	*pcur;		/* previous level's cursor */
-
-	level = 0;
-	nbno = NULLAGBLOCK;
-	nrec.ar_startblock = cpu_to_be32(cur->bc_rec.a.ar_startblock);
-	nrec.ar_blockcount = cpu_to_be32(cur->bc_rec.a.ar_blockcount);
-	ncur = NULL;
-	pcur = cur;
-	/*
-	 * Loop going up the tree, starting at the leaf level.
-	 * Stop when we don't get a split block, that must mean that
-	 * the insert is finished with this level.
-	 */
-	do {
-		/*
-		 * Insert nrec/nbno into this level of the tree.
-		 * Note if we fail, nbno will be null.
-		 */
-		if ((error = xfs_alloc_insrec(pcur, level++, &nbno, &nrec, &ncur,
-				&i))) {
-			if (pcur != cur)
-				xfs_btree_del_cursor(pcur, XFS_BTREE_ERROR);
-			return error;
-		}
-		/*
-		 * See if the cursor we just used is trash.
-		 * Can't trash the caller's cursor, but otherwise we should
-		 * if ncur is a new cursor or we're about to be done.
-		 */
-		if (pcur != cur && (ncur || nbno == NULLAGBLOCK)) {
-			cur->bc_nlevels = pcur->bc_nlevels;
-			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
-		}
-		/*
-		 * If we got a new cursor, switch to it.
-		 */
-		if (ncur) {
-			pcur = ncur;
-			ncur = NULL;
-		}
-	} while (nbno != NULLAGBLOCK);
-	*stat = i;
-	return 0;
+	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+		return be32_to_cpu(k1->alloc.ar_startblock) <
+		       be32_to_cpu(k2->alloc.ar_startblock);
+	} else {
+		return be32_to_cpu(k1->alloc.ar_blockcount) <
+			be32_to_cpu(k2->alloc.ar_blockcount) ||
+			(k1->alloc.ar_blockcount == k2->alloc.ar_blockcount &&
+			 be32_to_cpu(k1->alloc.ar_startblock) <
+			 be32_to_cpu(k2->alloc.ar_startblock));
+	}
 }
 
-/*
- * Lookup the record equal to [bno, len] in the btree given by cur.
- */
-int					/* error */
-xfs_alloc_lookup_eq(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	xfs_agblock_t	bno,		/* starting block of extent */
-	xfs_extlen_t	len,		/* length of extent */
-	int		*stat)		/* success/failure */
-{
-	cur->bc_rec.a.ar_startblock = bno;
-	cur->bc_rec.a.ar_blockcount = len;
-	return xfs_alloc_lookup(cur, XFS_LOOKUP_EQ, stat);
+STATIC int
+xfs_allocbt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
+{
+	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+		return be32_to_cpu(r1->alloc.ar_startblock) +
+			be32_to_cpu(r1->alloc.ar_blockcount) <=
+			be32_to_cpu(r2->alloc.ar_startblock);
+	} else {
+		return be32_to_cpu(r1->alloc.ar_blockcount) <
+			be32_to_cpu(r2->alloc.ar_blockcount) ||
+			(r1->alloc.ar_blockcount == r2->alloc.ar_blockcount &&
+			 be32_to_cpu(r1->alloc.ar_startblock) <
+			 be32_to_cpu(r2->alloc.ar_startblock));
+	}
 }
+#endif	/* DEBUG */
 
-/*
- * Lookup the first record greater than or equal to [bno, len]
- * in the btree given by cur.
- */
-int					/* error */
-xfs_alloc_lookup_ge(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	xfs_agblock_t	bno,		/* starting block of extent */
-	xfs_extlen_t	len,		/* length of extent */
-	int		*stat)		/* success/failure */
-{
-	cur->bc_rec.a.ar_startblock = bno;
-	cur->bc_rec.a.ar_blockcount = len;
-	return xfs_alloc_lookup(cur, XFS_LOOKUP_GE, stat);
+#ifdef XFS_BTREE_TRACE
+ktrace_t	*xfs_allocbt_trace_buf;
+
+STATIC void
+xfs_allocbt_trace_enter(
+	struct xfs_btree_cur	*cur,
+	const char		*func,
+	char			*s,
+	int			type,
+	int			line,
+	__psunsigned_t		a0,
+	__psunsigned_t		a1,
+	__psunsigned_t		a2,
+	__psunsigned_t		a3,
+	__psunsigned_t		a4,
+	__psunsigned_t		a5,
+	__psunsigned_t		a6,
+	__psunsigned_t		a7,
+	__psunsigned_t		a8,
+	__psunsigned_t		a9,
+	__psunsigned_t		a10)
+{
+	ktrace_enter(xfs_allocbt_trace_buf, (void *)(__psint_t)type,
+		(void *)func, (void *)s, NULL, (void *)cur,
+		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
+		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
+		(void *)a8, (void *)a9, (void *)a10);
 }
 
-/*
- * Lookup the first record less than or equal to [bno, len]
- * in the btree given by cur.
- */
-int					/* error */
-xfs_alloc_lookup_le(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	xfs_agblock_t	bno,		/* starting block of extent */
-	xfs_extlen_t	len,		/* length of extent */
-	int		*stat)		/* success/failure */
-{
-	cur->bc_rec.a.ar_startblock = bno;
-	cur->bc_rec.a.ar_blockcount = len;
-	return xfs_alloc_lookup(cur, XFS_LOOKUP_LE, stat);
+STATIC void
+xfs_allocbt_trace_cursor(
+	struct xfs_btree_cur	*cur,
+	__uint32_t		*s0,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
+{
+	*s0 = cur->bc_private.a.agno;
+	*l0 = cur->bc_rec.a.ar_startblock;
+	*l1 = cur->bc_rec.a.ar_blockcount;
 }
 
-/*
- * Update the record referred to by cur, to the value given by [bno, len].
- * This either works (return 0) or gets an EFSCORRUPTED error.
- */
-int					/* error */
-xfs_alloc_update(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agblock_t		bno,	/* starting block of extent */
-	xfs_extlen_t		len)	/* length of extent */
+STATIC void
+xfs_allocbt_trace_key(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
 {
-	xfs_alloc_block_t	*block;	/* btree block to update */
-	int			error;	/* error return value */
-	int			ptr;	/* current record number (updating) */
+	*l0 = be32_to_cpu(key->alloc.ar_startblock);
+	*l1 = be32_to_cpu(key->alloc.ar_blockcount);
+}
 
-	ASSERT(len > 0);
-	/*
-	 * Pick up the a.g. freelist struct and the current block.
-	 */
-	block = XFS_BUF_TO_ALLOC_BLOCK(cur->bc_bufs[0]);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, 0, cur->bc_bufs[0])))
-		return error;
-#endif
-	/*
-	 * Get the address of the rec to be updated.
-	 */
-	ptr = cur->bc_ptrs[0];
-	{
-		xfs_alloc_rec_t		*rp;	/* pointer to updated record */
+STATIC void
+xfs_allocbt_trace_record(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	__uint64_t		*l0,
+	__uint64_t		*l1,
+	__uint64_t		*l2)
+{
+	*l0 = be32_to_cpu(rec->alloc.ar_startblock);
+	*l1 = be32_to_cpu(rec->alloc.ar_blockcount);
+	*l2 = 0;
+}
+#endif /* XFS_BTREE_TRACE */
+
+static const struct xfs_btree_ops xfs_allocbt_ops = {
+	.rec_len		= sizeof(xfs_alloc_rec_t),
+	.key_len		= sizeof(xfs_alloc_key_t),
+
+	.dup_cursor		= xfs_allocbt_dup_cursor,
+	.set_root		= xfs_allocbt_set_root,
+	.kill_root		= xfs_allocbt_kill_root,
+	.alloc_block		= xfs_allocbt_alloc_block,
+	.free_block		= xfs_allocbt_free_block,
+	.update_lastrec		= xfs_allocbt_update_lastrec,
+	.get_minrecs		= xfs_allocbt_get_minrecs,
+	.get_maxrecs		= xfs_allocbt_get_maxrecs,
+	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
+	.init_rec_from_key	= xfs_allocbt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
+	.key_diff		= xfs_allocbt_key_diff,
+
+#ifdef DEBUG
+	.keys_inorder		= xfs_allocbt_keys_inorder,
+	.recs_inorder		= xfs_allocbt_recs_inorder,
+#endif
+
+#ifdef XFS_BTREE_TRACE
+	.trace_enter		= xfs_allocbt_trace_enter,
+	.trace_cursor		= xfs_allocbt_trace_cursor,
+	.trace_key		= xfs_allocbt_trace_key,
+	.trace_record		= xfs_allocbt_trace_record,
+#endif
+};
+
+/*
+ * Allocate a new allocation btree cursor.
+ */
+struct xfs_btree_cur *			/* new alloc btree cursor */
+xfs_allocbt_init_cursor(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_buf		*agbp,		/* buffer for agf structure */
+	xfs_agnumber_t		agno,		/* allocation group number */
+	xfs_btnum_t		btnum)		/* btree identifier */
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_btree_cur	*cur;
+
+	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
+
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[btnum]);
+	cur->bc_btnum = btnum;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+
+	cur->bc_ops = &xfs_allocbt_ops;
+	if (btnum == XFS_BTNUM_CNT)
+		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
 
-		rp = XFS_ALLOC_REC_ADDR(block, ptr, cur);
-		/*
-		 * Fill in the new contents and log them.
-		 */
-		rp->ar_startblock = cpu_to_be32(bno);
-		rp->ar_blockcount = cpu_to_be32(len);
-		xfs_alloc_log_recs(cur, cur->bc_bufs[0], ptr, ptr);
-	}
-	/*
-	 * If it's the by-size btree and it's the last leaf block and
-	 * it's the last record... then update the size of the longest
-	 * extent in the a.g., which we cache in the a.g. freelist header.
-	 */
-	if (cur->bc_btnum == XFS_BTNUM_CNT &&
-	    be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK &&
-	    ptr == be16_to_cpu(block->bb_numrecs)) {
-		xfs_agf_t	*agf;	/* a.g. freespace header */
-		xfs_agnumber_t	seqno;
-
-		agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-		seqno = be32_to_cpu(agf->agf_seqno);
-		cur->bc_mp->m_perag[seqno].pagf_longest = len;
-		agf->agf_longest = cpu_to_be32(len);
-		xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp,
-			XFS_AGF_LONGEST);
-	}
-	/*
-	 * Updating first record in leaf. Pass new key value up to our parent.
-	 */
-	if (ptr == 1) {
-		xfs_alloc_key_t	key;	/* key containing [bno, len] */
+	cur->bc_private.a.agbp = agbp;
+	cur->bc_private.a.agno = agno;
 
-		key.ar_startblock = cpu_to_be32(bno);
-		key.ar_blockcount = cpu_to_be32(len);
-		if ((error = xfs_alloc_updkey(cur, &key, 1)))
-			return error;
-	}
-	return 0;
+	return cur;
 }
Index: xfs-cmds/xfsprogs/libxfs/xfs_bmap.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_bmap.c	2008-09-24 19:50:58.000000000 +0200
+++ xfs-cmds/xfsprogs/libxfs/xfs_bmap.c	2008-09-24 20:01:15.000000000 +0200
@@ -327,6 +327,53 @@ xfs_bunmap_trace(
  * Bmap internal routines.
  */
 
+STATIC int				/* error */
+xfs_bmbt_lookup_eq(
+	struct xfs_btree_cur	*cur,
+	xfs_fileoff_t		off,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.b.br_startoff = off;
+	cur->bc_rec.b.br_startblock = bno;
+	cur->bc_rec.b.br_blockcount = len;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
+}
+
+STATIC int				/* error */
+xfs_bmbt_lookup_ge(
+	struct xfs_btree_cur	*cur,
+	xfs_fileoff_t		off,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.b.br_startoff = off;
+	cur->bc_rec.b.br_startblock = bno;
+	cur->bc_rec.b.br_blockcount = len;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
+}
+
+/*
+* Update the record referred to by cur to the value given
+ * by [off, bno, len, state].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int
+xfs_bmbt_update(
+	struct xfs_btree_cur	*cur,
+	xfs_fileoff_t		off,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
+	xfs_exntst_t		state)
+{
+	union xfs_btree_rec	rec;
+
+	xfs_bmbt_disk_set_allf(&rec.bmbt, off, bno, len, state);
+	return xfs_btree_update(cur, &rec);
+}
+
 /*
  * Called from xfs_bmap_add_attrfork to handle btree format files.
  */
@@ -347,15 +394,14 @@ xfs_bmap_add_attrfork_btree(
 	if (ip->i_df.if_broot_bytes <= XFS_IFORK_DSIZE(ip))
 		*flags |= XFS_ILOG_DBROOT;
 	else {
-		cur = xfs_btree_init_cursor(mp, tp, NULL, 0, XFS_BTNUM_BMAP, ip,
-			XFS_DATA_FORK);
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
 		cur->bc_private.b.flist = flist;
 		cur->bc_private.b.firstblock = *firstblock;
 		if ((error = xfs_bmbt_lookup_ge(cur, 0, 0, 0, &stat)))
 			goto error0;
 		/* must be at least one entry */
 		XFS_WANT_CORRUPTED_GOTO(stat == 1, error0);
-		if ((error = xfs_bmbt_newroot(cur, flags, &stat)))
+		if ((error = xfs_btree_new_iroot(cur, flags, &stat)))
 			goto error0;
 		if (stat == 0) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
@@ -743,10 +789,10 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_blockcount, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
@@ -856,7 +902,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -932,7 +978,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -1022,7 +1068,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -1077,7 +1123,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -1304,16 +1350,16 @@ xfs_bmap_add_extent_unwritten_real(
 					RIGHT.br_blockcount, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
@@ -1353,10 +1399,10 @@ xfs_bmap_add_extent_unwritten_real(
 					&i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
@@ -1396,10 +1442,10 @@ xfs_bmap_add_extent_unwritten_real(
 					RIGHT.br_blockcount, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, new->br_startoff,
@@ -1482,7 +1528,7 @@ xfs_bmap_add_extent_unwritten_real(
 				PREV.br_blockcount - new->br_blockcount,
 				oldext)))
 				goto done;
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (xfs_bmbt_update(cur, LEFT.br_startoff,
 				LEFT.br_startblock,
@@ -1530,7 +1576,7 @@ xfs_bmap_add_extent_unwritten_real(
 				oldext)))
 				goto done;
 			cur->bc_rec.b = *new;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -1572,7 +1618,7 @@ xfs_bmap_add_extent_unwritten_real(
 				PREV.br_blockcount - new->br_blockcount,
 				oldext)))
 				goto done;
-			if ((error = xfs_bmbt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto done;
 			if ((error = xfs_bmbt_update(cur, new->br_startoff,
 				new->br_startblock,
@@ -1620,7 +1666,7 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -1668,7 +1714,7 @@ xfs_bmap_add_extent_unwritten_real(
 			cur->bc_rec.b = PREV;
 			cur->bc_rec.b.br_blockcount =
 				new->br_startoff - PREV.br_startoff;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			/*
@@ -1683,7 +1729,7 @@ xfs_bmap_add_extent_unwritten_real(
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			/* new middle extent - newext */
 			cur->bc_rec.b.br_state = new->br_state;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -2031,10 +2077,10 @@ xfs_bmap_add_extent_hole_real(
 					right.br_blockcount, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, left.br_startoff,
@@ -2143,7 +2189,7 @@ xfs_bmap_add_extent_hole_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = new->br_state;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
@@ -2999,7 +3045,7 @@ xfs_bmap_del_extent(
 			flags |= XFS_ILOG_FEXT(whichfork);
 			break;
 		}
-		if ((error = xfs_bmbt_delete(cur, &i)))
+		if ((error = xfs_btree_delete(cur, &i)))
 			goto done;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		break;
@@ -3083,10 +3129,10 @@ xfs_bmap_del_extent(
 						got.br_startblock, temp,
 						got.br_state)))
 					goto done;
-				if ((error = xfs_bmbt_increment(cur, 0, &i)))
+				if ((error = xfs_btree_increment(cur, 0, &i)))
 					goto done;
 				cur->bc_rec.b = new;
-				error = xfs_bmbt_insert(cur, &i);
+				error = xfs_btree_insert(cur, &i);
 				if (error && error != ENOSPC)
 					goto done;
 				/*
@@ -3272,8 +3318,7 @@ xfs_bmap_extents_to_btree(
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
 	mp = ip->i_mount;
-	cur = xfs_btree_init_cursor(mp, tp, NULL, 0, XFS_BTNUM_BMAP, ip,
-		whichfork);
+	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 	cur->bc_private.b.firstblock = *firstblock;
 	cur->bc_private.b.flist = flist;
 	cur->bc_private.b.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
@@ -3349,8 +3394,8 @@ xfs_bmap_extents_to_btree(
 	 * Do all this logging at the end so that
 	 * the root is at the right level.
 	 */
-	xfs_bmbt_log_block(cur, abp, XFS_BB_ALL_BITS);
-	xfs_bmbt_log_recs(cur, abp, 1, be16_to_cpu(ablock->bb_numrecs));
+	xfs_btree_log_block(cur, abp, XFS_BB_ALL_BITS);
+	xfs_btree_log_recs(cur, abp, 1, be16_to_cpu(ablock->bb_numrecs));
 	ASSERT(*curp == NULL);
 	*curp = cur;
 	*logflagsp = XFS_ILOG_CORE | XFS_ILOG_FBROOT(whichfork);
@@ -4520,8 +4565,7 @@ xfs_bmapi(
 				if (abno == NULLFSBLOCK)
 					break;
 				if ((ifp->if_flags & XFS_IFBROOT) && !cur) {
-					cur = xfs_btree_init_cursor(mp,
-						tp, NULL, 0, XFS_BTNUM_BMAP,
+					cur = xfs_bmbt_init_cursor(mp, tp,
 						ip, whichfork);
 					cur->bc_private.b.firstblock =
 						*firstblock;
@@ -4638,9 +4682,8 @@ xfs_bmapi(
 			 */
 			ASSERT(mval->br_blockcount <= len);
 			if ((ifp->if_flags & XFS_IFBROOT) && !cur) {
-				cur = xfs_btree_init_cursor(mp,
-					tp, NULL, 0, XFS_BTNUM_BMAP,
-					ip, whichfork);
+				cur = xfs_bmbt_init_cursor(mp,
+					tp, ip, whichfork);
 				cur->bc_private.b.firstblock =
 					*firstblock;
 				cur->bc_private.b.flist = flist;
@@ -4931,8 +4974,7 @@ xfs_bunmapi(
 	logflags = 0;
 	if (ifp->if_flags & XFS_IFBROOT) {
 		ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
-		cur = xfs_btree_init_cursor(mp, tp, NULL, 0, XFS_BTNUM_BMAP, ip,
-			whichfork);
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = *firstblock;
 		cur->bc_private.b.flist = flist;
 		cur->bc_private.b.flags = 0;
Index: xfs-cmds/xfsprogs/libxfs/xfs_bmap_btree.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_bmap_btree.c	2008-09-24 19:50:58.000000000 +0200
+++ xfs-cmds/xfsprogs/libxfs/xfs_bmap_btree.c	2008-09-24 20:01:15.000000000 +0200
@@ -17,1163 +17,6 @@
  */
 #include <xfs.h>
 
-/*
- * Prototypes for internal btree functions.
- */
-
-
-STATIC int xfs_bmbt_killroot(xfs_btree_cur_t *);
-STATIC void xfs_bmbt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC void xfs_bmbt_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC int xfs_bmbt_lshift(xfs_btree_cur_t *, int, int *);
-STATIC int xfs_bmbt_rshift(xfs_btree_cur_t *, int, int *);
-STATIC int xfs_bmbt_split(xfs_btree_cur_t *, int, xfs_fsblock_t *,
-		__uint64_t *, xfs_btree_cur_t **, int *);
-STATIC int xfs_bmbt_updkey(xfs_btree_cur_t *, xfs_bmbt_key_t *, int);
-
-#define	XFS_BMBT_TRACE_ARGBI(c,b,i)
-#define	XFS_BMBT_TRACE_ARGBII(c,b,i,j)
-#define	XFS_BMBT_TRACE_ARGFFFI(c,o,b,i,j)
-#define	XFS_BMBT_TRACE_ARGI(c,i)
-#define	XFS_BMBT_TRACE_ARGIFK(c,i,f,s)
-#define	XFS_BMBT_TRACE_ARGIFR(c,i,f,r)
-#define	XFS_BMBT_TRACE_ARGIK(c,i,k)
-#define	XFS_BMBT_TRACE_CURSOR(c,s)
-
-/*
- * Internal functions.
- */
-
-/*
- * Delete record pointed to by cur/level.
- */
-STATIC int					/* error */
-xfs_bmbt_delrec(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	int			*stat)		/* success/failure */
-{
-	xfs_bmbt_block_t	*block;		/* bmap btree block */
-	xfs_fsblock_t		bno;		/* fs-relative block number */
-	xfs_buf_t		*bp;		/* buffer for block */
-	int			error;		/* error return value */
-	int			i;		/* loop counter */
-	int			j;		/* temp state */
-	xfs_bmbt_key_t		key;		/* bmap btree key */
-	xfs_bmbt_key_t		*kp=NULL;	/* pointer to bmap btree key */
-	xfs_fsblock_t		lbno;		/* left sibling block number */
-	xfs_buf_t		*lbp;		/* left buffer pointer */
-	xfs_bmbt_block_t	*left;		/* left btree block */
-	xfs_bmbt_key_t		*lkp;		/* left btree key */
-	xfs_bmbt_ptr_t		*lpp;		/* left address pointer */
-	int			lrecs=0;	/* left record count */
-	xfs_bmbt_rec_t		*lrp;		/* left record pointer */
-	xfs_mount_t		*mp;		/* file system mount point */
-	xfs_bmbt_ptr_t		*pp;		/* pointer to bmap block addr */
-	int			ptr;		/* key/record index */
-	xfs_fsblock_t		rbno;		/* right sibling block number */
-	xfs_buf_t		*rbp;		/* right buffer pointer */
-	xfs_bmbt_block_t	*right;		/* right btree block */
-	xfs_bmbt_key_t		*rkp;		/* right btree key */
-	xfs_bmbt_rec_t		*rp;		/* pointer to bmap btree rec */
-	xfs_bmbt_ptr_t		*rpp;		/* right address pointer */
-	xfs_bmbt_block_t	*rrblock;	/* right-right btree block */
-	xfs_buf_t		*rrbp;		/* right-right buffer pointer */
-	int			rrecs=0;	/* right record count */
-	xfs_bmbt_rec_t		*rrp;		/* right record pointer */
-	xfs_btree_cur_t		*tcur;		/* temporary btree cursor */
-	int			numrecs;	/* temporary numrec count */
-	int			numlrecs, numrrecs;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGI(cur, level);
-	ptr = cur->bc_ptrs[level];
-	tcur = NULL;
-	if (ptr == 0) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	block = xfs_bmbt_get_block(cur, level, &bp);
-	numrecs = be16_to_cpu(block->bb_numrecs);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, block, level, bp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		goto error0;
-	}
-#endif
-	if (ptr > numrecs) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	XFS_STATS_INC(xs_bmbt_delrec);
-	if (level > 0) {
-		kp = XFS_BMAP_KEY_IADDR(block, 1, cur);
-		pp = XFS_BMAP_PTR_IADDR(block, 1, cur);
-#ifdef DEBUG
-		for (i = ptr; i < numrecs; i++) {
-			if ((error = xfs_btree_check_lptr_disk(cur, pp[i], level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				goto error0;
-			}
-		}
-#endif
-		if (ptr < numrecs) {
-			memmove(&kp[ptr - 1], &kp[ptr],
-				(numrecs - ptr) * sizeof(*kp));
-			memmove(&pp[ptr - 1], &pp[ptr],
-				(numrecs - ptr) * sizeof(*pp));
-			xfs_bmbt_log_ptrs(cur, bp, ptr, numrecs - 1);
-			xfs_bmbt_log_keys(cur, bp, ptr, numrecs - 1);
-		}
-	} else {
-		rp = XFS_BMAP_REC_IADDR(block, 1, cur);
-		if (ptr < numrecs) {
-			memmove(&rp[ptr - 1], &rp[ptr],
-				(numrecs - ptr) * sizeof(*rp));
-			xfs_bmbt_log_recs(cur, bp, ptr, numrecs - 1);
-		}
-		if (ptr == 1) {
-			key.br_startoff =
-				cpu_to_be64(xfs_bmbt_disk_get_startoff(rp));
-			kp = &key;
-		}
-	}
-	numrecs--;
-	block->bb_numrecs = cpu_to_be16(numrecs);
-	xfs_bmbt_log_block(cur, bp, XFS_BB_NUMRECS);
-	/*
-	 * We're at the root level.
-	 * First, shrink the root block in-memory.
-	 * Try to get rid of the next level down.
-	 * If we can't then there's nothing left to do.
-	 */
-	if (level == cur->bc_nlevels - 1) {
-		xfs_iroot_realloc(cur->bc_private.b.ip, -1,
-			cur->bc_private.b.whichfork);
-		if ((error = xfs_bmbt_killroot(cur))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		if (level > 0 && (error = xfs_bmbt_decrement(cur, level, &j))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 1;
-		return 0;
-	}
-	if (ptr == 1 && (error = xfs_bmbt_updkey(cur, kp, level + 1))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		goto error0;
-	}
-	if (numrecs >= XFS_BMAP_BLOCK_IMINRECS(level, cur)) {
-		if (level > 0 && (error = xfs_bmbt_decrement(cur, level, &j))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 1;
-		return 0;
-	}
-	rbno = be64_to_cpu(block->bb_rightsib);
-	lbno = be64_to_cpu(block->bb_leftsib);
-	/*
-	 * One child of root, need to get a chance to copy its contents
-	 * into the root and delete it. Can't go up to next level,
-	 * there's nothing to delete there.
-	 */
-	if (lbno == NULLFSBLOCK && rbno == NULLFSBLOCK &&
-	    level == cur->bc_nlevels - 2) {
-		if ((error = xfs_bmbt_killroot(cur))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		if (level > 0 && (error = xfs_bmbt_decrement(cur, level, &i))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 1;
-		return 0;
-	}
-	ASSERT(rbno != NULLFSBLOCK || lbno != NULLFSBLOCK);
-	if ((error = xfs_btree_dup_cursor(cur, &tcur))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		goto error0;
-	}
-	bno = NULLFSBLOCK;
-	if (rbno != NULLFSBLOCK) {
-		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_bmbt_increment(tcur, level, &i))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		rbp = tcur->bc_bufs[level];
-		right = XFS_BUF_TO_BMBT_BLOCK(rbp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lblock(cur, right, level, rbp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-#endif
-		bno = be64_to_cpu(right->bb_leftsib);
-		if (be16_to_cpu(right->bb_numrecs) - 1 >=
-		    XFS_BMAP_BLOCK_IMINRECS(level, cur)) {
-			if ((error = xfs_bmbt_lshift(tcur, level, &i))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				goto error0;
-			}
-			if (i) {
-				ASSERT(be16_to_cpu(block->bb_numrecs) >=
-				       XFS_BMAP_BLOCK_IMINRECS(level, tcur));
-				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-				tcur = NULL;
-				if (level > 0) {
-					if ((error = xfs_bmbt_decrement(cur,
-							level, &i))) {
-						XFS_BMBT_TRACE_CURSOR(cur,
-							ERROR);
-						goto error0;
-					}
-				}
-				XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-				*stat = 1;
-				return 0;
-			}
-		}
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		if (lbno != NULLFSBLOCK) {
-			i = xfs_btree_firstrec(tcur, level);
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-			if ((error = xfs_bmbt_decrement(tcur, level, &i))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				goto error0;
-			}
-			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		}
-	}
-	if (lbno != NULLFSBLOCK) {
-		i = xfs_btree_firstrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		/*
-		 * decrement to last in block
-		 */
-		if ((error = xfs_bmbt_decrement(tcur, level, &i))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		i = xfs_btree_firstrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		lbp = tcur->bc_bufs[level];
-		left = XFS_BUF_TO_BMBT_BLOCK(lbp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lblock(cur, left, level, lbp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-#endif
-		bno = be64_to_cpu(left->bb_rightsib);
-		if (be16_to_cpu(left->bb_numrecs) - 1 >=
-		    XFS_BMAP_BLOCK_IMINRECS(level, cur)) {
-			if ((error = xfs_bmbt_rshift(tcur, level, &i))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				goto error0;
-			}
-			if (i) {
-				ASSERT(be16_to_cpu(block->bb_numrecs) >=
-				       XFS_BMAP_BLOCK_IMINRECS(level, tcur));
-				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-				tcur = NULL;
-				if (level == 0)
-					cur->bc_ptrs[0]++;
-				XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-				*stat = 1;
-				return 0;
-			}
-		}
-		lrecs = be16_to_cpu(left->bb_numrecs);
-	}
-	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-	tcur = NULL;
-	mp = cur->bc_mp;
-	ASSERT(bno != NULLFSBLOCK);
-	if (lbno != NULLFSBLOCK &&
-	    lrecs + be16_to_cpu(block->bb_numrecs) <= XFS_BMAP_BLOCK_IMAXRECS(level, cur)) {
-		rbno = bno;
-		right = block;
-		rbp = bp;
-		if ((error = xfs_btree_read_bufl(mp, cur->bc_tp, lbno, 0, &lbp,
-				XFS_BMAP_BTREE_REF))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		left = XFS_BUF_TO_BMBT_BLOCK(lbp);
-		if ((error = xfs_btree_check_lblock(cur, left, level, lbp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-	} else if (rbno != NULLFSBLOCK &&
-		   rrecs + be16_to_cpu(block->bb_numrecs) <=
-		   XFS_BMAP_BLOCK_IMAXRECS(level, cur)) {
-		lbno = bno;
-		left = block;
-		lbp = bp;
-		if ((error = xfs_btree_read_bufl(mp, cur->bc_tp, rbno, 0, &rbp,
-				XFS_BMAP_BTREE_REF))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		right = XFS_BUF_TO_BMBT_BLOCK(rbp);
-		if ((error = xfs_btree_check_lblock(cur, right, level, rbp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		lrecs = be16_to_cpu(left->bb_numrecs);
-	} else {
-		if (level > 0 && (error = xfs_bmbt_decrement(cur, level, &i))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 1;
-		return 0;
-	}
-	numlrecs = be16_to_cpu(left->bb_numrecs);
-	numrrecs = be16_to_cpu(right->bb_numrecs);
-	if (level > 0) {
-		lkp = XFS_BMAP_KEY_IADDR(left, numlrecs + 1, cur);
-		lpp = XFS_BMAP_PTR_IADDR(left, numlrecs + 1, cur);
-		rkp = XFS_BMAP_KEY_IADDR(right, 1, cur);
-		rpp = XFS_BMAP_PTR_IADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = 0; i < numrrecs; i++) {
-			if ((error = xfs_btree_check_lptr_disk(cur, rpp[i], level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				goto error0;
-			}
-		}
-#endif
-		memcpy(lkp, rkp, numrrecs * sizeof(*lkp));
-		memcpy(lpp, rpp, numrrecs * sizeof(*lpp));
-		xfs_bmbt_log_keys(cur, lbp, numlrecs + 1, numlrecs + numrrecs);
-		xfs_bmbt_log_ptrs(cur, lbp, numlrecs + 1, numlrecs + numrrecs);
-	} else {
-		lrp = XFS_BMAP_REC_IADDR(left, numlrecs + 1, cur);
-		rrp = XFS_BMAP_REC_IADDR(right, 1, cur);
-		memcpy(lrp, rrp, numrrecs * sizeof(*lrp));
-		xfs_bmbt_log_recs(cur, lbp, numlrecs + 1, numlrecs + numrrecs);
-	}
-	be16_add_cpu(&left->bb_numrecs, numrrecs);
-	left->bb_rightsib = right->bb_rightsib;
-	xfs_bmbt_log_block(cur, lbp, XFS_BB_RIGHTSIB | XFS_BB_NUMRECS);
-	if (be64_to_cpu(left->bb_rightsib) != NULLDFSBNO) {
-		if ((error = xfs_btree_read_bufl(mp, cur->bc_tp,
-				be64_to_cpu(left->bb_rightsib),
-				0, &rrbp, XFS_BMAP_BTREE_REF))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		rrblock = XFS_BUF_TO_BMBT_BLOCK(rrbp);
-		if ((error = xfs_btree_check_lblock(cur, rrblock, level, rrbp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			goto error0;
-		}
-		rrblock->bb_leftsib = cpu_to_be64(lbno);
-		xfs_bmbt_log_block(cur, rrbp, XFS_BB_LEFTSIB);
-	}
-	xfs_bmap_add_free(XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(rbp)), 1,
-		cur->bc_private.b.flist, mp);
-	cur->bc_private.b.ip->i_d.di_nblocks--;
-	xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
-	XFS_TRANS_MOD_DQUOT_BYINO(mp, cur->bc_tp, cur->bc_private.b.ip,
-			XFS_TRANS_DQ_BCOUNT, -1L);
-	xfs_trans_binval(cur->bc_tp, rbp);
-	if (bp != lbp) {
-		cur->bc_bufs[level] = lbp;
-		cur->bc_ptrs[level] += lrecs;
-		cur->bc_ra[level] = 0;
-	} else if ((error = xfs_bmbt_increment(cur, level + 1, &i))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		goto error0;
-	}
-	if (level > 0)
-		cur->bc_ptrs[level]--;
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 2;
-	return 0;
-
-error0:
-	if (tcur)
-		xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-	return error;
-}
-
-/*
- * Insert one record/level.  Return information to the caller
- * allowing the next level up to proceed if necessary.
- */
-STATIC int					/* error */
-xfs_bmbt_insrec(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	xfs_fsblock_t		*bnop,
-	xfs_bmbt_rec_t		*recp,
-	xfs_btree_cur_t		**curp,
-	int			*stat)		/* no-go/done/continue */
-{
-	xfs_bmbt_block_t	*block;		/* bmap btree block */
-	xfs_buf_t		*bp;		/* buffer for block */
-	int			error;		/* error return value */
-	int			i;		/* loop index */
-	xfs_bmbt_key_t		key;		/* bmap btree key */
-	xfs_bmbt_key_t		*kp=NULL;	/* pointer to bmap btree key */
-	int			logflags;	/* inode logging flags */
-	xfs_fsblock_t		nbno;		/* new block number */
-	struct xfs_btree_cur	*ncur;		/* new btree cursor */
-	__uint64_t		startoff;	/* new btree key value */
-	xfs_bmbt_rec_t		nrec;		/* new record count */
-	int			optr;		/* old key/record index */
-	xfs_bmbt_ptr_t		*pp;		/* pointer to bmap block addr */
-	int			ptr;		/* key/record index */
-	xfs_bmbt_rec_t		*rp=NULL;	/* pointer to bmap btree rec */
-	int			numrecs;
-
-	ASSERT(level < cur->bc_nlevels);
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGIFR(cur, level, *bnop, recp);
-	ncur = NULL;
-	key.br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(recp));
-	optr = ptr = cur->bc_ptrs[level];
-	if (ptr == 0) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	XFS_STATS_INC(xs_bmbt_insrec);
-	block = xfs_bmbt_get_block(cur, level, &bp);
-	numrecs = be16_to_cpu(block->bb_numrecs);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, block, level, bp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	if (ptr <= numrecs) {
-		if (level == 0) {
-			rp = XFS_BMAP_REC_IADDR(block, ptr, cur);
-			xfs_btree_check_rec(XFS_BTNUM_BMAP, recp, rp);
-		} else {
-			kp = XFS_BMAP_KEY_IADDR(block, ptr, cur);
-			xfs_btree_check_key(XFS_BTNUM_BMAP, &key, kp);
-		}
-	}
-#endif
-	nbno = NULLFSBLOCK;
-	if (numrecs == XFS_BMAP_BLOCK_IMAXRECS(level, cur)) {
-		if (numrecs < XFS_BMAP_BLOCK_DMAXRECS(level, cur)) {
-			/*
-			 * A root block, that can be made bigger.
-			 */
-			xfs_iroot_realloc(cur->bc_private.b.ip, 1,
-				cur->bc_private.b.whichfork);
-			block = xfs_bmbt_get_block(cur, level, &bp);
-		} else if (level == cur->bc_nlevels - 1) {
-			if ((error = xfs_bmbt_newroot(cur, &logflags, stat)) ||
-			    *stat == 0) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-			xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
-				logflags);
-			block = xfs_bmbt_get_block(cur, level, &bp);
-		} else {
-			if ((error = xfs_bmbt_rshift(cur, level, &i))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-			if (i) {
-				/* nothing */
-			} else {
-				if ((error = xfs_bmbt_lshift(cur, level, &i))) {
-					XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-					return error;
-				}
-				if (i) {
-					optr = ptr = cur->bc_ptrs[level];
-				} else {
-					if ((error = xfs_bmbt_split(cur, level,
-							&nbno, &startoff, &ncur,
-							&i))) {
-						XFS_BMBT_TRACE_CURSOR(cur,
-							ERROR);
-						return error;
-					}
-					if (i) {
-						block = xfs_bmbt_get_block(
-							    cur, level, &bp);
-#ifdef DEBUG
-						if ((error =
-						    xfs_btree_check_lblock(cur,
-							    block, level, bp))) {
-							XFS_BMBT_TRACE_CURSOR(
-								cur, ERROR);
-							return error;
-						}
-#endif
-						ptr = cur->bc_ptrs[level];
-						xfs_bmbt_disk_set_allf(&nrec,
-							startoff, 0, 0,
-							XFS_EXT_NORM);
-					} else {
-						XFS_BMBT_TRACE_CURSOR(cur,
-							EXIT);
-						*stat = 0;
-						return 0;
-					}
-				}
-			}
-		}
-	}
-	numrecs = be16_to_cpu(block->bb_numrecs);
-	if (level > 0) {
-		kp = XFS_BMAP_KEY_IADDR(block, 1, cur);
-		pp = XFS_BMAP_PTR_IADDR(block, 1, cur);
-#ifdef DEBUG
-		for (i = numrecs; i >= ptr; i--) {
-			if ((error = xfs_btree_check_lptr_disk(cur, pp[i - 1],
-					level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-		}
-#endif
-		memmove(&kp[ptr], &kp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*kp));
-		memmove(&pp[ptr], &pp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*pp));
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lptr(cur, *bnop, level))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-#endif
-		kp[ptr - 1] = key;
-		pp[ptr - 1] = cpu_to_be64(*bnop);
-		numrecs++;
-		block->bb_numrecs = cpu_to_be16(numrecs);
-		xfs_bmbt_log_keys(cur, bp, ptr, numrecs);
-		xfs_bmbt_log_ptrs(cur, bp, ptr, numrecs);
-	} else {
-		rp = XFS_BMAP_REC_IADDR(block, 1, cur);
-		memmove(&rp[ptr], &rp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*rp));
-		rp[ptr - 1] = *recp;
-		numrecs++;
-		block->bb_numrecs = cpu_to_be16(numrecs);
-		xfs_bmbt_log_recs(cur, bp, ptr, numrecs);
-	}
-	xfs_bmbt_log_block(cur, bp, XFS_BB_NUMRECS);
-#ifdef DEBUG
-	if (ptr < numrecs) {
-		if (level == 0)
-			xfs_btree_check_rec(XFS_BTNUM_BMAP, rp + ptr - 1,
-				rp + ptr);
-		else
-			xfs_btree_check_key(XFS_BTNUM_BMAP, kp + ptr - 1,
-				kp + ptr);
-	}
-#endif
-	if (optr == 1 && (error = xfs_bmbt_updkey(cur, &key, level + 1))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	*bnop = nbno;
-	if (nbno != NULLFSBLOCK) {
-		*recp = nrec;
-		*curp = ncur;
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
-}
-
-STATIC int
-xfs_bmbt_killroot(
-	xfs_btree_cur_t		*cur)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_bmbt_block_t	*cblock;
-	xfs_buf_t		*cbp;
-	xfs_bmbt_key_t		*ckp;
-	xfs_bmbt_ptr_t		*cpp;
-#ifdef DEBUG
-	int			error;
-#endif
-	int			i;
-	xfs_bmbt_key_t		*kp;
-	xfs_inode_t		*ip;
-	xfs_ifork_t		*ifp;
-	int			level;
-	xfs_bmbt_ptr_t		*pp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	level = cur->bc_nlevels - 1;
-	ASSERT(level >= 1);
-	/*
-	 * Don't deal with the root block needs to be a leaf case.
-	 * We're just going to turn the thing back into extents anyway.
-	 */
-	if (level == 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		return 0;
-	}
-	block = xfs_bmbt_get_block(cur, level, &cbp);
-	/*
-	 * Give up if the root has multiple children.
-	 */
-	if (be16_to_cpu(block->bb_numrecs) != 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		return 0;
-	}
-	/*
-	 * Only do this if the next level will fit.
-	 * Then the data must be copied up to the inode,
-	 * instead of freeing the root you free the next level.
-	 */
-	cbp = cur->bc_bufs[level - 1];
-	cblock = XFS_BUF_TO_BMBT_BLOCK(cbp);
-	if (be16_to_cpu(cblock->bb_numrecs) > XFS_BMAP_BLOCK_DMAXRECS(level, cur)) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		return 0;
-	}
-	ASSERT(be64_to_cpu(cblock->bb_leftsib) == NULLDFSBNO);
-	ASSERT(be64_to_cpu(cblock->bb_rightsib) == NULLDFSBNO);
-	ip = cur->bc_private.b.ip;
-	ifp = XFS_IFORK_PTR(ip, cur->bc_private.b.whichfork);
-	ASSERT(XFS_BMAP_BLOCK_IMAXRECS(level, cur) ==
-	       XFS_BMAP_BROOT_MAXRECS(ifp->if_broot_bytes));
-	i = (int)(be16_to_cpu(cblock->bb_numrecs) - XFS_BMAP_BLOCK_IMAXRECS(level, cur));
-	if (i) {
-		xfs_iroot_realloc(ip, i, cur->bc_private.b.whichfork);
-		block = ifp->if_broot;
-	}
-	be16_add_cpu(&block->bb_numrecs, i);
-	ASSERT(block->bb_numrecs == cblock->bb_numrecs);
-	kp = XFS_BMAP_KEY_IADDR(block, 1, cur);
-	ckp = XFS_BMAP_KEY_IADDR(cblock, 1, cur);
-	memcpy(kp, ckp, be16_to_cpu(block->bb_numrecs) * sizeof(*kp));
-	pp = XFS_BMAP_PTR_IADDR(block, 1, cur);
-	cpp = XFS_BMAP_PTR_IADDR(cblock, 1, cur);
-#ifdef DEBUG
-	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
-		if ((error = xfs_btree_check_lptr_disk(cur, cpp[i], level - 1))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-	}
-#endif
-	memcpy(pp, cpp, be16_to_cpu(block->bb_numrecs) * sizeof(*pp));
-	xfs_bmap_add_free(XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(cbp)), 1,
-			cur->bc_private.b.flist, cur->bc_mp);
-	ip->i_d.di_nblocks--;
-	XFS_TRANS_MOD_DQUOT_BYINO(cur->bc_mp, cur->bc_tp, ip,
-			XFS_TRANS_DQ_BCOUNT, -1L);
-	xfs_trans_binval(cur->bc_tp, cbp);
-	cur->bc_bufs[level - 1] = NULL;
-	be16_add_cpu(&block->bb_level, -1);
-	xfs_trans_log_inode(cur->bc_tp, ip,
-		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	cur->bc_nlevels--;
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	return 0;
-}
-
-/*
- * Log key values from the btree block.
- */
-STATIC void
-xfs_bmbt_log_keys(
-	xfs_btree_cur_t	*cur,
-	xfs_buf_t	*bp,
-	int		kfirst,
-	int		klast)
-{
-	xfs_trans_t	*tp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBII(cur, bp, kfirst, klast);
-	tp = cur->bc_tp;
-	if (bp) {
-		xfs_bmbt_block_t	*block;
-		int			first;
-		xfs_bmbt_key_t		*kp;
-		int			last;
-
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
-		kp = XFS_BMAP_KEY_DADDR(block, 1, cur);
-		first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
-		last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
-		xfs_trans_log_buf(tp, bp, first, last);
-	} else {
-		xfs_inode_t		 *ip;
-
-		ip = cur->bc_private.b.ip;
-		xfs_trans_log_inode(tp, ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-}
-
-/*
- * Log pointer values from the btree block.
- */
-STATIC void
-xfs_bmbt_log_ptrs(
-	xfs_btree_cur_t	*cur,
-	xfs_buf_t	*bp,
-	int		pfirst,
-	int		plast)
-{
-	xfs_trans_t	*tp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBII(cur, bp, pfirst, plast);
-	tp = cur->bc_tp;
-	if (bp) {
-		xfs_bmbt_block_t	*block;
-		int			first;
-		int			last;
-		xfs_bmbt_ptr_t		*pp;
-
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
-		pp = XFS_BMAP_PTR_DADDR(block, 1, cur);
-		first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
-		last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
-		xfs_trans_log_buf(tp, bp, first, last);
-	} else {
-		xfs_inode_t		*ip;
-
-		ip = cur->bc_private.b.ip;
-		xfs_trans_log_inode(tp, ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-}
-
-/*
- * Lookup the record.  The cursor is made to point to it, based on dir.
- */
-STATIC int				/* error */
-xfs_bmbt_lookup(
-	xfs_btree_cur_t		*cur,
-	xfs_lookup_t		dir,
-	int			*stat)		/* success/failure */
-{
-	xfs_bmbt_block_t	*block=NULL;
-	xfs_buf_t		*bp;
-	xfs_daddr_t		d;
-	xfs_sfiloff_t		diff;
-	int			error;		/* error return value */
-	xfs_fsblock_t		fsbno=0;
-	int			high;
-	int			i;
-	int			keyno=0;
-	xfs_bmbt_key_t		*kkbase=NULL;
-	xfs_bmbt_key_t		*kkp;
-	xfs_bmbt_rec_t		*krbase=NULL;
-	xfs_bmbt_rec_t		*krp;
-	int			level;
-	int			low;
-	xfs_mount_t		*mp;
-	xfs_bmbt_ptr_t		*pp;
-	xfs_bmbt_irec_t		*rp;
-	xfs_fileoff_t		startoff;
-	xfs_trans_t		*tp;
-
-	XFS_STATS_INC(xs_bmbt_lookup);
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGI(cur, (int)dir);
-	tp = cur->bc_tp;
-	mp = cur->bc_mp;
-	rp = &cur->bc_rec.b;
-	for (level = cur->bc_nlevels - 1, diff = 1; level >= 0; level--) {
-		if (level < cur->bc_nlevels - 1) {
-			d = XFS_FSB_TO_DADDR(mp, fsbno);
-			bp = cur->bc_bufs[level];
-			if (bp && XFS_BUF_ADDR(bp) != d)
-				bp = NULL;
-			if (!bp) {
-				if ((error = xfs_btree_read_bufl(mp, tp, fsbno,
-						0, &bp, XFS_BMAP_BTREE_REF))) {
-					XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-					return error;
-				}
-				xfs_btree_setbuf(cur, level, bp);
-				block = XFS_BUF_TO_BMBT_BLOCK(bp);
-				if ((error = xfs_btree_check_lblock(cur, block,
-						level, bp))) {
-					XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-					return error;
-				}
-			} else
-				block = XFS_BUF_TO_BMBT_BLOCK(bp);
-		} else
-			block = xfs_bmbt_get_block(cur, level, &bp);
-		if (diff == 0)
-			keyno = 1;
-		else {
-			if (level > 0)
-				kkbase = XFS_BMAP_KEY_IADDR(block, 1, cur);
-			else
-				krbase = XFS_BMAP_REC_IADDR(block, 1, cur);
-			low = 1;
-			if (!(high = be16_to_cpu(block->bb_numrecs))) {
-				ASSERT(level == 0);
-				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
-				XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-				*stat = 0;
-				return 0;
-			}
-			while (low <= high) {
-				XFS_STATS_INC(xs_bmbt_compare);
-				keyno = (low + high) >> 1;
-				if (level > 0) {
-					kkp = kkbase + keyno - 1;
-					startoff = be64_to_cpu(kkp->br_startoff);
-				} else {
-					krp = krbase + keyno - 1;
-					startoff = xfs_bmbt_disk_get_startoff(krp);
-				}
-				diff = (xfs_sfiloff_t)
-						(startoff - rp->br_startoff);
-				if (diff < 0)
-					low = keyno + 1;
-				else if (diff > 0)
-					high = keyno - 1;
-				else
-					break;
-			}
-		}
-		if (level > 0) {
-			if (diff > 0 && --keyno < 1)
-				keyno = 1;
-			pp = XFS_BMAP_PTR_IADDR(block, keyno, cur);
-			fsbno = be64_to_cpu(*pp);
-#ifdef DEBUG
-			if ((error = xfs_btree_check_lptr(cur, fsbno, level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-#endif
-			cur->bc_ptrs[level] = keyno;
-		}
-	}
-	if (dir != XFS_LOOKUP_LE && diff < 0) {
-		keyno++;
-		/*
-		 * If ge search and we went off the end of the block, but it's
-		 * not the last block, we're in the wrong block.
-		 */
-		if (dir == XFS_LOOKUP_GE && keyno > be16_to_cpu(block->bb_numrecs) &&
-		    be64_to_cpu(block->bb_rightsib) != NULLDFSBNO) {
-			cur->bc_ptrs[0] = keyno;
-			if ((error = xfs_bmbt_increment(cur, 0, &i))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-			XFS_WANT_CORRUPTED_RETURN(i == 1);
-			XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-			*stat = 1;
-			return 0;
-		}
-	}
-	else if (dir == XFS_LOOKUP_LE && diff > 0)
-		keyno--;
-	cur->bc_ptrs[0] = keyno;
-	if (keyno == 0 || keyno > be16_to_cpu(block->bb_numrecs)) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-	} else {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = ((dir != XFS_LOOKUP_EQ) || (diff == 0));
-	}
-	return 0;
-}
-
-/*
- * Move 1 record left from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int					/* error */
-xfs_bmbt_lshift(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	int			*stat)		/* success/failure */
-{
-	int			error;		/* error return value */
-#ifdef DEBUG
-	int			i;		/* loop counter */
-#endif
-	xfs_bmbt_key_t		key;		/* bmap btree key */
-	xfs_buf_t		*lbp;		/* left buffer pointer */
-	xfs_bmbt_block_t	*left;		/* left btree block */
-	xfs_bmbt_key_t		*lkp=NULL;	/* left btree key */
-	xfs_bmbt_ptr_t		*lpp;		/* left address pointer */
-	int			lrecs;		/* left record count */
-	xfs_bmbt_rec_t		*lrp=NULL;	/* left record pointer */
-	xfs_mount_t		*mp;		/* file system mount point */
-	xfs_buf_t		*rbp;		/* right buffer pointer */
-	xfs_bmbt_block_t	*right;		/* right btree block */
-	xfs_bmbt_key_t		*rkp=NULL;	/* right btree key */
-	xfs_bmbt_ptr_t		*rpp=NULL;	/* right address pointer */
-	xfs_bmbt_rec_t		*rrp=NULL;	/* right record pointer */
-	int			rrecs;		/* right record count */
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGI(cur, level);
-	if (level == cur->bc_nlevels - 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	rbp = cur->bc_bufs[level];
-	right = XFS_BUF_TO_BMBT_BLOCK(rbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, right, level, rbp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	if (be64_to_cpu(right->bb_leftsib) == NULLDFSBNO) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	if (cur->bc_ptrs[level] <= 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	mp = cur->bc_mp;
-	if ((error = xfs_btree_read_bufl(mp, cur->bc_tp, be64_to_cpu(right->bb_leftsib), 0,
-			&lbp, XFS_BMAP_BTREE_REF))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
-	if ((error = xfs_btree_check_lblock(cur, left, level, lbp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	if (be16_to_cpu(left->bb_numrecs) == XFS_BMAP_BLOCK_IMAXRECS(level, cur)) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	lrecs = be16_to_cpu(left->bb_numrecs) + 1;
-	if (level > 0) {
-		lkp = XFS_BMAP_KEY_IADDR(left, lrecs, cur);
-		rkp = XFS_BMAP_KEY_IADDR(right, 1, cur);
-		*lkp = *rkp;
-		xfs_bmbt_log_keys(cur, lbp, lrecs, lrecs);
-		lpp = XFS_BMAP_PTR_IADDR(left, lrecs, cur);
-		rpp = XFS_BMAP_PTR_IADDR(right, 1, cur);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lptr_disk(cur, *rpp, level))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-#endif
-		*lpp = *rpp;
-		xfs_bmbt_log_ptrs(cur, lbp, lrecs, lrecs);
-	} else {
-		lrp = XFS_BMAP_REC_IADDR(left, lrecs, cur);
-		rrp = XFS_BMAP_REC_IADDR(right, 1, cur);
-		*lrp = *rrp;
-		xfs_bmbt_log_recs(cur, lbp, lrecs, lrecs);
-	}
-	left->bb_numrecs = cpu_to_be16(lrecs);
-	xfs_bmbt_log_block(cur, lbp, XFS_BB_NUMRECS);
-#ifdef DEBUG
-	if (level > 0)
-		xfs_btree_check_key(XFS_BTNUM_BMAP, lkp - 1, lkp);
-	else
-		xfs_btree_check_rec(XFS_BTNUM_BMAP, lrp - 1, lrp);
-#endif
-	rrecs = be16_to_cpu(right->bb_numrecs) - 1;
-	right->bb_numrecs = cpu_to_be16(rrecs);
-	xfs_bmbt_log_block(cur, rbp, XFS_BB_NUMRECS);
-	if (level > 0) {
-#ifdef DEBUG
-		for (i = 0; i < rrecs; i++) {
-			if ((error = xfs_btree_check_lptr_disk(cur, rpp[i + 1],
-					level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-		}
-#endif
-		memmove(rkp, rkp + 1, rrecs * sizeof(*rkp));
-		memmove(rpp, rpp + 1, rrecs * sizeof(*rpp));
-		xfs_bmbt_log_keys(cur, rbp, 1, rrecs);
-		xfs_bmbt_log_ptrs(cur, rbp, 1, rrecs);
-	} else {
-		memmove(rrp, rrp + 1, rrecs * sizeof(*rrp));
-		xfs_bmbt_log_recs(cur, rbp, 1, rrecs);
-		key.br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(rrp));
-		rkp = &key;
-	}
-	if ((error = xfs_bmbt_updkey(cur, rkp, level + 1))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	cur->bc_ptrs[level]--;
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
-}
-
-/*
- * Move 1 record right from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int					/* error */
-xfs_bmbt_rshift(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	int			*stat)		/* success/failure */
-{
-	int			error;		/* error return value */
-	int			i;		/* loop counter */
-	xfs_bmbt_key_t		key;		/* bmap btree key */
-	xfs_buf_t		*lbp;		/* left buffer pointer */
-	xfs_bmbt_block_t	*left;		/* left btree block */
-	xfs_bmbt_key_t		*lkp;		/* left btree key */
-	xfs_bmbt_ptr_t		*lpp;		/* left address pointer */
-	xfs_bmbt_rec_t		*lrp;		/* left record pointer */
-	xfs_mount_t		*mp;		/* file system mount point */
-	xfs_buf_t		*rbp;		/* right buffer pointer */
-	xfs_bmbt_block_t	*right;		/* right btree block */
-	xfs_bmbt_key_t		*rkp;		/* right btree key */
-	xfs_bmbt_ptr_t		*rpp;		/* right address pointer */
-	xfs_bmbt_rec_t		*rrp=NULL;	/* right record pointer */
-	struct xfs_btree_cur	*tcur;		/* temporary btree cursor */
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGI(cur, level);
-	if (level == cur->bc_nlevels - 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	lbp = cur->bc_bufs[level];
-	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, left, level, lbp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	if (be64_to_cpu(left->bb_rightsib) == NULLDFSBNO) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	if (cur->bc_ptrs[level] >= be16_to_cpu(left->bb_numrecs)) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	mp = cur->bc_mp;
-	if ((error = xfs_btree_read_bufl(mp, cur->bc_tp, be64_to_cpu(left->bb_rightsib), 0,
-			&rbp, XFS_BMAP_BTREE_REF))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	right = XFS_BUF_TO_BMBT_BLOCK(rbp);
-	if ((error = xfs_btree_check_lblock(cur, right, level, rbp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	if (be16_to_cpu(right->bb_numrecs) == XFS_BMAP_BLOCK_IMAXRECS(level, cur)) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	if (level > 0) {
-		lkp = XFS_BMAP_KEY_IADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		lpp = XFS_BMAP_PTR_IADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rkp = XFS_BMAP_KEY_IADDR(right, 1, cur);
-		rpp = XFS_BMAP_PTR_IADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = be16_to_cpu(right->bb_numrecs) - 1; i >= 0; i--) {
-			if ((error = xfs_btree_check_lptr_disk(cur, rpp[i], level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-		}
-#endif
-		memmove(rkp + 1, rkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memmove(rpp + 1, rpp, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lptr_disk(cur, *lpp, level))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-#endif
-		*rkp = *lkp;
-		*rpp = *lpp;
-		xfs_bmbt_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		xfs_bmbt_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-	} else {
-		lrp = XFS_BMAP_REC_IADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rrp = XFS_BMAP_REC_IADDR(right, 1, cur);
-		memmove(rrp + 1, rrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		*rrp = *lrp;
-		xfs_bmbt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		key.br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(rrp));
-		rkp = &key;
-	}
-	be16_add_cpu(&left->bb_numrecs, -1);
-	xfs_bmbt_log_block(cur, lbp, XFS_BB_NUMRECS);
-	be16_add_cpu(&right->bb_numrecs, 1);
-#ifdef DEBUG
-	if (level > 0)
-		xfs_btree_check_key(XFS_BTNUM_BMAP, rkp, rkp + 1);
-	else
-		xfs_btree_check_rec(XFS_BTNUM_BMAP, rrp, rrp + 1);
-#endif
-	xfs_bmbt_log_block(cur, rbp, XFS_BB_NUMRECS);
-	if ((error = xfs_btree_dup_cursor(cur, &tcur))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	i = xfs_btree_lastrec(tcur, level);
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-	if ((error = xfs_bmbt_increment(tcur, level, &i))) {
-		XFS_BMBT_TRACE_CURSOR(tcur, ERROR);
-		goto error1;
-	}
-	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-	if ((error = xfs_bmbt_updkey(tcur, rkp, level + 1))) {
-		XFS_BMBT_TRACE_CURSOR(tcur, ERROR);
-		goto error1;
-	}
-	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
-error0:
-	XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-error1:
-	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-	return error;
-}
 
 /*
  * Determine the extent state.
@@ -1191,221 +34,6 @@ xfs_extent_state(
 	return XFS_EXT_NORM;
 }
 
-
-/*
- * Split cur/level block in half.
- * Return new block number and its first record (to be inserted into parent).
- */
-STATIC int					/* error */
-xfs_bmbt_split(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	xfs_fsblock_t		*bnop,
-	__uint64_t		*startoff,
-	xfs_btree_cur_t		**curp,
-	int			*stat)		/* success/failure */
-{
-	xfs_alloc_arg_t		args;		/* block allocation args */
-	int			error;		/* error return value */
-	int			i;		/* loop counter */
-	xfs_fsblock_t		lbno;		/* left sibling block number */
-	xfs_buf_t		*lbp;		/* left buffer pointer */
-	xfs_bmbt_block_t	*left;		/* left btree block */
-	xfs_bmbt_key_t		*lkp;		/* left btree key */
-	xfs_bmbt_ptr_t		*lpp;		/* left address pointer */
-	xfs_bmbt_rec_t		*lrp;		/* left record pointer */
-	xfs_buf_t		*rbp;		/* right buffer pointer */
-	xfs_bmbt_block_t	*right;		/* right btree block */
-	xfs_bmbt_key_t		*rkp;		/* right btree key */
-	xfs_bmbt_ptr_t		*rpp;		/* right address pointer */
-	xfs_bmbt_block_t	*rrblock;	/* right-right btree block */
-	xfs_buf_t		*rrbp;		/* right-right buffer pointer */
-	xfs_bmbt_rec_t		*rrp;		/* right record pointer */
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGIFK(cur, level, *bnop, *startoff);
-	args.tp = cur->bc_tp;
-	args.mp = cur->bc_mp;
-	lbp = cur->bc_bufs[level];
-	lbno = XFS_DADDR_TO_FSB(args.mp, XFS_BUF_ADDR(lbp));
-	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
-	args.fsbno = cur->bc_private.b.firstblock;
-	args.firstblock = args.fsbno;
-	args.minleft = 0;
-	if (args.fsbno == NULLFSBLOCK) {
-		args.fsbno = lbno;
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		/*
-		 * Make sure there is sufficient room left in the AG to
-		 * complete a full tree split for an extent insert.  If
-		 * we are converting the middle part of an extent then
-		 * we may need space for two tree splits.
-		 *
-		 * We are relying on the caller to make the correct block
-		 * reservation for this operation to succeed.  If the
-		 * reservation amount is insufficient then we may fail a
-		 * block allocation here and corrupt the filesystem.
-		 */
-		args.minleft = xfs_trans_get_block_res(args.tp);
-	} else if (cur->bc_private.b.flist->xbf_low)
-		args.type = XFS_ALLOCTYPE_START_BNO;
-	else
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	args.mod = args.alignment = args.total = args.isfl =
-		args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
-	if (!args.wasdel && xfs_trans_get_block_res(args.tp) == 0) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return XFS_ERROR(ENOSPC);
-	}
-	if ((error = xfs_alloc_vextent(&args))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	if (args.fsbno == NULLFSBLOCK && args.minleft) {
-		/*
-		 * Could not find an AG with enough free space to satisfy
-		 * a full btree split.  Try again without minleft and if
-		 * successful activate the lowspace algorithm.
-		 */
-		args.fsbno = 0;
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
-		args.minleft = 0;
-		if ((error = xfs_alloc_vextent(&args))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		cur->bc_private.b.flist->xbf_low = 1;
-	}
-	if (args.fsbno == NULLFSBLOCK) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	ASSERT(args.len == 1);
-	cur->bc_private.b.firstblock = args.fsbno;
-	cur->bc_private.b.allocated++;
-	cur->bc_private.b.ip->i_d.di_nblocks++;
-	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
-	XFS_TRANS_MOD_DQUOT_BYINO(args.mp, args.tp, cur->bc_private.b.ip,
-			XFS_TRANS_DQ_BCOUNT, 1L);
-	rbp = xfs_btree_get_bufl(args.mp, args.tp, args.fsbno, 0);
-	right = XFS_BUF_TO_BMBT_BLOCK(rbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, left, level, rbp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	right->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
-	right->bb_level = left->bb_level;
-	right->bb_numrecs = cpu_to_be16(be16_to_cpu(left->bb_numrecs) / 2);
-	if ((be16_to_cpu(left->bb_numrecs) & 1) &&
-	    cur->bc_ptrs[level] <= be16_to_cpu(right->bb_numrecs) + 1)
-		be16_add_cpu(&right->bb_numrecs, 1);
-	i = be16_to_cpu(left->bb_numrecs) - be16_to_cpu(right->bb_numrecs) + 1;
-	if (level > 0) {
-		lkp = XFS_BMAP_KEY_IADDR(left, i, cur);
-		lpp = XFS_BMAP_PTR_IADDR(left, i, cur);
-		rkp = XFS_BMAP_KEY_IADDR(right, 1, cur);
-		rpp = XFS_BMAP_PTR_IADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
-			if ((error = xfs_btree_check_lptr_disk(cur, lpp[i], level))) {
-				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-				return error;
-			}
-		}
-#endif
-		memcpy(rkp, lkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memcpy(rpp, lpp, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-		xfs_bmbt_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		xfs_bmbt_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		*startoff = be64_to_cpu(rkp->br_startoff);
-	} else {
-		lrp = XFS_BMAP_REC_IADDR(left, i, cur);
-		rrp = XFS_BMAP_REC_IADDR(right, 1, cur);
-		memcpy(rrp, lrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		xfs_bmbt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		*startoff = xfs_bmbt_disk_get_startoff(rrp);
-	}
-	be16_add_cpu(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
-	right->bb_rightsib = left->bb_rightsib;
-	left->bb_rightsib = cpu_to_be64(args.fsbno);
-	right->bb_leftsib = cpu_to_be64(lbno);
-	xfs_bmbt_log_block(cur, rbp, XFS_BB_ALL_BITS);
-	xfs_bmbt_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
-	if (be64_to_cpu(right->bb_rightsib) != NULLDFSBNO) {
-		if ((error = xfs_btree_read_bufl(args.mp, args.tp,
-				be64_to_cpu(right->bb_rightsib), 0, &rrbp,
-				XFS_BMAP_BTREE_REF))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		rrblock = XFS_BUF_TO_BMBT_BLOCK(rrbp);
-		if ((error = xfs_btree_check_lblock(cur, rrblock, level, rrbp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		rrblock->bb_leftsib = cpu_to_be64(args.fsbno);
-		xfs_bmbt_log_block(cur, rrbp, XFS_BB_LEFTSIB);
-	}
-	if (cur->bc_ptrs[level] > be16_to_cpu(left->bb_numrecs) + 1) {
-		xfs_btree_setbuf(cur, level, rbp);
-		cur->bc_ptrs[level] -= be16_to_cpu(left->bb_numrecs);
-	}
-	if (level + 1 < cur->bc_nlevels) {
-		if ((error = xfs_btree_dup_cursor(cur, curp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		(*curp)->bc_ptrs[level + 1]++;
-	}
-	*bnop = args.fsbno;
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
-}
-
-
-/*
- * Update keys for the record.
- */
-STATIC int
-xfs_bmbt_updkey(
-	xfs_btree_cur_t		*cur,
-	xfs_bmbt_key_t		*keyp,	/* on-disk format */
-	int			level)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_buf_t		*bp;
-#ifdef DEBUG
-	int			error;
-#endif
-	xfs_bmbt_key_t		*kp;
-	int			ptr;
-
-	ASSERT(level >= 1);
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGIK(cur, level, keyp);
-	for (ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
-		block = xfs_bmbt_get_block(cur, level, &bp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lblock(cur, block, level, bp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-#endif
-		ptr = cur->bc_ptrs[level];
-		kp = XFS_BMAP_KEY_IADDR(block, ptr, cur);
-		*kp = *keyp;
-		xfs_bmbt_log_keys(cur, bp, ptr, ptr);
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	return 0;
-}
-
 /*
  * Convert on-disk form of btree root to in-memory form.
  */
@@ -1439,116 +67,6 @@ xfs_bmdr_to_bmbt(
 }
 
 /*
- * Decrement cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int						/* error */
-xfs_bmbt_decrement(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	int			*stat)		/* success/failure */
-{
-	xfs_bmbt_block_t	*block;
-	xfs_buf_t		*bp;
-	int			error;		/* error return value */
-	xfs_fsblock_t		fsbno;
-	int			lev;
-	xfs_mount_t		*mp;
-	xfs_trans_t		*tp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGI(cur, level);
-	ASSERT(level < cur->bc_nlevels);
-	if (level < cur->bc_nlevels - 1)
-		xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
-	if (--cur->bc_ptrs[level] > 0) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 1;
-		return 0;
-	}
-	block = xfs_bmbt_get_block(cur, level, &bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, block, level, bp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	if (be64_to_cpu(block->bb_leftsib) == NULLDFSBNO) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		if (--cur->bc_ptrs[lev] > 0)
-			break;
-		if (lev < cur->bc_nlevels - 1)
-			xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
-	}
-	if (lev == cur->bc_nlevels) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	tp = cur->bc_tp;
-	mp = cur->bc_mp;
-	for (block = xfs_bmbt_get_block(cur, lev, &bp); lev > level; ) {
-		fsbno = be64_to_cpu(*XFS_BMAP_PTR_IADDR(block, cur->bc_ptrs[lev], cur));
-		if ((error = xfs_btree_read_bufl(mp, tp, fsbno, 0, &bp,
-				XFS_BMAP_BTREE_REF))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		lev--;
-		xfs_btree_setbuf(cur, lev, bp);
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
-		if ((error = xfs_btree_check_lblock(cur, block, lev, bp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		cur->bc_ptrs[lev] = be16_to_cpu(block->bb_numrecs);
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
-}
-
-/*
- * Delete the record pointed to by cur.
- */
-int					/* error */
-xfs_bmbt_delete(
-	xfs_btree_cur_t	*cur,
-	int		*stat)		/* success/failure */
-{
-	int		error;		/* error return value */
-	int		i;
-	int		level;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	for (level = 0, i = 2; i == 2; level++) {
-		if ((error = xfs_bmbt_delrec(cur, level, &i))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-	}
-	if (i == 0) {
-		for (level = 1; level < cur->bc_nlevels; level++) {
-			if (cur->bc_ptrs[level] == 0) {
-				if ((error = xfs_bmbt_decrement(cur, level,
-						&i))) {
-					XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-					return error;
-				}
-				break;
-			}
-		}
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = i;
-	return 0;
-}
-
-/*
  * Convert a compressed bmap extent record to an uncompressed form.
  * This code must be in sync with the routines xfs_bmbt_get_startoff,
  * xfs_bmbt_get_startblock, xfs_bmbt_get_blockcount and xfs_bmbt_get_state.
@@ -1595,35 +113,10 @@ __xfs_bmbt_get_all(
 
 void
 xfs_bmbt_get_all(
-	xfs_bmbt_rec_host_t *r,
-	xfs_bmbt_irec_t *s)
-{
-	__xfs_bmbt_get_all(r->l0, r->l1, s);
-}
-
-/*
- * Get the block pointer for the given level of the cursor.
- * Fill in the buffer pointer, if applicable.
- */
-xfs_bmbt_block_t *
-xfs_bmbt_get_block(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	xfs_buf_t		**bpp)
-{
-	xfs_ifork_t		*ifp;
-	xfs_bmbt_block_t	*rval;
-
-	if (level < cur->bc_nlevels - 1) {
-		*bpp = cur->bc_bufs[level];
-		rval = XFS_BUF_TO_BMBT_BLOCK(*bpp);
-	} else {
-		*bpp = NULL;
-		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
-			cur->bc_private.b.whichfork);
-		rval = ifp->if_broot;
-	}
-	return rval;
+	xfs_bmbt_rec_host_t *r,
+	xfs_bmbt_irec_t *s)
+{
+	__xfs_bmbt_get_all(r->l0, r->l1, s);
 }
 
 /*
@@ -1712,348 +205,6 @@ xfs_bmbt_disk_get_startoff(
 		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 }
 
-/*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int						/* error */
-xfs_bmbt_increment(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	int			*stat)		/* success/failure */
-{
-	xfs_bmbt_block_t	*block;
-	xfs_buf_t		*bp;
-	int			error;		/* error return value */
-	xfs_fsblock_t		fsbno;
-	int			lev;
-	xfs_mount_t		*mp;
-	xfs_trans_t		*tp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGI(cur, level);
-	ASSERT(level < cur->bc_nlevels);
-	if (level < cur->bc_nlevels - 1)
-		xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
-	block = xfs_bmbt_get_block(cur, level, &bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, block, level, bp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	if (++cur->bc_ptrs[level] <= be16_to_cpu(block->bb_numrecs)) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 1;
-		return 0;
-	}
-	if (be64_to_cpu(block->bb_rightsib) == NULLDFSBNO) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		block = xfs_bmbt_get_block(cur, lev, &bp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lblock(cur, block, lev, bp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-#endif
-		if (++cur->bc_ptrs[lev] <= be16_to_cpu(block->bb_numrecs))
-			break;
-		if (lev < cur->bc_nlevels - 1)
-			xfs_btree_readahead(cur, lev, XFS_BTCUR_RIGHTRA);
-	}
-	if (lev == cur->bc_nlevels) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	tp = cur->bc_tp;
-	mp = cur->bc_mp;
-	for (block = xfs_bmbt_get_block(cur, lev, &bp); lev > level; ) {
-		fsbno = be64_to_cpu(*XFS_BMAP_PTR_IADDR(block, cur->bc_ptrs[lev], cur));
-		if ((error = xfs_btree_read_bufl(mp, tp, fsbno, 0, &bp,
-				XFS_BMAP_BTREE_REF))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		lev--;
-		xfs_btree_setbuf(cur, lev, bp);
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
-		if ((error = xfs_btree_check_lblock(cur, block, lev, bp))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		cur->bc_ptrs[lev] = 1;
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
-}
-
-/*
- * Insert the current record at the point referenced by cur.
- *
- * A multi-level split of the tree on insert will invalidate the original
- * cursor.  All callers of this function should assume that the cursor is
- * no longer valid and revalidate it.
- */
-int					/* error */
-xfs_bmbt_insert(
-	xfs_btree_cur_t	*cur,
-	int		*stat)		/* success/failure */
-{
-	int		error;		/* error return value */
-	int		i;
-	int		level;
-	xfs_fsblock_t	nbno;
-	xfs_btree_cur_t	*ncur;
-	xfs_bmbt_rec_t	nrec;
-	xfs_btree_cur_t	*pcur;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	level = 0;
-	nbno = NULLFSBLOCK;
-	xfs_bmbt_disk_set_all(&nrec, &cur->bc_rec.b);
-	ncur = NULL;
-	pcur = cur;
-	do {
-		if ((error = xfs_bmbt_insrec(pcur, level++, &nbno, &nrec, &ncur,
-				&i))) {
-			if (pcur != cur)
-				xfs_btree_del_cursor(pcur, XFS_BTREE_ERROR);
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if (pcur != cur && (ncur || nbno == NULLFSBLOCK)) {
-			cur->bc_nlevels = pcur->bc_nlevels;
-			cur->bc_private.b.allocated +=
-				pcur->bc_private.b.allocated;
-			pcur->bc_private.b.allocated = 0;
-			ASSERT((cur->bc_private.b.firstblock != NULLFSBLOCK) ||
-			       XFS_IS_REALTIME_INODE(cur->bc_private.b.ip));
-			cur->bc_private.b.firstblock =
-				pcur->bc_private.b.firstblock;
-			ASSERT(cur->bc_private.b.flist ==
-			       pcur->bc_private.b.flist);
-			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
-		}
-		if (ncur) {
-			pcur = ncur;
-			ncur = NULL;
-		}
-	} while (nbno != NULLFSBLOCK);
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = i;
-	return 0;
-error0:
-	XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-	return error;
-}
-
-/*
- * Log fields from the btree block header.
- */
-void
-xfs_bmbt_log_block(
-	xfs_btree_cur_t		*cur,
-	xfs_buf_t		*bp,
-	int			fields)
-{
-	int			first;
-	int			last;
-	xfs_trans_t		*tp;
-	static const short	offsets[] = {
-		offsetof(xfs_bmbt_block_t, bb_magic),
-		offsetof(xfs_bmbt_block_t, bb_level),
-		offsetof(xfs_bmbt_block_t, bb_numrecs),
-		offsetof(xfs_bmbt_block_t, bb_leftsib),
-		offsetof(xfs_bmbt_block_t, bb_rightsib),
-		sizeof(xfs_bmbt_block_t)
-	};
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBI(cur, bp, fields);
-	tp = cur->bc_tp;
-	if (bp) {
-		xfs_btree_offsets(fields, offsets, XFS_BB_NUM_BITS, &first,
-				  &last);
-		xfs_trans_log_buf(tp, bp, first, last);
-	} else
-		xfs_trans_log_inode(tp, cur->bc_private.b.ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-}
-
-/*
- * Log record values from the btree block.
- */
-void
-xfs_bmbt_log_recs(
-	xfs_btree_cur_t		*cur,
-	xfs_buf_t		*bp,
-	int			rfirst,
-	int			rlast)
-{
-	xfs_bmbt_block_t	*block;
-	int			first;
-	int			last;
-	xfs_bmbt_rec_t		*rp;
-	xfs_trans_t		*tp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBII(cur, bp, rfirst, rlast);
-	ASSERT(bp);
-	tp = cur->bc_tp;
-	block = XFS_BUF_TO_BMBT_BLOCK(bp);
-	rp = XFS_BMAP_REC_DADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(tp, bp, first, last);
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-}
-
-int					/* error */
-xfs_bmbt_lookup_eq(
-	xfs_btree_cur_t	*cur,
-	xfs_fileoff_t	off,
-	xfs_fsblock_t	bno,
-	xfs_filblks_t	len,
-	int		*stat)		/* success/failure */
-{
-	cur->bc_rec.b.br_startoff = off;
-	cur->bc_rec.b.br_startblock = bno;
-	cur->bc_rec.b.br_blockcount = len;
-	return xfs_bmbt_lookup(cur, XFS_LOOKUP_EQ, stat);
-}
-
-int					/* error */
-xfs_bmbt_lookup_ge(
-	xfs_btree_cur_t	*cur,
-	xfs_fileoff_t	off,
-	xfs_fsblock_t	bno,
-	xfs_filblks_t	len,
-	int		*stat)		/* success/failure */
-{
-	cur->bc_rec.b.br_startoff = off;
-	cur->bc_rec.b.br_startblock = bno;
-	cur->bc_rec.b.br_blockcount = len;
-	return xfs_bmbt_lookup(cur, XFS_LOOKUP_GE, stat);
-}
-
-/*
- * Give the bmap btree a new root block.  Copy the old broot contents
- * down into a real block and make the broot point to it.
- */
-int						/* error */
-xfs_bmbt_newroot(
-	xfs_btree_cur_t		*cur,		/* btree cursor */
-	int			*logflags,	/* logging flags for inode */
-	int			*stat)		/* return status - 0 fail */
-{
-	xfs_alloc_arg_t		args;		/* allocation arguments */
-	xfs_bmbt_block_t	*block;		/* bmap btree block */
-	xfs_buf_t		*bp;		/* buffer for block */
-	xfs_bmbt_block_t	*cblock;	/* child btree block */
-	xfs_bmbt_key_t		*ckp;		/* child key pointer */
-	xfs_bmbt_ptr_t		*cpp;		/* child ptr pointer */
-	int			error;		/* error return code */
-#ifdef DEBUG
-	int			i;		/* loop counter */
-#endif
-	xfs_bmbt_key_t		*kp;		/* pointer to bmap btree key */
-	int			level;		/* btree level */
-	xfs_bmbt_ptr_t		*pp;		/* pointer to bmap block addr */
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	level = cur->bc_nlevels - 1;
-	block = xfs_bmbt_get_block(cur, level, &bp);
-	/*
-	 * Copy the root into a real block.
-	 */
-	args.mp = cur->bc_mp;
-	pp = XFS_BMAP_PTR_IADDR(block, 1, cur);
-	args.tp = cur->bc_tp;
-	args.fsbno = cur->bc_private.b.firstblock;
-	args.mod = args.minleft = args.alignment = args.total = args.isfl =
-		args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
-	args.firstblock = args.fsbno;
-	if (args.fsbno == NULLFSBLOCK) {
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lptr_disk(cur, *pp, level))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-#endif
-		args.fsbno = be64_to_cpu(*pp);
-		args.type = XFS_ALLOCTYPE_START_BNO;
-	} else if (cur->bc_private.b.flist->xbf_low)
-		args.type = XFS_ALLOCTYPE_START_BNO;
-	else
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	if ((error = xfs_alloc_vextent(&args))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	if (args.fsbno == NULLFSBLOCK) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	ASSERT(args.len == 1);
-	cur->bc_private.b.firstblock = args.fsbno;
-	cur->bc_private.b.allocated++;
-	cur->bc_private.b.ip->i_d.di_nblocks++;
-	XFS_TRANS_MOD_DQUOT_BYINO(args.mp, args.tp, cur->bc_private.b.ip,
-			  XFS_TRANS_DQ_BCOUNT, 1L);
-	bp = xfs_btree_get_bufl(args.mp, cur->bc_tp, args.fsbno, 0);
-	cblock = XFS_BUF_TO_BMBT_BLOCK(bp);
-	*cblock = *block;
-	be16_add_cpu(&block->bb_level, 1);
-	block->bb_numrecs = cpu_to_be16(1);
-	cur->bc_nlevels++;
-	cur->bc_ptrs[level + 1] = 1;
-	kp = XFS_BMAP_KEY_IADDR(block, 1, cur);
-	ckp = XFS_BMAP_KEY_IADDR(cblock, 1, cur);
-	memcpy(ckp, kp, be16_to_cpu(cblock->bb_numrecs) * sizeof(*kp));
-	cpp = XFS_BMAP_PTR_IADDR(cblock, 1, cur);
-#ifdef DEBUG
-	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
-		if ((error = xfs_btree_check_lptr_disk(cur, pp[i], level))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-	}
-#endif
-	memcpy(cpp, pp, be16_to_cpu(cblock->bb_numrecs) * sizeof(*pp));
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lptr(cur, args.fsbno, level))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	*pp = cpu_to_be64(args.fsbno);
-	xfs_iroot_realloc(cur->bc_private.b.ip, 1 - be16_to_cpu(cblock->bb_numrecs),
-		cur->bc_private.b.whichfork);
-	xfs_btree_setbuf(cur, level, bp);
-	/*
-	 * Do all this logging at the end so that
-	 * the root is at the right level.
-	 */
-	xfs_bmbt_log_block(cur, bp, XFS_BB_ALL_BITS);
-	xfs_bmbt_log_keys(cur, bp, 1, be16_to_cpu(cblock->bb_numrecs));
-	xfs_bmbt_log_ptrs(cur, bp, 1, be16_to_cpu(cblock->bb_numrecs));
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*logflags |=
-		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork);
-	*stat = 1;
-	return 0;
-}
 
 /*
  * Set all the fields in a bmap extent record from the arguments.
@@ -2278,51 +429,6 @@ xfs_bmbt_to_bmdr(
 }
 
 /*
- * Update the record to the passed values.
- */
-int
-xfs_bmbt_update(
-	xfs_btree_cur_t		*cur,
-	xfs_fileoff_t		off,
-	xfs_fsblock_t		bno,
-	xfs_filblks_t		len,
-	xfs_exntst_t		state)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_buf_t		*bp;
-	int			error;
-	xfs_bmbt_key_t		key;
-	int			ptr;
-	xfs_bmbt_rec_t		*rp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGFFFI(cur, (xfs_dfiloff_t)off, (xfs_dfsbno_t)bno,
-		(xfs_dfilblks_t)len, (int)state);
-	block = xfs_bmbt_get_block(cur, 0, &bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, block, 0, bp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	ptr = cur->bc_ptrs[0];
-	rp = XFS_BMAP_REC_IADDR(block, ptr, cur);
-	xfs_bmbt_disk_set_allf(rp, off, bno, len, state);
-	xfs_bmbt_log_recs(cur, bp, ptr, ptr);
-	if (ptr > 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		return 0;
-	}
-	key.br_startoff = cpu_to_be64(off);
-	if ((error = xfs_bmbt_updkey(cur, &key, 1))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	return 0;
-}
-
-/*
  * Check extent records, which have just been read, for
  * any bit in the extent flag field. ASSERT on debug
  * kernels, as this condition should not occur.
@@ -2346,3 +452,395 @@ xfs_check_nostate_extents(
 	}
 	return 0;
 }
+
+
+STATIC struct xfs_btree_cur *
+xfs_bmbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_btree_cur	*new;
+
+	new = xfs_bmbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.b.ip, cur->bc_private.b.whichfork);
+
+	/*
+	 * Copy the firstblock, flist, and flags values,
+	 * since init cursor doesn't get them.
+	 */
+	new->bc_private.b.firstblock = cur->bc_private.b.firstblock;
+	new->bc_private.b.flist = cur->bc_private.b.flist;
+	new->bc_private.b.flags = cur->bc_private.b.flags;
+
+	return new;
+}
+
+STATIC void
+xfs_bmbt_update_cursor(
+	struct xfs_btree_cur	*src,
+	struct xfs_btree_cur	*dst)
+{
+	ASSERT((dst->bc_private.b.firstblock != NULLFSBLOCK) ||
+	       (dst->bc_private.b.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
+	ASSERT(dst->bc_private.b.flist == src->bc_private.b.flist);
+
+	dst->bc_private.b.allocated += src->bc_private.b.allocated;
+	dst->bc_private.b.firstblock = src->bc_private.b.firstblock;
+
+	src->bc_private.b.allocated = 0;
+}
+
+STATIC int
+xfs_bmbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			length,
+	int			*stat)
+{
+	xfs_alloc_arg_t		args;		/* block allocation args */
+	int			error;		/* error return value */
+
+	memset(&args, 0, sizeof(args));
+	args.tp = cur->bc_tp;
+	args.mp = cur->bc_mp;
+	args.fsbno = cur->bc_private.b.firstblock;
+	args.firstblock = args.fsbno;
+
+	if (args.fsbno == NULLFSBLOCK) {
+		args.fsbno = be64_to_cpu(start->l);
+		args.type = XFS_ALLOCTYPE_START_BNO;
+		/*
+		 * Make sure there is sufficient room left in the AG to
+		 * complete a full tree split for an extent insert.  If
+		 * we are converting the middle part of an extent then
+		 * we may need space for two tree splits.
+		 *
+		 * We are relying on the caller to make the correct block
+		 * reservation for this operation to succeed.  If the
+		 * reservation amount is insufficient then we may fail a
+		 * block allocation here and corrupt the filesystem.
+		 */
+		args.minleft = xfs_trans_get_block_res(args.tp);
+	} else if (cur->bc_private.b.flist->xbf_low) {
+		args.type = XFS_ALLOCTYPE_START_BNO;
+	} else {
+		args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	}
+
+	args.minlen = args.maxlen = args.prod = 1;
+	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
+	if (!args.wasdel && xfs_trans_get_block_res(args.tp) == 0) {
+		error = XFS_ERROR(ENOSPC);
+		goto error0;
+	}
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto error0;
+
+	if (args.fsbno == NULLFSBLOCK && args.minleft) {
+		/*
+		 * Could not find an AG with enough free space to satisfy
+		 * a full btree split.  Try again without minleft and if
+		 * successful activate the lowspace algorithm.
+		 */
+		args.fsbno = 0;
+		args.type = XFS_ALLOCTYPE_FIRST_AG;
+		args.minleft = 0;
+		error = xfs_alloc_vextent(&args);
+		if (error)
+			goto error0;
+		cur->bc_private.b.flist->xbf_low = 1;
+	}
+	if (args.fsbno == NULLFSBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+	ASSERT(args.len == 1);
+	cur->bc_private.b.firstblock = args.fsbno;
+	cur->bc_private.b.allocated++;
+	cur->bc_private.b.ip->i_d.di_nblocks++;
+	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
+	XFS_TRANS_MOD_DQUOT_BYINO(args.mp, args.tp, cur->bc_private.b.ip,
+			XFS_TRANS_DQ_BCOUNT, 1L);
+
+	new->l = cpu_to_be64(args.fsbno);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+ error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+STATIC int
+xfs_bmbt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	struct xfs_trans	*tp = cur->bc_tp;
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+
+	xfs_bmap_add_free(fsbno, 1, cur->bc_private.b.flist, mp);
+	ip->i_d.di_nblocks--;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
+	xfs_trans_binval(tp, bp);
+	return 0;
+}
+
+STATIC int
+xfs_bmbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return XFS_BMAP_BLOCK_IMINRECS(level, cur);
+}
+
+STATIC int
+xfs_bmbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return XFS_BMAP_BLOCK_IMAXRECS(level, cur);
+}
+
+/*
+ * Get the maximum records we could store in the on-disk format.
+ *
+ * For non-root nodes this is equivalent to xfs_bmbt_get_maxrecs, but
+ * for the root node this checks the available space in the dinode fork
+ * so that we can resize the in-memory buffer to match it.  After a
+ * resize to the maximum size this function returns the same value
+ * as xfs_bmbt_get_maxrecs for the root node, too.
+ */
+STATIC int
+xfs_bmbt_get_dmaxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return XFS_BMAP_BLOCK_DMAXRECS(level, cur);
+}
+
+STATIC void
+xfs_bmbt_init_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	key->bmbt.br_startoff =
+		cpu_to_be64(xfs_bmbt_disk_get_startoff(&rec->bmbt));
+}
+
+STATIC void
+xfs_bmbt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(key->bmbt.br_startoff != 0);
+
+	xfs_bmbt_disk_set_allf(&rec->bmbt, be64_to_cpu(key->bmbt.br_startoff),
+			       0, 0, XFS_EXT_NORM);
+}
+
+STATIC void
+xfs_bmbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	xfs_bmbt_disk_set_all(&rec->bmbt, &cur->bc_rec.b);
+}
+
+STATIC void
+xfs_bmbt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	ptr->l = 0;
+}
+
+STATIC __int64_t
+xfs_bmbt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	return (__int64_t)be64_to_cpu(key->bmbt.br_startoff) -
+				      cur->bc_rec.b.br_startoff;
+}
+
+#ifdef DEBUG
+STATIC int
+xfs_bmbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return be64_to_cpu(k1->bmbt.br_startoff) <
+		be64_to_cpu(k2->bmbt.br_startoff);
+}
+
+STATIC int
+xfs_bmbt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
+{
+	return xfs_bmbt_disk_get_startoff(&r1->bmbt) +
+		xfs_bmbt_disk_get_blockcount(&r1->bmbt) <=
+		xfs_bmbt_disk_get_startoff(&r2->bmbt);
+}
+#endif	/* DEBUG */
+
+#ifdef XFS_BTREE_TRACE
+ktrace_t	*xfs_bmbt_trace_buf;
+
+STATIC void
+xfs_bmbt_trace_enter(
+	struct xfs_btree_cur	*cur,
+	const char		*func,
+	char			*s,
+	int			type,
+	int			line,
+	__psunsigned_t		a0,
+	__psunsigned_t		a1,
+	__psunsigned_t		a2,
+	__psunsigned_t		a3,
+	__psunsigned_t		a4,
+	__psunsigned_t		a5,
+	__psunsigned_t		a6,
+	__psunsigned_t		a7,
+	__psunsigned_t		a8,
+	__psunsigned_t		a9,
+	__psunsigned_t		a10)
+{
+	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	int			whichfork = cur->bc_private.b.whichfork;
+
+	ktrace_enter(xfs_bmbt_trace_buf,
+		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
+		(void *)func, (void *)s, (void *)ip, (void *)cur,
+		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
+		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
+		(void *)a8, (void *)a9, (void *)a10);
+	ktrace_enter(ip->i_btrace,
+		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
+		(void *)func, (void *)s, (void *)ip, (void *)cur,
+		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
+		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
+		(void *)a8, (void *)a9, (void *)a10);
+}
+
+STATIC void
+xfs_bmbt_trace_cursor(
+	struct xfs_btree_cur	*cur,
+	__uint32_t		*s0,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
+{
+	struct xfs_bmbt_rec_host r;
+
+	xfs_bmbt_set_all(&r, &cur->bc_rec.b);
+
+	*s0 = (cur->bc_nlevels << 24) |
+	      (cur->bc_private.b.flags << 16) |
+	       cur->bc_private.b.allocated;
+	*l0 = r.l0;
+	*l1 = r.l1;
+}
+
+STATIC void
+xfs_bmbt_trace_key(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
+{
+	*l0 = be64_to_cpu(key->bmbt.br_startoff);
+	*l1 = 0;
+}
+
+STATIC void
+xfs_bmbt_trace_record(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	__uint64_t		*l0,
+	__uint64_t		*l1,
+	__uint64_t		*l2)
+{
+	struct xfs_bmbt_irec	irec;
+
+	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
+	*l0 = irec.br_startoff;
+	*l1 = irec.br_startblock;
+	*l2 = irec.br_blockcount;
+}
+#endif /* XFS_BTREE_TRACE */
+
+static const struct xfs_btree_ops xfs_bmbt_ops = {
+	.rec_len		= sizeof(xfs_bmbt_rec_t),
+	.key_len		= sizeof(xfs_bmbt_key_t),
+
+	.dup_cursor		= xfs_bmbt_dup_cursor,
+	.update_cursor		= xfs_bmbt_update_cursor,
+	.alloc_block		= xfs_bmbt_alloc_block,
+	.free_block		= xfs_bmbt_free_block,
+	.get_maxrecs		= xfs_bmbt_get_maxrecs,
+	.get_minrecs		= xfs_bmbt_get_minrecs,
+	.get_dmaxrecs		= xfs_bmbt_get_dmaxrecs,
+	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
+	.init_rec_from_key	= xfs_bmbt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
+	.key_diff		= xfs_bmbt_key_diff,
+
+#ifdef DEBUG
+	.keys_inorder		= xfs_bmbt_keys_inorder,
+	.recs_inorder		= xfs_bmbt_recs_inorder,
+#endif
+
+#ifdef XFS_BTREE_TRACE
+	.trace_enter		= xfs_bmbt_trace_enter,
+	.trace_cursor		= xfs_bmbt_trace_cursor,
+	.trace_key		= xfs_bmbt_trace_key,
+	.trace_record		= xfs_bmbt_trace_record,
+#endif
+};
+
+/*
+ * Allocate a new bmap btree cursor.
+ */
+struct xfs_btree_cur *				/* new bmap btree cursor */
+xfs_bmbt_init_cursor(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_inode	*ip,		/* inode owning the btree */
+	int			whichfork)	/* data or attr fork */
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_btree_cur	*cur;
+
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
+	cur->bc_btnum = XFS_BTNUM_BMAP;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+
+	cur->bc_ops = &xfs_bmbt_ops;
+	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
+
+	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
+	cur->bc_private.b.ip = ip;
+	cur->bc_private.b.firstblock = NULLFSBLOCK;
+	cur->bc_private.b.flist = NULL;
+	cur->bc_private.b.allocated = 0;
+	cur->bc_private.b.flags = 0;
+	cur->bc_private.b.whichfork = whichfork;
+
+	return cur;
+}
Index: xfs-cmds/xfsprogs/libxfs/xfs_btree.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_btree.c	2008-09-24 19:50:58.000000000 +0200
+++ xfs-cmds/xfsprogs/libxfs/xfs_btree.c	2008-09-24 20:01:30.000000000 +0200
@@ -30,135 +30,31 @@ const __uint32_t xfs_magics[XFS_BTNUM_MA
 	XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, XFS_BMAP_MAGIC, XFS_IBT_MAGIC
 };
 
-/*
- * Checking routine: return maxrecs for the block.
- */
-STATIC int				/* number of records fitting in block */
-xfs_btree_maxrecs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_block_t	*block)	/* generic btree block pointer */
-{
-	switch (cur->bc_btnum) {
-	case XFS_BTNUM_BNO:
-	case XFS_BTNUM_CNT:
-		return (int)XFS_ALLOC_BLOCK_MAXRECS(
-				be16_to_cpu(block->bb_h.bb_level), cur);
-	case XFS_BTNUM_BMAP:
-		return (int)XFS_BMAP_BLOCK_IMAXRECS(
-				be16_to_cpu(block->bb_h.bb_level), cur);
-	case XFS_BTNUM_INO:
-		return (int)XFS_INOBT_BLOCK_MAXRECS(
-				be16_to_cpu(block->bb_h.bb_level), cur);
-	default:
-		ASSERT(0);
-		return 0;
-	}
-}
-
-/*
- * External routines.
- */
-
-#ifdef DEBUG
-/*
- * Debug routine: check that block header is ok.
- */
-void
-xfs_btree_check_block(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_block_t	*block,	/* generic btree block pointer */
-	int			level,	/* level of the btree block */
-	xfs_buf_t		*bp)	/* buffer containing block, if any */
-{
-	if (XFS_BTREE_LONG_PTRS(cur->bc_btnum))
-		xfs_btree_check_lblock(cur, (xfs_btree_lblock_t *)block, level,
-			bp);
-	else
-		xfs_btree_check_sblock(cur, (xfs_btree_sblock_t *)block, level,
-			bp);
-}
-
-/*
- * Debug routine: check that keys are in the right order.
- */
-void
-xfs_btree_check_key(
-	xfs_btnum_t	btnum,		/* btree identifier */
-	void		*ak1,		/* pointer to left (lower) key */
-	void		*ak2)		/* pointer to right (higher) key */
-{
-	switch (btnum) {
-	case XFS_BTNUM_BNO: {
-		xfs_alloc_key_t	*k1;
-		xfs_alloc_key_t	*k2;
-
-		k1 = ak1;
-		k2 = ak2;
-		ASSERT(be32_to_cpu(k1->ar_startblock) < be32_to_cpu(k2->ar_startblock));
-		break;
-	    }
-	case XFS_BTNUM_CNT: {
-		xfs_alloc_key_t	*k1;
-		xfs_alloc_key_t	*k2;
-
-		k1 = ak1;
-		k2 = ak2;
-		ASSERT(be32_to_cpu(k1->ar_blockcount) < be32_to_cpu(k2->ar_blockcount) ||
-		       (k1->ar_blockcount == k2->ar_blockcount &&
-			be32_to_cpu(k1->ar_startblock) < be32_to_cpu(k2->ar_startblock)));
-		break;
-	    }
-	case XFS_BTNUM_BMAP: {
-		xfs_bmbt_key_t	*k1;
-		xfs_bmbt_key_t	*k2;
-
-		k1 = ak1;
-		k2 = ak2;
-		ASSERT(be64_to_cpu(k1->br_startoff) < be64_to_cpu(k2->br_startoff));
-		break;
-	    }
-	case XFS_BTNUM_INO: {
-		xfs_inobt_key_t	*k1;
-		xfs_inobt_key_t	*k2;
-
-		k1 = ak1;
-		k2 = ak2;
-		ASSERT(be32_to_cpu(k1->ir_startino) < be32_to_cpu(k2->ir_startino));
-		break;
-	    }
-	default:
-		ASSERT(0);
-	}
-}
-#endif	/* DEBUG */
 
-/*
- * Checking routine: check that long form block header is ok.
- */
-/* ARGSUSED */
 int					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_lblock(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_lblock_t	*block,	/* btree long form block pointer */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	struct xfs_btree_lblock	*block,	/* btree long form block pointer */
 	int			level,	/* level of the btree block */
-	xfs_buf_t		*bp)	/* buffer for block, if any */
+	struct xfs_buf		*bp)	/* buffer for block, if any */
 {
 	int			lblock_ok; /* block passes checks */
-	xfs_mount_t		*mp;	/* file system mount point */
+	struct xfs_mount	*mp;	/* file system mount point */
 
 	mp = cur->bc_mp;
 	lblock_ok =
 		be32_to_cpu(block->bb_magic) == xfs_magics[cur->bc_btnum] &&
 		be16_to_cpu(block->bb_level) == level &&
 		be16_to_cpu(block->bb_numrecs) <=
-			xfs_btree_maxrecs(cur, (xfs_btree_block_t *)block) &&
+			cur->bc_ops->get_maxrecs(cur, level) &&
 		block->bb_leftsib &&
 		(be64_to_cpu(block->bb_leftsib) == NULLDFSBNO ||
 		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_leftsib))) &&
 		block->bb_rightsib &&
 		(be64_to_cpu(block->bb_rightsib) == NULLDFSBNO ||
 		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_rightsib)));
-	if (unlikely(XFS_TEST_ERROR(!lblock_ok, mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK,
+	if (unlikely(XFS_TEST_ERROR(!lblock_ok, mp,
+			XFS_ERRTAG_BTREE_CHECK_LBLOCK,
 			XFS_RANDOM_BTREE_CHECK_LBLOCK))) {
 		if (bp)
 			xfs_buftrace("LBTREE ERROR", bp);
@@ -169,98 +65,15 @@ xfs_btree_check_lblock(
 	return 0;
 }
 
-/*
- * Checking routine: check that (long) pointer is ok.
- */
-int					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_lptr(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	xfs_dfsbno_t	ptr,		/* btree block disk address */
-	int		level)		/* btree block level */
-{
-	xfs_mount_t	*mp;		/* file system mount point */
-
-	mp = cur->bc_mp;
-	XFS_WANT_CORRUPTED_RETURN(
-		level > 0 &&
-		ptr != NULLDFSBNO &&
-		XFS_FSB_SANITY_CHECK(mp, ptr));
-	return 0;
-}
-
-#ifdef DEBUG
-/*
- * Debug routine: check that records are in the right order.
- */
-void
-xfs_btree_check_rec(
-	xfs_btnum_t	btnum,		/* btree identifier */
-	void		*ar1,		/* pointer to left (lower) record */
-	void		*ar2)		/* pointer to right (higher) record */
-{
-	switch (btnum) {
-	case XFS_BTNUM_BNO: {
-		xfs_alloc_rec_t	*r1;
-		xfs_alloc_rec_t	*r2;
-
-		r1 = ar1;
-		r2 = ar2;
-		ASSERT(be32_to_cpu(r1->ar_startblock) +
-		       be32_to_cpu(r1->ar_blockcount) <=
-		       be32_to_cpu(r2->ar_startblock));
-		break;
-	    }
-	case XFS_BTNUM_CNT: {
-		xfs_alloc_rec_t	*r1;
-		xfs_alloc_rec_t	*r2;
-
-		r1 = ar1;
-		r2 = ar2;
-		ASSERT(be32_to_cpu(r1->ar_blockcount) < be32_to_cpu(r2->ar_blockcount) ||
-		       (r1->ar_blockcount == r2->ar_blockcount &&
-			be32_to_cpu(r1->ar_startblock) < be32_to_cpu(r2->ar_startblock)));
-		break;
-	    }
-	case XFS_BTNUM_BMAP: {
-		xfs_bmbt_rec_t	*r1;
-		xfs_bmbt_rec_t	*r2;
-
-		r1 = ar1;
-		r2 = ar2;
-		ASSERT(xfs_bmbt_disk_get_startoff(r1) +
-		       xfs_bmbt_disk_get_blockcount(r1) <=
-		       xfs_bmbt_disk_get_startoff(r2));
-		break;
-	    }
-	case XFS_BTNUM_INO: {
-		xfs_inobt_rec_t	*r1;
-		xfs_inobt_rec_t	*r2;
-
-		r1 = ar1;
-		r2 = ar2;
-		ASSERT(be32_to_cpu(r1->ir_startino) + XFS_INODES_PER_CHUNK <=
-		       be32_to_cpu(r2->ir_startino));
-		break;
-	    }
-	default:
-		ASSERT(0);
-	}
-}
-#endif	/* DEBUG */
-
-/*
- * Checking routine: check that block header is ok.
- */
-/* ARGSUSED */
-int					/* error (0 or EFSCORRUPTED) */
+STATIC int				/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_sblock(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_sblock_t	*block,	/* btree short form block pointer */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	struct xfs_btree_sblock	*block,	/* btree short form block pointer */
 	int			level,	/* level of the btree block */
-	xfs_buf_t		*bp)	/* buffer containing block */
+	struct xfs_buf		*bp)	/* buffer containing block */
 {
-	xfs_buf_t		*agbp;	/* buffer for ag. freespace struct */
-	xfs_agf_t		*agf;	/* ag. freespace structure */
+	struct xfs_buf		*agbp;	/* buffer for ag. freespace struct */
+	struct xfs_agf		*agf;	/* ag. freespace structure */
 	xfs_agblock_t		agflen;	/* native ag. freespace length */
 	int			sblock_ok; /* block passes checks */
 
@@ -271,7 +84,7 @@ xfs_btree_check_sblock(
 		be32_to_cpu(block->bb_magic) == xfs_magics[cur->bc_btnum] &&
 		be16_to_cpu(block->bb_level) == level &&
 		be16_to_cpu(block->bb_numrecs) <=
-			xfs_btree_maxrecs(cur, (xfs_btree_block_t *)block) &&
+			cur->bc_ops->get_maxrecs(cur, level) &&
 		(be32_to_cpu(block->bb_leftsib) == NULLAGBLOCK ||
 		 be32_to_cpu(block->bb_leftsib) < agflen) &&
 		block->bb_leftsib &&
@@ -291,27 +104,79 @@ xfs_btree_check_sblock(
 }
 
 /*
- * Checking routine: check that (short) pointer is ok.
+ * Debug routine: check that block header is ok.
+ */
+int
+xfs_btree_check_block(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	struct xfs_btree_block	*block,	/* generic btree block pointer */
+	int			level,	/* level of the btree block */
+	struct xfs_buf		*bp)	/* buffer containing block, if any */
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		return xfs_btree_check_lblock(cur,
+				(struct xfs_btree_lblock *)block, level, bp);
+	} else {
+		return xfs_btree_check_sblock(cur,
+				(struct xfs_btree_sblock *)block, level, bp);
+	}
+}
+
+/*
+ * Check that (long) pointer is ok.
  */
 int					/* error (0 or EFSCORRUPTED) */
+xfs_btree_check_lptr(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_dfsbno_t		bno,	/* btree block disk address */
+	int			level)	/* btree block level */
+{
+	XFS_WANT_CORRUPTED_RETURN(
+		level > 0 &&
+		bno != NULLDFSBNO &&
+		XFS_FSB_SANITY_CHECK(cur->bc_mp, bno));
+	return 0;
+}
+
+/*
+ * Check that (short) pointer is ok.
+ */
+STATIC int				/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_sptr(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	xfs_agblock_t	ptr,		/* btree block disk address */
-	int		level)		/* btree block level */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* btree block disk address */
+	int			level)	/* btree block level */
 {
-	xfs_buf_t	*agbp;		/* buffer for ag. freespace struct */
-	xfs_agf_t	*agf;		/* ag. freespace structure */
+	xfs_agblock_t		agblocks = cur->bc_mp->m_sb.sb_agblocks;
 
-	agbp = cur->bc_private.a.agbp;
-	agf = XFS_BUF_TO_AGF(agbp);
 	XFS_WANT_CORRUPTED_RETURN(
 		level > 0 &&
-		ptr != NULLAGBLOCK && ptr != 0 &&
-		ptr < be32_to_cpu(agf->agf_length));
+		bno != NULLAGBLOCK &&
+		bno != 0 &&
+		bno < agblocks);
 	return 0;
 }
 
 /*
+ * Check that block ptr is ok.
+ */
+STATIC int				/* error (0 or EFSCORRUPTED) */
+xfs_btree_check_ptr(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	union xfs_btree_ptr	*ptr,	/* btree block disk address */
+	int			index,	/* offset from ptr to check */
+	int			level)	/* btree block level */
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		return xfs_btree_check_lptr(cur,
+				be64_to_cpu((&ptr->l)[index]), level);
+	} else {
+		return xfs_btree_check_sptr(cur,
+				be32_to_cpu((&ptr->s)[index]), level);
+	}
+}
+
+/*
  * Delete the btree cursor.
  */
 void
@@ -367,16 +232,17 @@ xfs_btree_dup_cursor(
 
 	tp = cur->bc_tp;
 	mp = cur->bc_mp;
+
 	/*
 	 * Allocate a new cursor like the old one.
 	 */
-	new = xfs_btree_init_cursor(mp, tp, cur->bc_private.a.agbp,
-		cur->bc_private.a.agno, cur->bc_btnum, cur->bc_private.b.ip,
-		cur->bc_private.b.whichfork);
+	new = cur->bc_ops->dup_cursor(cur);
+
 	/*
 	 * Copy the record currently in the cursor.
 	 */
 	new->bc_rec = cur->bc_rec;
+
 	/*
 	 * For each level current, re-get the buffer and copy the ptr value.
 	 */
@@ -396,46 +262,174 @@ xfs_btree_dup_cursor(
 		} else
 			new->bc_bufs[i] = NULL;
 	}
-	/*
-	 * For bmap btrees, copy the firstblock, flist, and flags values,
-	 * since init cursor doesn't get them.
-	 */
-	if (new->bc_btnum == XFS_BTNUM_BMAP) {
-		new->bc_private.b.firstblock = cur->bc_private.b.firstblock;
-		new->bc_private.b.flist = cur->bc_private.b.flist;
-		new->bc_private.b.flags = cur->bc_private.b.flags;
-	}
 	*ncur = new;
 	return 0;
 }
 
 /*
+ * XFS btree block layout and addressing:
+ *
+ * There are two types of blocks in the btree: leaf and non-leaf blocks.
+ *
+ * The leaf record start with a header then followed by records containing
+ * the values.  A non-leaf block also starts with the same header, and
+ * then first contains lookup keys followed by an equal number of pointers
+ * to the btree blocks at the previous level.
+ *
+ *		+--------+-------+-------+-------+-------+-------+-------+
+ * Leaf:	| header | rec 1 | rec 2 | rec 3 | rec 4 | rec 5 | rec N |
+ *		+--------+-------+-------+-------+-------+-------+-------+
+ *
+ *		+--------+-------+-------+-------+-------+-------+-------+
+ * Non-Leaf:	| header | key 1 | key 2 | key N | ptr 1 | ptr 2 | ptr N |
+ *		+--------+-------+-------+-------+-------+-------+-------+
+ *
+ * The header is called struct xfs_btree_block for reasons better left unknown
+ * and comes in different versions for short (32bit) and long (64bit) block
+ * pointers.  The record and key structures are defined by the btree instances
+ * and opaque to the btree core.  The block pointers are simple disk endian
+ * integers, available in a short (32bit) and long (64bit) variant.
+ *
+ * The helpers below calculate the offset of a given record, key or pointer
+ * into a btree block (xfs_btree_*_offset) or return a pointer to the given
+ * record, key or pointer (xfs_btree_*_addr).  Note that all addressing
+ * inside the btree block is done using indices starting at one, not zero!
+ */
+
+/*
+ * Return size of the btree block header for this btree instance.
+ */
+static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
+{
+	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+		sizeof(struct xfs_btree_lblock) :
+		sizeof(struct xfs_btree_sblock);
+}
+
+/*
+ * Return size of btree block pointers for this btree instance.
+ */
+static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
+{
+	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+		sizeof(__be64) : sizeof(__be32);
+}
+
+/*
+ * Calculate offset of the n-th record in a btree block.
+ */
+STATIC size_t
+xfs_btree_rec_offset(
+	struct xfs_btree_cur	*cur,
+	int			n)
+{
+	return xfs_btree_block_len(cur) +
+		(n - 1) * cur->bc_ops->rec_len;
+}
+
+/*
+ * Calculate offset of the n-th key in a btree block.
+ */
+STATIC size_t
+xfs_btree_key_offset(
+	struct xfs_btree_cur	*cur,
+	int			n)
+{
+	return xfs_btree_block_len(cur) +
+		(n - 1) * cur->bc_ops->key_len;
+}
+
+/*
+ * Calculate offset of the n-th block pointer in a btree block.
+ */
+STATIC size_t
+xfs_btree_ptr_offset(
+	struct xfs_btree_cur	*cur,
+	int			n,
+	int			level)
+{
+	return xfs_btree_block_len(cur) +
+		cur->bc_ops->get_maxrecs(cur, level) * cur->bc_ops->key_len +
+		(n - 1) * xfs_btree_ptr_len(cur);
+}
+
+/*
+ * Return a pointer to the n-th record in the btree block.
+ */
+STATIC union xfs_btree_rec *
+xfs_btree_rec_addr(
+	struct xfs_btree_cur	*cur,
+	int			n,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_rec *)
+		((char *)block + xfs_btree_rec_offset(cur, n));
+}
+
+/*
+ * Return a pointer to the n-th key in the btree block.
+ */
+STATIC union xfs_btree_key *
+xfs_btree_key_addr(
+	struct xfs_btree_cur	*cur,
+	int			n,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_key *)
+		((char *)block + xfs_btree_key_offset(cur, n));
+}
+
+/*
+ * Return a pointer to the n-th block pointer in the btree block.
+ */
+STATIC union xfs_btree_ptr *
+xfs_btree_ptr_addr(
+	struct xfs_btree_cur	*cur,
+	int			n,
+	struct xfs_btree_block	*block)
+{
+	int			level = xfs_btree_get_level(block);
+
+	ASSERT(block->bb_level != 0);
+
+	return (union xfs_btree_ptr *)
+		((char *)block + xfs_btree_ptr_offset(cur, n, level));
+}
+
+/*
+ * Get a the root block which is stored in the inode.
+ *
+ * For now this btree implementation assumes the btree root is always
+ * stored in the if_broot field of an inode fork.
+ */
+STATIC struct xfs_btree_block *
+xfs_btree_get_iroot(
+       struct xfs_btree_cur    *cur)
+{
+       struct xfs_ifork        *ifp;
+
+       ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
+       return (struct xfs_btree_block *)ifp->if_broot;
+}
+
+/*
  * Retrieve the block pointer from the cursor at the given level.
- * This may be a bmap btree root or from a buffer.
+ * This may be an inode btree root or from a buffer.
  */
-STATIC xfs_btree_block_t *		/* generic btree block pointer */
+STATIC struct xfs_btree_block *		/* generic btree block pointer */
 xfs_btree_get_block(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
+	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level in btree */
-	xfs_buf_t		**bpp)	/* buffer containing the block */
+	struct xfs_buf		**bpp)	/* buffer containing the block */
 {
-	xfs_btree_block_t	*block;	/* return value */
-	xfs_buf_t		*bp;	/* return buffer */
-	xfs_ifork_t		*ifp;	/* inode fork pointer */
-	int			whichfork; /* data or attr fork */
-
-	if (cur->bc_btnum == XFS_BTNUM_BMAP && level == cur->bc_nlevels - 1) {
-		whichfork = cur->bc_private.b.whichfork;
-		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, whichfork);
-		block = (xfs_btree_block_t *)ifp->if_broot;
-		bp = NULL;
-	} else {
-		bp = cur->bc_bufs[level];
-		block = XFS_BUF_TO_BLOCK(bp);
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (level == cur->bc_nlevels - 1)) {
+		*bpp = NULL;
+		return xfs_btree_get_iroot(cur);
 	}
-	ASSERT(block != NULL);
-	*bpp = bp;
-	return block;
+
+	*bpp = cur->bc_bufs[level];
+	return XFS_BUF_TO_BLOCK(*bpp);
 }
 
 /*
@@ -485,97 +479,6 @@ xfs_btree_get_bufs(
 }
 
 /*
- * Allocate a new btree cursor.
- * The cursor is either for allocation (A) or bmap (B) or inodes (I).
- */
-xfs_btree_cur_t *			/* new btree cursor */
-xfs_btree_init_cursor(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_buf_t	*agbp,		/* (A only) buffer for agf structure */
-					/* (I only) buffer for agi structure */
-	xfs_agnumber_t	agno,		/* (AI only) allocation group number */
-	xfs_btnum_t	btnum,		/* btree identifier */
-	xfs_inode_t	*ip,		/* (B only) inode owning the btree */
-	int		whichfork)	/* (B only) data or attr fork */
-{
-	xfs_agf_t	*agf;		/* (A) allocation group freespace */
-	xfs_agi_t	*agi;		/* (I) allocation group inodespace */
-	xfs_btree_cur_t	*cur;		/* return value */
-	xfs_ifork_t	*ifp;		/* (I) inode fork pointer */
-	int		nlevels=0;	/* number of levels in the btree */
-
-	ASSERT(xfs_btree_cur_zone != NULL);
-	/*
-	 * Allocate a new cursor.
-	 */
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
-	/*
-	 * Deduce the number of btree levels from the arguments.
-	 */
-	switch (btnum) {
-	case XFS_BTNUM_BNO:
-	case XFS_BTNUM_CNT:
-		agf = XFS_BUF_TO_AGF(agbp);
-		nlevels = be32_to_cpu(agf->agf_levels[btnum]);
-		break;
-	case XFS_BTNUM_BMAP:
-		ifp = XFS_IFORK_PTR(ip, whichfork);
-		nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
-		break;
-	case XFS_BTNUM_INO:
-		agi = XFS_BUF_TO_AGI(agbp);
-		nlevels = be32_to_cpu(agi->agi_level);
-		break;
-	default:
-		ASSERT(0);
-	}
-	/*
-	 * Fill in the common fields.
-	 */
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_nlevels = nlevels;
-	cur->bc_btnum = btnum;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-	/*
-	 * Fill in private fields.
-	 */
-	switch (btnum) {
-	case XFS_BTNUM_BNO:
-	case XFS_BTNUM_CNT:
-		/*
-		 * Allocation btree fields.
-		 */
-		cur->bc_private.a.agbp = agbp;
-		cur->bc_private.a.agno = agno;
-		break;
-	case XFS_BTNUM_INO:
-		/*
-		 * Inode allocation btree fields.
-		 */
-		cur->bc_private.a.agbp = agbp;
-		cur->bc_private.a.agno = agno;
-		break;
-	case XFS_BTNUM_BMAP:
-		/*
-		 * Bmap btree fields.
-		 */
-		cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
-		cur->bc_private.b.ip = ip;
-		cur->bc_private.b.firstblock = NULLFSBLOCK;
-		cur->bc_private.b.flist = NULL;
-		cur->bc_private.b.allocated = 0;
-		cur->bc_private.b.flags = 0;
-		cur->bc_private.b.whichfork = whichfork;
-		break;
-	default:
-		ASSERT(0);
-	}
-	return cur;
-}
-
-/*
  * Check for the cursor referring to the last block at the given level.
  */
 int					/* 1=is last block, 0=not last block */
@@ -588,7 +491,7 @@ xfs_btree_islastblock(
 
 	block = xfs_btree_get_block(cur, level, &bp);
 	xfs_btree_check_block(cur, block, level, bp);
-	if (XFS_BTREE_LONG_PTRS(cur->bc_btnum))
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		return be64_to_cpu(block->bb_u.l.bb_rightsib) == NULLDFSBNO;
 	else
 		return be32_to_cpu(block->bb_u.s.bb_rightsib) == NULLAGBLOCK;
@@ -598,7 +501,7 @@ xfs_btree_islastblock(
  * Change the cursor to point to the first record at the given level.
  * Other levels are unaffected.
  */
-int					/* success=1, failure=0 */
+STATIC int				/* success=1, failure=0 */
 xfs_btree_firstrec(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			level)	/* level to change */
@@ -614,7 +517,7 @@ xfs_btree_firstrec(
 	/*
 	 * It's empty, there is no such record.
 	 */
-	if (!block->bb_h.bb_numrecs)
+	if (!block->bb_numrecs)
 		return 0;
 	/*
 	 * Set the ptr value to 1, that's the first record/key.
@@ -627,7 +530,7 @@ xfs_btree_firstrec(
  * Change the cursor to point to the last record in the current block
  * at the given level.  Other levels are unaffected.
  */
-int					/* success=1, failure=0 */
+STATIC int				/* success=1, failure=0 */
 xfs_btree_lastrec(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			level)	/* level to change */
@@ -643,12 +546,12 @@ xfs_btree_lastrec(
 	/*
 	 * It's empty, there is no such record.
 	 */
-	if (!block->bb_h.bb_numrecs)
+	if (!block->bb_numrecs)
 		return 0;
 	/*
 	 * Set the ptr value to numrecs, that's the last record/key.
 	 */
-	cur->bc_ptrs[level] = be16_to_cpu(block->bb_h.bb_numrecs);
+	cur->bc_ptrs[level] = be16_to_cpu(block->bb_numrecs);
 	return 1;
 }
 
@@ -759,90 +662,148 @@ xfs_btree_read_bufs(
 	return 0;
 }
 
+#ifdef __KERNEL__
 /*
- * Read-ahead btree blocks, at the given level.
- * Bits in lr are set from XFS_BTCUR_{LEFT,RIGHT}RA.
+ * Read-ahead the block, don't wait for it, don't return a buffer.
+ * Long-form addressing.
  */
-int
-xfs_btree_readahead_core(
-	xfs_btree_cur_t		*cur,		/* btree cursor */
-	int			lev,		/* level in btree */
-	int			lr)		/* left/right bits */
+/* ARGSUSED */
+void
+xfs_btree_reada_bufl(
+	xfs_mount_t	*mp,		/* file system mount point */
+	xfs_fsblock_t	fsbno,		/* file system block number */
+	xfs_extlen_t	count)		/* count of filesystem blocks */
 {
-	xfs_alloc_block_t	*a;
-	xfs_bmbt_block_t	*b;
-	xfs_inobt_block_t	*i;
-	int			rval = 0;
+	xfs_daddr_t		d;
 
-	ASSERT(cur->bc_bufs[lev] != NULL);
-	cur->bc_ra[lev] |= lr;
-	switch (cur->bc_btnum) {
-	case XFS_BTNUM_BNO:
-	case XFS_BTNUM_CNT:
-		a = XFS_BUF_TO_ALLOC_BLOCK(cur->bc_bufs[lev]);
-		if ((lr & XFS_BTCUR_LEFTRA) && be32_to_cpu(a->bb_leftsib) != NULLAGBLOCK) {
-			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
-				be32_to_cpu(a->bb_leftsib), 1);
-			rval++;
-		}
-		if ((lr & XFS_BTCUR_RIGHTRA) && be32_to_cpu(a->bb_rightsib) != NULLAGBLOCK) {
-			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
-				be32_to_cpu(a->bb_rightsib), 1);
-			rval++;
-		}
-		break;
-	case XFS_BTNUM_BMAP:
-		b = XFS_BUF_TO_BMBT_BLOCK(cur->bc_bufs[lev]);
-		if ((lr & XFS_BTCUR_LEFTRA) && be64_to_cpu(b->bb_leftsib) != NULLDFSBNO) {
-			xfs_btree_reada_bufl(cur->bc_mp, be64_to_cpu(b->bb_leftsib), 1);
-			rval++;
-		}
-		if ((lr & XFS_BTCUR_RIGHTRA) && be64_to_cpu(b->bb_rightsib) != NULLDFSBNO) {
-			xfs_btree_reada_bufl(cur->bc_mp, be64_to_cpu(b->bb_rightsib), 1);
-			rval++;
-		}
-		break;
-	case XFS_BTNUM_INO:
-		i = XFS_BUF_TO_INOBT_BLOCK(cur->bc_bufs[lev]);
-		if ((lr & XFS_BTCUR_LEFTRA) && be32_to_cpu(i->bb_leftsib) != NULLAGBLOCK) {
-			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
-				be32_to_cpu(i->bb_leftsib), 1);
-			rval++;
-		}
-		if ((lr & XFS_BTCUR_RIGHTRA) && be32_to_cpu(i->bb_rightsib) != NULLAGBLOCK) {
-			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
-				be32_to_cpu(i->bb_rightsib), 1);
-			rval++;
-		}
-		break;
-	default:
-		ASSERT(0);
-	}
-	return rval;
+	ASSERT(fsbno != NULLFSBLOCK);
+	d = XFS_FSB_TO_DADDR(mp, fsbno);
+	xfs_baread(mp->m_ddev_targp, d, mp->m_bsize * count);
 }
 
 /*
- * Set the buffer for level "lev" in the cursor to bp, releasing
- * any previous buffer.
+ * Read-ahead the block, don't wait for it, don't return a buffer.
+ * Short-form addressing.
  */
+/* ARGSUSED */
 void
-xfs_btree_setbuf(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			lev,	/* level in btree */
-	xfs_buf_t		*bp)	/* new buffer to set */
+xfs_btree_reada_bufs(
+	xfs_mount_t	*mp,		/* file system mount point */
+	xfs_agnumber_t	agno,		/* allocation group number */
+	xfs_agblock_t	agbno,		/* allocation group block number */
+	xfs_extlen_t	count)		/* count of filesystem blocks */
 {
-	xfs_btree_block_t	*b;	/* btree block */
-	xfs_buf_t		*obp;	/* old buffer pointer */
+	xfs_daddr_t		d;
 
-	obp = cur->bc_bufs[lev];
-	if (obp)
-		xfs_trans_brelse(cur->bc_tp, obp);
-	cur->bc_bufs[lev] = bp;
-	cur->bc_ra[lev] = 0;
-	if (!bp)
+	ASSERT(agno != NULLAGNUMBER);
+	ASSERT(agbno != NULLAGBLOCK);
+	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	xfs_baread(mp->m_ddev_targp, d, mp->m_bsize * count);
+}
+#endif
+
+STATIC int
+xfs_btree_readahead_lblock(
+	struct xfs_btree_cur	*cur,
+	int			lr,
+	struct xfs_btree_block	*block)
+{
+	int			rval = 0;
+	xfs_fsblock_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
+	xfs_fsblock_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
+
+	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLDFSBNO) {
+		xfs_btree_reada_bufl(cur->bc_mp, left, 1);
+		rval++;
+	}
+
+	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLDFSBNO) {
+		xfs_btree_reada_bufl(cur->bc_mp, right, 1);
+		rval++;
+	}
+
+	return rval;
+}
+
+STATIC int
+xfs_btree_readahead_sblock(
+	struct xfs_btree_cur	*cur,
+	int			lr,
+	struct xfs_btree_block *block)
+{
+	int			rval = 0;
+	xfs_agblock_t		left = be32_to_cpu(block->bb_u.s.bb_leftsib);
+	xfs_agblock_t		right = be32_to_cpu(block->bb_u.s.bb_rightsib);
+
+
+	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
+		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
+				     left, 1);
+		rval++;
+	}
+
+	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLAGBLOCK) {
+		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.a.agno,
+				     right, 1);
+		rval++;
+	}
+
+	return rval;
+}
+
+/*
+ * Read-ahead btree blocks, at the given level.
+ * Bits in lr are set from XFS_BTCUR_{LEFT,RIGHT}RA.
+ */
+STATIC int
+xfs_btree_readahead(
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			lev,		/* level in btree */
+	int			lr)		/* left/right bits */
+{
+	struct xfs_btree_block	*block;
+
+	/*
+	 * No readahead needed if we are at the root level and the
+	 * btree root is stored in the inode.
+	 */
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (lev == cur->bc_nlevels - 1))
+		return 0;
+
+	if ((cur->bc_ra[lev] | lr) == cur->bc_ra[lev])
+		return 0;
+
+	cur->bc_ra[lev] |= lr;
+	block = XFS_BUF_TO_BLOCK(cur->bc_bufs[lev]);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		return xfs_btree_readahead_lblock(cur, lr, block);
+	return xfs_btree_readahead_sblock(cur, lr, block);
+}
+
+/*
+ * Set the buffer for level "lev" in the cursor to bp, releasing
+ * any previous buffer.
+ */
+void
+xfs_btree_setbuf(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	int			lev,	/* level in btree */
+	xfs_buf_t		*bp)	/* new buffer to set */
+{
+	xfs_btree_block_t	*b;	/* btree block */
+	xfs_buf_t		*obp;	/* old buffer pointer */
+
+	obp = cur->bc_bufs[lev];
+	if (obp)
+		xfs_trans_brelse(cur->bc_tp, obp);
+	cur->bc_bufs[lev] = bp;
+	cur->bc_ra[lev] = 0;
+	if (!bp)
 		return;
 	b = XFS_BUF_TO_BLOCK(bp);
-	if (XFS_BTREE_LONG_PTRS(cur->bc_btnum)) {
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		if (be64_to_cpu(b->bb_u.l.bb_leftsib) == NULLDFSBNO)
 			cur->bc_ra[lev] |= XFS_BTCUR_LEFTRA;
 		if (be64_to_cpu(b->bb_u.l.bb_rightsib) == NULLDFSBNO)
@@ -854,3 +815,2855 @@ xfs_btree_setbuf(
 			cur->bc_ra[lev] |= XFS_BTCUR_RIGHTRA;
 	}
 }
+
+STATIC int
+xfs_btree_ptr_is_null(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		return be64_to_cpu(ptr->l) == NULLFSBLOCK;
+	else
+		return be32_to_cpu(ptr->s) == NULLAGBLOCK;
+}
+
+STATIC void
+xfs_btree_set_ptr_null(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		ptr->l = cpu_to_be64(NULLFSBLOCK);
+	else
+		ptr->s = cpu_to_be32(NULLAGBLOCK);
+}
+
+/*
+ * Get/set/init sibling pointers
+ */
+STATIC void
+xfs_btree_get_sibling(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	union xfs_btree_ptr	*ptr,
+	int			lr)
+{
+	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (lr == XFS_BB_RIGHTSIB)
+			ptr->l = block->bb_u.l.bb_rightsib;
+		else
+			ptr->l = block->bb_u.l.bb_leftsib;
+	} else {
+		if (lr == XFS_BB_RIGHTSIB)
+			ptr->s = block->bb_u.s.bb_rightsib;
+		else
+			ptr->s = block->bb_u.s.bb_leftsib;
+	}
+}
+
+STATIC void
+xfs_btree_set_sibling(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	union xfs_btree_ptr	*ptr,
+	int			lr)
+{
+	ASSERT(lr == XFS_BB_LEFTSIB || lr == XFS_BB_RIGHTSIB);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (lr == XFS_BB_RIGHTSIB)
+			block->bb_u.l.bb_rightsib = ptr->l;
+		else
+			block->bb_u.l.bb_leftsib = ptr->l;
+	} else {
+		if (lr == XFS_BB_RIGHTSIB)
+			block->bb_u.s.bb_rightsib = ptr->s;
+		else
+			block->bb_u.s.bb_leftsib = ptr->s;
+	}
+}
+
+STATIC void
+xfs_btree_init_block(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			numrecs,
+	struct xfs_btree_block	*new)	/* new block */
+{
+	new->bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
+	new->bb_level = cpu_to_be16(level);
+	new->bb_numrecs = cpu_to_be16(numrecs);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		new->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
+		new->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
+	} else {
+		new->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
+		new->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+	}
+}
+
+/*
+ * Return true if ptr is the last record in the btree and
+ * we need to track updateѕ to this record.  The decision
+ * will be further refined in the update_lastrec method.
+ */
+STATIC int
+xfs_btree_is_lastrec(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	int			level)
+{
+	union xfs_btree_ptr	ptr;
+
+	if (level > 0)
+		return 0;
+	if (!(cur->bc_flags & XFS_BTREE_LASTREC_UPDATE))
+		return 0;
+
+	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
+	if (!xfs_btree_ptr_is_null(cur, &ptr))
+		return 0;
+	return 1;
+}
+
+STATIC void
+xfs_btree_buf_to_ptr(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	union xfs_btree_ptr	*ptr)
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		ptr->l = cpu_to_be64(XFS_DADDR_TO_FSB(cur->bc_mp,
+					XFS_BUF_ADDR(bp)));
+	else {
+		ptr->s = cpu_to_be32(XFS_DADDR_TO_AGBNO(cur->bc_mp,
+					XFS_BUF_ADDR(bp)));
+	}
+}
+
+STATIC xfs_daddr_t
+xfs_btree_ptr_to_daddr(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		ASSERT(be64_to_cpu(ptr->l) != NULLFSBLOCK);
+
+		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
+	} else {
+		ASSERT(cur->bc_private.a.agno != NULLAGNUMBER);
+		ASSERT(be32_to_cpu(ptr->s) != NULLAGBLOCK);
+
+		return XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
+					be32_to_cpu(ptr->s));
+	}
+}
+
+STATIC void
+xfs_btree_set_refs(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	switch (cur->bc_btnum) {
+	case XFS_BTNUM_BNO:
+	case XFS_BTNUM_CNT:
+		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_MAP, XFS_ALLOC_BTREE_REF);
+		break;
+	case XFS_BTNUM_INO:
+		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_INOMAP, XFS_INO_BTREE_REF);
+		break;
+	case XFS_BTNUM_BMAP:
+		XFS_BUF_SET_VTYPE_REF(*bpp, B_FS_MAP, XFS_BMAP_BTREE_REF);
+		break;
+	default:
+		ASSERT(0);
+	}
+}
+
+STATIC int
+xfs_btree_get_buf_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			flags,
+	struct xfs_btree_block	**block,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_daddr_t		d;
+
+	/* need to sort out how callers deal with failures first */
+	ASSERT(!(flags & XFS_BUF_TRYLOCK));
+
+	d = xfs_btree_ptr_to_daddr(cur, ptr);
+	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
+				 mp->m_bsize, flags);
+
+	ASSERT(*bpp);
+	ASSERT(!XFS_BUF_GETERROR(*bpp));
+
+	*block = XFS_BUF_TO_BLOCK(*bpp);
+	return 0;
+}
+
+/*
+ * Read in the buffer at the given ptr and return the buffer and
+ * the block pointer within the buffer.
+ */
+STATIC int
+xfs_btree_read_buf_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			level,
+	int			flags,
+	struct xfs_btree_block	**block,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_daddr_t		d;
+	int			error;
+
+	/* need to sort out how callers deal with failures first */
+	ASSERT(!(flags & XFS_BUF_TRYLOCK));
+
+	d = xfs_btree_ptr_to_daddr(cur, ptr);
+	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
+				   mp->m_bsize, flags, bpp);
+	if (error)
+		return error;
+
+	ASSERT(*bpp != NULL);
+	ASSERT(!XFS_BUF_GETERROR(*bpp));
+
+	xfs_btree_set_refs(cur, *bpp);
+	*block = XFS_BUF_TO_BLOCK(*bpp);
+
+	error = xfs_btree_check_block(cur, *block, level, *bpp);
+	if (error)
+		xfs_trans_brelse(cur->bc_tp, *bpp);
+	return error;
+}
+
+/*
+ * Copy keys from one btree block to another.
+ */
+STATIC void
+xfs_btree_copy_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*dst_key,
+	union xfs_btree_key	*src_key,
+	int			numkeys)
+{
+	ASSERT(numkeys >= 0);
+	memcpy(dst_key, src_key, numkeys * cur->bc_ops->key_len);
+}
+
+/*
+ * Copy records from one btree block to another.
+ */
+STATIC void
+xfs_btree_copy_recs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*dst_rec,
+	union xfs_btree_rec	*src_rec,
+	int			numrecs)
+{
+	ASSERT(numrecs >= 0);
+	memcpy(dst_rec, src_rec, numrecs * cur->bc_ops->rec_len);
+}
+
+/*
+ * Copy block pointers from one btree block to another.
+ */
+STATIC void
+xfs_btree_copy_ptrs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*dst_ptr,
+	union xfs_btree_ptr	*src_ptr,
+	int			numptrs)
+{
+	ASSERT(numptrs >= 0);
+	memcpy(dst_ptr, src_ptr, numptrs * xfs_btree_ptr_len(cur));
+}
+
+/*
+ * Shift keys one index left/right inside a single btree block.
+ */
+STATIC void
+xfs_btree_shift_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key,
+	int			dir,
+	int			numkeys)
+{
+	char			*dst_key;
+
+	ASSERT(numkeys >= 0);
+	ASSERT(dir == 1 || dir == -1);
+
+	dst_key = (char *)key + (dir * cur->bc_ops->key_len);
+	memmove(dst_key, key, numkeys * cur->bc_ops->key_len);
+}
+
+/*
+ * Shift records one index left/right inside a single btree block.
+ */
+STATIC void
+xfs_btree_shift_recs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	int			dir,
+	int			numrecs)
+{
+	char			*dst_rec;
+
+	ASSERT(numrecs >= 0);
+	ASSERT(dir == 1 || dir == -1);
+
+	dst_rec = (char *)rec + (dir * cur->bc_ops->rec_len);
+	memmove(dst_rec, rec, numrecs * cur->bc_ops->rec_len);
+}
+
+/*
+ * Shift block pointers one index left/right inside a single btree block.
+ */
+STATIC void
+xfs_btree_shift_ptrs(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			dir,
+	int			numptrs)
+{
+	char			*dst_ptr;
+
+	ASSERT(numptrs >= 0);
+	ASSERT(dir == 1 || dir == -1);
+
+	dst_ptr = (char *)ptr + (dir * xfs_btree_ptr_len(cur));
+	memmove(dst_ptr, ptr, numptrs * xfs_btree_ptr_len(cur));
+}
+
+/*
+ * Log key values from the btree block.
+ */
+STATIC void
+xfs_btree_log_keys(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			first,
+	int			last)
+{
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
+
+	if (bp) {
+		xfs_trans_log_buf(cur->bc_tp, bp,
+				  xfs_btree_key_offset(cur, first),
+				  xfs_btree_key_offset(cur, last + 1) - 1);
+	} else {
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
+				xfs_ilog_fbroot(cur->bc_private.b.whichfork));
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
+
+/*
+ * Log record values from the btree block.
+ */
+void
+xfs_btree_log_recs(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			first,
+	int			last)
+{
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
+
+	xfs_trans_log_buf(cur->bc_tp, bp,
+			  xfs_btree_rec_offset(cur, first),
+			  xfs_btree_rec_offset(cur, last + 1) - 1);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
+
+/*
+ * Log block pointer fields from a btree block (nonleaf).
+ */
+STATIC void
+xfs_btree_log_ptrs(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	struct xfs_buf		*bp,	/* buffer containing btree block */
+	int			first,	/* index of first pointer to log */
+	int			last)	/* index of last pointer to log */
+{
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
+
+	if (bp) {
+		struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+		int			level = xfs_btree_get_level(block);
+
+		xfs_trans_log_buf(cur->bc_tp, bp,
+				xfs_btree_ptr_offset(cur, first, level),
+				xfs_btree_ptr_offset(cur, last + 1, level) - 1);
+	} else {
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
+			xfs_ilog_fbroot(cur->bc_private.b.whichfork));
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
+
+/*
+ * Log fields from a btree block header.
+ */
+void
+xfs_btree_log_block(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	struct xfs_buf		*bp,	/* buffer containing btree block */
+	int			fields)	/* mask of fields: XFS_BB_... */
+{
+	int			first;	/* first byte offset logged */
+	int			last;	/* last byte offset logged */
+	static const short	soffsets[] = {	/* table of offsets (short) */
+		offsetof(struct xfs_btree_sblock, bb_magic),
+		offsetof(struct xfs_btree_sblock, bb_level),
+		offsetof(struct xfs_btree_sblock, bb_numrecs),
+		offsetof(struct xfs_btree_sblock, bb_leftsib),
+		offsetof(struct xfs_btree_sblock, bb_rightsib),
+		sizeof(struct xfs_btree_sblock)
+	};
+	static const short	loffsets[] = {	/* table of offsets (long) */
+		offsetof(struct xfs_btree_lblock, bb_magic),
+		offsetof(struct xfs_btree_lblock, bb_level),
+		offsetof(struct xfs_btree_lblock, bb_numrecs),
+		offsetof(struct xfs_btree_lblock, bb_leftsib),
+		offsetof(struct xfs_btree_lblock, bb_rightsib),
+		sizeof(struct xfs_btree_lblock)
+	};
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBI(cur, bp, fields);
+
+	if (bp) {
+		xfs_btree_offsets(fields,
+				  (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+					loffsets : soffsets,
+				  XFS_BB_NUM_BITS, &first, &last);
+		xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	} else {
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
+			xfs_ilog_fbroot(cur->bc_private.b.whichfork));
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+}
+
+/*
+ * Increment cursor by one record at the level.
+ * For nonzero levels the leaf-ward information is untouched.
+ */
+int						/* error */
+xfs_btree_increment(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			*stat)		/* success/failure */
+{
+	struct xfs_btree_block	*block;
+	union xfs_btree_ptr	ptr;
+	struct xfs_buf		*bp;
+	int			error;		/* error return value */
+	int			lev;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+
+	ASSERT(level < cur->bc_nlevels);
+
+	/* Read-ahead to the right at this level. */
+	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
+
+	/* Get a pointer to the btree block. */
+	block = xfs_btree_get_block(cur, level, &bp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, level, bp);
+	if (error)
+		goto error0;
+#endif
+
+	/* We're done if we remain in the block after the increment. */
+	if (++cur->bc_ptrs[level] <= xfs_btree_get_numrecs(block))
+		goto out1;
+
+	/* Fail if we just went off the right edge of the tree. */
+	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
+	if (xfs_btree_ptr_is_null(cur, &ptr))
+		goto out0;
+
+	XFS_BTREE_STATS_INC(cur, increment);
+
+	/*
+	 * March up the tree incrementing pointers.
+	 * Stop when we don't go off the right edge of a block.
+	 */
+	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
+		block = xfs_btree_get_block(cur, lev, &bp);
+
+#ifdef DEBUG
+		error = xfs_btree_check_block(cur, block, lev, bp);
+		if (error)
+			goto error0;
+#endif
+
+		if (++cur->bc_ptrs[lev] <= xfs_btree_get_numrecs(block))
+			break;
+
+		/* Read-ahead the right block for the next loop. */
+		xfs_btree_readahead(cur, lev, XFS_BTCUR_RIGHTRA);
+	}
+
+	/*
+	 * If we went off the root then we are either seriously
+	 * confused or have the tree root in an inode.
+	 */
+	if (lev == cur->bc_nlevels) {
+		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+			goto out0;
+		ASSERT(0);
+		error = EFSCORRUPTED;
+		goto error0;
+	}
+	ASSERT(lev < cur->bc_nlevels);
+
+	/*
+	 * Now walk back down the tree, fixing up the cursor's buffer
+	 * pointers and key numbers.
+	 */
+	for (block = xfs_btree_get_block(cur, lev, &bp); lev > level; ) {
+		union xfs_btree_ptr	*ptrp;
+
+		ptrp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[lev], block);
+		error = xfs_btree_read_buf_block(cur, ptrp, --lev,
+							0, &block, &bp);
+		if (error)
+			goto error0;
+
+		xfs_btree_setbuf(cur, lev, bp);
+		cur->bc_ptrs[lev] = 1;
+	}
+out1:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 0;
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+/*
+ * Decrement cursor by one record at the level.
+ * For nonzero levels the leaf-ward information is untouched.
+ */
+int						/* error */
+xfs_btree_decrement(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			*stat)		/* success/failure */
+{
+	struct xfs_btree_block	*block;
+	xfs_buf_t		*bp;
+	int			error;		/* error return value */
+	int			lev;
+	union xfs_btree_ptr	ptr;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+
+	ASSERT(level < cur->bc_nlevels);
+
+	/* Read-ahead to the left at this level. */
+	xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
+
+	/* We're done if we remain in the block after the decrement. */
+	if (--cur->bc_ptrs[level] > 0)
+		goto out1;
+
+	/* Get a pointer to the btree block. */
+	block = xfs_btree_get_block(cur, level, &bp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, level, bp);
+	if (error)
+		goto error0;
+#endif
+
+	/* Fail if we just went off the left edge of the tree. */
+	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_LEFTSIB);
+	if (xfs_btree_ptr_is_null(cur, &ptr))
+		goto out0;
+
+	XFS_BTREE_STATS_INC(cur, decrement);
+
+	/*
+	 * March up the tree decrementing pointers.
+	 * Stop when we don't go off the left edge of a block.
+	 */
+	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
+		if (--cur->bc_ptrs[lev] > 0)
+			break;
+		/* Read-ahead the left block for the next loop. */
+		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
+	}
+
+	/*
+	 * If we went off the root then we are seriously confused.
+	 * or the root of the tree is in an inode.
+	 */
+	if (lev == cur->bc_nlevels) {
+		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+			goto out0;
+		ASSERT(0);
+		error = EFSCORRUPTED;
+		goto error0;
+	}
+	ASSERT(lev < cur->bc_nlevels);
+
+	/*
+	 * Now walk back down the tree, fixing up the cursor's buffer
+	 * pointers and key numbers.
+	 */
+	for (block = xfs_btree_get_block(cur, lev, &bp); lev > level; ) {
+		union xfs_btree_ptr	*ptrp;
+
+		ptrp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[lev], block);
+		error = xfs_btree_read_buf_block(cur, ptrp, --lev,
+							0, &block, &bp);
+		if (error)
+			goto error0;
+		xfs_btree_setbuf(cur, lev, bp);
+		cur->bc_ptrs[lev] = xfs_btree_get_numrecs(block);
+	}
+out1:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 0;
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+STATIC int
+xfs_btree_lookup_get_block(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	int			level,	/* level in the btree */
+	union xfs_btree_ptr	*pp,	/* ptr to btree block */
+	struct xfs_btree_block	**blkp) /* return btree block */
+{
+	struct xfs_buf		*bp;	/* buffer pointer for btree block */
+	int			error = 0;
+
+	/* special case the root block if in an inode */
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (level == cur->bc_nlevels - 1)) {
+		*blkp = xfs_btree_get_iroot(cur);
+		return 0;
+	}
+
+	/*
+	 * If the old buffer at this level for the disk address we are
+	 * looking for re-use it.
+	 *
+	 * Otherwise throw it away and get a new one.
+	 */
+	bp = cur->bc_bufs[level];
+	if (bp && XFS_BUF_ADDR(bp) == xfs_btree_ptr_to_daddr(cur, pp)) {
+		*blkp = XFS_BUF_TO_BLOCK(bp);
+		return 0;
+	}
+
+	error = xfs_btree_read_buf_block(cur, pp, level, 0, blkp, &bp);
+	if (error)
+		return error;
+
+	xfs_btree_setbuf(cur, level, bp);
+	return 0;
+}
+
+/*
+ * Get current search key.  For level 0 we don't actually have a key
+ * structure so we make one up from the record.  For all other levels
+ * we just return the right key.
+ */
+STATIC union xfs_btree_key *
+xfs_lookup_get_search_key(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			keyno,
+	struct xfs_btree_block	*block,
+	union xfs_btree_key	*kp)
+{
+	if (level == 0) {
+		cur->bc_ops->init_key_from_rec(kp,
+				xfs_btree_rec_addr(cur, keyno, block));
+		return kp;
+	}
+
+	return xfs_btree_key_addr(cur, keyno, block);
+}
+
+/*
+ * Lookup the record.  The cursor is made to point to it, based on dir.
+ * Return 0 if can't find any such record, 1 for success.
+ */
+int					/* error */
+xfs_btree_lookup(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_lookup_t		dir,	/* <=, ==, or >= */
+	int			*stat)	/* success/failure */
+{
+	struct xfs_btree_block	*block;	/* current btree block */
+	__int64_t		diff;	/* difference for the current key */
+	int			error;	/* error return value */
+	int			keyno;	/* current key number */
+	int			level;	/* level in the btree */
+	union xfs_btree_ptr	*pp;	/* ptr to btree block */
+	union xfs_btree_ptr	ptr;	/* ptr to btree block */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, dir);
+
+	XFS_BTREE_STATS_INC(cur, lookup);
+
+	block = NULL;
+	keyno = 0;
+
+	/* initialise start pointer from cursor */
+	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+	pp = &ptr;
+
+	/*
+	 * Iterate over each level in the btree, starting at the root.
+	 * For each level above the leaves, find the key we need, based
+	 * on the lookup record, then follow the corresponding block
+	 * pointer down to the next level.
+	 */
+	for (level = cur->bc_nlevels - 1, diff = 1; level >= 0; level--) {
+		/* Get the block we need to do the lookup on. */
+		error = xfs_btree_lookup_get_block(cur, level, pp, &block);
+		if (error)
+			goto error0;
+
+		if (diff == 0) {
+			/*
+			 * If we already had a key match at a higher level, we
+			 * know we need to use the first entry in this block.
+			 */
+			keyno = 1;
+		} else {
+			/* Otherwise search this block. Do a binary search. */
+
+			int	high;	/* high entry number */
+			int	low;	/* low entry number */
+
+			/* Set low and high entry numbers, 1-based. */
+			low = 1;
+			high = xfs_btree_get_numrecs(block);
+			if (!high) {
+				/* Block is empty, must be an empty leaf. */
+				ASSERT(level == 0 && cur->bc_nlevels == 1);
+
+				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
+				XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+				*stat = 0;
+				return 0;
+			}
+
+			/* Binary search the block. */
+			while (low <= high) {
+				union xfs_btree_key	key;
+				union xfs_btree_key	*kp;
+
+				XFS_BTREE_STATS_INC(cur, compare);
+
+				/* keyno is average of low and high. */
+				keyno = (low + high) >> 1;
+
+				/* Get current search key */
+				kp = xfs_lookup_get_search_key(cur, level,
+						keyno, block, &key);
+
+				/*
+				 * Compute difference to get next direction:
+				 *  - less than, move right
+				 *  - greater than, move left
+				 *  - equal, we're done
+				 */
+				diff = cur->bc_ops->key_diff(cur, kp);
+				if (diff < 0)
+					low = keyno + 1;
+				else if (diff > 0)
+					high = keyno - 1;
+				else
+					break;
+			}
+		}
+
+		/*
+		 * If there are more levels, set up for the next level
+		 * by getting the block number and filling in the cursor.
+		 */
+		if (level > 0) {
+			/*
+			 * If we moved left, need the previous key number,
+			 * unless there isn't one.
+			 */
+			if (diff > 0 && --keyno < 1)
+				keyno = 1;
+			pp = xfs_btree_ptr_addr(cur, keyno, block);
+
+#ifdef DEBUG
+			error = xfs_btree_check_ptr(cur, pp, 0, level);
+			if (error)
+				goto error0;
+#endif
+			cur->bc_ptrs[level] = keyno;
+		}
+	}
+
+	/* Done with the search. See if we need to adjust the results. */
+	if (dir != XFS_LOOKUP_LE && diff < 0) {
+		keyno++;
+		/*
+		 * If ge search and we went off the end of the block, but it's
+		 * not the last block, we're in the wrong block.
+		 */
+		xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
+		if (dir == XFS_LOOKUP_GE &&
+		    keyno > xfs_btree_get_numrecs(block) &&
+		    !xfs_btree_ptr_is_null(cur, &ptr)) {
+			int	i;
+
+			cur->bc_ptrs[0] = keyno;
+			error = xfs_btree_increment(cur, 0, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_RETURN(i == 1);
+			XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+			*stat = 1;
+			return 0;
+		}
+	} else if (dir == XFS_LOOKUP_LE && diff > 0)
+		keyno--;
+	cur->bc_ptrs[0] = keyno;
+
+	/* Return if we succeeded or not. */
+	if (keyno == 0 || keyno > xfs_btree_get_numrecs(block))
+		*stat = 0;
+	else if (dir != XFS_LOOKUP_EQ || diff == 0)
+		*stat = 1;
+	else
+		*stat = 0;
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+/*
+ * Update keys at all levels from here to the root along the cursor's path.
+ */
+STATIC int
+xfs_btree_updkey(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*keyp,
+	int			level)
+{
+	struct xfs_btree_block	*block;
+	struct xfs_buf		*bp;
+	union xfs_btree_key	*kp;
+	int			ptr;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGIK(cur, level, keyp);
+
+	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) || level >= 1);
+
+	/*
+	 * Go up the tree from this level toward the root.
+	 * At each level, update the key value to the value input.
+	 * Stop when we reach a level where the cursor isn't pointing
+	 * at the first entry in the block.
+	 */
+	for (ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
+#ifdef DEBUG
+		int		error;
+#endif
+		block = xfs_btree_get_block(cur, level, &bp);
+#ifdef DEBUG
+		error = xfs_btree_check_block(cur, block, level, bp);
+		if (error) {
+			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+			return error;
+		}
+#endif
+		ptr = cur->bc_ptrs[level];
+		kp = xfs_btree_key_addr(cur, ptr, block);
+		xfs_btree_copy_keys(cur, kp, keyp, 1);
+		xfs_btree_log_keys(cur, bp, ptr, ptr);
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+}
+
+/*
+ * Update the record referred to by cur to the value in the
+ * given record. This either works (return 0) or gets an
+ * EFSCORRUPTED error.
+ */
+int
+xfs_btree_update(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	struct xfs_btree_block	*block;
+	struct xfs_buf		*bp;
+	int			error;
+	int			ptr;
+	union xfs_btree_rec	*rp;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGR(cur, rec);
+
+	/* Pick up the current block. */
+	block = xfs_btree_get_block(cur, 0, &bp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, 0, bp);
+	if (error)
+		goto error0;
+#endif
+	/* Get the address of the rec to be updated. */
+	ptr = cur->bc_ptrs[0];
+	rp = xfs_btree_rec_addr(cur, ptr, block);
+
+	/* Fill in the new contents and log them. */
+	xfs_btree_copy_recs(cur, rp, rec, 1);
+	xfs_btree_log_recs(cur, bp, ptr, ptr);
+
+	/*
+	 * If we are tracking the last record in the tree and
+	 * we are at the far right edge of the tree, update it.
+	 */
+	if (xfs_btree_is_lastrec(cur, block, 0)) {
+		cur->bc_ops->update_lastrec(cur, block, rec,
+					    ptr, LASTREC_UPDATE);
+	}
+
+	/* Updating first rec in leaf. Pass new key value up to our parent. */
+	if (ptr == 1) {
+		union xfs_btree_key	key;
+
+		cur->bc_ops->init_key_from_rec(&key, rec);
+		error = xfs_btree_updkey(cur, &key, 1);
+		if (error)
+			goto error0;
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+/*
+ * Move 1 record left from cur/level if possible.
+ * Update cur to reflect the new path.
+ */
+STATIC int					/* error */
+xfs_btree_lshift(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			*stat)		/* success/failure */
+{
+	union xfs_btree_key	key;		/* btree key */
+	struct xfs_buf		*lbp;		/* left buffer pointer */
+	struct xfs_btree_block	*left;		/* left btree block */
+	int			lrecs;		/* left record count */
+	struct xfs_buf		*rbp;		/* right buffer pointer */
+	struct xfs_btree_block	*right;		/* right btree block */
+	int			rrecs;		/* right record count */
+	union xfs_btree_ptr	lptr;		/* left btree pointer */
+	union xfs_btree_key	*rkp = NULL;	/* right btree key */
+	union xfs_btree_ptr	*rpp = NULL;	/* right address pointer */
+	union xfs_btree_rec	*rrp = NULL;	/* right record pointer */
+	int			error;		/* error return value */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    level == cur->bc_nlevels - 1)
+		goto out0;
+
+	/* Set up variables for this block as "right". */
+	right = xfs_btree_get_block(cur, level, &rbp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, right, level, rbp);
+	if (error)
+		goto error0;
+#endif
+
+	/* If we've got no left sibling then we can't shift an entry left. */
+	xfs_btree_get_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
+	if (xfs_btree_ptr_is_null(cur, &lptr))
+		goto out0;
+
+	/*
+	 * If the cursor entry is the one that would be moved, don't
+	 * do it... it's too complicated.
+	 */
+	if (cur->bc_ptrs[level] <= 1)
+		goto out0;
+
+	/* Set up the left neighbor as "left". */
+	error = xfs_btree_read_buf_block(cur, &lptr, level, 0, &left, &lbp);
+	if (error)
+		goto error0;
+
+	/* If it's full, it can't take another entry. */
+	lrecs = xfs_btree_get_numrecs(left);
+	if (lrecs == cur->bc_ops->get_maxrecs(cur, level))
+		goto out0;
+
+	rrecs = xfs_btree_get_numrecs(right);
+
+	/*
+	 * We add one entry to the left side and remove one for the right side.
+	 * Accout for it here, the changes will be updated on disk and logged
+	 * later.
+	 */
+	lrecs++;
+	rrecs--;
+
+	XFS_BTREE_STATS_INC(cur, lshift);
+	XFS_BTREE_STATS_ADD(cur, moves, 1);
+
+	/*
+	 * If non-leaf, copy a key and a ptr to the left block.
+	 * Log the changes to the left block.
+	 */
+	if (level > 0) {
+		/* It's a non-leaf.  Move keys and pointers. */
+		union xfs_btree_key	*lkp;	/* left btree key */
+		union xfs_btree_ptr	*lpp;	/* left address pointer */
+
+		lkp = xfs_btree_key_addr(cur, lrecs, left);
+		rkp = xfs_btree_key_addr(cur, 1, right);
+
+		lpp = xfs_btree_ptr_addr(cur, lrecs, left);
+		rpp = xfs_btree_ptr_addr(cur, 1, right);
+#ifdef DEBUG
+		error = xfs_btree_check_ptr(cur, rpp, 0, level);
+		if (error)
+			goto error0;
+#endif
+		xfs_btree_copy_keys(cur, lkp, rkp, 1);
+		xfs_btree_copy_ptrs(cur, lpp, rpp, 1);
+
+		xfs_btree_log_keys(cur, lbp, lrecs, lrecs);
+		xfs_btree_log_ptrs(cur, lbp, lrecs, lrecs);
+
+		ASSERT(cur->bc_ops->keys_inorder(cur,
+			xfs_btree_key_addr(cur, lrecs - 1, left), lkp));
+	} else {
+		/* It's a leaf.  Move records.  */
+		union xfs_btree_rec	*lrp;	/* left record pointer */
+
+		lrp = xfs_btree_rec_addr(cur, lrecs, left);
+		rrp = xfs_btree_rec_addr(cur, 1, right);
+
+		xfs_btree_copy_recs(cur, lrp, rrp, 1);
+		xfs_btree_log_recs(cur, lbp, lrecs, lrecs);
+
+		ASSERT(cur->bc_ops->recs_inorder(cur,
+			xfs_btree_rec_addr(cur, lrecs - 1, left), lrp));
+	}
+
+	xfs_btree_set_numrecs(left, lrecs);
+	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS);
+
+	xfs_btree_set_numrecs(right, rrecs);
+	xfs_btree_log_block(cur, rbp, XFS_BB_NUMRECS);
+
+	/*
+	 * Slide the contents of right down one entry.
+	 */
+	XFS_BTREE_STATS_ADD(cur, moves, rrecs - 1);
+	if (level > 0) {
+		/* It's a nonleaf. operate on keys and ptrs */
+#ifdef DEBUG
+		int			i;		/* loop index */
+
+		for (i = 0; i < rrecs; i++) {
+			error = xfs_btree_check_ptr(cur, rpp, i + 1, level);
+			if (error)
+				goto error0;
+		}
+#endif
+		xfs_btree_shift_keys(cur,
+				xfs_btree_key_addr(cur, 2, right),
+				-1, rrecs);
+		xfs_btree_shift_ptrs(cur,
+				xfs_btree_ptr_addr(cur, 2, right),
+				-1, rrecs);
+
+		xfs_btree_log_keys(cur, rbp, 1, rrecs);
+		xfs_btree_log_ptrs(cur, rbp, 1, rrecs);
+	} else {
+		/* It's a leaf. operate on records */
+		xfs_btree_shift_recs(cur,
+			xfs_btree_rec_addr(cur, 2, right),
+			-1, rrecs);
+		xfs_btree_log_recs(cur, rbp, 1, rrecs);
+
+		/*
+		 * If it's the first record in the block, we'll need a key
+		 * structure to pass up to the next level (updkey).
+		 */
+		cur->bc_ops->init_key_from_rec(&key,
+			xfs_btree_rec_addr(cur, 1, right));
+		rkp = &key;
+	}
+
+	/* Update the parent key values of right. */
+	error = xfs_btree_updkey(cur, rkp, level + 1);
+	if (error)
+		goto error0;
+
+	/* Slide the cursor value left one. */
+	cur->bc_ptrs[level]--;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 0;
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+/*
+ * Move 1 record right from cur/level if possible.
+ * Update cur to reflect the new path.
+ */
+STATIC int					/* error */
+xfs_btree_rshift(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			*stat)		/* success/failure */
+{
+	union xfs_btree_key	key;		/* btree key */
+	struct xfs_buf		*lbp;		/* left buffer pointer */
+	struct xfs_btree_block	*left;		/* left btree block */
+	struct xfs_buf		*rbp;		/* right buffer pointer */
+	struct xfs_btree_block	*right;		/* right btree block */
+	struct xfs_btree_cur	*tcur;		/* temporary btree cursor */
+	union xfs_btree_ptr	rptr;		/* right block pointer */
+	union xfs_btree_key	*rkp;		/* right btree key */
+	int			rrecs;		/* right record count */
+	int			lrecs;		/* left record count */
+	int			error;		/* error return value */
+	int			i;		/* loop counter */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (level == cur->bc_nlevels - 1))
+		goto out0;
+
+	/* Set up variables for this block as "left". */
+	left = xfs_btree_get_block(cur, level, &lbp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, left, level, lbp);
+	if (error)
+		goto error0;
+#endif
+
+	/* If we've got no right sibling then we can't shift an entry right. */
+	xfs_btree_get_sibling(cur, left, &rptr, XFS_BB_RIGHTSIB);
+	if (xfs_btree_ptr_is_null(cur, &rptr))
+		goto out0;
+
+	/*
+	 * If the cursor entry is the one that would be moved, don't
+	 * do it... it's too complicated.
+	 */
+	lrecs = xfs_btree_get_numrecs(left);
+	if (cur->bc_ptrs[level] >= lrecs)
+		goto out0;
+
+	/* Set up the right neighbor as "right". */
+	error = xfs_btree_read_buf_block(cur, &rptr, level, 0, &right, &rbp);
+	if (error)
+		goto error0;
+
+	/* If it's full, it can't take another entry. */
+	rrecs = xfs_btree_get_numrecs(right);
+	if (rrecs == cur->bc_ops->get_maxrecs(cur, level))
+		goto out0;
+
+	XFS_BTREE_STATS_INC(cur, rshift);
+	XFS_BTREE_STATS_ADD(cur, moves, rrecs);
+
+	/*
+	 * Make a hole at the start of the right neighbor block, then
+	 * copy the last left block entry to the hole.
+	 */
+	if (level > 0) {
+		/* It's a nonleaf. make a hole in the keys and ptrs */
+		union xfs_btree_key	*lkp;
+		union xfs_btree_ptr	*lpp;
+		union xfs_btree_ptr	*rpp;
+
+		lkp = xfs_btree_key_addr(cur, lrecs, left);
+		lpp = xfs_btree_ptr_addr(cur, lrecs, left);
+		rkp = xfs_btree_key_addr(cur, 1, right);
+		rpp = xfs_btree_ptr_addr(cur, 1, right);
+
+#ifdef DEBUG
+		for (i = rrecs - 1; i >= 0; i--) {
+			error = xfs_btree_check_ptr(cur, rpp, i, level);
+			if (error)
+				goto error0;
+		}
+#endif
+
+		xfs_btree_shift_keys(cur, rkp, 1, rrecs);
+		xfs_btree_shift_ptrs(cur, rpp, 1, rrecs);
+
+#ifdef DEBUG
+		error = xfs_btree_check_ptr(cur, lpp, 0, level);
+		if (error)
+			goto error0;
+#endif
+
+		/* Now put the new data in, and log it. */
+		xfs_btree_copy_keys(cur, rkp, lkp, 1);
+		xfs_btree_copy_ptrs(cur, rpp, lpp, 1);
+
+		xfs_btree_log_keys(cur, rbp, 1, rrecs + 1);
+		xfs_btree_log_ptrs(cur, rbp, 1, rrecs + 1);
+
+		ASSERT(cur->bc_ops->keys_inorder(cur, rkp,
+			xfs_btree_key_addr(cur, 2, right)));
+	} else {
+		/* It's a leaf. make a hole in the records */
+		union xfs_btree_rec	*lrp;
+		union xfs_btree_rec	*rrp;
+
+		lrp = xfs_btree_rec_addr(cur, lrecs, left);
+		rrp = xfs_btree_rec_addr(cur, 1, right);
+
+		xfs_btree_shift_recs(cur, rrp, 1, rrecs);
+
+		/* Now put the new data in, and log it. */
+		xfs_btree_copy_recs(cur, rrp, lrp, 1);
+		xfs_btree_log_recs(cur, rbp, 1, rrecs + 1);
+
+		cur->bc_ops->init_key_from_rec(&key, rrp);
+		rkp = &key;
+
+		ASSERT(cur->bc_ops->recs_inorder(cur, rrp,
+			xfs_btree_rec_addr(cur, 2, right)));
+	}
+
+	/*
+	 * Decrement and log left's numrecs, bump and log right's numrecs.
+	 */
+	xfs_btree_set_numrecs(left, --lrecs);
+	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS);
+
+	xfs_btree_set_numrecs(right, ++rrecs);
+	xfs_btree_log_block(cur, rbp, XFS_BB_NUMRECS);
+
+	/*
+	 * Using a temporary cursor, update the parent key values of the
+	 * block on the right.
+	 */
+	error = xfs_btree_dup_cursor(cur, &tcur);
+	if (error)
+		goto error0;
+	i = xfs_btree_lastrec(tcur, level);
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+	error = xfs_btree_increment(tcur, level, &i);
+	if (error)
+		goto error1;
+
+	error = xfs_btree_updkey(tcur, rkp, level + 1);
+	if (error)
+		goto error1;
+
+	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 0;
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+
+error1:
+	XFS_BTREE_TRACE_CURSOR(tcur, XBT_ERROR);
+	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/*
+ * Split cur/level block in half.
+ * Return new block number and the key to its first
+ * record (to be inserted into parent).
+ */
+STATIC int					/* error */
+xfs_btree_split(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	union xfs_btree_ptr	*ptrp,
+	union xfs_btree_key	*key,
+	struct xfs_btree_cur	**curp,
+	int			*stat)		/* success/failure */
+{
+	union xfs_btree_ptr	lptr;		/* left sibling block ptr */
+	struct xfs_buf		*lbp;		/* left buffer pointer */
+	struct xfs_btree_block	*left;		/* left btree block */
+	union xfs_btree_ptr	rptr;		/* right sibling block ptr */
+	struct xfs_buf		*rbp;		/* right buffer pointer */
+	struct xfs_btree_block	*right;		/* right btree block */
+	union xfs_btree_ptr	rrptr;		/* right-right sibling ptr */
+	struct xfs_buf		*rrbp;		/* right-right buffer pointer */
+	struct xfs_btree_block	*rrblock;	/* right-right btree block */
+	int			lrecs;
+	int			rrecs;
+	int			src_index;
+	int			error;		/* error return value */
+#ifdef DEBUG
+	int			i;
+#endif
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGIPK(cur, level, *ptrp, key);
+
+	XFS_BTREE_STATS_INC(cur, split);
+
+	/* Set up left block (current one). */
+	left = xfs_btree_get_block(cur, level, &lbp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, left, level, lbp);
+	if (error)
+		goto error0;
+#endif
+
+	xfs_btree_buf_to_ptr(cur, lbp, &lptr);
+
+	/* Allocate the new block. If we can't do it, we're toast. Give up. */
+	error = cur->bc_ops->alloc_block(cur, &lptr, &rptr, 1, stat);
+	if (error)
+		goto error0;
+	if (*stat == 0)
+		goto out0;
+	XFS_BTREE_STATS_INC(cur, alloc);
+
+	/* Set up the new block as "right". */
+	error = xfs_btree_get_buf_block(cur, &rptr, 0, &right, &rbp);
+	if (error)
+		goto error0;
+
+	/* Fill in the btree header for the new right block. */
+	xfs_btree_init_block(cur, xfs_btree_get_level(left), 0, right);
+
+	/*
+	 * Split the entries between the old and the new block evenly.
+	 * Make sure that if there's an odd number of entries now, that
+	 * each new block will have the same number of entries.
+	 */
+	lrecs = xfs_btree_get_numrecs(left);
+	rrecs = lrecs / 2;
+	if ((lrecs & 1) && cur->bc_ptrs[level] <= rrecs + 1)
+		rrecs++;
+	src_index = (lrecs - rrecs + 1);
+
+	XFS_BTREE_STATS_ADD(cur, moves, rrecs);
+
+	/*
+	 * Copy btree block entries from the left block over to the
+	 * new block, the right. Update the right block and log the
+	 * changes.
+	 */
+	if (level > 0) {
+		/* It's a non-leaf.  Move keys and pointers. */
+		union xfs_btree_key	*lkp;	/* left btree key */
+		union xfs_btree_ptr	*lpp;	/* left address pointer */
+		union xfs_btree_key	*rkp;	/* right btree key */
+		union xfs_btree_ptr	*rpp;	/* right address pointer */
+
+		lkp = xfs_btree_key_addr(cur, src_index, left);
+		lpp = xfs_btree_ptr_addr(cur, src_index, left);
+		rkp = xfs_btree_key_addr(cur, 1, right);
+		rpp = xfs_btree_ptr_addr(cur, 1, right);
+
+#ifdef DEBUG
+		for (i = src_index; i < rrecs; i++) {
+			error = xfs_btree_check_ptr(cur, lpp, i, level);
+			if (error)
+				goto error0;
+		}
+#endif
+
+		xfs_btree_copy_keys(cur, rkp, lkp, rrecs);
+		xfs_btree_copy_ptrs(cur, rpp, lpp, rrecs);
+
+		xfs_btree_log_keys(cur, rbp, 1, rrecs);
+		xfs_btree_log_ptrs(cur, rbp, 1, rrecs);
+
+		/* Grab the keys to the entries moved to the right block */
+		xfs_btree_copy_keys(cur, key, rkp, 1);
+	} else {
+		/* It's a leaf.  Move records.  */
+		union xfs_btree_rec	*lrp;	/* left record pointer */
+		union xfs_btree_rec	*rrp;	/* right record pointer */
+
+		lrp = xfs_btree_rec_addr(cur, src_index, left);
+		rrp = xfs_btree_rec_addr(cur, 1, right);
+
+		xfs_btree_copy_recs(cur, rrp, lrp, rrecs);
+		xfs_btree_log_recs(cur, rbp, 1, rrecs);
+
+		cur->bc_ops->init_key_from_rec(key,
+			xfs_btree_rec_addr(cur, 1, right));
+	}
+
+
+	/*
+	 * Find the left block number by looking in the buffer.
+	 * Adjust numrecs, sibling pointers.
+	 */
+	xfs_btree_get_sibling(cur, left, &rrptr, XFS_BB_RIGHTSIB);
+	xfs_btree_set_sibling(cur, right, &rrptr, XFS_BB_RIGHTSIB);
+	xfs_btree_set_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
+	xfs_btree_set_sibling(cur, left, &rptr, XFS_BB_RIGHTSIB);
+
+	lrecs -= rrecs;
+	xfs_btree_set_numrecs(left, lrecs);
+	xfs_btree_set_numrecs(right, xfs_btree_get_numrecs(right) + rrecs);
+
+	xfs_btree_log_block(cur, rbp, XFS_BB_ALL_BITS);
+	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
+
+	/*
+	 * If there's a block to the new block's right, make that block
+	 * point back to right instead of to left.
+	 */
+	if (!xfs_btree_ptr_is_null(cur, &rrptr)) {
+		error = xfs_btree_read_buf_block(cur, &rrptr, level,
+							0, &rrblock, &rrbp);
+		if (error)
+			goto error0;
+		xfs_btree_set_sibling(cur, rrblock, &rptr, XFS_BB_LEFTSIB);
+		xfs_btree_log_block(cur, rrbp, XFS_BB_LEFTSIB);
+	}
+	/*
+	 * If the cursor is really in the right block, move it there.
+	 * If it's just pointing past the last entry in left, then we'll
+	 * insert there, so don't change anything in that case.
+	 */
+	if (cur->bc_ptrs[level] > lrecs + 1) {
+		xfs_btree_setbuf(cur, level, rbp);
+		cur->bc_ptrs[level] -= lrecs;
+	}
+	/*
+	 * If there are more levels, we'll need another cursor which refers
+	 * the right block, no matter where this cursor was.
+	 */
+	if (level + 1 < cur->bc_nlevels) {
+		error = xfs_btree_dup_cursor(cur, curp);
+		if (error)
+			goto error0;
+		(*curp)->bc_ptrs[level + 1]++;
+	}
+	*ptrp = rptr;
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 0;
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+/*
+ * Copy the old inode root contents into a real block and make the
+ * broot point to it.
+ */
+int						/* error */
+xfs_btree_new_iroot(
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			*logflags,	/* logging flags for inode */
+	int			*stat)		/* return status - 0 fail */
+{
+	struct xfs_buf		*cbp;		/* buffer for cblock */
+	struct xfs_btree_block	*block;		/* btree block */
+	struct xfs_btree_block	*cblock;	/* child btree block */
+	union xfs_btree_key	*ckp;		/* child key pointer */
+	union xfs_btree_ptr	*cpp;		/* child ptr pointer */
+	union xfs_btree_key	*kp;		/* pointer to btree key */
+	union xfs_btree_ptr	*pp;		/* pointer to block addr */
+	union xfs_btree_ptr	nptr;		/* new block addr */
+	int			level;		/* btree level */
+	int			error;		/* error return code */
+#ifdef DEBUG
+	int			i;		/* loop counter */
+#endif
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_STATS_INC(cur, newroot);
+
+	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+
+	level = cur->bc_nlevels - 1;
+
+	block = xfs_btree_get_iroot(cur);
+	pp = xfs_btree_ptr_addr(cur, 1, block);
+
+	/* Allocate the new block. If we can't do it, we're toast. Give up. */
+	error = cur->bc_ops->alloc_block(cur, pp, &nptr, 1, stat);
+	if (error)
+		goto error0;
+	if (*stat == 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		return 0;
+	}
+	XFS_BTREE_STATS_INC(cur, alloc);
+
+	/* Copy the root into a real block. */
+	error = xfs_btree_get_buf_block(cur, &nptr, 0, &cblock, &cbp);
+	if (error)
+		goto error0;
+
+	memcpy(cblock, block, xfs_btree_block_len(cur));
+
+	be16_add_cpu(&block->bb_level, 1);
+	xfs_btree_set_numrecs(block, 1);
+	cur->bc_nlevels++;
+	cur->bc_ptrs[level + 1] = 1;
+
+	kp = xfs_btree_key_addr(cur, 1, block);
+	ckp = xfs_btree_key_addr(cur, 1, cblock);
+	xfs_btree_copy_keys(cur, ckp, kp, xfs_btree_get_numrecs(cblock));
+
+	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
+#ifdef DEBUG
+	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
+		error = xfs_btree_check_ptr(cur, pp, i, level);
+		if (error)
+			goto error0;
+	}
+#endif
+	xfs_btree_copy_ptrs(cur, cpp, pp, xfs_btree_get_numrecs(cblock));
+
+#ifdef DEBUG
+	error = xfs_btree_check_ptr(cur, &nptr, 0, level);
+	if (error)
+		goto error0;
+#endif
+	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
+
+	xfs_iroot_realloc(cur->bc_private.b.ip,
+			  1 - xfs_btree_get_numrecs(cblock),
+			  cur->bc_private.b.whichfork);
+
+	xfs_btree_setbuf(cur, level, cbp);
+
+	/*
+	 * Do all this logging at the end so that
+	 * the root is at the right level.
+	 */
+	xfs_btree_log_block(cur, cbp, XFS_BB_ALL_BITS);
+	xfs_btree_log_keys(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
+	xfs_btree_log_ptrs(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
+
+	*logflags |=
+		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork);
+	*stat = 1;
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+/*
+ * Allocate a new root block, fill it in.
+ */
+STATIC int				/* error */
+xfs_btree_new_root(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	int			*stat)	/* success/failure */
+{
+	struct xfs_btree_block	*block;	/* one half of the old root block */
+	struct xfs_buf		*bp;	/* buffer containing block */
+	int			error;	/* error return value */
+	struct xfs_buf		*lbp;	/* left buffer pointer */
+	struct xfs_btree_block	*left;	/* left btree block */
+	struct xfs_buf		*nbp;	/* new (root) buffer */
+	struct xfs_btree_block	*new;	/* new (root) btree block */
+	int			nptr;	/* new value for key index, 1 or 2 */
+	struct xfs_buf		*rbp;	/* right buffer pointer */
+	struct xfs_btree_block	*right;	/* right btree block */
+	union xfs_btree_ptr	rptr;
+	union xfs_btree_ptr	lptr;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_STATS_INC(cur, newroot);
+
+	/* initialise our start point from the cursor */
+	cur->bc_ops->init_ptr_from_cur(cur, &rptr);
+
+	/* Allocate the new block. If we can't do it, we're toast. Give up. */
+	error = cur->bc_ops->alloc_block(cur, &rptr, &lptr, 1, stat);
+	if (error)
+		goto error0;
+	if (*stat == 0)
+		goto out0;
+	XFS_BTREE_STATS_INC(cur, alloc);
+
+	/* Set up the new block. */
+	error = xfs_btree_get_buf_block(cur, &lptr, 0, &new, &nbp);
+	if (error)
+		goto error0;
+
+	/* Set the root in the holding structure  increasing the level by 1. */
+	cur->bc_ops->set_root(cur, &lptr, 1);
+
+	/*
+	 * At the previous root level there are now two blocks: the old root,
+	 * and the new block generated when it was split.  We don't know which
+	 * one the cursor is pointing at, so we set up variables "left" and
+	 * "right" for each case.
+	 */
+	block = xfs_btree_get_block(cur, cur->bc_nlevels - 1, &bp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, cur->bc_nlevels - 1, bp);
+	if (error)
+		goto error0;
+#endif
+
+	xfs_btree_get_sibling(cur, block, &rptr, XFS_BB_RIGHTSIB);
+	if (!xfs_btree_ptr_is_null(cur, &rptr)) {
+		/* Our block is left, pick up the right block. */
+		lbp = bp;
+		xfs_btree_buf_to_ptr(cur, lbp, &lptr);
+		left = block;
+		error = xfs_btree_read_buf_block(cur, &rptr,
+					cur->bc_nlevels - 1, 0, &right, &rbp);
+		if (error)
+			goto error0;
+		bp = rbp;
+		nptr = 1;
+	} else {
+		/* Our block is right, pick up the left block. */
+		rbp = bp;
+		xfs_btree_buf_to_ptr(cur, rbp, &rptr);
+		right = block;
+		xfs_btree_get_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
+		error = xfs_btree_read_buf_block(cur, &lptr,
+					cur->bc_nlevels - 1, 0, &left, &lbp);
+		if (error)
+			goto error0;
+		bp = lbp;
+		nptr = 2;
+	}
+	/* Fill in the new block's btree header and log it. */
+	xfs_btree_init_block(cur, cur->bc_nlevels, 2, new);
+	xfs_btree_log_block(cur, nbp, XFS_BB_ALL_BITS);
+	ASSERT(!xfs_btree_ptr_is_null(cur, &lptr) &&
+			!xfs_btree_ptr_is_null(cur, &rptr));
+
+	/* Fill in the key data in the new root. */
+	if (xfs_btree_get_level(left) > 0) {
+		xfs_btree_copy_keys(cur,
+				xfs_btree_key_addr(cur, 1, new),
+				xfs_btree_key_addr(cur, 1, left), 1);
+		xfs_btree_copy_keys(cur,
+				xfs_btree_key_addr(cur, 2, new),
+				xfs_btree_key_addr(cur, 1, right), 1);
+	} else {
+		cur->bc_ops->init_key_from_rec(
+				xfs_btree_key_addr(cur, 1, new),
+				xfs_btree_rec_addr(cur, 1, left));
+		cur->bc_ops->init_key_from_rec(
+				xfs_btree_key_addr(cur, 2, new),
+				xfs_btree_rec_addr(cur, 1, right));
+	}
+	xfs_btree_log_keys(cur, nbp, 1, 2);
+
+	/* Fill in the pointer data in the new root. */
+	xfs_btree_copy_ptrs(cur,
+		xfs_btree_ptr_addr(cur, 1, new), &lptr, 1);
+	xfs_btree_copy_ptrs(cur,
+		xfs_btree_ptr_addr(cur, 2, new), &rptr, 1);
+	xfs_btree_log_ptrs(cur, nbp, 1, 2);
+
+	/* Fix up the cursor. */
+	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
+	cur->bc_ptrs[cur->bc_nlevels] = nptr;
+	cur->bc_nlevels++;
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 0;
+	return 0;
+}
+
+STATIC int
+xfs_btree_make_block_unfull(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	int			level,	/* btree level */
+	int			numrecs,/* # of recs in block */
+	int			*oindex,/* old tree index */
+	int			*index,	/* new tree index */
+	union xfs_btree_ptr	*nptr,	/* new btree ptr */
+	struct xfs_btree_cur	**ncur,	/* new btree cursor */
+	union xfs_btree_rec	*nrec,	/* new record */
+	int			*stat)
+{
+	union xfs_btree_key	key;	/* new btree key value */
+	int			error = 0;
+
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    level == cur->bc_nlevels - 1) {
+	    	struct xfs_inode *ip = cur->bc_private.b.ip;
+
+		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
+			/* A root block that can be made bigger. */
+
+			xfs_iroot_realloc(ip, 1, cur->bc_private.b.whichfork);
+		} else {
+			/* A root block that needs replacing */
+			int	logflags = 0;
+
+			error = xfs_btree_new_iroot(cur, &logflags, stat);
+			if (error || *stat == 0)
+				return error;
+
+			xfs_trans_log_inode(cur->bc_tp, ip, logflags);
+		}
+
+		return 0;
+	}
+
+	/* First, try shifting an entry to the right neighbor. */
+	error = xfs_btree_rshift(cur, level, stat);
+	if (error || *stat)
+		return error;
+
+	/* Next, try shifting an entry to the left neighbor. */
+	error = xfs_btree_lshift(cur, level, stat);
+	if (error)
+		return error;
+
+	if (*stat) {
+		*oindex = *index = cur->bc_ptrs[level];
+		return 0;
+	}
+
+	/*
+	 * Next, try splitting the current block in half.
+	 *
+	 * If this works we have to re-set our variables because we
+	 * could be in a different block now.
+	 */
+	error = xfs_btree_split(cur, level, nptr, &key, ncur, stat);
+	if (error || *stat == 0)
+		return error;
+
+
+	*index = cur->bc_ptrs[level];
+	cur->bc_ops->init_rec_from_key(&key, nrec);
+	return 0;
+}
+
+/*
+ * Insert one record/level.  Return information to the caller
+ * allowing the next level up to proceed if necessary.
+ */
+STATIC int
+xfs_btree_insrec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	int			level,	/* level to insert record at */
+	union xfs_btree_ptr	*ptrp,	/* i/o: block number inserted */
+	union xfs_btree_rec	*recp,	/* i/o: record data inserted */
+	struct xfs_btree_cur	**curp,	/* output: new cursor replacing cur */
+	int			*stat)	/* success/failure */
+{
+	struct xfs_btree_block	*block;	/* btree block */
+	struct xfs_buf		*bp;	/* buffer for block */
+	union xfs_btree_key	key;	/* btree key */
+	union xfs_btree_ptr	nptr;	/* new block ptr */
+	struct xfs_btree_cur	*ncur;	/* new btree cursor */
+	union xfs_btree_rec	nrec;	/* new record count */
+	int			optr;	/* old key/record index */
+	int			ptr;	/* key/record index */
+	int			numrecs;/* number of records */
+	int			error;	/* error return value */
+#ifdef DEBUG
+	int			i;
+#endif
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGIPR(cur, level, *ptrp, recp);
+
+	ncur = NULL;
+
+	/*
+	 * If we have an external root pointer, and we've made it to the
+	 * root level, allocate a new root block and we're done.
+	 */
+	if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (level >= cur->bc_nlevels)) {
+		error = xfs_btree_new_root(cur, stat);
+		xfs_btree_set_ptr_null(cur, ptrp);
+
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		return error;
+	}
+
+	/* If we're off the left edge, return failure. */
+	ptr = cur->bc_ptrs[level];
+	if (ptr == 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+
+	/* Make a key out of the record data to be inserted, and save it. */
+	cur->bc_ops->init_key_from_rec(&key, recp);
+
+	optr = ptr;
+
+	XFS_BTREE_STATS_INC(cur, insrec);
+
+	/* Get pointers to the btree buffer and block. */
+	block = xfs_btree_get_block(cur, level, &bp);
+	numrecs = xfs_btree_get_numrecs(block);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, level, bp);
+	if (error)
+		goto error0;
+
+	/* Check that the new entry is being inserted in the right place. */
+	if (ptr <= numrecs) {
+		if (level == 0) {
+			ASSERT(cur->bc_ops->recs_inorder(cur, recp,
+				xfs_btree_rec_addr(cur, ptr, block)));
+		} else {
+			ASSERT(cur->bc_ops->keys_inorder(cur, &key,
+				xfs_btree_key_addr(cur, ptr, block)));
+		}
+	}
+#endif
+
+	/*
+	 * If the block is full, we can't insert the new entry until we
+	 * make the block un-full.
+	 */
+	xfs_btree_set_ptr_null(cur, &nptr);
+	if (numrecs == cur->bc_ops->get_maxrecs(cur, level)) {
+		error = xfs_btree_make_block_unfull(cur, level, numrecs,
+					&optr, &ptr, &nptr, &ncur, &nrec, stat);
+		if (error || *stat == 0)
+			goto error0;
+	}
+
+	/*
+	 * The current block may have changed if the block was
+	 * previously full and we have just made space in it.
+	 */
+	block = xfs_btree_get_block(cur, level, &bp);
+	numrecs = xfs_btree_get_numrecs(block);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, level, bp);
+	if (error)
+		return error;
+#endif
+
+	/*
+	 * At this point we know there's room for our new entry in the block
+	 * we're pointing at.
+	 */
+	XFS_BTREE_STATS_ADD(cur, moves, numrecs - ptr + 1);
+
+	if (level > 0) {
+		/* It's a nonleaf. make a hole in the keys and ptrs */
+		union xfs_btree_key	*kp;
+		union xfs_btree_ptr	*pp;
+
+		kp = xfs_btree_key_addr(cur, ptr, block);
+		pp = xfs_btree_ptr_addr(cur, ptr, block);
+
+#ifdef DEBUG
+		for (i = numrecs - ptr; i >= 0; i--) {
+			error = xfs_btree_check_ptr(cur, pp, i, level);
+			if (error)
+				return error;
+		}
+#endif
+
+		xfs_btree_shift_keys(cur, kp, 1, numrecs - ptr + 1);
+		xfs_btree_shift_ptrs(cur, pp, 1, numrecs - ptr + 1);
+
+#ifdef DEBUG
+		error = xfs_btree_check_ptr(cur, ptrp, 0, level);
+		if (error)
+			goto error0;
+#endif
+
+		/* Now put the new data in, bump numrecs and log it. */
+		xfs_btree_copy_keys(cur, kp, &key, 1);
+		xfs_btree_copy_ptrs(cur, pp, ptrp, 1);
+		numrecs++;
+		xfs_btree_set_numrecs(block, numrecs);
+		xfs_btree_log_ptrs(cur, bp, ptr, numrecs);
+		xfs_btree_log_keys(cur, bp, ptr, numrecs);
+#ifdef DEBUG
+		if (ptr < numrecs) {
+			ASSERT(cur->bc_ops->keys_inorder(cur, kp,
+				xfs_btree_key_addr(cur, ptr + 1, block)));
+		}
+#endif
+	} else {
+		/* It's a leaf. make a hole in the records */
+		union xfs_btree_rec             *rp;
+
+		rp = xfs_btree_rec_addr(cur, ptr, block);
+
+		xfs_btree_shift_recs(cur, rp, 1, numrecs - ptr + 1);
+
+		/* Now put the new data in, bump numrecs and log it. */
+		xfs_btree_copy_recs(cur, rp, recp, 1);
+		xfs_btree_set_numrecs(block, ++numrecs);
+		xfs_btree_log_recs(cur, bp, ptr, numrecs);
+#ifdef DEBUG
+		if (ptr < numrecs) {
+			ASSERT(cur->bc_ops->recs_inorder(cur, rp,
+				xfs_btree_rec_addr(cur, ptr + 1, block)));
+		}
+#endif
+	}
+
+	/* Log the new number of records in the btree header. */
+	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
+
+	/* If we inserted at the start of a block, update the parents' keys. */
+	if (optr == 1) {
+		error = xfs_btree_updkey(cur, &key, level + 1);
+		if (error)
+			goto error0;
+	}
+
+	/*
+	 * If we are tracking the last record in the tree and
+	 * we are at the far right edge of the tree, update it.
+	 */
+	if (xfs_btree_is_lastrec(cur, block, level)) {
+		cur->bc_ops->update_lastrec(cur, block, recp,
+					    ptr, LASTREC_INSREC);
+	}
+
+	/*
+	 * Return the new block number, if any.
+	 * If there is one, give back a record value and a cursor too.
+	 */
+	*ptrp = nptr;
+	if (!xfs_btree_ptr_is_null(cur, &nptr)) {
+		*recp = nrec;
+		*curp = ncur;
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+/*
+ * Insert the record at the point referenced by cur.
+ *
+ * A multi-level split of the tree on insert will invalidate the original
+ * cursor.  All callers of this function should assume that the cursor is
+ * no longer valid and revalidate it.
+ */
+int
+xfs_btree_insert(
+	struct xfs_btree_cur	*cur,
+	int			*stat)
+{
+	int			error;	/* error return value */
+	int			i;	/* result value, 0 for failure */
+	int			level;	/* current level number in btree */
+	union xfs_btree_ptr	nptr;	/* new block number (split result) */
+	struct xfs_btree_cur	*ncur;	/* new cursor (split result) */
+	struct xfs_btree_cur	*pcur;	/* previous level's cursor */
+	union xfs_btree_rec	rec;	/* record to insert */
+
+	level = 0;
+	ncur = NULL;
+	pcur = cur;
+
+	xfs_btree_set_ptr_null(cur, &nptr);
+	cur->bc_ops->init_rec_from_cur(cur, &rec);
+
+	/*
+	 * Loop going up the tree, starting at the leaf level.
+	 * Stop when we don't get a split block, that must mean that
+	 * the insert is finished with this level.
+	 */
+	do {
+		/*
+		 * Insert nrec/nptr into this level of the tree.
+		 * Note if we fail, nptr will be null.
+		 */
+		error = xfs_btree_insrec(pcur, level, &nptr, &rec, &ncur, &i);
+		if (error) {
+			if (pcur != cur)
+				xfs_btree_del_cursor(pcur, XFS_BTREE_ERROR);
+			goto error0;
+		}
+
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		level++;
+
+		/*
+		 * See if the cursor we just used is trash.
+		 * Can't trash the caller's cursor, but otherwise we should
+		 * if ncur is a new cursor or we're about to be done.
+		 */
+		if (pcur != cur &&
+		    (ncur || xfs_btree_ptr_is_null(cur, &nptr))) {
+			/* Save the state from the cursor before we trash it */
+			if (cur->bc_ops->update_cursor)
+				cur->bc_ops->update_cursor(pcur, cur);
+			cur->bc_nlevels = pcur->bc_nlevels;
+			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
+		}
+		/* If we got a new cursor, switch to it. */
+		if (ncur) {
+			pcur = ncur;
+			ncur = NULL;
+		}
+	} while (!xfs_btree_ptr_is_null(cur, &nptr));
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = i;
+	return 0;
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+/*
+ * Try to merge a non-leaf block back into the inode root.
+ *
+ * Note: the killroot names comes from the fact that we're effectively
+ * killing the old root block.  But because we can't just delete the
+ * inode we have to copy the single block it was pointing to into the
+ * inode.
+ */
+int
+xfs_btree_kill_iroot(
+	struct xfs_btree_cur	*cur)
+{
+	int			whichfork = cur->bc_private.b.whichfork;
+	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_btree_block	*block;
+	struct xfs_btree_block	*cblock;
+	union xfs_btree_key	*kp;
+	union xfs_btree_key	*ckp;
+	union xfs_btree_ptr	*pp;
+	union xfs_btree_ptr	*cpp;
+	struct xfs_buf		*cbp;
+	int			level;
+	int			index;
+	int			numrecs;
+#ifdef DEBUG
+	union xfs_btree_ptr	ptr;
+	int			i;
+#endif
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+
+	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+	ASSERT(cur->bc_nlevels > 1);
+
+	/*
+	 * Don't deal with the root block needs to be a leaf case.
+	 * We're just going to turn the thing back into extents anyway.
+	 */
+	level = cur->bc_nlevels - 1;
+	if (level == 1)
+		goto out0;
+
+	/*
+	 * Give up if the root has multiple children.
+	 */
+	block = xfs_btree_get_iroot(cur);
+	if (xfs_btree_get_numrecs(block) != 1)
+		goto out0;
+
+	cblock = xfs_btree_get_block(cur, level - 1, &cbp);
+	numrecs = xfs_btree_get_numrecs(cblock);
+
+	/*
+	 * Only do this if the next level will fit.
+	 * Then the data must be copied up to the inode,
+	 * instead of freeing the root you free the next level.
+	 */
+	if (numrecs > cur->bc_ops->get_dmaxrecs(cur, level))
+		goto out0;
+
+	XFS_BTREE_STATS_INC(cur, killroot);
+
+#ifdef DEBUG
+	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_LEFTSIB);
+	ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
+	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
+	ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
+#endif
+
+	index = numrecs - cur->bc_ops->get_maxrecs(cur, level);
+	if (index) {
+		xfs_iroot_realloc(cur->bc_private.b.ip, index,
+				  cur->bc_private.b.whichfork);
+		block = (struct xfs_btree_block *)ifp->if_broot;
+	}
+
+	be16_add_cpu(&block->bb_numrecs, index);
+	ASSERT(block->bb_numrecs == cblock->bb_numrecs);
+
+	kp = xfs_btree_key_addr(cur, 1, block);
+	ckp = xfs_btree_key_addr(cur, 1, cblock);
+	xfs_btree_copy_keys(cur, kp, ckp, numrecs);
+
+	pp = xfs_btree_ptr_addr(cur, 1, block);
+	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
+#ifdef DEBUG
+	for (i = 0; i < numrecs; i++) {
+		int		error;
+
+		error = xfs_btree_check_ptr(cur, cpp, i, level - 1);
+		if (error) {
+			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+			return error;
+		}
+	}
+#endif
+	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
+
+	cur->bc_ops->free_block(cur, cbp);
+	XFS_BTREE_STATS_INC(cur, free);
+
+	cur->bc_bufs[level - 1] = NULL;
+	be16_add_cpu(&block->bb_level, -1);
+	xfs_trans_log_inode(cur->bc_tp, ip,
+		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+	cur->bc_nlevels--;
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+}
+
+STATIC int
+xfs_btree_dec_cursor(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			*stat)
+{
+	int			error;
+	int			i;
+
+	if (level > 0) {
+		error = xfs_btree_decrement(cur, level, &i);
+		if (error)
+			return error;
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+}
+
+/*
+ * Single level of the btree record deletion routine.
+ * Delete record pointed to by cur/level.
+ * Remove the record from its block then rebalance the tree.
+ * Return 0 for error, 1 for done, 2 to go on to the next level.
+ */
+STATIC int					/* error */
+xfs_btree_delrec(
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			level,		/* level removing record from */
+	int			*stat)		/* fail/done/go-on */
+{
+	struct xfs_btree_block	*block;		/* btree block */
+	union xfs_btree_ptr	cptr;		/* current block ptr */
+	struct xfs_buf		*bp;		/* buffer for block */
+	int			error;		/* error return value */
+	int			i;		/* loop counter */
+	union xfs_btree_key	key;		/* storage for keyp */
+	union xfs_btree_key	*keyp = &key;	/* passed to the next level */
+	union xfs_btree_ptr	lptr;		/* left sibling block ptr */
+	struct xfs_buf		*lbp;		/* left buffer pointer */
+	struct xfs_btree_block	*left;		/* left btree block */
+	int			lrecs = 0;	/* left record count */
+	int			ptr;		/* key/record index */
+	union xfs_btree_ptr	rptr;		/* right sibling block ptr */
+	struct xfs_buf		*rbp;		/* right buffer pointer */
+	struct xfs_btree_block	*right;		/* right btree block */
+	struct xfs_btree_block	*rrblock;	/* right-right btree block */
+	struct xfs_buf		*rrbp;		/* right-right buffer pointer */
+	int			rrecs = 0;	/* right record count */
+	struct xfs_btree_cur	*tcur;		/* temporary btree cursor */
+	int			numrecs;	/* temporary numrec count */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+
+	tcur = NULL;
+
+	/* Get the index of the entry being deleted, check for nothing there. */
+	ptr = cur->bc_ptrs[level];
+	if (ptr == 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+
+	/* Get the buffer & block containing the record or key/ptr. */
+	block = xfs_btree_get_block(cur, level, &bp);
+	numrecs = xfs_btree_get_numrecs(block);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, level, bp);
+	if (error)
+		goto error0;
+#endif
+
+	/* Fail if we're off the end of the block. */
+	if (ptr > numrecs) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+
+	XFS_BTREE_STATS_INC(cur, delrec);
+	XFS_BTREE_STATS_ADD(cur, moves, numrecs - ptr);
+
+	/* Excise the entries being deleted. */
+	if (level > 0) {
+		/* It's a nonleaf. operate on keys and ptrs */
+		union xfs_btree_key	*lkp;
+		union xfs_btree_ptr	*lpp;
+
+		lkp = xfs_btree_key_addr(cur, ptr + 1, block);
+		lpp = xfs_btree_ptr_addr(cur, ptr + 1, block);
+
+#ifdef DEBUG
+		for (i = 0; i < numrecs - ptr; i++) {
+			error = xfs_btree_check_ptr(cur, lpp, i, level);
+			if (error)
+				goto error0;
+		}
+#endif
+
+		if (ptr < numrecs) {
+			xfs_btree_shift_keys(cur, lkp, -1, numrecs - ptr);
+			xfs_btree_shift_ptrs(cur, lpp, -1, numrecs - ptr);
+			xfs_btree_log_keys(cur, bp, ptr, numrecs - 1);
+			xfs_btree_log_ptrs(cur, bp, ptr, numrecs - 1);
+		}
+
+		/*
+		 * If it's the first record in the block, we'll need to pass a
+		 * key up to the next level (updkey).
+		 */
+		if (ptr == 1)
+			keyp = xfs_btree_key_addr(cur, 1, block);
+	} else {
+		/* It's a leaf. operate on records */
+		if (ptr < numrecs) {
+			xfs_btree_shift_recs(cur,
+				xfs_btree_rec_addr(cur, ptr + 1, block),
+				-1, numrecs - ptr);
+			xfs_btree_log_recs(cur, bp, ptr, numrecs - 1);
+		}
+
+		/*
+		 * If it's the first record in the block, we'll need a key
+		 * structure to pass up to the next level (updkey).
+		 */
+		if (ptr == 1) {
+			cur->bc_ops->init_key_from_rec(&key,
+					xfs_btree_rec_addr(cur, 1, block));
+			keyp = &key;
+		}
+	}
+
+	/*
+	 * Decrement and log the number of entries in the block.
+	 */
+	xfs_btree_set_numrecs(block, --numrecs);
+	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
+
+	/*
+	 * If we are tracking the last record in the tree and
+	 * we are at the far right edge of the tree, update it.
+	 */
+	if (xfs_btree_is_lastrec(cur, block, level)) {
+		cur->bc_ops->update_lastrec(cur, block, NULL,
+					    ptr, LASTREC_DELREC);
+	}
+
+	/*
+	 * We're at the root level.  First, shrink the root block in-memory.
+	 * Try to get rid of the next level down.  If we can't then there's
+	 * nothing left to do.
+	 */
+	if (level == cur->bc_nlevels - 1) {
+		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+			xfs_iroot_realloc(cur->bc_private.b.ip, -1,
+					  cur->bc_private.b.whichfork);
+
+			error = xfs_btree_kill_iroot(cur);
+			if (error)
+				goto error0;
+
+			error = xfs_btree_dec_cursor(cur, level, stat);
+			if (error)
+				goto error0;
+			*stat = 1;
+			return 0;
+		}
+
+		/*
+		 * If this is the root level, and there's only one entry left,
+		 * and it's NOT the leaf level, then we can get rid of this
+		 * level.
+		 */
+		if (numrecs == 1 && level > 0) {
+			union xfs_btree_ptr	*pp;
+			/*
+			 * pp is still set to the first pointer in the block.
+			 * Make it the new root of the btree.
+			 */
+			pp = xfs_btree_ptr_addr(cur, 1, block);
+			error = cur->bc_ops->kill_root(cur, bp, level, pp);
+			if (error)
+				goto error0;
+		} else if (level > 0) {
+			error = xfs_btree_dec_cursor(cur, level, stat);
+			if (error)
+				goto error0;
+		}
+		*stat = 1;
+		return 0;
+	}
+
+	/*
+	 * If we deleted the leftmost entry in the block, update the
+	 * key values above us in the tree.
+	 */
+	if (ptr == 1) {
+		error = xfs_btree_updkey(cur, keyp, level + 1);
+		if (error)
+			goto error0;
+	}
+
+	/*
+	 * If the number of records remaining in the block is at least
+	 * the minimum, we're done.
+	 */
+	if (numrecs >= cur->bc_ops->get_minrecs(cur, level)) {
+		error = xfs_btree_dec_cursor(cur, level, stat);
+		if (error)
+			goto error0;
+		return 0;
+	}
+
+	/*
+	 * Otherwise, we have to move some records around to keep the
+	 * tree balanced.  Look at the left and right sibling blocks to
+	 * see if we can re-balance by moving only one record.
+	 */
+	xfs_btree_get_sibling(cur, block, &rptr, XFS_BB_RIGHTSIB);
+	xfs_btree_get_sibling(cur, block, &lptr, XFS_BB_LEFTSIB);
+
+	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		/*
+		 * One child of root, need to get a chance to copy its contents
+		 * into the root and delete it. Can't go up to next level,
+		 * there's nothing to delete there.
+		 */
+		if (xfs_btree_ptr_is_null(cur, &rptr) &&
+		    xfs_btree_ptr_is_null(cur, &lptr) &&
+		    level == cur->bc_nlevels - 2) {
+			error = xfs_btree_kill_iroot(cur);
+			if (!error)
+				error = xfs_btree_dec_cursor(cur, level, stat);
+			if (error)
+				goto error0;
+			return 0;
+		}
+	}
+
+	ASSERT(!xfs_btree_ptr_is_null(cur, &rptr) ||
+	       !xfs_btree_ptr_is_null(cur, &lptr));
+
+	/*
+	 * Duplicate the cursor so our btree manipulations here won't
+	 * disrupt the next level up.
+	 */
+	error = xfs_btree_dup_cursor(cur, &tcur);
+	if (error)
+		goto error0;
+
+	/*
+	 * If there's a right sibling, see if it's ok to shift an entry
+	 * out of it.
+	 */
+	if (!xfs_btree_ptr_is_null(cur, &rptr)) {
+		/*
+		 * Move the temp cursor to the last entry in the next block.
+		 * Actually any entry but the first would suffice.
+		 */
+		i = xfs_btree_lastrec(tcur, level);
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		error = xfs_btree_increment(tcur, level, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		i = xfs_btree_lastrec(tcur, level);
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		/* Grab a pointer to the block. */
+		right = xfs_btree_get_block(tcur, level, &rbp);
+#ifdef DEBUG
+		error = xfs_btree_check_block(tcur, right, level, rbp);
+		if (error)
+			goto error0;
+#endif
+		/* Grab the current block number, for future use. */
+		xfs_btree_get_sibling(tcur, right, &cptr, XFS_BB_LEFTSIB);
+
+		/*
+		 * If right block is full enough so that removing one entry
+		 * won't make it too empty, and left-shifting an entry out
+		 * of right to us works, we're done.
+		 */
+		if (xfs_btree_get_numrecs(right) - 1 >=
+		    cur->bc_ops->get_minrecs(tcur, level)) {
+			error = xfs_btree_lshift(tcur, level, &i);
+			if (error)
+				goto error0;
+			if (i) {
+				ASSERT(xfs_btree_get_numrecs(block) >=
+				       cur->bc_ops->get_minrecs(tcur, level));
+
+				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+				tcur = NULL;
+
+				error = xfs_btree_dec_cursor(cur, level, stat);
+				if (error)
+					goto error0;
+				return 0;
+			}
+		}
+
+		/*
+		 * Otherwise, grab the number of records in right for
+		 * future reference, and fix up the temp cursor to point
+		 * to our block again (last record).
+		 */
+		rrecs = xfs_btree_get_numrecs(right);
+		if (!xfs_btree_ptr_is_null(cur, &lptr)) {
+			i = xfs_btree_firstrec(tcur, level);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+			error = xfs_btree_decrement(tcur, level, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		}
+	}
+
+	/*
+	 * If there's a left sibling, see if it's ok to shift an entry
+	 * out of it.
+	 */
+	if (!xfs_btree_ptr_is_null(cur, &lptr)) {
+		/*
+		 * Move the temp cursor to the first entry in the
+		 * previous block.
+		 */
+		i = xfs_btree_firstrec(tcur, level);
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		error = xfs_btree_decrement(tcur, level, &i);
+		if (error)
+			goto error0;
+		i = xfs_btree_firstrec(tcur, level);
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		/* Grab a pointer to the block. */
+		left = xfs_btree_get_block(tcur, level, &lbp);
+#ifdef DEBUG
+		error = xfs_btree_check_block(cur, left, level, lbp);
+		if (error)
+			goto error0;
+#endif
+		/* Grab the current block number, for future use. */
+		xfs_btree_get_sibling(tcur, left, &cptr, XFS_BB_RIGHTSIB);
+
+		/*
+		 * If left block is full enough so that removing one entry
+		 * won't make it too empty, and right-shifting an entry out
+		 * of left to us works, we're done.
+		 */
+		if (xfs_btree_get_numrecs(left) - 1 >=
+		    cur->bc_ops->get_minrecs(tcur, level)) {
+			error = xfs_btree_rshift(tcur, level, &i);
+			if (error)
+				goto error0;
+			if (i) {
+				ASSERT(xfs_btree_get_numrecs(block) >=
+				       cur->bc_ops->get_minrecs(tcur, level));
+				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+				tcur = NULL;
+				if (level == 0)
+					cur->bc_ptrs[0]++;
+				XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+				*stat = 1;
+				return 0;
+			}
+		}
+
+		/*
+		 * Otherwise, grab the number of records in right for
+		 * future reference.
+		 */
+		lrecs = xfs_btree_get_numrecs(left);
+	}
+
+	/* Delete the temp cursor, we're done with it. */
+	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+	tcur = NULL;
+
+	/* If here, we need to do a join to keep the tree balanced. */
+	ASSERT(!xfs_btree_ptr_is_null(cur, &cptr));
+
+	if (!xfs_btree_ptr_is_null(cur, &lptr) &&
+	    lrecs + xfs_btree_get_numrecs(block) <=
+			cur->bc_ops->get_maxrecs(cur, level)) {
+		/*
+		 * Set "right" to be the starting block,
+		 * "left" to be the left neighbor.
+		 */
+		rptr = cptr;
+		right = block;
+		rbp = bp;
+		error = xfs_btree_read_buf_block(cur, &lptr, level,
+							0, &left, &lbp);
+		if (error)
+			goto error0;
+
+	/*
+	 * If that won't work, see if we can join with the right neighbor block.
+	 */
+	} else if (!xfs_btree_ptr_is_null(cur, &rptr) &&
+		   rrecs + xfs_btree_get_numrecs(block) <=
+			cur->bc_ops->get_maxrecs(cur, level)) {
+		/*
+		 * Set "left" to be the starting block,
+		 * "right" to be the right neighbor.
+		 */
+		lptr = cptr;
+		left = block;
+		lbp = bp;
+		error = xfs_btree_read_buf_block(cur, &rptr, level,
+							0, &right, &rbp);
+		if (error)
+			goto error0;
+
+	/*
+	 * Otherwise, we can't fix the imbalance.
+	 * Just return.  This is probably a logic error, but it's not fatal.
+	 */
+	} else {
+		error = xfs_btree_dec_cursor(cur, level, stat);
+		if (error)
+			goto error0;
+		return 0;
+	}
+
+	rrecs = xfs_btree_get_numrecs(right);
+	lrecs = xfs_btree_get_numrecs(left);
+
+	/*
+	 * We're now going to join "left" and "right" by moving all the stuff
+	 * in "right" to "left" and deleting "right".
+	 */
+	XFS_BTREE_STATS_ADD(cur, moves, rrecs);
+	if (level > 0) {
+		/* It's a non-leaf.  Move keys and pointers. */
+		union xfs_btree_key	*lkp;	/* left btree key */
+		union xfs_btree_ptr	*lpp;	/* left address pointer */
+		union xfs_btree_key	*rkp;	/* right btree key */
+		union xfs_btree_ptr	*rpp;	/* right address pointer */
+
+		lkp = xfs_btree_key_addr(cur, lrecs + 1, left);
+		lpp = xfs_btree_ptr_addr(cur, lrecs + 1, left);
+		rkp = xfs_btree_key_addr(cur, 1, right);
+		rpp = xfs_btree_ptr_addr(cur, 1, right);
+#ifdef DEBUG
+		for (i = 1; i < rrecs; i++) {
+			error = xfs_btree_check_ptr(cur, rpp, i, level);
+			if (error)
+				goto error0;
+		}
+#endif
+		xfs_btree_copy_keys(cur, lkp, rkp, rrecs);
+		xfs_btree_copy_ptrs(cur, lpp, rpp, rrecs);
+
+		xfs_btree_log_keys(cur, lbp, lrecs + 1, lrecs + rrecs);
+		xfs_btree_log_ptrs(cur, lbp, lrecs + 1, lrecs + rrecs);
+	} else {
+		/* It's a leaf.  Move records.  */
+		union xfs_btree_rec	*lrp;	/* left record pointer */
+		union xfs_btree_rec	*rrp;	/* right record pointer */
+
+		lrp = xfs_btree_rec_addr(cur, lrecs + 1, left);
+		rrp = xfs_btree_rec_addr(cur, 1, right);
+
+		xfs_btree_copy_recs(cur, lrp, rrp, rrecs);
+		xfs_btree_log_recs(cur, lbp, lrecs + 1, lrecs + rrecs);
+	}
+
+	XFS_BTREE_STATS_INC(cur, join);
+
+	/*
+	 * Fix up the the number of records and right block pointer in the
+	 * surviving block, and log it.
+	 */
+	xfs_btree_set_numrecs(left, lrecs + rrecs);
+	xfs_btree_get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB),
+	xfs_btree_set_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
+	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
+
+	/* If there is a right sibling, point it to the remaining block. */
+	xfs_btree_get_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
+	if (!xfs_btree_ptr_is_null(cur, &cptr)) {
+		error = xfs_btree_read_buf_block(cur, &cptr, level,
+							0, &rrblock, &rrbp);
+		if (error)
+			goto error0;
+		xfs_btree_set_sibling(cur, rrblock, &lptr, XFS_BB_LEFTSIB);
+		xfs_btree_log_block(cur, rrbp, XFS_BB_LEFTSIB);
+	}
+
+	/* Free the deleted block. */
+	error = cur->bc_ops->free_block(cur, rbp);
+	if (error)
+		goto error0;
+	XFS_BTREE_STATS_INC(cur, free);
+
+	/*
+	 * If we joined with the left neighbor, set the buffer in the
+	 * cursor to the left block, and fix up the index.
+	 */
+	if (bp != lbp) {
+		cur->bc_bufs[level] = lbp;
+		cur->bc_ptrs[level] += lrecs;
+		cur->bc_ra[level] = 0;
+	}
+	/*
+	 * If we joined with the right neighbor and there's a level above
+	 * us, increment the cursor at that level.
+	 */
+	else if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) ||
+		   (level + 1 < cur->bc_nlevels)) {
+		error = xfs_btree_increment(cur, level + 1, &i);
+		if (error)
+			goto error0;
+	}
+
+	/*
+	 * Readjust the ptr at this level if it's not a leaf, since it's
+	 * still pointing at the deletion point, which makes the cursor
+	 * inconsistent.  If this makes the ptr 0, the caller fixes it up.
+	 * We can't use decrement because it would change the next level up.
+	 */
+	if (level > 0)
+		cur->bc_ptrs[level]--;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	/* Return value means the next level up has something to do. */
+	*stat = 2;
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	if (tcur)
+		xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/*
+ * Delete the record pointed to by cur.
+ * The cursor refers to the place where the record was (could be inserted)
+ * when the operation returns.
+ */
+int					/* error */
+xfs_btree_delete(
+	struct xfs_btree_cur	*cur,
+	int			*stat)	/* success/failure */
+{
+	int			error;	/* error return value */
+	int			level;
+	int			i;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+
+	/*
+	 * Go up the tree, starting at leaf level.
+	 *
+	 * If 2 is returned then a join was done; go to the next level.
+	 * Otherwise we are done.
+	 */
+	for (level = 0, i = 2; i == 2; level++) {
+		error = xfs_btree_delrec(cur, level, &i);
+		if (error)
+			goto error0;
+	}
+
+	if (i == 0) {
+		for (level = 1; level < cur->bc_nlevels; level++) {
+			if (cur->bc_ptrs[level] == 0) {
+				error = xfs_btree_decrement(cur, level, &i);
+				if (error)
+					goto error0;
+				break;
+			}
+		}
+	}
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = i;
+	return 0;
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+int					/* error */
+xfs_btree_get_rec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	union xfs_btree_rec	**recp,	/* output: btree record */
+	int			*stat)	/* output: success/failure */
+{
+	struct xfs_btree_block	*block;	/* btree block */
+	struct xfs_buf		*bp;	/* buffer pointer */
+	int			ptr;	/* record number */
+#ifdef DEBUG
+	int			error;	/* error return value */
+#endif
+
+	ptr = cur->bc_ptrs[0];
+	block = xfs_btree_get_block(cur, 0, &bp);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, 0, bp);
+	if (error)
+		return error;
+#endif
+
+	/*
+	 * Off the right end or left end, return failure.
+	 */
+	if (ptr > xfs_btree_get_numrecs(block) || ptr <= 0) {
+		*stat = 0;
+		return 0;
+	}
+
+	/*
+	 * Point to the record and extract its data.
+	 */
+	*recp = xfs_btree_rec_addr(cur, ptr, block);
+	*stat = 1;
+	return 0;
+}
Index: xfs-cmds/xfsprogs/libxfs/xfs_ialloc.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_ialloc.c	2008-09-24 19:50:58.000000000 +0200
+++ xfs-cmds/xfsprogs/libxfs/xfs_ialloc.c	2008-09-24 20:01:15.000000000 +0200
@@ -100,6 +100,102 @@ xfs_ialloc_cluster_alignment(
 }
 
 /*
+ * Lookup the record equal to ino in the btree given by cur.
+ */
+STATIC int				/* error */
+xfs_inobt_lookup_eq(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agino_t		ino,	/* starting inode of chunk */
+	__int32_t		fcnt,	/* free inode count */
+	xfs_inofree_t		free,	/* free inode mask */
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.i.ir_startino = ino;
+	cur->bc_rec.i.ir_freecount = fcnt;
+	cur->bc_rec.i.ir_free = free;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
+}
+
+/*
+ * Lookup the first record greater than or equal to ino
+ * in the btree given by cur.
+ */
+int					/* error */
+xfs_inobt_lookup_ge(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agino_t		ino,	/* starting inode of chunk */
+	__int32_t		fcnt,	/* free inode count */
+	xfs_inofree_t		free,	/* free inode mask */
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.i.ir_startino = ino;
+	cur->bc_rec.i.ir_freecount = fcnt;
+	cur->bc_rec.i.ir_free = free;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
+}
+
+/*
+ * Lookup the first record less than or equal to ino
+ * in the btree given by cur.
+ */
+int					/* error */
+xfs_inobt_lookup_le(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agino_t		ino,	/* starting inode of chunk */
+	__int32_t		fcnt,	/* free inode count */
+	xfs_inofree_t		free,	/* free inode mask */
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.i.ir_startino = ino;
+	cur->bc_rec.i.ir_freecount = fcnt;
+	cur->bc_rec.i.ir_free = free;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+}
+
+/*
+ * Update the record referred to by cur to the value given
+ * by [ino, fcnt, free].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int				/* error */
+xfs_inobt_update(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agino_t		ino,	/* starting inode of chunk */
+	__int32_t		fcnt,	/* free inode count */
+	xfs_inofree_t		free)	/* free inode mask */
+{
+	union xfs_btree_rec	rec;
+
+	rec.inobt.ir_startino = cpu_to_be32(ino);
+	rec.inobt.ir_freecount = cpu_to_be32(fcnt);
+	rec.inobt.ir_free = cpu_to_be64(free);
+	return xfs_btree_update(cur, &rec);
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+int					/* error */
+xfs_inobt_get_rec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agino_t		*ino,	/* output: starting inode of chunk */
+	__int32_t		*fcnt,	/* output: number of free inodes */
+	xfs_inofree_t		*free,	/* output: free inode mask */
+	int			*stat)	/* output: success/failure */
+{
+	union xfs_btree_rec	*rec;
+	int			error;
+
+	error = xfs_btree_get_rec(cur, &rec, stat);
+	if (!error && *stat == 1) {
+		*ino = be32_to_cpu(rec->inobt.ir_startino);
+		*fcnt = be32_to_cpu(rec->inobt.ir_freecount);
+		*free = be64_to_cpu(rec->inobt.ir_free);
+	}
+	return error;
+}
+
+/*
  * Allocate new inodes in the allocation group specified by agbp.
  * Return 0 for success, else error code.
  */
@@ -316,8 +412,7 @@ xfs_ialloc_ag_alloc(
 	/*
 	 * Insert records describing the new inode chunk into the btree.
 	 */
-	cur = xfs_btree_init_cursor(args.mp, tp, agbp, agno,
-			XFS_BTNUM_INO, (xfs_inode_t *)0, 0);
+	cur = xfs_inobt_init_cursor(args.mp, tp, agbp, agno);
 	for (thisino = newino;
 	     thisino < newino + newlen;
 	     thisino += XFS_INODES_PER_CHUNK) {
@@ -327,7 +422,7 @@ xfs_ialloc_ag_alloc(
 			return error;
 		}
 		ASSERT(i == 0);
-		if ((error = xfs_inobt_insert(cur, &i))) {
+		if ((error = xfs_btree_insert(cur, &i))) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 			return error;
 		}
@@ -657,8 +752,7 @@ nextag:
 	 */
 	agno = tagno;
 	*IO_agbp = NULL;
-	cur = xfs_btree_init_cursor(mp, tp, agbp, be32_to_cpu(agi->agi_seqno),
-				    XFS_BTNUM_INO, (xfs_inode_t *)0, 0);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, be32_to_cpu(agi->agi_seqno));
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -678,7 +772,7 @@ nextag:
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			freecount += rec.ir_freecount;
-			if ((error = xfs_inobt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto error0;
 		} while (i == 1);
 
@@ -722,7 +816,7 @@ nextag:
 			/*
 			 * Search left with tcur, back up 1 record.
 			 */
-			if ((error = xfs_inobt_decrement(tcur, 0, &i)))
+			if ((error = xfs_btree_decrement(tcur, 0, &i)))
 				goto error1;
 			doneleft = !i;
 			if (!doneleft) {
@@ -736,7 +830,7 @@ nextag:
 			/*
 			 * Search right with cur, go forward 1 record.
 			 */
-			if ((error = xfs_inobt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto error1;
 			doneright = !i;
 			if (!doneright) {
@@ -798,7 +892,7 @@ nextag:
 				 * further left.
 				 */
 				if (useleft) {
-					if ((error = xfs_inobt_decrement(tcur, 0,
+					if ((error = xfs_btree_decrement(tcur, 0,
 							&i)))
 						goto error1;
 					doneleft = !i;
@@ -818,7 +912,7 @@ nextag:
 				 * further right.
 				 */
 				else {
-					if ((error = xfs_inobt_increment(cur, 0,
+					if ((error = xfs_btree_increment(cur, 0,
 							&i)))
 						goto error1;
 					doneright = !i;
@@ -873,7 +967,7 @@ nextag:
 				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 				if (rec.ir_freecount > 0)
 					break;
-				if ((error = xfs_inobt_increment(cur, 0, &i)))
+				if ((error = xfs_btree_increment(cur, 0, &i)))
 					goto error0;
 				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			}
@@ -907,7 +1001,7 @@ nextag:
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			freecount += rec.ir_freecount;
-			if ((error = xfs_inobt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto error0;
 		} while (i == 1);
 		ASSERT(freecount == be32_to_cpu(agi->agi_freecount) ||
@@ -1028,8 +1122,7 @@ xfs_dilocate(
 #endif /* DEBUG */
 			return error;
 		}
-		cur = xfs_btree_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO,
-			(xfs_inode_t *)0, 0);
+		cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
 		if ((error = xfs_inobt_lookup_le(cur, agino, 0, 0, &i))) {
 #ifdef DEBUG
 			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
Index: xfs-cmds/xfsprogs/libxfs/xfs_ialloc_btree.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_ialloc_btree.c	2008-09-24 19:50:58.000000000 +0200
+++ xfs-cmds/xfsprogs/libxfs/xfs_ialloc_btree.c	2008-09-24 20:01:15.000000000 +0200
@@ -17,1534 +17,327 @@
  */
 #include <xfs.h>
 
-STATIC void xfs_inobt_log_block(xfs_trans_t *, xfs_buf_t *, int);
-STATIC void xfs_inobt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC void xfs_inobt_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC void xfs_inobt_log_recs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC int xfs_inobt_lshift(xfs_btree_cur_t *, int, int *);
-STATIC int xfs_inobt_newroot(xfs_btree_cur_t *, int *);
-STATIC int xfs_inobt_rshift(xfs_btree_cur_t *, int, int *);
-STATIC int xfs_inobt_split(xfs_btree_cur_t *, int, xfs_agblock_t *,
-		xfs_inobt_key_t *, xfs_btree_cur_t **, int *);
-STATIC int xfs_inobt_updkey(xfs_btree_cur_t *, xfs_inobt_key_t *, int);
+STATIC int
+xfs_inobt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_inobt_mnr[level != 0];
+}
 
-/*
- * Insert one record/level.  Return information to the caller
- * allowing the next level up to proceed if necessary.
- */
-STATIC int				/* error */
-xfs_inobt_insrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to insert record at */
-	xfs_agblock_t		*bnop,	/* i/o: block number inserted */
-	xfs_inobt_rec_t		*recp,	/* i/o: record data inserted */
-	xfs_btree_cur_t		**curp,	/* output: new cursor replacing cur */
-	int			*stat)	/* success/failure */
+STATIC struct xfs_btree_cur *
+xfs_inobt_dup_cursor(
+	struct xfs_btree_cur	*cur)
 {
-	xfs_inobt_block_t	*block;	/* btree block record/key lives in */
-	xfs_buf_t		*bp;	/* buffer for block */
-	int			error;	/* error return value */
-	int			i;	/* loop index */
-	xfs_inobt_key_t		key;	/* key value being inserted */
-	xfs_inobt_key_t		*kp=NULL;	/* pointer to btree keys */
-	xfs_agblock_t		nbno;	/* block number of allocated block */
-	xfs_btree_cur_t		*ncur;	/* new cursor to be used at next lvl */
-	xfs_inobt_key_t		nkey;	/* new key value, from split */
-	xfs_inobt_rec_t		nrec;	/* new record value, for caller */
-	int			numrecs;
-	int			optr;	/* old ptr value */
-	xfs_inobt_ptr_t		*pp;	/* pointer to btree addresses */
-	int			ptr;	/* index in btree block for this rec */
-	xfs_inobt_rec_t		*rp=NULL;	/* pointer to btree records */
+	return xfs_inobt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.a.agbp, cur->bc_private.a.agno);
+}
 
-	/*
-	 * GCC doesn't understand the (arguably complex) control flow in
-	 * this function and complains about uninitialized structure fields
-	 * without this.
-	 */
-	memset(&nrec, 0, sizeof(nrec));
+STATIC void
+xfs_inobt_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*nptr,
+	int			inc)	/* level change */
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+
+	agi->agi_root = nptr->s;
+	be32_add_cpu(&agi->agi_level, inc);
+	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
+}
+
+STATIC int
+xfs_inobt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			length,
+	int			*stat)
+{
+	xfs_alloc_arg_t		args;		/* block allocation args */
+	int			error;		/* error return value */
+	xfs_agblock_t		sbno = be32_to_cpu(start->s);
 
-	/*
-	 * If we made it to the root level, allocate a new root block
-	 * and we're done.
-	 */
-	if (level >= cur->bc_nlevels) {
-		error = xfs_inobt_newroot(cur, &i);
-		*bnop = NULLAGBLOCK;
-		*stat = i;
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+
+	memset(&args, 0, sizeof(args));
+	args.tp = cur->bc_tp;
+	args.mp = cur->bc_mp;
+	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
+	args.minlen = 1;
+	args.maxlen = 1;
+	args.prod = 1;
+	args.type = XFS_ALLOCTYPE_NEAR_BNO;
+
+	error = xfs_alloc_vextent(&args);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 		return error;
 	}
-	/*
-	 * Make a key out of the record data to be inserted, and save it.
-	 */
-	key.ir_startino = recp->ir_startino;
-	optr = ptr = cur->bc_ptrs[level];
-	/*
-	 * If we're off the left edge, return failure.
-	 */
-	if (ptr == 0) {
+	if (args.fsbno == NULLFSBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 		*stat = 0;
 		return 0;
 	}
-	/*
-	 * Get pointers to the btree buffer and block.
-	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	numrecs = be16_to_cpu(block->bb_numrecs);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-		return error;
-	/*
-	 * Check that the new entry is being inserted in the right place.
-	 */
-	if (ptr <= numrecs) {
-		if (level == 0) {
-			rp = XFS_INOBT_REC_ADDR(block, ptr, cur);
-			xfs_btree_check_rec(cur->bc_btnum, recp, rp);
-		} else {
-			kp = XFS_INOBT_KEY_ADDR(block, ptr, cur);
-			xfs_btree_check_key(cur->bc_btnum, &key, kp);
-		}
-	}
-#endif
-	nbno = NULLAGBLOCK;
-	ncur = NULL;
-	/*
-	 * If the block is full, we can't insert the new entry until we
-	 * make the block un-full.
-	 */
-	if (numrecs == XFS_INOBT_BLOCK_MAXRECS(level, cur)) {
-		/*
-		 * First, try shifting an entry to the right neighbor.
-		 */
-		if ((error = xfs_inobt_rshift(cur, level, &i)))
-			return error;
-		if (i) {
-			/* nothing */
-		}
-		/*
-		 * Next, try shifting an entry to the left neighbor.
-		 */
-		else {
-			if ((error = xfs_inobt_lshift(cur, level, &i)))
-				return error;
-			if (i) {
-				optr = ptr = cur->bc_ptrs[level];
-			} else {
-				/*
-				 * Next, try splitting the current block
-				 * in half. If this works we have to
-				 * re-set our variables because
-				 * we could be in a different block now.
-				 */
-				if ((error = xfs_inobt_split(cur, level, &nbno,
-						&nkey, &ncur, &i)))
-					return error;
-				if (i) {
-					bp = cur->bc_bufs[level];
-					block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-					if ((error = xfs_btree_check_sblock(cur,
-							block, level, bp)))
-						return error;
-#endif
-					ptr = cur->bc_ptrs[level];
-					nrec.ir_startino = nkey.ir_startino;
-				} else {
-					/*
-					 * Otherwise the insert fails.
-					 */
-					*stat = 0;
-					return 0;
-				}
-			}
-		}
-	}
-	/*
-	 * At this point we know there's room for our new entry in the block
-	 * we're pointing at.
-	 */
-	numrecs = be16_to_cpu(block->bb_numrecs);
-	if (level > 0) {
-		/*
-		 * It's a non-leaf entry.  Make a hole for the new data
-		 * in the key and ptr regions of the block.
-		 */
-		kp = XFS_INOBT_KEY_ADDR(block, 1, cur);
-		pp = XFS_INOBT_PTR_ADDR(block, 1, cur);
-#ifdef DEBUG
-		for (i = numrecs; i >= ptr; i--) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(pp[i - 1]), level)))
-				return error;
-		}
-#endif
-		memmove(&kp[ptr], &kp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*kp));
-		memmove(&pp[ptr], &pp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*pp));
-		/*
-		 * Now stuff the new data in, bump numrecs and log the new data.
-		 */
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sptr(cur, *bnop, level)))
-			return error;
-#endif
-		kp[ptr - 1] = key;
-		pp[ptr - 1] = cpu_to_be32(*bnop);
-		numrecs++;
-		block->bb_numrecs = cpu_to_be16(numrecs);
-		xfs_inobt_log_keys(cur, bp, ptr, numrecs);
-		xfs_inobt_log_ptrs(cur, bp, ptr, numrecs);
-	} else {
-		/*
-		 * It's a leaf entry.  Make a hole for the new record.
-		 */
-		rp = XFS_INOBT_REC_ADDR(block, 1, cur);
-		memmove(&rp[ptr], &rp[ptr - 1],
-			(numrecs - ptr + 1) * sizeof(*rp));
-		/*
-		 * Now stuff the new record in, bump numrecs
-		 * and log the new data.
-		 */
-		rp[ptr - 1] = *recp;
-		numrecs++;
-		block->bb_numrecs = cpu_to_be16(numrecs);
-		xfs_inobt_log_recs(cur, bp, ptr, numrecs);
-	}
-	/*
-	 * Log the new number of records in the btree header.
-	 */
-	xfs_inobt_log_block(cur->bc_tp, bp, XFS_BB_NUMRECS);
-#ifdef DEBUG
-	/*
-	 * Check that the key/record is in the right place, now.
-	 */
-	if (ptr < numrecs) {
-		if (level == 0)
-			xfs_btree_check_rec(cur->bc_btnum, rp + ptr - 1,
-				rp + ptr);
-		else
-			xfs_btree_check_key(cur->bc_btnum, kp + ptr - 1,
-				kp + ptr);
-	}
-#endif
-	/*
-	 * If we inserted at the start of a block, update the parents' keys.
-	 */
-	if (optr == 1 && (error = xfs_inobt_updkey(cur, &key, level + 1)))
-		return error;
-	/*
-	 * Return the new block number, if any.
-	 * If there is one, give back a record value and a cursor too.
-	 */
-	*bnop = nbno;
-	if (nbno != NULLAGBLOCK) {
-		*recp = nrec;
-		*curp = ncur;
-	}
+	ASSERT(args.len == 1);
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+
+	new->s = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
 	*stat = 1;
 	return 0;
 }
 
-/*
- * Log header fields from a btree block.
- */
-STATIC void
-xfs_inobt_log_block(
-	xfs_trans_t		*tp,	/* transaction pointer */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			fields)	/* mask of fields: XFS_BB_... */
+STATIC int
+xfs_inobt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
 {
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	static const short	offsets[] = {	/* table of offsets */
-		offsetof(xfs_inobt_block_t, bb_magic),
-		offsetof(xfs_inobt_block_t, bb_level),
-		offsetof(xfs_inobt_block_t, bb_numrecs),
-		offsetof(xfs_inobt_block_t, bb_leftsib),
-		offsetof(xfs_inobt_block_t, bb_rightsib),
-		sizeof(xfs_inobt_block_t)
-	};
+	xfs_fsblock_t		fsbno;
+	int			error;
+
+	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp));
+	error = xfs_free_extent(cur->bc_tp, fsbno, 1);
+	if (error)
+		return error;
 
-	xfs_btree_offsets(fields, offsets, XFS_BB_NUM_BITS, &first, &last);
-	xfs_trans_log_buf(tp, bp, first, last);
+	xfs_trans_binval(cur->bc_tp, bp);
+	return error;
+}
+
+STATIC int
+xfs_inobt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_inobt_mxr[level != 0];
 }
 
-/*
- * Log keys from a btree block (nonleaf).
- */
 STATIC void
-xfs_inobt_log_keys(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			kfirst,	/* index of first key to log */
-	int			klast)	/* index of last key to log */
+xfs_inobt_init_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
 {
-	xfs_inobt_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	xfs_inobt_key_t		*kp;	/* key pointer in btree block */
-	int			last;	/* last byte offset logged */
-
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	kp = XFS_INOBT_KEY_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	key->inobt.ir_startino = rec->inobt.ir_startino;
 }
 
-/*
- * Log block pointer fields from a btree block (nonleaf).
- */
 STATIC void
-xfs_inobt_log_ptrs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			pfirst,	/* index of first pointer to log */
-	int			plast)	/* index of last pointer to log */
+xfs_inobt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
 {
-	xfs_inobt_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	xfs_inobt_ptr_t		*pp;	/* block-pointer pointer in btree blk */
-
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	pp = XFS_INOBT_PTR_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	rec->inobt.ir_startino = key->inobt.ir_startino;
 }
 
-/*
- * Log records from a btree block (leaf).
- */
 STATIC void
-xfs_inobt_log_recs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			rfirst,	/* index of first record to log */
-	int			rlast)	/* index of last record to log */
+xfs_inobt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
 {
-	xfs_inobt_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	xfs_inobt_rec_t		*rp;	/* record pointer for btree block */
-
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	rp = XFS_INOBT_REC_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	rec->inobt.ir_startino = cpu_to_be32(cur->bc_rec.i.ir_startino);
+	rec->inobt.ir_freecount = cpu_to_be32(cur->bc_rec.i.ir_freecount);
+	rec->inobt.ir_free = cpu_to_be64(cur->bc_rec.i.ir_free);
 }
 
 /*
- * Lookup the record.  The cursor is made to point to it, based on dir.
- * Return 0 if can't find any such record, 1 for success.
+ * intial value of ptr for lookup
  */
-STATIC int				/* error */
-xfs_inobt_lookup(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_lookup_t		dir,	/* <=, ==, or >= */
-	int			*stat)	/* success/failure */
+STATIC void
+xfs_inobt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
 {
-	xfs_agblock_t		agbno;	/* a.g. relative btree block number */
-	xfs_agnumber_t		agno;	/* allocation group number */
-	xfs_inobt_block_t	*block=NULL;	/* current btree block */
-	__int64_t		diff;	/* difference for the current key */
-	int			error;	/* error return value */
-	int			keyno=0;	/* current key number */
-	int			level;	/* level in the btree */
-	xfs_mount_t		*mp;	/* file system mount point */
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
 
-	/*
-	 * Get the allocation group header, and the root block number.
-	 */
-	mp = cur->bc_mp;
-	{
-		xfs_agi_t	*agi;	/* a.g. inode header */
-
-		agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
-		agno = be32_to_cpu(agi->agi_seqno);
-		agbno = be32_to_cpu(agi->agi_root);
-	}
-	/*
-	 * Iterate over each level in the btree, starting at the root.
-	 * For each level above the leaves, find the key we need, based
-	 * on the lookup record, then follow the corresponding block
-	 * pointer down to the next level.
-	 */
-	for (level = cur->bc_nlevels - 1, diff = 1; level >= 0; level--) {
-		xfs_buf_t	*bp;	/* buffer pointer for btree block */
-		xfs_daddr_t	d;	/* disk address of btree block */
-
-		/*
-		 * Get the disk address we're looking for.
-		 */
-		d = XFS_AGB_TO_DADDR(mp, agno, agbno);
-		/*
-		 * If the old buffer at this level is for a different block,
-		 * throw it away, otherwise just use it.
-		 */
-		bp = cur->bc_bufs[level];
-		if (bp && XFS_BUF_ADDR(bp) != d)
-			bp = NULL;
-		if (!bp) {
-			/*
-			 * Need to get a new buffer.  Read it, then
-			 * set it in the cursor, releasing the old one.
-			 */
-			if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-					agno, agbno, 0, &bp, XFS_INO_BTREE_REF)))
-				return error;
-			xfs_btree_setbuf(cur, level, bp);
-			/*
-			 * Point to the btree block, now that we have the buffer
-			 */
-			block = XFS_BUF_TO_INOBT_BLOCK(bp);
-			if ((error = xfs_btree_check_sblock(cur, block, level,
-					bp)))
-				return error;
-		} else
-			block = XFS_BUF_TO_INOBT_BLOCK(bp);
-		/*
-		 * If we already had a key match at a higher level, we know
-		 * we need to use the first entry in this block.
-		 */
-		if (diff == 0)
-			keyno = 1;
-		/*
-		 * Otherwise we need to search this block.  Do a binary search.
-		 */
-		else {
-			int		high;	/* high entry number */
-			xfs_inobt_key_t	*kkbase=NULL;/* base of keys in block */
-			xfs_inobt_rec_t	*krbase=NULL;/* base of records in block */
-			int		low;	/* low entry number */
-
-			/*
-			 * Get a pointer to keys or records.
-			 */
-			if (level > 0)
-				kkbase = XFS_INOBT_KEY_ADDR(block, 1, cur);
-			else
-				krbase = XFS_INOBT_REC_ADDR(block, 1, cur);
-			/*
-			 * Set low and high entry numbers, 1-based.
-			 */
-			low = 1;
-			if (!(high = be16_to_cpu(block->bb_numrecs))) {
-				/*
-				 * If the block is empty, the tree must
-				 * be an empty leaf.
-				 */
-				ASSERT(level == 0 && cur->bc_nlevels == 1);
-				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
-				*stat = 0;
-				return 0;
-			}
-			/*
-			 * Binary search the block.
-			 */
-			while (low <= high) {
-				xfs_agino_t	startino;	/* key value */
-
-				/*
-				 * keyno is average of low and high.
-				 */
-				keyno = (low + high) >> 1;
-				/*
-				 * Get startino.
-				 */
-				if (level > 0) {
-					xfs_inobt_key_t	*kkp;
-
-					kkp = kkbase + keyno - 1;
-					startino = be32_to_cpu(kkp->ir_startino);
-				} else {
-					xfs_inobt_rec_t	*krp;
-
-					krp = krbase + keyno - 1;
-					startino = be32_to_cpu(krp->ir_startino);
-				}
-				/*
-				 * Compute difference to get next direction.
-				 */
-				diff = (__int64_t)
-					startino - cur->bc_rec.i.ir_startino;
-				/*
-				 * Less than, move right.
-				 */
-				if (diff < 0)
-					low = keyno + 1;
-				/*
-				 * Greater than, move left.
-				 */
-				else if (diff > 0)
-					high = keyno - 1;
-				/*
-				 * Equal, we're done.
-				 */
-				else
-					break;
-			}
-		}
-		/*
-		 * If there are more levels, set up for the next level
-		 * by getting the block number and filling in the cursor.
-		 */
-		if (level > 0) {
-			/*
-			 * If we moved left, need the previous key number,
-			 * unless there isn't one.
-			 */
-			if (diff > 0 && --keyno < 1)
-				keyno = 1;
-			agbno = be32_to_cpu(*XFS_INOBT_PTR_ADDR(block, keyno, cur));
-#ifdef DEBUG
-			if ((error = xfs_btree_check_sptr(cur, agbno, level)))
-				return error;
-#endif
-			cur->bc_ptrs[level] = keyno;
-		}
-	}
-	/*
-	 * Done with the search.
-	 * See if we need to adjust the results.
-	 */
-	if (dir != XFS_LOOKUP_LE && diff < 0) {
-		keyno++;
-		/*
-		 * If ge search and we went off the end of the block, but it's
-		 * not the last block, we're in the wrong block.
-		 */
-		if (dir == XFS_LOOKUP_GE &&
-		    keyno > be16_to_cpu(block->bb_numrecs) &&
-		    be32_to_cpu(block->bb_rightsib) != NULLAGBLOCK) {
-			int	i;
-
-			cur->bc_ptrs[0] = keyno;
-			if ((error = xfs_inobt_increment(cur, 0, &i)))
-				return error;
-			ASSERT(i == 1);
-			*stat = 1;
-			return 0;
-		}
-	}
-	else if (dir == XFS_LOOKUP_LE && diff > 0)
-		keyno--;
-	cur->bc_ptrs[0] = keyno;
-	/*
-	 * Return if we succeeded or not.
-	 */
-	if (keyno == 0 || keyno > be16_to_cpu(block->bb_numrecs))
-		*stat = 0;
-	else
-		*stat = ((dir != XFS_LOOKUP_EQ) || (diff == 0));
-	return 0;
+	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
+
+	ptr->s = agi->agi_root;
 }
 
-/*
- * Move 1 record left from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int				/* error */
-xfs_inobt_lshift(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to shift record on */
-	int			*stat)	/* success/failure */
+STATIC __int64_t
+xfs_inobt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
 {
-	int			error;	/* error return value */
-#ifdef DEBUG
-	int			i;	/* loop index */
-#endif
-	xfs_inobt_key_t		key;	/* key value for leaf level upward */
-	xfs_buf_t		*lbp;	/* buffer for left neighbor block */
-	xfs_inobt_block_t	*left;	/* left neighbor btree block */
-	xfs_inobt_key_t		*lkp=NULL;	/* key pointer for left block */
-	xfs_inobt_ptr_t		*lpp;	/* address pointer for left block */
-	xfs_inobt_rec_t		*lrp=NULL;	/* record pointer for left block */
-	int			nrec;	/* new number of left block entries */
-	xfs_buf_t		*rbp;	/* buffer for right (current) block */
-	xfs_inobt_block_t	*right;	/* right (current) btree block */
-	xfs_inobt_key_t		*rkp=NULL;	/* key pointer for right block */
-	xfs_inobt_ptr_t		*rpp=NULL;	/* address pointer for right block */
-	xfs_inobt_rec_t		*rrp=NULL;	/* record pointer for right block */
-
-	/*
-	 * Set up variables for this block as "right".
-	 */
-	rbp = cur->bc_bufs[level];
-	right = XFS_BUF_TO_INOBT_BLOCK(rbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-		return error;
-#endif
-	/*
-	 * If we've got no left sibling then we can't shift an entry left.
-	 */
-	if (be32_to_cpu(right->bb_leftsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * If the cursor entry is the one that would be moved, don't
-	 * do it... it's too complicated.
-	 */
-	if (cur->bc_ptrs[level] <= 1) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Set up the left neighbor as "left".
-	 */
-	if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agno, be32_to_cpu(right->bb_leftsib),
-			0, &lbp, XFS_INO_BTREE_REF)))
-		return error;
-	left = XFS_BUF_TO_INOBT_BLOCK(lbp);
-	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-		return error;
-	/*
-	 * If it's full, it can't take another entry.
-	 */
-	if (be16_to_cpu(left->bb_numrecs) == XFS_INOBT_BLOCK_MAXRECS(level, cur)) {
-		*stat = 0;
-		return 0;
-	}
-	nrec = be16_to_cpu(left->bb_numrecs) + 1;
-	/*
-	 * If non-leaf, copy a key and a ptr to the left block.
-	 */
-	if (level > 0) {
-		lkp = XFS_INOBT_KEY_ADDR(left, nrec, cur);
-		rkp = XFS_INOBT_KEY_ADDR(right, 1, cur);
-		*lkp = *rkp;
-		xfs_inobt_log_keys(cur, lbp, nrec, nrec);
-		lpp = XFS_INOBT_PTR_ADDR(left, nrec, cur);
-		rpp = XFS_INOBT_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(*rpp), level)))
-			return error;
-#endif
-		*lpp = *rpp;
-		xfs_inobt_log_ptrs(cur, lbp, nrec, nrec);
-	}
-	/*
-	 * If leaf, copy a record to the left block.
-	 */
-	else {
-		lrp = XFS_INOBT_REC_ADDR(left, nrec, cur);
-		rrp = XFS_INOBT_REC_ADDR(right, 1, cur);
-		*lrp = *rrp;
-		xfs_inobt_log_recs(cur, lbp, nrec, nrec);
-	}
-	/*
-	 * Bump and log left's numrecs, decrement and log right's numrecs.
-	 */
-	be16_add_cpu(&left->bb_numrecs, 1);
-	xfs_inobt_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-#ifdef DEBUG
-	if (level > 0)
-		xfs_btree_check_key(cur->bc_btnum, lkp - 1, lkp);
-	else
-		xfs_btree_check_rec(cur->bc_btnum, lrp - 1, lrp);
-#endif
-	be16_add_cpu(&right->bb_numrecs, -1);
-	xfs_inobt_log_block(cur->bc_tp, rbp, XFS_BB_NUMRECS);
-	/*
-	 * Slide the contents of right down one entry.
-	 */
-	if (level > 0) {
-#ifdef DEBUG
-		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i + 1]),
-					level)))
-				return error;
-		}
-#endif
-		memmove(rkp, rkp + 1, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memmove(rpp, rpp + 1, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-		xfs_inobt_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		xfs_inobt_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-	} else {
-		memmove(rrp, rrp + 1, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		xfs_inobt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		key.ir_startino = rrp->ir_startino;
-		rkp = &key;
-	}
-	/*
-	 * Update the parent key values of right.
-	 */
-	if ((error = xfs_inobt_updkey(cur, rkp, level + 1)))
-		return error;
-	/*
-	 * Slide the cursor value left one.
-	 */
-	cur->bc_ptrs[level]--;
-	*stat = 1;
-	return 0;
+	return (__int64_t)be32_to_cpu(key->inobt.ir_startino) -
+			  cur->bc_rec.i.ir_startino;
 }
 
-/*
- * Allocate a new root block, fill it in.
- */
-STATIC int				/* error */
-xfs_inobt_newroot(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			*stat)	/* success/failure */
+STATIC int
+xfs_inobt_kill_root(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			level,
+	union xfs_btree_ptr	*newroot)
 {
-	xfs_agi_t		*agi;	/* a.g. inode header */
-	xfs_alloc_arg_t		args;	/* allocation argument structure */
-	xfs_inobt_block_t	*block;	/* one half of the old root block */
-	xfs_buf_t		*bp;	/* buffer containing block */
-	int			error;	/* error return value */
-	xfs_inobt_key_t		*kp;	/* btree key pointer */
-	xfs_agblock_t		lbno;	/* left block number */
-	xfs_buf_t		*lbp;	/* left buffer pointer */
-	xfs_inobt_block_t	*left;	/* left btree block */
-	xfs_buf_t		*nbp;	/* new (root) buffer */
-	xfs_inobt_block_t	*new;	/* new (root) btree block */
-	int			nptr;	/* new value for key index, 1 or 2 */
-	xfs_inobt_ptr_t		*pp;	/* btree address pointer */
-	xfs_agblock_t		rbno;	/* right block number */
-	xfs_buf_t		*rbp;	/* right buffer pointer */
-	xfs_inobt_block_t	*right;	/* right btree block */
-	xfs_inobt_rec_t		*rp;	/* btree record pointer */
+	int			error;
 
-	ASSERT(cur->bc_nlevels < XFS_IN_MAXLEVELS(cur->bc_mp));
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_STATS_INC(cur, killroot);
 
 	/*
-	 * Get a block & a buffer.
+	 * Update the root pointer, decreasing the level by 1 and then
+	 * free the old root.
 	 */
-	agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
-	args.tp = cur->bc_tp;
-	args.mp = cur->bc_mp;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno,
-		be32_to_cpu(agi->agi_root));
-	args.mod = args.minleft = args.alignment = args.total = args.wasdel =
-		args.isfl = args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	if ((error = xfs_alloc_vextent(&args)))
+	xfs_inobt_set_root(cur, newroot, -1);
+	error = xfs_inobt_free_block(cur, bp);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 		return error;
-	/*
-	 * None available, we fail.
-	 */
-	if (args.fsbno == NULLFSBLOCK) {
-		*stat = 0;
-		return 0;
 	}
-	ASSERT(args.len == 1);
-	nbp = xfs_btree_get_bufs(args.mp, args.tp, args.agno, args.agbno, 0);
-	new = XFS_BUF_TO_INOBT_BLOCK(nbp);
-	/*
-	 * Set the root data in the a.g. inode structure.
-	 */
-	agi->agi_root = cpu_to_be32(args.agbno);
-	be32_add_cpu(&agi->agi_level, 1);
-	xfs_ialloc_log_agi(args.tp, cur->bc_private.a.agbp,
-		XFS_AGI_ROOT | XFS_AGI_LEVEL);
-	/*
-	 * At the previous root level there are now two blocks: the old
-	 * root, and the new block generated when it was split.
-	 * We don't know which one the cursor is pointing at, so we
-	 * set up variables "left" and "right" for each case.
-	 */
-	bp = cur->bc_bufs[cur->bc_nlevels - 1];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, cur->bc_nlevels - 1, bp)))
-		return error;
-#endif
-	if (be32_to_cpu(block->bb_rightsib) != NULLAGBLOCK) {
-		/*
-		 * Our block is left, pick up the right block.
-		 */
-		lbp = bp;
-		lbno = XFS_DADDR_TO_AGBNO(args.mp, XFS_BUF_ADDR(lbp));
-		left = block;
-		rbno = be32_to_cpu(left->bb_rightsib);
-		if ((error = xfs_btree_read_bufs(args.mp, args.tp, args.agno,
-				rbno, 0, &rbp, XFS_INO_BTREE_REF)))
-			return error;
-		bp = rbp;
-		right = XFS_BUF_TO_INOBT_BLOCK(rbp);
-		if ((error = xfs_btree_check_sblock(cur, right,
-				cur->bc_nlevels - 1, rbp)))
-			return error;
-		nptr = 1;
-	} else {
-		/*
-		 * Our block is right, pick up the left block.
-		 */
-		rbp = bp;
-		rbno = XFS_DADDR_TO_AGBNO(args.mp, XFS_BUF_ADDR(rbp));
-		right = block;
-		lbno = be32_to_cpu(right->bb_leftsib);
-		if ((error = xfs_btree_read_bufs(args.mp, args.tp, args.agno,
-				lbno, 0, &lbp, XFS_INO_BTREE_REF)))
-			return error;
-		bp = lbp;
-		left = XFS_BUF_TO_INOBT_BLOCK(lbp);
-		if ((error = xfs_btree_check_sblock(cur, left,
-				cur->bc_nlevels - 1, lbp)))
-			return error;
-		nptr = 2;
-	}
-	/*
-	 * Fill in the new block's btree header and log it.
-	 */
-	new->bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
-	new->bb_level = cpu_to_be16(cur->bc_nlevels);
-	new->bb_numrecs = cpu_to_be16(2);
-	new->bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-	new->bb_rightsib = cpu_to_be32(NULLAGBLOCK);
-	xfs_inobt_log_block(args.tp, nbp, XFS_BB_ALL_BITS);
-	ASSERT(lbno != NULLAGBLOCK && rbno != NULLAGBLOCK);
-	/*
-	 * Fill in the key data in the new root.
-	 */
-	kp = XFS_INOBT_KEY_ADDR(new, 1, cur);
-	if (be16_to_cpu(left->bb_level) > 0) {
-		kp[0] = *XFS_INOBT_KEY_ADDR(left, 1, cur);
-		kp[1] = *XFS_INOBT_KEY_ADDR(right, 1, cur);
-	} else {
-		rp = XFS_INOBT_REC_ADDR(left, 1, cur);
-		kp[0].ir_startino = rp->ir_startino;
-		rp = XFS_INOBT_REC_ADDR(right, 1, cur);
-		kp[1].ir_startino = rp->ir_startino;
-	}
-	xfs_inobt_log_keys(cur, nbp, 1, 2);
-	/*
-	 * Fill in the pointer data in the new root.
-	 */
-	pp = XFS_INOBT_PTR_ADDR(new, 1, cur);
-	pp[0] = cpu_to_be32(lbno);
-	pp[1] = cpu_to_be32(rbno);
-	xfs_inobt_log_ptrs(cur, nbp, 1, 2);
-	/*
-	 * Fix up the cursor.
-	 */
-	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
-	cur->bc_ptrs[cur->bc_nlevels] = nptr;
-	cur->bc_nlevels++;
-	*stat = 1;
-	return 0;
-}
 
-/*
- * Move 1 record right from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int				/* error */
-xfs_inobt_rshift(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to shift record on */
-	int			*stat)	/* success/failure */
-{
-	int			error;	/* error return value */
-	int			i;	/* loop index */
-	xfs_inobt_key_t		key;	/* key value for leaf level upward */
-	xfs_buf_t		*lbp;	/* buffer for left (current) block */
-	xfs_inobt_block_t	*left;	/* left (current) btree block */
-	xfs_inobt_key_t		*lkp;	/* key pointer for left block */
-	xfs_inobt_ptr_t		*lpp;	/* address pointer for left block */
-	xfs_inobt_rec_t		*lrp;	/* record pointer for left block */
-	xfs_buf_t		*rbp;	/* buffer for right neighbor block */
-	xfs_inobt_block_t	*right;	/* right neighbor btree block */
-	xfs_inobt_key_t		*rkp;	/* key pointer for right block */
-	xfs_inobt_ptr_t		*rpp;	/* address pointer for right block */
-	xfs_inobt_rec_t		*rrp=NULL;	/* record pointer for right block */
-	xfs_btree_cur_t		*tcur;	/* temporary cursor */
+	XFS_BTREE_STATS_INC(cur, free);
 
-	/*
-	 * Set up variables for this block as "left".
-	 */
-	lbp = cur->bc_bufs[level];
-	left = XFS_BUF_TO_INOBT_BLOCK(lbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-		return error;
-#endif
-	/*
-	 * If we've got no right sibling then we can't shift an entry right.
-	 */
-	if (be32_to_cpu(left->bb_rightsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * If the cursor entry is the one that would be moved, don't
-	 * do it... it's too complicated.
-	 */
-	if (cur->bc_ptrs[level] >= be16_to_cpu(left->bb_numrecs)) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Set up the right neighbor as "right".
-	 */
-	if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agno, be32_to_cpu(left->bb_rightsib),
-			0, &rbp, XFS_INO_BTREE_REF)))
-		return error;
-	right = XFS_BUF_TO_INOBT_BLOCK(rbp);
-	if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-		return error;
-	/*
-	 * If it's full, it can't take another entry.
-	 */
-	if (be16_to_cpu(right->bb_numrecs) == XFS_INOBT_BLOCK_MAXRECS(level, cur)) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Make a hole at the start of the right neighbor block, then
-	 * copy the last left block entry to the hole.
-	 */
-	if (level > 0) {
-		lkp = XFS_INOBT_KEY_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		lpp = XFS_INOBT_PTR_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rkp = XFS_INOBT_KEY_ADDR(right, 1, cur);
-		rpp = XFS_INOBT_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = be16_to_cpu(right->bb_numrecs) - 1; i >= 0; i--) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i]), level)))
-				return error;
-		}
-#endif
-		memmove(rkp + 1, rkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memmove(rpp + 1, rpp, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(*lpp), level)))
-			return error;
-#endif
-		*rkp = *lkp;
-		*rpp = *lpp;
-		xfs_inobt_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		xfs_inobt_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-	} else {
-		lrp = XFS_INOBT_REC_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rrp = XFS_INOBT_REC_ADDR(right, 1, cur);
-		memmove(rrp + 1, rrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		*rrp = *lrp;
-		xfs_inobt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		key.ir_startino = rrp->ir_startino;
-		rkp = &key;
-	}
-	/*
-	 * Decrement and log left's numrecs, bump and log right's numrecs.
-	 */
-	be16_add_cpu(&left->bb_numrecs, -1);
-	xfs_inobt_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-	be16_add_cpu(&right->bb_numrecs, 1);
-#ifdef DEBUG
-	if (level > 0)
-		xfs_btree_check_key(cur->bc_btnum, rkp, rkp + 1);
-	else
-		xfs_btree_check_rec(cur->bc_btnum, rrp, rrp + 1);
-#endif
-	xfs_inobt_log_block(cur->bc_tp, rbp, XFS_BB_NUMRECS);
-	/*
-	 * Using a temporary cursor, update the parent key values of the
-	 * block on the right.
-	 */
-	if ((error = xfs_btree_dup_cursor(cur, &tcur)))
-		return error;
-	xfs_btree_lastrec(tcur, level);
-	if ((error = xfs_inobt_increment(tcur, level, &i)) ||
-	    (error = xfs_inobt_updkey(tcur, rkp, level + 1))) {
-		xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-		return error;
-	}
-	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-	*stat = 1;
+	cur->bc_bufs[level] = NULL;
+	cur->bc_nlevels--;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 	return 0;
 }
 
-/*
- * Split cur/level block in half.
- * Return new block number and its first record (to be inserted into parent).
- */
-STATIC int				/* error */
-xfs_inobt_split(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to split */
-	xfs_agblock_t		*bnop,	/* output: block number allocated */
-	xfs_inobt_key_t		*keyp,	/* output: first key of new block */
-	xfs_btree_cur_t		**curp,	/* output: new cursor */
-	int			*stat)	/* success/failure */
-{
-	xfs_alloc_arg_t		args;	/* allocation argument structure */
-	int			error;	/* error return value */
-	int			i;	/* loop index/record number */
-	xfs_agblock_t		lbno;	/* left (current) block number */
-	xfs_buf_t		*lbp;	/* buffer for left block */
-	xfs_inobt_block_t	*left;	/* left (current) btree block */
-	xfs_inobt_key_t		*lkp;	/* left btree key pointer */
-	xfs_inobt_ptr_t		*lpp;	/* left btree address pointer */
-	xfs_inobt_rec_t		*lrp;	/* left btree record pointer */
-	xfs_buf_t		*rbp;	/* buffer for right block */
-	xfs_inobt_block_t	*right;	/* right (new) btree block */
-	xfs_inobt_key_t		*rkp;	/* right btree key pointer */
-	xfs_inobt_ptr_t		*rpp;	/* right btree address pointer */
-	xfs_inobt_rec_t		*rrp;	/* right btree record pointer */
-
-	/*
-	 * Set up left block (current one).
-	 */
-	lbp = cur->bc_bufs[level];
-	args.tp = cur->bc_tp;
-	args.mp = cur->bc_mp;
-	lbno = XFS_DADDR_TO_AGBNO(args.mp, XFS_BUF_ADDR(lbp));
-	/*
-	 * Allocate the new block.
-	 * If we can't do it, we're toast.  Give up.
-	 */
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, lbno);
-	args.mod = args.minleft = args.alignment = args.total = args.wasdel =
-		args.isfl = args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	if ((error = xfs_alloc_vextent(&args)))
-		return error;
-	if (args.fsbno == NULLFSBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	ASSERT(args.len == 1);
-	rbp = xfs_btree_get_bufs(args.mp, args.tp, args.agno, args.agbno, 0);
-	/*
-	 * Set up the new block as "right".
-	 */
-	right = XFS_BUF_TO_INOBT_BLOCK(rbp);
-	/*
-	 * "Left" is the current (according to the cursor) block.
-	 */
-	left = XFS_BUF_TO_INOBT_BLOCK(lbp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-		return error;
-#endif
-	/*
-	 * Fill in the btree header for the new block.
-	 */
-	right->bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
-	right->bb_level = left->bb_level;
-	right->bb_numrecs = cpu_to_be16(be16_to_cpu(left->bb_numrecs) / 2);
-	/*
-	 * Make sure that if there's an odd number of entries now, that
-	 * each new block will have the same number of entries.
-	 */
-	if ((be16_to_cpu(left->bb_numrecs) & 1) &&
-	    cur->bc_ptrs[level] <= be16_to_cpu(right->bb_numrecs) + 1)
-		be16_add_cpu(&right->bb_numrecs, 1);
-	i = be16_to_cpu(left->bb_numrecs) - be16_to_cpu(right->bb_numrecs) + 1;
-	/*
-	 * For non-leaf blocks, copy keys and addresses over to the new block.
-	 */
-	if (level > 0) {
-		lkp = XFS_INOBT_KEY_ADDR(left, i, cur);
-		lpp = XFS_INOBT_PTR_ADDR(left, i, cur);
-		rkp = XFS_INOBT_KEY_ADDR(right, 1, cur);
-		rpp = XFS_INOBT_PTR_ADDR(right, 1, cur);
 #ifdef DEBUG
-		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(lpp[i]), level)))
-				return error;
-		}
-#endif
-		memcpy(rkp, lkp, be16_to_cpu(right->bb_numrecs) * sizeof(*rkp));
-		memcpy(rpp, lpp, be16_to_cpu(right->bb_numrecs) * sizeof(*rpp));
-		xfs_inobt_log_keys(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		xfs_inobt_log_ptrs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		*keyp = *rkp;
-	}
-	/*
-	 * For leaf blocks, copy records over to the new block.
-	 */
-	else {
-		lrp = XFS_INOBT_REC_ADDR(left, i, cur);
-		rrp = XFS_INOBT_REC_ADDR(right, 1, cur);
-		memcpy(rrp, lrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		xfs_inobt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs));
-		keyp->ir_startino = rrp->ir_startino;
-	}
-	/*
-	 * Find the left block number by looking in the buffer.
-	 * Adjust numrecs, sibling pointers.
-	 */
-	be16_add_cpu(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
-	right->bb_rightsib = left->bb_rightsib;
-	left->bb_rightsib = cpu_to_be32(args.agbno);
-	right->bb_leftsib = cpu_to_be32(lbno);
-	xfs_inobt_log_block(args.tp, rbp, XFS_BB_ALL_BITS);
-	xfs_inobt_log_block(args.tp, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
-	/*
-	 * If there's a block to the new block's right, make that block
-	 * point back to right instead of to left.
-	 */
-	if (be32_to_cpu(right->bb_rightsib) != NULLAGBLOCK) {
-		xfs_inobt_block_t	*rrblock;	/* rr btree block */
-		xfs_buf_t		*rrbp;		/* buffer for rrblock */
-
-		if ((error = xfs_btree_read_bufs(args.mp, args.tp, args.agno,
-				be32_to_cpu(right->bb_rightsib), 0, &rrbp,
-				XFS_INO_BTREE_REF)))
-			return error;
-		rrblock = XFS_BUF_TO_INOBT_BLOCK(rrbp);
-		if ((error = xfs_btree_check_sblock(cur, rrblock, level, rrbp)))
-			return error;
-		rrblock->bb_leftsib = cpu_to_be32(args.agbno);
-		xfs_inobt_log_block(args.tp, rrbp, XFS_BB_LEFTSIB);
-	}
-	/*
-	 * If the cursor is really in the right block, move it there.
-	 * If it's just pointing past the last entry in left, then we'll
-	 * insert there, so don't change anything in that case.
-	 */
-	if (cur->bc_ptrs[level] > be16_to_cpu(left->bb_numrecs) + 1) {
-		xfs_btree_setbuf(cur, level, rbp);
-		cur->bc_ptrs[level] -= be16_to_cpu(left->bb_numrecs);
-	}
-	/*
-	 * If there are more levels, we'll need another cursor which refers
-	 * the right block, no matter where this cursor was.
-	 */
-	if (level + 1 < cur->bc_nlevels) {
-		if ((error = xfs_btree_dup_cursor(cur, curp)))
-			return error;
-		(*curp)->bc_ptrs[level + 1]++;
-	}
-	*bnop = args.agbno;
-	*stat = 1;
-	return 0;
+STATIC int
+xfs_inobt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return be32_to_cpu(k1->inobt.ir_startino) <
+		be32_to_cpu(k2->inobt.ir_startino);
 }
 
-/*
- * Update keys at all levels from here to the root along the cursor's path.
- */
-STATIC int				/* error */
-xfs_inobt_updkey(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_inobt_key_t		*keyp,	/* new key value to update to */
-	int			level)	/* starting level for update */
+STATIC int
+xfs_inobt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
 {
-	int			ptr;	/* index of key in block */
+	return be32_to_cpu(r1->inobt.ir_startino) + XFS_INODES_PER_CHUNK <=
+		be32_to_cpu(r2->inobt.ir_startino);
+}
+#endif	/* DEBUG */
 
-	/*
-	 * Go up the tree from this level toward the root.
-	 * At each level, update the key value to the value input.
-	 * Stop when we reach a level where the cursor isn't pointing
-	 * at the first entry in the block.
-	 */
-	for (ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
-		xfs_buf_t		*bp;	/* buffer for block */
-		xfs_inobt_block_t	*block;	/* btree block */
-#ifdef DEBUG
-		int			error;	/* error return value */
-#endif
-		xfs_inobt_key_t		*kp;	/* ptr to btree block keys */
+#ifdef XFS_BTREE_TRACE
+ktrace_t	*xfs_inobt_trace_buf;
 
-		bp = cur->bc_bufs[level];
-		block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-			return error;
-#endif
-		ptr = cur->bc_ptrs[level];
-		kp = XFS_INOBT_KEY_ADDR(block, ptr, cur);
-		*kp = *keyp;
-		xfs_inobt_log_keys(cur, bp, ptr, ptr);
-	}
-	return 0;
+STATIC void
+xfs_inobt_trace_enter(
+	struct xfs_btree_cur	*cur,
+	const char		*func,
+	char			*s,
+	int			type,
+	int			line,
+	__psunsigned_t		a0,
+	__psunsigned_t		a1,
+	__psunsigned_t		a2,
+	__psunsigned_t		a3,
+	__psunsigned_t		a4,
+	__psunsigned_t		a5,
+	__psunsigned_t		a6,
+	__psunsigned_t		a7,
+	__psunsigned_t		a8,
+	__psunsigned_t		a9,
+	__psunsigned_t		a10)
+{
+	ktrace_enter(xfs_inobt_trace_buf, (void *)(__psint_t)type,
+		(void *)func, (void *)s, NULL, (void *)cur,
+		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
+		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
+		(void *)a8, (void *)a9, (void *)a10);
 }
 
-/*
- * Externally visible routines.
- */
+STATIC void
+xfs_inobt_trace_cursor(
+	struct xfs_btree_cur	*cur,
+	__uint32_t		*s0,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
+{
+	*s0 = cur->bc_private.a.agno;
+	*l0 = cur->bc_rec.i.ir_startino;
+	*l1 = cur->bc_rec.i.ir_free;
+}
 
-/*
- * Decrement cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int					/* error */
-xfs_inobt_decrement(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree, 0 is leaf */
-	int			*stat)	/* success/failure */
+STATIC void
+xfs_inobt_trace_key(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key,
+	__uint64_t		*l0,
+	__uint64_t		*l1)
 {
-	xfs_inobt_block_t	*block;	/* btree block */
-	int			error;
-	int			lev;	/* btree level */
-
-	ASSERT(level < cur->bc_nlevels);
-	/*
-	 * Read-ahead to the left at this level.
-	 */
-	xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
-	/*
-	 * Decrement the ptr at this level.  If we're still in the block
-	 * then we're done.
-	 */
-	if (--cur->bc_ptrs[level] > 0) {
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * Get a pointer to the btree block.
-	 */
-	block = XFS_BUF_TO_INOBT_BLOCK(cur->bc_bufs[level]);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level,
-			cur->bc_bufs[level])))
-		return error;
-#endif
-	/*
-	 * If we just went off the left edge of the tree, return failure.
-	 */
-	if (be32_to_cpu(block->bb_leftsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * March up the tree decrementing pointers.
-	 * Stop when we don't go off the left edge of a block.
-	 */
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		if (--cur->bc_ptrs[lev] > 0)
-			break;
-		/*
-		 * Read-ahead the left block, we're going to read it
-		 * in the next loop.
-		 */
-		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
-	}
-	/*
-	 * If we went off the root then we are seriously confused.
-	 */
-	ASSERT(lev < cur->bc_nlevels);
-	/*
-	 * Now walk back down the tree, fixing up the cursor's buffer
-	 * pointers and key numbers.
-	 */
-	for (block = XFS_BUF_TO_INOBT_BLOCK(cur->bc_bufs[lev]); lev > level; ) {
-		xfs_agblock_t	agbno;	/* block number of btree block */
-		xfs_buf_t	*bp;	/* buffer containing btree block */
-
-		agbno = be32_to_cpu(*XFS_INOBT_PTR_ADDR(block, cur->bc_ptrs[lev], cur));
-		if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-				cur->bc_private.a.agno, agbno, 0, &bp,
-				XFS_INO_BTREE_REF)))
-			return error;
-		lev--;
-		xfs_btree_setbuf(cur, lev, bp);
-		block = XFS_BUF_TO_INOBT_BLOCK(bp);
-		if ((error = xfs_btree_check_sblock(cur, block, lev, bp)))
-			return error;
-		cur->bc_ptrs[lev] = be16_to_cpu(block->bb_numrecs);
-	}
-	*stat = 1;
-	return 0;
+	*l0 = be32_to_cpu(key->inobt.ir_startino);
+	*l1 = 0;
 }
 
-/*
- * Get the data from the pointed-to record.
- */
-int					/* error */
-xfs_inobt_get_rec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agino_t		*ino,	/* output: starting inode of chunk */
-	__int32_t		*fcnt,	/* output: number of free inodes */
-	xfs_inofree_t		*free,	/* output: free inode mask */
-	int			*stat)	/* output: success/failure */
+STATIC void
+xfs_inobt_trace_record(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	__uint64_t		*l0,
+	__uint64_t		*l1,
+	__uint64_t		*l2)
 {
-	xfs_inobt_block_t	*block;	/* btree block */
-	xfs_buf_t		*bp;	/* buffer containing btree block */
-#ifdef DEBUG
-	int			error;	/* error return value */
-#endif
-	int			ptr;	/* record number */
-	xfs_inobt_rec_t		*rec;	/* record data */
-
-	bp = cur->bc_bufs[0];
-	ptr = cur->bc_ptrs[0];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, 0, bp)))
-		return error;
-#endif
-	/*
-	 * Off the right end or left end, return failure.
-	 */
-	if (ptr > be16_to_cpu(block->bb_numrecs) || ptr <= 0) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Point to the record and extract its data.
-	 */
-	rec = XFS_INOBT_REC_ADDR(block, ptr, cur);
-	*ino = be32_to_cpu(rec->ir_startino);
-	*fcnt = be32_to_cpu(rec->ir_freecount);
-	*free = be64_to_cpu(rec->ir_free);
-	*stat = 1;
-	return 0;
+	*l0 = be32_to_cpu(rec->inobt.ir_startino);
+	*l1 = be32_to_cpu(rec->inobt.ir_freecount);
+	*l2 = be64_to_cpu(rec->inobt.ir_free);
 }
+#endif /* XFS_BTREE_TRACE */
 
-/*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int					/* error */
-xfs_inobt_increment(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree, 0 is leaf */
-	int			*stat)	/* success/failure */
-{
-	xfs_inobt_block_t	*block;	/* btree block */
-	xfs_buf_t		*bp;	/* buffer containing btree block */
-	int			error;	/* error return value */
-	int			lev;	/* btree level */
+static const struct xfs_btree_ops xfs_inobt_ops = {
+	.rec_len		= sizeof(xfs_inobt_rec_t),
+	.key_len		= sizeof(xfs_inobt_key_t),
+
+	.dup_cursor		= xfs_inobt_dup_cursor,
+	.set_root		= xfs_inobt_set_root,
+	.kill_root		= xfs_inobt_kill_root,
+	.alloc_block		= xfs_inobt_alloc_block,
+	.free_block		= xfs_inobt_free_block,
+	.get_minrecs		= xfs_inobt_get_minrecs,
+	.get_maxrecs		= xfs_inobt_get_maxrecs,
+	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
+	.init_rec_from_key	= xfs_inobt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
+	.key_diff		= xfs_inobt_key_diff,
 
-	ASSERT(level < cur->bc_nlevels);
-	/*
-	 * Read-ahead to the right at this level.
-	 */
-	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
-	/*
-	 * Get a pointer to the btree block.
-	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-		return error;
-#endif
-	/*
-	 * Increment the ptr at this level.  If we're still in the block
-	 * then we're done.
-	 */
-	if (++cur->bc_ptrs[level] <= be16_to_cpu(block->bb_numrecs)) {
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * If we just went off the right edge of the tree, return failure.
-	 */
-	if (be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * March up the tree incrementing pointers.
-	 * Stop when we don't go off the right edge of a block.
-	 */
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		bp = cur->bc_bufs[lev];
-		block = XFS_BUF_TO_INOBT_BLOCK(bp);
 #ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, block, lev, bp)))
-			return error;
+	.keys_inorder		= xfs_inobt_keys_inorder,
+	.recs_inorder		= xfs_inobt_recs_inorder,
 #endif
-		if (++cur->bc_ptrs[lev] <= be16_to_cpu(block->bb_numrecs))
-			break;
-		/*
-		 * Read-ahead the right block, we're going to read it
-		 * in the next loop.
-		 */
-		xfs_btree_readahead(cur, lev, XFS_BTCUR_RIGHTRA);
-	}
-	/*
-	 * If we went off the root then we are seriously confused.
-	 */
-	ASSERT(lev < cur->bc_nlevels);
-	/*
-	 * Now walk back down the tree, fixing up the cursor's buffer
-	 * pointers and key numbers.
-	 */
-	for (bp = cur->bc_bufs[lev], block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	     lev > level; ) {
-		xfs_agblock_t	agbno;	/* block number of btree block */
-
-		agbno = be32_to_cpu(*XFS_INOBT_PTR_ADDR(block, cur->bc_ptrs[lev], cur));
-		if ((error = xfs_btree_read_bufs(cur->bc_mp, cur->bc_tp,
-				cur->bc_private.a.agno, agbno, 0, &bp,
-				XFS_INO_BTREE_REF)))
-			return error;
-		lev--;
-		xfs_btree_setbuf(cur, lev, bp);
-		block = XFS_BUF_TO_INOBT_BLOCK(bp);
-		if ((error = xfs_btree_check_sblock(cur, block, lev, bp)))
-			return error;
-		cur->bc_ptrs[lev] = 1;
-	}
-	*stat = 1;
-	return 0;
-}
 
-/*
- * Insert the current record at the point referenced by cur.
- * The cursor may be inconsistent on return if splits have been done.
- */
-int					/* error */
-xfs_inobt_insert(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		*stat)		/* success/failure */
-{
-	int		error;		/* error return value */
-	int		i;		/* result value, 0 for failure */
-	int		level;		/* current level number in btree */
-	xfs_agblock_t	nbno;		/* new block number (split result) */
-	xfs_btree_cur_t	*ncur;		/* new cursor (split result) */
-	xfs_inobt_rec_t	nrec;		/* record being inserted this level */
-	xfs_btree_cur_t	*pcur;		/* previous level's cursor */
-
-	level = 0;
-	nbno = NULLAGBLOCK;
-	nrec.ir_startino = cpu_to_be32(cur->bc_rec.i.ir_startino);
-	nrec.ir_freecount = cpu_to_be32(cur->bc_rec.i.ir_freecount);
-	nrec.ir_free = cpu_to_be64(cur->bc_rec.i.ir_free);
-	ncur = NULL;
-	pcur = cur;
-	/*
-	 * Loop going up the tree, starting at the leaf level.
-	 * Stop when we don't get a split block, that must mean that
-	 * the insert is finished with this level.
-	 */
-	do {
-		/*
-		 * Insert nrec/nbno into this level of the tree.
-		 * Note if we fail, nbno will be null.
-		 */
-		if ((error = xfs_inobt_insrec(pcur, level++, &nbno, &nrec, &ncur,
-				&i))) {
-			if (pcur != cur)
-				xfs_btree_del_cursor(pcur, XFS_BTREE_ERROR);
-			return error;
-		}
-		/*
-		 * See if the cursor we just used is trash.
-		 * Can't trash the caller's cursor, but otherwise we should
-		 * if ncur is a new cursor or we're about to be done.
-		 */
-		if (pcur != cur && (ncur || nbno == NULLAGBLOCK)) {
-			cur->bc_nlevels = pcur->bc_nlevels;
-			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
-		}
-		/*
-		 * If we got a new cursor, switch to it.
-		 */
-		if (ncur) {
-			pcur = ncur;
-			ncur = NULL;
-		}
-	} while (nbno != NULLAGBLOCK);
-	*stat = i;
-	return 0;
-}
+#ifdef XFS_BTREE_TRACE
+	.trace_enter		= xfs_inobt_trace_enter,
+	.trace_cursor		= xfs_inobt_trace_cursor,
+	.trace_key		= xfs_inobt_trace_key,
+	.trace_record		= xfs_inobt_trace_record,
+#endif
+};
 
 /*
- * Lookup the record equal to ino in the btree given by cur.
+ * Allocate a new inode btree cursor.
  */
-int					/* error */
-xfs_inobt_lookup_eq(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	xfs_agino_t	ino,		/* starting inode of chunk */
-	__int32_t	fcnt,		/* free inode count */
-	xfs_inofree_t	free,		/* free inode mask */
-	int		*stat)		/* success/failure */
+struct xfs_btree_cur *				/* new inode btree cursor */
+xfs_inobt_init_cursor(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_buf		*agbp,		/* buffer for agi structure */
+	xfs_agnumber_t		agno)		/* allocation group number */
 {
-	cur->bc_rec.i.ir_startino = ino;
-	cur->bc_rec.i.ir_freecount = fcnt;
-	cur->bc_rec.i.ir_free = free;
-	return xfs_inobt_lookup(cur, XFS_LOOKUP_EQ, stat);
-}
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+	struct xfs_btree_cur	*cur;
 
-/*
- * Lookup the first record greater than or equal to ino
- * in the btree given by cur.
- */
-int					/* error */
-xfs_inobt_lookup_ge(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	xfs_agino_t	ino,		/* starting inode of chunk */
-	__int32_t	fcnt,		/* free inode count */
-	xfs_inofree_t	free,		/* free inode mask */
-	int		*stat)		/* success/failure */
-{
-	cur->bc_rec.i.ir_startino = ino;
-	cur->bc_rec.i.ir_freecount = fcnt;
-	cur->bc_rec.i.ir_free = free;
-	return xfs_inobt_lookup(cur, XFS_LOOKUP_GE, stat);
-}
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
 
-/*
- * Lookup the first record less than or equal to ino
- * in the btree given by cur.
- */
-int					/* error */
-xfs_inobt_lookup_le(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	xfs_agino_t	ino,		/* starting inode of chunk */
-	__int32_t	fcnt,		/* free inode count */
-	xfs_inofree_t	free,		/* free inode mask */
-	int		*stat)		/* success/failure */
-{
-	cur->bc_rec.i.ir_startino = ino;
-	cur->bc_rec.i.ir_freecount = fcnt;
-	cur->bc_rec.i.ir_free = free;
-	return xfs_inobt_lookup(cur, XFS_LOOKUP_LE, stat);
-}
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_nlevels = be32_to_cpu(agi->agi_level);
+	cur->bc_btnum = XFS_BTNUM_INO;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
-/*
- * Update the record referred to by cur, to the value given
- * by [ino, fcnt, free].
- * This either works (return 0) or gets an EFSCORRUPTED error.
- */
-int					/* error */
-xfs_inobt_update(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agino_t		ino,	/* starting inode of chunk */
-	__int32_t		fcnt,	/* free inode count */
-	xfs_inofree_t		free)	/* free inode mask */
-{
-	xfs_inobt_block_t	*block;	/* btree block to update */
-	xfs_buf_t		*bp;	/* buffer containing btree block */
-	int			error;	/* error return value */
-	int			ptr;	/* current record number (updating) */
-	xfs_inobt_rec_t		*rp;	/* pointer to updated record */
+	cur->bc_ops = &xfs_inobt_ops;
 
-	/*
-	 * Pick up the current block.
-	 */
-	bp = cur->bc_bufs[0];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, 0, bp)))
-		return error;
-#endif
-	/*
-	 * Get the address of the rec to be updated.
-	 */
-	ptr = cur->bc_ptrs[0];
-	rp = XFS_INOBT_REC_ADDR(block, ptr, cur);
-	/*
-	 * Fill in the new contents and log them.
-	 */
-	rp->ir_startino = cpu_to_be32(ino);
-	rp->ir_freecount = cpu_to_be32(fcnt);
-	rp->ir_free = cpu_to_be64(free);
-	xfs_inobt_log_recs(cur, bp, ptr, ptr);
-	/*
-	 * Updating first record in leaf. Pass new key value up to our parent.
-	 */
-	if (ptr == 1) {
-		xfs_inobt_key_t	key;	/* key containing [ino] */
+	cur->bc_private.a.agbp = agbp;
+	cur->bc_private.a.agno = agno;
 
-		key.ir_startino = cpu_to_be32(ino);
-		if ((error = xfs_inobt_updkey(cur, &key, 1)))
-			return error;
-	}
-	return 0;
+	return cur;
 }
Index: xfs-cmds/xfsprogs/include/xfs_btree_trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs-cmds/xfsprogs/include/xfs_btree_trace.h	2008-09-24 20:01:15.000000000 +0200
@@ -0,0 +1,116 @@
+/*
+ * Copyright (c) 2008 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_BTREE_TRACE_H__
+#define	__XFS_BTREE_TRACE_H__
+
+struct xfs_btree_cur;
+struct xfs_buf;
+
+
+/*
+ * Trace hooks.
+ * i,j = integer (32 bit)
+ * b = btree block buffer (xfs_buf_t)
+ * p = btree ptr
+ * r = btree record
+ * k = btree key
+ */
+
+#ifdef XFS_BTREE_TRACE
+
+/*
+ * Trace buffer entry types.
+ */
+#define XFS_BTREE_KTRACE_ARGBI   1
+#define XFS_BTREE_KTRACE_ARGBII  2
+#define XFS_BTREE_KTRACE_ARGFFFI 3
+#define XFS_BTREE_KTRACE_ARGI    4
+#define XFS_BTREE_KTRACE_ARGIPK  5
+#define XFS_BTREE_KTRACE_ARGIPR  6
+#define XFS_BTREE_KTRACE_ARGIK   7
+#define XFS_BTREE_KTRACE_ARGR	 8
+#define XFS_BTREE_KTRACE_CUR     9
+
+/*
+ * Sub-types for cursor traces.
+ */
+#define XBT_ARGS	0
+#define XBT_ENTRY	1
+#define XBT_ERROR	2
+#define XBT_EXIT	3
+
+void xfs_btree_trace_argbi(const char *, struct xfs_btree_cur *,
+		struct xfs_buf *, int, int);
+void xfs_btree_trace_argbii(const char *, struct xfs_btree_cur *,
+		struct xfs_buf *, int, int, int);
+void xfs_btree_trace_argfffi(const char *, struct xfs_btree_cur *,
+		xfs_dfiloff_t, xfs_dfsbno_t, xfs_dfilblks_t, int, int);
+void xfs_btree_trace_argi(const char *, struct xfs_btree_cur *, int, int);
+void xfs_btree_trace_argipk(const char *, struct xfs_btree_cur *, int,
+		union xfs_btree_ptr, union xfs_btree_key *, int);
+void xfs_btree_trace_argipr(const char *, struct xfs_btree_cur *, int,
+		union xfs_btree_ptr, union xfs_btree_rec *, int);
+void xfs_btree_trace_argik(const char *, struct xfs_btree_cur *, int,
+		union xfs_btree_key *, int);
+void xfs_btree_trace_argr(const char *, struct xfs_btree_cur *,
+		union xfs_btree_rec *, int);
+void xfs_btree_trace_cursor(const char *, struct xfs_btree_cur *, int, int);
+
+
+#define XFS_ALLOCBT_TRACE_SIZE	4096	/* size of global trace buffer */
+extern ktrace_t	*xfs_allocbt_trace_buf;
+
+#define XFS_INOBT_TRACE_SIZE	4096	/* size of global trace buffer */
+extern ktrace_t	*xfs_inobt_trace_buf;
+
+#define XFS_BMBT_TRACE_SIZE	4096	/* size of global trace buffer */
+#define XFS_BMBT_KTRACE_SIZE	32	/* size of per-inode trace buffer */
+extern ktrace_t	*xfs_bmbt_trace_buf;
+
+
+#define	XFS_BTREE_TRACE_ARGBI(c, b, i)	\
+	xfs_btree_trace_argbi(__func__, c, b, i, __LINE__)
+#define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)	\
+	xfs_btree_trace_argbii(__func__, c, b, i, j, __LINE__)
+#define	XFS_BTREE_TRACE_ARGFFFI(c, o, b, i, j)	\
+	xfs_btree_trace_argfffi(__func__, c, o, b, i, j, __LINE__)
+#define	XFS_BTREE_TRACE_ARGI(c, i)	\
+	xfs_btree_trace_argi(__func__, c, i, __LINE__)
+#define	XFS_BTREE_TRACE_ARGIPK(c, i, p, k)	\
+	xfs_btree_trace_argipk(__func__, c, i, p, k, __LINE__)
+#define	XFS_BTREE_TRACE_ARGIPR(c, i, p, r)	\
+	xfs_btree_trace_argipr(__func__, c, i, p, r, __LINE__)
+#define	XFS_BTREE_TRACE_ARGIK(c, i, k)	\
+	xfs_btree_trace_argik(__func__, c, i, k, __LINE__)
+#define XFS_BTREE_TRACE_ARGR(c, r)	\
+	xfs_btree_trace_argr(__func__, c, r, __LINE__)
+#define	XFS_BTREE_TRACE_CURSOR(c, t)	\
+	xfs_btree_trace_cursor(__func__, c, t, __LINE__)
+#else
+#define	XFS_BTREE_TRACE_ARGBI(c, b, i)
+#define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)
+#define	XFS_BTREE_TRACE_ARGFFFI(c, o, b, i, j)
+#define	XFS_BTREE_TRACE_ARGI(c, i)
+#define	XFS_BTREE_TRACE_ARGIPK(c, i, p, s)
+#define	XFS_BTREE_TRACE_ARGIPR(c, i, p, r)
+#define	XFS_BTREE_TRACE_ARGIK(c, i, k)
+#define XFS_BTREE_TRACE_ARGR(c, r)
+#define	XFS_BTREE_TRACE_CURSOR(c, t)
+#endif	/* XFS_BTREE_TRACE */
+
+#endif /* __XFS_BTREE_TRACE_H__ */
Index: xfs-cmds/xfsprogs/include/libxfs.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/libxfs.h	2008-09-24 19:50:59.000000000 +0200
+++ xfs-cmds/xfsprogs/include/libxfs.h	2008-09-24 20:01:15.000000000 +0200
@@ -52,6 +52,7 @@
 #include <xfs/xfs_inode_item.h>
 #include <xfs/xfs_alloc.h>
 #include <xfs/xfs_btree.h>
+#include <xfs/xfs_btree_trace.h>
 #include <xfs/xfs_bmap.h>
 
 
Index: xfs-cmds/xfsprogs/db/metadump.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/metadump.c	2008-09-24 20:01:19.000000000 +0200
+++ xfs-cmds/xfsprogs/db/metadump.c	2008-09-24 20:01:34.000000000 +0200
@@ -181,7 +181,7 @@ scan_btree(
 	int		level,
 	typnm_t		btype,
 	void		*arg,
-	int		(*func)(xfs_btree_hdr_t		*bthdr,
+	int		(*func)(struct xfs_btree_block	*block,
 				xfs_agnumber_t		agno,
 				xfs_agblock_t		agbno,
 				int			level,
@@ -231,7 +231,7 @@ valid_bno(
 
 static int
 scanfunc_freesp(
-	xfs_btree_hdr_t		*bthdr,
+	struct xfs_btree_block	*block,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	int			level,
@@ -245,7 +245,7 @@ scanfunc_freesp(
 	if (level == 0)
 		return 1;
 
-	numrecs = be16_to_cpu(bthdr->bb_numrecs);
+	numrecs = be16_to_cpu(block->bb_numrecs);
 	if (numrecs > mp->m_alloc_mxr[1]) {
 		if (show_warnings)
 			print_warning("invalid numrecs (%u) in %s block %u/%u",
@@ -253,7 +253,7 @@ scanfunc_freesp(
 		return 1;
 	}
 
-	pp = XFS_BTREE_PTR_ADDR(xfs_alloc, bthdr, 1, mp->m_alloc_mxr[1]);
+	pp = XFS_BTREE_PTR_ADDR(xfs_alloc, block, 1, mp->m_alloc_mxr[1]);
 	for (i = 0; i < numrecs; i++) {
 		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
 			if (show_warnings)
@@ -993,7 +993,7 @@ process_bmbt_reclist(
 
 static int
 scanfunc_bmap(
-	xfs_btree_hdr_t		*bthdr,
+	struct xfs_btree_block	*block,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	int			level,
@@ -1004,7 +1004,7 @@ scanfunc_bmap(
 	xfs_bmbt_ptr_t		*pp;
 	int			nrecs;
 
-	nrecs = be16_to_cpu(bthdr->bb_numrecs);
+	nrecs = be16_to_cpu(block->bb_numrecs);
 
 	if (level == 0) {
 		if (nrecs > mp->m_bmap_dmxr[0]) {
@@ -1015,7 +1015,7 @@ scanfunc_bmap(
 			return 1;
 		}
 		return process_bmbt_reclist(XFS_BTREE_REC_ADDR(xfs_bmbt, 
-					bthdr, 1), nrecs, *(typnm_t*)arg);
+					block, 1), nrecs, *(typnm_t*)arg);
 	}
 
 	if (nrecs > mp->m_bmap_dmxr[1]) {
@@ -1024,7 +1024,7 @@ scanfunc_bmap(
 					nrecs, typtab[btype].name, agno, agbno);
 		return 1;
 	}
-	pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, bthdr, 1, mp->m_bmap_dmxr[1]);
+	pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, 1, mp->m_bmap_dmxr[1]);
 	for (i = 0; i < nrecs; i++) {
 		xfs_agnumber_t	ag;
 		xfs_agblock_t	bno;
@@ -1302,7 +1302,7 @@ pop_out:
 
 static int
 scanfunc_ino(
-	xfs_btree_hdr_t		*bthdr,
+	struct xfs_btree_block	*block,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	int			level,
@@ -1314,7 +1314,7 @@ scanfunc_ino(
 	int			i;
 	int			numrecs;
 
-	numrecs = be16_to_cpu(bthdr->bb_numrecs);
+	numrecs = be16_to_cpu(block->bb_numrecs);
 
 	if (level == 0) {
 		if (numrecs > mp->m_inobt_mxr[0]) {
@@ -1324,7 +1324,7 @@ scanfunc_ino(
 					typtab[btype].name, agno, agbno);
 			numrecs = mp->m_inobt_mxr[0];
 		}
-		rp = XFS_BTREE_REC_ADDR(xfs_inobt, bthdr, 1);
+		rp = XFS_BTREE_REC_ADDR(xfs_inobt, block, 1);
 		for (i = 0; i < numrecs; i++, rp++) {
 			if (!copy_inode_chunk(agno, rp))
 				return 0;
@@ -1339,7 +1339,7 @@ scanfunc_ino(
 		numrecs = mp->m_inobt_mxr[1];
 	}
 
-	pp = XFS_BTREE_PTR_ADDR(xfs_inobt, bthdr, 1, mp->m_inobt_mxr[1]);
+	pp = XFS_BTREE_PTR_ADDR(xfs_inobt, block, 1, mp->m_inobt_mxr[1]);
 	for (i = 0; i < numrecs; i++) {
 		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
 			if (show_warnings)
