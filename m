Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689C4C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiJBSav (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiJBSas (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:30:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF996286DB
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:30:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CD2F60F08
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2754C433D6;
        Sun,  2 Oct 2022 18:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735446;
        bh=uUF1A6N+3wAAaY6vGXrckLJgKTntvupHBmiAX77BTTI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gMA6usP1f0UBuAoUlkJObda1qbljLulhs58VAr8lyWK3GQlBdfOhUwmORQCvds9OW
         +I2e+pCGEojQy03n+KHatBP7dOObKftGs9dpArsMvpXDeXmIdMZCLG8fI1J5OvHf/2
         BAPaH/hncpv0tlb4crFsnK8rQ5lW3WSHNmRRu+21/cEf8RNZYTTcPZCXXAXBwCmUDG
         +yt46Mdv3NnjbJbnMmsPranFos0ADIiQxRybfTtMaOMvicufnG3cnQOeykSfbLI27L
         mNAQREMKpwJ9W+XqQroFK0YY0sHXiV11GdML1fYV+R3nzZtCzs8iuwBX7w6QVKWAtN
         6Ml0Fwn3Vs1bg==
Subject: [PATCH 2/2] xfs: online checking of the free rt extent count
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:05 -0700
Message-ID: <166473480575.1083794.6363015906526063261.stgit@magnolia>
In-Reply-To: <166473480544.1083794.8963547317476704789.stgit@magnolia>
References: <166473480544.1083794.8963547317476704789.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the summary count checker to count the number of free realtime
extents and compare that to the superblock copy.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/fscounters.c |   86 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/scrub.h      |    8 ----
 2 files changed, 84 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index c869b537fe34..2eea6a517b79 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -14,6 +14,8 @@
 #include "xfs_health.h"
 #include "xfs_btree.h"
 #include "xfs_ag.h"
+#include "xfs_rtalloc.h"
+#include "xfs_inode.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -43,6 +45,16 @@
  * our tolerance for mismatch between expected and actual counter values.
  */
 
+struct xchk_fscounters {
+	struct xfs_scrub	*sc;
+	uint64_t		icount;
+	uint64_t		ifree;
+	uint64_t		fdblocks;
+	uint64_t		frextents;
+	unsigned long long	icount_min;
+	unsigned long long	icount_max;
+};
+
 /*
  * Since the expected value computation is lockless but only browses incore
  * values, the percpu counters should be fairly close to each other.  However,
@@ -127,6 +139,7 @@ xchk_setup_fscounters(
 	if (!sc->buf)
 		return -ENOMEM;
 	fsc = sc->buf;
+	fsc->sc = sc;
 
 	xfs_icount_range(sc->mp, &fsc->icount_min, &fsc->icount_max);
 
@@ -288,6 +301,59 @@ xchk_fscount_aggregate_agcounts(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_RT
+static inline int
+xchk_fscount_add_frextent(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv)
+{
+	struct xchk_fscounters		*fsc = priv;
+	int				error = 0;
+
+	fsc->frextents += rec->ar_extcount;
+
+	xchk_should_terminate(fsc->sc, &error);
+	return error;
+}
+
+/* Calculate the number of free realtime extents from the realtime bitmap. */
+STATIC int
+xchk_fscount_count_frextents(
+	struct xfs_scrub	*sc,
+	struct xchk_fscounters	*fsc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	int			error;
+
+	fsc->frextents = 0;
+	if (!xfs_has_realtime(mp))
+		return 0;
+
+	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	error = xfs_rtalloc_query_all(sc->mp, sc->tp,
+			xchk_fscount_add_frextent, fsc);
+	if (error) {
+		xchk_set_incomplete(sc);
+		goto out_unlock;
+	}
+
+out_unlock:
+	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	return error;
+}
+#else
+STATIC int
+xchk_fscount_count_frextents(
+	struct xfs_scrub	*sc,
+	struct xchk_fscounters	*fsc)
+{
+	fsc->frextents = 0;
+	return 0;
+}
+#endif /* CONFIG_XFS_RT */
+
 /*
  * Part 2: Comparing filesystem summary counters.  All we have to do here is
  * sum the percpu counters and compare them to what we've observed.
@@ -359,16 +425,17 @@ xchk_fscounters(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xchk_fscounters	*fsc = sc->buf;
-	int64_t			icount, ifree, fdblocks;
+	int64_t			icount, ifree, fdblocks, frextents;
 	int			error;
 
 	/* Snapshot the percpu counters. */
 	icount = percpu_counter_sum(&mp->m_icount);
 	ifree = percpu_counter_sum(&mp->m_ifree);
 	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	frextents = percpu_counter_sum(&mp->m_frextents);
 
 	/* No negative values, please! */
-	if (icount < 0 || ifree < 0 || fdblocks < 0)
+	if (icount < 0 || ifree < 0 || fdblocks < 0 || frextents < 0)
 		xchk_set_corrupt(sc);
 
 	/* See if icount is obviously wrong. */
@@ -379,6 +446,10 @@ xchk_fscounters(
 	if (fdblocks > mp->m_sb.sb_dblocks)
 		xchk_set_corrupt(sc);
 
+	/* See if frextents is obviously wrong. */
+	if (frextents > mp->m_sb.sb_rextents)
+		xchk_set_corrupt(sc);
+
 	/*
 	 * If ifree exceeds icount by more than the minimum variance then
 	 * something's probably wrong with the counters.
@@ -393,6 +464,13 @@ xchk_fscounters(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
 		return 0;
 
+	/* Count the free extents counter for rt volumes. */
+	error = xchk_fscount_count_frextents(sc, fsc);
+	if (!xchk_process_error(sc, 0, XFS_SB_BLOCK(mp), &error))
+		return error;
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
+		return 0;
+
 	/* Compare the in-core counters with whatever we counted. */
 	if (!xchk_fscount_within_range(sc, icount, &mp->m_icount, fsc->icount))
 		xchk_set_corrupt(sc);
@@ -404,5 +482,9 @@ xchk_fscounters(
 			fsc->fdblocks))
 		xchk_set_corrupt(sc);
 
+	if (!xchk_fscount_within_range(sc, frextents, &mp->m_frextents,
+			fsc->frextents))
+		xchk_set_corrupt(sc);
+
 	return 0;
 }
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 92b383061e88..85c055c2ddc5 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -173,12 +173,4 @@ void xchk_xref_is_used_rt_space(struct xfs_scrub *sc, xfs_rtblock_t rtbno,
 # define xchk_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
 #endif
 
-struct xchk_fscounters {
-	uint64_t		icount;
-	uint64_t		ifree;
-	uint64_t		fdblocks;
-	unsigned long long	icount_min;
-	unsigned long long	icount_max;
-};
-
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

