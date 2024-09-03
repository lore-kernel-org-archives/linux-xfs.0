Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFB413CABC
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 04:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725337737; cv=none; b=feeJgG+jfvQwcaf3QV5SU8+6KKtgoJv7HAsIMTb6mDk0Q3b0xKMbI6Q3L3oeEXphzUUbD4cc85ZvpsulUruu0Mv76z3HnoF1hb+ZMg82MCpwbsPDqhDwE6Ihf1JOjd1NstGsxdfDTmhnyQo0etJ7/NX3nNT0Hj+tigAqxwLxpws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725337737; c=relaxed/simple;
	bh=IRK3MkmA9a/IqTgY+paGN2QhVZv/6JZnygY6nvQRKb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCBEfxGlbfiOlqw+QDEerd0NMXH0NUmqGyIzh0uAyGwIxwj1Um5jtJ1PePVtFvuorZzSo+7uifzqPDTSXzWyQHI1SD+8Rw5cayHUwBeeCvh0xSJ7Nr8/cxtUNIq6EzqmivVFqDLZlzuknX/KJ2Tc08SMRr4IUlPhd67E038Qh24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Iiu6Z7Os; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Iiu6Z7Os"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fe2D6P3P8U+1c5Q3fvmIIkwTplv62Yvc4IVKbv+3nww=; b=Iiu6Z7OsLYjuYx8fdT3G3ChKQ9
	ZDbCDfg9RS6C0yIVtazeG3pLg2YWW+mD9l0y/RHfCXQ0VaNiUnyrNuJ+X/qlofahPre7IUeHRVEbC
	zhVSbxJggMMFP2L6aCbffMeHTeY9IFPJzdvp8tTNhizZnDWgU/ggVCoCt3l53flBe0UbuLk56BqC8
	86yUzxz+0Sc8myVee2+w8GC7hqznhI8YcaOSQN4VOyrrOkkhHhsyQ9XqVV6Yr4WSEMBc1iTSb7fSu
	1beXULAwoapsHdEi06l2f1HGJFLzy8U+0orCBUKtjiKhrSe6dOVoSVG7YFNScX79CGuS646WSippo
	TemhirAw==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1slL9y-0000000GIAr-46yP;
	Tue, 03 Sep 2024 04:28:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
Date: Tue,  3 Sep 2024 07:27:49 +0300
Message-ID: <20240903042825.2700365-8-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240903042825.2700365-1-hch@lst.de>
References: <20240903042825.2700365-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the debug-only xfs_bmap_exact_minlen_extent_alloc allocation
variant fails to drop into the lowmode last resort allocator, and
thus can sometimes fail allocations for which the caller has a
transaction block reservation.

Fix this by using xfs_bmap_btalloc_low_space to do the actual allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a8c9825e2210ae..86cf29c98b1b08 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3493,7 +3493,13 @@ xfs_bmap_exact_minlen_extent_alloc(
 	 */
 	ap->blkno = XFS_AGB_TO_FSB(ap->ip->i_mount, 0, 0);
 
-	return xfs_alloc_vextent_first_ag(args, ap->blkno);
+	/*
+	 * Call xfs_bmap_btalloc_low_space here as it first does a "normal" AG
+	 * iteration and then drops args->total to args->minlen, which might be
+	 * required to find an allocation for the transaction reservation when
+	 * the file system is very full.
+	 */
+	return xfs_bmap_btalloc_low_space(ap, args);
 }
 #else
 
-- 
2.45.2

