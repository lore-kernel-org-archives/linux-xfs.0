Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BE51EC4EC
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907460; cv=none; b=TmpGkisOxd1GWSSP8/+8xkC3TByHNSoqChrUfMOO1wKCv7Y7ewGz/cq8R4LFs2iXlFmVUvnE1vvhc2ztMGQH37lXeCm6ljXDr+IJK/GH9kK/GTntOH59/5Mhp9kV5W9D+2SPAazB8Ycwd3jWLHqe20VhdM7Ddie5fuTKer2c5aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907460; c=relaxed/simple;
	bh=xdIxbwKuMnlvbGn0Wo89d+1Xa3asE1hn3MsuPCO9cak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUTs4i7nqkAOInM6L5X+sTj3D5pMss8lC7UFr27KyZLSx3VPdiM5o0FxYbDI9SifvnmmzA567mU2Ayal+CxLKPbMOz2StX4MniAlmB90KI/ES0s4DYkJBuAiMoO6mmZUGvh0Ufj9vNYO31D4oCjgztcakSUVXDxbFe1MmvlFq9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0QaXr0aP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0QaXr0aP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=m2IXdFM6BrXWDuw6B+2yW7DUOGq/LH9DICmroScX4pI=; b=0QaXr0aPFIgRjRTXwF1zg/EHeI
	LlkodR9bG3HNmaG+0R6v/7wJKhiuW9eqjv/OAH6M7gZD5wD6urti0oLW8cmdJRqg+q4DRSDHP/Eiv
	KgicnJBV9VsukdUCSIPufeMDBwG9KoORxSgznB+rSb4HyC2SGUoT1S0xyqQRZvG2jfVdGQA4CF1/7
	5Yy2sW8grwFDuUs2jTqQj7/QKKtYezF4nF+8TZ1nQqcMdFHfxIb+OLqIibFK1Y/r4KQnr/oE8p3Ky
	pdhrRoj6NLzvEEntG1HPI2VTOPpDj++2YKLLXFT8idStMgOtAU0jYNRMJvuVT/aqU8HATULWtfiVq
	YTYzn36g==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXK-0000000EJFr-1es5;
	Wed, 11 Dec 2024 08:57:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 22/43] xfs: skip zoned RT inodes in xfs_inodegc_want_queue_rt_file
Date: Wed, 11 Dec 2024 09:54:47 +0100
Message-ID: <20241211085636.1380516-23-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The zoned allocator never performs speculative preallocations, so don't
bother queueing up zoned inodes here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c9ded501e89b..2f53ca7e12d4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2073,7 +2073,7 @@ xfs_inodegc_want_queue_rt_file(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	if (!XFS_IS_REALTIME_INODE(ip))
+	if (!XFS_IS_REALTIME_INODE(ip) || xfs_has_zoned(mp))
 		return false;
 
 	if (xfs_compare_freecounter(mp, XC_FREE_RTEXTENTS,
-- 
2.45.2

