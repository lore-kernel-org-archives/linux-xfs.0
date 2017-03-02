Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:20820 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753632AbdCBCc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2017 21:32:29 -0500
Date: Wed, 1 Mar 2017 18:29:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 6/9] xfs: implement the GETFSMAP ioctl
Message-ID: <20170302022915.GL5297@birch.djwong.org>
References: <148830755018.22089.4423076490708341523.stgit@birch.djwong.org>
 <148830758872.22089.7483116162562984902.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148830758872.22089.7483116162562984902.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

Introduce a new ioctl that uses the reverse mapping btree to return
information about the physical layout of the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: improve comments and refactor common code
v3: move the rmap comparator to libxfs and more refactoring
---
 fs/xfs/Makefile          |    1 
 fs/xfs/libxfs/xfs_fs.h   |   13 +
 fs/xfs/libxfs/xfs_rmap.c |   28 ++
 fs/xfs/libxfs/xfs_rmap.h |    2 
 fs/xfs/xfs_fsmap.c       |  772 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsmap.h       |   53 +++
 fs/xfs/xfs_ioctl.c       |   84 +++++
 fs/xfs/xfs_ioctl32.c     |    2 
 fs/xfs/xfs_trace.c       |    1 
 fs/xfs/xfs_trace.h       |   84 +++++
 fs/xfs/xfs_trans.c       |   22 +
 fs/xfs/xfs_trans.h       |    2 
 12 files changed, 1064 insertions(+)
 create mode 100644 fs/xfs/xfs_fsmap.c
 create mode 100644 fs/xfs/xfs_fsmap.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c7515d4..0e7ee30 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -80,6 +80,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_extent_busy.o \
 				   xfs_file.o \
 				   xfs_filestream.o \
