Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:1693 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751099AbeENETN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 00:19:13 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fI4x0-0002v6-7F
        for linux-xfs@vger.kernel.org; Mon, 14 May 2018 14:19:06 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fI4x0-0002xY-5o
        for linux-xfs@vger.kernel.org; Mon, 14 May 2018 14:19:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/10] xfs: turn ag header initialisation into a table driven operation
Date: Mon, 14 May 2018 14:18:59 +1000
Message-Id: <20180514041904.11140-6-david@fromorbit.com>
In-Reply-To: <20180514041904.11140-1-david@fromorbit.com>
References: <20180514041904.11140-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There's still more cookie cutter code in setting up each AG header.
Separate all the variables into a simple structure and iterate a
table of header definitions to initialise everything.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fsops.c | 182 +++++++++++++++++++++++----------------------
 1 file changed, 92 insertions(+), 90 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ec3c51ee8134..fb283d2cf42b 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -282,12 +282,13 @@ xfs_agiblock_init(
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
@@ -304,6 +305,15 @@ xfs_growfs_init_aghdr(
 	return 0;
 }
 
+struct xfs_aghdr_grow_data {
+	xfs_daddr_t		daddr;
+	size_t			numblks;
+	const struct xfs_buf_ops *ops;
+	aghdr_init_work_f	work;
+	xfs_btnum_t		type;
+	bool			need_init;
+};
+
 /*
  * Write new AG headers to disk. Non-transactional, but written
  * synchronously so they are completed prior to the growfs transaction
@@ -315,101 +325,93 @@ xfs_grow_ag_headers(
 	struct aghdr_init_data	*id)
 
 {
+	struct xfs_aghdr_grow_data aghdr_data[] = {
+	{ /* AGF */
+		.daddr = XFS_AG_DADDR(mp, id->agno, XFS_AGF_DADDR(mp)),
+		.numblks = XFS_FSS_TO_BB(mp, 1),
+		.ops = &xfs_agf_buf_ops,
+		.work = &xfs_agfblock_init,
+		.need_init = true
+	},
+	{ /* AGFL */
+		.daddr = XFS_AG_DADDR(mp, id->agno, XFS_AGFL_DADDR(mp)),
+		.numblks = XFS_FSS_TO_BB(mp, 1),
+		.ops = &xfs_agfl_buf_ops,
+		.work = &xfs_agflblock_init,
+		.need_init = true
+	},
+	{ /* AGI */
+		.daddr = XFS_AG_DADDR(mp, id->agno, XFS_AGI_DADDR(mp)),
+		.numblks = XFS_FSS_TO_BB(mp, 1),
+		.ops = &xfs_agi_buf_ops,
+		.work = &xfs_agiblock_init,
+		.need_init = true
+	},
+	{ /* BNO root block */
+		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_BNO_BLOCK(mp)),
+		.numblks = BTOBB(mp->m_sb.sb_blocksize),
+		.ops = &xfs_allocbt_buf_ops,
+		.work = &xfs_bnoroot_init,
+		.need_init = true
+	},
+	{ /* CNT root block */
+		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_CNT_BLOCK(mp)),
+		.numblks = BTOBB(mp->m_sb.sb_blocksize),
+		.ops = &xfs_allocbt_buf_ops,
+		.work = &xfs_cntroot_init,
+		.need_init = true
+	},
+	{ /* INO root block */
+		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_IBT_BLOCK(mp)),
+		.numblks = BTOBB(mp->m_sb.sb_blocksize),
+		.ops = &xfs_inobt_buf_ops,
+		.work = &xfs_btroot_init,
+		.type = XFS_BTNUM_INO,
+		.need_init = true
+	},
+	{ /* FINO root block */
+		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_FIBT_BLOCK(mp)),
+		.numblks = BTOBB(mp->m_sb.sb_blocksize),
+		.ops = &xfs_inobt_buf_ops,
+		.work = &xfs_btroot_init,
+		.type = XFS_BTNUM_FINO,
+		.need_init =  xfs_sb_version_hasfinobt(&mp->m_sb)
+	},
+	{ /* RMAP root block */
+		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_RMAP_BLOCK(mp)),
+		.numblks = BTOBB(mp->m_sb.sb_blocksize),
+		.ops = &xfs_rmapbt_buf_ops,
+		.work = &xfs_rmaproot_init,
+		.need_init = xfs_sb_version_hasrmapbt(&mp->m_sb)
+	},
+	{ /* REFC root block */
+		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, xfs_refc_block(mp)),
+		.numblks = BTOBB(mp->m_sb.sb_blocksize),
+		.ops = &xfs_refcountbt_buf_ops,
+		.work = &xfs_btroot_init,
+		.type = XFS_BTNUM_REFC,
+		.need_init = xfs_sb_version_hasreflink(&mp->m_sb)
+	},
+	{ /* NULL terminating block */
+		.daddr = XFS_BUF_DADDR_NULL,
+	}
+	};
+	struct  xfs_aghdr_grow_data *dp;
 	int			error = 0;
 
 	/* Account for AG free space in new AG */
 	id->nfree += id->agsize - mp->m_ag_prealloc_blocks;
+	for (dp = &aghdr_data[0]; dp->daddr != XFS_BUF_DADDR_NULL; dp++) {
+		if (!dp->need_init)
+			continue;
 
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
-	error = xfs_growfs_init_aghdr(mp, id, xfs_bnoroot_init,
-				   &xfs_allocbt_buf_ops);
-	if (error)
-		goto out_error;
-
-
-	/* CNT btree root block */
-	id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_CNT_BLOCK(mp));
-	id->numblks = BTOBB(mp->m_sb.sb_blocksize);
-	error = xfs_growfs_init_aghdr(mp, id, xfs_cntroot_init,
-				   &xfs_allocbt_buf_ops);
-	if (error)
-		goto out_error;
-
-	/* RMAP btree root block */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-		id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_RMAP_BLOCK(mp));
-		id->numblks = BTOBB(mp->m_sb.sb_blocksize);
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
-		error = xfs_growfs_init_aghdr(mp, id, xfs_btroot_init,
-					   &xfs_inobt_buf_ops);
-		if (error)
-			goto out_error;
-	}
-
-	/*
-	 * refcount btree root block
-	 */
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-		id->daddr = XFS_AGB_TO_DADDR(mp, id->agno, xfs_refc_block(mp));
-		id->numblks = BTOBB(mp->m_sb.sb_blocksize);
-		id->type = XFS_BTNUM_REFC;
-		error = xfs_growfs_init_aghdr(mp, id, xfs_btroot_init,
-					   &xfs_refcountbt_buf_ops);
+		id->daddr = dp->daddr;
+		id->numblks = dp->numblks;
+		id->type = dp->type;
+		error = xfs_growfs_init_aghdr(mp, id, dp->work, dp->ops);
 		if (error)
-			goto out_error;
+			break;
 	}
-
-out_error:
 	return error;
 }
 
-- 
2.17.0

