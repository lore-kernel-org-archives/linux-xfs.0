Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A24376BC1;
	Wed, 23 Sep 2026 05:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143059; cv=none; b=c70mfItcbIHPLN4jiuSY0ZoPEGeQvEdf8xAX9Iy30ZfY5VjXnvZcwBAKAKAmBMuhUpm4YSkGECdW+55IbrYJ/dq3LdladPtmQnZw4pAlWEbleb3PGjn+kWcPp3Tv/0ofVTNZo1t70/nouBcY+z3jRfvxgfJHBlUkK2BIqj5ppFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143059; c=relaxed/simple;
	bh=yjrJ+nTMGFAHSOHe9/wsLPj7L9IZLkNAfdh3jq08Frg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l6ia4JYdlWj/s/181XzvOEuZ71qbiu0BJs1CiLrozZo3y8rLumxmpPrVGvDE0/fIal2UOU/yDCvYruxGON+Dnoa184phY9OGK/ITpUQ9wvW3kvJBAn/FVS/XSCehQDo28eDm4PHz76fCLxWawRicB6s8zLdcEdNlccb8Cj8OcYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nu3cmLCi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nu3cmLCi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E09CD1F000FF;
	Wed, 23 Sep 2026 05:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143058;
	bh=bfmBxeruR5Q1l9OSO4tBrzA8Du3y8huwypZ6Elwe0uQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=nu3cmLCigb2i26iHW+4XVRR4qfx8e+AzCuWUdKjEf1HfDlsu09GgV+O+YClYQGgny
	 wQUTsw7TS8I/96jR3nxG2QPh0jYpKNjK3J0lH7OB4FV0zeiuH88ZHzHSvQEShtdUaf
	 Z9fqr+V5684Ut08zLI2JlnQNcUy1Sf6UZANqx23+8Ak01fk+weoaFXUjqc6czmGFfn
	 Oug+HatH6osXGF16Pq+SGwkCqkIfZr+B2Jf9X1Y7i8gzvU0nWwLmh6YaoiKcpa5PCu
	 jJQr9mBdm/2xhRjlJE2nB6G9+DTf0+I2Vwo94t28avgzm3v5a0T9BO8N2Nkx1dMLVY
	 WZ1bQthVw7CSg==
Date: Tue, 22 Sep 2026 22:57:37 -0700
Subject: [PATCH 01/13] xfs: fix missing xfs_qm_adjust_dqlimits call in
 quotacheck repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014158950.1874904.17381414197584262088.stgit@frogsfrogsfrogs>
In-Reply-To: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
References: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that everywhere else in the kernel, a call to
xfs_qm_adjust_dqlimits precedes every call to xfs_qm_adjust_dqtimers.
In particular, mount-time quotacheck does this, but online quotacheck
does not.

Looking at xfs_qm_adjust_dqlimits, that function is in charge of
conveying default limits to a dquot if that dquot's limits have been
zeroed.  That's quite possible in a repair, so we actually need to do
that.

However, there's a pre-existing pattern in the kernel -- for non-root
dquots, first we call xfs_qm_adjust_dqlimits to set the dquot's limits
to the defaults if they are zero, and then xfs_qm_adjust_dqtimers to
start grace periods if the dquot's usage is above the softlimit.  The
grace period decision cannot be made correctly if we forget to import
the default limits.

Therefore, let's combine both into a single xfs_qm_adjust_dqenforcement
helper that takes care of both pieces, which fixes quotacheck and makes
it hard to repeat this mistake.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: 96ed2ae4a9b06b ("xfs: repair dquots based on live quotacheck results")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.h               |    2 +-
 fs/xfs/scrub/quota_repair.c      |    5 +----
 fs/xfs/scrub/quotacheck_repair.c |    3 +--
 fs/xfs/xfs_dquot.c               |   20 +++++++++++++++-----
 fs/xfs/xfs_qm.c                  |    6 +-----
 fs/xfs/xfs_trans_dquot.c         |    6 +-----
 6 files changed, 20 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index bbb824adca82ce..28c09704acc261 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -205,7 +205,7 @@ void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
 int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf *bp);
 void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
 void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
