Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465CDC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiL3Wnx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbiL3Wnw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:43:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AD812D26
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:43:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E614B81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BF6C433EF;
        Fri, 30 Dec 2022 22:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440229;
        bh=Vyv22cebcLtd2ZSALB1qU6+m/bGFNVTiwON197/y7CU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hsc/i254sY66cBpzkUqUipTTn5kwSIcaQvJeYTS4EN7fQU+wzCWBBbOurMo+WPuKm
         tHtRJ5VrRytroKSgrxiUBCrGCDBBApb0XxTUYZpfePQp7NplcpPu/Y9PPXsGbEYhRH
         e0ivWjW+BSQtf0NaZzjWkw11wbHsYZNvXsKhFabNtXTgUB/6AfWkUeoKs+IQ8tVgzK
         205kcWJyscnyh9t/WMwKo374D/jgmHQnGlCqx2cU8P1rKLu6iC4tc3wvbWJSOTVenb
         9fog5mV65jxNW1eiyq+Hk+oMTT2iXUs5vGSVMUEPXCcL6Ci8RBQskpTmmy3hlePHcl
         Hs4xby0KCgLeQ==
Subject: [PATCH 2/4] xfs: clean up broken eearly-exit code in the inode btree
 scrubber
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:29 -0800
Message-ID: <167243828920.684591.11266775527914452323.stgit@magnolia>
In-Reply-To: <167243828888.684591.12405031427937736396.stgit@magnolia>
References: <167243828888.684591.12405031427937736396.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Corrupt inode chunks should cause us to exit early after setting the
CORRUPT flag on the scrub state.  While we're at it, collapse trivial
helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/ialloc.c |   50 +++++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 5f04030b86c8..e5ce6a055ffe 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -79,43 +79,32 @@ xchk_iallocbt_chunk_xref_other(
 		xchk_btree_xref_set_corrupt(sc, *pcur, 0);
 }
 
-/* Cross-reference with the other btrees. */
-STATIC void
-xchk_iallocbt_chunk_xref(
-	struct xfs_scrub		*sc,
+/* Is this chunk worth checking and cross-referencing? */
+STATIC bool
+xchk_iallocbt_chunk(
+	struct xchk_btree		*bs,
 	struct xfs_inobt_rec_incore	*irec,
 	xfs_agino_t			agino,
-	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
-	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return;
+	struct xfs_scrub		*sc = bs->sc;
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_perag		*pag = bs->cur->bc_ag.pag;
+	xfs_agblock_t			agbno;
+
+	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+
+	if (!xfs_verify_agbext(pag, agbno, len))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return false;
 
 	xchk_xref_is_used_space(sc, agbno, len);
 	xchk_iallocbt_chunk_xref_other(sc, irec, agino);
 	xchk_xref_is_owned_by(sc, agbno, len, &XFS_RMAP_OINFO_INODES);
 	xchk_xref_is_not_shared(sc, agbno, len);
-}
-
-/* Is this chunk worth checking? */
-STATIC bool
-xchk_iallocbt_chunk(
-	struct xchk_btree		*bs,
-	struct xfs_inobt_rec_incore	*irec,
-	xfs_agino_t			agino,
-	xfs_extlen_t			len)
-{
-	struct xfs_mount		*mp = bs->cur->bc_mp;
-	struct xfs_perag		*pag = bs->cur->bc_ag.pag;
-	xfs_agblock_t			bno;
-
-	bno = XFS_AGINO_TO_AGBNO(mp, agino);
-
-	if (!xfs_verify_agbext(pag, bno, len))
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-
-	xchk_iallocbt_chunk_xref(bs->sc, irec, agino, bno, len);
-	xchk_xref_is_not_cow_staging(bs->sc, bno, len);
+	xchk_xref_is_not_cow_staging(sc, agbno, len);
 	return true;
 }
 
@@ -463,7 +452,7 @@ xchk_iallocbt_rec(
 		if (holemask & 1)
 			holecount += XFS_INODES_PER_HOLEMASK_BIT;
 		else if (!xchk_iallocbt_chunk(bs, &irec, agino, len))
-			break;
+			goto out;
 		holemask >>= 1;
 		agino += XFS_INODES_PER_HOLEMASK_BIT;
 	}
@@ -473,6 +462,9 @@ xchk_iallocbt_rec(
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 check_clusters:
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
 	error = xchk_iallocbt_check_clusters(bs, &irec);
 	if (error)
 		goto out;

