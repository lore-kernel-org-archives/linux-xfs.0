Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDCB35948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323794; cv=none; b=LqHACrJG09kTYcHRRi8NtAlExZ1kEo4/N8ztSTZW4qeuKyDFtYOJAxHDof2s6WJ0lmy664aO+N7I56QypZZp0IEkgp3OYuRlRG7Gt5pShNtsEXvwM99pOuOM3xB2irT5LqSn6hRvH8LImUPF/KOk9L5Aeu/eJEGIAXFy5FEP1wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323794; c=relaxed/simple;
	bh=m5VFJPapulUZMrFETNeWOQmbBH9p5MfjjtnLpp82QIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmTlvdrMKo1+PBvCfHy/kS8HWCYnNXGyv/dnx+aUa0JJ/1QNhiUotRYFLT8D/AN9KLvVDz/nv5YTFi5CvuT5THxn5hZaknP0NcIFlIqO9oaCDPv0pbCPPdFvg9e2QPaSNW5furs/noJW1aPOfIyKItnikcZ015Dd+slBMBrMU/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PHhR7ga1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PHhR7ga1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VpyVfYQAj7Yt2wnkHfYx4gROmMFJKDbd5QwIXnYx10Y=; b=PHhR7ga1gKiz+ykyXhEb74c/q/
	BBMHaidwA8DFY6O/Il/u1pgZQ8QzLy2ttl15fZoPLtx0UyhhLcxzoOdWDj18FUjvIkn9v8wFiFKjf
	TQ7LPH2Ee7Om6CyzoTRGq/yu3BGv63wwcbkmekri3v/GNspK0ocQ5wDxOw19JDQDuNifdvfnvz3nI
	fwGVvdm1bIIKmBmrJPEAUo7DU7T90nDdWz7/E3GUJ91uRGHRwGx5DFJiFBFbc7wQvd0RmOyP8rXBi
	6oO8Ki1r230dATuZ80/OCVYywHVXnng+Gun8ys3nH0CLcQpCbLivc7xaJkO9Z80cBNsd1bioB9RcN
	yAMHYFNA==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88dD-0000000C7jT-0tbz;
	Mon, 13 Oct 2025 02:49:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 13/17] xfs: move q_qlock locking into xchk_quota_item
Date: Mon, 13 Oct 2025 11:48:14 +0900
Message-ID: <20251013024851.4110053-14-hch@lst.de>
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

This avoids a pointless roundtrip because ilock needs to be taken first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quota.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index b711d36c5ec9..5c5374c44c5a 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -155,10 +155,7 @@ xchk_quota_item(
 	 * We want to validate the bmap record for the storage backing this
 	 * dquot, so we need to lock the dquot and the quota file.  For quota
 	 * operations, the locking order is first the ILOCK and then the dquot.
-	 * However, dqiterate gave us a locked dquot, so drop the dquot lock to
-	 * get the ILOCK.
 	 */
-	mutex_unlock(&dq->q_qlock);
 	xchk_ilock(sc, XFS_ILOCK_SHARED);
 	mutex_lock(&dq->q_qlock);
 
@@ -251,6 +248,7 @@ xchk_quota_item(
 	xchk_quota_item_timer(sc, offset, &dq->q_rtb);
 
 out:
+	mutex_unlock(&dq->q_qlock);
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return -ECANCELED;
 
@@ -329,9 +327,7 @@ xchk_quota(
 	/* Now look for things that the quota verifiers won't complain about. */
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
-		mutex_lock(&dq->q_qlock);
 		error = xchk_quota_item(&sqi, dq);
-		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
 		if (error)
 			break;
-- 
2.47.3

