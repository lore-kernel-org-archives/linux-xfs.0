Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9DF8A7FC8
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:30:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A9EB304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:11 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 5byMWYv0RRqpOPgX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:07 -0700 (PDT)
Subject: [PATCH 112/119] xfs: introduce the XFS_IOC_GETFSMAPX ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:29:57 -0700
Message-ID: <146612699713.12839.10667733856057619716.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Introduce a new ioctl that uses the reverse mapping btree to return
information about the physical layout of the filesystem.

v2: shorten the device field to u32 since that's all we need for
dev_t.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h       |   62 ++++++++
 fs/xfs/libxfs/xfs_refcount.c |   51 +++++-
 fs/xfs/libxfs/xfs_refcount.h |    4 
 fs/xfs/xfs_fsops.c           |  338 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.h           |    6 +
 fs/xfs/xfs_ioctl.c           |   76 +++++++++
 fs/xfs/xfs_ioctl32.c         |    1 
 fs/xfs/xfs_trace.h           |   76 +++++++++
 8 files changed, 600 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 10ebf99..8a1b96a 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -93,6 +93,67 @@ struct getbmapx {
 #define BMV_OF_SHARED		0x8	/* segment shared with another file */
 
 /*
+ *	Structure for XFS_IOC_GETFSMAPX.
+ *
+ *	Similar to XFS_IOC_GETBMAPX, the first two elements in the array are
+ *	used to constrain the output.  The first element in the array should
+ *	represent the lowest disk address that the user wants to learn about.
+ *	The second element in the array should represent the highest disk
+ *	address to query.  Subsequent array elements will be filled out by the
+ *	command.
+ *
+ *	The fmv_iflags field is only used in the first structure.  The
+ *	fmv_oflags field is filled in for each returned structure after the
+ *	second structure.  The fmv_unused1 fields in the first two array
+ *	elements must be zero.
+ *
+ *	The fmv_count, fmv_entries, and fmv_iflags fields in the second array
+ *	element must be zero.
+ *
+ *	fmv_block, fmv_offset, and fmv_length are expressed in units of 512
+ *	byte sectors.
+ */
+#ifndef HAVE_GETFSMAPX
+struct getfsmapx {
+	__u32		fmv_device;	/* device id */
+	__u32		fmv_unused1;	/* future use, must be zero */
+	__u64		fmv_block;	/* starting block */
+	__u64		fmv_owner;	/* owner id */
+	__u64		fmv_offset;	/* file offset of segment */
+	__u64		fmv_length;	/* length of segment, blocks */
+	__u32		fmv_oflags;	/* mapping flags */
+	__u32		fmv_iflags;	/* control flags (1st structure) */
+	__u32		fmv_count;	/* # of entries in array incl. input */
+	__u32		fmv_entries;	/* # of entries filled in (output). */
+	__u64		fmv_unused2;	/* future use, must be zero */
+};
+#endif
+
+/*	fmv_flags values - set by XFS_IOC_GETFSMAPX caller.	*/
+/* no flags defined yet */
+#define FMV_IF_VALID	0
+
+/*	fmv_flags values - returned for each non-header segment */
+#define FMV_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
+#define FMV_OF_ATTR_FORK	0x2	/* segment = attribute fork */
+#define FMV_OF_EXTENT_MAP	0x4	/* segment = extent map */
+#define FMV_OF_SHARED		0x8	/* segment = shared with another file */
+#define FMV_OF_SPECIAL_OWNER	0x10	/* owner is a special value */
+#define FMV_OF_LAST		0x20	/* segment is the last in the FS */
+
+/*	fmv_owner special values */
+#define	FMV_OWN_FREE		(-1ULL)	/* free space */
+#define FMV_OWN_UNKNOWN		(-2ULL)	/* unknown owner */
+#define FMV_OWN_FS		(-3ULL)	/* static fs metadata */
+#define FMV_OWN_LOG		(-4ULL)	/* journalling log */
+#define FMV_OWN_AG		(-5ULL)	/* per-AG metadata */
+#define FMV_OWN_INOBT		(-6ULL)	/* inode btree blocks */
+#define FMV_OWN_INODES		(-7ULL)	/* inodes */
+#define FMV_OWN_REFC		(-8ULL) /* refcount tree */
+#define FMV_OWN_COW		(-9ULL) /* cow allocations */
+#define FMV_OWN_DEFECTIVE	(-10ULL) /* bad blocks */
+
+/*
  * Structure for XFS_IOC_FSSETDM.
  * For use by backup and restore programs to set the XFS on-disk inode
  * fields di_dmevmask and di_dmstate.  These must be set to exactly and
@@ -502,6 +563,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
+#define XFS_IOC_GETFSMAPX	_IOWR('X', 59, struct getfsmapx)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index fd4369f..e8d8702 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1172,8 +1172,9 @@ xfs_refcount_decrease_extent(
  * extent we find.  If no shared blocks are found, flen will be set to zero.
  */
 int
-xfs_refcount_find_shared(
+__xfs_refcount_find_shared(
 	struct xfs_mount	*mp,
+	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen,
@@ -1182,23 +1183,13 @@ xfs_refcount_find_shared(
 	bool			find_maximal)
 {
 	struct xfs_btree_cur	*cur;
-	struct xfs_buf		*agbp;
 	struct xfs_refcount_irec	tmp;
-	int			error;
 	int			i, have;
 	int			bt_error = XFS_BTREE_ERROR;
+	int			error;
 
 	trace_xfs_refcount_find_shared(mp, agno, agbno, aglen);
 
-	if (xfs_always_cow) {
-		*fbno = agbno;
-		*flen = aglen;
-		return 0;
-	}
-
-	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
-	if (error)
-		goto out;
 	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
 
 	/* By default, skip the whole range */
@@ -1273,14 +1264,46 @@ done:
 
 out_error:
 	xfs_btree_del_cursor(cur, bt_error);
-	xfs_buf_relse(agbp);
-out:
 	if (error)
 		trace_xfs_refcount_find_shared_error(mp, agno, error, _RET_IP_);
 	return error;
 }
 
 /*
+ * Given an AG extent, find the lowest-numbered run of shared blocks within
+ * that range and return the range in fbno/flen.
+ */
+int
+xfs_refcount_find_shared(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	xfs_agblock_t		*fbno,
+	xfs_extlen_t		*flen,
+	bool			find_maximal)
+{
+	struct xfs_buf		*agbp;
+	int			error;
+
+	if (xfs_always_cow) {
+		*fbno = agbno;
+		*flen = aglen;
+		return 0;
+	}
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	error = __xfs_refcount_find_shared(mp, agbp, agno, agbno, aglen,
+			fbno, flen, find_maximal);
+
+	xfs_buf_relse(agbp);
+	return error;
+}
+
+/*
  * Recovering CoW Blocks After a Crash
  *
  * Due to the way that the copy on write mechanism works, there's a window of
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 6665eeb..44b0346 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -53,6 +53,10 @@ extern int xfs_refcount_finish_one(struct xfs_trans *tp,
 		xfs_fsblock_t startblock, xfs_extlen_t blockcount,
 		xfs_extlen_t *adjusted, struct xfs_btree_cur **pcur);
 
+extern int __xfs_refcount_find_shared(struct xfs_mount *mp,
+		struct xfs_buf *agbp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		xfs_extlen_t aglen, xfs_agblock_t *fbno, xfs_extlen_t *flen,
+		bool find_maximal);
 extern int xfs_refcount_find_shared(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
 		xfs_extlen_t *flen, bool find_maximal);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index e76aefc..e69d9cf 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -44,6 +44,8 @@
 #include "xfs_filestream.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_ag_resv.h"
+#include "xfs_bit.h"
+#include "xfs_refcount.h"
 
 /*
  * File system operations
@@ -1027,3 +1029,339 @@ xfs_fs_unreserve_ag_blocks(
 	if (error)
 		xfs_warn(mp, "Error %d unreserving metadata blocks.", error);
 }
+
+struct xfs_getfsmap_info {
+	struct getfsmapx	*fmv;
+	xfs_fsmap_format_t	formatter;
+	void			*format_arg;
+	xfs_daddr_t		next_daddr;
+	bool			last;
+	xfs_agnumber_t		start_ag;
+	struct xfs_rmap_irec	low;
+};
+
+/* Compare a record against our starting point */
+static bool
+xfs_getfsmap_compare(
+	xfs_agnumber_t			agno,
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
+STATIC bool
+xfs_getfsmap_is_shared(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec)
+{
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			error;
+
+	if (!xfs_sb_version_hasreflink(&cur->bc_mp->m_sb))
+		return false;
+
+	/* Are there any shared blocks here? */
+	flen = 0;
+	error = __xfs_refcount_find_shared(cur->bc_mp, cur->bc_private.a.agbp,
+			cur->bc_private.a.agno, rec->rm_startblock,
+			rec->rm_blockcount, &fbno, &flen, false);
+	return error == 0 && flen > 0;
+}
+
+/* Transform a rmap irec into a fsmapx */
+STATIC int
+xfs_getfsmap_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_getfsmap_info	*info = priv;
+	xfs_fsblock_t			fsb;
+	struct getfsmapx		fmv;
+	xfs_daddr_t			rec_daddr;
+	int				error;
+
+	fsb = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
+			rec->rm_startblock);
+	rec_daddr = XFS_FSB_TO_DADDR(mp, fsb);
+
+	/*
+	 * Filter out records that start before our startpoint, if the caller
+	 * requested that.
+	 */
+	if (info->fmv->fmv_length &&
+	    xfs_getfsmap_compare(cur->bc_private.a.agno, info, rec)) {
+		rec_daddr = XFS_FSB_TO_DADDR(mp, fsb +
+				rec->rm_blockcount);
+		if (info->next_daddr < rec_daddr)
+			info->next_daddr = rec_daddr;
+		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+	}
+
+	/* We're just counting mappings */
+	if (info->fmv->fmv_count == 2) {
+		if (rec_daddr > info->next_daddr)
+			info->fmv->fmv_entries++;
+
+		if (info->last)
+			return XFS_BTREE_QUERY_RANGE_CONTINUE;
+
+		info->fmv->fmv_entries++;
+
+		rec_daddr = XFS_FSB_TO_DADDR(mp, fsb +
+				rec->rm_blockcount);
+		if (info->next_daddr < rec_daddr)
+			info->next_daddr = rec_daddr;
+		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+	}
+
+	/* Did we find some free space? */
+	if (rec_daddr > info->next_daddr) {
+		if (info->fmv->fmv_entries >= info->fmv->fmv_count - 2)
+			return XFS_BTREE_QUERY_RANGE_ABORT;
+
+		trace_xfs_fsmap_mapping(mp, cur->bc_private.a.agno,
+				XFS_DADDR_TO_FSB(mp, info->next_daddr),
+				XFS_DADDR_TO_FSB(mp, rec_daddr -
+						info->next_daddr),
+				FMV_OWN_FREE, 0);
+
+		fmv.fmv_device = new_encode_dev(mp->m_ddev_targp->bt_dev);
+		fmv.fmv_block = info->next_daddr;
+		fmv.fmv_owner = FMV_OWN_FREE;
+		fmv.fmv_offset = 0;
+		fmv.fmv_length = rec_daddr - info->next_daddr;
+		fmv.fmv_oflags = FMV_OF_SPECIAL_OWNER;
+		fmv.fmv_count = 0;
+		fmv.fmv_entries = 0;
+		fmv.fmv_unused1 = 0;
+		fmv.fmv_unused2 = 0;
+		error = info->formatter(&fmv, info->format_arg);
+		if (error)
+			return error;
+		info->fmv->fmv_entries++;
+	}
+
+	if (info->last)
+		goto out;
+
+	/* Fill out the extent we found */
+	if (info->fmv->fmv_entries >= info->fmv->fmv_count - 2)
+		return XFS_BTREE_QUERY_RANGE_ABORT;
+
+	trace_xfs_fsmap_mapping(mp, cur->bc_private.a.agno,
+			rec->rm_startblock, rec->rm_blockcount, rec->rm_owner,
+			rec->rm_offset);
+
+	fmv.fmv_device = new_encode_dev(mp->m_ddev_targp->bt_dev);
+	fmv.fmv_block = rec_daddr;
+	fmv.fmv_owner = rec->rm_owner;
+	fmv.fmv_offset = XFS_FSB_TO_BB(mp, rec->rm_offset);
+	fmv.fmv_length = XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+	fmv.fmv_oflags = 0;
+	fmv.fmv_count = 0;
+	fmv.fmv_entries = 0;
+	fmv.fmv_unused1 = 0;
+	fmv.fmv_unused2 = 0;
+	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner))
+		fmv.fmv_oflags |= FMV_OF_SPECIAL_OWNER;
+	if (rec->rm_flags & XFS_RMAP_UNWRITTEN)
+		fmv.fmv_oflags |= FMV_OF_PREALLOC;
+	if (rec->rm_flags & XFS_RMAP_ATTR_FORK)
+		fmv.fmv_oflags |= FMV_OF_ATTR_FORK;
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK)
+		fmv.fmv_oflags |= FMV_OF_EXTENT_MAP;
+	if (fmv.fmv_oflags == 0 && xfs_getfsmap_is_shared(cur, rec))
+		fmv.fmv_oflags |= FMV_OF_SHARED;
+	error = info->formatter(&fmv, info->format_arg);
+	if (error)
+		return error;
+	info->fmv->fmv_entries++;
+
+out:
+	rec_daddr = XFS_FSB_TO_DADDR(mp, fsb + rec->rm_blockcount);
+	if (info->next_daddr < rec_daddr)
+		info->next_daddr = rec_daddr;
+	return XFS_BTREE_QUERY_RANGE_CONTINUE;
+}
+
+/* Do we recognize the device? */
+STATIC bool
+xfs_getfsmap_is_valid_device(
+	struct xfs_mount	*mp,
+	struct getfsmapx	*fmv)
+{
+	return fmv->fmv_device == 0 || fmv->fmv_device == UINT_MAX ||
+	       fmv->fmv_device == new_encode_dev(mp->m_ddev_targp->bt_dev);
+}
+
+/*
+ * Get filesystem's extents as described in fmv, and format for
+ * output.  Calls formatter to fill the user's buffer until all
+ * extents are mapped, until the passed-in fmv->fmv_count slots have
+ * been filled, or until the formatter short-circuits the loop, if it
+ * is tracking filled-in extents on its own.
+ */
+int
+xfs_getfsmap(
+	struct xfs_mount	*mp,
+	struct getfsmapx	*fmv,
+	xfs_fsmap_format_t	formatter,
+	void			*arg)
+{
+	struct xfs_getfsmap_info	info;
+	struct xfs_buf		*agbp = NULL;
+	struct xfs_btree_cur	*bt_cur = NULL;
+	struct getfsmapx	*fmv_low;
+	struct getfsmapx	*fmv_high;
+	struct xfs_rmap_irec	high;
+	xfs_fsblock_t		start_fsb;
+	xfs_fsblock_t		end_fsb;
+	xfs_agnumber_t		end_ag;
+	xfs_agnumber_t		agno;
+	xfs_daddr_t		eofs;
+	xfs_extlen_t		extlen;
+	int			error = 0;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+	if (fmv->fmv_count < 2)
+		return -EINVAL;
+	if (fmv->fmv_iflags & (~FMV_IF_VALID))
+		return -EINVAL;
+	fmv_low = fmv;
+	fmv_high = fmv + 1;
+	if (!xfs_getfsmap_is_valid_device(mp, fmv) ||
+	    !xfs_getfsmap_is_valid_device(mp, fmv_high) ||
+	    fmv_high->fmv_iflags || fmv_high->fmv_count ||
+	    fmv_high->fmv_length || fmv_high->fmv_entries ||
+	    fmv_high->fmv_unused1 || fmv->fmv_unused1 ||
+	    fmv_high->fmv_unused2 || fmv->fmv_unused2)
+		return -EINVAL;
+
+	fmv->fmv_entries = 0;
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (fmv->fmv_block >= eofs)
+		return 0;
+	if (fmv_high->fmv_block >= eofs)
+		fmv_high->fmv_block = eofs - 1;
+	start_fsb = XFS_DADDR_TO_FSB(mp, fmv->fmv_block);
+	end_fsb = XFS_DADDR_TO_FSB(mp, fmv_high->fmv_block);
+
+	/* Set up search keys */
+	info.low.rm_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
+	info.low.rm_offset = XFS_DADDR_TO_FSB(mp, fmv->fmv_offset);
+	info.low.rm_owner = fmv->fmv_owner;
+	info.low.rm_blockcount = 0;
+	extlen = XFS_DADDR_TO_FSB(mp, fmv->fmv_length);
+	if (fmv->fmv_oflags & (FMV_OF_SPECIAL_OWNER | FMV_OF_EXTENT_MAP)) {
+		info.low.rm_startblock += extlen;
+		info.low.rm_owner = 0;
+		info.low.rm_offset = 0;
+	} else
+		info.low.rm_offset += extlen;
+	if (fmv->fmv_oflags & FMV_OF_ATTR_FORK)
+		info.low.rm_flags |= XFS_RMAP_ATTR_FORK;
+	if (fmv->fmv_oflags & FMV_OF_EXTENT_MAP)
+		info.low.rm_flags |= XFS_RMAP_BMBT_BLOCK;
+	if (fmv->fmv_oflags & FMV_OF_PREALLOC)
+		info.low.rm_flags |= XFS_RMAP_UNWRITTEN;
+
+	high.rm_startblock = -1U;
+	high.rm_owner = ULLONG_MAX;
+	high.rm_offset = ULLONG_MAX;
+	high.rm_blockcount = 0;
+	high.rm_flags = XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			XFS_RMAP_UNWRITTEN;
+	info.fmv = fmv;
+	info.formatter = formatter;
+	info.format_arg = arg;
+	info.last = false;
+
+	info.start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
+	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
+	info.next_daddr = XFS_FSB_TO_DADDR(mp, XFS_AGB_TO_FSB(mp, info.start_ag,
+			info.low.rm_startblock));
+
+	/* Query each AG */
+	for (agno = info.start_ag; agno <= end_ag; agno++) {
+		if (agno == end_ag) {
+			high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsb);
+			high.rm_offset = XFS_DADDR_TO_FSB(mp,
+					fmv_high->fmv_offset);
+			high.rm_owner = fmv_high->fmv_owner;
+			if (fmv_high->fmv_oflags & FMV_OF_ATTR_FORK)
+				high.rm_flags |= XFS_RMAP_ATTR_FORK;
+			if (fmv_high->fmv_oflags & FMV_OF_EXTENT_MAP)
+				high.rm_flags |= XFS_RMAP_BMBT_BLOCK;
+			if (fmv_high->fmv_oflags & FMV_OF_PREALLOC)
+				high.rm_flags |= XFS_RMAP_UNWRITTEN;
+		}
+
+		if (bt_cur) {
+			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+			xfs_trans_brelse(NULL, agbp);
+			bt_cur = NULL;
+			agbp = NULL;
+		}
+
+		error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+		if (error)
+			goto err;
+
+		trace_xfs_fsmap_low_key(mp, agno, info.low.rm_startblock,
+				info.low.rm_blockcount, info.low.rm_owner,
+				info.low.rm_offset);
+
+		trace_xfs_fsmap_high_key(mp, agno, high.rm_startblock,
+				high.rm_blockcount, high.rm_owner,
+				high.rm_offset);
+
+		bt_cur = xfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
+		error = xfs_rmapbt_query_range(bt_cur, &info.low, &high,
+				xfs_getfsmap_helper, &info);
+		if (error)
+			goto err;
+
+		if (agno == info.start_ag) {
+			info.low.rm_startblock = 0;
+			info.low.rm_owner = 0;
+			info.low.rm_offset = 0;
+			info.low.rm_flags = 0;
+		}
+	}
+
+	/* Report any free space at the end of the AG */
+	info.last = true;
+	error = xfs_getfsmap_helper(bt_cur, &high, &info);
+	if (error)
+		goto err;
+
+err:
+	if (bt_cur)
+		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
+							 XFS_BTREE_NOERROR);
+	if (agbp)
+		xfs_trans_brelse(NULL, agbp);
+
+	return error;
+}
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 71e3248..8101fb9 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -29,4 +29,10 @@ extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
 extern void xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
 extern void xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
 
