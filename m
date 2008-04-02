Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 23:26:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m326QXgu006083
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 23:26:36 -0700
Message-Id: <20080402062708.380299192@chook.melbourne.sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com>
Date: Wed, 02 Apr 2008 16:25:11 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 3/7] XFS: Refactor node format directory lookup/addname
Content-Disposition: inline; filename=refactor_leafn_lookup.patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

The next step for case-insensitive support is to avoid polution of
the dentry cache with entries pointing to the same inode, but with
names that only differ in case.

To perform this, we will need to pass the actual filename that
matched backup to the XFS/VFS interface and make sure the dentry
cache only contains entries with the actual case-sensitive name.

But, before we can do this, it was found that the directory lookup
code with multiple leaves was shared with code adding a name to
that directory. Most of xfs_dir2_leafn_lookup_int() could be broken
into two functions determined by if (args->addname) { } else { }.

For the following patch, only the lookup case needs to handle the
various xfs_nameops, with case-insensitive match handling in
addition to returning the actual name.

So, this patch separates xfs_dir2_leafn_lookup_int() into
xfs_dir2_leafn_lookup_for_addname() and xfs_dir2_leafn_lookup_for_entry().

xfs_dir2_leafn_lookup_for_addname() iterates through the data blocks looking
for a suitable empty space to insert the name while
xfs_dir2_leafn_lookup_for_entry() uses the xfs_nameops to find the entry.

xfs_dir2_leafn_lookup_for_entry() path also retains the data block where
the first case-insensitive match occured as in the next patch which will
return the name, the name is obtained from that block.

Signed-off-by: Barry Naujok <bnaujok@sgi.com>

---
 fs/xfs/xfs_dir2_node.c |  373 +++++++++++++++++++++++++++++--------------------
 1 file changed, 225 insertions(+), 148 deletions(-)

Index: kern_ci/fs/xfs/xfs_dir2_node.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_node.c
+++ kern_ci/fs/xfs/xfs_dir2_node.c
@@ -387,12 +387,11 @@ xfs_dir2_leafn_lasthash(
 }
 
 /*
- * Look up a leaf entry in a node-format leaf block.
- * If this is an addname then the extrablk in state is a freespace block,
- * otherwise it's a data block.
+ * Look up a leaf entry for space to add a name in a node-format leaf block.
+ * The extrablk in state is a freespace block.
  */
