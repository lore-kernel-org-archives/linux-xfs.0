Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED2B621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710677; cv=none; b=N1axBI9uvxdXMvS/sr77eX5lbkanM3wlkYm7vo97jMPCc/tEMBuAouC5hUyPOq9uKfP4LiaJUmcacNiMXxz4csNMy8txGy+6Lp3zRZatPbhJ+mWDRKCGkPncOi25meCR8apvsnhRtiATTksJ0SmUG/fYyHCgmIMHpaibLSAXTr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710677; c=relaxed/simple;
	bh=FzRj/BgfAuXLdYEUmIbdVnWsmK30dbtXmV3ZDIGhsTQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RaTyuv8FKGikiaRydyx75HW7UhoPilGKX0fcKFW1JkvnI8O3keFo5GPQvLbNaGwBDhzElTFq75NnF+WTb/lPN1ipTqHMntB3G5HGBzdJxpr/tuFPOigeWUtUq9+d4KN1gADLg2ciCBWGhntb5T5jJVmThxYHtNbpzEMqfOucGY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1X8PLhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1X8PLhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2237AC433C7;
	Wed, 10 Apr 2024 00:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710677;
	bh=FzRj/BgfAuXLdYEUmIbdVnWsmK30dbtXmV3ZDIGhsTQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d1X8PLhU3YEyZvWkks9xf97J4iscrnywA0gO7Vt2sNefuEFg1VRkiJxZO0Fijg52R
	 duGAOGWudywCKJsMFX7JisgCXybPmgiThX+ZaFRZmJ2tDLbedmvmFrEi3TfEKVFhfd
	 gbeQ6ymtyla7szloJ/cC5xwXrdQxxPHbFXOAD3VStBIjgH6AaUKrHxqGUTVB5QAjvK
	 0W7ncYgRcXme/ec3y7mKDEahwOdYVyF8Edx1WFCg3pf7PvgtVF044hR4m++/99apou
	 oszqQvs0tcrW4Xuh0Bw49px6pHDvxgdPIplWw14LqsmE8RlyBjeCcoglaMS/P6GUfp
	 IKoLLeNXUDF+g==
Date: Tue, 09 Apr 2024 17:57:56 -0700
Subject: [PATCH 17/32] xfs: parent pointer attribute creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>, catherine.hoang@oracle.com,
 hch@lst.de, allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171270969840.3631889.8747832684298773440.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile                 |    1 +
 fs/xfs/libxfs/xfs_parent.c      |   68 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |   65 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_space.c |   52 ++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    9 +++--
 fs/xfs/scrub/tempfile.c         |    2 +
 fs/xfs/xfs_inode.c              |   32 +++++++++++++++---
 fs/xfs/xfs_iops.c               |   15 ++++++++-
 fs/xfs/xfs_super.c              |   10 ++++++
 fs/xfs/xfs_xattr.c              |    2 +
 fs/xfs/xfs_xattr.h              |    2 +
 11 files changed, 245 insertions(+), 13 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_trans_space.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 4956ea9a307b8..0c1a0b67af93c 100644
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
index d24104821a090..8875b4790112e 100644
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
@@ -139,3 +143,67 @@ xfs_parent_hashattr(
 
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
+	xfs_attr_defer_parent(&ppargs->args, XFS_ATTR_DEFER_SET);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 6a4028871b72a..6de24e3ef318c 100644
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
index 6f39504a216ea..ddbcccb3dba13 100644
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
index c079114b97ecf..ebef2767a86bd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -40,6 +40,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
 #include "xfs_pnfs.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -1016,7 +1018,7 @@ xfs_dir_hook_setup(
 int
 xfs_create(
 	struct mnt_idmap	*idmap,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -1028,7 +1030,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -1036,6 +1038,7 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	struct xfs_parent_args	*ppargs;
 
 	trace_xfs_create(dp, name);
 
@@ -1057,13 +1060,17 @@ xfs_create(
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
@@ -1079,7 +1086,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto out_parent;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1122,6 +1129,16 @@ xfs_create(
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
@@ -1154,6 +1171,7 @@ xfs_create(
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, ppargs);
 	return 0;
 
  out_trans_cancel:
@@ -1169,6 +1187,8 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+ out_parent:
+	xfs_parent_finish(mp, ppargs);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
@@ -3037,7 +3057,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(idmap, dp, S_IFCHR | WHITEOUT_MODE,
-				   false, &tmpfile);
+			xfs_has_parent(dp->i_mount), &tmpfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 273bc30fd2bad..a363af4d0bead 100644
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
index 5c9ba974252d1..84f37e8474da2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -44,6 +44,7 @@
 #include "xfs_dahash_test.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_exchmaps_item.h"
+#include "xfs_parent.h"
 #include "scrub/stats.h"
 #include "scrub/rcbag_btree.h"
 
@@ -2202,8 +2203,16 @@ xfs_init_caches(void)
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
@@ -2264,6 +2273,7 @@ xfs_destroy_caches(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_cache_destroy(xfs_parent_args_cache);
 	kmem_cache_destroy(xfs_xmd_cache);
 	kmem_cache_destroy(xfs_xmi_cache);
 	kmem_cache_destroy(xfs_iunlink_cache);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 514179a8d2a7f..85e886ee20e03 100644
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
 

