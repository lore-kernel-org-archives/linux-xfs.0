Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 00:55:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4E7sUaX029055
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 00:54:35 -0700
Message-Id: <20080514075516.430681639@chook.melbourne.sgi.com>
References: <20080514075244.738514733@chook.melbourne.sgi.com>
Date: Wed, 14 May 2008 17:52:46 +1000
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
 fs/xfs/xfs_attr.c       |   11 +++++------
 fs/xfs/xfs_attr_leaf.c  |   20 +++++++++++---------
 fs/xfs/xfs_da_btree.c   |    2 +-
 fs/xfs/xfs_da_btree.h   |   13 +++++++++----
 fs/xfs/xfs_dir2.c       |   12 ++++++------
 fs/xfs/xfs_dir2_block.c |   10 +++++-----
 fs/xfs/xfs_dir2_leaf.c  |   15 ++++++++-------
 fs/xfs/xfs_dir2_node.c  |   16 +++++++++-------
 fs/xfs/xfs_dir2_sf.c    |    8 ++++----
 fs/xfs/xfs_dir2_trace.c |   20 +++++++++++---------
 fs/xfs/xfsidbg.c        |    5 ++++-
 11 files changed, 73 insertions(+), 59 deletions(-)

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
+	if (args->op_flags & XFS_DA_OP_RENAME) {
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
+	if (args->op_flags & XFS_DA_OP_RENAME) {
 		/*
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
Index: kern_ci/fs/xfs/xfs_attr_leaf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_attr_leaf.c
+++ kern_ci/fs/xfs/xfs_attr_leaf.c
@@ -369,9 +369,10 @@ xfs_attr_shortform_remove(xfs_da_args_t 
 	 * Fix up the start offset of the attribute fork
 	 */
 	totsize -= size;
-	if (totsize == sizeof(xfs_attr_sf_hdr_t) && !args->addname &&
-	    (mp->m_flags & XFS_MOUNT_ATTR2) && 
-	    (dp->i_d.di_format != XFS_DINODE_FMT_BTREE)) {
+	if (totsize == sizeof(xfs_attr_sf_hdr_t) &&
+				!(args->op_flags & XFS_DA_OP_ADDNAME) &&
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
+				(args->op_flags & XFS_DA_OP_ADDNAME) ||
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
+	if (args->op_flags & XFS_DA_OP_RENAME) {
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
+		ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
 		return(0);
 	}
 
Index: kern_ci/fs/xfs/xfs_da_btree.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_da_btree.h
+++ kern_ci/fs/xfs/xfs_da_btree.h
@@ -132,14 +132,19 @@ typedef struct xfs_da_args {
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
+	if (args->op_flags & XFS_DA_OP_JUSTCHECK)
 		xfs_da_brelse(tp, bp);
 	/*
 	 * If we don't have space for the new entry & leaf ...
@@ -225,7 +225,7 @@ xfs_dir2_block_addname(
 		 * Not trying to actually do anything, or don't have
 		 * a space reservation: return no-space.
 		 */
-		if (args->justcheck || args->total == 0)
+		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
 			return XFS_ERROR(ENOSPC);
 		/*
 		 * Convert to the next larger format.
@@ -240,7 +240,7 @@ xfs_dir2_block_addname(
 	/*
 	 * Just checking, and it would work, so say so.
 	 */
-	if (args->justcheck)
+	if (args->op_flags & XFS_DA_OP_JUSTCHECK)
 		return 0;
 	needlog = needscan = 0;
 	/*
@@ -674,7 +674,7 @@ xfs_dir2_block_lookup_int(
 		else
 			high = mid - 1;
 		if (low > high) {
-			ASSERT(args->oknoent);
+			ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
 			xfs_da_brelse(tp, bp);
 			return XFS_ERROR(ENOENT);
 		}
@@ -713,7 +713,7 @@ xfs_dir2_block_lookup_int(
 	} while (++mid < be32_to_cpu(btp->count) &&
 			be32_to_cpu(blp[mid].hashval) == hash);
 
-	ASSERT(args->oknoent);
+	ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
 	/*
 	 * Here, we can only be doing a lookup (not a rename or replace).
 	 * If a case-insensitive match was found earlier, return success.
Index: kern_ci/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_leaf.c
+++ kern_ci/fs/xfs/xfs_dir2_leaf.c
@@ -263,20 +263,21 @@ xfs_dir2_leaf_addname(
 	 * If we don't have enough free bytes but we can make enough
 	 * by compacting out stale entries, we'll do that.
 	 */
-	if ((char *)bestsp - (char *)&leaf->ents[be16_to_cpu(leaf->hdr.count)] < needbytes &&
-	    be16_to_cpu(leaf->hdr.stale) > 1) {
+	if ((char *)bestsp - (char *)&leaf->ents[be16_to_cpu(leaf->hdr.count)] <
+				needbytes && be16_to_cpu(leaf->hdr.stale) > 1) {
 		compact = 1;
 	}
 	/*
 	 * Otherwise if we don't have enough free bytes we need to
 	 * convert to node form.
 	 */
-	else if ((char *)bestsp - (char *)&leaf->ents[be16_to_cpu(leaf->hdr.count)] <
-		 needbytes) {
+	else if ((char *)bestsp - (char *)&leaf->ents[be16_to_cpu(
+						leaf->hdr.count)] < needbytes) {
 		/*
 		 * Just checking or no space reservation, give up.
 		 */
-		if (args->justcheck || args->total == 0) {
+		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) ||
+							args->total == 0) {
 			xfs_da_brelse(tp, lbp);
 			return XFS_ERROR(ENOSPC);
 		}
@@ -301,7 +302,7 @@ xfs_dir2_leaf_addname(
 	 * If just checking, then it will fit unless we needed to allocate
 	 * a new data block.
 	 */
-	if (args->justcheck) {
+	if (args->op_flags & XFS_DA_OP_JUSTCHECK) {
 		xfs_da_brelse(tp, lbp);
 		return use_block == -1 ? XFS_ERROR(ENOSPC) : 0;
 	}
@@ -1414,7 +1415,7 @@ xfs_dir2_leaf_lookup_int(
 			cbp = dbp;
 		}
 	}
-	ASSERT(args->oknoent);
+	ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
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
+	if (args->op_flags & XFS_DA_OP_JUSTCHECK)
 		return 0;
 
 	/*
@@ -515,7 +515,7 @@ xfs_dir2_leafn_lookup_for_addname(
 	/* Didn't find any space */
 	fi = -1;
 out:
-	ASSERT(args->oknoent);
+	ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
 	if (curbp) {
 		/* Giving back a free block. */
 		state->extravalid = 1;
@@ -638,7 +638,8 @@ xfs_dir2_leafn_lookup_for_entry(
 	/* Didn't find an exact match. */
 	error = ENOENT;
 	di = -1;
-	ASSERT(index == be16_to_cpu(leaf->hdr.count) || args->oknoent);
+	ASSERT(index == be16_to_cpu(leaf->hdr.count) ||
+					(args->op_flags & XFS_DA_OP_OKNOENT));
 out:
 	if (curbp) {
 		/* Giving back a data block. */
@@ -669,7 +670,7 @@ xfs_dir2_leafn_lookup_int(
 	int			*indexp,	/* out: leaf entry index */
 	xfs_da_state_t		*state)		/* state to fill in */
 {
-	if (args->addname)
+	if (args->op_flags & XFS_DA_OP_ADDNAME)
 		return xfs_dir2_leafn_lookup_for_addname(bp, args, indexp,
 							state);
 	return xfs_dir2_leafn_lookup_for_entry(bp, args, indexp, state);
@@ -1383,7 +1384,7 @@ xfs_dir2_node_addname(
 		/*
 		 * It worked, fix the hash values up the btree.
 		 */
-		if (!args->justcheck)
+		if (!(args->op_flags & XFS_DA_OP_JUSTCHECK))
 			xfs_da_fixhashpath(state, &state->path);
 	} else {
 		/*
@@ -1566,7 +1567,8 @@ xfs_dir2_node_addname_int(
 		/*
 		 * Not allowed to allocate, return failure.
 		 */
-		if (args->justcheck || args->total == 0) {
+		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) ||
+							args->total == 0) {
 			/*
 			 * Drop the freespace buffer unless it came from our
 			 * caller.
@@ -1712,7 +1714,7 @@ xfs_dir2_node_addname_int(
 		/*
 		 * If just checking, we succeeded.
 		 */
-		if (args->justcheck) {
+		if (args->op_flags & XFS_DA_OP_JUSTCHECK) {
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
+		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
 			return XFS_ERROR(ENOSPC);
 		/*
 		 * Convert to block form then add the name.
@@ -345,7 +345,7 @@ xfs_dir2_sf_addname(
 	/*
 	 * Just checking, it fits.
 	 */
-	if (args->justcheck)
+	if (args->op_flags & XFS_DA_OP_JUSTCHECK)
 		return 0;
 	/*
 	 * Do it the easy way - just add it at the end.
@@ -869,7 +869,7 @@ xfs_dir2_sf_lookup(
 				return XFS_ERROR(EEXIST);
 		}
 	}
-	ASSERT(args->oknoent);
+	ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
 	/*
 	 * Here, we can only be doing a lookup (not a rename or replace).
 	 * If a case-insensitive match was found earlier, return "found".
@@ -1071,7 +1071,7 @@ xfs_dir2_sf_replace(
 		 * Didn't find it.
 		 */
 		if (i == sfp->hdr.count) {
-			ASSERT(args->oknoent);
+			ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
 #if XFS_BIG_INUMS
 			if (i8elevated)
 				xfs_dir2_sf_toino4(args);
Index: kern_ci/fs/xfs/xfs_dir2_trace.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_trace.c
+++ kern_ci/fs/xfs/xfs_dir2_trace.c
@@ -85,7 +85,8 @@ xfs_dir2_trace_args(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck, NULL, NULL);
+		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
+		NULL, NULL);
 }
 
 void
@@ -100,7 +101,7 @@ xfs_dir2_trace_args_b(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck,
+		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
 		(void *)(bp ? bp->bps[0] : NULL), NULL);
 }
 
@@ -117,7 +118,7 @@ xfs_dir2_trace_args_bb(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck,
+		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
 		(void *)(lbp ? lbp->bps[0] : NULL),
 		(void *)(dbp ? dbp->bps[0] : NULL));
 }
@@ -157,8 +158,8 @@ xfs_dir2_trace_args_db(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck, (void *)(long)db,
-		(void *)dbp);
+		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
+		(void *)(long)db, (void *)dbp);
 }
 
 void
@@ -173,7 +174,7 @@ xfs_dir2_trace_args_i(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck,
+		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
 		(void *)((unsigned long)(i >> 32)),
 		(void *)((unsigned long)(i & 0xFFFFFFFF)));
 }
@@ -190,7 +191,8 @@ xfs_dir2_trace_args_s(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck, (void *)(long)s, NULL);
+		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
+		(void *)(long)s, NULL);
 }
 
 void
@@ -208,7 +210,7 @@ xfs_dir2_trace_args_sb(
 		(void *)((unsigned long)(args->inumber >> 32)),
 		(void *)((unsigned long)(args->inumber & 0xFFFFFFFF)),
 		(void *)args->dp, (void *)args->trans,
-		(void *)(unsigned long)args->justcheck, (void *)(long)s,
-		(void *)dbp);
+		(void *)(unsigned long)(args->op_flags & XFS_DA_OP_JUSTCHECK),
+		(void *)(long)s, (void *)dbp);
 }
 #endif	/* XFS_DIR2_TRACE */
Index: kern_ci/fs/xfs/xfsidbg.c
===================================================================
--- kern_ci.orig/fs/xfs/xfsidbg.c
+++ kern_ci/fs/xfs/xfsidbg.c
@@ -5237,7 +5237,10 @@ xfsidbg_xdaargs(xfs_da_args_t *n)
 		kdb_printf("0x%x", n->flags & i);
 	kdb_printf(">\n");
 	kdb_printf(" rename %d justcheck %d addname %d oknoent %d\n",
-		  n->rename, n->justcheck, n->addname, n->oknoent);
+		  n->op_flags & XFS_DA_OP_RENAME != 0,
+		  n->op_flags & XFS_DA_OP_JUSTCHECK != 0,
+		  n->op_flags & XFS_DA_OP_ADDNAME != 0,
+		  n->op_flags & XFS_DA_OP_OKNOENT != 0);
 	kdb_printf(" leaf: blkno %d index %d rmtblkno %d rmtblkcnt %d\n",
 		  n->blkno, n->index, n->rmtblkno, n->rmtblkcnt);
 	kdb_printf(" leaf2: blkno %d index %d rmtblkno %d rmtblkcnt %d\n",

-- 
