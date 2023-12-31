Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444CBC147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgrZCqIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146B2C433C8;
	Sun, 31 Dec 2023 23:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063985;
	bh=Bt62LoT0gz4tWR1Iru05CGvHuJjuN0ykkvlQRrsUaos=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QgrZCqIhS78YTC87JTssVQyUSLwgWOHt7CbIpDoJWbqirnHvjARUXqutdKOvYfBsI
	 OFcfTTS7u+yO+GZrZPkR2xMGPaZe+wMo6f9f6T9uoy1t85fUq1saSrklkNpeBXxufr
	 OsA/BRRhAps6EjLyhLpX75WKUZxPJ/OvBxSiD5ALtF1428sb7hNZmYCuFc0d/pN72g
	 JSzehnfCRpyYF0Yy0edDlmM1HCJQHbRCBF5XS/jskDqT1RFsaboFJrRuiKkqisH+Pd
	 V7vfEHz57HKf//HtJmPNXkQn0dczLBYJsMaJd///avo+UMteugzk0/VOPoktJAkWSC
	 5Tl3FtFlaF6wg==
Date: Sun, 31 Dec 2023 15:06:24 -0800
Subject: [PATCH 05/32] xfs: parent pointer attribute creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Message-ID: <170405006169.1804688.18130227675090082383.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
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
 include/libxfs.h         |    1 +
 include/xfs_inode.h      |    6 +++
 libxfs/Makefile          |    1 +
 libxfs/init.c            |    3 ++
 libxfs/libxfs_api_defs.h |    2 +
 libxfs/libxfs_priv.h     |    5 ++-
 libxfs/xfs_attr.c        |    2 +
 libxfs/xfs_attr.h        |    2 +
 libxfs/xfs_parent.c      |   91 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h      |   77 ++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_trans_space.c |   52 ++++++++++++++++++++++++++
 libxfs/xfs_trans_space.h |    9 +++--
 repair/phase6.c          |    8 ++--
 13 files changed, 246 insertions(+), 13 deletions(-)
 create mode 100644 libxfs/xfs_trans_space.c


diff --git a/include/libxfs.h b/include/libxfs.h
index 77ecfda4bc7..425112b0693 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -87,6 +87,7 @@ struct iomap;
 #include "xfs_rtbitmap.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_ag_resv.h"
+#include "xfs_parent.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 47959314811..088a6b34f04 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -268,6 +268,12 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
 	return &ip->i_vnode;
 }
 
+/* convert from const xfs inode to const vfs inode */
+static inline const struct inode *VFS_IC(const struct xfs_inode *ip)
+{
+	return &ip->i_vnode;
+}
+
 /* We only have i_size in the xfs inode in userspace */
 static inline loff_t i_size_read(struct inode *inode)
 {
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 38594965882..e0bdaefb209 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -113,6 +113,7 @@ CFILES = cache.c \
 	xfs_symlink_remote.c \
 	xfs_trans_inode.c \
 	xfs_trans_resv.c \
+	xfs_trans_space.c \
 	xfs_types.c
 
 #
diff --git a/libxfs/init.c b/libxfs/init.c
index 2e59ba0d0a2..b6b1282201c 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -213,6 +213,8 @@ init_caches(void)
 			"xfs_extfree_item");
 	xfs_trans_cache = kmem_cache_init(
 			sizeof(struct xfs_trans), "xfs_trans");
+	xfs_parent_args_cache = kmem_cache_init(
+			sizeof(struct xfs_parent_args), "xfs_parent_args");
 }
 
 static int
@@ -230,6 +232,7 @@ destroy_caches(void)
 	xfs_btree_destroy_cur_caches();
 	leaked += kmem_cache_destroy(xfs_extfree_item_cache);
 	leaked += kmem_cache_destroy(xfs_trans_cache);
+	leaked += kmem_cache_destroy(xfs_parent_args_cache);
 
 	return leaked;
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index eba9a8386d2..6ab10be3ad6 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -89,6 +89,7 @@
 #define xfs_bwrite			libxfs_bwrite
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
 #define xfs_compute_rextslog		libxfs_compute_rextslog
+#define xfs_create_space_res		libxfs_create_space_res
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
 #define xfs_da_get_buf			libxfs_da_get_buf
 #define xfs_da_hashname			libxfs_da_hashname
@@ -175,6 +176,7 @@
 #define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
 #define xfs_log_sb			libxfs_log_sb
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
+#define xfs_mkdir_space_res		libxfs_mkdir_space_res
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_hold			libxfs_perag_hold
 #define xfs_perag_put			libxfs_perag_put
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 411c33b3956..123e25d2f5e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -562,8 +562,9 @@ struct xfs_item_ops;
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 void xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *lip, int type,
 		const struct xfs_item_ops *ops);
-#define xfs_attr_use_log_assist(mp)	(0)
-#define xlog_drop_incompat_feat(log)	do { } while (0)
+#define xfs_attr_grab_log_assist(mp)	(0)
+#define xfs_attr_rele_log_assist(mp)	((void) 0)
+#define xlog_drop_incompat_feat(log,w)	do { } while (0)
 #define xfs_log_in_recovery(mp)		(false)
 
 /* xfs_icache.c */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 04561f0318a..c4f543db474 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -893,7 +893,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static void
+void
 xfs_attr_defer_add(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags)
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 5b3a0d4b158..4a4d45a96dd 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
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
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 6874d8afe23..32e1d1f62ec 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -29,6 +29,8 @@
 #include "xfs_format.h"
 #include "xfs_trans_space.h"
 
+struct kmem_cache		*xfs_parent_args_cache;
+
 /*
  * Parent pointer attribute handling.
  *
@@ -112,3 +114,92 @@ xfs_parent_hashcheck(
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
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index fcfeddb645f..e2115a2b964 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
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
diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
new file mode 100644
index 00000000000..3408e700f01
--- /dev/null
+++ b/libxfs/xfs_trans_space.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "libxfs_priv.h"
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
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 9640fc232c1..6cda87153b3 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
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
diff --git a/repair/phase6.c b/repair/phase6.c
index 75391378291..825f0cf3956 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -924,7 +924,7 @@ mk_orphanage(xfs_mount_t *mp)
 	/*
 	 * could not be found, create it
 	 */
-	nres = XFS_MKDIR_SPACE_RES(mp, xname.len);
+	nres = libxfs_mkdir_space_res(mp, xname.len);
 	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir, nres, 0, 0, &tp);
 	if (i)
 		res_failed(i);
@@ -1335,7 +1335,7 @@ longform_dir2_rebuild(
 						p->name.name[1] == '.'))))
 			continue;
 
-		nres = XFS_CREATE_SPACE_RES(mp, p->name.len);
+		nres = libxfs_create_space_res(mp, p->name.len);
 		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_create,
 					    nres, 0, 0, &tp);
 		if (error)
@@ -2947,7 +2947,7 @@ _("error %d fixing shortform directory %llu\n"),
 
 		do_warn(_("recreating root directory .. entry\n"));
 
-		nres = XFS_MKDIR_SPACE_RES(mp, 2);
+		nres = libxfs_mkdir_space_res(mp, 2);
 		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
 					    nres, 0, 0, &tp);
 		if (error)
@@ -3002,7 +3002,7 @@ _("error %d fixing shortform directory %llu\n"),
 			do_warn(
 	_("creating missing \".\" entry in dir ino %" PRIu64 "\n"), ino);
 
-			nres = XFS_MKDIR_SPACE_RES(mp, 1);
+			nres = libxfs_mkdir_space_res(mp, 1);
 			error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
 						    nres, 0, 0, &tp);
 			if (error)

