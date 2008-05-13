Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 01:01:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4D816cf006484
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:01:09 -0700
Message-Id: <20080513080152.598022276@chook.melbourne.sgi.com>
References: <20080513075749.477238845@chook.melbourne.sgi.com>
Date: Tue, 13 May 2008 17:57:51 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 2/4] XFS: add op_flags field and helpers to xfs_da_args
Content-Disposition: inline; filename=additional_da_args_flag.patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

The end of the xfs_da_args structure has 4 unsigned char fields for 
true/false information on directory and attr operations using the
xfs_da_args structure.

The following converts these 4 into a op_flags field that uses the
first 4 bits for these fields and allows expansion for future 
operation information (eg. case-insensitive lookup request).

There is also a bit of EOL whitespace cleanup too.

Signed-off-by: Barry Naujok <bnaujok@sgi.com>

---
 fs/xfs/xfs_attr.c       |   11 ++++------
 fs/xfs/xfs_attr_leaf.c  |   52 ++++++++++++++++++++++++------------------------
 fs/xfs/xfs_da_btree.c   |    2 -
 fs/xfs/xfs_da_btree.h   |   33 ++++++++++++++++++++++++++----
 fs/xfs/xfs_dir2.c       |   12 +++++------
 fs/xfs/xfs_dir2_block.c |   10 ++++-----
 fs/xfs/xfs_dir2_leaf.c  |    6 ++---
 fs/xfs/xfs_dir2_node.c  |   15 +++++++------
 fs/xfs/xfs_dir2_sf.c    |    8 +++----
 fs/xfs/xfs_dir2_trace.c |   19 +++++++++--------
 fs/xfs/xfsidbg.c        |   13 ++++++------
 11 files changed, 105 insertions(+), 76 deletions(-)

