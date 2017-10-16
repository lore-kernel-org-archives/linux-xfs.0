Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27787 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbdJPTsH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 15:48:07 -0400
Date: Mon, 16 Oct 2017 12:48:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 04/30] xfs: refactor btree block header checking functions
Message-ID: <20171016194803.GG4703@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777246790.1724.5365622613986439998.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777246790.1724.5365622613986439998.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>

Refactor the btree block header checks to have an internal function that
returns the address of the failing check without logging errors.  The
scrubber will call the internal function, while the external version
will maintain the current logging behavior.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix raw use of asm volatile in __this_address and lengthen comments
---
 fs/xfs/libxfs/xfs_btree.c |  166 +++++++++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_btree.h |    8 ++
 fs/xfs/xfs_linux.h        |    7 ++
 3 files changed, 113 insertions(+), 68 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index ae19f24..67a5b0f 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -63,44 +63,61 @@ xfs_btree_magic(
 	return magic;
 }
 
-STATIC int				/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_lblock(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	struct xfs_btree_block	*block,	/* btree long form block pointer */
-	int			level,	/* level of the btree block */
-	struct xfs_buf		*bp)	/* buffer for block, if any */
+/*
+ * Check a long btree block header.  Return the address of the failing check,
+ * or NULL if everything is ok.
+ */
+void *
+__xfs_btree_check_lblock(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	int			level,
+	struct xfs_buf		*bp)
 {
-	int			lblock_ok = 1; /* block passes checks */
-	struct xfs_mount	*mp;	/* file system mount point */
+	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
-	int			crc;
-
-	mp = cur->bc_mp;
-	crc = xfs_sb_version_hascrc(&mp->m_sb);
+	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
 
 	if (crc) {
-		lblock_ok = lblock_ok &&
-			uuid_equal(&block->bb_u.l.bb_uuid,
-				   &mp->m_sb.sb_meta_uuid) &&
-			block->bb_u.l.bb_blkno == cpu_to_be64(
-				bp ? bp->b_bn : XFS_BUF_DADDR_NULL);
+		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
+			return __this_address;
+		if (block->bb_u.l.bb_blkno !=
+		    cpu_to_be64(bp ? bp->b_bn : XFS_BUF_DADDR_NULL))
+			return __this_address;
 	}
 
-	lblock_ok = lblock_ok &&
-		be32_to_cpu(block->bb_magic) == xfs_btree_magic(crc, btnum) &&
-		be16_to_cpu(block->bb_level) == level &&
-		be16_to_cpu(block->bb_numrecs) <=
-			cur->bc_ops->get_maxrecs(cur, level) &&
-		block->bb_u.l.bb_leftsib &&
-		(block->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK) ||
-		 XFS_FSB_SANITY_CHECK(mp,
-			be64_to_cpu(block->bb_u.l.bb_leftsib))) &&
-		block->bb_u.l.bb_rightsib &&
-		(block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK) ||
-		 XFS_FSB_SANITY_CHECK(mp,
-			be64_to_cpu(block->bb_u.l.bb_rightsib)));
-
-	if (unlikely(XFS_TEST_ERROR(!lblock_ok, mp,
+	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(crc, btnum))
+		return __this_address;
+	if (be16_to_cpu(block->bb_level) != level)
+		return __this_address;
+	if (be16_to_cpu(block->bb_numrecs) >
+	    cur->bc_ops->get_maxrecs(cur, level))
+		return __this_address;
+	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
+	    !xfs_btree_check_lptr(cur, be64_to_cpu(block->bb_u.l.bb_leftsib),
+			level + 1))
+		return __this_address;
+	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
+	    !xfs_btree_check_lptr(cur, be64_to_cpu(block->bb_u.l.bb_rightsib),
+			level + 1))
+		return __this_address;
+
+	return NULL;
+}
+
+/* Check a long btree block header. */
+int
+xfs_btree_check_lblock(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	int			level,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	void			*failed_at;
+
+	failed_at = __xfs_btree_check_lblock(cur, block, level, bp);
+	if (unlikely(XFS_TEST_ERROR(failed_at != NULL, mp,
 			XFS_ERRTAG_BTREE_CHECK_LBLOCK))) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
@@ -110,48 +127,61 @@ xfs_btree_check_lblock(
 	return 0;
 }
 
-STATIC int				/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_sblock(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	struct xfs_btree_block	*block,	/* btree short form block pointer */
-	int			level,	/* level of the btree block */
-	struct xfs_buf		*bp)	/* buffer containing block */
+/*
+ * Check a short btree block header.  Return the address of the failing check,
+ * or NULL if everything is ok.
+ */
+void *
+__xfs_btree_check_sblock(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	int			level,
+	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp;	/* file system mount point */
-	struct xfs_buf		*agbp;	/* buffer for ag. freespace struct */
-	struct xfs_agf		*agf;	/* ag. freespace structure */
-	xfs_agblock_t		agflen;	/* native ag. freespace length */
-	int			sblock_ok = 1; /* block passes checks */
+	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
-	int			crc;
-
-	mp = cur->bc_mp;
-	crc = xfs_sb_version_hascrc(&mp->m_sb);
-	agbp = cur->bc_private.a.agbp;
-	agf = XFS_BUF_TO_AGF(agbp);
-	agflen = be32_to_cpu(agf->agf_length);
+	int			crc = xfs_sb_version_hascrc(&mp->m_sb);
 
 	if (crc) {
-		sblock_ok = sblock_ok &&
-			uuid_equal(&block->bb_u.s.bb_uuid,
-				   &mp->m_sb.sb_meta_uuid) &&
-			block->bb_u.s.bb_blkno == cpu_to_be64(
-				bp ? bp->b_bn : XFS_BUF_DADDR_NULL);
+		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
+			return __this_address;
+		if (block->bb_u.s.bb_blkno !=
+		    cpu_to_be64(bp ? bp->b_bn : XFS_BUF_DADDR_NULL))
+			return __this_address;
 	}
 
-	sblock_ok = sblock_ok &&
-		be32_to_cpu(block->bb_magic) == xfs_btree_magic(crc, btnum) &&
-		be16_to_cpu(block->bb_level) == level &&
-		be16_to_cpu(block->bb_numrecs) <=
-			cur->bc_ops->get_maxrecs(cur, level) &&
-		(block->bb_u.s.bb_leftsib == cpu_to_be32(NULLAGBLOCK) ||
-		 be32_to_cpu(block->bb_u.s.bb_leftsib) < agflen) &&
-		block->bb_u.s.bb_leftsib &&
-		(block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK) ||
-		 be32_to_cpu(block->bb_u.s.bb_rightsib) < agflen) &&
-		block->bb_u.s.bb_rightsib;
-
-	if (unlikely(XFS_TEST_ERROR(!sblock_ok, mp,
+	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(crc, btnum))
+		return __this_address;
+	if (be16_to_cpu(block->bb_level) != level)
+		return __this_address;
+	if (be16_to_cpu(block->bb_numrecs) >
+	    cur->bc_ops->get_maxrecs(cur, level))
+		return __this_address;
+	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
+	    !xfs_btree_check_sptr(cur, be32_to_cpu(block->bb_u.s.bb_leftsib),
+			level + 1))
+		return __this_address;
+	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
+	    !xfs_btree_check_sptr(cur, be32_to_cpu(block->bb_u.s.bb_rightsib),
+			level + 1))
+		return __this_address;
+
+	return NULL;
+}
+
+/* Check a short btree block header. */
+STATIC int
+xfs_btree_check_sblock(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	int			level,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	void			*failed_at;
+
+	failed_at = __xfs_btree_check_sblock(cur, block, level, bp);
+	if (unlikely(XFS_TEST_ERROR(failed_at != NULL, mp,
 			XFS_ERRTAG_BTREE_CHECK_SBLOCK))) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 8f52eda..43694e4 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -255,6 +255,14 @@ typedef struct xfs_btree_cur
  */
 #define	XFS_BUF_TO_BLOCK(bp)	((struct xfs_btree_block *)((bp)->b_addr))
 
+/*
+ * Internal long and short btree block checks.  They return NULL if the
+ * block is ok or the address of the failed check otherwise.
+ */
+void *__xfs_btree_check_lblock(struct xfs_btree_cur *cur,
+		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
+void *__xfs_btree_check_sblock(struct xfs_btree_cur *cur,
+		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
 
 /*
  * Check that block header is ok.
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index dcd1292..00a5efe 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -142,6 +142,13 @@ typedef __u32			xfs_nlink_t;
 #define SYNCHRONIZE()	barrier()
 #define __return_address __builtin_return_address(0)
 
+/*
+ * Return the address of a label.  Use barrier() so that the optimizer
+ * won't reorder code to refactor the error jumpouts into a single
+ * return, which throws off the reported address.
+ */
+#define __this_address	({ __label__ __here; __here: barrier(); &&__here; })
+
 #define XFS_PROJID_DEFAULT	0
 
 #define MIN(a,b)	(min(a,b))
