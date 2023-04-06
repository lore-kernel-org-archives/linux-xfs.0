Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179AEC7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjDFTck (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDFTcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:32:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763B440DC
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1272C617E2
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75075C433EF;
        Thu,  6 Apr 2023 19:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809557;
        bh=HPsggvluFEi8fAv0FJlvgrOR4YBI0PulelDCTay81JI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=BX7SF2LU7dsPpJsErMbjewKIJ96/M6/Xjt+wvSkFVulFKZuiUuPQoVhyiPoSbnBe6
         WKSrJkmsMGWoauboZrF2HhbAD//HhGvYi21XpVPaUSvmqYoSjXJ72Rbee1f7pBuPX6
         CmalQDtbDRBUaAn6uBMj040xvc7P47YniLTJkY1OZZ5AikQhw0fQjufoD3FCg+na7f
         +yHqSQ4MJ6RuJh1n1FUhdylQpSVV6hdycNF4dmY7ytDGlkNNeZaBcUUyvzxSbeGXHs
         G/fN+wwBZrq4ag4FNL3PGFUGLOYv5RPfMrPQ7aPHijt5QEao/cRoo+JewtgY/rH+Wc
         HcCo1slUIO0cw==
Date:   Thu, 06 Apr 2023 12:32:37 -0700
Subject: [PATCH 04/32] xfs: add parent pointer validator functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827610.616793.3284991197002231123.stgit@frogsfrogsfrogs>
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

Attribute names of parent pointers are not strings.  So we need to
modify attr_namecheck to verify parent pointer records when the
XFS_ATTR_PARENT flag is set.  At the same time, we need to validate attr
values during log recovery if the xattr is really a parent pointer.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: move functions to xfs_parent.c, adjust for new disk format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/Makefile        |    2 +
 libxfs/xfs_attr.c      |   10 ++++-
 libxfs/xfs_attr.h      |    3 +-
 libxfs/xfs_da_format.h |    8 ++++
 libxfs/xfs_parent.c    |   92 ++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h    |   16 ++++++++
 repair/attr_repair.c   |   19 ++++++----
 7 files changed, 140 insertions(+), 10 deletions(-)
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h


diff --git a/libxfs/Makefile b/libxfs/Makefile
index 010ee68e2..89d29dc97 100644
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
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 13bc77f7c..809c285d4 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -24,6 +24,7 @@
 #include "xfs_quota_defs.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -1594,9 +1595,14 @@ xfs_attr_node_get(
 /* Returns true if the attribute entry name is valid. */
 bool
 xfs_attr_namecheck(
-	const void	*name,
-	size_t		length)
+	struct xfs_mount	*mp,
+	const void		*name,
+	size_t			length,
+	unsigned int		flags)
 {
+	if (flags & XFS_ATTR_PARENT)
+		return xfs_parent_namecheck(mp, name, length, flags);
+
 	/*
 	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
 	 * out, so use >= for the length check.
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index d543a6a01..13b65aaf3 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -552,7 +552,8 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
+		unsigned int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 40016eb08..7426f9052 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -731,6 +731,14 @@ xfs_attr3_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 	return &((char *)leafp)[be16_to_cpu(entries[idx].nameidx)];
 }
 
+static inline int
+xfs_attr3_leaf_flags(xfs_attr_leafblock_t *leafp, int idx)
+{
+	struct xfs_attr_leaf_entry *entries = xfs_attr3_leaf_entryp(leafp);
+
+	return entries[idx].flags;
+}
+
 static inline xfs_attr_leaf_name_remote_t *
 xfs_attr3_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 {
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
new file mode 100644
index 000000000..583607c13
--- /dev/null
+++ b/libxfs/xfs_parent.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022-2023 Oracle, Inc.
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
+#include "xfs_dir2.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_parent.h"
+#include "xfs_da_format.h"
+#include "xfs_format.h"
+#include "xfs_trans_space.h"
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
+/* Return true if parent pointer EA name is valid. */
+bool
+xfs_parent_namecheck(
+	struct xfs_mount			*mp,
+	const struct xfs_parent_name_rec	*rec,
+	size_t					reclen,
+	unsigned int				attr_flags)
+{
+	xfs_ino_t				p_ino;
+
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return false;
+
+	if (reclen != sizeof(struct xfs_parent_name_rec))
+		return false;
+
+	/* Only one namespace bit allowed. */
+	if (hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
+		return false;
+
+	p_ino = be64_to_cpu(rec->p_ino);
+	if (!xfs_verify_ino(mp, p_ino))
+		return false;
+
+	return true;
+}
+
+/* Return true if parent pointer EA value is valid. */
+bool
+xfs_parent_valuecheck(
+	struct xfs_mount		*mp,
+	const void			*value,
+	size_t				valuelen)
+{
+	if (valuelen == 0 || valuelen > XFS_PARENT_DIRENT_NAME_MAX_SIZE)
+		return false;
+
+	if (value == NULL)
+		return false;
+
+	/* Valid dirent name? */
+	if (!xfs_dir2_namecheck(value, valuelen))
+		return false;
+
+	return true;
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
new file mode 100644
index 000000000..6e2a2528d
--- /dev/null
+++ b/libxfs/xfs_parent.h
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022-2023 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+/* Metadata validators */
+bool xfs_parent_namecheck(struct xfs_mount *mp,
+		const struct xfs_parent_name_rec *rec, size_t reclen,
+		unsigned int attr_flags);
+bool xfs_parent_valuecheck(struct xfs_mount *mp, const void *value,
+		size_t valuelen);
+
+#endif /* __XFS_PARENT_H__ */
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index c3a6d5026..afe8073ca 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -293,8 +293,9 @@ process_shortform_attr(
 		}
 
 		/* namecheck checks for null chars in attr names. */
-		if (!libxfs_attr_namecheck(currententry->nameval,
-					   currententry->namelen)) {
+		if (!libxfs_attr_namecheck(mp, currententry->nameval,
+					   currententry->namelen,
+					   currententry->flags)) {
 			do_warn(
 	_("entry contains illegal character in shortform attribute name\n"));
 			junkit = 1;
@@ -454,12 +455,14 @@ process_leaf_attr_local(
 	xfs_dablk_t		da_bno,
 	xfs_ino_t		ino)
 {
-	xfs_attr_leaf_name_local_t *local;
+	xfs_attr_leaf_name_local_t	*local;
+	int				flags;
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
+	flags = xfs_attr3_leaf_flags(leaf, i);
 	if (local->namelen == 0 ||
-	    !libxfs_attr_namecheck(local->nameval,
-				   local->namelen)) {
+	    !libxfs_attr_namecheck(mp, local->nameval,
+				   local->namelen, flags)) {
 		do_warn(
 	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
 			i, da_bno, ino, local->namelen);
@@ -510,12 +513,14 @@ process_leaf_attr_remote(
 {
 	xfs_attr_leaf_name_remote_t *remotep;
 	char*			value;
+	int			flags;
 
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
+	flags = xfs_attr3_leaf_flags(leaf, i);
 
 	if (remotep->namelen == 0 ||
-	    !libxfs_attr_namecheck(remotep->name,
-				   remotep->namelen) ||
+	    !libxfs_attr_namecheck(mp, remotep->name,
+				   remotep->namelen, flags) ||
 	    be32_to_cpu(entry->hashval) !=
 			libxfs_da_hashname((unsigned char *)&remotep->name[0],
 					   remotep->namelen) ||

