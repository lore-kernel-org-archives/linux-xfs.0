Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9146C13C82E
	for <linux-xfs@vger.kernel.org>; Thu, 31 Jul 2025 14:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753971584; cv=none; b=b+aCMaNyKl53zXlov/Gn7bv10j6HH2CBp6PcZx049jV9fLshDwLhc8fhnYLGqOmTxzlbRqBovQpYc/o2lRd713wYvXHyG+/237FjggmBSqkhLuATM6y7QEqFUMcoB7vjtxqV1GWlMlV2EzL5L61DPgrtnFil5dCx6LqEhbM++DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753971584; c=relaxed/simple;
	bh=AiyoAOoYvyWIztfzU0iLet0oAcUyrjLRriZGPGIUR2g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mar83ajbmeNFcXEKwuaxp+tTOFbVHoqhulFyiLjd19TWVdlXSvS06z72oBrdtkIflTsDEtmd6FO/AvR2l0i7ymgXmLGap05ho/3cWxQ6gmF/6mL1RKqBYBE6slcP2UyMHvRST1+erCdmf/ijiWELQCKSZGGELqh3qViRrFdZ1Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZzpSvWqI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZzpSvWqI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WuBFW57R29jEriuNWKaqQym+Yyy2Hqlx6jNO4wBwW9Y=; b=ZzpSvWqIHZ9AVOxLbB0JNNIMFJ
	SMpEacxEWFGMgiNL4W9zJ8+Nj8HzzP82Fn7UzqYp5X+Bi1ITcS3I+z517rB4UrGgQoMRtuKCiuAZA
	TBRVkPDKbTAnTSvfE9dvUset1p+UYjR+UwH2j1VdV99MFf6KCg0iRFExZIRMlmqQensVK5BBl8Jn4
	g/C7STrmP5K6pgw3RhvqYvWmrevuDSVIK60f+FKiinJVIjlQJkpluclbj7fgzE9qq3HEgthowlCAz
	yrrH06PjBFS9ZIw+9BU/ql7vu6H6XQBmRKI459L1fzbodzTQP17FaY1Cals+JvPbzgvLfFKms9FjT
	e2kcHIKg==;
Received: from c-76-102-242-2.hsd1.ca.comcast.net ([76.102.242.2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uhU8E-00000003oN7-0LDL;
	Thu, 31 Jul 2025 14:19:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix frozen file system assert in xfs_trans_alloc
Date: Thu, 31 Jul 2025 07:19:41 -0700
Message-ID: <20250731141941.859866-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Commit 83a80e95e797 ("xfs: decouple xfs_trans_alloc_empty from
xfs_trans_alloc") move the place of the assert for a frozen file system
after the sb_start_intwrite call that ensures it doesn't run on frozen
file systems, and thus allows to incorrect trigger it.

Fix that by moving it back to where it belongs.

Fixes: 83a80e95e797 ("xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc")
Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 4917b7d390a3..9010dd682591 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -253,8 +253,8 @@ xfs_trans_alloc(
 	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
 	 */
 retry:
-	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 	tp = __xfs_trans_alloc(mp, flags);
+	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error == -ENOSPC && want_retry) {
 		xfs_trans_cancel(tp);
-- 
2.47.2

