Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41C5C2C6
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609188; cv=none; b=mmlIbbdDzOh6h1jlfrCpaXcxaNRP8mHUi+bFVGnbnDZzprisoGZCtuG2YwllkiM6ILPFi2/3nYNHDZO27giFQjjX2HzBmNMLkZJL12jgKbCRDWwNlL2tvHlSLUMXdjJJJ5KIsSMwuDLYqEiHYV01lEa45sT1lpCjxeAJ1LAdYvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609188; c=relaxed/simple;
	bh=rWrnyAojbdf/fov36eiwJ5ZGgaMKtql7N2l+/R1I3H8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T3vJZyOU7Rg4JqZDKBHHl0bFGuaX5+DRryprgiePg9KtzxW9SLeGq3CzUiqG0nZa6hx5z+KrqdCvTXhv9XQhZDF8H3eUm01jwAhOsPujoy81xCJz6ovUDqOpj5tkw50UiUjjCksMGQ9/OutW+nZassUmBiDcTVxpmfSpsiTSp6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CPP/jkBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CPP/jkBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEFEC4CEC5;
	Fri, 11 Oct 2024 01:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609188;
	bh=rWrnyAojbdf/fov36eiwJ5ZGgaMKtql7N2l+/R1I3H8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CPP/jkBazUcO+k1oCducTm8irHa0Hpca3EkdxdrxUqPiiznQS2v8RT0NCDnoqi0ji
	 4U5pt/qkZkEd5GKgu8gDFDouOj2WfAl7IZoITlrfJ1NxtFDiDKbqpQu7MdZRlM0D85
	 zYiHZAjA97Lj33r6j7+h/vr5vOHBSty7GkTQ72ninElkAoSG49nAuK9HKQNiw6foNC
	 XewtadKGbHGOhzjQJrHK0CDPezzSVI0nf+QpC3qhIl9LPCzJbDNGHrK5NQ+kvVllrq
	 0eNj+XrLWt3bE552c4HDbfMUsPhVKFxH7Mguxm/a3GQBwM60ScE7JbCzwOp3ZHQqi9
	 lv2Tq6Eqzmj+g==
Date: Thu, 10 Oct 2024 18:13:07 -0700
Subject: [PATCH 4/6] xfs: create quota preallocation watermarks for realtime
 quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860645745.4180109.11610582297211837331.stgit@frogsfrogsfrogs>
In-Reply-To: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
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

Refactor the quota preallocation watermarking code so that it'll work
for realtime quota too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c |   41 +++++++++++++++++++++++++----------------
 fs/xfs/xfs_dquot.h |   18 ++++++++++++++----
 fs/xfs/xfs_iomap.c |   37 ++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_qm.c    |   21 ++++++++++++++++-----
 4 files changed, 85 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 3bf47458c517af..76c6bb9d907f5f 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -277,6 +277,29 @@ xfs_qm_init_dquot_blk(
 		xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
 }
 
+static void
+xfs_dquot_set_prealloc(
+	struct xfs_dquot_pre		*pre,
+	const struct xfs_dquot_res	*res)
+{
+	uint64_t			space;
+
+	pre->q_prealloc_hi_wmark = res->hardlimit;
+	pre->q_prealloc_lo_wmark = res->softlimit;
+	if (!pre->q_prealloc_lo_wmark) {
+		pre->q_prealloc_lo_wmark = pre->q_prealloc_hi_wmark;
+		do_div(pre->q_prealloc_lo_wmark, 100);
+		pre->q_prealloc_lo_wmark *= 95;
+	}
+
+	space = pre->q_prealloc_hi_wmark;
+
+	do_div(space, 100);
+	pre->q_low_space[XFS_QLOWSP_1_PCNT] = space;
+	pre->q_low_space[XFS_QLOWSP_3_PCNT] = space * 3;
+	pre->q_low_space[XFS_QLOWSP_5_PCNT] = space * 5;
+}
+
 /*
  * Initialize the dynamic speculative preallocation thresholds. The lo/hi
  * watermarks correspond to the soft and hard limits by default. If a soft limit
@@ -285,22 +308,8 @@ xfs_qm_init_dquot_blk(
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
index fc952fe6269385..d763ef7c9dddfa 100644
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

