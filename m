Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295E722579E
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781075; cv=none; b=JsUWnLm3cQ3R9h3r2llRpMDNIKDwiEZy8r9nh4H68EWE5DABofUEX2sfuUciqjTck/7B8PBoCynQbSYDBQ5+IcGvzUhH0A+qyGFKK+1/jjj3ugMKHiRyu0FNZhiNASvkmxFKI3PnTi1r2afgMqNvawfAFkaickqDxcV043dnI8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781075; c=relaxed/simple;
	bh=8SKoRgasxGPzLlpgWkfIKcR1Dru6bP6rqbaybUbHUaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=so/LT10vewZC97tXUJ+do8eFUB5r3TuW2sLWO5pBgF1cCeZCfBThjfiBgQmgN7QGtL5sWhzY311WVp3UEurd9AsE2Nh0kFhWGdj39dFG7mDs7QKOrNJUAagwk/su9E1JNIaN0U3vl26yZOiMnKY8UzhVYwIYtmpEBRErD582rtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KdBcxpAv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KdBcxpAv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wOQ7yFcFwPAVciEjU3LEDRyLczNKfJDfN3DG+8W+y54=; b=KdBcxpAvqafJgTc+yTIGYmRtlF
	8uQsctKIk6MK8iq6DDwFeH3oLd2M/bTiyQ5wcLN+B24GTte9kZVMGRzQ/2Y4GGTZjgHL1NdNCnx6Z
	YxNnMvnCAwYCopJ1yXSdoQjuPuq9xzfWLNdUOPl27FjZWlgK8ICQaDaZKqB+6M/RPj3JIgGa2Bkry
	Zr1X2Ww8zPJVJTCqP6FJRnd1tEwkgguGEJcymoIIfMv/52ecFAo0YbrFG4/q3pKH0xfWOGi+elqkI
	TDF/xbVp5WP0Di9Oytzt+tzvCaRFoOCKLAy6PPq161aWmrubTE2QDny+sleXWvTcHR/N8slucDzJ/
	3rOBcZ+g==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRsn-00000005UVC-1HGa;
	Mon, 10 Nov 2025 13:24:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 13/18] xfs: move q_qlock locking into xchk_quota_item
Date: Mon, 10 Nov 2025 14:23:05 +0100
Message-ID: <20251110132335.409466-14-hch@lst.de>
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

This avoids a pointless roundtrip because ilock needs to be taken first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

