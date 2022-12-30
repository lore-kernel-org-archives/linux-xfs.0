Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BEF4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbiLaAAk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235668AbiLaAAi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:00:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EB116588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:00:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D32BCE19F4
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93147C433D2;
        Sat, 31 Dec 2022 00:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444831;
        bh=J2fHeeyNSVQdnFz+8Ti7HCF9zexGO+ndFPiO7EbALqc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SpuAQxlv7CL7miwNqhndlH3uTJxIYkGEse+3WuTHQEPczKH6nk5S8wXyZ8LI2F+jy
         kXBnfiypUXoEhSmoZrsvD3I/VBtKERRFbRsbgNdzgRZQaHU8xjz3Xa5312LBSudiUH
         bQXDQCGbIJhKpxm1r0hEet6QV50Fg49y4b9wl/ajIRtfYTuiOT7x+uhJa6viN7YpmY
         IZ6nWAhkSx5/V9qmJHTvv0aOr04tM1Ozx0xBG8PohQs5qnzA/kQ6jtBFEmmoS9w1kz
         +PpxKb6tXq/HCzOSzJeYbnbjoGZKhcIv94n5kDsF/kpNY2wIvp+ck4SDpwqCOv2eUi
         /yGwzCchmPuLg==
Subject: [PATCH 3/5] xfs: repair extended attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:13 -0800
Message-ID: <167243845312.700496.11725267957374968617.stgit@magnolia>
In-Reply-To: <167243845264.700496.9115810454468711427.stgit@magnolia>
References: <167243845264.700496.9115810454468711427.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the extended attributes look bad, try to sift through the rubble to
find whatever keys/values we can, stage a new attribute structure in a
temporary file and use the atomic extent swapping mechanism to commit
the results in bulk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile               |    1 
 fs/xfs/libxfs/xfs_attr.c      |    2 
 fs/xfs/libxfs/xfs_attr.h      |    2 
 fs/xfs/libxfs/xfs_da_format.h |    5 
 fs/xfs/scrub/attr.c           |   20 +
 fs/xfs/scrub/attr.h           |    7 
 fs/xfs/scrub/attr_repair.c    | 1158 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c         |   45 ++
 fs/xfs/scrub/repair.h         |    8 
 fs/xfs/scrub/scrub.c          |    2 
 fs/xfs/scrub/trace.h          |  105 ++++
 fs/xfs/scrub/xfarray.c        |   24 +
 fs/xfs/scrub/xfarray.h        |    2 
 fs/xfs/scrub/xfblob.c         |   24 +
 fs/xfs/scrub/xfblob.h         |    2 
 fs/xfs/xfs_buf.c              |    3 
 fs/xfs/xfs_trace.h            |    2 
 17 files changed, 1408 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ac3bda492446..0ae616f25a98 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -188,6 +188,7 @@ ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
