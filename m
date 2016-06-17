Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B7D377F8B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:30:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1FD35AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:13 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id wdxkCocmbP94H7W8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:09 -0700 (PDT)
Subject: [PATCH 113/119] xfs: scrub btree records and pointers while querying
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:30:03 -0700
Message-ID: <146612700354.12839.18272855403371334654.stgit@birch.djwong.org>
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

Create a function that walks a btree, checking the integrity of each
btree block (headers, keys, records) and calling back to the caller
to perform further checks on the records.

v2: Prefix function names with xfs_

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_alloc.c      |   33 +++
 fs/xfs/libxfs/xfs_alloc.h      |    3 
 fs/xfs/libxfs/xfs_btree.c      |   12 +
 fs/xfs/libxfs/xfs_btree.h      |   15 +-
 fs/xfs/libxfs/xfs_format.h     |    2 
 fs/xfs/libxfs/xfs_rmap.c       |   39 ++++
 fs/xfs/libxfs/xfs_rmap_btree.h |    3 
 fs/xfs/libxfs/xfs_scrub.c      |  396 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_scrub.h      |   76 ++++++++
 10 files changed, 571 insertions(+), 9 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_scrub.c
 create mode 100644 fs/xfs/libxfs/xfs_scrub.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 56c384b..8942390 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -58,6 +58,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_refcount.o \
 				   xfs_refcount_btree.o \
 				   xfs_sb.o \
