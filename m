Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FF2ECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJ3Xlo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3Xlm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:41:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0FC9FEA
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:41:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A365CB810A5
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A10BC433D7;
        Sun, 30 Oct 2022 23:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173299;
        bh=WlXLtFzOZlgeTfbtVbESGqTfAWUbZRN3OZ1QUwNspTg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lcrJQhKgplXzNOe97b9tw3HnYmRvExE+i+aLPFaGphzNoTB9VEyo4suVdj9BlP9iF
         mVKUVBh6G2SSEcRXqLz5Px2s2ddQKZliTv634I/knggjWbzgW/nBTAgCmqDfNO7EPj
         88c0M2oNRSOyUvE0GpA6Z7p3n1AbpJtufE+gGaQ7MZY4YTEOAc191jbbpNrV5U9Nrf
         dhwPD25BCc5uDjKA7oZ34xoPuG+80+kvsd/D4feTvqbOqs54Ccqi5RbzyKeh1/rqAW
         2L7AmJ3vDKZyv+NAjezxb5otOO9CndeXRH0Mq6fu86yLzrH+xctQk5yG8i+PjmlGFU
         i6eZNhAfdaQgw==
Subject: [PATCH 03/13] xfs: check deferred refcount op continuation parameters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:41:38 -0700
Message-ID: <166717329884.417886.372970393704654546.stgit@magnolia>
In-Reply-To: <166717328145.417886.10627661186183843873.stgit@magnolia>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_refcount.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 1a50ca53304a..542f749d0c6a 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1134,6 +1134,32 @@ xfs_refcount_finish_one_cleanup(
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
+	xfs_fsblock_t			*new_fsbno)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_perag		*pag = cur->bc_ag.pag;
+
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_agbext(pag, new_agbno, new_len)))
+		return -EFSCORRUPTED;
+
+	*new_fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+
+	ASSERT(xfs_verify_fsbext(mp, *new_fsbno, new_len));
+	ASSERT(pag->pag_agno == XFS_FSB_TO_AGNO(mp, *new_fsbno));
+
+	return 0;
+}
+
 /*
  * Process one of the deferred refcount operations.  We pass back the
  * btree cursor to maintain our lock on the btree between calls.
@@ -1201,12 +1227,20 @@ xfs_refcount_finish_one(
 	case XFS_REFCOUNT_INCREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
 				new_len, XFS_REFCOUNT_ADJUST_INCREASE);
-		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+		if (error)
+			goto out_drop;
+		if (*new_len > 0)
+			error = xfs_refcount_continue_op(rcur, startblock,
+					new_agbno, *new_len, new_fsb);
 		break;
 	case XFS_REFCOUNT_DECREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
 				new_len, XFS_REFCOUNT_ADJUST_DECREASE);
-		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+		if (error)
+			goto out_drop;
+		if (*new_len > 0)
+			error = xfs_refcount_continue_op(rcur, startblock,
+					new_agbno, *new_len, new_fsb);
 		break;
 	case XFS_REFCOUNT_ALLOC_COW:
 		*new_fsb = startblock + blockcount;

