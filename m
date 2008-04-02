Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 23:27:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m326QYao006084
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 23:26:36 -0700
Message-Id: <20080402062708.654277049@chook.melbourne.sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com>
Date: Wed, 02 Apr 2008 16:25:12 +1000
From: Barry Naujok <bnaujok@sgi.com>
Subject: [PATCH 4/7] XFS: Return case-insensitive match for dentry cache
Content-Disposition: inline; filename=return_name.patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

This implements the code to store the actual filename found
during a lookup in the dentry cache and to avoid multiple entries
in the dcache pointing to the same inode.

It also introduces a new type, xfs_name, which is similar to the
dentry cache's qstr type. It contains a pointer to a zone allocated
string (MAXNAMELEN sized) and the length of the actual name. This
string does not need to be NULL terminated (a counted string).

xfs_name_t is only used in the lookup path for this patch, but may
be used in other locations too if desired. It maybe desirable not
to use xfs_name_t at all in the lookup functions but stick to
separate parameters (which will mean 7 instead of 5 arguments).

To avoid polluting the dcache, we implement a new directory inode
operations for lookup. xfs_vn_ci_lookup() interacts directly with
the dcache and the code was derived from ntfs_lookup() in
fs/ntfs/namei.c. The dentry hash and compare overrides introduced
in the ASCII-CI patch has been removed.

The "actual name" is only allocated and returned for a case-
insensitive match and not an actual match.

Signed-off-by: Barry Naujok <bnaujok@sgi.com>

---
 fs/xfs/linux-2.6/xfs_export.c |    2 
 fs/xfs/linux-2.6/xfs_iops.c   |  165 +++++++++++++++++++++++++++++++-----------
 fs/xfs/linux-2.6/xfs_iops.h   |    1 
 fs/xfs/linux-2.6/xfs_super.c  |    5 +
 fs/xfs/linux-2.6/xfs_vnode.h  |    1 
 fs/xfs/xfs_da_btree.c         |   16 ++++
 fs/xfs/xfs_da_btree.h         |   13 +++
 fs/xfs/xfs_dir2.c             |   28 +++++--
 fs/xfs/xfs_dir2.h             |    4 -
 fs/xfs/xfs_dir2_block.c       |    9 ++
 fs/xfs/xfs_dir2_leaf.c        |    9 ++
 fs/xfs/xfs_dir2_node.c        |   20 ++++-
 fs/xfs/xfs_dir2_sf.c          |   13 +++
 fs/xfs/xfs_rename.c           |    5 +
 fs/xfs/xfs_utils.c            |   12 ++-
 fs/xfs/xfs_utils.h            |    6 +
 fs/xfs/xfs_vfsops.c           |    2 
 fs/xfs/xfs_vnodeops.c         |   15 +++
 fs/xfs/xfs_vnodeops.h         |    4 -
 19 files changed, 264 insertions(+), 66 deletions(-)

