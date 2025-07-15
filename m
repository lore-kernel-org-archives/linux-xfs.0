Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5702CCC5
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582366; cv=none; b=jd29Rmf/SVTM+hYju6OMRYoZ9e47XtawXzBpTMP055tq8EidnH0MCFO7rzKKTpl2zb7cdTmLBdpfMLQ5NlNdwzcEWD8/PIYtPu4c6nFejo/LZ1uNfosg8GKw6fdnAaQ0lkSkHDNBXOeQFVCnxrRGMjKKW/ueBG3qKZKxSXYICIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582366; c=relaxed/simple;
	bh=DzFEnxsyPMvIuAh9ig9xvm+mrBus3ZH8RUGgQV6eoDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeYsEtt5IkLEYpl1/9elDYaOr+rmNYH1XsygnoXXCQEQvwsaa9leAEg5GP32FLJt1KA837RYLb+bRkmdUIcRFSNkPf9qge/Kcv6OU2zVhmEqz1/YoeiLyQLIUZytMKb+d8rYg3AdIBn5Z5S8bRFa1iy2ewpzcuunZTCERF+FD3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=THGLl3I9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="THGLl3I9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=N6CdDJQUPqkln7tsORAbeq8fpRIca4CEMVT8rHP2LP0=; b=THGLl3I9dSlJs6BAfXupPPMO8h
	FVGRkBfEllS479t85BPI9lFZ5naCfsXJUHpqy2/HNXkz7+uuaPFTM6djMEbpBPTGmgZ7YsjU0BRGd
	m/uDcrG6Ceq6DPUlPWJ6dDykFrXyDogbIGHrS9l/ow8sTrlIQ9L2eRkaRwkfiSObLzks+rYJAr8bO
	W+IXK3od1q7twqpMBD6cLYximzi7qcRLsHY6RFZZNTvd+OND89LIHUvRGAgK9ULu16/kL10Byr1Gd
	AguxfJkVyDtn6uMbsnZowBKy+bAumj7Zqted7TWeMURwhnCgI/3DMzKutN+t1unvxb5tEtYAlLA1j
	McPoY3Dw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubejQ-000000053yg-1jUK;
	Tue, 15 Jul 2025 12:26:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: don't use xfs_trans_reserve in xfs_trans_roll
Date: Tue, 15 Jul 2025 14:25:37 +0200
Message-ID: <20250715122544.1943403-5-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715122544.1943403-1-hch@lst.de>
References: <20250715122544.1943403-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_trans_roll uses xfs_trans_reserve to basically just call into
xfs_log_regrant while bypassing the reset of xfs_trans_reserve.

