Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2952BEC53
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 10:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750157570; cv=none; b=R69H1Njw0HkD9M4iDZaWv5jCjKPPN9SEitRiHxGbbIELM2lIXFAs6bJDXSh8+eDIsUG7k2NgeziPnHF3OuC44Ln6ABQmc9zT4Rv2Jd+IW7idO1oDJN72QM4H9CTMTsUfAQrpyB3VBY/Lf/EAUJb49AFaQHK8qgCbYGFtCq53Cbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750157570; c=relaxed/simple;
	bh=yXWOEWfCYgj1OooPo8V0qkSXAR3/EMGu48FprT+Enx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sK/0PYXS65k608LuC5vLMXIoDa59/rAxSjntMzNGZzr3HHqERxTarppqEpTRmfnc/TBPdRJ3vfz4lp/ry3C4f02PZ9Vhesd/WbH4Qf6MSWh9/dr5LKLVxiEruMY/rogUdxuW7xTMOCOP20wKyFLqshB7If9Gv/w2yZnIHVxRdcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=umgPwAWQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="umgPwAWQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GlGxT1dKOVE5udS26vatyQjKzQHKLmB0PyewUGwfBNo=; b=umgPwAWQoblzKFw8txTFVj87P+
	JsBkiVGH9L2TZ8rtZ295Y6FzZeBREIFVudxbaJCfgoAqb89Cmtx93wfSVrQtyXMD+7Fq8CCTm2Wgj
	37hAaBYj/rwMc2X/SrouFkzMpcRjR0/5UTZ+K7zQ9QdDutrYi6FGJ9uJ5+99y8fSxapn19PHv60wg
	KIXCvlXUh9A9ym/iIy8v9rWwQRanWFQZgc5W1a5FWFy0JahjzC7bSaqvTCb0cLTmeJFnvxSnrx7tD
	IlV56ZrWCUuVaHwYau2D/hFVBPaFTNrtZocMpVR0oKn3QG2IKcORzwtYDSDVuNZjWN3DUn2fGLS9f
	3mPH5Jng==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uRTvs-00000006yPy-2Q9B;
	Tue, 17 Jun 2025 10:52:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] xfs: remove the call to sync_blockdev in xfs_configure_buftarg
Date: Tue, 17 Jun 2025 12:52:00 +0200
Message-ID: <20250617105238.3393499-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250617105238.3393499-1-hch@lst.de>
References: <20250617105238.3393499-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This extra call is no needed as xfs_alloc_buftarg already calls
sync_blockdev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8af83bd161f9..91647a43e1b2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1744,8 +1744,7 @@ xfs_configure_buftarg(
 	 */
 	if (bdev_can_atomic_write(btp->bt_bdev))
 		xfs_configure_buftarg_atomic_writes(btp);
-
-	return sync_blockdev(btp->bt_bdev);
+	return 0;
 }
 
 int
-- 
2.47.2

