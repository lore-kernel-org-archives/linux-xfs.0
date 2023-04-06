Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47609C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239751AbjDFTWd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjDFTWc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:22:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AF9E78
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60E0464ADB
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EB3C433EF;
        Thu,  6 Apr 2023 19:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808949;
        bh=4p4z4ZDBMS8ikMAyTQ2fiF8wYrIx7AWhyuWzKyL6EzU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=T3qXcgQCm2hYSaMP5tIu+oO3R9ktFMY0zMl+bWEAnG2/HF68+uqCL3Dn6imK4CSN4
         Jy03kjt+/ZMk8ixolIvZHQCQrn+zmUHD6gaoXR+vAmNkAxonmkMcfuUb0pceo70L0V
         lNtZMVPOeUfN9a6mF4W4VBFzi0wjWVHyZ6SCy6gomB/Xgj7w5LaKUq/uoE0k8AFopX
         NRuhcEMYWxKdESlUa+SLKqB+b3FXBh6J1SY8Xp5182TXgD10BafXG0KsHqJjf0+i7k
         f3rpoOTnGQwkS4S33usVv2VbunD1IOMCgS9mBi1qcegie3uxDYuMBahgRuxqcg+8FZ
         pcSkZksgRRYdQ==
Date:   Thu, 06 Apr 2023 12:22:29 -0700
Subject: [PATCH 08/23] xfs: parent pointer attribute creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824772.615225.1226312025020883651.stgit@frogsfrogsfrogs>
In-Reply-To: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
References: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: shorten names, adjust to new format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c   |    4 +-
 fs/xfs/libxfs/xfs_attr.h   |    4 +-
 fs/xfs/libxfs/xfs_parent.c |  115 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |   44 ++++++++++++++++-
 fs/xfs/xfs_inode.c         |   57 +++++++++++++++++++---
 fs/xfs/xfs_inode.h         |    6 ++
 fs/xfs/xfs_super.c         |   10 ++++
 fs/xfs/xfs_xattr.c         |    4 +-
 fs/xfs/xfs_xattr.h         |    2 +
 9 files changed, 233 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c9c6c5d7e144..e2acd7ecdfcc 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -895,7 +895,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
+int
 xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
@@ -913,7 +913,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 13b65aaf3116..1002e431b728 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -549,6 +549,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
+int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
@@ -557,7 +558,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-
+int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int op_flags,
+			 struct xfs_attr_intent  **attr);
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 3d9f5051f87b..f57e1a201f17 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -28,6 +28,8 @@
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
 
