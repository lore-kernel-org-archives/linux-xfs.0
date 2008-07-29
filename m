Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 12:30:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6TJTs6h032022
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:29:54 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3064733F201
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:31:03 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id FSS2SoR00p2ZOEVU for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:31:03 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6TJV4IF019295
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:31:04 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6TJV4Mf019293
	for xfs@oss.sgi.com; Tue, 29 Jul 2008 21:31:04 +0200
Date: Tue, 29 Jul 2008 21:31:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/21] implement generic xfs_btree_lookup
Message-ID: <20080729193104.GL19104@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-common-btree-lookup
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

From: Dave Chinner <dgc@sgi.com>

[hch: split out from bigger patch and minor adaptions]


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-15 17:51:36.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-15 18:24:15.000000000 +0200
@@ -1153,3 +1153,220 @@ error0:
 	return error;
 }
 
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
+		*blkp = cur->bc_ops->get_root_from_inode(cur);
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
+		union xfs_btree_rec	*krp;
+
+		krp = cur->bc_ops->rec_addr(cur, keyno, block);
+		cur->bc_ops->init_key_from_rec(cur, kp, krp);
+		return kp;
+	}
+
+	return cur->bc_ops->key_addr(cur, keyno, block);
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
+		/*
+		 * If we already had a key match at a higher level, we know
+		 * we need to use the first entry in this block.
+		 */
+		if (diff == 0)
+			keyno = 1;
+
+		/* Otherwise search this block. Do a binary search. */
+		else {
+			int	high;	/* high entry number */
+			int	low;	/* low entry number */
+
+			/* Set low and high entry numbers, 1-based. */
+			low = 1;
+			high = xfs_btree_get_numrecs(block);
+			if (!high) {
+				/* Block is empty, must be an empty leaf. */
+				ASSERT(level == 0 && cur->bc_nlevels == 1);
+				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
+				XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+				*stat = 0;
+				return 0;
+			}
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
+			pp = cur->bc_ops->ptr_addr(cur, keyno, block);
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
+	else
+		*stat = ((dir != XFS_LOOKUP_EQ) || (diff == 0));
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-15 17:46:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-15 17:51:41.000000000 +0200
@@ -194,6 +194,21 @@ struct xfs_btree_ops {
 	/* return address of btree structures */
 	union xfs_btree_ptr *(*ptr_addr)(struct xfs_btree_cur *cur, int index,
 					 struct xfs_btree_block *block);
+	union xfs_btree_key *(*key_addr)(struct xfs_btree_cur *cur, int index,
+					 struct xfs_btree_block *block);
+	union xfs_btree_rec *(*rec_addr)(struct xfs_btree_cur *cur, int index,
+					 struct xfs_btree_block *block);
+
+	/* init values of btree structures */
+	void	(*init_key_from_rec)(struct xfs_btree_cur *cur,
+				     union xfs_btree_key *key,
+				     union xfs_btree_rec *rec);
+	void	(*init_ptr_from_cur)(struct xfs_btree_cur *cur,
+				     union xfs_btree_ptr *ptr);
+
+	/* difference between key value and cursor value */
+	__int64_t (*key_diff)(struct xfs_btree_cur *cur,
+			      union xfs_btree_key *key);
 
 	/* btree tracing */
 #ifdef XFS_BTREE_TRACE
@@ -512,6 +527,7 @@ xfs_btree_setbuf(
 
 int xfs_btree_increment(struct xfs_btree_cur *, int, int *);
 int xfs_btree_decrement(struct xfs_btree_cur *, int, int *);
+int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
 
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-07-15 17:46:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-07-15 17:51:41.000000000 +0200
@@ -938,223 +938,6 @@ xfs_alloc_log_recs(
 }
 
 /*
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
-			if ((error = xfs_btree_increment(cur, 0, &i)))
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
  * Move 1 record left from cur/level if possible.
  * Update cur to reflect the new path.
  */
@@ -1919,53 +1702,6 @@ xfs_alloc_insert(
 }
 
 /*
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
-}
-
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
-}
-
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
-}
-
-/*
  * Update the record referred to by cur, to the value given by [bno, len].
  * This either works (return 0) or gets an EFSCORRUPTED error.
  */
@@ -2044,6 +1780,31 @@ xfs_allocbt_dup_cursor(
 			cur->bc_btnum);
 }
 
+STATIC void
+xfs_allocbt_init_key_from_rec(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(rec->alloc.ar_startblock != 0);
+
+	key->alloc.ar_startblock = rec->alloc.ar_startblock;
+	key->alloc.ar_blockcount = rec->alloc.ar_blockcount;
+}
+
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
 STATIC union xfs_btree_ptr *
 xfs_allocbt_ptr_addr(
 	struct xfs_btree_cur	*cur,
@@ -2054,6 +1815,47 @@ xfs_allocbt_ptr_addr(
 		XFS_ALLOC_PTR_ADDR(&block->bb_h, index, cur);
 }
 
+STATIC union xfs_btree_key *
+xfs_allocbt_key_addr(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_key *)
+		XFS_ALLOC_KEY_ADDR(&block->bb_h, index, cur);
+}
+
+STATIC union xfs_btree_rec *
+xfs_allocbt_rec_addr(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_rec *)
+		XFS_ALLOC_REC_ADDR(&block->bb_h, index, cur);
+}
+
+STATIC __int64_t
+xfs_allocbt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	xfs_alloc_rec_incore_t	*rec = &cur->bc_rec.a;
+  	xfs_alloc_key_t		*kp = &key->alloc;
+	__int64_t		diff;
+
+	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+		return (__int64_t)be32_to_cpu(kp->ar_startblock) -
+				rec->ar_startblock;
+	}
+
+	diff = (__int64_t)be32_to_cpu(kp->ar_blockcount) - rec->ar_blockcount;
+	if (diff)
+		return diff;
+
+	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
+}
+
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_allocbt_trace_buf;
@@ -2123,7 +1925,12 @@ xfs_allocbt_trace_record(
 
 static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.dup_cursor		= xfs_allocbt_dup_cursor,
+	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
+	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.ptr_addr		= xfs_allocbt_ptr_addr,
+	.key_addr		= xfs_allocbt_key_addr,
+	.rec_addr		= xfs_allocbt_rec_addr,
+	.key_diff		= xfs_allocbt_key_diff,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_allocbt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-07-15 17:46:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-07-15 17:51:41.000000000 +0200
@@ -829,212 +829,6 @@ xfs_inobt_log_recs(
 }
 
 /*
- * Lookup the record.  The cursor is made to point to it, based on dir.
- * Return 0 if can't find any such record, 1 for success.
- */
-STATIC int				/* error */
-xfs_inobt_lookup(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_lookup_t		dir,	/* <=, ==, or >= */
-	int			*stat)	/* success/failure */
-{
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
-			if ((error = xfs_btree_increment(cur, 0, &i)))
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
-}
-
-/*
  * Move 1 record left from cur/level if possible.
  * Update cur to reflect the new path.
  */
@@ -1798,59 +1592,6 @@ xfs_inobt_insert(
 }
 
 /*
- * Lookup the record equal to ino in the btree given by cur.
- */
-int					/* error */
-xfs_inobt_lookup_eq(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	xfs_agino_t	ino,		/* starting inode of chunk */
-	__int32_t	fcnt,		/* free inode count */
-	xfs_inofree_t	free,		/* free inode mask */
-	int		*stat)		/* success/failure */
-{
-	cur->bc_rec.i.ir_startino = ino;
-	cur->bc_rec.i.ir_freecount = fcnt;
-	cur->bc_rec.i.ir_free = free;
-	return xfs_inobt_lookup(cur, XFS_LOOKUP_EQ, stat);
-}
-
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
-
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
-
-/*
  * Update the record referred to by cur, to the value given
  * by [ino, fcnt, free].
  * This either works (return 0) or gets an EFSCORRUPTED error.
@@ -1910,6 +1651,30 @@ xfs_inobt_dup_cursor(
 			cur->bc_private.a.agbp, cur->bc_private.a.agno);
 }
 
+STATIC void
+xfs_inobt_init_key_from_rec(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	key->inobt.ir_startino = rec->inobt.ir_startino;
+}
+
+/*
+ * intial value of ptr for lookup
+ */
+STATIC void
+xfs_inobt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(cur->bc_private.a.agbp);
+
+	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agi->agi_seqno));
+
+	ptr->s = agi->agi_root;
+}
+
 STATIC union xfs_btree_ptr *
 xfs_inobt_ptr_addr(
 	struct xfs_btree_cur	*cur,
@@ -1920,6 +1685,35 @@ xfs_inobt_ptr_addr(
 		XFS_INOBT_PTR_ADDR(&block->bb_h, index, cur);
 }
 
+STATIC union xfs_btree_key *
+xfs_inobt_key_addr(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_key *)
+		XFS_INOBT_KEY_ADDR(&block->bb_h, index, cur);
+}
+
+STATIC union xfs_btree_rec *
+xfs_inobt_rec_addr(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_rec *)
+		XFS_INOBT_REC_ADDR(&block->bb_h, index, cur);
+}
+
+STATIC __int64_t
+xfs_inobt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	return (__int64_t)be32_to_cpu(key->inobt.ir_startino) -
+			  cur->bc_rec.i.ir_startino;
+}
+
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_inobt_trace_buf;
@@ -1989,7 +1783,12 @@ xfs_inobt_trace_record(
 
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.dup_cursor		= xfs_inobt_dup_cursor,
+	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
+	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.ptr_addr		= xfs_inobt_ptr_addr,
+	.key_addr		= xfs_inobt_key_addr,
+	.rec_addr		= xfs_inobt_rec_addr,
+	.key_diff		= xfs_inobt_key_diff,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_inobt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-07-15 17:46:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-07-15 17:51:41.000000000 +0200
@@ -812,146 +812,6 @@ xfs_bmbt_log_ptrs(
 }
 
 /*
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
-			if ((error = xfs_btree_increment(cur, 0, &i))) {
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
  * Move 1 record left from cur/level if possible.
  * Update cur to reflect the new path.
  */
@@ -1807,34 +1667,6 @@ xfs_bmbt_log_recs(
 	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
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
 /*
  * Give the bmap btree a new root block.  Copy the old broot contents
  * down into a real block and make the broot point to it.
@@ -2269,6 +2101,24 @@ xfs_bmbt_get_root_from_inode(
 	return (struct xfs_btree_block *)ifp->if_broot;
 }
 
+STATIC void
+xfs_bmbt_init_key_from_rec(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	key->bmbt.br_startoff =
+		cpu_to_be64(xfs_bmbt_disk_get_startoff(&rec->bmbt));
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
 STATIC union xfs_btree_ptr *
 xfs_bmbt_ptr_addr(
 	struct xfs_btree_cur	*cur,
@@ -2279,6 +2129,35 @@ xfs_bmbt_ptr_addr(
 		XFS_BMAP_PTR_IADDR(&block->bb_h, index, cur);
 }
 
+STATIC union xfs_btree_key *
+xfs_bmbt_key_addr(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_key *)
+		XFS_BMAP_KEY_IADDR(&block->bb_h, index, cur);
+}
+
+STATIC union xfs_btree_rec *
+xfs_bmbt_rec_addr(
+	struct xfs_btree_cur	*cur,
+	int			index,
+	struct xfs_btree_block	*block)
+{
+	return (union xfs_btree_rec *)
+		XFS_BMAP_REC_IADDR(&block->bb_h, index, cur);
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
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_bmbt_trace_buf;
@@ -2366,7 +2245,12 @@ xfs_bmbt_trace_record(
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.dup_cursor		= xfs_bmbt_dup_cursor,
 	.get_root_from_inode	= xfs_bmbt_get_root_from_inode,
+	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
+	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.ptr_addr		= xfs_bmbt_ptr_addr,
+	.key_addr		= xfs_bmbt_key_addr,
+	.rec_addr		= xfs_bmbt_rec_addr,
+	.key_diff		= xfs_bmbt_key_diff,
 
 #ifdef XFS_BTREE_TRACE
 	.trace_enter		= xfs_bmbt_trace_enter,
Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-07-15 17:46:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-07-15 17:51:41.000000000 +0200
@@ -90,6 +90,54 @@ STATIC int xfs_alloc_ag_vextent_small(xf
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
+
+/*
  * Compute aligned version of the found extent.
  * Takes alignment and min length into account.
  */
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.h	2008-07-15 17:46:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h	2008-07-15 17:51:41.000000000 +0200
@@ -114,26 +114,6 @@ extern int xfs_alloc_get_rec(struct xfs_
 extern int xfs_alloc_insert(struct xfs_btree_cur *cur, int *stat);
 
 /*
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
  * Update the record referred to by cur, to the value given by [bno, len].
  * This either works (return 0) or gets an EFSCORRUPTED error.
  */
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-07-15 17:46:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-07-15 17:51:41.000000000 +0200
@@ -402,6 +402,35 @@ xfs_bmap_disk_count_leaves(
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
+
 /*
  * Called from xfs_bmap_add_attrfork to handle btree format files.
  */
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-07-15 17:46:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-07-15 17:51:41.000000000 +0200
@@ -119,6 +119,59 @@ xfs_ialloc_cluster_alignment(
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
  * Allocate new inodes in the allocation group specified by agbp.
  * Return 0 for success, else error code.
  */
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.h	2008-07-15 15:11:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.h	2008-07-15 17:51:41.000000000 +0200
@@ -154,6 +154,21 @@ xfs_ialloc_pagi_init(
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
+
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_IALLOC_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h	2008-07-15 17:46:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h	2008-07-15 17:51:41.000000000 +0200
@@ -136,26 +136,6 @@ extern int xfs_inobt_get_rec(struct xfs_
 extern int xfs_inobt_insert(struct xfs_btree_cur *cur, int *stat);
 
 /*
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
  * Update the record referred to by cur, to the value given
  * by [ino, fcnt, free].
  * This either works (return 0) or gets an EFSCORRUPTED error.
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-07-15 17:46:52.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-07-15 17:51:41.000000000 +0200
@@ -254,10 +254,6 @@ extern int xfs_bmbt_insert(struct xfs_bt
 extern void xfs_bmbt_log_block(struct xfs_btree_cur *, struct xfs_buf *, int);
 extern void xfs_bmbt_log_recs(struct xfs_btree_cur *, struct xfs_buf *, int,
 				int);
-extern int xfs_bmbt_lookup_eq(struct xfs_btree_cur *, xfs_fileoff_t,
-				xfs_fsblock_t, xfs_filblks_t, int *);
-extern int xfs_bmbt_lookup_ge(struct xfs_btree_cur *, xfs_fileoff_t,
-				xfs_fsblock_t, xfs_filblks_t, int *);
 
 /*
  * Give the bmap btree a new root block.  Copy the old broot contents

-- 
