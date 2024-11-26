Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74559C2C6;
	Tue, 26 Nov 2024 01:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584549; cv=none; b=AAQzC1TusFF+vvyd2CWDZfPZxVfyqV0xT3DUE+NcMZjxwXU6534FtmJQ9SG9G/Dqjz2shJV9SnomUlWC9BrGtOCpz9fJrxTT2Izr5pMkkR7vcwpTf8MzuBO+Cb02BZhA0YXH2EVgzKWb505FnSpmRpr9bORZoXEmRQ/p6wd3SDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584549; c=relaxed/simple;
	bh=DtR02jdxVUubWxzt6q69az9tmCnyzg7sQr8bK9u+0no=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e0oNIoluUzjmS90BEJop0S94cdwtuZ83968MUDS7FQiN5aieON2ucmxXhHClUzygbhr6mO+iQ5d2DcI0HvLQ4+G3oA4/69qiyVz9oGdGytvCgtuCLT3oG8MaOJ2c9CdWlQ6qwVrlWQuFfhLDfV681kYXY5diFLUxsjr1yyAaCbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oi9Dq4gi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oi9Dq4gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145F5C4CECE;
	Tue, 26 Nov 2024 01:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584549;
	bh=DtR02jdxVUubWxzt6q69az9tmCnyzg7sQr8bK9u+0no=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oi9Dq4gibPx4Jwyv3lx9p9DbuIbJocgt8vwo1E6vkpnIQbse0/eTo+cQO7xe1L0Pn
	 RGWNkz3/jBqhuy5pNA3fZnRUH2UYEi2njj877myvQEGg29GiqZCKjrdolNYRhFBak5
	 I85AAkZC2qb67SY2fuhs2HTBFNUC07EafKY6n+wHdiMcf8/WLkylzFrm732IjXijRT
	 UOotWI3v65KIi34dbv3VcU+gbstf3sKQuZf55kDjZoAYmbzF/LA4e//zp4kMopgb0s
	 fWgNwS1tJHiu8nKpAwYHYf/qK7YKcfeCVsKCrzwc8j4UnAEai3wvk/X+Ou5fagEyZR
	 7mbmty9+D2yig==
Date: Mon, 25 Nov 2024 17:29:08 -0800
Subject: [PATCH 17/21] xfs: don't lose solo dquot update transactions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258398090.4032920.6440798067032580972.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Quota counter updates are tracked via incore objects which hang off the
xfs_trans object.  These changes are then turned into dirty log items in
xfs_trans_apply_dquot_deltas just prior to commiting the log items to
the CIL.

However, updating the incore deltas do not cause XFS_TRANS_DIRTY to be
set on the transaction.  In other words, a pure quota counter update
will be silently discarded if there are no other dirty log items
attached to the transaction.

This is currently not the case anywhere in the filesystem because quota
updates always dirty at least one other metadata item, but a subsequent
bug fix will add dquot log item precommits, so we actually need a dirty
dquot log item prior to xfs_trans_run_precommits.  Also let's not leave
a logic bomb.

Cc: <stable@vger.kernel.org> # v2.6.35
Fixes: 0924378a689ccb ("xfs: split out iclog writing from xfs_trans_commit()")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_quota.h       |    7 ++++---
 fs/xfs/xfs_trans.c       |   10 +++-------
 fs/xfs/xfs_trans_dquot.c |   31 ++++++++++++++++++++++++++-----
 3 files changed, 33 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index fa1317cc396c96..b864ed59787780 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -101,7 +101,8 @@ extern void xfs_trans_free_dqinfo(struct xfs_trans *);
 extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
 		uint, int64_t);
 extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
-extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
+void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *tp,
+		bool already_locked);
 int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
 		int64_t dblocks, int64_t rblocks, bool force);
 extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
@@ -172,8 +173,8 @@ static inline void xfs_trans_mod_dquot_byino(struct xfs_trans *tp,
 		struct xfs_inode *ip, uint field, int64_t delta)
 {
 }
