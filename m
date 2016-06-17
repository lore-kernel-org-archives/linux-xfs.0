Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 21AFF7FE5
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:30:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D43378F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:25 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id nzHaEmJE5MdrsGl1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:23 -0700 (PDT)
Subject: [PATCH 115/119] xfs: support scrubbing free space btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:30:16 -0700
Message-ID: <146612701627.12839.18375212914216273798.stgit@birch.djwong.org>
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

Plumb in the pieces necessary to check the free space btrees.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c       |   98 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h       |    3 +
 fs/xfs/libxfs/xfs_alloc_btree.c |   51 ++++++++++++++++++--
 fs/xfs/xfs_scrub_sysfs.c        |    5 ++
 4 files changed, 151 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6fc1981..bc2a1b1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -39,6 +39,7 @@
 #include "xfs_log.h"
 #include "xfs_ag_resv.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_scrub.h"
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -2957,3 +2958,100 @@ xfs_alloc_record_exists(
 	*is_freesp = (fbno <= bno && fbno + flen >= bno + len);
 	return 0;
 }
+
+STATIC int
+xfs_allocbt_scrub_rmap_check(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	xfs_err(cur->bc_mp, "%s: freespace in rmapbt! %u/%u %u %lld %lld %x",
+			__func__, cur->bc_private.a.agno, rec->rm_startblock,
+			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
+			rec->rm_flags);
+	return XFS_BTREE_QUERY_RANGE_ABORT;
+}
+
+STATIC int
+xfs_allocbt_scrub_helper(
+	struct xfs_btree_scrub		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	xfs_agblock_t			bno;
+	xfs_extlen_t			len;
+	struct xfs_rmap_irec		low;
+	struct xfs_rmap_irec		high;
+	bool				no_rmap;
+	int				error;
+
+	bno = be32_to_cpu(rec->alloc.ar_startblock);
+	len = be32_to_cpu(rec->alloc.ar_blockcount);
+
+	XFS_BTREC_SCRUB_CHECK(bs, bno <= mp->m_sb.sb_agblocks);
+	XFS_BTREC_SCRUB_CHECK(bs, bno < bno + len);
+	XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
+			mp->m_sb.sb_agblocks);
+
+	/* if rmapbt, make sure there's no record */
+	if (!bs->rmap_cur)
+		return 0;
+
+	memset(&low, 0, sizeof(low));
+	low.rm_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rm_startblock = bno + len - 1;
+
+	error = xfs_rmapbt_query_range(bs->rmap_cur, &low, &high,
+			&xfs_allocbt_scrub_rmap_check, NULL);
+	if (error && error != XFS_BTREE_QUERY_RANGE_ABORT)
+		goto err;
+	no_rmap = error == 0;
+	XFS_BTREC_SCRUB_CHECK(bs, no_rmap);
+err:
+	return error;
+}
+
+/* Scrub the freespace btrees for some AG. */
+STATIC int
+xfs_allocbt_scrub(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	int			which)
+{
+	struct xfs_btree_scrub	bs;
+	int			error;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &bs.agf_bp);
+	if (error)
+		return error;
+
+	bs.cur = xfs_allocbt_init_cursor(mp, NULL, bs.agf_bp, agno, which);
+	bs.scrub_rec = xfs_allocbt_scrub_helper;
+	xfs_rmap_ag_owner(&bs.oinfo, XFS_RMAP_OWN_AG);
+	error = xfs_btree_scrub(&bs);
+	xfs_btree_del_cursor(bs.cur,
+			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_trans_brelse(NULL, bs.agf_bp);
+
+	if (!error && bs.error)
+		error = bs.error;
+
+	return error;
+}
+
+int
+xfs_bnobt_scrub(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	return xfs_allocbt_scrub(mp, agno, XFS_BTNUM_BNO);
+}
+
+int
+xfs_cntbt_scrub(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	return xfs_allocbt_scrub(mp, agno, XFS_BTNUM_CNT);
+}
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 4f2ce38..f1fcc7e 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -213,4 +213,7 @@ xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
 int xfs_alloc_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, bool *is_freesp);
 
