Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F0048CCD
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 04:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723609445; cv=none; b=mvEhHvICLqrhoi4i9jBg4xj6riFKNO4DucOP+P93LQJmxH17oUKNEHcyoDmubnD1YERnlNdRnpL6rfMon5RcIYAFtHVGr+AleR1i4qf7phYBscGx29CeO1ozH3ZSOj8PxoCxWamU51a2La/n3MCr6xSL5i6plpqeefs7RHlD6TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723609445; c=relaxed/simple;
	bh=KoajIGlO0p2fL/+S/+N8KjBwVXITZBRootPWi8npg9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e608B5iKCgbzJHyHwjAW2HZxHpL+vr004RgyCpVzilWG1tJbwajMbf1CNT9tWEhoVwTwnt3yUAjHKvjaEf6ov8VOme1qMYTShNjfPuxtW6qj598CdHmLkLDzexbR5Web6PP2b7EBFKbleh8yyXy7EQ8LCvEkUxuEKRuZWx27bQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PIQSJi9R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PIQSJi9R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=HOSPjef32AO02nHMrhO4fpwsgn14dOnglB3T4zYDbJ8=; b=PIQSJi9RLnC+I/oRlmsFcrW5kZ
	oPlEsdKrYtgXooyFZhh1bdHI0q2Tqsk2f8dXajFyHzvsn1im3zHxA9Vrjpj3wGy8gJCM+Cf8tk4sT
	PUz1gC0SvHK1s+Rue0XQVCIyFyVgr1as1ukbOBLHNL7bm3aOOLd22sVvuBtVL1022aFApfShI06pz
	3e/U8Cw8Q4WbYQyZgzR6PSkzj6gQEULnmr2MV+OUftAS2d0A6THiJrlN7MoG7BoU+nd2bcQt0/Su8
	ky2cd3wlCqafjnhBAJsXX8zK8bfdyyC0aK4xeggoOovySJ5iwUizQ1hzhV7zSXLSl0eU9iZgz8zwg
	nykXiwuA==;
Received: from 2a02-8389-2341-5b80-fd16-64b9-63e2-2d30.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fd16:64b9:63e2:2d30] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1se5YI-00000005gi3-1I46;
	Wed, 14 Aug 2024 04:24:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: remove a stale comment in xfs_ioc_trim
Date: Wed, 14 Aug 2024 06:23:57 +0200
Message-ID: <20240814042358.19297-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There is no truncating down going on here, the code has changed multiple
times since the comment was added with the initial FITRIM implementation
and it doesn't make sense in the current context.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 6f0fc7fe1f2ba9..6516afecce0979 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -689,13 +689,6 @@ xfs_ioc_trim(
 	range.minlen = max_t(u64, granularity, range.minlen);
 	minlen = XFS_B_TO_FSB(mp, range.minlen);
 
-	/*
-	 * Truncating down the len isn't actually quite correct, but using
-	 * BBTOB would mean we trivially get overflows for values
-	 * of ULLONG_MAX or slightly lower.  And ULLONG_MAX is the default
-	 * used by the fstrim application.  In the end it really doesn't
-	 * matter as trimming blocks is an advisory interface.
-	 */
 	max_blocks = mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks;
 	if (range.start >= XFS_FSB_TO_B(mp, max_blocks) ||
 	    range.minlen > XFS_FSB_TO_B(mp, mp->m_ag_max_usable) ||
-- 
2.43.0

