Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26026 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbdIUATf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 20:19:35 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8L0JYmw006256
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:19:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0JYhI018599
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:19:34 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v8L0JY1v001551
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:19:34 GMT
Subject: [PATCH 19/27] xfs: scrub inode block mappings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Sep 2017 17:19:33 -0700
Message-ID: <150595317366.18473.16089782803596011910.stgit@magnolia>
In-Reply-To: <150595305131.18473.16572195821331601191.stgit@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Scrub an individual inode's block mappings to make sure they make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    5 +
 fs/xfs/scrub/bmap.c    |  358 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h  |    5 +
 fs/xfs/scrub/scrub.c   |   12 ++
 fs/xfs/scrub/scrub.h   |    3 
 6 files changed, 382 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/bmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 28e14b7..5a77489 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -148,6 +148,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   trace.o \
 				   agheader.o \
 				   alloc.o \
+				   bmap.o \
 				   btree.o \
 				   common.o \
 				   ialloc.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2051c3d..27e9f90 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -495,9 +495,12 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
 #define XFS_SCRUB_TYPE_REFCNTBT	10	/* reference count btree */
 #define XFS_SCRUB_TYPE_INODE	11	/* inode record */
+#define XFS_SCRUB_TYPE_BMBTD	12	/* data fork block mapping */
+#define XFS_SCRUB_TYPE_BMBTA	13	/* attr fork block mapping */
+#define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	12
+#define XFS_SCRUB_TYPE_NR	15
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
new file mode 100644
index 0000000..353ed4f
--- /dev/null
+++ b/fs/xfs/scrub/bmap.c
@@ -0,0 +1,358 @@
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
+#include "xfs_inode_fork.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_rmap.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+
+/* Set us up with an inode's bmap. */
+STATIC int
+__xfs_scrub_setup_inode_bmap(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	bool				flush_data)
+{
+	struct xfs_mount		*mp = sc->mp;
+	int				error;
+
+	error = xfs_scrub_get_inode(sc, ip);
+	if (error)
+		return error;
+
+	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+
+	/*
+	 * We don't want any ephemeral data fork updates sitting around
+	 * while we inspect block mappings, so wait for directio to finish
+	 * and flush dirty data if we have delalloc reservations.
+	 */
+	if (S_ISREG(VFS_I(sc->ip)->i_mode) && flush_data) {
+		inode_dio_wait(VFS_I(sc->ip));
+		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
+		if (error)
+			goto out_unlock;
+		error = invalidate_inode_pages2(VFS_I(sc->ip)->i_mapping);
+		if (error)
+			goto out_unlock;
+	}
+
+	/* Got the inode, lock it and we're ready to go. */
+	error = xfs_scrub_trans_alloc(sc->sm, mp, &M_RES(mp)->tr_itruncate,
+			0, 0, 0, &sc->tp);
+	if (error)
+		goto out_unlock;
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+
+	return 0;
+out_unlock:
+	xfs_iunlock(sc->ip, sc->ilock_flags);
+	if (sc->ip != ip)
+		iput(VFS_I(sc->ip));
+	sc->ip = NULL;
+	return error;
+}
+
+/* Set us up to scrub the data fork. */
+int
+xfs_scrub_setup_inode_bmap_data(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	return __xfs_scrub_setup_inode_bmap(sc, ip, true);
+}
+
+/* Set us up to scrub the attr or CoW fork. */
+int
+xfs_scrub_setup_inode_bmap(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	return __xfs_scrub_setup_inode_bmap(sc, ip, false);
+}
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
+	xfs_daddr_t			eofs;
+	xfs_fileoff_t			lastoff;
+	bool				is_rt;
+	bool				is_shared;
+	int				whichfork;
+};
+
+/* Scrub a single extent record. */
+STATIC int
+xfs_scrub_bmap_extent(
+	struct xfs_inode		*ip,
+	struct xfs_btree_cur		*cur,
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_bmbt_irec		*irec)
+{
+	struct xfs_scrub_ag		sa = { 0 };
+	struct xfs_mount		*mp = info->sc->mp;
+	struct xfs_buf			*bp = NULL;
+	xfs_daddr_t			daddr;
+	xfs_daddr_t			dlen;
+	xfs_fsblock_t			bno;
+	xfs_agnumber_t			agno;
+	int				error = 0;
+
+	if (cur)
+		xfs_btree_get_block(cur, 0, &bp);
+
+	xfs_scrub_fblock_check_ok(info->sc, info->whichfork, irec->br_startoff,
+			irec->br_startoff >= info->lastoff &&
+			irec->br_startblock != HOLESTARTBLOCK &&
+			!isnullstartblock(irec->br_startblock));
+
+	/* Actual mapping, so check the block ranges. */
+	if (info->is_rt) {
+		daddr = XFS_FSB_TO_BB(mp, irec->br_startblock);
+		agno = NULLAGNUMBER;
+		bno = irec->br_startblock;
+	} else {
+		daddr = XFS_FSB_TO_DADDR(mp, irec->br_startblock);
+		agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
+		if (!xfs_scrub_fblock_check_ok(info->sc, info->whichfork,
+				irec->br_startoff, agno < mp->m_sb.sb_agcount))
+			goto out;
+		bno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
+		xfs_scrub_fblock_check_ok(info->sc, info->whichfork,
+			irec->br_startoff, bno < mp->m_sb.sb_agblocks);
+	}
+	dlen = XFS_FSB_TO_BB(mp, irec->br_blockcount);
+	xfs_scrub_fblock_check_ok(info->sc, info->whichfork, irec->br_startoff,
+			irec->br_blockcount > 0 &&
+			irec->br_blockcount <= MAXEXTLEN &&
+			daddr < info->eofs &&
+			daddr + dlen <= info->eofs &&
+			(irec->br_state != XFS_EXT_UNWRITTEN ||
+			 xfs_sb_version_hasextflgbit(&mp->m_sb)));
+
+	/* Set ourselves up for cross-referencing later. */
+	if (!info->is_rt) {
+		error = xfs_scrub_ag_init(info->sc, agno, &sa);
+		if (!xfs_scrub_fblock_op_ok(info->sc, info->whichfork,
+				irec->br_startoff, &error))
+			goto out;
+	}
+
+	xfs_scrub_ag_free(info->sc, &sa);
+out:
+	info->lastoff = irec->br_startoff + irec->br_blockcount;
+	return error;
+}
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
+			xfs_scrub_fblock_check_ok(bs->sc, info->whichfork, 0,
+					owner == ip->i_ino);
+		}
+	}
+
+	/* Set up the in-core record and scrub it. */
+	ihost.l0 = be64_to_cpu(rec->bmbt.l0);
+	ihost.l1 = be64_to_cpu(rec->bmbt.l1);
+	xfs_bmbt_get_all(&ihost, &irec);
+	return xfs_scrub_bmap_extent(ip, bs->cur, info, &irec);
+}
+
+/* Scrub an inode fork's block mappings. */
+STATIC int
+xfs_scrub_bmap(
+	struct xfs_scrub_context	*sc,
+	int				whichfork)
+{
+	struct xfs_bmbt_irec		irec;
+	struct xfs_scrub_bmap_info	info = {0};
+	struct xfs_owner_info		oinfo;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_ifork		*ifp;
+	struct xfs_btree_cur		*cur;
+	xfs_fileoff_t			endoff;
+	xfs_extnum_t			idx;
+	bool				found;
+	int				error = 0;
+
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
+		if (!xfs_scrub_ino_check_ok(sc, sc->ip->i_ino, NULL,
+				xfs_is_reflink_inode(ip)))
+			goto out_unlock;
+		break;
+	case XFS_ATTR_FORK:
+		if (!ifp)
+			goto out_unlock;
+		xfs_scrub_ino_check_ok(sc, sc->ip->i_ino, NULL,
+				xfs_sb_version_hasattr(&mp->m_sb) ||
+				xfs_sb_version_hasattr2(&mp->m_sb));
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
+		if (!xfs_scrub_fblock_check_ok(sc, whichfork, 0,
+				ifp->if_flags & XFS_IFEXTENTS))
+			goto out_unlock;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		ASSERT(whichfork != XFS_COW_FORK);
+
+		/* Scan the btree records. */
+		cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
+		xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
+		error = xfs_scrub_btree(sc, cur, xfs_scrub_bmapbt_helper,
+				&oinfo, &info);
+		xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+		if (error == -EDEADLOCK)
+			return error;
+		else if (error)
+			goto out_unlock;
+		break;
+	default:
+		xfs_scrub_fblock_check_ok(sc, whichfork, 0, false);
+		goto out_unlock;
+	}
+
+	/* Extent data is in memory, so scrub that. */
+
+	/* Find the offset of the last extent in the mapping. */
+	error = xfs_bmap_last_offset(ip, &endoff, whichfork);
+	if (!xfs_scrub_fblock_op_ok(sc, whichfork, 0, &error))
+		goto out_unlock;
+
+	/* Scrub extent records. */
+	info.lastoff = 0;
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	for (found = xfs_iext_lookup_extent(ip, ifp, 0, &idx, &irec);
+	     found != 0;
+	     found = xfs_iext_get_extent(ifp, ++idx, &irec)) {
+		if (xfs_scrub_should_terminate(&error))
+			break;
+		if (isnullstartblock(irec.br_startblock))
+			continue;
+		if (!xfs_scrub_fblock_check_ok(sc, whichfork, irec.br_startoff,
+				irec.br_startoff < endoff))
+			goto out_unlock;
+		error = xfs_scrub_bmap_extent(ip, NULL, &info, &irec);
+		if (error == -EDEADLOCK)
+			return error;
+	}
+
+out_unlock:
+	return error;
+}
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
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index ae6b557..79c00ad 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -104,7 +104,10 @@ int xfs_scrub_setup_ag_refcountbt(struct xfs_scrub_context *sc,
 				  struct xfs_inode *ip);
 int xfs_scrub_setup_inode(struct xfs_scrub_context *sc,
 			  struct xfs_inode *ip);
