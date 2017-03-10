Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51822 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934472AbdCJXVy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Mar 2017 18:21:54 -0500
Subject: [PATCH 17/19] xfs: scrub extended attributes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 10 Mar 2017 15:21:35 -0800
Message-ID: <148918809583.6959.3381046092831629536.stgit@birch.djwong.org>
In-Reply-To: <148918798893.6959.7972227235163150709.stgit@birch.djwong.org>
References: <148918798893.6959.7972227235163150709.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Scrub the hash tree, keys, and values in an extended attribute structure.
Refactor the attribute code to use the transaction if the caller supplied
one to avoid buffer deadocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/libxfs/xfs_attr.c        |   26 +++--
 fs/xfs/libxfs/xfs_attr_remote.c |    5 +
 fs/xfs/libxfs/xfs_fs.h          |    3 -
 fs/xfs/scrub/attr.c             |  217 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c           |    5 +
 fs/xfs/scrub/common.h           |    6 +
 fs/xfs/xfs_attr.h               |    2 
 fs/xfs/xfs_attr_list.c          |   28 +++--
 fs/xfs/xfs_trace.h              |    3 -
 10 files changed, 270 insertions(+), 26 deletions(-)
 create mode 100644 fs/xfs/scrub/attr.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c05f503..d723ebc 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -106,6 +106,7 @@ xfs-y				+= xfs_aops.o \
 xfs-$(CONFIG_XFS_DEBUG)		+= $(addprefix scrub/, \
 				   agheader.o \
 				   alloc.o \
+				   attr.o \
 				   bmap.o \
 				   btree.o \
 				   common.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 6622d46..d66921b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -114,6 +114,23 @@ xfs_inode_hasattr(
  * Overall external interface routines.
  *========================================================================*/
 
+/* Retrieve an extended attribute and its value.  Must have iolock. */
+int
+xfs_attr_get_locked(
+	struct xfs_inode	*ip,
+	struct xfs_da_args	*args)
+{
+	if (!xfs_inode_hasattr(ip))
+		return -ENOATTR;
+	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
+		return xfs_attr_shortform_getvalue(args);
+	else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK))
+		return xfs_attr_leaf_get(args);
+	else
+		return xfs_attr_node_get(args);
+}
+
+/* Retrieve an extended attribute by name, and its value. */
 int
 xfs_attr_get(
 	struct xfs_inode	*ip,
@@ -141,14 +158,7 @@ xfs_attr_get(
 	args.op_flags = XFS_DA_OP_OKNOENT;
 
 	lock_mode = xfs_ilock_attr_map_shared(ip);
-	if (!xfs_inode_hasattr(ip))
-		error = -ENOATTR;
-	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
-		error = xfs_attr_shortform_getvalue(&args);
-	else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK))
-		error = xfs_attr_leaf_get(&args);
-	else
-		error = xfs_attr_node_get(&args);
+	error = xfs_attr_get_locked(ip, &args);
 	xfs_iunlock(ip, lock_mode);
 
 	*valuelenp = args.valuelen;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d52f525..76958b4 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -386,7 +386,8 @@ xfs_attr_rmtval_get(
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+			error = xfs_trans_read_buf(mp, args->trans,
+						   mp->m_ddev_targp,
 						   dblkno, dblkcnt, 0, &bp,
 						   &xfs_attr3_rmt_buf_ops);
 			if (error)
@@ -395,7 +396,7 @@ xfs_attr_rmtval_get(
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
 							&dst);
-			xfs_buf_relse(bp);
+			xfs_trans_brelse(args->trans, bp);
 			if (error)
 				return error;
 
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 7a6d1d1..f206bb4 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -508,7 +508,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTA	13	/* attr fork block mapping */
 #define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
 #define XFS_SCRUB_TYPE_DIR	15	/* directory */
-#define XFS_SCRUB_TYPE_MAX	15
+#define XFS_SCRUB_TYPE_XATTR	16	/* extended attribute */
+#define XFS_SCRUB_TYPE_MAX	16
 
 #define XFS_SCRUB_FLAG_REPAIR	0x01	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x02	/* o: needs repair */
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
new file mode 100644
index 0000000..12f2db2
--- /dev/null
+++ b/fs/xfs/scrub/attr.c
@@ -0,0 +1,217 @@
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
+/* Set us up with an inode and a buffer for reading xattr values. */
+int
+xfs_scrub_setup_inode_xattr(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	void				*buf;
+	int				error;
+
+	/* Allocate the buffer without the inode lock held. */
+	buf = kmem_zalloc_large(XATTR_SIZE_MAX, KM_SLEEP);
+	if (!buf)
+		return -ENOMEM;
+
+	error = xfs_scrub_setup_inode(sc, ip, sm, retry_deadlocked);
+	if (error) {
+		kmem_free(buf);
+		return error;
+	}
+
+	sc->buf = buf;
+	return 0;
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
+	error = xfs_attr_get_locked(context->dp, &args);
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
+	struct xfs_mount		*mp = sc->ip->i_mount;
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
+	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
+	error = xfs_attr_list_int(&sx.context);
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+
+	XFS_SCRUB_OP_ERROR_GOTO(sc,
+			XFS_INO_TO_AGNO(mp, sc->ip->i_ino),
+			XFS_INO_TO_AGBNO(mp, sc->ip->i_ino),
+			"inode", &error, out);
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index e2155d6..4e7c8c3 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -595,6 +595,10 @@ xfs_scrub_teardown(
 			IRELE(sc->ip);
 		sc->ip = NULL;
 	}
+	if (sc->buf) {
+		kmem_free(sc->buf);
+		sc->buf = NULL;
+	}
 	return error;
 }
 
@@ -703,6 +707,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_attr, NULL, NULL},
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_cow, NULL, NULL},
 	{xfs_scrub_setup_inode, xfs_scrub_directory, NULL, NULL},
