Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 01:01:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4D816nL006485
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:01:09 -0700
Message-Id: <20080513080152.911303131@chook.melbourne.sgi.com>
References: <20080513075749.477238845@chook.melbourne.sgi.com>
Date: Tue, 13 May 2008 17:57:52 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 3/4] XFS: Return case-insensitive match for dentry cache
Content-Disposition: inline; filename=return_name.patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

This implements the code to store the actual filename found
during a lookup in the dentry cache and to avoid multiple entries
in the dcache pointing to the same inode.

To avoid polluting the dcache, we implement a new directory inode
operations for lookup. xfs_vn_ci_lookup() interacts directly with
the dcache and the code was derived from ntfs_lookup() in
fs/ntfs/namei.c.

The "actual name" is only allocated and returned for a case-
insensitive match and not an actual match.

Another unusual interaction with the dcache is not storing 
negative dentries like other filesystems doing a d_add(dentry, NULL)
when an ENOENT is returned. During the VFS lookup, if a dentry
returned has no inode, dput is called and ENOENT is returned.
By not doing a d_add, this actually removes it completely from
the dcache to be reused. create/rename have to be modified to
support unhashed dentries being passed in.


Signed-off-by: Barry Naujok <bnaujok@sgi.com>

---
 fs/dcache.c                   |  104 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_export.c |    2 
 fs/xfs/linux-2.6/xfs_iops.c   |   61 ++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_iops.h   |    1 
 fs/xfs/xfs_da_btree.h         |    6 ++
 fs/xfs/xfs_dir2.c             |   40 +++++++++++++++-
 fs/xfs/xfs_dir2.h             |    6 ++
 fs/xfs/xfs_dir2_block.c       |    9 ++-
 fs/xfs/xfs_dir2_leaf.c        |    5 +-
 fs/xfs/xfs_dir2_node.c        |   16 ++++--
 fs/xfs/xfs_dir2_sf.c          |   12 ++--
 fs/xfs/xfs_vnodeops.c         |   18 +++++--
 fs/xfs/xfs_vnodeops.h         |    2 
 include/linux/dcache.h        |    1 
 14 files changed, 256 insertions(+), 27 deletions(-)

Index: kern_ci/fs/dcache.c
===================================================================
--- kern_ci.orig/fs/dcache.c
+++ kern_ci/fs/dcache.c
@@ -1191,6 +1191,109 @@ struct dentry *d_splice_alias(struct ino
 	return new;
 }
 
