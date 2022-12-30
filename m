Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9CCC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbiLaCnG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiLaCmt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:42:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095222DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:42:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B086EB81E0E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6277FC433EF;
        Sat, 31 Dec 2022 02:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454565;
        bh=o4GefcwPsvwwidfrWoE2ZuqR+2oZV1lKn4EbUbqjdsQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TYGjBjXcjNWpWiECwuUk9GW14Z60P0RHHQ8doZMl5/8l9YUMPXZHnoI5BkpB9PziW
         7zeAh2NT/4yV/u5YjfpEwtcM1L3lYvi5f+5tqDdSpNxs9RKybJb0iZBgSPlGcYXdTK
         5lK6bKZLt0ZENHxRzLFlR6i+LDjtlDQ0S+BNXP+Obw2mYjUJ9DGyqdtmLtsm5r1ydw
         cJzxZiCwmq9YrIBlRaoaIZOzJkX37Xzc1G56YGhkaVv+LnTgWtNfQn3hbBGJRoQZIW
         cWUTjz+UByh/y/+xGHvPp6MjJHzinhOhG2rXhIyTNuPtqGcKOcOnWLuKRvG9rlYkAs
         Xf0RaGrdHFJFA==
Subject: [PATCH 01/41] xfs: simplify the xfs_rmap_{alloc,free}_extent calling
 conventions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:56 -0800
Message-ID: <167243879607.732820.4802381078469492158.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Simplify the calling conventions by allowing callers to pass a fsbno
(xfs_fsblock_t) directly into these functions, since we're just going to
set it in a struct anyway.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount.c |    6 ++----
 libxfs/xfs_rmap.c     |   12 +++++-------
 libxfs/xfs_rmap.h     |    8 ++++----
 repair/rmap.c         |    8 ++++----
 4 files changed, 15 insertions(+), 19 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 6d1e1bfccd5..5cb2132d9ac 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1888,8 +1888,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1905,8 +1904,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 958e26f2dfd..bce30dd66d6 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -525,7 +525,7 @@ xfs_rmap_free_check_owner(
 	struct xfs_btree_cur	*cur,
 	uint64_t		ltoff,
 	struct xfs_rmap_irec	*rec,
-	xfs_filblks_t		len,
+	xfs_extlen_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags)
@@ -2744,8 +2744,7 @@ xfs_rmap_convert_extent(
 void
 xfs_rmap_alloc_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		fsbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
 {
@@ -2754,7 +2753,7 @@ xfs_rmap_alloc_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
@@ -2766,8 +2765,7 @@ xfs_rmap_alloc_extent(
 void
 xfs_rmap_free_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		fsbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
 {
@@ -2776,7 +2774,7 @@ xfs_rmap_free_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 36af4de506c..54c969731cf 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -187,10 +187,10 @@ void xfs_rmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 void xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
-void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
-		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
-void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
-		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
+void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+		xfs_extlen_t len, uint64_t owner);
+void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+		xfs_extlen_t len, uint64_t owner);
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
diff --git a/repair/rmap.c b/repair/rmap.c
index 00381c6e69d..db85b747e53 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1281,7 +1281,6 @@ rmap_diffkeys(
 {
 	__u64			oa;
 	__u64			ob;
-	int64_t			d;
 	struct xfs_rmap_irec	tmp;
 
 	tmp = *kp1;
@@ -1291,9 +1290,10 @@ rmap_diffkeys(
 	tmp.rm_flags &= ~XFS_RMAP_REC_FLAGS;
 	ob = libxfs_rmap_irec_offset_pack(&tmp);
 
-	d = (int64_t)kp1->rm_startblock - kp2->rm_startblock;
-	if (d)
-		return d;
+	if (kp1->rm_startblock > kp2->rm_startblock)
+		return 1;
+	else if (kp2->rm_startblock > kp1->rm_startblock)
+		return -1;
 
 	if (kp1->rm_owner > kp2->rm_owner)
 		return 1;

