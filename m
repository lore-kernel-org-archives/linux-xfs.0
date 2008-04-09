Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 01:47:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m398lDk9001208
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 01:47:15 -0700
Date: Wed, 09 Apr 2008 18:49:29 +1000
Subject: [REVIEW #2] cleanup -  refactor xfs_dir2_leafn_lookup_int()
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------pTyqiSRFmxcVjyw31j8o5M
MIME-Version: 1.0
Message-ID: <op.t9b5grqp3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

------------pTyqiSRFmxcVjyw31j8o5M
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

I've unified the state->extrablk info in the add and lookup paths
and fixed a bug :)


---
  fs/xfs/xfs_dir2_node.c |  364=20=20
+++++++++++++++++++++++++++----------------------
  1 file changed, 205 insertions(+), 159 deletions(-)

Index: kern_ci/fs/xfs/xfs_dir2_node.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_dir2_node.c
+++ kern_ci/fs/xfs/xfs_dir2_node.c
@@ -387,28 +387,26 @@ xfs_dir2_leafn_lasthash(
  }

  /*
- * Look up a leaf entry in a node-format leaf block.
- * If this is an addname then the extrablk in state is a freespace block,
- * otherwise it's a data block.
+ * Look up a leaf entry for space to add a name in a node-format leaf=20=
=20
block.
+ * The extrablk in state is a freespace block.
   */
