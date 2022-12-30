Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD91C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbiL3WnW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbiL3WnV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:43:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0B112D26
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:43:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53E0EB81C06
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16966C433EF;
        Fri, 30 Dec 2022 22:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440198;
        bh=+5z9n9Dxx0Bv5OmwgBljIBAZYjUjlh49hHP75hmJNKo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dK61hsD672ekO34oyhXExfTI50dScINpM2/bKA2WZUa6ndmO3hKp2BDhJI72K+CwT
         uq9mjK15ocQlJ4hqULo0lGBLtWKaA4aWhPtnNN1tF3+pBeO1HYvMXLUiaYwhKm43l4
         4Z7gDMFDlUIOvObjAQDpE/PxJyV3QF/xVxXKSqoi19rWRD20gkw0A/Ng0QR4ETQbvV
         k9ZVl74jOxiyRTiSXaZz6uhiq5tk3klWmQ8gdMlmoYFrIpaUijSsmj6HhNkO1hbpJ0
         4kg+drIh/Vudyg5IwdfstcSjWmEK2Dba8aBaG4K1turShPBv2MS5M9voD+UYW2vpj9
         M7LvYy4dPveOQ==
Subject: [PATCH 6/6] xfs: ensure that all metadata and data blocks are not cow
 staging extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:26 -0800
Message-ID: <167243828598.684405.10197316668398155741.stgit@magnolia>
In-Reply-To: <167243828503.684405.18151259725784634316.stgit@magnolia>
References: <167243828503.684405.18151259725784634316.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that all filesystem metadata blocks and file data blocks are
not also marked as CoW staging extents.  The extra checking added here
was inspired by an actual VM host filesystem corruption incident due to
bugs in the CoW handling of 4.x kernels.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/agheader.c |    5 +++++
 fs/xfs/scrub/alloc.c    |    1 +
 fs/xfs/scrub/bmap.c     |   11 ++++++++---
 fs/xfs/scrub/ialloc.c   |    2 +-
 fs/xfs/scrub/inode.c    |    1 +
 fs/xfs/scrub/refcount.c |   21 +++++++++++++++++++++
 fs/xfs/scrub/scrub.h    |    2 ++
 7 files changed, 39 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 3dd9151a20ad..520ec054e4a6 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -53,6 +53,7 @@ xchk_superblock_xref(
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
 	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
+	xchk_xref_is_not_cow_staging(sc, agbno, 1);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
@@ -517,6 +518,7 @@ xchk_agf_xref(
 	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_agf_xref_btreeblks(sc);
 	xchk_xref_is_not_shared(sc, agbno, 1);
+	xchk_xref_is_not_cow_staging(sc, agbno, 1);
 	xchk_agf_xref_refcblks(sc);
 
 	/* scrub teardown will take care of sc->sa for us */
@@ -644,6 +646,7 @@ xchk_agfl_block_xref(
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
 	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_AG);
 	xchk_xref_is_not_shared(sc, agbno, 1);
+	xchk_xref_is_not_cow_staging(sc, agbno, 1);
 }
 
 /* Scrub an AGFL block. */
@@ -700,6 +703,7 @@ xchk_agfl_xref(
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
 	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
+	xchk_xref_is_not_cow_staging(sc, agbno, 1);
 
 	/*
 	 * Scrub teardown will take care of sc->sa for us.  Leave sc->sa
@@ -855,6 +859,7 @@ xchk_agi_xref(
 	xchk_agi_xref_icounts(sc);
 	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
+	xchk_xref_is_not_cow_staging(sc, agbno, 1);
 	xchk_agi_xref_fiblocks(sc);
 
 	/* scrub teardown will take care of sc->sa for us */
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index c72001f6bad9..e9f8d29544aa 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -90,6 +90,7 @@ xchk_allocbt_xref(
 	xchk_xref_is_not_inode_chunk(sc, agbno, len);
 	xchk_xref_has_no_owner(sc, agbno, len);
 	xchk_xref_is_not_shared(sc, agbno, len);
+	xchk_xref_is_not_cow_staging(sc, agbno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 575f2c80d055..abc2da0b1824 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -328,12 +328,17 @@ xchk_bmap_iextent_xref(
 	xchk_bmap_xref_rmap(info, irec, agbno);
 	switch (info->whichfork) {
 	case XFS_DATA_FORK:
-		if (xfs_is_reflink_inode(info->sc->ip))
-			break;
-		fallthrough;
+		if (!xfs_is_reflink_inode(info->sc->ip))
+			xchk_xref_is_not_shared(info->sc, agbno,
+					irec->br_blockcount);
+		xchk_xref_is_not_cow_staging(info->sc, agbno,
+				irec->br_blockcount);
+		break;
 	case XFS_ATTR_FORK:
 		xchk_xref_is_not_shared(info->sc, agbno,
 				irec->br_blockcount);
+		xchk_xref_is_not_cow_staging(info->sc, agbno,
+				irec->br_blockcount);
 		break;
 	case XFS_COW_FORK:
 		xchk_xref_is_cow_staging(info->sc, agbno,
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index b85f0cd00bc2..5f04030b86c8 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -115,7 +115,7 @@ xchk_iallocbt_chunk(
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	xchk_iallocbt_chunk_xref(bs->sc, irec, agino, bno, len);
-
+	xchk_xref_is_not_cow_staging(bs->sc, bno, len);
 	return true;
 }
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 8c972ee15a30..95694eca3851 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -558,6 +558,7 @@ xchk_inode_xref(
 	xchk_inode_xref_finobt(sc, ino);
 	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_INODES);
 	xchk_xref_is_not_shared(sc, agbno, 1);
+	xchk_xref_is_not_cow_staging(sc, agbno, 1);
 	xchk_inode_xref_bmap(sc, dip);
 
 out_free:
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 10ef377873f6..e99c1e1246f8 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -555,3 +555,24 @@ xchk_xref_is_not_shared(
 	if (outcome != XBTREE_RECPACKING_EMPTY)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 }
+
+/* xref check that the extent is not being used for CoW staging. */
+void
+xchk_xref_is_not_cow_staging(
+	struct xfs_scrub	*sc,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len)
+{
+	enum xbtree_recpacking	outcome;
+	int			error;
+
+	if (!sc->sa.refc_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	error = xfs_refcount_has_records(sc->sa.refc_cur, XFS_REFC_DOMAIN_COW,
+			agbno, len, &outcome);
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
+		return;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 85c055c2ddc5..a331838e22ff 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -166,6 +166,8 @@ void xchk_xref_is_cow_staging(struct xfs_scrub *sc, xfs_agblock_t bno,
 		xfs_extlen_t len);
 void xchk_xref_is_not_shared(struct xfs_scrub *sc, xfs_agblock_t bno,
 		xfs_extlen_t len);
+void xchk_xref_is_not_cow_staging(struct xfs_scrub *sc, xfs_agblock_t bno,
+		xfs_extlen_t len);
 #ifdef CONFIG_XFS_RT
 void xchk_xref_is_used_rt_space(struct xfs_scrub *sc, xfs_rtblock_t rtbno,
 		xfs_extlen_t len);