+	{xfs_scrub_setup_inode_xattr, xfs_scrub_xattr, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 575c834..30b03ea 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -59,6 +59,7 @@ struct xfs_scrub_context {
 	struct xfs_scrub_metadata	*sm;
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip;
+	void				*buf;
 	bool				retry;
 
 	/* State tracking for multi-AG operations. */
@@ -226,6 +227,10 @@ int xfs_scrub_setup_inode_bmap(struct xfs_scrub_context *sc,
 			       struct xfs_inode *ip,
 			       struct xfs_scrub_metadata *sm,
 			       bool retry_deadlocked);
+int xfs_scrub_setup_inode_xattr(struct xfs_scrub_context *sc,
+				struct xfs_inode *ip,
+				struct xfs_scrub_metadata *sm,
+				bool retry_deadlocked);
 
 /* Metadata scrubbers */
 
@@ -244,5 +249,6 @@ int xfs_scrub_bmap_data(struct xfs_scrub_context *sc);
 int xfs_scrub_bmap_attr(struct xfs_scrub_context *sc);
 int xfs_scrub_bmap_cow(struct xfs_scrub_context *sc);
 int xfs_scrub_directory(struct xfs_scrub_context *sc);
+int xfs_scrub_xattr(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index d14691a..24093f4 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -117,6 +117,7 @@ typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
 			      unsigned char *, int, int);
 
 typedef struct xfs_attr_list_context {
+	struct xfs_trans		*tp;
 	struct xfs_inode		*dp;		/* inode */
 	struct attrlist_cursor_kern	*cursor;	/* position in list */
 	char				*alist;		/* output buffer */
@@ -142,6 +143,7 @@ typedef struct xfs_attr_list_context {
 int xfs_attr_inactive(struct xfs_inode *dp);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
+int xfs_attr_get_locked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 		 unsigned char *value, int *valuelenp, int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 97c45b6..42bd26d 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -230,7 +230,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	 */
 	bp = NULL;
 	if (cursor->blkno > 0) {
-		error = xfs_da3_node_read(NULL, dp, cursor->blkno, -1,
+		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, -1,
 					      &bp, XFS_ATTR_FORK);
 		if ((error != 0) && (error != -EFSCORRUPTED))
 			return error;
@@ -242,7 +242,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 			case XFS_DA_NODE_MAGIC:
 			case XFS_DA3_NODE_MAGIC:
 				trace_xfs_attr_list_wrong_blk(context);
-				xfs_trans_brelse(NULL, bp);
+				xfs_trans_brelse(context->tp, bp);
 				bp = NULL;
 				break;
 			case XFS_ATTR_LEAF_MAGIC:
@@ -254,18 +254,18 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 				if (cursor->hashval > be32_to_cpu(
 						entries[leafhdr.count - 1].hashval)) {
 					trace_xfs_attr_list_wrong_blk(context);
-					xfs_trans_brelse(NULL, bp);
+					xfs_trans_brelse(context->tp, bp);
 					bp = NULL;
 				} else if (cursor->hashval <= be32_to_cpu(
 						entries[0].hashval)) {
 					trace_xfs_attr_list_wrong_blk(context);
-					xfs_trans_brelse(NULL, bp);
+					xfs_trans_brelse(context->tp, bp);
 					bp = NULL;
 				}
 				break;
 			default:
 				trace_xfs_attr_list_wrong_blk(context);
-				xfs_trans_brelse(NULL, bp);
+				xfs_trans_brelse(context->tp, bp);
 				bp = NULL;
 			}
 		}
@@ -281,7 +281,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 		for (;;) {
 			__uint16_t magic;
 
-			error = xfs_da3_node_read(NULL, dp,
+			error = xfs_da3_node_read(context->tp, dp,
 						      cursor->blkno, -1, &bp,
 						      XFS_ATTR_FORK);
 			if (error)
@@ -297,7 +297,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 						     XFS_ERRLEVEL_LOW,
 						     context->dp->i_mount,
 						     node);
-				xfs_trans_brelse(NULL, bp);
+				xfs_trans_brelse(context->tp, bp);
 				return -EFSCORRUPTED;
 			}
 
@@ -313,10 +313,10 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 				}
 			}
 			if (i == nodehdr.count) {
-				xfs_trans_brelse(NULL, bp);
+				xfs_trans_brelse(context->tp, bp);
 				return 0;
 			}
-			xfs_trans_brelse(NULL, bp);
+			xfs_trans_brelse(context->tp, bp);
 		}
 	}
 	ASSERT(bp != NULL);
