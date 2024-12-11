Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1731EC4EC
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907484; cv=none; b=FAbGAuHeEkACfMNgwIBf8WqW3rfl6HqUugpJc2XYtbdq0pfqbIWVUSd5AbLxdMzlUWN+DUvweIWHY2B8RYSoaHRJ4fR/uv+c0UC4bhPOX0r7jd/24R0Yc79ni+M4hFSFLaYAWTZnsY9FK3LY1qtrL2r7B3TI80zcmVe677xobp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907484; c=relaxed/simple;
	bh=g4RWhDAvW4Jw0w86PVQ/2grvoBvm7nBgIzv7ffPo8Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeuJNkpI7G5g0jVyXMf+HwXBKHtK6AyWw1Wnq/7iUyqqlUdh6z0Mciv8gGQSqUUKdoA7kupeGUZYMvTOeBJb+Lyw4vjHD5JAbkKpT2WBFS+cUDf+YMIoWGUDaXEZTd3Uws5A4ZHtwJ86ome6+jZ08yS11dBTczGiHi2WUtpD0DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G10kChqA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G10kChqA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=g5QIE0TiStF+WxCsA47Qp2ZEFX4gteM1GBqqNCTgfOs=; b=G10kChqA9vElbvPjm+5R4kn0wD
	KwKWvWtnwCLphFdUmfHsUqBjqLDFjBLg8NCi7SMvnAeVjjajDdrAtip5lGaFKnaxNGvsBzYbcMuhH
	Cc+6s8muRo4a1e2vZw0n8F8i0LfmZ6/WphNmw4iZJOyuyPeUUXmK9OZT/myaAXf7wJlqDD/jNA16C
	LppBkwPjMWfDQf1Axxaefksh/u3pNkcEkpGRGrlYhVzsT3kxAhs2ZgW8ZcDrSVwFxJCVP2Ash5X49
	uZcnrADP8mZ2rda4CivOH8pxcCbkq/uqjPdSbt+yPpagP3hSTgAmdJIWLRJjGqg0SB70YkPifxrtt
	MQvepAeA==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXi-0000000EJN4-3BpU;
	Wed, 11 Dec 2024 08:58:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 30/43] xfs: hide reserved RT blocks from statfs
Date: Wed, 11 Dec 2024 09:54:55 +0100
Message-ID: <20241211085636.1380516-31-hch@lst.de>
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

File systems with a zoned RT device have a large number of reserved
blocks that are required for garbage collection, and which can't be
filled with user data.  Exclude them from the available blocks reported
through stat(v)fs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b289b2ba78b1..59998aac7ed7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -865,7 +865,8 @@ xfs_statfs_rt(
 		xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS);
 
 	st->f_bfree = xfs_rtbxlen_to_blen(mp, max(0LL, freertx));
-	st->f_blocks = mp->m_sb.sb_rblocks;
+	st->f_blocks = mp->m_sb.sb_rblocks -
+		xfs_rtbxlen_to_blen(mp, mp->m_resblks[XC_FREE_RTEXTENTS].total);
 }
 
 static void
-- 
2.45.2

