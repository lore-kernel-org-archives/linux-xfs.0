Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87C9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbiLaBUR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236057AbiLaBUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:20:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9AD1AD9A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADEF5B81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B613C433EF;
        Sat, 31 Dec 2022 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449612;
        bh=odV/N2q7tLlcZIdphjsrtfxkZOoTtEEemxlm7HKhzWA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZE9otFKOevhVSWvQ22ERIe3VxdRW114ucZA/mlTjUy3UtiZnCcEYVGtFRzvDOlse4
         SMvpITJyW33SqdpoUCn9xW1xBjqcXomNhSnYsaJ8vtGOTN89ITvmcaUj24Iy2hTwjv
         ktLN2PXX+nFs00RuOz9oBTLYUJXfp61A3IrhKNDetxUxdC+2in9eDUCjn0LDpXH/JN
         LCHSL7JhIsJmS+ih9Tyuz+97PTDTrBvif17iIecI5jGBlhH4NjV2CHhhP6h1GT+U7X
         YJdE8VqKGvn7wCrFTFdrYvbPUElm+QrLKHv5uqW/it5NkiCHXGgQGgjOK2OOoY+oUH
         VC8BHVWQx9ZJQ==
Subject: [PATCH 01/11] xfs: refactor realtime scrubbing context management
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:36 -0800
Message-ID: <167243865631.709511.1793171660440985926.stgit@magnolia>
In-Reply-To: <167243865605.709511.15650588946095003543.stgit@magnolia>
References: <167243865605.709511.15650588946095003543.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a pair of helpers to deal with setting up the necessary incore
context to check metadata records against the realtime metadata.  Right
now this is limited to locking the realtime bitmap and summary inodes,
but as we add rmap and reflink to the realtime device this will grow to
include btree cursors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c      |    2 ++
 fs/xfs/scrub/common.c    |   58 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h    |   17 +++++++++++++
 fs/xfs/scrub/rtbitmap.c  |    7 ++----
 fs/xfs/scrub/rtsummary.c |   24 +++++--------------
 fs/xfs/scrub/scrub.c     |    1 +
 fs/xfs/scrub/scrub.h     |    9 +++++++
 7 files changed, 95 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 150b8c40b809..47d6bae9d6da 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -318,8 +318,10 @@ xchk_bmap_rt_iextent_xref(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
+	xchk_rt_init(info->sc, &info->sc->sr, XCHK_RTLOCK_BITMAP_SHARED);
 	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
 			irec->br_blockcount);
+	xchk_rt_unlock(info->sc, &info->sc->sr);
 }
 
 /* Cross-reference a single datadev extent record. */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index b9c4f335cd8e..4de13f8f4277 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -671,6 +671,64 @@ xchk_ag_init(
 	return 0;
 }
 
+/*
+ * For scrubbing a realtime file, grab all the in-core resources we'll need to
+ * check the realtime metadata, which means taking the ILOCK of the realtime
+ * metadata inodes.  Callers must not join these inodes to the transaction
+ * with non-zero lockflags or concurrency problems will result.  The
+ * @rtlock_flags argument takes XCHK_RTLOCK_* flags because scrub has somewhat
+ * unusual locking requirements.
+ */
+void
+xchk_rt_init(
+	struct xfs_scrub	*sc,
+	struct xchk_rt		*sr,
+	unsigned int		rtlock_flags)
+{
+	ASSERT(!(rtlock_flags & ~XCHK_RTLOCK_ALL));
+	ASSERT(hweight32(rtlock_flags & (XCHK_RTLOCK_BITMAP |
+					 XCHK_RTLOCK_BITMAP_SHARED)) < 2);
+	ASSERT(hweight32(rtlock_flags & (XCHK_RTLOCK_SUMMARY |
+					 XCHK_RTLOCK_SUMMARY_SHARED)) < 2);
+
+	if (rtlock_flags & XCHK_RTLOCK_BITMAP)
+		xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	else if (rtlock_flags & XCHK_RTLOCK_BITMAP_SHARED)
+		xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+
+	if (rtlock_flags & XCHK_RTLOCK_SUMMARY)
+		xfs_ilock(sc->mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+	else if (rtlock_flags & XCHK_RTLOCK_SUMMARY_SHARED)
+		xfs_ilock(sc->mp->m_rsumip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
+
+	sr->rtlock_flags = rtlock_flags;
+}
+
+/*
+ * Unlock the realtime metadata inodes.  This must be done /after/ committing
+ * (or cancelling) the scrub transaction.
+ */
+void
+xchk_rt_unlock(
+	struct xfs_scrub	*sc,
+	struct xchk_rt		*sr)
+{
+	if (!sr->rtlock_flags)
+		return;
+
+	if (sr->rtlock_flags & XCHK_RTLOCK_SUMMARY)
+		xfs_iunlock(sc->mp->m_rsumip, XFS_ILOCK_EXCL);
+	else if (sr->rtlock_flags & XCHK_RTLOCK_SUMMARY)
+		xfs_iunlock(sc->mp->m_rsumip, XFS_ILOCK_SHARED);
+
+	if (sr->rtlock_flags & XCHK_RTLOCK_BITMAP)
+		xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_EXCL);
+	else if (sr->rtlock_flags & XCHK_RTLOCK_BITMAP_SHARED)
+		xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED);
+
+	sr->rtlock_flags = 0;
+}
+
 /* Per-scrubber setup functions */
 
 void
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 9bdacce17d82..e41224065421 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -152,6 +152,23 @@ xchk_ag_init_existing(
 	return error == -ENOENT ? -EFSCORRUPTED : error;
 }
 