+/**
+ * d_add_ci - lookup or allocate new dentry with case-exact name
+ * @inode:  the inode case-insensitive lookup has found
+ * @dentry: the negative dentry that was passed to the parent's lookup func
+ * @name:   the case-exact name to be associated with the returned dentry
+ *
+ * This is to avoid filling the dcache with case-insensitive names to the
+ * same inode, only the actual correct case is stored in the dcache for
+ * case-insensitive filesystems.
+ *
+ * For a case-insensitive lookup match and if the the case-exact dentry
+ * already exists in in the dcache, use it and return it.
+ *
+ * If no entry exists with the exact case name, allocate new dentry with
+ * the exact case, and return the spliced entry.
+ */
+
+struct dentry *d_add_ci(struct inode *inode, struct dentry *dentry,
+			struct qstr *name)
+{
+	int error;
+	struct dentry *found;
+	struct dentry *new;
+
+	/* Does a dentry matching the name exist already? */
+	found = d_hash_and_lookup(dentry->d_parent, name);
+	/* If not, create it now and return */
+	if (!found) {
+		new = d_alloc(dentry->d_parent, name);
+		if (!new) {
+			error = -ENOMEM;
+			goto err_out;
+		}
+		found = d_splice_alias(inode, new);
+		if (found) {
+			dput(new);
+			return found;
+		}
+		return new;
+	}
+	/* Matching dentry exists, check if it is negative. */
+	if (found->d_inode) {
+		if (unlikely(found->d_inode != inode)) {
+			/* This can't happen because bad inodes are unhashed. */
+			BUG_ON(!is_bad_inode(inode));
+			BUG_ON(!is_bad_inode(found->d_inode));
+		}
+		/*
+		 * Already have the inode and the dentry attached, decrement
+		 * the reference count to balance the iget() done
+		 * earlier on.  We found the dentry using d_lookup() so it
+		 * cannot be disconnected and thus we do not need to worry
+		 * about any NFS/disconnectedness issues here.
+		 */
+		iput(inode);
+		return found;
+	}
+	/*
+	 * Negative dentry: instantiate it unless the inode is a directory and
+	 * has a 'disconnected' dentry (i.e. IS_ROOT and DCACHE_DISCONNECTED),
+	 * in which case d_move() that in place of the found dentry.
+	 */
+	if (!S_ISDIR(inode->i_mode)) {
+		/* Not a directory; everything is easy. */
+		d_instantiate(found, inode);
+		return found;
+	}
+	spin_lock(&dcache_lock);
+	if (list_empty(&inode->i_dentry)) {
+		/*
+		 * Directory without a 'disconnected' dentry; we need to do
+		 * d_instantiate() by hand because it takes dcache_lock which
+		 * we already hold.
+		 */
+		list_add(&found->d_alias, &inode->i_dentry);
+		found->d_inode = inode;
+		spin_unlock(&dcache_lock);
+		security_d_instantiate(found, inode);
+		return found;
+	}
+	/*
+	 * Directory with a 'disconnected' dentry; get a reference to the
+	 * 'disconnected' dentry.
+	 */
+	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
+	dget_locked(new);
+	spin_unlock(&dcache_lock);
+	/* Do security vodoo. */
+	security_d_instantiate(found, inode);
+	/* Move new in place of found. */
+	d_move(new, found);
+	/* Balance the iget() we did above. */
+	iput(inode);
+	/* Throw away found. */
+	dput(found);
+	/* Use new as the actual dentry. */
+	return new;
+
+err_out:
+	iput(inode);
+	return ERR_PTR(error);
+}
+
 
 /**
  * d_lookup - search for a dentry
@@ -2178,6 +2281,7 @@ EXPORT_SYMBOL(d_path);
 EXPORT_SYMBOL(d_prune_aliases);
 EXPORT_SYMBOL(d_rehash);
 EXPORT_SYMBOL(d_splice_alias);
+EXPORT_SYMBOL(d_add_ci);
 EXPORT_SYMBOL(d_validate);
 EXPORT_SYMBOL(dget_locked);
 EXPORT_SYMBOL(dput);
Index: kern_ci/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_export.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_export.c
@@ -215,7 +215,7 @@ xfs_fs_get_parent(
 	struct xfs_inode	*cip;
 	struct dentry		*parent;
 
-	error = xfs_lookup(XFS_I(child->d_inode), &xfs_name_dotdot, &cip);
+	error = xfs_lookup(XFS_I(child->d_inode), &xfs_name_dotdot, &cip, NULL);
 	if (unlikely(error))
 		return ERR_PTR(-error);
 
Index: kern_ci/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_iops.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_iops.c
@@ -389,7 +389,7 @@ xfs_vn_lookup(
 		return ERR_PTR(-ENAMETOOLONG);
 
 	xfs_dentry_to_name(&name, dentry);
-	error = xfs_lookup(XFS_I(dir), &name, &cip);
+	error = xfs_lookup(XFS_I(dir), &name, &cip, NULL);
 	if (unlikely(error)) {
 		if (unlikely(error != ENOENT))
 			return ERR_PTR(-error);
@@ -400,6 +400,46 @@ xfs_vn_lookup(
 	return d_splice_alias(cip->i_vnode, dentry);
 }
 
+STATIC struct dentry *
+xfs_vn_ci_lookup(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	struct nameidata *nd)
+{
+	struct xfs_inode *ip;
+	struct xfs_name	xname;
+	struct qstr	dname;
+	int		ci_match = 0;
+	int		error;
+
+	if (dentry->d_name.len >= MAXNAMELEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	xfs_dentry_to_name(&xname, dentry);
+	error = xfs_lookup(XFS_I(dir), &xname, &ip, &ci_match);
+	if (unlikely(error)) {
+		if (unlikely(error != ENOENT))
+			return ERR_PTR(-error);
+		/*
+		 * don't d_add dentry, __link_path_walk will dput the
+		 * dentry if its inode is NULL which means the negative
+		 * dentry will be destroyed rather than kept around.
+		 */
+		return NULL;
+	}
+
+	/* if exact match, just splice and exit */
+	if (!ci_match)
+		return d_splice_alias(ip->i_vnode, dentry);
+
+	/* else case-insensitive match... */
+	dname.name = xname.name;
+	dname.len = xname.len;
+	dentry = d_add_ci(ip->i_vnode, dentry, &dname);
+	kmem_free(xname.name, xname.len);
+	return dentry;
+}
+
 STATIC int
 xfs_vn_link(
 	struct dentry	*old_dentry,
@@ -911,6 +951,25 @@ const struct inode_operations xfs_dir_in
 	.removexattr		= xfs_vn_removexattr,
 };
 
