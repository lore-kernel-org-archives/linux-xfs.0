Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:12843 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751378AbeBAGmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 01:42:09 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eh8ZR-0005Cs-4X
        for linux-xfs@vger.kernel.org; Thu, 01 Feb 2018 17:42:05 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90)
        (envelope-from <david@fromorbit.com>)
        id 1eh8ZR-00024Y-3L
        for linux-xfs@vger.kernel.org; Thu, 01 Feb 2018 17:42:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/7] xfs: separate secondary sb update in growfs
Date: Thu,  1 Feb 2018 17:42:01 +1100
Message-Id: <20180201064202.7174-7-david@fromorbit.com>
In-Reply-To: <20180201064202.7174-1-david@fromorbit.com>
References: <20180201064202.7174-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This happens after all the transactions to update the superblock
occur, and errors need to be handled slightly differently. Seperate
out the code into it's own function, and clean up the error goto
stack in the core growfs code as it is now much simpler.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c | 154 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 87 insertions(+), 67 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 5c844e540320..113be7dbdc81 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -401,9 +401,8 @@ xfs_growfs_data_private(
 {
 	xfs_agf_t		*agf;
 	xfs_agi_t		*agi;
-	xfs_agnumber_t		agno;
 	xfs_buf_t		*bp;
-	int			error, saved_error = 0;
+	int			error;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_mod;
@@ -475,12 +474,12 @@ xfs_growfs_data_private(
 		error = xfs_grow_ag_headers(mp, &id);
 		if (error) {
 			xfs_buf_delwri_cancel(&id.buffer_list);
-			goto error0;
+			goto out_trans_cancel;
 		}
 	}
 	error = xfs_buf_delwri_submit(&id.buffer_list);
 	if (error)
-		goto error0;
+		goto out_trans_cancel;
 
 	xfs_trans_agblocks_delta(tp, id.nfree);
 
@@ -494,22 +493,23 @@ xfs_growfs_data_private(
 		 * Change the agi length.
 		 */
 		error = xfs_ialloc_read_agi(mp, tp, id.agno, &bp);
-		if (error) {
-			goto error0;
-		}
+		if (error)
+			goto out_trans_cancel;
+
 		ASSERT(bp);
 		agi = XFS_BUF_TO_AGI(bp);
 		be32_add_cpu(&agi->agi_length, new);
 		ASSERT(nagcount == oagcount ||
 		       be32_to_cpu(agi->agi_length) == mp->m_sb.sb_agblocks);
 		xfs_ialloc_log_agi(tp, bp, XFS_AGI_LENGTH);
+
 		/*
 		 * Change agf length.
 		 */
 		error = xfs_alloc_read_agf(mp, tp, id.agno, 0, &bp);
-		if (error) {
-			goto error0;
-		}
+		if (error)
+			goto out_trans_cancel;
+
 		ASSERT(bp);
 		agf = XFS_BUF_TO_AGF(bp);
 		be32_add_cpu(&agf->agf_length, new);
@@ -529,13 +529,13 @@ xfs_growfs_data_private(
 				be32_to_cpu(agf->agf_length) - new,
 				new, &oinfo);
 		if (error)
-			goto error0;
+			goto out_trans_cancel;
 		error = xfs_free_extent(tp,
 				XFS_AGB_TO_FSB(mp, id.agno,
 					be32_to_cpu(agf->agf_length) - new),
 				new, &oinfo, XFS_AG_RESV_NONE);
 		if (error)
-			goto error0;
+			goto out_trans_cancel;
 	}
 
 	/*
@@ -572,16 +572,79 @@ xfs_growfs_data_private(
 		error = xfs_ag_resv_free(pag);
 		xfs_perag_put(pag);
 		if (error)
-			goto out;
+			return error;
 	}
 
 	/* Reserve AG metadata blocks. */
-	error = xfs_fs_reserve_ag_blocks(mp);
-	if (error && error != -ENOSPC)
-		goto out;
+	return xfs_fs_reserve_ag_blocks(mp);
+
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+static int
+xfs_growfs_log_private(
+	xfs_mount_t		*mp,	/* mount point for filesystem */
+	xfs_growfs_log_t	*in)	/* growfs log input struct */
+{
+	xfs_extlen_t		nb;
+
+	nb = in->newblocks;
+	if (nb < XFS_MIN_LOG_BLOCKS || nb < XFS_B_TO_FSB(mp, XFS_MIN_LOG_BYTES))
+		return -EINVAL;
+	if (nb == mp->m_sb.sb_logblocks &&
+	    in->isint == (mp->m_sb.sb_logstart != 0))
+		return -EINVAL;
+	/*
+	 * Moving the log is hard, need new interfaces to sync
+	 * the log first, hold off all activity while moving it.
+	 * Can have shorter or longer log in the same space,
+	 * or transform internal to external log or vice versa.
+	 */
+	return -ENOSYS;
+}
+
+static int
+xfs_growfs_imaxpct(
+	struct xfs_mount	*mp,
+	__u32			imaxpct)
+{
+	struct xfs_trans	*tp;
+	int			dpct;
+	int			error;
+
+	if (imaxpct > 100)
+		return -EINVAL;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
+			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
+	if (error)
+		return error;
+
+	dpct = imaxpct - mp->m_sb.sb_imax_pct;
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
+	xfs_trans_set_sync(tp);
+	return xfs_trans_commit(tp);
+}
+
+/*
+ * After a grow operation, we need to update all the secondary superblocks
+ * to match the new state of the primary. Read/init the superblocks and update
+ * them appropriately.
+ */
+static int
+xfs_growfs_update_superblocks(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		oagcount)
+{
+	struct xfs_buf		*bp;
+	xfs_agnumber_t		agno;
+	int			saved_error = 0;
+	int			error = 0;
 
 	/* update secondary superblocks. */
-	for (agno = 1; agno < nagcount; agno++) {
+	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
 		error = 0;
 		/*
 		 * new secondary superblocks need to be zeroed, not read from
@@ -631,57 +694,7 @@ xfs_growfs_data_private(
 		}
 	}
 
- out:
 	return saved_error ? saved_error : error;
-
- error0:
-	xfs_trans_cancel(tp);
-	return error;
-}
-
-static int
-xfs_growfs_log_private(
-	xfs_mount_t		*mp,	/* mount point for filesystem */
-	xfs_growfs_log_t	*in)	/* growfs log input struct */
-{
-	xfs_extlen_t		nb;
-
-	nb = in->newblocks;
-	if (nb < XFS_MIN_LOG_BLOCKS || nb < XFS_B_TO_FSB(mp, XFS_MIN_LOG_BYTES))
-		return -EINVAL;
-	if (nb == mp->m_sb.sb_logblocks &&
-	    in->isint == (mp->m_sb.sb_logstart != 0))
-		return -EINVAL;
-	/*
-	 * Moving the log is hard, need new interfaces to sync
-	 * the log first, hold off all activity while moving it.
-	 * Can have shorter or longer log in the same space,
-	 * or transform internal to external log or vice versa.
-	 */
-	return -ENOSYS;
-}
-
-static int
-xfs_growfs_imaxpct(
-	struct xfs_mount	*mp,
-	__u32			imaxpct)
-{
-	struct xfs_trans	*tp;
-	int64_t			dpct;
-	int			error;
-
-	if (imaxpct > 100)
-		return -EINVAL;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
-			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
-	if (error)
-		return error;
-
-	dpct = (int64_t)imaxpct - mp->m_sb.sb_imax_pct;
-	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
-	xfs_trans_set_sync(tp);
-	return xfs_trans_commit(tp);
 }
 
 /*
@@ -694,6 +707,7 @@ xfs_growfs_data(
 	struct xfs_mount	*mp,
 	struct xfs_growfs_data	*in)
 {
+	xfs_agnumber_t		oagcount;
 	int			error = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -708,6 +722,7 @@ xfs_growfs_data(
 			goto out_error;
 	}
 
+	oagcount = mp->m_sb.sb_agcount;
 	error = xfs_growfs_data_private(mp, in);
 	if (error)
 		goto out_error;
@@ -722,6 +737,11 @@ xfs_growfs_data(
 	} else
 		mp->m_maxicount = 0;
 
+	/*
+	 * Update secondary superblocks now the physical grow has completed
+	 */
+	error = xfs_growfs_update_superblocks(mp, oagcount);
+
 out_error:
 	/*
 	 * Increment the generation unconditionally, the error could be from
-- 
2.15.1

