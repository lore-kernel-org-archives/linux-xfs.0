Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67856126F07
	for <linux-xfs@vger.kernel.org>; Mon,  8 Apr 2024 14:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712588113; cv=none; b=Gy369EYs9Jb33BSyfCT8Gu5Yx8ypnnorzlz8pmX1x3zaTHjySOuBkCPz3xVSJ3jsSulA7CYFUZzkmOSwHCUNVnlZB8IxjjHQ1/QUzY2eTjkNePfKmImWJMI8kpucUvcERmET26b2jpjdBaMb7ZfKCSeaAel8/CyCTuLaIKA+Uww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712588113; c=relaxed/simple;
	bh=4kmd5FEK7zmmWLpH9R/19g3XusJuT5Gx1CwJbpENQ2I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TNiudYdtf7nzfYT1Ap1yrYRSivK5a/5cyUJKVYvMDz6Za75LOI31z5hmSA5RLVp3AySGCX7EZQ/RpB4w7WhX3Ljwv632p2vLW9H5GDiPSLpzSgTCtH6oPLlK439wr79eANRQ4QaHF4FjGoUbDYtRW0CDFQHME5xygXlG4O0jyk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BrEY2YJb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BrEY2YJb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=u1iR351bB/Vzgc1UrLgD97d8UiSZdcSSnXRNkq9MLxs=; b=BrEY2YJbSjVJpc1U2WM2fgqYe8
	MKMUp1jUhN0CHyPJ1RlA3mCosBSQGQ5nFKBIFNLc5dQyiE9u361lWI7CKol+3JZN9JLaznzlOOiy+
	4f2T3PhhNFOlFiJ3Cd+BBAVeMnHrV3Sejr7qwuKP4XhOS3g0l2WMthnnblNv2R0laSY028LisOT/h
	6bthvLpuoNjU0sjQCRBU0CJyavrVcud4DBTn3LbvOLB8Y5BmZ8Jobgs/AYUnrXQBYQUp0AZilOYhN
	nfH1LVaMDf79rcMc2eygqjsX+0kERIJc2ELmZbT7N6ZZf4ig4kIaQz1w5cxOt/IOyGDJNAJ+JfcCo
	0bu170ew==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtqOt-0000000FwZM-37TG;
	Mon, 08 Apr 2024 14:55:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH 6/8] xfs: remove the xfs_iext_peek_prev_extent call in xfs_bmapi_allocate
Date: Mon,  8 Apr 2024 16:54:52 +0200
Message-Id: <20240408145454.718047-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240408145454.718047-1-hch@lst.de>
References: <20240408145454.718047-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Both callers of xfs_bmapi_allocate already initialize bma->prev, don't
redo that in xfs_bmapi_allocate.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index aa182937de4641..08e13ebdee1b53 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4196,11 +4196,6 @@ xfs_bmapi_allocate(
 	ASSERT(bma->length > 0);
 	ASSERT(bma->length <= XFS_MAX_BMBT_EXTLEN);
 
-	if (bma->wasdel) {
-		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
-			bma->prev.br_startoff = NULLFILEOFF;
-	}
-
 	if (bma->flags & XFS_BMAPI_CONTIG)
 		bma->minlen = bma->length;
 	else
-- 
2.39.2

