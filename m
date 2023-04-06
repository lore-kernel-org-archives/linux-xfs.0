Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96B1C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbjDFTdP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236539AbjDFTdM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09607EFA
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3310364B8F
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A585C433D2;
        Thu,  6 Apr 2023 19:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809588;
        bh=EYu0sEln4WjV99vC2pd2B0JekyTXENU71wVbzvNQCO8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=gCiHSDxdBvMIc9o58Rw4d08rpRD85hJDVwx6+/2cr3aq2G8Wt4LQsgWiu9gpLqkwK
         rr+LMO3zi/dwpJ2WyEmM2z4QKKgI9Nig/842zLTm1xe5LlCx+Mho/yYSIZcKI/WnYW
         Gk+y5xAA4t9s4DcFnWuKSzsycAle+Cw8Uby22a4MubIwgaiOf7vcD1m9r7cj5lKO6V
         Qh42aUD0Sirm+Nid82t2Dc7k7zFOAnz//W3gA2JDfP5RSnXIoqLtdPfYYZ3QJCYbnh
         CZYd1ckM0vhCOHhNHvQw0kaejobo/lYJkmUpheirOOyQYE319fI6k2lizY6LDgEi0F
         l1BQCtBRl0v7Q==
Date:   Thu, 06 Apr 2023 12:33:08 -0700
Subject: [PATCH 06/32] xfs: parent pointer attribute creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827636.616793.4228168136077769272.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
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
 include/libxfs.h     |    1 
 include/xfs_inode.h  |    6 +++
 libxfs/init.c        |    3 +
 libxfs/libxfs_priv.h |    3 +
 libxfs/xfs_attr.c    |    4 +-
 libxfs/xfs_attr.h    |    4 +-
 libxfs/xfs_parent.c  |  116 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h  |   44 +++++++++++++++++++
 8 files changed, 176 insertions(+), 5 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index b28781d19..cc57e8887 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -78,6 +78,7 @@ struct iomap;
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
+#include "xfs_parent.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index b0bba1094..74de05191 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -175,6 +175,12 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
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
diff --git a/libxfs/init.c b/libxfs/init.c
index fda36ba0f..59cd547d6 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -258,6 +258,8 @@ init_caches(void)
 			"xfs_extfree_item");
 	xfs_trans_cache = kmem_cache_init(
 			sizeof(struct xfs_trans), "xfs_trans");
+	xfs_parent_intent_cache = kmem_cache_init(
+			sizeof(struct xfs_parent_defer), "xfs_parent_defer");
 }
 
 static int
@@ -275,6 +277,7 @@ destroy_caches(void)
 	xfs_btree_destroy_cur_caches();
 	leaked += kmem_cache_destroy(xfs_extfree_item_cache);
 	leaked += kmem_cache_destroy(xfs_trans_cache);
+	leaked += kmem_cache_destroy(xfs_parent_intent_cache);
 
 	return leaked;
 }
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index db6c40131..ff027dbe3 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -616,7 +616,8 @@ int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 /* xfs_log.c */
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 void xfs_log_item_init(struct xfs_mount *, struct xfs_log_item *, int);
-#define xfs_attr_use_log_assist(mp)	(0)
+#define xfs_attr_grab_log_assist(mp)	(0)
+#define xfs_attr_rele_log_assist(mp)	((void) 0)
 #define xlog_drop_incompat_feat(log)	do { } while (0)
 #define xfs_log_in_recovery(mp)		(false)
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 809c285d4..4e1d9551a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -893,7 +893,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
+int
 xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
@@ -911,7 +911,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 13b65aaf3..1002e431b 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
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
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 583607c13..ca1c6eeaf 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -21,6 +21,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_attr_sf.h"
 #include "xfs_bmap.h"
 #include "xfs_parent.h"
@@ -28,6 +29,8 @@
 #include "xfs_format.h"
 #include "xfs_trans_space.h"
 
+struct kmem_cache		*xfs_parent_intent_cache;
+
 /*
  * Parent pointer attribute handling.
  *
@@ -90,3 +93,116 @@ xfs_parent_valuecheck(
 
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
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 6e2a2528d..8e7dbe22e 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
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

