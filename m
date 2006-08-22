Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Aug 2006 19:58:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7M2vtDW013355
	for <xfs@oss.sgi.com>; Mon, 21 Aug 2006 19:58:00 -0700
Subject: [PATCH] reduce endian flipping in xfs_alloc_btree.c
Message-Id: <20060822025719.ED1A318DE2F38@sandeen.net>
Date: Mon, 21 Aug 2006 21:57:19 -0500 (CDT)
From: sandeen@sandeen.net
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

(Note: I've done some sanity-check testing, but this should probably
live in a patch stack for a while before checkin...)

Reduce endian flipping activity in this file; compare to xfs_ialloc_btree.c
for a sanity-check.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>k

Index: xfs-linux-killwantfuncs/xfs_alloc_btree.c
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_alloc_btree.c
+++ xfs-linux-killwantfuncs/xfs_alloc_btree.c
@@ -92,6 +92,7 @@ xfs_alloc_delrec(
 	xfs_alloc_key_t		*rkp;	/* right block key pointer */
 	xfs_alloc_ptr_t		*rpp;	/* right block address pointer */
 	int			rrecs=0;	/* number of records in right block */
+	int			numrecs;
 	xfs_alloc_rec_t		*rrp;	/* right block record pointer */
 	xfs_btree_cur_t		*tcur;	/* temporary btree cursor */
 
@@ -115,7 +116,8 @@ xfs_alloc_delrec(
 	/*
 	 * Fail if we're off the end of the block.
 	 */
-	if (ptr > be16_to_cpu(block->bb_numrecs)) {
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (ptr > numrecs) {
 		*stat = 0;
 		return 0;
 	}
@@ -129,18 +131,18 @@ xfs_alloc_delrec(
 		lkp = XFS_ALLOC_KEY_ADDR(block, 1, cur);
 		lpp = XFS_ALLOC_PTR_ADDR(block, 1, cur);
 #ifdef DEBUG
-		for (i = ptr; i < be16_to_cpu(block->bb_numrecs); i++) {
+		for (i = ptr; i < numrecs; i++) {
 			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(lpp[i]), level)))
 				return error;
 		}
 #endif
-		if (ptr < be16_to_cpu(block->bb_numrecs)) {
+		if (ptr < numrecs) {
 			memmove(&lkp[ptr - 1], &lkp[ptr],
-				(be16_to_cpu(block->bb_numrecs) - ptr) * sizeof(*lkp));
+				(numrecs - ptr) * sizeof(*lkp));
 			memmove(&lpp[ptr - 1], &lpp[ptr],
-				(be16_to_cpu(block->bb_numrecs) - ptr) * sizeof(*lpp));
-			xfs_alloc_log_ptrs(cur, bp, ptr, be16_to_cpu(block->bb_numrecs) - 1);
-			xfs_alloc_log_keys(cur, bp, ptr, be16_to_cpu(block->bb_numrecs) - 1);
+				(numrecs - ptr) * sizeof(*lpp));
+			xfs_alloc_log_ptrs(cur, bp, ptr, numrecs - 1);
+			xfs_alloc_log_keys(cur, bp, ptr, numrecs - 1);
 		}
 	}
 	/*
@@ -149,10 +151,10 @@ xfs_alloc_delrec(
 	 */
 	else {
 		lrp = XFS_ALLOC_REC_ADDR(block, 1, cur);
-		if (ptr < be16_to_cpu(block->bb_numrecs)) {
+		if (ptr < numrecs) {
 			memmove(&lrp[ptr - 1], &lrp[ptr],
-				(be16_to_cpu(block->bb_numrecs) - ptr) * sizeof(*lrp));
-			xfs_alloc_log_recs(cur, bp, ptr, be16_to_cpu(block->bb_numrecs) - 1);
+				(numrecs - ptr) * sizeof(*lrp));
+			xfs_alloc_log_recs(cur, bp, ptr, numrecs - 1);
 		}
 		/*
 		 * If it's the first record in the block, we'll need a key
@@ -167,7 +169,8 @@ xfs_alloc_delrec(
 	/*
 	 * Decrement and log the number of entries in the block.
 	 */
-	be16_add(&block->bb_numrecs, -1);
+	numrecs--;
+	block->bb_numrecs = cpu_to_be16(numrecs);
 	xfs_alloc_log_block(cur->bc_tp, bp, XFS_BB_NUMRECS);
 	/*
 	 * See if the longest free extent in the allocation group was
@@ -181,14 +184,14 @@ xfs_alloc_delrec(
 	if (level == 0 &&
 	    cur->bc_btnum == XFS_BTNUM_CNT &&
 	    be32_to_cpu(block->bb_rightsib) == NULLAGBLOCK &&
-	    ptr > be16_to_cpu(block->bb_numrecs)) {
-		ASSERT(ptr == be16_to_cpu(block->bb_numrecs) + 1);
+	    ptr > numrecs) {
+		ASSERT(ptr == numrecs + 1);
 		/*
 		 * There are still records in the block.  Grab the size
 		 * from the last one.
 		 */
-		if (be16_to_cpu(block->bb_numrecs)) {
-			rrp = XFS_ALLOC_REC_ADDR(block, be16_to_cpu(block->bb_numrecs), cur);
+		if (numrecs) {
+			rrp = XFS_ALLOC_REC_ADDR(block, numrecs, cur);
 			agf->agf_longest = rrp->ar_blockcount;
 		}
 		/*
@@ -211,7 +214,7 @@ xfs_alloc_delrec(
 		 * and it's NOT the leaf level,
 		 * then we can get rid of this level.
 		 */
-		if (be16_to_cpu(block->bb_numrecs) == 1 && level > 0) {
+		if (numrecs == 1 && level > 0) {
 			/*
 			 * lpp is still set to the first pointer in the block.
 			 * Make it the new root of the btree.
@@ -267,7 +270,7 @@ xfs_alloc_delrec(
 	 * If the number of records remaining in the block is at least
 	 * the minimum, we're done.
 	 */
-	if (be16_to_cpu(block->bb_numrecs) >= XFS_ALLOC_BLOCK_MINRECS(level, cur)) {
+	if (numrecs >= XFS_ALLOC_BLOCK_MINRECS(level, cur)) {
 		if (level > 0 && (error = xfs_alloc_decrement(cur, level, &i)))
 			return error;
 		*stat = 1;
@@ -419,19 +422,21 @@ xfs_alloc_delrec(
 	 * See if we can join with the left neighbor block.
 	 */
 	if (lbno != NULLAGBLOCK &&
-	    lrecs + be16_to_cpu(block->bb_numrecs) <= XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
+	    lrecs + numrecs <= XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
 		/*
 		 * Set "right" to be the starting block,
 		 * "left" to be the left neighbor.
 		 */
 		rbno = bno;
 		right = block;
+		rrecs = be16_to_cpu(right->bb_numrecs);
 		rbp = bp;
 		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
 				cur->bc_private.a.agno, lbno, 0, &lbp,
 				XFS_ALLOC_BTREE_REF)))
 			return error;
 		left = XFS_BUF_TO_ALLOC_BLOCK(lbp);
+		lrecs = be16_to_cpu(left->bb_numrecs);
 		if ((error = xfs_btree_check_sblock(cur, left, level, lbp)))
 			return error;
 	}
@@ -439,20 +444,21 @@ xfs_alloc_delrec(
 	 * If that won't work, see if we can join with the right neighbor block.
 	 */
 	else if (rbno != NULLAGBLOCK &&
-		 rrecs + be16_to_cpu(block->bb_numrecs) <=
-		  XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
+		 rrecs + numrecs <= XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
 		/*
 		 * Set "left" to be the starting block,
 		 * "right" to be the right neighbor.
 		 */
 		lbno = bno;
 		left = block;
+		lrecs = be16_to_cpu(left->bb_numrecs);
 		lbp = bp;
 		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
 				cur->bc_private.a.agno, rbno, 0, &rbp,
 				XFS_ALLOC_BTREE_REF)))
 			return error;
 		right = XFS_BUF_TO_ALLOC_BLOCK(rbp);
+		rrecs = be16_to_cpu(right->bb_numrecs);
 		if ((error = xfs_btree_check_sblock(cur, right, level, rbp)))
 			return error;
 	}
@@ -474,34 +480,28 @@ xfs_alloc_delrec(
 		/*
 		 * It's a non-leaf.  Move keys and pointers.
 		 */
-		lkp = XFS_ALLOC_KEY_ADDR(left, be16_to_cpu(left->bb_numrecs) + 1, cur);
-		lpp = XFS_ALLOC_PTR_ADDR(left, be16_to_cpu(left->bb_numrecs) + 1, cur);
+		lkp = XFS_ALLOC_KEY_ADDR(left, lrecs + 1, cur);
+		lpp = XFS_ALLOC_PTR_ADDR(left, lrecs + 1, cur);
 		rkp = XFS_ALLOC_KEY_ADDR(right, 1, cur);
 		rpp = XFS_ALLOC_PTR_ADDR(right, 1, cur);
 #ifdef DEBUG
-		for (i = 0; i < be16_to_cpu(right->bb_numrecs); i++) {
+		for (i = 0; i < rrecs; i++) {
 			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(rpp[i]), level)))
 				return error;
 		}
 #endif
-		memcpy(lkp, rkp, be16_to_cpu(right->bb_numrecs) * sizeof(*lkp));
-		memcpy(lpp, rpp, be16_to_cpu(right->bb_numrecs) * sizeof(*lpp));
-		xfs_alloc_log_keys(cur, lbp, be16_to_cpu(left->bb_numrecs) + 1,
-				   be16_to_cpu(left->bb_numrecs) +
-				   be16_to_cpu(right->bb_numrecs));
-		xfs_alloc_log_ptrs(cur, lbp, be16_to_cpu(left->bb_numrecs) + 1,
-				   be16_to_cpu(left->bb_numrecs) +
-				   be16_to_cpu(right->bb_numrecs));
+		memcpy(lkp, rkp, rrecs * sizeof(*lkp));
+		memcpy(lpp, rpp, rrecs * sizeof(*lpp));
+		xfs_alloc_log_keys(cur, lbp, lrecs + 1, lrecs + rrecs);
+		xfs_alloc_log_ptrs(cur, lbp, lrecs + 1, lrecs + rrecs);
 	} else {
 		/*
 		 * It's a leaf.  Move records.
 		 */
-		lrp = XFS_ALLOC_REC_ADDR(left, be16_to_cpu(left->bb_numrecs) + 1, cur);
+		lrp = XFS_ALLOC_REC_ADDR(left, lrecs + 1, cur);
 		rrp = XFS_ALLOC_REC_ADDR(right, 1, cur);
-		memcpy(lrp, rrp, be16_to_cpu(right->bb_numrecs) * sizeof(*lrp));
-		xfs_alloc_log_recs(cur, lbp, be16_to_cpu(left->bb_numrecs) + 1,
-				   be16_to_cpu(left->bb_numrecs) +
-				   be16_to_cpu(right->bb_numrecs));
+		memcpy(lrp, rrp, rrecs * sizeof(*lrp));
+		xfs_alloc_log_recs(cur, lbp, lrecs + 1, lrecs + rrecs);
 	}
 	/*
 	 * If we joined with the left neighbor, set the buffer in the
@@ -509,7 +509,7 @@ xfs_alloc_delrec(
 	 */
 	if (bp != lbp) {
 		xfs_btree_setbuf(cur, level, lbp);
-		cur->bc_ptrs[level] += be16_to_cpu(left->bb_numrecs);
+		cur->bc_ptrs[level] += lrecs;
 	}
 	/*
 	 * If we joined with the right neighbor and there's a level above
@@ -521,7 +521,8 @@ xfs_alloc_delrec(
 	/*
 	 * Fix up the number of records in the surviving block.
 	 */
-	be16_add(&left->bb_numrecs, be16_to_cpu(right->bb_numrecs));
+	lrecs += rrecs;
+	left->bb_numrecs = cpu_to_be16(lrecs);
 	/*
 	 * Fix up the right block pointer in the surviving block, and log it.
 	 */
@@ -608,6 +609,7 @@ xfs_alloc_insrec(
 	xfs_btree_cur_t		*ncur;	/* new cursor to be used at next lvl */
 	xfs_alloc_key_t		nkey;	/* new key value, from split */
 	xfs_alloc_rec_t		nrec;	/* new record value, for caller */
+	int			numrecs;
 	int			optr;	/* old ptr value */
 	xfs_alloc_ptr_t		*pp;	/* pointer to btree addresses */
 	int			ptr;	/* index in btree block for this rec */
@@ -653,13 +655,14 @@ xfs_alloc_insrec(
 	 */
 	bp = cur->bc_bufs[level];
 	block = XFS_BUF_TO_ALLOC_BLOCK(bp);
+	numrecs = be16_to_cpu(block->bb_numrecs);
 #ifdef DEBUG
 	if ((error = xfs_btree_check_sblock(cur, block, level, bp)))
 		return error;
 	/*
 	 * Check that the new entry is being inserted in the right place.
 	 */
-	if (ptr <= be16_to_cpu(block->bb_numrecs)) {
+	if (ptr <= numrecs) {
 		if (level == 0) {
 			rp = XFS_ALLOC_REC_ADDR(block, ptr, cur);
 			xfs_btree_check_rec(cur->bc_btnum, recp, rp);
@@ -675,7 +678,7 @@ xfs_alloc_insrec(
 	 * If the block is full, we can't insert the new entry until we
 	 * make the block un-full.
 	 */
-	if (be16_to_cpu(block->bb_numrecs) == XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
+	if (numrecs == XFS_ALLOC_BLOCK_MAXRECS(level, cur)) {
 		/*
 		 * First, try shifting an entry to the right neighbor.
 		 */
@@ -729,6 +732,7 @@ xfs_alloc_insrec(
 	 * At this point we know there's room for our new entry in the block
 	 * we're pointing at.
 	 */
+	numrecs = be16_to_cpu(block->bb_numrecs);
 	if (level > 0) {
 		/*
 		 * It's a non-leaf entry.  Make a hole for the new data
@@ -737,15 +741,15 @@ xfs_alloc_insrec(
 		kp = XFS_ALLOC_KEY_ADDR(block, 1, cur);
 		pp = XFS_ALLOC_PTR_ADDR(block, 1, cur);
 #ifdef DEBUG
-		for (i = be16_to_cpu(block->bb_numrecs); i >= ptr; i--) {
+		for (i = numrecs; i >= ptr; i--) {
 			if ((error = xfs_btree_check_sptr(cur, be32_to_cpu(pp[i - 1]), level)))
 				return error;
 		}
 #endif
 		memmove(&kp[ptr], &kp[ptr - 1],
-			(be16_to_cpu(block->bb_numrecs) - ptr + 1) * sizeof(*kp));
+			(numrecs - ptr + 1) * sizeof(*kp));
 		memmove(&pp[ptr], &pp[ptr - 1],
-			(be16_to_cpu(block->bb_numrecs) - ptr + 1) * sizeof(*pp));
+			(numrecs - ptr + 1) * sizeof(*pp));
 #ifdef DEBUG
 		if ((error = xfs_btree_check_sptr(cur, *bnop, level)))
 			return error;
@@ -755,11 +759,12 @@ xfs_alloc_insrec(
 		 */
 		kp[ptr - 1] = key;
 		pp[ptr - 1] = cpu_to_be32(*bnop);
-		be16_add(&block->bb_numrecs, 1);
-		xfs_alloc_log_keys(cur, bp, ptr, be16_to_cpu(block->bb_numrecs));
-		xfs_alloc_log_ptrs(cur, bp, ptr, be16_to_cpu(block->bb_numrecs));
+		numrecs++;
+		block->bb_numrecs = cpu_to_be16(numrecs);
+		xfs_alloc_log_keys(cur, bp, ptr, numrecs);
+		xfs_alloc_log_ptrs(cur, bp, ptr, numrecs);
 #ifdef DEBUG
-		if (ptr < be16_to_cpu(block->bb_numrecs))
+		if (ptr < numrecs)
 			xfs_btree_check_key(cur->bc_btnum, kp + ptr - 1,
 				kp + ptr);
 #endif
@@ -769,16 +774,17 @@ xfs_alloc_insrec(
 		 */
 		rp = XFS_ALLOC_REC_ADDR(block, 1, cur);
 		memmove(&rp[ptr], &rp[ptr - 1],
-			(be16_to_cpu(block->bb_numrecs) - ptr + 1) * sizeof(*rp));
+			(numrecs - ptr + 1) * sizeof(*rp));
 		/*
 		 * Now stuff the new record in, bump numrecs
 		 * and log the new data.
 		 */
 		rp[ptr - 1] = *recp;
-		be16_add(&block->bb_numrecs, 1);
-		xfs_alloc_log_recs(cur, bp, ptr, be16_to_cpu(block->bb_numrecs));
+		numrecs++;
+		block->bb_numrecs = cpu_to_be16(numrecs);
+		xfs_alloc_log_recs(cur, bp, ptr, numrecs);
 #ifdef DEBUG
-		if (ptr < be16_to_cpu(block->bb_numrecs))
+		if (ptr < numrecs)
 			xfs_btree_check_rec(cur->bc_btnum, rp + ptr - 1,
 				rp + ptr);
 #endif
