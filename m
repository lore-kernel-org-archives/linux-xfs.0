Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:32153 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758474AbcLCBjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:39:33 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id uB31dF6Z009273
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 3 Dec 2016 01:39:15 GMT
Subject: [PATCH 27/55] xfs: scrub inode block mappings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:38:11 -0800
Message-ID: <148072909150.12995.11936476795292464299.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Scrub an individual inode's block mappings to make sure they make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_bmap_btree.c |   26 +++
 fs/xfs/libxfs/xfs_fs.h         |    5 -
 fs/xfs/repair/bmap.c           |  337 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/repair/common.c         |   23 +++
 fs/xfs/repair/common.h         |    3 
 fs/xfs/xfs_bmap_util.c         |  105 +++++++-----
 fs/xfs/xfs_bmap_util.h         |    4 
 fs/xfs/xfs_trace.h             |    5 -
 9 files changed, 461 insertions(+), 48 deletions(-)
 create mode 100644 fs/xfs/repair/bmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a037d8e..d48c2f4 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -105,6 +105,7 @@ xfs-y				+= xfs_aops.o \
 xfs-$(CONFIG_XFS_ONLINE_REPAIR)	+= $(addprefix repair/, \
 				   agheader.o \
 				   alloc.o \
+				   bmap.o \
 				   btree.o \
 				   common.o \
 				   ialloc.o \
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 049fa59..54dd7a7 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -623,6 +623,16 @@ xfs_bmbt_init_key_from_rec(
 }
 
 STATIC void
+xfs_bmbt_init_high_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	key->bmbt.br_startoff = cpu_to_be64(
+			xfs_bmbt_disk_get_startoff(&rec->bmbt) +
+			xfs_bmbt_disk_get_blockcount(&rec->bmbt) - 1);
+}
+
+STATIC void
 xfs_bmbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
@@ -647,6 +657,16 @@ xfs_bmbt_key_diff(
 				      cur->bc_rec.b.br_startoff;
 }
 
+STATIC __int64_t
+xfs_bmbt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be64_to_cpu(k1->bmbt.br_startoff) -
+			  be64_to_cpu(k2->bmbt.br_startoff);
+}
+
 static bool
 xfs_bmbt_verify(
 	struct xfs_buf		*bp)
