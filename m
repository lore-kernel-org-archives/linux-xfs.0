Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF84C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbiL3Wi1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3Wi0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:38:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2786D17E33
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:38:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C93AFB81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FF5C433D2;
        Fri, 30 Dec 2022 22:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439902;
        bh=w2X/+rUYxu/DDmq+k3pp0V7AD8LjlyZ7nI6b2G39VWI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FrY/K/rB09eCfIWlhu5Cdq1PAOn42h0SVq6HUPcW9x/5leGzr3g6aGBxpXUPFGq81
         iRT5kqRWKzBzNDFubW9hmRgm3Hdf1R/MuH+S5M1J6zVLhhy6Ko9mFn77l+o1UdNH9p
         CxSjtzQa1ACYjoOQnDX3X5UjOW7BqR3TlBr/fTWDOkRkbKuoVa3Md9BxHXKmA3uLJL
         hdhYhzZ4Nh05/DxJ6YIWGJbYKj36wEBhghQvBPHl5U8+QZMwYz28q/yr9fywD4xvoS
         VqR/TiL19g5r8/Gltb1c2yiJV/Ir8RoVdqUVHK1OGyFOi9SWNaLc7F5sQZ1iQhNfrc
         vDOwYiB/dohRw==
Subject: [PATCH 2/8] xfs: standardize ondisk to incore conversion for inode
 btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:11 -0800
Message-ID: <167243827159.683855.13707304181971939138.stgit@magnolia>
In-Reply-To: <167243827121.683855.6049797551028464473.stgit@magnolia>
References: <167243827121.683855.6049797551028464473.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a xfs_inobt_check_irec function to detect corruption in btree
records.  Fix all xfs_inobt_btrec_to_irec callsites to call the new
helper and bubble up corruption reports.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c       |   61 ++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_ialloc.h       |    2 +
 fs/xfs/libxfs/xfs_ialloc_btree.c |    2 +
 fs/xfs/libxfs/xfs_ialloc_btree.h |    2 +
 fs/xfs/scrub/ialloc.c            |   24 ++-------------
 5 files changed, 47 insertions(+), 44 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 5118dedf9267..010d1f514742 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -95,33 +95,21 @@ xfs_inobt_btrec_to_irec(
 	irec->ir_free = be64_to_cpu(rec->inobt.ir_free);
 }
 
