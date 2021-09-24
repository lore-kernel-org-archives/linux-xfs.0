Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34F2C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8956C61100
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243751AbhIXB2R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243740AbhIXB2R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:28:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4162B604E9;
        Fri, 24 Sep 2021 01:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446805;
        bh=ODdp7Qca5YOttj5LEc0yQDH0len8f/VOek5AfJ+0r24=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d0viapAyeyjb9pf61Bk4VEbXhjf60UvumZBaBi1Q5tYV2OH6ZAHalauwZhxjkA6C6
         evhrNLk8Y28TKEQO1UAnPfdVaWJ1y+yEhUxP5m3vtnbeKEw9gkAov+4LYKW7nr180u
         t182MYjTlSFAwszR/rHADDTikJ26T7W9GVnF51a5aJSqe+JgScL05vxQPOo7JBRvAk
         XS1BPSedCnrC2+i3ZXHQWR/6er6FZVv+LUv/86xiIA0QTzfRmtq2ZftBWLoH9ZAyeQ
         w/P2p9YihAsHapiFgBFqDNBN3B4QGqI3j4aTYlUUrHI8CbOgm9BAKaFuj6F22qgrMI
         rbzKlk8gSEPpA==
Subject: [PATCH 06/15] xfs: stricter btree height checking when looking for
 errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:26:45 -0700
Message-ID: <163244680498.2701302.305104585133892705.stgit@magnolia>
In-Reply-To: <163244677169.2701302.12882919857957905332.stgit@magnolia>
References: <163244677169.2701302.12882919857957905332.stgit@magnolia>
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
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
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
 

