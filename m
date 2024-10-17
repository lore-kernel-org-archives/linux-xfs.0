Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED57218D72
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192170; cv=none; b=tBTFRYhBPEIrH6znKsOOL3nhc4EQtGUOk0GiQZBuVeIetEdc9VMf5PVHeo0THoVUcUySEgWaGFqoh33pZNYsgUxOJYs6VBP7MULh1iOJ4+K/eZJupvP73+Bqzmj63WrNTjOHYgoEh6pJ+ocF4B5lfLFf/k6ZbnxrY/HpW8m/EO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192170; c=relaxed/simple;
	bh=m0BIQVyY6KNLTQM70EYzNn1kxPw3qRanF0Kfg6vPScQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IhbsGfl7UaTEvIdKHWyk5TCdDxV+ebjcaDflnVJxyek/sv7XS/gt9iVccDTL13TckvF2I+FiqRCNW6amB3QiBqGgoK45AGFRD+9DCmXGiSNwEhdR2VCikQxgbZCY6M/dS/DRvdNGD0HQN4bwBkESm2gugtIzk104c08Fg6Lp3v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m9asmWuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m9asmWuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC62DC4CEC3;
	Thu, 17 Oct 2024 19:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192170;
	bh=m0BIQVyY6KNLTQM70EYzNn1kxPw3qRanF0Kfg6vPScQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m9asmWuBL73PaqtMSpXL50R60iv9SPw5UGMontCNXZFw10aDFYSAJVbEUAceU+4SN
	 FgW36cqU/MKJSbxcLBIua2zNMABVJDYzwKCt5QSoDPBzJTfN2U3UNhRi4gGi1NrFZG
	 T29aFcM+UHHyOIdAwqTBZRGaAp75soEngLHslJ1EDJmXU7BVA7ojQ27cHoFSYWPJte
	 n2rxE31w3PvJhD9KV03NwpQ45nAHVLI3ygdFlzFZXfeEeYk2HVAM3dw+KGesf1zPlx
	 5YkjdLPT7xBCpI11b/0ekQL+S1Zr64ResVDcVf17yN9951fXIPpGY22KAben/qGs4g
	 Y3tTJhoOXMReQ==
Date: Thu, 17 Oct 2024 12:09:29 -0700
Subject: [PATCH 32/34] xfs: port the perag discard code to handle generic
 groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072223.3453179.8959262334258999078.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Port xfs_discard_extents and its tracepoints to handle generic groups
instead of just perags.  This is needed to enable busy extent tracking
for rtgroups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c |   35 ++++++++++++++++++++++++++---------
 fs/xfs/xfs_trace.h   |   19 +++++++++++--------
 2 files changed, 37 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index a7635962448911..b7c1e09e9afefc 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -101,6 +101,24 @@ xfs_discard_endio(
 	bio_put(bio);
 }
 
+static inline struct block_device *
+xfs_group_bdev(
+	const struct xfs_group	*xg)
+{
+	struct xfs_mount	*mp = xg->xg_mount;
+
+	switch (xg->xg_type) {
+	case XG_TYPE_AG:
+		return mp->m_ddev_targp->bt_bdev;
+	case XG_TYPE_RTG:
+		return mp->m_rtdev_targp->bt_bdev;
+	default:
+		ASSERT(0);
+		break;
+	}
+	return NULL;
+}
+
 /*
  * Walk the discard list and issue discards on all the busy extents in the
  * list. We plug and chain the bios so that we only need a single completion
@@ -118,12 +136,11 @@ xfs_discard_extents(
 
 	blk_start_plug(&plug);
 	list_for_each_entry(busyp, &extents->extent_list, list) {
-		struct xfs_perag	*pag = to_perag(busyp->group);
+		trace_xfs_discard_extent(busyp->group, busyp->bno,
+				busyp->length);
 
-		trace_xfs_discard_extent(pag, busyp->bno, busyp->length);
-
-		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
-				xfs_agbno_to_daddr(pag, busyp->bno),
+		error = __blkdev_issue_discard(xfs_group_bdev(busyp->group),
+				xfs_gbno_to_daddr(busyp->group, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
 				GFP_KERNEL, &bio);
 		if (error && error != -EOPNOTSUPP) {
@@ -241,11 +258,11 @@ xfs_trim_gather_extents(
 		 * overlapping ranges for now.
 		 */
 		if (fbno + flen < tcur->start) {
-			trace_xfs_discard_exclude(pag, fbno, flen);
+			trace_xfs_discard_exclude(pag_group(pag), fbno, flen);
 			goto next_extent;
 		}
 		if (fbno > tcur->end) {
-			trace_xfs_discard_exclude(pag, fbno, flen);
+			trace_xfs_discard_exclude(pag_group(pag), fbno, flen);
 			if (tcur->by_bno) {
 				tcur->count = 0;
 				break;
@@ -263,7 +280,7 @@ xfs_trim_gather_extents(
 
 		/* Too small?  Give up. */
 		if (flen < tcur->minlen) {
-			trace_xfs_discard_toosmall(pag, fbno, flen);
+			trace_xfs_discard_toosmall(pag_group(pag), fbno, flen);
 			if (tcur->by_bno)
 				goto next_extent;
 			tcur->count = 0;
@@ -275,7 +292,7 @@ xfs_trim_gather_extents(
 		 * discard and try again the next time.
 		 */
 		if (xfs_extent_busy_search(pag_group(pag), fbno, flen)) {
-			trace_xfs_discard_busy(pag, fbno, flen);
+			trace_xfs_discard_busy(pag_group(pag), fbno, flen);
 			goto next_extent;
 		}
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e3218c0f6ac564..79dc7620694f38 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2480,23 +2480,26 @@ DEFINE_LOG_RECOVER_ICREATE_ITEM(xfs_log_recover_icreate_cancel);
 DEFINE_LOG_RECOVER_ICREATE_ITEM(xfs_log_recover_icreate_recover);
 
 DECLARE_EVENT_CLASS(xfs_discard_class,
-	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
+	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
 		 xfs_extlen_t len),
-	TP_ARGS(pag, agbno, len),
+	TP_ARGS(xg, agbno, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
-		__entry->dev = pag_mount(pag)->m_super->s_dev;
-		__entry->agno = pag_agno(pag);
+		__entry->dev = xg->xg_mount->m_super->s_dev;
+		__entry->type = xg->xg_type;
+		__entry->agno = xg->xg_gno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
+	TP_printk("dev %d:%d %sno 0x%x gbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
 		  __entry->agbno,
 		  __entry->len)
@@ -2504,9 +2507,9 @@ DECLARE_EVENT_CLASS(xfs_discard_class,
 
 #define DEFINE_DISCARD_EVENT(name) \
 DEFINE_EVENT(xfs_discard_class, name, \
-	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno, \
-		xfs_extlen_t len), \
-	TP_ARGS(pag, agbno, len))
+	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno, \
+		 xfs_extlen_t len), \
+	TP_ARGS(xg, agbno, len))
 DEFINE_DISCARD_EVENT(xfs_discard_extent);
 DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
 DEFINE_DISCARD_EVENT(xfs_discard_exclude);

