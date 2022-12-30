Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0278C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbiLaADL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiLaADK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:03:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5BD1E3C3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:03:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BF3361CBB
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB34CC433D2;
        Sat, 31 Dec 2022 00:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444987;
        bh=p2y75++GYVzmd3sXx9zjIrN0V260Iq8Gkbou/hxe40I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k775SiCeu2omfdbEz3088hErPsJPcGmqeoiHtfwxkGOBAAdguVFFJlkSoewbCHHxn
         myV9CROQFPDtRQm1084G6ZzeYUHy0PA+Sk97WEj7p45vtLCcYgrZfPgiv6VNs4JeDW
         OUdvLD0pEMEKhQx+BNSUfPw64c79e35G0x9zY1k2rX+/BVZPnHwMnpkh6NyFocB2M5
         lnRXG9aVHS7RDntwQYC/7FCyQSBJ0UbWwBD0dTOsHMaVZP3u+9I2gJW0hUPRMMoprL
         PrHT+ylpBEoDIbVUKSU41XdVv1DsN2Md6qhQU3AI5k4ueMtgW1awKBAUhDDI7/MHam
         G49C7XlhPhjCA==
Subject: [PATCH 1/1] xfs: create an xattr iteration function for scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:26 -0800
Message-ID: <167243846612.700977.16498328804042684325.stgit@magnolia>
In-Reply-To: <167243846597.700977.16776611507583639102.stgit@magnolia>
References: <167243846597.700977.16776611507583639102.stgit@magnolia>
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
 fs/xfs/scrub/attr.c      |  114 ++++++-----------
 fs/xfs/scrub/listxattr.c |  306 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/listxattr.h |   16 ++
 4 files changed, 364 insertions(+), 73 deletions(-)
 create mode 100644 fs/xfs/scrub/listxattr.c
 create mode 100644 fs/xfs/scrub/listxattr.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e7a8a740318a..33b1ea3e6e6b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -162,6 +162,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   ialloc.o \
 				   inode.o \
 				   iscan.o \
+				   listxattr.o \
 				   nlinks.o \
 				   parent.o \
 				   readdir.o \
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index a1585862c625..971cb6dd7dc8 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -21,6 +21,7 @@
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
 #include "scrub/attr.h"
+#include "scrub/listxattr.h"
 #include "scrub/repair.h"
 
 /* Free the buffers linked from the xattr buffer. */
@@ -153,82 +154,72 @@ xchk_setup_xattr(
 
 /* Extended Attributes */
 
-struct xchk_xattr {
-	struct xfs_attr_list_context	context;
-	struct xfs_scrub		*sc;
-};
-
 /*
  * Check that an extended attribute key can be looked up by hash.
  *
- * We use the XFS attribute list iterator (i.e. xfs_attr_list_ilocked)
- * to call this function for every attribute key in an inode.  Once
- * we're here, we load the attribute value to see if any errors happen,
- * or if we get more or less data than we expected.
+ * We use the extended attribute walk helper to call this function for every
+ * attribute key in an inode.  Once we're here, we load the attribute value to
+ * see if any errors happen, or if we get more or less data than we expected.
  */
-static void
-xchk_xattr_listent(
-	struct xfs_attr_list_context	*context,
-	int				flags,
-	unsigned char			*name,
-	int				namelen,
-	int				valuelen)
+static int
+xchk_xattr_actor(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	void			*name,
+	unsigned int		namelen,
+	unsigned int		valuelen,
+	void			*priv)
 {
 	struct xfs_da_args		args = {
 		.op_flags		= XFS_DA_OP_NOTIME,
-		.attr_filter		= flags & XFS_ATTR_NSP_ONDISK_MASK,
-		.geo			= context->dp->i_mount->m_attr_geo,
+		.attr_filter		= attr_flags & XFS_ATTR_NSP_ONDISK_MASK,
+		.geo			= sc->mp->m_attr_geo,
 		.whichfork		= XFS_ATTR_FORK,
-		.dp			= context->dp,
+		.dp			= ip,
 		.name			= name,
 		.namelen		= namelen,
 		.hashval		= xfs_da_hashname(name, namelen),
-		.trans			= context->tp,
+		.trans			= sc->tp,
 		.valuelen		= valuelen,
-		.owner			= context->dp->i_ino,
+		.owner			= ip->i_ino,
 	};
 	struct xchk_xattr_buf		*ab;
-	struct xchk_xattr		*sx;
 	int				error = 0;
 
-	sx = container_of(context, struct xchk_xattr, context);
-	ab = sx->sc->buf;
+	ab = sc->buf;
 
-	if (xchk_should_terminate(sx->sc, &error)) {
-		context->seen_enough = error;
-		return;
-	}
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
-	if (flags & XFS_ATTR_INCOMPLETE) {
+	if (attr_flags & XFS_ATTR_INCOMPLETE) {
 		/* Incomplete attr key, just mark the inode for preening. */
-		xchk_ino_set_preen(sx->sc, context->dp->i_ino);
-		return;
+		xchk_ino_set_preen(sc, ip->i_ino);
+		return 0;
 	}
 
 	/* Only one namespace bit allowed. */
-	if (hweight32(flags & XFS_ATTR_NSP_ONDISK_MASK) > 1) {
-		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
-		goto fail_xref;
+	if (hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) > 1) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+		return -ECANCELED;
 	}
 
 	/* Does this name make sense? */
 	if (!xfs_attr_namecheck(name, namelen)) {
-		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
-		goto fail_xref;
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+		return -ECANCELED;
 	}
 
 	/*
-	 * Try to allocate enough memory to extrat the attr value.  If that
-	 * doesn't work, we overload the seen_enough variable to convey
-	 * the error message back to the main scrub function.
+	 * Try to allocate enough memory to extract the attr value.  If that
+	 * doesn't work, return -EDEADLOCK as a signal to try again with a
+	 * maximally sized buffer.
 	 */
-	error = xchk_setup_xattr_buf(sx->sc, valuelen);
+	error = xchk_setup_xattr_buf(sc, valuelen);
 	if (error == -ENOMEM)
 		error = -EDEADLOCK;
-	if (error) {
-		context->seen_enough = error;
-		return;
-	}
+	if (error)
+		return error;
 
 	args.value = ab->value;
 
@@ -236,16 +227,13 @@ xchk_xattr_listent(
 	/* ENODATA means the hash lookup failed and the attr is bad */
 	if (error == -ENODATA)
 		error = -EFSCORRUPTED;
-	if (!xchk_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
+	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, args.blkno,
 			&error))
-		goto fail_xref;
+		return error;
 	if (args.valuelen != valuelen)
-		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK,
-					     args.blkno);
-fail_xref:
-	if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		context->seen_enough = 1;
-	return;
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+
+	return 0;
 }
 
 /*
@@ -615,16 +603,6 @@ int
 xchk_xattr(
 	struct xfs_scrub		*sc)
 {
-	struct xchk_xattr		sx = {
-		.sc			= sc,
-		.context		= {
-			.dp		= sc->ip,
-			.tp		= sc->tp,
-			.resynch	= 1,
-			.put_listent	= xchk_xattr_listent,
-			.allow_incomplete = true,
-		},
-	};
 	xfs_dablk_t			last_checked = -1U;
 	int				error = 0;
 
@@ -653,12 +631,6 @@ xchk_xattr(
 	/*
 	 * Look up every xattr in this file by name and hash.
 	 *
-	 * Use the backend implementation of xfs_attr_list to call
-	 * xchk_xattr_listent on every attribute key in this inode.
-	 * In other words, we use the same iterator/callback mechanism
-	 * that listattr uses to scrub extended attributes, though in our
-	 * _listent function, we check the value of the attribute.
-	 *
 	 * The VFS only locks i_rwsem when modifying attrs, so keep all
 	 * three locks held because that's the only way to ensure we're
 	 * the only thread poking into the da btree.  We traverse the da
@@ -666,13 +638,9 @@ xchk_xattr(
 	 * iteration, which doesn't really follow the usual buffer
 	 * locking order.
 	 */