+				   xfs_fsmap.o \
 				   xfs_fsops.o \
 				   xfs_globals.o \
 				   xfs_icache.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b72dc82..095bdf0 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -92,6 +92,18 @@ struct getbmapx {
 #define BMV_OF_LAST		0x4	/* segment is the last in the file */
 #define BMV_OF_SHARED		0x8	/* segment shared with another file */
 
+/*	fmr_owner special values for FS_IOC_GETFSMAP */
+#define XFS_FMR_OWN_FREE	FMR_OWN_FREE      /* free space */
+#define XFS_FMR_OWN_UNKNOWN	FMR_OWN_UNKNOWN   /* unknown owner */
+#define XFS_FMR_OWN_FS		FMR_OWNER('X', 1) /* static fs metadata */
+#define XFS_FMR_OWN_LOG		FMR_OWNER('X', 2) /* journalling log */
+#define XFS_FMR_OWN_AG		FMR_OWNER('X', 3) /* per-AG metadata */
+#define XFS_FMR_OWN_INOBT	FMR_OWNER('X', 4) /* inode btree blocks */
+#define XFS_FMR_OWN_INODES	FMR_OWNER('X', 5) /* inodes */
+#define XFS_FMR_OWN_REFC	FMR_OWNER('X', 6) /* refcount tree */
+#define XFS_FMR_OWN_COW		FMR_OWNER('X', 7) /* cow staging */
+#define XFS_FMR_OWN_DEFECTIVE	FMR_OWNER('X', 8) /* bad blocks */
+
 /*
  * Structure for XFS_IOC_FSSETDM.
  * For use by backup and restore programs to set the XFS on-disk inode
@@ -502,6 +514,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
+/*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 3840556..06cfb93 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2305,3 +2305,31 @@ xfs_rmap_free_extent(
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_FREE, owner,
 			XFS_DATA_FORK, &bmap);
 }
+
+/* Compare rmap records.  Returns -1 if a < b, 1 if a > b, and 0 if equal. */
+int
+xfs_rmap_compare(
+	const struct xfs_rmap_irec	*a,
+	const struct xfs_rmap_irec	*b)
+{
+	__u64				oa;
+	__u64				ob;
+
+	oa = xfs_rmap_irec_offset_pack(a);
+	ob = xfs_rmap_irec_offset_pack(b);
+
+	if (a->rm_startblock < b->rm_startblock)
+		return -1;
+	else if (a->rm_startblock > b->rm_startblock)
+		return 1;
+	else if (a->rm_owner < b->rm_owner)
+		return -1;
+	else if (a->rm_owner > b->rm_owner)
+		return 1;
+	else if (oa < ob)
+		return -1;
+	else if (oa > ob)
+		return 1;
+	else
+		return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index faf2c1a..98f908f 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -214,5 +214,7 @@ int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
 		struct xfs_rmap_irec *irec, int	*stat);
+int xfs_rmap_compare(const struct xfs_rmap_irec *a,
+		const struct xfs_rmap_irec *b);
 
 #endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
new file mode 100644
index 0000000..2fd05a0
--- /dev/null
+++ b/fs/xfs/xfs_fsmap.c
@@ -0,0 +1,772 @@
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
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_error.h"
+#include "xfs_btree.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_trace.h"
+#include "xfs_log.h"
+#include "xfs_rmap.h"
+#include "xfs_alloc.h"
+#include "xfs_bit.h"
+#include <linux/fsmap.h>
+#include "xfs_fsmap.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
+
+/* Convert an xfs_fsmap to an fsmap. */
+void
+xfs_fsmap_from_internal(
+	struct fsmap		*dest,
+	struct xfs_fsmap	*src)
+{
+	dest->fmr_device = src->fmr_device;
+	dest->fmr_flags = src->fmr_flags;
+	dest->fmr_physical = BBTOB(src->fmr_physical);
+	dest->fmr_owner = src->fmr_owner;
+	dest->fmr_offset = BBTOB(src->fmr_offset);
+	dest->fmr_length = BBTOB(src->fmr_length);
+	dest->fmr_reserved[0] = 0;
+	dest->fmr_reserved[1] = 0;
+	dest->fmr_reserved[2] = 0;
+}
+
+/* Convert an fsmap to an xfs_fsmap. */
+void
+xfs_fsmap_to_internal(
+	struct xfs_fsmap	*dest,
+	struct fsmap		*src)
+{
+	dest->fmr_device = src->fmr_device;
+	dest->fmr_flags = src->fmr_flags;
+	dest->fmr_physical = BTOBBT(src->fmr_physical);
+	dest->fmr_owner = src->fmr_owner;
+	dest->fmr_offset = BTOBBT(src->fmr_offset);
+	dest->fmr_length = BTOBBT(src->fmr_length);
+}
+
+/* Convert an fsmap owner into an rmapbt owner. */
+static int
+xfs_fsmap_owner_to_rmap(
+	struct xfs_rmap_irec	*dest,
+	struct xfs_fsmap	*src)
+{
+	if (!(src->fmr_flags & FMR_OF_SPECIAL_OWNER)) {
+		dest->rm_owner = src->fmr_owner;
+		return 0;
+	}
+
+	switch (src->fmr_owner) {
+	case 0:			/* "lowest owner id possible" */
+	case -1ULL:		/* "highest owner id possible" */
+		dest->rm_owner = 0;
+		break;
+	case XFS_FMR_OWN_FREE:
+		dest->rm_owner = XFS_RMAP_OWN_NULL;
+		break;
+	case XFS_FMR_OWN_UNKNOWN:
+		dest->rm_owner = XFS_RMAP_OWN_UNKNOWN;
+		break;
+	case XFS_FMR_OWN_FS:
+		dest->rm_owner = XFS_RMAP_OWN_FS;
+		break;
+	case XFS_FMR_OWN_LOG:
+		dest->rm_owner = XFS_RMAP_OWN_LOG;
+		break;
+	case XFS_FMR_OWN_AG:
+		dest->rm_owner = XFS_RMAP_OWN_AG;
+		break;
+	case XFS_FMR_OWN_INOBT:
+		dest->rm_owner = XFS_RMAP_OWN_INOBT;
+		break;
+	case XFS_FMR_OWN_INODES:
+		dest->rm_owner = XFS_RMAP_OWN_INODES;
+		break;
+	case XFS_FMR_OWN_REFC:
+		dest->rm_owner = XFS_RMAP_OWN_REFC;
+		break;
+	case XFS_FMR_OWN_COW:
+		dest->rm_owner = XFS_RMAP_OWN_COW;
+		break;
+	case XFS_FMR_OWN_DEFECTIVE:	/* not implemented */
+		/* fall through */
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* Convert an rmapbt owner into an fsmap owner. */
+static int
+xfs_fsmap_owner_from_rmap(
+	struct xfs_fsmap	*dest,
+	struct xfs_rmap_irec	*src)
+{
+	dest->fmr_flags = 0;
+	if (!XFS_RMAP_NON_INODE_OWNER(src->rm_owner)) {
+		dest->fmr_owner = src->rm_owner;
+		return 0;
+	}
+	dest->fmr_flags |= FMR_OF_SPECIAL_OWNER;
+
+	switch (src->rm_owner) {
+	case XFS_RMAP_OWN_FS:
+		dest->fmr_owner = XFS_FMR_OWN_FS;
+		break;
+	case XFS_RMAP_OWN_LOG:
+		dest->fmr_owner = XFS_FMR_OWN_LOG;
+		break;
+	case XFS_RMAP_OWN_AG:
+		dest->fmr_owner = XFS_FMR_OWN_AG;
+		break;
+	case XFS_RMAP_OWN_INOBT:
+		dest->fmr_owner = XFS_FMR_OWN_INOBT;
+		break;
+	case XFS_RMAP_OWN_INODES:
+		dest->fmr_owner = XFS_FMR_OWN_INODES;
+		break;
+	case XFS_RMAP_OWN_REFC:
+		dest->fmr_owner = XFS_FMR_OWN_REFC;
+		break;
+	case XFS_RMAP_OWN_COW:
+		dest->fmr_owner = XFS_FMR_OWN_COW;
+		break;
+	default:
+		return -EFSCORRUPTED;
+	}
+	return 0;
+}
+
+/* getfsmap query state */
+struct xfs_getfsmap_info {
+	struct xfs_fsmap_head	*head;
+	xfs_fsmap_format_t	formatter;	/* formatting fn */
+	void			*format_arg;	/* format buffer */
+	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
+	xfs_daddr_t		next_daddr;	/* next daddr we expect */
+	u64			missing_owner;	/* owner of holes */
+	u32			dev;		/* device id */
+	xfs_agnumber_t		agno;		/* AG number, if applicable */
+	struct xfs_rmap_irec	low;		/* low rmap key */
+	struct xfs_rmap_irec	high;		/* high rmap key */
+	bool			last;		/* last extent? */
+};
+
+/* Associate a device with a getfsmap handler. */
+struct xfs_getfsmap_dev {
+	u32			dev;
+	int			(*fn)(struct xfs_trans *tp,
+				      struct xfs_fsmap *keys,
+				      struct xfs_getfsmap_info *info);
+};
+
+/* Compare two getfsmap device handlers. */
+static int
+xfs_getfsmap_dev_compare(
+	const void			*p1,
+	const void			*p2)
+{
+	const struct xfs_getfsmap_dev	*d1 = p1;
+	const struct xfs_getfsmap_dev	*d2 = p2;
+
+	return d1->dev - d2->dev;
+}
+
+/* Decide if this mapping is shared. */
+STATIC int
+xfs_getfsmap_is_shared(
+	struct xfs_trans		*tp,
+	struct xfs_getfsmap_info	*info,
+	struct xfs_rmap_irec		*rec,
+	bool				*stat)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*cur;
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
+	int				error;
+
+	*stat = false;
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+	/* rt files will have agno set to NULLAGNUMBER */
+	if (info->agno == NULLAGNUMBER)
+		return 0;
+
+	/* Are there any shared blocks here? */
+	flen = 0;
+	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
+			info->agno, NULL);
+
+	error = xfs_refcount_find_shared(cur, rec->rm_startblock,
+			rec->rm_blockcount, &fbno, &flen, false);
+
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	if (error)
+		return error;
+
+	*stat = flen > 0;
+	return 0;
+}
+
+/*
+ * Format a reverse mapping for getfsmap, having translated rm_startblock
+ * into the appropriate daddr units.
+ */
+STATIC int
+xfs_getfsmap_helper(
+	struct xfs_trans		*tp,
+	struct xfs_getfsmap_info	*info,
+	struct xfs_rmap_irec		*rec,
+	xfs_daddr_t			rec_daddr)
+{
+	struct xfs_fsmap		fmr;
+	struct xfs_mount		*mp = tp->t_mountp;
+	bool				shared;
+	int				error;
+
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
+	/*
+	 * Filter out records that start before our startpoint, if the
+	 * caller requested that.
+	 */
+	if (xfs_rmap_compare(rec, &info->low) < 0) {
+		rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+		if (info->next_daddr < rec_daddr)
+			info->next_daddr = rec_daddr;
+		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+	}
+
+	/* Are we just counting mappings? */
+	if (info->head->fmh_count == 0) {
+		if (rec_daddr > info->next_daddr)
+			info->head->fmh_entries++;
+
+		if (info->last)
+			return XFS_BTREE_QUERY_RANGE_CONTINUE;
+
+		info->head->fmh_entries++;
+
+		rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+		if (info->next_daddr < rec_daddr)
+			info->next_daddr = rec_daddr;
+		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+	}
+
+	/*
+	 * If the record starts past the last physical block we saw,
+	 * then we've found a gap.  Report the gap as being owned by
+	 * whatever the caller specified is the missing owner.
+	 */
+	if (rec_daddr > info->next_daddr) {
+		if (info->head->fmh_entries >= info->head->fmh_count)
+			return XFS_BTREE_QUERY_RANGE_ABORT;
+
+		fmr.fmr_device = info->dev;
+		fmr.fmr_physical = info->next_daddr;
+		fmr.fmr_owner = info->missing_owner;
+		fmr.fmr_offset = 0;
+		fmr.fmr_length = rec_daddr - info->next_daddr;
+		fmr.fmr_flags = FMR_OF_SPECIAL_OWNER;
+		error = info->formatter(&fmr, info->format_arg);
+		if (error)
+			return error;
+		info->head->fmh_entries++;
+	}
+
+	if (info->last)
+		goto out;
+
+	/* Fill out the extent we found */
+	if (info->head->fmh_entries >= info->head->fmh_count)
+		return XFS_BTREE_QUERY_RANGE_ABORT;
+
+	trace_xfs_fsmap_mapping(mp, info->dev, info->agno, rec);
+
+	fmr.fmr_device = info->dev;
+	fmr.fmr_physical = rec_daddr;
+	error = xfs_fsmap_owner_from_rmap(&fmr, rec);
+	if (error)
+		return error;
+	fmr.fmr_offset = XFS_FSB_TO_BB(mp, rec->rm_offset);
+	fmr.fmr_length = XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+	if (rec->rm_flags & XFS_RMAP_UNWRITTEN)
+		fmr.fmr_flags |= FMR_OF_PREALLOC;
+	if (rec->rm_flags & XFS_RMAP_ATTR_FORK)
+		fmr.fmr_flags |= FMR_OF_ATTR_FORK;
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK)
+		fmr.fmr_flags |= FMR_OF_EXTENT_MAP;
+	if (fmr.fmr_flags == 0) {
+		error = xfs_getfsmap_is_shared(tp, info, rec, &shared);
+		if (error)
+			return error;
+		if (shared)
+			fmr.fmr_flags |= FMR_OF_SHARED;
+	}
+	error = info->formatter(&fmr, info->format_arg);
+	if (error)
+		return error;
+	info->head->fmh_entries++;
+
+out:
+	rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+	if (info->next_daddr < rec_daddr)
+		info->next_daddr = rec_daddr;
+	return XFS_BTREE_QUERY_RANGE_CONTINUE;
+}
+
+/* Transform a rmapbt irec into a fsmap */
+STATIC int
+xfs_getfsmap_datadev_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_getfsmap_info	*info = priv;
+	xfs_fsblock_t			fsb;
+	xfs_daddr_t			rec_daddr;
+
+	fsb = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno, rec->rm_startblock);
+	rec_daddr = XFS_FSB_TO_DADDR(mp, fsb);
+
+	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
+}
+
+/* Transform a absolute-startblock rmap (rtdev, logdev) into a fsmap */
+STATIC int
+xfs_getfsmap_rtdev_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_getfsmap_info	*info = priv;
+	xfs_daddr_t			rec_daddr;
+
+	rec_daddr = XFS_FSB_TO_BB(mp, rec->rm_startblock);
+
+	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
+}
+
+/* Set rmap flags based on the getfsmap flags */
+static void
+xfs_getfsmap_set_irec_flags(
+	struct xfs_rmap_irec	*irec,
+	struct xfs_fsmap	*fmr)
+{
+	irec->rm_flags = 0;
+	if (fmr->fmr_flags & FMR_OF_ATTR_FORK)
+		irec->rm_flags |= XFS_RMAP_ATTR_FORK;
+	if (fmr->fmr_flags & FMR_OF_EXTENT_MAP)
+		irec->rm_flags |= XFS_RMAP_BMBT_BLOCK;
+	if (fmr->fmr_flags & FMR_OF_PREALLOC)
+		irec->rm_flags |= XFS_RMAP_UNWRITTEN;
+}
+
+/* Execute a getfsmap query against the log device. */
+STATIC int
+xfs_getfsmap_logdev(
+	struct xfs_trans		*tp,
+	struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rmap_irec		rmap;
+	int				error;
+
+	/* Set up search keys */
+	info->low.rm_startblock = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
+	error = xfs_fsmap_owner_to_rmap(&info->low, keys);
+	if (error)
+		return error;
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+
+	error = xfs_fsmap_owner_to_rmap(&info->high, keys + 1);
+	if (error)
+		return error;
+	info->high.rm_startblock = -1U;
+	info->high.rm_owner = ULLONG_MAX;
+	info->high.rm_offset = ULLONG_MAX;
+	info->high.rm_blockcount = 0;
+	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
+	info->missing_owner = XFS_FMR_OWN_FREE;
+
+	trace_xfs_fsmap_low_key(mp, info->dev, info->agno, &info->low);
+	trace_xfs_fsmap_high_key(mp, info->dev, info->agno, &info->high);
+
+	if (keys[0].fmr_physical > 0)
+		return 0;
+
+	/* Fabricate an rmap entry for the external log device. */
+	rmap.rm_startblock = 0;
+	rmap.rm_blockcount = mp->m_sb.sb_logblocks;
+	rmap.rm_owner = XFS_RMAP_OWN_LOG;
+	rmap.rm_offset = 0;
+	rmap.rm_flags = 0;
+
+	return xfs_getfsmap_helper(tp, info, &rmap, 0);
+}
+
+/* Execute a getfsmap query against the regular data device. */
+STATIC int
+__xfs_getfsmap_datadev(
+	struct xfs_trans		*tp,
+	struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info,
+	int				(*query_fn)(struct xfs_trans *,
+						    struct xfs_getfsmap_info *,
+						    struct xfs_btree_cur **,
+						    void *),
+	void				*priv)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*bt_cur = NULL;
+	xfs_fsblock_t			start_fsb;
+	xfs_fsblock_t			end_fsb;
+	xfs_agnumber_t			start_ag;
+	xfs_agnumber_t			end_ag;
+	xfs_daddr_t			eofs;
+	int				error = 0;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (keys[0].fmr_physical >= eofs)
+		return 0;
+	if (keys[1].fmr_physical >= eofs)
+		keys[1].fmr_physical = eofs - 1;
+	start_fsb = XFS_DADDR_TO_FSB(mp, keys[0].fmr_physical);
+	end_fsb = XFS_DADDR_TO_FSB(mp, keys[1].fmr_physical);
+
+	/*
+	 * Convert the fsmap low/high keys to AG based keys.  Initialize
+	 * low to the fsmap low key and max out the high key to the end
+	 * of the AG.
+	 */
+	info->low.rm_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
+	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
+	if (error)
+		return error;
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+
+	info->high.rm_startblock = -1U;
+	info->high.rm_owner = ULLONG_MAX;
+	info->high.rm_offset = ULLONG_MAX;
+	info->high.rm_blockcount = 0;
+	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
+
+	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
+	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
+
+	/* Query each AG */
+	for (info->agno = start_ag; info->agno <= end_ag; info->agno++) {
+		/*
+		 * Set the AG high key from the fsmap high key if this
+		 * is the last AG that we're querying.
+		 */
+		if (info->agno == end_ag) {
+			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
+					end_fsb);
+			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
+					keys[1].fmr_offset);
+			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
+			if (error)
+				goto err;
+			xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
+		}
+
+		if (bt_cur) {
+			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+			bt_cur = NULL;
+			xfs_trans_brelse(tp, info->agf_bp);
+			info->agf_bp = NULL;
+		}
+
+		error = xfs_alloc_read_agf(mp, tp, info->agno, 0,
+				&info->agf_bp);
+		if (error)
+			goto err;
+
+		trace_xfs_fsmap_low_key(mp, info->dev, info->agno, &info->low);
+		trace_xfs_fsmap_high_key(mp, info->dev, info->agno,
+				&info->high);
+
+		error = query_fn(tp, info, &bt_cur, priv);
+		if (error)
+			goto err;
+
+		/*
+		 * Set the AG low key to the start of the AG prior to
+		 * moving on to the next AG.
+		 */
+		if (info->agno == start_ag) {
+			info->low.rm_startblock = 0;
+			info->low.rm_owner = 0;
+			info->low.rm_offset = 0;
+			info->low.rm_flags = 0;
+		}
+	}
+
+	/* Report any gap at the end of the AG */
+	info->last = true;
+	error = query_fn(tp, info, &bt_cur, priv);
+	if (error)
+		goto err;
+
+err:
+	if (bt_cur)
+		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
+							 XFS_BTREE_NOERROR);
+	if (info->agf_bp) {
+		xfs_trans_brelse(tp, info->agf_bp);
+		info->agf_bp = NULL;
+	}
+
+	return error;
+}
+
+/* Actually query the rmap btree. */
+STATIC int
+xfs_getfsmap_datadev_rmapbt_query(
+	struct xfs_trans		*tp,
+	struct xfs_getfsmap_info	*info,
+	struct xfs_btree_cur		**curpp,
+	void				*priv)
+{
+	/* Report any gap at the end of the last AG. */
+	if (info->last)
+		return xfs_getfsmap_datadev_helper(*curpp, &info->high, info);
+
+	/* Allocate cursor for this AG and query_range it. */
+	*curpp = xfs_rmapbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
+			info->agno);
+	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
+			xfs_getfsmap_datadev_helper, info);
+}
+
+/* Execute a getfsmap query against the regular data device rmapbt. */
+STATIC int
+xfs_getfsmap_datadev_rmapbt(
+	struct xfs_trans		*tp,
+	struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	info->missing_owner = XFS_FMR_OWN_FREE;
+	return __xfs_getfsmap_datadev(tp, keys, info,
+			xfs_getfsmap_datadev_rmapbt_query, NULL);
+}
+
+/* Do we recognize the device? */
+STATIC bool
+xfs_getfsmap_is_valid_device(
+	struct xfs_mount	*mp,
+	struct xfs_fsmap	*fm)
+{
+	if (fm->fmr_device == 0 || fm->fmr_device == UINT_MAX ||
+	    fm->fmr_device == new_encode_dev(mp->m_ddev_targp->bt_dev))
+		return true;
+	if (mp->m_logdev_targp &&
+	    fm->fmr_device == new_encode_dev(mp->m_logdev_targp->bt_dev))
+		return true;
+	return false;
+}
+
+/* Ensure that the low key is less than the high key. */
+STATIC bool
+xfs_getfsmap_check_keys(
+	struct xfs_fsmap		*low_key,
+	struct xfs_fsmap		*high_key)
+{
+	if (low_key->fmr_device > high_key->fmr_device)
+		return false;
+	if (low_key->fmr_device < high_key->fmr_device)
+		return true;
+
+	if (low_key->fmr_physical > high_key->fmr_physical)
+		return false;
+	if (low_key->fmr_physical < high_key->fmr_physical)
+		return true;
+
+	if (low_key->fmr_owner > high_key->fmr_owner)
+		return false;
+	if (low_key->fmr_owner < high_key->fmr_owner)
+		return true;
+
+	if (low_key->fmr_offset > high_key->fmr_offset)
+		return false;
+	if (low_key->fmr_offset < high_key->fmr_offset)
+		return true;
+
+	return false;
+}
+
+#define XFS_GETFSMAP_DEVS	2
+/*
+ * Get filesystem's extents as described in head, and format for
+ * output.  Calls formatter to fill the user's buffer until all
+ * extents are mapped, until the passed-in head->fmh_count slots have
+ * been filled, or until the formatter short-circuits the loop, if it
+ * is tracking filled-in extents on its own.
+ *
+ * Key to Confusion
+ * ----------------
+ * There are multiple levels of keys and counters at work here:
+ * xfs_fsmap_head.fmh_keys	-- low and high fsmap keys passed in;
+ * 				   these reflect fs-wide sector addrs.
+ * dkeys			-- fmh_keys used to query each device;
+ * 				   these are fmh_keys but w/ the low key
+ * 				   bumped up by fmr_length.
+ * xfs_getfsmap_info.next_daddr	-- next disk addr we expect to see; this
+ *				   is how we detect gaps in the fsmap
+				   records and report them.
+ * xfs_getfsmap_info.low/high	-- per-AG low/high keys computed from
+ * 				   dkeys; used to query the metadata.
+ */
+int
+xfs_getfsmap(
+	struct xfs_mount		*mp,
+	struct xfs_fsmap_head		*head,
+	xfs_fsmap_format_t		formatter,
+	void				*arg)
+{
+	struct xfs_trans		*tp = NULL;
+	struct xfs_fsmap		dkeys[2];	/* per-dev keys */
+	struct xfs_getfsmap_dev		handlers[XFS_GETFSMAP_DEVS];
+	struct xfs_getfsmap_info	info = {0};
+	int				i;
+	int				error = 0;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+	if (head->fmh_iflags & ~FMH_IF_VALID)
+		return -EINVAL;
+	if (!xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[0]) ||
+	    !xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[1]))
+		return -EINVAL;
+
+	head->fmh_entries = 0;
+
+	/* Set up our device handlers. */
+	memset(handlers, 0, sizeof(handlers));
+	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
+	handlers[0].fn = xfs_getfsmap_datadev_rmapbt;
+	if (mp->m_logdev_targp != mp->m_ddev_targp) {
+		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
+		handlers[1].fn = xfs_getfsmap_logdev;
+	}
+
+	xfs_sort(handlers, XFS_GETFSMAP_DEVS, sizeof(struct xfs_getfsmap_dev),
+			xfs_getfsmap_dev_compare);
+
+	/*
+	 * To continue where we left off, we allow userspace to use the
+	 * last mapping from a previous call as the low key of the next.
+	 * This is identified by a non-zero length in the low key. We
+	 * have to increment the low key in this scenario to ensure we
+	 * don't return the same mapping again, and instead return the
+	 * very next mapping.
+	 *
+	 * If the low key mapping refers to file data, the same physical
+	 * blocks could be mapped to several other files/offsets.
+	 * According to rmapbt record ordering, the minimal next
+	 * possible record for the block range is the next starting
+	 * offset in the same inode. Therefore, bump the file offset to
+	 * continue the search appropriately.  For all other low key
+	 * mapping types (attr blocks, metadata), bump the physical
+	 * offset as there can be no other mapping for the same physical
+	 * block range.
+	 */
+	dkeys[0] = head->fmh_keys[0];
+	if (dkeys[0].fmr_flags & (FMR_OF_SPECIAL_OWNER | FMR_OF_EXTENT_MAP)) {
+		dkeys[0].fmr_physical += dkeys[0].fmr_length;
+		dkeys[0].fmr_owner = 0;
+		if (dkeys[0].fmr_offset)
+			return -EINVAL;
+	} else
+		dkeys[0].fmr_offset += dkeys[0].fmr_length;
+	dkeys[0].fmr_length = 0;
+	memset(&dkeys[1], 0xFF, sizeof(struct xfs_fsmap));
+
+	if (!xfs_getfsmap_check_keys(dkeys, &head->fmh_keys[1]))
+		return -EINVAL;
+
+	info.next_daddr = head->fmh_keys[0].fmr_physical +
+			  head->fmh_keys[0].fmr_length;
+	info.formatter = formatter;
+	info.format_arg = arg;
+	info.head = head;
+
+	/* For each device we support... */
+	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
+		/* Is this device within the range the user asked for? */
+		if (!handlers[i].fn)
+			continue;
+		if (head->fmh_keys[0].fmr_device > handlers[i].dev)
+			continue;
+		if (head->fmh_keys[1].fmr_device < handlers[i].dev)
+			break;
+
+		/*
+		 * If this device number matches the high key, we have
+		 * to pass the high key to the handler to limit the
+		 * query results.  If the device number exceeds the
+		 * low key, zero out the low key so that we get
+		 * everything from the beginning.
+		 */
+		if (handlers[i].dev == head->fmh_keys[1].fmr_device)
+			dkeys[1] = head->fmh_keys[1];
+		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
+			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
+
+		error = xfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			break;
+
+		info.dev = handlers[i].dev;
+		info.last = false;
+		info.agno = NULLAGNUMBER;
+		error = handlers[i].fn(tp, dkeys, &info);
+		if (error)
+			break;
+		xfs_trans_cancel(tp);
+		tp = NULL;
+		info.next_daddr = 0;
+	}
+
+	if (tp)
+		xfs_trans_cancel(tp);
+	head->fmh_oflags = FMH_OF_DEV_T;
+	return error;
+}
diff --git a/fs/xfs/xfs_fsmap.h b/fs/xfs/xfs_fsmap.h
new file mode 100644
index 0000000..0b9bf82
--- /dev/null
+++ b/fs/xfs/xfs_fsmap.h
@@ -0,0 +1,53 @@
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
+#ifndef __XFS_FSMAP_H__
+#define __XFS_FSMAP_H__
+
+struct fsmap;
+
+/* internal fsmap representation */
+struct xfs_fsmap {
+	dev_t		fmr_device;	/* device id */
+	uint32_t	fmr_flags;	/* mapping flags */
+	uint64_t	fmr_physical;	/* device offset of segment */
+	uint64_t	fmr_owner;	/* owner id */
+	xfs_fileoff_t	fmr_offset;	/* file offset of segment */
+	xfs_filblks_t	fmr_length;	/* length of segment, blocks */
+};
+
+struct xfs_fsmap_head {
+	uint32_t	fmh_iflags;	/* control flags */
+	uint32_t	fmh_oflags;	/* output flags */
+	unsigned int	fmh_count;	/* # of entries in array incl. input */
+	unsigned int	fmh_entries;	/* # of entries filled in (output). */
+
+	struct xfs_fsmap fmh_keys[2];	/* low and high keys */
+};
+
+void xfs_fsmap_from_internal(struct fsmap *dest, struct xfs_fsmap *src);
+void xfs_fsmap_to_internal(struct xfs_fsmap *dest, struct fsmap *src);
+
+/* fsmap to userspace formatter - copy to user & advance pointer */
+typedef int (*xfs_fsmap_format_t)(struct xfs_fsmap *, void *);
+
+int xfs_getfsmap(struct xfs_mount *mp, struct xfs_fsmap_head *head,
+		xfs_fsmap_format_t formatter, void *arg);
+
+#endif /* __XFS_FSMAP_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c67cfb4..52f635a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -41,6 +41,9 @@
 #include "xfs_trans.h"
 #include "xfs_pnfs.h"
 #include "xfs_acl.h"
