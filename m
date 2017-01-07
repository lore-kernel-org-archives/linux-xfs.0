Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40615 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964977AbdAGAgP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 19:36:15 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v070aEk5023034
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:36:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v070aE3h032584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:36:14 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v070aEKC003459
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:36:14 GMT
Subject: [PATCH 04/47] xfs: introduce the XFS_IOC_GETFSMAP ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 06 Jan 2017 16:36:12 -0800
Message-ID: <148374937283.30431.11927442457304013157.stgit@birch.djwong.org>
In-Reply-To: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Introduce a new ioctl that uses the reverse mapping btree to return
information about the physical layout of the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |   95 +++++++
 fs/xfs/xfs_fsmap.c     |  698 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsmap.h     |   51 ++++
 fs/xfs/xfs_ioctl.c     |  104 +++++++
 fs/xfs/xfs_ioctl32.c   |    1 
 fs/xfs/xfs_trace.h     |   85 ++++++
 fs/xfs/xfs_trans.c     |   22 ++
 fs/xfs/xfs_trans.h     |    2 
 9 files changed, 1059 insertions(+)
 create mode 100644 fs/xfs/xfs_fsmap.c
 create mode 100644 fs/xfs/xfs_fsmap.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 26ef195..5c90f82 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -79,6 +79,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_extent_busy.o \
 				   xfs_file.o \
 				   xfs_filestream.o \
