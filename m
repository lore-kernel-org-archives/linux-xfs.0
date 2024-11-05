Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337C41CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846326; cv=none; b=PBWgBDdsNk1EIWcnX1+scq6RAnSxUUFlXCMQEzFdqOxTtUAcxR4jOiu77AuEtqLSUDsJoZ4S4lOF+7n5mGYx7d/gsZ8frlNVf6+drLOwHzFzKr6ZpXallcKfI/o0GzmkAmj67aI7D7dU5lzUjTWDoCj1sml4Tbd4kTDlTpIMCC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846326; c=relaxed/simple;
	bh=/TB/0CEup4e9ubGJDB6lUB9lxWhT5oLKgd9+Nasje2k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JR15p/CAHIh5KrVkplt5fFSZTwjYW5EjfHJHj2711SoPE2nL53sBCpYq8iVQ7UDKP8C8v7tQb5xu4xC4cbSqYUCw5KkyXx6STJFY7vPXCYVAuuw3keXJXyGO5zXA0QRnjLI5I02jb4MsZ/HvFbeK4xAHcpwOWSSyUbe4DtezaXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ExSwNOxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ExSwNOxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A81CC4CECF;
	Tue,  5 Nov 2024 22:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846325;
	bh=/TB/0CEup4e9ubGJDB6lUB9lxWhT5oLKgd9+Nasje2k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ExSwNOxNx3qsTPIUGgQagYbnhRoDuoCvql4YJeF3J16vrKyRBF5qyTfk2QKO0eQ+p
	 F8+RnQAuNa+9hwCs+DjlGp+v+jWkrHcRVDMtIHh+Ay0blvBGa5j2xI0LgocCMFnnFZ
	 ddsYV2DR9lA+bJ5OK6ZBxMiPsLGlHPOxuC/Ka0hDKxcEwubh00QBNW9R1jQlVslsB5
	 GcbLdo+67MILBt7bNi944AKMp5hmCPc41UTPvLzykBQ4Cv6t/icz3r9/1iiecAzGoW
	 6DBeZDJmwMBp37AUvmt5RHj9S4DOjdZn3TRaOQsq/yM+pwwIeOBMfdrhx4/bnkBvf9
	 YayzNat4iFo+g==
Date: Tue, 05 Nov 2024 14:38:45 -0800
Subject: [PATCH 34/34] xfs: use rtgroup busy extent list for FITRIM
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398766.1871887.11546999079229873258.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

For filesystems that have rtgroups and hence use the busy extent list
for freed rt space, use that busy extent list so that FITRIM can issue
discard commands asynchronously without worrying about other callers
accidentally allocating and using space that is being discarded.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c |  146 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 144 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index b7c1e09e9afefc..c4bd145f5ec1bf 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -73,6 +73,8 @@
  * extent search so that it overlaps in flight discard IO.
  */
 
+#define XFS_DISCARD_MAX_EXAMINE	(100)
+
 struct workqueue_struct *xfs_discard_wq;
 
 static void
