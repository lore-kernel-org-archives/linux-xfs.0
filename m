Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36FEC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiL3WsQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbiL3WsP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:48:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6D818E1D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:48:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65DA161B98
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB05C433D2;
        Fri, 30 Dec 2022 22:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440493;
        bh=YvduKITYQLysOZfOehPGaUEqSmlIeOQn1oMlna0q49E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jZysfg+EdXbxeKdqJbtwn4KTXHaUxFsXX3u1Vx1p3mo2WP1HFabmdgjCE9ZcZWeAh
         1vHeobEr6aobzidOAIHuk42jGPlpmkNQ31jLUvRjq8HMCEAlhU7jdyEqdBFr6z+KEf
         jO60D/VHHsHWmxpD814zKuxuqAOaC5hb7DBEEIPpuqdw5jg9qzd1kSvqQct8Q8rf1C
         AEFaKGy9ikF29zAYOyEKcy1Z+D/4pmmcPqFZoB11iDiLLRpVdGpVIfmUvjxRL1Ypv3
         BHt4DXm7kKGaCY/c+Kfkxew5znP+LX7iaBv1K97Q/CXynpUaiYOrpVda8X0BwsIjLi
         Fuc9kZmuqPWIQ==
Subject: [PATCH 6/6] xfs: check for reverse mapping records that could be
 merged
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:43 -0800
Message-ID: <167243830308.686829.2436455458356097769.stgit@magnolia>
In-Reply-To: <167243830218.686829.12866790282629472160.stgit@magnolia>
References: <167243830218.686829.12866790282629472160.stgit@magnolia>
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
index 270c4f1e76c9..3cb92f7ac165 100644
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
@@ -198,6 +204,51 @@ xchk_rmapbt_check_overlapping(
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
@@ -214,6 +265,7 @@ xchk_rmapbt_rec(
 	}
 
 	xchk_rmapbt_check_unwritten_in_keyflags(bs);
+	xchk_rmapbt_check_mergeable(bs, cr, &irec);
 	xchk_rmapbt_check_overlapping(bs, cr, &irec);
 	xchk_rmapbt_xref(bs->sc, &irec);
 	return 0;

