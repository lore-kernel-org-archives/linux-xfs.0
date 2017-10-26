Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:22504 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932437AbdJZIdt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 04:33:49 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0003Ca-Hq
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0005ML-Gh
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/14] xfs: turn ag header initialisation into a table driven operation
Date: Thu, 26 Oct 2017 19:33:12 +1100
Message-Id: <20171026083322.20428-5-david@fromorbit.com>
In-Reply-To: <20171026083322.20428-1-david@fromorbit.com>
References: <20171026083322.20428-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There's still more cookie cutter code in setting up each AG header.
Separate all the variables into a simple structure and iterate a table
of header definitions to initialise everything.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c | 163 ++++++++++++++++++++++-------------------------------
 1 file changed, 66 insertions(+), 97 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6744865da887..182f9eafab52 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -365,12 +365,13 @@ xfs_agiblock_init(
 		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
 }
 
+typedef void (*aghdr_init_work_f)(struct xfs_mount *mp, struct xfs_buf *bp,
+				  struct aghdr_init_data *id);
 static int
 xfs_growfs_init_aghdr(
 	struct xfs_mount	*mp,
 	struct aghdr_init_data	*id,
-	void			(*work)(struct xfs_mount *, struct xfs_buf *,
-					struct aghdr_init_data *),
+	aghdr_init_work_f	work,
 	const struct xfs_buf_ops *ops)
 
 {
@@ -387,6 +388,16 @@ xfs_growfs_init_aghdr(
 	return 0;
 }
 
+struct xfs_aghdr_grow_data {
+	xfs_daddr_t		daddr;
+	size_t			numblks;
+	const struct xfs_buf_ops *ops;
+	aghdr_init_work_f	work;
+	xfs_btnum_t		type;
+	int			numrecs;
+	bool			need_init;
+};
+
 /*
  * Write new AG headers to disk. Non-transactional, but written
  * synchronously so they are completed prior to the growfs transaction
@@ -398,107 +409,65 @@ xfs_grow_ag_headers(
 	struct aghdr_init_data	*id)
 
 {
+	struct xfs_aghdr_grow_data aghdr_data[] = {
+		/* AGF */
+		{ XFS_AG_DADDR(mp, id->agno, XFS_AGF_DADDR(mp)),
+		  XFS_FSS_TO_BB(mp, 1), &xfs_agf_buf_ops,
+		  &xfs_agfblock_init, 0, 0, true },
+		/* AGFL */
+		{ XFS_AG_DADDR(mp, id->agno, XFS_AGFL_DADDR(mp)),
+		  XFS_FSS_TO_BB(mp, 1), &xfs_agfl_buf_ops,
+		  &xfs_agflblock_init, 0, 0, true },
+		/* AGI */
+		{ XFS_AG_DADDR(mp, id->agno, XFS_AGI_DADDR(mp)),
+		  XFS_FSS_TO_BB(mp, 1), &xfs_agi_buf_ops,
+		  &xfs_agiblock_init, 0, 0, true },
+		/* BNO root block */
+		{ XFS_AGB_TO_DADDR(mp, id->agno, XFS_BNO_BLOCK(mp)),
+		  BTOBB(mp->m_sb.sb_blocksize), &xfs_allocbt_buf_ops,
+		  &xfs_bnoroot_init, XFS_BTNUM_BNO, 1, true },
+		/* CNT root block */
+		{ XFS_AGB_TO_DADDR(mp, id->agno, XFS_CNT_BLOCK(mp)),
+		  BTOBB(mp->m_sb.sb_blocksize), &xfs_allocbt_buf_ops,
+		  &xfs_cntroot_init, XFS_BTNUM_CNT, 1, true },
+		/* INO root block */
+		{ XFS_AGB_TO_DADDR(mp, id->agno, XFS_IBT_BLOCK(mp)),
+		  BTOBB(mp->m_sb.sb_blocksize), &xfs_inobt_buf_ops,
+		  &xfs_btroot_init, XFS_BTNUM_INO, 0, true },
+		/* FINO root block */
+		{ XFS_AGB_TO_DADDR(mp, id->agno, XFS_FIBT_BLOCK(mp)),
+		  BTOBB(mp->m_sb.sb_blocksize), &xfs_inobt_buf_ops,
+		  &xfs_btroot_init, XFS_BTNUM_FINO, 0,
+		  xfs_sb_version_hasfinobt(&mp->m_sb) },
+		/* RMAP root block */
+		{ XFS_AGB_TO_DADDR(mp, id->agno, XFS_RMAP_BLOCK(mp)),
+		  BTOBB(mp->m_sb.sb_blocksize), &xfs_rmapbt_buf_ops,
+		  &xfs_rmaproot_init, XFS_BTNUM_RMAP, 0,
+		  xfs_sb_version_hasrmapbt(&mp->m_sb) },
+		/* REFC root block */
+		{ XFS_AGB_TO_DADDR(mp, id->agno, xfs_refc_block(mp)),
+		  BTOBB(mp->m_sb.sb_blocksize), &xfs_refcountbt_buf_ops,
+		  &xfs_btroot_init, XFS_BTNUM_REFC, 0,
+		  xfs_sb_version_hasreflink(&mp->m_sb) },
+		/* NULL terminating block */
+		{ XFS_BUF_DADDR_NULL, 0, NULL, NULL, 0, 0, false },
+	};
+	struct  xfs_aghdr_grow_data *dp;
 	int			error = 0;
 