+				   xfs_fsmap.o \
 				   xfs_fsops.o \
 				   xfs_globals.o \
 				   xfs_icache.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b72dc82..e62996f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -93,6 +93,100 @@ struct getbmapx {
 #define BMV_OF_SHARED		0x8	/* segment shared with another file */
 
 /*
+ *	Structure for XFS_IOC_GETFSMAP.
+ *
+ *	The memory layout for this call are the scalar values defined in
+ *	struct fsmap_head, followed by two struct fsmap that describe
+ *	the lower and upper bound of mappings to return, followed by an
+ *	array of struct fsmap mappings.
+ *
+ *	fmh_iflags control the output of the call, whereas fmh_oflags report
+ *	on the overall record output.  fmh_count should be set to the
+ *	length of the fmh_recs array, and fmh_entries will be set to the
+ *	number of entries filled out during each call.  If fmh_count is
+ *	zero, the number of reverse mappings will be returned in
+ *	fmh_entries, though no mappings will be returned.  fmh_reserved
+ *	must be set to zero.
+ *
+ *	The two elements in the fmh_keys array are used to constrain the
+ *	output.  The first element in the array should represent the
+ *	lowest disk mapping ("low key") that the user wants to learn
+ *	about.  If this value is all zeroes, the filesystem will return
+ *	the first entry it knows about.  For a subsequent call, the
+ *	contents of fsmap_head.fmh_recs[fsmap_head.fmh_count - 1] should be
+ *	copied into fmh_keys[0] to have the kernel start where it left off.
+ *
+ *	The second element in the fmh_keys array should represent the
+ *	highest disk mapping ("high key") that the user wants to learn
+ *	about.  If this value is all ones, the filesystem will not stop
+ *	until it runs out of mapping to return or runs out of space in
+ *	fmh_recs.
+ *
+ *	fmr_device can be either a 32-bit cookie representing a device, or
+ *	a 32-bit dev_t if the FMH_OF_DEV_T flag is set.  fmr_physical,
+ *	fmr_offset, and fmr_length are expressed in units of bytes.
+ *	fmr_owner is either an inode number, or a special value if
+ *	FMR_OF_SPECIAL_OWNER is set in fmr_flags.
+ */
+#ifndef HAVE_GETFSMAP
+struct fsmap {
+	__u32		fmr_device;	/* device id */
+	__u32		fmr_flags;	/* mapping flags */
+	__u64		fmr_physical;	/* device offset of segment */
+	__u64		fmr_owner;	/* owner id */
+	__u64		fmr_offset;	/* file offset of segment */
+	__u64		fmr_length;	/* length of segment */
+	__u64		fmr_reserved[3];	/* must be zero */
+};
+
+struct fsmap_head {
+	__u32		fmh_iflags;	/* control flags */
+	__u32		fmh_oflags;	/* output flags */
+	__u32		fmh_count;	/* # of entries in array incl. input */
+	__u32		fmh_entries;	/* # of entries filled in (output). */
+	__u64		fmh_reserved[6];	/* must be zero */
+
+	struct fsmap	fmh_keys[2];	/* low and high keys for the mapping search */
+	struct fsmap	fmh_recs[];	/* returned records */
+};
+
+/* Size of an fsmap_head with room for nr records. */
+static inline size_t
+fsmap_sizeof(
+	unsigned int	nr)
+{
+	return sizeof(struct fsmap_head) + nr * sizeof(struct fsmap);
+}
+#endif
+
+/*	fmh_iflags values - set by XFS_IOC_GETFSMAP caller in the header. */
+/* no flags defined yet */
+#define FMH_IF_VALID		0
+
+/*	fmh_oflags values - returned in the header segment only. */
+#define FMH_OF_DEV_T		0x1	/* fmr_device values will be dev_t */
+
+/*	fmr_flags values - returned for each non-header segment */
+#define FMR_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
+#define FMR_OF_ATTR_FORK	0x2	/* segment = attribute fork */
+#define FMR_OF_EXTENT_MAP	0x4	/* segment = extent map */
+#define FMR_OF_SHARED		0x8	/* segment = shared with another file */
+#define FMR_OF_SPECIAL_OWNER	0x10	/* owner is a special value */
+#define FMR_OF_LAST		0x20	/* segment is the last in the FS */
+
+/*	fmr_owner special values */
+#define FMR_OWN_FREE		(-1ULL)	/* free space */
+#define FMR_OWN_UNKNOWN		(-2ULL)	/* unknown owner */
+#define FMR_OWN_FS		(-3ULL)	/* static fs metadata */
+#define FMR_OWN_LOG		(-4ULL)	/* journalling log */
+#define FMR_OWN_AG		(-5ULL)	/* per-AG metadata */
+#define FMR_OWN_INOBT		(-6ULL)	/* inode btree blocks */
+#define FMR_OWN_INODES		(-7ULL)	/* inodes */
+#define FMR_OWN_REFC		(-8ULL) /* refcount tree */
+#define FMR_OWN_COW		(-9ULL) /* cow staging */
+#define FMR_OWN_DEFECTIVE	(-10ULL) /* bad blocks */
+
+/*
  * Structure for XFS_IOC_FSSETDM.
  * For use by backup and restore programs to set the XFS on-disk inode
  * fields di_dmevmask and di_dmstate.  These must be set to exactly and
@@ -502,6 +596,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
+#define XFS_IOC_GETFSMAP	_IOWR('X', 59, struct fsmap_head)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
new file mode 100644
index 0000000..985415b
--- /dev/null
+++ b/fs/xfs/xfs_fsmap.c
@@ -0,0 +1,698 @@
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
+#include "xfs_fsmap.h"
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
+	struct xfs_fsmap	*fmr,
+	struct xfs_rmap_irec	*rm)
+{
+	if (!(fmr->fmr_flags & FMR_OF_SPECIAL_OWNER)) {
+		if (XFS_RMAP_NON_INODE_OWNER(fmr->fmr_owner))
+			return -EINVAL;
+		rm->rm_owner = fmr->fmr_owner;
+		return 0;
+	}
+
+	switch (fmr->fmr_owner) {
+	case 0:			/* "lowest owner id possible" */
+	case FMR_OWN_FREE:
+	case FMR_OWN_UNKNOWN:
+	case FMR_OWN_FS:
+	case FMR_OWN_LOG:
+	case FMR_OWN_AG:
+	case FMR_OWN_INOBT:
+	case FMR_OWN_INODES:
+	case FMR_OWN_REFC:
+	case FMR_OWN_COW:
+		rm->rm_owner = fmr->fmr_owner;
+		return 0;
+	case FMR_OWN_DEFECTIVE:
+		/* fall through */
+	default:
+		return -EINVAL;
+	}
+}
+
+/* Convert an rmapbt owner into an fsmap owner. */
+static int
+xfs_fsmap_owner_from_rmap(
+	struct xfs_rmap_irec	*rm,
+	struct xfs_fsmap	*fmr)
+{
+	fmr->fmr_flags = 0;
+	if (!XFS_RMAP_NON_INODE_OWNER(rm->rm_owner)) {
+		fmr->fmr_owner = rm->rm_owner;
+		return 0;
+	}
+	fmr->fmr_flags |= FMR_OF_SPECIAL_OWNER;
+
+	switch (rm->rm_owner) {
+	case XFS_RMAP_OWN_FS:
+	case XFS_RMAP_OWN_LOG:
+	case XFS_RMAP_OWN_AG:
+	case XFS_RMAP_OWN_INOBT:
+	case XFS_RMAP_OWN_INODES:
+	case XFS_RMAP_OWN_REFC:
+	case XFS_RMAP_OWN_COW:
+		fmr->fmr_owner = rm->rm_owner;
+		return 0;
+	default:
+		return -EFSCORRUPTED;
+	}
+}
+
+/* getfsmap query state */
+struct xfs_getfsmap_info {
+	struct xfs_fsmap_head	*head;
+	struct xfs_fsmap	*rkey_low;	/* lowest key */
+	xfs_fsmap_format_t	formatter;	/* formatting fn */
+	void			*format_arg;	/* format buffer */
+	bool			last;		/* last extent? */
+	xfs_daddr_t		next_daddr;	/* next daddr we expect */
+	u32			dev;		/* device id */
+	u64			missing_owner;	/* owner of holes */
+
+	xfs_agnumber_t		agno;		/* AG number, if applicable */
+	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
+	struct xfs_rmap_irec	low;		/* low rmap key */
+	struct xfs_rmap_irec	high;		/* high rmap key */
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
+/* Compare a record against our starting point */
+static bool
+xfs_getfsmap_rec_before_low_key(
+	struct xfs_getfsmap_info	*info,
+	struct xfs_rmap_irec		*rec)
+{
+	uint64_t			x, y;
+
+	if (rec->rm_startblock < info->low.rm_startblock)
+		return true;
+	if (rec->rm_startblock > info->low.rm_startblock)
+		return false;
+
+	if (rec->rm_owner < info->low.rm_owner)
+		return true;
+	if (rec->rm_owner > info->low.rm_owner)
+		return false;
+
+	x = xfs_rmap_irec_offset_pack(rec);
+	y = xfs_rmap_irec_offset_pack(&info->low);
+	if (x < y)
+		return true;
+	return false;
+}
+
+/*
+ * Format a reverse mapping for getfsmap, having translated rm_startblock
+ * into the appropriate daddr units.
+ */
+STATIC int
+xfs_getfsmap_helper(
+	struct xfs_mount		*mp,
+	struct xfs_getfsmap_info	*info,
+	struct xfs_rmap_irec		*rec,
+	xfs_daddr_t			rec_daddr)
+{
+	struct xfs_fsmap		fmr;
+	xfs_daddr_t			key_end;
+	int				error;
+
+	/*
+	 * Filter out records that start before our startpoint, if the
+	 * caller requested that.
+	 */
+	if (xfs_getfsmap_rec_before_low_key(info, rec)) {
+		rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+		if (info->next_daddr < rec_daddr)
+			info->next_daddr = rec_daddr;
+		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+	}
+
+	/*
+	 * If the caller passed in a length with the low record and
+	 * the record represents a file data extent, we incremented
+	 * the offset in the low key by the length in the hopes of
+	 * finding reverse mappings for the physical blocks we just
+	 * saw.  We did /not/ increment next_daddr by the length
+	 * because the range query would not be able to find shared
+	 * extents within the same physical block range.
+	 *
+	 * However, the extent we've been fed could have a startblock
+	 * past the passed-in low record.  If this is the case,
+	 * advance next_daddr to the end of the passed-in low record
+	 * so we don't report the extent prior to this extent as
+	 * free.
+	 */
+	key_end = info->rkey_low->fmr_physical + info->rkey_low->fmr_length;
+	if (info->dev == info->rkey_low->fmr_device &&
+	    info->next_daddr < key_end && rec_daddr >= key_end)
+		info->next_daddr = key_end;
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
+	 * then we've found some free space.  Report that too.
+	 */
+	if (rec_daddr > info->next_daddr) {
+		if (info->head->fmh_entries >= info->head->fmh_count)
+			return XFS_BTREE_QUERY_RANGE_ABORT;
+
+		trace_xfs_fsmap_mapping(mp, info->dev, info->agno,
+				XFS_DADDR_TO_FSB(mp, info->next_daddr),
+				XFS_DADDR_TO_FSB(mp, rec_daddr -
+						info->next_daddr),
+				info->missing_owner, 0);
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
+	trace_xfs_fsmap_mapping(mp, info->dev, info->agno,
+			rec->rm_startblock, rec->rm_blockcount, rec->rm_owner,
+			rec->rm_offset);
+
+	fmr.fmr_device = info->dev;
+	fmr.fmr_physical = rec_daddr;
+	error = xfs_fsmap_owner_from_rmap(rec, &fmr);
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
+	return xfs_getfsmap_helper(mp, info, rec, rec_daddr);
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
+	return xfs_getfsmap_helper(mp, info, rec, rec_daddr);
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
+	struct xfs_fsmap		*dkey_low = keys;
+	struct xfs_btree_cur		cur;
+	struct xfs_rmap_irec		rmap;
+	int				error;
+
+	/* Set up search keys */
+	info->low.rm_startblock = XFS_BB_TO_FSBT(mp, dkey_low->fmr_physical);
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, dkey_low->fmr_offset);
+	error = xfs_fsmap_owner_to_rmap(keys, &info->low);
+	if (error)
+		return error;
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, dkey_low);
+
+	error = xfs_fsmap_owner_to_rmap(keys + 1, &info->high);
+	if (error)
+		return error;
+	info->high.rm_startblock = -1U;
+	info->high.rm_owner = ULLONG_MAX;
+	info->high.rm_offset = ULLONG_MAX;
+	info->high.rm_blockcount = 0;
+	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
+	info->missing_owner = FMR_OWN_FREE;
+
+	trace_xfs_fsmap_low_key(mp, info->dev, info->agno,
+			info->low.rm_startblock,
+			info->low.rm_blockcount,
+			info->low.rm_owner,
+			info->low.rm_offset);
+
+	trace_xfs_fsmap_high_key(mp, info->dev, info->agno,
+			info->high.rm_startblock,
+			info->high.rm_blockcount,
+			info->high.rm_owner,
+			info->high.rm_offset);
+
+
+	if (dkey_low->fmr_physical > 0)
+		return 0;
+
+	rmap.rm_startblock = 0;
+	rmap.rm_blockcount = mp->m_sb.sb_logblocks;
+	rmap.rm_owner = XFS_RMAP_OWN_LOG;
+	rmap.rm_offset = 0;
+	rmap.rm_flags = 0;
+
+	cur.bc_mp = mp;
+	return xfs_getfsmap_rtdev_helper(&cur, &rmap, info);
+}
+
+/* Execute a getfsmap query against the regular data device. */
+STATIC int
+xfs_getfsmap_datadev(
+	struct xfs_trans		*tp,
+	struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*bt_cur = NULL;
+	struct xfs_fsmap		*dkey_low;
+	struct xfs_fsmap		*dkey_high;
+	xfs_fsblock_t			start_fsb;
+	xfs_fsblock_t			end_fsb;
+	xfs_agnumber_t			start_ag;
+	xfs_agnumber_t			end_ag;
+	xfs_daddr_t			eofs;
+	int				error = 0;
+
+	dkey_low = keys;
+	dkey_high = keys + 1;
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (dkey_low->fmr_physical >= eofs)
+		return 0;
+	if (dkey_high->fmr_physical >= eofs)
+		dkey_high->fmr_physical = eofs - 1;
+	start_fsb = XFS_DADDR_TO_FSB(mp, dkey_low->fmr_physical);
+	end_fsb = XFS_DADDR_TO_FSB(mp, dkey_high->fmr_physical);
+
+	/* Set up search keys */
+	info->low.rm_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, dkey_low->fmr_offset);
+	error = xfs_fsmap_owner_to_rmap(dkey_low, &info->low);
+	if (error)
+		return error;
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, dkey_low);
+
+	info->high.rm_startblock = -1U;
+	info->high.rm_owner = ULLONG_MAX;
+	info->high.rm_offset = ULLONG_MAX;
+	info->high.rm_blockcount = 0;
+	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
+	info->missing_owner = FMR_OWN_FREE;
+
+	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
+	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
+
+	/* Query each AG */
+	for (info->agno = start_ag; info->agno <= end_ag; info->agno++) {
+		if (info->agno == end_ag) {
+			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
+					end_fsb);
+			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
+					dkey_high->fmr_offset);
+			error = xfs_fsmap_owner_to_rmap(dkey_high, &info->high);
+			if (error)
+				goto err;
+			xfs_getfsmap_set_irec_flags(&info->high, dkey_high);
+		}
+
+		if (bt_cur) {
+			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+			bt_cur = NULL;
+			info->agf_bp = NULL;
+		}
+
+		error = xfs_alloc_read_agf(mp, tp, info->agno, 0,
+				&info->agf_bp);
+		if (error)
+			goto err;
+
+		trace_xfs_fsmap_low_key(mp, info->dev, info->agno,
+				info->low.rm_startblock,
+				info->low.rm_blockcount,
+				info->low.rm_owner,
+				info->low.rm_offset);
+
+		trace_xfs_fsmap_high_key(mp, info->dev, info->agno,
+				info->high.rm_startblock,
+				info->high.rm_blockcount,
+				info->high.rm_owner,
+				info->high.rm_offset);
+
+		bt_cur = xfs_rmapbt_init_cursor(mp, tp, info->agf_bp,
+				info->agno);
+		error = xfs_rmap_query_range(bt_cur, &info->low, &info->high,
+				xfs_getfsmap_datadev_helper, info);
+		if (error)
+			goto err;
+
+		if (info->agno == start_ag) {
+			info->low.rm_startblock = 0;
+			info->low.rm_owner = 0;
+			info->low.rm_offset = 0;
+			info->low.rm_flags = 0;
+		}
+	}
+
+	/* Report any free space at the end of the AG */
+	info->last = true;
+	error = xfs_getfsmap_datadev_helper(bt_cur, &info->high, info);
+	if (error)
+		goto err;
+
+err:
+	if (bt_cur)
+		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
+							 XFS_BTREE_NOERROR);
+	if (info->agf_bp)
+		info->agf_bp = NULL;
+
+	return error;
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
+#define XFS_GETFSMAP_DEVS	3
+/*
+ * Get filesystem's extents as described in head, and format for
+ * output.  Calls formatter to fill the user's buffer until all
+ * extents are mapped, until the passed-in head->fmh_count slots have
+ * been filled, or until the formatter short-circuits the loop, if it
+ * is tracking filled-in extents on its own.
+ */
+int
+xfs_getfsmap(
+	struct xfs_mount		*mp,
+	struct xfs_fsmap_head		*head,
+	xfs_fsmap_format_t		formatter,
+	void				*arg)
+{
+	struct xfs_trans		*tp = NULL;
+	struct xfs_fsmap		*rkey_low;	/* request keys */
+	struct xfs_fsmap		*rkey_high;
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
+	rkey_low = head->fmh_keys;
+	rkey_high = rkey_low + 1;
+	if (!xfs_getfsmap_is_valid_device(mp, rkey_low) ||
+	    !xfs_getfsmap_is_valid_device(mp, rkey_high))
+		return -EINVAL;
+
+	head->fmh_entries = 0;
+
+	/* Set up our device handlers. */
+	memset(handlers, 0, sizeof(handlers));
+	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
+	handlers[0].fn = xfs_getfsmap_datadev;
+	if (mp->m_logdev_targp != mp->m_ddev_targp) {
+		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
+		handlers[1].fn = xfs_getfsmap_logdev;
+	}
+
+	xfs_sort(handlers, XFS_GETFSMAP_DEVS, sizeof(struct xfs_getfsmap_dev),
+			xfs_getfsmap_dev_compare);
+
+	/*
+	 * Since we allow the user to copy the last mapping from a previous
+	 * call into the low key slot, we have to advance the low key by
+	 * whatever the reported length is.  If the offset field doesn't apply,
+	 * move up the start block to the next extent and start over with the
+	 * lowest owner/offset possible; otherwise it's file data, so move up
+	 * the offset only.
+	 */
+	dkeys[0] = *rkey_low;
+	if (dkeys[0].fmr_flags & (FMR_OF_SPECIAL_OWNER | FMR_OF_EXTENT_MAP)) {
+		dkeys[0].fmr_physical += dkeys[0].fmr_length;
+		dkeys[0].fmr_owner = 0;
+		dkeys[0].fmr_offset = 0;
+	} else
+		dkeys[0].fmr_offset += dkeys[0].fmr_length;
+	memset(&dkeys[1], 0xFF, sizeof(struct xfs_fsmap));
+
+	if (!xfs_getfsmap_check_keys(dkeys, rkey_high))
+		return -EINVAL;
+
+	info.rkey_low = rkey_low;
+	info.formatter = formatter;
+	info.format_arg = arg;
+	info.head = head;
+
+	/* For each device we support... */
+	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
+		/* Is this device within the range the user asked for? */
+		if (!handlers[i].fn)
+			continue;
+		if (rkey_low->fmr_device > handlers[i].dev)
+			continue;
+		if (rkey_high->fmr_device < handlers[i].dev)
+			break;
+
+		/*
+		 * If this device number matches the high key, we have
+		 * to pass the high key to the handler to limit the
+		 * query results.  If the device number exceeds the
+		 * low key, zero out the low key so that we get
+		 * everything from the beginning.
+		 */
+		if (handlers[i].dev == rkey_high->fmr_device)
+			dkeys[1] = *rkey_high;
+		if (handlers[i].dev > rkey_low->fmr_device)
+			memset(&dkeys[0], 0, sizeof(struct xfs_fsmap));
+
+		error = xfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			break;
+
+		info.next_daddr = dkeys[0].fmr_physical;
+		info.dev = handlers[i].dev;
+		info.last = false;
+		info.agno = NULLAGNUMBER;
+		error = handlers[i].fn(tp, dkeys, &info);
+		if (error)
+			break;
+		xfs_trans_cancel(tp);
+		tp = NULL;
+	}
+
+	if (tp)
+		xfs_trans_cancel(tp);
+	head->fmh_oflags = FMH_OF_DEV_T;
+	return error;
+}
diff --git a/fs/xfs/xfs_fsmap.h b/fs/xfs/xfs_fsmap.h
new file mode 100644
index 0000000..1943047
--- /dev/null
+++ b/fs/xfs/xfs_fsmap.h
@@ -0,0 +1,51 @@
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
+#define	__XFS_FSMAP_H__
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
index c67cfb4..d39da5d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -41,6 +41,8 @@
 #include "xfs_trans.h"
 #include "xfs_pnfs.h"
 #include "xfs_acl.h"
