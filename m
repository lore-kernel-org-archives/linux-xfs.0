Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94CC340401
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 07:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766070; cv=none; b=X8vXL1INV0wPLTsIO6vmH3JZDFO+L/9D0c5NXtZ4QWiFOSXkPi8bQE2I0h38TBAGZ2sZ0EByaQ5sExEjaW8a91dK3cNUR15zGJfUfsEuB4tXSx3hT/yM6iykzVv9yZHcUAe742YfKXGkdb6UwOUNcIfz2BVVQ3IXENxxeyXn4PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766070; c=relaxed/simple;
	bh=uLS5sa6x4r1DyQh+28uN3OwsuYPLx/QznCb1+NQz3qs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ku6S2SjTkXgyg5iuAwXIDUl000N0RqYAtiKqicYFKCsHbF1b6JRS7nJQ3HwjNuN1B8VB11rQ6BDOoWps6/giB+H6kcNNX/mR1ncYdFVKBShmTtYSEXu+1g9URGghSngsuxwaRiF51u64d9T7KRm7v5IpNHNtK8g2kBXv/KcMe5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rf6mHgHJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rf6mHgHJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=sPQ/GlgsJyDgAMKF6N3qvulpvYjD3ahmh4NVGIm3cLY=; b=rf6mHgHJ6pG8h0IKa/BqbpUn2i
	Nqc9SBBx8IrSW5HK6LG3FEouDUB5Q1gzEoBN97VQWldpE4HvZrbB04kFNQcaGX3Q8YMDp67MwMPaj
	on9RZZUuFAKfV3lsehEBqGl3Y+MHitmKcdFt1/GFp2J2bX5QZ5H9xmwtt6ZRRJojkxmgwRnwkjYpL
	zFQm+TcDByYL3OuAEBcCni0AkahPJoC98bMpiWAmi1nbQfBxlz6FKY4QLiwfTXFNxxUjufTJtXwJ7
	0cv0DDuK92is3NsLTZulhedeQwDBOLunE8796oon0PtxrfT//GI4G9blIboy+T3Eepo7j5PXCRrxV
	TpayKo+Q==;
Received: from [93.123.20.121] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3TlY-000000069vL-0k4i;
	Mon, 07 Sep 2026 07:27:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: anuj20.g@samsung.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: set IOMAP_F_INTEGRITY for zoned writes on integrity devices
Date: Mon,  7 Sep 2026 10:27:39 +0300
Message-ID: <20260907072739.719289-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Anuj Gupta <anuj20.g@samsung.com>

xfs_iomap_set_anon_write does not set IOMAP_F_INTEGRITY based on
bdev_has_integrity_csum(), so file system PI generation is silently
skipped for zoned writes on integrity-enabled devices, and left to
the block layer PI generation.

Fixes: 6bbb4d96f797 ("xfs: support T10 protection information")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
[hch: ported to the recently introduced xfs_iomap_set_anon_write()]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index c906c62d46f3..f2520a9b3a13 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -41,6 +41,8 @@ xfs_iomap_set_anon_write(
 	iomap->offset = offset;
 	iomap->length = length;
 	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
+	if (bdev_has_integrity_csum(iomap->bdev))
+		iomap->flags |= IOMAP_F_INTEGRITY;
 }
 
 static inline xfs_filblks_t
-- 
2.53.0

