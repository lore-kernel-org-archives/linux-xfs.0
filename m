Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19402440C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300013; cv=none; b=WW92PzCjEzXaj4flrnO9R2E7l6oo0F0bOjU/06KEpUr7N528drC+SVb26XE5pvc7/xp98Vx/eCpsuwGhGbwqDkexBKoJhFIw63gVIO8gapwBpMFO6n3l8MXKGdVk9fHPLLxov4y765HTG89ihRGZIpqniQci/47HQHFGAF8bJdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300013; c=relaxed/simple;
	bh=rVIZ9njt6tLrVmGOQmvkHWdU84OCj/8M+qG5f3XnEdA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mjq8pLXctTpQLhXAjMjT8CjZw28QKbOwj/YqWqu0kcaQlmlMzVCImfbezqtOY7L/E5HsRaUl1IDf82WGwzXz6c94zURZG1WmQQLZX6SaPbm4V/sCOs8LAUvVQdKBuJvNaO6IlgIVeOfI0bBPBRLiZzvfcjd2e/iAqYe9BPr65M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6M0Z6d0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6M0Z6d0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F98C32786;
	Tue, 30 Jul 2024 00:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300013;
	bh=rVIZ9njt6tLrVmGOQmvkHWdU84OCj/8M+qG5f3XnEdA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J6M0Z6d0Wls3C3y7uAiFZLeRlNUjU3YbYR5eEPVVK9hfYNtz28fL8AkT2O6/u8dZg
	 gRNFiyg8N5QcIVgpE4TFPrhtmo+BlwfZvQ1+p0ybpowCOiF5PB5blZWFPtj+UeN5ir
	 55vIztFnBvoqtAaSB9KsDpQHH3ZQpGOye5SM4P/FTX+lCZquphYJFhaGpOUa7V3GVb
	 mfgpAxZ1HRYdT8PoEQmswaZ5FHqp38EaIVEwBMQJS2a99B0V0JZl8cmzaGdzZ07OFL
	 Ch1qjvJgM01q4IKUOAOcno7wzeTDw3cW+C27KdMoNr+CcxTmM0CMj4vrKEnMZUqQHr
	 Kyd9uuAg6QGdA==
Date: Mon, 29 Jul 2024 17:40:12 -0700
Subject: [PATCH 063/115] xfs: parent pointer attribute creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843330.1338752.4977268474558843321.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: b7c62d90c12c6cc86f10b8a62cefe0029374b6ff

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
 include/libxfs.h         |    1 +
 include/xfs_inode.h      |    6 ++++
 libxfs/Makefile          |    1 +
 libxfs/init.c            |    3 ++
 libxfs/libxfs_api_defs.h |    2 +
 libxfs/xfs_parent.c      |   68 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h      |   65 ++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_trans_space.c |   52 +++++++++++++++++++++++++++++++++++
 libxfs/xfs_trans_space.h |    9 +++---
 repair/phase6.c          |    8 +++--
 10 files changed, 207 insertions(+), 8 deletions(-)
 create mode 100644 libxfs/xfs_trans_space.c


diff --git a/include/libxfs.h b/include/libxfs.h
index fb8efb696..e760a46d8 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -90,6 +90,7 @@ struct iomap;
 #include "libxfs/xfile.h"
 #include "libxfs/buf_mem.h"
 #include "xfs_btree_mem.h"
+#include "xfs_parent.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 825708383..c6e4f84bd 100644
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
index 2a5cead9a..9fb53d9cc 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -113,6 +113,7 @@ CFILES = buf_mem.c \
 	xfs_symlink_remote.c \
 	xfs_trans_inode.c \
 	xfs_trans_resv.c \
+	xfs_trans_space.c \
 	xfs_types.c
 
 #
diff --git a/libxfs/init.c b/libxfs/init.c
index de91bbf3c..95de1e6d1 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -214,6 +214,8 @@ init_caches(void)
 			"xfs_extfree_item");
 	xfs_trans_cache = kmem_cache_init(
 			sizeof(struct xfs_trans), "xfs_trans");
+	xfs_parent_args_cache = kmem_cache_init(
+			sizeof(struct xfs_parent_args), "xfs_parent_args");
 }
 
 static int
@@ -231,6 +233,7 @@ destroy_caches(void)
 	xfs_btree_destroy_cur_caches();
 	leaked += kmem_cache_destroy(xfs_extfree_item_cache);
 	leaked += kmem_cache_destroy(xfs_trans_cache);
+	leaked += kmem_cache_destroy(xfs_parent_args_cache);
 
 	return leaked;
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 16f6513f6..9b44b7709 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -98,6 +98,7 @@
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
 #define xfs_cntbt_init_cursor		libxfs_cntbt_init_cursor
 #define xfs_compute_rextslog		libxfs_compute_rextslog
+#define xfs_create_space_res		libxfs_create_space_res
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
 #define xfs_da_get_buf			libxfs_da_get_buf
 #define xfs_da_hashname			libxfs_da_hashname
@@ -186,6 +187,7 @@
 #define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
 #define xfs_log_sb			libxfs_log_sb
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
+#define xfs_mkdir_space_res		libxfs_mkdir_space_res
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_hold			libxfs_perag_hold
 #define xfs_perag_put			libxfs_perag_put
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 7447acc2c..b0516c3f6 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -24,6 +24,10 @@
 #include "xfs_defer.h"
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
+#include "defer_item.h"
+#include "xfs_health.h"
+
+struct kmem_cache		*xfs_parent_args_cache;
 
 /*
  * Parent pointer attribute handling.
@@ -134,3 +138,67 @@ xfs_parent_hashattr(
 
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
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 6a4028871..6de24e3ef 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
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
diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
new file mode 100644
index 000000000..3408e700f
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
index 9640fc232..6cda87153 100644
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
index e6103f768..c4260fb91 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -927,7 +927,7 @@ mk_orphanage(xfs_mount_t *mp)
 	/*
 	 * could not be found, create it
 	 */
-	nres = XFS_MKDIR_SPACE_RES(mp, xname.len);
+	nres = libxfs_mkdir_space_res(mp, xname.len);
 	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir, nres, 0, 0, &tp);
 	if (i)
 		res_failed(i);
@@ -1343,7 +1343,7 @@ longform_dir2_rebuild(
 						p->name.name[1] == '.'))))
 			continue;
 
-		nres = XFS_CREATE_SPACE_RES(mp, p->name.len);
+		nres = libxfs_create_space_res(mp, p->name.len);
 		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_create,
 					    nres, 0, 0, &tp);
 		if (error)
@@ -2955,7 +2955,7 @@ _("error %d fixing shortform directory %llu\n"),
 
 		do_warn(_("recreating root directory .. entry\n"));
 
-		nres = XFS_MKDIR_SPACE_RES(mp, 2);
+		nres = libxfs_mkdir_space_res(mp, 2);
 		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
 					    nres, 0, 0, &tp);
 		if (error)
@@ -3010,7 +3010,7 @@ _("error %d fixing shortform directory %llu\n"),
 			do_warn(
 	_("creating missing \".\" entry in dir ino %" PRIu64 "\n"), ino);
 
-			nres = XFS_MKDIR_SPACE_RES(mp, 1);
+			nres = libxfs_mkdir_space_res(mp, 1);
 			error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
 						    nres, 0, 0, &tp);
 			if (error)

