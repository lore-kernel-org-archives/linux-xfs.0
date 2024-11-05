Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3EF1CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846450; cv=none; b=WfVzh6gut93ydXF4ch2soZ9inCRynhd1uhqrgB2N55bX+iW5o/BSKgUXts4dInlKI+um9yrvqg1fuvXthG3co312kdCvWfgdhGYTduQUyWPfW11dZhgyi2E+1N3vHsMs31eBPu+IKIEOqUv+OHkwjXw7Xl6bL6/ecgtZhdDcIzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846450; c=relaxed/simple;
	bh=NQ6ku4PobNjBoQsGGWM2PUM1aTzf28bTKEAfCPBqoKo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTBcdFkhLSN0RdWxXA3t/MFaxjHprtFz7/KoY9U+xgUByQ/RPVIVo+T+JWrYihwFx8mVOWXgUzk2TTY3VdAx9pCliflJg63sKPheaGgsUS2luOn07UvoRmD8ePHU7GTff0KOmrl2njFL69sGjzyZXoj9iRLdt7vmmzH4qphg2qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cwTXZqGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cwTXZqGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6366DC4CECF;
	Tue,  5 Nov 2024 22:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846450;
	bh=NQ6ku4PobNjBoQsGGWM2PUM1aTzf28bTKEAfCPBqoKo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cwTXZqGxXNlzeblklxvqmsuR5zjk7P0aos3PIF4q8whyzhW3qJtHs89jo/DZBIo5H
	 0sAiJDWljZWWBCS5ksoauRH7OYQrketAEviXK0PAGVp1Bm1WUUmRhsDxavl+QaFfYU
	 JRotdQ02gsBou60yA3Uzp8+DP4fiKCZQXFV0QMl91KdTcfOxCHypXfDFlcr8tiNK7c
	 qkHC7lhFPmveizOuV5gGKxsLUxsSo0o6Vf2dFKVBmtvxKzNMAevOPrSC6E8LghElQn
	 T4qOeLFTsgt8NPuzDCiWhKlOkUeu6W6FNDYEO+GBk4xGkPWCdsh2c4SH1tqYB6AMZX
	 lIVVbuiDE3Rlg==
Date: Tue, 05 Nov 2024 14:40:49 -0800
Subject: [PATCH 4/6] xfs: create quota preallocation watermarks for realtime
 quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084399630.1873230.10827415923801994697.stgit@frogsfrogsfrogs>
In-Reply-To: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
References: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Refactor the quota preallocation watermarking code so that it'll work
for realtime quota too.  Convert the do_div calls into div_u64 for
compactness.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c |   37 +++++++++++++++++++++----------------
 fs/xfs/xfs_dquot.h |   18 ++++++++++++++----
 fs/xfs/xfs_iomap.c |   37 ++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_qm.c    |   21 ++++++++++++++++-----
 4 files changed, 81 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 3bf47458c517af..ff982d983989b0 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -277,6 +277,25 @@ xfs_qm_init_dquot_blk(
 		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
 }
 
