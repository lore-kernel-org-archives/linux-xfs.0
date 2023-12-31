Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA199BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+XKi9cV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A02C433C8;
	Sun, 31 Dec 2023 20:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055804;
	bh=78JarBRLz3QjY1lDxBi7IeTeMpvb4jxRubRzH1BQaEI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A+XKi9cVdmMl8+t1HV0PXNUKf6Qekh6clLZss+0ZyirG8dJCoEMxN2uMsqtgvdf7+
	 bwVyF3/37tZKUhhQaGTRs51zuS9U0A0kKykssTgeaLDd5uGSkeO2atJGoVttTtYSTR
	 0wuqq4RKFNfFP2d45dvTlZilnFgG07mIYhQnv3QirJzsim2d7v2v8VjLap5ii7hsq1
	 NUo2fORbLKBhA4Ki6pAa2X/muMQOs9K76g6RxAdeVCZCNipGldvZvxBZuuBRWqr9ft
	 8jPvwXeeIyTaYAe84vKQVMvZqswrUXY+mr4aTKOGSbJxcl8B5jGtokxpABxflqc0N0
	 DwXNxc/ezuEGw==
Date: Sun, 31 Dec 2023 12:50:03 -0800
Subject: [PATCH 06/18] xfs: parent pointer attribute creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <170404841134.1756905.1993997240273692140.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
References: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
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
initialize attributes

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: shorten names, adjust to new format, set init_xattrs for parent
pointers]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/libxfs/xfs_attr.c        |    2 -
 fs/xfs/libxfs/xfs_attr.h        |    2 -
 fs/xfs/libxfs/xfs_parent.c      |   91 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |   77 +++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_space.c |   52 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    9 ++--
 fs/xfs/scrub/tempfile.c         |    2 -
 fs/xfs/xfs_inode.c              |   30 ++++++++++---
 fs/xfs/xfs_iops.c               |   15 ++++++
 fs/xfs/xfs_super.c              |   10 ++++
 fs/xfs/xfs_xattr.c              |    4 +-
 fs/xfs/xfs_xattr.h              |    2 +
 13 files changed, 280 insertions(+), 17 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_trans_space.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 64ff5295d3fc9..5a358113ad9d7 100644
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
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d513ed57177e1..c13eb7b7b5b8f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -895,7 +895,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static void
+void
 xfs_attr_defer_add(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags)
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 5b3a0d4b1583c..4a4d45a96dd6c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -549,6 +549,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
+void xfs_attr_defer_add(struct xfs_da_args *args, unsigned int op_flags);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
@@ -557,7 +558,6 @@ bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 1d45f926c13a6..05ef155388a12 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -28,6 +28,8 @@
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
 
+struct kmem_cache		*xfs_parent_args_cache;
+
 /*
  * Parent pointer attribute handling.
  *
@@ -111,3 +113,92 @@ xfs_parent_hashcheck(
 	/* Namehash matches name? */
 	return be32_to_cpu(rec->p_namehash) == xfs_dir2_hashname(mp, &dname);
 }
