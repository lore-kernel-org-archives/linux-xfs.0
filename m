Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DBE267CA4
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:56:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE6A1304048
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:56:48 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id owdJjHceEUWvyNjs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:56:46 -0700 (PDT)
Subject: [PATCH 06/47] xfs: during btree split,
	save new block key & ptr for future insertion
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:56:39 -0700
Message-ID: <146907699965.25461.15978861148226786001.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

When a btree block has to be split, we pass the new block's ptr from
xfs_btree_split() back to xfs_btree_insert() via a pointer parameter;
however, we pass the block's key through the cursor's record.  It is a
little weird to "initialize" a record from a key since the non-key
attributes will have garbage values.

When we go to add support for interval queries, we have to be able to
pass the lowest and highest keys accessible via a pointer.  There's no
clean way to pass this back through the cursor's record field.
Therefore, pass the key directly back to xfs_btree_insert() the same
way that we pass the btree_ptr.

As a bonus, we no longer need init_rec_from_key and can drop it from the
codebase.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c  |   12 -----------
 fs/xfs/libxfs/xfs_bmap_btree.c   |   12 -----------
 fs/xfs/libxfs/xfs_btree.c        |   40 +++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_btree.h        |    2 --
 fs/xfs/libxfs/xfs_ialloc_btree.c |   10 ----------
 5 files changed, 20 insertions(+), 56 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index d9b42425..5ba2dac 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -212,17 +212,6 @@ xfs_allocbt_init_key_from_rec(
 }
 
 STATIC void
