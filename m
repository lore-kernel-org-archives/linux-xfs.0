Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40188 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754341AbcKEA2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:28:13 -0400
Subject: [PATCH 33/39] xfs: repair refcount btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:28:01 -0700
Message-ID: <147830568126.4165.8958545754826054251.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Reconstruct the refcount data from the rmap btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_btree.c    |   21 +++++++++++++++++++++
 libxfs/xfs_btree.h    |    1 +
 libxfs/xfs_refcount.c |   19 ++++++++++++++++++-
 libxfs/xfs_refcount.h |    4 ++++
 4 files changed, 44 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 0c7d549..d1a5347 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4891,3 +4891,24 @@ xfs_btree_has_record(
 
 	return 0;
 }
+
+/* Are there more records in this btree? */
+bool
+xfs_btree_has_more_records(
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_btree_block	*block;
+	struct xfs_buf		*bp;
+
+	block = xfs_btree_get_block(cur, 0, &bp);
+
+	/* There are still records in this block. */
+	if (cur->bc_ptrs[0] < xfs_btree_get_numrecs(block))
+		return true;
+
+	/* There are more record blocks. */
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		return block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK);
+	else
+		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
+}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 52714f0..ace0bb0 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -551,5 +551,6 @@ struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *cur,
 		int level, struct xfs_buf **bpp);
 int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
 		union xfs_btree_irec *high, bool *exists);
+bool xfs_btree_has_more_records(struct xfs_btree_cur *);
 
 #endif	/* __XFS_BTREE_H__ */
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index be0eab3..088f850 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -86,6 +86,23 @@ xfs_refcount_lookup_ge(
 	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
 }
 
+/*
+ * Look up the first record equal to [bno, len] in the btree
+ * given by cur.
+ */
+int
+xfs_refcount_lookup_eq(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	int			*stat)
+{
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
+			XFS_LOOKUP_LE);
+	cur->bc_rec.rc.rc_startblock = bno;
+	cur->bc_rec.rc.rc_blockcount = 0;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
+}
+
 /* Convert on-disk record to in-core format. */
 void
 xfs_refcount_btrec_to_irec(
@@ -147,7 +164,7 @@ xfs_refcount_update(
  * by [bno, len, refcount].
  * This either works (return 0) or gets an EFSCORRUPTED error.
  */
-STATIC int
+int
 xfs_refcount_insert(
 	struct xfs_btree_cur		*cur,
 	struct xfs_refcount_irec	*irec,
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 5973c56..cad61de 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -24,6 +24,8 @@ extern int xfs_refcount_lookup_le(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_lookup_ge(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, int *stat);
+extern int xfs_refcount_lookup_eq(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, int *stat);
 extern int xfs_refcount_get_rec(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 
@@ -72,5 +74,7 @@ extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
 union xfs_btree_rec;
 extern void xfs_refcount_btrec_to_irec(union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
+extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
+		struct xfs_refcount_irec *irec, int *stat);
 
 #endif	/* __XFS_REFCOUNT_H__ */

