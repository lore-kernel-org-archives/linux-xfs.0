Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28356 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751963AbdJLBnh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:43:37 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C1harM001332
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:43:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1haGb001606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:43:36 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1haWj001912
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:43:36 GMT
Subject: [PATCH 26/30] xfs: scrub extended attributes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Oct 2017 18:43:32 -0700
Message-ID: <150777261222.1724.8888733974981391611.stgit@magnolia>
In-Reply-To: <150777244315.1724.6916081372861799350.stgit@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
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
 fs/xfs/scrub/attr.c    |  239 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h  |    2 
 fs/xfs/scrub/scrub.c   |    8 ++
 fs/xfs/scrub/scrub.h   |    2 
 fs/xfs/xfs_attr.h      |    5 +
 fs/xfs/xfs_attr_list.c |    7 +
 8 files changed, 264 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/attr.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 69aa88e..4d46399 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -148,6 +148,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   trace.o \
 				   agheader.o \
 				   alloc.o \
+				   attr.o \
 				   bmap.o \
 				   btree.o \
 				   common.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b16d004..0834ce6 100644
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
index 0000000..69a4104
--- /dev/null
+++ b/fs/xfs/scrub/attr.c
@@ -0,0 +1,239 @@
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
+/*
+ * Check that an extended attribute key can be looked up by hash.
+ *
+ * We use the XFS attribute list iterator (i.e. xfs_attr_list_int_ilocked)
+ * to call this function for every attribute key in an inode.  Once
+ * we're here, we load the attribute value to see if any errors happen,
+ * or if we get more or less data than we expected.
+ */
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
+	if (flags & XFS_ATTR_INCOMPLETE) {
+		/* Incomplete attr key, just mark the inode for preening. */
+		xfs_scrub_ino_set_preen(sx->sc, NULL);
+		return;
+	}
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
+	if (!xfs_scrub_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
+			&error))
+		goto fail_xref;
+	if (args.valuelen != valuelen)
+		xfs_scrub_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK,
+					     args.blkno);
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
+	if (nameidx < hdrsize || nameidx >= mp->m_attr_geo->blksize) {
+		xfs_scrub_da_set_corrupt(ds, level);
+		goto out;
+	}
+
+	/* Retrieve the entry and check it. */
+	hash = be32_to_cpu(ent->hashval);
+	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
+			XFS_ATTR_INCOMPLETE);
+	if ((ent->flags & badflags) != 0)
+		xfs_scrub_da_set_corrupt(ds, level);
+	if (ent->flags & XFS_ATTR_LOCAL) {
+		lentry = (struct xfs_attr_leaf_name_local *)
+				(((char *)bp->b_addr) + nameidx);
+		if (lentry->namelen <= 0) {
+			xfs_scrub_da_set_corrupt(ds, level);
+			goto out;
+		}
+		calc_hash = xfs_da_hashname(lentry->nameval, lentry->namelen);
+	} else {
+		rentry = (struct xfs_attr_leaf_name_remote *)
+				(((char *)bp->b_addr) + nameidx);
+		if (rentry->namelen <= 0) {
+			xfs_scrub_da_set_corrupt(ds, level);
+			goto out;
+		}
+		calc_hash = xfs_da_hashname(rentry->name, rentry->namelen);
+	}
+	if (calc_hash != hash)
+		xfs_scrub_da_set_corrupt(ds, level);
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
+	sx.context.flags = ATTR_INCOMPLETE;
+	sx.sc = sc;
+
+	/*
+	 * Look up every xattr in this file by name.
+	 *
+	 * Use the backend implementation of xfs_attr_list to call
+	 * xfs_scrub_xattr_listent on every attribute key in this inode.
+	 * In other words, we use the same iterator/callback mechanism
+	 * that listattr uses to scrub extended attributes, though in our
+	 * _listent function, we check the value of the attribute.
+	 *
+	 * The VFS only locks i_rwsem when modifying attrs, so keep all
+	 * three locks held because that's the only way to ensure we're
+	 * the only thread poking into the da btree.  We traverse the da
+	 * btree while holding a leaf buffer locked for the xattr name
+	 * iteration, which doesn't really follow the usual buffer
+	 * locking order.
+	 */
+	error = xfs_attr_list_int_ilocked(&sx.context);
+	if (!xfs_scrub_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
+		goto out;
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 7cd4a78..b938429 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -95,6 +95,8 @@ int xfs_scrub_setup_inode_bmap_data(struct xfs_scrub_context *sc,
 				    struct xfs_inode *ip);
 int xfs_scrub_setup_directory(struct xfs_scrub_context *sc,
 			      struct xfs_inode *ip);
+int xfs_scrub_setup_xattr(struct xfs_scrub_context *sc,
+			  struct xfs_inode *ip);
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 4a44727..7ad9f54 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -148,6 +148,10 @@ xfs_scrub_teardown(
 			iput(VFS_I(sc->ip));
 		sc->ip = NULL;
 	}
+	if (sc->buf) {
+		kmem_free(sc->buf);
+		sc->buf = NULL;
+	}
 	return error;
 }
 
@@ -221,6 +225,10 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.setup	= xfs_scrub_setup_directory,
 		.scrub	= xfs_scrub_directory,
 	},
+	{ /* extended attributes */
+		.setup	= xfs_scrub_setup_xattr,
+		.scrub	= xfs_scrub_xattr,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 844506e..d31ff58 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -59,6 +59,7 @@ struct xfs_scrub_context {
 	const struct xfs_scrub_meta_ops	*ops;
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip;
+	void				*buf;
 	uint				ilock_flags;
 	bool				try_harder;
 
@@ -83,5 +84,6 @@ int xfs_scrub_bmap_data(struct xfs_scrub_context *sc);
 int xfs_scrub_bmap_attr(struct xfs_scrub_context *sc);
 int xfs_scrub_bmap_cow(struct xfs_scrub_context *sc);
 int xfs_scrub_directory(struct xfs_scrub_context *sc);
+int xfs_scrub_xattr(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index 5d5a5e2..d07bf27 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -48,6 +48,8 @@ struct xfs_attr_list_context;
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
 #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
 
+#define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
+
 #define XFS_ATTR_FLAGS \
 	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
 	{ ATTR_ROOT,		"ROOT" }, \
@@ -56,7 +58,8 @@ struct xfs_attr_list_context;
 	{ ATTR_CREATE,		"CREATE" }, \
 	{ ATTR_REPLACE,		"REPLACE" }, \
 	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
-	{ ATTR_KERNOVAL,	"KERNOVAL" }
+	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
+	{ ATTR_INCOMPLETE,	"INCOMPLETE" }
 
 /*
  * The maximum size (into the kernel or returned from the kernel) of an
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 7740c8a..5816786 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -407,7 +407,8 @@ xfs_attr3_leaf_list_int(
 			cursor->offset = 0;
 		}
 
-		if (entry->flags & XFS_ATTR_INCOMPLETE)
+		if ((entry->flags & XFS_ATTR_INCOMPLETE) &&
+		    !(context->flags & ATTR_INCOMPLETE))
 			continue;		/* skip incomplete entries */
 
 		if (entry->flags & XFS_ATTR_LOCAL) {
@@ -583,6 +584,10 @@ xfs_attr_list(
 	    (cursor->hashval || cursor->blkno || cursor->offset))
 		return -EINVAL;
 
+	/* Only internal consumers can retrieve incomplete attrs. */
+	if (flags & ATTR_INCOMPLETE)
+		return -EINVAL;
+
 	/*
 	 * Check for a properly aligned buffer.
 	 */