Index: kern_ci/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_export.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_export.c
@@ -216,7 +216,7 @@ xfs_fs_get_parent(
 	struct xfs_inode	*cip;
 	struct dentry		*parent;
 
-	error = xfs_lookup(XFS_I(child->d_inode), &dotdot, &cip);
+	error = xfs_lookup(XFS_I(child->d_inode), &dotdot.d_name, &cip, NULL);
 	if (unlikely(error))
 		return ERR_PTR(-error);
 
Index: kern_ci/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_iops.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_iops.c
@@ -375,27 +375,125 @@ xfs_vn_lookup(
 {
 	struct xfs_inode *cip;
 	int		error;
-	struct xfs_mount *mp = XFS_I(dir)->i_mount;
+
+	if (dentry->d_name.len >= MAXNAMELEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	error = xfs_lookup(XFS_I(dir), &dentry->d_name, &cip, NULL);
+	if (unlikely(error)) {
+		if (unlikely(error != ENOENT))
+			return ERR_PTR(-error);
+		d_add(dentry, NULL);
+		return NULL;
+	}
+
+	return d_splice_alias(cip->i_vnode, dentry);
+}
+
+STATIC struct dentry *
+xfs_vn_ci_lookup(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	struct nameidata *nd)
+{
+	struct xfs_inode *cip;
+	int		error;
 	struct dentry	*result;
+	struct qstr	ci_name = {0, 0, NULL};
+	struct inode	*inode;
 
 	if (dentry->d_name.len >= MAXNAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	if (xfs_sb_version_hasoldci(&mp->m_sb))
-		dentry->d_op = &xfs_ci_dentry_operations;
+	error = xfs_lookup(XFS_I(dir), &dentry->d_name, &cip, &ci_name);
 
-	error = xfs_lookup(XFS_I(dir), dentry, &cip);
 	if (unlikely(error)) {
 		if (unlikely(error != ENOENT))
 			return ERR_PTR(-error);
 		d_add(dentry, NULL);
 		return NULL;
 	}
+	inode = cip->i_vnode;
+
+	/* if exact match, just splice and exit */
+	if (!ci_name.name) {
+		result = d_splice_alias(inode, dentry);
+		return result;
+	}
 
-	result = d_splice_alias(cip->i_vnode, dentry);
-	if (result)
-		result->d_op = dentry->d_op;
-	return result;
+	/*
+	 * case-insensitive match, create a dentry to return and fill it
+	 * in with the correctly cased name. Parameter "dentry" is not
+	 * used anymore and the caller will free it.
+	 * Derived from fs/ntfs/namei.c
+	 */
+
+	ci_name.hash = full_name_hash(ci_name.name, ci_name.len);
+
+	/* Does an existing dentry match? */
+	result = d_lookup(dentry->d_parent, &ci_name);
+	if (!result) {
+		/* if not, create one */
+		result = d_alloc(dentry->d_parent, &ci_name);
+		xfs_da_name_free((char *)ci_name.name);
+		if (!result)
+			return ERR_PTR(-ENOMEM);
+		dentry = d_splice_alias(inode, result);
+		if (dentry) {
+			dput(result);
+			return dentry;
+		}
+		return result;
+	}
+	xfs_da_name_free((char *)ci_name.name);
+
+	/* an existing dentry matches, use it */
+
+	if (result->d_inode) {
+		/*
+		 * already an inode attached, deref the inode that was
+		 * refcounted with xfs_lookup and return the dentry.
+		 */
+		if (unlikely(result->d_inode != inode)) {
+			/* This can happen because bad inodes are unhashed. */
+			BUG_ON(!is_bad_inode(inode));
+			BUG_ON(!is_bad_inode(result->d_inode));
+		}
+		iput(inode);
+		return result;
+	}
+
+	if (!S_ISDIR(inode->i_mode)) {
+		/* not a directory, easy to handle */
+		d_instantiate(result, inode);
+		return result;
+	}
+
+	spin_lock(&dcache_lock);
+	if (list_empty(&inode->i_dentry)) {
+		/*
+		 * Directory without a 'disconnected' dentry; we need to do
+		 * d_instantiate() by hand because it takes dcache_lock which
+		 * we already hold.
+		 */
+		list_add(&result->d_alias, &inode->i_dentry);
+		result->d_inode = inode;
+		spin_unlock(&dcache_lock);
+		security_d_instantiate(result, inode);
+		return result;
+	}
+	/*
+	 * Directory with a 'disconnected' dentry; get a reference to the
+	 * 'disconnected' dentry.
+	 */
+	dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
+	dget_locked(dentry);
+	spin_unlock(&dcache_lock);
+	security_d_instantiate(result, inode);
+	d_move(dentry, result);
+	iput(inode);
+	dput(result);
+	return dentry;
 }
 
 STATIC int
@@ -886,6 +984,25 @@ const struct inode_operations xfs_dir_in
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
@@ -899,35 +1016,3 @@ const struct inode_operations xfs_symlin
 	.removexattr		= xfs_vn_removexattr,
 };
 
-STATIC int
-xfs_ci_dentry_hash(
-	struct dentry	*dir,
-	struct qstr	*this)
-{
-	this->hash = xfs_dir_hashname(XFS_I(dir->d_inode),
-				this->name, this->len);
-	return 0;
-}
-
-STATIC int
-xfs_ci_dentry_compare(
-	struct dentry	*dir,
-	struct qstr	*a,
-	struct qstr	*b)
-{
-	int	result = xfs_dir_compname(XFS_I(dir->d_inode), a->name, a->len,
-					b->name, b->len) == XFS_CMP_DIFFERENT;
-	/*
-	 * result == 0 if a match is found, and if so, copy the name in "b"
-	 * to "a" to cope with negative dentries getting the correct name.
-	 */
-	if (result == 0)
-		memcpy((unsigned char *)a->name, b->name, a->len);
-	return result;
-}
-
-struct dentry_operations xfs_ci_dentry_operations =
-{
-	.d_hash = xfs_ci_dentry_hash,
-	.d_compare = xfs_ci_dentry_compare,
-};
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
Index: kern_ci/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_super.c
+++ kern_ci/fs/xfs/linux-2.6/xfs_super.c
@@ -566,7 +566,10 @@ xfs_set_inodeops(
 		inode->i_mapping->a_ops = &xfs_address_space_operations;
 		break;
 	case S_IFDIR:
-		inode->i_op = &xfs_dir_inode_operations;
+		inode->i_op =
+			xfs_sb_version_hasoldci(&XFS_I(inode)->i_mount->m_sb) ?
+				&xfs_dir_ci_inode_operations :
+				&xfs_dir_inode_operations;
 		inode->i_fop = &xfs_dir_file_operations;
 		break;
 	case S_IFLNK:
Index: kern_ci/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- kern_ci.orig/fs/xfs/linux-2.6/xfs_vnode.h
+++ kern_ci/fs/xfs/linux-2.6/xfs_vnode.h
@@ -26,6 +26,7 @@ struct attrlist_cursor_kern;
 typedef struct dentry	bhv_vname_t;
 typedef __u64		bhv_vnumber_t;
 typedef struct inode	bhv_vnode_t;
+typedef struct qstr	bhv_vstr_t;
 
 #define VN_ISLNK(vp)	S_ISLNK((vp)->i_mode)
 #define VN_ISREG(vp)	S_ISREG((vp)->i_mode)
Index: kern_ci/fs/xfs/xfs_da_btree.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_da_btree.c
+++ kern_ci/fs/xfs/xfs_da_btree.c
@@ -2176,6 +2176,22 @@ xfs_da_reada_buf(
 		return rval;
 }
 
+
+kmem_zone_t	*xfs_da_name_zone;
+
+uchar_t *
+xfs_da_name_alloc(void)
+{
+	return kmem_zone_zalloc(xfs_da_name_zone, KM_SLEEP);
+}
+
+void
+xfs_da_name_free(const uchar_t *name)
+{
+	kmem_zone_free(xfs_da_name_zone, (void *)name);
+}
+
+
 kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
 kmem_zone_t *xfs_dabuf_zone;		/* dabuf zone */
 
Index: kern_ci/fs/xfs/xfs_da_btree.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_da_btree.h
+++ kern_ci/fs/xfs/xfs_da_btree.h
@@ -224,6 +224,14 @@ typedef struct xfs_nameops {
 	xfs_compname_t		compname;
 } xfs_nameops_t;
 
+/*
+ * Counted string for names, *name should be allocated and freed with
+ * xfs_da_name_alloc and xfs_da_name_free. len must not exceed MAXNAMELEN.
+ */
+typedef struct xfs_name {
+	const uchar_t	*name;
+	int		len;
+} xfs_name_t;
 
 #ifdef __KERNEL__
 /*========================================================================
@@ -277,6 +285,11 @@ uint xfs_da_hashname(const uchar_t *name
 xfs_dacmp_t xfs_da_compname(const uchar_t *name1, int len1,
 			    const uchar_t *name2, int len2);
 
+/* returns/frees a MAXNAMELEN buffer from a zone */
+extern struct kmem_zone *xfs_da_name_zone;
+uchar_t *xfs_da_name_alloc(void);
+void xfs_da_name_free(const uchar_t *name);
+
 xfs_da_state_t *xfs_da_state_alloc(void);
 void xfs_da_state_free(xfs_da_state_t *state);
 
Index: kern_ci/fs/xfs/xfs_dir2.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.c
+++ kern_ci/fs/xfs/xfs_dir2.c
@@ -242,15 +242,16 @@ xfs_dir_createname(
 }
 
 /*
- * Lookup a name in a directory, give back the inode number.
+ * Lookup a name in a directory, give back the inode number and also
+ * the actual name if a case-insensitive match.
  */
 int
 xfs_dir_lookup(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*dp,
-	char		*name,
-	int		namelen,
-	xfs_ino_t	*inum)		/* out: inode number */
+	xfs_name_t	*name,
+	xfs_ino_t	*inum,		/* out: inode number */
+	xfs_name_t	*ci_name)	/* out: actual name if different */
 {
 	xfs_da_args_t	args;
 	int		rval;
@@ -259,9 +260,9 @@ xfs_dir_lookup(
 	ASSERT((dp->i_d.di_mode & S_IFMT) == S_IFDIR);
 	XFS_STATS_INC(xs_dir_lookup);
 
-	args.name = name;
-	args.namelen = namelen;
-	args.hashval = xfs_dir_hashname(dp, name, namelen);
+	args.name = name->name;
+	args.namelen = name->len;
+	args.hashval = xfs_dir_hashname(dp, name->name, name->len);
 	args.inumber = 0;
 	args.dp = dp;
 	args.firstblock = NULL;
@@ -272,6 +273,8 @@ xfs_dir_lookup(
 	args.justcheck = args.addname = 0;
 	args.oknoent = 1;
 	args.cmpresult = XFS_CMP_DIFFERENT;
+	args.value = NULL;
+	args.valuelen = 0;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_lookup(&args);
@@ -287,8 +290,17 @@ xfs_dir_lookup(
 		rval = xfs_dir2_node_lookup(&args);
 	if (rval == EEXIST)
 		rval = 0;
-	if (rval == 0)
+	if (rval == 0) {
 		*inum = args.inumber;
+		if (args.value) {
+			ASSERT(args->cmpresult == XFS_CMP_CASE);
+			if (ci_name) {
+				ci_name->name = args.value;
+				ci_name->len = args.valuelen;
+			} else
+				xfs_da_name_free(args.value);
+		}
+	}
 	return rval;
 }
 
Index: kern_ci/fs/xfs/xfs_dir2.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2.h
+++ kern_ci/fs/xfs/xfs_dir2.h
@@ -26,6 +26,7 @@ struct xfs_bmap_free;
 struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_name;
 
 /*
  * Directory version 2.
@@ -72,7 +73,8 @@ extern int xfs_dir_createname(struct xfs
 				xfs_fsblock_t *first,
 				struct xfs_bmap_free *flist, xfs_extlen_t tot);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
-				char *name, int namelen, xfs_ino_t *inum);
+				struct xfs_name *name, xfs_ino_t *inum,
+				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				char *name, int namelen, xfs_ino_t ino,
 				xfs_fsblock_t *first,
Index: kern_ci/fs/xfs/xfs_dir2_block.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_block.c
+++ kern_ci/fs/xfs/xfs_dir2_block.c
@@ -616,6 +616,15 @@ xfs_dir2_block_lookup(
 	 * Fill in inode number, release the block.
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
+	/*
+	 * If a case-insensitive match, allocate a buffer and copy the actual
+	 * name into the buffer. Return it via args->value.
+	 */
+	if (args->cmpresult == XFS_CMP_CASE) {
+		args->value = xfs_da_name_alloc();
+		memcpy(args->value, dep->name, dep->namelen);
+		args->valuelen = dep->namelen;
+	}
 	xfs_da_brelse(args->trans, bp);
 	return XFS_ERROR(EEXIST);
 }
Index: kern_ci/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_leaf.c
+++ kern_ci/fs/xfs/xfs_dir2_leaf.c
@@ -1301,6 +1301,15 @@ xfs_dir2_leaf_lookup(
 	 * Return the found inode number.
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
+	/*
+	 * If a case-insensitive match, allocate a buffer and copy the actual
+	 * name into the buffer. Return it via args->value.
+	 */
+	if (args->cmpresult == XFS_CMP_CASE) {
+		args->value = xfs_da_name_alloc();
+		memcpy(args->value, dep->name, dep->namelen);
+		args->valuelen = dep->namelen;
+	}
 	xfs_da_brelse(tp, dbp);
 	xfs_da_brelse(tp, lbp);
 	return XFS_ERROR(EEXIST);
Index: kern_ci/fs/xfs/xfs_dir2_node.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_dir2_node.c
+++ kern_ci/fs/xfs/xfs_dir2_node.c
@@ -643,6 +643,8 @@ xfs_dir2_leafn_lookup_for_entry(
 			xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
 		/*
 		 * Compare the entry, return it if it matches.
+		 * "oknoent" is set for lookup and clear for
+		 * remove and replace.
 		 */
 		cmp = args->oknoent ?
 			xfs_dir_compname(dp, dep->name, dep->namelen,
@@ -1857,10 +1859,22 @@ xfs_dir2_node_lookup(
 	if (error)
 		rval = error;
 	/*
-	 * If case-insensitive match was found in a leaf, return EEXIST.
-	 */
-	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE)
+	 * If case-insensitive match was found (xfs_dir2_leafn_lookup_int
+	 * returns ENOENT for a case-insensitive match, but sets
+	 * args->cmpresult to XFS_CMP_CASE):
+	 *   - Allocate a buffer and copy the actual name into the buffer and
+	 *       return it via args->value.
+	 *   - set rval to EEXIST
+	 */
+	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE) {
+		xfs_dir2_data_entry_t	*dep = (xfs_dir2_data_entry_t *)
+					((char *)state->extrablk.bp->data +
+						state->extrablk.index);
+		args->value = xfs_da_name_alloc();
+		memcpy(args->value, dep->name, dep->namelen);
+		args->valuelen = dep->namelen;
 		rval = EEXIST;
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
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->hdr.count;
 	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
@@ -864,10 +866,19 @@ xfs_dir2_sf_lookup(
 					xfs_dir2_sf_inumberp(sfep));
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
+			ci_sfep = sfep;
 		}
 	}
-	if (args->cmpresult == XFS_CMP_CASE)
+	if (args->cmpresult == XFS_CMP_CASE) {
+		/*
+		 * If a case-insensitive match, allocate a buffer and copy the
+		 * actual name into the buffer and return it via args->value.
+		 */
+		args->value = xfs_da_name_alloc();
+		memcpy(args->value, ci_sfep->name, ci_sfep->namelen);
+		args->valuelen = ci_sfep->namelen;
 		return XFS_ERROR(EEXIST);
+	}
 	/*
 	 * Didn't find it.
 	 */
Index: kern_ci/fs/xfs/xfs_rename.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_rename.c
+++ kern_ci/fs/xfs/xfs_rename.c
@@ -100,6 +100,7 @@ xfs_lock_for_rename(
 	int			i, j;
 	uint			lock_mode;
 	int			diff_dirs = (dp1 != dp2);
+	xfs_name_t		name2;
 
 	ip2 = NULL;
 
@@ -125,7 +126,9 @@ xfs_lock_for_rename(
 		lock_mode = xfs_ilock_map_shared(dp2);
 	}
 
-	error = xfs_dir_lookup_int(dp2, lock_mode, vname2, &inum2, &ip2);
+	name2.name = VNAME(vname2);
+	name2.len = VNAMELEN(vname2);
+	error = xfs_dir_lookup_int(dp2, lock_mode, &name2, &inum2, &ip2, NULL);
 	if (error == ENOENT) {		/* target does not need to exist. */
 		inum2 = 0;
 	} else if (error) {
Index: kern_ci/fs/xfs/xfs_utils.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_utils.c
+++ kern_ci/fs/xfs/xfs_utils.c
@@ -24,6 +24,7 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
+#include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
@@ -45,15 +46,16 @@ int
 xfs_dir_lookup_int(
 	xfs_inode_t	*dp,
 	uint		lock_mode,
-	bhv_vname_t	*dentry,
+	xfs_name_t	*name,
 	xfs_ino_t	*inum,
-	xfs_inode_t	**ipp)
+	xfs_inode_t	**ipp,
+	xfs_name_t	*ci_name)
 {
 	int		error;
 
 	xfs_itrace_entry(dp);
 
-	error = xfs_dir_lookup(NULL, dp, VNAME(dentry), VNAMELEN(dentry), inum);
+	error = xfs_dir_lookup(NULL, dp, name, inum, ci_name);
 	if (!error) {
 		/*
 		 * Unlock the directory. We do this because we can't
@@ -80,6 +82,10 @@ xfs_dir_lookup_int(
 			xfs_ilock(dp, lock_mode);
 			error = XFS_ERROR(ENOENT);
 		}
+		if (error && ci_name && ci_name->name) {
+			xfs_da_name_free(ci_name->name);
+			ci_name->name = NULL;
+		}
 	}
 	return error;
 }
Index: kern_ci/fs/xfs/xfs_utils.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_utils.h
+++ kern_ci/fs/xfs/xfs_utils.h
@@ -18,11 +18,13 @@
 #ifndef __XFS_UTILS_H__
 #define __XFS_UTILS_H__
 
+struct xfs_name;
+
 #define IRELE(ip)	VN_RELE(XFS_ITOV(ip))
 #define IHOLD(ip)	VN_HOLD(XFS_ITOV(ip))
 
-extern int xfs_dir_lookup_int (xfs_inode_t *, uint, bhv_vname_t *, xfs_ino_t *,
-				xfs_inode_t **);
+extern int xfs_dir_lookup_int (xfs_inode_t *, uint, struct xfs_name *,
+				xfs_ino_t *, xfs_inode_t **, struct xfs_name *);
 extern int xfs_truncate_file (xfs_mount_t *, xfs_inode_t *);
 extern int xfs_dir_ialloc (xfs_trans_t **, xfs_inode_t *, mode_t, xfs_nlink_t,
 				xfs_dev_t, cred_t *, prid_t, int,
Index: kern_ci/fs/xfs/xfs_vfsops.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_vfsops.c
+++ kern_ci/fs/xfs/xfs_vfsops.c
@@ -74,6 +74,7 @@ xfs_init(void)
 	xfs_btree_cur_zone = kmem_zone_init(sizeof(xfs_btree_cur_t),
 					    "xfs_btree_cur");
 	xfs_trans_zone = kmem_zone_init(sizeof(xfs_trans_t), "xfs_trans");
+	xfs_da_name_zone = kmem_zone_init(MAXNAMELEN, "xfs_da_name");
 	xfs_da_state_zone =
 		kmem_zone_init(sizeof(xfs_da_state_t), "xfs_da_state");
 	xfs_dabuf_zone = kmem_zone_init(sizeof(xfs_dabuf_t), "xfs_dabuf");
@@ -177,6 +178,7 @@ xfs_cleanup(void)
 	kmem_zone_destroy(xfs_btree_cur_zone);
 	kmem_zone_destroy(xfs_inode_zone);
 	kmem_zone_destroy(xfs_trans_zone);
+	kmem_zone_destroy(xfs_da_name_zone);
 	kmem_zone_destroy(xfs_da_state_zone);
 	kmem_zone_destroy(xfs_dabuf_zone);
 	kmem_zone_destroy(xfs_buf_item_zone);
Index: kern_ci/fs/xfs/xfs_vnodeops.c
===================================================================
--- kern_ci.orig/fs/xfs/xfs_vnodeops.c
+++ kern_ci/fs/xfs/xfs_vnodeops.c
@@ -1762,24 +1762,33 @@ xfs_inactive(
 int
 xfs_lookup(
 	xfs_inode_t		*dp,
-	bhv_vname_t		*dentry,
-	xfs_inode_t		**ipp)
+	bhv_vstr_t		*d_name,
+	xfs_inode_t		**ipp,
+	bhv_vstr_t		*ci_name)
 {
 	xfs_inode_t		*ip;
 	xfs_ino_t		e_inum;
 	int			error;
 	uint			lock_mode;
+	xfs_name_t		name, rname;
 
 	xfs_itrace_entry(dp);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return XFS_ERROR(EIO);
 
+	name.name = (uchar_t *)d_name->name;
+	name.len = d_name->len;
+	rname.name = NULL;
 	lock_mode = xfs_ilock_map_shared(dp);
-	error = xfs_dir_lookup_int(dp, lock_mode, dentry, &e_inum, &ip);
+	error = xfs_dir_lookup_int(dp, lock_mode, &name, &e_inum, &ip, &rname);
 	if (!error) {
 		*ipp = ip;
 		xfs_itrace_ref(ip);
+		if (rname.name) {
+			ci_name->name = rname.name;
+			ci_name->len = rname.len;
+		}
 	}
 	xfs_iunlock_map_shared(dp, lock_mode);
 	return error;
Index: kern_ci/fs/xfs/xfs_vnodeops.h
===================================================================
--- kern_ci.orig/fs/xfs/xfs_vnodeops.h
+++ kern_ci/fs/xfs/xfs_vnodeops.h
@@ -23,8 +23,8 @@ int xfs_fsync(struct xfs_inode *ip, int 
 		xfs_off_t stop);
 int xfs_release(struct xfs_inode *ip);
 int xfs_inactive(struct xfs_inode *ip);
-int xfs_lookup(struct xfs_inode *dp, bhv_vname_t *dentry,
-		struct xfs_inode **ipp);
+int xfs_lookup(struct xfs_inode *dp, bhv_vstr_t *d_name,
+		struct xfs_inode **ipp, bhv_vstr_t *ci_name);
 int xfs_create(struct xfs_inode *dp, bhv_vname_t *dentry, mode_t mode,
 		xfs_dev_t rdev, struct xfs_inode **ipp, struct cred *credp);
 int xfs_remove(struct xfs_inode *dp, bhv_vname_t	*dentry);

-- 
