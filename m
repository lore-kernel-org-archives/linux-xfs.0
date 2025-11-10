Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5049922579E
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781072; cv=none; b=W12WLVeU7jsQBMBjD0JZRy9yqUwYNd50QbZkpxFUot+fF9zeAEF8/tJ6l6YenWPkmtpXQd2TKNfpwqxjOZOeh0uwxCxnM0kU96ZALX+6WgNS4Z9PYM3tmW8JpEY2SK0JRuQlBQHYNyNLKFuTRKe4h7NsbPdyo3ivJCOb/V46giM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781072; c=relaxed/simple;
	bh=VjZCBoWRVE2IJTVijw11pwlQ6lZseVJuEMPSrhaLkdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/nQrCnU6Dcn2biTOE6B4r/Qvd6k29aMsou1P/m2z0fWLXYopFaT95lCgY0IxTHI1LvZcE9+7ncG/ZyJxeEVDw9Ce+wVLU0oItwu7IqWCar28KOSIiJo9wwX9e2EBgTQgAByol7r8c+8xBy3knbFIRYshxXtSCEWe4R6lGbHEJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ykbb64Nn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ykbb64Nn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iDaMFPfeb/Spkhlmz/yAS7Su3Cq8pi0coMgawYoCK8U=; b=ykbb64Nn3chpSMaf9lgkvGSEpu
	SP4EapEzMwFl8hvsDAxuXnxM0llWb5qH3Ch1oqd0IoyEacs6wi5p154l56Ci4PdlP1vRL8qXOzkVK
	0B1mlqJ1Uze3m22/KsIT+Ha6CAd0HsjJhOQd77umkMgW70WFgw5aNWRmm1qfbuPZBQ72pnYBnDXju
	ZD+pMFGssWUbD5LOuoV5o1vxU9xRvunKMT/kKydJVonr6jgKg8DTGcqbzN71KHoJV3PyBQDPhKwAI
	D39DfgAKf7jtCmTEpytPwfo3Cae6wO29UIisjPSKAX0auGNLeKZfFIPPTsbGeAhjRfT6fwFPM+SCG
	BVAuUs8A==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRsj-00000005UV3-1v1a;
	Mon, 10 Nov 2025 13:24:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 12/18] xfs: push q_qlock acquisition from xchk_dquot_iter to the callers.
Date: Mon, 10 Nov 2025 14:23:04 +0100
Message-ID: <20251110132335.409466-13-hch@lst.de>
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

There is no good reason to take q_qlock in xchk_dquot_iter, which just
provides a reference to the dquot.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/dqiterate.c         | 1 -
 fs/xfs/scrub/quota.c             | 1 +
 fs/xfs/scrub/quota_repair.c      | 1 +
 fs/xfs/scrub/quotacheck.c        | 1 +
 fs/xfs/scrub/quotacheck_repair.c | 1 +
 5 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dqiterate.c b/fs/xfs/scrub/dqiterate.c
index 6f1185afbf39..20c4daedd48d 100644
--- a/fs/xfs/scrub/dqiterate.c
+++ b/fs/xfs/scrub/dqiterate.c
@@ -205,7 +205,6 @@ xchk_dquot_iter(
 	if (error)
 		return error;
 
-	mutex_lock(&dq->q_qlock);
 	cursor->id = dq->q_id + 1;
 	*dqpp = dq;
 	return 1;
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index cfcd0fb66845..b711d36c5ec9 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -329,6 +329,7 @@ xchk_quota(
 	/* Now look for things that the quota verifiers won't complain about. */
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
+		mutex_lock(&dq->q_qlock);
 		error = xchk_quota_item(&sqi, dq);
 		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index d4ce9e56d3ef..dae4889bdc84 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -512,6 +512,7 @@ xrep_quota_problems(
 
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
+		mutex_lock(&dq->q_qlock);
 		error = xrep_quota_item(&rqi, dq);
 		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index bef63f19cd87..20220afd90f1 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -675,6 +675,7 @@ xqcheck_compare_dqtype(
 	/* Compare what we observed against the actual dquots. */
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
+		mutex_lock(&dq->q_qlock);
 		error = xqcheck_compare_dquot(xqc, dqtype, dq);
 		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index 3b23219d43ed..3013211fa6c1 100644
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -155,6 +155,7 @@ xqcheck_commit_dqtype(
 	 */
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
+		mutex_lock(&dq->q_qlock);
 		error = xqcheck_commit_dquot(xqc, dqtype, dq);
 		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
-- 
2.47.3

