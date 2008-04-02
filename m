Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 23:27:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m326QYnT006085
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 23:26:36 -0700
Message-Id: <20080402062707.797672682@chook.melbourne.sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com>
Date: Wed, 02 Apr 2008 16:25:09 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 1/7] XFS: Name operation vector for hash and compare
Content-Disposition: inline; filename=nameops.patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

Adds two pieces of functionality for the basis of case-insensitive
support in XFS:

1.  A comparison result enumerated type: xfs_dacmp_t. It represents an
    exact match, case-insensitive match or no match at all. This patch
    only implements different and exact results.

2.  xfs_nameops vector for specifying how to perform the hash generation
    of filenames and comparision methods. In this patch the hash vector
    points to the existing xfs_da_hashname function and the comparison
    method does a length compare, and if the same, does a memcmp and
    return the xfs_dacmp_t result.

All filename functions that use the hash (create, lookup remove, rename,
etc) now use the xfs_nameops.hashname function and all directory lookup
functions also use the xfs_nameops.compname function.

The lookup functions also handle case-insensitive results even though
the default comparison function cannot return that. And important
aspect of the lookup functions is that an exact match always has
precedence over a case-insensitive. So while a case-insensitive match
is found, we have to keep looking just in case there is an exact
match. In the meantime, the info for the first case-insensitive match
is retained if no exact match is found.

Signed-off-by: Barry Naujok <bnaujok@sgi.com>

---
 fs/xfs/xfs_da_btree.c   |   12 ++++++++++++
 fs/xfs/xfs_da_btree.h   |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_dir2.c       |   12 +++++++-----
 fs/xfs/xfs_dir2.h       |    6 ++++++
 fs/xfs/xfs_dir2_block.c |   29 ++++++++++++++++++++++-------
 fs/xfs/xfs_dir2_data.c  |    3 ++-
 fs/xfs/xfs_dir2_leaf.c  |   47 ++++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_dir2_node.c  |   45 +++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_dir2_sf.c    |   26 ++++++++++++++++----------
 fs/xfs/xfs_mount.h      |    2 ++
 10 files changed, 166 insertions(+), 44 deletions(-)

Index: kern_ci/fs/xfs/xfs_da_btree.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_da_btree.c
+++ kern_ci/fs/xfs/xfs_da_btree.c
@@ -1530,6 +1530,18 @@ xfs_da_hashname(const uchar_t *name, int
 	}
 }
 