-#define xfs_trans_apply_dquot_deltas(tp)
-#define xfs_trans_unreserve_and_mod_dquots(tp)
+#define xfs_trans_apply_dquot_deltas(tp, a)
+#define xfs_trans_unreserve_and_mod_dquots(tp, a)
 static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
 		struct xfs_inode *ip, int64_t dblocks, int64_t rblocks,
 		bool force)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 427a8ba0ab99e2..4cd25717c9d130 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -866,6 +866,7 @@ __xfs_trans_commit(
 	 */
 	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
 		xfs_trans_apply_sb_deltas(tp);
+	xfs_trans_apply_dquot_deltas(tp);
 
 	error = xfs_trans_run_precommits(tp);
 	if (error)
@@ -894,11 +895,6 @@ __xfs_trans_commit(
 
 	ASSERT(tp->t_ticket != NULL);
 
-	/*
-	 * If we need to update the superblock, then do it now.
-	 */
-	xfs_trans_apply_dquot_deltas(tp);
-
 	xlog_cil_commit(log, tp, &commit_seq, regrant);
 
 	xfs_trans_free(tp);
@@ -924,7 +920,7 @@ __xfs_trans_commit(
 	 * the dqinfo portion to be.  All that means is that we have some
 	 * (non-persistent) quota reservations that need to be unreserved.
 	 */
-	xfs_trans_unreserve_and_mod_dquots(tp);
+	xfs_trans_unreserve_and_mod_dquots(tp, true);
 	if (tp->t_ticket) {
 		if (regrant && !xlog_is_shutdown(log))
 			xfs_log_ticket_regrant(log, tp->t_ticket);
@@ -1018,7 +1014,7 @@ xfs_trans_cancel(
 	}
 #endif
 	xfs_trans_unreserve_and_mod_sb(tp);
-	xfs_trans_unreserve_and_mod_dquots(tp);
+	xfs_trans_unreserve_and_mod_dquots(tp, false);
 
 	if (tp->t_ticket) {
 		xfs_log_ticket_ungrant(log, tp->t_ticket);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 481ba3dc9f190d..713b6d243e5631 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -606,6 +606,24 @@ xfs_trans_apply_dquot_deltas(
 			ASSERT(dqp->q_blk.reserved >= dqp->q_blk.count);
 			ASSERT(dqp->q_ino.reserved >= dqp->q_ino.count);
 			ASSERT(dqp->q_rtb.reserved >= dqp->q_rtb.count);
+
+			/*
+			 * We've applied the count changes and given back
+			 * whatever reservation we didn't use.  Zero out the
+			 * dqtrx fields.
+			 */
+			qtrx->qt_blk_res = 0;
+			qtrx->qt_bcount_delta = 0;
+			qtrx->qt_delbcnt_delta = 0;
+
+			qtrx->qt_rtblk_res = 0;
+			qtrx->qt_rtblk_res_used = 0;
+			qtrx->qt_rtbcount_delta = 0;
+			qtrx->qt_delrtb_delta = 0;
+
+			qtrx->qt_ino_res = 0;
+			qtrx->qt_ino_res_used = 0;
+			qtrx->qt_icount_delta = 0;
 		}
 	}
 }
@@ -642,7 +660,8 @@ xfs_trans_unreserve_and_mod_dquots_hook(
  */
 void
 xfs_trans_unreserve_and_mod_dquots(
-	struct xfs_trans	*tp)
+	struct xfs_trans	*tp,
+	bool			already_locked)
 {
 	int			i, j;
 	struct xfs_dquot	*dqp;
@@ -671,10 +690,12 @@ xfs_trans_unreserve_and_mod_dquots(
 			 * about the number of blocks used field, or deltas.
 			 * Also we don't bother to zero the fields.
 			 */
-			locked = false;
+			locked = already_locked;
 			if (qtrx->qt_blk_res) {
-				xfs_dqlock(dqp);
-				locked = true;
+				if (!locked) {
+					xfs_dqlock(dqp);
+					locked = true;
+				}
 				dqp->q_blk.reserved -=
 					(xfs_qcnt_t)qtrx->qt_blk_res;
 			}
@@ -695,7 +716,7 @@ xfs_trans_unreserve_and_mod_dquots(
 				dqp->q_rtb.reserved -=
 					(xfs_qcnt_t)qtrx->qt_rtblk_res;
 			}
-			if (locked)
+			if (locked && !already_locked)
 				xfs_dqunlock(dqp);
 
 		}

