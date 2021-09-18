Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DABA2C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C551061152
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbhIRBbW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234515AbhIRBbW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74E8760FBF;
        Sat, 18 Sep 2021 01:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928599;
        bh=hF1uzI4Sf8Onq+nZo2VRS0Bn9y/+ew9SsFSjtG+Spsc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LW8Jkn+KVk/Bc1EBlJ/bshFa2v6Oa79rzConSkKuCe6PM/nf0qzzYijgnCm/izivC
         CYUC+6MoS/bA6fQmlwuyTREm+X2zhRNmxDXJWYmg0ehBx5t3zxuUplIvEZgyahMBtZ
         Zyi0SpuFhJxSa2nCqMZb99CHjcQcr7/P66ukKtzY0W/brdDGwuV4H0D+f/VoaB4sCi
         iSwQ6aHQ3O4bzFGM6cMttEewHLEeaoXyrH9tqWSU+hiI3+BrPybwDkecQO4AS+pmKM
         ATtkn11Mwr1mphGIdd4maOTqZmsBRlzxRKyrhdRONJ8Q+OAM7h3djArO7CR15YR1+5
         MNBYQ1aSauJeQ==
Subject: [PATCH 09/14] xfs: fix maxlevels comparisons in the btree staging
 code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:29:59 -0700
Message-ID: <163192859919.416199.9790046292707106095.stgit@magnolia>
In-Reply-To: <163192854958.416199.3396890438240296942.stgit@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The btree geometry computation function has an off-by-one error in that
it does not allow maximally tall btrees (nlevels == XFS_BTREE_MAXLEVELS).
This can result in repairs failing unnecessarily on very fragmented
filesystems.  Subsequent patches to remove MAXLEVELS usage in favor of
the per-btree type computations will make this a much more likely
occurrence.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_staging.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 26143297bb7b..cc56efc2b90a 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -662,7 +662,7 @@ xfs_btree_bload_compute_geometry(
 	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
 
 	bbl->nr_records = nr_this_level = nr_records;
-	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
+	for (cur->bc_nlevels = 1; cur->bc_nlevels <= XFS_BTREE_MAXLEVELS;) {
 		uint64_t	level_blocks;
 		uint64_t	dontcare64;
 		unsigned int	level = cur->bc_nlevels - 1;
@@ -726,7 +726,7 @@ xfs_btree_bload_compute_geometry(
 		nr_this_level = level_blocks;
 	}
 
-	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
+	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS)
 		return -EOVERFLOW;
 
 	bbl->btree_height = cur->bc_nlevels;

