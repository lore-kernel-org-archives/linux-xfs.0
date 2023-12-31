Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEF9C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZXw863B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75ABC433C8;
	Sun, 31 Dec 2023 23:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065594;
	bh=SDcZLSNyIo/HvYA3tVyM0bE+aE4fhBTp1X4T1v59dTc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QZXw863BaZhFPNxB4uohGXzQY9S5jywlzQ4te7R42KeBDAuA7Ae35Mhr1HZB48ZgJ
	 OnSx+G/kFEk3cRr/w5rGPCHXWCVYmac2ivKC7M22SFlSxXOvkPS2/soI1wSCGsYTDW
	 RbNj1HxaRbSotFndEKC4CE0DqiSqnggbKPDacQpLegunkFmqOOOzfsohafpkbsfaZC
	 G6zWy3b5HFZKx4B4kQoOvEPHOH+sUYf7RkAsYeJxNOlhopnRCNS2QuIuLj4+gNjbhM
	 +Em6pSwTzxtiWcU9c0gMZNNaDuTplZuz03Lc+4q20udYcOvtZoqZGVSTjqI0zG4rgr
	 XNVeYlA6OPn1g==
Date: Sun, 31 Dec 2023 15:33:14 -0800
Subject: [PATCH 14/58] xfs: read and write metadata inode directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010134.1809361.2699363137966234355.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Plumb in the bits we need to look up metadata inode numbers from the
metadata inode directory and save them back.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h      |    5 
 include/xfs_trace.h      |    5 
 include/xfs_trans.h      |    3 
 libxfs/imeta_utils.c     |   66 +++++
 libxfs/libxfs_api_defs.h |    2 
 libxfs/libxfs_priv.h     |    2 
 libxfs/trans.c           |   33 +++
 libxfs/xfs_imeta.c       |  563 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_imeta.h       |   17 +
 libxfs/xfs_inode_util.c  |    3 
 libxfs/xfs_trans_resv.c  |    8 +
 11 files changed, 695 insertions(+), 12 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 4aacc488fa5..2675abdffcd 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -32,6 +32,11 @@ static inline kgid_t make_kgid(gid_t gid)
 	return v;
 }
 
+#define KUIDT_INIT(value) (kuid_t){ value }
+#define KGIDT_INIT(value) (kgid_t){ value }
+#define GLOBAL_ROOT_UID KUIDT_INIT(0)
+#define GLOBAL_ROOT_GID KGIDT_INIT(0)
+
 /* These match kernel side includes */
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index dd6011af90e..2cca9394b70 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -360,6 +360,11 @@
 
 #define trace_xlog_intent_recovery_failed(...)	((void) 0)
 
+#define trace_xfs_imeta_dir_link(...)		((void) 0)
+#define trace_xfs_imeta_dir_lookup(...)		((void) 0)
+#define trace_xfs_imeta_dir_try_create(...)	((void) 0)
+#define trace_xfs_imeta_dir_create(...)		((void) 0)
+#define trace_xfs_imeta_dir_unlink(...)		((void) 0)
 #define trace_xfs_imeta_teardown(...)		((void) 0)
 #define trace_xfs_imeta_sb_create(...)		((void) 0)
 #define trace_xfs_imeta_sb_link(...)		((void) 0)
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index b7f01ff073c..183163e81a5 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -93,6 +93,9 @@ int	libxfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
 int	libxfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
 			unsigned int dblocks, unsigned int rblocks, bool force,
 			struct xfs_trans **tpp);
+int	libxfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
+			struct xfs_inode *ip, unsigned int dblocks,
+			struct xfs_trans **tpp);
 int	libxfs_trans_alloc_rollable(struct xfs_mount *mp, uint blocks,
 				    struct xfs_trans **tpp);
 int	libxfs_trans_alloc_empty(struct xfs_mount *mp, struct xfs_trans **tpp);
diff --git a/libxfs/imeta_utils.c b/libxfs/imeta_utils.c
index f3165b5eed3..ce6000530d3 100644
--- a/libxfs/imeta_utils.c
+++ b/libxfs/imeta_utils.c
@@ -20,6 +20,7 @@
 #include "xfs_sb.h"
 #include "xfs_imeta.h"
 #include "xfs_trace.h"
+#include "xfs_parent.h"
 #include "imeta_utils.h"
 
 /* Initialize a metadata update structure. */
