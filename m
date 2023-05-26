Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E60FC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjEZCXN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjEZCXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:23:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843E1BC
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B29064C56
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682EEC433EF;
        Fri, 26 May 2023 02:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067789;
        bh=dKt0/xp3EEesq+x+wwdCRG70LI/cPKft3jZ6KYyyXDs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=vB6Q9ar3wG3L1fpoGP0Gb1Klx0N9HzJUuT9O3TVG30930ODz80jd/Rug+vaoi+b9z
         0+FgNwzxUhym+N1eBz7CV1JBUTGjd28XFdgT4I4kWyRpoV8gv27m8arktL7LGxsG2Q
         xPETvJL0TbMlouMC+e+jqi9N+wAZCG5RktkBXCeRi+yUHa6VJGX2ybZ1jxGN83CDY3
         ftqYHErzcmzLlSsCgInLlHkyOFSXAraeR5mNHYpqRJ6l1KU53dcYBlqC3KcsDMFFp2
         SZ8qNr2dwyYYPBwxyxJSHknWsFzldpqvTSPFZvc+gSEQZjs/dwPE4tCnaQSN/oQHeO
         g5dDGWXuYrP7Q==
Date:   Thu, 25 May 2023 19:23:08 -0700
Subject: [PATCH 05/30] xfs: parent pointer attribute creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077956.3749421.269466241552163473.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
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
 include/libxfs.h         |    1 
 include/xfs_inode.h      |    6 +++
 libxfs/Makefile          |    1 
 libxfs/init.c            |    3 +
 libxfs/libxfs_api_defs.h |    2 +
 libxfs/libxfs_priv.h     |    5 +-
 libxfs/xfs_attr.c        |    4 +-
 libxfs/xfs_attr.h        |    4 +-
 libxfs/xfs_parent.c      |  102 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h      |   41 ++++++++++++++++++
 libxfs/xfs_trans_space.c |   52 +++++++++++++++++++++++
 libxfs/xfs_trans_space.h |    9 ++--
 repair/phase6.c          |    8 ++--
 13 files changed, 224 insertions(+), 14 deletions(-)
 create mode 100644 libxfs/xfs_trans_space.c


diff --git a/include/libxfs.h b/include/libxfs.h
index 3b0f320f4f6..251a52d84ee 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -83,6 +83,7 @@ struct iomap;
 #include "xfs_btree_staging.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_ag_resv.h"
+#include "xfs_parent.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 5f6aabe7d4e..7ab3c53e1bf 100644
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
diff --git a/libxfs/Makefile b/libxfs/Makefile
index a12f43da149..f6c7c5c010e 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -111,6 +111,7 @@ CFILES = cache.c \
 	xfs_symlink_remote.c \
 	xfs_trans_inode.c \
 	xfs_trans_resv.c \
+	xfs_trans_space.c \
 	xfs_types.c
 
 #
diff --git a/libxfs/init.c b/libxfs/init.c
index 14a3fdb61ac..26b578134c7 100644
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
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 8360934b784..1e2cfa0ec22 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -87,6 +87,7 @@
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_bwrite			libxfs_bwrite
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
+#define xfs_create_space_res		libxfs_create_space_res
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
 #define xfs_da_get_buf			libxfs_da_get_buf
 #define xfs_da_hashname			libxfs_da_hashname
@@ -172,6 +173,7 @@
 #define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
 #define xfs_log_sb			libxfs_log_sb
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
+#define xfs_mkdir_space_res		libxfs_mkdir_space_res
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_put			libxfs_perag_put
 #define xfs_prealloc_blocks		libxfs_prealloc_blocks
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 2690431772d..ff94c5c7350 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -639,8 +639,9 @@ int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 /* xfs_log.c */
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 void xfs_log_item_init(struct xfs_mount *, struct xfs_log_item *, int);
-#define xfs_attr_use_log_assist(mp)	(0)
-#define xlog_drop_incompat_feat(log)	do { } while (0)
+#define xfs_attr_grab_log_assist(mp)	(0)
+#define xfs_attr_rele_log_assist(mp)	((void) 0)
+#define xlog_drop_incompat_feat(log,w)	do { } while (0)
 #define xfs_log_in_recovery(mp)		(false)
 
 /* xfs_icache.c */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index ba880fb8575..eb32db32b65 100644
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
index d2165c85f16..d77c132ff54 100644
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
index 583607c1301..88188d282e6 100644
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
@@ -90,3 +93,102 @@ xfs_parent_valuecheck(
 
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
+	xlog_drop_incompat_feat(mp->m_log, XLOG_INCOMPAT_FEAT_XATTRS);
+	kmem_cache_free(xfs_parent_intent_cache, parent);
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 6e2a2528d2d..43551956508 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -13,4 +13,43 @@ bool xfs_parent_namecheck(struct xfs_mount *mp,
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
index 3076378a730..4b49dcaa454 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -908,7 +908,7 @@ mk_orphanage(xfs_mount_t *mp)
 	/*
 	 * could not be found, create it
 	 */
-	nres = XFS_MKDIR_SPACE_RES(mp, xname.len);
+	nres = libxfs_mkdir_space_res(mp, xname.len);
 	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir, nres, 0, 0, &tp);
 	if (i)
 		res_failed(i);
@@ -1319,7 +1319,7 @@ longform_dir2_rebuild(
 						p->name.name[1] == '.'))))
 			continue;
 
-		nres = XFS_CREATE_SPACE_RES(mp, p->name.len);
+		nres = libxfs_create_space_res(mp, p->name.len);
 		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_create,
 					    nres, 0, 0, &tp);
 		if (error)
@@ -2931,7 +2931,7 @@ _("error %d fixing shortform directory %llu\n"),
 
 		do_warn(_("recreating root directory .. entry\n"));
 
-		nres = XFS_MKDIR_SPACE_RES(mp, 2);
+		nres = libxfs_mkdir_space_res(mp, 2);
 		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
 					    nres, 0, 0, &tp);
 		if (error)
@@ -2986,7 +2986,7 @@ _("error %d fixing shortform directory %llu\n"),
 			do_warn(
 	_("creating missing \".\" entry in dir ino %" PRIu64 "\n"), ino);
 
-			nres = XFS_MKDIR_SPACE_RES(mp, 1);
+			nres = libxfs_mkdir_space_res(mp, 1);
 			error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_mkdir,
 						    nres, 0, 0, &tp);
 			if (error)

