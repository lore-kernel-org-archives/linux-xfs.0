Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8040C944F
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609032; cv=none; b=qSspwLxZpTynwQDUJToPoi78AbYaKKarHuIboAiGb942kghgiRoFlavLdYmxcMaPUyVuVUmx/4QKw16D20osXPbMYxxv7srBCSYY63b8wlUwI6a6xrol18wcaPY5DtbMl4mtf2s2MjYlamwdbkrv+wUMFtZwSwpNgUR+lHQV++I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609032; c=relaxed/simple;
	bh=BKifZ7Q3HDgqg5PHAi7drnAQaDJiqKMDm8IjCOOJy7Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bj0gNDfbGBwp5qAwuspPBJC2K6lDv2g7Yo1DmDc6+r2MewjjhK9xrbhP95lLQwI0uUmAUwPT1mUCd1yUQkLxVG6wsDmsEaPOnoIupPMnwT2QJHXDdhUuHL7WMb+Pr8pTMOHTLNqsuX/sTtN7J5IlwATxUkL4EkgkQ7NakFKHCqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmbkyRXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmbkyRXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D9AC4CEC5;
	Fri, 11 Oct 2024 01:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609032;
	bh=BKifZ7Q3HDgqg5PHAi7drnAQaDJiqKMDm8IjCOOJy7Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mmbkyRXt7wJwb+aTSDmCPbFHCO2zzaVZCzt8GB48aVtZDreB3Fh+1SdN1d/h5Ftr1
	 SO/xjmbSweqqw/fS2A9Pnx+1mBZgb9/mF1AF94UD5WwG5h/WgiVhUJ8bxMgq4iLDjR
	 GWrVn0p2cUQwfb+s5hk4rLhNjcst8+TTqJ0S1ARXnGLFOmcOfVFFcykpz6gk5wJ6N9
	 DHfIY/Pl+iAWqy2jhwS3K3PJ09y9WAJyNzf9F+r5n2aFibPBIvPGtIg/5+4loOoDsD
	 s4SL59kh8QS0AXckpsUjUqLfK3IqK4RD8Kq9lYRQrdc7AwvsX0cxzsyexPfi0o9D50
	 9iwaEWE2vdI8g==
Date: Thu, 10 Oct 2024 18:10:31 -0700
Subject: [PATCH 34/36] xfs: port the perag discard code to handle generic
 groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644830.4178701.10909954990936352067.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

Port xfs_discard_extents and its tracepoints to handle generic groups
instead of just perags.  This is needed to enable busy extent tracking
for rtgroups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |   35 ++++++++++++++++++++++++++---------
 fs/xfs/xfs_trace.h   |   19 +++++++++++--------
 2 files changed, 37 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index bcc904e749b276..2200b119e55b6b 100644
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
+			trace_xfs_discard_exclude(&pag->pag_group, fbno, flen);
 			goto next_extent;
 		}
 		if (fbno > tcur->end) {
-			trace_xfs_discard_exclude(pag, fbno, flen);
+			trace_xfs_discard_exclude(&pag->pag_group, fbno, flen);
 			if (tcur->by_bno) {
 				tcur->count = 0;
 				break;
@@ -263,7 +280,7 @@ xfs_trim_gather_extents(
 
 		/* Too small?  Give up. */
 		if (flen < tcur->minlen) {
-			trace_xfs_discard_toosmall(pag, fbno, flen);
+			trace_xfs_discard_toosmall(&pag->pag_group, fbno, flen);
 			if (tcur->by_bno)
 				goto next_extent;
 			tcur->count = 0;
@@ -275,7 +292,7 @@ xfs_trim_gather_extents(
 		 * discard and try again the next time.
 		 */
 		if (xfs_extent_busy_search(&pag->pag_group, fbno, flen)) {
-			trace_xfs_discard_busy(pag, fbno, flen);
+			trace_xfs_discard_busy(&pag->pag_group, fbno, flen);
 			goto next_extent;
 		}
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7beeaac0ad4cf0..64af1470b838f0 100644
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
+		__entry->agno = xg->xg_index;
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

