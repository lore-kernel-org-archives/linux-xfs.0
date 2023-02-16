Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688CDC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBPUrw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBPUrv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:47:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4E130D8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:47:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81B2760C1A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1798C433EF;
        Thu, 16 Feb 2023 20:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580467;
        bh=RnfOfp+hOQa5m14Ip/aDbVcURNOTxVrGomcSqDyv018=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=LSeWjJZ1SM1dAj+LeO6C/kg+WMUelI4WzVm0NxYyXvCR/ss2E1OD02lch3RpDZXrQ
         cvCARvAMN/aIYs4mYlSmyeCj+jIaxoQ/LnLuRq/rLeiQRm59o37rOEHFbB2l4dvQJV
         KTSru5O6f9walP1uW3NkWk5ahwyXTelPh5lbpATC2rkWh6ixLed7/hw5FhJWB66Ezj
         UFU2ALJORO5QKZsx43fqCxbbm5KH+W1RpoDk9x3rPKz/DwgmhnQtTycAb5NQzRFKEM
         hbHRPmkC1XLRQu4TpSJNNTYr3S3gqeiAg7WFc6K3Hyc6bfZ5LJyUz9HX7TTqKLA27f
         gqmFrY17Nq2WQ==
Date:   Thu, 16 Feb 2023 12:47:47 -0800
Subject: [PATCH 23/23] xfs: create an xattr iteration function for scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874163.3474338.15582091868253799271.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a streamlined function to walk a file's xattrs, without all the
cursor management stuff in the regular listxattr.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile          |    1 
 fs/xfs/scrub/listxattr.c |  314 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/listxattr.h |   17 ++
 3 files changed, 332 insertions(+)
 create mode 100644 fs/xfs/scrub/listxattr.c
 create mode 100644 fs/xfs/scrub/listxattr.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index f2f3ab589c04..6a30b145491d 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -160,6 +160,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   ialloc.o \
 				   inode.o \
 				   iscan.o \
+				   listxattr.o \
 				   parent.o \
 				   readdir.o \
 				   refcount.o \
