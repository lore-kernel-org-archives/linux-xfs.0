Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56345C4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 02:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0223A224BE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 02:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgLDCtI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 21:49:08 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:38610 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727107AbgLDCtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 21:49:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0UHSRHSZ_1607050104;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UHSRHSZ_1607050104)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 10:48:24 +0800
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: remove unneeded return value check for *init_cursor()
Date:   Fri,  4 Dec 2020 10:48:24 +0800
Message-Id: <1607050104-60778-1-git-send-email-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since *init_cursor() can always return a valid cursor, the NULL check
in caller is unneeded. So clean them up.
This also keeps the behavior consistent with other callers.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/xfs/libxfs/xfs_bmap_btree.c   |  2 --
 fs/xfs/libxfs/xfs_ialloc_btree.c |  5 -----
 fs/xfs/libxfs/xfs_refcount.c     |  9 ---------
 fs/xfs/libxfs/xfs_rmap.c         |  9 ---------
 fs/xfs/scrub/agheader_repair.c   |  2 --
 fs/xfs/scrub/bmap.c              |  5 -----
 fs/xfs/scrub/common.c            | 14 --------------
 7 files changed, 46 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index ecec604..9766591 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -639,8 +639,6 @@ struct xfs_btree_cur *				/* new bmap btree cursor */
 	ASSERT(XFS_IFORK_PTR(ip, whichfork)->if_format == XFS_DINODE_FMT_BTREE);
 
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
-	if (!cur)
-		return -ENOMEM;
 	cur->bc_ino.flags |= XFS_BTCUR_BMBT_INVALID_OWNER;
 
 	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index cc919a2..4c58316 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -672,11 +672,6 @@ struct xfs_btree_cur *
 		return error;
 
 	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, agno, which);
-	if (!cur) {
-		xfs_trans_brelse(tp, *agi_bpp);
-		*agi_bpp = NULL;
-		return -ENOMEM;
-	}
 	*curpp = cur;
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 2076627..2037b9f 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1179,10 +1179,6 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 			return error;
 
 		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
-		if (!rcur) {
-			error = -ENOMEM;
-			goto out_cur;
-		}
 		rcur->bc_ag.refc.nr_ops = nr_ops;
 		rcur->bc_ag.refc.shape_changes = shape_changes;
 	}
@@ -1217,11 +1213,6 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
 		trace_xfs_refcount_finish_one_leftover(mp, agno, type,
 				bno, blockcount, new_agbno, *new_len);
 	return error;
-
-out_cur:
-	xfs_trans_brelse(tp, agbp);
-
-	return error;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 2668ebe..10e0cf99 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2404,10 +2404,6 @@ struct xfs_rmap_query_range_info {
 			return -EFSCORRUPTED;
 
 		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
-		if (!rcur) {
-			error = -ENOMEM;
-			goto out_cur;
-		}
 	}
 	*pcur = rcur;
 
@@ -2446,11 +2442,6 @@ struct xfs_rmap_query_range_info {
 		error = -EFSCORRUPTED;
 	}
 	return error;
-
-out_cur:
-	xfs_trans_brelse(tp, agbp);
-
-	return error;
 }
 
 /*
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 401f715..23690f8 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -829,8 +829,6 @@ enum {
 
 		cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
 				XFS_BTNUM_FINO);
-		if (error)
-			goto err;
 		error = xfs_btree_count_blocks(cur, &blocks);
 		if (error)
 			goto err;
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index fed56d2..dd165c0 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -563,10 +563,6 @@ struct xchk_bmap_check_rmap_info {
 		return error;
 
 	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, agno);
-	if (!cur) {
-		error = -ENOMEM;
-		goto out_agf;
-	}
 
 	sbcri.sc = sc;
 	sbcri.whichfork = whichfork;
@@ -575,7 +571,6 @@ struct xchk_bmap_check_rmap_info {
 		error = 0;
 
 	xfs_btree_del_cursor(cur, error);
-out_agf:
 	xfs_trans_brelse(sc->tp, agf);
 	return error;
 }
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 1887605..8ea6d4a 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -466,8 +466,6 @@ struct xchk_rmap_ownedby_info {
 		/* Set up a bnobt cursor for cross-referencing. */
 		sa->bno_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
 				agno, XFS_BTNUM_BNO);
-		if (!sa->bno_cur)
-			goto err;
 	}
 
 	if (sa->agf_bp &&
@@ -475,8 +473,6 @@ struct xchk_rmap_ownedby_info {
 		/* Set up a cntbt cursor for cross-referencing. */
 		sa->cnt_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
 				agno, XFS_BTNUM_CNT);
-		if (!sa->cnt_cur)
-			goto err;
 	}
 
 	/* Set up a inobt cursor for cross-referencing. */
@@ -484,8 +480,6 @@ struct xchk_rmap_ownedby_info {
 	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_INO)) {
 		sa->ino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
 					agno, XFS_BTNUM_INO);
-		if (!sa->ino_cur)
-			goto err;
 	}
 
 	/* Set up a finobt cursor for cross-referencing. */
@@ -493,8 +487,6 @@ struct xchk_rmap_ownedby_info {
 	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_FINO)) {
 		sa->fino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
 				agno, XFS_BTNUM_FINO);
-		if (!sa->fino_cur)
-			goto err;
 	}
 
 	/* Set up a rmapbt cursor for cross-referencing. */
@@ -502,8 +494,6 @@ struct xchk_rmap_ownedby_info {
 	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_RMAP)) {
 		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
 				agno);
-		if (!sa->rmap_cur)
-			goto err;
 	}
 
 	/* Set up a refcountbt cursor for cross-referencing. */
@@ -511,13 +501,9 @@ struct xchk_rmap_ownedby_info {
 	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_REFC)) {
 		sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
 				sa->agf_bp, agno);
-		if (!sa->refc_cur)
-			goto err;
 	}
 
 	return 0;
-err:
-	return -ENOMEM;
 }
 
 /* Release the AG header context and btree cursors. */
-- 
1.8.3.1