@@ -29,10 +30,33 @@ xfs_imeta_init(
 	const struct xfs_imeta_path	*path,
 	struct xfs_imeta_update		*upd)
 {
+	struct xfs_trans		*tp;
+	int				error;
+
 	memset(upd, 0, sizeof(struct xfs_imeta_update));
 	upd->mp = mp;
 	upd->path = path;
-	return 0;
+
+	if (!xfs_has_metadir(mp))
+		return 0;
+
+	/*
+	 * Find the parent of the last path component.  If the parent path does
+	 * not exist, we consider this corruption because paths are supposed
+	 * to exist.  For example, if the path is /quota/user, we require that
+	 * /quota already exists.
+	 */
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+	error = xfs_imeta_dir_parent(tp, upd->path, &upd->dp);
+	xfs_trans_cancel(tp);
+	if (error == -ENOENT)
+		return -EFSCORRUPTED;
+	if (error)
+		return error;
+
+	return xfs_parent_start(mp, &upd->ppargs);
 }
 
 /*
@@ -47,11 +71,25 @@ xfs_imeta_teardown(
 {
 	trace_xfs_imeta_teardown(upd, error);
 
+	if (upd->ppargs) {
+		xfs_parent_finish(upd->mp, upd->ppargs);
+		upd->ppargs = NULL;
+	}
+
 	if (upd->ip) {
 		if (upd->ip_locked)
 			xfs_iunlock(upd->ip, XFS_ILOCK_EXCL);
 		upd->ip_locked = false;
 	}
+
+	if (upd->dp) {
+		if (upd->dp_locked)
+			xfs_iunlock(upd->dp, XFS_ILOCK_EXCL);
+		upd->dp_locked = false;
+
+		xfs_imeta_irele(upd->dp);
+		upd->dp = NULL;
+	}
 }
 
 /*
@@ -75,6 +113,15 @@ xfs_imeta_start_create(
 	if (error)
 		goto out_teardown;
 
+	/*
+	 * Lock the parent directory if there is one.  We can't ijoin it to
+	 * the transaction until after the child file has been created.
+	 */
+	if (upd->dp) {
+		xfs_ilock(upd->dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
+		upd->dp_locked = true;
+	}
+
 	trace_xfs_imeta_start_create(upd);
 	return 0;
 out_teardown:
@@ -103,10 +150,19 @@ xfs_imeta_start_dir_update(
 
 	upd->ip = ip;
 
-	error = xfs_trans_alloc_inode(upd->ip, tr_resv, resblks, 0, false,
-			&upd->tp);
-	if (error)
-		goto out_teardown;
+	if (upd->dp) {
+		error = xfs_trans_alloc_dir(upd->dp, tr_resv, upd->ip,
+				resblks, &upd->tp);
+		if (error)
+			goto out_teardown;
+
+		upd->dp_locked = true;
+	} else {
+		error = xfs_trans_alloc_inode(upd->ip, tr_resv, resblks, 0,
+				false, &upd->tp);
+		if (error)
+			goto out_teardown;
+	}
 
 	upd->ip_locked = true;
 	return 0;
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a0cdad40ff9..90304da8983 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -184,6 +184,7 @@
 #define xfs_imeta_link_space_res	libxfs_imeta_link_space_res
 #define xfs_imeta_lookup		libxfs_imeta_lookup
 #define xfs_imeta_mount			libxfs_imeta_mount
+#define xfs_imeta_set_metaflag		libxfs_imeta_set_metaflag
 #define xfs_imeta_start_create		libxfs_imeta_start_create
 #define xfs_imeta_start_link		libxfs_imeta_start_link
 #define xfs_imeta_start_unlink		libxfs_imeta_start_unlink
@@ -289,6 +290,7 @@
 #define xfs_trans_add_item		libxfs_trans_add_item
 #define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
 #define xfs_trans_alloc			libxfs_trans_alloc
+#define xfs_trans_alloc_dir		libxfs_trans_alloc_dir
 #define xfs_trans_alloc_inode		libxfs_trans_alloc_inode
 #define xfs_trans_bhold			libxfs_trans_bhold
 #define xfs_trans_bhold_release		libxfs_trans_bhold_release
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 9bca059776d..f4614ee9631 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -175,6 +175,8 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 
 #define XFS_ERRLEVEL_LOW		1
 #define XFS_ILOCK_EXCL			0
+#define XFS_IOLOCK_SHARED		0
+#define XFS_IOLOCK_EXCL			0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 7fec2caff49..8d969400984 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -1184,6 +1184,39 @@ libxfs_trans_alloc_inode(
 	return 0;
 }
 
+/*
+ * Allocate an transaction, lock and join the directory and child inodes to it,
+ * and reserve quota for a directory update.
+ *
+ * The ILOCKs will be dropped when the transaction is committed or cancelled.
+ *
+ * Caller is responsible for unlocking the inodes manually upon return
+ */
+int
+libxfs_trans_alloc_dir(
+	struct xfs_inode	*dp,
+	struct xfs_trans_res	*resv,
+	struct xfs_inode	*ip,
+	unsigned int		resblks,
+	struct xfs_trans	**tpp)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
+	error = xfs_trans_alloc(mp, resv, resblks, 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin(tp, dp, 0);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	*tpp = tp;
+	return 0;
+}
+
 /*
  * Try to reserve more blocks for a transaction.  The single use case we
  * support is for offline repair -- use a transaction to gather data without
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index 672aba4d0e7..b1c5c6ec5e6 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -23,6 +23,8 @@
 #include "xfs_da_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
 
 /*
  * Metadata File Management
@@ -43,9 +45,16 @@
  * this structure must be passed to xfs_imeta_end_update to free resources that
  * cannot be freed during the transaction.
  *
- * Right now we only support callers passing in the predefined metadata inode
- * paths; the goal is that callers will some day locate metadata inodes based
- * on path lookups into a metadata directory structure.
+ * When the metadata directory tree (metadir) feature is enabled, we can create
+ * a complex directory tree in which to store metadata inodes.  Inodes within
+ * the metadata directory tree should have the "metadata" inode flag set to
+ * prevent them from being exposed to the outside world.
+ *
+ * Callers are not expected to take the IOLOCK of metadata directories.  They
+ * are expected to take the ILOCK of any inode in the metadata directory tree
+ * (just like the regular to synchronize access to that inode.  It is not
+ * necessary to take the MMAPLOCK since metadata inodes should never be exposed
+ * to user space.
  */
 
 /* Static metadata inode paths */
@@ -61,6 +70,11 @@ XFS_IMETA_DEFINE_PATH(XFS_IMETA_USRQUOTA,	usrquota_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_GRPQUOTA,	grpquota_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_PRJQUOTA,	prjquota_path);
 
+const struct xfs_imeta_path XFS_IMETA_METADIR = {
+	.im_depth = 0,
+	.im_ftype = XFS_DIR3_FT_DIR,
+};
+
 /* Are these two paths equal? */
 STATIC bool
 xfs_imeta_path_compare(
@@ -118,6 +132,10 @@ static const struct xfs_imeta_sbmap {
 		.path	= &XFS_IMETA_PRJQUOTA,
 		.offset	= offsetof(struct xfs_sb, sb_pquotino),
 	},
+	{
+		.path	= &XFS_IMETA_METADIR,
+		.offset	= offsetof(struct xfs_sb, sb_metadirino),
+	},
 	{ NULL, 0 },
 };
 
@@ -287,6 +305,521 @@ xfs_imeta_sb_link(
 	return 0;
 }
 
+/* Functions for storing and retrieving metadata directory inode values. */
+
+static inline void
+xfs_imeta_set_xname(
+	struct xfs_name			*xname,
+	const struct xfs_imeta_path	*path,
+	unsigned int			path_idx,
+	unsigned char			ftype)
+{
+	xname->name = (const unsigned char *)path->im_path[path_idx];
+	xname->len = strlen(path->im_path[path_idx]);
+	xname->type = ftype;
+}
+
+/*
+ * Look up the inode number and filetype for an exact name in a directory.
+ * Caller must hold ILOCK_EXCL.
+ */
+static inline int
+xfs_imeta_dir_lookup(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_name		*xname,
+	xfs_ino_t		*ino)
+{
+	struct xfs_da_args	args = {
+		.trans		= tp,
+		.dp		= dp,
+		.geo		= dp->i_mount->m_dir_geo,
+		.name		= xname->name,
+		.namelen	= xname->len,
+		.hashval	= xfs_dir2_hashname(dp->i_mount, xname),
+		.whichfork	= XFS_DATA_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+		.owner		= dp->i_ino,
+	};
+	bool			isblock, isleaf;
+	int			error;
+
+	if (xfs_is_shutdown(dp->i_mount))
+		return -EIO;
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		error = xfs_dir2_sf_lookup(&args);
+		goto out_unlock;
+	}
+
+	/* dir2 functions require that the data fork is loaded */
+	error = xfs_iread_extents(tp, dp, XFS_DATA_FORK);
+	if (error)
+		goto out_unlock;
+
+	error = xfs_dir2_isblock(&args, &isblock);
+	if (error)
+		goto out_unlock;
+
+	if (isblock) {
+		error = xfs_dir2_block_lookup(&args);
+		goto out_unlock;
+	}
+
+	error = xfs_dir2_isleaf(&args, &isleaf);
+	if (error)
+		goto out_unlock;
+
+	if (isleaf) {
+		error = xfs_dir2_leaf_lookup(&args);
+		goto out_unlock;
+	}
+
+	error = xfs_dir2_node_lookup(&args);
+
+out_unlock:
+	if (error == -EEXIST)
+		error = 0;
+	if (error)
+		return error;
+
+	*ino = args.inumber;
+	xname->type = args.filetype;
+	return 0;
+}
+
+/*
+ * Given a parent directory @dp and a metadata inode path component @xname,
+ * Look up the inode number in the directory, returning it in @ino.
+ * @xname.type must match the directory entry's ftype.
+ *
+ * Caller must hold ILOCK_EXCL.
+ */
+static inline int
+xfs_imeta_dir_lookup_component(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_name		*xname,
+	xfs_ino_t		*ino)
+{
+	int			type_wanted = xname->type;
+	int			error;
+
+	if (!S_ISDIR(VFS_I(dp)->i_mode))
+		return -EFSCORRUPTED;
+
+	error = xfs_imeta_dir_lookup(tp, dp, xname, ino);
+	if (error)
+		return error;
+	if (!xfs_verify_ino(dp->i_mount, *ino))
+		return -EFSCORRUPTED;
+	if (type_wanted != XFS_DIR3_FT_UNKNOWN && xname->type != type_wanted)
+		return -EFSCORRUPTED;
+
+	trace_xfs_imeta_dir_lookup(dp, xname, *ino);
+	return 0;
+}
+
+/*
+ * Traverse a metadata directory tree path, returning the inode corresponding
+ * to the parent of the last path component.  If any of the path components do
+ * not exist, return -ENOENT.  Caller must supply a transaction to avoid
+ * livelocks on btree cycles.
+ *
+ * @dp is returned without any locks held.
+ */
+int
+xfs_imeta_dir_parent(
+	struct xfs_trans		*tp,
+	const struct xfs_imeta_path	*path,
+	struct xfs_inode		**dpp)
+{
+	struct xfs_name			xname;
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_inode		*dp = NULL;
+	xfs_ino_t			ino;
+	unsigned int			i;
+	int				error;
+
+	/* Caller wanted the root, we're done! */
+	if (path->im_depth == 0)
+		goto out;
+
+	/* No metadata directory means no parent. */
+	if (mp->m_metadirip == NULL)
+		return -ENOENT;
+
+	/* Grab a new reference to the metadir root dir. */
+	error = xfs_imeta_iget(tp, mp->m_metadirip->i_ino, XFS_DIR3_FT_DIR,
+			&dp);
+	if (error)
+		return error;
+
+	for (i = 0; i < path->im_depth - 1; i++) {
+		struct xfs_inode	*ip = NULL;
+
+		xfs_ilock(dp, XFS_ILOCK_EXCL);
+
+		/* Look up the name in the current directory. */
+		xfs_imeta_set_xname(&xname, path, i, XFS_DIR3_FT_DIR);
+		error = xfs_imeta_dir_lookup_component(tp, dp, &xname, &ino);
+		if (error)
+			goto out_rele;
+
+		/*
+		 * Grab the child inode while we still have the parent
+		 * directory locked.
+		 */
+		error = xfs_imeta_iget(tp, ino, XFS_DIR3_FT_DIR, &ip);
+		if (error)
+			goto out_rele;
+
+		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+		xfs_imeta_irele(dp);
+		dp = ip;
+	}
+
+out:
+	*dpp = dp;
+	return 0;
+
+out_rele:
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_imeta_irele(dp);
+	return error;
+}
+
+/*
+ * Look up a metadata inode from the metadata directory.  If the last path
+ * component doesn't exist, return NULLFSINO.  If any other part of the path
+ * does not exist, return -ENOENT so we can distinguish the two.
+ */
+STATIC int
+xfs_imeta_dir_lookup_int(
+	struct xfs_trans		*tp,
+	const struct xfs_imeta_path	*path,
+	xfs_ino_t			*inop)
+{
+	struct xfs_name			xname;
+	struct xfs_inode		*dp = NULL;
+	xfs_ino_t			ino;
+	int				error;
+
+	/* metadir ino is recorded in superblock */
+	if (xfs_imeta_path_compare(path, &XFS_IMETA_METADIR))
+		return xfs_imeta_sb_lookup(tp->t_mountp, path, inop);
+
+	ASSERT(path->im_depth > 0);
+
+	/* Find the parent of the last path component. */
+	error = xfs_imeta_dir_parent(tp, path, &dp);
+	if (error)
+		return error;
+
+	xfs_ilock(dp, XFS_ILOCK_EXCL);
+
+	/* Look up the name in the current directory. */
+	xfs_imeta_set_xname(&xname, path, path->im_depth - 1, path->im_ftype);
+	error = xfs_imeta_dir_lookup_component(tp, dp, &xname, &ino);
+	switch (error) {
+	case 0:
+		*inop = ino;
+		break;
+	case -ENOENT:
+		*inop = NULLFSINO;
+		error = 0;
+		break;
+	}
+
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_imeta_irele(dp);
+	return error;
+}
+
+/*
+ * Load all the metadata inode pointers that are cached in the in-core
+ * superblock but live somewhere in the metadata directory tree.
+ */
+STATIC int
+xfs_imeta_dir_mount(
+	struct xfs_trans		*tp)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	const struct xfs_imeta_sbmap	*p;
+	xfs_ino_t			*sb_inop;
+	int				err2;
+	int				error = 0;
+
+	for (p = xfs_imeta_sbmaps; p->path && p->path->im_depth > 0; p++) {
+		if (p->path == &XFS_IMETA_METADIR)
+			continue;
+		sb_inop = xfs_imeta_sbmap_to_inop(mp, p);
+		err2 = xfs_imeta_dir_lookup_int(tp, p->path, sb_inop);
+		if (err2 == -ENOENT) {
+			*sb_inop = NULLFSINO;
+			continue;
+		}
+		if (!error && err2)
+			error = err2;
+	}
+
+	return error;
+}
+
+/* Set up an inode to be recognized as a metadata directory inode. */
+void
+xfs_imeta_set_iflag(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	VFS_I(ip)->i_mode &= ~0777;
+	VFS_I(ip)->i_uid = GLOBAL_ROOT_UID;
+	VFS_I(ip)->i_gid = GLOBAL_ROOT_GID;
+	ip->i_projid = 0;
+	ip->i_diflags |= (XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_SYNC |
+			  XFS_DIFLAG_NOATIME | XFS_DIFLAG_NODUMP |
+			  XFS_DIFLAG_NODEFRAG);
+	if (S_ISDIR(VFS_I(ip)->i_mode))
+		ip->i_diflags |= XFS_DIFLAG_NOSYMLINKS;
+	ip->i_diflags2 &= ~XFS_DIFLAG2_DAX;
+	ip->i_diflags2 |= XFS_DIFLAG2_METADIR;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+
+/* Clear the metadata directory inode flag. */
+void
+xfs_imeta_clear_iflag(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	ASSERT(xfs_is_metadir_inode(ip));
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+
+	ip->i_diflags2 &= ~XFS_DIFLAG2_METADIR;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+/*
+ * Create a new metadata inode accessible via the given metadata directory path.
+ * Callers must ensure that the directory entry does not already exist; a new
+ * one will be created.
+ */
+STATIC int
+xfs_imeta_dir_create(
+	struct xfs_imeta_update		*upd,
+	umode_t				mode)
+{
+	struct xfs_icreate_args		args = {
+		.pip			= upd->dp,
+		.nlink			= S_ISDIR(mode) ? 2 : 1,
+	};
+	struct xfs_name			xname;
+	struct xfs_dir_update		du = {
+		.dp			= upd->dp,
+		.name			= &xname,
+		.ppargs			= upd->ppargs,
+	};
+	struct xfs_mount		*mp = upd->mp;
+	xfs_ino_t			*sb_inop;
+	xfs_ino_t			ino;
+	unsigned int			resblks;
+	int				error;
+
+	ASSERT(xfs_isilocked(upd->dp, XFS_ILOCK_EXCL));
+
+	/* metadir ino is recorded in superblock; only mkfs gets to do this */
+	if (xfs_imeta_path_compare(upd->path, &XFS_IMETA_METADIR)) {
+		error = xfs_imeta_sb_create(upd, mode);
+		if (error)
+			return error;
+
+		/* Set the metadata iflag, initialize directory. */
+		xfs_imeta_set_iflag(upd->tp, upd->ip);
+		return xfs_dir_init(upd->tp, upd->ip, upd->ip);
+	}
+
+	ASSERT(upd->path->im_depth > 0);
+
+	xfs_icreate_args_rootfile(&args, mp, mode, xfs_has_parent(mp));
+
+	/* Check that the name does not already exist in the directory. */
+	xfs_imeta_set_xname(&xname, upd->path, upd->path->im_depth - 1,
+			XFS_DIR3_FT_UNKNOWN);
+	error = xfs_imeta_dir_lookup_component(upd->tp, upd->dp, &xname, &ino);
+	switch (error) {
+	case -ENOENT:
+		break;
+	case 0:
+		error = -EEXIST;
+		fallthrough;
+	default:
+		return error;
+	}
+
+	/*
+	 * A newly created regular or special file just has one directory
+	 * entry pointing to them, but a directory also the "." entry
+	 * pointing to itself.
+	 */
+	error = xfs_dialloc(&upd->tp, upd->dp->i_ino, mode, &ino);
+	if (error)
+		return error;
+	error = xfs_icreate(upd->tp, ino, &args, &upd->ip);
+	if (error)
+		return error;
+	du.ip = upd->ip;
+	xfs_imeta_set_iflag(upd->tp, upd->ip);
+	upd->ip_locked = true;
+
+	/*
+	 * Join the directory inode to the transaction.  We do not do it
+	 * earlier because xfs_dialloc rolls the transaction.
+	 */
+	xfs_trans_ijoin(upd->tp, upd->dp, 0);
+
+	/* Create the entry. */
+	if (S_ISDIR(args.mode))
+		resblks = xfs_mkdir_space_res(mp, xname.len);
+	else
+		resblks = xfs_create_space_res(mp, xname.len);
+	xname.type = xfs_mode_to_ftype(args.mode);
+
+	trace_xfs_imeta_dir_try_create(upd);
+
+	error = xfs_dir_create_child(upd->tp, resblks, &du);
+	if (error)
+		return error;
+
+	/* Metadir files are not accounted to quota. */
+
+	trace_xfs_imeta_dir_create(upd);
+
+	/* Update the in-core superblock value if there is one. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, upd->path);
+	if (sb_inop)
+		*sb_inop = ino;
+	return 0;
+}
+
+/*
+ * Remove the given entry from the metadata directory and drop the link count
+ * of the metadata inode.
+ */
+STATIC int
+xfs_imeta_dir_unlink(
+	struct xfs_imeta_update		*upd)
+{
+	struct xfs_name			xname;
+	struct xfs_dir_update		du = {
+		.dp			= upd->dp,
+		.name			= &xname,
+		.ip			= upd->ip,
+		.ppargs			= upd->ppargs,
+	};
+	struct xfs_mount		*mp = upd->mp;
+	xfs_ino_t			*sb_inop;
+	xfs_ino_t			ino;
+	unsigned int			resblks;
+	int				error;
+
+	ASSERT(xfs_isilocked(upd->dp, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(upd->ip, XFS_ILOCK_EXCL));
+
+	/* Metadata directory root cannot be unlinked. */
+	if (xfs_imeta_path_compare(upd->path, &XFS_IMETA_METADIR)) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	ASSERT(upd->path->im_depth > 0);
+
+	/* Look up the name in the current directory. */
+	xfs_imeta_set_xname(&xname, upd->path, upd->path->im_depth - 1,
+			xfs_mode_to_ftype(VFS_I(upd->ip)->i_mode));
+	error = xfs_imeta_dir_lookup_component(upd->tp, upd->dp, &xname, &ino);
+	switch (error) {
+	case 0:
+		if (ino != upd->ip->i_ino)
+			error = -ENOENT;
+		break;
+	case -ENOENT:
+		error = -EFSCORRUPTED;
+		break;
+	}
+	if (error)
+		return error;
+
+	resblks = xfs_remove_space_res(mp, xname.len);
+	error = xfs_dir_remove_child(upd->tp, resblks, &du);
+	if (error)
+		return error;
+
+	trace_xfs_imeta_dir_unlink(upd);
+
+	/* Update the in-core superblock value if there is one. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, upd->path);
+	if (sb_inop)
+		*sb_inop = NULLFSINO;
+	return 0;
+}
+
+/* Set the given path in the metadata directory to point to an inode. */
+STATIC int
+xfs_imeta_dir_link(
+	struct xfs_imeta_update		*upd)
+{
+	struct xfs_name			xname;
+	struct xfs_dir_update		du = {
+		.dp			= upd->dp,
+		.name			= &xname,
+		.ip			= upd->ip,
+		.ppargs			= upd->ppargs,
+	};
+	struct xfs_mount		*mp = upd->mp;
+	xfs_ino_t			*sb_inop;
+	xfs_ino_t			ino;
+	unsigned int			resblks;
+	int				error;
+
+	ASSERT(xfs_isilocked(upd->dp, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(upd->ip, XFS_ILOCK_EXCL));
+
+	/* Metadata directory root cannot be linked. */
+	if (xfs_imeta_path_compare(upd->path, &XFS_IMETA_METADIR)) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	ASSERT(upd->path->im_depth > 0);
+
+	/* Look up the name in the current directory. */
+	xfs_imeta_set_xname(&xname, upd->path, upd->path->im_depth - 1,
+			xfs_mode_to_ftype(VFS_I(upd->ip)->i_mode));
+	error = xfs_imeta_dir_lookup_component(upd->tp, upd->dp, &xname, &ino);
+	switch (error) {
+	case -ENOENT:
+		break;
+	case 0:
+		error = -EEXIST;
+		fallthrough;
+	default:
+		return error;
+	}
+
+	resblks = xfs_link_space_res(mp, xname.len);
+	error = xfs_dir_add_child(upd->tp, resblks, &du);
+	if (error)
+		return error;
+
+	trace_xfs_imeta_dir_link(upd);
+
+	/* Update the in-core superblock value if there is one. */
+	sb_inop = xfs_imeta_path_to_sb_inop(mp, upd->path);
+	if (sb_inop)
+		*sb_inop = upd->ip->i_ino;
+	return 0;
+}
+
 /* General functions for managing metadata inode pointers */
 
 /*
@@ -317,7 +850,13 @@ xfs_imeta_lookup(
 
 	ASSERT(xfs_imeta_path_check(path));
 
-	error = xfs_imeta_sb_lookup(mp, path, &ino);
+	if (xfs_has_metadir(mp)) {
+		error = xfs_imeta_dir_lookup_int(tp, path, &ino);
+		if (error == -ENOENT)
+			return -EFSCORRUPTED;
+	} else {
+		error = xfs_imeta_sb_lookup(mp, path, &ino);
+	}
 	if (error)
 		return error;
 
@@ -349,13 +888,17 @@ xfs_imeta_create(
 	umode_t				mode,
 	struct xfs_inode		**ipp)
 {
+	struct xfs_mount		*mp = upd->mp;
 	int				error;
 
 	ASSERT(xfs_imeta_path_check(upd->path));
 
 	*ipp = NULL;
 
-	error = xfs_imeta_sb_create(upd, mode);
+	if (xfs_has_metadir(mp))
+		error = xfs_imeta_dir_create(upd, mode);
+	else
+		error = xfs_imeta_sb_create(upd, mode);
 	*ipp = upd->ip;
 	return error;
 }
@@ -405,7 +948,10 @@ xfs_imeta_unlink(
 	ASSERT(xfs_imeta_path_check(upd->path));
 	ASSERT(xfs_imeta_verify(upd->mp, upd->ip->i_ino));
 
-	error = xfs_imeta_sb_unlink(upd);
+	if (xfs_has_metadir(upd->mp))
+		error = xfs_imeta_dir_unlink(upd);
+	else
+		error = xfs_imeta_sb_unlink(upd);
 	if (error)
 		return error;
 
@@ -431,6 +977,8 @@ xfs_imeta_link(
 {
 	ASSERT(xfs_imeta_path_check(upd->path));
 
+	if (xfs_has_metadir(upd->mp))
+		return xfs_imeta_dir_link(upd);
 	return xfs_imeta_sb_link(upd);
 }
 
@@ -461,5 +1009,8 @@ int
 xfs_imeta_mount(
 	struct xfs_trans	*tp)
 {
+	if (xfs_has_metadir(tp->t_mountp))
+		return xfs_imeta_dir_mount(tp);
+
 	return 0;
 }
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
index 60e0f6a6c13..b8e360bbdfb 100644
--- a/libxfs/xfs_imeta.h
+++ b/libxfs/xfs_imeta.h
@@ -13,6 +13,7 @@
 #define XFS_IMETA_DEFINE_PATH(name, path) \
 const struct xfs_imeta_path name = { \
 	.im_path = (path), \
+	.im_ftype = XFS_DIR3_FT_REG_FILE, \
 	.im_depth = ARRAY_SIZE(path), \
 }
 
@@ -23,6 +24,9 @@ struct xfs_imeta_path {
 
 	/* Number of strings in path. */
 	uint8_t			im_depth;
+
+	/* Expected file type. */
+	uint8_t			im_ftype;
 };
 
 /* Cleanup widget for metadata inode creation and deletion. */
@@ -32,9 +36,16 @@ struct xfs_imeta_update {
 
 	const struct xfs_imeta_path *path;
 
+	/* Parent pointer update context */
+	struct xfs_parent_args	*ppargs;
+
+	/* Parent directory */
+	struct xfs_inode	*dp;
+
 	/* Metadata inode */
 	struct xfs_inode	*ip;
 
+	unsigned int		dp_locked:1;
 	unsigned int		ip_locked:1;
 };
 
@@ -54,9 +65,15 @@ extern const struct xfs_imeta_path XFS_IMETA_RTSUMMARY;
 extern const struct xfs_imeta_path XFS_IMETA_USRQUOTA;
 extern const struct xfs_imeta_path XFS_IMETA_GRPQUOTA;
 extern const struct xfs_imeta_path XFS_IMETA_PRJQUOTA;
+extern const struct xfs_imeta_path XFS_IMETA_METADIR;
 
 int xfs_imeta_lookup(struct xfs_trans *tp, const struct xfs_imeta_path *path,
 		xfs_ino_t *ino);
+int xfs_imeta_dir_parent(struct xfs_trans *tp,
+		const struct xfs_imeta_path *path, struct xfs_inode **dpp);
+
+void xfs_imeta_set_iflag(struct xfs_trans *tp, struct xfs_inode *ip);
+void xfs_imeta_clear_iflag(struct xfs_trans *tp, struct xfs_inode *ip);
 
 int xfs_imeta_create(struct xfs_imeta_update *upd, umode_t mode,
 		struct xfs_inode **ipp);
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index b63aacb6971..c2e51a6ee94 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -19,6 +19,7 @@
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
 #include "xfs_ag.h"
+#include "xfs_imeta.h"
 #include "iunlink.h"
 
 uint16_t
@@ -646,6 +647,8 @@ xfs_droplink(
 	if (inode->i_nlink)
 		return 0;
 
+	if (xfs_is_metadir_inode(ip))
+		xfs_imeta_clear_iflag(tp, ip);
 	return xfs_iunlink(tp, ip);
 }
 
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index a46360e2bdb..74f46539179 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -1118,7 +1118,10 @@ xfs_calc_imeta_create_resv(
 	unsigned int		ret;
 
 	ret = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
-	ret += resp->tr_create.tr_logres;
+	if (xfs_has_metadir(mp))
+		ret += max(resp->tr_create.tr_logres, resp->tr_mkdir.tr_logres);
+	else
+		ret += resp->tr_create.tr_logres;
 	return ret;
 }
 
@@ -1128,6 +1131,9 @@ xfs_calc_imeta_create_count(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
+	if (xfs_has_metadir(mp))
+		return max(resp->tr_create.tr_logcount,
+			   resp->tr_mkdir.tr_logcount);
 	return resp->tr_create.tr_logcount;
 }
 

