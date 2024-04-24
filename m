Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9EC29429
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928590; cv=none; b=js8Tf9IcfNrRBSu0cf1UcOCHgI14tEAYb5v/3B2uHkZb30tlmTaKTkZSR8ab/HZdbc269EAq+k2TyEomsHV9BMTVc9SoRQK68BWC0LQ45voRAaB0ebnAJ8qIzWfP50ZT5VTEf8FjdVYvxn02Mq6BlsAlHPXMu/fIikVWvYQ4nJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928590; c=relaxed/simple;
	bh=ZbpFHWBOft1FBHnA3NH4DnSqOpygpmrN/f3VYqL6QDM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gO9eJdjyuinTfIfI6x+ERQLRwVHMtJUWKfQt7Www+nYFEc81+OxMBsGBzfMaAxJfSvTgEzC6Rv8sT1WTWje6L8UgPb+ExTc9bWCePorMTO+1RYKY2Oz1LK+zkvnc2IMcBOckwopCmK7TsmSexyNaROsAEizCyo/rbFTmkffJuc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AdtQmtYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AdtQmtYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7536CC116B1;
	Wed, 24 Apr 2024 03:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928590;
	bh=ZbpFHWBOft1FBHnA3NH4DnSqOpygpmrN/f3VYqL6QDM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AdtQmtYD9QYWqmy6v/JvFN7ozHB+Ax97JY0tbcX/TQmSzNELgsyjoYlTUMxkGUQ1G
	 YG3AbDgNqa+rKv4E57AIiP/j9+z9X+6gIQ8uvynLpL9w5X3QdL1tQq9vJY1QchIZnN
	 0lNddIb5x9ddtoVt5sj6yU3D9Hr5fK7OzAEZnqKhxXlKDhmxuEFXdSKXs/u4plasXO
	 jXo/lQkhs4AMs4b6Ng/zZkj634Qz3fgI77KL69//u7igyiYDqyGSIsQC0qeXv2Bwod
	 ckXKQVtp+5oTtaigeKwi2FdJhFfqffOns6a5/lk+jNO94Wi22ta5hhtEp164W/cD8z
	 0swH2mI3HZD1Q==
Date: Tue, 23 Apr 2024 20:16:30 -0700
Subject: [PATCH 15/30] xfs: parent pointer attribute creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783520.1905110.2465284054198581576.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes.  Note that the xfs_attr_intent object contains a
pointer to the caller's xfs_da_args object, so the latter must persist
until transaction commit.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: shorten names, adjust to new format, set init_xattrs for parent
pointers]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile                 |    1 +
 fs/xfs/libxfs/xfs_parent.c      |   68 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |   65 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_space.c |   52 ++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    9 +++--
 fs/xfs/scrub/tempfile.c         |    2 +
 fs/xfs/xfs_inode.c              |   32 +++++++++++++++---
 fs/xfs/xfs_iops.c               |   15 ++++++++-
 fs/xfs/xfs_super.c              |   10 ++++++
 9 files changed, 242 insertions(+), 12 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_trans_space.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 4956ea9a307b..0c1a0b67af93 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -51,6 +51,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_symlink_remote.o \
 				   xfs_trans_inode.o \
 				   xfs_trans_resv.o \
