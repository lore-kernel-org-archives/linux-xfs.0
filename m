Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623BF3BED2D;
	Mon, 31 Aug 2026 06:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158433; cv=none; b=UdU0Eh9t3Jo0EPTLYroKostugu17W8csOAMQMQccal3OilRx+pVTm5Gx4NAND7y5H51XEj6oW5bZ1dIHz5tlWTCotAfl4lC6A6l4MHKp3JX2Y0BMC/3UjzHnv8cQcEeslW8oUct95LYfrQocFbzLxFNw1PARIKqGkR2HmlTZlAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158433; c=relaxed/simple;
	bh=6t6QV7I2kO46gcnLhsG31ZxR1yt16jjVjWRjGLe+kbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWC3OYI47T73Q04FQVpYEHeNeHAPLep/wiJSyfmSrZ6Tl1p+g/DMnbepv4iVrVGTA3OYpiE1BkcrTQbnL/BkKehAtL6RHoTp9tiLibWXsfBfvJr78C90mEt8dTLDooRkJgrCNbGBggI+mOZgHbmAFQF+Qxf0/Z7P9U5JCNZdrf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=y8ctPwGs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y8ctPwGs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XK8ItuG4QBWdQkC/2E93WkqLMCVoX21pt3DSGkW9i/I=; b=y8ctPwGs+OflDfkRKuEb/U5BgO
	5RuG2kmpzuJVdGXU2hNL0D/VlXp0CbsGQRHdJHIhcD05hYRs4haeZi3i8daoRKFM5Th1sWSZ6ef7r
	j+b+cEERY+MmVnd5XdZ6zogLhHvUlDexNso+KmrhZYLEzQO1QzfKrpijS5xoo2AOm5xi0Y60XjJMm
	vaKDRgmSmEbam3WpYIU2Hn/qWV65rcNPIhM/JBk8pBBQyguTpTpLcXJWCiobg9GK3LZ9tRNh/WPUk
	mqt4GoqAVB0FXFq3iL+ZZsLLt4ks8Do4Kpj8a0FQxWoQLeNmCJrCAYlYxBre+e/p24YU8wqWTEyJr
	iMm82yaA==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vgz-00000008cth-1zDS;
	Mon, 31 Aug 2026 06:40:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 02/17] block: warn on too larger integrity allocations
Date: Mon, 31 Aug 2026 09:39:50 +0300
Message-ID: <20260831064010.2574896-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831064010.2574896-1-hch@lst.de>
References: <20260831064010.2574896-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Catch cases where upper layer bugs create larger I/Os than the
mempool would return even without dipping into the mempool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index b23e2434d80c..d3df726e0f08 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -72,6 +72,7 @@ void bio_integrity_alloc_buf(struct bio *bio, gfp_t gfp, bool zero_buffer)
 	unsigned int len = bio_integrity_bytes(bi, bio_sectors(bio));
 	void *buf;
 
+	WARN_ON_ONCE(len > BLK_INTEGRITY_MAX_SIZE);
 	buf = kmalloc(len, gfp | __GFP_NOWARN | (zero_buffer ? __GFP_ZERO : 0));
 	if (unlikely(!buf)) {
 		struct page *page;
-- 
2.53.0

