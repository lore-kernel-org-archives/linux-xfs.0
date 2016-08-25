Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 648887EF7
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:41:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C2BC8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:00 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 0quEYXsdhmvF7kX6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:40:56 -0700 (PDT)
Subject: [PATCH 06/25] xfs: generic functions to scrub metadata and btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:40:50 -0700
Message-ID: <147216845062.3108.1751981381146729642.stgit@birch.djwong.org>
In-Reply-To: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
References: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Create a function that walks a btree, checking the integrity of each
btree block (headers, keys, records) and calling back to the caller
to perform further checks on the records.  Add some helper functions
so that we report detailed scrub errors in a uniform manner in dmesg.
These are helper functions for subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/libxfs/xfs_btree.c  |   41 ++-
 fs/xfs/libxfs/xfs_btree.h  |   17 +
 fs/xfs/libxfs/xfs_format.h |    2 
 fs/xfs/xfs_scrub.c         |  705 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_scrub.h         |   25 ++
 6 files changed, 782 insertions(+), 9 deletions(-)
 create mode 100644 fs/xfs/xfs_scrub.c
 create mode 100644 fs/xfs/xfs_scrub.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5c90f82..a903bd3 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -92,6 +92,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
 				   xfs_reflink.o \
+				   xfs_scrub.o \
 				   xfs_stats.o \
 				   xfs_super.o \
 				   xfs_symlink.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2552c03..a926c54 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -552,7 +552,7 @@ xfs_btree_ptr_offset(
 /*
  * Return a pointer to the n-th record in the btree block.
  */
-STATIC union xfs_btree_rec *
+union xfs_btree_rec *
 xfs_btree_rec_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -565,7 +565,7 @@ xfs_btree_rec_addr(
 /*
  * Return a pointer to the n-th key in the btree block.
  */
-STATIC union xfs_btree_key *
+union xfs_btree_key *
 xfs_btree_key_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -578,7 +578,7 @@ xfs_btree_key_addr(
 /*
  * Return a pointer to the n-th high key in the btree block.
  */
-STATIC union xfs_btree_key *
+union xfs_btree_key *
 xfs_btree_high_key_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -591,7 +591,7 @@ xfs_btree_high_key_addr(
 /*
  * Return a pointer to the n-th block pointer in the btree block.
  */
-STATIC union xfs_btree_ptr *
+union xfs_btree_ptr *
 xfs_btree_ptr_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -625,7 +625,7 @@ xfs_btree_get_iroot(
  * Retrieve the block pointer from the cursor at the given level.
  * This may be an inode btree root or from a buffer.
  */
-STATIC struct xfs_btree_block *		/* generic btree block pointer */
+struct xfs_btree_block *		/* generic btree block pointer */
 xfs_btree_get_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level in btree */
@@ -1736,7 +1736,7 @@ error0:
 	return error;
 }
 
-STATIC int
+int
 xfs_btree_lookup_get_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level in the btree */
@@ -4852,3 +4852,32 @@ xfs_btree_count_blocks(
 	return xfs_btree_visit_blocks(cur, xfs_btree_count_blocks_helper,
 			blocks);
 }
+
+/* If there's an extent, we're done. */
+STATIC int
+xfs_btree_has_record_helper(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	return XFS_BTREE_QUERY_RANGE_ABORT;
+}
+
+/* Is there a record covering a given range of keys? */
+int
+xfs_btree_has_record(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_irec	*low,
+	union xfs_btree_irec	*high,
+	bool			*exists)
+{
+	int			error;
+
+	error = xfs_btree_query_range(cur, low, high,
+			&xfs_btree_has_record_helper, NULL);
+	if (error && error != XFS_BTREE_QUERY_RANGE_ABORT)
+		return error;
+	*exists = error == XFS_BTREE_QUERY_RANGE_ABORT;
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index eb20376..f81b2a8 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -197,7 +197,6 @@ struct xfs_btree_ops {
 
 	const struct xfs_buf_ops	*buf_ops;
 
-#if defined(DEBUG) || defined(XFS_WARN)
 	/* check that k1 is lower than k2 */
 	int	(*keys_inorder)(struct xfs_btree_cur *cur,
 				union xfs_btree_key *k1,
@@ -207,7 +206,6 @@ struct xfs_btree_ops {
 	int	(*recs_inorder)(struct xfs_btree_cur *cur,
 				union xfs_btree_rec *r1,
 				union xfs_btree_rec *r2);
-#endif
 };
 
 /*
@@ -537,4 +535,19 @@ int xfs_btree_visit_blocks(struct xfs_btree_cur *cur,
 
 int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_extlen_t *blocks);
 
+union xfs_btree_rec *xfs_btree_rec_addr(struct xfs_btree_cur *cur, int n,
+		struct xfs_btree_block *block);
+union xfs_btree_key *xfs_btree_key_addr(struct xfs_btree_cur *cur, int n,
+		struct xfs_btree_block *block);
+union xfs_btree_key *xfs_btree_high_key_addr(struct xfs_btree_cur *cur, int n,
+		struct xfs_btree_block *block);
+union xfs_btree_ptr *xfs_btree_ptr_addr(struct xfs_btree_cur *cur, int n,
+		struct xfs_btree_block *block);
+int xfs_btree_lookup_get_block(struct xfs_btree_cur *cur, int level,
+		union xfs_btree_ptr *pp, struct xfs_btree_block **blkp);
+struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *cur,
+		int level, struct xfs_buf **bpp);
+int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
+		union xfs_btree_irec *high, bool *exists);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index bf40fa8..a3aa5e9 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -518,7 +518,7 @@ static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
 		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
 }
 
-static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
new file mode 100644
index 0000000..13bea55
--- /dev/null
+++ b/fs/xfs/xfs_scrub.c
@@ -0,0 +1,705 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
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
+#include "xfs_scrub.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_rtalloc.h"
+
+/* Report a scrub corruption in dmesg. */
+STATIC void
+xfs_scrub_error(
+	struct xfs_mount		*mp,
+	struct xfs_buf			*bp,
+	const char			*type,
+	const char			*func,
+	int				line,
+	const char			*check)
+{
+	xfs_fsblock_t			fsbno;
+
+	fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
+	xfs_alert(mp, "scrub: %s corruption in block %u/%u: %s, func: %s, line: %d",
+			type,
+			XFS_FSB_TO_AGNO(mp, fsbno),
+			XFS_FSB_TO_AGBNO(mp, fsbno),
+			check, func, line);
+}
+
+#define XFS_SCRUB_CHECK(mp, bp, type, fs_ok) \
+	if (!(fs_ok)) { \
+		xfs_scrub_error((mp), (bp), (type), __func__, __LINE__, #fs_ok); \
+		error = -EFSCORRUPTED; \
+	}
+#define XFS_SCRUB_GOTO(mp, bp, type, fs_ok, label) \
+	if (!(fs_ok)) { \
+		xfs_scrub_error((mp), (bp), (type), __func__, __LINE__, #fs_ok); \
+		error = -EFSCORRUPTED; \
+		goto label; \
+	}
+
+/* Report a scrub corruption in dmesg. */
+STATIC void
+xfs_scrub_ino_error(
+	struct xfs_inode		*ip,
+	struct xfs_buf			*bp,
+	const char			*type,
+	const char			*func,
+	int				line,
+	const char			*check)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	xfs_fsblock_t			fsbno;
+
+	if (!bp) {
+		xfs_alert(mp, "scrub: inode %llu %s corruption: %s, "
+				"func: %s, line: %d",
+				ip->i_ino,
+				type,
+				check, func, line);
+		return;
+	}
+
+	fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
+	xfs_alert(mp, "scrub: inode %llu %s corruption in block %u/%u: %s, "
+			"func: %s, line: %d",
+			ip->i_ino,
+			type,
+			XFS_FSB_TO_AGNO(mp, fsbno),
+			XFS_FSB_TO_AGBNO(mp, fsbno),
+			check, func, line);
+}
+
+#define XFS_INO_SCRUB_CHECK(ip, bp, type, fs_ok) \
+	if (!(fs_ok)) { \
+		xfs_scrub_ino_error((ip), (bp), (type), __func__, __LINE__, #fs_ok); \
+		error = -EFSCORRUPTED; \
+	}
+#define XFS_INO_SCRUB_GOTO(ip, bp, type, fs_ok, label) \
+	if (!(fs_ok)) { \
+		xfs_scrub_ino_error((ip), (bp), (type), __func__, __LINE__, #fs_ok); \
+		error = -EFSCORRUPTED; \
+		goto label; \
+	}
+
+/* btree scrubbing */
+
+static const char * const btree_types[] = {
+	[XFS_BTNUM_BNO]		= "bnobt",
+	[XFS_BTNUM_CNT]		= "cntbt",
+	[XFS_BTNUM_RMAP]	= "rmapbt",
+	[XFS_BTNUM_BMAP]	= "bmapbt",
+	[XFS_BTNUM_INO]		= "inobt",
+	[XFS_BTNUM_FINO]	= "finobt",
+	[XFS_BTNUM_REFC]	= "refcountbt",
+};
+
+struct xfs_scrub_btree;
+typedef int (*xfs_scrub_btree_rec_fn)(
+	struct xfs_scrub_btree	*bs,
+	union xfs_btree_rec	*rec);
+
+struct xfs_scrub_btree {
+	/* caller-provided scrub state */
+	struct xfs_btree_cur		*cur;
+	xfs_scrub_btree_rec_fn		scrub_rec;
+	struct xfs_buf			*agi_bp;
+	struct xfs_buf			*agf_bp;
+	struct xfs_buf			*agfl_bp;
+	struct xfs_owner_info		oinfo;
+
+	/* internal scrub state */
+	union xfs_btree_rec		lastrec;
+	bool				firstrec;
+	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
+	bool				firstkey[XFS_BTREE_MAXLEVELS];
+	struct xfs_btree_cur		*bno_cur;
+	struct xfs_btree_cur		*cnt_cur;
+	struct xfs_btree_cur		*ino_cur;
+	struct xfs_btree_cur		*fino_cur;
+	struct xfs_btree_cur		*rmap_cur;
+	struct xfs_btree_cur		*refc_cur;
+	struct list_head		to_check;
+	int				error;
+};
+
+/* Report a scrub corruption in dmesg. */
+STATIC void
+xfs_scrub_btree_error(
+	struct xfs_btree_cur		*cur,
+	int				level,
+	const char			*func,
+	int				line,
+	const char			*check)
+{
+	char				buf[24];
+	char				descr[48];
+	const char			*type;
+	struct xfs_buf			*bp;
+	struct xfs_btree_block		*block;
+	xfs_fsblock_t			fsbno;
+
+	switch (cur->bc_btnum) {
+	case XFS_BTNUM_BMAP:
+		switch (cur->bc_private.b.whichfork) {
+		case XFS_DATA_FORK:
+			type = "data";
+			break;
+		case XFS_ATTR_FORK:
+			type = "attr";
+			break;
+		case XFS_COW_FORK:
+			type = "CoW";
+			break;
+		}
+		snprintf(descr, 48, "inode %llu %s fork",
+				(unsigned long long)cur->bc_private.b.ip->i_ino,
+				type);
+		type = descr;
+		break;
+	default:
+		type = btree_types[cur->bc_btnum];
+		break;
+	}
+
+	if (level < cur->bc_nlevels && cur->bc_ptrs[level] >= 1) {
+		block = xfs_btree_get_block(cur, level, &bp);
+		snprintf(buf, 24, " %s %d/%d", level == 0 ? "rec" : "ptr",
+				cur->bc_ptrs[level],
+				be16_to_cpu(block->bb_numrecs));
+	} else
+		buf[0] = 0;
+
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+			level >= cur->bc_nlevels - 1) {
+		xfs_alert(cur->bc_mp, "scrub: %s btree corruption in inode "
+				"%llu root%s: %s, func: %s, line: %d",
+				type, cur->bc_private.b.ip->i_ino,
+				buf, check, func, line);
+	} else if (!cur->bc_bufs[level]) {
+		xfs_alert(cur->bc_mp, "scrub: %s btree corruption, "
+				"func: %s, line: %d",
+				type, func, line);
+	} else {
+		fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, cur->bc_bufs[level]->b_bn);
+		xfs_alert(cur->bc_mp, "scrub: %s btree corruption in block "
+				"%u/%u%s: %s, func: %s, line: %d",
+				type,
+				XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
+				XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
+				buf, check, func, line);
+	}
+}
+
+#define XFS_BTREC_SCRUB_CHECK(bs, fs_ok) \
+	if (!(fs_ok)) { \
+		xfs_scrub_btree_error((bs)->cur, 0, __func__, __LINE__, #fs_ok); \
+		(bs)->error = -EFSCORRUPTED; \
+	}
+#define XFS_BTREC_SCRUB_GOTO(bs, fs_ok, label) \
+	if (!(fs_ok)) { \
+		xfs_scrub_btree_error((bs)->cur, 0, __func__, __LINE__, #fs_ok); \
+		(bs)->error = -EFSCORRUPTED; \
+		goto label; \
+	}
+#define XFS_BTKEY_SCRUB_CHECK(bs, level, fs_ok) \
+	if (!(fs_ok)) { \
+		xfs_scrub_btree_error((bs)->cur, (level), __func__, __LINE__, #fs_ok); \
+		(bs)->error = -EFSCORRUPTED; \
+	}
+#define XFS_BTKEY_SCRUB_GOTO(bs, level, fs_ok, label) \
+	if (!(fs_ok)) { \
+		xfs_scrub_btree_error((bs)->cur, (level), __func__, __LINE__, #fs_ok); \
+		(bs)->error = -EFSCORRUPTED; \
+		goto label; \
+	}
+
+/*
+ * Make sure this record is in order and doesn't stray outside of the parent
+ * keys.
+ */
+STATIC int
+xfs_scrub_btree_rec(
+	struct xfs_scrub_btree	*bs)
+{
+	struct xfs_btree_cur	*cur = bs->cur;
+	union xfs_btree_rec	*rec;
+	union xfs_btree_key	key;
+	union xfs_btree_key	hkey;
+	union xfs_btree_key	*keyp;
+	struct xfs_btree_block	*block;
+	struct xfs_btree_block	*keyblock;
+	struct xfs_buf		*bp;
+
+	block = xfs_btree_get_block(cur, 0, &bp);
+	rec = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
+
+	if (bp)
+		trace_xfs_scrub_btree_rec(cur->bc_mp,
+				XFS_FSB_TO_AGNO(cur->bc_mp,
+					XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn)),
+				XFS_FSB_TO_AGBNO(cur->bc_mp,
+					XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn)),
+				cur->bc_btnum, 0, cur->bc_nlevels,
+				cur->bc_ptrs[0]);
+	else if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+		trace_xfs_scrub_btree_rec(cur->bc_mp,
+				XFS_INO_TO_AGNO(cur->bc_mp,
+					cur->bc_private.b.ip->i_ino),
+				XFS_INO_TO_AGBNO(cur->bc_mp,
+					cur->bc_private.b.ip->i_ino),
+				cur->bc_btnum, 0, cur->bc_nlevels,
+				cur->bc_ptrs[0]);
+	else
+		trace_xfs_scrub_btree_rec(cur->bc_mp,
+				NULLAGNUMBER, NULLAGBLOCK,
+				cur->bc_btnum, 0, cur->bc_nlevels,
+				cur->bc_ptrs[0]);
+
+	/* If this isn't the first record, are they in order? */
+	XFS_BTREC_SCRUB_CHECK(bs, bs->firstrec ||
+			cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec));
+	bs->firstrec = false;
+	bs->lastrec = *rec;
+
+	if (cur->bc_nlevels == 1)
+		return 0;
+
+	/* Is this at least as large as the parent low key? */
+	cur->bc_ops->init_key_from_rec(&key, rec);
+	keyblock = xfs_btree_get_block(cur, 1, &bp);
+	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[1], keyblock);
+	XFS_BTKEY_SCRUB_CHECK(bs, 0,
+			cur->bc_ops->diff_two_keys(cur, &key, keyp) >= 0);
+
+	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
+		return 0;
+
+	/* Is this no larger than the parent high key? */
+	cur->bc_ops->init_high_key_from_rec(&hkey, rec);
+	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[1], keyblock);
+	XFS_BTKEY_SCRUB_CHECK(bs, 0,
+			cur->bc_ops->diff_two_keys(cur, keyp, &hkey) >= 0);
+
+	return 0;
+}
+
+/*
+ * Make sure this key is in order and doesn't stray outside of the parent
+ * keys.
+ */
+STATIC int
+xfs_scrub_btree_key(
+	struct xfs_scrub_btree	*bs,
+	int			level)
+{
+	struct xfs_btree_cur	*cur = bs->cur;
+	union xfs_btree_key	*key;
+	union xfs_btree_key	*keyp;
+	struct xfs_btree_block	*block;
+	struct xfs_btree_block	*keyblock;
+	struct xfs_buf		*bp;
+
+	block = xfs_btree_get_block(cur, level, &bp);
+	key = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
+
+	if (bp)
+		trace_xfs_scrub_btree_key(cur->bc_mp,
+				XFS_FSB_TO_AGNO(cur->bc_mp,
+					XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn)),
+				XFS_FSB_TO_AGBNO(cur->bc_mp,
+					XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn)),
+				cur->bc_btnum, level, cur->bc_nlevels,
+				cur->bc_ptrs[level]);
+	else if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+		trace_xfs_scrub_btree_key(cur->bc_mp,
+				XFS_INO_TO_AGNO(cur->bc_mp,
+					cur->bc_private.b.ip->i_ino),
+				XFS_INO_TO_AGBNO(cur->bc_mp,
+					cur->bc_private.b.ip->i_ino),
+				cur->bc_btnum, level, cur->bc_nlevels,
+				cur->bc_ptrs[level]);
+	else
+		trace_xfs_scrub_btree_key(cur->bc_mp,
+				NULLAGNUMBER, NULLAGBLOCK,
+				cur->bc_btnum, level, cur->bc_nlevels,
+				cur->bc_ptrs[level]);
+
+	/* If this isn't the first key, are they in order? */
+	XFS_BTKEY_SCRUB_CHECK(bs, level, bs->firstkey[level] ||
+			cur->bc_ops->keys_inorder(cur, &bs->lastkey[level],
+					key));
+	bs->firstkey[level] = false;
+	bs->lastkey[level] = *key;
+
+	if (level + 1 >= cur->bc_nlevels)
+		return 0;
+
+	/* Is this at least as large as the parent low key? */
+	keyblock = xfs_btree_get_block(cur, level + 1, &bp);
+	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
+	XFS_BTKEY_SCRUB_CHECK(bs, level,
+			cur->bc_ops->diff_two_keys(cur, key, keyp) >= 0);
+
+	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
+		return 0;
+
+	/* Is this no larger than the parent high key? */
+	key = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
+	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
+	XFS_BTKEY_SCRUB_CHECK(bs, level,
+			cur->bc_ops->diff_two_keys(cur, keyp, key) >= 0);
+
+	return 0;
+}
+
+/*
+ * For scrub, grab the AGI and the AGF headers, in that order.
+ * Locking order requires us to get the AGI before the AGF.
+ */
+STATIC int
+xfs_scrub_get_ag_headers(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	struct xfs_buf			**agi_bpp,
+	struct xfs_buf			**agf_bpp)
+{
+	int				error;
+
+	error = xfs_read_agi(mp, NULL, agno, agi_bpp);
+	if (error)
+		return error;
+
+	error = xfs_read_agf(mp, NULL, agno, 0, agf_bpp);
+	if (error) {
+		xfs_buf_relse(*agi_bpp);
+		*agi_bpp = NULL;
+	}
+
+	return error;
+}
+
+/*
+ * Release the AGF/AGI buffers.
+ */
+STATIC void
+xfs_scrub_put_ag_headers(
+	struct xfs_buf			**agi_bpp,
+	struct xfs_buf			**agf_bpp)
+{
+	if (*agf_bpp)
+		xfs_buf_relse(*agf_bpp);
+	if (*agi_bpp)
+		xfs_buf_relse(*agi_bpp);
+	*agi_bpp = *agf_bpp = NULL;
+}
+
+/*
+ * For scrub, grab the AGI and the AGF headers, in that order.
+ * Locking order requires us to get the AGI before the AGF.
+ */
+STATIC int
+xfs_scrub_btree_get_ag_headers(
+	struct xfs_mount		*mp,
+	struct xfs_scrub_btree		*bs,
+	xfs_agnumber_t			agno)
+{
+	return xfs_scrub_get_ag_headers(mp, agno, &bs->agi_bp, &bs->agf_bp);
+}
+
+/*
+ * Release the AGF/AGI buffers.
+ */
+STATIC void
+xfs_scrub_btree_put_ag_headers(
+	struct xfs_scrub_btree		*bs)
+{
+	xfs_scrub_put_ag_headers(&bs->agi_bp, &bs->agf_bp);
+}
+
+/* Check a btree pointer. */
+static int
+xfs_scrub_btree_ptr(
+	struct xfs_scrub_btree		*bs,
+	int				level,
+	union xfs_btree_ptr		*ptr)
+{
+	struct xfs_btree_cur		*cur = bs->cur;
+	xfs_daddr_t			daddr;
+	xfs_daddr_t			eofs;
+	int				error = 0;
+
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+			level == cur->bc_nlevels) {
+		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+			XFS_BTKEY_SCRUB_GOTO(bs, level, ptr->l == 0, out);
+		} else {
+			XFS_BTKEY_SCRUB_GOTO(bs, level, ptr->s == 0, out);
+		}
+		goto out;
+	}
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		XFS_BTKEY_SCRUB_GOTO(bs, level,
+				ptr->l != cpu_to_be64(NULLFSBLOCK), out);
+
+		daddr = XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
+	} else {
+		XFS_BTKEY_SCRUB_GOTO(bs, level,
+				cur->bc_private.a.agno != NULLAGNUMBER, out);
+		XFS_BTKEY_SCRUB_GOTO(bs, level,
+				ptr->s != cpu_to_be32(NULLAGBLOCK), out);
+
+		daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
+				be32_to_cpu(ptr->s));
+	}
+	eofs = XFS_FSB_TO_BB(cur->bc_mp, cur->bc_mp->m_sb.sb_dblocks);
+	XFS_BTKEY_SCRUB_GOTO(bs, level, daddr != 0, out);
+	XFS_BTKEY_SCRUB_GOTO(bs, level, daddr < eofs, out);
+
+out:
+	return error;
+}
+
+/* Should we end the scrub early? */
+static bool
+xfs_scrub_should_terminate(
+	int		*error)
+{
+	if (fatal_signal_pending(current)) {
+		if (*error == 0)
+			*error = -EAGAIN;
+		return true;
+	}
+	return false;
+}
+
+/*
+ * Visit all nodes and leaves of a btree.  Check that all pointers and
+ * records are in order, that the keys reflect the records, and use a callback
+ * so that the caller can verify individual records.  The callback is the same
+ * as the one for xfs_btree_query_range, so therefore this function also
+ * returns XFS_BTREE_QUERY_RANGE_ABORT, zero, or a negative error code.
+ */
+STATIC int
+xfs_scrub_btree(
+	struct xfs_scrub_btree		*bs)
+{
+	struct xfs_btree_cur		*cur = bs->cur;
+	union xfs_btree_ptr		ptr;
+	union xfs_btree_ptr		*pp;
+	union xfs_btree_rec		*recp;
+	struct xfs_btree_block		*block;
+	int				level;
+	struct xfs_buf			*bp;
+	int				i;
+	int				error = 0;
+
+	/* No such thing as a zero-level tree. */
+	XFS_BTREC_SCRUB_GOTO(bs, cur->bc_nlevels > 0, out_badcursor);
+
+	/* Make sure the root isn't in the superblock. */
+	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+	error = xfs_scrub_btree_ptr(bs, cur->bc_nlevels, &ptr);
+	if (error)
+		goto out_badcursor;
+
+	/* Finish filling out the scrub state */
+	bs->error = 0;
+	bs->firstrec = true;
+	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++)
+		bs->firstkey[i] = true;
+	bs->bno_cur = bs->cnt_cur = bs->ino_cur = bs->fino_cur = NULL;
+	bs->rmap_cur = bs->refc_cur = NULL;
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		bs->agi_bp = NULL;
+		bs->agf_bp = NULL;
+	}
+	INIT_LIST_HEAD(&bs->to_check);
+
+	/* Grab cursors to the other AGs for cross-referencing. */
+	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS)) {
+		/* Set up a bnobt cursor for cross-referencing. */
+		if (bs->cur->bc_btnum != XFS_BTNUM_BNO)
+			bs->bno_cur = xfs_allocbt_init_cursor(cur->bc_mp, NULL,
+					bs->agf_bp, bs->cur->bc_private.a.agno,
+					XFS_BTNUM_BNO);
+		/* Set up a cntbt cursor for cross-referencing. */
+		if (bs->cur->bc_btnum != XFS_BTNUM_CNT)
+			bs->cnt_cur = xfs_allocbt_init_cursor(cur->bc_mp, NULL,
+					bs->agf_bp, bs->cur->bc_private.a.agno,
+					XFS_BTNUM_CNT);
+		/* Set up a inobt cursor for cross-referencing. */
+		if (bs->cur->bc_btnum != XFS_BTNUM_INO)
+			bs->ino_cur = xfs_inobt_init_cursor(cur->bc_mp, NULL,
+					bs->agi_bp, bs->cur->bc_private.a.agno,
+					XFS_BTNUM_INO);
+		/* Set up a finobt cursor for cross-referencing. */
+		if (bs->cur->bc_btnum != XFS_BTNUM_FINO &&
+		    xfs_sb_version_hasfinobt(&cur->bc_mp->m_sb))
+			bs->fino_cur = xfs_inobt_init_cursor(cur->bc_mp, NULL,
+					bs->agi_bp, bs->cur->bc_private.a.agno,
+					XFS_BTNUM_FINO);
+		/* Set up a rmapbt cursor for cross-referencing. */
+		if (bs->cur->bc_btnum != XFS_BTNUM_RMAP &&
+		    xfs_sb_version_hasrmapbt(&cur->bc_mp->m_sb))
+			bs->rmap_cur = xfs_rmapbt_init_cursor(cur->bc_mp, NULL,
+					bs->agf_bp, bs->cur->bc_private.a.agno);
+		/* Set up a refcountbt cursor for cross-referencing. */
+		if (bs->cur->bc_btnum != XFS_BTNUM_REFC &&
+		    xfs_sb_version_hasreflink(&cur->bc_mp->m_sb))
+			bs->refc_cur = xfs_refcountbt_init_cursor(cur->bc_mp,
+					NULL, bs->agf_bp,
+					bs->cur->bc_private.a.agno, NULL);
+	}
+
+	/* Load the root of the btree. */
+	level = cur->bc_nlevels - 1;
+	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+	error = xfs_btree_lookup_get_block(cur, level, &ptr, &block);
+	if (error)
+		goto out;
+
+	xfs_btree_get_block(cur, level, &bp);
+	error = xfs_btree_check_block(cur, block, level, bp);
+	if (error)
+		goto out;
+
+	cur->bc_ptrs[level] = 1;
+
+	while (level < cur->bc_nlevels) {
+		block = xfs_btree_get_block(cur, level, &bp);
+
+		if (level == 0) {
+			/* End of leaf, pop back towards the root. */
+			if (cur->bc_ptrs[level] >
+			    be16_to_cpu(block->bb_numrecs)) {
+				if (level < cur->bc_nlevels - 1)
+					cur->bc_ptrs[level + 1]++;
+				level++;
+				continue;
+			}
+
+			/* Records in order for scrub? */
+			error = xfs_scrub_btree_rec(bs);
+			if (error)
+				goto out;
+			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
+			error = bs->scrub_rec(bs, recp);
+			if (error < 0 ||
+			    error == XFS_BTREE_QUERY_RANGE_ABORT)
+				break;
+			if (xfs_scrub_should_terminate(&error))
+				break;
+
+			cur->bc_ptrs[level]++;
+			continue;
+		}
+
+		/* End of node, pop back towards the root. */
+		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
+			if (level < cur->bc_nlevels - 1)
+				cur->bc_ptrs[level + 1]++;
+			level++;
+			continue;
+		}
+
+		/* Keys in order for scrub? */
+		error = xfs_scrub_btree_key(bs, level);
+		if (error)
+			goto out;
+
+		/* Drill another level deeper. */
+		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
+		error = xfs_scrub_btree_ptr(bs, level, pp);
+		if (error)
+			goto out;
+		level--;
+		error = xfs_btree_lookup_get_block(cur, level, pp, &block);
+		if (error)
+			goto out;
+
+		xfs_btree_get_block(cur, level, &bp);
+		error = xfs_btree_check_block(cur, block, level, bp);
+		if (error)
+			goto out;
+
+		cur->bc_ptrs[level] = 1;
+	}
+
+out:
+	/*
+	 * If we don't end this function with the cursor pointing at a record
+	 * block, a subsequent non-error cursor deletion will not release
+	 * node-level buffers, causing a buffer leak.  This is quite possible
+	 * with a zero-results range query, so release the buffers if we
+	 * failed to return any results.
+	 */
+	if (cur->bc_bufs[0] == NULL) {
+		for (i = 0; i < cur->bc_nlevels; i++) {
+			if (cur->bc_bufs[i]) {
+				xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);
+				cur->bc_bufs[i] = NULL;
+				cur->bc_ptrs[i] = 0;
+				cur->bc_ra[i] = 0;
+			}
+		}
+	}
+
+	if (bs->refc_cur)
+		xfs_btree_del_cursor(bs->refc_cur, XFS_BTREE_ERROR);
+	if (bs->rmap_cur && bs->rmap_cur != bs->cur)
+		xfs_btree_del_cursor(bs->rmap_cur, XFS_BTREE_ERROR);
+	if (bs->fino_cur)
+		xfs_btree_del_cursor(bs->fino_cur, XFS_BTREE_ERROR);
+	if (bs->ino_cur)
+		xfs_btree_del_cursor(bs->ino_cur, XFS_BTREE_ERROR);
+	if (bs->cnt_cur)
+		xfs_btree_del_cursor(bs->cnt_cur, XFS_BTREE_ERROR);
+	if (bs->bno_cur && bs->bno_cur != bs->cur)
+		xfs_btree_del_cursor(bs->bno_cur, XFS_BTREE_ERROR);
+
+	if (!error && bs->error)
+		error = bs->error;
+
+out_badcursor:
+	return error;
+}
diff --git a/fs/xfs/xfs_scrub.h b/fs/xfs/xfs_scrub.h
new file mode 100644
index 0000000..474df7e
--- /dev/null
+++ b/fs/xfs/xfs_scrub.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
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
+#ifndef __XFS_SCRUB_H__
+#define __XFS_SCRUB_H__
+
+/* Functions to come later. */
+
+#endif	/* __XFS_SCRUB_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