@@ -737,7 +757,6 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 };
 
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_bmbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -758,7 +777,6 @@ xfs_bmbt_recs_inorder(
 		xfs_bmbt_disk_get_blockcount(&r1->bmbt) <=
 		xfs_bmbt_disk_get_startoff(&r2->bmbt);
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
@@ -772,14 +790,14 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.get_minrecs		= xfs_bmbt_get_minrecs,
 	.get_dmaxrecs		= xfs_bmbt_get_dmaxrecs,
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
+	.diff_two_keys		= xfs_bmbt_diff_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 251db32..5c80264 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -586,7 +586,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
 #define XFS_SCRUB_TYPE_REFCNTBT	10	/* reference count btree */
 #define XFS_SCRUB_TYPE_INODE	11	/* inode record */
-#define XFS_SCRUB_TYPE_MAX	11
+#define XFS_SCRUB_TYPE_BMBTD	12	/* data fork block mapping */
+#define XFS_SCRUB_TYPE_BMBTA	13	/* attr fork block mapping */
+#define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
+#define XFS_SCRUB_TYPE_MAX	14
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/repair/bmap.c b/fs/xfs/repair/bmap.c
new file mode 100644
index 0000000..2550228
--- /dev/null
+++ b/fs/xfs/repair/bmap.c
@@ -0,0 +1,337 @@
+/*
+ * Copyright (C) 2016-2017 Oracle.  All Rights Reserved.
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
+#include "xfs_inode_fork.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_rmap.h"
+#include "repair/common.h"
+#include "repair/btree.h"
+
+/*
+ * Inode fork block mapping (BMBT) scrubber.
+ * More complex than the others because we have to scrub
+ * all the extents regardless of whether or not the fork
+ * is in btree format.
+ */
+
+struct xfs_scrub_bmap_info {
+	struct xfs_scrub_context	*sc;
+	const char			*type;
+	xfs_daddr_t			eofs;
+	xfs_fileoff_t			lastoff;
+	bool				is_rt;
+	bool				is_shared;
+	bool				scrub_btrec;
+	int				whichfork;
+};
+
+#define XFS_SCRUB_BMAP_CHECK(fs_ok) \
+	XFS_SCRUB_INO_CHECK(info->sc, info->sc->ip->i_ino, bp, info->type, fs_ok)
+#define XFS_SCRUB_BMAP_GOTO(fs_ok, label) \
+	XFS_SCRUB_INO_GOTO(info->sc, info->sc->ip->i_ino, bp, info->type, fs_ok, label)
+#define XFS_SCRUB_BMAP_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_OP_ERROR_GOTO(info->sc, agno, 0, "bmap", &error, label);
+/* Scrub a single extent record. */
+STATIC int
+xfs_scrub_bmap_extent(
+	struct xfs_inode		*ip,
+	struct xfs_btree_cur		*cur,
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_bmbt_irec		*irec)
+{
+	struct xfs_scrub_ag		sa = {0};
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_buf			*bp = NULL;
+	xfs_daddr_t			daddr;
+	xfs_daddr_t			dlen;
+	xfs_agnumber_t			agno;
+	int				error = 0;
+
+	if (cur)
+		xfs_btree_get_block(cur, 0, &bp);
+
+	XFS_SCRUB_BMAP_CHECK(irec->br_startoff >= info->lastoff);
+	XFS_SCRUB_BMAP_CHECK(irec->br_startblock != HOLESTARTBLOCK);
+
+	if (isnullstartblock(irec->br_startblock)) {
+		XFS_SCRUB_BMAP_CHECK(irec->br_state == XFS_EXT_NORM);
+		goto out;
+	}
+
+	/* Actual mapping, so check the block ranges. */
+	if (info->is_rt) {
+		daddr = XFS_FSB_TO_BB(mp, irec->br_startblock);
+		agno = NULLAGNUMBER;
+	} else {
+		daddr = XFS_FSB_TO_DADDR(mp, irec->br_startblock);
+		agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
+		XFS_SCRUB_BMAP_GOTO(agno < mp->m_sb.sb_agcount, out);
+	}
+	dlen = XFS_FSB_TO_BB(mp, irec->br_blockcount);
+	XFS_SCRUB_BMAP_CHECK(daddr < info->eofs);
+	XFS_SCRUB_BMAP_CHECK(daddr + dlen < info->eofs);
+	XFS_SCRUB_BMAP_CHECK(irec->br_state != XFS_EXT_UNWRITTEN ||
+			xfs_sb_version_hasextflgbit(&mp->m_sb));
+	if (error)
+		goto out;
+
+	/* Set ourselves up for cross-referencing later. */
+	if (!info->is_rt) {
+		if (!xfs_scrub_ag_can_lock(info->sc, agno))
+			return -EDEADLOCK;
+		error = xfs_scrub_ag_init(info->sc, agno, &sa);
+		XFS_SCRUB_BMAP_OP_ERROR_GOTO(out);
+	}
+
+	xfs_scrub_ag_free(&sa);
+out:
+	info->lastoff = irec->br_startoff + irec->br_blockcount;
+	return error;
+}
+#undef XFS_SCRUB_BMAP_OP_ERROR_GOTO
+#undef XFS_SCRUB_BMAP_GOTO
+
+/* Scrub a bmbt record. */
+STATIC int
+xfs_scrub_bmapbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_bmbt_rec_host	ihost;
+	struct xfs_bmbt_irec		irec;
+	struct xfs_scrub_bmap_info	*info = bs->private;
+	struct xfs_inode		*ip = bs->cur->bc_private.b.ip;
+	struct xfs_buf			*bp = NULL;
+	struct xfs_btree_block		*block;
+	uint64_t			owner;
+	int				i;
+
+	/*
+	 * Check the owners of the btree blocks up to the level below
+	 * the root since the verifiers don't do that.
+	 */
+	if (xfs_sb_version_hascrc(&bs->cur->bc_mp->m_sb) &&
+	    bs->cur->bc_ptrs[0] == 1) {
+		for (i = 0; i < bs->cur->bc_nlevels - 1; i++) {
+			block = xfs_btree_get_block(bs->cur, i, &bp);
+			owner = be64_to_cpu(block->bb_u.l.bb_owner);
+			XFS_SCRUB_BMAP_CHECK(owner == ip->i_ino);
+		}
+	}
+
+	if (!info->scrub_btrec)
+		return 0;
+
+	/* Set up the in-core record and scrub it. */
+	ihost.l0 = be64_to_cpu(rec->bmbt.l0);
+	ihost.l1 = be64_to_cpu(rec->bmbt.l1);
+	xfs_bmbt_get_all(&ihost, &irec);
+	return xfs_scrub_bmap_extent(ip, bs->cur, info, &irec);
+}
+#undef XFS_SCRUB_BMAP_CHECK
+
+#define XFS_SCRUB_FORK_CHECK(fs_ok) \
+	XFS_SCRUB_INO_CHECK(sc, ip->i_ino, NULL, info.type, fs_ok);
+#define XFS_SCRUB_FORK_GOTO(fs_ok, label) \
+	XFS_SCRUB_INO_GOTO(sc, ip->i_ino, NULL, info.type, fs_ok, label);
+#define XFS_SCRUB_FORK_OP_ERROR_GOTO(label) \
+	XFS_SCRUB_OP_ERROR_GOTO(sc, \
+			XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino), \
+			XFS_INO_TO_AGBNO(ip->i_mount, ip->i_ino), \
+			info.type, &error, label)
+/* Scrub an inode fork's block mappings. */
+STATIC int
+xfs_scrub_bmap(
+	struct xfs_scrub_context	*sc,
+	int				whichfork)
+{
+	struct xfs_bmbt_irec		irec;
+	struct xfs_scrub_bmap_info	info = {0};
+	struct xfs_owner_info		oinfo;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_ifork		*ifp;
+	struct xfs_btree_cur		*cur;
+	xfs_fileoff_t			off;
+	xfs_fileoff_t			endoff;
+	int				nmaps;
+	int				flags = 0;
+	int				error = 0;
+	int				err2 = 0;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		info.type = "data fork";
+		break;
+	case XFS_ATTR_FORK:
+		info.type = "attr fork";
+		break;
+	case XFS_COW_FORK:
+		info.type = "CoW fork";
+		break;
+	}
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+
+	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
+	info.eofs = XFS_FSB_TO_BB(mp, info.is_rt ? mp->m_sb.sb_rblocks :
+					      mp->m_sb.sb_dblocks);
+	info.whichfork = whichfork;
+	info.is_shared = whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(ip);
+	info.sc = sc;
+
+	switch (whichfork) {
+	case XFS_COW_FORK:
+		/* Non-existent CoW forks are ignorable. */
+		if (!ifp)
+			goto out_unlock;
+		/* No CoW forks on non-reflink inodes/filesystems. */
+		XFS_SCRUB_FORK_GOTO(xfs_is_reflink_inode(ip), out_unlock);
+		break;
+	case XFS_ATTR_FORK:
+		if (!ifp)
+			goto out_unlock;
+		XFS_SCRUB_FORK_CHECK(xfs_sb_version_hasattr(&mp->m_sb));
+		break;
+	}
+
+	/* Check the fork values */
+	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
+	case XFS_DINODE_FMT_UUID:
+	case XFS_DINODE_FMT_DEV:
+	case XFS_DINODE_FMT_LOCAL:
+		/* No mappings to check. */
+		goto out_unlock;
+	case XFS_DINODE_FMT_EXTENTS:
+		XFS_SCRUB_FORK_GOTO(ifp->if_flags & XFS_IFEXTENTS, out_unlock);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		XFS_SCRUB_FORK_CHECK(whichfork != XFS_COW_FORK);
+		/*
+		 * Scan the btree.  If extents aren't loaded, have the btree
+		 * scrub routine examine the extent records.
+		 */
+		info.scrub_btrec = !(ifp->if_flags & XFS_IFEXTENTS);
+
+		cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
+		xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
+		err2 = xfs_scrub_btree(sc, cur, xfs_scrub_bmapbt_helper,
+				&oinfo, &info);
+		xfs_btree_del_cursor(cur, err2 ? XFS_BTREE_ERROR :
+						 XFS_BTREE_NOERROR);
+		if (err2 == -EDEADLOCK)
+			return err2;
+		else if (err2)
+			goto out_unlock;
+		/* Skip in-core extent checking if we did it in the btree */
+		if (info.scrub_btrec)
+			goto out_unlock;
+		break;
+	default:
+		XFS_SCRUB_FORK_GOTO(false, out_unlock);
+		break;
+	}
+
+	/* Extent data is in memory, so scrub that. */
+	switch (whichfork) {
+	case XFS_ATTR_FORK:
+		flags |= XFS_BMAPI_ATTRFORK;
+		break;
+	case XFS_COW_FORK:
+		flags |= XFS_BMAPI_COWFORK;
+		break;
+	default:
+		break;
+	}
+
+	/* Find the offset of the last extent in the mapping. */
+	error = xfs_bmap_last_offset(ip, &endoff, whichfork);
+	XFS_SCRUB_FORK_OP_ERROR_GOTO(out_unlock);
+
+	/* Scrub extent records. */
+	off = 0;
+	while (true) {
+		nmaps = 1;
+		err2 = xfs_bmapi_read(ip, off, endoff - off, &irec,
+				&nmaps, flags);
+		if (err2 || nmaps == 0 || irec.br_startoff > endoff)
+			break;
+		/* Scrub non-hole extent. */
+		if (irec.br_startblock != HOLESTARTBLOCK) {
+			err2 = xfs_scrub_bmap_extent(ip, NULL, &info, &irec);
+			if (err2 == -EDEADLOCK)
+				return err2;
+			else if (!error && err2)
+				error = err2;
+			if (xfs_scrub_should_terminate(&error))
+				break;
+		}
+
+		off += irec.br_blockcount;
+	}
+
+out_unlock:
+	if (error == 0 && err2 != 0)
+		error = err2;
+	return error;
+}
+#undef XFS_SCRUB_FORK_CHECK
+#undef XFS_SCRUB_FORK_GOTO
+
+/* Scrub an inode's data fork. */
+int
+xfs_scrub_bmap_data(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_scrub_bmap(sc, XFS_DATA_FORK);
+}
+
+/* Scrub an inode's attr fork. */
+int
+xfs_scrub_bmap_attr(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_scrub_bmap(sc, XFS_ATTR_FORK);
+}
+
+/* Scrub an inode's CoW fork. */
+int
+xfs_scrub_bmap_cow(
+	struct xfs_scrub_context	*sc)
+{
+	if (!xfs_is_reflink_inode(sc->ip))
+		return -ENOENT;
+
+	return xfs_scrub_bmap(sc, XFS_COW_FORK);
+}
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index 40d304d65..0004632 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -801,6 +801,26 @@ xfs_scrub_setup_inode_raw(
 	return 0;
 }
 
