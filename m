Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 01:36:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L8a5Ck025352
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 01:36:08 -0700
Message-Id: <20080421083644.809426871@chook.melbourne.sgi.com>
References: <20080421083103.433280025@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 18:31:05 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 2/4] XFS: Return case-insensitive match for dentry cache
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

Signed-off-by: Barry Naujok <bnaujok@sgi.com>

---
 fs/xfs/linux-2.6/xfs_export.c |    2 
 fs/xfs/linux-2.6/xfs_iops.c   |  156 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/linux-2.6/xfs_iops.h   |    1 
 fs/xfs/xfs_dir2.c             |   24 +++++-
 fs/xfs/xfs_dir2.h             |   32 ++++++++
 fs/xfs/xfs_dir2_block.c       |   11 ++
 fs/xfs/xfs_dir2_leaf.c        |    7 +
 fs/xfs/xfs_dir2_node.c        |   21 ++++-
 fs/xfs/xfs_dir2_sf.c          |    7 +
 fs/xfs/xfs_vfsops.c           |    2 
 fs/xfs/xfs_vnodeops.c         |   17 +++-
 fs/xfs/xfs_vnodeops.h         |    2 
 12 files changed, 264 insertions(+), 18 deletions(-)

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
@@ -2,6 +2,8 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  *
+ * Portions Copyright (c) 2001-2006 Anton Altaparmakov
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -389,7 +391,7 @@ xfs_vn_lookup(
 		return ERR_PTR(-ENAMETOOLONG);
 
 	xfs_dentry_to_name(&name, dentry);
-	error = xfs_lookup(XFS_I(dir), &name, &cip);
+	error = xfs_lookup(XFS_I(dir), &name, &cip, NULL);
 	if (unlikely(error)) {
 		if (unlikely(error != ENOENT))
 			return ERR_PTR(-error);
@@ -400,6 +402,139 @@ xfs_vn_lookup(
 	return d_splice_alias(cip->i_vnode, dentry);
 }
 
+STATIC struct dentry *
+xfs_ci_dentry_update(
+	struct dentry	*dent,
+	struct inode	*dent_inode,
+	struct xfs_name	*name)
+{
+	int		err;
+	struct dentry	*real_dent;
+	struct dentry	*new_dent;
+	struct qstr	nls_name;
+
+	nls_name.name = name->name;
+	nls_name.len = name->len;
+
+	/*
+	 * following code from ntfs_lookup() in fs/ntfs/namei.c
+	 */
+
+	nls_name.hash = full_name_hash(nls_name.name, nls_name.len);
+
+	/* Does a dentry matching the nls_name exist already? */
+	real_dent = d_lookup(dent->d_parent, &nls_name);
+	/* If not, create it now. */
+	if (!real_dent) {
+		real_dent = d_alloc(dent->d_parent, &nls_name);
+		if (!real_dent) {
+			err = -ENOMEM;
+			goto err_out;
+		}
+		new_dent = d_splice_alias(dent_inode, real_dent);
+		if (new_dent)
+			dput(real_dent);
+		else
+			new_dent = real_dent;
+		return new_dent;
+	}
+	/* Matching dentry exists, check if it is negative. */
+	if (real_dent->d_inode) {
+		if (unlikely(real_dent->d_inode != dent_inode)) {
+			/* This can happen because bad inodes are unhashed. */
+			BUG_ON(!is_bad_inode(dent_inode));
+			BUG_ON(!is_bad_inode(real_dent->d_inode));
+		}
+		/*
+		 * Already have the inode and the dentry attached, decrement
+		 * the reference count to balance the xfs_lookup() we did
+		 * earlier on.  We found the dentry using d_lookup() so it
+		 * cannot be disconnected and thus we do not need to worry
+		 * about any NFS/disconnectedness issues here.
+		 */
+		iput(dent_inode);
+		return real_dent;
+	}
+	/*
+	 * Negative dentry: instantiate it unless the inode is a directory and
+	 * has a 'disconnected' dentry (i.e. IS_ROOT and DCACHE_DISCONNECTED),
+	 * in which case d_move() that in place of the found dentry.
+	 */
+	if (!S_ISDIR(dent_inode->i_mode)) {
+		/* Not a directory; everything is easy. */
+		d_instantiate(real_dent, dent_inode);
+		return real_dent;
+	}
+	spin_lock(&dcache_lock);
+	if (list_empty(&dent_inode->i_dentry)) {
+		/*
+		 * Directory without a 'disconnected' dentry; we need to do
+		 * d_instantiate() by hand because it takes dcache_lock which
+		 * we already hold.
+		 */
+		list_add(&real_dent->d_alias, &dent_inode->i_dentry);
+		real_dent->d_inode = dent_inode;
+		spin_unlock(&dcache_lock);
+		security_d_instantiate(real_dent, dent_inode);
+		return real_dent;
+	}
+	/*
+	 * Directory with a 'disconnected' dentry; get a reference to the
+	 * 'disconnected' dentry.
+	 */
+	new_dent = list_entry(dent_inode->i_dentry.next, struct dentry,
+			d_alias);
+	dget_locked(new_dent);
+	spin_unlock(&dcache_lock);
+	/* Do security vodoo. */
+	security_d_instantiate(real_dent, dent_inode);
+	/* Move new_dent in place of real_dent. */
+	d_move(new_dent, real_dent);
+	/* Balance the xfs_lookup() we did above. */
+	iput(dent_inode);
+	/* Throw away real_dent. */
+	dput(real_dent);
+	/* Use new_dent as the actual dentry. */
+	return new_dent;
+
+err_out:
+	iput(dent_inode);
+	return ERR_PTR(err);
+}
+
+STATIC struct dentry *
+xfs_vn_ci_lookup(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	struct nameidata *nd)
+{
+	struct xfs_inode *ip;
+	struct xfs_name	name;
+	int		ci_match = 0;
+	int		error;
+
+	if (dentry->d_name.len >= MAXNAMELEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	xfs_dentry_to_name(&name, dentry);
+	error = xfs_lookup(XFS_I(dir), &name, &ip, &ci_match);
+	if (unlikely(error)) {
+		if (unlikely(error != ENOENT))
+			return ERR_PTR(-error);
+		d_add(dentry, NULL);
+		return NULL;
+	}
+
+	/* if exact match, just splice and exit */
+	if (!ci_match)
+		return d_splice_alias(ip->i_vnode, dentry);
+
+	/* else case-insensitive match... */
+	dentry = xfs_ci_dentry_update(dentry, ip->i_vnode, &name);
+	xfs_name_free(name.name);
+	return dentry;
+}
+
 STATIC int
 xfs_vn_link(
 	struct dentry	*old_dentry,
@@ -911,6 +1046,25 @@ const struct inode_operations xfs_dir_in
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
Index: kern_ci/fs/xfs/xfs_dir2.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.c
+++ kern_ci/fs/xfs/xfs_dir2.c
@@ -46,6 +46,8 @@
 
 struct xfs_name xfs_name_dotdot = {"..", 2};
 
+kmem_zone_t	*xfs_name_zone;
+
 extern const struct xfs_nameops xfs_default_nameops;
 
 void
@@ -195,13 +197,16 @@ xfs_dir_createname(
 
 /*
  * Lookup a name in a directory, give back the inode number.
+ * If ci_match is not NULL, sets whether a CI match occurred of not, and
+ * if so, return the actual name in name.
  */
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
@@ -234,8 +239,23 @@ xfs_dir_lookup(
 		rval = xfs_dir2_node_lookup(&args);
 	if (rval == EEXIST)
 		rval = 0;
-	if (rval == 0)
+	if (!rval) {
 		*inum = args.inumber;
+		if (ci_match) {
+			*ci_match = args.cmpresult == XFS_CMP_CASE;
+			if (*ci_match) {
+				if (!args.value)
+					return ENOMEM;
+				name->name = args.value;
+				name->len = args.valuelen;
+			} else {
+				ASSERT(args.value == NULL);
+			}
+		} else {
+			if (args.value)
+				xfs_name_free(args.value);
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
@@ -99,4 +100,33 @@ extern int xfs_dir2_isleaf(struct xfs_tr
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_dabuf *bp);
 
+/*
+ * Name handling routines for directories and attrs
+ */
+
+extern struct kmem_zone *xfs_name_zone;
+
+static inline char *
+xfs_name_alloc(void)
+{
+	return kmem_zone_zalloc(xfs_name_zone, KM_MAYFAIL);
+}
+
+static inline void
+xfs_name_free(const char *name)
+{
+	kmem_zone_free(xfs_name_zone, (void *)name);
+}
+
+static inline char *
+xfs_name_dup(const char *src_name, int src_len, int *dest_len)
+{
+	char	*dest_name = xfs_name_alloc();
+	if (dest_name) {
+		memcpy(dest_name, src_name, src_len);
+		*dest_len = src_len;
+	}
+	return dest_name;
+}
+
 #endif	/* __XFS_DIR2_H__ */
Index: kern_ci/fs/xfs/xfs_dir2_block.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_block.c
+++ kern_ci/fs/xfs/xfs_dir2_block.c
@@ -610,12 +610,19 @@ xfs_dir2_block_lookup(
 	/*
 	 * Get the offset from the leaf entry, to point to the data.
 	 */
-	dep = (xfs_dir2_data_entry_t *)
-	      ((char *)block + xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
+	dep = (xfs_dir2_data_entry_t *)((char *)block +
+		xfs_dir2_dataptr_to_off(mp, be32_to_cpu(blp[ent].address)));
 	/*
 	 * Fill in inode number, release the block.
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
+	/*
+	 * If a case-insensitive match, allocate a buffer and copy the actual
+	 * name into the buffer. Return it via args->value.
+	 */
+	if (args->cmpresult == XFS_CMP_CASE)
+		args->value = xfs_name_dup(dep->name, dep->namelen,
+							&args->valuelen);
 	xfs_da_brelse(args->trans, bp);
 	return XFS_ERROR(EEXIST);
 }
Index: kern_ci/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_leaf.c
+++ kern_ci/fs/xfs/xfs_dir2_leaf.c
@@ -1301,6 +1301,13 @@ xfs_dir2_leaf_lookup(
 	 * Return the found inode number.
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
+	/*
+	 * If a case-insensitive match, allocate a buffer and copy the actual
+	 * name into the buffer. Return it via args->value.
+	 */
+	if (args->cmpresult == XFS_CMP_CASE)
+		args->value = xfs_name_dup(dep->name, dep->namelen,
+							&args->valuelen);
 	xfs_da_brelse(tp, dbp);
 	xfs_da_brelse(tp, lbp);
 	return XFS_ERROR(EEXIST);
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
@@ -638,7 +639,6 @@ xfs_dir2_leafn_lookup_for_entry(
 	}
 	/* Didn't find an exact match. */
 	error = ENOENT;
-	di = -1;
 	ASSERT(index == be16_to_cpu(leaf->hdr.count) || args->oknoent);
 out:
 	if (curbp) {
@@ -652,7 +652,7 @@ out:
 		state->extravalid = 0;
 	}
 	/*
-	 * Return the index, that will be the insertion point.
+	 * Return the index, that will be the deletion point for remove/replace.
 	 */
 	*indexp = index;
 	return XFS_ERROR(error);
@@ -1819,8 +1819,19 @@ xfs_dir2_node_lookup(
 	error = xfs_da_node_lookup_int(state, &rval);
 	if (error)
 		rval = error;
-	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE)
-		rval = EEXIST;	/* a case-insensitive match was found */
+	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE) {
+		/*
+		 * A case-insensitive match was found: return the actual
+		 * name in args->value and return EEXIST
+		 */
+		xfs_dir2_data_entry_t	*dep;
+
+		dep = (xfs_dir2_data_entry_t *)((char *)state->extrablk.bp->
+						data + state->extrablk.index);
+		args->value = xfs_name_dup(dep->name, dep->namelen,
+							&args->valuelen);
+		rval = EEXIST;
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
 	xfs_dacmp_t		cmp;		/* comparison result */
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
@@ -875,8 +877,11 @@ xfs_dir2_sf_lookup(
 	 * Here, we can only be doing a lookup (not a rename or replace).
 	 * If a case-insensitive match was found earlier, return "found".
 	 */
-	if (args->cmpresult == XFS_CMP_CASE)
+	if (args->cmpresult == XFS_CMP_CASE) {
+		args->value = xfs_name_dup(ci_sfep->name, ci_sfep->namelen,
+							&args->valuelen);
 		return XFS_ERROR(EEXIST);
+	}
 	/*
 	 * Didn't find it.
 	 */
Index: kern_ci/fs/xfs/xfs_vfsops.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_vfsops.c
+++ kern_ci/fs/xfs/xfs_vfsops.c
@@ -80,6 +80,7 @@ xfs_init(void)
 	xfs_dabuf_zone = kmem_zone_init(sizeof(xfs_dabuf_t), "xfs_dabuf");
 	xfs_ifork_zone = kmem_zone_init(sizeof(xfs_ifork_t), "xfs_ifork");
 	xfs_trans_zone = kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");
+	xfs_name_zone = kmem_zone_init(MAXNAMELEN, "xfs_name");
 	xfs_acl_zone_init(xfs_acl_zone, "xfs_acl");
 	xfs_mru_cache_init();
 	xfs_filestream_init();
@@ -179,6 +180,7 @@ xfs_cleanup(void)
 	kmem_zone_destroy(xfs_btree_cur_zone);
 	kmem_zone_destroy(xfs_inode_zone);
 	kmem_zone_destroy(xfs_trans_zone);
+	kmem_zone_destroy(xfs_name_zone);
 	kmem_zone_destroy(xfs_da_state_zone);
 	kmem_zone_destroy(xfs_dabuf_zone);
 	kmem_zone_destroy(xfs_buf_item_zone);
Index: kern_ci/fs/xfs/xfs_vnodeops.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_vnodeops.c
+++ kern_ci/fs/xfs/xfs_vnodeops.c
@@ -1629,12 +1629,18 @@ xfs_inactive(
 	return VN_INACTIVE_CACHE;
 }
 
-
+/*
+ * Lookups up an inode from "name". If ci_match is not NULL, then if a
+ * CI match is found, name->name can be replaced and ci_match is set to 1.
+ * The caller of xfs_lookup must call xfs_name_free(name->name) if
+ * ci_match in non-NULL and the value is non-zero.
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
@@ -1646,15 +1652,18 @@ xfs_lookup(
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
+			xfs_name_free(name->name);
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

-- 