+struct kmem_cache		*xfs_parent_intent_cache;
+
 /*
  * Parent pointer attribute handling.
  *
@@ -90,3 +92,116 @@ xfs_parent_valuecheck(
 
 	return true;
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
+__xfs_parent_init(
+	struct xfs_mount		*mp,
+	struct xfs_parent_defer		**parentp)
+{
+	struct xfs_parent_defer		*parent;
+	int				error;
+
+	error = xfs_attr_grab_log_assist(mp);
+	if (error)
+		return error;
+
+	parent = kmem_cache_zalloc(xfs_parent_intent_cache, GFP_KERNEL);
+	if (!parent) {
+		xfs_attr_rele_log_assist(mp);
+		return -ENOMEM;
+	}
+
+	/* init parent da_args */
+	parent->args.geo = mp->m_attr_geo;
+	parent->args.whichfork = XFS_ATTR_FORK;
+	parent->args.attr_filter = XFS_ATTR_PARENT;
+	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED |
+				XFS_DA_OP_NVLOOKUP;
+	parent->args.name = (const uint8_t *)&parent->rec;
+	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+
+	*parentp = parent;
+	return 0;
+}
+
+static inline xfs_dahash_t
+xfs_parent_hashname(
+	struct xfs_inode		*ip,
+	const struct xfs_parent_defer	*parent)
+{
+	return xfs_da_hashname((const void *)&parent->rec,
+			sizeof(struct xfs_parent_name_rec));
+}
+
+/* Add a parent pointer to reflect a dirent addition. */
+int
+xfs_parent_add(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*parent,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*parent_name,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, parent_name, child);
+	args->hashval = xfs_parent_hashname(dp, parent);
+
+	args->trans = tp;
+	args->dp = child;
+
+	xfs_init_parent_davalue(&parent->args, parent_name);
+
+	return xfs_attr_defer_add(args);
+}
+
+/* Cancel a parent pointer operation. */
+void
+__xfs_parent_cancel(
+	struct xfs_mount	*mp,
+	struct xfs_parent_defer	*parent)
+{
+	xlog_drop_incompat_feat(mp->m_log);
+	kmem_cache_free(xfs_parent_intent_cache, parent);
+}
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
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 6e2a2528d2d8..8e7dbe22e1f7 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -13,4 +13,46 @@ bool xfs_parent_namecheck(struct xfs_mount *mp,
 bool xfs_parent_valuecheck(struct xfs_mount *mp, const void *value,
 		size_t valuelen);
 
-#endif /* __XFS_PARENT_H__ */
+extern struct kmem_cache	*xfs_parent_intent_cache;
+
+/*
+ * Dynamically allocd structure used to wrap the needed data to pass around
+ * the defer ops machinery
+ */
+struct xfs_parent_defer {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+int __xfs_parent_init(struct xfs_mount *mp, struct xfs_parent_defer **parentp);
+
+static inline int
+xfs_parent_start(
+	struct xfs_mount	*mp,
+	struct xfs_parent_defer	**pp)
+{
+	*pp = NULL;
+
+	if (xfs_has_parent(mp))
+		return __xfs_parent_init(mp, pp);
+	return 0;
+}
+
+int xfs_parent_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		struct xfs_inode *child);
+void __xfs_parent_cancel(struct xfs_mount *mp, struct xfs_parent_defer *parent);
+
+static inline void
+xfs_parent_finish(
+	struct xfs_mount	*mp,
+	struct xfs_parent_defer	*p)
+{
+	if (p)
+		__xfs_parent_cancel(mp, p);
+}
+
+unsigned int xfs_parent_calc_space_res(struct xfs_mount *mp,
+		unsigned int namelen);
+
+#endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c8be00f20a6d..e079fa95ad2e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -37,6 +37,8 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -946,10 +948,32 @@ xfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
+static unsigned int
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
+static unsigned int
+xfs_mkdir_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	return xfs_create_space_res(mp, namelen);
+}
+
 int
 xfs_create(
 	struct mnt_idmap	*idmap,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -961,7 +985,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -969,6 +993,7 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	struct xfs_parent_defer	*parent;
 
 	trace_xfs_create(dp, name);
 
@@ -988,13 +1013,17 @@ xfs_create(
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
 
+	error = xfs_parent_start(mp, &parent);
+	if (error)
+		goto out_release_dquots;
+
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1010,7 +1039,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto out_parent;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1020,6 +1049,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
+	init_xattrs = init_xattrs || xfs_has_parent(mp);
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(idmap, tp, dp, ino, mode,
@@ -1034,8 +1064,7 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
 					resblks - XFS_IALLOC_SPACE_RES(mp));
@@ -1054,6 +1083,16 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (parent) {
+		error = xfs_parent_add(tp, parent, dp, name, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1079,6 +1118,8 @@ xfs_create(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return 0;
 
  out_trans_cancel:
@@ -1094,6 +1135,8 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+ out_parent:
+	xfs_parent_finish(mp, parent);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ee09aefa6088..a695bb2687ff 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -153,6 +153,12 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
 	return &ip->i_vnode;
 }
 
+/* convert from const xfs inode to vfs inode */
+static inline const struct inode *VFS_IC(const struct xfs_inode *ip)
+{
+	return &ip->i_vnode;
+}
+
 /*
  * For regular files we only update the on-disk filesize when actually
  * writing data back to disk.  Until then only the copy in the VFS inode
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4f814f9e12ab..95b906a14698 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -42,6 +42,7 @@
 #include "xfs_xattr.h"
 #include "xfs_iunlink_item.h"
 #include "xfs_dahash_test.h"
+#include "xfs_parent.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -2125,8 +2126,16 @@ xfs_init_caches(void)
 	if (!xfs_iunlink_cache)
 		goto out_destroy_attri_cache;
 
+	xfs_parent_intent_cache = kmem_cache_create("xfs_parent_intent",
+					     sizeof(struct xfs_parent_defer),
+					     0, 0, NULL);
+	if (!xfs_parent_intent_cache)
+		goto out_destroy_iul_cache;
+
 	return 0;
 
+ out_destroy_iul_cache:
+	kmem_cache_destroy(xfs_iunlink_cache);
  out_destroy_attri_cache:
 	kmem_cache_destroy(xfs_attri_cache);
  out_destroy_attrd_cache:
@@ -2181,6 +2190,7 @@ xfs_destroy_caches(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_cache_destroy(xfs_parent_intent_cache);
 	kmem_cache_destroy(xfs_iunlink_cache);
 	kmem_cache_destroy(xfs_attri_cache);
 	kmem_cache_destroy(xfs_attrd_cache);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 61779d92295f..ef5a635238e5 100644
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
@@ -61,7 +61,7 @@ xfs_attr_grab_log_assist(
 	return error;
 }
 
-static inline void
+void
 xfs_attr_rele_log_assist(
 	struct xfs_mount	*mp)
 {
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index 2b09133b1b9b..7e0a2f3bb7f8 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -7,6 +7,8 @@
 #define __XFS_XATTR_H__
 
 int xfs_attr_change(struct xfs_da_args *args);
+int xfs_attr_grab_log_assist(struct xfs_mount *mp);
+void xfs_attr_rele_log_assist(struct xfs_mount *mp);
 
 extern const struct xattr_handler *xfs_xattr_handlers[];
 

