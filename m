Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435AEC07E95
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 00:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24CEA6128E
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 00:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbhGNADA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 20:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235437AbhGNAC7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Jul 2021 20:02:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C1B66127C;
        Wed, 14 Jul 2021 00:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626220809;
        bh=s3VnJa8T9s9Uv76Y8E/uoS3306tWpjHsL2LXE0H0IBE=;
        h=Date:From:To:Cc:Subject:From;
        b=cP3YTC066EXntZmQ+itkw0nt5xww5HdP4ATnQV0dEcCLYqukonu5iAobb63tDnw0P
         LZ3Bc5y/va3HSxbwZcZWD8u3OylOoDwbfXwYQiaePsg36DX95oO9F3BKmA0PcL3R0W
         BJ+QMW3qZm6GhL5mCpQombxv77gacDz8GQhULYN9DZWBe7J26n1X76NUn9sam9HFfT
         Yj02YvxzVMNjpAPxW20IpS0r/Rfu+9+rvE/9nkXXFqryyvk1cpGT3EemTDvZtYs9fT
         cTIsU8oOwiZUJsrXC2PGvvBxZyrOfGW+PXoZ950ZvMfgjATY+s384juIpSRHq4uKAq
         tcXt2nSsr3XIQ==
Date:   Tue, 13 Jul 2021 17:00:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: keep the active perag reference between finish_one calls
Message-ID: <20210714000008.GC22402@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The refcount and rmap finish_one functions stash a btree cursor when
there are multiple ->finish_one calls to be made in a single
transaction.  This mechanism is how we maintain the AGF lock between
operations of a single intent item.  Since ag btree cursors now need
active references to perag structures, we must preserve the perag
reference when we save the cursor.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   33 ++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_rmap.c     |    8 +++++++-
 2 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 860a0c9801ba..cfd98958d38c 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1113,13 +1113,16 @@ xfs_refcount_finish_one_cleanup(
 	int			error)
 {
 	struct xfs_buf		*agbp;
+	struct xfs_perag	*pag;
 
 	if (rcur == NULL)
 		return;
 	agbp = rcur->bc_ag.agbp;
+	pag = rcur->bc_ag.pag;
 	xfs_btree_del_cursor(rcur, error);
 	if (error)
 		xfs_trans_brelse(tp, agbp);
+	xfs_perag_put(pag);
 }
 
 /*
@@ -1142,19 +1145,20 @@ xfs_refcount_finish_one(
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_btree_cur		*rcur;
 	struct xfs_buf			*agbp = NULL;
-	int				error = 0;
+	struct xfs_perag		*pag;
+	unsigned long			nr_ops = 0;
+	xfs_agnumber_t			agno;
 	xfs_agblock_t			bno;
 	xfs_agblock_t			new_agbno;
-	unsigned long			nr_ops = 0;
 	int				shape_changes = 0;
-	struct xfs_perag		*pag;
+	int				error = 0;
 
-	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, startblock));
+	agno = XFS_FSB_TO_AGNO(mp, startblock);
+	pag = xfs_perag_get(mp, agno);
 	bno = XFS_FSB_TO_AGBNO(mp, startblock);
 
-	trace_xfs_refcount_deferred(mp, XFS_FSB_TO_AGNO(mp, startblock),
-			type, XFS_FSB_TO_AGBNO(mp, startblock),
-			blockcount);
+	trace_xfs_refcount_deferred(mp, agno, type,
+			 XFS_FSB_TO_AGBNO(mp, startblock), blockcount);
 
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE)) {
 		error = -EIO;
@@ -1174,14 +1178,16 @@ xfs_refcount_finish_one(
 		*pcur = NULL;
 	}
 	if (rcur == NULL) {
-		error = xfs_alloc_read_agf(tp->t_mountp, tp, pag->pag_agno,
+		error = xfs_alloc_read_agf(mp, tp, agno,
 				XFS_ALLOC_FLAG_FREEING, &agbp);
 		if (error)
 			goto out_drop;
 
+		/* The cursor now owns the AGF buf and perag ref */
 		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
 		rcur->bc_ag.refc.nr_ops = nr_ops;
 		rcur->bc_ag.refc.shape_changes = shape_changes;
+		pag = NULL;
 	}
 	*pcur = rcur;
 
@@ -1189,12 +1195,12 @@ xfs_refcount_finish_one(
 	case XFS_REFCOUNT_INCREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
 			new_len, XFS_REFCOUNT_ADJUST_INCREASE, NULL);
-		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+		*new_fsb = XFS_AGB_TO_FSB(mp, agno, new_agbno);
 		break;
 	case XFS_REFCOUNT_DECREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
 			new_len, XFS_REFCOUNT_ADJUST_DECREASE, NULL);
-		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+		*new_fsb = XFS_AGB_TO_FSB(mp, agno, new_agbno);
 		break;
 	case XFS_REFCOUNT_ALLOC_COW:
 		*new_fsb = startblock + blockcount;
@@ -1211,10 +1217,11 @@ xfs_refcount_finish_one(
 		error = -EFSCORRUPTED;
 	}
 	if (!error && *new_len > 0)
-		trace_xfs_refcount_finish_one_leftover(mp, pag->pag_agno, type,
-				bno, blockcount, new_agbno, *new_len);
+		trace_xfs_refcount_finish_one_leftover(mp, agno, type, bno,
+				blockcount, new_agbno, *new_len);
 out_drop:
-	xfs_perag_put(pag);
+	if (pag)
+		xfs_perag_put(pag);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index d1dfad0204e3..003ca71515ac 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2335,13 +2335,16 @@ xfs_rmap_finish_one_cleanup(
 	int			error)
 {
 	struct xfs_buf		*agbp;
+	struct xfs_perag	*pag;
 
 	if (rcur == NULL)
 		return;
 	agbp = rcur->bc_ag.agbp;
+	pag = rcur->bc_ag.pag;
 	xfs_btree_del_cursor(rcur, error);
 	if (error)
 		xfs_trans_brelse(tp, agbp);
+	xfs_perag_put(pag);
 }
 
 /*
@@ -2408,7 +2411,9 @@ xfs_rmap_finish_one(
 			goto out_drop;
 		}
 
+		/* The cursor now owns the AGF buf and perag ref */
 		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
+		pag = NULL;
 	}
 	*pcur = rcur;
 
@@ -2447,7 +2452,8 @@ xfs_rmap_finish_one(
 		error = -EFSCORRUPTED;
 	}
 out_drop:
-	xfs_perag_put(pag);
+	if (pag)
+		xfs_perag_put(pag);
 	return error;
 }
 