-	/* AG freespace header block */
-	id->daddr = XFS_AG_DADDR(mp, id->agno, XFS_AGF_DADDR(mp));
-	id->numblks = XFS_FSS_TO_BB(mp, 1);
-	error = xfs_growfs_init_aghdr(mp, id, xfs_agfblock_init,
-					&xfs_agf_buf_ops);
-	if (error)
-		goto out_error;
-
-	/* AG freelist header block */
-	id->daddr = XFS_AG_DADDR(mp, id->agno, XFS_AGFL_DADDR(mp));
-	id->numblks = XFS_FSS_TO_BB(mp, 1);
-	error = xfs_growfs_init_aghdr(mp, id, xfs_agflblock_init,
-					&xfs_agfl_buf_ops);
-	if (error)
-		goto out_error;
-
-	/* AG inode header block */
-	id->daddr = XFS_AG_DADDR(mp, id->agno, XFS_AGI_DADDR(mp));
-	id->numblks = XFS_FSS_TO_BB(mp, 1);
-	error = xfs_growfs_init_aghdr(mp, id, xfs_agiblock_init,
-					&xfs_agi_buf_ops);
-	if (error)
-		goto out_error;
-
-
-	/* BNO btree root block */
-	id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_BNO_BLOCK(mp));
-	id->numblks = BTOBB(mp->m_sb.sb_blocksize);
-	id->type = XFS_BTNUM_BNO;
-	id->numrecs = 1;
-	error = xfs_growfs_init_aghdr(mp, id, xfs_bnoroot_init,
-				   &xfs_allocbt_buf_ops);
-	if (error)
-		goto out_error;
-
-
-	/* CNT btree root block */
-	id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_CNT_BLOCK(mp));
-	id->numblks = BTOBB(mp->m_sb.sb_blocksize);
-	id->type = XFS_BTNUM_CNT;
-	id->numrecs = 1;
-	error = xfs_growfs_init_aghdr(mp, id, xfs_cntroot_init,
-				   &xfs_allocbt_buf_ops);
-	if (error)
-		goto out_error;
-
-	/* RMAP btree root block */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-		id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_RMAP_BLOCK(mp));
-		id->numblks = BTOBB(mp->m_sb.sb_blocksize);
-		id->type = XFS_BTNUM_RMAP;
-		id->numrecs = 0;
-		error = xfs_growfs_init_aghdr(mp, id, xfs_rmaproot_init,
-					   &xfs_rmapbt_buf_ops);
-		if (error)
-			goto out_error;
-
-	}
-
-	/* INO btree root block */
-	id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_IBT_BLOCK(mp));
-	id->numblks = BTOBB(mp->m_sb.sb_blocksize);
-	id->type = XFS_BTNUM_INO;
-	id->numrecs = 0;
-	error = xfs_growfs_init_aghdr(mp, id, xfs_btroot_init,
-				   &xfs_inobt_buf_ops);
-	if (error)
-		goto out_error;
-
-
-	/*
-	 * FINO btree root block
-	 */
-	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
-		id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_FIBT_BLOCK(mp));
-		id->numblks = BTOBB(mp->m_sb.sb_blocksize);
-		id->type = XFS_BTNUM_FINO;
-		id->numrecs = 0;
-		error = xfs_growfs_init_aghdr(mp, id, xfs_btroot_init,
-					   &xfs_inobt_buf_ops);
-		if (error)
-			goto out_error;
-	}
+	for (dp = &aghdr_data[0]; dp->daddr != XFS_BUF_DADDR_NULL; dp++) {
+		if (!dp->need_init)
+			continue;
 
-	/*
-	 * refcount btree root block
-	 */
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-		id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, xfs_refc_block(mp));
-		id->numblks = BTOBB(mp->m_sb.sb_blocksize);
-		id->type = XFS_BTNUM_REFC;
-		id->numrecs = 0;
-		error = xfs_growfs_init_aghdr(mp, id, xfs_btroot_init,
-					   &xfs_refcountbt_buf_ops);
+		id->daddr = dp->daddr;
+		id->numblks = dp->numblks;
+		id->numrecs = dp->numrecs;
+		id->type = dp->type;
+		error = xfs_growfs_init_aghdr(mp, id, dp->work, dp->ops);
 		if (error)
-			goto out_error;
+			break;
 	}
 
-out_error:
 	return error;
 }
 
-- 
2.15.0.rc0

