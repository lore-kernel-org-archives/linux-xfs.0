Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF347768EA;
	Fri, 24 Jul 2026 05:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784869840; cv=none; b=H5bjt6UYFMQMJSgElMwZHEpmWizjBPq0wcByAtorBq82qYcjLOy0xluDAHN81piK0Eedl5MuoVkLPYAyfscSBTGweeEO71OvAWQ5qfcs3CeZvAEEuECJHRGIpF+lEIkr1iwYyN7jTlHXT8B1HL06gHFylk/PRHw/b5X41VPGyHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784869840; c=relaxed/simple;
	bh=yLMu/G7IzCBHNZj3i5Opf11wfHEt2l0Lvo50YEfW0ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHSPTFOkkJSjw+bCq3WGbaT/M5fFLbEeLfS/dx223Xkol+Zm38WB9LRx7grxZc3V7KrbkBRJgSsDfBRUoQlxQ5MKM4bnM8TQhoOm6xMRzQN1nxneYBLB9Ht0QQBAKbhauvlhsxbWlXhDMiqcJ4lzLepFd/yPWBMzFuMwig+FDhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xa+EbNWS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xa+EbNWS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rfJRwkV2JMtJVFc0pQ6fvMr4zYx8IxO5mPeNFriCcbA=; b=Xa+EbNWS5xtBmuBxVou59qFnq6
	rk37rF6VQH+IisOAVMQaks5hTltri3AOVqUWHuqxItYTiNMLjybVuYjbQDgEFIi93bUKsjhae1Elk
	59LgbX44Cfm1nLBIV/3caoRK5sh0+oldzIBXevkJbKBB+TIeqSjD5cVf5OAGpdoxKLWI2jPu2S0KA
	GY+5tgsJhq+JIs2EA5JGkqbzzMFZvZiha3F4UeQRa7PSeeQi6x3sSk/t2H9lfaMR2mwFHjuCycLW4
	g+GQ0oe7FGKVx4W7mCKTxkIvzDRZ71LIajSh9avmXXZtRvt11KCfTAGZ49uoIj9Pk4TrzZ2q0utaN
	V78nCtsw==;
Received: from [2001:4bb8:2d1:bd34:bc05:3da8:f7ec:c468] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wn8B0-0000000FUN5-1e98;
	Fri, 24 Jul 2026 05:10:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 4/4] iomap: don't free integrity payload that doesn't exist
Date: Fri, 24 Jul 2026 07:09:44 +0200
Message-ID: <20260724051001.202741-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724051001.202741-1-hch@lst.de>
References: <20260724051001.202741-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

fs_bio_integrity_alloc might not allocate a bio integrity payload if PI
verification is disabled on the block device.  Check for that case before
calling fs_bio_integirty_free in iomap_bio_read_folio_range_sync to
avoid a NULL pointer dereferences.

Make the branch cover the PI verification as well - while
fs_bio_integrity_verify works without an integrity payload, it requires
one to actually do useful work.

Fixes: 0b10a370529c ("iomap: support T10 protection information")
Cc: <stable@vger.kernel.org> # v7.1
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index dc8ac7e370a5..30ef78a66b4f 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -179,7 +179,7 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
 	if (srcmap->flags & IOMAP_F_INTEGRITY)
 		fs_bio_integrity_alloc(&bio);
 	error = submit_bio_wait(&bio);
-	if (srcmap->flags & IOMAP_F_INTEGRITY) {
+	if (bio_integrity(&bio)) {
 		if (!error)
 			error = fs_bio_integrity_verify(&bio, sector, len);
 		fs_bio_integrity_free(&bio);
-- 
2.53.0