-	error = xfs_attr_list_ilocked(&sx.context);
+	error = xchk_xattr_walk(sc, sc->ip, xchk_xattr_actor, NULL);
 	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
 		return error;
 
-	/* Did our listent function try to return any errors? */
-	if (sx.context.seen_enough < 0)
-		return sx.context.seen_enough;
-
 	return 0;
 }
diff --git a/fs/xfs/scrub/listxattr.c b/fs/xfs/scrub/listxattr.c
new file mode 100644
index 000000000000..60f0ff9e2776
--- /dev/null
+++ b/fs/xfs/scrub/listxattr.c
@@ -0,0 +1,306 @@
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
+				sfe->valuelen, priv);
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
+		char			*name;
+		unsigned int		namelen, valuelen;
+
+		if (entry->flags & XFS_ATTR_LOCAL) {
+			struct xfs_attr_leaf_name_local		*name_loc;
+
+			name_loc = xfs_attr3_leaf_name_local(leaf, i);
+			name = name_loc->nameval;
+			namelen = name_loc->namelen;
+			valuelen = be16_to_cpu(name_loc->valuelen);
+		} else {
+			struct xfs_attr_leaf_name_remote	*name_rmt;
+
+			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+			name = name_rmt->name;
+			namelen = name_rmt->namelen;
+			valuelen = be32_to_cpu(name_rmt->valuelen);
+		}
+
+		error = attr_fn(sc, ip, entry->flags, name, namelen, valuelen,
+				priv);
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
+	error = xfs_attr3_leaf_read(sc->tp, ip, ip->i_ino, 0, &leaf_bp);
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
+	xfs_failaddr_t			fa;
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
+		fa = xfs_da3_node_header_check(bp, ip->i_ino);
+		if (fa)
+			goto out_buf;
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
+	fa = xfs_attr3_leaf_header_check(bp, ip->i_ino);
+	if (fa)
+		goto out_buf;
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
+		error = xfs_attr3_leaf_read(sc->tp, ip, ip->i_ino,
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
index 000000000000..3a94573caf86
--- /dev/null
+++ b/fs/xfs/scrub/listxattr.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_LISTXATTR_H__
+#define __XFS_SCRUB_LISTXATTR_H__
+
+typedef int (*xchk_xattr_fn)(struct xfs_scrub *sc, struct xfs_inode *ip,
+		unsigned int attr_flags, void *name, unsigned int namelen,
+		unsigned int valuelen, void *priv);
+
+int xchk_xattr_walk(struct xfs_scrub *sc, struct xfs_inode *ip,
+		xchk_xattr_fn attr_fn, void *priv);
+
+#endif /* __XFS_SCRUB_LISTXATTR_H__ */