+#include "xfs_btree.h"
+#include "xfs_fsmap.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -1607,6 +1609,103 @@ xfs_ioc_getbmapx(
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
+	trace_xfs_getfsmap_mapping(info->mp, xfm->fmr_device, xfm->fmr_physical,
+			xfm->fmr_length, xfm->fmr_owner, xfm->fmr_offset,
+			xfm->fmr_flags);
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
+	if (head.fmh_reserved[0] || head.fmh_reserved[1] ||
+	    head.fmh_reserved[2] || head.fmh_reserved[3] ||
+	    head.fmh_reserved[4] || head.fmh_reserved[5] ||
+	    head.fmh_keys[0].fmr_reserved[0] ||
+	    head.fmh_keys[0].fmr_reserved[1] ||
+	    head.fmh_keys[0].fmr_reserved[2] ||
+	    head.fmh_keys[1].fmr_reserved[0] ||
+	    head.fmh_keys[1].fmr_reserved[1] ||
+	    head.fmh_keys[1].fmr_reserved[2])
+		return -EINVAL;
+
+	xhead.fmh_iflags = head.fmh_iflags;
+	xhead.fmh_count = head.fmh_count;
+	xfs_fsmap_to_internal(&xhead.fmh_keys[0], &head.fmh_keys[0]);
+	xfs_fsmap_to_internal(&xhead.fmh_keys[1], &head.fmh_keys[1]);
+
+	trace_xfs_getfsmap_low_key(ip->i_mount,
+			xhead.fmh_keys[0].fmr_device,
+			xhead.fmh_keys[0].fmr_physical,
+			xhead.fmh_keys[0].fmr_length,
+			xhead.fmh_keys[0].fmr_owner,
+			xhead.fmh_keys[0].fmr_offset,
+			xhead.fmh_keys[0].fmr_flags);
+
+	trace_xfs_getfsmap_high_key(ip->i_mount,
+			xhead.fmh_keys[1].fmr_device,
+			xhead.fmh_keys[1].fmr_physical,
+			xhead.fmh_keys[1].fmr_length,
+			xhead.fmh_keys[1].fmr_owner,
+			xhead.fmh_keys[1].fmr_offset,
+			xhead.fmh_keys[1].fmr_flags);
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
@@ -1787,6 +1886,11 @@ xfs_file_ioctl(
 	case XFS_IOC_GETBMAPX:
 		return xfs_ioc_getbmapx(ip, arg);
 
+	case XFS_IOC_GETFSMAP:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		return xfs_ioc_getfsmap(ip, arg);
+
 	case XFS_IOC_FD_TO_HANDLE:
 	case XFS_IOC_PATH_TO_HANDLE:
 	case XFS_IOC_PATH_TO_FSHANDLE: {
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 7c49938..5ba41b7 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -554,6 +554,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
+	case XFS_IOC_GETFSMAP:
 		return xfs_file_ioctl(filp, cmd, p);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 69c5bcd..09f4755 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3266,6 +3266,91 @@ DEFINE_INODE_IREC_EVENT(xfs_swap_extent_rmap_remap);
 DEFINE_INODE_IREC_EVENT(xfs_swap_extent_rmap_remap_piece);
 DEFINE_INODE_ERROR_EVENT(xfs_swap_extent_rmap_error);
 
+/* fsmap traces */
+DECLARE_EVENT_CLASS(xfs_fsmap_class,
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno,
+		 xfs_fsblock_t bno, xfs_filblks_t len, __uint64_t owner,
+		 __uint64_t offset),
+	TP_ARGS(mp, keydev, agno, bno, len, owner, offset),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, keydev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_fsblock_t, bno)
+		__field(xfs_filblks_t, len)
+		__field(__uint64_t, owner)
+		__field(__uint64_t, offset)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->keydev = new_decode_dev(keydev);
+		__entry->agno = agno;
+		__entry->bno = bno;
+		__entry->len = len;
+		__entry->owner = owner;
+		__entry->offset = offset;
+	),
+	TP_printk("dev %d:%d keydev %d:%d agno %u bno %llu len %llu owner %lld offset 0x%llx\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset)
+)
+#define DEFINE_FSMAP_EVENT(name) \
+DEFINE_EVENT(xfs_fsmap_class, name, \
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno, \
+		 xfs_fsblock_t bno, xfs_filblks_t len, __uint64_t owner, \
+		 __uint64_t offset), \
+	TP_ARGS(mp, keydev, agno, bno, len, owner, offset))
+DEFINE_FSMAP_EVENT(xfs_fsmap_low_key);
+DEFINE_FSMAP_EVENT(xfs_fsmap_high_key);
+DEFINE_FSMAP_EVENT(xfs_fsmap_mapping);
+
+DECLARE_EVENT_CLASS(xfs_getfsmap_class,
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_daddr_t block,
+		 xfs_daddr_t len, __uint64_t owner, __uint64_t offset,
+		 __uint64_t flags),
+	TP_ARGS(mp, keydev, block, len, owner, offset, flags),
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
+		__entry->keydev = new_decode_dev(keydev);
+		__entry->block = block;
+		__entry->len = len;
+		__entry->owner = owner;
+		__entry->offset = offset;
+		__entry->flags = flags;
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
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_daddr_t block, \
+		 xfs_daddr_t len, __uint64_t owner, __uint64_t offset, \
+		 __uint64_t flags), \
+	TP_ARGS(mp, keydev, block, len, owner, offset, flags))
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

