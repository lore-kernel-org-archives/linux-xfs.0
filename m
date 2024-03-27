Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D6163D0
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504981; cv=none; b=YaJrbOi0EvDOvaXTCDpYUO13gEQp2eBeagNFlzKQ4AdSKj1MHompGgEpYih7KrMnHllVdzq5JqClDjX+3jNinKDyhrR04TNnMLC1M2Y06PrIT7oaIC4NEh20nJZp/CqJ2+KwK5OOXSLR56K+mnlBp4HFM7XbrApXWvQzlgfKzfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504981; c=relaxed/simple;
	bh=95K3LCiAOBQkCNHc1PHrQpgNAdRxdwYtOX5/7q7T/hw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HPj4+zbHFMnJft1UJwUyEjpbDiGdNHzNG1Jn/1p7L5cZ4Lsf8a7P8S7JPQvQyAVGHZ4lxtrgQ9hYKR5T87PG9lJww94pNu/CSSMcthb5YRE7XxLrnYPI7NY2KYCXiCJBv15pbs+L0zQNKkgKQtWf5AksjzB9T2/XrtpSU1NJqqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JnRS/ox8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JnRS/ox8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AA5C433F1;
	Wed, 27 Mar 2024 02:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504981;
	bh=95K3LCiAOBQkCNHc1PHrQpgNAdRxdwYtOX5/7q7T/hw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JnRS/ox8765ur4toOSCJrHnOl5dtHX7e1nBd0LoWejs2o60F4TZR2kXkabxpqHMeU
	 Lf6TA2CcyY/SHwNxaVCa7bEoviAcGD+lE+R/WJTgQcxtZSMt5AsHFoGz83lByzoNnE
	 ZZ4N3hT9fHP4eHb5PIiWJxhk5ZQiToNqbkvpkgxLVLAJfKWV7WjYNL8icb8JhlnDR7
	 GcBUDExCl3LhKEKv6OZc5CmPnyfi0OBjCAs2saWKsJo4WlsYhzQICHm0soZU9v/G5t
	 SGnUY0aqV/++9LB0KTnVig/aIpOO0PYUyJuLhY6rptG8MsIRiNxsBR/isAz+W+GXVZ
	 0Y/zU8YnWMkFQ==
Date: Tue, 26 Mar 2024 19:03:00 -0700
Subject: [PATCH 7/7] xfs: create an xattr iteration function for scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150382786.3217666.9345698825963380599.stgit@frogsfrogsfrogs>
In-Reply-To: <171150382650.3217666.5736938027118830430.stgit@frogsfrogsfrogs>
References: <171150382650.3217666.5736938027118830430.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a streamlined function to walk a file's xattrs, without all the
cursor management stuff in the regular listxattr.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile           |    1 
 fs/xfs/scrub/attr.c       |  125 +++++++-----------
 fs/xfs/scrub/dab_bitmap.h |   37 +++++
 fs/xfs/scrub/listxattr.c  |  312 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/listxattr.h  |   17 ++
 5 files changed, 414 insertions(+), 78 deletions(-)
 create mode 100644 fs/xfs/scrub/dab_bitmap.h
 create mode 100644 fs/xfs/scrub/listxattr.c
 create mode 100644 fs/xfs/scrub/listxattr.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 8647629ac7bf9..7dbe6b3befb33 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -165,6 +165,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   ialloc.o \
 				   inode.o \
 				   iscan.o \
+				   listxattr.o \
 				   nlinks.o \
 				   parent.o \
 				   readdir.o \
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 696971204b876..8853e4d0eee3d 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -21,6 +21,7 @@
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
 #include "scrub/attr.h"
+#include "scrub/listxattr.h"
 #include "scrub/repair.h"
 
 /* Free the buffers linked from the xattr buffer. */
