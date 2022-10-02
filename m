Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95891C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJBSdG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiJBSdG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:33:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5C73C164
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:33:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74AA760F06
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EF0C433C1;
        Sun,  2 Oct 2022 18:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735583;
        bh=9LC0Q+6q/Ui9YuTSEdv7h1fks63FG3O5KK4KLnD+bzM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bMJ0xUGbjOUHIh/6cSWh4q+rnMXweDuXoAqONSFKeG2foiDrxidcgQU9p0bPxOR8U
         OEl8ne53Tuvi2sXs6xIiS07gWE7aSoEH21nTUODsyoa9V8P2NmxxttZMmFXtZvkoRD
         18M7TAaB97d+STMusqqszCLFIJnacjayw2X3lKpXNuay3NqnqKQc0P2rZnWHzRvAyf
         bBaZnopGZye1Hc2kBkSjCZtTqENFW/SbYerC2bRrrPnh5CwdKRCKQ1q0eH8Hf6jT4i
         llR1F1W/zGgEJNdahQvUgXE2ur0rslJoCkqpAFfdPWpYZuVRD77yQ+qlF3Drk2Uar/
         P5xDbZLBrn1Mg==
Subject: [PATCH 5/5] xfs: ensure that all metadata and data blocks are not cow
 staging extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:16 -0700
Message-ID: <166473481655.1084209.12908049694500649697.stgit@magnolia>
In-Reply-To: <166473481572.1084209.5434516873607335909.stgit@magnolia>
References: <166473481572.1084209.5434516873607335909.stgit@magnolia>
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
index d8f2ba7efa22..0cd20d998368 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -88,6 +88,7 @@ xchk_allocbt_xref(
 	xchk_xref_is_not_inode_chunk(sc, agbno, len);
 	xchk_xref_has_no_owner(sc, agbno, len);
 	xchk_xref_is_not_shared(sc, agbno, len);
+	xchk_xref_is_not_cow_staging(sc, agbno, len);
 }
 
 /* Scrub a bnobt/cntbt record. */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 5c4b25585b8c..1e4813c82cc5 100644
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
index 0b27c3520b74..efe346ddd1b7 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -116,7 +116,7 @@ xchk_iallocbt_chunk(
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	xchk_iallocbt_chunk_xref(bs->sc, irec, agino, bno, len);
-
+	xchk_xref_is_not_cow_staging(bs->sc, bno, len);
 	return true;
 }
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 998bf06d2347..a68ba8684465 100644
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
index d97e7e372b9c..2009efea923c 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -562,3 +562,24 @@ xchk_xref_is_not_shared(
 	if (keyfill != XFS_BTREE_KEYFILL_EMPTY)
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
+	enum xfs_btree_keyfill	keyfill;
+	int			error;
+
+	if (!sc->sa.refc_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	error = xfs_refcount_scan_keyfill(sc->sa.refc_cur, agbno +
+			XFS_REFC_COW_START, len, &keyfill);
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
+		return;
+	if (keyfill != XFS_BTREE_KEYFILL_EMPTY)
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