diff --git a/fs/xfs/scrub/listxattr.c b/fs/xfs/scrub/listxattr.c
new file mode 100644
index 000000000000..94a76dee8a0a
--- /dev/null
+++ b/fs/xfs/scrub/listxattr.c
@@ -0,0 +1,314 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_attr_sf.h"
+#include "xfs_trans.h"
+#include "scrub/scrub.h"
+#include "scrub/bitmap.h"
+#include "scrub/listxattr.h"
+
+/* Call a function for every entry in a shortform xattr structure. */
+STATIC int
+xchk_xattr_walk_sf(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	xchk_xattr_fn			attr_fn,
+	void				*priv)
+{
+	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_entry	*sfe;
+	unsigned int			i;
+	int				error;
+
+	sf = (struct xfs_attr_shortform *)ip->i_af.if_u1.if_data;
+	for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
+		error = attr_fn(sc, ip, sfe->flags, sfe->nameval, sfe->namelen,
+				&sfe->nameval[sfe->namelen], sfe->valuelen,
+				priv);
+		if (error)
+			return error;
+
+		sfe = xfs_attr_sf_nextentry(sfe);
+	}
+
+	return 0;
+}
+
+/* Call a function for every entry in this xattr leaf block. */
+STATIC int
+xchk_xattr_walk_leaf_entries(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	xchk_xattr_fn			attr_fn,
+	struct xfs_buf			*bp,
+	void				*priv)
+{
+	struct xfs_attr3_icleaf_hdr	ichdr;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_attr_leafblock	*leaf = bp->b_addr;
+	struct xfs_attr_leaf_entry	*entry;
+	unsigned int			i;
+	int				error;
+
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
+	entry = xfs_attr3_leaf_entryp(leaf);
+
+	for (i = 0; i < ichdr.count; entry++, i++) {
+		void			*value;
+		unsigned char		*name;
+		unsigned int		namelen, valuelen;
+
+		if (entry->flags & XFS_ATTR_LOCAL) {
+			struct xfs_attr_leaf_name_local		*name_loc;
+
+			name_loc = xfs_attr3_leaf_name_local(leaf, i);
+			name = name_loc->nameval;
+			namelen = name_loc->namelen;
+			value = &name_loc->nameval[name_loc->namelen];
+			valuelen = be16_to_cpu(name_loc->valuelen);
+		} else {
+			struct xfs_attr_leaf_name_remote	*name_rmt;
+
+			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+			name = name_rmt->name;
+			namelen = name_rmt->namelen;
+			value = NULL;
+			valuelen = be32_to_cpu(name_rmt->valuelen);
+		}
+
+		error = attr_fn(sc, ip, entry->flags, name, namelen, value,
+				valuelen, priv);
+		if (error)
+			return error;
+
+	}
+
+	return 0;
+}
+
+/*
+ * Call a function for every entry in a leaf-format xattr structure.  Avoid
+ * memory allocations for the loop detector since there's only one block.
+ */
+STATIC int
+xchk_xattr_walk_leaf(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	xchk_xattr_fn			attr_fn,
+	void				*priv)
+{
+	struct xfs_buf			*leaf_bp;
+	int				error;
+
+	error = xfs_attr3_leaf_read(sc->tp, ip, 0, &leaf_bp);
+	if (error)
+		return error;
+
+	error = xchk_xattr_walk_leaf_entries(sc, ip, attr_fn, leaf_bp, priv);
+	xfs_trans_brelse(sc->tp, leaf_bp);
+	return error;
+}
+
+/* Find the leftmost leaf in the xattr dabtree. */
+STATIC int
+xchk_xattr_find_leftmost_leaf(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	struct xbitmap			*seen_blocks,
+	struct xfs_buf			**leaf_bpp)
+{
+	struct xfs_da3_icnode_hdr	nodehdr;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_trans		*tp = sc->tp;
+	struct xfs_da_intnode		*node;
+	struct xfs_da_node_entry	*btree;
+	struct xfs_buf			*bp;
+	//xfs_failaddr_t			fa;
+	xfs_dablk_t			blkno = 0;
+	unsigned int			expected_level = 0;
+	int				error;
+
+	for (;;) {
+		uint64_t		len;
+		uint16_t		magic;
+
+		error = xfs_da3_node_read(tp, ip, blkno, &bp, XFS_ATTR_FORK);
+		if (error)
+			return error;
+
+		node = bp->b_addr;
+		magic = be16_to_cpu(node->hdr.info.magic);
+		if (magic == XFS_ATTR_LEAF_MAGIC ||
+		    magic == XFS_ATTR3_LEAF_MAGIC)
+			break;
+
+		error = -EFSCORRUPTED;
+		if (magic != XFS_DA_NODE_MAGIC &&
+		    magic != XFS_DA3_NODE_MAGIC)
+			goto out_buf;
+
+#if 0
+		fa = xfs_da3_node_header_check(bp, ip->i_ino);
+		if (fa)
+			goto out_buf;
+#endif
+
+		xfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
+
+		if (nodehdr.count == 0 || nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
+			goto out_buf;
+
+		/* Check the level from the root node. */
+		if (blkno == 0)
+			expected_level = nodehdr.level - 1;
+		else if (expected_level != nodehdr.level)
+			goto out_buf;
+		else
+			expected_level--;
+
+		/* Remember that we've seen this node. */
+		error = xbitmap_set(seen_blocks, blkno, 1);
+		if (error)
+			goto out_buf;
+
+		/* Find the next level towards the leaves of the dabtree. */
+		btree = nodehdr.btree;
+		blkno = be32_to_cpu(btree->before);
+		xfs_trans_brelse(tp, bp);
+
+		/* Make sure we haven't seen this new block already. */
+		len = 1;
+		if (xbitmap_test(seen_blocks, blkno, &len))
+			return -EFSCORRUPTED;
+	}
+
+	error = -EFSCORRUPTED;
+#if 0
+	fa = xfs_attr3_leaf_header_check(bp, ip->i_ino);
+	if (fa)
+		goto out_buf;
+#endif
+
+	if (expected_level != 0)
+		goto out_buf;
+
+	/* Remember that we've seen this leaf. */
+	error = xbitmap_set(seen_blocks, blkno, 1);
+	if (error)
+		goto out_buf;
+
+	*leaf_bpp = bp;
+	return 0;
+
+out_buf:
+	xfs_trans_brelse(tp, bp);
+	return error;
+}
+
+/* Call a function for every entry in a node-format xattr structure. */
+STATIC int
+xchk_xattr_walk_node(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	xchk_xattr_fn			attr_fn,
+	void				*priv)
+{
+	struct xfs_attr3_icleaf_hdr	leafhdr;
+	struct xbitmap			seen_blocks;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_buf			*leaf_bp;
+	int				error;
+
+	xbitmap_init(&seen_blocks);
+
+	error = xchk_xattr_find_leftmost_leaf(sc, ip, &seen_blocks, &leaf_bp);
+	if (error)
+		goto out_bitmap;
+
+	for (;;) {
+		uint64_t	len;
+
+		error = xchk_xattr_walk_leaf_entries(sc, ip, attr_fn, leaf_bp,
+				priv);
+		if (error)
+			goto out_leaf;
+
+		/* Find the right sibling of this leaf block. */
+		leaf = leaf_bp->b_addr;
+		xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+		if (leafhdr.forw == 0)
+			goto out_leaf;
+
+		xfs_trans_brelse(sc->tp, leaf_bp);
+
+		/* Make sure we haven't seen this new leaf already. */
+		len = 1;
+		if (xbitmap_test(&seen_blocks, leafhdr.forw, &len))
+			goto out_bitmap;
+
+		error = xfs_attr3_leaf_read(sc->tp, ip,
+				leafhdr.forw, &leaf_bp);
+		if (error)
+			goto out_bitmap;
+
+		/* Remember that we've seen this new leaf. */
+		error = xbitmap_set(&seen_blocks, leafhdr.forw, 1);
+		if (error)
+			goto out_leaf;
+	}
+
+out_leaf:
+	xfs_trans_brelse(sc->tp, leaf_bp);
+out_bitmap:
+	xbitmap_destroy(&seen_blocks);
+	return error;
+}
+
+/*
+ * Call a function for every extended attribute in a file.
+ *
+ * Callers must hold the ILOCK.  No validation or cursor restarts allowed.
+ * Returns -EFSCORRUPTED on any problem, including loops in the dabtree.
+ */
+int
+xchk_xattr_walk(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	xchk_xattr_fn		attr_fn,
+	void			*priv)
+{
+	int			error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+
+	if (!xfs_inode_hasattr(ip))
+		return 0;
+
+	if (ip->i_af.if_format == XFS_DINODE_FMT_LOCAL)
+		return xchk_xattr_walk_sf(sc, ip, attr_fn, priv);
+
+	/* attr functions require that the attr fork is loaded */
+	error = xfs_iread_extents(sc->tp, ip, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
+	if (xfs_attr_is_leaf(ip))
+		return xchk_xattr_walk_leaf(sc, ip, attr_fn, priv);
+
+	return xchk_xattr_walk_node(sc, ip, attr_fn, priv);
+}
diff --git a/fs/xfs/scrub/listxattr.h b/fs/xfs/scrub/listxattr.h
new file mode 100644
index 000000000000..97af8ca23324
--- /dev/null
+++ b/fs/xfs/scrub/listxattr.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_LISTXATTR_H__
+#define __XFS_SCRUB_LISTXATTR_H__
+
+typedef int (*xchk_xattr_fn)(struct xfs_scrub *sc, struct xfs_inode *ip,
+		unsigned int attr_flags, const unsigned char *name,
+		unsigned int namelen, const void *value, unsigned int valuelen,
+		void *priv);
+
+int xchk_xattr_walk(struct xfs_scrub *sc, struct xfs_inode *ip,
+		xchk_xattr_fn attr_fn, void *priv);
+
+#endif /* __XFS_SCRUB_LISTXATTR_H__ */