-/*
- * Get the data from the pointed-to record.
- */
-int
-xfs_inobt_get_rec(
-	struct xfs_btree_cur		*cur,
-	struct xfs_inobt_rec_incore	*irec,
-	int				*stat)
+/* Simple checks for inode records. */
+xfs_failaddr_t
+xfs_inobt_check_irec(
+	struct xfs_btree_cur			*cur,
+	const struct xfs_inobt_rec_incore	*irec)
 {
-	struct xfs_mount		*mp = cur->bc_mp;
-	union xfs_btree_rec		*rec;
-	int				error;
 	uint64_t			realfree;
 
-	error = xfs_btree_get_rec(cur, &rec, stat);
-	if (error || *stat == 0)
-		return error;
-
-	xfs_inobt_btrec_to_irec(mp, rec, irec);
-
 	if (!xfs_verify_agino(cur->bc_ag.pag, irec->ir_startino))
-		goto out_bad_rec;
+		return __this_address;
 	if (irec->ir_count < XFS_INODES_PER_HOLEMASK_BIT ||
 	    irec->ir_count > XFS_INODES_PER_CHUNK)
-		goto out_bad_rec;
+		return __this_address;
 	if (irec->ir_freecount > XFS_INODES_PER_CHUNK)
-		goto out_bad_rec;
+		return __this_address;
 
 	/* if there are no holes, return the first available offset */
 	if (!xfs_inobt_issparse(irec->ir_holemask))
@@ -129,15 +117,41 @@ xfs_inobt_get_rec(
 	else
 		realfree = irec->ir_free & xfs_inobt_irec_to_allocmask(irec);
 	if (hweight64(realfree) != irec->ir_freecount)
+		return __this_address;
+
+	return NULL;
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+int
+xfs_inobt_get_rec(
+	struct xfs_btree_cur		*cur,
+	struct xfs_inobt_rec_incore	*irec,
+	int				*stat)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	union xfs_btree_rec		*rec;
+	xfs_failaddr_t			fa;
+	int				error;
+
+	error = xfs_btree_get_rec(cur, &rec, stat);
+	if (error || *stat == 0)
+		return error;
+
+	xfs_inobt_btrec_to_irec(mp, rec, irec);
+	fa = xfs_inobt_check_irec(cur, irec);
+	if (fa)
 		goto out_bad_rec;
 
 	return 0;
 
 out_bad_rec:
 	xfs_warn(mp,
-		"%s Inode BTree record corruption in AG %d detected!",
+		"%s Inode BTree record corruption in AG %d detected at %pS!",
 		cur->bc_btnum == XFS_BTNUM_INO ? "Used" : "Free",
-		cur->bc_ag.pag->pag_agno);
+		cur->bc_ag.pag->pag_agno, fa);
 	xfs_warn(mp,
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
@@ -2705,6 +2719,9 @@ xfs_ialloc_count_inodes_rec(
 	struct xfs_ialloc_count_inodes	*ci = priv;
 
 	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, &irec);
+	if (xfs_inobt_check_irec(cur, &irec) != NULL)
+		return -EFSCORRUPTED;
+
 	ci->count += irec.ir_count;
 	ci->freecount += irec.ir_freecount;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 9bbbca6ac4ed..fa67bb090c01 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -92,6 +92,8 @@ union xfs_btree_rec;
 void xfs_inobt_btrec_to_irec(struct xfs_mount *mp,
 		const union xfs_btree_rec *rec,
 		struct xfs_inobt_rec_incore *irec);
+xfs_failaddr_t xfs_inobt_check_irec(struct xfs_btree_cur *cur,
+		const struct xfs_inobt_rec_incore *irec);
 int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
 int xfs_ialloc_has_inode_record(struct xfs_btree_cur *cur, xfs_agino_t low,
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index fb10760fd686..e849faae405a 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -610,7 +610,7 @@ xfs_iallocbt_maxlevels_ondisk(void)
  */
 uint64_t
 xfs_inobt_irec_to_allocmask(
-	struct xfs_inobt_rec_incore	*rec)
+	const struct xfs_inobt_rec_incore	*rec)
 {
 	uint64_t			bitmap = 0;
 	uint64_t			inodespbit;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 26451cb76b98..6d8d6bcd594d 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -55,7 +55,7 @@ struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_mount *mp,
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 /* ir_holemask to inode allocation bitmap conversion */
-uint64_t xfs_inobt_irec_to_allocmask(struct xfs_inobt_rec_incore *);
+uint64_t xfs_inobt_irec_to_allocmask(const struct xfs_inobt_rec_incore *irec);
 
 #if defined(DEBUG) || defined(XFS_WARN)
 int xfs_inobt_rec_check_count(struct xfs_mount *,
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index fd5bc289de4c..9aec5a793397 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -119,15 +119,6 @@ xchk_iallocbt_chunk(
 	return true;
 }
 
-/* Count the number of free inodes. */
-static unsigned int
-xchk_iallocbt_freecount(
-	xfs_inofree_t			freemask)
-{
-	BUILD_BUG_ON(sizeof(freemask) != sizeof(__u64));
-	return hweight64(freemask);
-}
-
 /*
  * Check that an inode's allocation status matches ir_free in the inobt
  * record.  First we try querying the in-core inode state, and if the inode
@@ -431,24 +422,17 @@ xchk_iallocbt_rec(
 	int				holecount;
 	int				i;
 	int				error = 0;
-	unsigned int			real_freecount;
 	uint16_t			holemask;
 
 	xfs_inobt_btrec_to_irec(mp, rec, &irec);
-
-	if (irec.ir_count > XFS_INODES_PER_CHUNK ||
-	    irec.ir_freecount > XFS_INODES_PER_CHUNK)
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-
-	real_freecount = irec.ir_freecount +
-			(XFS_INODES_PER_CHUNK - irec.ir_count);
-	if (real_freecount != xchk_iallocbt_freecount(irec.ir_free))
+	if (xfs_inobt_check_irec(bs->cur, &irec) != NULL) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return 0;
+	}
 
 	agino = irec.ir_startino;
 	/* Record has to be properly aligned within the AG. */
-	if (!xfs_verify_agino(pag, agino) ||
-	    !xfs_verify_agino(pag, agino + XFS_INODES_PER_CHUNK - 1)) {
+	if (!xfs_verify_agino(pag, agino + XFS_INODES_PER_CHUNK - 1)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		goto out;
 	}

