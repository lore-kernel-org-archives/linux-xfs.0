Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023C93101C5
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781086; cv=none; b=hwpHsmgfQ3gIoMefI2F9G7WARrdyp5RqWRYQO74M8GSftSP9vmdNsSYfcxiZU1wR9zoxr/mJIiK9fRlFJ+VZTpMBIlR37szOqtwUkBllo/uO8aVGK9llQxp8TuRlCDAvyT+OckV4BgzgQIWqo1Lo3slGqcWWVT4c8X74H+l8Lt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781086; c=relaxed/simple;
	bh=a/IpGjzqJQ4SlraI9Ly8ZchNBVTNXel+u43vif3MWj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0GG1YVOcMivi8asvTwBaPsKHQ8TqixtFFtwSkMaybwRDxmWGkNR9aKXttAzkK5gxLg+UChqIvb9xnhfQd3OZwW+Vm8/8CbBUafJWjJCK2xUN1yevQ++GOzI+97LgM8CzZZ+/10Y7YAdqxHAHELHxyTkaeROlBC+qHFC7rFcmfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KKjJCq0o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KKjJCq0o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=v2MaZnU0QUEO2FpucWaki1X02itVD0OxSLsu4ctp7bc=; b=KKjJCq0oJBywLTGLt4CzFH6Zs2
	NFC6swZMPvuPudMiEYulhuP9TnZ5MiCbf/VZ3TdOl/Q+NgsX95CdKtFV5wahOrx51budKtny7hFmn
	x0NDZanMWK3avJDJ4fwp+qCMInc9fluH9ROBsPnWecUn9gIzn5zU7bT+OdJGYo27MedKMHtjEc99S
	r/SAyGcOxnRcDP+rSOS9bNhvTnMKfMYNifbdeholBGq5tyIbNau6Bg5NfB2TVxoRkXXJXiY8QHT50
	/Mn2b2z2+eVX0VexjtznQ3wMzA9rtIJQMlZkQL32Lbyjk2T6Sw1xWWeQBeDKJdk/87B5W0aZgUpg4
	w/VXYCpg==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRsy-00000005UVx-0OyN;
	Mon, 10 Nov 2025 13:24:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 16/18] xfs: move quota locking into xrep_quota_item
Date: Mon, 10 Nov 2025 14:23:08 +0100
Message-ID: <20251110132335.409466-17-hch@lst.de>
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
 fs/xfs/scrub/quota_repair.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index dae4889bdc84..b1d661aa5f06 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -184,17 +184,13 @@ xrep_quota_item(
 	/*
 	 * We might need to fix holes in the bmap record for the storage
 	 * backing this dquot, so we need to lock the dquot and the quota file.
-	 * dqiterate gave us a locked dquot, so drop the dquot lock to get the
-	 * ILOCK_EXCL.
 	 */
-	mutex_unlock(&dq->q_qlock);
 	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	mutex_lock(&dq->q_qlock);
-
 	error = xrep_quota_item_bmap(sc, dq, &dirty);
 	xchk_iunlock(sc, XFS_ILOCK_EXCL);
 	if (error)
-		return error;
+		goto out_unlock_dquot;
 
 	/* Check the limits. */
 	if (dq->q_blk.softlimit > dq->q_blk.hardlimit) {
@@ -246,7 +242,7 @@ xrep_quota_item(
 	xrep_quota_item_timer(sc, &dq->q_rtb, &dirty);
 
 	if (!dirty)
-		return 0;
+		goto out_unlock_dquot;
 
 	trace_xrep_dquot_item(sc->mp, dq->q_type, dq->q_id);
 
@@ -257,8 +253,10 @@ xrep_quota_item(
 		xfs_qm_adjust_dqtimers(dq);
 	}
 	xfs_trans_log_dquot(sc->tp, dq);
-	error = xfs_trans_roll(&sc->tp);
-	mutex_lock(&dq->q_qlock);
+	return xfs_trans_roll(&sc->tp);
+
+out_unlock_dquot:
+	mutex_unlock(&dq->q_qlock);
 	return error;
 }
 
@@ -512,9 +510,7 @@ xrep_quota_problems(
 
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
-		mutex_lock(&dq->q_qlock);
 		error = xrep_quota_item(&rqi, dq);
-		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
 		if (error)
 			break;
-- 
2.47.3

