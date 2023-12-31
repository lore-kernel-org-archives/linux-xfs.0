Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC7FBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BIDW5f+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9E0C433C7;
	Sun, 31 Dec 2023 20:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054943;
	bh=sP53tHMcPuNOoSrYMb8rDmrmP7g+h9ovqRxSqiubDRE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BIDW5f+Q1xbwluSxHltkTRlCxhxjg4TK5IsG3FWZmTfON7NsmlBnrJxGZAw28YL3c
	 F9kZgX5aJ5sqqEdGQBT3Whzr9z3KMzNbBCPzFMpV7RjaP3XdmelH0wsAihnkDTQtr4
	 2KTUxJM93txKxcQn8EzGVDZdvXG6xfp23awPRMAbbgB9RyZU/a3uyPVq/M6/v5B+d3
	 wAQywfIqd8WLxQxG7hM/LgLdLe1yvGFkYAHyxUHzPoayvd5eShMyIdt9lfyfU1tvdn
	 B2CDd/wW3sQlOClxGfNOyGmObXZ1qXdX2q5Ryf5y0eZ/nKxqg6feJl5lFo+0JC/cPo
	 A2ByddVohbRvg==
Date: Sun, 31 Dec 2023 12:35:42 -0800
Subject: [PATCH 3/6] xfs: repair extended attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404835262.1753315.12576056577179918983.stgit@frogsfrogsfrogs>
In-Reply-To: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
References: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/attr_repair.c    | 1203 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/attr_repair.h    |   11 
 fs/xfs/scrub/repair.c         |   46 ++
 fs/xfs/scrub/repair.h         |    6 
 fs/xfs/scrub/scrub.c          |    2 
 fs/xfs/scrub/trace.h          |   83 +++
 fs/xfs/scrub/xfarray.c        |   17 +
 fs/xfs/scrub/xfarray.h        |    2 
 fs/xfs/scrub/xfblob.c         |   17 +
 fs/xfs/scrub/xfblob.h         |    2 
 fs/xfs/scrub/xfile.h          |   12 
 fs/xfs/xfs_buf.c              |    3 
 fs/xfs/xfs_trace.h            |    2 
 19 files changed, 1439 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c
 create mode 100644 fs/xfs/scrub/attr_repair.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 72df9890edcf6..9b227be3e28b6 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -194,6 +194,7 @@ ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
