Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E332FA3740
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbiJ0Vyp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbiJ0Vyo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:54:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2C5357D4
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:54:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D96EEB827DE
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 21:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0E6C433D7;
        Thu, 27 Oct 2022 21:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666907679;
        bh=0AAmaYkTXqhCB3SlSruL6+M0/nnOMaUmxPMIwPX2TbQ=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=RmBWtTFS9f5ir7WusuaJeXaA6oMTCWgSbj3VqMOwTnC2BxY0NXB1OTqOdNcpX855H
         5q8kXUaZ2zxnkINS+XGX5jrhatpE1D/Qre6HL9s7TR58yLEeq8Vu7DxRF8VEfVHg8o
         ZIbScfA5QIcWEcIPs29EySCSUZWqVpg0QmCrT7c3UAdV9IA0r5eYB/zVxHpfu7xH+K
         iQ7lBpwZANsPtGUHrBVOZ74R/IYpDz6jqku2WkH0ZnwgmwDl5Km/RFLu5OJ70a9Ypu
         BCPSoM4dmSyInte8Z9YJAiTgkWPQSPy8py6IhLo1lSlpFX3gzfriPtLbj/P66uT14v
         Xxl4Bc6WgxmXA==
Date:   Thu, 27 Oct 2022 14:54:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2.1 02/12] xfs: check deferred refcount op continuation
 parameters
Message-ID: <Y1r+HuR+SkrqG4Zu@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689085464.3788582.2756559047908250104.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166689085464.3788582.2756559047908250104.stgit@magnolia>
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
v2.1: reduce local variables, elide calls when there's no continuation
---
 fs/xfs/libxfs/xfs_refcount.c |   40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 831353ba96dc..06de33a0a684 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1138,6 +1138,34 @@ xfs_refcount_finish_one_cleanup(
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
+
+	new_fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, new_fsbno, new_len)))
+		return -EFSCORRUPTED;
+
+	if (XFS_IS_CORRUPT(mp, pag->pag_agno != XFS_FSB_TO_AGNO(mp, new_fsbno)))
+		return -EFSCORRUPTED;
+
+	*fsbp = new_fsbno;
+	return 0;
+}
+
 /*
  * Process one of the deferred refcount operations.  We pass back the
  * btree cursor to maintain our lock on the btree between calls.
@@ -1205,12 +1233,20 @@ xfs_refcount_finish_one(
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
