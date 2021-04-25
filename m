Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FCD0C433B4
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Apr 2021 15:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC53A611B0
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Apr 2021 15:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhDYPrk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Apr 2021 11:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhDYPrj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 25 Apr 2021 11:47:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA6DE611B0
        for <linux-xfs@vger.kernel.org>; Sun, 25 Apr 2021 15:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619365619;
        bh=/W+TuSQzoLVdCNXPTFyxhBqEAG6lBVmvdCFhQY49tYE=;
        h=Date:From:To:Subject:From;
        b=ECav83dxc1/iI+CMSmWZtMR2zPRa0IJbbR7LGnCi55NeuITXN+Ff4F72oOyHAXarc
         DUTnzao4wzPUJeTsn6vSDd4dhTBT/CeSQ3amyLQWkBF09G3a9xfkJcxNIGaHDRNqg8
         Dt3ZgvLaz5tcnI849dKjhID+yJaC9ULdqFwYBbgwYnH1HTqB8RTtafjWiA2FctVkbV
         V+tOHXCqr8Jjw9632G6fy+ej4YrIHgYMo50Tg4T6snihNQyXpaOPkcme0f0ukp9oqV
         K5N8wTROYWEHOU7XfiS2wqprExbuuZeGnhbkuWQrrFkz3R8UzMmbGcZOVBZ0JGRAjC
         V1SvNnezkDJIg==
Date:   Sun, 25 Apr 2021 08:46:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: don't check agf_btreeblks on pre-lazysbcount filesystems
Message-ID: <20210425154659.GA3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The AGF free space btree block counter wasn't added until the
lazysbcount feature was added to XFS midway through the life of the V4
format, so ignore the field when checking.  Online AGF repair requires
rmapbt, so it doesn't need the feature check.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c   |    7 ++++++-
 fs/xfs/scrub/fscounters.c |    3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 749faa17f8e2..7a2f9b5f2db5 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -416,6 +416,10 @@ xchk_agf_xref_btreeblks(
 	xfs_agblock_t		btreeblks;
 	int			error;
 
+	/* agf_btreeblks didn't exist before lazysbcount */
+	if (!xfs_sb_version_haslazysbcount(&sc->mp->m_sb))
+		return;
+
 	/* Check agf_rmap_blocks; set up for agf_btreeblks check */
 	if (sc->sa.rmap_cur) {
 		error = xfs_btree_count_blocks(sc->sa.rmap_cur, &blocks);
@@ -581,7 +585,8 @@ xchk_agf(
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 	if (pag->pagf_flcount != be32_to_cpu(agf->agf_flcount))
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
-	if (pag->pagf_btreeblks != be32_to_cpu(agf->agf_btreeblks))
+	if (xfs_sb_version_haslazysbcount(&sc->mp->m_sb) &&
+	    pag->pagf_btreeblks != be32_to_cpu(agf->agf_btreeblks))
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 	xfs_perag_put(pag);
 
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 7b4386c78fbf..318b81c0f90d 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -182,7 +182,8 @@ xchk_fscount_aggregate_agcounts(
 		/* Add up the free/freelist/bnobt/cntbt blocks */
 		fsc->fdblocks += pag->pagf_freeblks;
 		fsc->fdblocks += pag->pagf_flcount;
-		fsc->fdblocks += pag->pagf_btreeblks;
+		if (xfs_sb_version_haslazysbcount(&sc->mp->m_sb))
+			fsc->fdblocks += pag->pagf_btreeblks;
 
 		/*
 		 * Per-AG reservations are taken out of the incore counters,
