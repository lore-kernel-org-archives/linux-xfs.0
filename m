Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49CC35948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323754; cv=none; b=RyILtKZ1F4Tx+fMNFZQOND480TYwBT0uoqDbDLjEAa/nlvb+8tQseqHP0nEsA/m05kXZSPL109HiFFUevrDsF6AG4wkxlPoSN6Ll9g+new0IwQxuar89qYiMhVtoh41h8wU6xXjcjmXruhZnUCkHppSJeVXF67m0anZHdxlhG50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323754; c=relaxed/simple;
	bh=S/sX/s8NMggt9iJqWecu7z9OmLeidyD7uTJCkzJrWok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGAXAAeMLcxP4cJsOPkgPrrqcSU/HYbwG/pSpU18g7aoKzRMUwmSypruLCble+ui0L1FjZChZHduPXU1K3EKmEZa2oz3THQV84rkcmg6KVNcqgYA6dYgBTW/GAm7vyyX+17Qn82xc+1k94tnfL9ziylP4kgGwEMJnVz2p+ZBhvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f7CUmin+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f7CUmin+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lihNmkw18rZdNIxjRRtxbMF+KwVbrXs/STzvWNJaZZc=; b=f7CUmin+JfWxUJtWVJXKHuvalf
	F+w4HYYAocY0oLJ2ei1ktxb5gEPwTeuU9dXLJLZOmGl6637DbTv0nmc2HjByDia3od8H5ZkHt2WKr
	CacEJzVW1C7C2n1Ce/r7OkngkZEx+l29nlCW11Cij7pXhsMzDPlfPWoe/WXzVyt5BonMWMUmMFjmy
	/b5JlWyPMOlHfDb3fkB6WwSBnH4XXitoJl57xvVBmb1ka076/3m/sxVykq/eksO2laf16lw2LBoi7
	18bID82r18d31Vc9nLy/XpRrrojBvXccyEIshSzsFls7GOBDgDckrJCkkBi7D+ThUoF8khvTKngiS
	PqoG5Ihw==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88ca-0000000C7dq-1109;
	Mon, 13 Oct 2025 02:49:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 03/17] xfs: don't lock the dquot before return in xqcheck_commit_dquot
Date: Mon, 13 Oct 2025 11:48:04 +0900
Message-ID: <20251013024851.4110053-4-hch@lst.de>
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

While xfs_qm_dqput requires the dquot to be locked, the callers can use
the more common xfs_qm_dqrele helper that takes care of locking the dquot
instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quotacheck_repair.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index 415314911499..67bdc872996a 100644
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -121,17 +121,12 @@ xqcheck_commit_dquot(
 	 * the caller can put the reference (which apparently requires a locked
 	 * dquot).
 	 */
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
 
@@ -156,7 +151,7 @@ xqcheck_commit_dqtype(
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
 		error = xqcheck_commit_dquot(xqc, dqtype, dq);
-		xfs_qm_dqput(dq);
+		xfs_qm_dqrele(dq);
 		if (error)
 			break;
 	}
@@ -187,7 +182,7 @@ xqcheck_commit_dqtype(
 			return error;
 
 		error = xqcheck_commit_dquot(xqc, dqtype, dq);
-		xfs_qm_dqput(dq);
+		xfs_qm_dqrele(dq);
 		if (error)
 			return error;
 
-- 
2.47.3

