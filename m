Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 26EC47F50
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:41:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ED8178F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:49 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5EPMdotFLfRtTQcl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:48 -0700 (PDT)
Subject: [PATCH 14/25] xfs: support scrubbing refcount btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:41:44 -0700
Message-ID: <147216850417.3108.11834451022377166006.stgit@birch.djwong.org>
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

Plumb in the pieces necessary to check the refcount btree.  If rmap is
available, check the reference count by performing an interval query
against the rmapbt.

v2: Handle the case where the rmap records are not all at least the
length of the refcount extent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h             |    3 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   33 +++++++++++++-----
 fs/xfs/xfs_scrub.c                 |   67 ++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 31e091c..60dfe03 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -544,7 +544,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_INOBT	6	/* inode btree */
 #define XFS_SCRUB_TYPE_FINOBT	7	/* free inode btree */
 #define XFS_SCRUB_TYPE_RMAPBT	8	/* reverse mapping btree */
-#define XFS_SCRUB_TYPE_MAX	8
+#define XFS_SCRUB_TYPE_REFCNTBT	9	/* reference count btree */
+#define XFS_SCRUB_TYPE_MAX	9
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index fa8dfd6..a58540c 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -164,18 +164,26 @@ xfs_refcountbt_init_key_from_rec(
 	union xfs_btree_key	*key,
 	union xfs_btree_rec	*rec)
 {
-	ASSERT(rec->refc.rc_startblock != 0);
-
 	key->refc.rc_startblock = rec->refc.rc_startblock;
 }
 
 STATIC void
+xfs_refcountbt_init_high_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	__u32			x;
+
+	x = be32_to_cpu(rec->refc.rc_startblock);
+	x += be32_to_cpu(rec->refc.rc_blockcount) - 1;
+	key->refc.rc_startblock = cpu_to_be32(x);
+}
+
+STATIC void
 xfs_refcountbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
 {
-	ASSERT(cur->bc_rec.rc.rc_startblock != 0);
-
 	rec->refc.rc_startblock = cpu_to_be32(cur->bc_rec.rc.rc_startblock);
 	rec->refc.rc_blockcount = cpu_to_be32(cur->bc_rec.rc.rc_blockcount);
 	rec->refc.rc_refcount = cpu_to_be32(cur->bc_rec.rc.rc_refcount);
@@ -205,6 +213,16 @@ xfs_refcountbt_key_diff(
 	return (__int64_t)be32_to_cpu(kp->rc_startblock) - rec->rc_startblock;
 }
 
+STATIC __int64_t
+xfs_refcountbt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be32_to_cpu(k1->refc.rc_startblock) -
+			  be32_to_cpu(k2->refc.rc_startblock);
+}
+
 STATIC bool
 xfs_refcountbt_verify(
 	struct xfs_buf		*bp)
@@ -267,7 +285,6 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 	.verify_write		= xfs_refcountbt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_refcountbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -296,13 +313,13 @@ xfs_refcountbt_recs_inorder(
 		b.rc_startblock = be32_to_cpu(r2->refc.rc_startblock);
 		b.rc_blockcount = be32_to_cpu(r2->refc.rc_blockcount);
 		b.rc_refcount = be32_to_cpu(r2->refc.rc_refcount);
+		a = a; b = b;
 		trace_xfs_refcount_rec_order_error(cur->bc_mp,
 				cur->bc_private.a.agno, &a, &b);
 	}
 
 	return ret;
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
@@ -315,14 +332,14 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.get_minrecs		= xfs_refcountbt_get_minrecs,
 	.get_maxrecs		= xfs_refcountbt_get_maxrecs,
 	.init_key_from_rec	= xfs_refcountbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_refcountbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_refcountbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
 	.key_diff		= xfs_refcountbt_key_diff,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
+	.diff_two_keys		= xfs_refcountbt_diff_two_keys,
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
 	.recs_inorder		= xfs_refcountbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index d155c52..4894221 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1247,6 +1247,72 @@ xfs_scrub_rmapbt(
 	return error;
 }
 
+/* Reference count btree scrubber. */
+
+/* Scrub a refcountbt record. */
+STATIC int
+xfs_scrub_refcountbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_agf			*agf;
+	struct xfs_refcount_irec	irec;
+	xfs_agblock_t			eoag;
+	int				error = 0;
+
+	irec.rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
+	irec.rc_blockcount = be32_to_cpu(rec->refc.rc_blockcount);
+	irec.rc_refcount = be32_to_cpu(rec->refc.rc_refcount);
+	agf = XFS_BUF_TO_AGF(bs->agf_bp);
+	eoag = be32_to_cpu(agf->agf_length);
+
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rc_startblock < mp->m_sb.sb_agblocks);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rc_startblock < eoag);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rc_startblock < irec.rc_startblock +
+			irec.rc_blockcount);
+	XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)irec.rc_startblock +
+			irec.rc_blockcount <= mp->m_sb.sb_agblocks);
+	XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)irec.rc_startblock +
+			irec.rc_blockcount <= eoag);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rc_refcount >= 1);
+
+	return error;
+}
+
+/* Scrub the refcount btree for some AG. */
+STATIC int
+xfs_scrub_refcountbt(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_scrub_btree		bs;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	if (sm->control >= mp->m_sb.sb_agcount || sm->flags)
+		return -EINVAL;
+	agno = sm->control;
+
+	error = xfs_scrub_btree_get_ag_headers(mp, &bs, agno);
+	if (error)
+		return error;
+
+	bs.cur = xfs_refcountbt_init_cursor(mp, NULL, bs.agf_bp, agno, NULL);
+	bs.scrub_rec = xfs_scrub_refcountbt_helper;
+	xfs_rmap_ag_owner(&bs.oinfo, XFS_RMAP_OWN_REFC);
+	error = xfs_scrub_btree(&bs);
+	xfs_btree_del_cursor(bs.cur,
+			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_scrub_btree_put_ag_headers(&bs);
+
+	if (!error && bs.error)
+		error = bs.error;
+
+	return error;
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -1264,6 +1330,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_inobt,	NULL},
 	{xfs_scrub_finobt,	xfs_sb_version_hasfinobt},
 	{xfs_scrub_rmapbt,	xfs_sb_version_hasrmapbt},
+	{xfs_scrub_refcountbt,	xfs_sb_version_hasreflink},
 };
 
 /* Dispatch metadata scrubbing. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
