Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B17156979
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224730; cv=none; b=N+cbTTbqxO8kqMr+m0eF9tkk7wKE8lr7JYXKEheWCPfv7PD2ECACxK/NV+6CH7DrSMxiVl3QVCMsE2MyTAG0sfXeUQw49dzRcq3aMbrinM2r/uiKEYC1ZSfaM0/rxi2JXGKz856NAXwXFqEM8HMcFPOSe5tW52ULglh7DucufNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224730; c=relaxed/simple;
	bh=kui6qGNM/rbYihijBVCPvgua2KKpuSshX3uP5WSg02k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JM46e7QQCgnSvZ+l/1L4fEI5/N3m4z9TczWk8zIJ0BzEmWbbtwKqa55FKIWgT/GWLnWiy32ZXd6eBZSE1CyG2tOko2LLOByjuU6TwA7xlV+glB5YGkex9Q/p/6Vk6IxBXfkySsicGsxbZjWpajbAZbDdZFVyeuON92TNWIfb3iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZ9kAC6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZ9kAC6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425F9C113CC;
	Mon, 15 Apr 2024 23:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224730;
	bh=kui6qGNM/rbYihijBVCPvgua2KKpuSshX3uP5WSg02k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OZ9kAC6GDLx0w5mjDfm9ytQvBrZtDYQSMgQGlhrmrVTVFUowCPrz4WiSbU+Mng8Ev
	 1+Rd3qmgro1GcMsc7sH6kqqTMPpuo4GhHFDq3FCur8MI6bOh+co4z4PlUkz9kV1/kT
	 NK+jVPDVGWPu4madgjyWc5fdunt/JExhd4bxJo2/h3jHUBqRoVQfV2d2dDudRDQrNj
	 QTXQy4AdiAsuqFjIl40kPzRXWjBZBE1DZKQPn/F8rP9R3AAPZqi7e2EkyNNOBEAX+h
	 3VbW7jwFiKXNADNDgWhKigx2K1CtWby3rQFEfb6lFF3N0vPfx10u5wmairG6rfIoiq
	 OOmrOzcXNkLyA==
Date: Mon, 15 Apr 2024 16:45:29 -0700
Subject: [PATCH 3/4] xfs: refactor live buffer invalidation for repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171322381841.87900.17584647776806183286.stgit@frogsfrogsfrogs>
In-Reply-To: <171322381780.87900.770231063979470318.stgit@frogsfrogsfrogs>
References: <171322381780.87900.770231063979470318.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In an upcoming patch, we will need to be able to look for xfs_buf
objects caching file-based metadata blocks without needing to walk the
(possibly corrupt) structures to find all the buffers.  Repair already
has most of the code needed to scan the buffer cache, so hoist these
utility functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/reap.c |   73 ++++++++++++++++++++++++++++++++++++---------------
 fs/xfs/scrub/reap.h |   20 ++++++++++++++
 2 files changed, 71 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 0252a3b5b65a..7ae6253395e7 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -211,6 +211,48 @@ static inline void xreap_defer_finish_reset(struct xreap_state *rs)
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
+				scan->__sector_count, XBF_LIVESCAN, &bp);
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
@@ -241,28 +283,15 @@ xreap_agextent_binval(
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
-		for (fsbcount = 1; fsbcount <= max_fsbs; fsbcount++) {
-			struct xfs_buf	*bp = NULL;
-			xfs_daddr_t	daddr;
-			int		error;
-
-			daddr = XFS_AGB_TO_DADDR(mp, agno, bno);
-			error = xfs_buf_incore(mp->m_ddev_targp, daddr,
-					XFS_FSB_TO_BB(mp, fsbcount),
-					XBF_LIVESCAN, &bp);
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
index 0b69f16dd98f..bb09e21fcb17 100644
--- a/fs/xfs/scrub/reap.h
+++ b/fs/xfs/scrub/reap.h
@@ -14,4 +14,24 @@ int xrep_reap_agblocks(struct xfs_scrub *sc, struct xagb_bitmap *bitmap,
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

