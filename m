Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8086C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiJBSg2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiJBSg0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:36:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E1E3B949
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:36:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3593960F04
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDB9C433C1;
        Sun,  2 Oct 2022 18:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735784;
        bh=FurszeHmIic3q3wnRPvexm+049Xqq/0ezG1b9NBAn40=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Yylo+oOZX67GnkErrrb5icuCuMyLzx74DPerOqmIYhcfPwlKTeGZ1brdwjABUWjnI
         6G56GX/QxdCw+JVbi4NTbibTWwLIJkXzu82kZjuMT5oCt/EGo3aQ3CeQHYI1WDf3UD
         pJh2YmcfGnQDVN+6P5nqi3YAkIrfjr4qSNKFvvZTmHHOo5XiojvLWaaHKfK8z+wB/y
         6Ada9lGVJ7+XIVztdyQVSDx3N/H+PTmE3lsCI7WgB5uCg5k2UhMkOYp1ur9GKf+CCs
         GQF8IguLbFjtLp7ssYIF11R5hSIArPhdutNSYg3VI9zJTNVAVmc9EKpCT3GtsMjdDW
         ypdXeX/pdzsMw==
Subject: [PATCH 6/6] xfs: check for reverse mapping records that could be
 merged
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:36 -0700
Message-ID: <166473483687.1084923.4272579683695514551.stgit@magnolia>
In-Reply-To: <166473483595.1084923.1946295148534639238.stgit@magnolia>
References: <166473483595.1084923.1946295148534639238.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enhance the rmap scrubber to flag adjacent records that could be merged.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rmap.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)


diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index efb13a21afbc..76ac2279e37d 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -39,6 +39,12 @@ struct xchk_rmap {
 	 * allocations that cannot be shared.
 	 */
 	struct xfs_rmap_irec	overlap_rec;
+
+	/*
+	 * The previous rmapbt record, so that we can check for two records
+	 * that could be one.
+	 */
+	struct xfs_rmap_irec	prev_rec;
 };
 
 /* Cross-reference a rmap against the refcount btree. */
@@ -146,6 +152,51 @@ xchk_rmapbt_check_overlapping(
 	memcpy(&cr->overlap_rec, irec, sizeof(struct xfs_rmap_irec));
 }
 
+/* Decide if two reverse-mapping records can be merged. */
+static inline bool
+xchk_rmap_mergeable(
+	struct xchk_rmap		*cr,
+	const struct xfs_rmap_irec	*r2)
+{
+	const struct xfs_rmap_irec	*r1 = &cr->prev_rec;
+
+	/* Ignore if prev_rec is not yet initialized. */
+	if (cr->prev_rec.rm_blockcount == 0)
+		return false;
+
+	if (r1->rm_owner != r2->rm_owner)
+		return false;
+	if (r1->rm_startblock + r1->rm_blockcount != r2->rm_startblock)
+		return false;
+	if ((unsigned long long)r1->rm_blockcount + r2->rm_blockcount >
+	    XFS_RMAP_LEN_MAX)
+		return false;
+	if (XFS_RMAP_NON_INODE_OWNER(r2->rm_owner))
+		return true;
+	/* must be an inode owner below here */
+	if (r1->rm_flags != r2->rm_flags)
+		return false;
+	if (r1->rm_flags & XFS_RMAP_BMBT_BLOCK)
+		return true;
+	return r1->rm_offset + r1->rm_blockcount == r2->rm_offset;
+}
+
+/* Flag failures for records that could be merged. */
+STATIC void
+xchk_rmapbt_check_mergeable(
+	struct xchk_btree		*bs,
+	struct xchk_rmap		*cr,
+	const struct xfs_rmap_irec	*irec)
+{
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	if (xchk_rmap_mergeable(cr, irec))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	memcpy(&cr->prev_rec, irec, sizeof(struct xfs_rmap_irec));
+}
+
 /* Scrub an rmapbt record. */
 STATIC int
 xchk_rmapbt_rec(
@@ -218,6 +269,7 @@ xchk_rmapbt_rec(
 			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 	}
 
+	xchk_rmapbt_check_mergeable(bs, cr, &irec);
 	xchk_rmapbt_check_overlapping(bs, cr, &irec);
 	xchk_rmapbt_xref(bs->sc, &irec);
 out:

