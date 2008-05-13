Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 01:01:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4D816La006482
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:01:09 -0700
Message-Id: <20080513080152.312488863@chook.melbourne.sgi.com>
References: <20080513075749.477238845@chook.melbourne.sgi.com>
Date: Tue, 13 May 2008 17:57:50 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 1/4] XFS: Name operation vector for hash and compare
Content-Disposition: inline; filename=nameops.patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

Adds two pieces of functionality for the basis of case-insensitive
support in XFS:

1.  A comparison result enumerated type: xfs_dacmp. It represents an
    exact match, case-insensitive match or no match at all. This patch
    only implements different and exact results.

2.  xfs_nameops vector for specifying how to perform the hash generation
    of filenames and comparision methods. In this patch the hash vector
    points to the existing xfs_da_hashname function and the comparison
    method does a length compare, and if the same, does a memcmp and
    return the xfs_dacmp result.

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
 fs/xfs/xfs_da_btree.c   |   22 +++++++++++++++++
 fs/xfs/xfs_da_btree.h   |   22 +++++++++++++++++
 fs/xfs/xfs_dir2.c       |   12 +++++----
 fs/xfs/xfs_dir2_block.c |   33 ++++++++++++++++++-------
 fs/xfs/xfs_dir2_data.c  |    5 +++
 fs/xfs/xfs_dir2_leaf.c  |   60 +++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_dir2_node.c  |   25 +++++++++++--------
 fs/xfs/xfs_dir2_sf.c    |   62 +++++++++++++++++++++++++++---------------------
 fs/xfs/xfs_mount.h      |    2 +
 9 files changed, 175 insertions(+), 68 deletions(-)

Index: kern_ci/fs/xfs/xfs_da_btree.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_da_btree.c
+++ kern_ci/fs/xfs/xfs_da_btree.c
@@ -1530,6 +1530,28 @@ xfs_da_hashname(const uchar_t *name, int
 	}
 }
 
+enum xfs_dacmp
+xfs_da_compname(
+	struct xfs_da_args *args,
+	const char 	*name,
+	int 		len)
+{
+	return (args->namelen == len && memcmp(args->name, name, len) == 0) ?
+					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
+}
+
+static xfs_dahash_t
+xfs_default_hashname(
+	struct xfs_name	*name)
+{
+	return xfs_da_hashname(name->name, name->len);
+}
+
+const struct xfs_nameops xfs_default_nameops = {
+	.hashname	= xfs_default_hashname,
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
+enum xfs_dacmp {
+	XFS_CMP_DIFFERENT,	/* names are completely different */
+	XFS_CMP_EXACT,		/* names are exactly the same */
+	XFS_CMP_CASE		/* names are same but differ in case */
+};
+
+/*
  * Structure to ease passing around component names.
  */
 typedef struct xfs_da_args {
@@ -127,6 +136,7 @@ typedef struct xfs_da_args {
 	unsigned char	rename;		/* T/F: this is an atomic rename op */
 	unsigned char	addname;	/* T/F: this is an add operation */
 	unsigned char	oknoent;	/* T/F: ok to return ENOENT, else die */
+	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
 } xfs_da_args_t;
 
 /*
@@ -201,6 +211,14 @@ typedef struct xfs_da_state {
 		(uint)(XFS_DA_LOGOFF(BASE, ADDR)), \
 		(uint)(XFS_DA_LOGOFF(BASE, ADDR)+(SIZE)-1)
 
+/*
+ * Name ops for directory and/or attr name operations
+ */
+struct xfs_nameops {
+	xfs_dahash_t	(*hashname)(struct xfs_name *);
+	enum xfs_dacmp	(*compname)(struct xfs_da_args *, const char *, int);
+};
+
 
 #ifdef __KERNEL__
 /*========================================================================
@@ -249,6 +267,10 @@ int	xfs_da_shrink_inode(xfs_da_args_t *a
 					  xfs_dabuf_t *dead_buf);
 
 uint xfs_da_hashname(const uchar_t *name_string, int name_length);
+enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
+				const char *name, int len);
+
+
 xfs_da_state_t *xfs_da_state_alloc(void);
 void xfs_da_state_free(xfs_da_state_t *state);
 
Index: kern_ci/fs/xfs/xfs_dir2.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.c
+++ kern_ci/fs/xfs/xfs_dir2.c
@@ -67,6 +67,7 @@ xfs_dir_mount(
 		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
 		(uint)sizeof(xfs_da_node_entry_t);
 	mp->m_dir_magicpct = (mp->m_dirblksize * 37) / 100;
+	mp->m_dirnameops = &xfs_default_nameops;
 }
 
 /*
@@ -166,7 +167,7 @@ xfs_dir_createname(
 
 	args.name = name->name;
 	args.namelen = name->len;
-	args.hashval = xfs_da_hashname(name->name, name->len);
+	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = inum;
 	args.dp = dp;
 	args.firstblock = first;
@@ -212,11 +213,12 @@ xfs_dir_lookup(
 
 	args.name = name->name;
 	args.namelen = name->len;
-	args.hashval = xfs_da_hashname(name->name, name->len);
+	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
 	args.oknoent = 1;
+	args.cmpresult = XFS_CMP_DIFFERENT;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_lookup(&args);
@@ -259,7 +261,7 @@ xfs_dir_removename(
 
 	args.name = name->name;
 	args.namelen = name->len;
-	args.hashval = xfs_da_hashname(name->name, name->len);
+	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = ino;
 	args.dp = dp;
 	args.firstblock = first;
@@ -342,7 +344,7 @@ xfs_dir_replace(
 
 	args.name = name->name;
 	args.namelen = name->len;
-	args.hashval = xfs_da_hashname(name->name, name->len);
+	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = inum;
 	args.dp = dp;
 	args.firstblock = first;
@@ -390,7 +392,7 @@ xfs_dir_canenter(
 
 	args.name = name->name;
 	args.namelen = name->len;
-	args.hashval = xfs_da_hashname(name->name, name->len);
+	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
Index: kern_ci/fs/xfs/xfs_dir2_block.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_block.c
+++ kern_ci/fs/xfs/xfs_dir2_block.c
@@ -643,6 +643,7 @@ xfs_dir2_block_lookup_int(
 	int			mid;		/* binary search current idx */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	enum xfs_dacmp		cmp;		/* comparison result */
 
 	dp = args->dp;
 	tp = args->trans;
@@ -697,20 +698,31 @@ xfs_dir2_block_lookup_int(
 		dep = (xfs_dir2_data_entry_t *)
 			((char *)block + xfs_dir2_dataptr_to_off(mp, addr));
 		/*
-		 * Compare, if it's right give back buffer & entry number.
+		 * Compare name and if it's an exact match, return the index
+		 * and buffer. If it's the first case-insensitive match, store
+		 * the index and buffer and continue looking for an exact match.
 		 */
-		if (dep->namelen == args->namelen &&
-		    dep->name[0] == args->name[0] &&
-		    memcmp(dep->name, args->name, args->namelen) == 0) {
+		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
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
+	/*
+	 * Here, we can only be doing a lookup (not a rename or replace).
+	 * If a case-insensitive match was found earlier, return success.
+	 */
+	if (args->cmpresult == XFS_CMP_CASE)
+		return 0;
 	/*
 	 * No match, release the buffer and return ENOENT.
 	 */
-	ASSERT(args->oknoent);
 	xfs_da_brelse(tp, bp);
 	return XFS_ERROR(ENOENT);
 }
@@ -1033,6 +1045,7 @@ xfs_dir2_sf_to_block(
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 	__be16			*tagp;		/* end of data entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	struct xfs_name		name;
 
 	xfs_dir2_trace_args("sf_to_block", args);
 	dp = args->dp;
@@ -1187,8 +1200,10 @@ xfs_dir2_sf_to_block(
 		tagp = xfs_dir2_data_entry_tag_p(dep);
 		*tagp = cpu_to_be16((char *)dep - (char *)block);
 		xfs_dir2_data_log_entry(tp, bp, dep);
-		blp[2 + i].hashval = cpu_to_be32(xfs_da_hashname(
-					(char *)sfep->name, sfep->namelen));
+		name.name = sfep->name;
+		name.len = sfep->namelen;
+		blp[2 + i].hashval = cpu_to_be32(mp->m_dirnameops->
+							hashname(&name));
 		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 						 (char *)dep - (char *)block));
 		offset = (int)((char *)(tagp + 1) - (char *)block);
Index: kern_ci/fs/xfs/xfs_dir2_data.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_data.c
+++ kern_ci/fs/xfs/xfs_dir2_data.c
@@ -65,6 +65,7 @@ xfs_dir2_data_check(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	char			*p;		/* current data position */
 	int			stale;		/* count of stale leaves */
+	struct xfs_name		name;
 
 	mp = dp->i_mount;
 	d = bp->data;
@@ -140,7 +141,9 @@ xfs_dir2_data_check(
 			addr = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)d));
-			hash = xfs_da_hashname((char *)dep->name, dep->namelen);
+			name.name = dep->name;
+			name.len = dep->namelen;
+			hash = mp->m_dirnameops->hashname(&name);
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
+	enum xfs_dacmp		cmp;		/* name compare result */
 
 	dp = args->dp;
 	tp = args->trans;
@@ -1354,9 +1356,11 @@ xfs_dir2_leaf_lookup_int(
 	 * Loop over all the entries with the right hash value
 	 * looking to match the name.
 	 */
+	cbp = NULL;
 	for (lep = &leaf->ents[index], dbp = NULL, curdb = -1;
-	     index < be16_to_cpu(leaf->hdr.count) && be32_to_cpu(lep->hashval) == args->hashval;
-	     lep++, index++) {
+				index < be16_to_cpu(leaf->hdr.count) &&
+				be32_to_cpu(lep->hashval) == args->hashval;
+				lep++, index++) {
 		/*
 		 * Skip over stale leaf entries.
 		 */
@@ -1371,12 +1375,12 @@ xfs_dir2_leaf_lookup_int(
 		 * need to pitch the old one and read the new one.
 		 */
 		if (newdb != curdb) {
-			if (dbp)
+			if (dbp != cbp)
 				xfs_da_brelse(tp, dbp);
-			if ((error =
-			    xfs_da_read_buf(tp, dp,
-				    xfs_dir2_db_to_da(mp, newdb), -1, &dbp,
-				    XFS_DATA_FORK))) {
+			error = xfs_da_read_buf(tp, dp,
+						xfs_dir2_db_to_da(mp, newdb),
+						-1, &dbp, XFS_DATA_FORK);
+			if (error) {
 				xfs_da_brelse(tp, lbp);
 				return error;
 			}
@@ -1386,24 +1390,46 @@ xfs_dir2_leaf_lookup_int(
 		/*
 		 * Point to the data entry.
 		 */
-		dep = (xfs_dir2_data_entry_t *)
-		      ((char *)dbp->data +
-		       xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
+		dep = (xfs_dir2_data_entry_t *)((char *)dbp->data +
+			xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
 		/*
-		 * If it matches then return it.
+		 * Compare name and if it's an exact match, return the index
+		 * and buffer. If it's the first case-insensitive match, store
+		 * the index and buffer and continue looking for an exact match.
 		 */
-		if (dep->namelen == args->namelen &&
-		    dep->name[0] == args->name[0] &&
-		    memcmp(dep->name, args->name, args->namelen) == 0) {
-			*dbpp = dbp;
+		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
+		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
+			args->cmpresult = cmp;
 			*indexp = index;
-			return 0;
+			/*
+			 * case exact match: release the stored CI buffer if it
+			 * exists and return the current buffer.
+			 */
+			if (cmp == XFS_CMP_EXACT) {
+				if (cbp && cbp != dbp)
+					xfs_da_brelse(tp, cbp);
+				*dbpp = dbp;
+				return 0;
+			}
+			cbp = dbp;
 		}
 	}
+	ASSERT(args->oknoent);
+	/*
+	 * Here, we can only be doing a lookup (not a rename or replace).
+	 * If a case-insensitive match was found earlier, release the current
+	 * buffer and return the stored CI matching buffer.
+	 */
+	if (args->cmpresult == XFS_CMP_CASE) {
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
@@ -556,6 +556,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_dir2_db_t		newdb;		/* new data block number */
 	xfs_trans_t		*tp;		/* transaction pointer */
+	enum xfs_dacmp		cmp;		/* comparison result */
 
 	dp = args->dp;
 	tp = args->trans;
@@ -620,17 +621,21 @@ xfs_dir2_leafn_lookup_for_entry(
 		dep = (xfs_dir2_data_entry_t *)((char *)curbp->data +
 			xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
 		/*
-		 * Compare the entry, return it if it matches.
-		 */
-		if (dep->namelen == args->namelen && memcmp(dep->name,
-					args->name, args->namelen) == 0) {
+		 * Compare the entry and if it's an exact match, return
+		 * EEXIST immediately. If it's the first case-insensitive
+		 * match, store the inode number and continue looking.
+		 */
+		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
+		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
+			args->cmpresult = cmp;
 			args->inumber = be64_to_cpu(dep->inumber);
 			di = (int)((char *)dep - (char *)curbp->data);
 			error = EEXIST;
-			goto out;
+			if (cmp == XFS_CMP_EXACT)
+				goto out;
 		}
 	}
-	/* Didn't find a match. */
+	/* Didn't find an exact match. */
 	error = ENOENT;
 	di = -1;
 	ASSERT(index == be16_to_cpu(leaf->hdr.count) || args->oknoent);
@@ -1813,6 +1818,8 @@ xfs_dir2_node_lookup(
 	error = xfs_da_node_lookup_int(state, &rval);
 	if (error)
 		rval = error;
+	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE)
+		rval = EEXIST;	/* a case-insensitive match was found */
 	/*
 	 * Release the btree blocks and leaf block.
 	 */
@@ -1856,9 +1863,8 @@ xfs_dir2_node_removename(
 	 * Look up the entry we're deleting, set up the cursor.
 	 */
 	error = xfs_da_node_lookup_int(state, &rval);
-	if (error) {
+	if (error)
 		rval = error;
-	}
 	/*
 	 * Didn't find it, upper layer screwed up.
 	 */
@@ -1875,9 +1881,8 @@ xfs_dir2_node_removename(
 	 */
 	error = xfs_dir2_leafn_remove(args, blk->bp, blk->index,
 		&state->extrablk, &rval);
-	if (error) {
+	if (error)
 		return error;
-	}
 	/*
 	 * Fix the hash values up the btree.
 	 */
Index: kern_ci/fs/xfs/xfs_dir2_sf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_sf.c
+++ kern_ci/fs/xfs/xfs_dir2_sf.c
@@ -814,6 +814,7 @@ xfs_dir2_sf_lookup(
 	int			i;		/* entry index */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
+	enum xfs_dacmp		cmp;		/* comparison result */
 
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
@@ -844,27 +846,39 @@ xfs_dir2_sf_lookup(
 	if (args->namelen == 2 &&
 	    args->name[0] == '.' && args->name[1] == '.') {
 		args->inumber = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
+		args->cmpresult = XFS_CMP_EXACT;
 		return XFS_ERROR(EEXIST);
 	}
 	/*
 	 * Loop over all the entries trying to match ours.
 	 */
-	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
-	     i < sfp->hdr.count;
-	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
-		if (sfep->namelen == args->namelen &&
-		    sfep->name[0] == args->name[0] &&
-		    memcmp(args->name, sfep->name, args->namelen) == 0) {
-			args->inumber =
-				xfs_dir2_sf_get_inumber(sfp,
-					xfs_dir2_sf_inumberp(sfep));
-			return XFS_ERROR(EEXIST);
+	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->hdr.count;
+				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
+		/*
+		 * Compare name and if it's an exact match, return the inode
+		 * number. If it's the first case-insensitive match, store the
+		 * inode number and continue looking for an exact match.
+		 */
+		cmp = dp->i_mount->m_dirnameops->compname(args, sfep->name,
+								sfep->namelen);
+		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
+			args->cmpresult = cmp;
+			args->inumber = xfs_dir2_sf_get_inumber(sfp,
+						xfs_dir2_sf_inumberp(sfep));
+			if (cmp == XFS_CMP_EXACT)
+				return XFS_ERROR(EEXIST);
 		}
 	}
+	ASSERT(args->oknoent);
+	/*
+	 * Here, we can only be doing a lookup (not a rename or replace).
+	 * If a case-insensitive match was found earlier, return "found".
+	 */
+	if (args->cmpresult == XFS_CMP_CASE)
+		return XFS_ERROR(EEXIST);
 	/*
 	 * Didn't find it.
 	 */
-	ASSERT(args->oknoent);
 	return XFS_ERROR(ENOENT);
 }
 
@@ -904,24 +918,21 @@ xfs_dir2_sf_removename(
 	 * Loop over the old directory entries.
 	 * Find the one we're deleting.
 	 */
-	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
-	     i < sfp->hdr.count;
-	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
-		if (sfep->namelen == args->namelen &&
-		    sfep->name[0] == args->name[0] &&
-		    memcmp(sfep->name, args->name, args->namelen) == 0) {
+	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->hdr.count;
+				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
+		if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
+								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_inumber(sfp,
-					xfs_dir2_sf_inumberp(sfep)) ==
-				args->inumber);
+						xfs_dir2_sf_inumberp(sfep)) ==
+								args->inumber);
 			break;
 		}
 	}
 	/*
 	 * Didn't find it.
 	 */
-	if (i == sfp->hdr.count) {
+	if (i == sfp->hdr.count)
 		return XFS_ERROR(ENOENT);
-	}
 	/*
 	 * Calculate sizes.
 	 */
@@ -1042,11 +1053,10 @@ xfs_dir2_sf_replace(
 	 */
 	else {
 		for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
-		     i < sfp->hdr.count;
-		     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
-			if (sfep->namelen == args->namelen &&
-			    sfep->name[0] == args->name[0] &&
-			    memcmp(args->name, sfep->name, args->namelen) == 0) {
+				i < sfp->hdr.count;
+				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
+			if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
+								XFS_CMP_EXACT) {
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
@@ -313,6 +314,7 @@ typedef struct xfs_mount {
 	__uint8_t		m_inode_quiesce;/* call quiesce on new inodes.
 						   field governed by m_ilock */
 	__uint8_t		m_sectbb_log;	/* sectlog - BBSHIFT */
+	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
 	int			m_dirblkfsbs;	/* directory block sz--fsbs */
 	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */

-- 