+				   xfs_trans_space.o \
 				   xfs_types.o \
 				   )
 # xfs_rtbitmap is shared with libxfs
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index d564baf2549c..65616cfc1a2b 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -27,6 +27,10 @@
 #include "xfs_xattr.h"
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
+#include "xfs_attr_item.h"
+#include "xfs_health.h"
+
+struct kmem_cache		*xfs_parent_args_cache;
 
 /*
  * Parent pointer attribute handling.
@@ -137,3 +141,67 @@ xfs_parent_hashattr(
 
 	return xfs_parent_hashval(mp, name, namelen, be64_to_cpu(rec->p_ino));
 }
+
+/*
+ * Initialize the parent pointer arguments structure.  Caller must have zeroed
+ * the contents of @args.  @tp is only required for updates.
+ */
+static void
+xfs_parent_da_args_init(
+	struct xfs_da_args	*args,
+	struct xfs_trans	*tp,
+	struct xfs_parent_rec	*rec,
+	struct xfs_inode	*child,
+	xfs_ino_t		owner,
+	const struct xfs_name	*parent_name)
+{
+	args->geo = child->i_mount->m_attr_geo;
+	args->whichfork = XFS_ATTR_FORK;
+	args->attr_filter = XFS_ATTR_PARENT;
+	args->op_flags = XFS_DA_OP_LOGGED | XFS_DA_OP_OKNOENT;
+	args->trans = tp;
+	args->dp = child;
+	args->owner = owner;
+	args->name = parent_name->name;
+	args->namelen = parent_name->len;
+	args->value = rec;
+	args->valuelen = sizeof(struct xfs_parent_rec);
+	xfs_attr_sethash(args);
+}
+
+/* Make sure the incore state is ready for a parent pointer query/update. */
+static inline int
+xfs_parent_iread_extents(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*child)
+{
+	/* Parent pointers require that the attr fork must exist. */
+	if (XFS_IS_CORRUPT(child->i_mount, !xfs_inode_has_attr_fork(child))) {
+		xfs_inode_mark_sick(child, XFS_SICK_INO_PARENT);
+		return -EFSCORRUPTED;
+	}
+
+	return xfs_iread_extents(tp, child, XFS_ATTR_FORK);
+}
+
+/* Add a parent pointer to reflect a dirent addition. */
+int
+xfs_parent_addname(
+	struct xfs_trans	*tp,
+	struct xfs_parent_args	*ppargs,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*parent_name,
+	struct xfs_inode	*child)
+{
+	int			error;
+
+	error = xfs_parent_iread_extents(tp, child);
+	if (error)
+		return error;
+
+	xfs_inode_to_parent_rec(&ppargs->rec, dp);
+	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
+			child->i_ino, parent_name);
+	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 6a4028871b72..6de24e3ef318 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -17,4 +17,69 @@ xfs_dahash_t xfs_parent_hashval(struct xfs_mount *mp, const uint8_t *name,
 xfs_dahash_t xfs_parent_hashattr(struct xfs_mount *mp, const uint8_t *name,
 		int namelen, const void *value, int valuelen);
 
+/* Initializes a xfs_parent_rec to be stored as an attribute name. */
+static inline void
+xfs_parent_rec_init(
+	struct xfs_parent_rec	*rec,
+	xfs_ino_t		ino,
+	uint32_t		gen)
+{
+	rec->p_ino = cpu_to_be64(ino);
+	rec->p_gen = cpu_to_be32(gen);
+}
+
+/* Initializes a xfs_parent_rec to be stored as an attribute name. */
+static inline void
+xfs_inode_to_parent_rec(
+	struct xfs_parent_rec	*rec,
+	const struct xfs_inode	*dp)
+{
+	xfs_parent_rec_init(rec, dp->i_ino, VFS_IC(dp)->i_generation);
+}
+
+extern struct kmem_cache	*xfs_parent_args_cache;
+
+/*
+ * Parent pointer information needed to pass around the deferred xattr update
+ * machinery.
+ */
+struct xfs_parent_args {
+	struct xfs_parent_rec	rec;
+	struct xfs_da_args	args;
+};
+
+/*
+ * Start a parent pointer update by allocating the context object we need to
+ * perform a parent pointer update.
+ */
+static inline int
+xfs_parent_start(
+	struct xfs_mount	*mp,
+	struct xfs_parent_args	**ppargsp)
+{
+	if (!xfs_has_parent(mp)) {
+		*ppargsp = NULL;
+		return 0;
+	}
+
+	*ppargsp = kmem_cache_zalloc(xfs_parent_args_cache, GFP_KERNEL);
+	if (!*ppargsp)
+		return -ENOMEM;
+	return 0;
+}
+
+/* Finish a parent pointer update by freeing the context object. */
+static inline void
+xfs_parent_finish(
+	struct xfs_mount	*mp,
+	struct xfs_parent_args	*ppargs)
+{
+	if (ppargs)
+		kmem_cache_free(xfs_parent_args_cache, ppargs);
+}
+
+int xfs_parent_addname(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		struct xfs_inode *child);
+
 #endif /* __XFS_PARENT_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
new file mode 100644
index 000000000000..90532c3fa205
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+
+/* Calculate the disk space required to add a parent pointer. */
+unsigned int
+xfs_parent_calc_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	/*
+	 * Parent pointers are always the first attr in an attr tree, and never
+	 * larger than a block
+	 */
+	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
+	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
+}
+
+unsigned int
+xfs_create_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_parent_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
+unsigned int
+xfs_mkdir_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	return xfs_create_space_res(mp, namelen);
+}
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 9640fc232c14..6cda87153b38 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -80,8 +80,6 @@
 /* This macro is not used - see inline code in xfs_attr_set */
 #define	XFS_ATTRSET_SPACE_RES(mp, v)	\
 	(XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) + XFS_B_TO_FSB(mp, v))
-#define	XFS_CREATE_SPACE_RES(mp,nl)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_DIOSTRAT_SPACE_RES(mp, v)	\
 	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + (v))
 #define	XFS_GROWFS_SPACE_RES(mp)	\
@@ -90,8 +88,6 @@
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
 #define	XFS_LINK_SPACE_RES(mp,nl)	\
 	XFS_DIRENTER_SPACE_RES(mp,nl)
