Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57328 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752331AbeEOWfq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 18:35:46 -0400
Subject: [PATCH 19/22] xfs: repair extended attributes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 15 May 2018 15:35:41 -0700
Message-ID: <152642374185.1556.15481575793461468110.stgit@magnolia>
In-Reply-To: <152642361893.1556.9335169821674946249.stgit@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

If the extended attributes look bad, try to sift through the rubble to
find whatever keys/values we can, zap the attr tree, and re-add the
values.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/scrub/attr.c        |    2 
 fs/xfs/scrub/attr_repair.c |  519 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h      |    2 
 fs/xfs/scrub/scrub.c       |    2 
 fs/xfs/scrub/scrub.h       |    3 
 6 files changed, 527 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5e336892f21f..5bc7e2deacbd 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -175,6 +175,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   attr_repair.o \
 				   alloc_repair.o \
 				   bmap_repair.o \
 				   ialloc_repair.o \
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 84b6d6b66578..ac25d624286e 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -139,7 +139,7 @@ xfs_scrub_xattr_listent(
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
index 000000000000..c7a50fd8f0f5
--- /dev/null
+++ b/fs/xfs/scrub/attr_repair.c
@@ -0,0 +1,519 @@
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
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
+/* Extended attribute repair. */
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
+	struct list_head		attrlist;
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
+	list_add_tail(&key->list, &rx->attrlist);
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
+xfs_repair_xattr_zap(
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
+/* Repair the extended attribute metadata. */
+int
+xfs_repair_xattr(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_repair_xattr		rx;
+	struct xfs_attr_key		*key, *next;
+	struct xfs_ifork		*ifp;
+	int				error;
+
+	if (!xfs_inode_hasattr(sc->ip))
+		return -ENOENT;
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
+	memset(&rx, 0, sizeof(rx));
+	rx.sc = sc;
+	INIT_LIST_HEAD(&rx.attrlist);
+
+	/* Read every attr key and value and record them in memory. */
+	error = xfs_repair_xattr_recover(&rx);
+	if (error)
+		return error;
+
+	/* Reinsert the security and root attrs first. */
+	list_sort(NULL, &rx.attrlist, xfs_repair_xattr_key_cmp);
+
+	/*
+	 * Invalidate and truncate the attribute fork extents, commit the
+	 * repair transaction, and drop the ilock.  The attribute setting code
+	 * needs to be able to allocate special transactions and take the
+	 * ilock on its own.  This means that we can't 100% prevent other
+	 * programs from accessing the inode while we're rebuilding the
+	 * attributes.
+	 */
+	error = xfs_repair_xattr_zap(sc);
+	if (error)
+		goto out_attrs;
+	error = xfs_trans_commit(sc->tp);
+	sc->tp = NULL;
+	if (error)
+		goto out_attrs;
+	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
+	sc->ilock_flags &= ~XFS_ILOCK_EXCL;
+
+	/* Re-add every attr to the file. */
+	list_for_each_entry_safe(key, next, &rx.attrlist, list) {
+		error = xfs_attr_set(sc->ip, key->name, key->value,
+				key->valuelen, key->flags);
+		if (error)
+			goto out_attrs;
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
+out_attrs:
+	/* Free attribute list. */
+	list_for_each_entry_safe(key, next, &rx.attrlist, list) {
+		list_del(&key->list);
+		kmem_free(key->value);
+		kmem_free(key);
+	}
+
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 4c48da0dfc02..bac0668b0396 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -120,6 +120,7 @@ int xfs_repair_inode(struct xfs_scrub_context *sc);
 int xfs_repair_bmap_data(struct xfs_scrub_context *sc);
 int xfs_repair_bmap_attr(struct xfs_scrub_context *sc);
 int xfs_repair_symlink(struct xfs_scrub_context *sc);
+int xfs_repair_xattr(struct xfs_scrub_context *sc);
 
 #else
 
@@ -180,6 +181,7 @@ static inline int xfs_repair_rmapbt_setup(
 #define xfs_repair_bmap_data		xfs_repair_notsupported
 #define xfs_repair_bmap_attr		xfs_repair_notsupported
 #define xfs_repair_symlink		xfs_repair_notsupported
+#define xfs_repair_xattr		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index e22b48e0b2f3..4fc0b6a4ae70 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -319,7 +319,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xfs_scrub_setup_xattr,
 		.scrub	= xfs_scrub_xattr,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_xattr,
 	},
 	[XFS_SCRUB_TYPE_SYMLINK] = {	/* symbolic link */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 8cf4062e069d..336c3169ae92 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -156,4 +156,7 @@ void xfs_scrub_xref_is_used_rt_space(struct xfs_scrub_context *sc,
 # define xfs_scrub_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
 #endif
 
+bool xfs_scrub_xattr_set_map(struct xfs_scrub_context *sc, unsigned long *map,
+		unsigned int start, unsigned int len);
+
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

