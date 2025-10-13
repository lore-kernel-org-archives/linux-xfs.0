Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214D035948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323800; cv=none; b=AYExQQaVpzK+Tyu74gv1NA1d3ti4P++d1vXI9+3UX6HMRCrEgGlUczGmXbtla5+nFlzXqivuBq5KDH2YeX9F37qxndaJ1NQlJZTQ4R/ovpRn7uauE6AnT+fq+HVVRnkv9uFVQnYIj4maPlSAbD51nK1N/9cXfJf8Sts5h32hebA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323800; c=relaxed/simple;
	bh=bkvWEx8sdOusnxUhxpvc5LsGCSPT2nQYo+NkwOX0dWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmCEf8R/22xT4ziX+BrsYQIC9onZyQZZ7b2DKFbe6oXRbus2zGo01JiAuxkSHMOXXH7dmC3MjxsntXkZpFExKSAgmIH1F+vNnsN7scybz11ErS5oaGxHHSJAVgviW2+Bpnr3AswcCMPSDAhpjVQRBidSL2yvn82TXQtyKHIJjjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1y76xfKc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1y76xfKc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CFNSJ1vCM+L5H8f+YkZmQASbWvMxSfR5SY7RaKdLrKo=; b=1y76xfKcKNF7FvJw83JD79jxZW
	iAMJr1o1KG/dYi6icNZTE+EUFoxIqhyIC53CbbYpUd6RwAgaNgQlEMZStydFuqJdAFdfp0mWXmYh0
	kuWtc10qD0gHgW3jcdWaQv1zjmetBPa8hjSCNjaGACJL0EYFd/aB1vJjImII2TZkadnjJt7HFoTfF
	g1Zo0o2X8V+Y8lGAKeKDMx09bZVZ/e97L1ScmUeYQ9wqxtpbVQSt8y/dDALAmm3dI6xwWu6LcISjC
	i20QMbtAT8D0bkZscIisy/w0FJRKSjuqzIHYDfSKEEADpethd8rQVpSBD0f1CBFkafFGrRc370MtW
	S1b8+50Q==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88dK-0000000C7kJ-1IMC;
	Mon, 13 Oct 2025 02:49:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 15/17] xfs: move q_qlock acquisition into xqcheck_commit_dquot
Date: Mon, 13 Oct 2025 11:48:16 +0900
Message-ID: <20251013024851.4110053-16-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013024851.4110053-1-hch@lst.de>
References: <20251013024851.4110053-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This removes a pointless roundtrip because xqcheck_commit_dquot has to
drop the lock for allocating a transaction right now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quotacheck_repair.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index de1521739ec9..942df94e1215 100644
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
@@ -150,7 +148,6 @@ xqcheck_commit_dqtype(
 	 */
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
-		mutex_lock(&dq->q_qlock);
 		error = xqcheck_commit_dquot(xqc, dqtype, dq);
 		xfs_qm_dqrele(dq);
 		if (error)
@@ -182,7 +179,6 @@ xqcheck_commit_dqtype(
 		if (error)
 			return error;
 
-		mutex_lock(&dq->q_qlock);
 		error = xqcheck_commit_dquot(xqc, dqtype, dq);
 		xfs_qm_dqrele(dq);
 		if (error)
-- 
2.47.3