-void		xfs_qm_adjust_dqlimits(struct xfs_dquot *d);
+void		xfs_qm_adjust_dqenforcement(struct xfs_dquot *d);
 xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
 				xfs_dqtype_t type);
 int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 59302e8afc7ef0..89f7ea4f92ef4a 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -248,10 +248,7 @@ xrep_quota_item(
 
 	dq->q_flags |= XFS_DQFLAG_DIRTY;
 	xfs_trans_dqjoin(sc->tp, dq);
-	if (dq->q_id) {
-		xfs_qm_adjust_dqlimits(dq);
-		xfs_qm_adjust_dqtimers(dq);
-	}
+	xfs_qm_adjust_dqenforcement(dq);
 	xfs_trans_log_dquot(sc->tp, dq);
 	return xfs_trans_roll(&sc->tp);
 
diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index dbb522e1513b0b..48ee08df302a42 100644
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -110,8 +110,7 @@ xqcheck_commit_dquot(
 
 	/* Commit the dirty dquot to disk. */
 	dq->q_flags |= XFS_DQFLAG_DIRTY;
-	if (dq->q_id)
-		xfs_qm_adjust_dqtimers(dq);
+	xfs_qm_adjust_dqenforcement(dq);
 	xfs_trans_log_dquot(xqc->sc->tp, dq);
 	return xrep_trans_commit(xqc->sc);
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index e696ee36c2e8d2..6d22ead562da58 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -115,18 +115,15 @@ xfs_qm_dqdestroy(
  * We overwrite the dquot limits only if they are zero and this
  * is not the root dquot.
  */
-void
+static void
 xfs_qm_adjust_dqlimits(
 	struct xfs_dquot	*dq)
 {
 	struct xfs_mount	*mp = dq->q_mount;
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_def_quota	*defq;
+	struct xfs_def_quota	*defq = xfs_get_defquota(q, xfs_dquot_type(dq));
 	int			prealloc = 0;
 
-	ASSERT(dq->q_id);
-	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
-
 	if (!dq->q_blk.softlimit) {
 		dq->q_blk.softlimit = defq->blk.soft;
 		prealloc = 1;
@@ -223,6 +220,19 @@ xfs_qm_adjust_dqtimers(
 	xfs_qm_adjust_res_timer(dq->q_mount, &dq->q_rtb, &defq->rtb);
 }
 
+/* Adjust enforcement limits and timers after a change in usage. */
+void
+xfs_qm_adjust_dqenforcement(
+	struct xfs_dquot	*dq)
+{
+	if (dq->q_id == 0)
+		return;
+
+	xfs_qm_adjust_dqlimits(dq);
+	xfs_qm_adjust_dqtimers(dq);
+	dq->q_flags |= XFS_DQFLAG_DIRTY;
+}
+
 /*
  * initialize a buffer full of dquots and log the whole thing
  */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 54d00d543b513a..008fed8624be2c 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1294,11 +1294,7 @@ xfs_qm_quotacheck_dqadjust(
 	 *
 	 * There are no timers for the default values set in the root dquot.
 	 */
-	if (dqp->q_id) {
-		xfs_qm_adjust_dqlimits(dqp);
-		xfs_qm_adjust_dqtimers(dqp);
-	}
-
+	xfs_qm_adjust_dqenforcement(dqp);
 	dqp->q_flags |= XFS_DQFLAG_DIRTY;
 out_unlock:
 	mutex_unlock(&dqp->q_qlock);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 1606c614f205ae..93ec876792cc76 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -566,11 +566,7 @@ xfs_trans_apply_dquot_deltas(
 			 * Get any default limits in use.
 			 * Start/reset the timer(s) if needed.
 			 */
-			if (dqp->q_id) {
-				xfs_qm_adjust_dqlimits(dqp);
-				xfs_qm_adjust_dqtimers(dqp);
-			}
-
+			xfs_qm_adjust_dqenforcement(dqp);
 			dqp->q_flags |= XFS_DQFLAG_DIRTY;
 			/*
 			 * add this to the list of items to get logged

