Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38575 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751493AbcKEAUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:20:44 -0400
Subject: [PATCH 15/41] xfs: support scrubbing free space btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:20:40 -0700
Message-ID: <147830524067.2155.1950676824465928564.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Check the extent records free space btrees to ensure that the values
look sane.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c |    6 ----
 fs/xfs/libxfs/xfs_fs.h          |    4 ++-
 fs/xfs/xfs_scrub.c              |   60 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h              |    4 ++-
 4 files changed, 66 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 3dad54e..927f444 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -386,7 +386,6 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
 };
 
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_bnobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -433,7 +432,6 @@ xfs_cntbt_recs_inorder(
 		 be32_to_cpu(r1->alloc.ar_startblock) <
 		 be32_to_cpu(r2->alloc.ar_startblock));
 }
-#endif /* DEBUG */
 
 static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
@@ -453,10 +451,8 @@ static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.key_diff		= xfs_bnobt_key_diff,
 	.buf_ops		= &xfs_allocbt_buf_ops,
 	.diff_two_keys		= xfs_bnobt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_bnobt_keys_inorder,
 	.recs_inorder		= xfs_bnobt_recs_inorder,
-#endif
 };
 
 static const struct xfs_btree_ops xfs_cntbt_ops = {
@@ -476,10 +472,8 @@ static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.key_diff		= xfs_cntbt_key_diff,
 	.buf_ops		= &xfs_allocbt_buf_ops,
 	.diff_two_keys		= xfs_cntbt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_cntbt_keys_inorder,
 	.recs_inorder		= xfs_cntbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d93787b..d640464 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -579,7 +579,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
 #define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
 #define XFS_SCRUB_TYPE_AGI	4	/* AG inode header */
-#define XFS_SCRUB_TYPE_MAX	4
+#define XFS_SCRUB_TYPE_BNOBT	5	/* freesp by block btree */
+#define XFS_SCRUB_TYPE_CNTBT	6	/* freesp by length btree */
+#define XFS_SCRUB_TYPE_MAX	6
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 35bb141..3784f46 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1700,6 +1700,64 @@ xfs_scrub_agi(
 }
 #undef XFS_SCRUB_AGI_CHECK
 
+/* Free space btree scrubber. */
+
+/* Scrub a bnobt/cntbt record. */
+STATIC int
+xfs_scrub_allocbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_agf			*agf;
+	xfs_agblock_t			bno;
+	xfs_extlen_t			len;
+	int				error = 0;
+
+	bno = be32_to_cpu(rec->alloc.ar_startblock);
+	len = be32_to_cpu(rec->alloc.ar_blockcount);
+	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
+
+	XFS_SCRUB_BTREC_CHECK(bs, bno < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_BTREC_CHECK(bs, bno < be32_to_cpu(agf->agf_length));
+	XFS_SCRUB_BTREC_CHECK(bs, bno < bno + len);
+	XFS_SCRUB_BTREC_CHECK(bs, (unsigned long long)bno + len <=
+			mp->m_sb.sb_agblocks);
+	XFS_SCRUB_BTREC_CHECK(bs, (unsigned long long)bno + len <=
+			be32_to_cpu(agf->agf_length));
+
+	return error;
+}
+
+/* Scrub the freespace btrees for some AG. */
+STATIC int
+xfs_scrub_allocbt(
+	struct xfs_scrub_context	*sc,
+	xfs_btnum_t			which)
+{
+	struct xfs_owner_info		oinfo;
+	struct xfs_btree_cur		*cur;
+
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+	cur = which == XFS_BTNUM_BNO ? sc->sa.bno_cur : sc->sa.cnt_cur;
+	return xfs_scrub_btree(sc, cur, xfs_scrub_allocbt_helper,
+			&oinfo, NULL);
+}
+
+STATIC int
+xfs_scrub_bnobt(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_scrub_allocbt(sc, XFS_BTNUM_BNO);
+}
+
+STATIC int
+xfs_scrub_cntbt(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_scrub_allocbt(sc, XFS_BTNUM_CNT);
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -1716,6 +1774,8 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header, xfs_scrub_agf, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_agfl, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_agi, NULL, NULL},
+	{xfs_scrub_setup_ag_header, xfs_scrub_bnobt, NULL, NULL},
+	{xfs_scrub_setup_ag_header, xfs_scrub_cntbt, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8454a72..48e0191 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3466,7 +3466,9 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_SB,		"superblock" }, \
 	{ XFS_SCRUB_TYPE_AGF,		"AGF" }, \
 	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }, \
-	{ XFS_SCRUB_TYPE_AGI,		"AGI" }
+	{ XFS_SCRUB_TYPE_AGI,		"AGI" }, \
+	{ XFS_SCRUB_TYPE_BNOBT,		"bnobt" }, \
+	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

