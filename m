Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58914 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbeFXTZZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:25:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJPPnq077819
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:25:25 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2jt8a7gese-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:25:25 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJPO5l021295
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:25:24 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5OJPOhR012221
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:25:24 GMT
Subject: [PATCH 17/21] xfs: repair extended attributes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:25:23 -0700
Message-ID: <152986832301.3155.2967196267590663478.stgit@magnolia>
In-Reply-To: <152986820984.3155.16417868536016544528.stgit@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the extended attributes look bad, try to sift through the rubble to
find whatever keys/values we can, zap the attr tree, and re-add the
values.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/scrub/attr.c        |    2 
 fs/xfs/scrub/attr_repair.c |  568 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h      |    2 
 fs/xfs/scrub/scrub.c       |    2 
 fs/xfs/scrub/scrub.h       |    3 
 6 files changed, 576 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 36156166fef0..24d8b19a837b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -164,6 +164,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   attr_repair.o \
 				   alloc_repair.o \
 				   bmap_repair.o \
 				   ialloc_repair.o \
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index de51cf8a8516..50715617eb1e 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -125,7 +125,7 @@ xfs_scrub_xattr_listent(
  * Within a char, the lowest bit of the char represents the byte with
  * the smallest address
  */
-STATIC bool
+bool
 xfs_scrub_xattr_set_map(
 	struct xfs_scrub_context	*sc,
 	unsigned long			*map,
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
new file mode 100644
index 000000000000..5f2e4dad92b7
--- /dev/null
+++ b/fs/xfs/scrub/attr_repair.c
@@ -0,0 +1,568 @@
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
+struct xfs_attr_key {
+	struct list_head		list;
+	unsigned char			*value;
+	int				valuelen;
+	int				flags;
+	int				namelen;
+	unsigned char			name[0];
+};
+
+#define XFS_ATTR_KEY_LEN(namelen) (sizeof(struct xfs_attr_key) + (namelen) + 1)
+
+struct xfs_repair_xattr {
+	struct list_head		*attrlist;
+	struct xfs_scrub_context	*sc;
+};
+
+/* Iterate each block in an attr fork extent */
+#define for_each_xfs_attr_block(mp, irec, dabno) \
+	for ((dabno) = roundup((xfs_dablk_t)(irec)->br_startoff, \
+			(mp)->m_attr_geo->fsbcount); \
+	     (dabno) < (irec)->br_startoff + (irec)->br_blockcount; \
+	     (dabno) += (mp)->m_attr_geo->fsbcount)
+
+/*
+ * Record an extended attribute key & value for later reinsertion into the
+ * inode.  Use the helpers below, don't call this directly.
+ */
+STATIC int
+__xfs_repair_xattr_salvage_attr(
+	struct xfs_repair_xattr		*rx,
+	struct xfs_buf			*bp,
+	int				flags,
+	int				idx,
+	unsigned char			*name,
+	int				namelen,
+	unsigned char			*value,
+	int				valuelen)
+{
+	struct xfs_attr_key		*key;
+	struct xfs_da_args		args;
+	int				error = -ENOMEM;
+
+	/* Ignore incomplete or oversized attributes. */
+	if ((flags & XFS_ATTR_INCOMPLETE) ||
+	    namelen > XATTR_NAME_MAX || namelen < 0 ||
+	    valuelen > XATTR_SIZE_MAX || valuelen < 0)
+		return 0;
+
+	/* Store attr key. */
+	key = kmem_alloc(XFS_ATTR_KEY_LEN(namelen), KM_MAYFAIL);
+	if (!key)
+		goto err;
+	INIT_LIST_HEAD(&key->list);
+	key->value = kmem_zalloc_large(valuelen, KM_MAYFAIL);
+	if (!key->value)
+		goto err_key;
+	key->valuelen = valuelen;
+	key->flags = flags & (ATTR_ROOT | ATTR_SECURE);
+	key->namelen = namelen;
+	key->name[namelen] = 0;
+	memcpy(key->name, name, namelen);
+
+	/* Caller already had the value, so copy it and exit. */
+	if (value) {
+		memcpy(key->value, value, valuelen);
+		goto out_ok;
+	}
+
+	/* Otherwise look up the remote value directly. */
+	memset(&args, 0, sizeof(args));
+	args.geo = rx->sc->mp->m_attr_geo;
+	args.index = idx;
+	args.namelen = namelen;
+	args.name = key->name;
+	args.valuelen = valuelen;
+	args.value = key->value;
+	args.dp = rx->sc->ip;
+	args.trans = rx->sc->tp;
+	error = xfs_attr3_leaf_getvalue(bp, &args);
+	if (error || args.rmtblkno == 0)
+		goto err_value;
+
+	error = xfs_attr_rmtval_get(&args);
+	switch (error) {
+	case 0:
+		break;
+	case -EFSBADCRC:
+	case -EFSCORRUPTED:
+		error = 0;
+		/* fall through */
+	default:
+		goto err_value;
+	}
+
+out_ok:
+	list_add_tail(&key->list, rx->attrlist);
+	return 0;
+
+err_value:
+	kmem_free(key->value);
+err_key:
+	kmem_free(key);
+err:
+	return error;
+}
+
+/*
+ * Record a local format extended attribute key & value for later reinsertion
+ * into the inode.
+ */
+static inline int
+xfs_repair_xattr_salvage_local_attr(
+	struct xfs_repair_xattr		*rx,
+	int				flags,
+	unsigned char			*name,
+	int				namelen,
+	unsigned char			*value,
+	int				valuelen)
+{
+	return __xfs_repair_xattr_salvage_attr(rx, NULL, flags, 0, name,
+			namelen, value, valuelen);
+}
+
+/*
+ * Record a remote format extended attribute key & value for later reinsertion
+ * into the inode.
+ */
+static inline int
+xfs_repair_xattr_salvage_remote_attr(
+	struct xfs_repair_xattr		*rx,
+	int				flags,
+	unsigned char			*name,
+	int				namelen,
+	struct xfs_buf			*leaf_bp,
+	int				idx,
+	int				valuelen)
+{
+	return __xfs_repair_xattr_salvage_attr(rx, leaf_bp, flags, idx,
+			name, namelen, NULL, valuelen);
+}
+
+/* Extract every xattr key that we can from this attr fork block. */
+STATIC int
+xfs_repair_xattr_recover_leaf(
+	struct xfs_repair_xattr		*rx,
+	struct xfs_buf			*bp)
+{
+	struct xfs_attr3_icleaf_hdr	leafhdr;
+	struct xfs_scrub_context	*sc = rx->sc;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_attr_leafblock	*leaf;
+	unsigned long			*usedmap = sc->buf;
+	struct xfs_attr_leaf_name_local	*lentry;
+	struct xfs_attr_leaf_name_remote *rentry;
+	struct xfs_attr_leaf_entry	*ent;
+	struct xfs_attr_leaf_entry	*entries;
+	char				*buf_end;
+	char				*name;
+	char				*name_end;
+	char				*value;
+	size_t				off;
+	unsigned int			nameidx;
+	unsigned int			namesize;
+	unsigned int			hdrsize;
+	unsigned int			namelen;
+	unsigned int			valuelen;
+	int				i;
+	int				error;
+
+	bitmap_zero(usedmap, mp->m_attr_geo->blksize);
+
+	/* Check the leaf header */
+	leaf = bp->b_addr;
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
+	xfs_scrub_xattr_set_map(sc, usedmap, 0, hdrsize);
+	entries = xfs_attr3_leaf_entryp(leaf);
+
+	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
+	for (i = 0, ent = entries; i < leafhdr.count; ent++, i++) {
+		/* Skip key if it conflicts with something else? */
+		off = (char *)ent - (char *)leaf;
+		if (!xfs_scrub_xattr_set_map(sc, usedmap, off,
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
+			namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
+					be16_to_cpu(lentry->valuelen));
+			name_end = (char *)lentry + namesize;
+			if (lentry->namelen == 0)
+				continue;
+			name = lentry->nameval;
+			namelen = lentry->namelen;
+			valuelen = be16_to_cpu(lentry->valuelen);
+			value = &name[namelen];
+		} else {
+			rentry = xfs_attr3_leaf_name_remote(leaf, i);
+			namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
+			name_end = (char *)rentry + namesize;
+			if (rentry->namelen == 0 || rentry->valueblk == 0)
+				continue;
+			name = rentry->name;
+			namelen = rentry->namelen;
+			valuelen = be32_to_cpu(rentry->valuelen);
+			value = NULL;
+		}
+		if (name_end > buf_end)
+			continue;
+		if (!xfs_scrub_xattr_set_map(sc, usedmap, nameidx, namesize))
+			continue;
+
+		/* Ok, let's save this key/value. */
+		if (ent->flags & XFS_ATTR_LOCAL)
+			error = xfs_repair_xattr_salvage_local_attr(rx,
+				ent->flags, name, namelen, value, valuelen);
+		else
+			error = xfs_repair_xattr_salvage_remote_attr(rx,
+				ent->flags, name, namelen, bp, i, valuelen);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Try to recover shortform attrs. */
+STATIC int
+xfs_repair_xattr_recover_sf(
+	struct xfs_repair_xattr		*rx)
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
+		error = xfs_repair_xattr_salvage_local_attr(rx, sfe->flags,
+				sfe->nameval, sfe->namelen,
+				&sfe->nameval[sfe->namelen], sfe->valuelen);
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
+xfs_repair_xattr_recover(
+	struct xfs_repair_xattr		*rx)
+{
+	struct xfs_iext_cursor		icur;
+	struct xfs_bmbt_irec		got;
+	struct xfs_scrub_context	*sc = rx->sc;
+	struct xfs_ifork		*ifp;
+	struct xfs_da_blkinfo		*info;
+	struct xfs_buf			*bp;
+	xfs_dablk_t			dabno;
+	int				error = 0;
+
+	if (sc->ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
+		return xfs_repair_xattr_recover_sf(rx);
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
+			error = xfs_repair_xattr_recover_leaf(rx, bp);
+			if (error)
+				return error;
+		}
+	}
+
+	return 0;
+}
+
+/* Free all the attribute fork blocks and delete the fork. */
+STATIC int
+xfs_repair_xattr_reset_btree(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_iext_cursor		icur;
+	struct xfs_bmbt_irec		got;
+	struct xfs_ifork		*ifp;
+	struct xfs_buf			*bp;
+	xfs_fileoff_t			lblk;
+	int				error;
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
+xfs_repair_xattr_key_cmp(
+	void			*priv,
+	struct list_head	*a,
+	struct list_head	*b)
+{
+	struct xfs_attr_key	*ap;
+	struct xfs_attr_key	*bp;
+	uint			ahash, bhash;
+
+	ap = container_of(a, struct xfs_attr_key, list);
+	bp = container_of(b, struct xfs_attr_key, list);
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
+xfs_repair_xattr_find_attributes(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*attributes)
+{
+	struct xfs_repair_xattr		rx;
+	struct xfs_ifork		*ifp;
+	int				error;
+
+	error = xfs_repair_ino_dqattach(sc);
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
+	rx.attrlist = attributes;
+	rx.sc = sc;
+
+	/* Read every attr key and value and record them in memory. */
+	return xfs_repair_xattr_recover(&rx);
+}
+
+/* Free all the attributes. */
+STATIC void
+xfs_repair_xattr_cancel_attrs(
+	struct list_head	*attributes)
+{
+	struct xfs_attr_key	*key;
+	struct xfs_attr_key	*n;
+
+	list_for_each_entry_safe(key, n, attributes, list) {
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
+xfs_repair_xattr_rebuild_tree(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*attributes)
+{
+	struct xfs_attr_key		*key;
+	struct xfs_attr_key		*n;
+	int				error;
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
+	list_sort(NULL, attributes, xfs_repair_xattr_key_cmp);
+	list_for_each_entry_safe(key, n, attributes, list) {
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
+	xfs_repair_xattr_cancel_attrs(attributes);
+	return 0;
+}
+
+/*
+ * Repair the extended attribute metadata.
+ *
+ * XXX: Remote attribute value buffers encompass the entire (up to 64k) buffer
+ * and we can't handle those 100% until the buffer cache learns how to deal
+ * with that.
+ */
+int
+xfs_repair_xattr(
+	struct xfs_scrub_context	*sc)
+{
+	struct list_head		attributes;
+	int				error;
+
+	if (!xfs_inode_hasattr(sc->ip))
+		return -ENOENT;
+
+	/* Collect extended attributes by parsing raw blocks. */
+	INIT_LIST_HEAD(&attributes);
+	error = xfs_repair_xattr_find_attributes(sc, &attributes);
+	if (error)
+		goto out;
+
+	/*
+	 * Invalidate and truncate all attribute fork extents.  This is the
+	 * point at which we are no longer able to bail out gracefully.
+	 * We commit the transaction here because xfs_attr_set allocates its
+	 * own transactions.
+	 */
+	error = xfs_repair_xattr_reset_btree(sc);
+	if (error)
+		goto out;
+
+	/* Now rebuild the attribute information. */
+	error = xfs_repair_xattr_rebuild_tree(sc, &attributes);
+out:
+	xfs_repair_xattr_cancel_attrs(&attributes);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 14fa8cf89799..05a63fcc2364 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -113,6 +113,7 @@ int xfs_repair_inode(struct xfs_scrub_context *sc);
 int xfs_repair_bmap_data(struct xfs_scrub_context *sc);
 int xfs_repair_bmap_attr(struct xfs_scrub_context *sc);
 int xfs_repair_symlink(struct xfs_scrub_context *sc);
+int xfs_repair_xattr(struct xfs_scrub_context *sc);
 
 #else
 
@@ -155,6 +156,7 @@ static inline int xfs_repair_rmapbt_setup(
 #define xfs_repair_bmap_data		xfs_repair_notsupported
 #define xfs_repair_bmap_attr		xfs_repair_notsupported
 #define xfs_repair_symlink		xfs_repair_notsupported
+#define xfs_repair_xattr		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 6d7ae6e0e165..857197c89729 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -323,7 +323,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_xattr,
 		.scrub	= xfs_scrub_xattr,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_xattr,
 	},
 	[XFS_SCRUB_TYPE_SYMLINK] = {	/* symbolic link */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 93a4a0b22273..270098bb3225 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -155,4 +155,7 @@ void xfs_scrub_xref_is_used_rt_space(struct xfs_scrub_context *sc,
 # define xfs_scrub_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
 #endif
 
+bool xfs_scrub_xattr_set_map(struct xfs_scrub_context *sc, unsigned long *map,
+		unsigned int start, unsigned int len);
+
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

