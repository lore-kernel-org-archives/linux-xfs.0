Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E55BACCA47C
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 00:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiF0ASp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 20:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiF0ASn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 20:18:43 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C09402BF8
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 17:18:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8B6F510E75C4
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 10:18:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSZ-00BTVL-2p
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 10:18:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5cSZ-000uB3-1b
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 10:18:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/14] xfs: pass perag to xfs_read_agi
Date:   Mon, 27 Jun 2022 10:18:24 +1000
Message-Id: <20220627001832.215779-7-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627001832.215779-1-david@fromorbit.com>
References: <20220627001832.215779-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62b8f75c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=Ru3meIeGREELRzOxrq8A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We have the perag in most palces we call xfs_read_agi, so pass the
perag instead of a mount/agno pair.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ialloc.c | 21 ++++++++++-----------
 fs/xfs/libxfs/xfs_ialloc.h | 10 +++-------
 fs/xfs/xfs_inode.c         | 14 ++++++++------
 fs/xfs/xfs_log_recover.c   | 38 +++++++++++++++++++-------------------
 4 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index dfa8061f65d9..55757b990ac6 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2571,25 +2571,24 @@ const struct xfs_buf_ops xfs_agi_buf_ops = {
  */
 int
 xfs_read_agi(
-	struct xfs_mount	*mp,	/* file system mount structure */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_agnumber_t		agno,	/* allocation group number */
-	struct xfs_buf		**bpp)	/* allocation group hdr buf */
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
+	struct xfs_buf		**agibpp)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
-	trace_xfs_read_agi(mp, agno);
+	trace_xfs_read_agi(pag->pag_mount, pag->pag_agno);
 
-	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, bpp, &xfs_agi_buf_ops);
+			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGI_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), 0, agibpp, &xfs_agi_buf_ops);
 	if (error)
 		return error;
 	if (tp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_AGI_BUF);
+		xfs_trans_buf_set_type(tp, *agibpp, XFS_BLFT_AGI_BUF);
 
-	xfs_buf_set_ref(*bpp, XFS_AGI_REF);
+	xfs_buf_set_ref(*agibpp, XFS_AGI_REF);
 	return 0;
 }
 
