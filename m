Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35281 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdGUEk3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:29 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6L4eRmK010307
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:40:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6L4eRNW030209
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:40:27 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v6L4eR3B019300
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:40:27 GMT
Subject: [PATCH 18/22] xfs: scrub extended attributes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jul 2017 21:40:26 -0700
Message-ID: <150061202593.14732.2028384029545105215.stgit@magnolia>
In-Reply-To: <150061190859.14732.17040548800470377701.stgit@magnolia>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Scrub the hash tree, keys, and values in an extended attribute structure.
Refactor the attribute code to use the transaction if the caller supplied
one to avoid buffer deadocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    3 -
 fs/xfs/scrub/attr.c    |  212 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c  |    8 ++
 fs/xfs/scrub/common.h  |    3 +
 fs/xfs/xfs_trace.h     |    3 -
 6 files changed, 228 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/attr.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c568d0d..da64bef 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -142,6 +142,7 @@ ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader.o \
 				   alloc.o \
+				   attr.o \
 				   bmap.o \
 				   btree.o \
 				   common.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index e646b5f..2f553ed 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -498,7 +498,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTA	14	/* attr fork block mapping */
 #define XFS_SCRUB_TYPE_BMBTC	15	/* CoW fork block mapping */
 #define XFS_SCRUB_TYPE_DIR	16	/* directory */
-#define XFS_SCRUB_TYPE_MAX	16
+#define XFS_SCRUB_TYPE_XATTR	17	/* extended attribute */
+#define XFS_SCRUB_TYPE_MAX	17
 
 /* i: repair this metadata */
 #define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
new file mode 100644
index 0000000..f6a4b59
--- /dev/null
+++ b/fs/xfs/scrub/attr.c
@@ -0,0 +1,212 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
+#include "xfs_trace.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_attr.h"
+#include "xfs_attr_leaf.h"
+#include "scrub/common.h"
+#include "scrub/dabtree.h"
+
+#include <linux/posix_acl_xattr.h>
+#include <linux/xattr.h>
+
+/* Set us up to scrub an inode's extended attributes. */
+int
+xfs_scrub_setup_xattr(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	/* Allocate the buffer without the inode lock held. */
+	sc->buf = kmem_zalloc_large(XATTR_SIZE_MAX, KM_SLEEP);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	return xfs_scrub_setup_inode_contents(sc, ip, 0);
+}
+
+/* Extended Attributes */
+
+struct xfs_scrub_xattr {
+	struct xfs_attr_list_context	context;
+	struct xfs_scrub_context	*sc;
+};
+
+#define XFS_SCRUB_ATTR_CHECK(fs_ok) \
+	XFS_SCRUB_DATA_CHECK(sx->sc, XFS_ATTR_FORK, args.blkno, "attr", fs_ok)
+#define XFS_SCRUB_ATTR_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_FILE_OP_ERROR_GOTO(sx->sc, XFS_ATTR_FORK, args.blkno, "attr", &error, label)
+/* Check that an extended attribute key can be looked up by hash. */
+static void
+xfs_scrub_xattr_listent(
+	struct xfs_attr_list_context	*context,
+	int				flags,
+	unsigned char			*name,
+	int				namelen,
+	int				valuelen)
+{
+	struct xfs_scrub_xattr		*sx;
+	struct xfs_da_args		args = {0};
+	int				error = 0;
+
+	sx = container_of(context, struct xfs_scrub_xattr, context);
+
+	args.flags = ATTR_KERNOTIME;
+	if (flags & XFS_ATTR_ROOT)
+		args.flags |= ATTR_ROOT;
+	else if (flags & XFS_ATTR_SECURE)
+		args.flags |= ATTR_SECURE;
+	args.geo = context->dp->i_mount->m_attr_geo;
+	args.whichfork = XFS_ATTR_FORK;
+	args.dp = context->dp;
+	args.name = name;
+	args.namelen = namelen;
+	args.hashval = xfs_da_hashname(args.name, args.namelen);
+	args.trans = context->tp;
+	args.value = sx->sc->buf;
+	args.valuelen = XATTR_SIZE_MAX;
+
+	error = xfs_attr_get_ilocked(context->dp, &args);
+	if (error == -EEXIST)
+		error = 0;
+	XFS_SCRUB_ATTR_OP_ERROR_GOTO(fail_xref);
+	XFS_SCRUB_ATTR_CHECK(args.valuelen == valuelen);
+
+fail_xref:
+	return;
+}
+#undef XFS_SCRUB_ATTR_OP_ERROR_GOTO
+#undef XFS_SCRUB_ATTR_CHECK
+
+/* Scrub a attribute btree record. */
+STATIC int
+xfs_scrub_xattr_rec(
+	struct xfs_scrub_da_btree	*ds,
+	int				level,
+	void				*rec)
+{
+	struct xfs_mount		*mp = ds->state->mp;
+	struct xfs_attr_leaf_entry	*ent = rec;
+	struct xfs_da_state_blk		*blk;
+	struct xfs_attr_leaf_name_local	*lentry;
+	struct xfs_attr_leaf_name_remote	*rentry;
+	struct xfs_buf			*bp;
+	xfs_dahash_t			calc_hash;
+	xfs_dahash_t			hash;
+	int				nameidx;
+	int				hdrsize;
+	unsigned int			badflags;
+	int				error;
+
+	blk = &ds->state->path.blk[level];
+
+	/* Check the hash of the entry. */
+	error = xfs_scrub_da_btree_hash(ds, level, &ent->hashval);
+	if (error)
+		goto out;
+
+	/* Find the attr entry's location. */
+	bp = blk->bp;
+	hdrsize = xfs_attr3_leaf_hdr_size(bp->b_addr);
+	nameidx = be16_to_cpu(ent->nameidx);
+	XFS_SCRUB_DA_GOTO(ds, nameidx >= hdrsize, out);
+	XFS_SCRUB_DA_GOTO(ds, nameidx < mp->m_attr_geo->blksize, out);
+
+	/* Retrieve the entry and check it. */
+	hash = be32_to_cpu(ent->hashval);
+	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
+			XFS_ATTR_INCOMPLETE);
+	XFS_SCRUB_DA_CHECK(ds, (ent->flags & badflags) == 0);
+	if (ent->flags & XFS_ATTR_LOCAL) {
+		lentry = (struct xfs_attr_leaf_name_local *)
+				(((char *)bp->b_addr) + nameidx);
+		XFS_SCRUB_DA_GOTO(ds, lentry->namelen < MAXNAMELEN, out);
+		calc_hash = xfs_da_hashname(lentry->nameval, lentry->namelen);
+	} else {
+		rentry = (struct xfs_attr_leaf_name_remote *)
+				(((char *)bp->b_addr) + nameidx);
+		XFS_SCRUB_DA_GOTO(ds, rentry->namelen < MAXNAMELEN, out);
+		calc_hash = xfs_da_hashname(rentry->name, rentry->namelen);
+	}
+	XFS_SCRUB_DA_CHECK(ds, calc_hash == hash);
+
+out:
+	return error;
+}
+
+/* Scrub the extended attribute metadata. */
+int
+xfs_scrub_xattr(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_scrub_xattr		sx = { 0 };
+	struct attrlist_cursor_kern	cursor = { 0 };
+	struct xfs_mount		*mp = sc->mp;
+	int				error = 0;
+
+	if (!xfs_inode_hasattr(sc->ip))
+		return -ENOENT;
+
+	memset(&sx, 0, sizeof(sx));
+	/* Check attribute tree structure */
+	error = xfs_scrub_da_btree(sc, XFS_ATTR_FORK, xfs_scrub_xattr_rec);
+	if (error)
+		goto out;
+
+	/* Check that every attr key can also be looked up by hash. */
+	sx.context.dp = sc->ip;
+	sx.context.cursor = &cursor;
+	sx.context.resynch = 1;
+	sx.context.put_listent = xfs_scrub_xattr_listent;
+	sx.context.tp = sc->tp;
+	sx.sc = sc;
+
+	/*
+	 * Look up every xattr in this file by name.
+	 *
+	 * The VFS only locks i_rwsem when modifying attrs, so keep all
+	 * three locks held because that's the only way to ensure we're
+	 * the only thread poking into the da btree.  We traverse the da
+	 * btree while holding a leaf buffer locked for the xattr name
+	 * iteration, which doesn't really follow the usual buffer
+	 * locking order.
+	 */
+	error = xfs_attr_list_int_ilocked(&sx.context);
+	XFS_SCRUB_OP_ERROR_GOTO(sc,
+			XFS_INO_TO_AGNO(mp, sc->ip->i_ino),
+			XFS_INO_TO_AGBNO(mp, sc->ip->i_ino),
+			"inode", &error, out);
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 92627e9..a47c654 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -686,6 +686,10 @@ xfs_scrub_teardown(
 			IRELE(sc->ip);
 		sc->ip = NULL;
 	}
+	if (sc->buf) {
+		kmem_free(sc->buf);
+		sc->buf = NULL;
+	}
 	return error;
 }
 