+static void
+xfs_dquot_set_prealloc(
+	struct xfs_dquot_pre		*pre,
+	const struct xfs_dquot_res	*res)
+{
+	xfs_qcnt_t			space;
+
+	pre->q_prealloc_hi_wmark = res->hardlimit;
+	pre->q_prealloc_lo_wmark = res->softlimit;
+
+	space = div_u64(pre->q_prealloc_hi_wmark, 100);
+	if (!pre->q_prealloc_lo_wmark)
+		pre->q_prealloc_lo_wmark = space * 95;
+
+	pre->q_low_space[XFS_QLOWSP_1_PCNT] = space;
+	pre->q_low_space[XFS_QLOWSP_3_PCNT] = space * 3;
+	pre->q_low_space[XFS_QLOWSP_5_PCNT] = space * 5;
+}
+
 /*
  * Initialize the dynamic speculative preallocation thresholds. The lo/hi
  * watermarks correspond to the soft and hard limits by default. If a soft limit
@@ -285,22 +304,8 @@ xfs_qm_init_dquot_blk(
 void
 xfs_dquot_set_prealloc_limits(struct xfs_dquot *dqp)
 {
-	uint64_t space;
-
-	dqp->q_prealloc_hi_wmark = dqp->q_blk.hardlimit;
-	dqp->q_prealloc_lo_wmark = dqp->q_blk.softlimit;
-	if (!dqp->q_prealloc_lo_wmark) {
-		dqp->q_prealloc_lo_wmark = dqp->q_prealloc_hi_wmark;
-		do_div(dqp->q_prealloc_lo_wmark, 100);
-		dqp->q_prealloc_lo_wmark *= 95;
-	}
-
-	space = dqp->q_prealloc_hi_wmark;
-
-	do_div(space, 100);
-	dqp->q_low_space[XFS_QLOWSP_1_PCNT] = space;
-	dqp->q_low_space[XFS_QLOWSP_3_PCNT] = space * 3;
-	dqp->q_low_space[XFS_QLOWSP_5_PCNT] = space * 5;
+	xfs_dquot_set_prealloc(&dqp->q_blk_prealloc, &dqp->q_blk);
+	xfs_dquot_set_prealloc(&dqp->q_rtb_prealloc, &dqp->q_rtb);
 }
 
 /*
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 677bb2dc9ac913..d73d179df00958 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -56,6 +56,12 @@ xfs_dquot_res_over_limits(
 	return false;
 }
 
+struct xfs_dquot_pre {
+	xfs_qcnt_t		q_prealloc_lo_wmark;
+	xfs_qcnt_t		q_prealloc_hi_wmark;
+	int64_t			q_low_space[XFS_QLOWSP_MAX];
+};
+
 /*
  * The incore dquot structure
  */
