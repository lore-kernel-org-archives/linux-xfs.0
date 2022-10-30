Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D86ECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJ3Xlg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3Xlf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:41:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BBA9FED
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:41:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42ABD60F95
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DC9C433D6;
        Sun, 30 Oct 2022 23:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173293;
        bh=1F1kRdPdcfMhjOgQrHcVb8JKfXt0k9Cb9NlQQ09BH24=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gb+DseexTqHmOFyfje5AE5fEK92RLudZSRFSuY8H7ClTeu6sP7+19yw6qcUr91Nht
         beg8fIJboNiV0KCiyWtbplmCftsGzkYUe4jO1MXdzUyanMhtTiOykVC+hWh/h/Ab4Z
         iND5fgt79fu2SeFeCb/JwiMu0rgH7S1AQ4ic+xCkb2w96SyifrMG/pbms5BT5gph0H
         2h0I3dRWncEQsnc/R8Th9usBErREIVJ1Nu5qCJ8lpf+XRCpfaXLOTybxgOxZ95P72C
         t7fATfbNpZBMCrooiQOoSBAcGMtiWeSq1AuPuzdK+D6jm0QrYnnm0UaIYLxYBIENoe
         meNx1RgBvFbSw==
Subject: [PATCH 02/13] xfs: create a predicate to verify per-AG extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:41:33 -0700
Message-ID: <166717329319.417886.15868613353170498219.stgit@magnolia>
In-Reply-To: <166717328145.417886.10627661186183843873.stgit@magnolia>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a predicate function to verify that a given agbno/blockcount pair
fit entirely within a single allocation group and don't suffer
mathematical overflows.  Refactor the existng open-coded logic; we're
going to add more calls to this function in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.h       |   15 +++++++++++++++
 fs/xfs/libxfs/xfs_alloc.c    |    6 +-----
 fs/xfs/libxfs/xfs_refcount.c |    6 +-----
 fs/xfs/libxfs/xfs_rmap.c     |    9 ++-------
 fs/xfs/scrub/alloc.c         |    4 +---
 fs/xfs/scrub/ialloc.c        |    5 ++---
 fs/xfs/scrub/refcount.c      |    5 ++---
 7 files changed, 24 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 517a138faa66..191b22b9a35b 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -133,6 +133,21 @@ xfs_verify_agbno(struct xfs_perag *pag, xfs_agblock_t agbno)
 	return true;
 }
 
+static inline bool
+xfs_verify_agbext(
+	struct xfs_perag	*pag,
+	xfs_agblock_t		agbno,
+	xfs_agblock_t		len)
+{
+	if (agbno + len <= agbno)
+		return false;
+
+	if (!xfs_verify_agbno(pag, agbno))
+		return false;
+
+	return xfs_verify_agbno(pag, agbno + len - 1);
+}
+
 /*
  * Verify that an AG inode number pointer neither points outside the AG
  * nor points at static metadata.
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6261599bb389..de79f5d07f65 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -263,11 +263,7 @@ xfs_alloc_get_rec(
 		goto out_bad_rec;
 
 	/* check for valid extent range, including overflow */
-	if (!xfs_verify_agbno(pag, *bno))
-		goto out_bad_rec;
-	if (*bno > *bno + *len)
-		goto out_bad_rec;
-	if (!xfs_verify_agbno(pag, *bno + *len - 1))
+	if (!xfs_verify_agbext(pag, *bno, *len))
 		goto out_bad_rec;
 
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 831353ba96dc..1a50ca53304a 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -135,11 +135,7 @@ xfs_refcount_get_rec(
 	}
 
 	/* check for valid extent range, including overflow */
-	if (!xfs_verify_agbno(pag, realstart))
-		goto out_bad_rec;
-	if (realstart > realstart + irec->rc_blockcount)
-		goto out_bad_rec;
-	if (!xfs_verify_agbno(pag, realstart + irec->rc_blockcount - 1))
+	if (!xfs_verify_agbext(pag, realstart, irec->rc_blockcount))
 		goto out_bad_rec;
 
 	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 094dfc897ebc..b56aca1e7c66 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -235,13 +235,8 @@ xfs_rmap_get_rec(
 			goto out_bad_rec;
 	} else {
 		/* check for valid extent range, including overflow */
-		if (!xfs_verify_agbno(pag, irec->rm_startblock))
-			goto out_bad_rec;
-		if (irec->rm_startblock >
-				irec->rm_startblock + irec->rm_blockcount)
-			goto out_bad_rec;
-		if (!xfs_verify_agbno(pag,
-				irec->rm_startblock + irec->rm_blockcount - 1))
+		if (!xfs_verify_agbext(pag, irec->rm_startblock,
+					    irec->rm_blockcount))
 			goto out_bad_rec;
 	}
 
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index ab427b4d7fe0..3b38f4e2a537 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -100,9 +100,7 @@ xchk_allocbt_rec(
 	bno = be32_to_cpu(rec->alloc.ar_startblock);
 	len = be32_to_cpu(rec->alloc.ar_blockcount);
 
-	if (bno + len <= bno ||
-	    !xfs_verify_agbno(pag, bno) ||
-	    !xfs_verify_agbno(pag, bno + len - 1))
+	if (!xfs_verify_agbext(pag, bno, len))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	xchk_allocbt_xref(bs->sc, bno, len);
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index e1026e07bf94..e312be7cd375 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -108,9 +108,8 @@ xchk_iallocbt_chunk(
 	xfs_agblock_t			bno;
 
 	bno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (bno + len <= bno ||
-	    !xfs_verify_agbno(pag, bno) ||
-	    !xfs_verify_agbno(pag, bno + len - 1))
+
+	if (!xfs_verify_agbext(pag, bno, len))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	xchk_iallocbt_chunk_xref(bs->sc, irec, agino, bno, len);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index c68b767dc08f..9959397f797f 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -354,9 +354,8 @@ xchk_refcountbt_rec(
 
 	/* Check the extent. */
 	bno &= ~XFS_REFC_COW_START;
-	if (bno + len <= bno ||
-	    !xfs_verify_agbno(pag, bno) ||
-	    !xfs_verify_agbno(pag, bno + len - 1))
+
+	if (!xfs_verify_agbext(pag, bno, len))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	if (refcount == 0)

