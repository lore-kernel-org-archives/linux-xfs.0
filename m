Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36268 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdG0WoM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2017 18:44:12 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6RMiAAK008687
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:44:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6RMiAwr018223
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:44:10 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v6RMiAQ2012123
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2017 22:44:10 GMT
Subject: [PATCH 22/26] xfs: scrub extended attributes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 27 Jul 2017 15:44:08 -0700
Message-ID: <150119544884.15159.10519535770596933613.stgit@magnolia>
In-Reply-To: <150119530010.15159.9900948790538082160.stgit@magnolia>
References: <150119530010.15159.9900948790538082160.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Scrub the hash tree, keys, and values in an extended attribute structure.
Refactor the attribute code to use the transaction if the caller supplied
one to avoid buffer deadocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    3 -
 fs/xfs/scrub/attr.c    |  212 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h  |    2 
 fs/xfs/scrub/scrub.c   |    8 ++
 fs/xfs/scrub/scrub.h   |    2 
 fs/xfs/scrub/trace.h   |    3 -
 7 files changed, 229 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/attr.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 43807bc..2a1b118 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -146,6 +146,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   trace.o \
 				   agheader.o \
 				   alloc.o \
+				   attr.o \
 				   bmap.o \
 				   btree.o \
 				   common.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 8d2bea5..d31d743 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -499,9 +499,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTA	13	/* attr fork block mapping */
 #define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
 #define XFS_SCRUB_TYPE_DIR	15	/* directory */
+#define XFS_SCRUB_TYPE_XATTR	16	/* extended attribute */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	16
+#define XFS_SCRUB_TYPE_NR	17
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
new file mode 100644
index 0000000..8ceb147
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
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_attr.h"
+#include "xfs_attr_leaf.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/dabtree.h"
+#include "scrub/trace.h"
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
+	if (!xfs_scrub_fblock_op_ok(sx->sc, XFS_ATTR_FORK, args.blkno, &error))
+		goto fail_xref;
+	xfs_scrub_fblock_check_ok(sx->sc, XFS_ATTR_FORK, args.blkno,
+			args.valuelen == valuelen);
+
+fail_xref:
+	return;
+}
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
+	if (!xfs_scrub_da_check_ok(ds, level, nameidx >= hdrsize &&
+			nameidx < mp->m_attr_geo->blksize))
+		goto out;
+
+	/* Retrieve the entry and check it. */
+	hash = be32_to_cpu(ent->hashval);
+	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
+			XFS_ATTR_INCOMPLETE);
+	xfs_scrub_da_check_ok(ds, level, (ent->flags & badflags) == 0);
+	if (ent->flags & XFS_ATTR_LOCAL) {
+		lentry = (struct xfs_attr_leaf_name_local *)
+				(((char *)bp->b_addr) + nameidx);
+		if (!xfs_scrub_da_check_ok(ds, level,
+				lentry->namelen < MAXNAMELEN))
+			goto out;
+		calc_hash = xfs_da_hashname(lentry->nameval, lentry->namelen);
+	} else {
+		rentry = (struct xfs_attr_leaf_name_remote *)
+				(((char *)bp->b_addr) + nameidx);
+		if (!xfs_scrub_da_check_ok(ds, level,
+				rentry->namelen < MAXNAMELEN))
+			goto out;
+		calc_hash = xfs_da_hashname(rentry->name, rentry->namelen);
+	}
+	xfs_scrub_da_check_ok(ds, level, calc_hash == hash);
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
+	if (!xfs_scrub_fblock_op_ok(sc, XFS_ATTR_FORK, 0, &error))
+		goto out;
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 82b8056..f0a33b3 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -110,6 +110,8 @@ int xfs_scrub_setup_inode_bmap_data(struct xfs_scrub_context *sc,
 				    struct xfs_inode *ip);
 int xfs_scrub_setup_directory(struct xfs_scrub_context *sc,
 			      struct xfs_inode *ip);
+int xfs_scrub_setup_xattr(struct xfs_scrub_context *sc,
+			  struct xfs_inode *ip);
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b0c4627..361aaff 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -161,6 +161,10 @@ xfs_scrub_teardown(
 			iput(VFS_I(sc->ip));
 		sc->ip = NULL;
 	}
+	if (sc->buf) {
+		kmem_free(sc->buf);
+		sc->buf = NULL;
+	}
 	return error;
 }
 
@@ -234,6 +238,10 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.setup	= xfs_scrub_setup_directory,
 		.scrub	= xfs_scrub_directory,
 	},
+	{ /* extended attributes */
+		.setup	= xfs_scrub_setup_xattr,
+		.scrub	= xfs_scrub_xattr,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 4c348e8..b440e26 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -54,6 +54,7 @@ struct xfs_scrub_context {
 	const struct xfs_scrub_meta_ops	*ops;
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip;
+	void				*buf;
 	uint				ilock_flags;
 	bool				try_harder;
 
@@ -78,5 +79,6 @@ int xfs_scrub_bmap_data(struct xfs_scrub_context *sc);
 int xfs_scrub_bmap_attr(struct xfs_scrub_context *sc);
 int xfs_scrub_bmap_cow(struct xfs_scrub_context *sc);
 int xfs_scrub_directory(struct xfs_scrub_context *sc);
+int xfs_scrub_xattr(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 1b59f02..549d305 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -41,7 +41,8 @@
 	{ XFS_SCRUB_TYPE_BMBTD,		"bmapbtd" }, \
 	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
 	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }, \
-	{ XFS_SCRUB_TYPE_DIR,		"dir" }
+	{ XFS_SCRUB_TYPE_DIR,		"dir" }, \
+	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

