Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B6713F01A
	for <linux-xfs@vger.kernel.org>; Mon,  8 Apr 2024 14:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712588106; cv=none; b=SqhNKwFLnE+9daQY3hu/9OiCDRMg2SkksXkHRj7q9UAPf2yD9rfoBXaP36O/qiXiKZ+7o9fuxO02tKKvjdXlpXy0t10B9lXFWoN6fmKacnMtA+6TTqu8crYn8IWyA1urvZZtT0aK6OIB9DexbJBYzABqGlrpa9zKQwx9x05Mm+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712588106; c=relaxed/simple;
	bh=vS4y7XvvWAwoNrg8/cjMOjQz33oa/IhqJ1aGcbFfzPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XUef0PMs+jZ6KCepYU8lB0DVgnHwdN4GgWbjX8UTQ23mIje8IK+FzpWEOerzUNfEwarWf6WGYpIOXI6jpIALWmlKXcSG3LVXaAbPz2m5UEabcg6TRhoOpciJTj2guB9xYgFIBaJ+3qxxPhk4NIypbFwgI3q6vyuE1ARGefa7DDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rmbbZ45P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rmbbZ45P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kAcCmRtyVAGvs2VcI6PjFKKWxs+xF+LAne4zWzO9sA0=; b=rmbbZ45PGO1XWLPRA8v9DFTkQg
	2JPS/HMQeMw5NfQy7vyrZqsOzClSINFTEWkwuIS7b5kp6wGBt+5zNIQrGPSt3BHbSy7OGQuFZNRjQ
	2lEFe5ogWpQ88ZuuepfAM195bUSlzOHIzhings0rgmdY+zMIs2ap6Du1zf9tFvgCPvX1nedmpmWqV
	RiK6jP/nonVbRK7io2yl4SKaxYgwLJk5pu7xXsaAM4SvaLWaLXfI6RyyV5opRwHzD12d64jiy7vuH
	UMCn+blKNi1JbbSp7f7jvGV9PIVs6miv7iP/6MuqIVL07v/3V1LSU1v/YiDv9suY2a3CuaIHDKXmc
	5y5Man5Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtqOm-0000000FwY1-2g9c;
	Mon, 08 Apr 2024 14:55:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH 3/8] xfs: lifr a xfs_valid_startblock into xfs_bmapi_allocate
Date: Mon,  8 Apr 2024 16:54:49 +0200
Message-Id: <20240408145454.718047-4-hch@lst.de>
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

xfs_bmapi_convert_delalloc has a xfs_valid_startblock check on the block
allocated by xfs_bmapi_allocate.  Lift it into xfs_bmapi_allocate as
we should assert the same for xfs_bmapi_write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a847159302703a..3b5816de4af2a1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4230,6 +4230,11 @@ xfs_bmapi_allocate(
 	if (bma->blkno == NULLFSBLOCK)
 		return -ENOSPC;
 
+	if (WARN_ON_ONCE(!xfs_valid_startblock(bma->ip, bma->blkno))) {
+		xfs_bmap_mark_sick(bma->ip, whichfork);
+		return -EFSCORRUPTED;
+	}
+
 	if (bma->flags & XFS_BMAPI_ZERO) {
 		error = xfs_zero_extent(bma->ip, bma->blkno, bma->length);
 		if (error)
@@ -4721,12 +4726,6 @@ xfs_bmapi_convert_delalloc(
 	if (error)
 		goto out_finish;
 
-	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock))) {
-		xfs_bmap_mark_sick(ip, whichfork);
-		error = -EFSCORRUPTED;
-		goto out_finish;
-	}
-
 	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
 	XFS_STATS_INC(mp, xs_xstrat_quick);
 
-- 
2.39.2

