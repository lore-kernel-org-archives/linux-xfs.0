Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A5D59B45
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798214; cv=none; b=g9jdbGaxJ9CY0+J5moOz5SL1dbkZpEx21jzop9B8NdPxcR9osSox2RpfUdFlO9CfhLTOoCDF+Jst1PyQQyZO/3ULmlnSDeTPMSk0BhzkMGtlao2B5twmjmVMwnuvOZc8p82bc4xwamurv6m7DbSxjmLn8JhG5xoyvbyHZTh9d0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798214; c=relaxed/simple;
	bh=a0puYSIHmT9Quiw89tnOKPLIu7W/+kU8aJO0npDGabU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d0cFfvdGzWWqTx6WebwjIKgNABp/3/XCj9Wr/SRIfUOLXnr+9cB85PuTLe2PlsU41m0fywEt2gCIhJDEWM0244sO4X0aJxIAK6pu4nhTpYGnp2juZEN5U6AF0C6TuzSbNohbxgYIzOvffpzj0M8DiwyppzNkvMxzNdNRIRZCRfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/xRCrHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/xRCrHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55354C433C7;
	Mon, 18 Mar 2024 21:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798214;
	bh=a0puYSIHmT9Quiw89tnOKPLIu7W/+kU8aJO0npDGabU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F/xRCrHhjfGScopUKpRoTIwdsbKjF33/+0lorwAiK8XLwOSP0FOQf8aWV1LxJLrls
	 zvRknfmwfXwX8//L4XyLjfHB6MgbpgW72iuYAOE2YN3yf0Kzs2/I8xslDchz4xHV3L
	 8+XcKsi/64Gi5IGkdpy5jod+wG6Adrk0H/cNpl9urI7GFw+0uZhMzmhGwvSZtcxkwH
	 3CeF+umeleICEO/dDAjngBODnl63AdADnP792E3jqsijSgy+SL7Ur2uQGd5MTaWMHC
	 5k/+ighA+bDGeNsE0RfB18jPHSX42mBUriMmAKq1ZrTuQoSE/zof/iace33y0zOwx/
	 pzij0Qf7B9FrA==
Date: Mon, 18 Mar 2024 14:43:33 -0700
Subject: [PATCH 06/23] xfs: parent pointer attribute creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079801970.3806377.394636363692581136.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_xattr.c              |    2 -
 fs/xfs/xfs_xattr.h              |    2 +
 13 files changed, 279 insertions(+), 16 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_trans_space.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 3ab23c9a52c59..1861deef6f005 100644
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
index 4bfc11ffd081c..1c1ac2232dfad 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -898,7 +898,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static void
+void
 xfs_attr_defer_add(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags)
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index d2165c85f16b9..b643d005a158b 100644
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
index 6862e65fe67f1..c486a8070c0f6 100644
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
index ab177f82b4302..96b05ef2548ab 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -40,6 +40,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
 #include "xfs_pnfs.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -1038,7 +1040,7 @@ xfs_dir_hook_setup(
 int
 xfs_create(
 	struct mnt_idmap	*idmap,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -1050,7 +1052,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -1058,6 +1060,7 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	struct xfs_parent_args	*ppargs;
 
 	trace_xfs_create(dp, name);
 
@@ -1079,13 +1082,17 @@ xfs_create(
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
@@ -1101,7 +1108,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto out_parent;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1144,6 +1151,14 @@ xfs_create(
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
@@ -1176,6 +1191,7 @@ xfs_create(
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, ppargs);
 	return 0;
 
  out_trans_cancel:
@@ -1191,6 +1207,8 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+ out_parent:
+	xfs_parent_finish(mp, ppargs);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
@@ -3048,7 +3066,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-				   false, &tmpfile);
+			xfs_has_parent(dp->i_mount), &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e3d6a5d04ae38..cf94d1cd5a977 100644
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
index 0d210b0a87908..66930ef4ad8cd 100644
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
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index f9b7078cbbb57..a12cfc4d345ee 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -24,7 +24,7 @@
  * Get permission to use log-assisted atomic exchange of file extents.
  * Callers must not be running any transactions or hold any ILOCKs.
  */
-static inline int
+int
 xfs_attr_grab_log_assist(
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
 