+/* fsmap to userspace formatter - copy to user & advance pointer */
+typedef int (*xfs_fsmap_format_t)(struct getfsmapx *, void *);
+
+int	xfs_getfsmap(struct xfs_mount *mp, struct getfsmapx *fmv,
+		xfs_fsmap_format_t formatter, void *arg);
+
 #endif	/* __XFS_FSOPS_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index aa9645c..736e747 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -42,6 +42,7 @@
 #include "xfs_pnfs.h"
 #include "xfs_acl.h"
 #include "xfs_reflink.h"
+#include "xfs_btree.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -1611,6 +1612,76 @@ xfs_ioc_getbmapx(
 	return 0;
 }
 
+struct getfsmapx_info {
+	struct xfs_mount	*mp;
+	struct getfsmapx __user	*data;
+	__s64			last_flags;
+};
+
+STATIC int
+xfs_getfsmapx_format(struct getfsmapx *fmv, void *priv)
+{
+	struct getfsmapx_info	*info = priv;
+
+	trace_xfs_getfsmap_mapping(info->mp, fmv->fmv_block,
+			fmv->fmv_length, fmv->fmv_owner,
+			fmv->fmv_offset, fmv->fmv_oflags);
+
+	info->last_flags = fmv->fmv_oflags;
+	if (copy_to_user(info->data, fmv, sizeof(struct getfsmapx)))
+		return -EFAULT;
+
+	info->data++;
+	return 0;
+}
+
+STATIC int
+xfs_ioc_getfsmapx(
+	struct xfs_inode	*ip,
+	void			__user *arg)
+{
+	struct getfsmapx_info	info;
+	struct getfsmapx	fmx[2];
+	bool			aborted = false;
+	int			error;
+
+	if (copy_from_user(&fmx, arg, 2 * sizeof(struct getfsmapx)))
+		return -EFAULT;
+
+	trace_xfs_getfsmap_low_key(ip->i_mount, fmx[0].fmv_block,
+			fmx[0].fmv_length, fmx[0].fmv_owner,
+			fmx[0].fmv_offset, fmx[0].fmv_oflags);
+
+	trace_xfs_getfsmap_high_key(ip->i_mount, fmx[1].fmv_block,
+			fmx[1].fmv_length, fmx[1].fmv_owner,
+			fmx[1].fmv_offset, fmx[1].fmv_oflags);
+
+	info.mp = ip->i_mount;
+	info.data = (__force struct getfsmapx *)arg + 2;
+	error = xfs_getfsmap(ip->i_mount, fmx, xfs_getfsmapx_format, &info);
+	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
+		error = 0;
+		aborted = true;
+	}
+	if (error)
+		return error;
+
+	/* If we didn't abort, set the "last" flag in the last fmx */
+	if (!aborted && fmx[0].fmv_entries) {
+		info.data--;
+		info.last_flags |= FMV_OF_LAST;
+		if (copy_to_user(&info.data->fmv_oflags, &info.last_flags,
+				sizeof(info.last_flags)))
+			return -EFAULT;
+	}
+
+	/* copy back header */
+	if (copy_to_user(arg, fmx, 2 * sizeof(struct getfsmapx)))
+		return -EFAULT;
+
+	return 0;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1784,6 +1855,11 @@ xfs_file_ioctl(
 	case XFS_IOC_GETBMAPX:
 		return xfs_ioc_getbmapx(ip, arg);
 
+	case XFS_IOC_GETFSMAPX:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		return xfs_ioc_getfsmapx(ip, arg);
+
 	case XFS_IOC_FD_TO_HANDLE:
 	case XFS_IOC_PATH_TO_HANDLE:
 	case XFS_IOC_PATH_TO_FSHANDLE: {
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 1a05d8a..337e436 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -558,6 +558,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_GOINGDOWN:
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
+	case XFS_IOC_GETFSMAPX:
 		return xfs_file_ioctl(filp, cmd, p);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d64bab7..9fe812f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3352,6 +3352,82 @@ DEFINE_INODE_EVENT(xfs_reflink_cancel_pending_cow);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cancel_cow);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_pending_cow_error);
 