+/* Set us up with an inode and AG headers, if needed. */
+STATIC int
+xfs_scrub_setup_inode_bmap(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	int				error;
+
+	error = xfs_scrub_setup_inode(sc, ip, sm, retry_deadlocked);
+	if (error || !retry_deadlocked)
+		return error;
+
+	error = xfs_scrub_ag_lock_all(sc);
+	if (error)
+		return xfs_scrub_teardown(sc, ip, error);
+	return 0;
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -824,6 +844,9 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header, xfs_scrub_rmapbt, NULL, xfs_sb_version_hasrmapbt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_refcountbt, NULL, xfs_sb_version_hasreflink},
 	{xfs_scrub_setup_inode_raw, xfs_scrub_inode, NULL, NULL},
+	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_data, NULL, NULL},
+	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_attr, NULL, NULL},
+	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_cow, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index 223d245..0f43a57 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -205,5 +205,8 @@ int xfs_scrub_finobt(struct xfs_scrub_context *sc);
 int xfs_scrub_rmapbt(struct xfs_scrub_context *sc);
 int xfs_scrub_refcountbt(struct xfs_scrub_context *sc);
 int xfs_scrub_inode(struct xfs_scrub_context *sc);
+int xfs_scrub_bmap_data(struct xfs_scrub_context *sc);
+int xfs_scrub_bmap_attr(struct xfs_scrub_context *sc);
+int xfs_scrub_bmap_cow(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index b9abce5..d983f28 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -231,7 +231,7 @@ xfs_bmap_count_leaves(
 	xfs_ifork_t		*ifp,
 	xfs_extnum_t		idx,
 	int			numrecs,
-	int			*count)
+	unsigned long long	*count)
 {
 	int		b;
 
@@ -250,7 +250,7 @@ xfs_bmap_disk_count_leaves(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*block,
 	int			numrecs,
-	int			*count)
+	unsigned long long	*count)
 {
 	int		b;
 	xfs_bmbt_rec_t	*frp;
@@ -265,17 +265,18 @@ xfs_bmap_disk_count_leaves(
  * Recursively walks each level of a btree
  * to count total fsblocks in use.
  */
-STATIC int                                     /* error */
+STATIC int
 xfs_bmap_count_tree(
-	xfs_mount_t     *mp,            /* file system mount point */
-	xfs_trans_t     *tp,            /* transaction pointer */
-	xfs_ifork_t	*ifp,		/* inode fork pointer */
-	xfs_fsblock_t   blockno,	/* file system block number */
-	int             levelin,	/* level in btree */
-	int		*count)		/* Count of blocks */
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_ifork	*ifp,
+	xfs_fsblock_t		blockno,
+	int			levelin,
+	unsigned int		*nextents,
+	unsigned long long	*count)
 {
 	int			error;
-	xfs_buf_t		*bp, *nbp;
+	struct xfs_buf		*bp, *nbp;
 	int			level = levelin;
 	__be64			*pp;
 	xfs_fsblock_t           bno = blockno;
@@ -308,8 +309,9 @@ xfs_bmap_count_tree(
 		/* Dive to the next level */
 		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
-		if (unlikely((error =
-		     xfs_bmap_count_tree(mp, tp, ifp, bno, level, count)) < 0)) {
+		error = xfs_bmap_count_tree(mp, tp, ifp, bno, level, nextents,
+				count);
+		if (error) {
 			xfs_trans_brelse(tp, bp);
 			XFS_ERROR_REPORT("xfs_bmap_count_tree(1)",
 					 XFS_ERRLEVEL_LOW, mp);
@@ -321,6 +323,7 @@ xfs_bmap_count_tree(
 		for (;;) {
 			nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
 			numrecs = be16_to_cpu(block->bb_numrecs);
+			(*nextents) += numrecs;
 			xfs_bmap_disk_count_leaves(mp, block, numrecs, count);
 			xfs_trans_brelse(tp, bp);
 			if (nextbno == NULLFSBLOCK)
@@ -341,44 +344,61 @@ xfs_bmap_count_tree(
 /*
  * Count fsblocks of the given fork.
  */
-static int					/* error */
+int
 xfs_bmap_count_blocks(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_inode_t		*ip,		/* incore inode */
-	int			whichfork,	/* data or attr fork */
-	int			*count)		/* out: count of blocks */
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	unsigned int		*nextents,
+	unsigned long long	*count)
 {
 	struct xfs_btree_block	*block;	/* current btree block */
 	xfs_fsblock_t		bno;	/* block # of "block" */
-	xfs_ifork_t		*ifp;	/* fork structure */
+	struct xfs_ifork	*ifp;	/* fork structure */
 	int			level;	/* btree level, for checking */
-	xfs_mount_t		*mp;	/* file system mount structure */
+	struct xfs_mount	*mp;	/* file system mount structure */
 	__be64			*pp;	/* pointer to block address */
+	int			error;
 
 	bno = NULLFSBLOCK;
 	mp = ip->i_mount;
+	*nextents = 0;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if ( XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ) {
-		xfs_bmap_count_leaves(ifp, 0, xfs_iext_count(ifp), count);
+	if (!ifp)
 		return 0;
-	}
 
-	/*
-	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
-	 */
-	block = ifp->if_broot;
-	level = be16_to_cpu(block->bb_level);
-	ASSERT(level > 0);
-	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
-	bno = be64_to_cpu(*pp);
-	ASSERT(bno != NULLFSBLOCK);
-	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
-	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
-
-	if (unlikely(xfs_bmap_count_tree(mp, tp, ifp, bno, level, count) < 0)) {
-		XFS_ERROR_REPORT("xfs_bmap_count_blocks(2)", XFS_ERRLEVEL_LOW,
-				 mp);
-		return -EFSCORRUPTED;
+	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
+	case XFS_DINODE_FMT_EXTENTS:
+		*nextents = xfs_iext_count(ifp);
+		xfs_bmap_count_leaves(ifp, 0, (*nextents), count);
+		return 0;
+	case XFS_DINODE_FMT_BTREE:
+		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+			error = xfs_iread_extents(tp, ip, whichfork);
+			if (error)
+				return error;
+		}
+
+		/*
+		 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
+		 */
+		block = ifp->if_broot;
+		level = be16_to_cpu(block->bb_level);
+		ASSERT(level > 0);
+		pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
+		bno = be64_to_cpu(*pp);
+		ASSERT(bno != NULLFSBLOCK);
+		ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
+		ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
+
+		error = xfs_bmap_count_tree(mp, tp, ifp, bno, level,
+				nextents, count);
+		if (error) {
+			XFS_ERROR_REPORT("xfs_bmap_count_blocks(2)",
+					XFS_ERRLEVEL_LOW, mp);
+			return -EFSCORRUPTED;
+		}
+		return 0;
 	}
 
 	return 0;
@@ -1788,8 +1808,9 @@ xfs_swap_extent_forks(
 	int			*target_log_flags)
 {
 	struct xfs_ifork	tempifp, *ifp, *tifp;
-	int			aforkblks = 0;
-	int			taforkblks = 0;
+	unsigned long long	aforkblks = 0;
+	unsigned long long	taforkblks = 0;
+	unsigned int		junk;
 	xfs_extnum_t		nextents;
 	__uint64_t		tmp;
 	int			error;
@@ -1799,14 +1820,14 @@ xfs_swap_extent_forks(
 	 */
 	if ( ((XFS_IFORK_Q(ip) != 0) && (ip->i_d.di_anextents > 0)) &&
 	     (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
-		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK,
+		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &junk,
 				&aforkblks);
 		if (error)
 			return error;
 	}
 	if ( ((XFS_IFORK_Q(tip) != 0) && (tip->i_d.di_anextents > 0)) &&
 	     (tip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
-		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK,
+		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK, &junk,
 				&taforkblks);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 68a621a..73a03c3 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -71,4 +71,8 @@ int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
 
 xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
 
+int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
+			  int whichfork, unsigned int *nextents,
+			  unsigned long long *count);
+
 #endif	/* __XFS_BMAP_UTIL_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5314fca..829a62f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3473,7 +3473,10 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
 	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }, \
 	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }, \
-	{ XFS_SCRUB_TYPE_INODE,		"inode" }
+	{ XFS_SCRUB_TYPE_INODE,		"inode" }, \
+	{ XFS_SCRUB_TYPE_BMBTD, 	"bmapbtd" }, \
+	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
+	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

