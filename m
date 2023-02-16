Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B85C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjBPU40 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjBPU4Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:56:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238644E5C5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:56:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B214C60A55
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C11C433EF;
        Thu, 16 Feb 2023 20:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580983;
        bh=EnGRM37QchEM3xwB6ODimyMEf6Fvn1UIMqDjLRQ1I3g=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ZhuO2rb2icT2Nc7ZCxAJ8pcR7Je+pS+c93AGtIUD9bLjlufDONfO5Qqb/9fTg5QdO
         +UjWdGXmV//LIa4YMqjPJBfE2Lyx2zh4cv1YLTPXPYgdjVPJ6yUzveG1bD/cDpqaZ6
         v3k373CISXxuh/yF0W5fYo2VEwDezMI3w9bF4jyZszL+iyTwWlJFUwLXTdp0O+Cqmn
         34Q/MZgP6ur6aXDY6qjG+HSCuhrWUl61X8Lq6R1NOFSCdZ6xOoSpn7c/FXANbPsoDZ
         hxn8mFuuYOaByZ3W5o6/JOFayMF6EpkXCv2he3oYcHT2RcWuZ/1UIQ1WM7k2n6nsoB
         Rx0X15Kep6xrA==
Date:   Thu, 16 Feb 2023 12:56:22 -0800
Subject: [PATCH 11/25] xfsprogs: parent pointer attribute creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879051.3476112.8270420254403475829.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: bb5cfa7e0c8eff07c62b1a28e0a4ea1d2561e0bb

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
[djwong: sync with kernel code]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/Makefile        |    2 +
 libxfs/libxfs_priv.h   |    3 +
 libxfs/xfs_attr.c      |    4 +
 libxfs/xfs_attr.h      |    4 +
 libxfs/xfs_da_format.h |   12 ----
 libxfs/xfs_parent.c    |  140 ++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h    |   57 ++++++++++++++++++++
 7 files changed, 206 insertions(+), 16 deletions(-)
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h


diff --git a/libxfs/Makefile b/libxfs/Makefile
index 010ee68e..89d29dc9 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -45,6 +45,7 @@ HFILES = \
 	xfs_ialloc_btree.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
+	xfs_parent.h \
 	xfs_quota_defs.h \
 	xfs_refcount.h \
 	xfs_refcount_btree.h \
@@ -92,6 +93,7 @@ CFILES = cache.c \
 	xfs_inode_fork.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
+	xfs_parent.c \
 	xfs_refcount.c \
 	xfs_refcount_btree.c \
 	xfs_rmap.c \
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 9dec26f9..ad21a25d 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -614,7 +614,8 @@ int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 /* xfs_log.c */
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 void xfs_log_item_init(struct xfs_mount *, struct xfs_log_item *, int);
-#define xfs_attr_use_log_assist(mp)	(0)
+#define xfs_attr_grab_log_assist(mp)	(0)
+#define xfs_attr_rele_log_assist(mp)	((void) 0)
 #define xlog_drop_incompat_feat(log)	do { } while (0)
 #define xfs_log_in_recovery(mp)		(false)
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index d5f1f488..edf7e1ee 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -884,7 +884,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
+int
 xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
@@ -902,7 +902,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index b79dae78..0cf23f51 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -544,6 +544,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
+int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
@@ -552,7 +553,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-
+int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int op_flags,
+			 struct xfs_attr_intent  **attr);
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 75b13807..2db1cf97 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -826,16 +826,4 @@ struct xfs_parent_name_rec {
 	__be32  p_diroffset;
 };
 
-/*
- * incore version of the above, also contains name pointers so callers
- * can pass/obtain all the parent pointer information in a single structure
- */
-struct xfs_parent_name_irec {
-	xfs_ino_t		p_ino;
-	uint32_t		p_gen;
-	xfs_dir2_dataptr_t	p_diroffset;
-	const char		*p_name;
-	uint8_t			p_namelen;
-};
-
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
new file mode 100644
index 00000000..e0a59998
--- /dev/null
+++ b/libxfs/xfs_parent.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "libxfs_priv.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_trace.h"
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_da_format.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_parent.h"
+#include "xfs_da_format.h"
+#include "xfs_format.h"
+#include "xfs_trans_space.h"
+
+struct kmem_cache		*xfs_parent_intent_cache;
+
+/*
+ * Parent pointer attribute handling.
+ *
+ * Because the attribute value is a filename component, it will never be longer
+ * than 255 bytes. This means the attribute will always be a local format
+ * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
+ * always be larger than this (max is 75% of block size).
+ *
+ * Creating a new parent attribute will always create a new attribute - there
+ * should never, ever be an existing attribute in the tree for a new inode.
+ * ENOSPC behavior is problematic - creating the inode without the parent
+ * pointer is effectively a corruption, so we allow parent attribute creation
+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
+ * occurring.
+ */
+
+
+/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
+void
+xfs_init_parent_name_rec(
+	struct xfs_parent_name_rec	*rec,
+	struct xfs_inode		*ip,
+	uint32_t			p_diroffset)
+{
+	xfs_ino_t			p_ino = ip->i_ino;
+	uint32_t			p_gen = VFS_I(ip)->i_generation;
+
+	rec->p_ino = cpu_to_be64(p_ino);
+	rec->p_gen = cpu_to_be32(p_gen);
+	rec->p_diroffset = cpu_to_be32(p_diroffset);
+}
+
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
+	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
+	parent->args.name = (const uint8_t *)&parent->rec;
+	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+
+	*parentp = parent;
+	return 0;
+}
+
+int
+xfs_parent_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*parent,
+	struct xfs_inode	*dp,
+	struct xfs_name		*parent_name,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+
+	args->trans = tp;
+	args->dp = child;
+	if (parent_name) {
+		parent->args.value = (void *)parent_name->name;
+		parent->args.valuelen = parent_name->len;
+	}
+
+	return xfs_attr_defer_add(args);
+}
+
+void
+__xfs_parent_cancel(
+	xfs_mount_t		*mp,
+	struct xfs_parent_defer *parent)
+{
+	xlog_drop_incompat_feat(mp->m_log);
+	kmem_cache_free(xfs_parent_intent_cache, parent);
+}
+
+unsigned int
+xfs_pptr_calc_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	/*
+	 * Pptrs are always the first attr in an attr tree, and never larger
+	 * than a block
+	 */
+	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
+	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
+}
+
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
new file mode 100644
index 00000000..d5a8c8e5
--- /dev/null
+++ b/libxfs/xfs_parent.h
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
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
+/*
+ * Parent pointer attribute prototypes
+ */
+void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
+			      struct xfs_inode *ip,
+			      uint32_t p_diroffset);
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
+int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
+			 struct xfs_inode *dp, struct xfs_name *parent_name,
+			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
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
+unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
+				     unsigned int namelen);
+
+#endif	/* __XFS_PARENT_H__ */

