Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0678C35948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323758; cv=none; b=A87gz3Vduvq1Zvzi+Zeovnv0FK1QoNIDkL3p6KedGl3d30MbSKIOhlJK48GmLh+rw79FjcNwh5xxFMG1aWp31dVAKua8RKOPIuAJNa3qwsv7nBUinlURSz/xpmEjSNRAU6cJ8581yYa+nG+9foyxkxuvXuu6TXmMgcZxA3/ingo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323758; c=relaxed/simple;
	bh=ClFOv1PaQQGWBhKkIooCqQ5XbyKzZ+R7xkBiqL/mzR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVykOm0qFYlBKVk31mr0mUPN1xv2gWWRLuieDvMFZScWwU+0FtU5YyUcp6i9K487rNdT0U8cYcDxHa7DRJ02B//mI6M68lF3UpGRtNyOfpEw0C1IwNkhszd+M16nT3Bo8LHImotdk1urdiRaiOQF4+eWEkINl1zoQFzQBda9/gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rUc5WVco; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rUc5WVco"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PtMXomQrPLHaAh8yv9z4dcGdWZcp2uIG83BSc9kDaU8=; b=rUc5WVcoCTQCsKeMQIPIV9J2/u
	P++63xOHglPq+6xXNDzfsQ7Lo8ey3v3EqtV48JPq2qX/QFX4dTWyA/hCDT6ksOqNlEv0FM+M03iRF
	TyOor9zs76rk4YgqyF1u/jlaIb8PAIY7/h/g7O6qdjy4wdFLAfMnqdF767iohcCoUDmAogGzQFG37
	Dulv8VCwcAJEDT9fflNwrTMiNsUqhNyREIvIQC+d5t/Kalhd0SrihNEnB+WCKEB7+zD7VjFAeebpw
	AubdvosPa4w0vkk70IUDHZXa2bAgBAHvWsSGHJXRNTyfRlkc2t7WkfeXRvm2ZoDdF4DoKfFA4VBpM
	12f0wKyA==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88cd-0000000C7e0-3goV;
	Mon, 13 Oct 2025 02:49:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 04/17] xfs: don't lock the dquot before return in xrep_quota_item
Date: Mon, 13 Oct 2025 11:48:05 +0900
Message-ID: <20251013024851.4110053-5-hch@lst.de>
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

While xfs_qm_dqput requires the dquot to be locked, the caller can use
the more common xfs_qm_dqrele helper that takes care of locking the
dquot instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quota_repair.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 8c89c6cc2950..00a4d2e75797 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -257,9 +257,7 @@ xrep_quota_item(
 		xfs_qm_adjust_dqtimers(dq);
 	}
 	xfs_trans_log_dquot(sc->tp, dq);
-	error = xfs_trans_roll(&sc->tp);
-	mutex_lock(&dq->q_qlock);
-	return error;
+	return xfs_trans_roll(&sc->tp);
 }
 
 /* Fix a quota timer so that we can pass the verifier. */
@@ -513,7 +511,7 @@ xrep_quota_problems(
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
 		error = xrep_quota_item(&rqi, dq);
-		xfs_qm_dqput(dq);
+		xfs_qm_dqrele(dq);
 		if (error)
 			break;
 	}
-- 
2.47.3