-int
-xfs_dir2_leafn_lookup_int(
+static int
+xfs_dir2_leafn_lookup_for_addname(
 	xfs_dabuf_t		*bp,		/* leaf buffer */
 	xfs_da_args_t		*args,		/* operation arguments */
 	int			*indexp,	/* out: leaf entry index */
@@ -401,7 +400,6 @@ xfs_dir2_leafn_lookup_int(
 	xfs_dabuf_t		*curbp;		/* current data/free buffer */
 	xfs_dir2_db_t		curdb;		/* current data block number */
 	xfs_dir2_db_t		curfdb;		/* current free block number */
-	xfs_dir2_data_entry_t	*dep;		/* data block entry */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return value */
 	int			fi;		/* free entry index */
@@ -414,7 +412,6 @@ xfs_dir2_leafn_lookup_int(
 	xfs_dir2_db_t		newdb;		/* new data block number */
 	xfs_dir2_db_t		newfdb;		/* new free block number */
 	xfs_trans_t		*tp;		/* transaction pointer */
-	xfs_dacmp_t		cmp;		/* comparison result */
 
 	dp = args->dp;
 	tp = args->trans;
@@ -432,27 +429,15 @@ xfs_dir2_leafn_lookup_int(
 	/*
 	 * Do we have a buffer coming in?
 	 */
-	if (state->extravalid)
-		curbp = state->extrablk.bp;
-	else
-		curbp = NULL;
+	curbp = state->extravalid ? state->extrablk.bp : NULL;
 	/*
 	 * For addname, it's a free block buffer, get the block number.
 	 */
-	if (args->addname) {
-		curfdb = curbp ? state->extrablk.blkno : -1;
-		curdb = -1;
-		length = xfs_dir2_data_entsize(args->namelen);
-		if ((free = (curbp ? curbp->data : NULL)))
-			ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
-	}
-	/*
-	 * For others, it's a data block buffer, get the block number.
-	 */
-	else {
-		curfdb = -1;
-		curdb = curbp ? state->extrablk.blkno : -1;
-	}
+	curfdb = curbp ? state->extrablk.blkno : -1;
+	free = curbp ? curbp->data : NULL;
+	curdb = -1;
+	length = xfs_dir2_data_entsize(args->namelen);
+	ASSERT(!free || be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
@@ -472,134 +457,69 @@ xfs_dir2_leafn_lookup_int(
 		 * For addname, we're looking for a place to put the new entry.
 		 * We want to use a data block with an entry of equal
 		 * hash value to ours if there is one with room.
+		 *
+		 * If this block isn't the data block we already have
+		 * in hand, take a look at it.
 		 */
-		if (args->addname) {
+		if (newdb != curdb) {
+			curdb = newdb;
 			/*
-			 * If this block isn't the data block we already have
-			 * in hand, take a look at it.
+			 * Convert the data block to the free block
+			 * holding its freespace information.
 			 */
-			if (newdb != curdb) {
-				curdb = newdb;
-				/*
-				 * Convert the data block to the free block
-				 * holding its freespace information.
-				 */
-				newfdb = xfs_dir2_db_to_fdb(mp, newdb);
-				/*
-				 * If it's not the one we have in hand,
-				 * read it in.
-				 */
-				if (newfdb != curfdb) {
-					/*
-					 * If we had one before, drop it.
-					 */
-					if (curbp)
-						xfs_da_brelse(tp, curbp);
-					/*
-					 * Read the free block.
-					 */
-					if ((error = xfs_da_read_buf(tp, dp,
-							xfs_dir2_db_to_da(mp,
-								newfdb),
-							-1, &curbp,
-							XFS_DATA_FORK))) {
-						return error;
-					}
-					free = curbp->data;
-					ASSERT(be32_to_cpu(free->hdr.magic) ==
-					       XFS_DIR2_FREE_MAGIC);
-					ASSERT((be32_to_cpu(free->hdr.firstdb) %
-						XFS_DIR2_MAX_FREE_BESTS(mp)) ==
-					       0);
-					ASSERT(be32_to_cpu(free->hdr.firstdb) <= curdb);
-					ASSERT(curdb <
-					       be32_to_cpu(free->hdr.firstdb) +
-					       be32_to_cpu(free->hdr.nvalid));
-				}
-				/*
-				 * Get the index for our entry.
-				 */
-				fi = xfs_dir2_db_to_fdindex(mp, curdb);
-				/*
-				 * If it has room, return it.
-				 */
-				if (unlikely(be16_to_cpu(free->bests[fi]) == NULLDATAOFF)) {
-					XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
-							 XFS_ERRLEVEL_LOW, mp);
-					if (curfdb != newfdb)
-						xfs_da_brelse(tp, curbp);
-					return XFS_ERROR(EFSCORRUPTED);
-				}
-				curfdb = newfdb;
-				if (be16_to_cpu(free->bests[fi]) >= length) {
-					*indexp = index;
-					state->extravalid = 1;
-					state->extrablk.bp = curbp;
-					state->extrablk.blkno = curfdb;
-					state->extrablk.index = fi;
-					state->extrablk.magic =
-						XFS_DIR2_FREE_MAGIC;
-					ASSERT(args->oknoent);
-					return XFS_ERROR(ENOENT);
-				}
-			}
-		}
-		/*
-		 * Not adding a new entry, so we really want to find
-		 * the name given to us.
-		 */
-		else {
+			newfdb = xfs_dir2_db_to_fdb(mp, newdb);
 			/*
-			 * If it's a different data block, go get it.
+			 * If it's not the one we have in hand,
+			 * read it in.
 			 */
-			if (newdb != curdb) {
+			if (newfdb != curfdb) {
 				/*
-				 * If we had a block before, drop it.
+				 * If we had one before, drop it.
 				 */
 				if (curbp)
 					xfs_da_brelse(tp, curbp);
 				/*
-				 * Read the data block.
+				 * Read the free block.
 				 */
-				if ((error =
-				    xfs_da_read_buf(tp, dp,
-					    xfs_dir2_db_to_da(mp, newdb), -1,
-					    &curbp, XFS_DATA_FORK))) {
+				error = xfs_da_read_buf(tp, dp,
+						xfs_dir2_db_to_da(mp, newfdb),
+						-1, &curbp, XFS_DATA_FORK);
+				if (error)
 					return error;
-				}
-				xfs_dir2_data_check(dp, curbp);
-				curdb = newdb;
+
+				free = curbp->data;
+				ASSERT(be32_to_cpu(free->hdr.magic) ==
+				       XFS_DIR2_FREE_MAGIC);
+				ASSERT((be32_to_cpu(free->hdr.firstdb) %
+					XFS_DIR2_MAX_FREE_BESTS(mp)) == 0);
+				ASSERT(be32_to_cpu(free->hdr.firstdb) <= curdb);
+				ASSERT(curdb < be32_to_cpu(free->hdr.firstdb) +
+				       be32_to_cpu(free->hdr.nvalid));
 			}
 			/*
-			 * Point to the data entry.
+			 * Get the index for our entry.
+			 */
+			fi = xfs_dir2_db_to_fdindex(mp, curdb);
+			/*
+			 * If it has room, return it.
 			 */
-			dep = (xfs_dir2_data_entry_t *)
-			      ((char *)curbp->data +
-			       xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
-			/*
-			 * Compare the entry, return it if it matches.
-			 */
-			cmp = args->oknoent ?
-				xfs_dir_compname(dp, dep->name, dep->namelen,
-						args->name, args->namelen):
-				xfs_da_compname(dep->name, dep->namelen,
-						args->name, args->namelen);
-			if (cmp != XFS_CMP_DIFFERENT &&
-					cmp != args->cmpresult) {
-				args->cmpresult = cmp;
-				args->inumber = be64_to_cpu(dep->inumber);
+			if (unlikely(be16_to_cpu(free->bests[fi]) == NULLDATAOFF)) {
+				XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
+						 XFS_ERRLEVEL_LOW, mp);
+				if (curfdb != newfdb)
+					xfs_da_brelse(tp, curbp);
+				return XFS_ERROR(EFSCORRUPTED);
+			}
+			curfdb = newfdb;
+			if (be16_to_cpu(free->bests[fi]) >= length) {
 				*indexp = index;
-				if (cmp == XFS_CMP_EXACT) {
-					state->extravalid = 1;
-					state->extrablk.blkno = curdb;
-					state->extrablk.index =
-						(int)((char *)dep -
-						      (char *)curbp->data);
-					state->extrablk.magic =
-						XFS_DIR2_DATA_MAGIC;
-					state->extrablk.bp = curbp;
-					return XFS_ERROR(EEXIST);
-				}
+				state->extravalid = 1;
+				state->extrablk.bp = curbp;
+				state->extrablk.blkno = curfdb;
+				state->extrablk.index = fi;
+				state->extrablk.magic = XFS_DIR2_FREE_MAGIC;
+				ASSERT(args->oknoent);
+				return XFS_ERROR(ENOENT);
 			}
 		}
 	}
@@ -608,31 +528,166 @@ xfs_dir2_leafn_lookup_int(
 	 * If we are holding a buffer, give it back in case our caller
 	 * finds it useful.
 	 */
-	if ((state->extravalid = (curbp != NULL))) {
+	if (curbp != NULL) {
+		state->extravalid = 1;
 		state->extrablk.bp = curbp;
 		state->extrablk.index = -1;
 		/*
 		 * For addname, giving back a free block.
 		 */
-		if (args->addname) {
-			state->extrablk.blkno = curfdb;
-			state->extrablk.magic = XFS_DIR2_FREE_MAGIC;
+		state->extrablk.blkno = curfdb;
+		state->extrablk.magic = XFS_DIR2_FREE_MAGIC;
+	}
+	/*
+	 * Return the final index, that will be the insertion point.
+	 */
+	*indexp = index;
+	ASSERT(index == be16_to_cpu(leaf->hdr.count) || args->oknoent);
+	return XFS_ERROR(ENOENT);
+}
+
+/*
+ * Look up a leaf entry in a node-format leaf block.
+ * The extrablk in state a data block.
+ */
+static int
+xfs_dir2_leafn_lookup_for_entry(
+	xfs_dabuf_t		*bp,		/* leaf buffer */
+	xfs_da_args_t		*args,		/* operation arguments */
+	int			*indexp,	/* out: leaf entry index */
+	xfs_da_state_t		*state)		/* state to fill in */
+{
+	xfs_dabuf_t		*curbp;		/* current data/free buffer */
+	xfs_dir2_db_t		curdb;		/* current data block number */
+	xfs_dir2_data_entry_t	*dep;		/* data block entry */
+	xfs_inode_t		*dp;		/* incore directory inode */
+	int			error;		/* error return value */
+	int			index;		/* leaf entry index */
+	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
+	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
+	xfs_mount_t		*mp;		/* filesystem mount point */
+	xfs_dir2_db_t		newdb;		/* new data block number */
+	xfs_trans_t		*tp;		/* transaction pointer */
+	xfs_dacmp_t		cmp;		/* comparison result */
+	xfs_dabuf_t		*ci_bp = NULL;	/* buffer with CI match */
+
+	dp = args->dp;
+	tp = args->trans;
+	mp = dp->i_mount;
+	leaf = bp->data;
+	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
+#ifdef __KERNEL__
+	ASSERT(be16_to_cpu(leaf->hdr.count) > 0);
+#endif
+	xfs_dir2_leafn_check(dp, bp);
+	/*
+	 * Look up the hash value in the leaf entries.
+	 */
+	index = xfs_dir2_leaf_search_hash(args, bp);
+	/*
+	 * Do we have a buffer coming in?
+	 */
+	if (state->extravalid) {
+		curbp = state->extrablk.bp;
+		curdb = state->extrablk.blkno;
+		if (args->cmpresult == XFS_CMP_CASE)
+			ci_bp = curbp;
+	} else {
+		curbp = NULL;
+		curdb = -1;
+	}
+	/*
+	 * Loop over leaf entries with the right hash value.
+	 */
+	for (lep = &leaf->ents[index];
+	     index < be16_to_cpu(leaf->hdr.count) &&
+			be32_to_cpu(lep->hashval) == args->hashval;
+	     lep++, index++) {
+		/*
+		 * Skip stale leaf entries.
+		 */
+		if (be32_to_cpu(lep->address) == XFS_DIR2_NULL_DATAPTR)
+			continue;
+		/*
+		 * Pull the data block number from the entry.
+		 */
+		newdb = xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
+		/*
+		 * Not adding a new entry, so we really want to find
+		 * the name given to us.
+		 *
+		 * If it's a different data block, go get it.
+		 */
+		if (newdb != curdb) {
+			/*
+			 * If we had a block before, drop it (unless it
+			 * contains a case-insensitive match).
+			 */
+			if (curbp && curbp != ci_bp)
+				xfs_da_brelse(tp, curbp);
+			/*
+			 * Read the data block.
+			 */
+			error = xfs_da_read_buf(tp, dp,
+					xfs_dir2_db_to_da(mp, newdb), -1,
+					&curbp, XFS_DATA_FORK);
+			if (error)
+				return error;
+			xfs_dir2_data_check(dp, curbp);
+			curdb = newdb;
 		}
 		/*
-		 * For other callers, giving back a data block.
+		 * Point to the data entry.
 		 */
-		else {
+		dep = (xfs_dir2_data_entry_t *)((char *)curbp->data +
+			xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
+		/*
+		 * Compare the entry, return it if it matches.
+		 */
+		cmp = args->oknoent ?
+			xfs_dir_compname(dp, dep->name, dep->namelen,
+					args->name, args->namelen):
+			xfs_da_compname(dep->name, dep->namelen,
+					args->name, args->namelen);
+		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
+			args->cmpresult = cmp;
+			args->inumber = be64_to_cpu(dep->inumber);
+			*indexp = index;
+			if (ci_bp && ci_bp != curbp)
+				xfs_da_brelse(tp, ci_bp);
+			state->extravalid = 1;
 			state->extrablk.blkno = curdb;
+			state->extrablk.index = (int)((char *)dep -
+					(char *)curbp->data);
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
+			state->extrablk.bp = curbp;
+			if (cmp == XFS_CMP_EXACT)
+				return XFS_ERROR(EEXIST);
 		}
 	}
 	/*
-	 * For lookup (where args->oknoent is set, and args->addname is not
-	 * set, the state->extrablk info is not used, just freed.
+	 * if we have a case-insensitive match, we have to return ENOENT
+	 * so xfs_da_node_lookup_int() can try the next leaf if one exists
+	 * for the hash that may have an exact match.
+	 * xfs_dir2_node_lookup() below handles the ENOENT and args->cmpresult
+	 * to find the case-insensitive match and returns EEXIST.
 	 */
-	if (args->cmpresult == XFS_CMP_CASE) {
-		ASSERT(!args->addname);
-		return XFS_ERROR(EEXIST);
+	if (args->cmpresult == XFS_CMP_CASE)
+		return XFS_ERROR(ENOENT);
+	/*
+	 * Didn't find a match.
+	 * If we are holding a buffer, give it back in case our caller
+	 * finds it useful.
+	 */
+	if (curbp != NULL) {
+		state->extravalid = 1;
+		state->extrablk.bp = curbp;
+		state->extrablk.index = -1;
+		/*
+		 * Giving back a data block.
+		 */
+		state->extrablk.blkno = curdb;
+		state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
 	}
 	/*
 	 * Return the final index, that will be the insertion point.
@@ -643,6 +698,23 @@ xfs_dir2_leafn_lookup_int(
 }
 
 /*
+ * Look up a leaf entry in a node-format leaf block.
+ * If this is an addname then the extrablk in state is a freespace block,
+ * otherwise it's a data block.
+ */
+int
+xfs_dir2_leafn_lookup_int(
+	xfs_dabuf_t		*bp,		/* leaf buffer */
+	xfs_da_args_t		*args,		/* operation arguments */
+	int			*indexp,	/* out: leaf entry index */
+	xfs_da_state_t		*state)		/* state to fill in */
+{
+	return args->addname ?
+		xfs_dir2_leafn_lookup_for_addname(bp, args, indexp, state) :
+		xfs_dir2_leafn_lookup_for_entry(bp, args, indexp, state);
+}
+
+/*
  * Move count leaf entries from source to destination leaf.
  * Log entries and headers.  Stale entries are preserved.
  */
@@ -1785,6 +1857,11 @@ xfs_dir2_node_lookup(
 	if (error)
 		rval = error;
 	/*
+	 * If case-insensitive match was found in a leaf, return EEXIST.
+	 */
+	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE)
+		rval = EEXIST;
+	/*
 	 * Release the btree blocks and leaf block.
 	 */
 	for (i = 0; i < state->path.active; i++) {

-- 
