Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49367 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752812AbdGXUFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2017 16:05:35 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6OK5Y5B008421
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2017 20:05:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6OK5Xd0027069
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2017 20:05:34 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v6OK5XdD009199
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2017 20:05:33 GMT
Date: Mon, 24 Jul 2017 13:05:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/22] xfs: scrub inode block mappings
Message-ID: <20170724200531.GH4352@magnolia>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061200031.14732.1433534154923181136.stgit@magnolia>
 <51f5765c-1f64-74ab-e191-caea129cb6e4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51f5765c-1f64-74ab-e191-caea129cb6e4@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jul 23, 2017 at 10:41:48AM -0700, Allison Henderson wrote:
> 
> 
> On 7/20/2017 9:40 PM, Darrick J. Wong wrote:
> >From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> >Scrub an individual inode's block mappings to make sure they make sense.
> >
> >Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >---
> > fs/xfs/Makefile        |    1
> > fs/xfs/libxfs/xfs_fs.h |    5 +
> > fs/xfs/scrub/bmap.c    |  378 ++++++++++++++++++++++++++++++++++++++++++++++++
> > fs/xfs/scrub/common.c  |   12 ++
> > fs/xfs/scrub/common.h  |    5 +
> > fs/xfs/xfs_trace.h     |    5 +
> > 6 files changed, 404 insertions(+), 2 deletions(-)
> > create mode 100644 fs/xfs/scrub/bmap.c
> >
> >
> >diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> >index 2ba33ad..89c67e1a 100644
> >--- a/fs/xfs/Makefile
> >+++ b/fs/xfs/Makefile
> >@@ -142,6 +142,7 @@ ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
> > xfs-y				+= $(addprefix scrub/, \
> > 				   agheader.o \
> > 				   alloc.o \
> >+				   bmap.o \
> > 				   btree.o \
> > 				   common.o \
> > 				   ialloc.o \
> >diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> >index 277b528..d762277 100644
> >--- a/fs/xfs/libxfs/xfs_fs.h
> >+++ b/fs/xfs/libxfs/xfs_fs.h
> >@@ -494,7 +494,10 @@ struct xfs_scrub_metadata {
> > #define XFS_SCRUB_TYPE_RMAPBT	10	/* reverse mapping btree */
> > #define XFS_SCRUB_TYPE_REFCNTBT	11	/* reference count btree */
> > #define XFS_SCRUB_TYPE_INODE	12	/* inode record */
> >-#define XFS_SCRUB_TYPE_MAX	12
> >+#define XFS_SCRUB_TYPE_BMBTD	13	/* data fork block mapping */
> >+#define XFS_SCRUB_TYPE_BMBTA	14	/* attr fork block mapping */
> >+#define XFS_SCRUB_TYPE_BMBTC	15	/* CoW fork block mapping */
> >+#define XFS_SCRUB_TYPE_MAX	15
> >
> > /* i: repair this metadata */
> > #define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
> >diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> >new file mode 100644
> >index 0000000..731f026
> >--- /dev/null
> >+++ b/fs/xfs/scrub/bmap.c
> >@@ -0,0 +1,378 @@
> >+/*
> >+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
> >+ *
> >+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
> >+ *
> >+ * This program is free software; you can redistribute it and/or
> >+ * modify it under the terms of the GNU General Public License
> >+ * as published by the Free Software Foundation; either version 2
> >+ * of the License, or (at your option) any later version.
> >+ *
> >+ * This program is distributed in the hope that it would be useful,
> >+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >+ * GNU General Public License for more details.
> >+ *
> >+ * You should have received a copy of the GNU General Public License
> >+ * along with this program; if not, write the Free Software Foundation,
> >+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> >+ */
> >+#include "xfs.h"
> >+#include "xfs_fs.h"
> >+#include "xfs_shared.h"
> >+#include "xfs_format.h"
> >+#include "xfs_trans_resv.h"
> >+#include "xfs_mount.h"
> >+#include "xfs_defer.h"
> >+#include "xfs_btree.h"
> >+#include "xfs_bit.h"
> >+#include "xfs_log_format.h"
> >+#include "xfs_trans.h"
> >+#include "xfs_trace.h"
> >+#include "xfs_sb.h"
> >+#include "xfs_inode.h"
> >+#include "xfs_inode_fork.h"
> >+#include "xfs_bmap.h"
> >+#include "xfs_bmap_util.h"
> >+#include "xfs_bmap_btree.h"
> >+#include "xfs_rmap.h"
> >+#include "scrub/common.h"
> >+#include "scrub/btree.h"
> >+
> >+/* Set us up with an inode's bmap. */
> >+STATIC int
> >+__xfs_scrub_setup_inode_bmap(
> >+	struct xfs_scrub_context	*sc,
> >+	struct xfs_inode		*ip,
> >+	bool				flush_data)
> >+{
> >+	struct xfs_mount		*mp = sc->mp;
> >+	int				error;
> >+
> >+	error = xfs_scrub_get_inode(sc, ip);
> >+	if (error)
> >+		return error;
> >+
> >+	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
> >+	xfs_ilock(sc->ip, sc->ilock_flags);
> >+
> >+	/*
> >+	 * We don't want any ephemeral data fork updates sitting around
> >+	 * while we inspect block mappings, so wait for directio to finish
> >+	 * and flush dirty data if we have delalloc reservations.
> >+	 */
> >+	if (S_ISREG(VFS_I(sc->ip)->i_mode) && flush_data) {
> >+		inode_dio_wait(VFS_I(sc->ip));
> >+		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
> >+		if (error)
> >+			goto out_unlock;
> >+		error = invalidate_inode_pages2(VFS_I(sc->ip)->i_mapping);
> >+		if (error)
> >+			goto out_unlock;
> >+	}
> >+
> >+	/* Got the inode, lock it and we're ready to go. */
> >+	error = xfs_scrub_trans_alloc(sc->sm, mp, &M_RES(mp)->tr_itruncate,
> >+			0, 0, 0, &sc->tp);
> >+	if (error)
> >+		goto out_unlock;
> >+	sc->ilock_flags |= XFS_ILOCK_EXCL;
> >+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
> >+
> >+	return 0;
> >+out_unlock:
> >+	xfs_iunlock(sc->ip, sc->ilock_flags);
> >+	if (sc->ip != ip)
> >+		IRELE(sc->ip);
> >+	sc->ip = NULL;
> >+	return error;
> >+}
> >+
> >+/* Set us up to scrub the data fork. */
> >+int
> >+xfs_scrub_setup_inode_bmap_data(
> >+	struct xfs_scrub_context	*sc,
> >+	struct xfs_inode		*ip)
> >+{
> >+	return __xfs_scrub_setup_inode_bmap(sc, ip, true);
> >+}
> >+
> >+/* Set us up to scrub the attr or CoW fork. */
> >+int
> >+xfs_scrub_setup_inode_bmap(
> >+	struct xfs_scrub_context	*sc,
> >+	struct xfs_inode		*ip)
> >+{
> >+	return __xfs_scrub_setup_inode_bmap(sc, ip, false);
> >+}
> >+
> >+/*
> >+ * Inode fork block mapping (BMBT) scrubber.
> >+ * More complex than the others because we have to scrub
> >+ * all the extents regardless of whether or not the fork
> >+ * is in btree format.
> >+ */
> >+
> >+struct xfs_scrub_bmap_info {
> >+	struct xfs_scrub_context	*sc;
> >+	const char			*type;
> >+	xfs_daddr_t			eofs;
> >+	xfs_fileoff_t			lastoff;
> >+	bool				is_rt;
> >+	bool				is_shared;
> >+	int				whichfork;
> >+};
> >+
> >+#define XFS_SCRUB_BMAP_CHECK(fs_ok) \
> >+	XFS_SCRUB_INO_CHECK(info->sc, info->sc->ip->i_ino, bp, info->type, fs_ok)
> >+#define XFS_SCRUB_BMAP_GOTO(fs_ok, label) \
> >+	XFS_SCRUB_INO_GOTO(info->sc, info->sc->ip->i_ino, bp, info->type, fs_ok, label)
> >+#define XFS_SCRUB_BMAP_OP_ERROR_GOTO(label) \
> >+	XFS_SCRUB_OP_ERROR_GOTO(info->sc, agno, 0, "bmap", &error, label)
> >+/* Scrub a single extent record. */
> >+STATIC int
> >+xfs_scrub_bmap_extent(
> >+	struct xfs_inode		*ip,
> >+	struct xfs_btree_cur		*cur,
> >+	struct xfs_scrub_bmap_info	*info,
> >+	struct xfs_bmbt_irec		*irec)
> >+{
> >+	struct xfs_scrub_ag		sa = { 0 };
> >+	struct xfs_mount		*mp = info->sc->mp;
> >+	struct xfs_buf			*bp = NULL;
> >+	xfs_daddr_t			daddr;
> >+	xfs_daddr_t			dlen;
> >+	xfs_fsblock_t			bno;
> >+	xfs_agnumber_t			agno;
> >+	int				error = 0;
> >+
> >+	if (cur)
> >+		xfs_btree_get_block(cur, 0, &bp);
> >+
> >+	XFS_SCRUB_BMAP_CHECK(irec->br_startoff >= info->lastoff);
> >+	XFS_SCRUB_BMAP_CHECK(irec->br_startblock != HOLESTARTBLOCK);
> >+	XFS_SCRUB_BMAP_CHECK(!isnullstartblock(irec->br_startblock));
> >+
> >+	/* Actual mapping, so check the block ranges. */
> >+	if (info->is_rt) {
> >+		daddr = XFS_FSB_TO_BB(mp, irec->br_startblock);
> >+		agno = NULLAGNUMBER;
> >+		bno = irec->br_startblock;
> >+	} else {
> >+		daddr = XFS_FSB_TO_DADDR(mp, irec->br_startblock);
> >+		agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
> >+		XFS_SCRUB_BMAP_GOTO(agno < mp->m_sb.sb_agcount, out);
> >+		bno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
> >+		XFS_SCRUB_BMAP_CHECK(bno < mp->m_sb.sb_agblocks);
> >+	}
> >+	dlen = XFS_FSB_TO_BB(mp, irec->br_blockcount);
> >+	XFS_SCRUB_BMAP_CHECK(irec->br_blockcount > 0);
> >+	XFS_SCRUB_BMAP_CHECK(irec->br_blockcount <= MAXEXTLEN);
> >+	XFS_SCRUB_BMAP_CHECK(daddr < info->eofs);
> >+	XFS_SCRUB_BMAP_CHECK(daddr + dlen <= info->eofs);
> >+	XFS_SCRUB_BMAP_CHECK(irec->br_state != XFS_EXT_UNWRITTEN ||
> >+			xfs_sb_version_hasextflgbit(&mp->m_sb));
> >+	if (error)
> >+		goto out;
> >+
> >+	/* Set ourselves up for cross-referencing later. */
> >+	if (!info->is_rt) {
> >+		error = xfs_scrub_ag_init(info->sc, agno, &sa);
> >+		XFS_SCRUB_BMAP_OP_ERROR_GOTO(out);
> >+	}
> >+
> >+	xfs_scrub_ag_free(info->sc, &sa);
> >+out:
> >+	info->lastoff = irec->br_startoff + irec->br_blockcount;
> >+	return error;
> >+}
> >+#undef XFS_SCRUB_BMAP_OP_ERROR_GOTO
> >+#undef XFS_SCRUB_BMAP_GOTO
> >+
> >+/* Scrub a bmbt record. */
> >+STATIC int
> >+xfs_scrub_bmapbt_helper(
> >+	struct xfs_scrub_btree		*bs,
> >+	union xfs_btree_rec		*rec)
> >+{
> >+	struct xfs_bmbt_rec_host	ihost;
> >+	struct xfs_bmbt_irec		irec;
> >+	struct xfs_scrub_bmap_info	*info = bs->private;
> >+	struct xfs_inode		*ip = bs->cur->bc_private.b.ip;
> >+	struct xfs_buf			*bp = NULL;
> >+	struct xfs_btree_block		*block;
> >+	uint64_t			owner;
> >+	int				i;
> >+
> >+	/*
> >+	 * Check the owners of the btree blocks up to the level below
> >+	 * the root since the verifiers don't do that.
> >+	 */
> >+	if (xfs_sb_version_hascrc(&bs->cur->bc_mp->m_sb) &&
> >+	    bs->cur->bc_ptrs[0] == 1) {
> >+		for (i = 0; i < bs->cur->bc_nlevels - 1; i++) {
> >+			block = xfs_btree_get_block(bs->cur, i, &bp);
> >+			owner = be64_to_cpu(block->bb_u.l.bb_owner);
> >+			XFS_SCRUB_BMAP_CHECK(owner == ip->i_ino);
> >+		}
> >+	}
> >+
> >+	/* Set up the in-core record and scrub it. */
> >+	ihost.l0 = be64_to_cpu(rec->bmbt.l0);
> >+	ihost.l1 = be64_to_cpu(rec->bmbt.l1);
> >+	xfs_bmbt_get_all(&ihost, &irec);
> >+	return xfs_scrub_bmap_extent(ip, bs->cur, info, &irec);
> >+}
> >+#undef XFS_SCRUB_BMAP_CHECK
> >+
> >+#define XFS_SCRUB_FORK_CHECK(fs_ok) \
> >+	XFS_SCRUB_INO_CHECK(sc, ip->i_ino, NULL, info.type, fs_ok)
> >+#define XFS_SCRUB_FORK_GOTO(fs_ok, label) \
> >+	XFS_SCRUB_INO_GOTO(sc, ip->i_ino, NULL, info.type, fs_ok, label)
> >+#define XFS_SCRUB_FORK_OP_ERROR_GOTO(label) \
> >+	XFS_SCRUB_OP_ERROR_GOTO(sc, \
> >+			XFS_INO_TO_AGNO(mp, ip->i_ino), \
> >+			XFS_INO_TO_AGBNO(mp, ip->i_ino), \
> >+			info.type, &error, label)
> >+/* Scrub an inode fork's block mappings. */
> >+STATIC int
> >+xfs_scrub_bmap(
> >+	struct xfs_scrub_context	*sc,
> >+	int				whichfork)
> >+{
> >+	struct xfs_bmbt_irec		irec;
> >+	struct xfs_scrub_bmap_info	info = {0};
> >+	struct xfs_owner_info		oinfo;
> >+	struct xfs_mount		*mp = sc->mp;
> >+	struct xfs_inode		*ip = sc->ip;
> >+	struct xfs_ifork		*ifp;
> >+	struct xfs_btree_cur		*cur;
> >+	xfs_fileoff_t			endoff;
> >+	xfs_extnum_t			idx;
> >+	bool				found;
> >+	int				error = 0;
> >+	int				err2 = 0;
> >+
> >+	switch (whichfork) {
> >+	case XFS_DATA_FORK:
> >+		info.type = "data fork";
> >+		break;
> >+	case XFS_ATTR_FORK:
> >+		info.type = "attr fork";
> >+		break;
> >+	case XFS_COW_FORK:
> >+		info.type = "CoW fork";
> >+		break;
> >+	}
> >+	ifp = XFS_IFORK_PTR(ip, whichfork);
> >+
> >+	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
> >+	info.eofs = XFS_FSB_TO_BB(mp, info.is_rt ? mp->m_sb.sb_rblocks :
> >+					      mp->m_sb.sb_dblocks);
> >+	info.whichfork = whichfork;
> >+	info.is_shared = whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(ip);
> >+	info.sc = sc;
> >+
> >+	switch (whichfork) {
> >+	case XFS_COW_FORK:
> >+		/* Non-existent CoW forks are ignorable. */
> >+		if (!ifp)
> >+			goto out_unlock;
> >+		/* No CoW forks on non-reflink inodes/filesystems. */
> >+		XFS_SCRUB_FORK_GOTO(xfs_is_reflink_inode(ip), out_unlock);
> >+		break;
> >+	case XFS_ATTR_FORK:
> >+		if (!ifp)
> >+			goto out_unlock;
> >+		XFS_SCRUB_FORK_CHECK(xfs_sb_version_hasattr(&mp->m_sb) ||
> >+				     xfs_sb_version_hasattr2(&mp->m_sb));
> >+		break;
> >+	}
> >+
> >+	/* Check the fork values */
> >+	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
> >+	case XFS_DINODE_FMT_UUID:
> >+	case XFS_DINODE_FMT_DEV:
> >+	case XFS_DINODE_FMT_LOCAL:
> >+		/* No mappings to check. */
> >+		goto out_unlock;
> >+	case XFS_DINODE_FMT_EXTENTS:
> >+		XFS_SCRUB_FORK_GOTO(ifp->if_flags & XFS_IFEXTENTS, out_unlock);
> >+		break;
> >+	case XFS_DINODE_FMT_BTREE:
> >+		XFS_SCRUB_FORK_CHECK(whichfork != XFS_COW_FORK);
> >+		/* Scan the btree records. */
> >+		cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
> >+		xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
> >+		err2 = xfs_scrub_btree(sc, cur, xfs_scrub_bmapbt_helper,
> >+				&oinfo, &info);
> >+		xfs_btree_del_cursor(cur, err2 ? XFS_BTREE_ERROR :
> >+						 XFS_BTREE_NOERROR);
> >+		if (err2 == -EDEADLOCK)
> >+			return err2;
> >+		else if (err2)
> >+			goto out_unlock;
> >+		break;
> >+	default:
> >+		XFS_SCRUB_FORK_GOTO(false, out_unlock);
> >+		break;
> >+	}
> >+
> >+	/* Extent data is in memory, so scrub that. */
> >+
> >+	/* Find the offset of the last extent in the mapping. */
> >+	error = xfs_bmap_last_offset(ip, &endoff, whichfork);
> >+	XFS_SCRUB_FORK_OP_ERROR_GOTO(out_unlock);
> >+
> >+	/* Scrub extent records. */
> >+	info.lastoff = 0;
> >+	ifp = XFS_IFORK_PTR(ip, whichfork);
> >+	for (found = xfs_iext_lookup_extent(ip, ifp, 0, &idx, &irec);
> >+	     found;
> Did you mean to have the found; without an assignment here?  Not sure if
> that was intentional or a typo.

It's a second-clause-of-a-for-loop null test; I can change it to "found
!= NULL" to be more obvious.

--D

> Otherwise looks good.
> Reviewed by: Allison Henderson <allison.henderson@oracle.com>
> >+	     found = xfs_iext_get_extent(ifp, ++idx, &irec)) {
> >+		if (xfs_scrub_should_terminate(&error))
> >+			break;
> >+		if (isnullstartblock(irec.br_startblock))
> >+			continue;
> >+		XFS_SCRUB_FORK_CHECK(irec.br_startoff < endoff);
> >+		err2 = xfs_scrub_bmap_extent(ip, NULL, &info, &irec);
> >+		if (err2 == -EDEADLOCK)
> >+			return err2;
> >+		else if (!error && err2)
> >+			error = err2;
> >+	}
> >+
> >+out_unlock:
> >+	if (error == 0 && err2 != 0)
> >+		error = err2;
> >+	return error;
> >+}
> >+#undef XFS_SCRUB_FORK_CHECK
> >+#undef XFS_SCRUB_FORK_GOTO
> >+
> >+/* Scrub an inode's data fork. */
> >+int
> >+xfs_scrub_bmap_data(
> >+	struct xfs_scrub_context	*sc)
> >+{
> >+	return xfs_scrub_bmap(sc, XFS_DATA_FORK);
> >+}
> >+
> >+/* Scrub an inode's attr fork. */
> >+int
> >+xfs_scrub_bmap_attr(
> >+	struct xfs_scrub_context	*sc)
> >+{
> >+	return xfs_scrub_bmap(sc, XFS_ATTR_FORK);
> >+}
> >+
> >+/* Scrub an inode's CoW fork. */
> >+int
> >+xfs_scrub_bmap_cow(
> >+	struct xfs_scrub_context	*sc)
> >+{
> >+	if (!xfs_is_reflink_inode(sc->ip))
> >+		return -ENOENT;
> >+
> >+	return xfs_scrub_bmap(sc, XFS_COW_FORK);
> >+}
> >diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> >index 066fd3e..da3c006 100644
> >--- a/fs/xfs/scrub/common.c
> >+++ b/fs/xfs/scrub/common.c
> >@@ -795,6 +795,18 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
> > 		.setup	= xfs_scrub_setup_inode,
> > 		.scrub	= xfs_scrub_inode,
> > 	},
> >+	{ /* inode data fork */
> >+		.setup	= xfs_scrub_setup_inode_bmap_data,
> >+		.scrub	= xfs_scrub_bmap_data,
> >+	},
> >+	{ /* inode attr fork */
> >+		.setup	= xfs_scrub_setup_inode_bmap,
> >+		.scrub	= xfs_scrub_bmap_attr,
> >+	},
> >+	{ /* inode CoW fork */
> >+		.setup	= xfs_scrub_setup_inode_bmap,
> >+		.scrub	= xfs_scrub_bmap_cow,
> >+	},
> > };
> >
> > /* Dispatch metadata scrubbing. */
> >diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> >index 5caa6c9..1025466 100644
> >--- a/fs/xfs/scrub/common.h
> >+++ b/fs/xfs/scrub/common.h
> >@@ -216,6 +216,8 @@ SETUP_FN(xfs_scrub_setup_ag_iallocbt);
> > SETUP_FN(xfs_scrub_setup_ag_rmapbt);
> > SETUP_FN(xfs_scrub_setup_ag_refcountbt);
> > SETUP_FN(xfs_scrub_setup_inode);
> >+SETUP_FN(xfs_scrub_setup_inode_bmap_data);
> >+SETUP_FN(xfs_scrub_setup_inode_bmap);
> > #undef SETUP_FN
> >
> > /* Metadata scrubbers */
> >@@ -234,6 +236,9 @@ SCRUB_FN(xfs_scrub_finobt);
> > SCRUB_FN(xfs_scrub_rmapbt);
> > SCRUB_FN(xfs_scrub_refcountbt);
> > SCRUB_FN(xfs_scrub_inode);
> >+SCRUB_FN(xfs_scrub_bmap_data);
> >+SCRUB_FN(xfs_scrub_bmap_attr);
> >+SCRUB_FN(xfs_scrub_bmap_cow);
> > #undef SCRUB_FN
> >
> > #endif	/* __XFS_REPAIR_COMMON_H__ */
> >diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> >index 950e2c8..edfa4c7 100644
> >--- a/fs/xfs/xfs_trace.h
> >+++ b/fs/xfs/xfs_trace.h
> >@@ -3324,7 +3324,10 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
> > 	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }, \
> > 	{ XFS_SCRUB_TYPE_RMAPBT,	"rmapbt" }, \
> > 	{ XFS_SCRUB_TYPE_REFCNTBT,	"refcountbt" }, \
> >-	{ XFS_SCRUB_TYPE_INODE,		"inode" }
> >+	{ XFS_SCRUB_TYPE_INODE,		"inode" }, \
> >+	{ XFS_SCRUB_TYPE_BMBTD,		"bmapbtd" }, \
> >+	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
> >+	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }
> > DECLARE_EVENT_CLASS(xfs_scrub_class,
> > 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
> > 		 int error),
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