-
+int xfs_scrub_setup_inode_bmap(struct xfs_scrub_context *sc,
+			       struct xfs_inode *ip);
+int xfs_scrub_setup_inode_bmap_data(struct xfs_scrub_context *sc,
+				    struct xfs_inode *ip);
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b88f86e..cd896e5 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -218,6 +218,18 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.setup	= xfs_scrub_setup_inode,
 		.scrub	= xfs_scrub_inode,
 	},
+	{ /* inode data fork */
+		.setup	= xfs_scrub_setup_inode_bmap_data,
+		.scrub	= xfs_scrub_bmap_data,
+	},
+	{ /* inode attr fork */
+		.setup	= xfs_scrub_setup_inode_bmap,
+		.scrub	= xfs_scrub_bmap_attr,
+	},
+	{ /* inode CoW fork */
+		.setup	= xfs_scrub_setup_inode_bmap,
+		.scrub	= xfs_scrub_bmap_cow,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index fed8ed1..75323e4 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -74,5 +74,8 @@ int xfs_scrub_finobt(struct xfs_scrub_context *sc);
 int xfs_scrub_rmapbt(struct xfs_scrub_context *sc);
 int xfs_scrub_refcountbt(struct xfs_scrub_context *sc);
 int xfs_scrub_inode(struct xfs_scrub_context *sc);
+int xfs_scrub_bmap_data(struct xfs_scrub_context *sc);
+int xfs_scrub_bmap_attr(struct xfs_scrub_context *sc);
+int xfs_scrub_bmap_cow(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