+xfs_dacmp_t
+xfs_da_compname(const uchar_t *name1, int len1, const uchar_t *name2, int len2)
+{
+	return (len1 == len2 && memcmp(name1, name2, len1) == 0) ?
+			XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
+}
+
+struct xfs_nameops xfs_default_nameops = {
+	.hashname	= xfs_da_hashname,
+	.compname	= xfs_da_compname
+};
+
 /*
  * Add a block to the btree ahead of the file.
  * Return the new block number to the caller.
Index: kern_ci/fs/xfs/xfs_da_btree.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_da_btree.h
+++ kern_ci/fs/xfs/xfs_da_btree.h
@@ -99,6 +99,15 @@ typedef struct xfs_da_node_entry xfs_da_
  *========================================================================*/
 
 /*
+ * Search comparison results
+ */
+typedef enum {
+	XFS_CMP_DIFFERENT,	/* names are completely different */
+	XFS_CMP_EXACT,		/* names are exactly the same */
+	XFS_CMP_CASE		/* names are same but differ in case */
+} xfs_dacmp_t;
+
+/*
  * Structure to ease passing around component names.
  */
 typedef struct xfs_da_args {
@@ -127,6 +136,7 @@ typedef struct xfs_da_args {
 	unsigned char	rename;		/* T/F: this is an atomic rename op */
 	unsigned char	addname;	/* T/F: this is an add operation */
 	unsigned char	oknoent;	/* T/F: ok to return ENOENT, else die */
+	xfs_dacmp_t	cmpresult;	/* name compare result for lookups */
 } xfs_da_args_t;
 
 /*
@@ -201,6 +211,19 @@ typedef struct xfs_da_state {
 		(uint)(XFS_DA_LOGOFF(BASE, ADDR)), \
 		(uint)(XFS_DA_LOGOFF(BASE, ADDR)+(SIZE)-1)
 
+/*
+ * Name ops for directory and/or attr name operations
+ */
+
+typedef xfs_dahash_t	(*xfs_hashname_t)(const uchar_t *, int);
+typedef xfs_dacmp_t	(*xfs_compname_t)(const uchar_t *, int,
+					  const uchar_t *, int);
+
+typedef struct xfs_nameops {
+	xfs_hashname_t		hashname;
+	xfs_compname_t		compname;
+} xfs_nameops_t;
+
 
 #ifdef __KERNEL__
 /*========================================================================
@@ -248,7 +271,12 @@ xfs_daddr_t	xfs_da_reada_buf(struct xfs_
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  xfs_dabuf_t *dead_buf);
 
+extern struct xfs_nameops xfs_default_nameops;
+
 uint xfs_da_hashname(const uchar_t *name_string, int name_length);
+xfs_dacmp_t xfs_da_compname(const uchar_t *name1, int len1,
+			    const uchar_t *name2, int len2);
+
 xfs_da_state_t *xfs_da_state_alloc(void);
 void xfs_da_state_free(xfs_da_state_t *state);
 
Index: kern_ci/fs/xfs/xfs_dir2.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.c
+++ kern_ci/fs/xfs/xfs_dir2.c
@@ -64,6 +64,7 @@ xfs_dir_mount(
 		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
 		(uint)sizeof(xfs_da_node_entry_t);
 	mp->m_dir_magicpct = (mp->m_dirblksize * 37) / 100;
+	mp->m_dirnameops = &xfs_default_nameops;
 }
 
 /*
@@ -164,7 +165,7 @@ xfs_dir_createname(
 
 	args.name = name;
 	args.namelen = namelen;
-	args.hashval = xfs_da_hashname(name, namelen);
+	args.hashval = xfs_dir_hashname(dp, name, namelen);
 	args.inumber = inum;
 	args.dp = dp;
 	args.firstblock = first;
@@ -210,7 +211,7 @@ xfs_dir_lookup(
 
 	args.name = name;
 	args.namelen = namelen;
-	args.hashval = xfs_da_hashname(name, namelen);
+	args.hashval = xfs_dir_hashname(dp, name, namelen);
 	args.inumber = 0;
 	args.dp = dp;
 	args.firstblock = NULL;
@@ -220,6 +221,7 @@ xfs_dir_lookup(
 	args.trans = tp;
 	args.justcheck = args.addname = 0;
 	args.oknoent = 1;
+	args.cmpresult = XFS_CMP_DIFFERENT;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_lookup(&args);
@@ -263,7 +265,7 @@ xfs_dir_removename(
 
 	args.name = name;
 	args.namelen = namelen;
-	args.hashval = xfs_da_hashname(name, namelen);
+	args.hashval = xfs_dir_hashname(dp, name, namelen);
 	args.inumber = ino;
 	args.dp = dp;
 	args.firstblock = first;
@@ -347,7 +349,7 @@ xfs_dir_replace(
 
 	args.name = name;
 	args.namelen = namelen;
-	args.hashval = xfs_da_hashname(name, namelen);
+	args.hashval = xfs_dir_hashname(dp, name, namelen);
 	args.inumber = inum;
 	args.dp = dp;
 	args.firstblock = first;
@@ -390,7 +392,7 @@ xfs_dir_canenter(
 
 	args.name = name;
 	args.namelen = namelen;
-	args.hashval = xfs_da_hashname(name, namelen);
+	args.hashval = xfs_dir_hashname(dp, name, namelen);
 	args.inumber = 0;
 	args.dp = dp;
 	args.firstblock = NULL;
Index: kern_ci/fs/xfs/xfs_dir2.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.h
+++ kern_ci/fs/xfs/xfs_dir2.h
@@ -85,6 +85,12 @@ extern int xfs_dir_canenter(struct xfs_t
 				char *name, int namelen);
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
+#define xfs_dir_hashname(dp, n, l) \
+		((dp)->i_mount->m_dirnameops->hashname((n), (l)))
+
+#define xfs_dir_compname(dp, n1, l1, n2, l2) \
+		((dp)->i_mount->m_dirnameops->compname((n1), (l1), (n2), (l2)))
+
 /*
  * Utility routines for v2 directories.
  */
Index: kern_ci/fs/xfs/xfs_dir2_block.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_block.c
+++ kern_ci/fs/xfs/xfs_dir2_block.c
@@ -643,6 +643,7 @@ xfs_dir2_block_lookup_int(
 	int			mid;		/* binary search current idx */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	xfs_dacmp_t		cmp;		/* comparison result */
 
 	dp = args->dp;
 	tp = args->trans;
@@ -698,19 +699,33 @@ xfs_dir2_block_lookup_int(
 			((char *)block + xfs_dir2_dataptr_to_off(mp, addr));
 		/*
 		 * Compare, if it's right give back buffer & entry number.
+		 *
+		 * lookup case - use nameops;
+		 *
+		 * replace/remove case - as lookup has been already been
+		 * performed, look for an exact match using the fast method
 		 */
-		if (dep->namelen == args->namelen &&
-		    dep->name[0] == args->name[0] &&
-		    memcmp(dep->name, args->name, args->namelen) == 0) {
+		cmp = args->oknoent ?
+			xfs_dir_compname(dp, dep->name, dep->namelen,
+						args->name, args->namelen) :
+			xfs_da_compname(dep->name, dep->namelen,
+						args->name, args->namelen);
+		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
+			args->cmpresult = cmp;
 			*bpp = bp;
 			*entno = mid;
-			return 0;
+			if (cmp == XFS_CMP_EXACT)
+				return 0;
 		}
-	} while (++mid < be32_to_cpu(btp->count) && be32_to_cpu(blp[mid].hashval) == hash);
+	} while (++mid < be32_to_cpu(btp->count) &&
+			be32_to_cpu(blp[mid].hashval) == hash);
+
+	ASSERT(args->oknoent);
+	if (args->cmpresult == XFS_CMP_CASE)
+		return 0;
 	/*
 	 * No match, release the buffer and return ENOENT.
 	 */
-	ASSERT(args->oknoent);
 	xfs_da_brelse(tp, bp);
 	return XFS_ERROR(ENOENT);
 }
@@ -1187,7 +1202,7 @@ xfs_dir2_sf_to_block(
 		tagp = xfs_dir2_data_entry_tag_p(dep);
 		*tagp = cpu_to_be16((char *)dep - (char *)block);
 		xfs_dir2_data_log_entry(tp, bp, dep);
-		blp[2 + i].hashval = cpu_to_be32(xfs_da_hashname(
+		blp[2 + i].hashval = cpu_to_be32(xfs_dir_hashname(dp,
 					(char *)sfep->name, sfep->namelen));
 		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 						 (char *)dep - (char *)block));
Index: kern_ci/fs/xfs/xfs_dir2_data.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_data.c
+++ kern_ci/fs/xfs/xfs_dir2_data.c
@@ -140,7 +140,8 @@ xfs_dir2_data_check(
 			addr = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)d));
-			hash = xfs_da_hashname((char *)dep->name, dep->namelen);
+			hash = xfs_dir_hashname(dp, (char *)dep->name,
+					dep->namelen);
 			for (i = 0; i < be32_to_cpu(btp->count); i++) {
 				if (be32_to_cpu(lep[i].address) == addr &&
 				    be32_to_cpu(lep[i].hashval) == hash)
Index: kern_ci/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_leaf.c
+++ kern_ci/fs/xfs/xfs_dir2_leaf.c
@@ -1331,6 +1331,8 @@ xfs_dir2_leaf_lookup_int(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_dir2_db_t		newdb;		/* new data block number */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	xfs_dabuf_t		*cbp;		/* case match data buffer */
+	xfs_dacmp_t		cmp;		/* name compare result */
 
 	dp = args->dp;
 	tp = args->trans;
@@ -1354,6 +1356,7 @@ xfs_dir2_leaf_lookup_int(
 	 * Loop over all the entries with the right hash value
 	 * looking to match the name.
 	 */
+	cbp = NULL;
 	for (lep = &leaf->ents[index], dbp = NULL, curdb = -1;
 	     index < be16_to_cpu(leaf->hdr.count) && be32_to_cpu(lep->hashval) == args->hashval;
 	     lep++, index++) {
@@ -1371,7 +1374,7 @@ xfs_dir2_leaf_lookup_int(
 		 * need to pitch the old one and read the new one.
 		 */
 		if (newdb != curdb) {
-			if (dbp)
+			if (dbp != cbp)
 				xfs_da_brelse(tp, dbp);
 			if ((error =
 			    xfs_da_read_buf(tp, dp,
@@ -1391,19 +1394,49 @@ xfs_dir2_leaf_lookup_int(
 		       xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
 		/*
 		 * If it matches then return it.
+		 *
+		 * lookup case - use nameops;
+		 *
+		 * replace/remove case - as lookup has been already been
+		 * performed, look for an exact match using the fast method
 		 */
-		if (dep->namelen == args->namelen &&
-		    dep->name[0] == args->name[0] &&
-		    memcmp(dep->name, args->name, args->namelen) == 0) {
-			*dbpp = dbp;
+		cmp = args->oknoent ?
+			xfs_dir_compname(dp, dep->name, dep->namelen,
+						args->name, args->namelen) :
+			xfs_da_compname(dep->name, dep->namelen,
+						args->name, args->namelen);
+		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
+			args->cmpresult = cmp;
 			*indexp = index;
-			return 0;
+			if (cmp == XFS_CMP_EXACT) {
+				/*
+				 * case exact match: release the case-insens.
+				 * match buffer if it exists and return the
+				 * current data buffer.
+				 */
+				if (cbp && cbp != dbp)
+					xfs_da_brelse(tp, cbp);
+				*dbpp = dbp;
+				return 0;
+			}
+			cbp = dbp;
 		}
 	}
+	ASSERT(args->oknoent);
+	if (args->cmpresult == XFS_CMP_CASE) {
+		/*
+		 * case-insensitive match: release current buffer and
+		 * return the buffer with the case-insensitive match.
+		 */
+		if (cbp != dbp)
+			xfs_da_brelse(tp, dbp);
+		*dbpp = cbp;
+		return 0;
+	}
 	/*
 	 * No match found, return ENOENT.
 	 */
-	ASSERT(args->oknoent);
+	ASSERT(cbp == NULL);
 	if (dbp)
 		xfs_da_brelse(tp, dbp);
 	xfs_da_brelse(tp, lbp);
Index: kern_ci/fs/xfs/xfs_dir2_node.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_node.c
+++ kern_ci/fs/xfs/xfs_dir2_node.c
@@ -414,6 +414,7 @@ xfs_dir2_leafn_lookup_int(
 	xfs_dir2_db_t		newdb;		/* new data block number */
 	xfs_dir2_db_t		newfdb;		/* new free block number */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	xfs_dacmp_t		cmp;		/* comparison result */
 
 	dp = args->dp;
 	tp = args->trans;
@@ -578,19 +579,27 @@ xfs_dir2_leafn_lookup_int(
 			/*
 			 * Compare the entry, return it if it matches.
 			 */
-			if (dep->namelen == args->namelen &&
-			    dep->name[0] == args->name[0] &&
-			    memcmp(dep->name, args->name, args->namelen) == 0) {
+			cmp = args->oknoent ?
+				xfs_dir_compname(dp, dep->name, dep->namelen,
+						args->name, args->namelen):
+				xfs_da_compname(dep->name, dep->namelen,
+						args->name, args->namelen);
+			if (cmp != XFS_CMP_DIFFERENT &&
+					cmp != args->cmpresult) {
+				args->cmpresult = cmp;
 				args->inumber = be64_to_cpu(dep->inumber);
 				*indexp = index;
-				state->extravalid = 1;
-				state->extrablk.bp = curbp;
-				state->extrablk.blkno = curdb;
-				state->extrablk.index =
-					(int)((char *)dep -
-					      (char *)curbp->data);
-				state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
-				return XFS_ERROR(EEXIST);
+				if (cmp == XFS_CMP_EXACT) {
+					state->extravalid = 1;
+					state->extrablk.blkno = curdb;
+					state->extrablk.index =
+						(int)((char *)dep -
+						      (char *)curbp->data);
+					state->extrablk.magic =
+						XFS_DIR2_DATA_MAGIC;
+					state->extrablk.bp = curbp;
+					return XFS_ERROR(EEXIST);
+				}
 			}
 		}
 	}
@@ -618,6 +627,14 @@ xfs_dir2_leafn_lookup_int(
 		}
 	}
 	/*
+	 * For lookup (where args->oknoent is set, and args->addname is not
+	 * set, the state->extrablk info is not used, just freed.
+	 */
+	if (args->cmpresult == XFS_CMP_CASE) {
+		ASSERT(!args->addname);
+		return XFS_ERROR(EEXIST);
+	}
+	/*
 	 * Return the final index, that will be the insertion point.
 	 */
 	*indexp = index;
@@ -823,9 +840,9 @@ xfs_dir2_leafn_rebalance(
 	 */
 	if (!state->inleaf)
 		blk2->index = blk1->index - be16_to_cpu(leaf1->hdr.count);
-	
-	/* 
-	 * Finally sanity check just to make sure we are not returning a negative index 
+
+	/*
+	 * Finally sanity check just to make sure we are not returning a negative index
 	 */
 	if(blk2->index < 0) {
 		state->inleaf = 1;
Index: kern_ci/fs/xfs/xfs_dir2_sf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_sf.c
+++ kern_ci/fs/xfs/xfs_dir2_sf.c
@@ -814,6 +814,7 @@ xfs_dir2_sf_lookup(
 	int			i;		/* entry index */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
+	xfs_dacmp_t		cmp;		/* comparison result */
 
 	xfs_dir2_trace_args("sf_lookup", args);
 	xfs_dir2_sf_check(args);
@@ -836,6 +837,7 @@ xfs_dir2_sf_lookup(
 	 */
 	if (args->namelen == 1 && args->name[0] == '.') {
 		args->inumber = dp->i_ino;
+		args->cmpresult = XFS_CMP_EXACT;
 		return XFS_ERROR(EEXIST);
 	}
 	/*
@@ -844,6 +846,7 @@ xfs_dir2_sf_lookup(
 	if (args->namelen == 2 &&
 	    args->name[0] == '.' && args->name[1] == '.') {
 		args->inumber = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
+		args->cmpresult = XFS_CMP_EXACT;
 		return XFS_ERROR(EEXIST);
 	}
 	/*
@@ -852,15 +855,19 @@ xfs_dir2_sf_lookup(
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->hdr.count;
 	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
-		if (sfep->namelen == args->namelen &&
-		    sfep->name[0] == args->name[0] &&
-		    memcmp(args->name, sfep->name, args->namelen) == 0) {
+		cmp = xfs_dir_compname(dp, sfep->name, sfep->namelen,
+					args->name, args->namelen);
+		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
+			args->cmpresult = cmp;
 			args->inumber =
 				xfs_dir2_sf_get_inumber(sfp,
 					xfs_dir2_sf_inumberp(sfep));
-			return XFS_ERROR(EEXIST);
+			if (cmp == XFS_CMP_EXACT)
+				return XFS_ERROR(EEXIST);
 		}
 	}
+	if (args->cmpresult == XFS_CMP_CASE)
+		return XFS_ERROR(EEXIST);
 	/*
 	 * Didn't find it.
 	 */
@@ -907,9 +914,8 @@ xfs_dir2_sf_removename(
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->hdr.count;
 	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
-		if (sfep->namelen == args->namelen &&
-		    sfep->name[0] == args->name[0] &&
-		    memcmp(sfep->name, args->name, args->namelen) == 0) {
+		if (xfs_da_compname(sfep->name, sfep->namelen,
+				args->name, args->namelen) == XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_inumber(sfp,
 					xfs_dir2_sf_inumberp(sfep)) ==
 				args->inumber);
@@ -1044,9 +1050,9 @@ xfs_dir2_sf_replace(
 		for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 		     i < sfp->hdr.count;
 		     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
-			if (sfep->namelen == args->namelen &&
-			    sfep->name[0] == args->name[0] &&
-			    memcmp(args->name, sfep->name, args->namelen) == 0) {
+			if (xfs_da_compname(sfep->name, sfep->namelen,
+					    args->name, args->namelen) ==
+					XFS_CMP_EXACT) {
 #if XFS_BIG_INUMS || defined(DEBUG)
 				ino = xfs_dir2_sf_get_inumber(sfp,
 					xfs_dir2_sf_inumberp(sfep));
Index: kern_ci/fs/xfs/xfs_mount.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_mount.h
+++ kern_ci/fs/xfs/xfs_mount.h
@@ -61,6 +61,7 @@ struct xfs_bmap_free;
 struct xfs_extdelta;
 struct xfs_swapext;
 struct xfs_mru_cache;
+struct xfs_nameops;
 
 /*
  * Prototypes and functions for the Data Migration subsystem.
@@ -312,6 +313,7 @@ typedef struct xfs_mount {
 	__uint8_t		m_inode_quiesce;/* call quiesce on new inodes.
 						   field governed by m_ilock */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
+	struct xfs_nameops	*m_dirnameops;	/* vector of dir name ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
 	int			m_dirblkfsbs;	/* directory block sz--fsbs */
 	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */

-- 