+/* Lock the rt bitmap in exclusive mode */
+#define XCHK_RTLOCK_BITMAP		(1U << 31)
+/* Lock the rt bitmap in shared mode */
+#define XCHK_RTLOCK_BITMAP_SHARED	(1U << 30)
+/* Lock the rt summary in exclusive mode */
+#define XCHK_RTLOCK_SUMMARY		(1U << 29)
+/* Lock the rt summary in shared mode */
+#define XCHK_RTLOCK_SUMMARY_SHARED	(1U << 28)
+
+#define XCHK_RTLOCK_ALL		(XCHK_RTLOCK_BITMAP | \
+				 XCHK_RTLOCK_BITMAP_SHARED | \
+				 XCHK_RTLOCK_SUMMARY | \
+				 XCHK_RTLOCK_SUMMARY_SHARED)
+
+void xchk_rt_init(struct xfs_scrub *sc, struct xchk_rt *sr,
+		unsigned int xchk_rtlock_flags);
+void xchk_rt_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
 int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		struct xchk_ag *sa);
 void xchk_ag_btcur_free(struct xchk_ag *sa);
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 1d84a9eed67c..e524055ba709 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -44,7 +44,7 @@ xchk_setup_rtbitmap(
 	if (error)
 		return error;
 
-	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	xchk_rt_init(sc, &sc->sr, XCHK_RTLOCK_BITMAP);
 	return 0;
 }
 
@@ -157,13 +157,10 @@ xchk_xref_is_used_rt_space(
 	do_div(startext, sc->mp->m_sb.sb_rextsize);
 	do_div(endext, sc->mp->m_sb.sb_rextsize);
 	extcount = endext - startext + 1;
-	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext, extcount,
 			&is_free);
 	if (!xchk_should_check_xref(sc, &error, NULL))
-		goto out_unlock;
+		return;
 	if (is_free)
 		xchk_ino_xref_set_corrupt(sc, sc->mp->m_rbmip->i_ino);
-out_unlock:
-	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 }
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 7d1bc49fb3dd..c0bf65273f1a 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -75,14 +75,8 @@ xchk_setup_rtsummary(
 	if (error)
 		return error;
 
-	/*
-	 * Locking order requires us to take the rtbitmap first.  We must be
-	 * careful to unlock it ourselves when we are done with the rtbitmap
-	 * file since the scrub infrastructure won't do that for us.  Only
-	 * then we can lock the rtsummary inode.
-	 */
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
-	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+	xchk_rt_init(sc, &sc->sr,
+			XCHK_RTLOCK_SUMMARY | XCHK_RTLOCK_BITMAP_SHARED);
 	return 0;
 }
 
@@ -248,7 +242,7 @@ xchk_rtsummary(
 	/* Invoke the fork scrubber. */
 	error = xchk_metadata_inode_forks(sc);
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
-		goto out_rbm;
+		return error;
 
 	/* Construct the new summary file from the rtbitmap. */
 	error = xchk_rtsum_compute(sc);
@@ -258,17 +252,11 @@ xchk_rtsummary(
 		 * error since we're checking the summary file.
 		 */
 		xchk_ino_xref_set_corrupt(sc, mp->m_rbmip->i_ino);
-		error = 0;
-		goto out_rbm;
+		return 0;
 	}
 	if (error)
-		goto out_rbm;
+		return error;
 
 	/* Does the computed summary file match the actual rtsummary file? */
-	error = xchk_rtsum_compare(sc);
-
-out_rbm:
-	/* Unlock the rtbitmap since we're done with it. */
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
-	return error;
+	return xchk_rtsum_compare(sc);
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a596789e463d..1b3820b30384 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -189,6 +189,7 @@ xchk_teardown(
 			xfs_trans_cancel(sc->tp);
 		sc->tp = NULL;
 	}
+	xchk_rt_unlock(sc, &sc->sr);
 	if (sc->ip) {
 		if (sc->ilock_flags)
 			xchk_iunlock(sc, sc->ilock_flags);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index d606d4f370c7..38437104fc86 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -67,6 +67,12 @@ struct xchk_ag {
 	struct xfs_btree_cur	*refc_cur;
 };
 
+/* Inode lock state for the RT volume. */
+struct xchk_rt {
+	/* XCHK_RTLOCK_* lock state */
+	unsigned int		rtlock_flags;
+};
+
 struct xfs_scrub {
 	/* General scrub state. */
 	struct xfs_mount		*mp;
@@ -125,6 +131,9 @@ struct xfs_scrub {
 
 	/* State tracking for single-AG operations. */
 	struct xchk_ag			sa;
+
+	/* State tracking for realtime operations. */
+	struct xchk_rt			sr;
 };
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */

