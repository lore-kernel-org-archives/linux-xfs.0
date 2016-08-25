Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B87F7F2B
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:41:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1D7A48F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:45 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id o45Cdbdhg6WsmRQG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:44 -0700 (PDT)
Subject: [PATCH 13/25] xfs: support scrubbing rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:41:37 -0700
Message-ID: <147216849790.3108.6113125984791659243.stgit@birch.djwong.org>
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

Plumb in the pieces necessary to check the rmap btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h         |    3 +
 fs/xfs/libxfs/xfs_rmap.c       |    3 +
 fs/xfs/libxfs/xfs_rmap.h       |    3 +
 fs/xfs/libxfs/xfs_rmap_btree.c |    4 --
 fs/xfs/xfs_scrub.c             |   84 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 91 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6b8ff75..31e091c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -543,7 +543,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_CNTBT	5	/* freesp by length btree */
 #define XFS_SCRUB_TYPE_INOBT	6	/* inode btree */
 #define XFS_SCRUB_TYPE_FINOBT	7	/* free inode btree */
-#define XFS_SCRUB_TYPE_MAX	7
+#define XFS_SCRUB_TYPE_RMAPBT	8	/* reverse mapping btree */
+#define XFS_SCRUB_TYPE_MAX	8
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 3a8cc71..b0308fc 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -179,7 +179,8 @@ done:
 	return error;
 }
 
-static int
+/* Convert an internal btree record to an rmap record. */
+int
 xfs_rmap_btrec_to_irec(
 	union xfs_btree_rec	*rec,
 	struct xfs_rmap_irec	*irec)
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 7899305..188db38 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -212,5 +212,8 @@ int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
 		struct xfs_rmap_irec *irec, int	*stat);
+union xfs_btree_rec;
+int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
+		struct xfs_rmap_irec *irec);
 
 #endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 385c2ac..f4c776d 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -377,7 +377,6 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.verify_write		= xfs_rmapbt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_rmapbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -437,7 +436,6 @@ xfs_rmapbt_recs_inorder(
 		return 1;
 	return 0;
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
@@ -456,10 +454,8 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
 	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 81d24f5..d155c52 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1164,6 +1164,89 @@ xfs_scrub_finobt(
 	return xfs_scrub_iallocbt(ip->i_mount, sm, XFS_BTNUM_FINO);
 }
 
+/* Reverse-mapping scrubber. */
+
+/* Scrub an rmapbt record. */
+STATIC int
+xfs_scrub_rmapbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_agf			*agf;
+	struct xfs_rmap_irec		irec;
+	xfs_agblock_t			eoag;
+	bool				non_inode;
+	bool				is_unwritten;
+	bool				is_bmbt;
+	bool				is_attr;
+	int				error;
+
+	error = xfs_rmap_btrec_to_irec(rec, &irec);
+	if (error)
+		return error;
+
+	agf = XFS_BUF_TO_AGF(bs->agf_bp);
+	eoag = be32_to_cpu(agf->agf_length);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rm_startblock < mp->m_sb.sb_agblocks)
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rm_startblock < eoag);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rm_startblock < irec.rm_startblock +
+			irec.rm_blockcount);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rm_startblock + irec.rm_blockcount <=
+			mp->m_sb.sb_agblocks)
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rm_startblock + irec.rm_blockcount <=
+			eoag);
+
+	non_inode = XFS_RMAP_NON_INODE_OWNER(irec.rm_owner);
+	is_bmbt = irec.rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec.rm_flags & XFS_RMAP_ATTR_FORK;
+	is_unwritten = irec.rm_flags & XFS_RMAP_UNWRITTEN;
+
+	XFS_BTREC_SCRUB_CHECK(bs, !is_bmbt || irec.rm_offset == 0);
+	XFS_BTREC_SCRUB_CHECK(bs, !non_inode || irec.rm_offset == 0);
+	XFS_BTREC_SCRUB_CHECK(bs, !is_unwritten || !(is_bmbt || non_inode ||
+			is_attr));
+	XFS_BTREC_SCRUB_CHECK(bs, !non_inode || !(is_bmbt || is_unwritten ||
+			is_attr));
+
+	/* XXX: check with the owner */
+
+	return error;
+}
+
+/* Scrub the rmap btree for some AG. */
+STATIC int
+xfs_scrub_rmapbt(
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
+	bs.cur = xfs_rmapbt_init_cursor(mp, NULL, bs.agf_bp, agno);
+	bs.scrub_rec = xfs_scrub_rmapbt_helper;
+	xfs_rmap_ag_owner(&bs.oinfo, XFS_RMAP_OWN_AG);
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
@@ -1180,6 +1263,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_cntbt,	NULL},
 	{xfs_scrub_inobt,	NULL},
 	{xfs_scrub_finobt,	xfs_sb_version_hasfinobt},
+	{xfs_scrub_rmapbt,	xfs_sb_version_hasrmapbt},
 };
 
 /* Dispatch metadata scrubbing. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