@@ -153,90 +154,81 @@ xchk_setup_xattr(
 
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
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
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
-	 * Local xattr values are stored in the attr leaf block, so we don't
-	 * need to retrieve the value from a remote block to detect corruption
-	 * problems.
+	 * Local and shortform xattr values are stored in the attr leaf block,
+	 * so we don't need to retrieve the value from a remote block to detect
+	 * corruption problems.
 	 */
-	if (flags & XFS_ATTR_LOCAL)
-		goto fail_xref;
+	if (value)
+		return 0;
 
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
 
@@ -244,16 +236,13 @@ xchk_xattr_listent(
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
@@ -618,16 +607,6 @@ int
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
 
@@ -656,12 +635,6 @@ xchk_xattr(
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
@@ -669,13 +642,9 @@ xchk_xattr(
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
diff --git a/fs/xfs/scrub/dab_bitmap.h b/fs/xfs/scrub/dab_bitmap.h
new file mode 100644
index 0000000000000..0c6e3aad43954
--- /dev/null
+++ b/fs/xfs/scrub/dab_bitmap.h
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_DAB_BITMAP_H__
+#define __XFS_SCRUB_DAB_BITMAP_H__
+
+/* Bitmaps, but for type-checked for xfs_dablk_t */
+
+struct xdab_bitmap {
+	struct xbitmap32	dabitmap;
+};
+
+static inline void xdab_bitmap_init(struct xdab_bitmap *bitmap)
+{
+	xbitmap32_init(&bitmap->dabitmap);
+}
+
+static inline void xdab_bitmap_destroy(struct xdab_bitmap *bitmap)
+{
+	xbitmap32_destroy(&bitmap->dabitmap);
+}
+
+static inline int xdab_bitmap_set(struct xdab_bitmap *bitmap,
+		xfs_dablk_t dabno, xfs_extlen_t len)
+{
+	return xbitmap32_set(&bitmap->dabitmap, dabno, len);
+}
+
+static inline bool xdab_bitmap_test(struct xdab_bitmap *bitmap,
+		xfs_dablk_t dabno, xfs_extlen_t *len)
+{
+	return xbitmap32_test(&bitmap->dabitmap, dabno, len);
+}
+
+#endif	/* __XFS_SCRUB_DAB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/listxattr.c b/fs/xfs/scrub/listxattr.c
new file mode 100644
index 0000000000000..cbe5911ecbbcf
--- /dev/null
+++ b/fs/xfs/scrub/listxattr.c
@@ -0,0 +1,312 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
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
+#include "scrub/dab_bitmap.h"
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
+	struct xfs_attr_sf_hdr		*hdr = ip->i_af.if_data;
+	struct xfs_attr_sf_entry	*sfe;
+	unsigned int			i;
+	int				error;
+
+	sfe = xfs_attr_sf_firstentry(hdr);
+	for (i = 0; i < hdr->count; i++) {
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
+	struct xdab_bitmap		*seen_dablks,
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
+		xfs_extlen_t		len = 1;
+		uint16_t		magic;
+
+		/* Make sure we haven't seen this new block already. */
+		if (xdab_bitmap_test(seen_dablks, blkno, &len))
+			return -EFSCORRUPTED;
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
+		error = xdab_bitmap_set(seen_dablks, blkno, 1);
+		if (error)
+			goto out_buf;
+
+		/* Find the next level towards the leaves of the dabtree. */
+		btree = nodehdr.btree;
+		blkno = be32_to_cpu(btree->before);
+		xfs_trans_brelse(tp, bp);
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
+	error = xdab_bitmap_set(seen_dablks, blkno, 1);
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
+	struct xdab_bitmap		seen_dablks;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_buf			*leaf_bp;
+	int				error;
+
+	xdab_bitmap_init(&seen_dablks);
+
+	error = xchk_xattr_find_leftmost_leaf(sc, ip, &seen_dablks, &leaf_bp);
+	if (error)
+		goto out_bitmap;
+
+	for (;;) {
+		xfs_extlen_t	len;
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
+		if (xdab_bitmap_test(&seen_dablks, leafhdr.forw, &len)) {
+			error = -EFSCORRUPTED;
+			goto out_bitmap;
+		}
+
+		error = xfs_attr3_leaf_read(sc->tp, ip, ip->i_ino,
+				leafhdr.forw, &leaf_bp);
+		if (error)
+			goto out_bitmap;
+
+		/* Remember that we've seen this new leaf. */
+		error = xdab_bitmap_set(&seen_dablks, leafhdr.forw, 1);
+		if (error)
+			goto out_leaf;
+	}
+
+out_leaf:
+	xfs_trans_brelse(sc->tp, leaf_bp);
+out_bitmap:
+	xdab_bitmap_destroy(&seen_dablks);
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
+	xfs_assert_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
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
index 0000000000000..48fe89d05946b
--- /dev/null
+++ b/fs/xfs/scrub/listxattr.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
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