@@ -76,9 +82,9 @@ struct xfs_dquot {
 
 	struct xfs_dq_logitem	q_logitem;
 
-	xfs_qcnt_t		q_prealloc_lo_wmark;
-	xfs_qcnt_t		q_prealloc_hi_wmark;
-	int64_t			q_low_space[XFS_QLOWSP_MAX];
+	struct xfs_dquot_pre	q_blk_prealloc;
+	struct xfs_dquot_pre	q_rtb_prealloc;
+
 	struct mutex		q_qlock;
 	struct completion	q_flush;
 	atomic_t		q_pincount;
@@ -192,7 +198,11 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 	int64_t freesp;
 
 	freesp = dqp->q_blk.hardlimit - dqp->q_blk.reserved;
-	if (freesp < dqp->q_low_space[XFS_QLOWSP_1_PCNT])
+	if (freesp < dqp->q_blk_prealloc.q_low_space[XFS_QLOWSP_1_PCNT])
+		return true;
+
+	freesp = dqp->q_rtb.hardlimit - dqp->q_rtb.reserved;
+	if (freesp < dqp->q_rtb_prealloc.q_low_space[XFS_QLOWSP_1_PCNT])
 		return true;
 
 	return false;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 17e5c273e28c45..a6fc5acbb6f2c7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -353,16 +353,26 @@ xfs_quota_need_throttle(
 	xfs_fsblock_t		alloc_blocks)
 {
 	struct xfs_dquot	*dq = xfs_inode_dquot(ip, type);
+	struct xfs_dquot_res	*res;
+	struct xfs_dquot_pre	*pre;
 
 	if (!dq || !xfs_this_quota_on(ip->i_mount, type))
 		return false;
 
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		res = &dq->q_rtb;
+		pre = &dq->q_rtb_prealloc;
+	} else {
+		res = &dq->q_blk;
+		pre = &dq->q_blk_prealloc;
+	}
+
 	/* no hi watermark, no throttle */
-	if (!dq->q_prealloc_hi_wmark)
+	if (!pre->q_prealloc_hi_wmark)
 		return false;
 
 	/* under the lo watermark, no throttle */
-	if (dq->q_blk.reserved + alloc_blocks < dq->q_prealloc_lo_wmark)
+	if (res->reserved + alloc_blocks < pre->q_prealloc_lo_wmark)
 		return false;
 
 	return true;
@@ -377,22 +387,35 @@ xfs_quota_calc_throttle(
 	int64_t			*qfreesp)
 {
 	struct xfs_dquot	*dq = xfs_inode_dquot(ip, type);
+	struct xfs_dquot_res	*res;
+	struct xfs_dquot_pre	*pre;
 	int64_t			freesp;
 	int			shift = 0;
 
+	if (!dq) {
+		res = NULL;
+		pre = NULL;
+	} else if (XFS_IS_REALTIME_INODE(ip)) {
+		res = &dq->q_rtb;
+		pre = &dq->q_rtb_prealloc;
+	} else {
+		res = &dq->q_blk;
+		pre = &dq->q_blk_prealloc;
+	}
+
 	/* no dq, or over hi wmark, squash the prealloc completely */
-	if (!dq || dq->q_blk.reserved >= dq->q_prealloc_hi_wmark) {
+	if (!res || res->reserved >= pre->q_prealloc_hi_wmark) {
 		*qblocks = 0;
 		*qfreesp = 0;
 		return;
 	}
 
-	freesp = dq->q_prealloc_hi_wmark - dq->q_blk.reserved;
-	if (freesp < dq->q_low_space[XFS_QLOWSP_5_PCNT]) {
+	freesp = pre->q_prealloc_hi_wmark - res->reserved;
+	if (freesp < pre->q_low_space[XFS_QLOWSP_5_PCNT]) {
 		shift = 2;
-		if (freesp < dq->q_low_space[XFS_QLOWSP_3_PCNT])
+		if (freesp < pre->q_low_space[XFS_QLOWSP_3_PCNT])
 			shift += 2;
-		if (freesp < dq->q_low_space[XFS_QLOWSP_1_PCNT])
+		if (freesp < pre->q_low_space[XFS_QLOWSP_1_PCNT])
 			shift += 2;
 	}
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 1c7d861dfbeceb..90d45aae5cb891 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -2178,6 +2178,8 @@ xfs_inode_near_dquot_enforcement(
 	xfs_dqtype_t		type)
 {
 	struct xfs_dquot	*dqp;
+	struct xfs_dquot_res	*res;
+	struct xfs_dquot_pre	*pre;
 	int64_t			freesp;
 
 	/* We only care for quotas that are enabled and enforced. */
@@ -2186,21 +2188,30 @@ xfs_inode_near_dquot_enforcement(
 		return false;
 
 	if (xfs_dquot_res_over_limits(&dqp->q_ino) ||
+	    xfs_dquot_res_over_limits(&dqp->q_blk) ||
 	    xfs_dquot_res_over_limits(&dqp->q_rtb))
 		return true;
 
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		res = &dqp->q_rtb;
+		pre = &dqp->q_rtb_prealloc;
+	} else {
+		res = &dqp->q_blk;
+		pre = &dqp->q_blk_prealloc;
+	}
+
 	/* For space on the data device, check the various thresholds. */
-	if (!dqp->q_prealloc_hi_wmark)
+	if (!pre->q_prealloc_hi_wmark)
 		return false;
 
-	if (dqp->q_blk.reserved < dqp->q_prealloc_lo_wmark)
+	if (res->reserved < pre->q_prealloc_lo_wmark)
 		return false;
 
-	if (dqp->q_blk.reserved >= dqp->q_prealloc_hi_wmark)
+	if (res->reserved >= pre->q_prealloc_hi_wmark)
 		return true;
 
-	freesp = dqp->q_prealloc_hi_wmark - dqp->q_blk.reserved;
-	if (freesp < dqp->q_low_space[XFS_QLOWSP_5_PCNT])
+	freesp = pre->q_prealloc_hi_wmark - res->reserved;
+	if (freesp < pre->q_low_space[XFS_QLOWSP_5_PCNT])
 		return true;
 
 	return false;