-xfs_allocbt_init_rec_from_key(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
-{
-	ASSERT(key->alloc.ar_startblock != 0);
-
-	rec->alloc.ar_startblock = key->alloc.ar_startblock;
-	rec->alloc.ar_blockcount = key->alloc.ar_blockcount;
-}
-
-STATIC void
 xfs_allocbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
@@ -406,7 +395,6 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.get_minrecs		= xfs_allocbt_get_minrecs,
 	.get_maxrecs		= xfs_allocbt_get_maxrecs,
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
-	.init_rec_from_key	= xfs_allocbt_init_rec_from_key,
 	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_allocbt_key_diff,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index db0c71e..714b387 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -600,17 +600,6 @@ xfs_bmbt_init_key_from_rec(
 }
 
 STATIC void
-xfs_bmbt_init_rec_from_key(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
-{
-	ASSERT(key->bmbt.br_startoff != 0);
-
-	xfs_bmbt_disk_set_allf(&rec->bmbt, be64_to_cpu(key->bmbt.br_startoff),
-			       0, 0, XFS_EXT_NORM);
-}
-
-STATIC void
 xfs_bmbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
@@ -760,7 +749,6 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.get_minrecs		= xfs_bmbt_get_minrecs,
 	.get_dmaxrecs		= xfs_bmbt_get_dmaxrecs,
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
-	.init_rec_from_key	= xfs_bmbt_init_rec_from_key,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f5ff95a..8d8e362 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2858,10 +2858,9 @@ xfs_btree_make_block_unfull(
 	int			*index,	/* new tree index */
 	union xfs_btree_ptr	*nptr,	/* new btree ptr */
 	struct xfs_btree_cur	**ncur,	/* new btree cursor */
-	union xfs_btree_rec	*nrec,	/* new record */
+	union xfs_btree_key	*key, /* key of new block */
 	int			*stat)
 {
-	union xfs_btree_key	key;	/* new btree key value */
 	int			error = 0;
 
 	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
@@ -2907,13 +2906,12 @@ xfs_btree_make_block_unfull(
 	 * If this works we have to re-set our variables because we
 	 * could be in a different block now.
 	 */
-	error = xfs_btree_split(cur, level, nptr, &key, ncur, stat);
+	error = xfs_btree_split(cur, level, nptr, key, ncur, stat);
 	if (error || *stat == 0)
 		return error;
 
 
 	*index = cur->bc_ptrs[level];
-	cur->bc_ops->init_rec_from_key(&key, nrec);
 	return 0;
 }
 
@@ -2926,16 +2924,16 @@ xfs_btree_insrec(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level to insert record at */
 	union xfs_btree_ptr	*ptrp,	/* i/o: block number inserted */
-	union xfs_btree_rec	*recp,	/* i/o: record data inserted */
+	union xfs_btree_rec	*rec,	/* record to insert */
+	union xfs_btree_key	*key,	/* i/o: block key for ptrp */
 	struct xfs_btree_cur	**curp,	/* output: new cursor replacing cur */
 	int			*stat)	/* success/failure */
 {
 	struct xfs_btree_block	*block;	/* btree block */
 	struct xfs_buf		*bp;	/* buffer for block */
-	union xfs_btree_key	key;	/* btree key */
 	union xfs_btree_ptr	nptr;	/* new block ptr */
 	struct xfs_btree_cur	*ncur;	/* new btree cursor */
-	union xfs_btree_rec	nrec;	/* new record count */
+	union xfs_btree_key	nkey;	/* new block key */
 	int			optr;	/* old key/record index */
 	int			ptr;	/* key/record index */
 	int			numrecs;/* number of records */
@@ -2945,7 +2943,7 @@ xfs_btree_insrec(
 #endif
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGIPR(cur, level, *ptrp, recp);
+	XFS_BTREE_TRACE_ARGIPR(cur, level, *ptrp, &rec);
 
 	ncur = NULL;
 
@@ -2970,9 +2968,6 @@ xfs_btree_insrec(
 		return 0;
 	}
 
-	/* Make a key out of the record data to be inserted, and save it. */
-	cur->bc_ops->init_key_from_rec(&key, recp);
-
 	optr = ptr;
 
 	XFS_BTREE_STATS_INC(cur, insrec);
@@ -2989,10 +2984,10 @@ xfs_btree_insrec(
 	/* Check that the new entry is being inserted in the right place. */
 	if (ptr <= numrecs) {
 		if (level == 0) {
-			ASSERT(cur->bc_ops->recs_inorder(cur, recp,
+			ASSERT(cur->bc_ops->recs_inorder(cur, rec,
 				xfs_btree_rec_addr(cur, ptr, block)));
 		} else {
-			ASSERT(cur->bc_ops->keys_inorder(cur, &key,
+			ASSERT(cur->bc_ops->keys_inorder(cur, key,
 				xfs_btree_key_addr(cur, ptr, block)));
 		}
 	}
@@ -3005,7 +3000,7 @@ xfs_btree_insrec(
 	xfs_btree_set_ptr_null(cur, &nptr);
 	if (numrecs == cur->bc_ops->get_maxrecs(cur, level)) {
 		error = xfs_btree_make_block_unfull(cur, level, numrecs,
-					&optr, &ptr, &nptr, &ncur, &nrec, stat);
+					&optr, &ptr, &nptr, &ncur, &nkey, stat);
 		if (error || *stat == 0)
 			goto error0;
 	}
@@ -3055,7 +3050,7 @@ xfs_btree_insrec(
 #endif
 
 		/* Now put the new data in, bump numrecs and log it. */
-		xfs_btree_copy_keys(cur, kp, &key, 1);
+		xfs_btree_copy_keys(cur, kp, key, 1);
 		xfs_btree_copy_ptrs(cur, pp, ptrp, 1);
 		numrecs++;
 		xfs_btree_set_numrecs(block, numrecs);
@@ -3076,7 +3071,7 @@ xfs_btree_insrec(
 		xfs_btree_shift_recs(cur, rp, 1, numrecs - ptr + 1);
 
 		/* Now put the new data in, bump numrecs and log it. */
-		xfs_btree_copy_recs(cur, rp, recp, 1);
+		xfs_btree_copy_recs(cur, rp, rec, 1);
 		xfs_btree_set_numrecs(block, ++numrecs);
 		xfs_btree_log_recs(cur, bp, ptr, numrecs);
 #ifdef DEBUG
@@ -3092,7 +3087,7 @@ xfs_btree_insrec(
 
 	/* If we inserted at the start of a block, update the parents' keys. */
 	if (optr == 1) {
-		error = xfs_btree_updkey(cur, &key, level + 1);
+		error = xfs_btree_updkey(cur, key, level + 1);
 		if (error)
 			goto error0;
 	}
@@ -3102,7 +3097,7 @@ xfs_btree_insrec(
 	 * we are at the far right edge of the tree, update it.
 	 */
 	if (xfs_btree_is_lastrec(cur, block, level)) {
-		cur->bc_ops->update_lastrec(cur, block, recp,
+		cur->bc_ops->update_lastrec(cur, block, rec,
 					    ptr, LASTREC_INSREC);
 	}
 
@@ -3112,7 +3107,7 @@ xfs_btree_insrec(
 	 */
 	*ptrp = nptr;
 	if (!xfs_btree_ptr_is_null(cur, &nptr)) {
-		*recp = nrec;
+		*key = nkey;
 		*curp = ncur;
 	}
 
@@ -3143,6 +3138,7 @@ xfs_btree_insert(
 	union xfs_btree_ptr	nptr;	/* new block number (split result) */
 	struct xfs_btree_cur	*ncur;	/* new cursor (split result) */
 	struct xfs_btree_cur	*pcur;	/* previous level's cursor */
+	union xfs_btree_key	key;	/* key of block to insert */
 	union xfs_btree_rec	rec;	/* record to insert */
 
 	level = 0;
@@ -3150,7 +3146,10 @@ xfs_btree_insert(
 	pcur = cur;
 
 	xfs_btree_set_ptr_null(cur, &nptr);
+
+	/* Make a key out of the record data to be inserted, and save it. */
 	cur->bc_ops->init_rec_from_cur(cur, &rec);
+	cur->bc_ops->init_key_from_rec(&key, &rec);
 
 	/*
 	 * Loop going up the tree, starting at the leaf level.
@@ -3162,7 +3161,8 @@ xfs_btree_insert(
 		 * Insert nrec/nptr into this level of the tree.
 		 * Note if we fail, nptr will be null.
 		 */
-		error = xfs_btree_insrec(pcur, level, &nptr, &rec, &ncur, &i);
+		error = xfs_btree_insrec(pcur, level, &nptr, &rec, &key,
+				&ncur, &i);
 		if (error) {
 			if (pcur != cur)
 				xfs_btree_del_cursor(pcur, XFS_BTREE_ERROR);
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 785a996..b4f3035 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -158,8 +158,6 @@ struct xfs_btree_ops {
 	/* init values of btree structures */
 	void	(*init_key_from_rec)(union xfs_btree_key *key,
 				     union xfs_btree_rec *rec);
-	void	(*init_rec_from_key)(union xfs_btree_key *key,
-				     union xfs_btree_rec *rec);
 	void	(*init_rec_from_cur)(struct xfs_btree_cur *cur,
 				     union xfs_btree_rec *rec);
 	void	(*init_ptr_from_cur)(struct xfs_btree_cur *cur,
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 89c21d7..88da2ad 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -146,14 +146,6 @@ xfs_inobt_init_key_from_rec(
 }
 
 STATIC void
-xfs_inobt_init_rec_from_key(
-	union xfs_btree_key	*key,
-	union xfs_btree_rec	*rec)
-{
-	rec->inobt.ir_startino = key->inobt.ir_startino;
-}
-
-STATIC void
 xfs_inobt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
@@ -314,7 +306,6 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.get_minrecs		= xfs_inobt_get_minrecs,
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
-	.init_rec_from_key	= xfs_inobt_init_rec_from_key,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
@@ -336,7 +327,6 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 	.get_minrecs		= xfs_inobt_get_minrecs,
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
-	.init_rec_from_key	= xfs_inobt_init_rec_from_key,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