+const struct inode_operations xfs_dir_ci_inode_operations = {
+	.create			= xfs_vn_create,
+	.lookup			= xfs_vn_ci_lookup,
+	.link			= xfs_vn_link,
+	.unlink			= xfs_vn_unlink,
+	.symlink		= xfs_vn_symlink,
+	.mkdir			= xfs_vn_mkdir,
+	.rmdir			= xfs_vn_rmdir,
+	.mknod			= xfs_vn_mknod,
+	.rename			= xfs_vn_rename,
+	.permission		= xfs_vn_permission,
+	.getattr		= xfs_vn_getattr,
+	.setattr		= xfs_vn_setattr,
+	.setxattr		= xfs_vn_setxattr,
+	.getxattr		= xfs_vn_getxattr,
+	.listxattr		= xfs_vn_listxattr,
+	.removexattr		= xfs_vn_removexattr,
+};
+
 const struct inode_operations xfs_symlink_inode_operations = {
 	.readlink		= generic_readlink,
 	.follow_link		= xfs_vn_follow_link,
Index: kern_ci/fs/xfs/linux-2.6/xfs_iops.h
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_iops.h
+++ kern_ci/fs/xfs/linux-2.6/xfs_iops.h
@@ -20,6 +20,7 @@
 
 extern const struct inode_operations xfs_inode_operations;
 extern const struct inode_operations xfs_dir_inode_operations;
+extern const struct inode_operations xfs_dir_ci_inode_operations;
 extern const struct inode_operations xfs_symlink_inode_operations;
 
 extern const struct file_operations xfs_file_operations;
Index: kern_ci/fs/xfs/xfs_da_btree.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_da_btree.h
+++ kern_ci/fs/xfs/xfs_da_btree.h
@@ -143,6 +143,7 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_RENAME	0x0002	/* this is an atomic rename op */
 #define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
+#define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
 
 static inline int xfs_da_isjustcheck_op(struct xfs_da_args *args)
 {
@@ -164,6 +165,11 @@ static inline int xfs_da_isoknoent_op(st
 	return args->op_flags & XFS_DA_OP_OKNOENT;
 }
 
+static inline int xfs_da_iscilookup_op(struct xfs_da_args *args)
+{
+	return args->op_flags & XFS_DA_OP_CILOOKUP;
+}
+
 /*
  * Structure to describe buffer(s) for a block.
  * This is needed in the directory version 2 format case, when
Index: kern_ci/fs/xfs/xfs_dir2.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.c
+++ kern_ci/fs/xfs/xfs_dir2.c
@@ -193,14 +193,42 @@ xfs_dir_createname(
 }
 
 /*
+ * If doing a CI lookup and case-insensitive match, dup actual name into
+ * args.value. Return EEXIST for success (ie. name found) or an error.
+ */
+int
+xfs_dir_cilookup_result(
+	struct xfs_da_args *args,
+	const char	*name,
+	int		len)
+{
+	if (args->cmpresult == XFS_CMP_DIFFERENT)
+		return ENOENT;
+	if (args->cmpresult != XFS_CMP_CASE || !xfs_da_iscilookup_op(args))
+		return EEXIST;
+
+	args->value = kmem_alloc(len, KM_MAYFAIL);
+	if (!args->value)
+		return ENOMEM;
+
+	memcpy(args->value, name, len);
+	args->valuelen = len;
+	return EEXIST;
+}
+
+/*
  * Lookup a name in a directory, give back the inode number.
+ * If ci_match is not NULL, sets whether a CI match occurred of not, and
+ * if so, return the actual name in name.
  */
+
 int
 xfs_dir_lookup(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*dp,
 	struct xfs_name	*name,
-	xfs_ino_t	*inum)		/* out: inode number */
+	xfs_ino_t	*inum,		/* out: inode number */
+	int		*ci_match)	/* out: CI match occurred */
 {
 	xfs_da_args_t	args;
 	int		rval;
@@ -217,6 +245,8 @@ xfs_dir_lookup(
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
 	args.op_flags = XFS_DA_OP_OKNOENT;
+	if (ci_match)
+		args.op_flags |= XFS_DA_OP_CILOOKUP;
 	args.cmpresult = XFS_CMP_DIFFERENT;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
@@ -233,8 +263,14 @@ xfs_dir_lookup(
 		rval = xfs_dir2_node_lookup(&args);
 	if (rval == EEXIST)
 		rval = 0;
-	if (rval == 0)
+	if (!rval) {
 		*inum = args.inumber;
+		if (ci_match) {
+			*ci_match = args.cmpresult == XFS_CMP_CASE;
+			name->name = args.value;
+			name->len = args.valuelen;
+		}
+	}
 	return rval;
 }
 
Index: kern_ci/fs/xfs/xfs_dir2.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.h
+++ kern_ci/fs/xfs/xfs_dir2.h
@@ -74,7 +74,8 @@ extern int xfs_dir_createname(struct xfs
 				xfs_fsblock_t *first,
 				struct xfs_bmap_free *flist, xfs_extlen_t tot);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t *inum);
+				struct xfs_name *name, xfs_ino_t *inum,
+				int *ci_match);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_fsblock_t *first,
@@ -99,4 +100,7 @@ extern int xfs_dir2_isleaf(struct xfs_tr
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_dabuf *bp);
 
+extern int xfs_dir_cilookup_result(struct xfs_da_args *args, const char *name,
+				int len);
+
 #endif	/* __XFS_DIR2_H__ */
Index: kern_ci/fs/xfs/xfs_dir2_block.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_block.c
+++ kern_ci/fs/xfs/xfs_dir2_block.c
@@ -610,14 +610,15 @@ xfs_dir2_block_lookup(
 	/*
 	 * Get the offset from the leaf entry, to point to the data.
 	 */
-	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)block + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
+	dep = (xfs_dir2_data_entry_t *)((char *)block +
+		xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
 	/*
-	 * Fill in inode number, release the block.
+	 * Fill in inode number, CI name if appropriate, release the block.
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
+	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	xfs_da_brelse(args->trans, bp);
-	return XFS_ERROR(EEXIST);
+	return XFS_ERROR(error);
 }
 
 /*
Index: kern_ci/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_leaf.c
+++ kern_ci/fs/xfs/xfs_dir2_leaf.c
@@ -1298,12 +1298,13 @@ xfs_dir2_leaf_lookup(
 	      ((char *)dbp->data +
 	       xfs_dir2_dataptr_to_off(dp->i_mount, be32_to_cpu(lep->address)));
 	/*
-	 * Return the found inode number.
+	 * Return the found inode number & CI name if appropriate
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
+	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	xfs_da_brelse(tp, dbp);
 	xfs_da_brelse(tp, lbp);
-	return XFS_ERROR(EEXIST);
+	return XFS_ERROR(error);
 }
 
 /*
Index: kern_ci/fs/xfs/xfs_dir2_node.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_node.c
+++ kern_ci/fs/xfs/xfs_dir2_node.c
@@ -549,7 +549,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	xfs_dir2_data_entry_t	*dep;		/* data block entry */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return value */
-	int			di;		/* data entry index */
+	int			di = -1;	/* data entry index */
 	int			index;		/* leaf entry index */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
@@ -577,6 +577,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	if (state->extravalid) {
 		curbp = state->extrablk.bp;
 		curdb = state->extrablk.blkno;
+		di = state->extrablk.index;
 	}
 	/*
 	 * Loop over leaf entries with the right hash value.
@@ -637,7 +638,6 @@ xfs_dir2_leafn_lookup_for_entry(
 	}
 	/* Didn't find an exact match. */
 	error = ENOENT;
-	di = -1;
 	ASSERT(index == be16_to_cpu(leaf->hdr.count) ||
 					xfs_da_isoknoent_op(args));
 out:
@@ -652,7 +652,7 @@ out:
 		state->extravalid = 0;
 	}
 	/*
-	 * Return the index, that will be the insertion point.
+	 * Return the index, that will be the deletion point for remove/replace.
 	 */
 	*indexp = index;
 	return XFS_ERROR(error);
@@ -1819,8 +1819,14 @@ xfs_dir2_node_lookup(
 	error = xfs_da_node_lookup_int(state, &rval);
 	if (error)
 		rval = error;
-	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE)
-		rval = EEXIST;	/* a case-insensitive match was found */
+	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE) {
+		/* If a CI match, dup the actual name and return EEXIST */
+		xfs_dir2_data_entry_t	*dep;
+
+		dep = (xfs_dir2_data_entry_t *)((char *)state->extrablk.bp->
+						data + state->extrablk.index);
+		rval = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
+	}
 	/*
 	 * Release the btree blocks and leaf block.
 	 */
