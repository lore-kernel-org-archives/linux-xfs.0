Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90261CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846294; cv=none; b=n/c8MtClt2PSrgJ13d4XrswOLhw3YRzNeTyPPox4xqvWSiMqkZMhtJ6+Czx1bXFFwzLQ7FTMs2p1rfrWPWEI9G+YnKp/fZcQBEh3HCN0+n5EsxApZOMNwpjNFo0NtEWZEZBJ4TMTyoPMCdmHkEz8lSWgQdhhPq6pEg1jdaYOgUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846294; c=relaxed/simple;
	bh=dhLqLn/i5uYOXofuIIZX4qj96DuXbVQcuj7MoA8mwbM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j9SNg7+dsF96vWmtUk1PYVXpm5LHstvitZNy7XnK9d7hRvmYDjh+ex3Kun7SeRfRXDmeKsgNbwLuOTl6Zk9w+MaK+AMfBaHytStZxz5Ji5hbEpdXHag5HSHEu6nIRcVbIMsfFALNRevyrrlsiWQdvpRz+tT9oKgT5DVWSg+ASLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2I2LY8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2I2LY8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3B2C4CECF;
	Tue,  5 Nov 2024 22:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846294;
	bh=dhLqLn/i5uYOXofuIIZX4qj96DuXbVQcuj7MoA8mwbM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q2I2LY8s3TwZwFPnAY+ue1EhtLSOfZFEBRGUqKG8Zn5OQjPs7XOXmCGVSAdJsK4Rn
	 s7bao/Arh6LP/dU9Gf+67pRqw1OfS8s4CLXDeYwbgr3UbO7bvRAvHuP9N3xZeaTyKe
	 rGQv9czRieKbDdlPA0lcdrkSYv7JM83lN+tbxC86FLUpAuyszAqsHtgSnfXtG1S0So
	 zrsghVDqAjcU5UlUoaW/uDTWMyBtw5TYmBGH3L0LPDFP5pNkyrUitkYLtuHpvaNGXz
	 OFR/r08ghKs3+Lh+UFMsQRwMdLY4OZaEKAL2wr4vUDoq5FWuvX+wo5UyXR3yl5vzyV
	 p/FX1S3RcxxYg==
Date: Tue, 05 Nov 2024 14:38:13 -0800
Subject: [PATCH 32/34] xfs: port the perag discard code to handle generic
 groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398732.1871887.9821869713684804332.stgit@frogsfrogsfrogs>
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
index b07790d74d351f..5f7b461286ab67 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2475,23 +2475,26 @@ DEFINE_LOG_RECOVER_ICREATE_ITEM(xfs_log_recover_icreate_cancel);
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
@@ -2499,9 +2502,9 @@ DECLARE_EVENT_CLASS(xfs_discard_class,
 
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