@@ -844,6 +848,10 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 		.setup	= xfs_scrub_setup_directory,
 		.scrub	= xfs_scrub_directory,
 	},
+	{ /* extended attributes */
+		.setup	= xfs_scrub_setup_xattr,
+		.scrub	= xfs_scrub_xattr,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 7baaa2d..1cfe0cc 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -52,6 +52,7 @@ struct xfs_scrub_context {
 	const struct xfs_scrub_meta_fns	*fns;
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip;
+	void				*buf;
 	uint				ilock_flags;
 	bool				try_harder;
 
@@ -221,6 +222,7 @@ SETUP_FN(xfs_scrub_setup_inode);
 SETUP_FN(xfs_scrub_setup_inode_bmap_data);
 SETUP_FN(xfs_scrub_setup_inode_bmap);
 SETUP_FN(xfs_scrub_setup_directory);
+SETUP_FN(xfs_scrub_setup_xattr);
 #undef SETUP_FN
 
 /* Metadata scrubbers */
@@ -243,6 +245,7 @@ SCRUB_FN(xfs_scrub_bmap_data);
 SCRUB_FN(xfs_scrub_bmap_attr);
 SCRUB_FN(xfs_scrub_bmap_cow);
 SCRUB_FN(xfs_scrub_directory);
+SCRUB_FN(xfs_scrub_xattr);
 #undef SCRUB_FN
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ccd27ec..fe4b313 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3328,7 +3328,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_BMBTD,		"bmapbtd" }, \
 	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
 	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }, \
-	{ XFS_SCRUB_TYPE_DIR,		"dir" }
+	{ XFS_SCRUB_TYPE_DIR,		"dir" }, \
+	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