+int xfs_bnobt_scrub(struct xfs_mount *mp, xfs_agnumber_t agno);
+int xfs_cntbt_scrub(struct xfs_mount *mp, xfs_agnumber_t agno);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 5ba2dac..f9859e8 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -256,6 +256,26 @@ xfs_allocbt_key_diff(
 	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
+STATIC __int64_t
+xfs_bnobt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be32_to_cpu(k2->alloc.ar_startblock) -
+			  be32_to_cpu(k1->alloc.ar_startblock);
+}
+
+STATIC __int64_t
+xfs_cntbt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be32_to_cpu(k2->alloc.ar_blockcount) -
+			  be32_to_cpu(k1->alloc.ar_blockcount);
+}
+
 static bool
 xfs_allocbt_verify(
 	struct xfs_buf		*bp)
@@ -344,7 +364,6 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
 };
 
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_allocbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -381,9 +400,29 @@ xfs_allocbt_recs_inorder(
 			 be32_to_cpu(r2->alloc.ar_startblock));
 	}
 }
-#endif	/* DEBUG */
 
-static const struct xfs_btree_ops xfs_allocbt_ops = {
+static const struct xfs_btree_ops xfs_bnobt_ops = {
+	.rec_len		= sizeof(xfs_alloc_rec_t),
+	.key_len		= sizeof(xfs_alloc_key_t),
+
+	.dup_cursor		= xfs_allocbt_dup_cursor,
+	.set_root		= xfs_allocbt_set_root,
+	.alloc_block		= xfs_allocbt_alloc_block,
+	.free_block		= xfs_allocbt_free_block,
+	.update_lastrec		= xfs_allocbt_update_lastrec,
+	.get_minrecs		= xfs_allocbt_get_minrecs,
+	.get_maxrecs		= xfs_allocbt_get_maxrecs,
+	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
+	.init_rec_from_cur	= xfs_allocbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
+	.key_diff		= xfs_allocbt_key_diff,
+	.buf_ops		= &xfs_allocbt_buf_ops,
+	.diff_two_keys		= xfs_bnobt_diff_two_keys,
+	.keys_inorder		= xfs_allocbt_keys_inorder,
+	.recs_inorder		= xfs_allocbt_recs_inorder,
+};
+
+static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 
@@ -399,10 +438,9 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_allocbt_key_diff,
 	.buf_ops		= &xfs_allocbt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
+	.diff_two_keys		= xfs_cntbt_diff_two_keys,
 	.keys_inorder		= xfs_allocbt_keys_inorder,
 	.recs_inorder		= xfs_allocbt_recs_inorder,
-#endif
 };
 
 /*
@@ -427,12 +465,13 @@ xfs_allocbt_init_cursor(
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-	cur->bc_ops = &xfs_allocbt_ops;
 
 	if (btnum == XFS_BTNUM_CNT) {
+		cur->bc_ops = &xfs_cntbt_ops;
 		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
 		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
 	} else {
+		cur->bc_ops = &xfs_bnobt_ops;
 		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
 	}
 
diff --git a/fs/xfs/xfs_scrub_sysfs.c b/fs/xfs/xfs_scrub_sysfs.c
index 9942d55..efaa635 100644
--- a/fs/xfs/xfs_scrub_sysfs.c
+++ b/fs/xfs/xfs_scrub_sysfs.c
@@ -174,7 +174,12 @@ static struct xfs_agdata_scrub_attr xfs_agdata_scrub_attr_##_name = {	     \
 }
 #define XFS_AGDATA_SCRUB_LIST(name)	&xfs_agdata_scrub_attr_##name.sa.attr
 
+XFS_AGDATA_SCRUB_ATTR(bnobt, NULL);
+XFS_AGDATA_SCRUB_ATTR(cntbt, NULL);
+
 static struct attribute *xfs_agdata_scrub_attrs[] = {
+	XFS_AGDATA_SCRUB_LIST(bnobt),
+	XFS_AGDATA_SCRUB_LIST(cntbt),
 	NULL,
 };
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
