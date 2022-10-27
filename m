Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067D8ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbiJ0ROR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbiJ0ROR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:14:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3CF1A4022
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 10:14:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0DEC623F9
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 17:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21439C433D6;
        Thu, 27 Oct 2022 17:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890855;
        bh=2/SFh18dvCiIXqJPOqGgb4rQHQSU8sUhsmo+YTBjBJU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KIPR8VcevT2eHuJaz9p71sMin6TCHo3guKTQCXQx7si9ibyHCqiFoVsRc1hA29i2F
         KET03VxZURvVXXuxwo9Dr1txQcQiRJjwr2Si/1k6gmqnR7dj/opEM/8JPap3PWjwQY
         6E4RB46PrHB5LNfbQcyG9OzftEmPwUVAaTlCFz3GSIcCtgHpsOx8IjO9FIJxp3s61o
         eTkOIJybGvgvZ4f9arPg6DFndSzJdLFOJ5A8rkofAL4CJg47f0YqaykkDAfd3T6mal
         xK4zYc77fZ1d2jOinVDuLwu9M6EHaW2xQhGXq+1g4YAgI2i3GmqMi37O9VeEZK4BNe
         nDwPjETdh6ukw==
Subject: [PATCH 02/12] xfs: check deferred refcount op continuation parameters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:14:14 -0700
Message-ID: <166689085464.3788582.2756559047908250104.stgit@magnolia>
In-Reply-To: <166689084304.3788582.15155501738043912776.stgit@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we're in the middle of a deferred refcount operation and decide to
roll the transaction to avoid overflowing the transaction space, we need
to check the new agbno/aglen parameters that we're about to record in
the new intent.  Specifically, we need to check that the new extent is
completely within the filesystem, and that continuation does not put us
into a different AG.

If the keys of a node block are wrong, the lookup to resume an
xfs_refcount_adjust_extents operation can put us into the wrong record
block.  If this happens, we might not find that we run out of aglen at
an exact record boundary, which will cause the loop control to do the
wrong thing.

The previous patch should take care of that problem, but let's add this
extra sanity check to stop corruption problems sooner than later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   48 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 831353ba96dc..c6aa832a8713 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1138,6 +1138,44 @@ xfs_refcount_finish_one_cleanup(
 		xfs_trans_brelse(tp, agbp);
 }
 
+/*
+ * Set up a continuation a deferred refcount operation by updating the intent.
+ * Checks to make sure we're not going to run off the end of the AG.
+ */
+static inline int
+xfs_refcount_continue_op(
+	struct xfs_btree_cur		*cur,
+	xfs_fsblock_t			startblock,
+	xfs_agblock_t			new_agbno,
+	xfs_extlen_t			new_len,
+	xfs_fsblock_t			*fsbp)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_perag		*pag = cur->bc_ag.pag;
+	xfs_fsblock_t			new_fsbno;
+	xfs_agnumber_t			old_agno;
+
+	old_agno = XFS_FSB_TO_AGNO(mp, startblock);
+	new_fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+
+	/*
+	 * If we don't have any work left to do, then there's no need
+	 * to perform the validation of the new parameters.
+	 */
+	if (!new_len)
+		goto done;
+
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, new_fsbno, new_len)))
+		return -EFSCORRUPTED;
+
+	if (XFS_IS_CORRUPT(mp, old_agno != XFS_FSB_TO_AGNO(mp, new_fsbno)))
+		return -EFSCORRUPTED;
+
+done:
+	*fsbp = new_fsbno;
+	return 0;
+}
+
 /*
  * Process one of the deferred refcount operations.  We pass back the
  * btree cursor to maintain our lock on the btree between calls.
@@ -1205,12 +1243,18 @@ xfs_refcount_finish_one(
 	case XFS_REFCOUNT_INCREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
 				new_len, XFS_REFCOUNT_ADJUST_INCREASE);
-		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+		if (error)
+			goto out_drop;
+		error = xfs_refcount_continue_op(rcur, startblock, new_agbno,
+				*new_len, new_fsb);
 		break;
 	case XFS_REFCOUNT_DECREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
 				new_len, XFS_REFCOUNT_ADJUST_DECREASE);
-		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+		if (error)
+			goto out_drop;
+		error = xfs_refcount_continue_op(rcur, startblock, new_agbno,
+				*new_len, new_fsb);
 		break;
 	case XFS_REFCOUNT_ALLOC_COW:
 		*new_fsb = startblock + blockcount;

