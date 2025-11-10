Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA94023C516
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781083; cv=none; b=UpehvHm8eW7WTABvVVJ0THphRytsOBbLMUWgwd4hGaU89jMk7gEwwsMRtEBPoCrWgcEkdcSZLZyyAG/bnl4fzR/fc6glRjIEhwSEs1H+CDz0OIh/82O8QJfndVKbbED3z6u2c5E0eHTR8qWLPybM2yg9tZzBqgb09PcwffQO9sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781083; c=relaxed/simple;
	bh=ZxZrwJ1k2FSJabxI9dqK21cYeIUQQxRyT6Rc92WPKOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgUBDNZHO7u3DdquwY6wBTSRxqoehMvLdXx49qLT0fS3NRcg70Yt134dItgAdc2GfBtAVDDH3xTPGdIi9EWQot4XIpf4OpdBM+0RUQLaV2kzGxGrSmR/D9cEoc6jawJmkiNVqhHeFhOt/HGoLUGTsHEK0GHy136/Ms8LKmdlX9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ElObC00A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ElObC00A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xc9eOaiiOLm6GtV7wVb9nxDG/F5Hp/nvNysnqEvlAHQ=; b=ElObC00Aqh1M8dayViF7+L2trY
	bKnYwomvrx/VMfQ3kRaJ38PH0dRLOv99cShDNUqheAE0sDu29eUGxyESPb8OMkHtZSuMiLNoFRmTt
	0vYFelx4GPnKbceM/+qiPl7LDGL6RRbex3n29YED3LUsED55sV8D8lxosXWUHlTZoZuroqoqEJnca
	QspyuG5v0AVDJllXOggdZ0rslGAdVscRwU8iITuz/UuLKtw1wi90cBeTdLJwffJOqdIR5HuKFsbGo
	8IK6mSEkm2a37js0ebYSs+g2DQYogcFabaDcUYH8NCm5gVG/E66WiWySwkCrK7motA98qA1TlS//i
	kfMmuy2g==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRsu-00000005UVc-3MCl;
	Mon, 10 Nov 2025 13:24:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 15/18] xfs: move quota locking into xqcheck_commit_dquot
Date: Mon, 10 Nov 2025 14:23:07 +0100
Message-ID: <20251110132335.409466-16-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110132335.409466-1-hch@lst.de>
References: <20251110132335.409466-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Drop two redundant lock roundtrips by not requiring q_lock to be held on
entry and return.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quotacheck_repair.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index 3013211fa6c1..51be8d8d261b 100644
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -52,13 +52,11 @@ xqcheck_commit_dquot(
 	bool			dirty = false;
 	int			error = 0;
 
-	/* Unlock the dquot just long enough to allocate a transaction. */
-	mutex_unlock(&dq->q_qlock);
 	error = xchk_trans_alloc(xqc->sc, 0);
-	mutex_lock(&dq->q_qlock);
 	if (error)
 		return error;
 
+	mutex_lock(&dq->q_qlock);
 	xfs_trans_dqjoin(xqc->sc->tp, dq);
 
 	if (xchk_iscan_aborted(&xqc->iscan)) {
@@ -115,23 +113,12 @@ xqcheck_commit_dquot(
 	if (dq->q_id)
 		xfs_qm_adjust_dqtimers(dq);
 	xfs_trans_log_dquot(xqc->sc->tp, dq);
-
-	/*
-	 * Transaction commit unlocks the dquot, so we must re-lock it so that
-	 * the caller can put the reference (which apparently requires a locked
-	 * dquot).
-	 */
-	error = xrep_trans_commit(xqc->sc);
-	mutex_lock(&dq->q_qlock);
-	return error;
+	return xrep_trans_commit(xqc->sc);
 
 out_unlock:
 	mutex_unlock(&xqc->lock);
 out_cancel:
 	xchk_trans_cancel(xqc->sc);
-
-	/* Re-lock the dquot so the caller can put the reference. */
-	mutex_lock(&dq->q_qlock);
 	return error;
 }
 
@@ -155,9 +142,7 @@ xqcheck_commit_dqtype(
 	 */
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
-		mutex_lock(&dq->q_qlock);
 		error = xqcheck_commit_dquot(xqc, dqtype, dq);
-		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
 		if (error)
 			break;
@@ -188,9 +173,7 @@ xqcheck_commit_dqtype(
 		if (error)
 			return error;
 
-		mutex_lock(&dq->q_qlock);
 		error = xqcheck_commit_dquot(xqc, dqtype, dq);
-		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
 		if (error)
 			return error;
-- 
2.47.3

