Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B64F4EB
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000719; cv=none; b=TjhR8dQmwl/dVTXuONrU2kg6nIySOkWysWLBEgrVnvNIuNEaVV8KDAb5aIa4erWFMqcX0dO6Fj0ov81+gc+Q4E6han4mPfvyY3aq1YPcmStGI4oNCjvc0Umd5kwwgouonQ4HQCYL/2dIjqovfZu4tpfLejXoiJD0U2Y0LtRZxgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000719; c=relaxed/simple;
	bh=bk7qdveTOWdI6YtnsvPNu7zKbL7aVgI3LPHKfO4axbI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bTVUx0hiN/zLQ415zdc+VYbKD2kr0XfH/Xadsp0NuEmwe0qUG59Hn653qDefXvOb45bu5h80fIFL1v8XMZn0d8ubXKqWQOxmriZzjc2fUGEz8wbDJ9o9whkeRELqcN4Z+D2WjKH5QyIbWeGG/qFJzOxj/U7cDlol5BK13I1o8ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DwPefEbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DwPefEbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1986DC433C7;
	Tue, 27 Feb 2024 02:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000718;
	bh=bk7qdveTOWdI6YtnsvPNu7zKbL7aVgI3LPHKfO4axbI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DwPefEbtb86oUufFt7O/TP1x3taL+5m3x9nDOfKUWiw1drjGijAII+aOaOTOWZpI4
	 3t1/Kq72jghU0As17vkT+IuYg8hRuLrGmJsR/RPkM9+eTNLo9oMwgUJ+//cKptDaG8
	 EvutFdQwwbynEbpniwhi/HVJXoIxYnO+JZ0D4B9m4Gr4SJKjkrVD8C/Dzv+xGkdX5s
	 WIGYiu8p1U8OIUzXmLvsZYYWvcYarw7jfy3oAGL/Rg8VFF4WJ3H9MeNp74VQZ2lspn
	 or9qe8nxH5ss/1NbHlGjJqH+fgHRedIMO05Ay/v0S5S7ChaUpXikFiMzCRIOK5Oz2R
	 4LZySR0Khd9QQ==
Date: Mon, 26 Feb 2024 18:25:17 -0800
Subject: [PATCH 3/4] xfs: refactor live buffer invalidation for repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170900012265.938660.17219985816705973845.stgit@frogsfrogsfrogs>
In-Reply-To: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
References: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
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