+				   attr_repair.o \
 				   bmap_repair.o \
 				   cow_repair.o \
 				   fscounters_repair.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1e94e933d7682..b002ddd5f05a2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1047,7 +1047,7 @@ xfs_attr_set(
  * External routines when attribute list is inside the inode
  *========================================================================*/
 
-static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
+int xfs_attr_sf_totsize(struct xfs_inode *dp)
 {
 	struct xfs_attr_shortform *sf;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e40047..e4f55008552b4 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -618,4 +618,6 @@ extern struct kmem_cache *xfs_attr_intent_cache;
 int __init xfs_attr_intent_init_cache(void);
 void xfs_attr_intent_destroy_cache(void);
 
+int xfs_attr_sf_totsize(struct xfs_inode *dp);
+
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 44748f1640e53..0e1ada44f21ba 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -716,6 +716,11 @@ struct xfs_attr3_leafblock {
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
index 40a59b24c209f..692e1b2837bbb 100644
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
@@ -247,7 +263,7 @@ xchk_xattr_listent(
  * Within a char, the lowest bit of the char represents the byte with
  * the smallest address
  */
-STATIC bool
+bool
 xchk_xattr_set_map(
 	struct xfs_scrub	*sc,
 	unsigned long		*map,
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index 48fd9402c4328..7db58af56646b 100644
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
index 0000000000000..9a88d46392626
--- /dev/null
+++ b/fs/xfs/scrub/attr_repair.c
@@ -0,0 +1,1203 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
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
+#include "scrub/attr_repair.h"
+
+/*
+ * Extended Attribute Repair
+ * =========================
+ *
+ * We repair extended attributes by reading the attr leaf blocks looking for
+ * attributes entries that look salvageable (name passes verifiers, value can
+ * be retrieved, etc).  Each extended attribute worth salvaging is stashed in
+ * memory, and the stashed entries are periodically replayed into a temporary
+ * file to constrain memory use.  Batching the construction of the temporary
+ * extended attribute structure in this fashion reduces lock cycling of the
+ * file being repaired and the temporary file.
+ *
+ * When salvaging completes, the remaining stashed attributes are replayed to
+ * the temporary file.  An atomic extent swap is used to commit the new xattr
+ * blocks to the file being repaired.  This will disrupt attrmulti cursors.
+ */
+
+struct xrep_xattr_key {
+	/* Cookie for retrieval of the xattr name. */
+	xfblob_cookie		name_cookie;
+
+	/* Cookie for retrieval of the xattr value. */
+	xfblob_cookie		value_cookie;
+
+	/* XFS_ATTR_* flags */
+	int			flags;
+
+	/* Length of the value and name. */
+	uint32_t		valuelen;
+	uint16_t		namelen;
+};
+
+/*
+ * Stash up to 8 pages of attrs in xattr_records/xattr_blobs before we write
+ * them to the temp file.
+ */
+#define XREP_XATTR_MAX_STASH_BYTES	(PAGE_SIZE * 8)
+
+struct xrep_xattr {
+	struct xfs_scrub	*sc;
+
+	/* Information for swapping attr forks at the end. */
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
+ * incomplete or oversized keys or values.  The @value parameter can be null
+ * for remote attrs.
+ */
+STATIC int
+xrep_xattr_want_salvage(
+	struct xrep_xattr	*rx,
+	unsigned int		attr_flags,
+	const void		*name,
+	int			namelen,
+	const void		*value,
+	int			valuelen)
+{
+	if (attr_flags & XFS_ATTR_INCOMPLETE)
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
+		.flags		= flags & XFS_ATTR_NSP_ONDISK_MASK,
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
+
+	trace_xrep_xattr_salvage_rec(rx->sc->ip, flags, name, key.namelen,
+			valuelen);
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
+	if (!xrep_xattr_want_salvage(rx, sfe->flags, sfe->nameval,
+			sfe->namelen, value, sfe->valuelen))
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
+	value = &lentry->nameval[lentry->namelen];
+	valuelen = be16_to_cpu(lentry->valuelen);
+	namesize = xfs_attr_leaf_entsize_local(lentry->namelen, valuelen);
+	if ((char *)lentry + namesize > buf_end)
+		return 0;
+	if (!xrep_xattr_want_salvage(rx, ent->flags, lentry->nameval,
+			lentry->namelen, value, valuelen))
+		return 0;
+	if (!xchk_xattr_set_map(rx->sc, ab->usedmap, nameidx, namesize))
+		return 0;
+
+	/* Try to save this attribute. */
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
+	    !xrep_xattr_want_salvage(rx, ent->flags, rentry->name,
+			rentry->namelen, NULL, valuelen))
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
+xrep_xattr_flush_stashed(
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
+	 * prevents anyone from modifying the damaged xattr data while we
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
+	 * to userspace, but we follow the same locking rules.  We still hold
+	 * sc->ip's IOLOCK.
+	 */
+	error = xrep_tempfile_iolock_polled(rx->sc);
+	if (error)
+		return error;
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
+
+	/* Empty out both arrays now that we've added the entries. */
+	xfarray_truncate(rx->xattr_records);
+	xfblob_truncate(rx->xattr_blobs);
+
+	xrep_tempfile_iounlock(rx->sc);
+
+	/* Recreate the salvage transaction and relock the inode. */
+	error = xchk_trans_alloc(rx->sc, 0);
+	if (error)
+		return error;
+	xchk_ilock(rx->sc, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/* Decide if we've stashed too much xattr data in memory. */
+static inline bool
+xrep_xattr_want_flush_stashed(
+	struct xrep_xattr	*rx)
+{
+	unsigned long long	bytes;
+
+	bytes = xfarray_bytes(rx->xattr_records) +
+		xfblob_bytes(rx->xattr_blobs);
+	return bytes > XREP_XATTR_MAX_STASH_BYTES;
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
+			if (xrep_xattr_want_flush_stashed(rx)) {
+				error = xrep_xattr_flush_stashed(rx);
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
+ * Free all the attribute fork blocks of the file being repaired and delete the
+ * fork.  The caller must ILOCK the scrub file and join it to the transaction.
+ * This function returns with the inode joined to a clean transaction.
+ */
+int
+xrep_xattr_reset_fork(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	trace_xrep_xattr_reset_fork(sc->ip, sc->ip);
+
+	/* Unmap all the attr blocks. */
+	if (xfs_ifork_has_extents(&sc->ip->i_af)) {
+		error = xrep_reap_ifork(sc, sc->ip, XFS_ATTR_FORK);
+		if (error)
+			return error;
+	}
+
+	error = xrep_xattr_fork_remove(sc, sc->ip);
+	if (error)
+		return error;
+
+	return xfs_trans_roll_inode(&sc->tp, sc->ip);
+}
+
+/*
+ * Free all the attribute fork blocks of the temporary file and delete the attr
+ * fork.  The caller must ILOCK the tempfile and join it to the transaction.
+ * This function returns with the inode joined to a clean scrub transaction.
+ */
+STATIC int
+xrep_xattr_reset_tempfile_fork(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	trace_xrep_xattr_reset_fork(sc->ip, sc->tempip);
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
+	return xrep_xattr_fork_remove(sc, sc->tempip);
+}
+
+/*
+ * Find all the extended attributes for this inode by scraping them out of the
+ * attribute key blocks by hand, and flushing them into the temp file.
+ * When we're done, free the staging memory before swapping the xattr
+ * structures to reduce memory usage.
+ */
+STATIC int
+xrep_xattr_salvage_attributes(
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
+		return xrep_xattr_flush_stashed(rx);
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
+	return xrep_xattr_flush_stashed(rx);
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
+	struct xfs_scrub	*sc,
+	struct xrep_tempswap	*tx)
+{
+	bool			ip_local, temp_local;
+	int			error = 0;
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
+	return xrep_tempswap_contents(sc, tx);
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
+	 * zapping its attr fork.
+	 */
+	if (rx->attrs_found == 0) {
+		xfs_trans_ijoin(sc->tp, sc->ip, 0);
+		error = xrep_xattr_reset_fork(sc);
+		if (error)
+			return error;
+
+		goto forget_acls;
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
+	 * Take the IOLOCK on the temporary file so that we can run xattr
+	 * operations with the same locks held as we would for a normal file.
+	 * We still hold sc->ip's IOLOCK.
+	 */
+	error = xrep_tempfile_iolock_polled(rx->sc);
+	if (error)
+		return error;
+
+	/* Allocate swapext transaction and lock both inodes. */
+	error = xrep_tempswap_trans_alloc(rx->sc, XFS_ATTR_FORK, &rx->tx);
+	if (error)
+		return error;
+
+	/*
+	 * Exchange the blocks mapped by the tempfile's attr fork with the file
+	 * being repaired.  The old attr blocks will then be attached to the
+	 * tempfile, so reap its attr fork.
+	 */
+	error = xrep_xattr_swap(sc, &rx->tx);
+	if (error)
+		return error;
+
+	error = xrep_xattr_reset_tempfile_fork(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Roll to get a transaction without any inodes joined to it.  Then we
+	 * can drop the tempfile's ILOCK and IOLOCK before doing more work on
+	 * the scrub target file.
+	 */
+	error = xfs_trans_roll(&sc->tp);
+	if (error)
+		return error;
+
+	xrep_tempfile_iunlock(sc);
+	xrep_tempfile_iounlock(sc);
+
+forget_acls:
+	/* Invalidate cached ACLs now that we've reloaded all the xattrs. */
+	xfs_forget_acl(VFS_I(sc->ip), SGI_ACL_FILE);
+	xfs_forget_acl(VFS_I(sc->ip), SGI_ACL_DEFAULT);
+	return 0;
+}
+
+/* Tear down all the incore scan stuff we created. */
+STATIC void
+xrep_xattr_teardown(
+	struct xrep_xattr	*rx)
+{
+	xfblob_destroy(rx->xattr_blobs);
+	xfarray_destroy(rx->xattr_records);
+	kfree(rx);
+}
+
+/* Set up the filesystem scan so we can regenerate extended attributes. */
+STATIC int
+xrep_xattr_setup_scan(
+	struct xfs_scrub	*sc,
+	struct xrep_xattr	**rxp)
+{
+	struct xrep_xattr	*rx;
+	char			*descr;
+	int			max_len;
+	int			error;
+
+	rx = kzalloc(sizeof(struct xrep_xattr), XCHK_GFP_FLAGS);
+	if (!rx)
+		return -ENOMEM;
+	rx->sc = sc;
+
+	/*
+	 * Allocate enough memory to handle loading local attr values from the
+	 * xfblob data while flushing stashed attrs to the temporary file.
+	 * We only realloc the buffer when salvaging remote attr values.
+	 */
+	max_len = xfs_attr_leaf_entsize_local_max(sc->mp->m_attr_geo->blksize);
+	error = xchk_setup_xattr_buf(rx->sc, max_len);
+	if (error == -ENOMEM)
+		error = -EDEADLOCK;
+	if (error)
+		goto out_rx;
+
+	/* Set up some staging for salvaged attribute keys and values */
+	descr = xchk_xfile_ino_descr(sc, "xattr keys");
+	error = xfarray_create(descr, 0, sizeof(struct xrep_xattr_key),
+			&rx->xattr_records);
+	kfree(descr);
+	if (error)
+		goto out_rx;
+
+	descr = xchk_xfile_ino_descr(sc, "xattr names");
+	error = xfblob_create(descr, &rx->xattr_blobs);
+	kfree(descr);
+	if (error)
+		goto out_keys;
+
+	*rxp = rx;
+	return 0;
+out_keys:
+	xfarray_destroy(rx->xattr_records);
+out_rx:
+	kfree(rx);
+	return error;
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
+	struct xrep_xattr	*rx = NULL;
+	int			error;
+
+	if (!xfs_inode_hasattr(sc->ip))
+		return -ENOENT;
+
+	/* The rmapbt is required to reap the old attr fork. */
+	if (!xfs_has_rmapbt(sc->mp))
+		return -EOPNOTSUPP;
+
+	error = xrep_xattr_setup_scan(sc, &rx);
+	if (error)
+		return error;
+
+	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
+
+	error = xrep_xattr_salvage_attributes(rx);
+	if (error)
+		goto out_scan;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto out_scan;
+
+	error = xrep_xattr_rebuild_tree(rx);
+	if (error)
+		goto out_scan;
+
+out_scan:
+	xrep_xattr_teardown(rx);
+	return error;
+}
diff --git a/fs/xfs/scrub/attr_repair.h b/fs/xfs/scrub/attr_repair.h
new file mode 100644
index 0000000000000..0a9ffa7cfa906
--- /dev/null
+++ b/fs/xfs/scrub/attr_repair.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_ATTR_REPAIR_H__
+#define __XFS_SCRUB_ATTR_REPAIR_H__
+
+int xrep_xattr_reset_fork(struct xfs_scrub *sc);
+
+#endif /* __XFS_SCRUB_ATTR_REPAIR_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 6490f064e091f..83b7aa48dec19 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -32,6 +32,9 @@
 #include "xfs_reflink.h"
 #include "xfs_health.h"
 #include "xfs_buf_xfile.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -39,6 +42,7 @@
 #include "scrub/bitmap.h"
 #include "scrub/stats.h"
 #include "scrub/xfile.h"
+#include "scrub/attr_repair.h"
 
 /*
  * Attempt to repair some metadata, if the metadata is corrupt and userspace
@@ -1136,6 +1140,17 @@ xrep_metadata_inode_forks(
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
@@ -1201,3 +1216,34 @@ xrep_trans_cancel_hook_dummy(
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
index 06125d0a2c602..2bc5dd18d46f4 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -90,6 +90,7 @@ int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
 int xrep_metadata_inode_forks(struct xfs_scrub *sc);
 int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
 int xrep_setup_ag_refcountbt(struct xfs_scrub *sc);
+int xrep_setup_xattr(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -123,6 +124,7 @@ int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_bmap_cow(struct xfs_scrub *sc);
 int xrep_nlinks(struct xfs_scrub *sc);
 int xrep_fscounters(struct xfs_scrub *sc);
+int xrep_xattr(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -147,6 +149,8 @@ int xrep_trans_alloc_hook_dummy(struct xfs_mount *mp, void **cookiep,
 		struct xfs_trans **tpp);
 void xrep_trans_cancel_hook_dummy(void **cookiep, struct xfs_trans *tp);
 
+bool xrep_buf_verify_struct(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
+
 #else
 
 #define xrep_ino_dqattach(sc)	(0)
@@ -190,6 +194,7 @@ xrep_setup_nothing(
 #define xrep_setup_ag_allocbt		xrep_setup_nothing
 #define xrep_setup_ag_rmapbt		xrep_setup_nothing
 #define xrep_setup_ag_refcountbt	xrep_setup_nothing
+#define xrep_setup_xattr		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
@@ -215,6 +220,7 @@ xrep_setup_nothing(
 #define xrep_nlinks			xrep_notsupported
 #define xrep_fscounters			xrep_notsupported
 #define xrep_rtsummary			xrep_notsupported
+#define xrep_xattr			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9af91874e58b9..0b8fdd62055fe 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -334,7 +334,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_xattr,
 		.scrub	= xchk_xattr,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_xattr,
 	},
 	[XFS_SCRUB_TYPE_SYMLINK] = {	/* symbolic link */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 1f06c1ace5902..ba75a56b2e2de 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2497,6 +2497,89 @@ TRACE_EVENT(xreap_bmapi_binval_scan,
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
+DECLARE_EVENT_CLASS(xrep_xattr_salvage_class,
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
+#define DEFINE_XREP_XATTR_SALVAGE_EVENT(name) \
+DEFINE_EVENT(xrep_xattr_salvage_class, name, \
+	TP_PROTO(struct xfs_inode *ip, unsigned int flags, char *name, \
+		 unsigned int namelen, unsigned int valuelen), \
+	TP_ARGS(ip, flags, name, namelen, valuelen))
+DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_xattr_salvage_rec);
+DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_xattr_insert_rec);
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
+#define DEFINE_XREP_XATTR_EVENT(name) \
+DEFINE_EVENT(xrep_xattr_class, name, \
+	TP_PROTO(struct xfs_inode *ip, struct xfs_inode *arg_ip), \
+	TP_ARGS(ip, arg_ip))
+DEFINE_XREP_XATTR_EVENT(xrep_xattr_rebuild_tree);
+DEFINE_XREP_XATTR_EVENT(xrep_xattr_reset_fork);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 
diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index f0f532c10a5ac..1bd690ac5d368 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -1081,3 +1081,20 @@ xfarray_sort(
 	kvfree(si);
 	return error;
 }
+
+/* How many bytes is this array consuming? */
+unsigned long long
+xfarray_bytes(
+	struct xfarray		*array)
+{
+	return xfile_bytes(array->xfile);
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
index 0f1dac3aa1916..f06af7eb484ec 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -44,6 +44,8 @@ int xfarray_unset(struct xfarray *array, xfarray_idx_t idx);
 int xfarray_store(struct xfarray *array, xfarray_idx_t idx, const void *ptr);
 int xfarray_store_anywhere(struct xfarray *array, const void *ptr);
 bool xfarray_element_is_null(struct xfarray *array, const void *ptr);
+void xfarray_truncate(struct xfarray *array);
+unsigned long long xfarray_bytes(struct xfarray *array);
 
 /*
  * Load an array element, but zero the buffer if there's no data because we
diff --git a/fs/xfs/scrub/xfblob.c b/fs/xfs/scrub/xfblob.c
index 216f9cb2965a7..9c9ec90c69dbc 100644
--- a/fs/xfs/scrub/xfblob.c
+++ b/fs/xfs/scrub/xfblob.c
@@ -149,3 +149,20 @@ xfblob_free(
 	xfile_discard(blob->xfile, cookie, sizeof(key) + key.xb_size);
 	return 0;
 }
+
+/* How many bytes is this blob storage object consuming? */
+unsigned long long
+xfblob_bytes(
+	struct xfblob		*blob)
+{
+	return xfile_bytes(blob->xfile);
+}
+
+/* Drop all the blobs. */
+void
+xfblob_truncate(
+	struct xfblob	*blob)
+{
+	xfile_discard(blob->xfile, PAGE_SIZE, MAX_LFS_FILESIZE - PAGE_SIZE);
+	blob->last_offset = PAGE_SIZE;
+}
diff --git a/fs/xfs/scrub/xfblob.h b/fs/xfs/scrub/xfblob.h
index bd98647407f1d..78a67a06408f8 100644
--- a/fs/xfs/scrub/xfblob.h
+++ b/fs/xfs/scrub/xfblob.h
@@ -20,5 +20,7 @@ int xfblob_load(struct xfblob *blob, xfblob_cookie cookie, void *ptr,
 int xfblob_store(struct xfblob *blob, xfblob_cookie *cookie, const void *ptr,
 		uint32_t size);
 int xfblob_free(struct xfblob *blob, xfblob_cookie cookie);
+unsigned long long xfblob_bytes(struct xfblob *blob);
+void xfblob_truncate(struct xfblob *blob);
 
 #endif /* __XFS_SCRUB_XFBLOB_H__ */
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index 36061af2c1352..849f59da6a184 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -86,6 +86,18 @@ static inline loff_t xfile_size(struct xfile *xf)
 	return i_size_read(file_inode(xf->file));
 }
 
+static inline unsigned long long xfile_bytes(struct xfile *xf)
+{
+	struct xfile_stat	xs;
+	int			ret;
+
+	ret = xfile_stat(xf, &xs);
+	if (ret)
+		return 0;
+
+	return xs.bytes;
+}
+
 /* file block (aka system page size) to basic block conversions. */
 typedef unsigned long long	xfileoff_t;
 #define XFB_BLOCKSIZE		(PAGE_SIZE)
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a61ad61cb9136..b62518968e784 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -481,6 +481,9 @@ _xfs_buf_obj_cmp(
 		 * it stale has not yet committed. i.e. we are
 		 * reallocating a busy extent. Skip this buffer and
 		 * continue searching for an exact match.
+		 *
+		 * Note: If we're scanning for incore buffers to stale, don't
+		 * complain if we find non-stale buffers.
 		 */
 		if (!(map->bm_flags & XBM_LIVESCAN))
 			ASSERT(bp->b_flags & XBF_STALE);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ee6f569c2f3d9..2c838b7471191 100644
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

