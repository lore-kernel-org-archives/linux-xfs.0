Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A8045DF60;
	Thu, 23 Jul 2026 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818223; cv=none; b=XbYTNdr01yJCWHaQTccUEkJE4qmpr9+fp0zzXT09B55IZaIfb/m2I7en+93RasJRTPykhLcGAhzBSywHNgavuph1DXdhkAbHI51AIq9ojod+FNm6n1bqDmYy42xzjwCsaKmR600cJFD2/iJAHVcV94zXss4aJT1lqsEL6O6xrLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818223; c=relaxed/simple;
	bh=j+5TZkyIkUm/gJf4oOYcxXIrXNicjJNITlIiIfxDnu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rzn3ZoMnK1mQ4hBoljLCVJOcObRBn3md1gj7imJCAy6n1OpnI39Al1dK743XdxmiclhSkL7gXFQNduIqdL1pMMizzdQBT9q31AwuS1nIyhEm7A9huTajQfrPNlS5SvLvqFBThRsjwdncPtLmqdCbAAJtLtkw4palCc82CbEC9Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Yb8jzxbs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yb8jzxbs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=T3+AftTFWn1InDRG0+3u37k+0fxQr5n4Uhpbkaqt8MY=; b=Yb8jzxbsvix33xh/pM81B7KTn+
	+ZkXjEuoHDQ3BZdnQZekO6mWPS1a8cwtQ/JL3LKtfUa4Qp6mdsqsEAim4gcL3ttmlqR9LbNfGtfEH
	A4fwmk998pkT3PhZ+Yu4jX9MK8cr8WCBjrVufX92ofVCpGnP66pVEOY3syxkZ+HDURK8ourlmoGDQ
	bMgeKfiqzwSYGV6MZj+NnZdhTj7yh+YaarkBGLAzP3c4TndoOu6sSrGzLl9wflJ113wazCbeRRbN7
	uZ8u6Q4Kb527/oqmbbA5FBvAsfres71nHZQrRe9eZsq0utc712vYvwqp55wT+lnMAlYk2QNGx0eEZ
	PddbbtxQ==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuke-0000000EXHk-1XkX;
	Thu, 23 Jul 2026 14:50:20 +0000
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
Subject: [PATCH 04/22] block: handle nogenerate/noverify properly in fs-integrity
Date: Thu, 23 Jul 2026 16:49:29 +0200
Message-ID: <20260723145000.116419-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723145000.116419-1-hch@lst.de>
References: <20260723145000.116419-1-hch@lst.de>
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

