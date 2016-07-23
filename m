Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 715D87CA0
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 23:28:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C15DFAC005
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 21:28:37 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 5AkzZAKcmPT2hehQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2016 21:28:30 -0700 (PDT)
Date: Fri, 22 Jul 2016 21:28:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 47/47] xfs: introduce the XFS_IOC_GETFSMAP ioctl
Message-ID: <20160723042812.GA4684@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907727500.25461.15944158970310442107.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907727500.25461.15944158970310442107.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Introduce a new ioctl that uses the reverse mapping btree to return
information about the physical layout of the filesystem.

v2: shorten the device field to u32 since that's all we need for
dev_t.  Support reporting reverse mapping information for all the
devices that XFS supports (data, log).

v3: don't call the function that reports the journalling log rmap if
we don't have an external device, since the regular rmapbt will take
care of that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   65 ++++++
 fs/xfs/xfs_fsops.c     |  528 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.h     |    6 +
 fs/xfs/xfs_ioctl.c     |   76 +++++++
 fs/xfs/xfs_ioctl32.c   |    1 
 fs/xfs/xfs_trace.h     |   76 +++++++
 6 files changed, 752 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 7945505..b08f23d 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -91,6 +91,70 @@ struct getbmapx {
 #define BMV_OF_LAST		0x4	/* segment is the last in the file */
 
 /*
+ *	Structure for XFS_IOC_GETFSMAP.
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
+#ifndef HAVE_GETFSMAP
+struct getfsmap {
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
+/*	fmv_iflags values - set by XFS_IOC_GETFSMAP caller in the header. */
+/* no flags defined yet */
+#define FMV_HIF_VALID		0
+
+/*	fmv_oflags values - returned in the header segment only. */
+#define FMV_HOF_DEV_T		0x1	/* fmv_device values will be dev_t */
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
+#define FMV_OWN_FREE		(-1ULL)	/* free space */
+#define FMV_OWN_UNKNOWN		(-2ULL)	/* unknown owner */
+#define FMV_OWN_FS		(-3ULL)	/* static fs metadata */
+#define FMV_OWN_LOG		(-4ULL)	/* journalling log */
+#define FMV_OWN_AG		(-5ULL)	/* per-AG metadata */
+#define FMV_OWN_INOBT		(-6ULL)	/* inode btree blocks */
+#define FMV_OWN_INODES		(-7ULL)	/* inodes */
+#define FMV_OWN_REFC		(-8ULL) /* refcount tree */
+#define FMV_OWN_COW		(-9ULL) /* cow staging */
+#define FMV_OWN_DEFECTIVE	(-10ULL) /* bad blocks */
+
+/*
  * Structure for XFS_IOC_FSSETDM.
  * For use by backup and restore programs to set the XFS on-disk inode
  * fields di_dmevmask and di_dmstate.  These must be set to exactly and
@@ -498,6 +562,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
+#define XFS_IOC_GETFSMAP	_IOWR('X', 59, struct getfsmap)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 0f96847..39a4231 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -43,6 +43,7 @@
 #include "xfs_log.h"
 #include "xfs_filestream.h"
 #include "xfs_rmap.h"
+#include "xfs_bit.h"
 
 /*
  * File system operations
@@ -947,3 +948,530 @@ xfs_do_force_shutdown(
 	"Please umount the filesystem and rectify the problem(s)");
 	}
 }
+
+/* getfsmap query state */
+struct xfs_getfsmap_info {
+	struct getfsmap		*fmv;		/* vector header */
+	xfs_fsmap_format_t	formatter;	/* formatting fn */
+	void			*format_arg;	/* format buffer */
+	bool			last;		/* last extent? */
+	xfs_daddr_t		next_daddr;	/* next daddr we expect */
+	u32			dev;		/* device id */
+
+	xfs_agnumber_t		agno;		/* AG number, if applicable */
+	struct xfs_buf		*agbp;		/* AGF, for refcount queries */
+	struct xfs_rmap_irec	low;		/* low rmap key */
+	struct xfs_rmap_irec	high;		/* high rmap key */
+};
+
+/* Associate a device with a getfsmap handler. */
+struct xfs_getfsmap_dev {
+	u32			dev;
+	int			(*fn)(struct xfs_mount *mp,
+				      struct getfsmap *keys,
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
+	struct getfsmap			fmv;
+	xfs_daddr_t			key_end;
+	int				error;
+
+	/*
+	 * Filter out records that start before our startpoint, if the
+	 * caller requested that.
+	 */
+	if (info->fmv->fmv_length &&
+	    xfs_getfsmap_rec_before_low_key(info, rec)) {
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
+	key_end = info->fmv->fmv_block + info->fmv->fmv_length;
+	if (info->next_daddr < key_end && rec_daddr >= key_end)
+		info->next_daddr = key_end;
+
+	/* Are we just counting mappings? */
+	if (info->fmv->fmv_count == 2) {
+		if (rec_daddr > info->next_daddr)
+			info->fmv->fmv_entries++;
+
+		if (info->last)
+			return XFS_BTREE_QUERY_RANGE_CONTINUE;
+
+		info->fmv->fmv_entries++;
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
+		if (info->fmv->fmv_entries >= info->fmv->fmv_count - 2)
+			return XFS_BTREE_QUERY_RANGE_ABORT;
+
+		trace_xfs_fsmap_mapping(mp, info->agno,
+				XFS_DADDR_TO_FSB(mp, info->next_daddr),
+				XFS_DADDR_TO_FSB(mp, rec_daddr -
+						info->next_daddr),
+				FMV_OWN_FREE, 0);
+
+		fmv.fmv_device = info->dev;
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
+	trace_xfs_fsmap_mapping(mp, info->agno,
+			rec->rm_startblock, rec->rm_blockcount, rec->rm_owner,
+			rec->rm_offset);
+
+	fmv.fmv_device = info->dev;
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
+	error = info->formatter(&fmv, info->format_arg);
+	if (error)
+		return error;
+	info->fmv->fmv_entries++;
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
+	fsb = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
+			rec->rm_startblock);
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
+	struct getfsmap		*fmv)
+{
+	irec->rm_flags = 0;
+	if (fmv->fmv_oflags & FMV_OF_ATTR_FORK)
+		irec->rm_flags |= XFS_RMAP_ATTR_FORK;
+	if (fmv->fmv_oflags & FMV_OF_EXTENT_MAP)
+		irec->rm_flags |= XFS_RMAP_BMBT_BLOCK;
+	if (fmv->fmv_oflags & FMV_OF_PREALLOC)
+		irec->rm_flags |= XFS_RMAP_UNWRITTEN;
+}
+
+/* Execute a getfsmap query against the log device. */
+STATIC int
+xfs_getfsmap_logdev(
+	struct xfs_mount		*mp,
+	struct getfsmap			*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_btree_cur		cur;
+	struct getfsmap			*lowkey = keys;
+	struct xfs_rmap_irec		rmap;
+
+	/* Set up search keys */
+	info->low.rm_startblock = XFS_BB_TO_FSBT(mp, lowkey->fmv_block);
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, lowkey->fmv_offset);
+	info->low.rm_owner = lowkey->fmv_owner;
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, lowkey);
+
+	info->high.rm_startblock = -1U;
+	info->high.rm_owner = ULLONG_MAX;
+	info->high.rm_offset = ULLONG_MAX;
+	info->high.rm_blockcount = 0;
+	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
+
+	trace_xfs_fsmap_low_key(mp, info->agno,
+			info->low.rm_startblock,
+			info->low.rm_blockcount,
+			info->low.rm_owner,
+			info->low.rm_offset);
+
+	trace_xfs_fsmap_high_key(mp, info->agno,
+			info->high.rm_startblock,
+			info->high.rm_blockcount,
+			info->high.rm_owner,
+			info->high.rm_offset);
+
+
+	if (lowkey->fmv_block > 0)
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
+	struct xfs_mount		*mp,
+	struct getfsmap			*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_btree_cur		*bt_cur = NULL;
+	struct getfsmap			*lowkey;
+	struct getfsmap			*highkey;
+	xfs_fsblock_t			start_fsb;
+	xfs_fsblock_t			end_fsb;
+	xfs_agnumber_t			start_ag;
+	xfs_agnumber_t			end_ag;
+	xfs_daddr_t			eofs;
+	int				error = 0;
+
+	lowkey = keys;
+	highkey = keys + 1;
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (lowkey->fmv_block >= eofs)
+		return 0;
+	if (highkey->fmv_block >= eofs)
+		highkey->fmv_block = eofs - 1;
+	start_fsb = XFS_DADDR_TO_FSB(mp, lowkey->fmv_block);
+	end_fsb = XFS_DADDR_TO_FSB(mp, highkey->fmv_block);
+
+	/* Set up search keys */
+	info->low.rm_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, lowkey->fmv_offset);
+	info->low.rm_owner = lowkey->fmv_owner;
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, lowkey);
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
+		if (info->agno == end_ag) {
+			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
+					end_fsb);
+			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
+					highkey->fmv_offset);
+			info->high.rm_owner = highkey->fmv_owner;
+			xfs_getfsmap_set_irec_flags(&info->high, highkey);
+		}
+
+		if (bt_cur) {
+			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+			xfs_trans_brelse(NULL, info->agbp);
+			bt_cur = NULL;
+			info->agbp = NULL;
+		}
+
+		error = xfs_alloc_read_agf(mp, NULL, info->agno, 0,
+				&info->agbp);
+		if (error)
+			goto err;
+
+		trace_xfs_fsmap_low_key(mp, info->agno,
+				info->low.rm_startblock,
+				info->low.rm_blockcount,
+				info->low.rm_owner,
+				info->low.rm_offset);
+
+		trace_xfs_fsmap_high_key(mp, info->agno,
+				info->high.rm_startblock,
+				info->high.rm_blockcount,
+				info->high.rm_owner,
+				info->high.rm_offset);
+
+		bt_cur = xfs_rmapbt_init_cursor(mp, NULL, info->agbp,
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
+	if (info->agbp) {
+		xfs_trans_brelse(NULL, info->agbp);
+		info->agbp = NULL;
+	}
+
+	return error;
+}
+
+/* Do we recognize the device? */
+STATIC bool
+xfs_getfsmap_is_valid_device(
+	struct xfs_mount	*mp,
+	struct getfsmap		*fmv)
+{
+	if (fmv->fmv_device == 0 || fmv->fmv_device == UINT_MAX ||
+	    fmv->fmv_device == new_encode_dev(mp->m_ddev_targp->bt_dev))
+		return true;
+	if (mp->m_logdev_targp &&
+	    fmv->fmv_device == new_encode_dev(mp->m_logdev_targp->bt_dev))
+		return true;
+	return false;
+}
+
+#define XFS_GETFSMAP_DEVS	3
+/*
+ * Get filesystem's extents as described in fmv, and format for
+ * output.  Calls formatter to fill the user's buffer until all
+ * extents are mapped, until the passed-in fmv->fmv_count slots have
+ * been filled, or until the formatter short-circuits the loop, if it
+ * is tracking filled-in extents on its own.
+ */
+int
+xfs_getfsmap(
+	struct xfs_mount		*mp,
+	struct getfsmap			*fmv_low,
+	xfs_fsmap_format_t		formatter,
+	void				*arg)
+{
+	struct getfsmap			*fmv_high;
+	struct getfsmap			keys[2];
+	struct xfs_getfsmap_dev		handlers[XFS_GETFSMAP_DEVS];
+	struct xfs_getfsmap_info	info;
+	int				i;
+	int				error = 0;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+	if (fmv_low->fmv_count < 2)
+		return -EINVAL;
+	if (fmv_low->fmv_iflags & (~FMV_HIF_VALID))
+		return -EINVAL;
+	fmv_high = fmv_low + 1;
+	if (!xfs_getfsmap_is_valid_device(mp, fmv_low) ||
+	    !xfs_getfsmap_is_valid_device(mp, fmv_high) ||
+	    fmv_high->fmv_iflags || fmv_high->fmv_count ||
+	    fmv_high->fmv_length || fmv_high->fmv_entries ||
+	    fmv_high->fmv_unused1 || fmv_low->fmv_unused1 ||
+	    fmv_high->fmv_unused2 || fmv_low->fmv_unused2)
+		return -EINVAL;
+
+	fmv_low->fmv_entries = 0;
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
+	 * Since we allow the user to copy the last fmv item from a previous
+	 * call into the low key slot, we have to advance the low key by
+	 * whatever the reported length is.  If the offset field doesn't apply,
+	 * move up the start block to the next extent and start over with the
+	 * lowest owner/offset possible; otherwise it's file data, so move up
+	 * the offset only.
+	 */
+	keys[0] = *fmv_low;
+	if (keys[0].fmv_oflags & (FMV_OF_SPECIAL_OWNER | FMV_OF_EXTENT_MAP)) {
+		keys[0].fmv_block += fmv_low->fmv_length;
+		keys[0].fmv_owner = 0;
+		keys[0].fmv_offset = 0;
+	} else
+		keys[0].fmv_offset += fmv_low->fmv_length;
+	memset(keys + 1, 0xFF, sizeof(struct getfsmap));
+
+	info.fmv = fmv_low;
+	info.formatter = formatter;
+	info.format_arg = arg;
+
+	/* For each device we support... */
+	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
+		/* Is this device within the range the user asked for? */
+		if (!handlers[i].fn)
+			continue;
+		if (fmv_low->fmv_device > handlers[i].dev)
+			continue;
+		if (fmv_high->fmv_device < handlers[i].dev)
+			break;
+
+		/*
+		 * If this device number matches the high key, we have
+		 * to pass the high key to the handler to limit the
+		 * query results.  If the device number exceeds the
+		 * low key, zero out the low key so that we get
+		 * everything from the beginning.
+		 */
+		if (handlers[i].dev == fmv_high->fmv_device)
+			keys[1] = *fmv_high;
+		if (handlers[i].dev > fmv_low->fmv_device)
+			memset(keys, 0, sizeof(struct getfsmap));
+
+		info.next_daddr = keys[0].fmv_block;
+		info.dev = handlers[i].dev;
+		info.last = false;
+		info.agno = NULLAGNUMBER;
+		error = handlers[i].fn(mp, keys, &info);
+		if (error)
+			break;
+
+	}
+
+	fmv_low->fmv_oflags = FMV_HOF_DEV_T;
+	return error;
+}
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index f32713f..53ab2d7 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -26,4 +26,10 @@ extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
 
