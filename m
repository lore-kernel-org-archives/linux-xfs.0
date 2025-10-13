Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2697835948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323796; cv=none; b=ccBQwpmG7bLQQiSPqc2wuEgxi4geec/zdMXw4jhh35Nu7I1JtL3vQFfo71mFqeCxApWMByHgf/qhM6VI95T/pl+dIyK8xtVyJTMxrjHJhRff2+ymKZ82RbmGl/7krBV5boGP83Mt/2KGkkFa0TJI0EyyfCz3YIuDdrU0o81i99M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323796; c=relaxed/simple;
	bh=3RVuAdKCVht59qyyLnq1broLNiqnQY6jUhLrdS+Roy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wl8OBgG/l81ejMpC+0eYVSz1atlfK/219ar10xXoDd0czmb9U4MOnRqt3rjxnLRW+4AVV/ehsfLP6jAf6N2otlvDtpzBUntmnJaksEsMLkviQDQGbcmO4Eax/t9qVLFI8xJ/3kHmXZKY1wzbXxKVFXRZ7R+FRN3VJypAtDFvtto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IUyo9Ur3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IUyo9Ur3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sE4JyVccwSbdNo5gVnoYzZGAlUUVdgUfpeorpt9w9B4=; b=IUyo9Ur36hzNshmqJjHcTHxBQ/
	cPZg5cf61Ycz/Turjve1nwEnLCHuCy17BV9hRfUuBdCp4M9sfoj6CcJ0GcQLHoo8to3ssD/+qQ0cq
	9jT6LNljIgItuh0e9vQ+0W/Fxj7C8bvTnQJ72KxhOjhnRFs5sJibnJSExOs/4eVQBZOFdO8BSuylu
	fxLzciNZ5fPodRsSMeISRJknIcjn3c6tQaUDyHXjqalAphxn0Waqa4C6NvjWl7LJGLl8RHVK7wVJd
	i89g5VcieqaS38Ipsb1/VWr2iYOYVt1E5/yBh+8U+5SXCChsfpH8LzQ0en2WvJAAV21T3nQ98eH6T
	W7CLDdDA==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88dG-0000000C7kB-21wm;
	Mon, 13 Oct 2025 02:49:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 14/17] xfs: move q_qlock locking into xqcheck_compare_dquot
Date: Mon, 13 Oct 2025 11:48:15 +0900
Message-ID: <20251013024851.4110053-15-hch@lst.de>
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

Instead of having both callers do it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quotacheck.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index 20220afd90f1..cc2b2dfc9261 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -563,6 +563,7 @@ xqcheck_compare_dquot(
 		return -ECANCELED;
 	}
 
+	mutex_lock(&dq->q_qlock);
 	mutex_lock(&xqc->lock);
 	error = xfarray_load_sparse(counts, dq->q_id, &xcdq);
 	if (error)
@@ -590,6 +591,7 @@ xqcheck_compare_dquot(
 		error = -ECANCELED;
 	}
 	mutex_unlock(&xqc->lock);
+	mutex_unlock(&dq->q_qlock);
 	if (error)
 		return error;
 
@@ -635,9 +637,7 @@ xqcheck_walk_observations(
 		if (error)
 			return error;
 
-		mutex_lock(&dq->q_qlock);
 		error = xqcheck_compare_dquot(xqc, dqtype, dq);
-		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
 		if (error)
 			return error;
@@ -675,9 +675,7 @@ xqcheck_compare_dqtype(
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

