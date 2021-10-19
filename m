Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C52CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6783360E90
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 18:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234715AbhJSSys (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234722AbhJSSys (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Oct 2021 14:54:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8C8C60F9F;
        Tue, 19 Oct 2021 18:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634669555;
        bh=ETPaNOXJ66wSN+LcMpC/s90szZopuBakrhEQmYK7/8k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QdV9zdhx2Nhfs7iW1aVR89V4psWhrOdDfgpmmptJVqCzKxyAnWhIZ58on8NjkzUyV
         vAdSSDJx96qQs18SZp66Vo4+nWivk+Rt+i7Xz3Sqp0leIxARfuhDLMnBhnQR6gfEzl
         /k4g6KDso4ExA1HrOVEbtsdKa3sDsd2ctvLAhcJjuCCWDopUNlza9W8+BXD5HU3GMx
         0jO5xRtzH79DajgetXxXr+RD3HS7vX5dgDpMR9QrJUfF0DC6BlyfQFsu4EGRRaY4kC
         B4D4j7B+BvhFqgW0Q/iBm1SQo15jl+QAJLok9HqHzGanpejxWn0BmBDgMOl84MeMgu
         IPcwJTMzKFF0w==
Subject: [PATCH 5/5] xfs: remove unused parameter from refcount code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Oct 2021 11:52:34 -0700
Message-ID: <163466955467.2235671.4983293287731225085.stgit@magnolia>
In-Reply-To: <163466952709.2235671.6966476326124447013.stgit@magnolia>
References: <163466952709.2235671.6966476326124447013.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The owner info parameter is always NULL, so get rid of the parameter.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index bb9e256f4970..327ba25e9e17 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -918,8 +918,7 @@ xfs_refcount_adjust_extents(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		*agbno,
 	xfs_extlen_t		*aglen,
-	enum xfs_refc_adjust_op	adj,
-	struct xfs_owner_info	*oinfo)
+	enum xfs_refc_adjust_op	adj)
 {
 	struct xfs_refcount_irec	ext, tmp;
 	int				error;
@@ -977,7 +976,7 @@ xfs_refcount_adjust_extents(
 						cur->bc_ag.pag->pag_agno,
 						tmp.rc_startblock);
 				xfs_free_extent_later(cur->bc_tp, fsbno,
-						  tmp.rc_blockcount, oinfo);
+						  tmp.rc_blockcount, NULL);
 			}
 
 			(*agbno) += tmp.rc_blockcount;
@@ -1021,8 +1020,8 @@ xfs_refcount_adjust_extents(
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 					cur->bc_ag.pag->pag_agno,
 					ext.rc_startblock);
-			xfs_free_extent_later(cur->bc_tp, fsbno, ext.rc_blockcount,
-					  oinfo);
+			xfs_free_extent_later(cur->bc_tp, fsbno,
+					ext.rc_blockcount, NULL);
 		}
 
 skip:
@@ -1050,8 +1049,7 @@ xfs_refcount_adjust(
 	xfs_extlen_t		aglen,
 	xfs_agblock_t		*new_agbno,
 	xfs_extlen_t		*new_aglen,
-	enum xfs_refc_adjust_op	adj,
-	struct xfs_owner_info	*oinfo)
+	enum xfs_refc_adjust_op	adj)
 {
 	bool			shape_changed;
 	int			shape_changes = 0;
@@ -1094,8 +1092,7 @@ xfs_refcount_adjust(
 		cur->bc_ag.refc.shape_changes++;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
-	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen,
-			adj, oinfo);
+	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen, adj);
 	if (error)
 		goto out_error;
 
@@ -1190,12 +1187,12 @@ xfs_refcount_finish_one(
 	switch (type) {
 	case XFS_REFCOUNT_INCREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
-			new_len, XFS_REFCOUNT_ADJUST_INCREASE, NULL);
+				new_len, XFS_REFCOUNT_ADJUST_INCREASE);
 		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
 		break;
 	case XFS_REFCOUNT_DECREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
-			new_len, XFS_REFCOUNT_ADJUST_DECREASE, NULL);
+				new_len, XFS_REFCOUNT_ADJUST_DECREASE);
 		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
 		break;
 	case XFS_REFCOUNT_ALLOC_COW:

