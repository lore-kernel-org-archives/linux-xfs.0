Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 961667F0F
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:41:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F0AE6AC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:21 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4ws8Hm3bBrc904ki (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:20 -0700 (PDT)
Subject: [PATCH 09/25] xfs: scrub AGF and AGFL
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:41:09 -0700
Message-ID: <147216846953.3108.18345853853421759907.stgit@birch.djwong.org>
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

Check the block references in the AGF and AGFL headers to make sure
they make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    2 -
 fs/xfs/libxfs/xfs_alloc.h |    2 +
 fs/xfs/libxfs/xfs_fs.h    |    4 +
 fs/xfs/xfs_scrub.c        |  133 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 139 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 8b3e6b3..37782a1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -629,7 +629,7 @@ const struct xfs_buf_ops xfs_agfl_buf_ops = {
 /*
  * Read in the allocation group free block array.
  */
-STATIC int				/* error */
+int					/* error */
 xfs_alloc_read_agfl(
 	xfs_mount_t	*mp,		/* mount point structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 0b00de0..c3ada6b 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -204,6 +204,8 @@ xfs_alloc_get_rec(
 
 int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
+int xfs_alloc_read_agfl(struct xfs_mount *mp, struct xfs_trans *tp,
+			xfs_agnumber_t agno, struct xfs_buf **bpp);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
 int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
 		struct xfs_buf **agbp);
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 8d58061..8249ae0 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -536,7 +536,9 @@ struct xfs_scrub_metadata {
  * Metadata types and flags for scrub operation.
  */
 #define XFS_SCRUB_TYPE_SB	0	/* superblock */
-#define XFS_SCRUB_TYPE_MAX	0
+#define XFS_SCRUB_TYPE_AGF	1	/* AG free header */
+#define XFS_SCRUB_TYPE_AGFL	2	/* AG free list */
+#define XFS_SCRUB_TYPE_MAX	2
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 3def216..c04a097 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -778,6 +778,137 @@ out:
 	return error;
 }
 
+/* Scrub the AGF. */
+STATIC int
+xfs_scrub_agf(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_agf			*agf;
+	struct xfs_buf			*agi_bp = NULL;
+	struct xfs_buf			*agf_bp = NULL;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	xfs_agblock_t			eoag;
+	xfs_daddr_t			daddr;
+	xfs_daddr_t			eofs;
+	int				error;
+
+	if (sm->control >= mp->m_sb.sb_agcount || sm->flags)
+		return -EINVAL;
+	agno = sm->control;
+
+	/* Let the verifier check most of the AGF fields. */
+	error = xfs_scrub_get_ag_headers(mp, agno, &agi_bp, &agf_bp);
+	if (error)
+		return error;
+
+	agf = XFS_BUF_TO_AGF(agf_bp);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+
+	/* Check the AG length */
+	eoag = be32_to_cpu(agf->agf_length);
+	if (agno == mp->m_sb.sb_agcount - 1) {
+		XFS_SCRUB_CHECK(mp, agf_bp, "AGF",
+				eoag <= mp->m_sb.sb_agblocks);
+	} else {
+		XFS_SCRUB_CHECK(mp, agf_bp, "AGF",
+				eoag == mp->m_sb.sb_agblocks);
+	}
+	daddr = XFS_AGB_TO_DADDR(mp, agno, eoag);
+	XFS_SCRUB_CHECK(mp, agf_bp, "AGF", daddr <= eofs);
+
+	/* Check the AGF btree roots */
+	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
+	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	XFS_SCRUB_CHECK(mp, agf_bp, "AGF", agbno < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_CHECK(mp, agf_bp, "AGF", agbno < eoag);
+	XFS_SCRUB_CHECK(mp, agf_bp, "AGF", daddr < eofs);
+
+	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
+	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	XFS_SCRUB_CHECK(mp, agf_bp, "AGF", agbno < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_CHECK(mp, agf_bp, "AGF", agbno < eoag);
+	XFS_SCRUB_CHECK(mp, agf_bp, "AGF", daddr < eofs);
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
+		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		XFS_SCRUB_CHECK(mp, agf_bp, "AGF",
+				agbno < mp->m_sb.sb_agblocks);
+		XFS_SCRUB_CHECK(mp, agf_bp, "AGF", agbno < eoag);
+		XFS_SCRUB_CHECK(mp, agf_bp, "AGF", daddr < eofs);
+	}
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		agbno = be32_to_cpu(agf->agf_refcount_root);
+		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
+		XFS_SCRUB_CHECK(mp, agf_bp, "AGF",
+				agbno < mp->m_sb.sb_agblocks);
+		XFS_SCRUB_CHECK(mp, agf_bp, "AGF", agbno < eoag);
+		XFS_SCRUB_CHECK(mp, agf_bp, "AGF", daddr < eofs);
+	}
+
+	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
+	return error;
+}
+
+/* Scrub the AGFL. */
+STATIC int
+xfs_scrub_agfl(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_agf			*agf;
+	struct xfs_buf			*agi_bp = NULL;
+	struct xfs_buf			*agf_bp = NULL;
+	struct xfs_buf			*agfl_bp;
+	__be32				*agfl_bno;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	xfs_agblock_t			eoag;
+	xfs_daddr_t			eofs;
+	int				i;
+	int				error;
+
+	if (sm->control >= mp->m_sb.sb_agcount || sm->flags)
+		return -EINVAL;
+	agno = sm->control;
+
+	/* Let the verifier check most of the AGF fields. */
+	error = xfs_scrub_get_ag_headers(mp, agno, &agi_bp, &agf_bp);
+	if (error)
+		return error;
+
+	error = xfs_alloc_read_agfl(mp, NULL, agno, &agfl_bp);
+	if (error)
+		goto err_no_agfl;
+
+	agf = XFS_BUF_TO_AGF(agf_bp);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	eoag = be32_to_cpu(agf->agf_length);
+
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
+	for (i = be32_to_cpu(agf->agf_flfirst);
+	     i <= be32_to_cpu(agf->agf_fllast);
+	     i++) {
+		agbno = be32_to_cpu(agfl_bno[i]);
+		XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL",
+				XFS_AGB_TO_DADDR(mp, agno, agbno) < eofs);
+		XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL",
+				agbno < mp->m_sb.sb_agblocks);
+		XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL",
+				agbno < eoag);
+	}
+
+	xfs_buf_relse(agfl_bp);
+err_no_agfl:
+	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
+	return error;
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -787,6 +918,8 @@ struct xfs_scrub_meta_fns {
 
 static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_sb,		NULL},
+	{xfs_scrub_agf,		NULL},
+	{xfs_scrub_agfl,	NULL},
 };
 
 /* Dispatch metadata scrubbing. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