+/* fsmap to userspace formatter - copy to user & advance pointer */
+typedef int (*xfs_fsmap_format_t)(struct getfsmap *, void *);
+
+int	xfs_getfsmap(struct xfs_mount *mp, struct getfsmap *fmv,
+		xfs_fsmap_format_t formatter, void *arg);
+
 #endif	/* __XFS_FSOPS_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9a7c878..ecdd77b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -41,6 +41,7 @@
 #include "xfs_trans.h"
 #include "xfs_pnfs.h"
 #include "xfs_acl.h"
+#include "xfs_btree.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -1532,6 +1533,76 @@ xfs_ioc_getbmapx(
 	return 0;
 }
 
+struct getfsmap_info {
+	struct xfs_mount	*mp;
+	struct getfsmap __user	*data;
+	__s64			last_flags;
+};
+
+STATIC int
+xfs_getfsmap_format(struct getfsmap *fmv, void *priv)
+{
+	struct getfsmap_info	*info = priv;
+
+	trace_xfs_getfsmap_mapping(info->mp, fmv->fmv_block,
+			fmv->fmv_length, fmv->fmv_owner,
+			fmv->fmv_offset, fmv->fmv_oflags);
+
+	info->last_flags = fmv->fmv_oflags;
+	if (copy_to_user(info->data, fmv, sizeof(struct getfsmap)))
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
+	struct getfsmap		fmx[2];
+	bool			aborted = false;
+	int			error;
+
+	if (copy_from_user(&fmx, arg, 2 * sizeof(struct getfsmap)))
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
+	info.data = (__force struct getfsmap *)arg + 2;
+	error = xfs_getfsmap(ip->i_mount, fmx, xfs_getfsmap_format, &info);
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
+	if (copy_to_user(arg, fmx, 2 * sizeof(struct getfsmap)))
+		return -EFAULT;
+
+	return 0;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1712,6 +1783,11 @@ xfs_file_ioctl(
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
index 321f577..9491bc8 100644
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
index 551b7e2..8a42609 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2559,6 +2559,82 @@ DEFINE_RMAPBT_EVENT(xfs_rmap_lookup_le_range_result);
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_right_neighbor_result);
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_result);
 
+/* fsmap traces */
+DECLARE_EVENT_CLASS(xfs_fsmap_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_fsblock_t bno,
+		 xfs_filblks_t len, __uint64_t owner, __uint64_t offset),
+	TP_ARGS(mp, agno, bno, len, owner, offset),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_fsblock_t, bno)
+		__field(xfs_filblks_t, len)
+		__field(__uint64_t, owner)
+		__field(__uint64_t, offset)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->bno = bno;
+		__entry->len = len;
+		__entry->owner = owner;
+		__entry->offset = offset;
+	),
+	TP_printk("dev %d:%d agno %u bno %llu len %llu owner %lld offset 0x%llx\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset)
+)
+#define DEFINE_FSMAP_EVENT(name) \
+DEFINE_EVENT(xfs_fsmap_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_fsblock_t bno, xfs_filblks_t len, __uint64_t owner, \
+		 __uint64_t offset), \
+	TP_ARGS(mp, agno, bno, len, owner, offset))
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