Index: kern_ci/fs/xfs/xfs_attr.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_attr.c
+++ kern_ci/fs/xfs/xfs_attr.c
@@ -241,8 +241,7 @@ xfs_attr_set_int(xfs_inode_t *dp, struct
 	args.firstblock = &firstblock;
 	args.flist = &flist;
 	args.whichfork = XFS_ATTR_FORK;
-	args.addname = 1;
-	args.oknoent = 1;
+	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
 
 	/*
 	 * Determine space new attribute will use, and if it would be
@@ -974,7 +973,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *arg
 			xfs_da_brelse(args->trans, bp);
 			return(retval);
 		}
-		args->rename = 1;			/* an atomic rename */
+		args->op_flags |= XFS_DA_OP_RENAME;	/* an atomic rename */
 		args->blkno2 = args->blkno;		/* set 2nd entry info*/
 		args->index2 = args->index;
 		args->rmtblkno2 = args->rmtblkno;
@@ -1054,7 +1053,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *arg
 	 * so that one disappears and one appears atomically.  Then we
 	 * must remove the "old" attribute/value pair.
 	 */
-	if (args->rename) {
+	if (xfs_da_isrename_op(args)) {
 		/*
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
@@ -1307,7 +1306,7 @@ restart:
 	} else if (retval == EEXIST) {
 		if (args->flags & ATTR_CREATE)
 			goto out;
-		args->rename = 1;			/* atomic rename op */
+		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
 		args->blkno2 = args->blkno;		/* set 2nd entry info*/
 		args->index2 = args->index;
 		args->rmtblkno2 = args->rmtblkno;
@@ -1425,7 +1424,7 @@ restart:
 	 * so that one disappears and one appears atomically.  Then we
 	 * must remove the "old" attribute/value pair.
 	 */
-	if (args->rename) {
+	if (xfs_da_isrename_op(args)) {
 		/*
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
Index: kern_ci/fs/xfs/xfs_attr_leaf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_attr_leaf.c
+++ kern_ci/fs/xfs/xfs_attr_leaf.c
@@ -150,7 +150,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 	int offset;
 	int minforkoff;	/* lower limit on valid forkoff locations */
 	int maxforkoff;	/* upper limit on valid forkoff locations */
-	int dsize;	
+	int dsize;
 	xfs_mount_t *mp = dp->i_mount;
 
 	offset = (XFS_LITINO(mp) - bytes) >> 3; /* rounded down */
@@ -171,39 +171,39 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 	}
 
 	dsize = dp->i_df.if_bytes;
-	
+
 	switch (dp->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
-		/* 
-		 * If there is no attr fork and the data fork is extents, 
-		 * determine if creating the default attr fork will result 
-		 * in the extents form migrating to btree. If so, the 
-		 * minimum offset only needs to be the space required for 
+		/*
+		 * If there is no attr fork and the data fork is extents,
+		 * determine if creating the default attr fork will result
+		 * in the extents form migrating to btree. If so, the
+		 * minimum offset only needs to be the space required for
 		 * the btree root.
-		 */ 
+		 */
 		if (!dp->i_d.di_forkoff && dp->i_df.if_bytes > mp->m_attroffset)
 			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 		break;
-		
+
 	case XFS_DINODE_FMT_BTREE:
 		/*
 		 * If have data btree then keep forkoff if we have one,
-		 * otherwise we are adding a new attr, so then we set 
-		 * minforkoff to where the btree root can finish so we have 
+		 * otherwise we are adding a new attr, so then we set
+		 * minforkoff to where the btree root can finish so we have
 		 * plenty of room for attrs
 		 */
 		if (dp->i_d.di_forkoff) {
-			if (offset < dp->i_d.di_forkoff) 
+			if (offset < dp->i_d.di_forkoff)
 				return 0;
-			else 
+			else
 				return dp->i_d.di_forkoff;
 		} else
 			dsize = XFS_BMAP_BROOT_SPACE(dp->i_df.if_broot);
 		break;
 	}
-	
-	/* 
-	 * A data fork btree root must have space for at least 
+
+	/*
+	 * A data fork btree root must have space for at least
 	 * MINDBTPTRS key/ptr pairs if the data fork is small or empty.
 	 */
 	minforkoff = MAX(dsize, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
@@ -369,9 +369,10 @@ xfs_attr_shortform_remove(xfs_da_args_t 
 	 * Fix up the start offset of the attribute fork
 	 */
 	totsize -= size;
-	if (totsize == sizeof(xfs_attr_sf_hdr_t) && !args->addname &&
-	    (mp->m_flags & XFS_MOUNT_ATTR2) && 
-	    (dp->i_d.di_format != XFS_DINODE_FMT_BTREE)) {
+	if (totsize == sizeof(xfs_attr_sf_hdr_t) &&
+				!xfs_da_isaddname_op(args) &&
+				(mp->m_flags & XFS_MOUNT_ATTR2) &&
+				(dp->i_d.di_format != XFS_DINODE_FMT_BTREE)) {
 		/*
 		 * Last attribute now removed, revert to original
 		 * inode format making all literal area available
@@ -389,9 +390,10 @@ xfs_attr_shortform_remove(xfs_da_args_t 
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
 		dp->i_d.di_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
 		ASSERT(dp->i_d.di_forkoff);
-		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) || args->addname ||
-			!(mp->m_flags & XFS_MOUNT_ATTR2) ||
-			dp->i_d.di_format == XFS_DINODE_FMT_BTREE);
+		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
+				xfs_da_isaddname_op(args) ||
+				!(mp->m_flags & XFS_MOUNT_ATTR2) ||
+				dp->i_d.di_format == XFS_DINODE_FMT_BTREE);
 		dp->i_afp->if_ext_max =
 			XFS_IFORK_ASIZE(dp) / (uint)sizeof(xfs_bmbt_rec_t);
 		dp->i_df.if_ext_max =
@@ -531,7 +533,7 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t
 	nargs.total = args->total;
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
-	nargs.oknoent = 1;
+	nargs.op_flags = XFS_DA_OP_OKNOENT;
 
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; i++) {
@@ -853,7 +855,7 @@ xfs_attr_leaf_to_shortform(xfs_dabuf_t *
 	nargs.total = args->total;
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
-	nargs.oknoent = 1;
+	nargs.op_flags = XFS_DA_OP_OKNOENT;
 	entry = &leaf->entries[0];
 	for (i = 0; i < be16_to_cpu(leaf->hdr.count); entry++, i++) {
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
@@ -1155,7 +1157,7 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, 
 	entry->hashval = cpu_to_be32(args->hashval);
 	entry->flags = tmp ? XFS_ATTR_LOCAL : 0;
 	entry->flags |= XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
-	if (args->rename) {
+	if (xfs_da_isrename_op(args)) {
 		entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
Index: kern_ci/fs/xfs/xfs_da_btree.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_da_btree.c
+++ kern_ci/fs/xfs/xfs_da_btree.c
@@ -1431,7 +1431,7 @@ xfs_da_path_shift(xfs_da_state_t *state,
 	}
 	if (level < 0) {
 		*result = XFS_ERROR(ENOENT);	/* we're out of our tree */
-		ASSERT(args->oknoent);
+		ASSERT(xfs_da_isoknoent_op(args));
 		return(0);
 	}
 
Index: kern_ci/fs/xfs/xfs_da_btree.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_da_btree.h
+++ kern_ci/fs/xfs/xfs_da_btree.h
@@ -132,14 +132,39 @@ typedef struct xfs_da_args {
 	int		index2;		/* index of 2nd attr in blk */
 	xfs_dablk_t	rmtblkno2;	/* remote attr value starting blkno */
 	int		rmtblkcnt2;	/* remote attr value block count */
-	unsigned char	justcheck;	/* T/F: check for ok with no space */
-	unsigned char	rename;		/* T/F: this is an atomic rename op */
-	unsigned char	addname;	/* T/F: this is an add operation */
-	unsigned char	oknoent;	/* T/F: ok to return ENOENT, else die */
+	int		op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
 } xfs_da_args_t;
 
 /*
+ * Operation flags:
+ */
+#define XFS_DA_OP_JUSTCHECK	0x0001	/* check for ok with no space */
+#define XFS_DA_OP_RENAME	0x0002	/* this is an atomic rename op */
+#define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
+#define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
+
+static inline int xfs_da_isjustcheck_op(struct xfs_da_args *args)
+{
+	return args->op_flags & XFS_DA_OP_JUSTCHECK;
+}
+
+static inline int xfs_da_isrename_op(struct xfs_da_args *args)
+{
+	return args->op_flags & XFS_DA_OP_RENAME;
+}
+
+static inline int xfs_da_isaddname_op(struct xfs_da_args *args)
+{
+	return args->op_flags & XFS_DA_OP_ADDNAME;
+}
+
+static inline int xfs_da_isoknoent_op(struct xfs_da_args *args)
+{
+	return args->op_flags & XFS_DA_OP_OKNOENT;
+}
+
+/*
  * Structure to describe buffer(s) for a block.
  * This is needed in the directory version 2 format case, when
  * multiple non-contiguous fsblocks might be needed to cover one
Index: kern_ci/fs/xfs/xfs_dir2.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.c
+++ kern_ci/fs/xfs/xfs_dir2.c
@@ -175,8 +175,7 @@ xfs_dir_createname(
 	args.total = total;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
-	args.justcheck = 0;
-	args.addname = args.oknoent = 1;
+	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_addname(&args);
@@ -217,7 +216,7 @@ xfs_dir_lookup(
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
-	args.oknoent = 1;
+	args.op_flags = XFS_DA_OP_OKNOENT;
 	args.cmpresult = XFS_CMP_DIFFERENT;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
@@ -269,7 +268,7 @@ xfs_dir_removename(
 	args.total = total;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
-	args.justcheck = args.addname = args.oknoent = 0;
+	args.op_flags = 0;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_removename(&args);
@@ -352,7 +351,7 @@ xfs_dir_replace(
 	args.total = total;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
-	args.justcheck = args.addname = args.oknoent = 0;
+	args.op_flags = 0;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_replace(&args);
@@ -396,7 +395,8 @@ xfs_dir_canenter(
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
-	args.justcheck = args.addname = args.oknoent = 1;
+	args.op_flags = XFS_DA_OP_JUSTCHECK | XFS_DA_OP_ADDNAME |
+							XFS_DA_OP_OKNOENT;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_addname(&args);
Index: kern_ci/fs/xfs/xfs_dir2_block.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_block.c
+++ kern_ci/fs/xfs/xfs_dir2_block.c
@@ -215,7 +215,7 @@ xfs_dir2_block_addname(
 	/*
 	 * If this isn't a real add, we're done with the buffer.
 	 */
-	if (args->justcheck)
+	if (xfs_da_isjustcheck_op(args))
 		xfs_da_brelse(tp, bp);
 	/*
 	 * If we don't have space for the new entry & leaf ...
@@ -225,7 +225,7 @@ xfs_dir2_block_addname(
 		 * Not trying to actually do anything, or don't have
 		 * a space reservation: return no-space.
 		 */
-		if (args->justcheck || args->total == 0)
+		if (xfs_da_isjustcheck_op(args) || args->total == 0)
 			return XFS_ERROR(ENOSPC);
 		/*
 		 * Convert to the next larger format.
@@ -240,7 +240,7 @@ xfs_dir2_block_addname(
 	/*
 	 * Just checking, and it would work, so say so.
 	 */
-	if (args->justcheck)
+	if (xfs_da_isjustcheck_op(args))
 		return 0;
 	needlog = needscan = 0;
 	/*
@@ -674,7 +674,7 @@ xfs_dir2_block_lookup_int(
 		else
 			high = mid - 1;
 		if (low > high) {
-			ASSERT(args->oknoent);
+			ASSERT(xfs_da_isoknoent_op(args));
 			xfs_da_brelse(tp, bp);
 			return XFS_ERROR(ENOENT);
 		}
@@ -713,7 +713,7 @@ xfs_dir2_block_lookup_int(
 	} while (++mid < be32_to_cpu(btp->count) &&
 			be32_to_cpu(blp[mid].hashval) == hash);
 
-	ASSERT(args->oknoent);
+	ASSERT(xfs_da_isoknoent_op(args));
 	/*
 	 * Here, we can only be doing a lookup (not a rename or replace).
 	 * If a case-insensitive match was found earlier, return success.
Index: kern_ci/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_leaf.c
+++ kern_ci/fs/xfs/xfs_dir2_leaf.c
@@ -276,7 +276,7 @@ xfs_dir2_leaf_addname(
 		/*
 		 * Just checking or no space reservation, give up.
 		 */
-		if (args->justcheck || args->total == 0) {
+		if (xfs_da_isjustcheck_op(args) || args->total == 0) {
 			xfs_da_brelse(tp, lbp);
 			return XFS_ERROR(ENOSPC);
 		}
@@ -301,7 +301,7 @@ xfs_dir2_leaf_addname(
 	 * If just checking, then it will fit unless we needed to allocate
 	 * a new data block.
 	 */
-	if (args->justcheck) {
+	if (xfs_da_isjustcheck_op(args)) {
 		xfs_da_brelse(tp, lbp);
 		return use_block == -1 ? XFS_ERROR(ENOSPC) : 0;
 	}
@@ -1414,7 +1414,7 @@ xfs_dir2_leaf_lookup_int(
 			cbp = dbp;
 		}
 	}
-	ASSERT(args->oknoent);
+	ASSERT(xfs_da_isoknoent_op(args));
 	/*
 	 * Here, we can only be doing a lookup (not a rename or replace).
 	 * If a case-insensitive match was found earlier, release the current
Index: kern_ci/fs/xfs/xfs_dir2_node.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_node.c
+++ kern_ci/fs/xfs/xfs_dir2_node.c
@@ -226,7 +226,7 @@ xfs_dir2_leafn_add(
 	ASSERT(index == be16_to_cpu(leaf->hdr.count) ||
 	       be32_to_cpu(leaf->ents[index].hashval) >= args->hashval);
 
-	if (args->justcheck)
+	if (xfs_da_isjustcheck_op(args))
 		return 0;
 
 	/*
@@ -515,7 +515,7 @@ xfs_dir2_leafn_lookup_for_addname(
 	/* Didn't find any space */
 	fi = -1;
 out:
-	ASSERT(args->oknoent);
+	ASSERT(xfs_da_isoknoent_op(args));
 	if (curbp) {
 		/* Giving back a free block. */
 		state->extravalid = 1;
@@ -638,7 +638,8 @@ xfs_dir2_leafn_lookup_for_entry(
 	/* Didn't find an exact match. */
 	error = ENOENT;
 	di = -1;
-	ASSERT(index == be16_to_cpu(leaf->hdr.count) || args->oknoent);
+	ASSERT(index == be16_to_cpu(leaf->hdr.count) ||
+					xfs_da_isoknoent_op(args));
 out:
 	if (curbp) {
 		/* Giving back a data block. */
@@ -669,7 +670,7 @@ xfs_dir2_leafn_lookup_int(
 	int			*indexp,	/* out: leaf entry index */
 	xfs_da_state_t		*state)		/* state to fill in */
 {
-	if (args->addname)
+	if (xfs_da_isaddname_op(args))
 		return xfs_dir2_leafn_lookup_for_addname(bp, args, indexp,
 							state);
 	return xfs_dir2_leafn_lookup_for_entry(bp, args, indexp, state);
@@ -1383,7 +1384,7 @@ xfs_dir2_node_addname(
 		/*
 		 * It worked, fix the hash values up the btree.
 		 */
-		if (!args->justcheck)
+		if (!xfs_da_isjustcheck_op(args))
 			xfs_da_fixhashpath(state, &state->path);
 	} else {
 		/*
@@ -1566,7 +1567,7 @@ xfs_dir2_node_addname_int(
 		/*
 		 * Not allowed to allocate, return failure.
 		 */
-		if (args->justcheck || args->total == 0) {
+		if (xfs_da_isjustcheck_op(args) || args->total == 0) {
 			/*
 			 * Drop the freespace buffer unless it came from our
 			 * caller.
@@ -1712,7 +1713,7 @@ xfs_dir2_node_addname_int(
 		/*
 		 * If just checking, we succeeded.
 		 */
-		if (args->justcheck) {
+		if (xfs_da_isjustcheck_op(args)) {
 			if ((fblk == NULL || fblk->bp == NULL) && fbp != NULL)
 				xfs_da_buf_done(fbp);
 			return 0;
Index: kern_ci/fs/xfs/xfs_dir2_sf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_sf.c
+++ kern_ci/fs/xfs/xfs_dir2_sf.c
@@ -332,7 +332,7 @@ xfs_dir2_sf_addname(
 		/*
 		 * Just checking or no space reservation, it doesn't fit.
 		 */
-		if (args->justcheck || args->total == 0)
+		if (xfs_da_isjustcheck_op(args) || args->total == 0)
 			return XFS_ERROR(ENOSPC);
 		/*
 		 * Convert to block form then add the name.
@@ -345,7 +345,7 @@ xfs_dir2_sf_addname(
 	/*
 	 * Just checking, it fits.
 	 */
-	if (args->justcheck)
+	if (xfs_da_isjustcheck_op(args))
 		return 0;
 	/*
 	 * Do it the easy way - just add it at the end.
@@ -869,7 +869,7 @@ xfs_dir2_sf_lookup(
 				return XFS_ERROR(EEXIST);
 		}
 	}
-	ASSERT(args->oknoent);
+	ASSERT(xfs_da_isoknoent_op(args));
 	/*
 	 * Here, we can only be doing a lookup (not a rename or replace).
 	 * If a case-insensitive match was found earlier, return "found".
@@ -1071,7 +1071,7 @@ xfs_dir2_sf_replace(
 		 * Didn't find it.
 		 */
 		if (i == sfp->hdr.count) {
-			ASSERT(args->oknoent);
+			ASSERT(xfs_da_isoknoent_op(args));
 #if XFS_BIG_INUMS
 			if (i8elevated)
 				xfs_dir2_sf_toino4(args);
Index: kern_ci/fs/xfs/xfs_dir2_trace.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_trace.c
+++ kern_ci/fs/xfs/xfs_dir2_trace.c
@@ -85,7 +85,7 @@ xfs_dir2_trace_args(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck, NULL, NULL);
+		(void *)(unsigned long)xfs_da_isjustcheck_op(args), NULL, NULL);
 }
 
 void
@@ -100,7 +100,7 @@ xfs_dir2_trace_args_b(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck,
+		(void *)(unsigned long)xfs_da_isjustcheck_op(args),
 		(void *)(bp ? bp->bps[0] : NULL), NULL);
 }
 
@@ -117,7 +117,7 @@ xfs_dir2_trace_args_bb(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck,
+		(void *)(unsigned long)xfs_da_isjustcheck_op(args),
 		(void *)(lbp ? lbp->bps[0] : NULL),
 		(void *)(dbp ? dbp->bps[0] : NULL));
 }
@@ -157,8 +157,8 @@ xfs_dir2_trace_args_db(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck, (void *)(long)db,
-		(void *)dbp);
+		(void *)(unsigned long)xfs_da_isjustcheck_op(args),
+		(void *)(long)db, (void *)dbp);
 }
 
 void
@@ -173,7 +173,7 @@ xfs_dir2_trace_args_i(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck,
+		(void *)(unsigned long)xfs_da_isjustcheck_op(args),
 		(void *)((unsigned long)(i >> 32)),
 		(void *)((unsigned long)(i & 0xFFFFFFFF)));
 }
@@ -190,7 +190,8 @@ xfs_dir2_trace_args_s(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck, (void *)(long)s, NULL);
+		(void *)(unsigned long)xfs_da_isjustcheck_op(args),
+		(void *)(long)s, NULL);
 }
 
 void
@@ -208,7 +209,7 @@ xfs_dir2_trace_args_sb(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck, (void *)(long)s,
-		(void *)dbp);
+		(void *)(unsigned long)xfs_da_isjustcheck_op(args),
+		(void *)(long)s, (void *)dbp);
 }
 #endif	/* XFS_DIR2_TRACE */
Index: kern_ci/fs/xfs/xfsidbg.c
===================================================================
--- kern_ci.orig/fs/xfs/xfsidbg.c
+++ kern_ci/fs/xfs/xfsidbg.c
@@ -308,7 +308,7 @@ static int	kdbm_xfs_xalatrace(
 	int nextarg = 1;
 	long offset = 0;
 	int diag;
-	
+
 	if (argc != 1)
 		return KDB_ARGCOUNT;
 
@@ -5237,7 +5237,8 @@ xfsidbg_xdaargs(xfs_da_args_t *n)
 		kdb_printf("0x%x", n->flags & i);
 	kdb_printf(">\n");
 	kdb_printf(" rename %d justcheck %d addname %d oknoent %d\n",
-		  n->rename, n->justcheck, n->addname, n->oknoent);
+		  xfs_da_isrename_op(n) != 0, xfs_da_isjustcheck_op(n) != 0,
+		  xfs_da_isaddname_op(n) != 0, xfs_da_isoknoent_op(n) != 0);
 	kdb_printf(" leaf: blkno %d index %d rmtblkno %d rmtblkcnt %d\n",
 		  n->blkno, n->index, n->rmtblkno, n->rmtblkcnt);
 	kdb_printf(" leaf2: blkno %d index %d rmtblkno %d rmtblkcnt %d\n",
@@ -5955,7 +5956,7 @@ xfsidbg_xlog_granttrace(xlog_t *log)
 		xfsidbg_print_trans_type((unsigned long)ktep->val[12]);
 		qprintf("]\n");
 		qprintf("  t_ocnt = %lu, t_cnt = %lu, t_curr_res = %lu, "
-			"t_unit_res = %lu\n", 
+			"t_unit_res = %lu\n",
 			t_ocnt, t_cnt, (unsigned long)ktep->val[14],
 			(unsigned long)ktep->val[15]);
 		qprintf("  tic:0x%p resQ:0x%p wrQ:0x%p ",
@@ -6449,16 +6450,16 @@ xfsidbg_xnode(xfs_inode_t *ip)
 #endif
 #ifdef XFS_BMBT_TRACE
 	qprintf(" bmbt trace 0x%p\n", ip->i_btrace);
-#endif  
+#endif
 #ifdef XFS_RW_TRACE
 	qprintf(" rw trace 0x%p\n", ip->i_rwtrace);
-#endif  
+#endif
 #ifdef XFS_ILOCK_TRACE
 	qprintf(" ilock trace 0x%p\n", ip->i_lock_trace);
 #endif
 #ifdef XFS_DIR2_TRACE
 	qprintf(" dir trace 0x%p\n", ip->i_dir_trace);
-#endif  
+#endif
 	kdb_printf("\n");
 	xfs_xnode_fork("data", &ip->i_df);
 	xfs_xnode_fork("attr", ip->i_afp);

-- 
