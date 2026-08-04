Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D28375F95;
	Tue,  4 Aug 2026 12:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785847215; cv=none; b=RkrdcvdxtKfNelGOv/I3S/4jDgQC8fVIIGd1uW0qBjdR9Y4slZ/zW6lnrhQa7q0osZwRxmWr0Lp+oUrzrt6TfL11qjqVE90+nwjfm3upB5A2vd9v1O+oiy1DL7RC9OeYI98eTwBDCeEakg4McBfjdPhfbU5Y0Rg3yEmMD9uAn4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785847215; c=relaxed/simple;
	bh=ZLcbkfof8rVCT71/eGjZUPG26GzFM8S4xumaEqECWS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnx/Pfmnn7iMvae53sqGMIhzz3ZHN8WWOA50b7TRpGDkiROjzqPBc/iQyuKDlt/y0Y8oZVslVrP8t/1Vr/ytoYik4OLHEyEqPTJ2OXDtuXozU+Ch14p/VANCdcuIa3AbMfYLSAwwRTvcEd36Xh2BsHUqrAH8Xr32+eKPG0mmuRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uDP83i/o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uDP83i/o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rCsMXuAPNfRRrdR6gFtvytiqZeQXAI48EUxhI/IJ7eU=; b=uDP83i/ovLa4AIg3kJQdManYvJ
	DwHzMLnnCEwwEBHfmSIIwCWlNTSN3EPitvZuZITOIGmc2rvD2TfhNsXb9qYEhfaPhhjFL9TNK3GDa
	i+Edst/KOw3ND7zrfo5+fTS30YxY/FPJF1d/IoF6uUjD1R9C1zPyzLuIKtAasywfeBdGgE7hmA08v
	De4y6E3VgvmQyxjEBOt6NJbmX46hn6QoTDIeYltVPTYteCmDWrrTSnYkzWHZusZxg3aHe9gSAX5IY
	LW83KwFx4inny+WJPNczqf7e9ALhi/txYn1XWIvSFFd2cLnZuHmsqg6cdlYVgPtp7LiR5u7p1i8Na
	LgviM28Q==;
Received: from [93.123.20.94] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrERG-00000001pzm-18PO;
	Tue, 04 Aug 2026 12:40:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/3] block: handle nogenerate/noverify properly in fs-integrity
Date: Tue,  4 Aug 2026 05:39:25 -0700
Message-ID: <20260804123928.736596-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260804123928.736596-1-hch@lst.de>
References: <20260804123928.736596-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Check the BIP_CHECK flags before generating or verifying PI information,
otherwise this can be incorrectly called for non-PI metadata and
cause generation of incorrect metadata and crashed in the verification
handler.

The new behavior matches that of the block layer auto-generated
metadata.

Fixes: 0bde8a12b554 ("block: add fs_bio_integrity helpers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity-fs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index 9c5fe5fa8f0d..692403dfa047 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -46,7 +46,8 @@ void fs_bio_integrity_free(struct bio *bio)
 
 void fs_bio_integrity_generate(struct bio *bio)
 {
-	if (fs_bio_integrity_alloc(bio))
+	if (fs_bio_integrity_alloc(bio) &&
+	    (bio_integrity(bio)->bip_flags & BIP_CHECK_FLAGS))
 		bio_integrity_generate(bio);
 }
 EXPORT_SYMBOL_GPL(fs_bio_integrity_generate);
@@ -60,6 +61,9 @@ int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
 		.bi_size	= size,
 	};
 
+	if (!bip || !(bip->bip_flags & BIP_CHECK_FLAGS))
+		return 0;
+
 	/*
 	 * Reinitialize bip->bip_iter.
 	 *
-- 
2.53.0