Index: kern_ci/fs/xfs/xfs_dir2_sf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_sf.c
+++ kern_ci/fs/xfs/xfs_dir2_sf.c
@@ -815,6 +815,7 @@ xfs_dir2_sf_lookup(
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
 	enum xfs_dacmp		cmp;		/* comparison result */
+	xfs_dir2_sf_entry_t	*ci_sfep;	/* case-insens. entry */
 
 	xfs_dir2_trace_args("sf_lookup", args);
 	xfs_dir2_sf_check(args);
@@ -852,6 +853,7 @@ xfs_dir2_sf_lookup(
 	/*
 	 * Loop over all the entries trying to match ours.
 	 */
+	ci_sfep = NULL;
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->hdr.count;
 				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
 		/*
@@ -867,15 +869,13 @@ xfs_dir2_sf_lookup(
 						xfs_dir2_sf_inumberp(sfep));
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
+			ci_sfep = sfep;
 		}
 	}
 	ASSERT(xfs_da_isoknoent_op(args));
-	/*
-	 * Here, we can only be doing a lookup (not a rename or replace).
-	 * If a case-insensitive match was found earlier, return "found".
-	 */
-	if (args->cmpresult == XFS_CMP_CASE)
-		return XFS_ERROR(EEXIST);
+	if (ci_sfep)
+		return XFS_ERROR(xfs_dir_cilookup_result(args,
+					ci_sfep->name, ci_sfep->namelen));
 	/*
 	 * Didn't find it.
 	 */
Index: kern_ci/fs/xfs/xfs_vnodeops.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_vnodeops.c
+++ kern_ci/fs/xfs/xfs_vnodeops.c
@@ -1629,12 +1629,19 @@ xfs_inactive(
 	return VN_INACTIVE_CACHE;
 }
 
-
+/*
+ * Lookups up an inode from "name". If ci_match is not NULL, then name->name
+ * will be replaced. If a CI match is found, name->name will point to a the
+ * actual name (caller must free) and ci_match is set to 1.
+ * The caller of xfs_lookup must call xfs_name_free(name->name) if
+ * ci_match in non-NULL. If no CI match is found, name->name will be NULL.
+ */
 int
 xfs_lookup(
 	xfs_inode_t		*dp,
 	struct xfs_name		*name,
-	xfs_inode_t		**ipp)
+	xfs_inode_t		**ipp,
+	int			*ci_match)
 {
 	xfs_ino_t		inum;
 	int			error;
@@ -1646,15 +1653,18 @@ xfs_lookup(
 		return XFS_ERROR(EIO);
 
 	lock_mode = xfs_ilock_map_shared(dp);
-	error = xfs_dir_lookup(NULL, dp, name, &inum);
+	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_match);
 	xfs_iunlock_map_shared(dp, lock_mode);
 
 	if (error)
 		goto out;
 
 	error = xfs_iget(dp->i_mount, NULL, inum, 0, 0, ipp, 0);
-	if (error)
+	if (error) {
+		if (ci_match && *ci_match)
+			kmem_free(name->name, name->len);
 		goto out;
+	}
 
 	xfs_itrace_ref(*ipp);
 	return 0;
Index: kern_ci/fs/xfs/xfs_vnodeops.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_vnodeops.h
+++ kern_ci/fs/xfs/xfs_vnodeops.h
@@ -23,7 +23,7 @@ int xfs_fsync(struct xfs_inode *ip, int 
 int xfs_release(struct xfs_inode *ip);
 int xfs_inactive(struct xfs_inode *ip);
 int xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
-		struct xfs_inode **ipp);
+		struct xfs_inode **ipp, int *ci_match);
 int xfs_create(struct xfs_inode *dp, struct xfs_name *name, mode_t mode,
 		xfs_dev_t rdev, struct xfs_inode **ipp, struct cred *credp);
 int xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
Index: kern_ci/include/linux/dcache.h
===================================================================
--- kern_ci.orig/include/linux/dcache.h
+++ kern_ci/include/linux/dcache.h
@@ -231,6 +231,7 @@ extern void d_delete(struct dentry *);
 extern struct dentry * d_alloc(struct dentry *, const struct qstr *);
 extern struct dentry * d_alloc_anon(struct inode *);
 extern struct dentry * d_splice_alias(struct inode *, struct dentry *);
+extern struct dentry * d_add_ci(struct inode *, struct dentry *, struct qstr *);
 extern void shrink_dcache_sb(struct super_block *);
 extern void shrink_dcache_parent(struct dentry *);
 extern void shrink_dcache_for_umount(struct super_block *);

-- 
