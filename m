Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB309F9C4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDgwTDQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B842C433C8;
	Sun, 31 Dec 2023 20:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054693;
	bh=bk7qdveTOWdI6YtnsvPNu7zKbL7aVgI3LPHKfO4axbI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kDgwTDQHbPXKDXtntuPU94ViMyJh8O4S19qhm7OWFq8VEtiqDitQt2tdg0oSeDNEG
	 FNAjOn85dwnns+098CyGMtz5c8klOSjR3M8KbpY+DHGC9ZamDjdbkfq1oSrPmxLD8S
	 MzQtzsKLwKA25tSzHnC8G5RLCq1B+iaJBo+T5f6G0JGvNqrsGC6K2NfITJcc95L/zI
	 GilPH69zg0sVHAbCziGAsyDmWr2r77D6ns6srMf3tlZwY/IvDAppEZrHFJQlrEU83P
	 FyKtSlF+CdIeyXUn6rnDCvENKNtv1FRZVG1IaJbYsqVBa3o0EQOO91FEdXNaEAG2gv
	 0ci9QGK2YeGhg==
Date: Sun, 31 Dec 2023 12:31:32 -0800
Subject: [PATCH 3/4] xfs: refactor live buffer invalidation for repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833916.1752674.1840854505881973455.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833858.1752674.247392515267008994.stgit@frogsfrogsfrogs>
References: <170404833858.1752674.247392515267008994.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/reap.c |   73 ++++++++++++++++++++++++++++++++++++---------------
 fs/xfs/scrub/reap.h |   20 ++++++++++++++
 2 files changed, 71 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 0252a3b5b65ac..7ae6253395e72 100644
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
index 0b69f16dd98f9..bb09e21fcb172 100644
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