Open code the call to xfs_log_regrant in xfs_trans_roll and simplify
xfs_trans_reserve now that it never regrants and always asks for a log
reservation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c | 122 +++++++++++++++++++--------------------------
 1 file changed, 51 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index e43f44f62c5f..553128b7f86a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -134,18 +134,14 @@ xfs_trans_dup(
 }
 
 /*
- * This is called to reserve free disk blocks and log space for the
- * given transaction.  This must be done before allocating any resources
- * within the transaction.
+ * This is called to reserve free disk blocks and log space for the given
+ * transaction before allocating any resources within the transaction.
  *
  * This will return ENOSPC if there are not enough blocks available.
  * It will sleep waiting for available log space.
- * The only valid value for the flags parameter is XFS_RES_LOG_PERM, which
- * is used by long running transactions.  If any one of the reservations
- * fails then they will all be backed out.
  *
- * This does not do quota reservations. That typically is done by the
- * caller afterwards.
+ * This does not do quota reservations. That typically is done by the caller
+ * afterwards.
  */
 static int
 xfs_trans_reserve(
@@ -158,10 +154,12 @@ xfs_trans_reserve(
 	int			error = 0;
 	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
+	ASSERT(resp->tr_logres > 0);
+
 	/*
-	 * Attempt to reserve the needed disk blocks by decrementing
-	 * the number needed from the number available.  This will
-	 * fail if the count would go below zero.
+	 * Attempt to reserve the needed disk blocks by decrementing the number
+	 * needed from the number available.  This will fail if the count would
+	 * go below zero.
 	 */
 	if (blocks > 0) {
 		error = xfs_dec_fdblocks(mp, blocks, rsvd);
@@ -173,42 +171,20 @@ xfs_trans_reserve(
 	/*
 	 * Reserve the log space needed for this transaction.
 	 */
-	if (resp->tr_logres > 0) {
-		bool	permanent = false;
-
-		ASSERT(tp->t_log_res == 0 ||
-		       tp->t_log_res == resp->tr_logres);
-		ASSERT(tp->t_log_count == 0 ||
-		       tp->t_log_count == resp->tr_logcount);
-
-		if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES) {
-			tp->t_flags |= XFS_TRANS_PERM_LOG_RES;
-			permanent = true;
-		} else {
-			ASSERT(tp->t_ticket == NULL);
-			ASSERT(!(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
-		}
-
-		if (tp->t_ticket != NULL) {
-			ASSERT(resp->tr_logflags & XFS_TRANS_PERM_LOG_RES);
-			error = xfs_log_regrant(mp, tp->t_ticket);
-		} else {
-			error = xfs_log_reserve(mp, resp->tr_logres,
-						resp->tr_logcount,
-						&tp->t_ticket, permanent);
-		}
-
-		if (error)
-			goto undo_blocks;
+	if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES)
+		tp->t_flags |= XFS_TRANS_PERM_LOG_RES;
+	error = xfs_log_reserve(mp, resp->tr_logres, resp->tr_logcount,
+			&tp->t_ticket, (tp->t_flags & XFS_TRANS_PERM_LOG_RES));
+	if (error)
+		goto undo_blocks;
 
-		tp->t_log_res = resp->tr_logres;
-		tp->t_log_count = resp->tr_logcount;
-	}
+	tp->t_log_res = resp->tr_logres;
+	tp->t_log_count = resp->tr_logcount;
 
 	/*
-	 * Attempt to reserve the needed realtime extents by decrementing
-	 * the number needed from the number available.  This will
-	 * fail if the count would go below zero.
+	 * Attempt to reserve the needed realtime extents by decrementing the
+	 * number needed from the number available.  This will fail if the
+	 * count would go below zero.
 	 */
 	if (rtextents > 0) {
 		error = xfs_dec_frextents(mp, rtextents);
@@ -221,18 +197,11 @@ xfs_trans_reserve(
 
 	return 0;
 
-	/*
-	 * Error cases jump to one of these labels to undo any
-	 * reservations which have already been performed.
-	 */
 undo_log:
-	if (resp->tr_logres > 0) {
-		xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
-		tp->t_ticket = NULL;
-		tp->t_log_res = 0;
-		tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
-	}
-
+	xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
+	tp->t_ticket = NULL;
+	tp->t_log_res = 0;
+	tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
 undo_blocks:
 	if (blocks > 0) {
 		xfs_add_fdblocks(mp, blocks);
@@ -1030,36 +999,41 @@ xfs_trans_cancel(
 }
 
 /*
- * Roll from one trans in the sequence of PERMANENT transactions to
- * the next: permanent transactions are only flushed out when
- * committed with xfs_trans_commit(), but we still want as soon
- * as possible to let chunks of it go to the log. So we commit the
- * chunk we've been working on and get a new transaction to continue.
+ * Roll from one trans in the sequence of PERMANENT transactions to the next:
+ * permanent transactions are only flushed out when committed with
+ * xfs_trans_commit(), but we still want as soon as possible to let chunks of it
+ * go to the log.  So we commit the chunk we've been working on and get a new
+ * transaction to continue.
  */
 int
 xfs_trans_roll(
 	struct xfs_trans	**tpp)
 {
 	struct xfs_trans	*trans = *tpp;
+	struct xfs_mount	*mp = trans->t_mountp;
 	struct xfs_trans_res	tres;
 	int			error;
 
 	trace_xfs_trans_roll(trans, _RET_IP_);
 
+	ASSERT(trans->t_log_res > 0);
+
 	/*
 	 * Copy the critical parameters from one trans to the next.
 	 */
 	tres.tr_logres = trans->t_log_res;
 	tres.tr_logcount = trans->t_log_count;
+	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 
 	*tpp = xfs_trans_dup(trans);
 
 	/*
 	 * Commit the current transaction.
-	 * If this commit failed, then it'd just unlock those items that
-	 * are not marked ihold. That also means that a filesystem shutdown
-	 * is in progress. The caller takes the responsibility to cancel
-	 * the duplicate transaction that gets returned.
+	 *
+	 * If this commit failed, then it'd just unlock those items that are not
+	 * marked ihold. That also means that a filesystem shutdown is in
+	 * progress.  The caller takes the responsibility to cancel the
+	 * duplicate transaction that gets returned.
 	 */
 	error = __xfs_trans_commit(trans, true);
 	if (error)
@@ -1067,14 +1041,20 @@ xfs_trans_roll(
 
 	/*
 	 * Reserve space in the log for the next transaction.
-	 * This also pushes items in the "AIL", the list of logged items,
-	 * out to disk if they are taking up space at the tail of the log
-	 * that we want to use.  This requires that either nothing be locked
-	 * across this call, or that anything that is locked be logged in
-	 * the prior and the next transactions.
+	 *
+	 * This also pushes items in the AIL out to disk if they are taking up
+	 * space at the tail of the log that we want to use.  This requires that
+	 * either nothing be locked across this call, or that anything that is
+	 * locked be logged in the prior and the next transactions.
 	 */
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-	return xfs_trans_reserve(*tpp, &tres, 0, 0);
+	trans = *tpp;
+	trans->t_flags |= XFS_TRANS_PERM_LOG_RES;
+	error = xfs_log_regrant(mp, trans->t_ticket);
+	if (error)
+		return error;
+	trans->t_log_res = tres.tr_logres;
+	trans->t_log_count = tres.tr_logcount;
+	return 0;
 }
 
 /*
-- 
2.47.2

