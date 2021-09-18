Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50480C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 347286112E
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhIRBaz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234491AbhIRBay (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:30:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16A2960FBF;
        Sat, 18 Sep 2021 01:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928572;
        bh=ikFCyOytKcPdRQFStzh9UtWulVY1CfifxapE/vtYPo0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PzTHQMzQpva1rLO70Fh1IzIhjjoD7PKORhYDC29Fx97zySNIrqzHVs4770whuIyE7
         3459k/3t7fpTV6AsxY/Nf1lrK3h0TcFN2ZriDEqRjgI3LTtwNakM5xKJO0xRkZJ6ke
         6ebuHJ2T1pLtYQeVB3kdqkWjm5/I3qsd/KMbEtOSkKXERfDgtIb9BTs8n8a9RJ+vam
         y5iF+TefNOiyP8SLxEN9bfpggH+Lks3iKDCtIb05pMHv5pmlBzpJmACvKCA/cmZaEm
         i9yA5AsgHTOuw5pW2IqGtpDf/jLCixaxy4G2KqbR+FdZqHP1bM/s/QTSYV7R24FQpe
         +owgoJIs1Ryfg==
Subject: [PATCH 04/14] xfs: stricter btree height checking when looking for
 errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:29:31 -0700
Message-ID: <163192857182.416199.9310383108874723785.stgit@magnolia>
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

Since each btree type has its own precomputed maxlevels variable now,
use them instead of the generic XFS_BTREE_MAXLEVELS to check the level
of each per-AG btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index ae3c9f6e2c69..a2c3af77b6c2 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -555,11 +555,11 @@ xchk_agf(
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
-	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+	if (level <= 0 || level > mp->m_ag_maxlevels)
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
-	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+	if (level <= 0 || level > mp->m_ag_maxlevels)
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	if (xfs_has_rmapbt(mp)) {
@@ -568,7 +568,7 @@ xchk_agf(
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 		level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
-		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+		if (level <= 0 || level > mp->m_rmap_maxlevels)
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 	}
 
@@ -578,7 +578,7 @@ xchk_agf(
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 		level = be32_to_cpu(agf->agf_refcount_level);
-		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+		if (level <= 0 || level > mp->m_refc_maxlevels)
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 	}
 
@@ -850,6 +850,7 @@ xchk_agi(
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_agi		*agi;
 	struct xfs_perag	*pag;
+	struct xfs_ino_geometry	*igeo = M_IGEO(sc->mp);
 	xfs_agnumber_t		agno = sc->sm->sm_agno;
 	xfs_agblock_t		agbno;
 	xfs_agblock_t		eoag;
@@ -880,7 +881,7 @@ xchk_agi(
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	level = be32_to_cpu(agi->agi_level);
-	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+	if (level <= 0 || level > igeo->inobt_maxlevels)
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	if (xfs_has_finobt(mp)) {
@@ -889,7 +890,7 @@ xchk_agi(
 			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 		level = be32_to_cpu(agi->agi_free_level);
-		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
+		if (level <= 0 || level > igeo->inobt_maxlevels)
 			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 	}
 