+				   xfs_scrub.o \
 				   xfs_symlink_remote.o \
 				   xfs_trans_resv.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 188c359a..6fc1981 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2924,3 +2924,36 @@ err:
 	xfs_trans_brelse(tp, agbp);
 	return error;
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_alloc_record_exists(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			*is_freesp)
+{
+	int			stat;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			error;
+
+	error = xfs_alloc_lookup_le(cur, bno, len, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		*is_freesp = false;
+		return 0;
+	}
+
+	error = xfs_alloc_get_rec(cur, &fbno, &flen, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		*is_freesp = false;
+		return 0;
+	}
+
+	*is_freesp = (fbno <= bno && fbno + flen >= bno + len);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 9f6373a4..4f2ce38 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -210,4 +210,7 @@ int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
 
 xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
 
+int xfs_alloc_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, bool *is_freesp);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 9c84184..5260085 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -549,7 +549,7 @@ xfs_btree_ptr_offset(
 /*
  * Return a pointer to the n-th record in the btree block.
  */
-STATIC union xfs_btree_rec *
+union xfs_btree_rec *
 xfs_btree_rec_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -562,7 +562,7 @@ xfs_btree_rec_addr(
 /*
  * Return a pointer to the n-th key in the btree block.
  */
-STATIC union xfs_btree_key *
+union xfs_btree_key *
 xfs_btree_key_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -575,7 +575,7 @@ xfs_btree_key_addr(
 /*
  * Return a pointer to the n-th high key in the btree block.
  */
-STATIC union xfs_btree_key *
+union xfs_btree_key *
 xfs_btree_high_key_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -588,7 +588,7 @@ xfs_btree_high_key_addr(
 /*
  * Return a pointer to the n-th block pointer in the btree block.
  */
-STATIC union xfs_btree_ptr *
+union xfs_btree_ptr *
 xfs_btree_ptr_addr(
 	struct xfs_btree_cur	*cur,
 	int			n,
@@ -622,7 +622,7 @@ xfs_btree_get_iroot(
  * Retrieve the block pointer from the cursor at the given level.
  * This may be an inode btree root or from a buffer.
  */
-STATIC struct xfs_btree_block *		/* generic btree block pointer */
+struct xfs_btree_block *		/* generic btree block pointer */
 xfs_btree_get_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level in btree */
@@ -1733,7 +1733,7 @@ error0:
 	return error;
 }
 
-STATIC int
+int
 xfs_btree_lookup_get_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level in the btree */
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index dbf299f..6f22cb0 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -194,7 +194,6 @@ struct xfs_btree_ops {
 
 	const struct xfs_buf_ops	*buf_ops;
 
-#if defined(DEBUG) || defined(XFS_WARN)
 	/* check that k1 is lower than k2 */
 	int	(*keys_inorder)(struct xfs_btree_cur *cur,
 				union xfs_btree_key *k1,
@@ -204,7 +203,6 @@ struct xfs_btree_ops {
 	int	(*recs_inorder)(struct xfs_btree_cur *cur,
 				union xfs_btree_rec *r1,
 				union xfs_btree_rec *r2);
-#endif
 };
 
 /* btree ops flags */
@@ -537,4 +535,17 @@ int xfs_btree_visit_blocks(struct xfs_btree_cur *cur,
 
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
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 211a8b5..6ea8a84 100644
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
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 29d08fc..e7673ec 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2328,3 +2328,42 @@ xfs_rmap_free_defer(
 
 	return __xfs_rmap_add(mp, dfops, &ri);
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_rmap_record_exists(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	struct xfs_owner_info	*oinfo,
+	bool			*has_rmap)
+{
+	uint64_t		owner;
+	uint64_t		offset;
+	unsigned int		flags;
+	int			stat;
+	struct xfs_rmap_irec	irec;
+	int			error;
+
+	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
+
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		*has_rmap = false;
+		return 0;
+	}
+
+	error = xfs_rmap_get_rec(cur, &irec, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		*has_rmap = false;
+		return 0;
+	}
+
+	*has_rmap = (irec.rm_startblock <= bno &&
+		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 5baa81f..2f072c8 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -144,4 +144,7 @@ extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp);
 extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp,
 		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
 
+extern int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, struct xfs_owner_info *oinfo, bool *has_rmap);
+
 #endif	/* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_scrub.c b/fs/xfs/libxfs/xfs_scrub.c
new file mode 100644
index 0000000..d43d5c5
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_scrub.c
@@ -0,0 +1,396 @@
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
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_ialloc.h"
+#include "xfs_refcount.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_scrub.h"
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
+/* Report a scrub corruption in dmesg. */
+void
+xfs_btree_scrub_error(
+	struct xfs_btree_cur		*cur,
+	int				level,
+	const char			*file,
+	int				line,
+	const char			*check)
+{
+	char				buf[16];
+	xfs_fsblock_t			fsbno;
+
+	if (cur->bc_ptrs[level] >= 1)
+		snprintf(buf, 16, " ptr %d", cur->bc_ptrs[level]);
+	else
+		buf[0] = 0;
+
+	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, cur->bc_bufs[level]->b_bn);
+	xfs_alert(cur->bc_mp, "scrub: %s btree corruption in block %u/%u%s: %s, file: %s, line: %d",
+			btree_types[cur->bc_btnum],
+			XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
+			buf, check, file, line);
+}
+
+/* AG metadata scrubbing */
+
+/*
+ * Make sure this record is in order and doesn't stray outside of the parent
+ * keys.
+ */
+static int
+xfs_btree_scrub_rec(
+	struct xfs_btree_scrub	*bs)
+{
+	struct xfs_btree_cur	*cur = bs->cur;
+	union xfs_btree_rec	*rec;
+	union xfs_btree_key	key;
+	union xfs_btree_key	*keyp;
+	struct xfs_btree_block	*block;
+	struct xfs_btree_block	*keyblock;
+
+	block = XFS_BUF_TO_BLOCK(cur->bc_bufs[0]);
+	rec = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
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
+	keyblock = XFS_BUF_TO_BLOCK(cur->bc_bufs[1]);
+	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[1], keyblock);
+
+	XFS_BTKEY_SCRUB_CHECK(bs, 0,
+			cur->bc_ops->diff_two_keys(cur, keyp, &key) >= 0);
+
+	if (!(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING))
+		return 0;
+
+	/* Is this no larger than the parent high key? */
+	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[1], keyblock);
+
+	XFS_BTKEY_SCRUB_CHECK(bs, 0,
+			cur->bc_ops->diff_two_keys(cur, &key, keyp) >= 0);
+
+	return 0;
+}
+
+/*
+ * Make sure this key is in order and doesn't stray outside of the parent
+ * keys.
+ */
+static int
+xfs_btree_scrub_key(
+	struct xfs_btree_scrub	*bs,
+	int			level)
+{
+	struct xfs_btree_cur	*cur = bs->cur;
+	union xfs_btree_key	*key;
+	union xfs_btree_key	*keyp;
+	struct xfs_btree_block	*block;
+	struct xfs_btree_block	*keyblock;
+
+	block = XFS_BUF_TO_BLOCK(cur->bc_bufs[level]);
+	key = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
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
+	keyblock = XFS_BUF_TO_BLOCK(cur->bc_bufs[level + 1]);
+	keyp = xfs_btree_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
+
+	XFS_BTKEY_SCRUB_CHECK(bs, level,
+			cur->bc_ops->diff_two_keys(cur, keyp, key) >= 0);
+
+	if (!(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING))
+		return 0;
+
+	/* Is this no larger than the parent high key? */
+	key = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
+	keyp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level + 1], keyblock);
+
+	XFS_BTKEY_SCRUB_CHECK(bs, level,
+			cur->bc_ops->diff_two_keys(cur, key, keyp) >= 0);
+
+	return 0;
+}
+
+struct check_owner {
+	struct list_head	list;
+	xfs_agblock_t		bno;
+};
+
+/*
+ * Make sure this btree block isn't in the free list and that there's
+ * an rmap record for it.
+ */
+static int
+xfs_btree_block_check_owner(
+	struct xfs_btree_scrub		*bs,
+	xfs_agblock_t			bno)
+{
+	bool				has_rmap;
+	bool				is_freesp;
+	int				error;
+
+	/* Check that this block isn't free */
+	error = xfs_alloc_record_exists(bs->bno_cur, bno, 1, &is_freesp);
+	if (error)
+		goto err;
+	XFS_BTREC_SCRUB_CHECK(bs, !is_freesp);
+
+	if (!bs->rmap_cur)
+		return 0;
+
+	/* Check that there's an rmap record for this */
+	error = xfs_rmap_record_exists(bs->rmap_cur, bno, 1, &bs->oinfo,
+			&has_rmap);
+	if (error)
+		goto err;
+	XFS_BTREC_SCRUB_CHECK(bs, has_rmap);
+err:
+	return error;
+}
+
+/* Check the owner of a btree block. */
+static int
+xfs_btree_scrub_check_owner(
+	struct xfs_btree_scrub		*bs,
+	struct xfs_buf			*bp)
+{
+	struct xfs_btree_cur		*cur = bs->cur;
+	xfs_agblock_t			bno;
+	xfs_fsblock_t			fsbno;
+	struct check_owner		*co;
+
+	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+	bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
+
+	/* Do we need to defer this one? */
+	if ((!bs->rmap_cur && xfs_sb_version_hasrmapbt(&cur->bc_mp->m_sb)) ||
+	    !bs->bno_cur) {
+		co = kmem_alloc(sizeof(struct check_owner), KM_SLEEP | KM_NOFS);
+		co->bno = bno;
+		list_add_tail(&co->list, &bs->to_check);
+		return 0;
+	}
+
+	return xfs_btree_block_check_owner(bs, bno);
+}
+
+/*
+ * Visit all nodes and leaves of a btree.  Check that all pointers and
+ * records are in order, that the keys reflect the records, and use a callback
+ * so that the caller can verify individual records.  The callback is the same
+ * as the one for xfs_btree_query_range, so therefore this function also
+ * returns XFS_BTREE_QUERY_RANGE_ABORT, zero, or a negative error code.
+ */
+int
+xfs_btree_scrub(
+	struct xfs_btree_scrub		*bs)
+{
+	struct xfs_btree_cur		*cur = bs->cur;
+	union xfs_btree_ptr		ptr;
+	union xfs_btree_ptr		*pp;
+	union xfs_btree_rec		*recp;
+	struct xfs_btree_block		*block;
+	int				level;
+	struct xfs_buf			*bp;
+	int				i;
+	struct check_owner		*co, *n;
+	int				error;
+
+	/* Finish filling out the scrub state */
+	bs->error = 0;
+	bs->firstrec = true;
+	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++)
+		bs->firstkey[i] = true;
+	bs->bno_cur = bs->rmap_cur = NULL;
+	INIT_LIST_HEAD(&bs->to_check);
+	if (bs->cur->bc_btnum != XFS_BTNUM_BNO)
+		bs->bno_cur = xfs_allocbt_init_cursor(cur->bc_mp, NULL,
+				bs->agf_bp, bs->cur->bc_private.a.agno,
+				XFS_BTNUM_BNO);
+	if (bs->cur->bc_btnum != XFS_BTNUM_RMAP &&
+	    xfs_sb_version_hasrmapbt(&cur->bc_mp->m_sb))
+		bs->rmap_cur = xfs_rmapbt_init_cursor(cur->bc_mp, NULL,
+				bs->agf_bp, bs->cur->bc_private.a.agno);
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
+	error = xfs_btree_scrub_check_owner(bs, bp);
+	if (error)
+		goto out;
+
+	cur->bc_ptrs[level] = 1;
+
+	while (level < cur->bc_nlevels) {
+		block = XFS_BUF_TO_BLOCK(cur->bc_bufs[level]);
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
+			error = xfs_btree_scrub_rec(bs);
+			if (error)
+				goto out;
+
+			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
+			error = bs->scrub_rec(bs, recp);
+			if (error < 0 ||
+			    error == XFS_BTREE_QUERY_RANGE_ABORT)
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
+		error = xfs_btree_scrub_key(bs, level);
+		if (error)
+			goto out;
+
+		/* Drill another level deeper. */
+		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
+		level--;
+		error = xfs_btree_lookup_get_block(cur, level, pp,
+				&block);
+		if (error)
+			goto out;
+
+		xfs_btree_get_block(cur, level, &bp);
+		error = xfs_btree_check_block(cur, block, level, bp);
+		if (error)
+			goto out;
+
+		error = xfs_btree_scrub_check_owner(bs, bp);
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
+	/* Check the deferred stuff */
+	if (!error) {
+		if (bs->cur->bc_btnum == XFS_BTNUM_BNO)
+			bs->bno_cur = bs->cur;
+		else if (bs->cur->bc_btnum == XFS_BTNUM_RMAP)
+			bs->rmap_cur = bs->cur;
+		list_for_each_entry(co, &bs->to_check, list) {
+			error = xfs_btree_block_check_owner(bs, co->bno);
+			if (error)
+				break;
+		}
+	}
+	list_for_each_entry_safe(co, n, &bs->to_check, list) {
+		list_del(&co->list);
+		kmem_free(co);
+	}
+
+	if (bs->bno_cur && bs->bno_cur != bs->cur)
+		xfs_btree_del_cursor(bs->bno_cur, XFS_BTREE_ERROR);
+	if (bs->rmap_cur && bs->rmap_cur != bs->cur)
+		xfs_btree_del_cursor(bs->rmap_cur, XFS_BTREE_ERROR);
+
+	if (error || bs->error)
+		xfs_alert(cur->bc_mp,
+			"Corruption detected. Unmount and run xfs_repair.");
+
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_scrub.h b/fs/xfs/libxfs/xfs_scrub.h
new file mode 100644
index 0000000..af80a9d
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_scrub.h
@@ -0,0 +1,76 @@
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
+#define	__XFS_SCRUB_H__
+
+/* btree scrub */
+struct xfs_btree_scrub;
+
+typedef int (*xfs_btree_scrub_rec_fn)(
+	struct xfs_btree_scrub	*bs,
+	union xfs_btree_rec	*rec);
+
+struct xfs_btree_scrub {
+	/* caller-provided scrub state */
+	struct xfs_btree_cur		*cur;
+	xfs_btree_scrub_rec_fn		scrub_rec;
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
+	struct xfs_btree_cur		*rmap_cur;
+	struct xfs_btree_cur		*bno_cur;
+	struct list_head		to_check;
+	int				error;
+};
+
+int xfs_btree_scrub(struct xfs_btree_scrub *bs);
+void xfs_btree_scrub_error(struct xfs_btree_cur *cur, int level,
+		const char *file, int line, const char *check);
+#define XFS_BTREC_SCRUB_CHECK(bs, fs_ok) \
+	if (!(fs_ok)) { \
+		xfs_btree_scrub_error((bs)->cur, 0, __FILE__, __LINE__, #fs_ok); \
+		(bs)->error = -EFSCORRUPTED; \
+	}
+#define XFS_BTREC_SCRUB_GOTO(bs, fs_ok, label) \
+	if (!(fs_ok)) { \
+		xfs_btree_scrub_error((bs)->cur, 0, __FILE__, __LINE__, #fs_ok); \
+		(bs)->error = -EFSCORRUPTED; \
+		goto label; \
+	}
+#define XFS_BTKEY_SCRUB_CHECK(bs, level, fs_ok) \
+	if (!(fs_ok)) { \
+		xfs_btree_scrub_error((bs)->cur, (level), __FILE__, __LINE__, #fs_ok); \
+		(bs)->error = -EFSCORRUPTED; \
+	}
+#define XFS_BTKEY_SCRUB_GOTO(bs, level, fs_ok, label) \
+	if (!(fs_ok)) { \
+		xfs_btree_scrub_error((bs)->cur, 0, __FILE__, __LINE__, #fs_ok); \
+		(bs)->error = -EFSCORRUPTED; \
+		goto label; \
+	}
+
+#endif	/* __XFS_SCRUB_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