+#include "xfs_btree.h"
+#include <linux/fsmap.h>
+#include "xfs_fsmap.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -1607,6 +1610,84 @@ xfs_ioc_getbmapx(
 	return 0;
 }
 
+struct getfsmap_info {
+	struct xfs_mount	*mp;
+	struct fsmap __user	*data;
+	__u32			last_flags;
+};
+
+STATIC int
+xfs_getfsmap_format(struct xfs_fsmap *xfm, void *priv)
+{
+	struct getfsmap_info	*info = priv;
+	struct fsmap		fm;
+
+	trace_xfs_getfsmap_mapping(info->mp, xfm);
+
+	info->last_flags = xfm->fmr_flags;
+	xfs_fsmap_from_internal(&fm, xfm);
+	if (copy_to_user(info->data, &fm, sizeof(struct fsmap)))
+		return -EFAULT;
+
+	info->data++;
+	return 0;
+}
+
+STATIC int
+xfs_ioc_getfsmap(
+	struct xfs_inode	*ip,
+	void			__user *arg)
+{
+	struct getfsmap_info	info;
+	struct xfs_fsmap_head	xhead = {0};
+	struct fsmap_head	head;
+	bool			aborted = false;
+	int			error;
+
+	if (copy_from_user(&head, arg, sizeof(struct fsmap_head)))
+		return -EFAULT;
+	if (memchr_inv(head.fmh_reserved, 0, sizeof(head.fmh_reserved)) ||
+	    memchr_inv(head.fmh_keys[0].fmr_reserved, 0,
+		       sizeof(head.fmh_keys[0].fmr_reserved)) ||
+	    memchr_inv(head.fmh_keys[1].fmr_reserved, 0,
+		       sizeof(head.fmh_keys[1].fmr_reserved)))
+		return -EINVAL;
+
+	xhead.fmh_iflags = head.fmh_iflags;
+	xhead.fmh_count = head.fmh_count;
+	xfs_fsmap_to_internal(&xhead.fmh_keys[0], &head.fmh_keys[0]);
+	xfs_fsmap_to_internal(&xhead.fmh_keys[1], &head.fmh_keys[1]);
+
+	trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
+	trace_xfs_getfsmap_high_key(ip->i_mount, &xhead.fmh_keys[1]);
+
+	info.mp = ip->i_mount;
+	info.data = ((__force struct fsmap_head *)arg)->fmh_recs;
+	error = xfs_getfsmap(ip->i_mount, &xhead, xfs_getfsmap_format, &info);
+	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
+		error = 0;
+		aborted = true;
+	} else if (error)
+		return error;
+
+	/* If we didn't abort, set the "last" flag in the last fmx */
+	if (!aborted && xhead.fmh_entries) {
+		info.data--;
+		info.last_flags |= FMR_OF_LAST;
+		if (copy_to_user(&info.data->fmr_flags, &info.last_flags,
+				sizeof(info.last_flags)))
+			return -EFAULT;
+	}
+
+	/* copy back header */
+	head.fmh_entries = xhead.fmh_entries;
+	head.fmh_oflags = xhead.fmh_oflags;
+	if (copy_to_user(arg, &head, sizeof(struct fsmap_head)))
+		return -EFAULT;
+
+	return 0;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1787,6 +1868,9 @@ xfs_file_ioctl(
 	case XFS_IOC_GETBMAPX:
 		return xfs_ioc_getbmapx(ip, arg);
 
+	case FS_IOC_GETFSMAP:
+		return xfs_ioc_getfsmap(ip, arg);
+
 	case XFS_IOC_FD_TO_HANDLE:
 	case XFS_IOC_PATH_TO_HANDLE:
 	case XFS_IOC_PATH_TO_FSHANDLE: {
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 7c49938..fa0bc4d 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -20,6 +20,7 @@
 #include <linux/mount.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/fsmap.h>
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
@@ -554,6 +555,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
+	case FS_IOC_GETFSMAP:
 		return xfs_file_ioctl(filp, cmd, p);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 7f17ae6..5d95fe3 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -47,6 +47,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_filestream.h"
+#include "xfs_fsmap.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d3d11905..ef666e6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -40,6 +40,8 @@ struct xfs_inode_log_format;
 struct xfs_bmbt_irec;
 struct xfs_btree_cur;
 struct xfs_refcount_irec;
+struct xfs_fsmap;
+struct xfs_rmap_irec;
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
@@ -3270,6 +3272,88 @@ DEFINE_INODE_IREC_EVENT(xfs_swap_extent_rmap_remap);
 DEFINE_INODE_IREC_EVENT(xfs_swap_extent_rmap_remap_piece);
 DEFINE_INODE_ERROR_EVENT(xfs_swap_extent_rmap_error);
 
+/* fsmap traces */
+DECLARE_EVENT_CLASS(xfs_fsmap_class,
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno,
+		 struct xfs_rmap_irec *rmap),
+	TP_ARGS(mp, keydev, agno, rmap),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, keydev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_fsblock_t, bno)
+		__field(xfs_filblks_t, len)
+		__field(__uint64_t, owner)
+		__field(__uint64_t, offset)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->keydev = new_decode_dev(keydev);
+		__entry->agno = agno;
+		__entry->bno = rmap->rm_startblock;
+		__entry->len = rmap->rm_blockcount;
+		__entry->owner = rmap->rm_owner;
+		__entry->offset = rmap->rm_offset;
+		__entry->flags = rmap->rm_flags;
+	),
+	TP_printk("dev %d:%d keydev %d:%d agno %u bno %llu len %llu owner %lld offset %llu flags 0x%x\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
+)
+#define DEFINE_FSMAP_EVENT(name) \
+DEFINE_EVENT(xfs_fsmap_class, name, \
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno, \
+		 struct xfs_rmap_irec *rmap), \
+	TP_ARGS(mp, keydev, agno, rmap))
+DEFINE_FSMAP_EVENT(xfs_fsmap_low_key);
+DEFINE_FSMAP_EVENT(xfs_fsmap_high_key);
+DEFINE_FSMAP_EVENT(xfs_fsmap_mapping);
+
+DECLARE_EVENT_CLASS(xfs_getfsmap_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_fsmap *fsmap),
+	TP_ARGS(mp, fsmap),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, keydev)
+		__field(xfs_daddr_t, block)
+		__field(xfs_daddr_t, len)
+		__field(__uint64_t, owner)
+		__field(__uint64_t, offset)
+		__field(__uint64_t, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->keydev = new_decode_dev(fsmap->fmr_device);
+		__entry->block = fsmap->fmr_physical;
+		__entry->len = fsmap->fmr_length;
+		__entry->owner = fsmap->fmr_owner;
+		__entry->offset = fsmap->fmr_offset;
+		__entry->flags = fsmap->fmr_flags;
+	),
+	TP_printk("dev %d:%d keydev %d:%d block %llu len %llu owner %lld offset %llu flags 0x%llx\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
+		  __entry->block,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
+)
+#define DEFINE_GETFSMAP_EVENT(name) \
+DEFINE_EVENT(xfs_getfsmap_class, name, \
+	TP_PROTO(struct xfs_mount *mp, struct xfs_fsmap *fsmap), \
+	TP_ARGS(mp, fsmap))
+DEFINE_GETFSMAP_EVENT(xfs_getfsmap_low_key);
+DEFINE_GETFSMAP_EVENT(xfs_getfsmap_high_key);
+DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 70f42ea..a280e12 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -263,6 +263,28 @@ xfs_trans_alloc(
 }
 
 /*
+ * Create an empty transaction with no reservation.  This is a defensive
+ * mechanism for routines that query metadata without actually modifying
+ * them -- if the metadata being queried is somehow cross-linked (think a
+ * btree block pointer that points higher in the tree), we risk deadlock.
+ * However, blocks grabbed as part of a transaction can be re-grabbed.
+ * The verifiers will notice the corrupt block and the operation will fail
+ * back to userspace without deadlocking.
+ *
+ * Note the zero-length reservation; this transaction MUST be cancelled
+ * without any dirty data.
+ */
+int
+xfs_trans_alloc_empty(
+	struct xfs_mount		*mp,
+	struct xfs_trans		**tpp)
+{
+	struct xfs_trans_res		resv = {0};
+
+	return xfs_trans_alloc(mp, &resv, 0, 0, XFS_TRANS_NO_WRITECOUNT, tpp);
+}
+
+/*
  * Record the indicated change to the given field for application
  * to the file system's superblock when the transaction commits.
  * For now, just store the change in the transaction structure.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 61b7fbd..98024cb 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -159,6 +159,8 @@ typedef struct xfs_trans {
 int		xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
 			uint blocks, uint rtextents, uint flags,
 			struct xfs_trans **tpp);
+int		xfs_trans_alloc_empty(struct xfs_mount *mp,
+			struct xfs_trans **tpp);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
 
 struct xfs_buf	*xfs_trans_get_buf_map(struct xfs_trans *tp,
