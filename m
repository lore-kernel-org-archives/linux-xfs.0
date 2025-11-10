Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1243919DF4F
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781079; cv=none; b=mKJN8jpvuphdbcLG/5fQgsb65z/1vYk0E7lWa1JAYh9mfm9/1FtiwxmGABGagdEWYPY1squ2Fyz2sWPViAr1BSUa+9iYyJ7tPXdiCuYV7YCGmk6Hz2RUyK5oHoWLr/2vh9KRp1wlQBs6J6PKjwJF77aPAI+J5KGGtKtXR3fu6yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781079; c=relaxed/simple;
	bh=df2DbsAxo+C6c7sYJgct2vBV+3RtT+flVm4u+Kigy0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXd7y8EqA8PLlTO5jBDwZnjIodfGor58cBeP3BLcGG4gwsP612T0zKcbdENtrQBLOoL7783BX1lbaciZhsqxp9IuFg/4hTDzZ5KlwwAJTlc4HKFzo+Kc3WtzMWwoZU4JqpfrmXUD7hLnQ97MqhU03a8HXYpMsvEwIv9JQDhMahQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K5nLWUMw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K5nLWUMw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=O6Y5csMYD68XBhEfTAhiHSdDe6CtPf3KN3aFxNiOinc=; b=K5nLWUMwC3SL9V+eq3Wo2vVqqD
	czdx/TLHdWisWKBE6advMv1Gl5ifVU+Xk23Wqfka0L2sHa68pwLgPQV7sThpsKKf7CwRw638f1M1t
	Z5PRgAl0evKgMh4xrgF6aJjvOQAXvEO4nfg1sO3YjYIa9K6x0VtOZKXjgcG83N4Xxvm2J9AcTok1j
	OMPhEX5pcgZsFcAGYozRlohRmvnu0rdwsS0RvB8p8aKC246VHfC/oOWGSJ6+SJX8yQMLbNBtejnHf
	EL/FaPFqkfeztL/nAyl7inyku2ZkaO04Aqh3sOTLO35BcRvibJwCeD8EFRvcdu/Havi0fUkrB2/he
	nQZsowuA==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRsr-00000005UVK-0uYd;
	Mon, 10 Nov 2025 13:24:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 14/18] xfs: move q_qlock locking into xqcheck_compare_dquot
Date: Mon, 10 Nov 2025 14:23:06 +0100
Message-ID: <20251110132335.409466-15-hch@lst.de>
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

Instead of having both callers do it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quotacheck.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index 20220afd90f1..d412a8359784 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -563,6 +563,7 @@ xqcheck_compare_dquot(
 		return -ECANCELED;
 	}
 
+	mutex_lock(&dq->q_qlock);
 	mutex_lock(&xqc->lock);
 	error = xfarray_load_sparse(counts, dq->q_id, &xcdq);
 	if (error)
@@ -589,7 +590,9 @@ xqcheck_compare_dquot(
 		xchk_set_incomplete(xqc->sc);
 		error = -ECANCELED;
 	}
+out_unlock:
 	mutex_unlock(&xqc->lock);
+	mutex_unlock(&dq->q_qlock);
 	if (error)
 		return error;
 
@@ -597,10 +600,6 @@ xqcheck_compare_dquot(
 		return -ECANCELED;
 
 	return 0;
-
-out_unlock:
-	mutex_unlock(&xqc->lock);
-	return error;
 }
 
 /*
@@ -635,9 +634,7 @@ xqcheck_walk_observations(
 		if (error)
 			return error;
 
-		mutex_lock(&dq->q_qlock);
 		error = xqcheck_compare_dquot(xqc, dqtype, dq);
-		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
 		if (error)
 			return error;
@@ -675,9 +672,7 @@ xqcheck_compare_dqtype(
 	/* Compare what we observed against the actual dquots. */
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
-		mutex_lock(&dq->q_qlock);
 		error = xqcheck_compare_dquot(xqc, dqtype, dq);
-		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
 		if (error)
 			break;
-- 
2.47.3