-#define	XFS_MKDIR_SPACE_RES(mp,nl)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
 	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + \
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
@@ -106,5 +102,10 @@
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
+unsigned int xfs_parent_calc_space_res(struct xfs_mount *mp,
+		unsigned int namelen);
+
+unsigned int xfs_create_space_res(struct xfs_mount *mp, unsigned int namelen);
+unsigned int xfs_mkdir_space_res(struct xfs_mount *mp, unsigned int namelen);
 
 #endif	/* __XFS_TRANS_SPACE_H__ */
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 6f39504a216e..ddbcccb3dba1 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -71,7 +71,7 @@ xrep_tempfile_create(
 		return error;
 
 	if (is_dir) {
-		resblks = XFS_MKDIR_SPACE_RES(mp, 0);
+		resblks = xfs_mkdir_space_res(mp, 0);
 		tres = &M_RES(mp)->tr_mkdir;
 	} else {
 		resblks = XFS_IALLOC_SPACE_RES(mp);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 060e4e767b51..0dd4111a6773 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -40,6 +40,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
 #include "xfs_pnfs.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -1017,7 +1019,7 @@ xfs_dir_hook_setup(
 int
 xfs_create(
 	struct mnt_idmap	*idmap,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -1029,7 +1031,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -1037,6 +1039,7 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	struct xfs_parent_args	*ppargs;
 
 	trace_xfs_create(dp, name);
 
@@ -1058,13 +1061,17 @@ xfs_create(
 		return error;
 
 	if (is_dir) {
-		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
+		resblks = xfs_mkdir_space_res(mp, name->len);
 		tres = &M_RES(mp)->tr_mkdir;
 	} else {
-		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
+		resblks = xfs_create_space_res(mp, name->len);
 		tres = &M_RES(mp)->tr_create;
 	}
 
+	error = xfs_parent_start(mp, &ppargs);
+	if (error)
+		goto out_release_dquots;
+
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1080,7 +1087,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto out_parent;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1123,6 +1130,16 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (ppargs) {
+		error = xfs_parent_addname(tp, ppargs, dp, name, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * Create ip with a reference from dp, and add '.' and '..' references
 	 * if it's a directory.
@@ -1155,6 +1172,7 @@ xfs_create(
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, ppargs);
 	return 0;
 
  out_trans_cancel:
@@ -1170,6 +1188,8 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+ out_parent:
+	xfs_parent_finish(mp, ppargs);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
@@ -3038,7 +3058,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-				   false, &tmpfile);
+			xfs_has_parent(dp->i_mount), &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d32322f9ecde..ff222827e550 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -157,6 +157,8 @@ xfs_create_need_xattr(
 	if (dir->i_sb->s_security)
 		return true;
 #endif
+	if (xfs_has_parent(XFS_I(dir)->i_mount))
+		return true;
 	return false;
 }
 
@@ -201,7 +203,18 @@ xfs_generic_create(
 				xfs_create_need_xattr(dir, default_acl, acl),
 				&ip);
 	} else {
-		error = xfs_create_tmpfile(idmap, XFS_I(dir), mode, false, &ip);
+		bool	init_xattrs = false;
+
+		/*
+		 * If this temporary file will be linkable, set up the file
+		 * with an attr fork to receive a parent pointer.
+		 */
+		if (!(tmpfile->f_flags & O_EXCL) &&
+		    xfs_has_parent(XFS_I(dir)->i_mount))
+			init_xattrs = true;
+
+		error = xfs_create_tmpfile(idmap, XFS_I(dir), mode,
+				init_xattrs, &ip);
 	}
 	if (unlikely(error))
 		goto out_free_acl;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e525a6c477ff..c303d7ff9597 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -44,6 +44,7 @@
 #include "xfs_dahash_test.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_exchmaps_item.h"
+#include "xfs_parent.h"
 #include "scrub/stats.h"
 #include "scrub/rcbag_btree.h"
 
@@ -2211,8 +2212,16 @@ xfs_init_caches(void)
 	if (!xfs_xmi_cache)
 		goto out_destroy_xmd_cache;
 
+	xfs_parent_args_cache = kmem_cache_create("xfs_parent_args",
+					     sizeof(struct xfs_parent_args),
+					     0, 0, NULL);
+	if (!xfs_parent_args_cache)
+		goto out_destroy_xmi_cache;
+
 	return 0;
 
+ out_destroy_xmi_cache:
+	kmem_cache_destroy(xfs_xmi_cache);
  out_destroy_xmd_cache:
 	kmem_cache_destroy(xfs_xmd_cache);
  out_destroy_iul_cache:
@@ -2273,6 +2282,7 @@ xfs_destroy_caches(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_cache_destroy(xfs_parent_args_cache);
 	kmem_cache_destroy(xfs_xmd_cache);
 	kmem_cache_destroy(xfs_xmi_cache);
 	kmem_cache_destroy(xfs_iunlink_cache);