-int
-xfs_dir2_leafn_lookup_int(
+STATIC int
+xfs_dir2_leafn_lookup_for_addname(
  	xfs_dabuf_t		*bp,		/* leaf buffer */
  	xfs_da_args_t		*args,		/* operation arguments */
  	int			*indexp,	/* out: leaf entry index */
  	xfs_da_state_t		*state)		/* state to fill in */
  {
-	xfs_dabuf_t		*curbp;		/* current data/free buffer */
-	xfs_dir2_db_t		curdb;		/* current data block number */
-	xfs_dir2_db_t		curfdb;		/* current free block number */
-	xfs_dir2_data_entry_t	*dep;		/* data block entry */
+	xfs_dabuf_t		*curbp =3D NULL;	/* current data/free buffer */
+	xfs_dir2_db_t		curdb =3D -1;	/* current data block number */
+	xfs_dir2_db_t		curfdb =3D -1;	/* current free block number */
  	xfs_inode_t		*dp;		/* incore directory inode */
  	int			error;		/* error return value */
  	int			fi;		/* free entry index */
-	xfs_dir2_free_t		*free=3DNULL;	/* free block structure */
+	xfs_dir2_free_t		*free =3D NULL;	/* free block structure */
  	int			index;		/* leaf entry index */
  	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
-	int			length=3D0;	/* length of new data entry */
+	int			length;		/* length of new data entry */
  	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
  	xfs_mount_t		*mp;		/* filesystem mount point */
  	xfs_dir2_db_t		newdb;		/* new data block number */
@@ -431,33 +429,20 @@ xfs_dir2_leafn_lookup_int(
  	/*
  	 * Do we have a buffer coming in?
  	 */
-	if (state->extravalid)
+	if (state->extravalid) {
+		/* If so, it's a free block buffer, get the block number. */
  		curbp =3D state->extrablk.bp;
-	else
-		curbp =3D NULL;
-	/*
-	 * For addname, it's a free block buffer, get the block number.
-	 */
-	if (args->addname) {
-		curfdb =3D curbp ? state->extrablk.blkno : -1;
-		curdb =3D -1;
-		length =3D xfs_dir2_data_entsize(args->namelen);
-		if ((free =3D (curbp ? curbp->data : NULL)))
-			ASSERT(be32_to_cpu(free->hdr.magic) =3D=3D XFS_DIR2_FREE_MAGIC);
-	}
-	/*
-	 * For others, it's a data block buffer, get the block number.
-	 */
-	else {
-		curfdb =3D -1;
-		curdb =3D curbp ? state->extrablk.blkno : -1;
+		curfdb =3D state->extrablk.blkno;
+		free =3D curbp->data;
+		ASSERT(be32_to_cpu(free->hdr.magic) =3D=3D XFS_DIR2_FREE_MAGIC);
  	}
+	length =3D xfs_dir2_data_entsize(args->namelen);
  	/*
  	 * Loop over leaf entries with the right hash value.
  	 */
-	for (lep =3D &leaf->ents[index];
-	     index < be16_to_cpu(leaf->hdr.count) && be32_to_cpu(lep->hashval)=20=
=20
=3D=3D args->hashval;
-	     lep++, index++) {
+	for (lep =3D &leaf->ents[index]; index < be16_to_cpu(leaf->hdr.count) &&
+				be32_to_cpu(lep->hashval) =3D=3D args->hashval;
+				lep++, index++) {
  		/*
  		 * Skip stale leaf entries.
  		 */
@@ -471,158 +456,218 @@ xfs_dir2_leafn_lookup_int(
  		 * For addname, we're looking for a place to put the new entry.
  		 * We want to use a data block with an entry of equal
  		 * hash value to ours if there is one with room.
+		 *
+		 * If this block isn't the data block we already have
+		 * in hand, take a look at it.
  		 */
-		if (args->addname) {
+		if (newdb !=3D curdb) {
+			curdb =3D newdb;
  			/*
-			 * If this block isn't the data block we already have
-			 * in hand, take a look at it.
+			 * Convert the data block to the free block
+			 * holding its freespace information.
  			 */
-			if (newdb !=3D curdb) {
-				curdb =3D newdb;
-				/*
-				 * Convert the data block to the free block
-				 * holding its freespace information.
-				 */
-				newfdb =3D xfs_dir2_db_to_fdb(mp, newdb);
-				/*
-				 * If it's not the one we have in hand,
-				 * read it in.
-				 */
-				if (newfdb !=3D curfdb) {
-					/*
-					 * If we had one before, drop it.
-					 */
-					if (curbp)
-						xfs_da_brelse(tp, curbp);
-					/*
-					 * Read the free block.
-					 */
-					if ((error =3D xfs_da_read_buf(tp, dp,
-							xfs_dir2_db_to_da(mp,
-								newfdb),
-							-1, &curbp,
-							XFS_DATA_FORK))) {
-						return error;
-					}
-					free =3D curbp->data;
-					ASSERT(be32_to_cpu(free->hdr.magic) =3D=3D
-					       XFS_DIR2_FREE_MAGIC);
-					ASSERT((be32_to_cpu(free->hdr.firstdb) %
-						XFS_DIR2_MAX_FREE_BESTS(mp)) =3D=3D
-					       0);
-					ASSERT(be32_to_cpu(free->hdr.firstdb) <=3D curdb);
-					ASSERT(curdb <
-					       be32_to_cpu(free->hdr.firstdb) +
-					       be32_to_cpu(free->hdr.nvalid));
-				}
-				/*
-				 * Get the index for our entry.
-				 */
-				fi =3D xfs_dir2_db_to_fdindex(mp, curdb);
-				/*
-				 * If it has room, return it.
-				 */
-				if (unlikely(be16_to_cpu(free->bests[fi]) =3D=3D NULLDATAOFF)) {
-					XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
-							 XFS_ERRLEVEL_LOW, mp);
-					if (curfdb !=3D newfdb)
-						xfs_da_brelse(tp, curbp);
-					return XFS_ERROR(EFSCORRUPTED);
-				}
-				curfdb =3D newfdb;
-				if (be16_to_cpu(free->bests[fi]) >=3D length) {
-					*indexp =3D index;
-					state->extravalid =3D 1;
-					state->extrablk.bp =3D curbp;
-					state->extrablk.blkno =3D curfdb;
-					state->extrablk.index =3D fi;
-					state->extrablk.magic =3D
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
+			newfdb =3D xfs_dir2_db_to_fdb(mp, newdb);
  			/*
-			 * If it's a different data block, go get it.
+			 * If it's not the one we have in hand, read it in.
  			 */
-			if (newdb !=3D curdb) {
+			if (newfdb !=3D curfdb) {
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
-				if ((error =3D
-				    xfs_da_read_buf(tp, dp,
-					    xfs_dir2_db_to_da(mp, newdb), -1,
-					    &curbp, XFS_DATA_FORK))) {
+				error =3D xfs_da_read_buf(tp, dp,
+						xfs_dir2_db_to_da(mp, newfdb),
+						-1, &curbp, XFS_DATA_FORK);
+				if (error)
  					return error;
-				}
-				xfs_dir2_data_check(dp, curbp);
-				curdb =3D newdb;
+				free =3D curbp->data;
+				ASSERT(be32_to_cpu(free->hdr.magic) =3D=3D
+					XFS_DIR2_FREE_MAGIC);
+				ASSERT((be32_to_cpu(free->hdr.firstdb) %
+					XFS_DIR2_MAX_FREE_BESTS(mp)) =3D=3D 0);
+				ASSERT(be32_to_cpu(free->hdr.firstdb) <=3D curdb);
+				ASSERT(curdb < be32_to_cpu(free->hdr.firstdb) +
+					be32_to_cpu(free->hdr.nvalid));
  			}
  			/*
-			 * Point to the data entry.
+			 * Get the index for our entry.
+			 */
+			fi =3D xfs_dir2_db_to_fdindex(mp, curdb);
+			/*
+			 * If it has room, return it.
  			 */
-			dep =3D (xfs_dir2_data_entry_t *)
-			      ((char *)curbp->data +
-			       xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
-			/*
-			 * Compare the entry, return it if it matches.
-			 */
-			if (dep->namelen =3D=3D args->namelen &&
-			    dep->name[0] =3D=3D args->name[0] &&
-			    memcmp(dep->name, args->name, args->namelen) =3D=3D 0) {
-				args->inumber =3D be64_to_cpu(dep->inumber);
-				*indexp =3D index;
-				state->extravalid =3D 1;
-				state->extrablk.bp =3D curbp;
-				state->extrablk.blkno =3D curdb;
-				state->extrablk.index =3D
-					(int)((char *)dep -
-					      (char *)curbp->data);
-				state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
-				return XFS_ERROR(EEXIST);
+			if (unlikely(be16_to_cpu(free->bests[fi]) =3D=3D NULLDATAOFF)) {
+				XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
+							XFS_ERRLEVEL_LOW, mp);
+				if (curfdb !=3D newfdb)
+					xfs_da_brelse(tp, curbp);
+				return XFS_ERROR(EFSCORRUPTED);
  			}
+			curfdb =3D newfdb;
+			if (be16_to_cpu(free->bests[fi]) >=3D length)
+				goto out;
  		}
  	}
+	/* Didn't find any space */
+	fi =3D -1;
+out:
+	ASSERT(args->oknoent);
+	if (curbp) {
+		/* Giving back a free block. */
+		state->extravalid =3D 1;
+		state->extrablk.bp =3D curbp;
+		state->extrablk.index =3D fi;
+		state->extrablk.blkno =3D curfdb;
+		state->extrablk.magic =3D XFS_DIR2_FREE_MAGIC;
+	} else {
+		state->extravalid =3D 0;
+	}
  	/*
-	 * Didn't find a match.
-	 * If we are holding a buffer, give it back in case our caller
-	 * finds it useful.
+	 * Return the index, that will be the insertion point.
  	 */
-	if ((state->extravalid =3D (curbp !=3D NULL))) {
-		state->extrablk.bp =3D curbp;
-		state->extrablk.index =3D -1;
+	*indexp =3D index;
+	return XFS_ERROR(ENOENT);
+}
+
+/*
+ * Look up a leaf entry in a node-format leaf block.
+ * The extrablk in state a data block.
+ */
+STATIC int
+xfs_dir2_leafn_lookup_for_entry(
+	xfs_dabuf_t		*bp,		/* leaf buffer */
+	xfs_da_args_t		*args,		/* operation arguments */
+	int			*indexp,	/* out: leaf entry index */
+	xfs_da_state_t		*state)		/* state to fill in */
+{
+	xfs_dabuf_t		*curbp =3D NULL;	/* current data/free buffer */
+	xfs_dir2_db_t		curdb =3D -1;	/* current data block number */
+	xfs_dir2_data_entry_t	*dep;		/* data block entry */
+	xfs_inode_t		*dp;		/* incore directory inode */
+	int			error;		/* error return value */
+	int			di;		/* data entry index */
+	int			index;		/* leaf entry index */
+	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
+	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
+	xfs_mount_t		*mp;		/* filesystem mount point */
+	xfs_dir2_db_t		newdb;		/* new data block number */
+	xfs_trans_t		*tp;		/* transaction pointer */
+
+	dp =3D args->dp;
+	tp =3D args->trans;
+	mp =3D dp->i_mount;
+	leaf =3D bp->data;
+	ASSERT(be16_to_cpu(leaf->hdr.info.magic) =3D=3D XFS_DIR2_LEAFN_MAGIC);
+#ifdef __KERNEL__
+	ASSERT(be16_to_cpu(leaf->hdr.count) > 0);
+#endif
+	xfs_dir2_leafn_check(dp, bp);
+	/*
+	 * Look up the hash value in the leaf entries.
+	 */
+	index =3D xfs_dir2_leaf_search_hash(args, bp);
+	/*
+	 * Do we have a buffer coming in?
+	 */
+	if (state->extravalid) {
+		curbp =3D state->extrablk.bp;
+		curdb =3D state->extrablk.blkno;
+	}
+	/*
+	 * Loop over leaf entries with the right hash value.
+	 */
+	for (lep =3D &leaf->ents[index]; index < be16_to_cpu(leaf->hdr.count) &&
+				be32_to_cpu(lep->hashval) =3D=3D args->hashval;
+				lep++, index++) {
  		/*
-		 * For addname, giving back a free block.
+		 * Skip stale leaf entries.
  		 */
-		if (args->addname) {
-			state->extrablk.blkno =3D curfdb;
-			state->extrablk.magic =3D XFS_DIR2_FREE_MAGIC;
-		}
+		if (be32_to_cpu(lep->address) =3D=3D XFS_DIR2_NULL_DATAPTR)
+			continue;
  		/*
-		 * For other callers, giving back a data block.
+		 * Pull the data block number from the entry.
  		 */
-		else {
-			state->extrablk.blkno =3D curdb;
-			state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
+		newdb =3D xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
+		/*
+		 * Not adding a new entry, so we really want to find
+		 * the name given to us.
+		 *
+		 * If it's a different data block, go get it.
+		 */
+		if (newdb !=3D curdb) {
+			/*
+			 * If we had a block before, drop it.
+			 */
+			if (curbp)
+				xfs_da_brelse(tp, curbp);
+			/*
+			 * Read the data block.
+			 */
+			error =3D xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp,
+					newdb), -1, &curbp, XFS_DATA_FORK);
+			if (error)
+				return error;
+			xfs_dir2_data_check(dp, curbp);
+			curdb =3D newdb;
  		}
+		/*
+		 * Point to the data entry.
+		 */
+		dep =3D (xfs_dir2_data_entry_t *)((char *)curbp->data +
+			xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
+		/*
+		 * Compare the entry, return it if it matches.
+		 */
+		if (dep->namelen =3D=3D args->namelen && memcmp(dep->name,
+					args->name, args->namelen) =3D=3D 0) {
+			args->inumber =3D be64_to_cpu(dep->inumber);
+			di =3D (int)((char *)dep - (char *)curbp->data);
+			error =3D EEXIST;
+			goto out;
+		}
+	}
+	/* Didn't find a match. */
+	error =3D ENOENT;
+	di =3D -1;
+	ASSERT(index =3D=3D be16_to_cpu(leaf->hdr.count) || args->oknoent);
+out:
+	if (curbp) {
+		/* Giving back a data block. */
+		state->extravalid =3D 1;
+		state->extrablk.bp =3D curbp;
+		state->extrablk.index =3D di;
+		state->extrablk.blkno =3D curdb;
+		state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
+	} else {
+		state->extravalid =3D 0;
  	}
  	/*
-	 * Return the final index, that will be the insertion point.
+	 * Return the index, that will be the insertion point.
  	 */
  	*indexp =3D index;
-	ASSERT(index =3D=3D be16_to_cpu(leaf->hdr.count) || args->oknoent);
-	return XFS_ERROR(ENOENT);
+	return XFS_ERROR(error);
+}
+
+/*
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
+	if (args->addname)
+		return xfs_dir2_leafn_lookup_for_addname(bp, args, indexp,
+							state);
+	return xfs_dir2_leafn_lookup_for_entry(bp, args, indexp, state);
  }

  /*
@@ -823,9 +868,10 @@ xfs_dir2_leafn_rebalance(
  	 */
  	if (!state->inleaf)
  		blk2->index =3D blk1->index - be16_to_cpu(leaf1->hdr.count);
-=09
-	/*
-	 * Finally sanity check just to make sure we are not returning a=20=20
negative index
+
+	/*
+	 * Finally sanity check just to make sure we are not returning a
+	 * negative index
  	 */
  	if(blk2->index < 0) {
  		state->inleaf =3D 1;
------------pTyqiSRFmxcVjyw31j8o5M
Content-Disposition: attachment; filename=refactor_leafn_lookup.patch
Content-Type: text/x-patch; name=refactor_leafn_lookup.patch
Content-Transfer-Encoding: Quoted-Printable

The next step for case-insensitive support is to avoid polution of
the dentry cache with entries pointing to the same inode, but with
names that only differ in case.
=20
To perform this, we will need to pass the actual filename that
matched backup to the XFS/VFS interface and make sure the dentry
cache only contains entries with the actual case-sensitive name.
=20
But, before we can do this, it was found that the directory lookup
code with multiple leaves was shared with code adding a name to
that directory. Most of xfs_dir2_leafn_lookup_int() could be broken
into two functions determined by if (args->addname) { } else { }.
=20
For the following patch, only the lookup case needs to handle the
various xfs_nameops, with case-insensitive match handling in
addition to returning the actual name.
=20
So, this patch separates xfs_dir2_leafn_lookup_int() into
xfs_dir2_leafn_lookup_for_addname() and xfs_dir2_leafn_lookup_for_entry().
=20
xfs_dir2_leafn_lookup_for_addname() iterates through the data blocks looking
for a suitable empty space to insert the name while
xfs_dir2_leafn_lookup_for_entry() uses the xfs_nameops to find the entry.
=20
xfs_dir2_leafn_lookup_for_entry() path also retains the data block where
the first case-insensitive match occured as in the next patch which will
return the name, the name is obtained from that block.
=20
Signed-off-by: Barry Naujok <bnaujok@sgi.com>
=20
---
 fs/xfs/xfs_dir2_node.c |  364 +++++++++++++++++++++++++++-----------------=
-----
 1 file changed, 205 insertions(+), 159 deletions(-)
=20
Index: kern_ci/fs/xfs/xfs_dir2_node.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kern_ci.orig/fs/xfs/xfs_dir2_node.c
+++ kern_ci/fs/xfs/xfs_dir2_node.c
@@ -387,28 +387,26 @@ xfs_dir2_leafn_lasthash(
 }
=20
 /*
- * Look up a leaf entry in a node-format leaf block.
- * If this is an addname then the extrablk in state is a freespace block,
- * otherwise it's a data block.
+ * Look up a leaf entry for space to add a name in a node-format leaf bloc=
k.
+ * The extrablk in state is a freespace block.
  */
-int
-xfs_dir2_leafn_lookup_int(
+STATIC int
+xfs_dir2_leafn_lookup_for_addname(
 	xfs_dabuf_t		*bp,		/* leaf buffer */
 	xfs_da_args_t		*args,		/* operation arguments */
 	int			*indexp,	/* out: leaf entry index */
 	xfs_da_state_t		*state)		/* state to fill in */
 {
-	xfs_dabuf_t		*curbp;		/* current data/free buffer */
-	xfs_dir2_db_t		curdb;		/* current data block number */
-	xfs_dir2_db_t		curfdb;		/* current free block number */
-	xfs_dir2_data_entry_t	*dep;		/* data block entry */
+	xfs_dabuf_t		*curbp =3D NULL;	/* current data/free buffer */
+	xfs_dir2_db_t		curdb =3D -1;	/* current data block number */
+	xfs_dir2_db_t		curfdb =3D -1;	/* current free block number */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return value */
 	int			fi;		/* free entry index */
-	xfs_dir2_free_t		*free=3DNULL;	/* free block structure */
+	xfs_dir2_free_t		*free =3D NULL;	/* free block structure */
 	int			index;		/* leaf entry index */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
-	int			length=3D0;	/* length of new data entry */
+	int			length;		/* length of new data entry */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_dir2_db_t		newdb;		/* new data block number */
@@ -431,33 +429,20 @@ xfs_dir2_leafn_lookup_int(
 	/*
 	 * Do we have a buffer coming in?
 	 */
-	if (state->extravalid)
+	if (state->extravalid) {
+		/* If so, it's a free block buffer, get the block number. */
 		curbp =3D state->extrablk.bp;
-	else
-		curbp =3D NULL;
-	/*
-	 * For addname, it's a free block buffer, get the block number.
-	 */
-	if (args->addname) {
-		curfdb =3D curbp ? state->extrablk.blkno : -1;
-		curdb =3D -1;
-		length =3D xfs_dir2_data_entsize(args->namelen);
-		if ((free =3D (curbp ? curbp->data : NULL)))
-			ASSERT(be32_to_cpu(free->hdr.magic) =3D=3D XFS_DIR2_FREE_MAGIC);
-	}
-	/*
-	 * For others, it's a data block buffer, get the block number.
-	 */
-	else {
-		curfdb =3D -1;
-		curdb =3D curbp ? state->extrablk.blkno : -1;
+		curfdb =3D state->extrablk.blkno;
+		free =3D curbp->data;
+		ASSERT(be32_to_cpu(free->hdr.magic) =3D=3D XFS_DIR2_FREE_MAGIC);
 	}
+	length =3D xfs_dir2_data_entsize(args->namelen);
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
-	for (lep =3D &leaf->ents[index];
-	     index < be16_to_cpu(leaf->hdr.count) && be32_to_cpu(lep->hashval) =
=3D=3D args->hashval;
-	     lep++, index++) {
+	for (lep =3D &leaf->ents[index]; index < be16_to_cpu(leaf->hdr.count) &&
+				be32_to_cpu(lep->hashval) =3D=3D args->hashval;
+				lep++, index++) {
 		/*
 		 * Skip stale leaf entries.
 		 */
@@ -471,158 +456,218 @@ xfs_dir2_leafn_lookup_int(
 		 * For addname, we're looking for a place to put the new entry.
 		 * We want to use a data block with an entry of equal
 		 * hash value to ours if there is one with room.
+		 *
+		 * If this block isn't the data block we already have
+		 * in hand, take a look at it.
 		 */
-		if (args->addname) {
+		if (newdb !=3D curdb) {
+			curdb =3D newdb;
 			/*
-			 * If this block isn't the data block we already have
-			 * in hand, take a look at it.
+			 * Convert the data block to the free block
+			 * holding its freespace information.
 			 */
-			if (newdb !=3D curdb) {
-				curdb =3D newdb;
-				/*
-				 * Convert the data block to the free block
-				 * holding its freespace information.
-				 */
-				newfdb =3D xfs_dir2_db_to_fdb(mp, newdb);
-				/*
-				 * If it's not the one we have in hand,
-				 * read it in.
-				 */
-				if (newfdb !=3D curfdb) {
-					/*
-					 * If we had one before, drop it.
-					 */
-					if (curbp)
-						xfs_da_brelse(tp, curbp);
-					/*
-					 * Read the free block.
-					 */
-					if ((error =3D xfs_da_read_buf(tp, dp,
-							xfs_dir2_db_to_da(mp,
-								newfdb),
-							-1, &curbp,
-							XFS_DATA_FORK))) {
-						return error;
-					}
-					free =3D curbp->data;
-					ASSERT(be32_to_cpu(free->hdr.magic) =3D=3D
-					       XFS_DIR2_FREE_MAGIC);
-					ASSERT((be32_to_cpu(free->hdr.firstdb) %
-						XFS_DIR2_MAX_FREE_BESTS(mp)) =3D=3D
-					       0);
-					ASSERT(be32_to_cpu(free->hdr.firstdb) <=3D curdb);
-					ASSERT(curdb <
-					       be32_to_cpu(free->hdr.firstdb) +
-					       be32_to_cpu(free->hdr.nvalid));
-				}
-				/*
-				 * Get the index for our entry.
-				 */
-				fi =3D xfs_dir2_db_to_fdindex(mp, curdb);
-				/*
-				 * If it has room, return it.
-				 */
-				if (unlikely(be16_to_cpu(free->bests[fi]) =3D=3D NULLDATAOFF)) {
-					XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
-							 XFS_ERRLEVEL_LOW, mp);
-					if (curfdb !=3D newfdb)
-						xfs_da_brelse(tp, curbp);
-					return XFS_ERROR(EFSCORRUPTED);
-				}
-				curfdb =3D newfdb;
-				if (be16_to_cpu(free->bests[fi]) >=3D length) {
-					*indexp =3D index;
-					state->extravalid =3D 1;
-					state->extrablk.bp =3D curbp;
-					state->extrablk.blkno =3D curfdb;
-					state->extrablk.index =3D fi;
-					state->extrablk.magic =3D
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
+			newfdb =3D xfs_dir2_db_to_fdb(mp, newdb);
 			/*
-			 * If it's a different data block, go get it.
+			 * If it's not the one we have in hand, read it in.
 			 */
-			if (newdb !=3D curdb) {
+			if (newfdb !=3D curfdb) {
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
-				if ((error =3D
-				    xfs_da_read_buf(tp, dp,
-					    xfs_dir2_db_to_da(mp, newdb), -1,
-					    &curbp, XFS_DATA_FORK))) {
+				error =3D xfs_da_read_buf(tp, dp,
+						xfs_dir2_db_to_da(mp, newfdb),
+						-1, &curbp, XFS_DATA_FORK);
+				if (error)
 					return error;
-				}
-				xfs_dir2_data_check(dp, curbp);
-				curdb =3D newdb;
+				free =3D curbp->data;
+				ASSERT(be32_to_cpu(free->hdr.magic) =3D=3D
+					XFS_DIR2_FREE_MAGIC);
+				ASSERT((be32_to_cpu(free->hdr.firstdb) %
+					XFS_DIR2_MAX_FREE_BESTS(mp)) =3D=3D 0);
+				ASSERT(be32_to_cpu(free->hdr.firstdb) <=3D curdb);
+				ASSERT(curdb < be32_to_cpu(free->hdr.firstdb) +
+					be32_to_cpu(free->hdr.nvalid));
 			}
 			/*
-			 * Point to the data entry.
+			 * Get the index for our entry.
+			 */
+			fi =3D xfs_dir2_db_to_fdindex(mp, curdb);
+			/*
+			 * If it has room, return it.
 			 */
-			dep =3D (xfs_dir2_data_entry_t *)
-			      ((char *)curbp->data +
-			       xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
-			/*
-			 * Compare the entry, return it if it matches.
-			 */
-			if (dep->namelen =3D=3D args->namelen &&
-			    dep->name[0] =3D=3D args->name[0] &&
-			    memcmp(dep->name, args->name, args->namelen) =3D=3D 0) {
-				args->inumber =3D be64_to_cpu(dep->inumber);
-				*indexp =3D index;
-				state->extravalid =3D 1;
-				state->extrablk.bp =3D curbp;
-				state->extrablk.blkno =3D curdb;
-				state->extrablk.index =3D
-					(int)((char *)dep -
-					      (char *)curbp->data);
-				state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
-				return XFS_ERROR(EEXIST);
+			if (unlikely(be16_to_cpu(free->bests[fi]) =3D=3D NULLDATAOFF)) {
+				XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
+							XFS_ERRLEVEL_LOW, mp);
+				if (curfdb !=3D newfdb)
+					xfs_da_brelse(tp, curbp);
+				return XFS_ERROR(EFSCORRUPTED);
 			}
+			curfdb =3D newfdb;
+			if (be16_to_cpu(free->bests[fi]) >=3D length)
+				goto out;
 		}
 	}
+	/* Didn't find any space */
+	fi =3D -1;
+out:
+	ASSERT(args->oknoent);
+	if (curbp) {
+		/* Giving back a free block. */
+		state->extravalid =3D 1;
+		state->extrablk.bp =3D curbp;
+		state->extrablk.index =3D fi;
+		state->extrablk.blkno =3D curfdb;
+		state->extrablk.magic =3D XFS_DIR2_FREE_MAGIC;
+	} else {
+		state->extravalid =3D 0;
+	}
 	/*
-	 * Didn't find a match.
-	 * If we are holding a buffer, give it back in case our caller
-	 * finds it useful.
+	 * Return the index, that will be the insertion point.
 	 */
-	if ((state->extravalid =3D (curbp !=3D NULL))) {
-		state->extrablk.bp =3D curbp;
-		state->extrablk.index =3D -1;
+	*indexp =3D index;
+	return XFS_ERROR(ENOENT);
+}
+
+/*
+ * Look up a leaf entry in a node-format leaf block.
+ * The extrablk in state a data block.
+ */
+STATIC int
+xfs_dir2_leafn_lookup_for_entry(
+	xfs_dabuf_t		*bp,		/* leaf buffer */
+	xfs_da_args_t		*args,		/* operation arguments */
+	int			*indexp,	/* out: leaf entry index */
+	xfs_da_state_t		*state)		/* state to fill in */
+{
+	xfs_dabuf_t		*curbp =3D NULL;	/* current data/free buffer */
+	xfs_dir2_db_t		curdb =3D -1;	/* current data block number */
+	xfs_dir2_data_entry_t	*dep;		/* data block entry */
+	xfs_inode_t		*dp;		/* incore directory inode */
+	int			error;		/* error return value */
+	int			di;		/* data entry index */
+	int			index;		/* leaf entry index */
+	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
+	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
+	xfs_mount_t		*mp;		/* filesystem mount point */
+	xfs_dir2_db_t		newdb;		/* new data block number */
+	xfs_trans_t		*tp;		/* transaction pointer */
+
+	dp =3D args->dp;
+	tp =3D args->trans;
+	mp =3D dp->i_mount;
+	leaf =3D bp->data;
+	ASSERT(be16_to_cpu(leaf->hdr.info.magic) =3D=3D XFS_DIR2_LEAFN_MAGIC);
+#ifdef __KERNEL__
+	ASSERT(be16_to_cpu(leaf->hdr.count) > 0);
+#endif
+	xfs_dir2_leafn_check(dp, bp);
+	/*
+	 * Look up the hash value in the leaf entries.
+	 */
+	index =3D xfs_dir2_leaf_search_hash(args, bp);
+	/*
+	 * Do we have a buffer coming in?
+	 */
+	if (state->extravalid) {
+		curbp =3D state->extrablk.bp;
+		curdb =3D state->extrablk.blkno;
+	}
+	/*
+	 * Loop over leaf entries with the right hash value.
+	 */
+	for (lep =3D &leaf->ents[index]; index < be16_to_cpu(leaf->hdr.count) &&
+				be32_to_cpu(lep->hashval) =3D=3D args->hashval;
+				lep++, index++) {
 		/*
-		 * For addname, giving back a free block.
+		 * Skip stale leaf entries.
 		 */
-		if (args->addname) {
-			state->extrablk.blkno =3D curfdb;
-			state->extrablk.magic =3D XFS_DIR2_FREE_MAGIC;
-		}
+		if (be32_to_cpu(lep->address) =3D=3D XFS_DIR2_NULL_DATAPTR)
+			continue;
 		/*
-		 * For other callers, giving back a data block.
+		 * Pull the data block number from the entry.
 		 */
-		else {
-			state->extrablk.blkno =3D curdb;
-			state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
+		newdb =3D xfs_dir2_dataptr_to_db(mp, be32_to_cpu(lep->address));
+		/*
+		 * Not adding a new entry, so we really want to find
+		 * the name given to us.
+		 *
+		 * If it's a different data block, go get it.
+		 */
+		if (newdb !=3D curdb) {
+			/*
+			 * If we had a block before, drop it.
+			 */
+			if (curbp)
+				xfs_da_brelse(tp, curbp);
+			/*
+			 * Read the data block.
+			 */
+			error =3D xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp,
+					newdb), -1, &curbp, XFS_DATA_FORK);
+			if (error)
+				return error;
+			xfs_dir2_data_check(dp, curbp);
+			curdb =3D newdb;
 		}
+		/*
+		 * Point to the data entry.
+		 */
+		dep =3D (xfs_dir2_data_entry_t *)((char *)curbp->data +
+			xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
+		/*
+		 * Compare the entry, return it if it matches.
+		 */
+		if (dep->namelen =3D=3D args->namelen && memcmp(dep->name,
+					args->name, args->namelen) =3D=3D 0) {
+			args->inumber =3D be64_to_cpu(dep->inumber);
+			di =3D (int)((char *)dep - (char *)curbp->data);
+			error =3D EEXIST;
+			goto out;
+		}
+	}
+	/* Didn't find a match. */
+	error =3D ENOENT;
+	di =3D -1;
+	ASSERT(index =3D=3D be16_to_cpu(leaf->hdr.count) || args->oknoent);
+out:
+	if (curbp) {
+		/* Giving back a data block. */
+		state->extravalid =3D 1;
+		state->extrablk.bp =3D curbp;
+		state->extrablk.index =3D di;
+		state->extrablk.blkno =3D curdb;
+		state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
+	} else {
+		state->extravalid =3D 0;
 	}
 	/*
-	 * Return the final index, that will be the insertion point.
+	 * Return the index, that will be the insertion point.
 	 */
 	*indexp =3D index;
-	ASSERT(index =3D=3D be16_to_cpu(leaf->hdr.count) || args->oknoent);
-	return XFS_ERROR(ENOENT);
+	return XFS_ERROR(error);
+}
+
+/*
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
+	if (args->addname)
+		return xfs_dir2_leafn_lookup_for_addname(bp, args, indexp,
+							state);
+	return xfs_dir2_leafn_lookup_for_entry(bp, args, indexp, state);
 }
=20
 /*
@@ -823,9 +868,10 @@ xfs_dir2_leafn_rebalance(
 	 */
 	if (!state->inleaf)
 		blk2->index =3D blk1->index - be16_to_cpu(leaf1->hdr.count);
-=09
-	/*=20
-	 * Finally sanity check just to make sure we are not returning a negative=
 index=20
+
+	/*
+	 * Finally sanity check just to make sure we are not returning a
+	 * negative index
 	 */
 	if(blk2->index < 0) {
 		state->inleaf =3D 1;

------------pTyqiSRFmxcVjyw31j8o5M--
