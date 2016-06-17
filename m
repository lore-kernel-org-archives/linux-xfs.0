Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 356B27FA9
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:30:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ECBF630404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:38 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 82m9135AvLdAvH0q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:37 -0700 (PDT)
Subject: [PATCH 117/119] xfs: support scrubbing rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:30:28 -0700
Message-ID: <146612702887.12839.3951774203711037031.stgit@birch.djwong.org>
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

Plumb in the pieces necessary to check the rmap btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c       |   77 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.c |    4 --
 fs/xfs/libxfs/xfs_rmap_btree.h |    2 +
 fs/xfs/xfs_scrub_sysfs.c       |    2 +
 4 files changed, 81 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index e7673ec..0c8a236 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -38,6 +38,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
+#include "xfs_scrub.h"
 
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
@@ -2367,3 +2368,79 @@ xfs_rmap_record_exists(
 		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
 	return 0;
 }
+
+STATIC int
+xfs_rmapbt_scrub_helper(
+	struct xfs_btree_scrub		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_rmap_irec		irec;
+	bool				is_freesp;
+	bool				non_inode;
+	bool				is_unwritten;
+	bool				is_bmbt;
+	bool				is_attr;
+	int				error;
+
+	error = xfs_rmapbt_btrec_to_irec(rec, &irec);
+	if (error)
+		return error;
+
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rm_startblock < mp->m_sb.sb_agblocks)
+	XFS_BTREC_SCRUB_CHECK(bs, irec.rm_startblock < irec.rm_startblock +
+			irec.rm_blockcount);
+	XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)irec.rm_startblock +
+			irec.rm_blockcount <= mp->m_sb.sb_agblocks)
+
+	non_inode = XFS_RMAP_NON_INODE_OWNER(irec.rm_owner);
+	is_bmbt = irec.rm_flags & XFS_RMAP_ATTR_FORK;
+	is_attr = irec.rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_unwritten = irec.rm_flags & XFS_RMAP_UNWRITTEN;
+
+	XFS_BTREC_SCRUB_CHECK(bs, !is_bmbt || irec.rm_offset == 0);
+	XFS_BTREC_SCRUB_CHECK(bs, !non_inode || irec.rm_offset == 0);
+	XFS_BTREC_SCRUB_CHECK(bs, !is_unwritten || !(is_bmbt || non_inode ||
+			is_attr));
+	XFS_BTREC_SCRUB_CHECK(bs, !non_inode || !(is_bmbt || is_unwritten ||
+			is_attr));
+
+	/* check there's no record in freesp btrees */
+	error = xfs_alloc_record_exists(bs->bno_cur, irec.rm_startblock,
+			irec.rm_blockcount, &is_freesp);
+	if (error)
+		goto err;
+	XFS_BTREC_SCRUB_CHECK(bs, !is_freesp);
+
+	/* XXX: check with the owner */
+
+err:
+	return error;
+}
+
+/* Scrub the rmap btree for some AG. */
+int
+xfs_rmapbt_scrub(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_btree_scrub	bs;
+	int			error;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &bs.agf_bp);
+	if (error)
+		return error;
+
+	bs.cur = xfs_rmapbt_init_cursor(mp, NULL, bs.agf_bp, agno);
+	bs.scrub_rec = xfs_rmapbt_scrub_helper;
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
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 0b045a6..9861e49 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -372,7 +372,6 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.verify_write		= xfs_rmapbt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_rmapbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -408,7 +407,6 @@ xfs_rmapbt_recs_inorder(
 		return 1;
 	return 0;
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
@@ -428,10 +426,8 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
 	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 2f072c8..3f8742d 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -147,4 +147,6 @@ extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp,
 extern int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, struct xfs_owner_info *oinfo, bool *has_rmap);
 
+int xfs_rmapbt_scrub(struct xfs_mount *mp, xfs_agnumber_t agno);
+
 #endif	/* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_scrub_sysfs.c b/fs/xfs/xfs_scrub_sysfs.c
index cb7812f..c2256f3 100644
--- a/fs/xfs/xfs_scrub_sysfs.c
+++ b/fs/xfs/xfs_scrub_sysfs.c
@@ -178,12 +178,14 @@ XFS_AGDATA_SCRUB_ATTR(bnobt, NULL);
 XFS_AGDATA_SCRUB_ATTR(cntbt, NULL);
 XFS_AGDATA_SCRUB_ATTR(inobt, NULL);
 XFS_AGDATA_SCRUB_ATTR(finobt, xfs_sb_version_hasfinobt);
+XFS_AGDATA_SCRUB_ATTR(rmapbt, xfs_sb_version_hasrmapbt);
 
 static struct attribute *xfs_agdata_scrub_attrs[] = {
 	XFS_AGDATA_SCRUB_LIST(bnobt),
 	XFS_AGDATA_SCRUB_LIST(cntbt),
 	XFS_AGDATA_SCRUB_LIST(inobt),
 	XFS_AGDATA_SCRUB_LIST(finobt),
+	XFS_AGDATA_SCRUB_LIST(rmapbt),
 	NULL,
 };
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
