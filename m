Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38568 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbfAACLl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:11:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0128wWj015783
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:11:37 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2pp0btp72s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:11:36 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012Bamm008352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:11:36 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012BaO4004001
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:11:36 GMT
Subject: [PATCH 14/17] xfs: repair extended attributes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:11:34 -0800
Message-ID: <154630869485.15625.8405047289184513280.stgit@magnolia>
In-Reply-To: <154630859850.15625.17640302184521917854.stgit@magnolia>
References: <154630859850.15625.17640302184521917854.stgit@magnolia>
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
 fs/xfs/scrub/attr.c        |    5 
 fs/xfs/scrub/attr_repair.c |  643 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h      |    2 
 fs/xfs/scrub/scrub.c       |    2 
 fs/xfs/scrub/scrub.h       |    3 
 6 files changed, 653 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ed719baac5af..980f2a15a5c2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -167,6 +167,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
 				   array.o \
+				   attr_repair.o \
 				   bitmap.o \
 				   blob.o \
 				   bmap_repair.o \
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 9960bc5b5d76..20a3483704c1 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -44,7 +44,8 @@ xchk_setup_xattr(
 	 * hold three copies of the xattr free space bitmap.  (Not both at
 	 * the same time.)
 	 */
-	sz = max_t(size_t, XATTR_SIZE_MAX, 3 * sizeof(long) *
+	sz = max_t(size_t, XATTR_SIZE_MAX + XATTR_NAME_MAX + 1,
+			3 * sizeof(long) *
 			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize));
 	sc->buf = kmem_zalloc_large(sz, KM_SLEEP);
 	if (!sc->buf)
@@ -130,7 +131,7 @@ xchk_xattr_listent(
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
index 000000000000..9f80de95b3df
--- /dev/null
+++ b/fs/xfs/scrub/attr_repair.c
@@ -0,0 +1,643 @@
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
+#include "xfs_bmap.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/array.h"
+#include "scrub/blob.h"
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
+	xblob_cookie		value_cookie;
+	xblob_cookie		name_cookie;
+	uint			hash;
+	int			flags;
+	uint16_t		valuelen;
+	uint16_t		namelen;
+} __attribute__((packed));
+
+struct xrep_xattr {
+	struct xfs_scrub	*sc;
+	struct xfbma		*xattr_records;
+	struct xblob		*xattr_blobs;
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
+		.namelen	= namelen,
+	};
+	int			error;
+
+	error = xblob_put(rx->xattr_blobs, &key.name_cookie, name, namelen);
+	if (error)
+		return error;
+	error = xblob_put(rx->xattr_blobs, &key.value_cookie, value, valuelen);
+	if (error)
+		return error;
+
+	key.hash = xfs_da_hashname(name, namelen);
+
+	return xfbma_append(rx->xattr_records, &key);
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
+
+	if (!xrep_xattr_want_salvage(sfe->flags, sfe->namelen, sfe->valuelen))
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
+	unsigned char			*value;
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
+		.trans	= rx->sc->tp,
+		.dp	= rx->sc->ip,
+		.index	= ent_idx,
+		.geo	= rx->sc->mp->m_attr_geo,
+	};
+	unsigned long			*usedmap = rx->sc->buf;
+	unsigned char			*value;
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
+	/* Find somewhere to save this value. */
+	value = kmem_alloc_large(valuelen, KM_MAYFAIL);
+	if (!value)
+		return -ENOMEM;
+
+	/* Look up the remote value and stash it for reconstruction. */
+	args.valuelen = valuelen;
+	args.namelen = rentry->namelen;
+	args.name = rentry->name;
+	args.value = value;
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
+			rentry->namelen, value, valuelen);
+err_free:
+	/* remote value was garbage, junk it */
+	if (error == -EFSBADCRC || error == -EFSCORRUPTED)
+		error = 0;
+	kmem_free(value);
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
+		if (xchk_should_terminate(sc, &error))
+			break;
+
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
+		if (xchk_should_terminate(rx->sc, &error))
+			break;
+
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
+		xfs_trim_extent(&got, 0, (xfs_dablk_t)-1U);
+		if (got.br_blockcount == 0)
+			continue;
+		for_each_xfs_attr_block(sc->mp, &got, dabno) {
+			if (xchk_should_terminate(sc, &error))
+				return error;
+
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
+		xfs_trim_extent(&got, 0, (xfs_dablk_t)-1U);
+		if (got.br_blockcount == 0)
+			continue;
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
+	error = xfs_bunmapi_range(&sc->tp, sc->ip, XFS_ATTR_FORK, 0, -1ULL,
+			XFS_BMAPI_NODISCARD);
+	if (error)
+		return error;
+
+	/* Log the inode core to keep it moving forward in the log. */
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
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
+	const void			*a,
+	const void			*b)
+{
+	const struct xrep_xattr_key	*ap = a;
+	const struct xrep_xattr_key	*bp = b;
+
+	if (ap->flags > bp->flags)
+		return 1;
+	else if (ap->flags < bp->flags)
+		return -1;
+
+	if (ap->hash > bp->hash)
+		return 1;
+	else if (ap->hash < bp->hash)
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
+	struct xfbma		*xattr_records,
+	struct xblob		*xattr_blobs)
+{
+	struct xrep_xattr	rx = {
+		.sc		= sc,
+		.xattr_records	= xattr_records,
+		.xattr_blobs	= xattr_blobs,
+	};
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
+	/* Read every attr key and value and record them in memory. */
+	return xrep_xattr_recover(&rx);
+}
+
+struct xrep_add_attr {
+	struct xfs_scrub	*sc;
+	struct xfbma		*xattr_records;
+	struct xblob		*xattr_blobs;
+};
+
+/* Insert one xattr key/value. */
+STATIC int
+xrep_xattr_insert_rec(
+	const void			*item,
+	void				*priv)
+{
+	const struct xrep_xattr_key	*key = item;
+	struct xrep_add_attr		*x = priv;
+	unsigned char			*name;
+	unsigned char			*value;
+	int				error;
+
+	name = x->sc->buf;
+	value = x->sc->buf + XATTR_NAME_MAX + 1;
+
+	error = xblob_get(x->xattr_blobs, key->name_cookie, name, key->namelen);
+	if (error)
+		return error;
+
+	error = xblob_free(x->xattr_blobs, key->name_cookie);
+	if (error)
+		return error;
+
+	error = xblob_get(x->xattr_blobs, key->value_cookie, value,
+			key->valuelen);
+	if (error)
+		return error;
+
+	error = xblob_free(x->xattr_blobs, key->value_cookie);
+	if (error)
+		return error;
+
+	name[key->namelen] = 0;
+	value[key->valuelen] = 0;
+
+	return xfs_attr_set(x->sc->ip, name, value, key->valuelen,
+			XFS_ATTR_NSP_ONDISK_TO_ARGS(key->flags));
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
+	struct xfbma		*xattr_records,
+	struct xblob		*xattr_blobs)
+{
+	struct xrep_add_attr	x = {
+		.sc		= sc,
+		.xattr_records	= xattr_records,
+		.xattr_blobs	= xattr_blobs,
+	};
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
+	/*
+	 * Sort the attribute keys by hash to minimize dabtree splits when we
+	 * rebuild the extended attribute information.
+	 */
+	error = xfbma_sort(xattr_records, xrep_xattr_key_cmp);
+	if (error)
+		return error;
+
+	/* Re-add every attr to the file. */
+	return xfbma_iter_del(xattr_records, xrep_xattr_insert_rec, &x);
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
+	struct xfbma		*xattr_records;
+	struct xblob		*xattr_blobs;
+	int			error;
+
+	if (!xfs_inode_hasattr(sc->ip))
+		return -ENOENT;
+
+	/* Set up some storage */
+	xattr_records = xfbma_init(sizeof(struct xrep_xattr_key));
+	if (IS_ERR(xattr_records))
+		return PTR_ERR(xattr_records);
+	xattr_blobs = xblob_init();
+	if (IS_ERR(xattr_blobs)) {
+		error = PTR_ERR(xattr_blobs);
+		goto out_arr;
+	}
+
+	/* Collect extended attributes by parsing raw blocks. */
+	error = xrep_xattr_find_attributes(sc, xattr_records, xattr_blobs);
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
+	error = xrep_xattr_rebuild_tree(sc, xattr_records, xattr_blobs);
+out:
+	xblob_destroy(xattr_blobs);
+out_arr:
+	xfbma_destroy(xattr_records);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 0056835b2e15..bd80770fb3c5 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -70,6 +70,7 @@ int xrep_inode(struct xfs_scrub *sc);
 int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_symlink(struct xfs_scrub *sc);
+int xrep_xattr(struct xfs_scrub *sc);
 
 #else
 
@@ -111,6 +112,7 @@ xrep_reset_perag_resv(
 #define xrep_bmap_data			xrep_notsupported
 #define xrep_bmap_attr			xrep_notsupported
 #define xrep_symlink			xrep_notsupported
+#define xrep_xattr			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 39238e92219b..b93b03e4dfca 100644
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
index 81333809c198..780cc8e9ef6a 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -139,4 +139,7 @@ void xchk_xref_is_used_rt_space(struct xfs_scrub *sc, xfs_rtblock_t rtbno,
 # define xchk_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
 #endif
 
+bool xchk_xattr_set_map(struct xfs_scrub *sc, unsigned long *map,
+		unsigned int start, unsigned int len);
+
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
