Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9D2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbiLaBhZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbiLaBhZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:37:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75B313DD9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:37:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 830E8B81E34
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3788BC433EF;
        Sat, 31 Dec 2022 01:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450641;
        bh=wUPPK0fYbejmPKzElBD0aEvou/tbXT2CP47lVoEKwDk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q7K64zKTW0FchQ++nJVetaKNusfV5gPiyVlEswnrQxsp/7aWrH1kQW4ULp/i2wfUY
         FNohHkbMGLMj9/U4ApM/aS3In97ehHgibGNG4rQ+8Uug/53no4137mZygakId0vexO
         tYey6EJlOTiq/+Qr0ia834vVovOnlJ9YEmltgQKTqkSJM2qnoEksu6H7OUymNErTdV
         e1L0jDq6Iy0W3XdLa2tjQ/LLIpRgspFNXL0XgWZBK2NUqnb22++QYPupUKd1Ih3Vij
         6c/++eAyYtB9bEw68TUwA/bW8Vzllpq5Vj4swhl6c/m/FttkApCZrtlCwtGDhAF3Cf
         +KR60bg8U5OGw==
Subject: [PATCH 02/38] xfs: simplify the xfs_rmap_{alloc,free}_extent calling
 conventions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:16 -0800
Message-ID: <167243869629.715303.14412443667827419096.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Simplify the calling conventions by allowing callers to pass a fsbno
(xfs_fsblock_t) directly into these functions, since we're just going to
set it in a struct anyway.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |    6 ++----
 fs/xfs/libxfs/xfs_rmap.c     |   12 +++++-------
 fs/xfs/libxfs/xfs_rmap.h     |    8 ++++----
 fs/xfs/scrub/alloc_repair.c  |   10 +++++++---
 4 files changed, 18 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 2721c6076712..20c12cb7b7de 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1889,8 +1889,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1906,8 +1905,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
-			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 9ad3e5077f34..a2a863e0c7fb 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -526,7 +526,7 @@ xfs_rmap_free_check_owner(
 	struct xfs_btree_cur	*cur,
 	uint64_t		ltoff,
 	struct xfs_rmap_irec	*rec,
-	xfs_filblks_t		len,
+	xfs_extlen_t		len,
 	uint64_t		owner,
 	uint64_t		offset,
 	unsigned int		flags)
@@ -2745,8 +2745,7 @@ xfs_rmap_convert_extent(
 void
 xfs_rmap_alloc_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		fsbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
 {
@@ -2755,7 +2754,7 @@ xfs_rmap_alloc_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
@@ -2767,8 +2766,7 @@ xfs_rmap_alloc_extent(
 void
 xfs_rmap_free_extent(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
+	xfs_fsblock_t		fsbno,
 	xfs_extlen_t		len,
 	uint64_t		owner)
 {
@@ -2777,7 +2775,7 @@ xfs_rmap_free_extent(
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
 		return;
 
-	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
+	bmap.br_startblock = fsbno;
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 36af4de506c7..54c969731cf4 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -187,10 +187,10 @@ void xfs_rmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 void xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
-void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
-		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
-void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
-		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
+void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+		xfs_extlen_t len, uint64_t owner);
+void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
+		xfs_extlen_t len, uint64_t owner);
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 1e06ffe26029..6506fc202571 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -524,9 +524,13 @@ xrep_abt_dispose_one(
 	ASSERT(pag == resv->pag);
 
 	/* Add a deferred rmap for each extent we used. */
-	if (resv->used > 0)
-		xfs_rmap_alloc_extent(sc->tp, pag->pag_agno, resv->agbno,
-				resv->used, XFS_RMAP_OWN_AG);
+	if (resv->used > 0) {
+		xfs_fsblock_t	fsbno;
+
+		fsbno = XFS_AGB_TO_FSB(sc->mp, pag->pag_agno, resv->agbno);
+		xfs_rmap_alloc_extent(sc->tp, fsbno, resv->used,
+				XFS_RMAP_OWN_AG);
+	}
 
 	/*
 	 * For each reserved btree block we didn't use, add it to the free

