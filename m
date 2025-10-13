Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF8E35948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323789; cv=none; b=pGmXNyK2MRuHA1SQRGYUxRwpXbu+itdf1p0CdYKL9SmrggLKafXC49Go36e2S1AQH5iyw4dR3kIt6ZmVRS5y18UJV+qQ2MyHu++J1u/op1x5rgPoW/oaoB6bc+4po/h09THOKQWmSCpHTMnvQIZA0wKkBUBzjxUu2M07x21p/Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323789; c=relaxed/simple;
	bh=jgDpfm8Z57418qVoO6zMOa2UZScy5NVdB8Zk4r5i5e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoaqI58c+j0m3tlM0TOPnBi9LmieBKl+lqQHEsyDhHJ/M1AIyeIZuwAU3i21p1hxIE9UmdMe0FHb3snvEotQHkwZy65MjDsOm2+aPB4Dt4GYEAgOd2JunTgMFqLtNbxrCMjMcWqtBnWjF2wEhJZ7I2Ha3VMv0HBpV0OlpDD5EmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z7XjscVR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z7XjscVR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=J3YqrRudFyS4TFhJeGine1YVdEszSQxdmHV23NwDmAo=; b=Z7XjscVRZ+HrXyZ7ahrEoxu5dn
	G/vX5kXoU72AZv3VHgHt+w8aTO5vbWkoPBPd6oKyUDAGk1jg7Dqen3FaSyPx3wneHWVkt6nWmWmg5
	TEWhCpihgtbGfN+QRYseAJvI2M7iv9ZdTCjGzZHJvEQk3zycOmrvHkpfDzKpBNzfNWqZlxDWX4stm
	fqDArGn5/3BO4BxV5JPnxjqn42TaCg/oyLravZzTGidodFiK5LbzsUgocSOeUcHooBKU7fEbvU8vy
	9qxHs+7ZpjP2n0+06tonharYdQCOySDYaWJKquH3caxxM/NKws3Zapo09Qup92y7sNNbYXB3/Pz1y
	A2bcctnQ==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88d9-0000000C7ik-1KDY;
	Mon, 13 Oct 2025 02:49:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 12/17] xfs: push q_qlock acquisition from xchk_dquot_iter to the callers.
Date: Mon, 13 Oct 2025 11:48:13 +0900
Message-ID: <20251013024851.4110053-13-hch@lst.de>
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

There is no good reason to take q_qlock in xchk_dquot_iter, which just
provides a reference to the dquot.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index 00a4d2e75797..7897b93c639a 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -510,6 +510,7 @@ xrep_quota_problems(
 
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
+		mutex_lock(&dq->q_qlock);
 		error = xrep_quota_item(&rqi, dq);
 		xfs_qm_dqrele(dq);
 		if (error)
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
index f7b1add43a2c..de1521739ec9 100644
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -150,6 +150,7 @@ xqcheck_commit_dqtype(
 	 */
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
+		mutex_lock(&dq->q_qlock);
 		error = xqcheck_commit_dquot(xqc, dqtype, dq);
 		xfs_qm_dqrele(dq);
 		if (error)
-- 
2.47.3

