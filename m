Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7E0C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjEZCKp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjEZCKo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:10:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408F2A3
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A854A6122B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183A2C433D2;
        Fri, 26 May 2023 02:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067041;
        bh=ZrRsLOfSxMZ++oKhudvo600/dTUR8h8l+tIcgxh7ZhU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=tSfxFToeGvQA5rm2Fv6PLGfrgihrImCMwiTucc9qXUfAFU1ptmI8BDq18uQFVO5BQ
         /8Wf52Fs+3ZMcnBPpLhT2+BQCotc8ysXidU9U2//WZAfUCM5Z2jApfZ21ak7pA/Ei8
         f+9I/tsdlaQPN3K07qGje45JAqoScj+3f/8Kkuy3GMf7ACeYVKPEeFF4x/1HQenUYx
         kDRmUnaWLYzKXWMJlG3HbtqBKnSuj4Rte7xGcRkPhYqYj92p2XcXU7ibxLJbU1hAuI
         PrNSeHzbID/iGn8vtR2QquVcHsn6ksDx+NrDKLIsKnlbX5ra9rDd0zCQX1+280Qy4L
         rDXzs6MQxPVKw==
Date:   Thu, 25 May 2023 19:10:40 -0700
Subject: [PATCH 03/18] xfs: add parent pointer validator functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072739.3744191.10744007520430343275.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
References: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile               |    1 
 fs/xfs/libxfs/xfs_attr.c      |   10 ++++
 fs/xfs/libxfs/xfs_attr.h      |    3 +
 fs/xfs/libxfs/xfs_da_format.h |    8 ++++
 fs/xfs/libxfs/xfs_parent.c    |   92 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h    |   16 +++++++
 fs/xfs/scrub/attr.c           |    2 -
 fs/xfs/xfs_attr_item.c        |   24 +++++++++--
 fs/xfs/xfs_attr_list.c        |   17 +++++---
 9 files changed, 161 insertions(+), 12 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ecc8120bff8b..3f2b9dfb1358 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -41,6 +41,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
 				   xfs_ag_resv.o \
+				   xfs_parent.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
 				   xfs_refcount.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e2bf7a37d1e0..0d381b3e828a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -26,6 +26,7 @@
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -1596,9 +1597,14 @@ xfs_attr_node_get(
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
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index bb1776b8a6ce..d2165c85f16b 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
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
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 62d75e0f3682..700c87743ae5 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -747,6 +747,14 @@ xfs_attr3_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
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
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..3d9f5051f87b
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022-2023 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log.h"
+#include "xfs_xattr.h"
+#include "xfs_parent.h"
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
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..6e2a2528d2d8
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.h
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
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 247517f7e69b..f213d745746f 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -206,7 +206,7 @@ xchk_xattr_actor(
 	}
 
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(sc->mp, name, namelen, attr_flags)) {
 		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
 		return -ECANCELED;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index e255b60ffe57..b9f639619fb3 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -27,6 +27,7 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attri_cache;
 struct kmem_cache		*xfs_attrd_cache;
@@ -644,7 +645,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
+				attrp->alfi_attr_filter))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -899,7 +901,8 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, name_len)) {
+	if (!xfs_attr_namecheck(mp, attr_name, name_len,
+				attri_formatp->alfi_attr_filter)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
 		return -EFSCORRUPTED;
@@ -916,7 +919,8 @@ xlog_recover_attri_commit_pass2(
 		}
 
 		attr_new_name = item->ri_buf[i].i_addr;
-		if (!xfs_attr_namecheck(attr_new_name, new_name_len)) {
+		if (!xfs_attr_namecheck(mp, attr_new_name, new_name_len,
+					attri_formatp->alfi_attr_filter)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[i].i_addr,
 					item->ri_buf[i].i_len);
@@ -934,6 +938,13 @@ xlog_recover_attri_commit_pass2(
 		}
 
 		attr_value = item->ri_buf[i].i_addr;
+		if ((attri_formatp->alfi_attr_filter & XFS_ATTR_PARENT) &&
+		    !xfs_parent_valuecheck(mp, attr_value, value_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
 		i++;
 	}
 
@@ -946,6 +957,13 @@ xlog_recover_attri_commit_pass2(
 		}
 
 		attr_new_value = item->ri_buf[i].i_addr;
+		if ((attri_formatp->alfi_attr_filter & XFS_ATTR_PARENT) &&
+		    !xfs_parent_valuecheck(mp, attr_new_value, new_value_len)) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					item->ri_buf[i].i_addr,
+					item->ri_buf[i].i_len);
+			return -EFSCORRUPTED;
+		}
 		i++;
 	}
 
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 24516f3ff2df..c86e5952c137 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -59,9 +59,13 @@ xfs_attr_shortform_list(
 	struct xfs_attr_sf_sort		*sbuf, *sbp;
 	struct xfs_attr_shortform	*sf;
 	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_mount		*mp;
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
+	ASSERT(context != NULL);
+	ASSERT(dp != NULL);
+	mp = dp->i_mount;
 	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
@@ -83,8 +87,9 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
-							       sfe->namelen))) {
+					   !xfs_attr_namecheck(mp, sfe->nameval,
+							       sfe->namelen,
+							       sfe->flags))) {
 				xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 				return -EFSCORRUPTED;
 			}
@@ -178,8 +183,9 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
-						       sbp->namelen))) {
+				   !xfs_attr_namecheck(mp, sbp->name,
+						       sbp->namelen,
+						       sbp->flags))) {
 			xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 			error = -EFSCORRUPTED;
 			goto out;
@@ -503,7 +509,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen))) {
+				   !xfs_attr_namecheck(mp, name, namelen,
+						       entry->flags))) {
 			xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
 		}

