Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 01:19:17 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA69Ihsn002714
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 01:18:45 -0800
Date: Tue, 6 Nov 2007 20:18:36 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH,RFC] Factor some btree code....
Message-ID: <20071106091836.GV995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


Only a small patch. ;)

basically, I need to introduce new formats to some of the btree block
fields (crc, uuids) for resilience and recovery purposes. Rather than
have to copy large chunks of three separate btree implementations, I
decided that I'd factor them into one implementation first.

The approach I took was to build a bunch of ops structures taht each
different btree structure could implement. basically, all the btrees
do the same fundamental operations, so it shoul dbe easy to do. Right?

I've formed a "btree core" set of functions that operation on:

	xfs_btree_block_t	- a generic btree block
	xfs_btree_key_t		- a union of the different key types
	xfs_btree_ptr_t		- a union of the different pointer types
	xfs_btree_rec_t		- a union of the different record types

These are passed around the core btree code in disk endian format
and the callouts convert to/from disk endian format as needed.
there are operations for intialising keys, ptrs and records from
either the cursor or other keys or records. There are operations
for moving them, getting the address within the block of a given
index within a block, logging the changes made etc.

There's various block operations e.g. allocating and freeing blocks,
logging block headers, etc in a separate ops structure.

Some of the remaining operations are lumped into a "cursor ops"
structure - I think I'll probably fold them back into the block
ops structure, or even just make it one large ops structure for
everything - there's really no need for multiple ops structures,
except for....

... the btree tracing code. I haven't completed that yet, but the
btree core inherits the tracing code from the bmap btree code, so
we'll have fined grained tracing on all btree operations once this
is complete.

The core btree code also got factored and commenting was improved;
the result is that the code is now readable and understandable, which
it certainly wasn't before I began this.

A further feature is that the core btree code now supports the btree
root being placed in an inode. I still need to move the extent format
code into the core as well as some of the root manipulation code,
but in future the only difference between a pointer rooted btree
(eg freespace trees) and an inode rooted btree (inode extent btree)
will be a single flag being set in during the btree cursor initialisation.

The result of all this is a massive patch that cleans up a lot of stuff,
introduces new functionality into the btree code and reduces each btree
implementation down to a relatively simple set of operations to write.
The freespace btrees (xfs_alloc_btree.c) have gone from 2200 lines to 900,
the inode btree (xfs_ialloc_btree.c) has gone from 2000 lines to less than
800, and the bmap btree has gone from ~2600 lines to ~1400. There's
probably more this can be reduced as well.

On top of this, modifying the btree structures will now involve writing
only a handful of new functions to be written instead of duplicating
most of those three files mentioned above.

The next question - does it work? Well, apart from test 042 (massively
fragmented file and freespace btree) and occasional 013 (fstress) and
083 (fstress @ ENOSPC) corruptions, it runs fine. Indeed, I just did
an apt-get update that replaced about 500MB of the binaries on the root
drive of my test box, updated a git tree and rebuilt a kernel and the
filesystem survived that just fine.

