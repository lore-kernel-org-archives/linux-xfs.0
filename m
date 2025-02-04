Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F98216E33;
	Tue,  4 Feb 2025 18:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695113; cv=none; b=mELOTk1nh2IVNVKORbdAPz9vKTTFI46UmSoY1B59AiwNTTe5VgtWzQVM5iILy7SFqcS2JgGHl0FA6bB6Yu0JUuQhvc9EluXlTxsC0GG0Qqeb5/OxEdrvcjW/UB6EPUeU3zLQ85XRgaaTldzoCHnyEqByF3gXCMtQt632XUwybaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695113; c=relaxed/simple;
	bh=sKLBbsxcmVe1BdfWL5MvVP1VT9jxZlXKwqyMH9LVXZg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dCHzVJzPWgTmshEklSTfJ4ndDQM4ZeKaIn61yIu8qrUZx0eF/+anje242kaL0q6ae7B0DXPmyOVWSeAvia9wPV0xrYtApxVceAFzhwC6DPsz0kOsADXAnxqf4vDEtCW2MeRt1DWVx+60lURbDmptmX8sVDInhIHe5TKsDakuk3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6kTHPcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6kTHPcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194C2C4CEDF;
	Tue,  4 Feb 2025 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738695113;
	bh=sKLBbsxcmVe1BdfWL5MvVP1VT9jxZlXKwqyMH9LVXZg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g6kTHPcSD2Su31Ldq0QmcvQDZC0cCTV8WNQQ1C3awE90ijhZWwDbiFmDcJlGXVBG3
	 gmwnIahOw7xlGnQKiT5jJKATz/D4a/wd8D1kVTyy31UcrlrUqP52Y3obvbOaxzJU/v
	 N/pQWH2ik1APrsLerlJS2DcR3yR8AgA9reAlXPLf2bd+Li2BU4inc46SdGJTNPyvmB
	 SS3+lMeyXQmbeFktQOQhcLeH+HqFagwC1DqdF7/hL/+ZpO5cHUxL5Q+i+NJyVS5y7B
	 mIws+MsmiVZTjGWZag0HcdiqXBV0xRwPNoj7uh1+qVlgAs6oX3Bbx30yAFSzj/HZQt
	 vUTYsCQOrwsRA==
Date: Tue, 04 Feb 2025 10:51:52 -0800
Subject: [PATCH 03/10] xfs: don't lose solo dquot update transactions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org
Cc: hch@lst.de, stable@vger.kernel.org
Message-ID: <173869499389.410229.5267576388058456974.stgit@frogsfrogsfrogs>
In-Reply-To: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
References: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

commit d00ffba4adacd0d4d905f6e64bd8cd87011f5711 upstream

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_quota.h       |    7 ++++---
 fs/xfs/xfs_trans.c       |   10 +++-------
 fs/xfs/xfs_trans_dquot.c |   31 ++++++++++++++++++++++++++-----
 3 files changed, 33 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 23d71a55bbc006..823c5d472dc0d5 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -96,7 +96,8 @@ extern void xfs_trans_free_dqinfo(struct xfs_trans *);
 extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
 		uint, int64_t);
 extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
-extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
+void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *tp,
+		bool already_locked);
 int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
 		int64_t dblocks, int64_t rblocks, bool force);
 extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
@@ -165,8 +166,8 @@ static inline void xfs_trans_mod_dquot_byino(struct xfs_trans *tp,
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
index ee46051db12dde..39cd11cbe21fcb 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -840,6 +840,7 @@ __xfs_trans_commit(
 	 */
 	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
 		xfs_trans_apply_sb_deltas(tp);
+	xfs_trans_apply_dquot_deltas(tp);
 
 	error = xfs_trans_run_precommits(tp);
 	if (error)
@@ -868,11 +869,6 @@ __xfs_trans_commit(
 
 	ASSERT(tp->t_ticket != NULL);
 
-	/*
-	 * If we need to update the superblock, then do it now.
-	 */
-	xfs_trans_apply_dquot_deltas(tp);
-
 	xlog_cil_commit(log, tp, &commit_seq, regrant);
 
 	xfs_trans_free(tp);
@@ -898,7 +894,7 @@ __xfs_trans_commit(
 	 * the dqinfo portion to be.  All that means is that we have some
 	 * (non-persistent) quota reservations that need to be unreserved.
 	 */
-	xfs_trans_unreserve_and_mod_dquots(tp);
+	xfs_trans_unreserve_and_mod_dquots(tp, true);
 	if (tp->t_ticket) {
 		if (regrant && !xlog_is_shutdown(log))
 			xfs_log_ticket_regrant(log, tp->t_ticket);
@@ -992,7 +988,7 @@ xfs_trans_cancel(
 	}
 #endif
 	xfs_trans_unreserve_and_mod_sb(tp);
-	xfs_trans_unreserve_and_mod_dquots(tp);
+	xfs_trans_unreserve_and_mod_dquots(tp, false);
 
 	if (tp->t_ticket) {
 		xfs_log_ticket_ungrant(log, tp->t_ticket);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index b368e13424c4f4..b92eeaa1a2a9e7 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -602,6 +602,24 @@ xfs_trans_apply_dquot_deltas(
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
@@ -638,7 +656,8 @@ xfs_trans_unreserve_and_mod_dquots_hook(
  */
 void
 xfs_trans_unreserve_and_mod_dquots(
-	struct xfs_trans	*tp)
+	struct xfs_trans	*tp,
+	bool			already_locked)
 {
 	int			i, j;
 	struct xfs_dquot	*dqp;
@@ -667,10 +686,12 @@ xfs_trans_unreserve_and_mod_dquots(
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
@@ -691,7 +712,7 @@ xfs_trans_unreserve_and_mod_dquots(
 				dqp->q_rtb.reserved -=
 					(xfs_qcnt_t)qtrx->qt_rtblk_res;
 			}
-			if (locked)
+			if (locked && !already_locked)
 				xfs_dqunlock(dqp);
 
 		}