@@ -185,7 +187,7 @@ xfs_trim_gather_extents(
 	struct xfs_buf		*agbp;
 	int			error;
 	int			i;
-	int			batch = 100;
+	int			batch = XFS_DISCARD_MAX_EXAMINE;
 
 	/*
 	 * Force out the log.  This means any transactions that might have freed
@@ -565,6 +567,7 @@ xfs_trim_gather_rtextent(
 	return 0;
 }
 
+/* Trim extents on an !rtgroups realtime device */
 static int
 xfs_trim_rtextents(
 	struct xfs_rtgroup	*rtg,
@@ -619,6 +622,140 @@ xfs_trim_rtextents(
 	return error;
 }
 
+struct xfs_trim_rtgroup {
+	/* list of rtgroup extents to free */
+	struct xfs_busy_extents	*extents;
+
+	/* minimum length that caller allows us to trim */
+	xfs_rtblock_t		minlen_fsb;
+
+	/* restart point for the rtbitmap walk */
+	xfs_rtxnum_t		restart_rtx;
+
+	/* number of extents to examine before stopping to issue discard ios */
+	int			batch;
+
+	/* number of extents queued for discard */
+	int			queued;
+};
+
+static int
+xfs_trim_gather_rtgroup_extent(
+	struct xfs_rtgroup		*rtg,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv)
+{
+	struct xfs_trim_rtgroup		*tr = priv;
+	xfs_rgblock_t			rgbno;
+	xfs_extlen_t			len;
+
+	if (--tr->batch <= 0) {
+		/*
+		 * If we've checked a large number of extents, update the
+		 * cursor to point at this extent so we restart the next batch
+		 * from this extent.
+		 */
+		tr->restart_rtx = rec->ar_startext;
+		return -ECANCELED;
+	}
+
+	rgbno = xfs_rtx_to_rgbno(rtg, rec->ar_startext);
+	len = xfs_rtxlen_to_extlen(rtg_mount(rtg), rec->ar_extcount);
+
+	/* Ignore too small. */
+	if (len < tr->minlen_fsb) {
+		trace_xfs_discard_toosmall(rtg_group(rtg), rgbno, len);
+		return 0;
+	}
+
+	/*
+	 * If any blocks in the range are still busy, skip the discard and try
+	 * again the next time.
+	 */
+	if (xfs_extent_busy_search(rtg_group(rtg), rgbno, len)) {
+		trace_xfs_discard_busy(rtg_group(rtg), rgbno, len);
+		return 0;
+	}
+
+	xfs_extent_busy_insert_discard(rtg_group(rtg), rgbno, len,
+			&tr->extents->extent_list);
+
+	tr->queued++;
+	tr->restart_rtx = rec->ar_startext + rec->ar_extcount;
+	return 0;
+}
+
+/* Trim extents in this rtgroup using the busy extent machinery. */
+static int
+xfs_trim_rtgroup_extents(
+	struct xfs_rtgroup	*rtg,
+	xfs_rtxnum_t		low,
+	xfs_rtxnum_t		high,
+	xfs_daddr_t		minlen)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_trim_rtgroup	tr = {
+		.minlen_fsb	= XFS_BB_TO_FSB(mp, minlen),
+	};
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	/*
+	 * Walk the free ranges between low and high.  The query_range function
+	 * trims the extents returned.
+	 */
+	do {
+		tr.extents = kzalloc(sizeof(*tr.extents), GFP_KERNEL);
+		if (!tr.extents) {
+			error = -ENOMEM;
+			break;
+		}
+
+		tr.queued = 0;
+		tr.batch = XFS_DISCARD_MAX_EXAMINE;
+		tr.extents->owner = tr.extents;
+		INIT_LIST_HEAD(&tr.extents->extent_list);
+
+		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
+		error = xfs_rtalloc_query_range(rtg, tp, low, high,
+				xfs_trim_gather_rtgroup_extent, &tr);
+		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
+		if (error == -ECANCELED)
+			error = 0;
+		if (error) {
+			kfree(tr.extents);
+			break;
+		}
+
+		if (!tr.queued)
+			break;
+
+		/*
+		 * We hand the extent list to the discard function here so the
+		 * discarded extents can be removed from the busy extent list.
+		 * This allows the discards to run asynchronously with
+		 * gathering the next round of extents to discard.
+		 *
+		 * However, we must ensure that we do not reference the extent
+		 * list  after this function call, as it may have been freed by
+		 * the time control returns to us.
+		 */
+		error = xfs_discard_extents(rtg_mount(rtg), tr.extents);
+		if (error)
+			break;
+
+		low = tr.restart_rtx;
+	} while (!xfs_trim_should_stop() && low <= high);
+
+	xfs_trans_cancel(tp);
+	return error;
+}
+
 static int
 xfs_trim_rtdev_extents(
 	struct xfs_mount	*mp,
@@ -657,7 +794,12 @@ xfs_trim_rtdev_extents(
 		if (rtg_rgno(rtg) == end_rgno)
 			rtg_end = min(rtg_end, end_rtx);
 
-		error = xfs_trim_rtextents(rtg, start_rtx, rtg_end, minlen);
+		if (xfs_has_rtgroups(mp))
+			error = xfs_trim_rtgroup_extents(rtg, start_rtx,
+					rtg_end, minlen);
+		else
+			error = xfs_trim_rtextents(rtg, start_rtx, rtg_end,
+					minlen);
 		if (error)
 			last_error = error;
 