@@ -2609,7 +2608,7 @@ xfs_ialloc_read_agi(
 
 	trace_xfs_ialloc_read_agi(pag->pag_mount, pag->pag_agno);
 
-	error = xfs_read_agi(pag->pag_mount, tp, pag->pag_agno, &agibp);
+	error = xfs_read_agi(pag, tp, &agibp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 72cb33170d9f..9bbbca6ac4ed 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -62,11 +62,9 @@ xfs_ialloc_log_agi(
 	struct xfs_buf	*bp,		/* allocation group header buffer */
 	uint32_t	fields);	/* bitmask of fields to log */
 
-/*
- * Read in the allocation group header (inode allocation section)
- */
-int					/* error */
-xfs_ialloc_read_agi(struct xfs_perag *pag, struct xfs_trans *tp,
+int xfs_read_agi(struct xfs_perag *pag, struct xfs_trans *tp,
+		struct xfs_buf **agibpp);
+int xfs_ialloc_read_agi(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf **agibpp);
 
 /*
@@ -89,8 +87,6 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_agnumber_t agno, xfs_agblock_t agbno,
 			  xfs_agblock_t length, unsigned int gen);
 
-int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
-		xfs_agnumber_t agno, struct xfs_buf **bpp);
 
 union xfs_btree_rec;
 void xfs_inobt_btrec_to_irec(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 52d6f2c7d58b..6dcb9b0fa852 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2157,7 +2157,7 @@ xfs_iunlink(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
+	error = xfs_read_agi(pag, tp, &agibp);
 	if (error)
 		goto out;
 	agi = agibp->b_addr;
@@ -2342,7 +2342,7 @@ xfs_iunlink_remove(
 	trace_xfs_iunlink_remove(ip);
 
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
+	error = xfs_read_agi(pag, tp, &agibp);
 	if (error)
 		return error;
 	agi = agibp->b_addr;
@@ -3243,11 +3243,13 @@ xfs_rename(
 		if (inodes[i] == wip ||
 		    (inodes[i] == target_ip &&
 		     (VFS_I(target_ip)->i_nlink == 1 || src_is_directory))) {
-			struct xfs_buf	*bp;
-			xfs_agnumber_t	agno;
+			struct xfs_perag	*pag;
+			struct xfs_buf		*bp;
 
-			agno = XFS_INO_TO_AGNO(mp, inodes[i]->i_ino);
-			error = xfs_read_agi(mp, tp, agno, &bp);
+			pag = xfs_perag_get(mp,
+					XFS_INO_TO_AGNO(mp, inodes[i]->i_ino));
+			error = xfs_read_agi(pag, tp, &bp);
+			xfs_perag_put(pag);
 			if (error)
 				goto out_trans_cancel;
 		}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5f7e4e6e33ce..38aae3409c96 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2629,21 +2629,21 @@ xlog_recover_cancel_intents(
  */
 STATIC void
 xlog_recover_clear_agi_bucket(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno,
-	int		bucket)
+	struct xfs_perag	*pag,
+	int			bucket)
 {
-	xfs_trans_t	*tp;
-	xfs_agi_t	*agi;
-	struct xfs_buf	*agibp;
-	int		offset;
-	int		error;
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_trans	*tp;
+	struct xfs_agi		*agi;
+	struct xfs_buf		*agibp;
+	int			offset;
+	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_clearagi, 0, 0, 0, &tp);
 	if (error)
 		goto out_error;
 
-	error = xfs_read_agi(mp, tp, agno, &agibp);
+	error = xfs_read_agi(pag, tp, &agibp);
 	if (error)
 		goto out_abort;
 
@@ -2662,14 +2662,14 @@ xlog_recover_clear_agi_bucket(
 out_abort:
 	xfs_trans_cancel(tp);
 out_error:
-	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__, agno);
+	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__,
+			pag->pag_agno);
 	return;
 }
 
 STATIC xfs_agino_t
 xlog_recover_process_one_iunlink(
-	struct xfs_mount		*mp,
-	xfs_agnumber_t			agno,
+	struct xfs_perag		*pag,
 	xfs_agino_t			agino,
 	int				bucket)
 {
@@ -2679,15 +2679,15 @@ xlog_recover_process_one_iunlink(
 	xfs_ino_t			ino;
 	int				error;
 
-	ino = XFS_AGINO_TO_INO(mp, agno, agino);
-	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
+	ino = XFS_AGINO_TO_INO(pag->pag_mount, pag->pag_agno, agino);
+	error = xfs_iget(pag->pag_mount, NULL, ino, 0, 0, &ip);
 	if (error)
 		goto fail;
 
 	/*
 	 * Get the on disk inode to find the next inode in the bucket.
 	 */
-	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &ibp);
+	error = xfs_imap_to_bp(pag->pag_mount, NULL, &ip->i_imap, &ibp);
 	if (error)
 		goto fail_iput;
 	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
@@ -2714,7 +2714,7 @@ xlog_recover_process_one_iunlink(
 	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
 	 * clear the inode pointer in the bucket.
 	 */
-	xlog_recover_clear_agi_bucket(mp, agno, bucket);
+	xlog_recover_clear_agi_bucket(pag, bucket);
 	return NULLAGINO;
 }
 
@@ -2755,7 +2755,7 @@ xlog_recover_process_iunlinks(
 	int			error;
 
 	for_each_perag(mp, agno, pag) {
-		error = xfs_read_agi(mp, NULL, pag->pag_agno, &agibp);
+		error = xfs_read_agi(pag, NULL, &agibp);
 		if (error) {
 			/*
 			 * AGI is b0rked. Don't process it.
@@ -2780,8 +2780,8 @@ xlog_recover_process_iunlinks(
 		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
 			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 			while (agino != NULLAGINO) {
-				agino = xlog_recover_process_one_iunlink(mp,
-						pag->pag_agno, agino, bucket);
+				agino = xlog_recover_process_one_iunlink(pag,
+						agino, bucket);
 				cond_resched();
 			}
 		}
-- 
2.36.1