@@ -333,12 +333,12 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 		if (context->seen_enough || leafhdr.forw == 0)
 			break;
 		cursor->blkno = leafhdr.forw;
-		xfs_trans_brelse(NULL, bp);
-		error = xfs_attr3_leaf_read(NULL, dp, cursor->blkno, -1, &bp);
+		xfs_trans_brelse(context->tp, bp);
+		error = xfs_attr3_leaf_read(context->tp, dp, cursor->blkno, -1, &bp);
 		if (error)
 			return error;
 	}
-	xfs_trans_brelse(NULL, bp);
+	xfs_trans_brelse(context->tp, bp);
 	return 0;
 }
 
@@ -448,12 +448,12 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
 	trace_xfs_attr_leaf_list(context);
 
 	context->cursor->blkno = 0;
-	error = xfs_attr3_leaf_read(NULL, context->dp, 0, -1, &bp);
+	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, -1, &bp);
 	if (error)
 		return error;
 
 	xfs_attr3_leaf_list_int(bp, context);
-	xfs_trans_brelse(NULL, bp);
+	xfs_trans_brelse(context->tp, bp);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d2bb5d5..9f7079e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3369,7 +3369,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_BMBTD,		"bmapbtd" }, \
 	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
 	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }, \
-	{ XFS_SCRUB_TYPE_DIR,		"dir" }
+	{ XFS_SCRUB_TYPE_DIR,		"dir" }, \
+	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