+
+/* Initializes a xfs_parent_name_rec to be stored as an attribute name. */
+static inline void
+xfs_init_parent_name_rec(
+	struct xfs_parent_name_rec	*rec,
+	const struct xfs_inode		*dp,
+	const struct xfs_name		*name,
+	struct xfs_inode		*ip)
+{
+	rec->p_ino = cpu_to_be64(dp->i_ino);
+	rec->p_gen = cpu_to_be32(VFS_IC(dp)->i_generation);
+	rec->p_namehash = cpu_to_be32(xfs_dir2_hashname(dp->i_mount, name));
+}
+
+/* Point the da args value fields at the non-key parts of a parent pointer. */
+static inline void
+xfs_init_parent_davalue(
+	struct xfs_da_args		*args,
+	const struct xfs_name		*name)
+{
+	args->valuelen = name->len;
+	args->value = (void *)name->name;
+}
+
+/*
+ * Allocate memory to control a logged parent pointer update as part of a
+ * dirent operation.
+ */
+int
+xfs_parent_args_alloc(
+	struct xfs_mount		*mp,
+	struct xfs_parent_args		**ppargsp)
+{
+	struct xfs_parent_args		*ppargs;
+
+	ppargs = kmem_cache_zalloc(xfs_parent_args_cache, GFP_KERNEL);
+	if (!ppargs)
+		return -ENOMEM;
+
+	xfs_parent_args_init(mp, ppargs);
+	*ppargsp = ppargs;
+	return 0;
+}
+
+static inline xfs_dahash_t
+xfs_parent_hashname(
+	struct xfs_inode		*ip,
+	const struct xfs_parent_args	*ppargs)
+{
+	return xfs_da_hashname((const void *)&ppargs->rec,
+			sizeof(struct xfs_parent_name_rec));
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
+	struct xfs_da_args	*args = &ppargs->args;
+
+	if (XFS_IS_CORRUPT(tp->t_mountp,
+			!xfs_parent_valuecheck(tp->t_mountp, parent_name->name,
+					       parent_name->len)))
+		return -EFSCORRUPTED;
+
+	xfs_init_parent_name_rec(&ppargs->rec, dp, parent_name, child);
+	args->hashval = xfs_parent_hashname(dp, ppargs);
+
+	args->trans = tp;
+	args->dp = child;
+
+	xfs_init_parent_davalue(&ppargs->args, parent_name);
+
+	xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_SET);
+	return 0;
+}
+
+/* Free a parent pointer context object. */
+void
+xfs_parent_args_free(
+	struct xfs_mount	*mp,
+	struct xfs_parent_args	*ppargs)
+{
+	kmem_cache_free(xfs_parent_args_cache, ppargs);
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index fcfeddb645f6d..e2115a2b9648b 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -16,4 +16,79 @@ bool xfs_parent_hashcheck(struct xfs_mount *mp,
 		const struct xfs_parent_name_rec *rec, const void *value,
 		size_t valuelen);
 
-#endif /* __XFS_PARENT_H__ */
+extern struct kmem_cache	*xfs_parent_args_cache;
+
+/*
+ * Dynamically allocd structure used to wrap the needed data to pass around
+ * the defer ops machinery
+ */
+struct xfs_parent_args {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+int xfs_parent_args_alloc(struct xfs_mount *mp,
+		struct xfs_parent_args **ppargsp);
+
+/*
+ * Initialize the parent pointer arguments structure.  Caller must have zeroed
+ * the contents.
+ */
+static inline void
+xfs_parent_args_init(
+	struct xfs_mount		*mp,
+	struct xfs_parent_args		*ppargs)
+{
+	ppargs->args.geo = mp->m_attr_geo;
+	ppargs->args.whichfork = XFS_ATTR_FORK;
+	ppargs->args.attr_filter = XFS_ATTR_PARENT;
+	ppargs->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED |
+				XFS_DA_OP_NVLOOKUP;
+	ppargs->args.name = (const uint8_t *)&ppargs->rec;
+	ppargs->args.namelen = sizeof(struct xfs_parent_name_rec);
+}
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
+	*ppargsp = NULL;
+
+	if (xfs_has_parent(mp))
+		return xfs_parent_args_alloc(mp, ppargsp);
+	return 0;
+}
+
+int xfs_parent_addname(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		struct xfs_inode *child);
+
+/* Schedule a parent pointer addition. */
+static inline int
+xfs_parent_add(struct xfs_trans *tp, struct xfs_parent_args *ppargs,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		struct xfs_inode *child)
+{
+	if (ppargs)
+		return xfs_parent_addname(tp, ppargs, dp, parent_name, child);
+	return 0;
+}
+
+void xfs_parent_args_free(struct xfs_mount *mp, struct xfs_parent_args *ppargs);
+
+/* Finish a parent pointer update by freeing the context object. */
+static inline void
+xfs_parent_finish(
+	struct xfs_mount	*mp,
+	struct xfs_parent_args	*ppargs)
+{
+	if (ppargs)
+		xfs_parent_args_free(mp, ppargs);
+}
+
+#endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
new file mode 100644
index 0000000000000..90532c3fa2053
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
index 9640fc232c147..6cda87153b38c 100644
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
index 9e0f1d311118b..43d48f1e331de 100644
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
index f1f8f85f941eb..20aee9db1b43a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -40,6 +40,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
 #include "xfs_pnfs.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -1029,7 +1031,7 @@ xfs_dir_hook_del(
 int
 xfs_create(
 	struct mnt_idmap	*idmap,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -1041,7 +1043,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -1049,6 +1051,7 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	struct xfs_parent_args	*ppargs;
 
 	trace_xfs_create(dp, name);
 
@@ -1070,13 +1073,17 @@ xfs_create(
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
@@ -1092,7 +1099,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto out_parent;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1135,6 +1142,14 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	error = xfs_parent_add(tp, ppargs, dp, name, ip);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * Create ip with a reference from dp, and add '.' and '..' references
 	 * if it's a directory.
@@ -1167,6 +1182,7 @@ xfs_create(
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, ppargs);
 	return 0;
 
  out_trans_cancel:
@@ -1182,6 +1198,8 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+ out_parent:
+	xfs_parent_finish(mp, ppargs);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
@@ -3039,7 +3057,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-				   false, &tmpfile);
+			xfs_has_parent(dp->i_mount), &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d9277f7faf534..62b425129d11c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -158,6 +158,8 @@ xfs_create_need_xattr(
 	if (dir->i_sb->s_security)
 		return true;
 #endif
+	if (xfs_has_parent(XFS_I(dir)->i_mount))
+		return true;
 	return false;
 }
 
@@ -202,7 +204,18 @@ xfs_generic_create(
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
index e6e8e8fb17a19..e981c8b666a5d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -44,6 +44,7 @@
 #include "xfs_dahash_test.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_swapext_item.h"
+#include "xfs_parent.h"
 #include "scrub/stats.h"
 #include "scrub/rcbag_btree.h"
 
@@ -2209,8 +2210,16 @@ xfs_init_caches(void)
 	if (!xfs_sxi_cache)
 		goto out_destroy_sxd_cache;
 
+	xfs_parent_args_cache = kmem_cache_create("xfs_parent_args",
+					     sizeof(struct xfs_parent_args),
+					     0, 0, NULL);
+	if (!xfs_parent_args_cache)
+		goto out_destroy_sxi_cache;
+
 	return 0;
 
+ out_destroy_sxi_cache:
+	kmem_cache_destroy(xfs_sxi_cache);
  out_destroy_sxd_cache:
 	kmem_cache_destroy(xfs_sxd_cache);
  out_destroy_iul_cache:
@@ -2271,6 +2280,7 @@ xfs_destroy_caches(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_cache_destroy(xfs_parent_args_cache);
 	kmem_cache_destroy(xfs_sxd_cache);
 	kmem_cache_destroy(xfs_sxi_cache);
 	kmem_cache_destroy(xfs_iunlink_cache);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 2339e3fcfb384..12405e4a70c1b 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -27,7 +27,7 @@
  * they must release the permission by calling xlog_drop_incompat_feat
  * when they're done.
  */
-static inline int
+int
 xfs_attr_grab_log_assist(
 	struct xfs_mount	*mp)
 {
@@ -79,7 +79,7 @@ xfs_attr_grab_log_assist(
 	return error;
 }
 
-static inline void
+void
 xfs_attr_rele_log_assist(
 	struct xfs_mount	*mp)
 {
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index cec766cad26cd..f097002d06571 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -7,6 +7,8 @@
 #define __XFS_XATTR_H__
 
 int xfs_attr_change(struct xfs_da_args *args);
+int xfs_attr_grab_log_assist(struct xfs_mount *mp);
+void xfs_attr_rele_log_assist(struct xfs_mount *mp);
 
 extern const struct xattr_handler * const xfs_xattr_handlers[];
 

