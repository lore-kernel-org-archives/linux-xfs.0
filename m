Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41470 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbeGZBfy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 21:35:54 -0400
Subject: [PATCH 14/16] xfs: repair extended attributes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 Jul 2018 17:21:39 -0700
Message-ID: <153256449926.29021.12551448240961968713.stgit@magnolia>
In-Reply-To: <153256436688.29021.4638459579042241728.stgit@magnolia>
References: <153256436688.29021.4638459579042241728.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

If the extended attributes look bad, try to sift through the rubble to
find whatever keys/values we can, zap the attr tree, and re-add the
values.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/scrub/attr.c        |    2 
 fs/xfs/scrub/attr_repair.c |  611 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h      |    2 
 fs/xfs/scrub/scrub.c       |    2 
 fs/xfs/scrub/scrub.h       |    3 
 6 files changed, 619 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e25cde969d99..c3963c88f952 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -164,6 +164,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   attr_repair.o \
 				   alloc_repair.o \
 				   bitmap.o \
 				   bmap_repair.o \
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 81d5e90547a1..e20074c241b5 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -125,7 +125,7 @@ xchk_xattr_listent(
  * Within a char, the lowest bit of the char represents the byte with
  * the smallest address
  */
-STATIC bool
+bool
 xchk_xattr_set_map(
 	struct xfs_scrub	*sc,
 	unsigned long		*map,
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
new file mode 100644
index 000000000000..5bacfb88f25e
--- /dev/null
+++ b/fs/xfs/scrub/attr_repair.c
@@ -0,0 +1,611 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
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
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * Extended Attribute Repair
+ * =========================
+ *
+ * We repair extended attributes by reading the attribute fork blocks looking
+ * for keys and values, then truncate the entire attr fork and reinsert all
+ * the attributes.  Unfortunately, there's no secondary copy of most extended
+ * attribute data, which means that if we blow up midway through there's
+ * little we can do.
+ */
+
+struct xrep_xattr_key {
+	struct list_head	list;
+	unsigned char		*value;
+	int			valuelen;
+	int			flags;
+	int			namelen;
+	unsigned char		name[0];
+};
+
+#define XREP_XATTR_KEY_LEN(namelen) \
+	(sizeof(struct xrep_xattr_key) + (namelen) + 1)
+
+struct xrep_xattr {
+	struct list_head	*attrlist;
+	struct xfs_scrub	*sc;
+};
+
+/*
+ * Iterate each block in an attr fork extent.  The m_attr_geo fsbcount is
+ * always 1 for now, but code defensively in case this ever changes.
+ */
+#define for_each_xfs_attr_block(mp, irec, dabno) \
+	for ((dabno) = roundup((xfs_dablk_t)(irec)->br_startoff, \
+			(mp)->m_attr_geo->fsbcount); \
+	     (dabno) < (irec)->br_startoff + (irec)->br_blockcount; \
+	     (dabno) += (mp)->m_attr_geo->fsbcount)
+
+/*
+ * Decide if we want to salvage this attribute.  We don't bother with
+ * incomplete or oversized keys or values.
+ */
+STATIC int
+xrep_xattr_want_salvage(
+	int			flags,
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
+STATIC struct xrep_xattr_key *
+xrep_xattr_salvage_key(
+	int			flags,
+	unsigned char		*name,
+	int			namelen,
+	int			valuelen)
+{
+	struct xrep_xattr_key	*key;
+
+	/* Store attr key. */
+	key = kmem_alloc(XREP_XATTR_KEY_LEN(namelen), KM_MAYFAIL);
+	if (!key)
+		return NULL;
+	INIT_LIST_HEAD(&key->list);
+	key->valuelen = valuelen;
+	key->flags = flags & (ATTR_ROOT | ATTR_SECURE);
+	key->namelen = namelen;
+	key->name[namelen] = 0;
+	memcpy(key->name, name, namelen);
+	key->value = NULL;
+	if (valuelen) {
+		key->value = kmem_alloc_large(valuelen, KM_MAYFAIL);
+		if (!key->value) {
+			kmem_free(key);
+			return NULL;
+		}
+	}
+	return key;
+}
+
+/*
+ * Record a shortform extended attribute key & value for later reinsertion
+ * into the inode.
+ */
+STATIC int
+xrep_xattr_salvage_sf_attr(
+	struct xrep_xattr		*rx,
+	struct xfs_attr_sf_entry	*sfe)
+{
+	unsigned char			*value = &sfe->nameval[sfe->namelen];
+	struct xrep_xattr_key		*key;
+
+	if (!xrep_xattr_want_salvage(sfe->flags, sfe->namelen, sfe->valuelen))
+		return 0;
+	key = xrep_xattr_salvage_key(sfe->flags, sfe->nameval, sfe->namelen,
+			sfe->valuelen);
+	if (!key)
+		return -ENOMEM;
+	if (sfe->valuelen)
+		memcpy(key->value, value, sfe->valuelen);
+	list_add_tail(&key->list, rx->attrlist);
+	return 0;
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
+	struct xrep_xattr_key		*key;
+	unsigned long			*usedmap = rx->sc->buf;
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
+	if (!xrep_xattr_want_salvage(ent->flags, lentry->namelen, valuelen))
+		return 0;
+	if (!xchk_xattr_set_map(rx->sc, usedmap, nameidx, namesize))
+		return 0;
+
+	/* Try to save this attribute. */
+	key = xrep_xattr_salvage_key(ent->flags, lentry->nameval,
+			lentry->namelen, valuelen);
+	if (!key)
+		return -ENOMEM;
+	if (valuelen)
+		memcpy(key->value, &lentry->nameval[lentry->namelen], valuelen);
+	list_add_tail(&key->list, rx->attrlist);
+	return 0;
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
+		.trans		= rx->sc->tp,
+		.dp		= rx->sc->ip,
+		.index		= ent_idx,
+		.geo		= rx->sc->mp->m_attr_geo,
+	};
+	struct xrep_xattr_key		*key;
+	unsigned long			*usedmap = rx->sc->buf;
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
+	    !xrep_xattr_want_salvage(ent->flags, rentry->namelen, valuelen))
+		return 0;
+	if (!xchk_xattr_set_map(rx->sc, usedmap, nameidx, namesize))
+		return 0;
+
+	/* Try to save this attribute. */
+	key = xrep_xattr_salvage_key(ent->flags, rentry->name, rentry->namelen,
+			valuelen);
+	if (!key)
+		return -ENOMEM;
+
+	/* Look up the remote value and stash it for reconstruction. */
+	args.valuelen = valuelen;
+	args.namelen = rentry->namelen;
+	args.name = key->name;
+	args.value = key->value;
+	error = xfs_attr3_leaf_getvalue(leaf_bp, &args);
+	if (error || args.rmtblkno == 0)
+		goto err_free;
+
+	error = xfs_attr_rmtval_get(&args);
+	if (error == 0) {
+		/* Got the value, add the attr and get out. */
+		list_add_tail(&key->list, rx->attrlist);
+		return 0;
+	}
+
+err_free:
+	/* remote value was garbage, junk it */
+	if (error == -EFSBADCRC || error == -EFSCORRUPTED)
+		error = 0;
+	kmem_free(key->value);
+	kmem_free(key);
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
+	unsigned long			*usedmap = sc->buf;
+	struct xfs_attr_leaf_name_local	*lentry;
+	struct xfs_attr_leaf_name_remote *rentry;
+	struct xfs_attr_leaf_entry	*ent;
+	struct xfs_attr_leaf_entry	*entries;
+	char				*buf_end;
+	size_t				off;
+	unsigned int			nameidx;
+	unsigned int			hdrsize;
+	int				i;
+	int				error = 0;
+
+	bitmap_zero(usedmap, mp->m_attr_geo->blksize);
+
+	/* Check the leaf header */
+	leaf = bp->b_addr;
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
+	xchk_xattr_set_map(sc, usedmap, 0, hdrsize);
+	entries = xfs_attr3_leaf_entryp(leaf);
+
+	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
+	for (i = 0, ent = entries; i < leafhdr.count; ent++, i++) {
+		/* Skip key if it conflicts with something else? */
+		off = (char *)ent - (char *)leaf;
+		if (!xchk_xattr_set_map(sc, usedmap, off,
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
+			break;
+	}
+
+	return error;
+}
+
+/* Try to recover shortform attrs. */
+STATIC int
+xrep_xattr_recover_sf(
+	struct xrep_xattr		*rx)
+{
+	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_attr_sf_entry	*next;
+	struct xfs_ifork		*ifp;
+	unsigned char			*end;
+	int				i;
+	int				error;
+
+	ifp = XFS_IFORK_PTR(rx->sc->ip, XFS_ATTR_FORK);
+	sf = (struct xfs_attr_shortform *)rx->sc->ip->i_afp->if_u1.if_data;
+	end = (unsigned char *)ifp->if_u1.if_data + ifp->if_bytes;
+
+	for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
+		next = XFS_ATTR_SF_NEXTENTRY(sfe);
+		if ((unsigned char *)next > end)
+			break;
+
+		/* Ok, let's save this key/value. */
+		error = xrep_xattr_salvage_sf_attr(rx, sfe);
+		if (error)
+			return error;
+
+		sfe = next;
+	}
+
+	return 0;
+}
+
+/* Extract as many attribute keys and values as we can. */
+STATIC int
+xrep_xattr_recover(
+	struct xrep_xattr	*rx)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	struct xfs_scrub	*sc = rx->sc;
+	struct xfs_ifork	*ifp;
+	struct xfs_da_blkinfo	*info;
+	struct xfs_buf		*bp;
+	xfs_dablk_t		dabno;
+	int			error = 0;
+
+	if (sc->ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
+		return xrep_xattr_recover_sf(rx);
+
+	/* Iterate each attr block in the attr fork. */
+	ifp = XFS_IFORK_PTR(sc->ip, XFS_ATTR_FORK);
+	for_each_xfs_iext(ifp, &icur, &got) {
+		for_each_xfs_attr_block(sc->mp, &got, dabno) {
+			/*
+			 * Try to read buffer.  We invalidate them in the next
+			 * step so we don't bother to set a buffer type or
+			 * ops.
+			 */
+			error = xfs_da_read_buf(sc->tp, sc->ip, dabno, -1, &bp,
+					XFS_ATTR_FORK, NULL);
+			if (error || !bp)
+				continue;
+
+			/* Screen out non-leaves & other garbage. */
+			info = bp->b_addr;
+			if (info->magic != cpu_to_be16(XFS_ATTR3_LEAF_MAGIC) ||
+			    xfs_attr3_leaf_buf_ops.verify_struct(bp) != NULL)
+				continue;
+
+			error = xrep_xattr_recover_leaf(rx, bp);
+			if (error)
+				return error;
+		}
+	}
+
+	return error;
+}
+
+/* Free all the attribute fork blocks and delete the fork. */
+STATIC int
+xrep_xattr_reset_btree(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	struct xfs_ifork	*ifp;
+	struct xfs_buf		*bp;
+	xfs_fileoff_t		lblk;
+	int			error;
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	if (sc->ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
+		goto out_fork_remove;
+
+	/* Invalidate each attr block in the attr fork. */
+	ifp = XFS_IFORK_PTR(sc->ip, XFS_ATTR_FORK);
+	for_each_xfs_iext(ifp, &icur, &got) {
+		for_each_xfs_attr_block(sc->mp, &got, lblk) {
+			error = xfs_da_get_buf(sc->tp, sc->ip, lblk, -1, &bp,
+					XFS_ATTR_FORK);
+			if (error || !bp)
+				continue;
+			xfs_trans_binval(sc->tp, bp);
+			error = xfs_trans_roll_inode(&sc->tp, sc->ip);
+			if (error)
+				return error;
+		}
+	}
+
+	/* Now free all the blocks. */
+	error = xfs_itruncate_extents(&sc->tp, sc->ip, XFS_ATTR_FORK, 0);
+	if (error)
+		return error;
+
+out_fork_remove:
+	/* Reset the attribute fork - this also destroys the in-core fork */
+	xfs_attr_fork_remove(sc->ip, sc->tp);
+	return 0;
+}
+
+/*
+ * Compare two xattr keys.  ATTR_SECURE keys come before ATTR_ROOT and
+ * ATTR_ROOT keys come before user attrs.  Otherwise sort in hash order.
+ */
+static int
+xrep_xattr_key_cmp(
+	void			*priv,
+	struct list_head	*a,
+	struct list_head	*b)
+{
+	struct xrep_xattr_key	*ap;
+	struct xrep_xattr_key	*bp;
+	uint			ahash;
+	uint			bhash;
+
+	ap = container_of(a, struct xrep_xattr_key, list);
+	bp = container_of(b, struct xrep_xattr_key, list);
+
+	if (ap->flags > bp->flags)
+		return 1;
+	else if (ap->flags < bp->flags)
+		return -1;
+
+	ahash = xfs_da_hashname(ap->name, ap->namelen);
+	bhash = xfs_da_hashname(bp->name, bp->namelen);
+	if (ahash > bhash)
+		return 1;
+	else if (ahash < bhash)
+		return -1;
+	return 0;
+}
+
+/*
+ * Find all the extended attributes for this inode by scraping them out of the
+ * attribute key blocks by hand.  The caller must clean up the lists if
+ * anything goes wrong.
+ */
+STATIC int
+xrep_xattr_find_attributes(
+	struct xfs_scrub	*sc,
+	struct list_head	*attrlist)
+{
+	struct xrep_xattr	rx;
+	struct xfs_ifork	*ifp;
+	int			error;
+
+	error = xrep_ino_dqattach(sc);
+	if (error)
+		return error;
+
+	/* Extent map should be loaded. */
+	ifp = XFS_IFORK_PTR(sc->ip, XFS_ATTR_FORK);
+	if (XFS_IFORK_FORMAT(sc->ip, XFS_ATTR_FORK) != XFS_DINODE_FMT_LOCAL &&
+	    !(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(sc->tp, sc->ip, XFS_ATTR_FORK);
+		if (error)
+			return error;
+	}
+
+	rx.attrlist = attrlist;
+	rx.sc = sc;
+
+	/* Read every attr key and value and record them in memory. */
+	return xrep_xattr_recover(&rx);
+}
+
+/* Free all the attributes. */
+STATIC void
+xrep_xattr_cancel_attrs(
+	struct list_head	*attrlist)
+{
+	struct xrep_xattr_key	*key;
+	struct xrep_xattr_key	*n;
+
+	list_for_each_entry_safe(key, n, attrlist, list) {
+		list_del(&key->list);
+		kmem_free(key->value);
+		kmem_free(key);
+	}
+}
+
+/*
+ * Insert all the attributes that we collected.
+ *
+ * Commit the repair transaction and drop the ilock because the attribute
+ * setting code needs to be able to allocate special transactions and take the
+ * ilock on its own.  Some day we'll have deferred attribute setting, at which
+ * point we'll be able to use that to replace the attributes atomically and
+ * safely.
+ */
+STATIC int
+xrep_xattr_rebuild_tree(
+	struct xfs_scrub	*sc,
+	struct list_head	*attrlist)
+{
+	struct xrep_xattr_key	*key;
+	struct xrep_xattr_key	*n;
+	int			error;
+
+	error = xfs_trans_commit(sc->tp);
+	sc->tp = NULL;
+	if (error)
+		return error;
+
+	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
+	sc->ilock_flags &= ~XFS_ILOCK_EXCL;
+
+	/* Re-add every attr to the file. */
+	list_sort(NULL, attrlist, xrep_xattr_key_cmp);
+	list_for_each_entry_safe(key, n, attrlist, list) {
+		error = xfs_attr_set(sc->ip, key->name, key->value,
+				key->valuelen, key->flags);
+		if (error)
+			return error;
+
+		/*
+		 * If the attr value is larger than a single page, free the
+		 * key now so that we aren't hogging memory while doing a lot
+		 * of metadata updates.  Otherwise, we want to spend as little
+		 * time reconstructing the attrs as we possibly can.
+		 */
+		if (key->valuelen <= PAGE_SIZE)
+			continue;
+		list_del(&key->list);
+		kmem_free(key->value);
+		kmem_free(key);
+	}
+
+	xrep_xattr_cancel_attrs(attrlist);
+	return 0;
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
+	struct list_head	attrlist;
+	int			error;
+
+	if (!xfs_inode_hasattr(sc->ip))
+		return -ENOENT;
+
+	/* Collect extended attributes by parsing raw blocks. */
+	INIT_LIST_HEAD(&attrlist);
+	error = xrep_xattr_find_attributes(sc, &attrlist);
+	if (error)
+		goto out;
+
+	/*
+	 * Invalidate and truncate all attribute fork extents.  This is the
+	 * point at which we are no longer able to bail out gracefully.
+	 * We commit the transaction here because xfs_attr_set allocates its
+	 * own transactions.
+	 */
+	error = xrep_xattr_reset_btree(sc);
+	if (error)
+		goto out;
+
+	/* Now rebuild the attribute information. */
+	error = xrep_xattr_rebuild_tree(sc, &attrlist);
+out:
+	xrep_xattr_cancel_attrs(&attrlist);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 17769efb20d9..b630084d0f39 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -69,6 +69,7 @@ int xrep_inode(struct xfs_scrub *sc);
 int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_symlink(struct xfs_scrub *sc);
+int xrep_xattr(struct xfs_scrub *sc);
 
 #else
 
@@ -110,6 +111,7 @@ xrep_reset_perag_resv(
 #define xrep_bmap_data			xrep_notsupported
 #define xrep_bmap_attr			xrep_notsupported
 #define xrep_symlink			xrep_notsupported
+#define xrep_xattr			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0a8eea77e58f..537636d789fb 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -301,7 +301,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_xattr,
 		.scrub	= xchk_xattr,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_xattr,
 	},
 	[XFS_SCRUB_TYPE_SYMLINK] = {	/* symbolic link */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 762db46fd696..d7ad8fad9318 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -139,4 +139,7 @@ void xchk_xref_is_used_rt_space(struct xfs_scrub *sc, xfs_rtblock_t rtbno,
 # define xchk_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
 #endif
 
+bool xchk_xattr_set_map(struct xfs_scrub *sc, unsigned long *map,
+		unsigned int start, unsigned int len);
+
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