+/* fsmap traces */
+DECLARE_EVENT_CLASS(xfs_fsmap_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		 xfs_extlen_t len, __uint64_t owner, __uint64_t offset),
+	TP_ARGS(mp, agno, agbno, len, owner, offset),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(__uint64_t, owner)
+		__field(__uint64_t, offset)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->owner = owner;
+		__entry->offset = offset;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld offset 0x%llx\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset)
+)
+#define DEFINE_FSMAP_EVENT(name) \
+DEFINE_EVENT(xfs_fsmap_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len, __uint64_t owner, \
+		 __uint64_t offset), \
+	TP_ARGS(mp, agno, agbno, len, owner, offset))
+DEFINE_FSMAP_EVENT(xfs_fsmap_low_key);
+DEFINE_FSMAP_EVENT(xfs_fsmap_high_key);
+DEFINE_FSMAP_EVENT(xfs_fsmap_mapping);
+
+DECLARE_EVENT_CLASS(xfs_getfsmap_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_daddr_t block, xfs_daddr_t len,
+		 __uint64_t owner, __uint64_t offset, __uint64_t flags),
+	TP_ARGS(mp, block, len, owner, offset, flags),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_daddr_t, block)
+		__field(xfs_daddr_t, len)
+		__field(__uint64_t, owner)
+		__field(__uint64_t, offset)
+		__field(__uint64_t, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->block = block;
+		__entry->len = len;
+		__entry->owner = owner;
+		__entry->offset = offset;
+		__entry->flags = flags;
+	),
+	TP_printk("dev %d:%d block %llu len %llu owner %lld offset %llu flags 0x%llx\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->block,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
+)
+#define DEFINE_GETFSMAP_EVENT(name) \
+DEFINE_EVENT(xfs_getfsmap_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_daddr_t block, xfs_daddr_t len, \
+		 __uint64_t owner, __uint64_t offset, __uint64_t flags), \
+	TP_ARGS(mp, block, len, owner, offset, flags))
+DEFINE_GETFSMAP_EVENT(xfs_getfsmap_low_key);
+DEFINE_GETFSMAP_EVENT(xfs_getfsmap_high_key);
+DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
