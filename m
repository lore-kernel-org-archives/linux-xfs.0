Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56366 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfHEAgd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:36:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750O54T029728
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:29 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u52wqv6t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:36:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750MxPZ149703
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2u50abb8wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:36:28 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x750aRvg002792
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:28 GMT
Subject: [PATCH 15/18] xfs: repair extended attributes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 04 Aug 2019 17:36:21 -0700
Message-ID: <156496538179.804304.10465392486870987928.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
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
 fs/xfs/scrub/attr.c        |   10 -
 fs/xfs/scrub/attr.h        |   10 +
 fs/xfs/scrub/attr_repair.c |  728 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h      |    2 
 fs/xfs/scrub/scrub.c       |    2 
 fs/xfs/scrub/scrub.h       |    3 
 7 files changed, 753 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index fecde2c9d2de..270a3f41fb30 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -162,6 +162,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
 				   array.o \
+				   attr_repair.o \
 				   bitmap.o \
 				   blob.o \
 				   bmap_repair.o \
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 1afc58bf71dd..67f42b666aad 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -38,9 +38,15 @@ xchk_setup_xattr_buf(
 	 * We need enough space to read an xattr value from the file or enough
 	 * space to hold three copies of the xattr free space bitmap.  We don't
 	 * need the buffer space for both purposes at the same time.
+	 *
+	 * If we're doing a repair, we need enough space to hold the largest
+	 * xattr value and the largest xattr name.
 	 */
 	sz = 3 * sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
-	sz = max_t(size_t, sz, value_size);
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+		sz = max_t(size_t, sz, value_size + XATTR_NAME_MAX + 1);
+	else
+		sz = max_t(size_t, sz, value_size);
 
 	/*
 	 * If there's already a buffer, figure out if we need to reallocate it
@@ -184,7 +190,7 @@ xchk_xattr_listent(
  * Within a char, the lowest bit of the char represents the byte with
  * the smallest address
  */
-STATIC bool
+bool
 xchk_xattr_set_map(
 	struct xfs_scrub	*sc,
 	unsigned long		*map,
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index 13a1d2e8424d..b2d758953300 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -37,6 +37,16 @@ xchk_xattr_valuebuf(
 	return ab->buf;
 }
 
+/* A place to store attribute names. */
+static inline unsigned char *
+xchk_xattr_namebuf(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_xattr_buf	*ab = sc->buf;
+
+	return (unsigned char *)ab->buf + ab->sz - XATTR_NAME_MAX - 1;
+}
+
 /* A bitmap of space usage computed by walking an attr leaf block. */
 static inline unsigned long *
 xchk_xattr_usedmap(
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
new file mode 100644
index 000000000000..b05547efc7b4
--- /dev/null
+++ b/fs/xfs/scrub/attr_repair.c
@@ -0,0 +1,728 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
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
+#include "scrub/attr.h"
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
+} __packed;
+
+struct xrep_xattr {
+	struct xfs_scrub	*sc;
+	struct xfbma		*xattr_records;
+	struct xblob		*xattr_blobs;
+
+	/* Size of the largest attribute value we're trying to salvage. */
+	size_t			max_valuelen;
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
+	if (!xfs_attr_namecheck(name, namelen))
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
+	error = xfbma_append(rx->xattr_records, &key);
+	if (error)
+		return error;
+
+	rx->max_valuelen = max_t(size_t, rx->max_valuelen, valuelen);
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
+	struct xfs_attr_sf_entry	*sfe)
+{
+	unsigned char			*value = &sfe->nameval[sfe->namelen];
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
+	unsigned char			*value;
+	unsigned long			*usedmap = xchk_xattr_usedmap(rx->sc);
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
+	unsigned long			*usedmap = xchk_xattr_usedmap(rx->sc);
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
+	    !xrep_xattr_want_salvage(ent->flags, rentry->name, rentry->namelen,
+			valuelen))
+		return 0;
+	if (!xchk_xattr_set_map(rx->sc, usedmap, nameidx, namesize))
+		return 0;
+
+	/*
+	 * Find somewhere to save this value.  We can't use the xchk_xattr_buf
+	 * here because we're still using the memory for the attr block bitmap.
+	 */
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
+	unsigned long			*usedmap = xchk_xattr_usedmap(sc);
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
+	/*
+	 * Set the xchk_attr_buf to be as large as we're going to need it to be
+	 * to compute space usage bitmaps for each attr block we try to
+	 * salvage.  We don't salvage attrs whose name and value areas are
+	 * crosslinked with anything else.
+	 */
+	error = xchk_setup_xattr_buf(sc, 0, KM_MAYFAIL);
+	if (error == -ENOMEM)
+		return -EDEADLOCK;
+	if (error)
+		return error;
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
+/* Reset a shortform attr fork. */
+static void
+xrep_xattr_reset_attr_local(
+	struct xfs_scrub	*sc,
+	uint64_t		nr_attrs)
+{
+	struct xfs_attr_sf_hdr	*hdr;
+	struct xfs_ifork	*ifp;
+
+	/*
+	 * If the data fork isn't in btree format (or there are no attrs) then
+	 * all we need to do is zap the attr fork.
+	 */
+	if (nr_attrs == 0 || sc->ip->i_d.di_format != XFS_DINODE_FMT_BTREE) {
+		xfs_attr_fork_remove(sc->ip, sc->tp);
+		return;
+	}
+
+	/*
+	 * If the data fork is in btree format we can't change di_forkoff
+	 * because we could run afoul of the rule that forks aren't supposed to
+	 * be in btree format if there's enough space in the fork that we could
+	 * have extents format.  Instead, reinitialize the shortform fork to
+	 * have zero attributes.
+	 */
+	ifp = XFS_IFORK_PTR(sc->ip, XFS_ATTR_FORK);
+	xfs_idata_realloc(sc->ip, (int)sizeof(*hdr) - ifp->if_bytes,
+			XFS_ATTR_FORK);
+	hdr = (struct xfs_attr_sf_hdr *)ifp->if_u1.if_data;
+	hdr->count = 0;
+	hdr->totsize = cpu_to_be16(sizeof(*hdr));
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE | XFS_ILOG_ADATA);
+}
+
+/* Free all the attribute fork blocks and delete the fork. */
+STATIC int
+xrep_xattr_reset_fork(
+	struct xfs_scrub	*sc,
+	uint64_t		nr_attrs)
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
+	if (sc->ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		xrep_xattr_reset_attr_local(sc, nr_attrs);
+		return 0;
+	}
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
+	error = xrep_xattr_recover(&rx);
+	if (error)
+		return error;
+
+	/*
+	 * Reset the xchk_attr_buf to be as large as we're going to need it to
+	 * be to store each attribute name and value as we re-add them to the
+	 * file.  We must preallocate the memory here because once we start
+	 * to modify the filesystem we cannot afford an ENOMEM.
+	 */
+	error = xchk_setup_xattr_buf(sc, rx.max_valuelen, KM_MAYFAIL);
+	if (error == -ENOMEM)
+		return -EDEADLOCK;
+	if (error)
+		return error;
+
+	return 0;
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
+	unsigned char			*name = xchk_xattr_namebuf(x->sc);
+	unsigned char			*value = xchk_xattr_valuebuf(x->sc);
+	int				error;
+
+	/*
+	 * The attribute name is stored near the end of the in-core buffer,
+	 * though we reserve one more byte to ensure null termination.
+	 */
+	name[XATTR_NAME_MAX] = 0;
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
+	error = xrep_xattr_reset_fork(sc, xfbma_length(xattr_records));
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
index 4ff2ef9fc13b..ea77ce90401d 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -72,6 +72,7 @@ int xrep_inode(struct xfs_scrub *sc);
 int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_symlink(struct xfs_scrub *sc);
+int xrep_xattr(struct xfs_scrub *sc);
 
 #else
 
@@ -118,6 +119,7 @@ xrep_reset_perag_resv(
 #define xrep_bmap_data			xrep_notsupported
 #define xrep_bmap_attr			xrep_notsupported
 #define xrep_symlink			xrep_notsupported
+#define xrep_xattr			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index ea1154aa2225..0561cce37a31 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -290,7 +290,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_xattr,
 		.scrub	= xchk_xattr,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_xattr,
 	},
 	[XFS_SCRUB_TYPE_SYMLINK] = {	/* symbolic link */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 16ed1d3e1404..99c4a3021284 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -170,4 +170,7 @@ struct xchk_fscounters {
 	unsigned long long	icount_max;
 };
 
+bool xchk_xattr_set_map(struct xfs_scrub *sc, unsigned long *map,
+		unsigned int start, unsigned int len);
+
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