+				   attr_repair.o \
 				   bmap_repair.o \
 				   cow_repair.o \
 				   fscounters_repair.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 564345a17119..d38a4c42a912 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1095,7 +1095,7 @@ xfs_attr_set(
  * External routines when attribute list is inside the inode
  *========================================================================*/
 
-static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
+int xfs_attr_sf_totsize(struct xfs_inode *dp)
 {
 	struct xfs_attr_shortform *sf;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..e4f55008552b 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -618,4 +618,6 @@ extern struct kmem_cache *xfs_attr_intent_cache;
 int __init xfs_attr_intent_init_cache(void);
 void xfs_attr_intent_destroy_cache(void);
 
+int xfs_attr_sf_totsize(struct xfs_inode *dp);
+
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 9d332415e0b6..e37de511bc2f 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -706,6 +706,11 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
 
+#define XFS_ATTR_NAMESPACE_STR \
+	{ XFS_ATTR_LOCAL,	"local" }, \
+	{ XFS_ATTR_ROOT,	"root" }, \
+	{ XFS_ATTR_SECURE,	"secure" }
+
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
  * there can be only one alignment value)
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 090710acc4b6..1401525074a3 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -10,6 +10,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_log_format.h"
+#include "xfs_trans.h"
 #include "xfs_inode.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
@@ -20,6 +21,7 @@
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
 #include "scrub/attr.h"
+#include "scrub/repair.h"
 
 /* Free the buffers linked from the xattr buffer. */
 static void
@@ -35,6 +37,8 @@ xchk_xattr_buf_cleanup(
 	kvfree(ab->value);
 	ab->value = NULL;
 	ab->value_sz = 0;
+	kvfree(ab->name);
+	ab->name = NULL;
 }
 
 /*
@@ -65,7 +69,7 @@ xchk_xattr_want_freemap(
  * reallocating the buffer if necessary.  Buffer contents are not preserved
  * across a reallocation.
  */
-static int
+int
 xchk_setup_xattr_buf(
 	struct xfs_scrub	*sc,
 	size_t			value_size)
@@ -95,6 +99,12 @@ xchk_setup_xattr_buf(
 			return -ENOMEM;
 	}
 
+	if (xchk_could_repair(sc)) {
+		ab->name = kvmalloc(XATTR_NAME_MAX + 1, XCHK_GFP_FLAGS);
+		if (!ab->name)
+			return -ENOMEM;
+	}
+
 resize_value:
 	if (ab->value_sz >= value_size)
 		return 0;
@@ -121,6 +131,12 @@ xchk_setup_xattr(
 {
 	int			error;
 
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_xattr(sc);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * We failed to get memory while checking attrs, so this time try to
 	 * get all the memory we're ever going to need.  Allocate the buffer
@@ -239,7 +255,7 @@ xchk_xattr_listent(
  * Within a char, the lowest bit of the char represents the byte with
  * the smallest address
  */
-STATIC bool
+bool
 xchk_xattr_set_map(
 	struct xfs_scrub	*sc,
 	unsigned long		*map,
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index 5f6835752738..e90e9195c882 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -16,9 +16,16 @@ struct xchk_xattr_buf {
 	/* Bitmap of free space in xattr leaf blocks. */
 	unsigned long		*freemap;
 
+	/* Memory buffer used to hold salvaged xattr names. */
+	unsigned char		*name;
+
 	/* Memory buffer used to extract xattr values. */
 	void			*value;
 	size_t			value_sz;
 };
 
+bool xchk_xattr_set_map(struct xfs_scrub *sc, unsigned long *map,
+		unsigned int start, unsigned int len);
+int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size);
+
 #endif	/* __XFS_SCRUB_ATTR_H__ */
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
new file mode 100644
index 000000000000..3362f784e4e5
--- /dev/null
+++ b/fs/xfs/scrub/attr_repair.c
@@ -0,0 +1,1158 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_attr.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_attr_sf.h"
+#include "xfs_attr_remote.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_swapext.h"
+#include "xfs_xchgrange.h"
+#include "xfs_acl.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/tempfile.h"
+#include "scrub/tempswap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
+#include "scrub/attr.h"
+#include "scrub/reap.h"
+
+/*
+ * Extended Attribute Repair
+ * =========================
+ *
+ * We repair extended attributes by reading the xattr leaf blocks looking for
+ * attributes.  Salvaged attrs are added to a private hidden temporary file.
+ * When we're done salvaging, we rewrite the xattr block owners and use an
+ * atomic extent swap to commit the new xattr blocks to the file being
+ * repaired.
+ */
+
+struct xrep_xattr_key {
+	/* Cookie for retrieval of the xattr name. */
+	xfblob_cookie		name_cookie;
+
+	/* Cookie for retrieval of the xattr value. */
+	xfblob_cookie		value_cookie;
+
+	/* Hash of the dirent name. */
+	unsigned int		hash;
+
+	/* XFS_ATTR_* flags */
+	int			flags;
+
+	/* Length of the value and name. */
+	uint32_t		valuelen;
+	uint16_t		namelen;
+};
+
+struct xrep_xattr {
+	struct xfs_scrub	*sc;
+
+	struct xrep_tempswap	tx;
+
+	/* xattr keys */
+	struct xfarray		*xattr_records;
+
+	/* xattr values */
+	struct xfblob		*xattr_blobs;
+
+	/* Number of attributes that we are salvaging. */
+	unsigned long long	attrs_found;
+};
+
+/* Absorb up to 8 pages of attrs before we flush them to the temp file. */
+#define XREP_XATTR_SALVAGE_BYTES	(PAGE_SIZE * 8)
+
+/* Set up to recreate the extended attributes. */
+int
+xrep_setup_xattr(
+	struct xfs_scrub	*sc)
+{
+	return xrep_tempfile_create(sc, S_IFREG);
+}
+
+/*
+ * Decide if we want to salvage this attribute.  We don't bother with
+ * incomplete or oversized keys or values.
+ */
+STATIC int
+xrep_xattr_want_salvage(
+	int			flags,
+	const void		*name,
+	int			namelen,
+	int			valuelen)
+{
+	if (flags & XFS_ATTR_INCOMPLETE)
+		return false;
+	if (namelen > XATTR_NAME_MAX || namelen <= 0)
+		return false;
+	if (valuelen > XATTR_SIZE_MAX || valuelen < 0)
+		return false;
+	return true;
+}
+
+/* Allocate an in-core record to hold xattrs while we rebuild the xattr data. */
+STATIC int
+xrep_xattr_salvage_key(
+	struct xrep_xattr	*rx,
+	int			flags,
+	unsigned char		*name,
+	int			namelen,
+	unsigned char		*value,
+	int			valuelen)
+{
+	struct xrep_xattr_key	key = {
+		.valuelen	= valuelen,
+		.flags		= flags & (XFS_ATTR_ROOT | XFS_ATTR_SECURE),
+	};
+	unsigned int		i = 0;
+	int			error = 0;
+
+	if (xchk_should_terminate(rx->sc, &error))
+		return error;
+
+	/*
+	 * Truncate the name to the first character that would trip namecheck.
+	 * If we no longer have a name after that, ignore this attribute.
+	 */
+	while (i < namelen && name[i] != 0)
+		i++;
+	if (i == 0)
+		return 0;
+	key.namelen = i;
+	key.hash = xfs_da_hashname(name, key.namelen);
+
+	trace_xrep_xattr_salvage_key(rx->sc->ip, key.flags, name, key.namelen,
+			key.valuelen);
+
+	error = xfblob_store(rx->xattr_blobs, &key.name_cookie, name,
+			key.namelen);
+	if (error)
+		return error;
+
+	error = xfblob_store(rx->xattr_blobs, &key.value_cookie, value,
+			key.valuelen);
+	if (error)
+		return error;
+
+	error = xfarray_append(rx->xattr_records, &key);
+	if (error)
+		return error;
+
+	rx->attrs_found++;
+	return 0;
+}
+
+/*
+ * Record a shortform extended attribute key & value for later reinsertion
+ * into the inode.
+ */
+STATIC int
+xrep_xattr_salvage_sf_attr(
+	struct xrep_xattr		*rx,
+	struct xfs_attr_shortform	*sf,
+	struct xfs_attr_sf_entry	*sfe)
+{
+	struct xfs_scrub		*sc = rx->sc;
+	struct xchk_xattr_buf		*ab = sc->buf;
+	unsigned char			*name = sfe->nameval;
+	unsigned char			*value = &sfe->nameval[sfe->namelen];
+
+	if (!xchk_xattr_set_map(sc, ab->usedmap, (char *)name - (char *)sf,
+			sfe->namelen))
+		return 0;
+
+	if (!xchk_xattr_set_map(sc, ab->usedmap, (char *)value - (char *)sf,
+			sfe->valuelen))
+		return 0;
+
+	if (!xrep_xattr_want_salvage(sfe->flags, sfe->nameval, sfe->namelen,
+			sfe->valuelen))
+		return 0;
+
+	return xrep_xattr_salvage_key(rx, sfe->flags, sfe->nameval,
+			sfe->namelen, value, sfe->valuelen);
+}
+
+/*
+ * Record a local format extended attribute key & value for later reinsertion
+ * into the inode.
+ */
+STATIC int
+xrep_xattr_salvage_local_attr(
+	struct xrep_xattr		*rx,
+	struct xfs_attr_leaf_entry	*ent,
+	unsigned int			nameidx,
+	const char			*buf_end,
+	struct xfs_attr_leaf_name_local	*lentry)
+{
+	struct xchk_xattr_buf		*ab = rx->sc->buf;
+	unsigned char			*value;
+	unsigned int			valuelen;
+	unsigned int			namesize;
+
+	/*
+	 * Decode the leaf local entry format.  If something seems wrong, we
+	 * junk the attribute.
+	 */
+	valuelen = be16_to_cpu(lentry->valuelen);
+	namesize = xfs_attr_leaf_entsize_local(lentry->namelen, valuelen);
+	if ((char *)lentry + namesize > buf_end)
+		return 0;
+	if (!xrep_xattr_want_salvage(ent->flags, lentry->nameval,
+			lentry->namelen, valuelen))
+		return 0;
+	if (!xchk_xattr_set_map(rx->sc, ab->usedmap, nameidx, namesize))
+		return 0;
+
+	/* Try to save this attribute. */
+	value = &lentry->nameval[lentry->namelen];
+	return xrep_xattr_salvage_key(rx, ent->flags, lentry->nameval,
+			lentry->namelen, value, valuelen);
+}
+
+/*
+ * Record a remote format extended attribute key & value for later reinsertion
+ * into the inode.
+ */
+STATIC int
+xrep_xattr_salvage_remote_attr(
+	struct xrep_xattr		*rx,
+	struct xfs_attr_leaf_entry	*ent,
+	unsigned int			nameidx,
+	const char			*buf_end,
+	struct xfs_attr_leaf_name_remote *rentry,
+	unsigned int			ent_idx,
+	struct xfs_buf			*leaf_bp)
+{
+	struct xfs_da_args		args = {
+		.trans			= rx->sc->tp,
+		.dp			= rx->sc->ip,
+		.index			= ent_idx,
+		.geo			= rx->sc->mp->m_attr_geo,
+		.owner			= rx->sc->ip->i_ino,
+	};
+	struct xchk_xattr_buf		*ab = rx->sc->buf;
+	unsigned int			valuelen;
+	unsigned int			namesize;
+	int				error;
+
+	/*
+	 * Decode the leaf remote entry format.  If something seems wrong, we
+	 * junk the attribute.  Note that we should never find a zero-length
+	 * remote attribute value.
+	 */
+	valuelen = be32_to_cpu(rentry->valuelen);
+	namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
+	if ((char *)rentry + namesize > buf_end)
+		return 0;
+	if (valuelen == 0 ||
+	    !xrep_xattr_want_salvage(ent->flags, rentry->name, rentry->namelen,
+			valuelen))
+		return 0;
+	if (!xchk_xattr_set_map(rx->sc, ab->usedmap, nameidx, namesize))
+		return 0;
+
+	/*
+	 * Enlarge the buffer (if needed) to hold the value that we're trying
+	 * to salvage from the old extended attribute data.
+	 */
+	error = xchk_setup_xattr_buf(rx->sc, valuelen);
+	if (error == -ENOMEM)
+		error = -EDEADLOCK;
+	if (error)
+		return error;
+
+	/* Look up the remote value and stash it for reconstruction. */
+	args.valuelen = valuelen;
+	args.namelen = rentry->namelen;
+	args.name = rentry->name;
+	args.value = ab->value;
+	error = xfs_attr3_leaf_getvalue(leaf_bp, &args);
+	if (error || args.rmtblkno == 0)
+		goto err_free;
+
+	error = xfs_attr_rmtval_get(&args);
+	if (error)
+		goto err_free;
+
+	/* Try to save this attribute. */
+	error = xrep_xattr_salvage_key(rx, ent->flags, rentry->name,
+			rentry->namelen, ab->value, valuelen);
+err_free:
+	/* remote value was garbage, junk it */
+	if (error == -EFSBADCRC || error == -EFSCORRUPTED)
+		error = 0;
+	return error;
+}
+
+/* Extract every xattr key that we can from this attr fork block. */
+STATIC int
+xrep_xattr_recover_leaf(
+	struct xrep_xattr		*rx,
+	struct xfs_buf			*bp)
+{
+	struct xfs_attr3_icleaf_hdr	leafhdr;
+	struct xfs_scrub		*sc = rx->sc;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_attr_leaf_name_local	*lentry;
+	struct xfs_attr_leaf_name_remote *rentry;
+	struct xfs_attr_leaf_entry	*ent;
+	struct xfs_attr_leaf_entry	*entries;
+	struct xchk_xattr_buf		*ab = rx->sc->buf;
+	char				*buf_end;
+	size_t				off;
+	unsigned int			nameidx;
+	unsigned int			hdrsize;
+	int				i;
+	int				error = 0;
+
+	bitmap_zero(ab->usedmap, mp->m_attr_geo->blksize);
+
+	/* Check the leaf header */
+	leaf = bp->b_addr;
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
+	xchk_xattr_set_map(sc, ab->usedmap, 0, hdrsize);
+	entries = xfs_attr3_leaf_entryp(leaf);
+
+	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
+	for (i = 0, ent = entries; i < leafhdr.count; ent++, i++) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		/* Skip key if it conflicts with something else? */
+		off = (char *)ent - (char *)leaf;
+		if (!xchk_xattr_set_map(sc, ab->usedmap, off,
+				sizeof(xfs_attr_leaf_entry_t)))
+			continue;
+
+		/* Check the name information. */
+		nameidx = be16_to_cpu(ent->nameidx);
+		if (nameidx < leafhdr.firstused ||
+		    nameidx >= mp->m_attr_geo->blksize)
+			continue;
+
+		if (ent->flags & XFS_ATTR_LOCAL) {
+			lentry = xfs_attr3_leaf_name_local(leaf, i);
+			error = xrep_xattr_salvage_local_attr(rx, ent, nameidx,
+					buf_end, lentry);
+		} else {
+			rentry = xfs_attr3_leaf_name_remote(leaf, i);
+			error = xrep_xattr_salvage_remote_attr(rx, ent, nameidx,
+					buf_end, rentry, i, bp);
+		}
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Try to recover shortform attrs. */
+STATIC int
+xrep_xattr_recover_sf(
+	struct xrep_xattr		*rx)
+{
+	struct xfs_scrub		*sc = rx->sc;
+	struct xchk_xattr_buf		*ab = sc->buf;
+	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_attr_sf_entry	*next;
+	struct xfs_ifork		*ifp;
+	unsigned char			*end;
+	int				i;
+	int				error = 0;
+
+	ifp = xfs_ifork_ptr(rx->sc->ip, XFS_ATTR_FORK);
+
+	bitmap_zero(ab->usedmap, ifp->if_bytes);
+	sf = (struct xfs_attr_shortform *)rx->sc->ip->i_af.if_u1.if_data;
+	end = (unsigned char *)ifp->if_u1.if_data + ifp->if_bytes;
+	xchk_xattr_set_map(sc, ab->usedmap, 0, sizeof(sf->hdr));
+
+	sfe = &sf->list[0];
+	if ((unsigned char *)sfe > end)
+		return 0;
+
+	for (i = 0; i < sf->hdr.count; i++) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		next = xfs_attr_sf_nextentry(sfe);
+		if ((unsigned char *)next > end)
+			break;
+
+		if (xchk_xattr_set_map(sc, ab->usedmap,
+				(char *)sfe - (char *)sf,
+				sizeof(struct xfs_attr_sf_entry))) {
+			/*
+			 * No conflicts with the sf entry; let's save this
+			 * attribute.
+			 */
+			error = xrep_xattr_salvage_sf_attr(rx, sf, sfe);
+			if (error)
+				return error;
+		}
+
+		sfe = next;
+	}
+
+	return 0;
+}
+
+/*
+ * Try to return a buffer of xattr data for a given physical extent.
+ *
+ * Because the buffer cache get function complains if it finds a buffer
+ * matching the block number but not matching the length, we must be careful to
+ * look for incore buffers (up to the maximum length of a remote value) that
+ * could be hiding anywhere in the physical range.  If we find an incore
+ * buffer, we can pass that to the caller.  Optionally, read a single block and
+ * pass that back.
+ *
+ * Note the subtlety that remote attr value blocks for which there is no incore
+ * buffer will be passed to the callback one block at a time.  These buffers
+ * will not have any ops attached and must be staled to prevent aliasing with
+ * multiblock buffers once we drop the ILOCK.
+ */
+STATIC int
+xrep_xattr_find_buf(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno,
+	xfs_extlen_t		max_len,
+	bool			can_read,
+	struct xfs_buf		**bpp)
+{
+	struct xrep_bufscan	scan = {
+		.daddr		= XFS_FSB_TO_DADDR(mp, fsbno),
+		.max_sectors	= xrep_bufscan_max_sectors(mp, max_len),
+		.daddr_step	= XFS_FSB_TO_BB(mp, 1),
+	};
+	struct xfs_buf		*bp;
+
+	while ((bp = xrep_bufscan_advance(mp, &scan)) != NULL) {
+		*bpp = bp;
+		return 0;
+	}
+
+	if (!can_read) {
+		*bpp = NULL;
+		return 0;
+	}
+
+	return xfs_buf_read(mp->m_ddev_targp, scan.daddr, XFS_FSB_TO_BB(mp, 1),
+			XBF_TRYLOCK, bpp, NULL);
+}
+
+/*
+ * Deal with a buffer that we found during our walk of the attr fork.
+ *
+ * Attribute leaf and node blocks are simple -- they're a single block, so we
+ * can walk them one at a time and we never have to worry about discontiguous
+ * multiblock buffers like we do for directories.
+ *
+ * Unfortunately, remote attr blocks add a lot of complexity here.  Each disk
+ * block is totally self contained, in the sense that the v5 header provides no
+ * indication that there could be more data in the next block.  The incore
+ * buffers can span multiple blocks, though they never cross extent records.
+ * However, they don't necessarily start or end on an extent record boundary.
+ * Therefore, we need a special buffer find function to walk the buffer cache
+ * for us.
+ *
+ * The caller must hold the ILOCK on the file being repaired.  We use
+ * XBF_TRYLOCK here to skip any locked buffer on the assumption that we don't
+ * own the block and don't want to hang the system on a potentially garbage
+ * buffer.
+ */
+STATIC int
+xrep_xattr_recover_block(
+	struct xrep_xattr	*rx,
+	xfs_dablk_t		dabno,
+	xfs_fsblock_t		fsbno,
+	xfs_extlen_t		max_len,
+	xfs_extlen_t		*actual_len)
+{
+	struct xfs_da_blkinfo	*info;
+	struct xfs_buf		*bp;
+	int			error;
+
+	error = xrep_xattr_find_buf(rx->sc->mp, fsbno, max_len, true, &bp);
+	if (error)
+		return error;
+	info = bp->b_addr;
+	*actual_len = XFS_BB_TO_FSB(rx->sc->mp, bp->b_length);
+
+	trace_xrep_xattr_recover_leafblock(rx->sc->ip, dabno,
+			be16_to_cpu(info->magic));
+
+	/*
+	 * If the buffer has the right magic number for an attr leaf block and
+	 * passes a structure check (we don't care about checksums), salvage
+	 * as much as we can from the block. */
+	if (info->magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC) &&
+	    xrep_buf_verify_struct(bp, &xfs_attr3_leaf_buf_ops) &&
+	    xfs_attr3_leaf_header_check(bp, rx->sc->ip->i_ino) == NULL)
+		error = xrep_xattr_recover_leaf(rx, bp);
+
+	/*
+	 * If the buffer didn't already have buffer ops set, it was read in by
+	 * the _find_buf function and could very well be /part/ of a multiblock
+	 * remote block.  Mark it stale so that it doesn't hang around in
+	 * memory to cause problems.
+	 */
+	if (bp->b_ops == NULL)
+		xfs_buf_stale(bp);
+
+	xfs_buf_relse(bp);
+	return error;
+}
+
+/* Insert one xattr key/value. */
+STATIC int
+xrep_xattr_insert_rec(
+	struct xrep_xattr		*rx,
+	const struct xrep_xattr_key	*key)
+{
+	struct xfs_da_args		args = {
+		.dp			= rx->sc->tempip,
+		.attr_filter		= key->flags,
+		.attr_flags		= XATTR_CREATE,
+		.namelen		= key->namelen,
+		.valuelen		= key->valuelen,
+		.op_flags		= XFS_DA_OP_NOTIME,
+		.owner			= rx->sc->ip->i_ino,
+	};
+	struct xchk_xattr_buf		*ab = rx->sc->buf;
+	int				error;
+
+	/*
+	 * Grab pointers to the scrub buffer so that we can use them to insert
+	 * attrs into the temp file.
+	 */
+	args.name = ab->name;
+	args.value = ab->value;
+
+	/*
+	 * The attribute name is stored near the end of the in-core buffer,
+	 * though we reserve one more byte to ensure null termination.
+	 */
+	ab->name[XATTR_NAME_MAX] = 0;
+
+	error = xfblob_load(rx->xattr_blobs, key->name_cookie, ab->name,
+			key->namelen);
+	if (error)
+		return error;
+
+	error = xfblob_free(rx->xattr_blobs, key->name_cookie);
+	if (error)
+		return error;
+
+	error = xfblob_load(rx->xattr_blobs, key->value_cookie, args.value,
+			key->valuelen);
+	if (error)
+		return error;
+
+	error = xfblob_free(rx->xattr_blobs, key->value_cookie);
+	if (error)
+		return error;
+
+	ab->name[key->namelen] = 0;
+
+	trace_xrep_xattr_insert_rec(rx->sc->tempip, key->flags, ab->name,
+			key->namelen, key->valuelen);
+
+	/*
+	 * xfs_attr_set creates and commits its own transaction.  If the attr
+	 * already exists, we'll just drop it during the rebuild.
+	 */
+	error = xfs_attr_set(&args);
+	if (error == -EEXIST)
+		error = 0;
+
+	return error;
+}
+
+/*
+ * Periodically flush salvaged attributes to the temporary file.  This is done
+ * to reduce the memory requirements of the xattr rebuild because files can
+ * contain millions of attributes.
+ */
+STATIC int
+xrep_xattr_flush_salvaged(
+	struct xrep_xattr	*rx)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	/*
+	 * Entering this function, the scrub context has a reference to the
+	 * inode being repaired, the temporary file, and a scrub transaction
+	 * that we use during xattr salvaging to avoid livelocking if there
+	 * are cycles in the xattr structures.  We hold ILOCK_EXCL on both
+	 * the inode being repaired, though it is not ijoined to the scrub
+	 * transaction.
+	 *
+	 * To constrain kernel memory use, we occasionally flush salvaged
+	 * xattrs from the xfarray and xfblob structures into the temporary
+	 * file in preparation for swapping the xattr structures at the end.
+	 * Updating the temporary file requires a transaction, so we commit the
+	 * scrub transaction and drop the two ILOCKs so that xfs_attr_set can
+	 * allocate whatever transaction it wants.
+	 *
+	 * We still hold IOLOCK_EXCL on the inode being repaired, which
+	 * prevents anyone from accessing the damaged xattr data while we
+	 * repair it.
+	 */
+	error = xrep_trans_commit(rx->sc);
+	if (error)
+		return error;
+	xchk_iunlock(rx->sc, XFS_ILOCK_EXCL);
+
+	/*
+	 * Take the IOLOCK of the temporary file while we modify xattrs.  This
+	 * isn't strictly required because the temporary file is never revealed
+	 * to userspace, but we follow the same locking rules.
+	 */
+	while (!xrep_tempfile_iolock_nowait(rx->sc)) {
+		if (xchk_should_terminate(rx->sc, &error))
+			return error;
+		delay(1);
+	}
+
+	/* Add all the salvaged attrs to the temporary file. */
+	foreach_xfarray_idx(rx->xattr_records, array_cur) {
+		struct xrep_xattr_key	key;
+
+		error = xfarray_load(rx->xattr_records, array_cur, &key);
+		if (error)
+			return error;
+
+		error = xrep_xattr_insert_rec(rx, &key);
+		if (error)
+			return error;
+	}
+	xrep_tempfile_iounlock(rx->sc);
+
+	/* Empty out both arrays now that we've added the entries. */
+	xfarray_truncate(rx->xattr_records);
+	xfblob_truncate(rx->xattr_blobs);
+
+	/* Recreate the salvage transaction and relock the inode. */
+	error = xchk_trans_alloc(rx->sc, 0);
+	if (error)
+		return error;
+	xchk_ilock(rx->sc, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/*
+ * Decide if we need to flush the xattrs we've salvaged to disk to constrain
+ * memory usage.
+ */
+static int
+xrep_xattr_need_flush(
+	struct xrep_xattr	*rx,
+	bool			*need)
+{
+	long long		key_bytes, value_bytes;
+
+	key_bytes = xfarray_bytes(rx->xattr_records);
+	if (key_bytes < 0)
+		return key_bytes;
+
+	value_bytes = xfblob_bytes(rx->xattr_blobs);
+	if (value_bytes < 0)
+		return value_bytes;
+
+	*need = key_bytes + value_bytes >= XREP_XATTR_SALVAGE_BYTES;
+	return 0;
+}
+
+/* Extract as many attribute keys and values as we can. */
+STATIC int
+xrep_xattr_recover(
+	struct xrep_xattr	*rx)
+{
+	struct xfs_bmbt_irec	got;
+	struct xfs_scrub	*sc = rx->sc;
+	struct xfs_da_geometry	*geo = sc->mp->m_attr_geo;
+	xfs_fileoff_t		offset;
+	xfs_extlen_t		len;
+	xfs_dablk_t		dabno;
+	int			nmap;
+	int			error;
+
+	/*
+	 * Iterate each xattr leaf block in the attr fork to scan them for any
+	 * attributes that we might salvage.
+	 */
+	for (offset = 0;
+	     offset < XFS_MAX_FILEOFF;
+	     offset = got.br_startoff + got.br_blockcount) {
+		nmap = 1;
+		error = xfs_bmapi_read(sc->ip, offset, XFS_MAX_FILEOFF - offset,
+				&got, &nmap, XFS_BMAPI_ATTRFORK);
+		if (error)
+			return error;
+		if (nmap != 1)
+			return -EFSCORRUPTED;
+		if (!xfs_bmap_is_written_extent(&got))
+			continue;
+
+		for (dabno = round_up(got.br_startoff, geo->fsbcount);
+		     dabno < got.br_startoff + got.br_blockcount;
+		     dabno += len) {
+			xfs_fileoff_t	curr_offset = dabno - got.br_startoff;
+			xfs_extlen_t	maxlen;
+			bool		need_flush = false;
+
+			if (xchk_should_terminate(rx->sc, &error))
+				return error;
+
+			maxlen = min_t(xfs_filblks_t, INT_MAX,
+					got.br_blockcount - curr_offset);
+			error = xrep_xattr_recover_block(rx, dabno,
+					curr_offset + got.br_startblock,
+					maxlen, &len);
+			if (error)
+				return error;
+
+			error = xrep_xattr_need_flush(rx, &need_flush);
+			if (error)
+				return error;
+
+			if (need_flush) {
+				error = xrep_xattr_flush_salvaged(rx);
+				if (error)
+					return error;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Reset the extended attribute fork to a state where we can start re-adding
+ * the salvaged attributes.
+ */
+STATIC int
+xrep_xattr_fork_remove(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	struct xfs_attr_sf_hdr	*hdr;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_ATTR_FORK);
+
+	/*
+	 * If the data fork is in btree format, we can't change di_forkoff
+	 * because we could run afoul of the rule that the data fork isn't
+	 * supposed to be in btree format if there's enough space in the fork
+	 * that it could have used extents format.  Instead, reinitialize the
+	 * attr fork to have a shortform structure with zero attributes.
+	 */
+	if (ip->i_df.if_format == XFS_DINODE_FMT_BTREE) {
+		ifp->if_format = XFS_DINODE_FMT_LOCAL;
+		xfs_idata_realloc(ip, (int)sizeof(*hdr) - ifp->if_bytes,
+				XFS_ATTR_FORK);
+		hdr = (struct xfs_attr_sf_hdr *)ifp->if_u1.if_data;
+		hdr->count = 0;
+		hdr->totsize = cpu_to_be16(sizeof(*hdr));
+		xfs_trans_log_inode(sc->tp, ip,
+				XFS_ILOG_CORE | XFS_ILOG_ADATA);
+		return 0;
+	}
+
+	/* If we still have attr fork extents, something's wrong. */
+	if (ifp->if_nextents != 0) {
+		struct xfs_iext_cursor	icur;
+		struct xfs_bmbt_irec	irec;
+		unsigned int		i = 0;
+
+		xfs_emerg(sc->mp,
+	"inode 0x%llx attr fork still has %llu attr extents, format %d?!",
+				ip->i_ino, ifp->if_nextents, ifp->if_format);
+		for_each_xfs_iext(ifp, &icur, &irec) {
+			xfs_err(sc->mp,
+	"[%u]: startoff %llu startblock %llu blockcount %llu state %u",
+					i++, irec.br_startoff,
+					irec.br_startblock, irec.br_blockcount,
+					irec.br_state);
+		}
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	xfs_attr_fork_remove(ip, sc->tp);
+	return 0;
+}
+
+/*
+ * Free all the attribute fork blocks and delete the fork.  The caller must
+ * ILOCK the file being repaired and ijoin it to the transaction.  This
+ * function returns with the inode joined to a clean scrub transaction.
+ */
+int
+xrep_xattr_reset_fork(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	/* Unmap all the attr blocks. */
+	if (xfs_ifork_has_extents(&sc->ip->i_af)) {
+		error = xrep_reap_ifork(sc, sc->ip, XFS_ATTR_FORK);
+		if (error)
+			return error;
+	}
+
+	trace_xrep_xattr_reset_fork(sc->ip, sc->ip);
+
+	error = xrep_xattr_fork_remove(sc, sc->ip);
+	if (error)
+		return error;
+
+	return xfs_trans_roll_inode(&sc->tp, sc->ip);
+}
+
+/*
+ * Find all the extended attributes for this inode by scraping them out of the
+ * attribute key blocks by hand, and flushing them into the temp file.
+ */
+STATIC int
+xrep_xattr_find_attributes(
+	struct xrep_xattr	*rx)
+{
+	struct xfs_inode	*ip = rx->sc->ip;
+	int			error;
+
+	/* Short format xattrs are easy! */
+	if (rx->sc->ip->i_af.if_format == XFS_DINODE_FMT_LOCAL) {
+		error = xrep_xattr_recover_sf(rx);
+		if (error)
+			return error;
+
+		return xrep_xattr_flush_salvaged(rx);
+	}
+
+	/*
+	 * For non-inline xattr structures, the salvage function scans the
+	 * buffer cache looking for potential attr leaf blocks.  The scan
+	 * requires the ability to lock any buffer found and runs independently
+	 * of any transaction <-> buffer item <-> buffer linkage.  Therefore,
+	 * roll the transaction to ensure there are no buffers joined.  We hold
+	 * the ILOCK independently of the transaction.
+	 */
+	error = xfs_trans_roll(&rx->sc->tp);
+	if (error)
+		return error;
+
+	error = xfs_iread_extents(rx->sc->tp, ip, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
+	error = xrep_xattr_recover(rx);
+	if (error)
+		return error;
+
+	return xrep_xattr_flush_salvaged(rx);
+}
+
+/*
+ * Prepare both inodes' attribute forks for extent swapping.  Promote the
+ * tempfile from short format to leaf format, and if the file being repaired
+ * has a short format attr fork, turn it into an empty extent list.
+ */
+STATIC int
+xrep_xattr_swap_prep(
+	struct xfs_scrub	*sc,
+	bool			temp_local,
+	bool			ip_local)
+{
+	int			error;
+
+	/*
+	 * If the tempfile's attributes are in shortform format, convert that
+	 * to a single leaf extent so that we can use the atomic extent swap.
+	 */
+	if (temp_local) {
+		struct xfs_da_args	args = {
+			.dp		= sc->tempip,
+			.geo		= sc->mp->m_attr_geo,
+			.whichfork	= XFS_ATTR_FORK,
+			.trans		= sc->tp,
+			.total		= 1,
+			.owner		= sc->ip->i_ino,
+		};
+
+		error = xfs_attr_shortform_to_leaf(&args);
+		if (error)
+			return error;
+
+		/*
+		 * Roll the deferred log items to get us back to a clean
+		 * transaction.
+		 */
+		error = xfs_defer_finish(&sc->tp);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * If the file being repaired had a shortform attribute fork, convert
+	 * that to an empty extent list in preparation for the atomic extent
+	 * swap.
+	 */
+	if (ip_local) {
+		struct xfs_ifork	*ifp;
+
+		ifp = xfs_ifork_ptr(sc->ip, XFS_ATTR_FORK);
+
+		xfs_idestroy_fork(ifp);
+		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
+		ifp->if_nextents = 0;
+		ifp->if_bytes = 0;
+		ifp->if_u1.if_root = NULL;
+		ifp->if_height = 0;
+
+		xfs_trans_log_inode(sc->tp, sc->ip,
+				XFS_ILOG_CORE | XFS_ILOG_ADATA);
+	}
+
+	return 0;
+}
+
+/* Swap the temporary file's attribute fork with the one being repaired. */
+STATIC int
+xrep_xattr_swap(
+	struct xrep_xattr	*rx)
+{
+	struct xfs_scrub	*sc = rx->sc;
+	bool			ip_local, temp_local;
+	int			error = 0;
+
+	/*
+	 * Take the IOLOCK on the temporary file so that we can run xattr
+	 * operations with the same locks held as we would for a normal file.
+	 */
+	while (!xrep_tempfile_iolock_nowait(rx->sc)) {
+		if (xchk_should_terminate(rx->sc, &error))
+			return error;
+		delay(1);
+	}
+
+	error = xrep_tempswap_trans_alloc(rx->sc, XFS_ATTR_FORK, &rx->tx);
+	if (error)
+		return error;
+
+	ip_local = sc->ip->i_af.if_format == XFS_DINODE_FMT_LOCAL;
+	temp_local = sc->tempip->i_af.if_format == XFS_DINODE_FMT_LOCAL;
+
+	/*
+	 * If the both files have a local format attr fork and the rebuilt
+	 * xattr data would fit in the repaired file's attr fork, just copy
+	 * the contents from the tempfile and declare ourselves done.
+	 */
+	if (ip_local && temp_local) {
+		int	forkoff;
+		int	newsize;
+
+		newsize = xfs_attr_sf_totsize(sc->tempip);
+		forkoff = xfs_attr_shortform_bytesfit(sc->ip, newsize);
+		if (forkoff > 0) {
+			sc->ip->i_forkoff = forkoff;
+			xrep_tempfile_copyout_local(sc, XFS_ATTR_FORK);
+			return 0;
+		}
+	}
+
+	/* Otherwise, make sure both attr forks are in block-mapping mode. */
+	error = xrep_xattr_swap_prep(sc, temp_local, ip_local);
+	if (error)
+		return error;
+
+	return xrep_tempswap_contents(sc, &rx->tx);
+}
+
+/*
+ * Swap the new extended attribute data (which we created in the tempfile) into
+ * the file being repaired.
+ */
+STATIC int
+xrep_xattr_rebuild_tree(
+	struct xrep_xattr	*rx)
+{
+	struct xfs_scrub	*sc = rx->sc;
+	int			error;
+
+	/*
+	 * If we didn't find any attributes to salvage, repair the file by
+	 * zapping the attr fork.
+	 */
+	if (rx->attrs_found == 0) {
+		xfs_trans_ijoin(sc->tp, sc->ip, 0);
+		return xrep_xattr_reset_fork(sc);
+	}
+
+	trace_xrep_xattr_rebuild_tree(sc->ip, sc->tempip);
+
+	/*
+	 * Commit the repair transaction and drop the ILOCKs so that we can use
+	 * the atomic extent swap helper functions to compute the correct
+	 * resource reservations.
+	 *
+	 * We still hold IOLOCK_EXCL (aka i_rwsem) which will prevent xattr
+	 * modifications, but there's nothing to prevent userspace from reading
+	 * the attributes until we're ready for the swap operation.  Reads will
+	 * return -EIO without shutting down the fs, so we're ok with that.
+	 */
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	/*
+	 * Swap the tempfile's attr fork with the file being repaired.  This
+	 * recreates the transaction and takes the ILOCKs of both the file
+	 * being repaired and the temporary file.
+	 */
+	error = xrep_xattr_swap(rx);
+	if (error)
+		return error;
+
+	/*
+	 * Wipe out the attr fork of the temp file so that regular inode
+	 * inactivation won't trip over the corrupt attr fork.
+	 */
+	if (xfs_ifork_has_extents(&sc->tempip->i_af)) {
+		error = xrep_reap_ifork(sc, sc->tempip, XFS_ATTR_FORK);
+		if (error)
+			return error;
+	}
+
+	trace_xrep_xattr_reset_fork(sc->ip, sc->tempip);
+
+	error = xrep_xattr_fork_remove(sc, sc->tempip);
+	if (error)
+		return error;
+
+	return xrep_tempfile_roll_trans(sc);
+}
+
+/*
+ * Repair the extended attribute metadata.
+ *
+ * XXX: Remote attribute value buffers encompass the entire (up to 64k) buffer.
+ * The buffer cache in XFS can't handle aliased multiblock buffers, so this
+ * might misbehave if the attr fork is crosslinked with other filesystem
+ * metadata.
+ */
+int
+xrep_xattr(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_xattr	*rx;
+	int			max_len;
+	int			error;
+
+	if (!xfs_inode_hasattr(sc->ip))
+		return -ENOENT;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_has_rmapbt(sc->mp))
+		return -EOPNOTSUPP;
+
+	rx = kzalloc(sizeof(struct xrep_xattr), XCHK_GFP_FLAGS);
+	if (!rx)
+		return -ENOMEM;
+	rx->sc = sc;
+
+	/*
+	 * Make sure we have enough space to handle salvaging and spilling
+	 * every possible local attr value, since we only realloc the buffer
+	 * for remote values.
+	 */
+	max_len = xfs_attr_leaf_entsize_local_max(sc->mp->m_attr_geo->blksize);
+	error = xchk_setup_xattr_buf(rx->sc, max_len);
+	if (error == -ENOMEM)
+		error = -EDEADLOCK;
+	if (error)
+		goto out_rx;
+
+	/* Set up some storage */
+	error = xfarray_create(sc->mp, "xattr keys", 0,
+			sizeof(struct xrep_xattr_key), &rx->xattr_records);
+	if (error)
+		goto out_rx;
+
+	error = xfblob_create(sc->mp, "xattr values", &rx->xattr_blobs);
+	if (error)
+		goto out_keys;
+
+	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
+
+	/*
+	 * Collect extended attributes by parsing raw blocks to salvage
+	 * whatever we can into the tempfile.  When we're done, free the
+	 * staging memory before swapping the xattr structures to reduce memory
+	 * usage.
+	 */
+	error = xrep_xattr_find_attributes(rx);
+	if (error)
+		goto out_values;
+
+	xfblob_destroy(rx->xattr_blobs);
+	xfarray_destroy(rx->xattr_records);
+	rx->xattr_blobs = NULL;
+	rx->xattr_records = NULL;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto out_rx;
+
+	/* Swap in the good contents. */
+	error = xrep_xattr_rebuild_tree(rx);
+	if (error)
+		goto out_values;
+
+	/* Invalidate ACLs now that we've reloaded all the xattrs. */
+	xfs_forget_acl(VFS_I(sc->ip), SGI_ACL_FILE);
+	xfs_forget_acl(VFS_I(sc->ip), SGI_ACL_DEFAULT);
+
+out_values:
+	if (rx->xattr_blobs)
+		xfblob_destroy(rx->xattr_blobs);
+out_keys:
+	if (rx->xattr_records)
+		xfarray_destroy(rx->xattr_records);
+out_rx:
+	kfree(rx);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index da6bff1fcd86..e5e5dbdce7c4 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -31,6 +31,9 @@
 #include "xfs_error.h"
 #include "xfs_reflink.h"
 #include "xfs_health.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -1118,6 +1121,17 @@ xrep_metadata_inode_forks(
 			return error;
 	}
 
+	/* Clear the attr forks since metadata shouldn't have that. */
+	if (xfs_inode_hasattr(sc->ip)) {
+		if (!dirty) {
+			dirty = true;
+			xfs_trans_ijoin(sc->tp, sc->ip, 0);
+		}
+		error = xrep_xattr_reset_fork(sc);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * If we modified the inode, roll the transaction but don't rejoin the
 	 * inode to the new transaction because xrep_bmap_data can do that.
@@ -1189,3 +1203,34 @@ xrep_trans_cancel_hook_dummy(
 	current->journal_info = *cookiep;
 	*cookiep = NULL;
 }
+
+/*
+ * See if this buffer can pass the given ->verify_struct() function.
+ *
+ * If the buffer already has ops attached and they're not the ones that were
+ * passed in, we reject the buffer.  Otherwise, we perform the structure test
+ * (note that we do not check CRCs) and return the outcome of the test.  The
+ * buffer ops and error state are left unchanged.
+ */
+bool
+xrep_buf_verify_struct(
+	struct xfs_buf			*bp,
+	const struct xfs_buf_ops	*ops)
+{
+	const struct xfs_buf_ops	*old_ops = bp->b_ops;
+	xfs_failaddr_t			fa;
+	int				old_error;
+
+	if (old_ops) {
+		if (old_ops != ops)
+			return false;
+	}
+
+	old_error = bp->b_error;
+	bp->b_ops = ops;
+	fa = bp->b_ops->verify_struct(bp);
+	bp->b_ops = old_ops;
+	bp->b_error = old_error;
+
+	return fa == NULL;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 086e8e739264..2a79d7a5ba7e 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -82,6 +82,9 @@ int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
 int xrep_setup_ag_refcountbt(struct xfs_scrub *sc);
 int xrep_setup_rtsummary(struct xfs_scrub *sc, unsigned int *resblks,
 		size_t *bufsize);
+int xrep_setup_xattr(struct xfs_scrub *sc);
+
+int xrep_xattr_reset_fork(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -116,6 +119,7 @@ int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_bmap_cow(struct xfs_scrub *sc);
 int xrep_nlinks(struct xfs_scrub *sc);
 int xrep_fscounters(struct xfs_scrub *sc);
+int xrep_xattr(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -140,6 +144,8 @@ int xrep_trans_alloc_hook_dummy(struct xfs_mount *mp, void **cookiep,
 		struct xfs_trans **tpp);
 void xrep_trans_cancel_hook_dummy(void **cookiep, struct xfs_trans *tp);
 
+bool xrep_buf_verify_struct(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
+
 #else
 
 #define xrep_ino_dqattach(sc)	(0)
@@ -182,6 +188,7 @@ xrep_setup_nothing(
 #define xrep_setup_ag_allocbt		xrep_setup_nothing
 #define xrep_setup_ag_rmapbt		xrep_setup_nothing
 #define xrep_setup_ag_refcountbt	xrep_setup_nothing
+#define xrep_setup_xattr		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
@@ -221,6 +228,7 @@ xrep_setup_rtsummary(
 #define xrep_nlinks			xrep_notsupported
 #define xrep_fscounters			xrep_notsupported
 #define xrep_rtsummary			xrep_notsupported
+#define xrep_xattr			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a9030603b424..0ec23fc650be 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -333,7 +333,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_xattr,
 		.scrub	= xchk_xattr,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_xattr,
 	},
 	[XFS_SCRUB_TYPE_SYMLINK] = {	/* symbolic link */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index aebfaef07e2d..8f925889d51a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2293,6 +2293,111 @@ TRACE_EVENT(xreap_bmapi_binval_scan,
 		  __entry->scan_blocks)
 );
 
+TRACE_EVENT(xrep_xattr_recover_leafblock,
+	TP_PROTO(struct xfs_inode *ip, xfs_dablk_t dabno, uint16_t magic),
+	TP_ARGS(ip, dabno, magic),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_dablk_t, dabno)
+		__field(uint16_t, magic)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->dabno = dabno;
+		__entry->magic = magic;
+	),
+	TP_printk("dev %d:%d ino 0x%llx dablk 0x%x magic 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->dabno,
+		  __entry->magic)
+);
+
+TRACE_EVENT(xrep_xattr_salvage_key,
+	TP_PROTO(struct xfs_inode *ip, unsigned int flags, char *name,
+		 unsigned int namelen, unsigned int valuelen),
+	TP_ARGS(ip, flags, name, namelen, valuelen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, flags)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, namelen)
+		__field(unsigned int, valuelen)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->flags = flags;
+		__entry->namelen = namelen;
+		memcpy(__get_str(name), name, namelen);
+		__entry->valuelen = valuelen;
+	),
+	TP_printk("dev %d:%d ino 0x%llx flags %s name '%.*s' valuelen 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		   __print_flags(__entry->flags, "|", XFS_ATTR_NAMESPACE_STR),
+		  __entry->namelen,
+		  __get_str(name),
+		  __entry->valuelen)
+);
+
+TRACE_EVENT(xrep_xattr_insert_rec,
+	TP_PROTO(struct xfs_inode *ip, unsigned int flags, char *name,
+		 unsigned int namelen, unsigned int valuelen),
+	TP_ARGS(ip, flags, name, namelen, valuelen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, flags)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, namelen)
+		__field(unsigned int, valuelen)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->flags = flags;
+		__entry->namelen = namelen;
+		memcpy(__get_str(name), name, namelen);
+		__entry->valuelen = valuelen;
+	),
+	TP_printk("dev %d:%d ino 0x%llx flags %s name '%.*s' valuelen 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		   __print_flags(__entry->flags, "|", XFS_ATTR_NAMESPACE_STR),
+		  __entry->namelen,
+		  __get_str(name),
+		  __entry->valuelen)
+);
+
+TRACE_EVENT(xrep_xattr_class,
+	TP_PROTO(struct xfs_inode *ip, struct xfs_inode *arg_ip),
+	TP_ARGS(ip, arg_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_ino_t, src_ino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->src_ino = arg_ip->i_ino;
+	),
+	TP_printk("dev %d:%d ino 0x%llx src 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->src_ino)
+)
+#define DEFINE_XREP_XATTR_CLASS(name) \
+DEFINE_EVENT(xrep_xattr_class, name, \
+	TP_PROTO(struct xfs_inode *ip, struct xfs_inode *arg_ip), \
+	TP_ARGS(ip, arg_ip))
+DEFINE_XREP_XATTR_CLASS(xrep_xattr_rebuild_tree);
+DEFINE_XREP_XATTR_CLASS(xrep_xattr_reset_fork);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 
diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index ce1365144209..f5af17fff40d 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -1082,3 +1082,27 @@ xfarray_sort(
 	kvfree(si);
 	return error;
 }
+
+/* How many bytes is this array consuming? */
+long long
+xfarray_bytes(
+	struct xfarray		*array)
+{
+	struct xfile_stat	statbuf;
+	int			error;
+
+	error = xfile_stat(array->xfile, &statbuf);
+	if (error)
+		return error;
+
+	return statbuf.bytes;
+}
+
+/* Empty the entire array. */
+void
+xfarray_truncate(
+	struct xfarray	*array)
+{
+	xfile_discard(array->xfile, 0, MAX_LFS_FILESIZE);
+	array->nr = 0;
+}
diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index 44c7e7083881..7f4bc4ad28ad 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -45,6 +45,8 @@ int xfarray_unset(struct xfarray *array, xfarray_idx_t idx);
 int xfarray_store(struct xfarray *array, xfarray_idx_t idx, const void *ptr);
 int xfarray_store_anywhere(struct xfarray *array, const void *ptr);
 bool xfarray_element_is_null(struct xfarray *array, const void *ptr);
+void xfarray_truncate(struct xfarray *array);
+long long xfarray_bytes(struct xfarray *array);
 
 /*
  * Load an array element, but zero the buffer if there's no data because we
diff --git a/fs/xfs/scrub/xfblob.c b/fs/xfs/scrub/xfblob.c
index c3a646cad5ed..5c1a4e0616c0 100644
--- a/fs/xfs/scrub/xfblob.c
+++ b/fs/xfs/scrub/xfblob.c
@@ -150,3 +150,27 @@ xfblob_free(
 	xfile_discard(blob->xfile, cookie, sizeof(key) + key.xb_size);
 	return 0;
 }
+
+/* How many bytes is this blob storage object consuming? */
+long long
+xfblob_bytes(
+	struct xfblob		*blob)
+{
+	struct xfile_stat	statbuf;
+	int			error;
+
+	error = xfile_stat(blob->xfile, &statbuf);
+	if (error)
+		return error;
+
+	return statbuf.bytes;
+}
+
+/* Drop all the blobs. */
+void
+xfblob_truncate(
+	struct xfblob	*blob)
+{
+	xfile_discard(blob->xfile, 0, MAX_LFS_FILESIZE);
+	blob->last_offset = 0;
+}
diff --git a/fs/xfs/scrub/xfblob.h b/fs/xfs/scrub/xfblob.h
index 2c1810b4a4eb..73051c8616c6 100644
--- a/fs/xfs/scrub/xfblob.h
+++ b/fs/xfs/scrub/xfblob.h
@@ -21,5 +21,7 @@ int xfblob_load(struct xfblob *blob, xfblob_cookie cookie, void *ptr,
 int xfblob_store(struct xfblob *blob, xfblob_cookie *cookie, void *ptr,
 		uint32_t size);
 int xfblob_free(struct xfblob *blob, xfblob_cookie cookie);
+long long xfblob_bytes(struct xfblob *blob);
+void xfblob_truncate(struct xfblob *blob);
 
 #endif /* __XFS_SCRUB_XFBLOB_H__ */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 410db46e7935..b65dab243130 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -482,6 +482,9 @@ _xfs_buf_obj_cmp(
 		 * it stale has not yet committed. i.e. we are
 		 * reallocating a busy extent. Skip this buffer and
 		 * continue searching for an exact match.
+		 *
+		 * Note: If we're scanning for incore buffers to stale, don't
+		 * complain if we find non-stale buffers.
 		 */
 		if (!(map->bm_flags & XBM_IGNORE_LENGTH_MISMATCH))
 			ASSERT(bp->b_flags & XBF_STALE);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index da6b7461f4d0..147dbdf73d92 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -31,6 +31,8 @@
  * pos: file offset, in bytes
  * bytecount: number of bytes
  *
+ * dablk: directory or xattr block offset, in filesystem blocks
+ *
  * disize: ondisk file size, in bytes
  * isize: incore file size, in bytes
  *

