Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF6FC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjEZB3W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjEZB3V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:29:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5BB125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:29:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AFB760C2B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5E3C433EF;
        Fri, 26 May 2023 01:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064559;
        bh=sCd4Dh+Buz/oSMAVEqFeoxbzuY9ZiGbv9JWLZUhOYwU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=GvI4li2BLPy0tP1mrjAVvLNJf/4VxPlM/MqvFrCnO91yzxmfBOF1jFBfg6D0Qvbi9
         Wj6lXoDiKV+srGXI019VmIz3vT3XMyWNP1L5VnXklVdr4NLfYecbhZKQjT9E1NZT1k
         MzR0lehS7TtFnbcXhqvr3Vfe2a3umyIP4AdyjZbHSZJneyFFSUPIde2T7/1eFTmWQc
         YPggrw4Jwe49r47oMmRr3dXAI/5iHKPNyjZnRYN2AkCOzm/2FBDu92SbwWLOjFL6Rl
         NxZN7HII3hcY+BkFDUVemx/0Uo3amzrDnGRi0GIE9qUQdw7T4eEItGPQd58yoIkaar
         qudNZ99rRQ1dg==
Date:   Thu, 25 May 2023 18:29:19 -0700
Subject: [PATCH 3/4] xfs: refactor stale buffer scanning for repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506065685.3735098.13561060121336904634.stgit@frogsfrogsfrogs>
In-Reply-To: <168506065638.3735098.13625967488642973015.stgit@frogsfrogsfrogs>
References: <168506065638.3735098.13625967488642973015.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In an upcoming patch, we will need to be able to look for xfs_buf
objects caching file-based metadata blocks without needing to walk the
(possibly corrupt) structures to find all the buffers.  Repair already
has most of the code needed to scan the buffer cache, so hoist these
utility functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/reap.c |   73 ++++++++++++++++++++++++++++++++++++---------------
 fs/xfs/scrub/reap.h |   20 ++++++++++++++
 2 files changed, 71 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index f1103f82fdc5..73da76a3d89d 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -209,6 +209,48 @@ static inline void xreap_defer_finish_reset(struct xreap_state *rs)
 	rs->force_roll = false;
 }
 
+/*
+ * Compute the maximum length of a buffer cache scan (in units of sectors),
+ * given a quantity of fs blocks.
+ */
+xfs_daddr_t
+xrep_bufscan_max_sectors(
+	struct xfs_mount	*mp,
+	xfs_extlen_t		fsblocks)
+{
+	int			max_fsbs;
+
+	/* Remote xattr values are the largest buffers that we support. */
+	max_fsbs = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
+
+	return XFS_FSB_TO_BB(mp, min_t(xfs_extlen_t, fsblocks, max_fsbs));
+}
+
+/*
+ * Return an incore buffer from a sector scan, or NULL if there are no buffers
+ * left to return.
+ */
+struct xfs_buf *
+xrep_bufscan_advance(
+	struct xfs_mount	*mp,
+	struct xrep_bufscan	*scan)
+{
+	scan->__sector_count += scan->daddr_step;
+	while (scan->__sector_count <= scan->max_sectors) {
+		struct xfs_buf	*bp = NULL;
+		int		error;
+
+		error = xfs_buf_incore(mp->m_ddev_targp, scan->daddr,
+				scan->__sector_count, XBF_BCACHE_SCAN, &bp);
+		if (!error)
+			return bp;
+
+		scan->__sector_count += scan->daddr_step;
+	}
+
+	return NULL;
+}
+
 /* Try to invalidate the incore buffers for an extent that we're freeing. */
 STATIC void
 xreap_agextent_binval(
@@ -239,28 +281,15 @@ xreap_agextent_binval(
 	 * of any plausible size.
 	 */
 	while (bno < agbno_next) {
-		xfs_agblock_t	fsbcount;
-		xfs_agblock_t	max_fsbs;
-
-		/*
-		 * Max buffer size is the max remote xattr buffer size, which
-		 * is one fs block larger than 64k.
-		 */
-		max_fsbs = min_t(xfs_agblock_t, agbno_next - bno,
-				xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX));
-
-		for (fsbcount = 1; fsbcount < max_fsbs; fsbcount++) {
-			struct xfs_buf	*bp = NULL;
-			xfs_daddr_t	daddr;
-			int		error;
-
-			daddr = XFS_AGB_TO_DADDR(mp, agno, bno);
-			error = xfs_buf_incore(mp->m_ddev_targp, daddr,
-					XFS_FSB_TO_BB(mp, fsbcount),
-					XBF_BCACHE_SCAN, &bp);
-			if (error)
-				continue;
-
+		struct xrep_bufscan	scan = {
+			.daddr		= XFS_AGB_TO_DADDR(mp, agno, bno),
+			.max_sectors	= xrep_bufscan_max_sectors(mp,
+							agbno_next - bno),
+			.daddr_step	= XFS_FSB_TO_BB(mp, 1),
+		};
+		struct xfs_buf	*bp;
+
+		while ((bp = xrep_bufscan_advance(mp, &scan)) != NULL) {
 			xfs_trans_bjoin(sc->tp, bp);
 			xfs_trans_binval(sc->tp, bp);
 			rs->invalidated++;
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
index 5e710be44b4b..3ced16f0b30a 100644
--- a/fs/xfs/scrub/reap.h
+++ b/fs/xfs/scrub/reap.h
@@ -11,4 +11,24 @@ int xrep_reap_agblocks(struct xfs_scrub *sc, struct xagb_bitmap *bitmap,
 int xrep_reap_fsblocks(struct xfs_scrub *sc, struct xfsb_bitmap *bitmap,
 		const struct xfs_owner_info *oinfo);
 
+/* Buffer cache scan context. */
+struct xrep_bufscan {
+	/* Disk address for the buffers we want to scan. */
+	xfs_daddr_t		daddr;
+
+	/* Maximum number of sectors to scan. */
+	xfs_daddr_t		max_sectors;
+
+	/* Each round, increment the search length by this number of sectors. */
+	xfs_daddr_t		daddr_step;
+
+	/* Internal scan state; initialize to zero. */
+	xfs_daddr_t		__sector_count;
+};
+
+xfs_daddr_t xrep_bufscan_max_sectors(struct xfs_mount *mp,
+		xfs_extlen_t fsblocks);
+struct xfs_buf *xrep_bufscan_advance(struct xfs_mount *mp,
+		struct xrep_bufscan *scan);
+
 #endif /* __XFS_SCRUB_REAP_H__ */

