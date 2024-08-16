Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028E112AAC6
	for <linux-xfs@vger.kernel.org>; Fri, 16 Aug 2024 08:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723796358; cv=none; b=U4/pkjvCDcryRf/bmEVUzTY1t3iBBGF1Q8/GepGMVbFykZCNBjYSRofsZD56FjknDc71OR1dulIjPkCOlchPbC0XQzy+lGqir43YAfNLxsT/2JXcH4H0H9d8sUeIhGYP5LypHUNhQw2FAVwZmPJf87dqXIQVOB9fD/DtkLGPoT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723796358; c=relaxed/simple;
	bh=FiBZtWS2OtuVEWRlebItiwZ0CF7dOD2PZSS/wC1JVHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eB35RkVHsWtFbsv3AA6BC1qJtFplfTfpq7LbGzHB1gJvPpxR0kf7ZMboV/6/GxRXCNI11cF5n5NJDs1kBROrGTRyj03IQkKpGpvy1DktbMPF+jXO4U9Us8hVIkMrVjGSdOPYNVwpHv+3oxXUXWqNHqA1CviDhfh1tEmDFVgmojY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q+sfV9SP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q+sfV9SP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EKIBQjbm5CQHMCXBNWarJi2QcnE1LNU0JZ0BENJLReI=; b=q+sfV9SPvKUumH6w0uhhu2OpQw
	cF/YSiHfK2U8RAumRGDPpVd1fEFrBOwVUffZ5gsbzfcOUfeH8Y/WB7nXUZAxDrAnbM9TVDSNw6wKc
	+OEIbNgwM4WO47l61+xb3H4NtJpQtkYwKWru1kyfyUrZ5jqnCYwDBFtp6+WEytCz/hElDczBGFVo5
	2l56XYxlt21XrDqPUaFAG1ZvP2F/nEpG4Vstuf4aTAtll02hmxQJrKtJUQLGu0RFlNCHvQgKtFj88
	doSN2x0mHU/3MAx4KOoAQ/LdRlv5agWExajEHgJNTkl6KNG/X3KzPg9dDcOdwZ8clqBM7Wfvtgfz9
	F3K/X5Ig==;
Received: from 2a02-8389-2341-5b80-2de7-24a4-8123-7c8f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2de7:24a4:8123:7c8f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sesB1-0000000CEwp-4Bkw;
	Fri, 16 Aug 2024 08:19:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: remove a stale comment in xfs_ioc_trim
Date: Fri, 16 Aug 2024 10:18:42 +0200
Message-ID: <20240816081908.467810-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240816081908.467810-1-hch@lst.de>
References: <20240816081908.467810-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 80586336276c19..d56efe9eae2cef 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -720,13 +720,6 @@ xfs_ioc_trim(
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