So, while I would not recommend it for production yet, it's definitely
usable. The probelms remaining stem from level 3 btrees and larger,
and I need the btree tracing code working to trace those problems (it
doesn't work yet).

There's plenty still to clean up in the patch, but I thought that pushing
it out early for comment would be better than leaving it until I had
everything working.

Thoughts, comments, flames?

(Eric, I'm looking at you and your 3-way diffstats ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs.h              |    2 
 fs/xfs/xfs_alloc.c        |   48 
 fs/xfs/xfs_alloc_btree.c  | 2611 +++++++++---------------------------
 fs/xfs/xfs_alloc_btree.h  |    2 
 fs/xfs/xfs_bmap.c         |   58 
 fs/xfs/xfs_bmap_btree.c   | 3307 ++++++++++++++--------------------------------
 fs/xfs/xfs_bmap_btree.h   |    8 
 fs/xfs/xfs_btree.c        |  351 +++-
 fs/xfs/xfs_btree.h        |  419 +++++
 fs/xfs/xfs_btree_core.c   | 2299 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_btree_trace.c  |  202 ++
 fs/xfs/xfs_ialloc.c       |   24 
 fs/xfs/xfs_ialloc_btree.c | 2399 +++++++--------------------------
 fs/xfs/xfs_ialloc_btree.h |    2 
 fs/xfs/xfs_itable.c       |    6 
 15 files changed, 5497 insertions(+), 6241 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs.h	2007-09-12 15:41:22.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs.h	2007-11-06 19:40:29.694676106 +1100
@@ -30,7 +30,7 @@
 #define XFS_ATTR_TRACE 1
 #define XFS_BLI_TRACE 1
 #define XFS_BMAP_TRACE 1
-#define XFS_BMBT_TRACE 1
+#define XFS_BTREE_TRACE 1
 #define XFS_DIR2_TRACE 1
 #define XFS_DQUOT_TRACE 1
 #define XFS_ILOCK_TRACE 1
Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc.c	2007-10-16 08:52:58.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc.c	2007-11-06 19:40:29.694676106 +1100
@@ -334,7 +334,7 @@ xfs_alloc_fixup_trees(
 	/*
 	 * Delete the entry from the by-size btree.
 	 */
-	if ((error = xfs_alloc_delete(cnt_cur, &i)))
+	if ((error = xfs_btree_delete(cnt_cur, &i)))
 		return error;
 	XFS_WANT_CORRUPTED_RETURN(i == 1);
 	/*
@@ -344,7 +344,7 @@ xfs_alloc_fixup_trees(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno1, nflen1, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 0);
-		if ((error = xfs_alloc_insert(cnt_cur, &i)))
+		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	}
@@ -352,7 +352,7 @@ xfs_alloc_fixup_trees(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno2, nflen2, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 0);
-		if ((error = xfs_alloc_insert(cnt_cur, &i)))
+		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	}
@@ -363,7 +363,7 @@ xfs_alloc_fixup_trees(
 		/*
 		 * No remaining freespace, just delete the by-block tree entry.
 		 */
-		if ((error = xfs_alloc_delete(bno_cur, &i)))
+		if ((error = xfs_btree_delete(bno_cur, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	} else {
@@ -380,7 +380,7 @@ xfs_alloc_fixup_trees(
 		if ((error = xfs_alloc_lookup_eq(bno_cur, nfbno2, nflen2, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 0);
-		if ((error = xfs_alloc_insert(bno_cur, &i)))
+		if ((error = xfs_btree_insert(bno_cur, &i)))
 			return error;
 		XFS_WANT_CORRUPTED_RETURN(i == 1);
 	}
@@ -819,7 +819,7 @@ xfs_alloc_ag_vextent_near(
 				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 				if (ltlen >= args->minlen)
 					break;
-				if ((error = xfs_alloc_increment(cnt_cur, 0, &i)))
+				if ((error = xfs_btree_increment(cnt_cur, 0, &i)))
 					goto error0;
 			} while (i);
 			ASSERT(ltlen >= args->minlen);
@@ -829,7 +829,7 @@ xfs_alloc_ag_vextent_near(
 		i = cnt_cur->bc_ptrs[0];
 		for (j = 1, blen = 0, bdiff = 0;
 		     !error && j && (blen < args->maxlen || bdiff > 0);
-		     error = xfs_alloc_increment(cnt_cur, 0, &j)) {
+		     error = xfs_btree_increment(cnt_cur, 0, &j)) {
 			/*
 			 * For each entry, decide if it's better than
 			 * the previous best entry.
@@ -939,7 +939,7 @@ xfs_alloc_ag_vextent_near(
 	 * Increment the cursor, so we will point at the entry just right
 	 * of the leftward entry if any, or to the leftmost entry.
 	 */
-	if ((error = xfs_alloc_increment(bno_cur_gt, 0, &i)))
+	if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
 		goto error0;
 	if (!i) {
 		/*
@@ -962,7 +962,7 @@ xfs_alloc_ag_vextent_near(
 					args->alignment, args->minlen,
 					&ltbnoa, &ltlena))
 				break;
-			if ((error = xfs_alloc_decrement(bno_cur_lt, 0, &i)))
+			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
 				goto error0;
 			if (!i) {
 				xfs_btree_del_cursor(bno_cur_lt,
@@ -978,7 +978,7 @@ xfs_alloc_ag_vextent_near(
 					args->alignment, args->minlen,
 					&gtbnoa, &gtlena))
 				break;
-			if ((error = xfs_alloc_increment(bno_cur_gt, 0, &i)))
+			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
 				goto error0;
 			if (!i) {
 				xfs_btree_del_cursor(bno_cur_gt,
@@ -1067,7 +1067,7 @@ xfs_alloc_ag_vextent_near(
 					/*
 					 * Fell off the right end.
 					 */
-					if ((error = xfs_alloc_increment(
+					if ((error = xfs_btree_increment(
 							bno_cur_gt, 0, &i)))
 						goto error0;
 					if (!i) {
@@ -1163,7 +1163,7 @@ xfs_alloc_ag_vextent_near(
 					/*
 					 * Fell off the left end.
 					 */
-					if ((error = xfs_alloc_decrement(
+					if ((error = xfs_btree_decrement(
 							bno_cur_lt, 0, &i)))
 						goto error0;
 					if (!i) {
@@ -1322,7 +1322,7 @@ xfs_alloc_ag_vextent_size(
 		bestflen = flen;
 		bestfbno = fbno;
 		for (;;) {
-			if ((error = xfs_alloc_decrement(cnt_cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cnt_cur, 0, &i)))
 				goto error0;
 			if (i == 0)
 				break;
@@ -1417,7 +1417,7 @@ xfs_alloc_ag_vextent_small(
 	xfs_extlen_t	flen;
 	int		i;
 
-	if ((error = xfs_alloc_decrement(ccur, 0, &i)))
+	if ((error = xfs_btree_decrement(ccur, 0, &i)))
 		goto error0;
 	if (i) {
 		if ((error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i)))
@@ -1550,7 +1550,7 @@ xfs_free_ag_extent(
 	 * Look for a neighboring block on the right (higher block numbers)
 	 * that is contiguous with this space.
 	 */
-	if ((error = xfs_alloc_increment(bno_cur, 0, &haveright)))
+	if ((error = xfs_btree_increment(bno_cur, 0, &haveright)))
 		goto error0;
 	if (haveright) {
 		/*
@@ -1589,7 +1589,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_delete(cnt_cur, &i)))
+		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		/*
@@ -1598,19 +1598,19 @@ xfs_free_ag_extent(
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
@@ -1649,14 +1649,14 @@ xfs_free_ag_extent(
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
@@ -1675,7 +1675,7 @@ xfs_free_ag_extent(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		if ((error = xfs_alloc_delete(cnt_cur, &i)))
+		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		/*
@@ -1694,7 +1694,7 @@ xfs_free_ag_extent(
 	else {
 		nbno = bno;
 		nlen = len;
-		if ((error = xfs_alloc_insert(bno_cur, &i)))
+		if ((error = xfs_btree_insert(bno_cur, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	}
@@ -1706,7 +1706,7 @@ xfs_free_ag_extent(
 	if ((error = xfs_alloc_lookup_eq(cnt_cur, nbno, nlen, &i)))
 		goto error0;
 	XFS_WANT_CORRUPTED_GOTO(i == 0, error0);
-	if ((error = xfs_alloc_insert(cnt_cur, &i)))
+	if ((error = xfs_btree_insert(cnt_cur, &i)))
 		goto error0;
 	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc_btree.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc_btree.c	2007-05-22 19:04:51.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc_btree.c	2007-11-06 19:40:29.702675076 +1100
@@ -39,519 +39,119 @@
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 
+
 /*
- * Prototypes for internal functions.
+ * Get the block pointer for the given level of the cursor.
+ * Fill in the buffer pointer, if applicable.
  */
+STATIC xfs_btree_block_t *
+xfs_alloc_get_block(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	xfs_buf_t		**bpp)
+{
+	ASSERT(level < cur->bc_nlevels);
+	*bpp = cur->bc_bufs[level];
+	return (xfs_btree_block_t *)XFS_BUF_TO_ALLOC_BLOCK(*bpp);
+}
 
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
 
-/*
- * Internal functions.
- */
+STATIC int
+xfs_alloc_get_buf(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr,
+	int		flags,
+	xfs_buf_t	**bpp)
+{
+	xfs_buf_t	*bp;
 
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
+	bp = xfs_btree_get_bufs(cur->bc_mp, cur->bc_tp, cur->bc_private.a.agno,
+				be32_to_cpu(ptr->u.alloc), flags);
+	*bpp = bp;
+	return 0;
+
+}
+
+STATIC int
+xfs_alloc_read_buf(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr,
+	int		flags,
+	xfs_buf_t	**bpp)
 {
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
+	return xfs_btree_read_bufs(cur->bc_mp,
+				cur->bc_tp, cur->bc_private.a.agno,
+				be32_to_cpu(ptr->u.alloc), flags,
+				bpp, XFS_ALLOC_BTREE_REF);
+}
 
+STATIC xfs_btree_block_t *
+xfs_alloc_buf_to_block(
+	xfs_btree_cur_t	*cur,
+	xfs_buf_t	*bp)
+{
+	/* XFS_BUF_TO_ALLOC_BLOCK(rbp); */
+	return XFS_BUF_TO_BLOCK(bp);
+}
+
+STATIC void
+xfs_alloc_buf_to_ptr(
+	xfs_btree_cur_t	*cur,
+	xfs_buf_t	*bp,
+	xfs_btree_ptr_t	*ptr)
+{
+	ptr->u.alloc = cpu_to_be32(XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(bp)));
+}
+
+STATIC int
+xfs_alloc_alloc_block(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*start,
+	xfs_btree_ptr_t	*new,
+	int		length,
+	int		*stat)
+{
+	int		error;
+	xfs_agblock_t	bno;
+
+	XFS_BTREE_TRACE_CURSOR(cur, ENTER);
 	/*
-	 * Get the index of the entry being deleted, check for nothing there.
-	 */
-	ptr = cur->bc_ptrs[level];
-	if (ptr == 0) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Get the buffer & block containing the record or key/ptr.
+	 * Allocate the new block from the freelist.
+	 * If we can't do it, we're toast.  Give up.
 	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
+	error = xfs_alloc_get_freelist(cur->bc_tp,
+				cur->bc_private.a.agbp, &bno, 1);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, ERROR);
 		return error;
-#endif
-	/*
-	 * Fail if we're off the end of the block.
-	 */
-	numrecs = be16_to_cpu(block->bb_numrecs);
-	if (ptr > numrecs) {
+	}
+	if (bno == NULLAGBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, EXIT);
 		*stat = 0;
 		return 0;
 	}
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
+	xfs_trans_agbtree_delta(cur->bc_tp, 1);
+	XFS_BTREE_TRACE_CURSOR(cur, EXIT);
+	new->u.alloc = cpu_to_be32(bno);
+	*stat = 1;
+	return 0;
+}
+
+STATIC int
+xfs_alloc_free_block(
+	xfs_btree_cur_t	*cur,
+	xfs_buf_t	*bp,
+	int		size)
+{
+	xfs_agf_t		*agf;	/* allocation group freelist header */
+	int			error;
+	xfs_agblock_t		bno;
+
+	bno = XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(bp));
 	agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-	mp = cur->bc_mp;
 
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
-			be32_add(&agf->agf_levels[cur->bc_btnum], -1);
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
+	error = xfs_alloc_put_freelist(cur->bc_tp, cur->bc_private.a.agbp,
+						NULL, bno, size);
 	if (error)
 		return error;
 	/*
@@ -568,278 +168,15 @@ xfs_alloc_delrec(
 	 */
 	xfs_alloc_mark_busy(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
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
 	return 0;
-
-error0:
-	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-	return error;
 }
 
 /*
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
+ * Log fields from the btree block header.
  */
 STATIC void
 xfs_alloc_log_block(
-	xfs_trans_t		*tp,	/* transaction pointer */
+	xfs_btree_cur_t		*cur,	/* btree cursor */
 	xfs_buf_t		*bp,	/* buffer containing btree block */
 	int			fields)	/* mask of fields: XFS_BB_... */
 {
@@ -854,1243 +191,629 @@ xfs_alloc_log_block(
 		sizeof(xfs_alloc_block_t)
 	};
 
+	XFS_BTREE_TRACE_CURSOR(cur, ENTRY);
+	XFS_BTREE_TRACE_ARGBI(cur, bp, fields);
 	xfs_btree_offsets(fields, offsets, XFS_BB_NUM_BITS, &first, &last);
-	xfs_trans_log_buf(tp, bp, first, last);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	XFS_BTREE_TRACE_CURSOR(cur, EXIT);
 }
 
-/*
- * Log keys from a btree block (nonleaf).
- */
-STATIC void
-xfs_alloc_log_keys(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			kfirst,	/* index of first key to log */
-	int			klast)	/* index of last key to log */
+static const struct xfs_btree_block_ops xfs_alloc_blkops = {
+	.get_buf	= xfs_alloc_get_buf,
+	.read_buf	= xfs_alloc_read_buf,
+	.get_block	= xfs_alloc_get_block,
+	.buf_to_block	= xfs_alloc_buf_to_block,
+	.buf_to_ptr	= xfs_alloc_buf_to_ptr,
+	.log_block	= xfs_alloc_log_block,
+	.check_block	= xfs_btree_check_sblock,
+
+	.alloc_block	= xfs_alloc_alloc_block,
+	.free_block	= xfs_alloc_free_block,
+
+	.get_sibling	= xfs_btree_get_ssibling,
+	.set_sibling	= xfs_btree_set_ssibling,
+	.init_sibling	= xfs_btree_init_sibling,
+};
+
+STATIC int
+xfs_alloc_get_minrecs(
+	xfs_btree_cur_t	*cur,
+	int		lev)
 {
-	xfs_alloc_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	xfs_alloc_key_t		*kp;	/* key pointer in btree block */
-	int			last;	/* last byte offset logged */
+	return cur->bc_mp->m_alloc_mnr[lev != 0];
+}
 
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-	kp = XFS_ALLOC_KEY_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+STATIC int
+xfs_alloc_get_maxrecs(
+	xfs_btree_cur_t	*cur,
+	int		lev)
+{
+	return cur->bc_mp->m_alloc_mxr[lev != 0];
 }
 
-/*
- * Log block pointer fields from a btree block (nonleaf).
- */
-STATIC void
-xfs_alloc_log_ptrs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			pfirst,	/* index of first pointer to log */
-	int			plast)	/* index of last pointer to log */
+STATIC int
+xfs_btree_get_numrecs(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block)
 {
-	xfs_alloc_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	xfs_alloc_ptr_t		*pp;	/* block-pointer pointer in btree blk */
+	BUG_ON(be16_to_cpu(block->bb_h.bb_numrecs) < 0);
+	BUG_ON(be16_to_cpu(block->bb_h.bb_numrecs) > 1000);
+	return be16_to_cpu(block->bb_h.bb_numrecs);
+}
 
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-	pp = XFS_ALLOC_PTR_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+STATIC void
+xfs_btree_set_numrecs(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block,
+	int			numrecs)
+{
+	BUG_ON(numrecs < 0);
+	BUG_ON(numrecs > 1000);
+	block->bb_h.bb_numrecs = cpu_to_be16(numrecs);
 }
 
-/*
- * Log records from a btree block (leaf).
- */
 STATIC void
-xfs_alloc_log_recs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			rfirst,	/* index of first record to log */
-	int			rlast)	/* index of last record to log */
+xfs_alloc_init_key_from_rec(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_key_t	*key,
+	xfs_btree_rec_t	*rec)
 {
-	xfs_alloc_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	xfs_alloc_rec_t		*rp;	/* record pointer for btree block */
-
-
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
+	key->u.alloc.ar_startblock = rec->u.alloc.ar_startblock;
+	key->u.alloc.ar_blockcount = rec->u.alloc.ar_blockcount;
+	BUG_ON(key->u.alloc.ar_startblock == 0);
 }
 
 /*
- * Lookup the record.  The cursor is made to point to it, based on dir.
- * Return 0 if can't find any such record, 1 for success.
+ * intial value of ptr for lookup
  */
-STATIC int				/* error */
-xfs_alloc_lookup(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_lookup_t		dir,	/* <=, ==, or >= */
-	int			*stat)	/* success/failure */
+STATIC void
+xfs_alloc_init_ptr_from_cur(
+	xfs_btree_cur_t *cur,
+	xfs_btree_ptr_t	*ptr)
 {
-	xfs_agblock_t		agbno;	/* a.g. relative btree block number */
-	xfs_agnumber_t		agno;	/* allocation group number */
-	xfs_alloc_block_t	*block=NULL;	/* current btree block */
-	int			diff;	/* difference for the current key */
-	int			error;	/* error return value */
-	int			keyno=0;	/* current key number */
-	int			level;	/* level in the btree */
-	xfs_mount_t		*mp;	/* file system mount point */
+	xfs_agf_t	*agf;	/* a.g. freespace header */
 
-	XFS_STATS_INC(xs_abt_lookup);
-	/*
-	 * Get the allocation group header, and the root block number.
-	 */
-	mp = cur->bc_mp;
+	agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
+	ptr->u.alloc = agf->agf_roots[cur->bc_btnum];
+	BUG_ON(ptr->u.alloc == 0);
+}
 
-	{
-		xfs_agf_t	*agf;	/* a.g. freespace header */
+STATIC void
+xfs_alloc_init_rec_from_key(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_key_t	*key,
+	xfs_btree_rec_t	*rec)
+{
+	BUG_ON(key->u.alloc.ar_startblock == 0);
+	rec->u.alloc.ar_startblock = key->u.alloc.ar_startblock;
+	rec->u.alloc.ar_blockcount = key->u.alloc.ar_blockcount;
+}
 
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
+STATIC void
+xfs_alloc_init_rec_from_cur(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_rec_t	*rec)
+{
+	BUG_ON(cur->bc_rec.a.ar_startblock == 0);
+	rec->u.alloc.ar_startblock = cpu_to_be32(cur->bc_rec.a.ar_startblock);
+	rec->u.alloc.ar_blockcount = cpu_to_be32(cur->bc_rec.a.ar_blockcount);
 }
 
-/*
- * Move 1 record left from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int				/* error */
-xfs_alloc_lshift(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to shift record on */
-	int			*stat)	/* success/failure */
+STATIC xfs_btree_key_t *
+xfs_alloc_key_addr(
+	xfs_btree_cur_t		*cur,
+	int			index,
+	xfs_btree_block_t	*block)
 {
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
+	return (xfs_btree_key_t *)XFS_ALLOC_KEY_ADDR(&block->bb_h, index, cur);
+}
 
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
+STATIC xfs_btree_ptr_t *
+xfs_alloc_ptr_addr(
+	xfs_btree_cur_t		*cur,
+	int			index,
+	xfs_btree_block_t	*block)
+{
+	return (xfs_btree_ptr_t *)XFS_ALLOC_PTR_ADDR(&block->bb_h, index, cur);
+}
 
-		lrp = XFS_ALLOC_REC_ADDR(left, nrec, cur);
-		rrp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-		*lrp = *rrp;
-		xfs_alloc_log_recs(cur, lbp, nrec, nrec);
-		xfs_btree_check_rec(cur->bc_btnum, lrp - 1, lrp);
-	}
-	/*
-	 * Bump and log left's numrecs, decrement and log right's numrecs.
-	 */
-	be16_add(&left->bb_numrecs, 1);
-	xfs_alloc_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-	be16_add(&right->bb_numrecs, -1);
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
+STATIC xfs_btree_rec_t *
+xfs_alloc_rec_addr(
+	xfs_btree_cur_t		*cur,
+	int			index,
+	xfs_btree_block_t	*block)
+{
+	return (xfs_btree_rec_t *)XFS_ALLOC_REC_ADDR(&block->bb_h, index, cur);
 }
 
-/*
- * Allocate a new root block, fill it in.
- */
-STATIC int				/* error */
-xfs_alloc_newroot(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			*stat)	/* success/failure */
+STATIC int64_t
+xfs_alloc_key_diff(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_key_t		*key)
 {
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
+	xfs_alloc_rec_incore_t	*rec = &cur->bc_rec.a;
+	xfs_alloc_key_t		*kp = &key->u.alloc;
+	int64_t			diff;
 
-	mp = cur->bc_mp;
+	if (cur->bc_btnum == XFS_BTNUM_BNO)
+		return (int64_t)(be32_to_cpu(kp->ar_startblock)) -
+							rec->ar_startblock;
 
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
+	diff = (int64_t)(be32_to_cpu(kp->ar_blockcount)) - rec->ar_blockcount;
+	if (!diff)
+		diff = (int64_t)(be32_to_cpu(kp->ar_startblock)) -
+							rec->ar_startblock;
+	return diff;
+}
 
-		agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
-		agf->agf_roots[cur->bc_btnum] = cpu_to_be32(nbno);
-		be32_add(&agf->agf_levels[cur->bc_btnum], 1);
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
+STATIC xfs_daddr_t
+xfs_alloc_ptr_to_daddr(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_ptr_t		*ptr)
+{
+	return XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
+				be32_to_cpu(ptr->u.alloc));
+}
 
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
+STATIC void
+xfs_alloc_move_keys(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_key_t		*src_key,
+	xfs_btree_key_t		*dst_key,
+	int			from,
+	int			to,
+	int			numkeys)
+{
+	BUG_ON(from < 0 || to < 0);
+	BUG_ON(from > 1000 || to > 1000);
+	BUG_ON(numkeys < 0);
+
+	/*
+	 * we can get a request to move zero records if the
+	 * block is already empty. e.g. xfs_alloc_fix_freelist
+	 * will delete the current entry and then reinsert a
+	 * modified entry. If there is only a single entry in
+	 * the block, the will result in an empty block.
+	 */
+	if (numkeys == 0)
+		return;
+	if (dst_key == NULL) {
+		/* moving within a block */
+		xfs_alloc_key_t	*kp = &src_key->u.alloc;
+		memmove(&kp[to], &kp[from], numkeys * sizeof(*kp));
+	} else {
+		/* moving between blocks */
+		memcpy(dst_key, src_key, numkeys * sizeof(xfs_alloc_key_t));
 	}
-	xfs_alloc_log_keys(cur, nbp, 1, 2);
-	/*
-	 * Fill in the pointer data in the new root.
-	 */
-	{
-		xfs_alloc_ptr_t		*pp;	/* btree address pointer */
+}
 
-		pp = XFS_ALLOC_PTR_ADDR(new, 1, cur);
-		pp[0] = cpu_to_be32(lbno);
-		pp[1] = cpu_to_be32(rbno);
+STATIC void
+xfs_alloc_move_ptrs(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_ptr_t		*src_ptr,
+	xfs_btree_ptr_t		*dst_ptr,
+	int			from,
+	int			to,
+	int			numptrs)
+{
+	BUG_ON(from < 0 || to < 0);
+	BUG_ON(from > 1000 || to > 1000);
+	BUG_ON(numptrs < 0);
+	if (numptrs == 0)
+		return;
+	if (dst_ptr == NULL) {
+		xfs_alloc_ptr_t	*pp = &src_ptr->u.alloc;
+		memmove(&pp[to], &pp[from], numptrs * sizeof(*pp));
+	} else {
+		memcpy(dst_ptr, src_ptr, numptrs * sizeof(xfs_alloc_ptr_t));
 	}
-	xfs_alloc_log_ptrs(cur, nbp, 1, 2);
-	/*
-	 * Fix up the cursor.
-	 */
-	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
-	cur->bc_ptrs[cur->bc_nlevels] = nptr;
-	cur->bc_nlevels++;
-	*stat = 1;
-	return 0;
 }
 
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
-			0, &rbp, XFS_ALLOC_BTREE_REF)))
-		return error;
-	right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
-	if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-		return error;
-	/*
-	 * If it's full, it can't take another entry.
-	 */
-	if (be16_to_cpu(right->bb_numrecs) == XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
-		*stat = 0;
-		return 0;
-	}
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
+STATIC void
+xfs_alloc_move_recs(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_rec_t		*src_rec,
+	xfs_btree_rec_t		*dst_rec,
+	int			from,
+	int			to,
+	int			numrecs)
+{
+	BUG_ON(from < 0 || to < 0);
+	BUG_ON(from > 1000 || to > 1000);
+	BUG_ON(numrecs < 0);
+	if (numrecs == 0)
+		return;
+	if (dst_rec == NULL) {
+		xfs_alloc_rec_t	*rp = &src_rec->u.alloc;
+		memmove(&rp[to], &rp[from], numrecs * sizeof(*rp));
 	} else {
-		xfs_alloc_rec_t	*lrp;	/* record pointer for left block */
-		xfs_alloc_rec_t	*rrp;	/* record pointer for right block */
-
-		lrp = XFS_ALLOC_REC_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rrp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-		memmove(rrp + 1, rrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		*rrp = *lrp;
-		xfs_alloc_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		key.ar_startblock = rrp->ar_startblock;
-		key.ar_blockcount = rrp->ar_blockcount;
-		rkp = &key;
-		xfs_btree_check_rec(cur->bc_btnum, rrp, rrp + 1);
+		memcpy(dst_rec, src_rec, numrecs * sizeof(xfs_alloc_rec_t));
 	}
-	/*
-	 * Decrement and log left's numrecs, bump and log right's numrecs.
-	 */
-	be16_add(&left->bb_numrecs, -1);
-	xfs_alloc_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-	be16_add(&right->bb_numrecs, 1);
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
-	*stat = 1;
-	return 0;
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
+
+STATIC void
+xfs_alloc_set_key(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_key_t	*key_addr,
+	int		index,
+	xfs_btree_key_t	*newkey)
 {
-	int			error;	/* error return value */
-	int			i;	/* loop index/record number */
-	xfs_agblock_t		lbno;	/* left (current) block number */
-	xfs_buf_t		*lbp;	/* buffer for left block */
-	xfs_alloc_block_t	*left;	/* left (current) btree block */
-	xfs_agblock_t		rbno;	/* right (new) block number */
-	xfs_buf_t		*rbp;	/* buffer for right block */
-	xfs_alloc_block_t	*right;	/* right (new) btree block */
+	xfs_alloc_key_t	*kp = &key_addr->u.alloc;
 
-	/*
-	 * Allocate the new block from the freelist.
-	 * If we can't do it, we're toast.  Give up.
-	 */
-	error = xfs_alloc_get_freelist(cur->bc_tp,
-					 cur->bc_private.a.agbp, &rbno, 1);
-	if (error)
-		return error;
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
-		be16_add(&right->bb_numrecs, 1);
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
-	be16_add(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
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
-	/*
-	 * If there are more levels, we'll need another cursor which refers to
-	 * the right block, no matter where this cursor was.
-	 */
-	if (level + 1 < cur->bc_nlevels) {
-		if ((error = xfs_btree_dup_cursor(cur, curp)))
-			return error;
-		(*curp)->bc_ptrs[level + 1]++;
-	}
-	*bnop = rbno;
-	*stat = 1;
-	return 0;
+	kp[index] = newkey->u.alloc;
+}
+
+STATIC void
+xfs_alloc_set_ptr(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr_addr,
+	int		index,
+	xfs_btree_ptr_t	*newptr)
+{
+	xfs_alloc_ptr_t	*pp = &ptr_addr->u.alloc;
+
+	pp[index] = newptr->u.alloc;
+}
+
+STATIC void
+xfs_alloc_set_rec(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_rec_t	*rec_addr,
+	int		index,
+	xfs_btree_rec_t	*newrec)
+{
+	xfs_alloc_rec_t	*rp = &rec_addr->u.alloc;
+
+	rp[index] = newrec->u.alloc;
 }
 
 /*
- * Update keys at all levels from here to the root along the cursor's path.
+ * Log keys from a btree block (nonleaf).
  */
-STATIC int				/* error */
-xfs_alloc_updkey(
+STATIC void
+xfs_alloc_log_keys(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_alloc_key_t		*keyp,	/* new key value to update to */
-	int			level)	/* starting level for update */
+	xfs_buf_t		*bp,	/* buffer containing btree block */
+	int			kfirst,	/* index of first key to log */
+	int			klast)	/* index of last key to log */
 {
-	int			ptr;	/* index of key in block */
-
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
+	xfs_alloc_block_t	*block;	/* btree block to log from */
+	int			first;	/* first byte offset logged */
+	xfs_alloc_key_t		*kp;	/* key pointer in btree block */
+	int			last;	/* last byte offset logged */
 
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
-	}
-	return 0;
+	XFS_BTREE_TRACE_CURSOR(cur, ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, kfirst, klast);
+	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
+	kp = XFS_ALLOC_KEY_ADDR(block, 1, cur);
+	first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
+	last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	XFS_BTREE_TRACE_CURSOR(cur, EXIT);
 }
 
 /*
- * Externally visible routines.
+ * Log block pointer fields from a btree block (nonleaf).
  */
+STATIC void
+xfs_alloc_log_ptrs(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_buf_t		*bp,	/* buffer containing btree block */
+	int			pfirst,	/* index of first pointer to log */
+	int			plast)	/* index of last pointer to log */
+{
+	xfs_alloc_block_t	*block;	/* btree block to log from */
+	int			first;	/* first byte offset logged */
+	int			last;	/* last byte offset logged */
+	xfs_alloc_ptr_t		*pp;	/* block-pointer pointer in btree blk */
+
+	XFS_BTREE_TRACE_CURSOR(cur, ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, pfirst, plast);
+	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
+	pp = XFS_ALLOC_PTR_ADDR(block, 1, cur);
+	first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
+	last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	XFS_BTREE_TRACE_CURSOR(cur, EXIT);
+}
 
 /*
- * Decrement cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
+ * Log records from a btree block (leaf).
  */
-int					/* error */
-xfs_alloc_decrement(
+STATIC void
+xfs_alloc_log_recs(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree, 0 is leaf */
-	int			*stat)	/* success/failure */
+	xfs_buf_t		*bp,	/* buffer containing btree block */
+	int			rfirst,	/* index of first record to log */
+	int			rlast)	/* index of last record to log */
 {
-	xfs_alloc_block_t	*block;	/* btree block */
-	int			error;	/* error return value */
-	int			lev;	/* btree level */
+	xfs_alloc_block_t	*block;	/* btree block to log from */
+	int			first;	/* first byte offset logged */
+	int			last;	/* last byte offset logged */
+	xfs_alloc_rec_t		*rp;	/* record pointer for btree block */
 
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
+
+	XFS_BTREE_TRACE_CURSOR(cur, ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, rfirst, rlast);
+	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
+	rp = XFS_ALLOC_REC_ADDR(block, 1, cur);
 #ifdef DEBUG
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
+	{
+		xfs_agf_t	*agf;
+		xfs_alloc_rec_t	*p;
+
+		agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+		for (p = &rp[rfirst - 1]; p <= &rp[rlast - 1]; p++)
+			ASSERT(be32_to_cpu(p->ar_startblock) +
+			       be32_to_cpu(p->ar_blockcount) <=
+			       be32_to_cpu(agf->agf_length));
 	}
+#endif
+	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
+	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	XFS_BTREE_TRACE_CURSOR(cur, EXIT);
+}
+
+static const struct xfs_btree_record_ops xfs_alloc_recops = {
+	.get_minrecs	= xfs_alloc_get_minrecs,
+	.get_maxrecs	= xfs_alloc_get_maxrecs,
+	.get_numrecs	= xfs_btree_get_numrecs,
+	.set_numrecs	= xfs_btree_set_numrecs,
+
+	.init_key_from_rec = xfs_alloc_init_key_from_rec,
+	.init_ptr_from_cur = xfs_alloc_init_ptr_from_cur,
+	.init_rec_from_key = xfs_alloc_init_rec_from_key,
+	.init_rec_from_cur = xfs_alloc_init_rec_from_cur,
+
+	.key_addr	= xfs_alloc_key_addr,
+	.ptr_addr	= xfs_alloc_ptr_addr,
+	.rec_addr	= xfs_alloc_rec_addr,
+
+	.key_diff	= xfs_alloc_key_diff,
+	.ptr_to_daddr	= xfs_alloc_ptr_to_daddr,
+
+	.move_keys	= xfs_alloc_move_keys,
+	.move_ptrs	= xfs_alloc_move_ptrs,
+	.move_recs	= xfs_alloc_move_recs,
+
+	.set_key	= xfs_alloc_set_key,
+	.set_ptr	= xfs_alloc_set_ptr,
+	.set_rec	= xfs_alloc_set_rec,
+
+	.log_keys	= xfs_alloc_log_keys,
+	.log_ptrs	= xfs_alloc_log_ptrs,
+	.log_recs	= xfs_alloc_log_recs,
+
+	.check_ptrs	= xfs_btree_check_sptr,
+};
+
+STATIC void
+xfs_alloc_setroot(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr,
+	int		inc)
+{
+	xfs_agf_t	*agf;	/* a.g. freespace header */
+	xfs_agnumber_t	seqno;
+
+	agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+
+	BUG_ON(ptr->u.alloc == 0);
+	agf->agf_roots[cur->bc_btnum] = ptr->u.alloc;
+	be32_add(&agf->agf_levels[cur->bc_btnum], inc);
+
+	seqno = be32_to_cpu(agf->agf_seqno);
+	cur->bc_mp->m_perag[seqno].pagf_levels[cur->bc_btnum] += inc;
+
+	xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp,
+		XFS_AGF_ROOTS | XFS_AGF_LEVELS);
+}
+
+STATIC int
+xfs_alloc_killroot(
+	xfs_btree_cur_t	*cur,
+	int		level,
+	xfs_btree_ptr_t	*newroot)
+{
+	xfs_agf_t		*agf;	/* allocation group freelist header */
+	xfs_agblock_t		bno;	/* old root block number */
+	int			error;
+
+	agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+
 	/*
-	 * March up the tree decrementing pointers.
-	 * Stop when we don't go off the left edge of a block.
+	 * Set the root entry in the agf structure,
+	 * decreasing the level by 1.
 	 */
-	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
-		if (--cur->bc_ptrs[lev] > 0)
-			break;
-		/*
-		 * Read-ahead the left block, we're going to read it
-		 * in the next loop.
-		 */
-		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
-	}
+	bno = be32_to_cpu(agf->agf_roots[cur->bc_btnum]);
+	xfs_alloc_setroot(cur, newroot, -1);
 	/*
-	 * If we went off the root then we are seriously confused.
+	 * Put this buffer/block on the ag's freelist.
 	 */
-	ASSERT(lev < cur->bc_nlevels);
+	BUG_ON(bno == 0);
+	error = xfs_alloc_put_freelist(cur->bc_tp,
+			cur->bc_private.a.agbp, NULL, bno, 1);
+	if (error)
+		return error;
 	/*
-	 * Now walk back down the tree, fixing up the cursor's buffer
-	 * pointers and key numbers.
+	 * Since blocks move to the free list without the
+	 * coordination used in xfs_bmap_finish, we can't allow
+	 * block to be available for reallocation and
+	 * non-transaction writing (user data) until we know
+	 * that the transaction that moved it to the free list
+	 * is permanently on disk. We track the blocks by
+	 * declaring these blocks as "busy"; the busy list is
+	 * maintained on a per-ag basis and each transaction
+	 * records which entries should be removed when the
+	 * iclog commits to disk. If a busy block is
+	 * allocated, the iclog is pushed up to the LSN
+	 * that freed the block.
 	 */
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
-}
-
-/*
- * Delete the record pointed to by cur.
- * The cursor refers to the place where the record was (could be inserted)
- * when the operation returns.
- */
-int					/* error */
-xfs_alloc_delete(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		*stat)		/* success/failure */
-{
-	int		error;		/* error return value */
-	int		i;		/* result code */
-	int		level;		/* btree level */
+	xfs_alloc_mark_busy(cur->bc_tp,
+		be32_to_cpu(agf->agf_seqno), bno, 1);
 
+	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 	/*
-	 * Go up the tree, starting at leaf level.
-	 * If 2 is returned then a join was done; go to the next level.
-	 * Otherwise we are done.
+	 * Update the cursor so there's one fewer level.
 	 */
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
+	xfs_btree_setbuf(cur, level, NULL);
+	cur->bc_nlevels--;
 	return 0;
 }
 
 /*
- * Get the data from the pointed-to record.
+ * update the longest extent in the AGF
  */
-int					/* error */
-xfs_alloc_get_rec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agblock_t		*bno,	/* output: starting block of extent */
-	xfs_extlen_t		*len,	/* output: length of extent */
-	int			*stat)	/* output: success/failure */
+STATIC int
+xfs_alloc_update_lastrec(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block)
 {
-	xfs_alloc_block_t	*block;	/* btree block */
-#ifdef DEBUG
-	int			error;	/* error return value */
-#endif
-	int			ptr;	/* record number */
+	xfs_agf_t		*agf;	/* allocation group freelist header */
+	xfs_alloc_rec_t		*rrp;	/* right block record pointer */
+	int			numrecs;
 
-	ptr = cur->bc_ptrs[0];
-	block = XFS_BUF_TO_ALLOC_BLOCK(cur->bc_bufs[0]);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, 0, cur->bc_bufs[0])))
-		return error;
-#endif
+	if (cur->bc_btnum != XFS_BTNUM_CNT)
+		return 0;
+
+	agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
 	/*
-	 * Off the right end or left end, return failure.
+	 * There are still records in the block.  Grab the size
+	 * from the last one.
 	 */
-	if (ptr > be16_to_cpu(block->bb_numrecs) || ptr <= 0) {
-		*stat = 0;
-		return 0;
+	numrecs = xfs_btree_get_numrecs(cur, block);
+	if (numrecs) {
+		rrp = XFS_ALLOC_REC_ADDR(block, numrecs, cur);
+		ASSERT(be32_to_cpu(rrp->ar_blockcount) >=
+					be32_to_cpu(agf->agf_longest));
+		agf->agf_longest = rrp->ar_blockcount;
 	}
 	/*
-	 * Point to the record and extract its data.
+	 * No free extents left.
 	 */
-	{
-		xfs_alloc_rec_t		*rec;	/* record data */
+	else
+		agf->agf_longest = 0;
 
-		rec = XFS_ALLOC_REC_ADDR(block, ptr, cur);
-		*bno = be32_to_cpu(rec->ar_startblock);
-		*len = be32_to_cpu(rec->ar_blockcount);
-	}
-	*stat = 1;
+	cur->bc_mp->m_perag[be32_to_cpu(agf->agf_seqno)].pagf_longest =
+						be32_to_cpu(agf->agf_longest);
+	xfs_alloc_log_agf(cur->bc_tp, cur->bc_private.a.agbp, XFS_AGF_LONGEST);
 	return 0;
 }
 
+static const struct xfs_btree_cur_ops xfs_alloc_curops = {
+	.update_lastrec	= xfs_alloc_update_lastrec,
+	.set_root	= xfs_alloc_setroot,
+	.new_root	= xfs_btree_newroot,
+	.kill_root	= xfs_alloc_killroot,
+};
+
+#if defined(XFS_BTREE_TRACE)
+
 /*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
+ * Global alloc btree trace buffer
  */
-int					/* error */
-xfs_alloc_increment(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree, 0 is leaf */
-	int			*stat)	/* success/failure */
+ktrace_t        *xfs_allocbt_trace_buf;
+/*
+ * Add a trace buffer entry for the arguments given to the routine,
+ * generic form.
+ */
+STATIC void
+xfs_alloc_trace_enter(
+	const char	*func,
+	xfs_btree_cur_t	*cur,
+	char		*s,
+	int		type,
+	int		line,
+	__psunsigned_t	a0,
+	__psunsigned_t	a1,
+	__psunsigned_t	a2,
+	__psunsigned_t	a3,
+	__psunsigned_t	a4,
+	__psunsigned_t	a5,
+	__psunsigned_t	a6,
+	__psunsigned_t	a7,
+	__psunsigned_t	a8,
+	__psunsigned_t	a9,
+	__psunsigned_t	a10)
+{
+	ktrace_enter(xfs_allocbt_trace_buf,
+		(void *)(__psint_t)type,
+		(void *)func, (void *)s, (void *)ip, (void *)cur,
+		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
+		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
+		(void *)a8, (void *)a9, (void *)a10);
+}
+
+STATIC void
+xfs_alloc_trace_cursor(
+	xfs_btree_cur_t	*cur,
+	__uint32_t	*s0,
+	__uint64_t	*l0,
+	__uint64_t	*l1)
+{
+	*s0 = cur->bc_private.a.agno;
+	*l0 = cur->bc_rec.a.ar_startblock;
+	*l1 = cur->bc_rec.a.ar_blockcount;
+}
+
+STATIC void
+xfs_alloc_trace_record(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_rec_t	*rec,
+	__uint64_t	*l0,
+	__uint64_t	*l1,
+	__uint64_t	*l2)
 {
-	xfs_alloc_block_t	*block;	/* btree block */
-	xfs_buf_t		*bp;	/* tree block buffer */
-	int			error;	/* error return value */
-	int			lev;	/* btree level */
+	*l0 = be32_to_cpu(&rec->u.alloc.ar_startblock);
+	*l1 = be32_to_cpu(&rec->u.alloc.ar_blockcount);
+	*l2 = 0;
+}
 
-	ASSERT(level < cur->bc_nlevels);
-	/*
-	 * Read-ahead to the right at this level.
-	 */
-	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
-	/*
-	 * Get a pointer to the btree block.
-	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-		return error;
+static const struct xfs_btree_trc_ops xfs_alloc_trcops = {
+	.enter		= xfs_alloc_trace_enter,
+	.cursor		= xfs_alloc_trace_cursor,
+	.record		= xfs_alloc_trace_record,
+};
 #endif
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
+
+void
+xfs_alloc_init_cursor(
+	xfs_btree_cur_t	*cur)
+{
+	cur->bc_flags = 0;
+	if (cur->bc_btnum == XFS_BTNUM_CNT)
+		cur->bc_flags |= XFS_BTREE_LASTREC_UPDATE;
+	cur->bc_curops = &xfs_alloc_curops;
+	cur->bc_blkops = &xfs_alloc_blkops;
+	cur->bc_recops = &xfs_alloc_recops;
+#if defined(XFS_BTREE_TRACE)
+	cur->bc_trcops = &xfs_alloc_trcops;
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
-	}
-	*stat = 1;
-	return 0;
 }
 
 /*
- * Insert the current record at the point referenced by cur.
- * The cursor may be inconsistent on return if splits have been done.
+ * ALLOC functions that are not covered by core btree code.
+ * Externally visible routines.
+ */
+
+/*
+ * Update the record referred to by cur, to the value given by [bno, len].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
  */
 int					/* error */
-xfs_alloc_insert(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		*stat)		/* success/failure */
+xfs_alloc_update(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len)	/* length of extent */
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
+	xfs_btree_rec_t	rec;
+
+	rec.u.alloc.ar_startblock = cpu_to_be32(bno);
+	rec.u.alloc.ar_blockcount = cpu_to_be32(len);
+	return xfs_btree_update(cur, &rec);
 }
 
 /*
@@ -2105,7 +828,7 @@ xfs_alloc_lookup_eq(
 {
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
-	return xfs_alloc_lookup(cur, XFS_LOOKUP_EQ, stat);
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
 }
 
 /*
@@ -2121,7 +844,7 @@ xfs_alloc_lookup_ge(
 {
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
-	return xfs_alloc_lookup(cur, XFS_LOOKUP_GE, stat);
+	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
 }
 
 /*
@@ -2137,75 +860,53 @@ xfs_alloc_lookup_le(
 {
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
-	return xfs_alloc_lookup(cur, XFS_LOOKUP_LE, stat);
+	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
 }
 
 /*
- * Update the record referred to by cur, to the value given by [bno, len].
- * This either works (return 0) or gets an EFSCORRUPTED error.
+ * Get the data from the pointed-to record.
  */
 int					/* error */
-xfs_alloc_update(
+xfs_alloc_get_rec(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agblock_t		bno,	/* starting block of extent */
-	xfs_extlen_t		len)	/* length of extent */
+	xfs_agblock_t		*bno,	/* output: starting block of extent */
+	xfs_extlen_t		*len,	/* output: length of extent */
+	int			*stat)	/* output: success/failure */
 {
-	xfs_alloc_block_t	*block;	/* btree block to update */
+	xfs_btree_block_t	*block;	/* btree block */
+	xfs_btree_rec_t		*rec;	/* record data */
+	xfs_buf_t		*bp;	/* buffer containing btree block */
+#ifdef DEBUG
 	int			error;	/* error return value */
-	int			ptr;	/* current record number (updating) */
+#endif
+	int			ptr;	/* record number */
 
-	ASSERT(len > 0);
-	/*
-	 * Pick up the a.g. freelist struct and the current block.
-	 */
-	block = XFS_BUF_TO_ALLOC_BLOCK(cur->bc_bufs[0]);
+	XFS_BTREE_TRACE_CURSOR(cur, ENTRY);
+	XFS_BTREE_TRACE_ARGFFF(cur, *ino, *fcnt, *free);
+
+	ptr = cur->bc_ptrs[0];
+	block = xfs_alloc_get_block(cur, 0, &bp);
 #ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, 0, cur->bc_bufs[0])))
+	error = xfs_btree_check_sblock(cur, block, 0, bp);
+	if (error)
 		return error;
 #endif
 	/*
-	 * Get the address of the rec to be updated.
-	 */
-	ptr = cur->bc_ptrs[0];
-	{
-		xfs_alloc_rec_t		*rp;	/* pointer to updated record */
-
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
+	 * Off the right end or left end, return failure.
 	 */
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
+	if (ptr > be16_to_cpu(block->bb_h.bb_numrecs) || ptr <= 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, EXIT);
+		*stat = 0;
+		return 0;
 	}
 	/*
-	 * Updating first record in leaf. Pass new key value up to our parent.
+	 * Point to the record and extract its data.
 	 */
-	if (ptr == 1) {
-		xfs_alloc_key_t	key;	/* key containing [bno, len] */
-
-		key.ar_startblock = cpu_to_be32(bno);
-		key.ar_blockcount = cpu_to_be32(len);
-		if ((error = xfs_alloc_updkey(cur, &key, 1)))
-			return error;
-	}
+	rec = xfs_alloc_rec_addr(cur, ptr, block);
+	*bno = be32_to_cpu(rec->u.alloc.ar_startblock);
+	*len = be32_to_cpu(rec->u.alloc.ar_blockcount);
+	XFS_BTREE_TRACE_CURSOR(cur, EXIT);
+	*stat = 1;
 	return 0;
 }
+
Index: 2.6.x-xfs-new/fs/xfs/xfs_alloc_btree.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_alloc_btree.h	2007-02-07 13:24:32.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_alloc_btree.h	2007-11-06 19:40:29.702675076 +1100
@@ -94,6 +94,8 @@ typedef	struct xfs_btree_sblock xfs_allo
 #define	XFS_ALLOC_PTR_ADDR(bb,i,cur)	\
 	XFS_BTREE_PTR_ADDR(xfs_alloc, bb, i, XFS_ALLOC_BLOCK_MAXRECS(1, cur))
 
+extern void xfs_alloc_init_cursor(struct xfs_btree_cur *cur);
+
 /*
  * Decrement cursor by one record at the level.
  * For nonzero levels the leaf-ward information is untouched.
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap.c	2007-11-05 10:08:51.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap.c	2007-11-06 19:40:29.710674046 +1100
@@ -817,10 +817,10 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_blockcount, &i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			ASSERT(i == 1);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
@@ -930,7 +930,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			ASSERT(i == 0);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
 		}
@@ -1006,7 +1006,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			ASSERT(i == 0);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
 		}
@@ -1096,7 +1096,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			ASSERT(i == 0);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
 		}
@@ -1151,7 +1151,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			ASSERT(i == 0);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
 		}
@@ -1378,16 +1378,16 @@ xfs_bmap_add_extent_unwritten_real(
 					RIGHT.br_blockcount, &i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			ASSERT(i == 1);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
@@ -1427,10 +1427,10 @@ xfs_bmap_add_extent_unwritten_real(
 					&i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			ASSERT(i == 1);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
@@ -1470,10 +1470,10 @@ xfs_bmap_add_extent_unwritten_real(
 					RIGHT.br_blockcount, &i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			ASSERT(i == 1);
 			if ((error = xfs_bmbt_update(cur, new->br_startoff,
@@ -1556,7 +1556,7 @@ xfs_bmap_add_extent_unwritten_real(
 				PREV.br_blockcount - new->br_blockcount,
 				oldext)))
 				goto done;
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			if (xfs_bmbt_update(cur, LEFT.br_startoff,
 				LEFT.br_startblock,
@@ -1604,7 +1604,7 @@ xfs_bmap_add_extent_unwritten_real(
 				oldext)))
 				goto done;
 			cur->bc_rec.b = *new;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
 		}
@@ -1646,7 +1646,7 @@ xfs_bmap_add_extent_unwritten_real(
 				PREV.br_blockcount - new->br_blockcount,
 				oldext)))
 				goto done;
-			if ((error = xfs_bmbt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto done;
 			if ((error = xfs_bmbt_update(cur, new->br_startoff,
 				new->br_startblock,
@@ -1694,7 +1694,7 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			ASSERT(i == 0);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
 		}
@@ -1742,15 +1742,15 @@ xfs_bmap_add_extent_unwritten_real(
 			PREV.br_blockcount =
 				new->br_startoff - PREV.br_startoff;
 			cur->bc_rec.b = PREV;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto done;
 			ASSERT(i == 1);
 			/* new middle extent - newext */
 			cur->bc_rec.b = *new;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
 		}
@@ -2098,10 +2098,10 @@ xfs_bmap_add_extent_hole_real(
 					right.br_blockcount, &i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_delete(cur, &i)))
+			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
-			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
+			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			ASSERT(i == 1);
 			if ((error = xfs_bmbt_update(cur, left.br_startoff,
@@ -2210,7 +2210,7 @@ xfs_bmap_add_extent_hole_real(
 				goto done;
 			ASSERT(i == 0);
 			cur->bc_rec.b.br_state = new->br_state;
-			if ((error = xfs_bmbt_insert(cur, &i)))
+			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			ASSERT(i == 1);
 		}
@@ -2989,7 +2989,7 @@ xfs_bmap_btree_to_extents(
 	int			whichfork)  /* data or attr fork */
 {
 	/* REFERENCED */
-	xfs_bmbt_block_t	*cblock;/* child btree block */
+	xfs_btree_block_t	*cblock;/* child btree block */
 	xfs_fsblock_t		cbno;	/* child block number */
 	xfs_buf_t		*cbp;	/* child block's buffer */
 	int			error;	/* error return value */
@@ -3016,7 +3016,7 @@ xfs_bmap_btree_to_extents(
 	if ((error = xfs_btree_read_bufl(mp, tp, cbno, 0, &cbp,
 			XFS_BMAP_BTREE_REF)))
 		return error;
-	cblock = XFS_BUF_TO_BMBT_BLOCK(cbp);
+	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_lblock(cur, cblock, 0, cbp)))
 		return error;
 	xfs_bmap_add_free(cbno, 1, cur->bc_private.b.flist, mp);
@@ -3163,7 +3163,7 @@ xfs_bmap_del_extent(
 			flags |= XFS_ILOG_FEXT(whichfork);
 			break;
 		}
-		if ((error = xfs_bmbt_delete(cur, &i)))
+		if ((error = xfs_btree_delete(cur, &i)))
 			goto done;
 		ASSERT(i == 1);
 		break;
@@ -3247,10 +3247,10 @@ xfs_bmap_del_extent(
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
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap_btree.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap_btree.c	2007-11-05 10:09:31.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap_btree.c	2007-11-06 19:41:45.344933663 +1100
@@ -35,1466 +35,544 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
-#include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_ialloc.h"
+#include "xfs_alloc.h"
 #include "xfs_itable.h"
 #include "xfs_bmap.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
 
-#if defined(XFS_BMBT_TRACE)
-ktrace_t	*xfs_bmbt_trace_buf;
-#endif
-
 /*
- * Prototypes for internal btree functions.
+ * Determine the extent state.
  */
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
-
-#if defined(XFS_BMBT_TRACE)
-
-static char	ARGS[] = "args";
-static char	ENTRY[] = "entry";
-static char	ERROR[] = "error";
-#undef EXIT
-static char	EXIT[] = "exit";
+/* ARGSUSED */
+STATIC xfs_exntst_t
+xfs_extent_state(
+	xfs_filblks_t		blks,
+	int			extent_flag)
+{
+	if (extent_flag) {
+		ASSERT(blks != 0);	/* saved for DMIG */
+		return XFS_EXT_UNWRITTEN;
+	}
+	return XFS_EXT_NORM;
+}
 
 /*
- * Add a trace buffer entry for the arguments given to the routine,
- * generic form.
+ * Convert on-disk form of btree root to in-memory form.
  */
-STATIC void
-xfs_bmbt_trace_enter(
-	const char	*func,
-	xfs_btree_cur_t	*cur,
-	char		*s,
-	int		type,
-	int		line,
-	__psunsigned_t	a0,
-	__psunsigned_t	a1,
-	__psunsigned_t	a2,
-	__psunsigned_t	a3,
-	__psunsigned_t	a4,
-	__psunsigned_t	a5,
-	__psunsigned_t	a6,
-	__psunsigned_t	a7,
-	__psunsigned_t	a8,
-	__psunsigned_t	a9,
-	__psunsigned_t	a10)
+void
+xfs_bmdr_to_bmbt(
+	xfs_bmdr_block_t	*dblock,
+	int			dblocklen,
+	xfs_bmbt_block_t	*rblock,
+	int			rblocklen)
 {
-	xfs_inode_t	*ip;
-	int		whichfork;
+	int			dmxr;
+	xfs_bmbt_key_t		*fkp;
+	__be64			*fpp;
+	xfs_bmbt_key_t		*tkp;
+	__be64			*tpp;
 
-	ip = cur->bc_private.b.ip;
-	whichfork = cur->bc_private.b.whichfork;
-	ktrace_enter(xfs_bmbt_trace_buf,
-		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
-		(void *)func, (void *)s, (void *)ip, (void *)cur,
-		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
-		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
-		(void *)a8, (void *)a9, (void *)a10);
-	ASSERT(ip->i_btrace);
-	ktrace_enter(ip->i_btrace,
-		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
-		(void *)func, (void *)s, (void *)ip, (void *)cur,
-		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
-		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
-		(void *)a8, (void *)a9, (void *)a10);
+	rblock->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
+	rblock->bb_level = dblock->bb_level;
+	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
+	rblock->bb_numrecs = dblock->bb_numrecs;
+	rblock->bb_leftsib = cpu_to_be64(NULLDFSBNO);
+	rblock->bb_rightsib = cpu_to_be64(NULLDFSBNO);
+	dmxr = (int)XFS_BTREE_BLOCK_MAXRECS(dblocklen, xfs_bmdr, 0);
+	fkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
+	tkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
+	fpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
+	tpp = XFS_BMAP_BROOT_PTR_ADDR(rblock, 1, rblocklen);
+	dmxr = be16_to_cpu(dblock->bb_numrecs);
+	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
+	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
 }
+
 /*
- * Add a trace buffer entry for arguments, for a buffer & 1 integer arg.
+ * Convert a compressed bmap extent record to an uncompressed form.
+ * This code must be in sync with the routines xfs_bmbt_get_startoff,
+ * xfs_bmbt_get_startblock, xfs_bmbt_get_blockcount and xfs_bmbt_get_state.
  */
-STATIC void
-xfs_bmbt_trace_argbi(
-	const char	*func,
-	xfs_btree_cur_t	*cur,
-	xfs_buf_t	*b,
-	int		i,
-	int		line)
+STATIC_INLINE void
+__xfs_bmbt_get_all(
+		__uint64_t l0,
+		__uint64_t l1,
+		xfs_bmbt_irec_t *s)
 {
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGBI, line,
-		(__psunsigned_t)b, i, 0, 0,
-		0, 0, 0, 0,
-		0, 0, 0);
+	int	ext_flag;
+	xfs_exntst_t st;
+
+	ext_flag = (int)(l0 >> (64 - BMBT_EXNTFLAG_BITLEN));
+	s->br_startoff = ((xfs_fileoff_t)l0 &
+			   XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+#if XFS_BIG_BLKNOS
+	s->br_startblock = (((xfs_fsblock_t)l0 & XFS_MASK64LO(9)) << 43) |
+			   (((xfs_fsblock_t)l1) >> 21);
+#else
+#ifdef DEBUG
+	{
+		xfs_dfsbno_t	b;
+
+		b = (((xfs_dfsbno_t)l0 & XFS_MASK64LO(9)) << 43) |
+		    (((xfs_dfsbno_t)l1) >> 21);
+		ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
+		s->br_startblock = (xfs_fsblock_t)b;
+	}
+#else	/* !DEBUG */
+	s->br_startblock = (xfs_fsblock_t)(((xfs_dfsbno_t)l1) >> 21);
+#endif	/* DEBUG */
+#endif	/* XFS_BIG_BLKNOS */
+	s->br_blockcount = (xfs_filblks_t)(l1 & XFS_MASK64LO(21));
+	/* This is xfs_extent_state() in-line */
+	if (ext_flag) {
+		ASSERT(s->br_blockcount != 0);	/* saved for DMIG */
+		st = XFS_EXT_UNWRITTEN;
+	} else
+		st = XFS_EXT_NORM;
+	s->br_state = st;
 }
 
-/*
- * Add a trace buffer entry for arguments, for a buffer & 2 integer args.
- */
-STATIC void
-xfs_bmbt_trace_argbii(
-	const char	*func,
-	xfs_btree_cur_t	*cur,
-	xfs_buf_t	*b,
-	int		i0,
-	int		i1,
-	int		line)
+void
+xfs_bmbt_get_all(
+	xfs_bmbt_rec_host_t *r,
+	xfs_bmbt_irec_t *s)
 {
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGBII, line,
-		(__psunsigned_t)b, i0, i1, 0,
-		0, 0, 0, 0,
-		0, 0, 0);
+	__xfs_bmbt_get_all(r->l0, r->l1, s);
 }
 
 /*
- * Add a trace buffer entry for arguments, for 3 block-length args
- * and an integer arg.
+ * Extract the blockcount field from an in memory bmap extent record.
  */
-STATIC void
-xfs_bmbt_trace_argfffi(
-	const char		*func,
-	xfs_btree_cur_t		*cur,
-	xfs_dfiloff_t		o,
-	xfs_dfsbno_t		b,
-	xfs_dfilblks_t		i,
-	int			j,
-	int			line)
+xfs_filblks_t
+xfs_bmbt_get_blockcount(
+	xfs_bmbt_rec_host_t	*r)
 {
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGFFFI, line,
-		o >> 32, (int)o, b >> 32, (int)b,
-		i >> 32, (int)i, (int)j, 0,
-		0, 0, 0);
+	return (xfs_filblks_t)(r->l1 & XFS_MASK64LO(21));
 }
 
 /*
- * Add a trace buffer entry for arguments, for one integer arg.
+ * Extract the startblock field from an in memory bmap extent record.
  */
-STATIC void
-xfs_bmbt_trace_argi(
-	const char	*func,
-	xfs_btree_cur_t	*cur,
-	int		i,
-	int		line)
+xfs_fsblock_t
+xfs_bmbt_get_startblock(
+	xfs_bmbt_rec_host_t	*r)
 {
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGI, line,
-		i, 0, 0, 0,
-		0, 0, 0, 0,
-		0, 0, 0);
+#if XFS_BIG_BLKNOS
+	return (((xfs_fsblock_t)r->l0 & XFS_MASK64LO(9)) << 43) |
+	       (((xfs_fsblock_t)r->l1) >> 21);
+#else
+#ifdef DEBUG
+	xfs_dfsbno_t	b;
+
+	b = (((xfs_dfsbno_t)r->l0 & XFS_MASK64LO(9)) << 43) |
+	    (((xfs_dfsbno_t)r->l1) >> 21);
+	ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
+	return (xfs_fsblock_t)b;
+#else	/* !DEBUG */
+	return (xfs_fsblock_t)(((xfs_dfsbno_t)r->l1) >> 21);
+#endif	/* DEBUG */
+#endif	/* XFS_BIG_BLKNOS */
 }
 
 /*
- * Add a trace buffer entry for arguments, for int, fsblock, key.
+ * Extract the startoff field from an in memory bmap extent record.
  */
-STATIC void
-xfs_bmbt_trace_argifk(
-	const char		*func,
-	xfs_btree_cur_t		*cur,
-	int			i,
-	xfs_fsblock_t		f,
-	xfs_dfiloff_t		o,
-	int			line)
+xfs_fileoff_t
+xfs_bmbt_get_startoff(
+	xfs_bmbt_rec_host_t	*r)
 {
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGIFK, line,
-		i, (xfs_dfsbno_t)f >> 32, (int)f, o >> 32,
-		(int)o, 0, 0, 0,
-		0, 0, 0);
+	return ((xfs_fileoff_t)r->l0 &
+		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 }
 
-/*
- * Add a trace buffer entry for arguments, for int, fsblock, rec.
- */
-STATIC void
-xfs_bmbt_trace_argifr(
-	const char		*func,
-	xfs_btree_cur_t		*cur,
-	int			i,
-	xfs_fsblock_t		f,
-	xfs_bmbt_rec_t		*r,
-	int			line)
+xfs_exntst_t
+xfs_bmbt_get_state(
+	xfs_bmbt_rec_host_t	*r)
 {
-	xfs_dfsbno_t		b;
-	xfs_dfilblks_t		c;
-	xfs_dfsbno_t		d;
-	xfs_dfiloff_t		o;
-	xfs_bmbt_irec_t		s;
-
-	d = (xfs_dfsbno_t)f;
-	xfs_bmbt_disk_get_all(r, &s);
-	o = (xfs_dfiloff_t)s.br_startoff;
-	b = (xfs_dfsbno_t)s.br_startblock;
-	c = s.br_blockcount;
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGIFR, line,
-		i, d >> 32, (int)d, o >> 32,
-		(int)o, b >> 32, (int)b, c >> 32,
-		(int)c, 0, 0);
+	int	ext_flag;
+
+	ext_flag = (int)((r->l0) >> (64 - BMBT_EXNTFLAG_BITLEN));
+	return xfs_extent_state(xfs_bmbt_get_blockcount(r),
+				ext_flag);
 }
 
-/*
- * Add a trace buffer entry for arguments, for int, key.
- */
-STATIC void
-xfs_bmbt_trace_argik(
-	const char		*func,
-	xfs_btree_cur_t		*cur,
-	int			i,
-	xfs_bmbt_key_t		*k,
-	int			line)
+/* Endian flipping versions of the bmbt extraction functions */
+void
+xfs_bmbt_disk_get_all(
+	xfs_bmbt_rec_t	*r,
+	xfs_bmbt_irec_t *s)
 {
-	xfs_dfiloff_t		o;
-
-	o = be64_to_cpu(k->br_startoff);
-	xfs_bmbt_trace_enter(func, cur, ARGS, XFS_BMBT_KTRACE_ARGIFK, line,
-		i, o >> 32, (int)o, 0,
-		0, 0, 0, 0,
-		0, 0, 0);
+	__xfs_bmbt_get_all(be64_to_cpu(r->l0), be64_to_cpu(r->l1), s);
 }
 
 /*
- * Add a trace buffer entry for the cursor/operation.
+ * Extract the blockcount field from an on disk bmap extent record.
  */
-STATIC void
-xfs_bmbt_trace_cursor(
-	const char	*func,
-	xfs_btree_cur_t	*cur,
-	char		*s,
-	int		line)
+xfs_filblks_t
+xfs_bmbt_disk_get_blockcount(
+	xfs_bmbt_rec_t	*r)
 {
-	xfs_bmbt_rec_host_t	r;
-
-	xfs_bmbt_set_all(&r, &cur->bc_rec.b);
-	xfs_bmbt_trace_enter(func, cur, s, XFS_BMBT_KTRACE_CUR, line,
-		(cur->bc_nlevels << 24) | (cur->bc_private.b.flags << 16) |
-		cur->bc_private.b.allocated,
-		r.l0 >> 32, (int)r.l0,
-		r.l1 >> 32, (int)r.l1,
-		(unsigned long)cur->bc_bufs[0], (unsigned long)cur->bc_bufs[1],
-		(unsigned long)cur->bc_bufs[2], (unsigned long)cur->bc_bufs[3],
-		(cur->bc_ptrs[0] << 16) | cur->bc_ptrs[1],
-		(cur->bc_ptrs[2] << 16) | cur->bc_ptrs[3]);
-}
-
-#define	XFS_BMBT_TRACE_ARGBI(c,b,i)	\
-	xfs_bmbt_trace_argbi(__FUNCTION__, c, b, i, __LINE__)
-#define	XFS_BMBT_TRACE_ARGBII(c,b,i,j)	\
-	xfs_bmbt_trace_argbii(__FUNCTION__, c, b, i, j, __LINE__)
-#define	XFS_BMBT_TRACE_ARGFFFI(c,o,b,i,j)	\
-	xfs_bmbt_trace_argfffi(__FUNCTION__, c, o, b, i, j, __LINE__)
-#define	XFS_BMBT_TRACE_ARGI(c,i)	\
-	xfs_bmbt_trace_argi(__FUNCTION__, c, i, __LINE__)
-#define	XFS_BMBT_TRACE_ARGIFK(c,i,f,s)	\
-	xfs_bmbt_trace_argifk(__FUNCTION__, c, i, f, s, __LINE__)
-#define	XFS_BMBT_TRACE_ARGIFR(c,i,f,r)	\
-	xfs_bmbt_trace_argifr(__FUNCTION__, c, i, f, r, __LINE__)
-#define	XFS_BMBT_TRACE_ARGIK(c,i,k)	\
-	xfs_bmbt_trace_argik(__FUNCTION__, c, i, k, __LINE__)
-#define	XFS_BMBT_TRACE_CURSOR(c,s)	\
-	xfs_bmbt_trace_cursor(__FUNCTION__, c, s, __LINE__)
-#else
-#define	XFS_BMBT_TRACE_ARGBI(c,b,i)
-#define	XFS_BMBT_TRACE_ARGBII(c,b,i,j)
-#define	XFS_BMBT_TRACE_ARGFFFI(c,o,b,i,j)
-#define	XFS_BMBT_TRACE_ARGI(c,i)
-#define	XFS_BMBT_TRACE_ARGIFK(c,i,f,s)
-#define	XFS_BMBT_TRACE_ARGIFR(c,i,f,r)
-#define	XFS_BMBT_TRACE_ARGIK(c,i,k)
-#define	XFS_BMBT_TRACE_CURSOR(c,s)
-#endif	/* XFS_BMBT_TRACE */
-
+	return (xfs_filblks_t)(be64_to_cpu(r->l1) & XFS_MASK64LO(21));
+}
 
 /*
- * Internal functions.
+ * Extract the startoff field from a disk format bmap extent record.
  */
+xfs_fileoff_t
+xfs_bmbt_disk_get_startoff(
+	xfs_bmbt_rec_t	*r)
+{
+	return ((xfs_fileoff_t)be64_to_cpu(r->l0) &
+		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+}
 
 /*
- * Delete record pointed to by cur/level.
+ * Set all the fields in a bmap extent record from the arguments.
  */
-STATIC int					/* error */
-xfs_bmbt_delrec(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	int			*stat)		/* success/failure */
+void
+xfs_bmbt_set_allf(
+	xfs_bmbt_rec_host_t	*r,
+	xfs_fileoff_t		startoff,
+	xfs_fsblock_t		startblock,
+	xfs_filblks_t		blockcount,
+	xfs_exntst_t		state)
 {
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
+	int		extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
+
+	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
+	ASSERT((startoff & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
+	ASSERT((blockcount & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
+
+#if XFS_BIG_BLKNOS
+	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+
+	r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
+		((xfs_bmbt_rec_base_t)startoff << 9) |
+		((xfs_bmbt_rec_base_t)startblock >> 43);
+	r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
+		((xfs_bmbt_rec_base_t)blockcount &
+		(xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+#else	/* !XFS_BIG_BLKNOS */
+	if (ISNULLSTARTBLOCK(startblock)) {
+		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
+			((xfs_bmbt_rec_base_t)startoff << 9) |
+			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
+		r->l1 = XFS_MASK64HI(11) |
+			  ((xfs_bmbt_rec_base_t)startblock << 21) |
+			  ((xfs_bmbt_rec_base_t)blockcount &
+			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
 	} else {
-		lrp = XFS_BMAP_REC_IADDR(left, numlrecs + 1, cur);
-		rrp = XFS_BMAP_REC_IADDR(right, 1, cur);
-		memcpy(lrp, rrp, numrrecs * sizeof(*lrp));
-		xfs_bmbt_log_recs(cur, lbp, numlrecs + 1, numlrecs + numrrecs);
-	}
-	be16_add(&left->bb_numrecs, numrrecs);
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
+		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
+			((xfs_bmbt_rec_base_t)startoff << 9);
+		r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
+			 ((xfs_bmbt_rec_base_t)blockcount &
+			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
 	}
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
+#endif	/* XFS_BIG_BLKNOS */
 }
 
 /*
- * Insert one record/level.  Return information to the caller
- * allowing the next level up to proceed if necessary.
+ * Set all the fields in a bmap extent record from the uncompressed form.
  */
-STATIC int					/* error */
-xfs_bmbt_insrec(
-	xfs_btree_cur_t		*cur,
-	int			level,
-	xfs_fsblock_t		*bnop,
-	xfs_bmbt_rec_t		*recp,
-	xfs_btree_cur_t		**curp,
-	int			*stat)		/* no-go/done/continue */
+void
+xfs_bmbt_set_all(
+	xfs_bmbt_rec_host_t *r,
+	xfs_bmbt_irec_t	*s)
 {
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
+	xfs_bmbt_set_allf(r, s->br_startoff, s->br_startblock,
+			     s->br_blockcount, s->br_state);
 }
 
-STATIC int
-xfs_bmbt_killroot(
-	xfs_btree_cur_t		*cur)
+
+/*
+ * Set all the fields in a disk format bmap extent record from the arguments.
+ */
+void
+xfs_bmbt_disk_set_allf(
+	xfs_bmbt_rec_t		*r,
+	xfs_fileoff_t		startoff,
+	xfs_fsblock_t		startblock,
+	xfs_filblks_t		blockcount,
+	xfs_exntst_t		state)
 {
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
+	int			extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
 
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
-	be16_add(&block->bb_numrecs, i);
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
+	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
+	ASSERT((startoff & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
+	ASSERT((blockcount & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
+
+#if XFS_BIG_BLKNOS
+	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+
+	r->l0 = cpu_to_be64(
+		((xfs_bmbt_rec_base_t)extent_flag << 63) |
+		 ((xfs_bmbt_rec_base_t)startoff << 9) |
+		 ((xfs_bmbt_rec_base_t)startblock >> 43));
+	r->l1 = cpu_to_be64(
+		((xfs_bmbt_rec_base_t)startblock << 21) |
+		 ((xfs_bmbt_rec_base_t)blockcount &
+		  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+#else	/* !XFS_BIG_BLKNOS */
+	if (ISNULLSTARTBLOCK(startblock)) {
+		r->l0 = cpu_to_be64(
+			((xfs_bmbt_rec_base_t)extent_flag << 63) |
+			 ((xfs_bmbt_rec_base_t)startoff << 9) |
+			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
+		r->l1 = cpu_to_be64(XFS_MASK64HI(11) |
+			  ((xfs_bmbt_rec_base_t)startblock << 21) |
+			  ((xfs_bmbt_rec_base_t)blockcount &
+			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+	} else {
+		r->l0 = cpu_to_be64(
+			((xfs_bmbt_rec_base_t)extent_flag << 63) |
+			 ((xfs_bmbt_rec_base_t)startoff << 9));
+		r->l1 = cpu_to_be64(
+			((xfs_bmbt_rec_base_t)startblock << 21) |
+			 ((xfs_bmbt_rec_base_t)blockcount &
+			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
 	}
-#endif
-	memcpy(pp, cpp, be16_to_cpu(block->bb_numrecs) * sizeof(*pp));
-	xfs_bmap_add_free(XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(cbp)), 1,
-			cur->bc_private.b.flist, cur->bc_mp);
-	ip->i_d.di_nblocks--;
-	XFS_TRANS_MOD_DQUOT_BYINO(cur->bc_mp, cur->bc_tp, ip,
-			XFS_TRANS_DQ_BCOUNT, -1L);
-	xfs_trans_binval(cur->bc_tp, cbp);
-	cur->bc_bufs[level - 1] = NULL;
-	be16_add(&block->bb_level, -1);
-	xfs_trans_log_inode(cur->bc_tp, ip,
-		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	cur->bc_nlevels--;
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	return 0;
+#endif	/* XFS_BIG_BLKNOS */
 }
 
 /*
- * Log key values from the btree block.
+ * Set all the fields in a bmap extent record from the uncompressed form.
  */
-STATIC void
-xfs_bmbt_log_keys(
-	xfs_btree_cur_t	*cur,
-	xfs_buf_t	*bp,
-	int		kfirst,
-	int		klast)
+void
+xfs_bmbt_disk_set_all(
+	xfs_bmbt_rec_t	*r,
+	xfs_bmbt_irec_t *s)
 {
-	xfs_trans_t	*tp;
+	xfs_bmbt_disk_set_allf(r, s->br_startoff, s->br_startblock,
+				  s->br_blockcount, s->br_state);
+}
 
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBII(cur, bp, kfirst, klast);
-	tp = cur->bc_tp;
-	if (bp) {
-		xfs_bmbt_block_t	*block;
-		int			first;
-		xfs_bmbt_key_t		*kp;
-		int			last;
+/*
+ * Set the blockcount field in a bmap extent record.
+ */
+void
+xfs_bmbt_set_blockcount(
+	xfs_bmbt_rec_host_t *r,
+	xfs_filblks_t	v)
+{
+	ASSERT((v & XFS_MASK64HI(43)) == 0);
+	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64HI(43)) |
+		  (xfs_bmbt_rec_base_t)(v & XFS_MASK64LO(21));
+}
 
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
-		kp = XFS_BMAP_KEY_DADDR(block, 1, cur);
-		first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
-		last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
-		xfs_trans_log_buf(tp, bp, first, last);
+/*
+ * Set the startblock field in a bmap extent record.
+ */
+void
+xfs_bmbt_set_startblock(
+	xfs_bmbt_rec_host_t *r,
+	xfs_fsblock_t	v)
+{
+#if XFS_BIG_BLKNOS
+	ASSERT((v & XFS_MASK64HI(12)) == 0);
+	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t)XFS_MASK64HI(55)) |
+		  (xfs_bmbt_rec_base_t)(v >> 43);
+	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)) |
+		  (xfs_bmbt_rec_base_t)(v << 21);
+#else	/* !XFS_BIG_BLKNOS */
+	if (ISNULLSTARTBLOCK(v)) {
+		r->l0 |= (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
+		r->l1 = (xfs_bmbt_rec_base_t)XFS_MASK64HI(11) |
+			  ((xfs_bmbt_rec_base_t)v << 21) |
+			  (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
 	} else {
-		xfs_inode_t		 *ip;
-
-		ip = cur->bc_private.b.ip;
-		xfs_trans_log_inode(tp, ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+		r->l0 &= ~(xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
+		r->l1 = ((xfs_bmbt_rec_base_t)v << 21) |
+			  (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
 	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
+#endif	/* XFS_BIG_BLKNOS */
 }
 
 /*
- * Log pointer values from the btree block.
+ * Set the startoff field in a bmap extent record.
  */
-STATIC void
-xfs_bmbt_log_ptrs(
-	xfs_btree_cur_t	*cur,
-	xfs_buf_t	*bp,
-	int		pfirst,
-	int		plast)
+void
+xfs_bmbt_set_startoff(
+	xfs_bmbt_rec_host_t *r,
+	xfs_fileoff_t	v)
 {
-	xfs_trans_t	*tp;
+	ASSERT((v & XFS_MASK64HI(9)) == 0);
+	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t) XFS_MASK64HI(1)) |
+		((xfs_bmbt_rec_base_t)v << 9) |
+		  (r->l0 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
+}
 
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBII(cur, bp, pfirst, plast);
-	tp = cur->bc_tp;
-	if (bp) {
-		xfs_bmbt_block_t	*block;
-		int			first;
-		int			last;
-		xfs_bmbt_ptr_t		*pp;
+/*
+ * Set the extent state field in a bmap extent record.
+ */
+void
+xfs_bmbt_set_state(
+	xfs_bmbt_rec_host_t *r,
+	xfs_exntst_t	v)
+{
+	ASSERT(v == XFS_EXT_NORM || v == XFS_EXT_UNWRITTEN);
+	if (v == XFS_EXT_NORM)
+		r->l0 &= XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN);
+	else
+		r->l0 |= XFS_MASK64HI(BMBT_EXNTFLAG_BITLEN);
+}
 
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
-		pp = XFS_BMAP_PTR_DADDR(block, 1, cur);
-		first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
-		last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
-		xfs_trans_log_buf(tp, bp, first, last);
-	} else {
-		xfs_inode_t		*ip;
+/*
+ * Convert in-memory form of btree root to on-disk form.
+ */
+void
+xfs_bmbt_to_bmdr(
+	xfs_bmbt_block_t	*rblock,
+	int			rblocklen,
+	xfs_bmdr_block_t	*dblock,
+	int			dblocklen)
+{
+	int			dmxr;
+	xfs_bmbt_key_t		*fkp;
+	__be64			*fpp;
+	xfs_bmbt_key_t		*tkp;
+	__be64			*tpp;
 
-		ip = cur->bc_private.b.ip;
-		xfs_trans_log_inode(tp, ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
+	ASSERT(be32_to_cpu(rblock->bb_magic) == XFS_BMAP_MAGIC);
+	ASSERT(be64_to_cpu(rblock->bb_leftsib) == NULLDFSBNO);
+	ASSERT(be64_to_cpu(rblock->bb_rightsib) == NULLDFSBNO);
+	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
+	dblock->bb_level = rblock->bb_level;
+	dblock->bb_numrecs = rblock->bb_numrecs;
+	dmxr = (int)XFS_BTREE_BLOCK_MAXRECS(dblocklen, xfs_bmdr, 0);
+	fkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
+	tkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
+	fpp = XFS_BMAP_BROOT_PTR_ADDR(rblock, 1, rblocklen);
+	tpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
+	dmxr = be16_to_cpu(dblock->bb_numrecs);
+	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
+	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
 }
 
 /*
- * Lookup the record.  The cursor is made to point to it, based on dir.
+ * Check extent records, which have just been read, for
+ * any bit in the extent flag field. ASSERT on debug
+ * kernels, as this condition should not occur.
+ * Return an error condition (1) if any flags found,
+ * otherwise return 0.
  */
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
+
+int
+xfs_check_nostate_extents(
+	xfs_ifork_t		*ifp,
+	xfs_extnum_t		idx,
+	xfs_extnum_t		num)
+{
+	for (; num > 0; num--, idx++) {
+		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, idx);
+		if ((ep->l0 >>
+		     (64 - BMBT_EXNTFLAG_BITLEN)) != 0) {
+			ASSERT(0);
+			return 1;
 		}
 	}
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
 	return 0;
 }
 
 /*
- * Move 1 record left from cur/level if possible.
- * Update cur to reflect the new path.
+ * BMBT function vectors for core btree operations
  */
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
 
 /*
- * Move 1 record right from cur/level if possible.
- * Update cur to reflect the new path.
+ * Get the block pointer for the given level of the cursor.
+ * Fill in the buffer pointer, if applicable.
  */
-STATIC int					/* error */
-xfs_bmbt_rshift(
+STATIC xfs_btree_block_t *
+xfs_bmbt_get_block(
 	xfs_btree_cur_t		*cur,
 	int			level,
-	int			*stat)		/* success/failure */
+	xfs_buf_t		**bpp)
 {
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
+	xfs_ifork_t		*ifp;
+	xfs_bmbt_block_t	*rval;
+
+	if (level < cur->bc_nlevels - 1) {
+		*bpp = cur->bc_bufs[level];
+		rval = XFS_BUF_TO_BMBT_BLOCK(*bpp);
 	} else {
-		lrp = XFS_BMAP_REC_IADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rrp = XFS_BMAP_REC_IADDR(right, 1, cur);
-		memmove(rrp + 1, rrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		*rrp = *lrp;
-		xfs_bmbt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		key.br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(rrp));
-		rkp = &key;
-	}
-	be16_add(&left->bb_numrecs, -1);
-	xfs_bmbt_log_block(cur, lbp, XFS_BB_NUMRECS);
-	be16_add(&right->bb_numrecs, 1);
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
+		*bpp = NULL;
+		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
+			cur->bc_private.b.whichfork);
+		rval = ifp->if_broot;
 	}
-	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
+	return (xfs_btree_block_t *)rval;
+}
+
+
+STATIC int
+xfs_bmbt_get_buf(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr,
+	int		flags,
+	xfs_buf_t	**bpp)
+{
+	xfs_buf_t	*bp;
+
+	BUG_ON(be64_to_cpu(ptr->u.bmbt) == 0);
+	bp = xfs_btree_get_bufl(cur->bc_mp, cur->bc_tp,
+				be64_to_cpu(ptr->u.bmbt), flags);
+	*bpp = bp;
 	return 0;
-error0:
-	XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-error1:
-	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-	return error;
+
 }
 
-/*
- * Determine the extent state.
- */
-/* ARGSUSED */
-STATIC xfs_exntst_t
-xfs_extent_state(
-	xfs_filblks_t		blks,
-	int			extent_flag)
+STATIC int
+xfs_bmbt_read_buf(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr,
+	int		flags,
+	xfs_buf_t	**bpp)
+{
+	BUG_ON(be64_to_cpu(ptr->u.bmbt) == 0);
+	return xfs_btree_read_bufl(cur->bc_mp, cur->bc_tp,
+				be64_to_cpu(ptr->u.bmbt), flags,
+				bpp, XFS_BMAP_BTREE_REF);
+}
+
+STATIC xfs_btree_block_t *
+xfs_bmbt_buf_to_block(
+	xfs_btree_cur_t	*cur,
+	xfs_buf_t	*bp)
 {
-	if (extent_flag) {
-		ASSERT(blks != 0);	/* saved for DMIG */
-		return XFS_EXT_UNWRITTEN;
-	}
-	return XFS_EXT_NORM;
+	/* XFS_BUF_TO_BMBT_BLOCK(rbp); */
+	return XFS_BUF_TO_BLOCK(bp);
 }
 
+STATIC void
+xfs_bmbt_buf_to_ptr(
+	xfs_btree_cur_t	*cur,
+	xfs_buf_t	*bp,
+	xfs_btree_ptr_t	*ptr)
+{
+	ptr->u.bmbt = cpu_to_be64(XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)));
+}
 
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
+STATIC int
+xfs_bmbt_alloc_block(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*start,
+	xfs_btree_ptr_t	*new,
+	int		length,
+	int		*stat)
 {
 	xfs_alloc_arg_t		args;		/* block allocation args */
 	int			error;		/* error return value */
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
+	xfs_fsblock_t		sbno = be64_to_cpu(start->u.bmbt);
 
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGIFK(cur, level, *bnop, *startoff);
+	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	lbp = cur->bc_bufs[level];
-	lbno = XFS_DADDR_TO_FSB(args.mp, XFS_BUF_ADDR(lbp));
-	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
 	args.fsbno = cur->bc_private.b.firstblock;
 	args.firstblock = args.fsbno;
 	if (args.fsbno == NULLFSBLOCK) {
-		args.fsbno = lbno;
+		args.fsbno = sbno;
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
@@ -1503,15 +581,16 @@ xfs_bmbt_split(
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
 	if (!args.wasdel && xfs_trans_get_block_res(args.tp) == 0) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 		return XFS_ERROR(ENOSPC);
 	}
-	if ((error = xfs_alloc_vextent(&args))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
+	error = xfs_alloc_vextent(&args);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 		return error;
 	}
 	if (args.fsbno == NULLFSBLOCK) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 		*stat = 0;
 		return 0;
 	}
@@ -1522,602 +601,383 @@ xfs_bmbt_split(
 	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
 	XFS_TRANS_MOD_DQUOT_BYINO(args.mp, args.tp, cur->bc_private.b.ip,
 			XFS_TRANS_DQ_BCOUNT, 1L);
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
-		be16_add(&right->bb_numrecs, 1);
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
-	be16_add(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
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
+
+	new->u.bmbt = cpu_to_be64(args.fsbno);
 	*stat = 1;
 	return 0;
 }
 
-
-/*
- * Update keys for the record.
- */
 STATIC int
-xfs_bmbt_updkey(
-	xfs_btree_cur_t		*cur,
-	xfs_bmbt_key_t		*keyp,	/* on-disk format */
-	int			level)
+xfs_bmbt_free_block(
+	xfs_btree_cur_t	*cur,
+	xfs_buf_t	*bp,
+	int		size)
 {
-	xfs_bmbt_block_t	*block;
-	xfs_buf_t		*bp;
-#ifdef DEBUG
-	int			error;
-#endif
-	xfs_bmbt_key_t		*kp;
-	int			ptr;
+	xfs_mount_t	*mp = cur->bc_mp;
+	xfs_inode_t	*ip = cur->bc_private.b.ip;
 
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
+	xfs_bmap_add_free(XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp)), 1,
+		cur->bc_private.b.flist, mp);
+	ip->i_d.di_nblocks--;
+	xfs_trans_log_inode(cur->bc_tp, ip, XFS_ILOG_CORE);
+	XFS_TRANS_MOD_DQUOT_BYINO(mp, cur->bc_tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
+	xfs_trans_binval(cur->bc_tp, bp);
 	return 0;
 }
 
+
 /*
- * Convert on-disk form of btree root to in-memory form.
+ * Log fields from the btree block header.
  */
 void
-xfs_bmdr_to_bmbt(
-	xfs_bmdr_block_t	*dblock,
-	int			dblocklen,
-	xfs_bmbt_block_t	*rblock,
-	int			rblocklen)
-{
-	int			dmxr;
-	xfs_bmbt_key_t		*fkp;
-	__be64			*fpp;
-	xfs_bmbt_key_t		*tkp;
-	__be64			*tpp;
-
-	rblock->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
-	rblock->bb_level = dblock->bb_level;
-	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
-	rblock->bb_numrecs = dblock->bb_numrecs;
-	rblock->bb_leftsib = cpu_to_be64(NULLDFSBNO);
-	rblock->bb_rightsib = cpu_to_be64(NULLDFSBNO);
-	dmxr = (int)XFS_BTREE_BLOCK_MAXRECS(dblocklen, xfs_bmdr, 0);
-	fkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
-	tkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
-	fpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
-	tpp = XFS_BMAP_BROOT_PTR_ADDR(rblock, 1, rblocklen);
-	dmxr = be16_to_cpu(dblock->bb_numrecs);
-	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
-	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
-}
+xfs_bmbt_log_block(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_buf_t		*bp,	/* buffer containing btree block */
+	int			fields)	/* mask of fields: XFS_BB_... */
+{
+	int			first;	/* first byte offset logged */
+	int			last;	/* last byte offset logged */
+	static const short	offsets[] = {	/* table of offsets */
+		offsetof(xfs_bmbt_block_t, bb_magic),
+		offsetof(xfs_bmbt_block_t, bb_level),
+		offsetof(xfs_bmbt_block_t, bb_numrecs),
+		offsetof(xfs_bmbt_block_t, bb_leftsib),
+		offsetof(xfs_bmbt_block_t, bb_rightsib),
+		sizeof(xfs_bmbt_block_t)
+	};
 
-/*
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
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBI(cur, bp, fields);
+	if (bp) {
+		xfs_btree_offsets(fields, offsets, XFS_BB_NUM_BITS, &first,
+				  &last);
+		xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	} else
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
+			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 }
 
-/*
- * Delete the record pointed to by cur.
- */
-int					/* error */
-xfs_bmbt_delete(
+static const struct xfs_btree_block_ops xfs_bmbt_blkops = {
+	.get_buf	= xfs_bmbt_get_buf,
+	.read_buf	= xfs_bmbt_read_buf,
+	.get_block	= xfs_bmbt_get_block,
+	.buf_to_block	= xfs_bmbt_buf_to_block,
+	.buf_to_ptr	= xfs_bmbt_buf_to_ptr,
+	.log_block	= xfs_bmbt_log_block,
+	.check_block	= xfs_btree_check_lblock,
+
+	.alloc_block	= xfs_bmbt_alloc_block,
+	.free_block	= xfs_bmbt_free_block,
+
+	.get_sibling	= xfs_btree_get_lsibling,
+	.set_sibling	= xfs_btree_set_lsibling,
+	.init_sibling	= xfs_btree_init_sibling,
+};
+
+STATIC int
+xfs_bmbt_get_iminrecs(
 	xfs_btree_cur_t	*cur,
-	int		*stat)		/* success/failure */
+	int		lev)
 {
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
+	return XFS_BMAP_BLOCK_IMINRECS(lev, cur);
 }
 
-/*
- * Convert a compressed bmap extent record to an uncompressed form.
- * This code must be in sync with the routines xfs_bmbt_get_startoff,
- * xfs_bmbt_get_startblock, xfs_bmbt_get_blockcount and xfs_bmbt_get_state.
- */
-
-STATIC_INLINE void
-__xfs_bmbt_get_all(
-		__uint64_t l0,
-		__uint64_t l1,
-		xfs_bmbt_irec_t *s)
+STATIC int
+xfs_bmbt_get_imaxrecs(
+	xfs_btree_cur_t	*cur,
+	int		lev)
 {
-	int	ext_flag;
-	xfs_exntst_t st;
-
-	ext_flag = (int)(l0 >> (64 - BMBT_EXNTFLAG_BITLEN));
-	s->br_startoff = ((xfs_fileoff_t)l0 &
-			   XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
-#if XFS_BIG_BLKNOS
-	s->br_startblock = (((xfs_fsblock_t)l0 & XFS_MASK64LO(9)) << 43) |
-			   (((xfs_fsblock_t)l1) >> 21);
-#else
-#ifdef DEBUG
-	{
-		xfs_dfsbno_t	b;
+	return XFS_BMAP_BLOCK_IMAXRECS(lev, cur);
+}
 
-		b = (((xfs_dfsbno_t)l0 & XFS_MASK64LO(9)) << 43) |
-		    (((xfs_dfsbno_t)l1) >> 21);
-		ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
-		s->br_startblock = (xfs_fsblock_t)b;
-	}
-#else	/* !DEBUG */
-	s->br_startblock = (xfs_fsblock_t)(((xfs_dfsbno_t)l1) >> 21);
-#endif	/* DEBUG */
-#endif	/* XFS_BIG_BLKNOS */
-	s->br_blockcount = (xfs_filblks_t)(l1 & XFS_MASK64LO(21));
-	/* This is xfs_extent_state() in-line */
-	if (ext_flag) {
-		ASSERT(s->br_blockcount != 0);	/* saved for DMIG */
-		st = XFS_EXT_UNWRITTEN;
-	} else
-		st = XFS_EXT_NORM;
-	s->br_state = st;
+STATIC int
+xfs_bmbt_get_dminrecs(
+	xfs_btree_cur_t	*cur,
+	int		lev)
+{
+	return XFS_BMAP_BLOCK_DMINRECS(lev, cur);
 }
 
-void
-xfs_bmbt_get_all(
-	xfs_bmbt_rec_host_t *r,
-	xfs_bmbt_irec_t *s)
+STATIC int
+xfs_bmbt_get_dmaxrecs(
+	xfs_btree_cur_t	*cur,
+	int		lev)
 {
-	__xfs_bmbt_get_all(r->l0, r->l1, s);
+	return XFS_BMAP_BLOCK_DMAXRECS(lev, cur);
 }
 
-/*
- * Get the block pointer for the given level of the cursor.
- * Fill in the buffer pointer, if applicable.
- */
-xfs_bmbt_block_t *
-xfs_bmbt_get_block(
+STATIC int
+xfs_btree_get_numrecs(
 	xfs_btree_cur_t		*cur,
-	int			level,
-	xfs_buf_t		**bpp)
+	xfs_btree_block_t	*block)
 {
-	xfs_ifork_t		*ifp;
-	xfs_bmbt_block_t	*rval;
+	return be16_to_cpu(block->bb_h.bb_numrecs);
+}
 
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
+STATIC void
+xfs_btree_set_numrecs(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block,
+	int			numrecs)
+{
+	block->bb_h.bb_numrecs = cpu_to_be16(numrecs);
 }
 
-/*
- * Extract the blockcount field from an in memory bmap extent record.
- */
-xfs_filblks_t
-xfs_bmbt_get_blockcount(
-	xfs_bmbt_rec_host_t	*r)
+STATIC void
+xfs_bmbt_init_key_from_rec(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_key_t	*key,
+	xfs_btree_rec_t	*rec)
 {
-	return (xfs_filblks_t)(r->l1 & XFS_MASK64LO(21));
+	key->u.bmbt.br_startoff = cpu_to_be64(
+				xfs_bmbt_disk_get_startoff(&rec->u.bmbt));
 }
 
 /*
- * Extract the startblock field from an in memory bmap extent record.
+ * intial value of ptr for lookup
  */
-xfs_fsblock_t
-xfs_bmbt_get_startblock(
-	xfs_bmbt_rec_host_t	*r)
+STATIC void
+xfs_bmbt_init_ptr_from_cur(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr)
 {
-#if XFS_BIG_BLKNOS
-	return (((xfs_fsblock_t)r->l0 & XFS_MASK64LO(9)) << 43) |
-	       (((xfs_fsblock_t)r->l1) >> 21);
-#else
-#ifdef DEBUG
-	xfs_dfsbno_t	b;
-
-	b = (((xfs_dfsbno_t)r->l0 & XFS_MASK64LO(9)) << 43) |
-	    (((xfs_dfsbno_t)r->l1) >> 21);
-	ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
-	return (xfs_fsblock_t)b;
-#else	/* !DEBUG */
-	return (xfs_fsblock_t)(((xfs_dfsbno_t)r->l1) >> 21);
-#endif	/* DEBUG */
-#endif	/* XFS_BIG_BLKNOS */
+	ptr->u.bmbt = 0;
 }
 
-/*
- * Extract the startoff field from an in memory bmap extent record.
- */
-xfs_fileoff_t
-xfs_bmbt_get_startoff(
-	xfs_bmbt_rec_host_t	*r)
+STATIC void
+xfs_bmbt_init_rec_from_key(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_key_t	*key,
+	xfs_btree_rec_t	*rec)
 {
-	return ((xfs_fileoff_t)r->l0 &
-		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+	BUG_ON(be64_to_cpu(key->u.bmbt.br_startoff) == 0);
+	xfs_bmbt_disk_set_allf(&rec->u.bmbt,
+				be64_to_cpu(key->u.bmbt.br_startoff),
+				0, 0, XFS_EXT_NORM);
 }
 
-xfs_exntst_t
-xfs_bmbt_get_state(
-	xfs_bmbt_rec_host_t	*r)
+STATIC void
+xfs_bmbt_init_rec_from_cur(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_rec_t	*rec)
 {
-	int	ext_flag;
+	BUG_ON(cur->bc_rec.b.br_startoff == 0);
+	xfs_bmbt_disk_set_all(&rec->u.bmbt, &cur->bc_rec.b);
+}
 
-	ext_flag = (int)((r->l0) >> (64 - BMBT_EXNTFLAG_BITLEN));
-	return xfs_extent_state(xfs_bmbt_get_blockcount(r),
-				ext_flag);
+STATIC xfs_btree_key_t *
+xfs_bmbt_key_addr(
+	xfs_btree_cur_t		*cur,
+	int			index,
+	xfs_btree_block_t	*block)
+{
+	return (xfs_btree_key_t *)XFS_BMAP_KEY_IADDR(&block->bb_h, index, cur);
 }
 
-/* Endian flipping versions of the bmbt extraction functions */
-void
-xfs_bmbt_disk_get_all(
-	xfs_bmbt_rec_t	*r,
-	xfs_bmbt_irec_t *s)
+STATIC xfs_btree_ptr_t *
+xfs_bmbt_ptr_addr(
+	xfs_btree_cur_t		*cur,
+	int			index,
+	xfs_btree_block_t	*block)
 {
-	__xfs_bmbt_get_all(be64_to_cpu(r->l0), be64_to_cpu(r->l1), s);
+	return (xfs_btree_ptr_t *)XFS_BMAP_PTR_IADDR(&block->bb_h, index, cur);
 }
 
-/*
- * Extract the blockcount field from an on disk bmap extent record.
- */
-xfs_filblks_t
-xfs_bmbt_disk_get_blockcount(
-	xfs_bmbt_rec_t	*r)
+STATIC xfs_btree_rec_t *
+xfs_bmbt_rec_addr(
+	xfs_btree_cur_t		*cur,
+	int			index,
+	xfs_btree_block_t	*block)
 {
-	return (xfs_filblks_t)(be64_to_cpu(r->l1) & XFS_MASK64LO(21));
+	return (xfs_btree_rec_t *)XFS_BMAP_REC_IADDR(&block->bb_h, index, cur);
 }
 
-/*
- * Extract the startoff field from a disk format bmap extent record.
- */
-xfs_fileoff_t
-xfs_bmbt_disk_get_startoff(
-	xfs_bmbt_rec_t	*r)
+STATIC int64_t
+xfs_bmbt_key_diff(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_key_t		*key)
 {
-	return ((xfs_fileoff_t)be64_to_cpu(r->l0) &
-		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+	return (int64_t)(be64_to_cpu(key->u.bmbt.br_startoff) -
+						cur->bc_rec.b.br_startoff);
 }
 
-/*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
- */
-int						/* error */
-xfs_bmbt_increment(
+STATIC xfs_daddr_t
+xfs_bmbt_ptr_to_daddr(
 	xfs_btree_cur_t		*cur,
-	int			level,
-	int			*stat)		/* success/failure */
+	xfs_btree_ptr_t		*ptr)
 {
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
+	return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->u.bmbt));
+}
+
+STATIC void
+xfs_bmbt_move_keys(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_key_t		*src_key,
+	xfs_btree_key_t		*dst_key,
+	int			from,
+	int			to,
+	int			numkeys)
+{
+	if (dst_key == NULL) {
+		/* moving within a block */
+		xfs_bmbt_key_t	*kp = &src_key->u.bmbt;
+		memmove(&kp[to], &kp[from], numkeys * sizeof(*kp));
+	} else {
+		/* moving between blocks */
+		memcpy(dst_key, src_key, numkeys * sizeof(xfs_bmbt_key_t));
 	}
-	if (lev == cur->bc_nlevels) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
+}
+
+STATIC void
+xfs_bmbt_move_ptrs(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_ptr_t		*src_ptr,
+	xfs_btree_ptr_t		*dst_ptr,
+	int			from,
+	int			to,
+	int			numptrs)
+{
+	if (dst_ptr == NULL) {
+		/* moving within a block */
+		xfs_bmbt_ptr_t	*pp = &src_ptr->u.bmbt;
+		memmove(&pp[to], &pp[from], numptrs * sizeof(*pp));
+	} else {
+		/* moving between blocks */
+		memcpy(dst_ptr, src_ptr, numptrs * sizeof(xfs_bmbt_ptr_t));
 	}
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
+}
+
+STATIC void
+xfs_bmbt_move_recs(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_rec_t		*src_rec,
+	xfs_btree_rec_t		*dst_rec,
+	int			from,
+	int			to,
+	int			numrecs)
+{
+	if (dst_rec == NULL) {
+		/* moving within a block */
+		xfs_bmbt_rec_t	*rp = &src_rec->u.bmbt;
+		memmove(&rp[to], &rp[from], numrecs * sizeof(*rp));
+	} else {
+		/* moving between blocks */
+		memcpy(dst_rec, src_rec, numrecs * sizeof(xfs_bmbt_rec_t));
 	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*stat = 1;
-	return 0;
+}
+
+
+STATIC void
+xfs_bmbt_set_key(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_key_t	*key_addr,
+	int		index,
+	xfs_btree_key_t	*newkey)
+{
+	xfs_bmbt_key_t	*kp = &key_addr->u.bmbt;
+
+	kp[index] = newkey->u.bmbt;
+}
+
+STATIC void
+xfs_bmbt_set_ptr(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr_addr,
+	int		index,
+	xfs_btree_ptr_t	*newptr)
+{
+	xfs_bmbt_ptr_t	*pp = &ptr_addr->u.bmbt;
+
+	pp[index] = newptr->u.bmbt;
+}
+
+STATIC void
+xfs_bmbt_set_rec(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_rec_t	*rec_addr,
+	int		index,
+	xfs_btree_rec_t	*newrec)
+{
+	xfs_bmbt_rec_t	*rp = &rec_addr->u.bmbt;
+
+	rp[index] = newrec->u.bmbt;
 }
 
 /*
- * Insert the current record at the point referenced by cur.
+ * Log keys from a btree block (nonleaf).
  */
-int					/* error */
-xfs_bmbt_insert(
+STATIC void
+xfs_bmbt_log_keys(
 	xfs_btree_cur_t	*cur,
-	int		*stat)		/* success/failure */
+	xfs_buf_t	*bp,
+	int		kfirst,
+	int		klast)
 {
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
+	xfs_trans_t	*tp;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, kfirst, klast);
+	tp = cur->bc_tp;
+	if (bp) {
+		xfs_bmbt_block_t	*block;
+		int			first;
+		xfs_bmbt_key_t		*kp;
+		int			last;
+
+		block = XFS_BUF_TO_BMBT_BLOCK(bp);
+		kp = XFS_BMAP_KEY_DADDR(block, 1, cur);
+		first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
+		last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
+		xfs_trans_log_buf(tp, bp, first, last);
+	} else {
+		xfs_inode_t		 *ip;
+
+		ip = cur->bc_private.b.ip;
+		xfs_trans_log_inode(tp, ip,
+			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+	}
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 }
 
 /*
- * Log fields from the btree block header.
+ * Log block pointer fields from a btree block (nonleaf).
  */
-void
-xfs_bmbt_log_block(
-	xfs_btree_cur_t		*cur,
-	xfs_buf_t		*bp,
-	int			fields)
+STATIC void
+xfs_bmbt_log_ptrs(
+	xfs_btree_cur_t	*cur,
+	xfs_buf_t	*bp,
+	int		pfirst,
+	int		plast)
 {
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
+	xfs_trans_t	*tp;
 
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBI(cur, bp, fields);
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, pfirst, plast);
 	tp = cur->bc_tp;
 	if (bp) {
-		xfs_btree_offsets(fields, offsets, XFS_BB_NUM_BITS, &first,
-				  &last);
+		xfs_bmbt_block_t	*block;
+		int			first;
+		int			last;
+		xfs_bmbt_ptr_t		*pp;
+
+		block = XFS_BUF_TO_BMBT_BLOCK(bp);
+		pp = XFS_BMAP_PTR_DADDR(block, 1, cur);
+		first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
+		last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
 		xfs_trans_log_buf(tp, bp, first, last);
-	} else
-		xfs_trans_log_inode(tp, cur->bc_private.b.ip,
+	} else {
+		xfs_inode_t		*ip;
+
+		ip = cur->bc_private.b.ip;
+		xfs_trans_log_inode(tp, ip,
 			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
+	}
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 }
 
 /*
- * Log record values from the btree block.
+ * Log records from a btree block (leaf).
  */
 void
 xfs_bmbt_log_recs(
@@ -2130,445 +990,432 @@ xfs_bmbt_log_recs(
 	int			first;
 	int			last;
 	xfs_bmbt_rec_t		*rp;
-	xfs_trans_t		*tp;
 
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBII(cur, bp, rfirst, rlast);
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, rfirst, rlast);
 	ASSERT(bp);
-	tp = cur->bc_tp;
 	block = XFS_BUF_TO_BMBT_BLOCK(bp);
 	rp = XFS_BMAP_REC_DADDR(block, 1, cur);
 	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
 	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(tp, bp, first, last);
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 }
 
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
+static const struct xfs_btree_record_ops xfs_bmbt_recops = {
+	.get_minrecs	= xfs_bmbt_get_iminrecs,
+	.get_maxrecs	= xfs_bmbt_get_imaxrecs,
+	.get_dminrecs	= xfs_bmbt_get_dminrecs,
+	.get_dmaxrecs	= xfs_bmbt_get_dmaxrecs,
+	.get_numrecs	= xfs_btree_get_numrecs,
+	.set_numrecs	= xfs_btree_set_numrecs,
+
+	.init_key_from_rec = xfs_bmbt_init_key_from_rec,
+	.init_ptr_from_cur = xfs_bmbt_init_ptr_from_cur,
+	.init_rec_from_key = xfs_bmbt_init_rec_from_key,
+	.init_rec_from_cur = xfs_bmbt_init_rec_from_cur,
+
+	.key_addr	= xfs_bmbt_key_addr,
+	.ptr_addr	= xfs_bmbt_ptr_addr,
+	.rec_addr	= xfs_bmbt_rec_addr,
+
+	.key_diff	= xfs_bmbt_key_diff,
+	.ptr_to_daddr	= xfs_bmbt_ptr_to_daddr,
+
+	.move_keys	= xfs_bmbt_move_keys,
+	.move_ptrs	= xfs_bmbt_move_ptrs,
+	.move_recs	= xfs_bmbt_move_recs,
+
+	.set_key	= xfs_bmbt_set_key,
+	.set_ptr	= xfs_bmbt_set_ptr,
+	.set_rec	= xfs_bmbt_set_rec,
+
+	.log_keys	= xfs_bmbt_log_keys,
+	.log_ptrs	= xfs_bmbt_log_ptrs,
+	.log_recs	= xfs_bmbt_log_recs,
 
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
+	.check_ptrs	= xfs_btree_check_lptr,
+};
 
-/*
- * Give the bmap btree a new root block.  Copy the old broot contents
- * down into a real block and make the broot point to it.
- */
-int						/* error */
-xfs_bmbt_newroot(
+STATIC int						/* error */
+xfs_bmbt_new_root(
 	xfs_btree_cur_t		*cur,		/* btree cursor */
-	int			*logflags,	/* logging flags for inode */
 	int			*stat)		/* return status - 0 fail */
 {
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
+	int			logflags = 0;
+	int			error;
+
+	error = xfs_bmbt_newroot(cur, &logflags, stat);
+	if (!(error || *stat == 0))
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip, logflags);
+	return error;
+}
+
+STATIC int
+xfs_bmbt_killroot(
+	xfs_btree_cur_t		*cur,
+	int			lev,		/* unused */
+	xfs_btree_ptr_t		*newroot)	/* unused */
+{
+	xfs_btree_block_t	*block;
+	xfs_btree_block_t	*cblock;
+	xfs_buf_t		*cbp;
+	xfs_btree_key_t		*ckp;
+	xfs_btree_ptr_t		*cpp;
+	int			i;
+	xfs_btree_key_t		*kp;
+	xfs_inode_t		*ip;
+	xfs_ifork_t		*ifp;
+	int			level;
+	xfs_btree_ptr_t		*pp;
+
+	ASSERT(newroot == NULL);
+	ASSERT(lev == -1);
 
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
 	level = cur->bc_nlevels - 1;
-	block = xfs_bmbt_get_block(cur, level, &bp);
+	ASSERT(level >= 1);
 	/*
-	 * Copy the root into a real block.
+	 * Don't deal with the root block needs to be a leaf case.
+	 * We're just going to turn the thing back into extents anyway.
 	 */
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
-	} else
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	if ((error = xfs_alloc_vextent(&args))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	if (args.fsbno == NULLFSBLOCK) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
+	if (level == 1)
+		goto out0;
+
+	block = xfs_bmbt_get_block(cur, level, &cbp);
+	/*
+	 * Give up if the root has multiple children.
+	 */
+	if (be16_to_cpu(block->bb_h.bb_numrecs) != 1)
+		goto out0;
+	/*
+	 * Only do this if the next level will fit.
+	 * Then the data must be copied up to the inode,
+	 * instead of freeing the root you free the next level.
+	 */
+	cbp = cur->bc_bufs[level - 1];
+	cblock = xfs_bmbt_buf_to_block(cur, cbp);
+	if (be16_to_cpu(cblock->bb_h.bb_numrecs) > xfs_bmbt_get_dmaxrecs(cur, level))
+		goto out0;
+
+	ASSERT(be64_to_cpu(cblock->bb_h.bb_leftsib) == NULLDFSBNO);
+	ASSERT(be64_to_cpu(cblock->bb_h.bb_rightsib) == NULLDFSBNO);
+	ip = cur->bc_private.b.ip;
+	ifp = XFS_IFORK_PTR(ip, cur->bc_private.b.whichfork);
+	ASSERT(xfs_bmbt_get_imaxrecs(cur, level) ==
+	       XFS_BMAP_BROOT_MAXRECS(ifp->if_broot_bytes));
+	i = (int)(be16_to_cpu(cblock->bb_h.bb_numrecs) - xfs_bmbt_get_imaxrecs(cur, level));
+	if (i) {
+		xfs_iroot_realloc(ip, i, cur->bc_private.b.whichfork);
+		block = (xfs_btree_block_t *)ifp->if_broot;
 	}
-	ASSERT(args.len == 1);
-	cur->bc_private.b.firstblock = args.fsbno;
-	cur->bc_private.b.allocated++;
-	cur->bc_private.b.ip->i_d.di_nblocks++;
-	XFS_TRANS_MOD_DQUOT_BYINO(args.mp, args.tp, cur->bc_private.b.ip,
-			  XFS_TRANS_DQ_BCOUNT, 1L);
-	bp = xfs_btree_get_bufl(args.mp, cur->bc_tp, args.fsbno, 0);
-	cblock = XFS_BUF_TO_BMBT_BLOCK(bp);
-	*cblock = *block;
-	be16_add(&block->bb_level, 1);
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
+	be16_add(&block->bb_h.bb_numrecs, i);
+	ASSERT(block->bb_h.bb_numrecs == cblock->bb_h.bb_numrecs);
+	kp = xfs_bmbt_key_addr(cur, 1, block);
+	ckp = xfs_bmbt_key_addr(cur, 1, cblock);
+	memcpy(kp, ckp, be16_to_cpu(block->bb_h.bb_numrecs) * sizeof(xfs_bmbt_key_t));
+	pp = xfs_bmbt_ptr_addr(cur, 1, block);
+	cpp = xfs_bmbt_ptr_addr(cur, 1, cblock);
+#ifdef DEBUG
+	for (i = 0; i < be16_to_cpu(cblock->bb_h.bb_numrecs); i++) {
+		int	error;
+		error = xfs_btree_check_lptr_disk(cur, cpp, i, level - 1);
+		if (error) {
+			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 			return error;
 		}
 	}
 #endif
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
+	memcpy(pp, cpp, be16_to_cpu(block->bb_h.bb_numrecs) * sizeof(xfs_bmbt_ptr_t));
+
+	xfs_bmbt_free_block(cur, cbp, 1);
+	cur->bc_bufs[level - 1] = NULL;
+	be16_add(&block->bb_h.bb_level, -1);
+	xfs_trans_log_inode(cur->bc_tp, ip,
+		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+	cur->bc_nlevels--;
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 	return 0;
 }
 
-/*
- * Set all the fields in a bmap extent record from the arguments.
- */
-void
-xfs_bmbt_set_allf(
-	xfs_bmbt_rec_host_t	*r,
-	xfs_fileoff_t		startoff,
-	xfs_fsblock_t		startblock,
-	xfs_filblks_t		blockcount,
-	xfs_exntst_t		state)
+STATIC int
+xfs_bmbt_realloc_root(
+	xfs_btree_cur_t	*cur,
+	int		index)
 {
-	int		extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
-
-	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
-	ASSERT((startoff & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
-	ASSERT((blockcount & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
+	xfs_inode_t	*ip = cur->bc_private.b.ip;
+	xfs_iroot_realloc(ip, index, cur->bc_private.b.whichfork);
+	return 0;
+}
 
-#if XFS_BIG_BLKNOS
-	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+STATIC void
+xfs_bmbt_update_cursor(
+	xfs_btree_cur_t	*src,
+	xfs_btree_cur_t	*dst)
+{
+	ASSERT((dst->bc_private.b.firstblock != NULLFSBLOCK) ||
+	       (dst->bc_private.b.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
+	ASSERT(dst->bc_private.b.flist == src->bc_private.b.flist);
 
-	r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-		((xfs_bmbt_rec_base_t)startoff << 9) |
-		((xfs_bmbt_rec_base_t)startblock >> 43);
-	r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
-		((xfs_bmbt_rec_base_t)blockcount &
-		(xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
-#else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(startblock)) {
-		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			((xfs_bmbt_rec_base_t)startoff << 9) |
-			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
-		r->l1 = XFS_MASK64HI(11) |
-			  ((xfs_bmbt_rec_base_t)startblock << 21) |
-			  ((xfs_bmbt_rec_base_t)blockcount &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
-	} else {
-		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			((xfs_bmbt_rec_base_t)startoff << 9);
-		r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
-			 ((xfs_bmbt_rec_base_t)blockcount &
-			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
-	}
-#endif	/* XFS_BIG_BLKNOS */
+	dst->bc_private.b.allocated += src->bc_private.b.allocated;
+	src->bc_private.b.allocated = 0;
+	dst->bc_private.b.firstblock = src->bc_private.b.firstblock;
 }
 
+static const struct xfs_btree_cur_ops xfs_bmbt_curops = {
+	.new_root	= xfs_bmbt_new_root,
+	.realloc_root	= xfs_bmbt_realloc_root,
+	.kill_root	= xfs_bmbt_killroot,
+	.update_cursor	=xfs_bmbt_update_cursor,
+};
+
+#if defined(XFS_BTREE_TRACE)
+
 /*
- * Set all the fields in a bmap extent record from the uncompressed form.
+ * Global bmbt trace buffer
  */
-void
-xfs_bmbt_set_all(
-	xfs_bmbt_rec_host_t *r,
-	xfs_bmbt_irec_t	*s)
+ktrace_t        *xfs_bmbt_trace_buf;
+/*
+ * Add a trace buffer entry for the arguments given to the routine,
+ * generic form.
+ */
+STATIC void
+xfs_bmbt_trace_enter(
+	const char	*func,
+	xfs_btree_cur_t	*cur,
+	char		*s,
+	int		type,
+	int		line,
+	__psunsigned_t	a0,
+	__psunsigned_t	a1,
+	__psunsigned_t	a2,
+	__psunsigned_t	a3,
+	__psunsigned_t	a4,
+	__psunsigned_t	a5,
+	__psunsigned_t	a6,
+	__psunsigned_t	a7,
+	__psunsigned_t	a8,
+	__psunsigned_t	a9,
+	__psunsigned_t	a10)
 {
-	xfs_bmbt_set_allf(r, s->br_startoff, s->br_startblock,
-			     s->br_blockcount, s->br_state);
+	xfs_inode_t	*ip;
+	int		whichfork;
+
+	ip = cur->bc_private.b.ip;
+	whichfork = cur->bc_private.b.whichfork;
+	ktrace_enter(xfs_bmbt_trace_buf,
+		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
+		(void *)func, (void *)s, (void *)ip, (void *)cur,
+		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
+		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
+		(void *)a8, (void *)a9, (void *)a10);
+	ASSERT(ip->i_btrace);
+	ktrace_enter(ip->i_btrace,
+		(void *)((__psint_t)type | (whichfork << 8) | (line << 16)),
+		(void *)func, (void *)s, (void *)ip, (void *)cur,
+		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
+		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
+		(void *)a8, (void *)a9, (void *)a10);
 }
 
-
-/*
- * Set all the fields in a disk format bmap extent record from the arguments.
- */
-void
-xfs_bmbt_disk_set_allf(
-	xfs_bmbt_rec_t		*r,
-	xfs_fileoff_t		startoff,
-	xfs_fsblock_t		startblock,
-	xfs_filblks_t		blockcount,
-	xfs_exntst_t		state)
+STATIC void
+xfs_bmbt_trace_cursor(
+	xfs_btree_cur_t	*cur,
+	__uint32_t	*s0,
+	__uint64_t	*l0,
+	__uint64_t	*l1)
 {
-	int			extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
-
-	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
-	ASSERT((startoff & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
-	ASSERT((blockcount & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
+	xfs_bmbt_rec_host_t	r;
 
-#if XFS_BIG_BLKNOS
-	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+	xfs_bmbt_set_all(&r, &cur->bc_rec.b);
 
-	r->l0 = cpu_to_be64(
-		((xfs_bmbt_rec_base_t)extent_flag << 63) |
-		 ((xfs_bmbt_rec_base_t)startoff << 9) |
-		 ((xfs_bmbt_rec_base_t)startblock >> 43));
-	r->l1 = cpu_to_be64(
-		((xfs_bmbt_rec_base_t)startblock << 21) |
-		 ((xfs_bmbt_rec_base_t)blockcount &
-		  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
-#else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(startblock)) {
-		r->l0 = cpu_to_be64(
-			((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			 ((xfs_bmbt_rec_base_t)startoff << 9) |
-			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
-		r->l1 = cpu_to_be64(XFS_MASK64HI(11) |
-			  ((xfs_bmbt_rec_base_t)startblock << 21) |
-			  ((xfs_bmbt_rec_base_t)blockcount &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
-	} else {
-		r->l0 = cpu_to_be64(
-			((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			 ((xfs_bmbt_rec_base_t)startoff << 9));
-		r->l1 = cpu_to_be64(
-			((xfs_bmbt_rec_base_t)startblock << 21) |
-			 ((xfs_bmbt_rec_base_t)blockcount &
-			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
-	}
-#endif	/* XFS_BIG_BLKNOS */
+	*s0 = (cur->bc_private.b.flags << 16) | cur->bc_private.b.allocated;
+	*l0 = r.l0;
+	*l1 = r.l1;
 }
 
-/*
- * Set all the fields in a bmap extent record from the uncompressed form.
- */
-void
-xfs_bmbt_disk_set_all(
-	xfs_bmbt_rec_t	*r,
-	xfs_bmbt_irec_t *s)
-{
-	xfs_bmbt_disk_set_allf(r, s->br_startoff, s->br_startblock,
-				  s->br_blockcount, s->br_state);
-}
+STATIC void
+xfs_bmbt_trace_record(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_rec_t	*rec,
+	__uint64_t	*l0,
+	__uint64_t	*l1,
+	__uint64_t	*l2)
+{
+	xfs_bmbt_irec_t         s;
+
+	xfs_bmbt_disk_get_all(&rec->u.bmbt, &s);
+	*l0 = s.br_startoff;
+	*l1 = s.br_startblock;
+	*l2 = s.br_blockcount;
+}
+
+static const struct xfs_btree_trc_ops xfs_bmbt_trcops = {
+	.enter		= xfs_bmbt_trace_enter,
+	.cursor		= xfs_bmbt_trace_cursor,
+	.record		= xfs_bmbt_trace_record,
+};
+#endif
 
-/*
- * Set the blockcount field in a bmap extent record.
- */
 void
-xfs_bmbt_set_blockcount(
-	xfs_bmbt_rec_host_t *r,
-	xfs_filblks_t	v)
+xfs_bmbt_init_cursor(
+	xfs_btree_cur_t	*cur)
 {
-	ASSERT((v & XFS_MASK64HI(43)) == 0);
-	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64HI(43)) |
-		  (xfs_bmbt_rec_base_t)(v & XFS_MASK64LO(21));
+	cur->bc_flags = XFS_BTREE_ROOT_IN_INODE;
+	cur->bc_curops = &xfs_bmbt_curops;
+	cur->bc_blkops = &xfs_bmbt_blkops;
+	cur->bc_recops = &xfs_bmbt_recops;
+#if defined(XFS_BTREE_TRACE)
+	cur->bc_trcops = &xfs_bmbt_trcops;
+#endif
 }
 
 /*
- * Set the startblock field in a bmap extent record.
+ * BMBT functions that are not covered by core btree code.
+ * Externally visible routines.
  */
-void
-xfs_bmbt_set_startblock(
-	xfs_bmbt_rec_host_t *r,
-	xfs_fsblock_t	v)
-{
-#if XFS_BIG_BLKNOS
-	ASSERT((v & XFS_MASK64HI(12)) == 0);
-	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t)XFS_MASK64HI(55)) |
-		  (xfs_bmbt_rec_base_t)(v >> 43);
-	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)) |
-		  (xfs_bmbt_rec_base_t)(v << 21);
-#else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(v)) {
-		r->l0 |= (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
-		r->l1 = (xfs_bmbt_rec_base_t)XFS_MASK64HI(11) |
-			  ((xfs_bmbt_rec_base_t)v << 21) |
-			  (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
-	} else {
-		r->l0 &= ~(xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
-		r->l1 = ((xfs_bmbt_rec_base_t)v << 21) |
-			  (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
-	}
-#endif	/* XFS_BIG_BLKNOS */
-}
 
 /*
- * Set the startoff field in a bmap extent record.
+ * Update the record referred to by cur to the value given
+ * by [off, bno, len, state].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
  */
-void
-xfs_bmbt_set_startoff(
-	xfs_bmbt_rec_host_t *r,
-	xfs_fileoff_t	v)
+int
+xfs_bmbt_update(
+	xfs_btree_cur_t	*cur,
+	xfs_fileoff_t	off,
+	xfs_fsblock_t	bno,
+	xfs_filblks_t	len,
+	xfs_exntst_t	state)
 {
-	ASSERT((v & XFS_MASK64HI(9)) == 0);
-	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t) XFS_MASK64HI(1)) |
-		((xfs_bmbt_rec_base_t)v << 9) |
-		  (r->l0 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
+	xfs_btree_rec_t	rec;
+
+	xfs_bmbt_disk_set_allf(&rec.u.bmbt, off, bno, len, state);
+	return xfs_btree_update(cur, &rec);
 }
 
 /*
- * Set the extent state field in a bmap extent record.
+ * Lookup the record equal to [off, bno, len] in the btree given by cur.
  */
-void
-xfs_bmbt_set_state(
-	xfs_bmbt_rec_host_t *r,
-	xfs_exntst_t	v)
+int					/* error */
+xfs_bmbt_lookup_eq(
+	xfs_btree_cur_t	*cur,		/* btree cursor */
+	xfs_fileoff_t	off,
+	xfs_fsblock_t	bno,
+	xfs_filblks_t	len,
+	int		*stat)		/* success/failure */
 {
-	ASSERT(v == XFS_EXT_NORM || v == XFS_EXT_UNWRITTEN);
-	if (v == XFS_EXT_NORM)
-		r->l0 &= XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN);
-	else
-		r->l0 |= XFS_MASK64HI(BMBT_EXNTFLAG_BITLEN);
+	cur->bc_rec.b.br_startoff = off;
+	cur->bc_rec.b.br_startblock = bno;
+	cur->bc_rec.b.br_blockcount = len;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
 }
 
 /*
- * Convert in-memory form of btree root to on-disk form.
+ * Lookup the first record greater than or equal to [off, bno, len]
+ * in the btree given by cur.
  */
-void
-xfs_bmbt_to_bmdr(
-	xfs_bmbt_block_t	*rblock,
-	int			rblocklen,
-	xfs_bmdr_block_t	*dblock,
-	int			dblocklen)
+int					/* error */
+xfs_bmbt_lookup_ge(
+	xfs_btree_cur_t	*cur,		/* btree cursor */
+	xfs_fileoff_t	off,
+	xfs_fsblock_t	bno,
+	xfs_filblks_t	len,
+	int		*stat)		/* success/failure */
 {
-	int			dmxr;
-	xfs_bmbt_key_t		*fkp;
-	__be64			*fpp;
-	xfs_bmbt_key_t		*tkp;
-	__be64			*tpp;
-
-	ASSERT(be32_to_cpu(rblock->bb_magic) == XFS_BMAP_MAGIC);
-	ASSERT(be64_to_cpu(rblock->bb_leftsib) == NULLDFSBNO);
-	ASSERT(be64_to_cpu(rblock->bb_rightsib) == NULLDFSBNO);
-	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
-	dblock->bb_level = rblock->bb_level;
-	dblock->bb_numrecs = rblock->bb_numrecs;
-	dmxr = (int)XFS_BTREE_BLOCK_MAXRECS(dblocklen, xfs_bmdr, 0);
-	fkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
-	tkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
-	fpp = XFS_BMAP_BROOT_PTR_ADDR(rblock, 1, rblocklen);
-	tpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
-	dmxr = be16_to_cpu(dblock->bb_numrecs);
-	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
-	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
+	cur->bc_rec.b.br_startoff = off;
+	cur->bc_rec.b.br_startblock = bno;
+	cur->bc_rec.b.br_blockcount = len;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
 }
 
 /*
- * Update the record to the passed values.
+ * Give the bmap btree a new root block.  Copy the old broot contents
+ * down into a real block and make the broot point to it.
  */
-int
-xfs_bmbt_update(
-	xfs_btree_cur_t		*cur,
-	xfs_fileoff_t		off,
-	xfs_fsblock_t		bno,
-	xfs_filblks_t		len,
-	xfs_exntst_t		state)
+int						/* error */
+xfs_bmbt_newroot(
+	xfs_btree_cur_t		*cur,		/* btree cursor */
+	int			*logflags,	/* logging flags for inode */
+	int			*stat)		/* return status - 0 fail */
 {
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
+	xfs_btree_block_t	*block;		/* bmap btree block */
+	xfs_buf_t		*bp;		/* buffer for block */
+	xfs_btree_block_t	*cblock;	/* child btree block */
+	xfs_btree_key_t		*ckp;		/* child key pointer */
+	xfs_btree_ptr_t		*cpp;		/* child ptr pointer */
+	int			error;		/* error return code */
 #ifdef DEBUG
-	if ((error = xfs_btree_check_lblock(cur, block, 0, bp))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
+	int			i;		/* loop counter */
 #endif
-	ptr = cur->bc_ptrs[0];
-	rp = XFS_BMAP_REC_IADDR(block, ptr, cur);
-	xfs_bmbt_disk_set_allf(rp, off, bno, len, state);
-	xfs_bmbt_log_recs(cur, bp, ptr, ptr);
-	if (ptr > 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
+	xfs_btree_key_t		*kp;		/* pointer to bmap btree key */
+	int			level;		/* btree level */
+	xfs_btree_ptr_t		*pp;		/* pointer to bmap block addr */
+	xfs_btree_ptr_t		nptr;		/* pointer to bmap block addr */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	level = cur->bc_nlevels - 1;
+	block = xfs_bmbt_get_block(cur, level, &bp);
+	pp = xfs_bmbt_ptr_addr(cur, 1, block);
+
+	/*
+	 * Allocate the new block.
+	 * If we can't do it, we're toast.  Give up.
+	 */
+	error = xfs_bmbt_alloc_block(cur, pp, &nptr, 1, stat);
+	if (error)
+		goto error0;
+	if (*stat == 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 		return 0;
 	}
-	key.br_startoff = cpu_to_be64(off);
-	if ((error = xfs_bmbt_updkey(cur, &key, 1))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
+	/*
+	 * Copy the root into a real block.
+	 */
+	error = xfs_bmbt_get_buf(cur, &nptr, 0, &bp);
+	if (error)
+		goto error0;
+	cblock = xfs_bmbt_buf_to_block(cur, bp);
+	*cblock = *block;
+	be16_add(&block->bb_h.bb_level, 1);
+	block->bb_h.bb_numrecs = cpu_to_be16(1);
+	cur->bc_nlevels++;
+	cur->bc_ptrs[level + 1] = 1;
+	kp = xfs_bmbt_key_addr(cur, 1, block);
+	ckp = xfs_bmbt_key_addr(cur, 1, cblock);
+	memcpy(ckp, kp, be16_to_cpu(cblock->bb_h.bb_numrecs) * sizeof(xfs_bmbt_key_t));
+	cpp = xfs_bmbt_ptr_addr(cur, 1, cblock);
+#ifdef DEBUG
+	for (i = 0; i < be16_to_cpu(cblock->bb_h.bb_numrecs); i++) {
+		error = xfs_btree_check_lptr_disk(cur, pp[i], level);
+		if (error)
+			goto error0;
 	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
+#endif
+	memcpy(cpp, pp, be16_to_cpu(cblock->bb_h.bb_numrecs) * sizeof(xfs_bmbt_ptr_t));
+#ifdef DEBUG
+	error = xfs_btree_check_lptr(cur, nptr.u.bmbt, level);
+	if (error)
+		goto error0;
+#endif
+	memcpy(pp, &nptr, sizeof(xfs_bmbt_ptr_t));
+	xfs_bmbt_realloc_root(cur, 1 - be16_to_cpu(cblock->bb_h.bb_numrecs));
+	xfs_btree_setbuf(cur, level, bp);
+	/*
+	 * Do all this logging at the end so that
+	 * the root is at the right level.
+	 */
+	xfs_bmbt_log_block(cur, bp, XFS_BB_ALL_BITS);
+	xfs_bmbt_log_keys(cur, bp, 1, be16_to_cpu(cblock->bb_h.bb_numrecs));
+	xfs_bmbt_log_ptrs(cur, bp, 1, be16_to_cpu(cblock->bb_h.bb_numrecs));
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*logflags |=
+		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork);
+	*stat = 1;
 	return 0;
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
 }
 
-/*
- * Check extent records, which have just been read, for
- * any bit in the extent flag field. ASSERT on debug
- * kernels, as this condition should not occur.
- * Return an error condition (1) if any flags found,
- * otherwise return 0.
- */
-
-int
-xfs_check_nostate_extents(
-	xfs_ifork_t		*ifp,
-	xfs_extnum_t		idx,
-	xfs_extnum_t		num)
-{
-	for (; num > 0; num--, idx++) {
-		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, idx);
-		if ((ep->l0 >>
-		     (64 - BMBT_EXNTFLAG_BITLEN)) != 0) {
-			ASSERT(0);
-			return 1;
-		}
-	}
-	return 0;
-}
Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap_btree.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap_btree.h	2007-08-02 22:13:10.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap_btree.h	2007-11-06 19:40:29.718673016 +1100
@@ -254,11 +254,7 @@ extern ktrace_t	*xfs_bmbt_trace_buf;
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
@@ -268,8 +264,6 @@ extern void xfs_bmbt_disk_get_all(xfs_bm
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
 
-extern int xfs_bmbt_increment(struct xfs_btree_cur *, int, int *);
-extern int xfs_bmbt_insert(struct xfs_btree_cur *, int *);
 extern void xfs_bmbt_log_block(struct xfs_btree_cur *, struct xfs_buf *, int);
 extern void xfs_bmbt_log_recs(struct xfs_btree_cur *, struct xfs_buf *, int,
 				int);
@@ -299,6 +293,8 @@ extern void xfs_bmbt_disk_set_allf(xfs_b
 extern void xfs_bmbt_to_bmdr(xfs_bmbt_block_t *, int, xfs_bmdr_block_t *, int);
 extern int xfs_bmbt_update(struct xfs_btree_cur *, xfs_fileoff_t,
 				xfs_fsblock_t, xfs_filblks_t, xfs_exntst_t);
+extern void xfs_bmbt_init_cursor(struct xfs_btree_cur *cur);
+
 
 #endif	/* __KERNEL__ */
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_btree.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_btree.c	2007-08-24 22:24:45.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_btree.c	2007-11-06 19:40:29.750668896 +1100
@@ -52,19 +52,7 @@ const __uint32_t xfs_magics[XFS_BTNUM_MA
 };
 
 /*
- * Prototypes for internal routines.
- */
-
-/*
- * Checking routine: return maxrecs for the block.
- */
-STATIC int				/* number of records fitting in block */
-xfs_btree_maxrecs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_block_t	*block);/* generic btree block pointer */
-
-/*
- * Internal routines.
+ * Internal prototypes
  */
 
 /*
@@ -75,7 +63,7 @@ STATIC xfs_btree_block_t *			/* generic 
 xfs_btree_get_block(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			level,	/* level in btree */
-	struct xfs_buf		**bpp);	/* buffer containing the block */
+	xfs_buf_t		**bpp);	/* buffer containing the block */
 
 /*
  * Checking routine: return maxrecs for the block.
@@ -177,65 +165,7 @@ xfs_btree_check_key(
 		ASSERT(0);
 	}
 }
-#endif	/* DEBUG */
-
-/*
- * Checking routine: check that long form block header is ok.
- */
-/* ARGSUSED */
-int					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_lblock(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_lblock_t	*block,	/* btree long form block pointer */
-	int			level,	/* level of the btree block */
-	xfs_buf_t		*bp)	/* buffer for block, if any */
-{
-	int			lblock_ok; /* block passes checks */
-	xfs_mount_t		*mp;	/* file system mount point */
-
-	mp = cur->bc_mp;
-	lblock_ok =
-		be32_to_cpu(block->bb_magic) == xfs_magics[cur->bc_btnum] &&
-		be16_to_cpu(block->bb_level) == level &&
-		be16_to_cpu(block->bb_numrecs) <=
-			xfs_btree_maxrecs(cur, (xfs_btree_block_t *)block) &&
-		block->bb_leftsib &&
-		(be64_to_cpu(block->bb_leftsib) == NULLDFSBNO ||
-		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_leftsib))) &&
-		block->bb_rightsib &&
-		(be64_to_cpu(block->bb_rightsib) == NULLDFSBNO ||
-		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_rightsib)));
-	if (unlikely(XFS_TEST_ERROR(!lblock_ok, mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK,
-			XFS_RANDOM_BTREE_CHECK_LBLOCK))) {
-		if (bp)
-			xfs_buftrace("LBTREE ERROR", bp);
-		XFS_ERROR_REPORT("xfs_btree_check_lblock", XFS_ERRLEVEL_LOW,
-				 mp);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
-	return 0;
-}
-
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
 
-#ifdef DEBUG
 /*
  * Debug routine: check that records are in the right order.
  */
@@ -296,13 +226,73 @@ xfs_btree_check_rec(
 #endif	/* DEBUG */
 
 /*
+ * Checking routine: check that long form block header is ok.
+ */
+/* ARGSUSED */
+int					/* error (0 or EFSCORRUPTED) */
+xfs_btree_check_lblock(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_btree_block_t	*block,	/* btree long form block pointer */
+	int			level,	/* level of the btree block */
+	xfs_buf_t		*bp)	/* buffer for block, if any */
+{
+	int			lblock_ok; /* block passes checks */
+	xfs_mount_t		*mp;	/* file system mount point */
+	xfs_btree_lblock_t	*lb;	/* btree long form block pointer */
+
+	mp = cur->bc_mp;
+	lb = (xfs_btree_lblock_t *)block;
+	lblock_ok =
+		be32_to_cpu(lb->bb_magic) == xfs_magics[cur->bc_btnum] &&
+		be16_to_cpu(lb->bb_level) == level &&
+		be16_to_cpu(lb->bb_numrecs) <= xfs_btree_maxrecs(cur, block) &&
+		lb->bb_leftsib &&
+		(be64_to_cpu(lb->bb_leftsib) == NULLDFSBNO ||
+		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(lb->bb_leftsib))) &&
+		lb->bb_rightsib &&
+		(be64_to_cpu(lb->bb_rightsib) == NULLDFSBNO ||
+		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(lb->bb_rightsib)));
+	if (unlikely(XFS_TEST_ERROR(!lblock_ok, mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK,
+			XFS_RANDOM_BTREE_CHECK_LBLOCK))) {
+		if (bp)
+			xfs_buftrace("LBTREE ERROR", bp);
+		XFS_ERROR_REPORT("xfs_btree_check_lblock", XFS_ERRLEVEL_LOW,
+				 mp);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+	return 0;
+}
+
+/*
+ * Checking routine: check that (long) pointer is ok.
+ */
+int					/* error (0 or EFSCORRUPTED) */
+xfs_btree_check_lptr(
+	xfs_btree_cur_t	*cur,		/* btree cursor */
+	xfs_btree_ptr_t	*ptr,		/* btree block disk address */
+	int		index,		/* offset from ptr */
+	int		level)		/* btree block level */
+{
+	xfs_mount_t	*mp;		/* file system mount point */
+	xfs_fsblock_t	bno;
+
+	mp = cur->bc_mp;
+	bno = be64_to_cpu((&ptr->u.l)[index]);
+	XFS_WANT_CORRUPTED_RETURN(level > 0 &&
+				bno != NULLDFSBNO &&
+				XFS_FSB_SANITY_CHECK(mp, bno));
+	return 0;
+}
+
+
+/*
  * Checking routine: check that block header is ok.
  */
 /* ARGSUSED */
 int					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_sblock(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_sblock_t	*block,	/* btree short form block pointer */
+	xfs_btree_block_t	*block,	/* btree short form block pointer */
 	int			level,	/* level of the btree block */
 	xfs_buf_t		*bp)	/* buffer containing block */
 {
@@ -310,21 +300,22 @@ xfs_btree_check_sblock(
 	xfs_agf_t		*agf;	/* ag. freespace structure */
 	xfs_agblock_t		agflen;	/* native ag. freespace length */
 	int			sblock_ok; /* block passes checks */
+	xfs_btree_sblock_t	*sb;	/* btree short form block pointer */
 
 	agbp = cur->bc_private.a.agbp;
 	agf = XFS_BUF_TO_AGF(agbp);
 	agflen = be32_to_cpu(agf->agf_length);
+	sb = (xfs_btree_sblock_t *)block;
 	sblock_ok =
-		be32_to_cpu(block->bb_magic) == xfs_magics[cur->bc_btnum] &&
-		be16_to_cpu(block->bb_level) == level &&
-		be16_to_cpu(block->bb_numrecs) <=
-			xfs_btree_maxrecs(cur, (xfs_btree_block_t *)block) &&
-		(be32_to_cpu(block->bb_leftsib) == NULLAGBLOCK ||
-		 be32_to_cpu(block->bb_leftsib) < agflen) &&
-		block->bb_leftsib &&
-		(be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK ||
-		 be32_to_cpu(block->bb_rightsib) < agflen) &&
-		block->bb_rightsib;
+		be32_to_cpu(sb->bb_magic) == xfs_magics[cur->bc_btnum] &&
+		be16_to_cpu(sb->bb_level) == level &&
+		be16_to_cpu(sb->bb_numrecs) <= xfs_btree_maxrecs(cur, block) &&
+		(be32_to_cpu(sb->bb_leftsib) == NULLAGBLOCK ||
+		 be32_to_cpu(sb->bb_leftsib) < agflen) &&
+		sb->bb_leftsib &&
+		(be32_to_cpu(sb->bb_rightsib) == NULLAGBLOCK ||
+		 be32_to_cpu(sb->bb_rightsib) < agflen) &&
+		sb->bb_rightsib;
 	if (unlikely(XFS_TEST_ERROR(!sblock_ok, cur->bc_mp,
 			XFS_ERRTAG_BTREE_CHECK_SBLOCK,
 			XFS_RANDOM_BTREE_CHECK_SBLOCK))) {
@@ -343,22 +334,105 @@ xfs_btree_check_sblock(
 int					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_sptr(
 	xfs_btree_cur_t	*cur,		/* btree cursor */
-	xfs_agblock_t	ptr,		/* btree block disk address */
+	xfs_btree_ptr_t	*ptr,		/* btree block disk address */
+	int		index,		/* offset from ptr to check */
 	int		level)		/* btree block level */
 {
 	xfs_buf_t	*agbp;		/* buffer for ag. freespace struct */
 	xfs_agf_t	*agf;		/* ag. freespace structure */
+	xfs_agblock_t	bno;
 
 	agbp = cur->bc_private.a.agbp;
 	agf = XFS_BUF_TO_AGF(agbp);
-	XFS_WANT_CORRUPTED_RETURN(
-		level > 0 &&
-		ptr != NULLAGBLOCK && ptr != 0 &&
-		ptr < be32_to_cpu(agf->agf_length));
+	bno = be32_to_cpu((&ptr->u.s)[index]);
+	XFS_WANT_CORRUPTED_RETURN(level > 0 && bno != NULLAGBLOCK &&
+			bno != 0 && bno < be32_to_cpu(agf->agf_length));
 	return 0;
 }
 
 /*
+ * Get/set/init sibling pointers
+ */
+void
+xfs_btree_get_lsibling(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block,
+	xfs_btree_ptr_t		*ptr,
+	int			lr)
+{
+	if (lr == XFS_BB_RIGHTSIB) {
+		ptr->u.l = block->bb_u.l.bb_rightsib;
+	} else {
+		ASSERT(lr == XFS_BB_LEFTSIB);
+		ptr->u.l = block->bb_u.l.bb_leftsib;
+	}
+
+}
+
+void
+xfs_btree_set_lsibling(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block,
+	xfs_btree_ptr_t		*ptr,
+	int			lr)
+{
+	if (lr == XFS_BB_RIGHTSIB) {
+		block->bb_u.l.bb_rightsib = ptr->u.l;
+	} else {
+		ASSERT(sibling == XFS_BB_LEFTSIB);
+		block->bb_u.l.bb_leftsib = ptr->u.l;
+	}
+
+}
+
+void
+xfs_btree_get_ssibling(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block,
+	xfs_btree_ptr_t		*ptr,
+	int			lr)
+{
+	if (lr == XFS_BB_RIGHTSIB) {
+		ptr->u.s = block->bb_u.s.bb_rightsib;
+	} else {
+		ASSERT(lr == XFS_BB_LEFTSIB);
+		ptr->u.s = block->bb_u.s.bb_leftsib;
+	}
+
+}
+
+void
+xfs_btree_set_ssibling(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block,
+	xfs_btree_ptr_t		*ptr,
+	int			lr)
+{
+	if (lr == XFS_BB_RIGHTSIB) {
+		block->bb_u.s.bb_rightsib = ptr->u.s;
+	} else {
+		ASSERT(sibling == XFS_BB_LEFTSIB);
+		block->bb_u.s.bb_leftsib = ptr->u.s;
+	}
+
+}
+
+/* set up block header and records for new block in split */
+void
+xfs_btree_init_sibling(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*new,
+	xfs_btree_block_t	*sib)	/* sibling block next to new block */
+{
+	/*
+	 * Fill in the btree header for the new block.
+	 */
+	new->bb_h.bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
+	new->bb_h.bb_level = sib->bb_h.bb_level;
+	new->bb_h.bb_numrecs = 0;
+}
+
+/*
  * Delete the btree cursor.
  */
 void
@@ -625,6 +699,7 @@ xfs_btree_init_cursor(
 		 */
 		cur->bc_private.a.agbp = agbp;
 		cur->bc_private.a.agno = agno;
+		xfs_alloc_init_cursor(cur);
 		break;
 	case XFS_BTNUM_BMAP:
 		/*
@@ -637,6 +712,7 @@ xfs_btree_init_cursor(
 		cur->bc_private.b.allocated = 0;
 		cur->bc_private.b.flags = 0;
 		cur->bc_private.b.whichfork = whichfork;
+		xfs_bmbt_init_cursor(cur);
 		break;
 	case XFS_BTNUM_INO:
 		/*
@@ -644,6 +720,7 @@ xfs_btree_init_cursor(
 		 */
 		cur->bc_private.i.agbp = agbp;
 		cur->bc_private.i.agno = agno;
+		xfs_inobt_init_cursor(cur);
 		break;
 	default:
 		ASSERT(0);
@@ -848,60 +925,70 @@ xfs_btree_reada_bufs(
  * Read-ahead btree blocks, at the given level.
  * Bits in lr are set from XFS_BTCUR_{LEFT,RIGHT}RA.
  */
+STATIC int
+xfs_btree_reada_cores(
+	xfs_btree_cur_t		*cur,		/* btree cursor */
+	int			lr,
+	xfs_agblock_t		left,
+	xfs_agblock_t		right)
+{
+	int			rval = 0;
+
+	if ((lr & XFS_BTCUR_LEFTRA) && (left != NULLAGBLOCK)) {
+		xfs_btree_reada_bufs(cur->bc_mp,
+					cur->bc_private.a.agno, left, 1);
+		rval++;
+	}
+	if ((lr & XFS_BTCUR_RIGHTRA) && (right != NULLAGBLOCK)) {
+		xfs_btree_reada_bufs(cur->bc_mp,
+					cur->bc_private.a.agno, right, 1);
+		rval++;
+	}
+	return rval;
+}
+
+STATIC int
+xfs_btree_reada_corel(
+	xfs_btree_cur_t		*cur,		/* btree cursor */
+	int			lr,
+	xfs_fsblock_t		left,
+	xfs_fsblock_t		right)
+{
+	int			rval = 0;
+
+	if ((lr & XFS_BTCUR_LEFTRA) && (left != NULLDFSBNO)) {
+		xfs_btree_reada_bufl(cur->bc_mp, left, 1);
+		rval++;
+	}
+	if ((lr & XFS_BTCUR_RIGHTRA) && (right != NULLDFSBNO)) {
+		xfs_btree_reada_bufl(cur->bc_mp, right, 1);
+		rval++;
+	}
+	return rval;
+}
+
 int
 xfs_btree_readahead_core(
 	xfs_btree_cur_t		*cur,		/* btree cursor */
 	int			lev,		/* level in btree */
 	int			lr)		/* left/right bits */
 {
-	xfs_alloc_block_t	*a;
-	xfs_bmbt_block_t	*b;
-	xfs_inobt_block_t	*i;
 	int			rval = 0;
 
 	ASSERT(cur->bc_bufs[lev] != NULL);
 	cur->bc_ra[lev] |= lr;
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
-			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.i.agno,
-				be32_to_cpu(i->bb_leftsib), 1);
-			rval++;
-		}
-		if ((lr & XFS_BTCUR_RIGHTRA) && be32_to_cpu(i->bb_rightsib) != NULLAGBLOCK) {
-			xfs_btree_reada_bufs(cur->bc_mp, cur->bc_private.i.agno,
-				be32_to_cpu(i->bb_rightsib), 1);
-			rval++;
-		}
-		break;
-	default:
-		ASSERT(0);
+	if (XFS_BTREE_LONG_PTRS(cur->bc_btnum)) {
+		xfs_btree_lblock_t	*b;
+		b = XFS_BUF_TO_LBLOCK(cur->bc_bufs[lev]);
+		rval = xfs_btree_reada_corel(cur, lr,
+					be64_to_cpu(b->bb_leftsib),
+					be64_to_cpu(b->bb_rightsib));
+	} else {
+		xfs_btree_sblock_t	*b;
+		b = XFS_BUF_TO_SBLOCK(cur->bc_bufs[lev]);
+		rval = xfs_btree_reada_cores(cur, lr,
+					be32_to_cpu(b->bb_leftsib),
+					be32_to_cpu(b->bb_rightsib));
 	}
 	return rval;
 }
Index: 2.6.x-xfs-new/fs/xfs/xfs_btree.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_btree.h	2007-11-02 13:44:45.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_btree.h	2007-11-06 19:40:29.750668896 +1100
@@ -85,6 +85,43 @@ typedef struct xfs_btree_block {
 } xfs_btree_block_t;
 
 /*
+ * Generic block, key, ptr and record wrapper structures
+ * These are disk format structures, and are converted where
+ * necessary be the btree specific code that needs to interpret
+ * them.
+ */
+typedef struct xfs_btree_key {
+	union {
+		xfs_bmbt_key_t		bmbt;
+		xfs_bmdr_key_t		bmbr;	/* bmbt root block */
+		xfs_alloc_key_t		alloc;
+		xfs_inobt_key_t		inobt;
+		__be32			s;	/* short form key */
+		__be64			l;	/* long form key */
+	} u;
+} xfs_btree_key_t;
+
+typedef struct xfs_btree_ptr {
+	union {
+		xfs_bmbt_ptr_t		bmbt;
+		xfs_bmdr_ptr_t		bmbr;	/* bmbt root block */
+		xfs_alloc_ptr_t		alloc;
+		xfs_inobt_ptr_t		inobt;
+		__be32			s;	/* short form ptr */
+		__be64			l;	/* long form ptr */
+	} u;
+} xfs_btree_ptr_t;
+
+typedef struct xfs_btree_rec {
+	union {
+		xfs_bmbt_rec_t		bmbt;
+		xfs_bmdr_rec_t		bmbr;	/* bmbt root block */
+		xfs_alloc_rec_t		alloc;
+		xfs_inobt_rec_t		inobt;
+	} u;
+} xfs_btree_rec_t;
+
+/*
  * For logging record fields.
  */
 #define	XFS_BB_MAGIC		0x01
@@ -136,6 +173,183 @@ extern const __uint32_t	xfs_magics[];
 
 #define	XFS_BTREE_MAXLEVELS	8	/* max of all btrees */
 
+typedef const struct xfs_btree_cur_ops {
+	int	(*new_root)(struct xfs_btree_cur *cur, int *stat);
+	int	(*realloc_root)(struct xfs_btree_cur *cur, int index);
+	int	(*kill_root)(struct xfs_btree_cur *cur, int level,
+				xfs_btree_ptr_t *nptr);
+	void	(*set_root)(struct xfs_btree_cur *cur,
+				xfs_btree_ptr_t *nptr, int level_change);
+	int	(*update_lastrec)(struct xfs_btree_cur *cur,
+				xfs_btree_block_t *block);
+	void	(*update_cursor)(struct xfs_btree_cur *src,
+				struct xfs_btree_cur *dst);
+} xfs_btree_curops_t;
+
+typedef const struct xfs_btree_block_ops {
+	int	(*get_buf)(struct xfs_btree_cur *cur, xfs_btree_ptr_t *ptr,
+				int flags, struct xfs_buf **bpp);
+	int	(*read_buf)(struct xfs_btree_cur *cur, xfs_btree_ptr_t *ptr,
+				int flags, struct xfs_buf **bpp);
+	int	(*check_block)(struct xfs_btree_cur *cur,
+				xfs_btree_block_t *block,
+				int level, struct xfs_buf *bp);
+	xfs_btree_block_t *
+		(*get_block)(struct xfs_btree_cur *cur, int lvl,
+				struct xfs_buf **bpp);
+	xfs_btree_block_t *
+		(*buf_to_block)(struct xfs_btree_cur *cur, struct xfs_buf *bp);
+	void	(*buf_to_ptr)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
+				xfs_btree_ptr_t *ptr);
+	void	(*log_block)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
+				int fields);
+
+	int	(*alloc_block)(struct xfs_btree_cur *cur, xfs_btree_ptr_t *sbno,
+				xfs_btree_ptr_t *nbno, int length, int *stat);
+	int	(*free_block)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
+				int length);
+
+	void	(*get_sibling)(struct xfs_btree_cur *cur,
+				xfs_btree_block_t *block,
+				xfs_btree_ptr_t *ptr, int lr);
+	void	(*set_sibling)(struct xfs_btree_cur *cur,
+				xfs_btree_block_t *block,
+				xfs_btree_ptr_t *ptr, int lr);
+	void	(*init_sibling)(struct xfs_btree_cur *cur,
+				xfs_btree_block_t *nsib, xfs_btree_block_t *sib);
+} xfs_btree_blkops_t;
+
+typedef const struct xfs_btree_record_ops {
+	/* records in block/level */
+	int	(*get_minrecs)(struct xfs_btree_cur *cur, int level);
+	int	(*get_maxrecs)(struct xfs_btree_cur *cur, int level);
+	int	(*get_dminrecs)(struct xfs_btree_cur *cur, int level);
+	int	(*get_dmaxrecs)(struct xfs_btree_cur *cur, int level);
+	int	(*get_numrecs)(struct xfs_btree_cur *cur,
+				xfs_btree_block_t *block);
+	void	(*set_numrecs)(struct xfs_btree_cur *cur,
+				xfs_btree_block_t *block,
+				int numrecs);
+
+	/* init values of btree structures */
+	void	(*init_key_from_rec)(struct xfs_btree_cur *cur,
+				xfs_btree_key_t *key, xfs_btree_rec_t *rec);
+	void	(*init_ptr_from_cur)(struct xfs_btree_cur *cur,
+				xfs_btree_ptr_t *ptr);
+	void	(*init_rec_from_key)(struct xfs_btree_cur *cur,
+				xfs_btree_key_t *key, xfs_btree_rec_t *rec);
+	void	(*init_rec_from_cur)(struct xfs_btree_cur *cur,
+				xfs_btree_rec_t *rec);
+
+	/* return address of btree structures */
+	xfs_btree_key_t *
+		(*key_addr)(struct xfs_btree_cur *cur, int index,
+				xfs_btree_block_t *block);
+	xfs_btree_ptr_t *
+		(*ptr_addr)(struct xfs_btree_cur *cur, int index,
+				xfs_btree_block_t *block);
+	xfs_btree_rec_t *
+		(*rec_addr)(struct xfs_btree_cur *cur, int index,
+				xfs_btree_block_t *block);
+
+	/* difference between key value and cursor value */
+	int64_t	(*key_diff)(struct xfs_btree_cur *cur, xfs_btree_key_t *key);
+
+	xfs_daddr_t
+		(*ptr_to_daddr)(struct xfs_btree_cur *cur,
+				xfs_btree_ptr_t *ptr);
+
+	/* set values of btree structures */
+	void	(*set_key)(struct xfs_btree_cur *cur,
+				xfs_btree_key_t *key_addr, int index,
+				xfs_btree_key_t *newkey);
+	void	(*set_ptr)(struct xfs_btree_cur *cur,
+				xfs_btree_ptr_t *ptr_addr, int index,
+				xfs_btree_ptr_t *newptr);
+	void	(*set_rec)(struct xfs_btree_cur *cur,
+				xfs_btree_rec_t *rec_addr, int index,
+				xfs_btree_rec_t *newrec);
+
+	/* move bits of btree blocks around */
+	void	(*move_keys)(struct xfs_btree_cur *cur,
+				xfs_btree_key_t *src_key,
+				xfs_btree_key_t *dst_key, int src_index,
+				int dst_index, int numkeys);
+	void	(*move_ptrs)(struct xfs_btree_cur *cur,
+				xfs_btree_ptr_t *src_ptr,
+				xfs_btree_ptr_t *dst_ptr, int src_index,
+				int dst_index, int numptrs);
+	void	(*move_recs)(struct xfs_btree_cur *cur,
+				xfs_btree_rec_t *src_rec,
+				xfs_btree_rec_t *dst_rec, int src_index,
+				int dst_index, int numrecs);
+
+	/* log changes to btree structures */
+	void	(*log_keys)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
+				int first, int last);
+	void	(*log_ptrs)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
+				int first, int last);
+	void	(*log_recs)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
+				int first, int last);
+
+	/* paranoia */
+	int	(*check_ptrs)(struct xfs_btree_cur *cur,
+				xfs_btree_ptr_t *ptr, int index, int level);
+} xfs_btree_recops_t;
+
+#ifdef XFS_BTREE_TRACE
+typedef const struct xfs_btree_trc_ops {
+	void	(*enter)(const char *func, xfs_btree_cur_t *cur,
+				char *s, int type, int line,
+				__psunsigned_t a0, __psunsigned_t a1,
+				__psunsigned_t a2, __psunsigned_t a3,
+				__psunsigned_t a4, __psunsigned_t a5,
+				__psunsigned_t a6, __psunsigned_t a7,
+				__psunsigned_t a8, __psunsigned_t a9,
+				__psunsigned_t a10);
+	void	(*cursor)(xfs_btree_cur_t *cur, __uint32_t *s0,
+				__uint64_t *l0, __uint64_t *l1);
+	void	(*record)(xfs_btree_cur_t *cur, xfs_btree_rec_t *rec,
+				__uint64_t *l0, __uint64_t *l1,
+				__uint64_t *l2);
+} xfs_btree_trcops_t;
+
+#define XBT_ENTRY	1
+#define XBT_EXIT	2
+#define XBT_ERROR	3
+#define XBT_ARGS	4
+
+/*
+ * Trace hooks.
+ * i,j = integer (32 bit)
+ * b = btree block buffer (xfs_buf_t)
+ * p = btree ptr
+ * r = btree record
+ * k = btree key
+ */
+#define	XFS_BTREE_TRACE_ARGI(c,i)	\
+	xfs_btree_trace_argi(__FUNCTION__, c, i, __LINE__)
+#define	XFS_BTREE_TRACE_ARGBI(c,b,i)	\
+	xfs_btree_trace_argbi(__FUNCTION__, c, b, i, __LINE__)
+#define	XFS_BTREE_TRACE_ARGBII(c,b,i,j)	\
+	xfs_btree_trace_argbii(__FUNCTION__, c, b, i, j, __LINE__)
+#define	XFS_BTREE_TRACE_ARGIPK(c,i,p,s)	\
+	xfs_btree_trace_argifk(__FUNCTION__, c, i, p, s, __LINE__)
+#define	XFS_BTREE_TRACE_ARGIPR(c,i,p,r)	\
+	xfs_btree_trace_argifr(__FUNCTION__, c, i, p, r, __LINE__)
+#define	XFS_BTREE_TRACE_ARGIK(c,i,k)	\
+	xfs_btree_trace_argik(__FUNCTION__, c, i, k, __LINE__)
+#define	XFS_BTREE_TRACE_CURSOR(c,s)	\
+	xfs_btree_trace_cursor(__FUNCTION__, c, s, __LINE__)
+#else
+#define	XFS_BTREE_TRACE_ARGBI(c,b,i)
+#define	XFS_BTREE_TRACE_ARGBII(c,b,i,j)
+#define	XFS_BTREE_TRACE_ARGI(c,i)
+#define	XFS_BTREE_TRACE_ARGIPK(c,i,p,s)
+#define	XFS_BTREE_TRACE_ARGIPR(c,i,p,r)
+#define	XFS_BTREE_TRACE_ARGIK(c,i,k)
+#define	XFS_BTREE_TRACE_CURSOR(c,s)
+#endif	/* XFS_BTREE_TRACE */
 /*
  * Btree cursor structure.
  * This collects all information needed by the btree code in one place.
@@ -144,6 +358,13 @@ typedef struct xfs_btree_cur
 {
 	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
 	struct xfs_mount	*bc_mp;	/* file system mount struct */
+	xfs_btree_curops_t	*bc_curops;
+	xfs_btree_blkops_t	*bc_blkops;
+	xfs_btree_recops_t	*bc_recops;
+#ifdef XFS_BTREE_TRACE
+	xfs_btree_trcops_t	*bc_trcops;
+#endif
+	uint			bc_flags;	/* btree features - below */
 	union {
 		xfs_alloc_rec_incore_t	a;
 		xfs_bmbt_irec_t		b;
@@ -179,6 +400,10 @@ typedef struct xfs_btree_cur
 	}		bc_private;	/* per-btree type data */
 } xfs_btree_cur_t;
 
+/* cursor flags */
+#define XFS_BTREE_ROOT_IN_INODE		(1<<0)	/* root may be variable size */
+#define XFS_BTREE_LASTREC_UPDATE	(1<<1)	/* track last rec externally */
+
 #define	XFS_BTREE_NOERROR	0
 #define	XFS_BTREE_ERROR		1
 
@@ -192,6 +417,17 @@ typedef struct xfs_btree_cur
 
 #ifdef __KERNEL__
 
+#define	XFS_BTREE_TRACE_ARGBI(c,b,i)
+#define	XFS_BTREE_TRACE_ARGBII(c,b,i,j)
+#define	XFS_BTREE_TRACE_ARGFFF(c,o,b,i)
+#define	XFS_BTREE_TRACE_ARGFFFI(c,o,b,i,j)
+#define	XFS_BTREE_TRACE_ARGI(c,i)
+#define	XFS_BTREE_TRACE_ARGII(c,i,j)
+#define	XFS_BTREE_TRACE_ARGIFK(c,i,f,s)
+#define	XFS_BTREE_TRACE_ARGIFR(c,i,f,r)
+#define	XFS_BTREE_TRACE_ARGIK(c,i,k)
+#define	XFS_BTREE_TRACE_CURSOR(c,s)
+
 #ifdef DEBUG
 /*
  * Debug routine: check that block header is ok.
@@ -232,7 +468,7 @@ xfs_btree_check_rec(
 int					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_lblock(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_lblock_t	*block,	/* btree long form block pointer */
+	xfs_btree_block_t	*block,	/* btree long form block pointer */
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp);	/* buffer containing block, if any */
 
@@ -242,19 +478,17 @@ xfs_btree_check_lblock(
 int					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_lptr(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_dfsbno_t		ptr,	/* btree block disk address */
+	xfs_btree_ptr_t		*ptr,	/* btree block ptr */
+	int			offset,	/* offset from ptr to check */
 	int			level);	/* btree block level */
 
-#define xfs_btree_check_lptr_disk(cur, ptr, level) \
-	xfs_btree_check_lptr(cur, be64_to_cpu(ptr), level)
-
 /*
  * Checking routine: check that short form block header is ok.
  */
 int					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_sblock(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_sblock_t	*block,	/* btree short form block pointer */
+	xfs_btree_block_t	*block,	/* btree short form block pointer */
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp);	/* buffer containing block */
 
@@ -264,7 +498,8 @@ xfs_btree_check_sblock(
 int					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_sptr(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agblock_t		ptr,	/* btree block disk address */
+	xfs_btree_ptr_t		*ptr,	/* btree block ptr */
+	int			offset,	/* offset from ptr to check */
 	int			level);	/* btree block level */
 
 /*
@@ -423,12 +658,52 @@ xfs_btree_readahead(
 	int			lev,	/* level in btree */
 	int			lr)	/* left/right bits */
 {
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (lev == cur->bc_nlevels - 1))
+		return 0;
+
 	if ((cur->bc_ra[lev] | lr) == cur->bc_ra[lev])
 		return 0;
 
 	return xfs_btree_readahead_core(cur, lev, lr);
 }
 
+/*
+ * Block sibling operations.
+ */
+void
+xfs_btree_get_lsibling(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block,
+	xfs_btree_ptr_t		*ptr,
+	int			lr);
+
+void
+xfs_btree_set_lsibling(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block,
+	xfs_btree_ptr_t		*ptr,
+	int			lr);
+
+void
+xfs_btree_get_ssibling(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block,
+	xfs_btree_ptr_t		*ptr,
+	int			lr);
+
+void
+xfs_btree_set_ssibling(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block,
+	xfs_btree_ptr_t		*ptr,
+	int			lr);
+
+void
+xfs_btree_init_sibling(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*nsib,
+	xfs_btree_block_t	*sib);	/* sibling block next to new block */
 
 /*
  * Set the buffer for level "lev" in the cursor to bp, releasing
@@ -440,6 +715,136 @@ xfs_btree_setbuf(
 	int			lev,	/* level in btree */
 	struct xfs_buf		*bp);	/* new buffer to set */
 
+/*
+ * Core btree functions
+ */
+
+/*
+ * Insert one record/level.  Return information to the caller
+ * allowing the next level up to proceed if necessary.
+ */
+int xfs_btree_insrec(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	xfs_btree_ptr_t		*ptrp,
+	xfs_btree_rec_t		*recp,
+	xfs_btree_cur_t		**curp,
+	int			*stat);		/* no-go/done/continue */
+
+/*
+ * Delete record pointed to by cur/level.
+ */
+int xfs_btree_delrec(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	int			*stat);		/* success/failure */
+
+/*
+ * Move 1 record right from cur/level if possible.
+ * Update cur to reflect the new path.
+ */
+int xfs_btree_rshift(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	int			*stat);		/* success/failure */
+
+/*
+ * Move 1 record left from cur/level if possible.
+ * Update cur to reflect the new path.
+ */
+int xfs_btree_lshift(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	int			*stat);		/* success/failure */
+
+/*
+ * Split cur/level block in half.
+ * Return new block number and the key to its
+ * first record (to be inserted into parent).
+ */
+int					/* error */
+xfs_btree_split(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	xfs_btree_ptr_t		*ptrp,
+	xfs_btree_key_t		*key,
+	xfs_btree_cur_t		**curp,
+	int			*stat);		/* success/failure */
+
+/*
+ * Update keys for the record.
+ */
+int
+xfs_btree_updkey(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_key_t		*keyp,	/* on-disk format */
+	int			level);
+
+/*
+ * Decrement cursor by one record at the level.
+ * For nonzero levels the leaf-ward information is untouched.
+ */
+int						/* error */
+xfs_btree_decrement(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	int			*stat);		/* success/failure */
+
+/*
+ * Increment cursor by one record at the level.
+ * For nonzero levels the leaf-ward information is untouched.
+ */
+int					/* error */
+xfs_btree_increment(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	int			*stat);	/* success/failure */
+
+/*
+ * Insert the record in cur at the point referenced by cur.
+ * The cursor may be inconsistent on return if splits have been done.
+ */
+int
+xfs_btree_insert(
+	xfs_btree_cur_t		*cur,
+	int			*stat);
+
+/*
+ * Delete the record pointed to by cur.
+ */
+int					/* error */
+xfs_btree_delete(
+	xfs_btree_cur_t		*cur,
+	int			*stat);	/* success/failure */
+
+/*
+ * Lookup the record.  The cursor is made to point to it, based on dir.
+ * Return 0 if can't find any such record, 1 for success.
+ */
+int				/* error */
+xfs_btree_lookup(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_lookup_t		dir,	/* <=, ==, or >= */
+	int			*stat);	/* success/failure */
+
+/*
+ * Allocate a new root block, fill it in.
+ */
+int				/* error */
+xfs_btree_newroot(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	int			*stat);	/* success/failure */
+
+/*
+ * Update the record referred to by cur to the value in the
+ * given record. This either works (return 0) or gets an
+ * EFSCORRUPTED error.
+ */
+int
+xfs_btree_update(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_rec_t	*rec);
+
 #endif	/* __KERNEL__ */
 
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_btree_core.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.x-xfs-new/fs/xfs/xfs_btree_core.c	2007-11-06 19:40:29.758667866 +1100
@@ -0,0 +1,2299 @@
+/*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * Derived from existing XFS btree code by Dave Chinner.
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
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_dmapi.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_dir2_sf.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_error.h"
+
+/*
+ * ToDo:
+ *
+ *	- trace infrastructure
+ *	- fix 32bit-ness in xfs_btree_newroot
+ *	- per-btree stats
+ *	- fix check_sblock/sptr as they are alloc btree specific
+ */
+
+/*
+ * Keys, ptrs and records are supposed to be passed around in host
+ * format in this code. type specific callouts need to do endian
+ * swapping as necessary.
+ */
+
+/*
+ * Btree keys, ptrs and records are passed around in disk format
+ * and converted where needed by end functions. The values held in
+ * the cursor for anything is in host order.
+ */
+
+/*
+ * Internal functions.
+ */
+STATIC int
+xfs_btree_ptr_null(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr)
+{
+	switch(cur->bc_btnum) {
+	case XFS_BTNUM_BNO:
+	case XFS_BTNUM_CNT:
+		return be32_to_cpu(ptr->u.alloc) == NULLAGBLOCK;
+		break;
+	case XFS_BTNUM_INO:
+		return be32_to_cpu(ptr->u.inobt) == NULLAGBLOCK;
+	case XFS_BTNUM_BMAP:
+		return be64_to_cpu(ptr->u.bmbt) == NULLFSBLOCK;
+	default:
+		ASSERT(0);
+		break;
+	}
+	return 0;
+}
+
+STATIC void
+xfs_btree_set_ptr_null(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr)
+{
+	switch(cur->bc_btnum) {
+	case XFS_BTNUM_BNO:
+	case XFS_BTNUM_CNT:
+		ptr->u.alloc = cpu_to_be32(NULLAGBLOCK);
+		break;
+	case XFS_BTNUM_INO:
+		ptr->u.inobt = cpu_to_be32(NULLAGBLOCK);
+		break;
+	case XFS_BTNUM_BMAP:
+		ptr->u.bmbt = cpu_to_be64(NULLFSBLOCK);
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+}
+
+STATIC int
+xfs_btree_dec_cursor(
+	xfs_btree_cur_t	*cur,
+	int		level,
+	int		*stat)
+{
+	int		i;
+	int		error;
+
+	if (level > 0) {
+		error = xfs_btree_decrement(cur, level, &i);
+		if (error)
+			return error;
+	}
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+}
+
+/*
+ * Return true if ptr is the last record in the btree and
+ * we need to track updateѕ to this record.
+ */
+STATIC int
+xfs_btree_is_lastrec(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block,
+	int			level,
+	int			last)
+{
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+	xfs_btree_ptr_t		ptr;
+	int			numrecs;
+
+	numrecs = rops->get_numrecs(cur, block);
+	bops->get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
+	return ((cur->bc_flags & XFS_BTREE_LASTREC_UPDATE) &&
+		level == 0 &&
+		xfs_btree_ptr_null(cur, &ptr) &&
+		last >= numrecs);
+
+}
+
+/*
+ * Move numrecs from the src block to the dst block.
+ * Log the changes to the destination block.
+ */
+STATIC int
+xfs_btree_move_entries(
+	xfs_btree_cur_t	*cur,
+	int		level,
+	xfs_buf_t	*sbp,		/* source block */
+	xfs_buf_t	*dbp,		/* destination block */
+	int		src_index,	/* src block index */
+	int		dst_index,	/* dst block index */
+	int		numrecs)	 /* number of records to move */
+{
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+	xfs_btree_block_t	*src;		/* src btree block */
+	xfs_btree_key_t		*skp;		/* src btree key */
+	xfs_btree_ptr_t		*spp;		/* src address pointer */
+	xfs_btree_rec_t		*srp;		/* src record pointer */
+	xfs_btree_block_t	*dst;		/* dst btree block */
+	xfs_btree_key_t		*dkp;		/* dst btree key */
+	xfs_btree_ptr_t		*dpp;		/* dst address pointer */
+	xfs_btree_rec_t		*drp;		/* dst record pointer */
+
+	src = bops->buf_to_block(cur, sbp);
+	dst = bops->buf_to_block(cur, dbp);
+	if (level > 0) {
+		/*
+		 * It's a non-leaf.  Move keys and pointers.
+		 */
+		skp = rops->key_addr(cur, src_index, src);
+		spp = rops->ptr_addr(cur, src_index, src);
+		dkp = rops->key_addr(cur, dst_index, dst);
+		dpp = rops->ptr_addr(cur, dst_index, dst);
+#ifdef DEBUG
+		for (i = ptr; i < numrecs; i++) {
+			error = bops->check_lptr_disk(cur, rpp, i, level);
+			if (error)
+				goto error0;
+		}
+#endif
+		rops->move_keys(cur, skp, dkp, 0, 0, numrecs);
+		rops->move_ptrs(cur, spp, dpp, 0, 0, numrecs);
+
+		rops->log_keys(cur, dbp, dst_index, numrecs);
+		rops->log_ptrs(cur, dbp, dst_index, numrecs);
+	} else {
+		/*
+		 * It's a leaf.  Move records.
+		 */
+		srp = rops->rec_addr(cur, src_index, src);
+		drp = rops->rec_addr(cur, dst_index, dst);
+		rops->move_recs(cur, srp, drp, 0, 0, numrecs);
+		rops->log_recs(cur, dbp, dst_index, numrecs);
+	}
+	rops->set_numrecs(cur, dst, rops->get_numrecs(cur, dst) + numrecs);
+	bops->log_block(cur, dbp, XFS_BB_NUMRECS);
+#ifdef DEBUG
+	if (level > 0)
+		xfs_btree_check_key(cur->bc_btnum, lkp - 1, lkp);
+	else
+		xfs_btree_check_rec(cur->bc_btnum, lrp - 1, lrp);
+#endif
+	return 0;
+}
+/*
+ * Excise the entries indicated by the start, end.
+ * Simply slide the entries past them down.
+ * Log the changed areas of the block.
+ */
+STATIC int
+xfs_btree_remove_entry(
+	xfs_btree_cur_t	*cur,
+	int		level,
+	xfs_buf_t	*bp,
+	xfs_btree_key_t	*key,
+	int		index)	/* index to excise */
+{
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+	xfs_btree_block_t	*block;		/* bmap btree block */
+	xfs_btree_key_t		*kp=NULL;	/* pointer to bmap btree key */
+	xfs_btree_ptr_t		*pp;		/* pointer to bmap block addr */
+	xfs_btree_rec_t		*rp;		/* pointer to bmap btree rec */
+	int			numrecs;
+
+	block = bops->buf_to_block(cur, bp);
+	numrecs = rops->get_numrecs(cur, block);
+	if (level > 0) {
+		/*
+		 * It's a nonleaf.  Excise the key and ptr being deleted, by
+		 * sliding the entries past them down one.  Log the changed
+		 * areas of the block.
+		 */
+		kp = rops->key_addr(cur, 1, block);
+		pp = rops->ptr_addr(cur, 1, block);
+#ifdef DEBUG
+		for (i = index; i < numrecs; i++) {
+			error = cur->b_ops->check_lptr_disk(cur, pp, i, level);
+			if (error)
+				goto error0;
+		}
+#endif
+		if (index < numrecs) {
+			rops->move_keys(cur, kp, NULL, index, index - 1, numrecs - index);
+			rops->move_ptrs(cur, pp, NULL, index, index - 1, numrecs - index);
+			rops->log_ptrs(cur, bp, index, numrecs - 1);
+			rops->log_keys(cur, bp, index, numrecs - 1);
+		}
+	} else {
+		/*
+		 * It's a leaf.  Excise the record being deleted, by sliding
+		 * the entries past it down one.  Log the changed areas of the
+		 * block.
+		 */
+		rp = rops->rec_addr(cur, 1, block);
+		if (index < numrecs) {
+			rops->move_recs(cur, rp, NULL, index, index - 1, numrecs - index);
+			rops->log_recs(cur, bp, index, numrecs - 1);
+		}
+		/*
+		 * If it's the first record in the block, we'll need a key
+		 * structure to pass up to the next level (updkey).
+		 */
+		if (index == 1)
+			rops->init_key_from_rec(cur, key, rp);
+	}
+	numrecs--;
+	rops->set_numrecs(cur, block, numrecs);
+	bops->log_block(cur, bp, XFS_BB_NUMRECS);
+	return 0;
+}
+
+/*
+ * Insert the entry indicated by the start index
+ * Simply slide the entries up one, inser the new entry and
+ * Log the changed areas of the block.
+ */
+STATIC int
+xfs_btree_insert_entry(
+	xfs_btree_cur_t	*cur,
+	int		level,
+	xfs_buf_t	*bp,
+	int		index,	/* index to insert at */
+	xfs_btree_key_t	*key,
+	xfs_btree_ptr_t	*ptr,
+	xfs_btree_rec_t	*rec)
+{
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+	xfs_btree_block_t	*block;
+	xfs_btree_key_t		*kp;
+	xfs_btree_ptr_t		*pp;
+	xfs_btree_rec_t		*rp;
+	int			numrecs;
+
+	block = bops->buf_to_block(cur, bp);
+	numrecs = rops->get_numrecs(cur, block);
+	if (level > 0) {
+		/*
+		 * It's a non-leaf entry.  Make a hole for the new data
+		 * in the key and ptr regions of the block.
+		 */
+		kp = rops->key_addr(cur, 1, block);
+		pp = rops->ptr_addr(cur, 1, block);
+#ifdef DEBUG
+		for (i = numrecs; i >= index; i--) {
+			error = bops->check_lptr_disk(cur, pp, i - 1, level);
+			if (error)
+				goto error0;
+		}
+#endif
+		rops->move_keys(cur, kp, NULL, index - 1, index,
+						numrecs - index + 1);
+		rops->move_ptrs(cur, pp, NULL, index - 1, index,
+						numrecs - index + 1);
+		/*
+		 * Now stuff the new data in, bump numrecs and log the new data.
+		 */
+#ifdef DEBUG
+		error = bops->check_lptr_disk(cur, ptr, 0, level);
+		if (error)
+			goto error0;
+#endif
+		rops->set_key(cur, kp, index - 1, key);
+		rops->set_ptr(cur, pp, index - 1, ptr);
+		numrecs++;
+		rops->set_numrecs(cur, block, numrecs);
+		rops->log_ptrs(cur, bp, index, numrecs);
+		rops->log_keys(cur, bp, index, numrecs);
+	} else {
+		/*
+		 * It's a leaf entry.  Make a hole for the new record.
+		 */
+		rp = rops->rec_addr(cur, 1, block);
+		rops->move_recs(cur, rp, NULL, index - 1, index,
+						numrecs - index + 1);
+		/*
+		 * Now stuff the new record in, bump numrecs
+		 * and log the new data.
+		 */
+		rops->set_rec(cur, rp, index - 1, rec);
+		numrecs++;
+		rops->set_numrecs(cur, block, numrecs);
+		rops->log_recs(cur, bp, index, numrecs);
+	}
+	/*
+	 * Log the new number of records in the btree header.
+	 */
+	bops->log_block(cur, bp, XFS_BB_NUMRECS);
+
+#ifdef DEBUG
+	/*
+	 * Check that the key/record is in the right place, now.
+	 */
+	if (ptr < numrecs) {
+		if (level == 0)
+			xfs_btree_check_rec(cur->bc_btnum, rp + index - 1,
+				rp + index);
+		else
+			xfs_btree_check_key(cur->bc_btnum, kp + index - 1,
+				kp + index);
+	}
+#endif
+	return 0;
+}
+
+/*
+ * Single level of the btree record deletion routine.
+ * Delete record pointed to by cur/level.
+ * Remove the record from its block then rebalance the tree.
+ * Return 0 for error, 1 for done, 2 to go on to the next level.
+ */
+int					/* error */
+xfs_btree_delrec(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	int			level,	/* level removing record from */
+	int			*stat)	/* fail/done/go-on */
+{
+	xfs_btree_block_t	*block;		/* bmap btree block */
+	xfs_btree_ptr_t		cptr;		/* current block ptr */
+	xfs_buf_t		*bp;		/* buffer for block */
+	int			error;		/* error return value */
+	int			i;		/* loop counter */
+	xfs_btree_key_t		key;		/* bmap btree key */
+	xfs_btree_key_t		*kp=NULL;	/* pointer to bmap btree key */
+	xfs_btree_ptr_t		lptr;		/* left sibling block ptr */
+	xfs_buf_t		*lbp;		/* left buffer pointer */
+	xfs_btree_block_t	*left;		/* left btree block */
+	int			lrecs=0;	/* left record count */
+	int			ptr;		/* key/record index */
+	xfs_btree_ptr_t		rptr;		/* right sibling block ptr */
+	xfs_buf_t		*rbp;		/* right buffer pointer */
+	xfs_btree_block_t	*right;		/* right btree block */
+	xfs_btree_block_t	*rrblock;	/* right-right btree block */
+	xfs_buf_t		*rrbp;		/* right-right buffer pointer */
+	int			rrecs=0;	/* right record count */
+	xfs_btree_cur_t		*tcur;		/* temporary btree cursor */
+	int			numrecs;	/* temporary numrec count */
+	xfs_btree_curops_t	*cops = cur->bc_curops;
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+	tcur = NULL;
+
+	/*
+	 * Get the index of the entry being deleted, check for nothing there.
+	 */
+	ptr = cur->bc_ptrs[level];
+	if (ptr == 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+
+	/*
+	 * Get the buffer & block containing the record or key/ptr.
+	 */
+	block = bops->get_block(cur, level, &bp);
+	numrecs = rops->get_numrecs(cur, block);
+#ifdef DEBUG
+	error = bops->check_block(cur, block, level, bp);
+	if (error)
+		goto error0;
+#endif
+	/*
+	 * Fail if we're off the end of the block.
+	 */
+	if (ptr > numrecs) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+
+	XFS_STATS_INC(xs_bmbt_delrec);
+
+	/*
+	 * Excise the entries being deleted.
+	 * Log the changed areas of the block.
+	 */
+	error = xfs_btree_remove_entry(cur, level, bp, &key, ptr);
+	if (error)
+		goto error0;
+
+	/*
+	 * If we are tracking the last record in the tree and
+	 * we are at the far right edge of the tree, update it.
+	 */
+	numrecs = rops->get_numrecs(cur, block);
+	if (xfs_btree_is_lastrec(cur, block, level, ptr)) {
+		ASSERT(ptr == numrecs + 1);
+		error = cops->update_lastrec(cur, block);
+		if (error)
+			goto error0;
+	}
+
+	/*
+	 * We're at the root level.
+	 * First, shrink the root block in-memory.
+	 * Try to get rid of the next level down.
+	 * If we can't then there's nothing left to do.
+	 */
+	if (level == cur->bc_nlevels - 1) {
+		/* root in inode is special */
+		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+			cops->realloc_root(cur, -1);
+			error = cops->kill_root(cur, -1, NULL);
+			if (!error)
+				error = xfs_btree_dec_cursor(cur, level, stat);
+			if (error)
+				goto error0;
+		}
+		/*
+		 * If this is the root level, and there's only one entry left,
+		 * and it's NOT the leaf level, then we can get rid of this
+		 * level.
+		 */
+		else if (numrecs == 1 && level > 0) {
+			xfs_btree_ptr_t	*pp;
+			/*
+			 * pp is still set to the first pointer in the block.
+			 * Make it the new root of the btree.
+			 */
+			pp = rops->ptr_addr(cur, 1, block);
+			error = cops->kill_root(cur, level, pp);
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
+		error = xfs_btree_updkey(cur, kp, level + 1);
+		if (error)
+			goto error0;
+	}
+
+	/*
+	 * If the number of records remaining in the block is at least
+	 * the minimum, we're done.
+	 */
+	if (numrecs >= rops->get_minrecs(cur, level)) {
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
+	bops->get_sibling(cur, block, &rptr, XFS_BB_RIGHTSIB);
+	bops->get_sibling(cur, block, &lptr, XFS_BB_LEFTSIB);
+	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		/*
+		 * One child of root, need to get a chance to copy its contents
+		 * into the root and delete it. Can't go up to next level,
+		 * there's nothing to delete there.
+		 */
+		if (xfs_btree_ptr_null(cur, &rptr) &&
+		    xfs_btree_ptr_null(cur, &lptr) &&
+		    level == cur->bc_nlevels - 2) {
+			error = cops->kill_root(cur, -1, NULL);
+			if (!error)
+				error = xfs_btree_dec_cursor(cur, level, stat);
+			if (error)
+				goto error0;
+			return 0;
+		}
+	}
+	ASSERT(!xfs_btree_ptr_null(cur, &rptr) ||
+		!xfs_btree_ptr_null(cur, &lptr));
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
+	if (!xfs_btree_ptr_null(cur, &rptr)) {
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
+		/*
+		 * Grab a pointer to the block.
+		 */
+		rbp = tcur->bc_bufs[level];
+		right = bops->buf_to_block(tcur, rbp);
+#ifdef DEBUG
+		error = bops->check_block(tcur, right, level, rbp);
+		if (error)
+			goto error0;
+#endif
+		/*
+		 * Grab the current block number, for future use.
+		 */
+		bops->get_sibling(tcur, right, &cptr, XFS_BB_LEFTSIB);
+		/*
+		 * If right block is full enough so that removing one entry
+		 * won't make it too empty, and left-shifting an entry out
+		 * of right to us works, we're done.
+		 */
+		if (rops->get_numrecs(tcur, right) - 1 >=
+		    rops->get_minrecs(tcur, level)) {
+			error = xfs_btree_lshift(tcur, level, &i);
+			if (error)
+				goto error0;
+			if (i) {
+				ASSERT(rops->get_numrecs(tcur, block) >=
+				    rops->get_minrecs(tcur, level));
+				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+				tcur = NULL;
+				error = xfs_btree_dec_cursor(cur, level, stat);
+				if (error)
+					goto error0;
+				return 0;
+			}
+		}
+		/*
+		 * Otherwise, grab the number of records in right for
+		 * future reference, and fix up the temp cursor to point
+		 * to our block again (last record).
+		 */
+		rrecs = rops->get_numrecs(tcur, right);
+		if (!xfs_btree_ptr_null(cur, &lptr)) {
+			i = xfs_btree_firstrec(tcur, level);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+			error = xfs_btree_decrement(tcur, level, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		}
+	}
+	/*
+	 * If there's a left sibling, see if it's ok to shift an entry
+	 * out of it.
+	 */
+	if (!xfs_btree_ptr_null(cur, &lptr)) {
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
+		/*
+		 * Grab a pointer to the block.
+		 */
+		lbp = tcur->bc_bufs[level];
+		left = bops->buf_to_block(cur, lbp);
+#ifdef DEBUG
+		error = bops->check_block(cur, left, level, lbp);
+		if (error)
+			goto error0;
+#endif
+		/*
+		 * Grab the current block number, for future use.
+		 */
+		bops->get_sibling(tcur, left, &cptr, XFS_BB_RIGHTSIB);
+		/*
+		 * If left block is full enough so that removing one entry
+		 * won't make it too empty, and right-shifting an entry out
+		 * of left to us works, we're done.
+		 */
+		if (rops->get_numrecs(tcur, left) - 1 >=
+		    rops->get_minrecs(tcur, level)) {
+			error = xfs_btree_rshift(tcur, level, &i);
+			if (error)
+				goto error0;
+			if (i) {
+				ASSERT(rops->get_numrecs(tcur, block) >=
+				    rops->get_minrecs(tcur, level));
+				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+				tcur = NULL;
+				if (level == 0)
+					cur->bc_ptrs[0]++;
+				XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+				*stat = 1;
+				return 0;
+			}
+		}
+		/*
+		 * Otherwise, grab the number of records in right for
+		 * future reference.
+		 */
+		lrecs = rops->get_numrecs(tcur, left);
+	}
+	/*
+	 * Delete the temp cursor, we're done with it.
+	 */
+	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
+	tcur = NULL;
+
+	/*
+	 * If here, we need to do a join to keep the tree balanced.
+	 */
+	ASSERT(!xfs_btree_ptr_null(cur, &cptr));
+	if (!xfs_btree_ptr_null(cur, &lptr) &&
+	    ((lrecs + rops->get_numrecs(cur, block)) <=
+			(rops->get_maxrecs(cur, level)))) {
+		/*
+		 * Set "right" to be the starting block,
+		 * "left" to be the left neighbor.
+		 */
+		rptr = cptr;
+		right = block;
+		rbp = bp;
+		error = bops->read_buf(cur, &lptr, 0, &lbp);
+		if (error)
+			goto error0;
+		left = bops->buf_to_block(cur, lbp);
+		error = bops->check_block(cur, left, level, lbp);
+		if (error)
+			goto error0;
+	}
+	/*
+	 * If that won't work, see if we can join with the right neighbor block.
+	 */
+	else if (!xfs_btree_ptr_null(cur, &rptr) &&
+		   ((rrecs + rops->get_numrecs(cur, block)) <=
+			(rops->get_maxrecs(cur, level)))) {
+		/*
+		 * Set "left" to be the starting block,
+		 * "right" to be the right neighbor.
+		 */
+		lptr = cptr;
+		left = block;
+		lbp = bp;
+		error = bops->read_buf(cur, &rptr, 0, &rbp);
+		if (error)
+			goto error0;
+		right = bops->buf_to_block(cur, rbp);
+		error = bops->check_block(cur, right, level, rbp);
+		if (error)
+			goto error0;
+		lrecs = rops->get_numrecs(cur, left);
+	}
+	/*
+	 * Otherwise, we can't fix the imbalance.
+	 * Just return.  This is probably a logic error, but it's not fatal.
+	 */
+	else {
+		error = xfs_btree_dec_cursor(cur, level, stat);
+		if (error)
+			goto error0;
+		return 0;
+	}
+	/*
+	 * We're now going to join "left" and "right" by moving all the stuff
+	 * in "right" to "left" and deleting "right".
+	 */
+	error = xfs_btree_move_entries(cur, level, rbp, lbp, 1, lrecs + 1, rrecs);
+	if (error)
+		goto error0;
+
+	/*
+	 * Fix up the right block pointer in the surviving block, and log it.
+	 */
+	bops->get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB),
+	bops->set_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
+	bops->log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
+
+	/*
+	 * If there is a right sibling now, make it point to the
+	 * remaining block.
+	 */
+	bops->get_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
+	if (!xfs_btree_ptr_null(cur, &cptr)) {
+		error = bops->read_buf(cur, &cptr, 0, &rrbp);
+		if (error)
+			goto error0;
+		rrblock = bops->buf_to_block(cur, rrbp);
+		error = bops->check_block(cur, rrblock, level, rrbp);
+		if (error)
+			goto error0;
+		bops->set_sibling(cur, rrblock, &lptr, XFS_BB_LEFTSIB);
+		bops->log_block(cur, rrbp, XFS_BB_LEFTSIB);
+	}
+	/*
+	 * Free the deleted block.
+	 */
+	error = bops->free_block(cur, rbp, 1);
+	if (error)
+		goto error0;
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
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	/*
+	 * Return value means the next level up has something to do.
+	 */
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
+STATIC int
+xfs_btree_make_block_unfull(
+	xfs_btree_cur_t		*cur,		/* btree cursor */
+	int			level,		/* btree level */
+	int			numrecs,	/* # of recs in block */
+	int			*oindex,	/* old tree index */
+	int			*index,		/* new tree index */
+	xfs_btree_ptr_t		*nptr,		/* new btree ptr */
+	xfs_btree_cur_t		**ncur,		/* new btree cursor */
+	xfs_btree_rec_t		*nrec,		/* new record */
+	int			*stat)
+{
+	xfs_btree_curops_t	*cops = cur->bc_curops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+	xfs_btree_key_t		key;	/* new btree key value */
+	int			error = 0;
+
+	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		if (numrecs < rops->get_dmaxrecs(cur, level)) {
+			/* A resizeable root block that can be made bigger. */
+			cops->realloc_root(cur, 1);
+			return 0;
+		}
+		if (level == cur->bc_nlevels - 1) {
+			/* A root block that needs replacing */
+			error = cops->new_root(cur, stat);
+			if (error || *stat == 0)
+				return error;
+			return 0;
+		}
+	}
+
+	/*
+	 * First, try shifting an entry to the right neighbor.
+	 */
+	error = xfs_btree_rshift(cur, level, stat);
+	if (error)
+		return error;
+	if (*stat) {
+		/* nothing */
+	} else {
+		/*
+		 * Next, try shifting an entry to the left neighbor.
+		 */
+		error = xfs_btree_lshift(cur, level, stat);
+		if (error)
+			return error;
+		if (*stat) {
+			*oindex = *index = cur->bc_ptrs[level];
+		} else {
+			/*
+			 * Next, try splitting the current block in half. If
+			 * this works we have to re-set our variables because
+			 * we could be in a different block now.
+			 */
+			error = xfs_btree_split(cur, level, nptr, &key,
+								ncur, stat);
+			if (error || *stat == 0)
+				return error;
+
+			*index = cur->bc_ptrs[level];
+			rops->init_rec_from_key(cur, &key, nrec);
+		}
+	}
+	return 0;
+}
+
+/*
+ * Insert one record/level.  Return information to the caller
+ * allowing the next level up to proceed if necessary.
+ */
+int
+xfs_btree_insrec(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	int			level,	/* level to insert record at */
+	xfs_btree_ptr_t		*ptrp,	/* i/o: block number inserted */
+	xfs_btree_rec_t		*recp,	/* i/o: record data inserted */
+	xfs_btree_cur_t		**curp,	/* output: new cursor replacing cur */
+	int			*stat)	/* success/failure */
+{
+	xfs_btree_block_t	*block;		/* bmap btree block */
+	xfs_buf_t		*bp;		/* buffer for block */
+	int			error;		/* error return value */
+	int			i;		/* loop index */
+	xfs_btree_key_t		key;		/* bmap btree key */
+	xfs_btree_ptr_t		nptr;		/* new block ptr */
+	struct xfs_btree_cur	*ncur;		/* new btree cursor */
+	xfs_btree_rec_t		nrec;		/* new record count */
+	int			optr;		/* old key/record index */
+	int			ptr;		/* key/record index */
+	int			numrecs;
+	xfs_btree_curops_t	*cops = cur->bc_curops;
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+
+	ASSERT(level < cur->bc_nlevels);
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGIPR(cur, level, ptrp, recp);
+	ncur = NULL;
+	/*
+	 * If we have an external root pointer, and we've made it to the
+	 * root level, allocate a new root block and we're done.
+	 */
+	if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (level >= cur->bc_nlevels)) {
+		error = cops->new_root(cur, &i);
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		xfs_btree_set_ptr_null(cur, ptrp);
+		*stat = i;
+		return error;
+	}
+	/*
+	 * Make a key out of the record data to be inserted, and save it.
+	 */
+	rops->init_key_from_rec(cur, &key, recp);
+	/*
+	 * If we're off the left edge, return failure.
+	 */
+	optr = ptr = cur->bc_ptrs[level];
+	if (ptr == 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+	XFS_STATS_INC(xs_bmbt_insrec);
+
+	/*
+	 * Get pointers to the btree buffer and block.
+	 */
+        block = bops->get_block(cur, level, &bp);
+	numrecs = rops->get_numrecs(cur, block);
+#ifdef DEBUG
+	error = bops->check_block(cur, block, level, bp);
+	if (error)
+		goto error0;
+	/*
+	 * Check that the new entry is being inserted in the right place.
+	 */
+	if (ptr <= numrecs) {
+		if (level == 0) {
+			rp = rops->rec_addr(cur, ptr, block);
+			xfs_btree_check_rec(cur->bc_btnum, recp, rp);
+		} else {
+			kp = rops->key_addr(cur, ptr, block);
+			xfs_btree_check_key(cur->bc_btnum, &key, kp);
+		}
+	}
+#endif
+	/*
+	 * If the block is full, we can't insert the new entry until we
+	 * make the block un-full.
+	 */
+	xfs_btree_set_ptr_null(cur, &nptr);
+	ncur = NULL;
+	if (numrecs == rops->get_maxrecs(cur, level)) {
+		error = xfs_btree_make_block_unfull(cur, level, numrecs,
+					&optr, &ptr, &nptr, &ncur, &nrec, stat);
+		if (error || *stat == 0)
+			goto error0;
+	}
+	/*
+	 * The current block may have changed during the split.
+	 */
+	block = bops->get_block(cur, level, &bp);
+#ifdef DEBUG
+	error = bops->check_block(cur, block, level, bp);
+	if (error)
+		return error;
+#endif
+
+	/*
+	 * At this point we know there's room for our new entry in the block
+	 * we're pointing at.
+	 */
+	error = xfs_btree_insert_entry(cur, level, bp, ptr, &key, ptrp, recp);
+	if (error)
+		goto error0;
+
+	/*
+	 * If we inserted at the start of a block, update the parents' keys.
+	 */
+	if (optr == 1) {
+		error = xfs_btree_updkey(cur, &key, level + 1);
+		if (error)
+			goto error0;
+	}
+
+	/*
+	 * Return the new block number, if any.
+	 * If there is one, give back a record value and a cursor too.
+	 */
+	*ptrp = nptr;
+	if (!xfs_btree_ptr_null(cur, &nptr)) {
+		*recp = nrec;
+		*curp = ncur;
+	}
+
+	/*
+	 * If we are tracking the last record in the tree and
+	 * we are at the far right edge of the tree, update it.
+	 */
+	if (xfs_btree_is_lastrec(cur, block, level, ptr)) {
+		error = cops->update_lastrec(cur, block);
+		if (error)
+			goto error0;
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
+ * Move 1 record left from cur/level if possible.
+ * Update cur to reflect the new path.
+ */
+int					/* error */
+xfs_btree_lshift(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	int			*stat)		/* success/failure */
+{
+	int			error;		/* error return value */
+#ifdef DEBUG
+	int			i;		/* loop counter */
+#endif
+	xfs_btree_key_t		key;		/* btree key */
+	xfs_buf_t		*lbp;		/* left buffer pointer */
+	xfs_btree_block_t	*left;		/* left btree block */
+	int			lrecs;		/* left record count */
+	xfs_buf_t		*rbp;		/* right buffer pointer */
+	xfs_btree_block_t	*right;		/* right btree block */
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+	xfs_btree_ptr_t		rptr;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    level == cur->bc_nlevels - 1)
+		goto out0;
+	/*
+	 * Set up variables for this block as "right".
+	 */
+	rbp = cur->bc_bufs[level];
+	right = bops->buf_to_block(cur, rbp);
+#ifdef DEBUG
+	error = bops->check_block(cur, right, level, rbp);
+	if (error)
+		goto error0;
+#endif
+	/*
+	 * If we've got no left sibling then we can't shift an entry left.
+	 */
+	bops->get_sibling(cur, right, &rptr, XFS_BB_LEFTSIB);
+	if (xfs_btree_ptr_null(cur, &rptr))
+		goto out0;
+	/*
+	 * If the cursor entry is the one that would be moved, don't
+	 * do it... it's too complicated.
+	 */
+	if (cur->bc_ptrs[level] <= 1)
+		goto out0;
+
+	/*
+	 * Set up the left neighbor as "left".
+	 */
+	error = bops->read_buf(cur, &rptr, 0, &lbp);
+	if (error)
+		goto error0;
+	left = bops->buf_to_block(cur, lbp);
+	error = bops->check_block(cur, left, level, lbp);
+	if (error)
+		goto error0;
+
+	/*
+	 * If it's full, it can't take another entry.
+	 */
+	lrecs = rops->get_numrecs(cur, left);
+	if (lrecs == rops->get_maxrecs(cur, level))
+		goto out0;
+	/*
+	 * If non-leaf, copy a key and a ptr to the left block.
+	 * Log the changes to the left block.
+	 */
+	error = xfs_btree_move_entries(cur, level, rbp, lbp, 1, lrecs + 1, 1);
+	if (error)
+		goto error0;
+
+	/*
+	 * Slide the contents of right down one entry.
+	 * Log the changes to the right block.
+	 */
+	error = xfs_btree_remove_entry(cur, level, rbp, &key, 1);
+	if (error)
+		goto error0;
+
+	/*
+	 * Update the parent key values of right.
+	 */
+	error = xfs_btree_updkey(cur, &key, level + 1);
+	if (error)
+		goto error0;
+	/*
+	 * Slide the cursor value left one.
+	 */
+	cur->bc_ptrs[level]--;
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
+int					/* error */
+xfs_btree_rshift(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	int			*stat)		/* success/failure */
+{
+	int			error;		/* error return value */
+	int			i;		/* loop counter */
+	xfs_btree_key_t		key;		/* btree key */
+	xfs_buf_t		*lbp;		/* left buffer pointer */
+	xfs_btree_block_t	*left;		/* left btree block */
+	xfs_buf_t		*rbp;		/* right buffer pointer */
+	xfs_btree_block_t	*right;		/* right btree block */
+	struct xfs_btree_cur	*tcur;		/* temporary btree cursor */
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+	xfs_btree_ptr_t		rptr;
+	int			rrecs;		/* right record count */
+	int			lrecs;		/* left record count */
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (level == cur->bc_nlevels - 1))
+		goto out0;
+	/*
+	 * Set up variables for this block as "left".
+	 */
+	lbp = cur->bc_bufs[level];
+	left = bops->buf_to_block(cur, lbp);
+#ifdef DEBUG
+	error = bops->check_block(cur, left, level, lbp);
+	if (error)
+		goto error0;
+#endif
+	/*
+	 * If we've got no right sibling then we can't shift an entry right.
+	 */
+	bops->get_sibling(cur, left, &rptr, XFS_BB_RIGHTSIB);
+	if (xfs_btree_ptr_null(cur, &rptr))
+		goto out0;
+	/*
+	 * If the cursor entry is the one that would be moved, don't
+	 * do it... it's too complicated.
+	 */
+	lrecs = rops->get_numrecs(cur, left);
+	if (cur->bc_ptrs[level] >= lrecs)
+		goto out0;
+	/*
+	 * Set up the right neighbor as "right".
+	 */
+	error = bops->read_buf(cur, &rptr, 0, &rbp);
+	if (error)
+		goto error0;
+	right = bops->buf_to_block(cur, rbp);
+	error = bops->check_block(cur, right, level, rbp);
+	if (error)
+		goto error0;
+
+	/*
+	 * If it's full, it can't take another entry.
+	 */
+	rrecs = rops->get_numrecs(cur, right);
+	if (rrecs == rops->get_maxrecs(cur, level))
+		goto out0;
+
+	/*
+	 * Make a hole at the start of the right neighbor block, then
+	 * copy the last left block entry to the hole. Update and
+	 * log the right block.
+	 */
+	error = xfs_btree_insert_entry(cur, level, rbp, 1,
+					rops->key_addr(cur, lrecs, left),
+					rops->ptr_addr(cur, lrecs, left),
+					rops->rec_addr(cur, lrecs, left));
+	if (error)
+		goto error0;
+
+	/*
+	 * If we are at leaf level, grab the key of the new entry in
+	 * the right block for later.
+	 */
+	if (level == 0)
+		rops->init_key_from_rec(cur, &key, rops->rec_addr(cur, 1, right));
+
+	/*
+	 * Now update the left block to reflect the moved entry
+	 */
+	lrecs--;
+	rops->set_numrecs(cur, left, lrecs);
+	bops->log_block(cur, lbp, XFS_BB_NUMRECS);
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
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+	error = xfs_btree_updkey(cur, &key, level + 1);
+	if (error)
+		goto error1;
+
+	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
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
+int					/* error */
+xfs_btree_split(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	xfs_btree_ptr_t		*ptrp,
+	xfs_btree_key_t		*key,
+	xfs_btree_cur_t		**curp,
+	int			*stat)		/* success/failure */
+{
+	int			error;		/* error return value */
+	xfs_btree_ptr_t		lptr;		/* left sibling block ptr */
+	xfs_buf_t		*lbp;		/* left buffer pointer */
+	xfs_btree_block_t	*left;		/* left btree block */
+	xfs_btree_ptr_t		rptr;		/* right sibling block ptr */
+	xfs_buf_t		*rbp;		/* right buffer pointer */
+	xfs_btree_block_t	*right;		/* right btree block */
+	xfs_btree_ptr_t		rrptr;		/* right-right sibling ptr */
+	xfs_buf_t		*rrbp;		/* right-right buffer pointer */
+	xfs_btree_block_t	*rrblock;	/* right-right btree block */
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+	int			lrecs;
+	int			rrecs;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGIPK(cur, level, ptrp, key);
+
+	/*
+	 * Set up left block (current one).
+	 */
+	lbp = cur->bc_bufs[level];
+	bops->buf_to_ptr(cur, lbp, &lptr);
+
+	/*
+	 * Allocate the new block.
+	 * If we can't do it, we're toast.  Give up.
+	 */
+	error = bops->alloc_block(cur, &lptr, &rptr, 1, stat);
+	if (error)
+		goto error0;
+	if (*stat == 0)
+		goto out0;
+
+	/*
+	 * Set up the new block as "right".
+	 */
+	error = bops->get_buf(cur, &rptr, 0, &rbp);
+	if (error)
+		goto error0;
+	right = bops->buf_to_block(cur, rbp);
+
+	/*
+	 * "Left" is the current (according to the cursor) block.
+	 */
+	left = bops->buf_to_block(cur, lbp);
+#ifdef DEBUG
+	error = bops->check_block(cur, left, level, lbp);
+	if (error)
+		goto error0;
+#endif
+
+	/*
+	 * Fill in the btree header for the new block.
+	 */
+	bops->init_sibling(cur, right, left);
+
+	/*
+	 * Split the entries between the old and the new block evenly.
+	 * Make sure that if there's an odd number of entries now, that
+	 * each new block will have the same number of entries.
+	 */
+	lrecs = rops->get_numrecs(cur, left);
+	rrecs = lrecs / 2;
+	if ((lrecs & 1) && cur->bc_ptrs[level] <= rrecs + 1)
+		rrecs++;
+
+	/*
+	 * Copy btree block entries from the left block over to the
+	 * new block, the right. Update the right block and log the
+	 * changes.
+	 */
+	error = xfs_btree_move_entries(cur, level, lbp, rbp,
+					(lrecs - rrecs + 1), 1, rrecs);
+	if (error)
+		goto error0;
+
+	/*
+	 * Grab the keys to the entries moved to the right block
+	 */
+	if (level > 0) {
+		xfs_btree_key_t	*keyp;
+		keyp = rops->key_addr(cur, 1, right);
+		rops->move_keys(cur, keyp, key, 0, 0, 1);
+	} else {
+		rops->init_key_from_rec(cur, key, rops->rec_addr(cur, 1, right));
+	}
+
+	/*
+	 * Find the left block number by looking in the buffer.
+	 * Adjust numrecs, sibling pointers.
+	 */
+	bops->get_sibling(cur, left, &rrptr, XFS_BB_RIGHTSIB);
+	bops->set_sibling(cur, right, &rrptr, XFS_BB_RIGHTSIB);
+	bops->set_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
+	bops->set_sibling(cur, left, &rptr, XFS_BB_RIGHTSIB);
+
+	lrecs -= rrecs;
+	rops->set_numrecs(cur, left, lrecs);
+
+	bops->log_block(cur, rbp, XFS_BB_ALL_BITS);
+	bops->log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
+
+	/*
+	 * If there's a block to the new block's right, make that block
+	 * point back to right instead of to left.
+	 */
+	if (!xfs_btree_ptr_null(cur, &rrptr)) {
+		error = bops->read_buf(cur, &rrptr, 0, &rrbp);
+		if (error)
+			goto error0;
+		rrblock = bops->buf_to_block(cur, rrbp);
+		error = bops->check_block(cur, rrblock, level, rrbp);
+		if (error)
+			goto error0;
+
+		bops->set_sibling(cur, rrblock, &rptr, XFS_BB_LEFTSIB);
+		bops->log_block(cur, rrbp, XFS_BB_LEFTSIB);
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
+ * Update keys at all levels from here to the root along the cursor's path.
+ */
+int
+xfs_btree_updkey(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_key_t		*keyp,	/* on-disk format */
+	int			level)
+{
+	xfs_btree_block_t	*block;
+	xfs_buf_t		*bp;
+#ifdef DEBUG
+	int			error;
+#endif
+	xfs_btree_key_t		*kp;
+	int			ptr;
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+
+	ASSERT(!(cur->bc_flags & XFS_BTREE_INODE_IN_ROOT) || level >= 1);
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGIK(cur, level, keyp);
+	/*
+	 * Go up the tree from this level toward the root.
+	 * At each level, update the key value to the value input.
+	 * Stop when we reach a level where the cursor isn't pointing
+	 * at the first entry in the block.
+	 */
+	for (ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
+		block = bops->get_block(cur, level, &bp);
+#ifdef DEBUG
+		error = bops->check_block(cur, block, level, bp);
+		if (error) {
+			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+			return error;
+		}
+#endif
+		ptr = cur->bc_ptrs[level];
+		kp = rops->key_addr(cur, ptr, block);
+		rops->move_keys(cur, keyp, kp, 0, 0, 1);
+		rops->log_keys(cur, bp, ptr, ptr);
+	}
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+}
+
+/*
+ * Increment cursor by one record at the level.
+ * For nonzero levels the leaf-ward information is untouched.
+ */
+int						/* error */
+xfs_btree_increment(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	int			*stat)		/* success/failure */
+{
+	xfs_btree_block_t	*block;
+	xfs_btree_ptr_t		ptr;
+	xfs_buf_t		*bp;
+	int			error;		/* error return value */
+	int			lev;
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+	ASSERT(level < cur->bc_nlevels);
+	/*
+	 * Read-ahead to the right at this level.
+	 */
+	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
+	/*
+	 * Get a pointer to the btree block.
+	 */
+	block = bops->get_block(cur, level, &bp);
+#ifdef DEBUG
+	error = bops->check_block(cur, block, level, bp);
+	if (error)
+		goto error0;
+#endif
+	/*
+	 * Increment the ptr at this level.  If we're still in the block
+	 * then we're done.
+	 */
+	if (++cur->bc_ptrs[level] <= rops->get_numrecs(cur, block))
+		goto out1;
+	/*
+	 * If we just went off the right edge of the tree, return failure.
+	 */
+	bops->get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
+	if (xfs_btree_ptr_null(cur, &ptr))
+		goto out0;
+
+	/*
+	 * March up the tree incrementing pointers.
+	 * Stop when we don't go off the right edge of a block.
+	 */
+	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
+		block = bops->get_block(cur, lev, &bp);
+#ifdef DEBUG
+		error = bops->check_block(cur, block, lev, bp);
+		if (error)
+			goto error0;
+#endif
+		if (++cur->bc_ptrs[lev] <= rops->get_numrecs(cur, block))
+			break;
+		/*
+		 * Read-ahead the right block, we're going to read it
+		 * in the next loop.
+		 */
+		xfs_btree_readahead(cur, lev, XFS_BTCUR_RIGHTRA);
+	}
+	/*
+	 * If we went off the root then we are either seriously
+	 * confused or have the tree root in an inode.
+	 */
+	if (lev == cur->bc_nlevels) {
+		ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+		goto out0;
+	}
+	ASSERT(lev < cur->bc_nlevels);
+
+	/*
+	 * Now walk back down the tree, fixing up the cursor's buffer
+	 * pointers and key numbers.
+	 */
+	for (block = bops->get_block(cur, lev, &bp); lev > level; ) {
+		xfs_btree_ptr_t	*ptrp;
+
+		ptrp = rops->ptr_addr(cur, cur->bc_ptrs[lev], block);
+		error = bops->read_buf(cur, ptrp, 0, &bp);
+		if (error)
+			goto error0;
+		lev--;
+		xfs_btree_setbuf(cur, lev, bp);
+		block = bops->buf_to_block(cur, bp);
+		error = bops->check_block(cur, block, lev, bp);
+		if (error)
+			goto error0;
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
+	xfs_btree_cur_t		*cur,
+	int			level,
+	int			*stat)		/* success/failure */
+{
+	xfs_btree_block_t	*block;
+	xfs_buf_t		*bp;
+	int			error;		/* error return value */
+	int			lev;
+	xfs_btree_ptr_t		ptr;
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_TRACE_ARGI(cur, level);
+	ASSERT(level < cur->bc_nlevels);
+	/*
+	 * Read-ahead to the left at this level.
+	 */
+	xfs_btree_readahead(cur, level, XFS_BTCUR_LEFTRA);
+	/*
+	 * Decrement the ptr at this level.  If we're still in the block
+	 * then we're done.
+	 */
+	if (--cur->bc_ptrs[level] > 0)
+		goto out1;
+	/*
+	 * Get a pointer to the btree block.
+	 */
+	block = bops->get_block(cur, level, &bp);
+#ifdef DEBUG
+	error = bops->check_block(cur, block, level, bp);
+	if (error)
+		goto error0;
+#endif
+	/*
+	 * If we just went off the left edge of the tree, return failure.
+	 */
+	bops->get_sibling(cur, block, &ptr, XFS_BB_LEFTSIB);
+	if (xfs_btree_ptr_null(cur, &ptr))
+		goto out0;
+	/*
+	 * March up the tree decrementing pointers.
+	 * Stop when we don't go off the left edge of a block.
+	 */
+	for (lev = level + 1; lev < cur->bc_nlevels; lev++) {
+		if (--cur->bc_ptrs[lev] > 0)
+			break;
+		/*
+		 * Read-ahead the left block, we're going to read it
+		 * in the next loop.
+		 */
+		xfs_btree_readahead(cur, lev, XFS_BTCUR_LEFTRA);
+	}
+	/*
+	 * If we went off the root then we are seriously confused.
+	 * or the root of the tree is in an inode.
+	 */
+	if (lev == cur->bc_nlevels) {
+		ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+		goto out0;
+	}
+	ASSERT(lev < cur->bc_nlevels);
+	/*
+	 * Now walk back down the tree, fixing up the cursor's buffer
+	 * pointers and key numbers.
+	 */
+	for (block = bops->get_block(cur, lev, &bp); lev > level; ) {
+		xfs_btree_ptr_t	*ptrp;
+
+		ptrp = rops->ptr_addr(cur, cur->bc_ptrs[lev], block);
+		error = bops->read_buf(cur, ptrp, 0, &bp);
+		if (error)
+			goto error0;
+		lev--;
+		xfs_btree_setbuf(cur, lev, bp);
+		block = bops->buf_to_block(cur, bp);
+		error = bops->check_block(cur, block, lev, bp);
+		if (error)
+			goto error0;
+		cur->bc_ptrs[lev] = rops->get_numrecs(cur, block);
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
+ * Insert the record at the point referenced by cur.
+ * The cursor may be inconsistent on return if splits have been done.
+ */
+int
+xfs_btree_insert(
+	xfs_btree_cur_t	*cur,
+	int		*stat)
+{
+	int		error;		/* error return value */
+	int		i;		/* result value, 0 for failure */
+	int		level;		/* current level number in btree */
+	xfs_btree_ptr_t	nptr;		/* new block number (split result) */
+	xfs_btree_cur_t	*ncur;		/* new cursor (split result) */
+	xfs_btree_cur_t	*pcur;		/* previous level's cursor */
+	xfs_btree_rec_t	rec;		/* record to insert */
+	xfs_btree_curops_t	*cops = cur->bc_curops;
+
+	level = 0;
+	xfs_btree_set_ptr_null(cur, &nptr);
+	cur->bc_recops->init_rec_from_cur(cur, &rec);
+	ncur = NULL;
+	pcur = cur;
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
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+		level++;
+		/*
+		 * See if the cursor we just used is trash.
+		 * Can't trash the caller's cursor, but otherwise we should
+		 * if ncur is a new cursor or we're about to be done.
+		 */
+		if (pcur != cur && (ncur || xfs_btree_ptr_null(cur, &nptr))) {
+			/*
+			 * some btrees need to move state from one cursor
+			 * to another here.
+			 */
+			if (cops->update_cursor)
+				cops->update_cursor(pcur, cur);
+			cur->bc_nlevels = pcur->bc_nlevels;
+			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
+		}
+		/*
+		 * If we got a new cursor, switch to it.
+		 */
+		if (ncur) {
+			pcur = ncur;
+			ncur = NULL;
+		}
+	} while (!xfs_btree_ptr_null(cur, &nptr));
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = i;
+	return 0;
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
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
+	xfs_btree_cur_t	*cur,
+	int		*stat)		/* success/failure */
+{
+	int		error;		/* error return value */
+	int		i;
+	int		level;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	/*
+	 * Go up the tree, starting at leaf level.
+	 * If 2 is returned then a join was done; go to the next level.
+	 * Otherwise we are done.
+	 */
+	for (level = 0, i = 2; i == 2; level++) {
+		error = xfs_btree_delrec(cur, level, &i);
+		if (error)
+			goto error0;
+	}
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
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = i;
+	return 0;
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+STATIC int
+xfs_btree_lookup_get_block(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_btree_block_t	**blkp, /* current btree block */
+	int			level,	/* level in the btree */
+	xfs_btree_ptr_t		*pp)	/* ptr to btree block */
+{
+	xfs_buf_t		*bp;	/* buffer pointer for btree block */
+	xfs_daddr_t		d;	/* disk address of btree block */
+	int			error = 0;
+	xfs_btree_block_t	*block; /* current btree block */
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+
+	/*
+	 * special case the root block if in an inode
+	 */
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    (level >= cur->bc_nlevels - 1)) {
+		*blkp = bops->get_block(cur, level, &bp);
+		return 0;
+	}
+
+	/*
+	 * Get the disk address we're looking for.
+	 */
+	d = rops->ptr_to_daddr(cur, pp);
+	/*
+	 * If the old buffer at this level is for a different block,
+	 * throw it away, otherwise just use it.
+	 */
+	bp = cur->bc_bufs[level];
+	if (bp && XFS_BUF_ADDR(bp) != d)
+		bp = NULL;
+	if (!bp) {
+		/*
+		 * Need to get a new buffer.  Read it, then
+		 * set it in the cursor, releasing the old one.
+		 */
+		error = bops->read_buf(cur, pp, 0, &bp);
+		if (error)
+			return error;
+		xfs_btree_setbuf(cur, level, bp);
+		/*
+		 * Point to the btree block, now that we have the buffer
+		 */
+		block = bops->buf_to_block(cur, bp);
+		error = bops->check_block(cur, block, level, bp);
+		if (error)
+			return error;
+	} else
+		block = bops->buf_to_block(cur, bp);
+
+	*blkp = block;
+	return 0;
+}
+
+/*
+ * Lookup the record.  The cursor is made to point to it, based on dir.
+ * Return 0 if can't find any such record, 1 for success.
+ */
+int				/* error */
+xfs_btree_lookup(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_lookup_t		dir,	/* <=, ==, or >= */
+	int			*stat)	/* success/failure */
+{
+	xfs_btree_block_t	*block = NULL;	/* current btree block */
+	__int64_t		diff;	/* difference for the current key */
+	int			error;	/* error return value */
+	int			keyno = 0;	/* current key number */
+	int			level;	/* level in the btree */
+	xfs_btree_ptr_t		*pp;	/* ptr to btree block */
+	xfs_btree_ptr_t		ptr;	/* ptr to btree block */
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+
+	/*
+	 * initialise start pointer from cursor
+	 */
+	rops->init_ptr_from_cur(cur, &ptr);
+	pp = &ptr;
+
+	/*
+	 * Iterate over each level in the btree, starting at the root.
+	 * For each level above the leaves, find the key we need, based
+	 * on the lookup record, then follow the corresponding block
+	 * pointer down to the next level.
+	 */
+	for (level = cur->bc_nlevels - 1, diff = 1; level >= 0; level--) {
+		/*
+		 * Get the block we need to do the lookup on.
+		 */
+		error = xfs_btree_lookup_get_block(cur, &block, level, pp);
+		if (error)
+			goto error0;
+
+		/*
+		 * If we already had a key match at a higher level, we know
+		 * we need to use the first entry in this block.
+		 */
+		if (diff == 0)
+			keyno = 1;
+		/*
+		 * Otherwise we need to search this block.  Do a binary search.
+		 */
+		else {
+			int	high;	/* high entry number */
+			int	low;	/* low entry number */
+
+			/*
+			 * Set low and high entry numbers, 1-based.
+			 */
+			low = 1;
+			high = rops->get_numrecs(cur, block);
+			if (!high) {
+				/*
+				 * If the block is empty, the tree must
+				 * be an empty leaf.
+				 */
+				ASSERT(level == 0 && cur->bc_nlevels == 1);
+				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
+				XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+				*stat = 0;
+				return 0;
+			}
+			/*
+			 * Binary search the block.
+			 */
+			while (low <= high) {
+				xfs_btree_key_t	key;
+				xfs_btree_key_t	*kp;
+
+				XFS_STATS_INC(xs_bmbt_compare);
+				/*
+				 * keyno is average of low and high.
+				 */
+				keyno = (low + high) >> 1;
+				/*
+				 * Get current search key
+				 */
+				if (level > 0) {
+					kp = rops->key_addr(cur, keyno, block);
+				} else {
+					xfs_btree_rec_t	*krp;
+
+					krp = rops->rec_addr(cur, keyno, block);
+					kp = &key;
+					rops->init_key_from_rec(cur, kp, krp);
+				}
+				/*
+				 * Compute difference to get next direction.
+				 */
+				diff = rops->key_diff(cur, kp);
+
+				/*
+				 * Less than, move right.
+				 * Greater than, move left.
+				 * Equal, we're done.
+				 */
+				if (diff < 0)
+					low = keyno + 1;
+				else if (diff > 0)
+					high = keyno - 1;
+				else
+					break;
+			}
+		}
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
+			pp = rops->ptr_addr(cur, keyno, block);
+
+#ifdef DEBUG
+			error = bops->xfs_btree_check_ptr(cur, pp, level);
+			if (error)
+				goto error0;
+#endif
+			cur->bc_ptrs[level] = keyno;
+		}
+	}
+	/*
+	 * Done with the search.
+	 * See if we need to adjust the results.
+	 */
+	if (dir != XFS_LOOKUP_LE && diff < 0) {
+		keyno++;
+		/*
+		 * If ge search and we went off the end of the block, but it's
+		 * not the last block, we're in the wrong block.
+		 */
+		bops->get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
+		if (dir == XFS_LOOKUP_GE &&
+		    keyno > rops->get_numrecs(cur, block) &&
+		    !xfs_btree_ptr_null(cur, &ptr)) {
+			int	i;
+
+			cur->bc_ptrs[0] = keyno;
+			error = xfs_btree_increment(cur, 0, &i);
+			if (error)
+				goto error0;
+			ASSERT(i == 1);
+			XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+			*stat = 1;
+			return 0;
+		}
+	}
+	else if (dir == XFS_LOOKUP_LE && diff > 0)
+		keyno--;
+	cur->bc_ptrs[0] = keyno;
+	/*
+	 * Return if we succeeded or not.
+	 */
+	if (keyno == 0 || keyno > rops->get_numrecs(cur, block))
+		*stat = 0;
+	else
+		*stat = ((dir != XFS_LOOKUP_EQ) || (diff == 0));
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+/*
+ * Allocate a new root block, fill it in.
+ */
+int				/* error */
+xfs_btree_newroot(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	int			*stat)	/* success/failure */
+{
+	xfs_btree_block_t	*block;	/* one half of the old root block */
+	xfs_buf_t		*bp;	/* buffer containing block */
+	int			error;	/* error return value */
+	xfs_btree_key_t		*kp;	/* btree key pointer */
+	xfs_buf_t		*lbp;	/* left buffer pointer */
+	xfs_btree_block_t	*left;	/* left btree block */
+	xfs_buf_t		*nbp;	/* new (root) buffer */
+	xfs_btree_block_t	*new;	/* new (root) btree block */
+	int			nptr;	/* new value for key index, 1 or 2 */
+	xfs_btree_ptr_t		*pp;	/* btree address pointer */
+	xfs_buf_t		*rbp;	/* right buffer pointer */
+	xfs_btree_block_t	*right;	/* right btree block */
+	xfs_btree_curops_t	*cops = cur->bc_curops;
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+	xfs_btree_ptr_t		rptr;
+	xfs_btree_ptr_t		lptr;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	//ASSERT(cur->bc_nlevels < XFS_IN_MAXLEVELS(cur->bc_mp)); // inobt
+	//ASSERT(cur->bc_nlevels < XFS_AG_MAXLEVELS(cur->bc_mp)); // alloc
+
+	/*
+	 * Get a block & a buffer.
+	 */
+	rops->init_ptr_from_cur(cur, &rptr);
+
+	/*
+	 * Allocate the new block.
+	 * If we can't do it, we're toast.  Give up.
+	 */
+	error = bops->alloc_block(cur, &rptr, &lptr, 1, stat);
+	if (error)
+		goto error0;
+	if (*stat == 0)
+		goto out0;
+
+	/*
+	 * Set up the new block.
+	 */
+	error = bops->get_buf(cur, &lptr, 0, &nbp);
+	if (error)
+		goto error0;
+	new = bops->buf_to_block(cur, nbp);
+
+	/*
+	 * Set the root data in the a.g. inode structure,
+	 * increasing the level by 1.
+	 */
+	cops->set_root(cur, &lptr, 1);
+
+	/*
+	 * At the previous root level there are now two blocks: the old
+	 * root, and the new block generated when it was split.
+	 * We don't know which one the cursor is pointing at, so we
+	 * set up variables "left" and "right" for each case.
+	 */
+	bp = cur->bc_bufs[cur->bc_nlevels - 1];
+	block = bops->buf_to_block(cur, bp);
+#ifdef DEBUG
+	error = bops->check_block(cur, block, cur->bc_nlevels - 1, bp);
+	if (error)
+		goto error0;
+#endif
+	bops->get_sibling(cur, block, &rptr, XFS_BB_RIGHTSIB);
+	if (!xfs_btree_ptr_null(cur, &rptr)) {
+		/*
+		 * Our block is left, pick up the right block.
+		 */
+		lbp = bp;
+		bops->buf_to_ptr(cur, lbp, &lptr);
+		left = block;
+		error = bops->read_buf(cur, &rptr, 0, &rbp);
+		if (error)
+			goto error0;
+		bp = rbp;
+		right = bops->buf_to_block(cur, rbp);
+		error = bops->check_block(cur, right, cur->bc_nlevels-1, rbp);
+		if (error)
+			goto error0;
+		nptr = 1;
+	} else {
+		/*
+		 * Our block is right, pick up the left block.
+		 */
+		rbp = bp;
+		bops->buf_to_ptr(cur, rbp, &rptr);
+		right = block;
+		bops->get_sibling(cur, right, &lptr, XFS_BB_LEFTSIB);
+		error = bops->read_buf(cur, &lptr, 0, &lbp);
+		if (error)
+			goto error0;
+		bp = lbp;
+		left = bops->buf_to_block(cur, lbp);
+		error = bops->check_block(cur, left, cur->bc_nlevels-1, lbp);
+		if (error)
+			goto error0;
+		nptr = 2;
+	}
+	/*
+	 * Fill in the new block's btree header and log it.
+	 * XXX: this is 32bit btree specific
+	 */
+	new->bb_h.bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
+	new->bb_h.bb_level = cpu_to_be16(cur->bc_nlevels);
+	new->bb_h.bb_numrecs = cpu_to_be16(2);
+	new->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
+	new->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+	bops->log_block(cur, nbp, XFS_BB_ALL_BITS);
+	ASSERT(!xfs_btree_ptr_null(lp) && !xfs_btree_ptr_null(rp));
+
+	/*
+	 * Fill in the key data in the new root.
+	 */
+	kp = rops->key_addr(cur, 1, new);
+	if (be16_to_cpu(left->bb_h.bb_level) > 0) {
+		rops->set_key(cur, kp, 0, rops->key_addr(cur, 1, left));
+		rops->set_key(cur, kp, 1, rops->key_addr(cur, 1, right));
+	} else {
+		rops->init_key_from_rec(cur, kp, rops->rec_addr(cur, 1, left));
+		kp = rops->key_addr(cur, 2, new);
+		rops->init_key_from_rec(cur, kp, rops->rec_addr(cur, 1, right));
+	}
+	rops->log_keys(cur, nbp, 1, 2);
+	/*
+	 * Fill in the pointer data in the new root.
+	 */
+	pp = rops->ptr_addr(cur, 1, new);
+	rops->set_ptr(cur, pp, 0, &lptr);
+	rops->set_ptr(cur, pp, 1, &rptr);
+	rops->log_ptrs(cur, nbp, 1, 2);
+	/*
+	 * Fix up the cursor.
+	 */
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
+/*
+ * Update the record referred to by cur to the value in the
+ * given record. This either works (return 0) or gets an
+ * EFSCORRUPTED error.
+ */
+int
+xfs_btree_update(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_rec_t	*rec)
+{
+	xfs_btree_block_t	*block;
+	xfs_buf_t		*bp;
+	int			error;
+	int			ptr;
+	xfs_btree_rec_t		*rp;
+	xfs_btree_curops_t	*cops = cur->bc_curops;
+	xfs_btree_blkops_t	*bops = cur->bc_blkops;
+	xfs_btree_recops_t	*rops = cur->bc_recops;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	//XFS_BTREE_TRACE_ARGR(cur, rec);
+
+	/*
+	 * Pick up the current block.
+	 */
+	block = bops->get_block(cur, 0, &bp);
+#ifdef DEBUG
+	error = bops->check_block(cur, block, 0, bp);
+	if (error)
+		goto error0;
+#endif
+	/*
+	 * Get the address of the rec to be updated.
+	 */
+	ptr = cur->bc_ptrs[0];
+	rp = rops->rec_addr(cur, ptr, block);
+	/*
+	 * Fill in the new contents and log them.
+	 */
+	rops->move_recs(cur, rec, rp, 0, 0, 1);
+	rops->log_recs(cur, bp, ptr, ptr);
+	/*
+	 * If we are tracking the last record in the tree and
+	 * we are at the far right edge of the tree, update it.
+	 */
+	if (xfs_btree_is_lastrec(cur, block, 0, ptr)) {
+		error = cops->update_lastrec(cur, block);
+		if (error)
+			goto error0;
+	}
+
+	/*
+	 * Updating first record in leaf. Pass new key value up to our parent.
+	 */
+	if (ptr == 1) {
+		xfs_btree_key_t	key;
+
+		rops->init_key_from_rec(cur, &key, rec);
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
Index: 2.6.x-xfs-new/fs/xfs/xfs_btree_trace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.x-xfs-new/fs/xfs/xfs_btree_trace.c	2007-11-06 19:40:29.758667866 +1100
@@ -0,0 +1,202 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
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
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_dmapi.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_dir2_sf.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_alloc.h"
+#include "xfs_error.h"
+
+#if defined(XFS_BTREE_TRACE)
+
+/*
+ * Add a trace buffer entry for arguments, for one integer arg.
+ */
+STATIC void
+xfs_btree_trace_argi(
+	const char	*func,
+	xfs_btree_cur_t	*cur,
+	int		i,
+	int		line)
+{
+	cur->bc_trcops->trace(func, cur, XBT_ARGS, XFS_BTREE_KTRACE_ARGI, line,
+		i, 0, 0, 0,
+		0, 0, 0, 0,
+		0, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for arguments, for a buffer & 1 integer arg.
+ */
+STATIC void
+xfs_btree_trace_argbi(
+	const char	*func,
+	xfs_btree_cur_t	*cur,
+	xfs_buf_t	*b,
+	int		i,
+	int		line)
+{
+	cur->bc_trcops->trace(func, cur, XBT_ARGS, XFS_BTREE_KTRACE_ARGBI, line,
+		(__psunsigned_t)b, i, 0, 0,
+		0, 0, 0, 0,
+		0, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for arguments, for a buffer & 2 integer args.
+ */
+STATIC void
+xfs_btree_trace_argbii(
+	const char	*func,
+	xfs_btree_cur_t	*cur,
+	xfs_buf_t	*b,
+	int		i0,
+	int		i1,
+	int		line)
+{
+	cur->bc_trcops->trace(func, cur, XBT_ARGS, XFS_BTREE_KTRACE_ARGBII, line,
+		(__psunsigned_t)b, i0, i1, 0,
+		0, 0, 0, 0,
+		0, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for arguments, for int, ptr, key.
+ */
+STATIC void
+xfs_btree_trace_argipk(
+	const char		*func,
+	xfs_btree_cur_t		*cur,
+	int			i,
+	xfs_btree_ptr_t		*p,
+	xfs_btree_key_t		*k,
+	int			line)
+{
+	__uint64_t		v = 0, u = 0;
+	if (XFS_BTREE_LONG_PTRS(cur->bc_btnum)) {
+		u = be64_to_cpu(p->u.l);
+		v = be64_to_cpu(k->u.l);
+	} else {
+		u = be32_to_cpu(p->u.s);
+		v = be32_to_cpu(k->u.s);
+	}
+
+	cur->bc_trcops->trace(func, cur, XBT_ARGS, XFS_BTREE_KTRACE_ARGIPK,
+		line, i, u >> 32, (int)u,
+		v >> 32, (int)v, 0, 0, 0,
+		0, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for arguments, for int, ptr, rec.
+ */
+STATIC void
+xfs_btree_trace_argipr(
+	const char		*func,
+	xfs_btree_cur_t		*cur,
+	int			i,
+	xfs_btree_ptr_t		*p,
+	xfs_btree_rec_t		*r,
+	int			line)
+{
+	__uint64_t		l0 = 0, l1 = 0, l2 = 0;
+	__uint64_t		d;
+
+	if (XFS_BTREE_LONG_PTRS(cur->bc_btnum))
+		d = be64_to_cpu(p->u.l);
+	else
+		d = be32_to_cpu(p->u.s);
+
+	if (cur->bc_trcops->record)
+		cur->bc_trcops->record(cur, r, &l0, &l1, &l2);
+
+	cur->bc_trcops->trace(func, cur, XBT_ARGS, XFS_BTREE_KTRACE_ARGIPR, line,
+		i, d >> 32, (int)d, l0 >> 32,
+		(int)l0, l1 >> 32, (int)l1, l2 >> 32,
+		(int)l2, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for arguments, for int, key.
+ */
+STATIC void
+xfs_btree_trace_argik(
+	const char		*func,
+	xfs_btree_cur_t		*cur,
+	int			i,
+	xfs_btree_key_t		*k,
+	int			line)
+{
+	__uint64_t		v = 0;
+
+	if (XFS_BTREE_LONG_PTRS(cur->bc_btnum))
+		v = be64_to_cpu(k->u.l);
+	else
+		v = be32_to_cpu(k->u.s);
+
+	cur->bc_trcops->trace(func, cur, XBT_ARGS, XFS_BTREE_KTRACE_ARGIPK, line,
+		i, 0, 0, v >> 32, (int)v,
+		0, 0, 0,
+		0, 0, 0);
+}
+
+/*
+ * Add a trace buffer entry for the cursor/operation.
+ */
+STATIC void
+xfs_btree_trace_cursor(
+	const char	*func,
+	xfs_btree_cur_t	*cur,
+	char		*s,
+	int		line)
+{
+	__uint32_t	s0 = 0;
+	__uint64_t	l0 = 0, l1 = 0;
+
+	if (cur->bc_trcops->cursor)
+		cur->bc_trcops->cursor(cur, &s0, &l0, &l1);
+
+	cur->bc_trcops->enter(func, cur, s, XFS_BTREE_KTRACE_CUR, line,
+		(cur->bc_nlevels << 24) | s0,
+		l0 >> 32, (int)l0,
+		l1 >> 32, (int)l1,
+		(unsigned long)cur->bc_bufs[0], (unsigned long)cur->bc_bufs[1],
+		(unsigned long)cur->bc_bufs[2], (unsigned long)cur->bc_bufs[3],
+		(cur->bc_ptrs[0] << 16) | cur->bc_ptrs[1],
+		(cur->bc_ptrs[2] << 16) | cur->bc_ptrs[3]);
+}
+
+
+
Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.c	2007-10-16 08:52:58.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c	2007-11-06 19:40:29.762667351 +1100
@@ -322,7 +322,7 @@ xfs_ialloc_ag_alloc(
 			return error;
 		}
 		ASSERT(i == 0);
-		if ((error = xfs_inobt_insert(cur, &i))) {
+		if ((error = xfs_btree_insert(cur, &i))) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 			return error;
 		}
@@ -673,7 +673,7 @@ nextag:
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			freecount += rec.ir_freecount;
-			if ((error = xfs_inobt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto error0;
 		} while (i == 1);
 
@@ -717,7 +717,7 @@ nextag:
 			/*
 			 * Search left with tcur, back up 1 record.
 			 */
-			if ((error = xfs_inobt_decrement(tcur, 0, &i)))
+			if ((error = xfs_btree_decrement(tcur, 0, &i)))
 				goto error1;
 			doneleft = !i;
 			if (!doneleft) {
@@ -731,7 +731,7 @@ nextag:
 			/*
 			 * Search right with cur, go forward 1 record.
 			 */
-			if ((error = xfs_inobt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto error1;
 			doneright = !i;
 			if (!doneright) {
@@ -793,7 +793,7 @@ nextag:
 				 * further left.
 				 */
 				if (useleft) {
-					if ((error = xfs_inobt_decrement(tcur, 0,
+					if ((error = xfs_btree_decrement(tcur, 0,
 							&i)))
 						goto error1;
 					doneleft = !i;
@@ -813,7 +813,7 @@ nextag:
 				 * further right.
 				 */
 				else {
-					if ((error = xfs_inobt_increment(cur, 0,
+					if ((error = xfs_btree_increment(cur, 0,
 							&i)))
 						goto error1;
 					doneright = !i;
@@ -868,7 +868,7 @@ nextag:
 				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 				if (rec.ir_freecount > 0)
 					break;
-				if ((error = xfs_inobt_increment(cur, 0, &i)))
+				if ((error = xfs_btree_increment(cur, 0, &i)))
 					goto error0;
 				XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			}
@@ -902,7 +902,7 @@ nextag:
 				goto error0;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			freecount += rec.ir_freecount;
-			if ((error = xfs_inobt_increment(cur, 0, &i)))
+			if ((error = xfs_btree_increment(cur, 0, &i)))
 				goto error0;
 		} while (i == 1);
 		ASSERT(freecount == be32_to_cpu(agi->agi_freecount) ||
@@ -1012,7 +1012,7 @@ xfs_difree(
 				goto error0;
 			if (i) {
 				freecount += rec.ir_freecount;
-				if ((error = xfs_inobt_increment(cur, 0, &i)))
+				if ((error = xfs_btree_increment(cur, 0, &i)))
 					goto error0;
 			}
 		} while (i == 1);
@@ -1074,8 +1074,8 @@ xfs_difree(
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
 
-		if ((error = xfs_inobt_delete(cur, &i))) {
-			cmn_err(CE_WARN, "xfs_difree: xfs_inobt_delete returned an error %d on %s.\n",
+		if ((error = xfs_btree_delete(cur, &i))) {
+			cmn_err(CE_WARN, "xfs_difree: xfs_btree_delete returned an error %d on %s.\n",
 				error, mp->m_fsname);
 			goto error0;
 		}
@@ -1117,7 +1117,7 @@ xfs_difree(
 				goto error0;
 			if (i) {
 				freecount += rec.ir_freecount;
-				if ((error = xfs_inobt_increment(cur, 0, &i)))
+				if ((error = xfs_btree_increment(cur, 0, &i)))
 					goto error0;
 			}
 		} while (i == 1);
Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc_btree.c	2007-06-05 22:12:50.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc_btree.c	2007-11-06 19:40:29.770666321 +1100
@@ -39,711 +39,132 @@
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 
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
 
 /*
- * Single level of the xfs_inobt_delete record deletion routine.
- * Delete record pointed to by cur/level.
- * Remove the record from its block then rebalance the tree.
- * Return 0 for error, 1 for done, 2 to go on to the next level.
+ * Get the block pointer for the given level of the cursor.
+ * Fill in the buffer pointer, if applicable.
  */
-STATIC int				/* error */
-xfs_inobt_delrec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level removing record from */
-	int			*stat)	/* fail/done/go-on */
+STATIC xfs_btree_block_t *
+xfs_inobt_get_block(
+	xfs_btree_cur_t		*cur,
+	int			level,
+	xfs_buf_t		**bpp)
 {
-	xfs_buf_t		*agbp;	/* buffer for a.g. inode header */
-	xfs_mount_t		*mp;	/* mount structure */
-	xfs_agi_t		*agi;	/* allocation group inode header */
-	xfs_inobt_block_t	*block;	/* btree block record/key lives in */
-	xfs_agblock_t		bno;	/* btree block number */
-	xfs_buf_t		*bp;	/* buffer for block */
-	int			error;	/* error return value */
-	int			i;	/* loop index */
-	xfs_inobt_key_t		key;	/* kp points here if block is level 0 */
-	xfs_inobt_key_t		*kp = NULL;	/* pointer to btree keys */
-	xfs_agblock_t		lbno;	/* left block's block number */
-	xfs_buf_t		*lbp;	/* left block's buffer pointer */
-	xfs_inobt_block_t	*left;	/* left btree block */
-	xfs_inobt_key_t		*lkp;	/* left block key pointer */
-	xfs_inobt_ptr_t		*lpp;	/* left block address pointer */
-	int			lrecs = 0;	/* number of records in left block */
-	xfs_inobt_rec_t		*lrp;	/* left block record pointer */
-	xfs_inobt_ptr_t		*pp = NULL;	/* pointer to btree addresses */
-	int			ptr;	/* index in btree block for this rec */
-	xfs_agblock_t		rbno;	/* right block's block number */
-	xfs_buf_t		*rbp;	/* right block's buffer pointer */
-	xfs_inobt_block_t	*right;	/* right btree block */
-	xfs_inobt_key_t		*rkp;	/* right block key pointer */
-	xfs_inobt_rec_t		*rp;	/* pointer to btree records */
-	xfs_inobt_ptr_t		*rpp;	/* right block address pointer */
-	int			rrecs = 0;	/* number of records in right block */
-	int			numrecs;
-	xfs_inobt_rec_t		*rrp;	/* right block record pointer */
-	xfs_btree_cur_t		*tcur;	/* temporary btree cursor */
+	ASSERT(level < cur->bc_nlevels);
+	*bpp = cur->bc_bufs[level];
+	return (xfs_btree_block_t *)XFS_BUF_TO_INOBT_BLOCK(*bpp);
+}
 
-	mp = cur->bc_mp;
 
-	/*
-	 * Get the index of the entry being deleted, check for nothing there.
-	 */
-	ptr = cur->bc_ptrs[level];
-	if (ptr == 0) {
-		*stat = 0;
-		return 0;
-	}
-
-	/*
-	 * Get the buffer & block containing the record or key/ptr.
-	 */
-	bp = cur->bc_bufs[level];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
-		return error;
-#endif
-	/*
-	 * Fail if we're off the end of the block.
-	 */
+STATIC int
+xfs_inobt_get_buf(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr,
+	int		flags,
+	xfs_buf_t	**bpp)
+{
+	xfs_buf_t	*bp;
 
-	numrecs = be16_to_cpu(block->bb_numrecs);
-	if (ptr > numrecs) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * It's a nonleaf.  Excise the key and ptr being deleted, by
-	 * sliding the entries past them down one.
-	 * Log the changed areas of the block.
-	 */
-	if (level > 0) {
-		kp = XFS_INOBT_KEY_ADDR(block, 1, cur);
-		pp = XFS_INOBT_PTR_ADDR(block, 1, cur);
-#ifdef DEBUG
-		for (i = ptr; i < numrecs; i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(pp[i]), level)))
-				return error;
-		}
-#endif
-		if (ptr < numrecs) {
-			memmove(&kp[ptr - 1], &kp[ptr],
-				(numrecs - ptr) * sizeof(*kp));
-			memmove(&pp[ptr - 1], &pp[ptr],
-				(numrecs - ptr) * sizeof(*kp));
-			xfs_inobt_log_keys(cur, bp, ptr, numrecs - 1);
-			xfs_inobt_log_ptrs(cur, bp, ptr, numrecs - 1);
-		}
-	}
-	/*
-	 * It's a leaf.  Excise the record being deleted, by sliding the
-	 * entries past it down one.  Log the changed areas of the block.
-	 */
-	else {
-		rp = XFS_INOBT_REC_ADDR(block, 1, cur);
-		if (ptr < numrecs) {
-			memmove(&rp[ptr - 1], &rp[ptr],
-				(numrecs - ptr) * sizeof(*rp));
-			xfs_inobt_log_recs(cur, bp, ptr, numrecs - 1);
-		}
-		/*
-		 * If it's the first record in the block, we'll need a key
-		 * structure to pass up to the next level (updkey).
-		 */
-		if (ptr == 1) {
-			key.ir_startino = rp->ir_startino;
-			kp = &key;
-		}
-	}
-	/*
-	 * Decrement and log the number of entries in the block.
-	 */
-	numrecs--;
-	block->bb_numrecs = cpu_to_be16(numrecs);
-	xfs_inobt_log_block(cur->bc_tp, bp, XFS_BB_NUMRECS);
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
-			agbp = cur->bc_private.i.agbp;
-			agi = XFS_BUF_TO_AGI(agbp);
-			/*
-			 * pp is still set to the first pointer in the block.
-			 * Make it the new root of the btree.
-			 */
-			bno = be32_to_cpu(agi->agi_root);
-			agi->agi_root = *pp;
-			be32_add(&agi->agi_level, -1);
-			/*
-			 * Free the block.
-			 */
-			if ((error = xfs_free_extent(cur->bc_tp,
-				XFS_AGB_TO_FSB(mp, cur->bc_private.i.agno, bno), 1)))
-				return error;
-			xfs_trans_binval(cur->bc_tp, bp);
-			xfs_ialloc_log_agi(cur->bc_tp, agbp,
-				XFS_AGI_ROOT | XFS_AGI_LEVEL);
-			/*
-			 * Update the cursor so there's one fewer level.
-			 */
-			cur->bc_bufs[level] = NULL;
-			cur->bc_nlevels--;
-		} else if (level > 0 &&
-			   (error = xfs_inobt_decrement(cur, level, &i)))
-			return error;
-		*stat = 1;
-		return 0;
-	}
-	/*
-	 * If we deleted the leftmost entry in the block, update the
-	 * key values above us in the tree.
-	 */
-	if (ptr == 1 && (error = xfs_inobt_updkey(cur, kp, level + 1)))
-		return error;
-	/*
-	 * If the number of records remaining in the block is at least
-	 * the minimum, we're done.
-	 */
-	if (numrecs >= XFS_INOBT_BLOCK_MINRECS(level, cur)) {
-		if (level > 0 &&
-		    (error = xfs_inobt_decrement(cur, level, &i)))
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
-		if ((error = xfs_inobt_increment(tcur, level, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		/*
-		 * Grab a pointer to the block.
-		 */
-		rbp = tcur->bc_bufs[level];
-		right = XFS_BUF_TO_INOBT_BLOCK(rbp);
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
-		     XFS_INOBT_BLOCK_MINRECS(level, cur)) {
-			if ((error = xfs_inobt_lshift(tcur, level, &i)))
-				goto error0;
-			if (i) {
-				ASSERT(be16_to_cpu(block->bb_numrecs) >=
-				       XFS_INOBT_BLOCK_MINRECS(level, cur));
-				xfs_btree_del_cursor(tcur,
-						     XFS_BTREE_NOERROR);
-				if (level > 0 &&
-				    (error = xfs_inobt_decrement(cur, level,
-						&i)))
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
-			xfs_btree_firstrec(tcur, level);
-			if ((error = xfs_inobt_decrement(tcur, level, &i)))
-				goto error0;
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
-		xfs_btree_firstrec(tcur, level);
-		if ((error = xfs_inobt_decrement(tcur, level, &i)))
-			goto error0;
-		xfs_btree_firstrec(tcur, level);
-		/*
-		 * Grab a pointer to the block.
-		 */
-		lbp = tcur->bc_bufs[level];
-		left = XFS_BUF_TO_INOBT_BLOCK(lbp);
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
-		     XFS_INOBT_BLOCK_MINRECS(level, cur)) {
-			if ((error = xfs_inobt_rshift(tcur, level, &i)))
-				goto error0;
-			if (i) {
-				ASSERT(be16_to_cpu(block->bb_numrecs) >=
-				       XFS_INOBT_BLOCK_MINRECS(level, cur));
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
-	    lrecs + numrecs <= XFS_INOBT_BLOCK_MAXRECS(level, cur)) {
-		/*
-		 * Set "right" to be the starting block,
-		 * "left" to be the left neighbor.
-		 */
-		rbno = bno;
-		right = block;
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		rbp = bp;
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.i.agno, lbno, 0, &lbp,
-				XFS_INO_BTREE_REF)))
-			return error;
-		left = XFS_BUF_TO_INOBT_BLOCK(lbp);
-		lrecs = be16_to_cpu(left->bb_numrecs);
-		if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
-			return error;
-	}
-	/*
-	 * If that won't work, see if we can join with the right neighbor block.
-	 */
-	else if (rbno != NULLAGBLOCK &&
-		 rrecs + numrecs <= XFS_INOBT_BLOCK_MAXRECS(level, cur)) {
-		/*
-		 * Set "left" to be the starting block,
-		 * "right" to be the right neighbor.
-		 */
-		lbno = bno;
-		left = block;
-		lrecs = be16_to_cpu(left->bb_numrecs);
-		lbp = bp;
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.i.agno, rbno, 0, &rbp,
-				XFS_INO_BTREE_REF)))
-			return error;
-		right = XFS_BUF_TO_INOBT_BLOCK(rbp);
-		rrecs = be16_to_cpu(right->bb_numrecs);
-		if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
-			return error;
-	}
-	/*
-	 * Otherwise, we can't fix the imbalance.
-	 * Just return.  This is probably a logic error, but it's not fatal.
-	 */
-	else {
-		if (level > 0 && (error = xfs_inobt_decrement(cur, level, &i)))
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
-		lkp = XFS_INOBT_KEY_ADDR(left, lrecs + 1, cur);
-		lpp = XFS_INOBT_PTR_ADDR(left, lrecs + 1, cur);
-		rkp = XFS_INOBT_KEY_ADDR(right, 1, cur);
-		rpp = XFS_INOBT_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
-		for (i = 0; i < rrecs; i++) {
-			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i]), level)))
-				return error;
-		}
-#endif
-		memcpy(lkp, rkp, rrecs * sizeof(*lkp));
-		memcpy(lpp, rpp, rrecs * sizeof(*lpp));
-		xfs_inobt_log_keys(cur, lbp, lrecs + 1, lrecs + rrecs);
-		xfs_inobt_log_ptrs(cur, lbp, lrecs + 1, lrecs + rrecs);
-	} else {
-		/*
-		 * It's a leaf.  Move records.
-		 */
-		lrp = XFS_INOBT_REC_ADDR(left, lrecs + 1, cur);
-		rrp = XFS_INOBT_REC_ADDR(right, 1, cur);
-		memcpy(lrp, rrp, rrecs * sizeof(*lrp));
-		xfs_inobt_log_recs(cur, lbp, lrecs + 1, lrecs + rrecs);
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
-	xfs_inobt_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
-	/*
-	 * If there is a right sibling now, make it point to the
-	 * remaining block.
-	 */
-	if (be32_to_cpu(left->bb_rightsib) != NULLAGBLOCK) {
-		xfs_inobt_block_t	*rrblock;
-		xfs_buf_t		*rrbp;
-
-		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
-				cur->bc_private.i.agno, be32_to_cpu(left->bb_rightsib), 0,
-				&rrbp, XFS_INO_BTREE_REF)))
-			return error;
-		rrblock = XFS_BUF_TO_INOBT_BLOCK(rrbp);
-		if ((error = xfs_btree_check_sblock(cur, rrblock, level, rrbp)))
-			return error;
-		rrblock->bb_leftsib = cpu_to_be32(lbno);
-		xfs_inobt_log_block(cur->bc_tp, rrbp, XFS_BB_LEFTSIB);
-	}
-	/*
-	 * Free the deleting block.
-	 */
-	if ((error = xfs_free_extent(cur->bc_tp, XFS_AGB_TO_FSB(mp,
-				     cur->bc_private.i.agno, rbno), 1)))
-		return error;
-	xfs_trans_binval(cur->bc_tp, rbp);
-	/*
-	 * Readjust the ptr at this level if it's not a leaf, since it's
-	 * still pointing at the deletion point, which makes the cursor
-	 * inconsistent.  If this makes the ptr 0, the caller fixes it up.
-	 * We can't use decrement because it would change the next level up.
-	 */
-	if (level > 0)
-		cur->bc_ptrs[level]--;
-	/*
-	 * Return value means the next level up has something to do.
-	 */
-	*stat = 2;
+	bp = xfs_btree_get_bufs(cur->bc_mp, cur->bc_tp, cur->bc_private.i.agno,
+				be32_to_cpu(ptr->u.inobt), flags);
+	*bpp = bp;
 	return 0;
 
-error0:
-	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
-	return error;
 }
 
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
+STATIC int
+xfs_inobt_read_buf(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr,
+	int		flags,
+	xfs_buf_t	**bpp)
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
+	return xfs_btree_read_bufs(cur->bc_mp,
+				cur->bc_tp, cur->bc_private.i.agno,
+				be32_to_cpu(ptr->u.inobt), flags,
+				bpp, XFS_INO_BTREE_REF);
+}
 
-	/*
-	 * GCC doesn't understand the (arguably complex) control flow in
-	 * this function and complains about uninitialized structure fields
-	 * without this.
-	 */
-	memset(&nrec, 0, sizeof(nrec));
+STATIC xfs_btree_block_t *
+xfs_inobt_buf_to_block(
+	xfs_btree_cur_t	*cur,
+	xfs_buf_t	*bp)
+{
+	/* XFS_BUF_TO_INOBT_BLOCK(rbp); */
+	return XFS_BUF_TO_BLOCK(bp);
+}
 
-	/*
-	 * If we made it to the root level, allocate a new root block
-	 * and we're done.
-	 */
-	if (level >= cur->bc_nlevels) {
-		error = xfs_inobt_newroot(cur, &i);
-		*bnop = NULLAGBLOCK;
-		*stat = i;
+STATIC void
+xfs_inobt_buf_to_ptr(
+	xfs_btree_cur_t	*cur,
+	xfs_buf_t	*bp,
+	xfs_btree_ptr_t	*ptr)
+{
+	ptr->u.inobt = cpu_to_be32(XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(bp)));
+}
+
+STATIC int
+xfs_inobt_alloc_block(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*start,
+	xfs_btree_ptr_t	*new,
+	int		length,
+	int		*stat)
+{
+	xfs_alloc_arg_t		args;		/* block allocation args */
+	int			error;		/* error return value */
+	xfs_agblock_t		sbno = be32_to_cpu(start->u.inobt);
+
+	XFS_BTREE_TRACE_CURSOR(cur, ENTRY);
+	memset(&args, 0, sizeof(args));
+	args.tp = cur->bc_tp;
+	args.mp = cur->bc_mp;
+	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.i.agno, sbno);
+	args.mod = args.minleft = args.alignment = args.total = args.wasdel =
+		args.isfl = args.userdata = args.minalignslop = 0;
+	args.minlen = args.maxlen = args.prod = 1;
+	args.type = XFS_ALLOCTYPE_NEAR_BNO;
+
+	error = xfs_alloc_vextent(&args);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, ERROR);
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
+		XFS_BTREE_TRACE_CURSOR(cur, EXIT);
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
+	XFS_BTREE_TRACE_CURSOR(cur, EXIT);
+
+	new->u.inobt = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
 	*stat = 1;
 	return 0;
 }
 
+STATIC int
+xfs_inobt_free_block(
+	xfs_btree_cur_t	*cur,
+	xfs_buf_t	*bp,
+	int		size)
+{
+	int		error;
+
+	error = xfs_free_extent(cur->bc_tp,
+			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1);
+	if (error)
+		return error;
+	xfs_trans_binval(cur->bc_tp, bp);
+	return 0;
+}
+
 /*
- * Log header fields from a btree block.
+ * Log fields from the btree block header.
  */
 STATIC void
 xfs_inobt_log_block(
-	xfs_trans_t		*tp,	/* transaction pointer */
+	xfs_btree_cur_t		*cur,	/* btree cursor */
 	xfs_buf_t		*bp,	/* buffer containing btree block */
 	int			fields)	/* mask of fields: XFS_BB_... */
 {
@@ -758,1218 +179,514 @@ xfs_inobt_log_block(
 		sizeof(xfs_inobt_block_t)
 	};
 
+	XFS_BTREE_TRACE_CURSOR(cur, ENTRY);
+	XFS_BTREE_TRACE_ARGBI(cur, bp, fields);
 	xfs_btree_offsets(fields, offsets, XFS_BB_NUM_BITS, &first, &last);
-	xfs_trans_log_buf(tp, bp, first, last);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	XFS_BTREE_TRACE_CURSOR(cur, EXIT);
 }
 
-/*
- * Log keys from a btree block (nonleaf).
- */
-STATIC void
-xfs_inobt_log_keys(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			kfirst,	/* index of first key to log */
-	int			klast)	/* index of last key to log */
+static const struct xfs_btree_block_ops xfs_inobt_blkops = {
+	.get_buf	= xfs_inobt_get_buf,
+	.read_buf	= xfs_inobt_read_buf,
+	.get_block	= xfs_inobt_get_block,
+	.buf_to_block	= xfs_inobt_buf_to_block,
+	.buf_to_ptr	= xfs_inobt_buf_to_ptr,
+	.log_block	= xfs_inobt_log_block,
+	.check_block	= xfs_btree_check_sblock,
+
+	.alloc_block	= xfs_inobt_alloc_block,
+	.free_block	= xfs_inobt_free_block,
+
+	.get_sibling	= xfs_btree_get_ssibling,
+	.set_sibling	= xfs_btree_set_ssibling,
+	.init_sibling	= xfs_btree_init_sibling,
+};
+
+STATIC int
+xfs_inobt_get_minrecs(
+	xfs_btree_cur_t	*cur,
+	int		lev)
 {
-	xfs_inobt_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	xfs_inobt_key_t		*kp;	/* key pointer in btree block */
-	int			last;	/* last byte offset logged */
+	return cur->bc_mp->m_inobt_mnr[lev != 0];
+}
 
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	kp = XFS_INOBT_KEY_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+STATIC int
+xfs_inobt_get_maxrecs(
+	xfs_btree_cur_t	*cur,
+	int		lev)
+{
+	return cur->bc_mp->m_inobt_mxr[lev != 0];
+}
+
+STATIC int
+xfs_btree_get_numrecs(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block)
+{
+	return be16_to_cpu(block->bb_h.bb_numrecs);
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
+xfs_btree_set_numrecs(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_block_t	*block,
+	int			numrecs)
 {
-	xfs_inobt_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	xfs_inobt_ptr_t		*pp;	/* block-pointer pointer in btree blk */
+	block->bb_h.bb_numrecs = cpu_to_be16(numrecs);
+}
 
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	pp = XFS_INOBT_PTR_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+STATIC void
+xfs_inobt_init_key_from_rec(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_key_t	*key,
+	xfs_btree_rec_t	*rec)
+{
+	key->u.inobt.ir_startino = rec->u.inobt.ir_startino;
 }
 
 /*
- * Log records from a btree block (leaf).
+ * intial value of ptr for lookup
  */
 STATIC void
-xfs_inobt_log_recs(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_buf_t		*bp,	/* buffer containing btree block */
-	int			rfirst,	/* index of first record to log */
-	int			rlast)	/* index of last record to log */
+xfs_inobt_init_ptr_from_cur(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr)
 {
-	xfs_inobt_block_t	*block;	/* btree block to log from */
-	int			first;	/* first byte offset logged */
-	int			last;	/* last byte offset logged */
-	xfs_inobt_rec_t		*rp;	/* record pointer for btree block */
+	xfs_agi_t	*agi;	/* a.g. inode header */
 
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-	rp = XFS_INOBT_REC_ADDR(block, 1, cur);
-	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
-	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
-	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	agi = XFS_BUF_TO_AGI(cur->bc_private.i.agbp);
+	ASSERT(cur->bc_private.i.agno == be32_to_cpu(agi->agi_seqno));
+
+	ptr->u.inobt = agi->agi_root;
 }
 
-/*
- * Lookup the record.  The cursor is made to point to it, based on dir.
- * Return 0 if can't find any such record, 1 for success.
- */
-STATIC int				/* error */
-xfs_inobt_lookup(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_lookup_t		dir,	/* <=, ==, or >= */
-	int			*stat)	/* success/failure */
+STATIC void
+xfs_inobt_init_rec_from_key(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_key_t	*key,
+	xfs_btree_rec_t	*rec)
 {
-	xfs_agblock_t		agbno;	/* a.g. relative btree block number */
-	xfs_agnumber_t		agno;	/* allocation group number */
-	xfs_inobt_block_t	*block=NULL;	/* current btree block */
-	__int64_t		diff;	/* difference for the current key */
-	int			error;	/* error return value */
-	int			keyno=0;	/* current key number */
-	int			level;	/* level in the btree */
-	xfs_mount_t		*mp;	/* file system mount point */
-
-	/*
-	 * Get the allocation group header, and the root block number.
-	 */
-	mp = cur->bc_mp;
-	{
-		xfs_agi_t	*agi;	/* a.g. inode header */
-
-		agi = XFS_BUF_TO_AGI(cur->bc_private.i.agbp);
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
+	rec->u.inobt.ir_startino = key->u.inobt.ir_startino;
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
+STATIC void
+xfs_inobt_init_rec_from_cur(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_rec_t	*rec)
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
+	rec->u.inobt.ir_startino = cpu_to_be32(cur->bc_rec.i.ir_startino);
+	rec->u.inobt.ir_freecount = cpu_to_be32(cur->bc_rec.i.ir_freecount);
+	rec->u.inobt.ir_free = cpu_to_be64(cur->bc_rec.i.ir_free);
+}
 
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
-			cur->bc_private.i.agno, be32_to_cpu(right->bb_leftsib),
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
-	be16_add(&left->bb_numrecs, 1);
-	xfs_inobt_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-#ifdef DEBUG
-	if (level > 0)
-		xfs_btree_check_key(cur->bc_btnum, lkp - 1, lkp);
-	else
-		xfs_btree_check_rec(cur->bc_btnum, lrp - 1, lrp);
-#endif
-	be16_add(&right->bb_numrecs, -1);
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
+STATIC xfs_btree_key_t *
+xfs_inobt_key_addr(
+	xfs_btree_cur_t		*cur,
+	int			index,
+	xfs_btree_block_t	*block)
+{
+	return (xfs_btree_key_t *)XFS_INOBT_KEY_ADDR(&block->bb_h, index, cur);
 }
 
-/*
- * Allocate a new root block, fill it in.
- */
-STATIC int				/* error */
-xfs_inobt_newroot(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			*stat)	/* success/failure */
+STATIC xfs_btree_ptr_t *
+xfs_inobt_ptr_addr(
+	xfs_btree_cur_t		*cur,
+	int			index,
+	xfs_btree_block_t	*block)
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
+	return (xfs_btree_ptr_t *)XFS_INOBT_PTR_ADDR(&block->bb_h, index, cur);
+}
 
-	ASSERT(cur->bc_nlevels < XFS_IN_MAXLEVELS(cur->bc_mp));
+STATIC xfs_btree_rec_t *
+xfs_inobt_rec_addr(
+	xfs_btree_cur_t		*cur,
+	int			index,
+	xfs_btree_block_t	*block)
+{
+	return (xfs_btree_rec_t *)XFS_INOBT_REC_ADDR(&block->bb_h, index, cur);
+}
 
-	/*
-	 * Get a block & a buffer.
-	 */
-	agi = XFS_BUF_TO_AGI(cur->bc_private.i.agbp);
-	args.tp = cur->bc_tp;
-	args.mp = cur->bc_mp;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.i.agno,
-		be32_to_cpu(agi->agi_root));
-	args.mod = args.minleft = args.alignment = args.total = args.wasdel =
-		args.isfl = args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	if ((error = xfs_alloc_vextent(&args)))
-		return error;
-	/*
-	 * None available, we fail.
-	 */
-	if (args.fsbno == NULLFSBLOCK) {
-		*stat = 0;
-		return 0;
-	}
-	ASSERT(args.len == 1);
-	nbp = xfs_btree_get_bufs(args.mp, args.tp, args.agno, args.agbno, 0);
-	new = XFS_BUF_TO_INOBT_BLOCK(nbp);
-	/*
-	 * Set the root data in the a.g. inode structure.
-	 */
-	agi->agi_root = cpu_to_be32(args.agbno);
-	be32_add(&agi->agi_level, 1);
-	xfs_ialloc_log_agi(args.tp, cur->bc_private.i.agbp,
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
+STATIC int64_t
+xfs_inobt_key_diff(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_key_t		*key)
+{
+	return (int64_t)(be32_to_cpu(key->u.inobt.ir_startino)) -
+						cur->bc_rec.i.ir_startino;
 }
 
-/*
- * Move 1 record right from cur/level if possible.
- * Update cur to reflect the new path.
- */
-STATIC int				/* error */
-xfs_inobt_rshift(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level to shift record on */
-	int			*stat)	/* success/failure */
+STATIC xfs_daddr_t
+xfs_inobt_ptr_to_daddr(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_ptr_t		*ptr)
 {
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
+	return XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.i.agno,
+						be32_to_cpu(ptr->u.inobt));
+}
 
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
-			cur->bc_private.i.agno, be32_to_cpu(left->bb_rightsib),
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
+STATIC void
+xfs_inobt_move_keys(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_key_t		*src_key,
+	xfs_btree_key_t		*dst_key,
+	int			from,
+	int			to,
+	int			numkeys)
+{
+	if (dst_key == NULL) {
+		/* moving within a block */
+		xfs_inobt_key_t	*kp = &src_key->u.inobt;
+		memmove(&kp[to], &kp[from], numkeys * sizeof(*kp));
 	} else {
-		lrp = XFS_INOBT_REC_ADDR(left, be16_to_cpu(left->bb_numrecs), cur);
-		rrp = XFS_INOBT_REC_ADDR(right, 1, cur);
-		memmove(rrp + 1, rrp, be16_to_cpu(right->bb_numrecs) * sizeof(*rrp));
-		*rrp = *lrp;
-		xfs_inobt_log_recs(cur, rbp, 1, be16_to_cpu(right->bb_numrecs) + 1);
-		key.ir_startino = rrp->ir_startino;
-		rkp = &key;
+		/* moving between blocks */
+		memcpy(dst_key, src_key, numkeys * sizeof(xfs_inobt_key_t));
 	}
-	/*
-	 * Decrement and log left's numrecs, bump and log right's numrecs.
-	 */
-	be16_add(&left->bb_numrecs, -1);
-	xfs_inobt_log_block(cur->bc_tp, lbp, XFS_BB_NUMRECS);
-	be16_add(&right->bb_numrecs, 1);
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
-	return 0;
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
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.i.agno, lbno);
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
-		be16_add(&right->bb_numrecs, 1);
-	i = be16_to_cpu(left->bb_numrecs) - be16_to_cpu(right->bb_numrecs) + 1;
-	/*
-	 * For non-leaf blocks, copy keys and addresses over to the new block.
-	 */
-	if (level > 0) {
-		lkp = XFS_INOBT_KEY_ADDR(left, i, cur);
-		lpp = XFS_INOBT_PTR_ADDR(left, i, cur);
-		rkp = XFS_INOBT_KEY_ADDR(right, 1, cur);
-		rpp = XFS_INOBT_PTR_ADDR(right, 1, cur);
-#ifdef DEBUG
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
-	be16_add(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
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
+STATIC void
+xfs_inobt_move_ptrs(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_ptr_t		*src_ptr,
+	xfs_btree_ptr_t		*dst_ptr,
+	int			from,
+	int			to,
+	int			numptrs)
+{
+	if (dst_ptr == NULL) {
+		/* moving within a block */
+		xfs_inobt_ptr_t	*pp = &src_ptr->u.inobt;
+		memmove(&pp[to], &pp[from], numptrs * sizeof(*pp));
+	} else {
+		/* moving between blocks */
+		memcpy(dst_ptr, src_ptr, numptrs * sizeof(xfs_inobt_ptr_t));
 	}
-	/*
-	 * If there are more levels, we'll need another cursor which refers
-	 * the right block, no matter where this cursor was.
-	 */
-	if (level + 1 < cur->bc_nlevels) {
-		if ((error = xfs_btree_dup_cursor(cur, curp)))
-			return error;
-		(*curp)->bc_ptrs[level + 1]++;
+}
+
+STATIC void
+xfs_inobt_move_recs(
+	xfs_btree_cur_t		*cur,
+	xfs_btree_rec_t		*src_rec,
+	xfs_btree_rec_t		*dst_rec,
+	int			from,
+	int			to,
+	int			numrecs)
+{
+	if (dst_rec == NULL) {
+		/* moving within a block */
+		xfs_inobt_rec_t	*rp = &src_rec->u.inobt;
+		memmove(&rp[to], &rp[from], numrecs * sizeof(*rp));
+	} else {
+		/* moving between blocks */
+		memcpy(dst_rec, src_rec, numrecs * sizeof(xfs_inobt_rec_t));
 	}
-	*bnop = args.agbno;
-	*stat = 1;
-	return 0;
 }
 
-/*
- * Update keys at all levels from here to the root along the cursor's path.
- */
-STATIC int				/* error */
-xfs_inobt_updkey(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_inobt_key_t		*keyp,	/* new key value to update to */
-	int			level)	/* starting level for update */
+
+STATIC void
+xfs_inobt_set_key(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_key_t	*key_addr,
+	int		index,
+	xfs_btree_key_t	*newkey)
 {
-	int			ptr;	/* index of key in block */
+	xfs_inobt_key_t	*kp = &key_addr->u.inobt;
 
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
+	kp[index] = newkey->u.inobt;
+}
 
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
+xfs_inobt_set_ptr(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*ptr_addr,
+	int		index,
+	xfs_btree_ptr_t	*newptr)
+{
+	xfs_inobt_ptr_t	*pp = &ptr_addr->u.inobt;
+
+	pp[index] = newptr->u.inobt;
 }
 
-/*
- * Externally visible routines.
- */
+STATIC void
+xfs_inobt_set_rec(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_rec_t	*rec_addr,
+	int		index,
+	xfs_btree_rec_t	*newrec)
+{
+	xfs_inobt_rec_t	*rp = &rec_addr->u.inobt;
+
+	rp[index] = newrec->u.inobt;
+}
 
 /*
- * Decrement cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
+ * Log keys from a btree block (nonleaf).
  */
-int					/* error */
-xfs_inobt_decrement(
+STATIC void
+xfs_inobt_log_keys(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree, 0 is leaf */
-	int			*stat)	/* success/failure */
+	xfs_buf_t		*bp,	/* buffer containing btree block */
+	int			kfirst,	/* index of first key to log */
+	int			klast)	/* index of last key to log */
 {
-	xfs_inobt_block_t	*block;	/* btree block */
-	int			error;
-	int			lev;	/* btree level */
+	xfs_inobt_block_t	*block;	/* btree block to log from */
+	int			first;	/* first byte offset logged */
+	xfs_inobt_key_t		*kp;	/* key pointer in btree block */
+	int			last;	/* last byte offset logged */
 
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
-				cur->bc_private.i.agno, agbno, 0, &bp,
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
+	XFS_BTREE_TRACE_CURSOR(cur, ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, kfirst, klast);
+	block = XFS_BUF_TO_INOBT_BLOCK(bp);
+	kp = XFS_INOBT_KEY_ADDR(block, 1, cur);
+	first = (int)((xfs_caddr_t)&kp[kfirst - 1] - (xfs_caddr_t)block);
+	last = (int)(((xfs_caddr_t)&kp[klast] - 1) - (xfs_caddr_t)block);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	XFS_BTREE_TRACE_CURSOR(cur, EXIT);
 }
 
 /*
- * Delete the record pointed to by cur.
- * The cursor refers to the place where the record was (could be inserted)
- * when the operation returns.
+ * Log block pointer fields from a btree block (nonleaf).
  */
-int					/* error */
-xfs_inobt_delete(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		*stat)		/* success/failure */
+STATIC void
+xfs_inobt_log_ptrs(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_buf_t		*bp,	/* buffer containing btree block */
+	int			pfirst,	/* index of first pointer to log */
+	int			plast)	/* index of last pointer to log */
 {
-	int		error;
-	int		i;		/* result code */
-	int		level;		/* btree level */
+	xfs_inobt_block_t	*block;	/* btree block to log from */
+	int			first;	/* first byte offset logged */
+	int			last;	/* last byte offset logged */
+	xfs_inobt_ptr_t		*pp;	/* block-pointer pointer in btree blk */
 
-	/*
-	 * Go up the tree, starting at leaf level.
-	 * If 2 is returned then a join was done; go to the next level.
-	 * Otherwise we are done.
-	 */
-	for (level = 0, i = 2; i == 2; level++) {
-		if ((error = xfs_inobt_delrec(cur, level, &i)))
-			return error;
-	}
-	if (i == 0) {
-		for (level = 1; level < cur->bc_nlevels; level++) {
-			if (cur->bc_ptrs[level] == 0) {
-				if ((error = xfs_inobt_decrement(cur, level, &i)))
-					return error;
-				break;
-			}
-		}
-	}
-	*stat = i;
-	return 0;
+	XFS_BTREE_TRACE_CURSOR(cur, ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, pfirst, plast);
+	block = XFS_BUF_TO_INOBT_BLOCK(bp);
+	pp = XFS_INOBT_PTR_ADDR(block, 1, cur);
+	first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
+	last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	XFS_BTREE_TRACE_CURSOR(cur, EXIT);
 }
 
-
 /*
- * Get the data from the pointed-to record.
+ * Log records from a btree block (leaf).
  */
-int					/* error */
-xfs_inobt_get_rec(
+STATIC void
+xfs_inobt_log_recs(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agino_t		*ino,	/* output: starting inode of chunk */
-	__int32_t		*fcnt,	/* output: number of free inodes */
-	xfs_inofree_t		*free,	/* output: free inode mask */
-	int			*stat)	/* output: success/failure */
+	xfs_buf_t		*bp,	/* buffer containing btree block */
+	int			rfirst,	/* index of first record to log */
+	int			rlast)	/* index of last record to log */
 {
-	xfs_inobt_block_t	*block;	/* btree block */
-	xfs_buf_t		*bp;	/* buffer containing btree block */
-#ifdef DEBUG
-	int			error;	/* error return value */
-#endif
-	int			ptr;	/* record number */
-	xfs_inobt_rec_t		*rec;	/* record data */
+	xfs_inobt_block_t	*block;	/* btree block to log from */
+	int			first;	/* first byte offset logged */
+	int			last;	/* last byte offset logged */
+	xfs_inobt_rec_t		*rp;	/* record pointer for btree block */
 
-	bp = cur->bc_bufs[0];
-	ptr = cur->bc_ptrs[0];
+	XFS_BTREE_TRACE_CURSOR(cur, ENTRY);
+	XFS_BTREE_TRACE_ARGBII(cur, bp, rfirst, rlast);
 	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, 0, bp)))
-		return error;
-#endif
+	rp = XFS_INOBT_REC_ADDR(block, 1, cur);
+	first = (int)((xfs_caddr_t)&rp[rfirst - 1] - (xfs_caddr_t)block);
+	last = (int)(((xfs_caddr_t)&rp[rlast] - 1) - (xfs_caddr_t)block);
+	xfs_trans_log_buf(cur->bc_tp, bp, first, last);
+	XFS_BTREE_TRACE_CURSOR(cur, EXIT);
+}
+
+static const struct xfs_btree_record_ops xfs_inobt_recops = {
+	.get_minrecs	= xfs_inobt_get_minrecs,
+	.get_maxrecs	= xfs_inobt_get_maxrecs,
+	.get_numrecs	= xfs_btree_get_numrecs,
+	.set_numrecs	= xfs_btree_set_numrecs,
+
+	.init_key_from_rec = xfs_inobt_init_key_from_rec,
+	.init_ptr_from_cur = xfs_inobt_init_ptr_from_cur,
+	.init_rec_from_key = xfs_inobt_init_rec_from_key,
+	.init_rec_from_cur = xfs_inobt_init_rec_from_cur,
+
+	.key_addr	= xfs_inobt_key_addr,
+	.ptr_addr	= xfs_inobt_ptr_addr,
+	.rec_addr	= xfs_inobt_rec_addr,
+
+	.key_diff	= xfs_inobt_key_diff,
+	.ptr_to_daddr	= xfs_inobt_ptr_to_daddr,
+
+	.move_keys	= xfs_inobt_move_keys,
+	.move_ptrs	= xfs_inobt_move_ptrs,
+	.move_recs	= xfs_inobt_move_recs,
+
+	.set_key	= xfs_inobt_set_key,
+	.set_ptr	= xfs_inobt_set_ptr,
+	.set_rec	= xfs_inobt_set_rec,
+
+	.log_keys	= xfs_inobt_log_keys,
+	.log_ptrs	= xfs_inobt_log_ptrs,
+	.log_recs	= xfs_inobt_log_recs,
+
+	.check_ptrs	= xfs_btree_check_sptr,
+};
+
+STATIC void
+xfs_inobt_setroot(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_ptr_t	*nptr,
+	int		inc)	/* level change */
+{
+	xfs_buf_t	*agbp = cur->bc_private.i.agbp;
+	xfs_agi_t	*agi = XFS_BUF_TO_AGI(agbp);
+
+	agi->agi_root = nptr->u.inobt;
+	be32_add(&agi->agi_level, inc);
+	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_ROOT | XFS_AGI_LEVEL);
+}
+
+
+STATIC int
+xfs_inobt_killroot(
+	xfs_btree_cur_t	*cur,
+	int		level,
+	xfs_btree_ptr_t	*newroot)
+{
+	xfs_buf_t	*agbp = cur->bc_private.i.agbp;
+	xfs_agi_t	*agi = XFS_BUF_TO_AGI(agbp);
+	xfs_agblock_t	bno;
+	int		error;
+
 	/*
-	 * Off the right end or left end, return failure.
+	 * Set the root entry in the a.g. inode structure,
+	 * decreasing the level by 1.
 	 */
-	if (ptr > be16_to_cpu(block->bb_numrecs) || ptr <= 0) {
-		*stat = 0;
-		return 0;
-	}
+	bno = be32_to_cpu(agi->agi_root);
+	xfs_inobt_setroot(cur, newroot, -1);
 	/*
-	 * Point to the record and extract its data.
+	 * Free the old root.
 	 */
-	rec = XFS_INOBT_REC_ADDR(block, ptr, cur);
-	*ino = be32_to_cpu(rec->ir_startino);
-	*fcnt = be32_to_cpu(rec->ir_freecount);
-	*free = be64_to_cpu(rec->ir_free);
-	*stat = 1;
+	error = xfs_free_extent(cur->bc_tp,
+		XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.i.agno, bno), 1);
+	if (error)
+		return error;
+	xfs_trans_binval(cur->bc_tp, cur->bc_bufs[level]);
+	/*
+	 * Update the cursor so there's one fewer level.
+	 */
+	cur->bc_bufs[level] = NULL;
+	cur->bc_nlevels--;
 	return 0;
 }
 
+static const struct xfs_btree_cur_ops xfs_inobt_curops = {
+	.set_root	= xfs_inobt_setroot,
+	.new_root	= xfs_btree_newroot,
+	.kill_root	= xfs_inobt_killroot,
+};
+
+
+#if defined(XFS_BTREE_TRACE)
+
 /*
- * Increment cursor by one record at the level.
- * For nonzero levels the leaf-ward information is untouched.
+ * Global inobt trace buffer
  */
-int					/* error */
-xfs_inobt_increment(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level,	/* level in btree, 0 is leaf */
-	int			*stat)	/* success/failure */
+ktrace_t        *xfs_inobt_trace_buf;
+/*
+ * Add a trace buffer entry for the arguments given to the routine,
+ * generic form.
+ */
+STATIC void
+xfs_inobt_trace_enter(
+	const char	*func,
+	xfs_btree_cur_t	*cur,
+	char		*s,
+	int		type,
+	int		line,
+	__psunsigned_t	a0,
+	__psunsigned_t	a1,
+	__psunsigned_t	a2,
+	__psunsigned_t	a3,
+	__psunsigned_t	a4,
+	__psunsigned_t	a5,
+	__psunsigned_t	a6,
+	__psunsigned_t	a7,
+	__psunsigned_t	a8,
+	__psunsigned_t	a9,
+	__psunsigned_t	a10)
+{
+	ktrace_enter(xfs_inobt_trace_buf,
+		(void *)(__psint_t)type,
+		(void *)func, (void *)s, (void *)ip, (void *)cur,
+		(void *)a0, (void *)a1, (void *)a2, (void *)a3,
+		(void *)a4, (void *)a5, (void *)a6, (void *)a7,
+		(void *)a8, (void *)a9, (void *)a10);
+}
+
+STATIC void
+xfs_inobt_trace_cursor(
+	xfs_btree_cur_t	*cur,
+	__uint32_t	*s0,
+	__uint64_t	*l0,
+	__uint64_t	*l1)
+{
+	*s0 = cur->bc_private.i.agno;
+	*l0 = cur->bc_rec.i.ir_startino;
+	*l1 = cur->bc_rec.i.ir_free;
+}
+
+STATIC void
+xfs_inobt_trace_record(
+	xfs_btree_cur_t	*cur,
+	xfs_btree_rec_t	*rec,
+	__uint64_t	*l0,
+	__uint64_t	*l1,
+	__uint64_t	*l2)
 {
-	xfs_inobt_block_t	*block;	/* btree block */
-	xfs_buf_t		*bp;	/* buffer containing btree block */
-	int			error;	/* error return value */
-	int			lev;	/* btree level */
+	*l0 = be32_to_cpu(&rec->u.inobt.ir_startino);
+	*l1 = be32_to_cpu(&rec->u.inobt.ir_freecount);
+	*l2 = be64_to_cpu(&rec->u.inobt.ir_free);
+}
 
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
+static const struct xfs_btree_trc_ops xfs_inobt_trcops = {
+	.enter		= xfs_inobt_trace_enter,
+	.cursor		= xfs_inobt_trace_cursor,
+	.record		= xfs_inobt_trace_record,
+};
 #endif
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
-#ifdef DEBUG
-		if ((error = xfs_btree_check_sblock(cur, block, lev, bp)))
-			return error;
+
+void
+xfs_inobt_init_cursor(
+	xfs_btree_cur_t	*cur)
+{
+	cur->bc_flags = 0;
+	cur->bc_curops = &xfs_inobt_curops;
+	cur->bc_blkops = &xfs_inobt_blkops;
+	cur->bc_recops = &xfs_inobt_recops;
+#if defined(XFS_BTREE_TRACE)
+	cur->bc_trcops = &xfs_inobt_trcops;
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
-				cur->bc_private.i.agno, agbno, 0, &bp,
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
 }
 
 /*
- * Insert the current record at the point referenced by cur.
- * The cursor may be inconsistent on return if splits have been done.
+ * INOBT functions that are not covered by core btree code.
+ * Externally visible routines.
+ */
+
+/*
+ * Update the record referred to by cur to the value given
+ * by [ino, fcnt, free].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
  */
 int					/* error */
-xfs_inobt_insert(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		*stat)		/* success/failure */
+xfs_inobt_update(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_agino_t		ino,	/* starting inode of chunk */
+	__int32_t		fcnt,	/* free inode count */
+	xfs_inofree_t		free)	/* free inode mask */
 {
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
+	xfs_btree_rec_t	rec;
+
+	rec.u.inobt.ir_startino = cpu_to_be32(ino);
+	rec.u.inobt.ir_freecount = cpu_to_be32(fcnt);
+	rec.u.inobt.ir_free = cpu_to_be64(free);
+	return xfs_btree_update(cur, &rec);
 }
 
 /*
@@ -1986,7 +703,7 @@ xfs_inobt_lookup_eq(
 	cur->bc_rec.i.ir_startino = ino;
 	cur->bc_rec.i.ir_freecount = fcnt;
 	cur->bc_rec.i.ir_free = free;
-	return xfs_inobt_lookup(cur, XFS_LOOKUP_EQ, stat);
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
 }
 
 /*
@@ -2004,7 +721,7 @@ xfs_inobt_lookup_ge(
 	cur->bc_rec.i.ir_startino = ino;
 	cur->bc_rec.i.ir_freecount = fcnt;
 	cur->bc_rec.i.ir_free = free;
-	return xfs_inobt_lookup(cur, XFS_LOOKUP_GE, stat);
+	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
 }
 
 /*
@@ -2022,57 +739,55 @@ xfs_inobt_lookup_le(
 	cur->bc_rec.i.ir_startino = ino;
 	cur->bc_rec.i.ir_freecount = fcnt;
 	cur->bc_rec.i.ir_free = free;
-	return xfs_inobt_lookup(cur, XFS_LOOKUP_LE, stat);
+	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
 }
 
 /*
- * Update the record referred to by cur, to the value given
- * by [ino, fcnt, free].
- * This either works (return 0) or gets an EFSCORRUPTED error.
+ * Get the data from the pointed-to record.
  */
 int					/* error */
-xfs_inobt_update(
+xfs_inobt_get_rec(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agino_t		ino,	/* starting inode of chunk */
-	__int32_t		fcnt,	/* free inode count */
-	xfs_inofree_t		free)	/* free inode mask */
+	xfs_agino_t		*ino,	/* output: starting inode of chunk */
+	__int32_t		*fcnt,	/* output: number of free inodes */
+	xfs_inofree_t		*free,	/* output: free inode mask */
+	int			*stat)	/* output: success/failure */
 {
-	xfs_inobt_block_t	*block;	/* btree block to update */
+	xfs_btree_block_t	*block;	/* btree block */
 	xfs_buf_t		*bp;	/* buffer containing btree block */
+#ifdef DEBUG
 	int			error;	/* error return value */
-	int			ptr;	/* current record number (updating) */
-	xfs_inobt_rec_t		*rp;	/* pointer to updated record */
+#endif
+	int			ptr;	/* record number */
+	xfs_btree_rec_t		*rec;	/* record data */
 
-	/*
-	 * Pick up the current block.
-	 */
-	bp = cur->bc_bufs[0];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
+	XFS_BTREE_TRACE_CURSOR(cur, ENTRY);
+	XFS_BTREE_TRACE_ARGFFF(cur, *ino, *fcnt, *free);
+
+	ptr = cur->bc_ptrs[0];
+	block = xfs_inobt_get_block(cur, 0, &bp);
 #ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, 0, bp)))
+	error = xfs_btree_check_sblock(cur, block, 0, bp);
+	if (error)
 		return error;
 #endif
 	/*
-	 * Get the address of the rec to be updated.
-	 */
-	ptr = cur->bc_ptrs[0];
-	rp = XFS_INOBT_REC_ADDR(block, ptr, cur);
-	/*
-	 * Fill in the new contents and log them.
+	 * Off the right end or left end, return failure.
 	 */
-	rp->ir_startino = cpu_to_be32(ino);
-	rp->ir_freecount = cpu_to_be32(fcnt);
-	rp->ir_free = cpu_to_be64(free);
-	xfs_inobt_log_recs(cur, bp, ptr, ptr);
+	if (ptr > be16_to_cpu(block->bb_h.bb_numrecs) || ptr <= 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, EXIT);
+		*stat = 0;
+		return 0;
+	}
 	/*
-	 * Updating first record in leaf. Pass new key value up to our parent.
+	 * Point to the record and extract its data.
 	 */
-	if (ptr == 1) {
-		xfs_inobt_key_t	key;	/* key containing [ino] */
-
-		key.ir_startino = cpu_to_be32(ino);
-		if ((error = xfs_inobt_updkey(cur, &key, 1)))
-			return error;
-	}
+	rec = xfs_inobt_rec_addr(cur, ptr, block);
+	*ino = be32_to_cpu(rec->u.inobt.ir_startino);
+	*fcnt = be32_to_cpu(rec->u.inobt.ir_freecount);
+	*free = be64_to_cpu(rec->u.inobt.ir_free);
+	XFS_BTREE_TRACE_CURSOR(cur, EXIT);
+	*stat = 1;
 	return 0;
 }
+
Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc_btree.h	2007-10-15 09:58:18.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc_btree.h	2007-11-06 19:40:29.770666321 +1100
@@ -116,6 +116,8 @@ typedef	struct xfs_btree_sblock xfs_inob
 	(XFS_BTREE_PTR_ADDR(xfs_inobt, bb, \
 				i, XFS_INOBT_BLOCK_MAXRECS(1, cur)))
 
+extern void xfs_inobt_init_cursor(struct xfs_btree_cur *cur);
+
 /*
  * Decrement cursor by one record at the level.
  * For nonzero levels the leaf-ward information is untouched.
Index: 2.6.x-xfs-new/fs/xfs/xfs_itable.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_itable.c	2007-10-24 16:01:47.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_itable.c	2007-11-06 19:40:29.770666321 +1100
@@ -475,7 +475,7 @@ xfs_bulkstat(
 			 * In any case, increment to the next record.
 			 */
 			if (!error)
-				error = xfs_inobt_increment(cur, 0, &tmp);
+				error = xfs_btree_increment(cur, 0, &tmp);
 		} else {
 			/*
 			 * Start of ag.  Lookup the first inode chunk.
@@ -541,7 +541,7 @@ xfs_bulkstat(
 			 * Set agino to after this chunk and bump the cursor.
 			 */
 			agino = gino + XFS_INODES_PER_CHUNK;
-			error = xfs_inobt_increment(cur, 0, &tmp);
+			error = xfs_btree_increment(cur, 0, &tmp);
 		}
 		/*
 		 * Drop the btree buffers and the agi buffer.
@@ -881,7 +881,7 @@ xfs_inumbers(
 			bufidx = 0;
 		}
 		if (left) {
-			error = xfs_inobt_increment(cur, 0, &tmp);
+			error = xfs_btree_increment(cur, 0, &tmp);
 			if (error) {
 				xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 				cur = NULL;
