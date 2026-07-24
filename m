Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52468274B46;
	Fri, 24 Jul 2026 05:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784869826; cv=none; b=YAp15twTRjP6eK9WMIFzJTZXlHYdwAazUd1Bcp/+xTs323MtW7/RFpSRoKPbU8kXXVRzN4aXcdTVOkRW6tjE5R3RhHq57jUMwLedVbLaWAUu8s0led05ZEH2IBnME6FdyhMeEs6vAFtmtsg4o5r3aivrZgv6EKpzTL9cLyd5MbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784869826; c=relaxed/simple;
	bh=qeZM1qjRFnadQ0+2xHfJiTpn5zZsfw3zZU9M+IBoW9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sptH30oocMM6tJtnbtZfR+LnmVLRy63Ok/dn3TADp2nu/BVJAU5k91V4JLWBxq2VjLW8EcC6KHcrZAUYgztrWGI6OJvZiC3EVEOkU2xrZXZ0CsEoklz4kfvo0h0KxDU5C6IHNwuwFW38KK25b4FolKZb1vO/ay96gA3EIbNHNF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RFBBBwkt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RFBBBwkt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BmSdDCU376JH5jZcyBs3YCGK7N267sqFMLaAyvAbnZU=; b=RFBBBwkt76pAi/VBZ2b08dnC89
	gx/TsO2cAvcgeFhFIleJgiggNs1tUstAV1gKsbj4SxIp/mrzOtq63uYhYmWEaFP8FI4BjUf/HL34L
	vbPE2Ut8FtT91BxASNSKdUGS/GkPoFJMfJj0XwTH0ZF9FplduDkGrLMD911Z7cUDPEm2kxmQ0iA09
	b7zQiu0V4UJVAgyFLeMET1/Rh1sStQoAdV1wLzTAkgFQuAeVt/QMPK+1GVNeJVR4hI1bEsc+z+ihx
	c94D8Hd9NZqTH4YMcjXA2Y8QjcIG0HU8G4qq2HhbZF5pxxZbeLzpAB2kEavi66ozTQEaE5GzYNkeX
	wDABQlvA==;
Received: from [2001:4bb8:2d1:bd34:bc05:3da8:f7ec:c468] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wn8Al-0000000FUMW-2RC5;
	Fri, 24 Jul 2026 05:10:11 +0000
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
Subject: [PATCH 1/4] block: remove bip_should_check
Date: Fri, 24 Jul 2026 07:09:41 +0200
Message-ID: <20260724051001.202741-2-hch@lst.de>
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

There is no benefit in using this helper over the simple flags check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/bio-integrity-auto.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
index b1c733ecfd2e..43ac9f338183 100644
--- a/block/bio-integrity-auto.c
+++ b/block/bio-integrity-auto.c
@@ -45,10 +45,6 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 }
 
 #define BIP_CHECK_FLAGS (BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
-static bool bip_should_check(struct bio_integrity_payload *bip)
-{
-	return bip->bip_flags & BIP_CHECK_FLAGS;
-}
 
 /**
  * __bio_integrity_endio - Integrity I/O completion function
@@ -66,7 +62,7 @@ bool __bio_integrity_endio(struct bio *bio)
 		container_of(bip, struct bio_integrity_data, bip);
 
 	if (bio_op(bio) == REQ_OP_READ && !bio->bi_status &&
-	    bip_should_check(bip)) {
+	    (bip->bip_flags & BIP_CHECK_FLAGS)) {
 		INIT_WORK(&bid->work, bio_integrity_verify_fn);
 		queue_work(kintegrityd_wq, &bid->work);
 		return false;
@@ -99,7 +95,7 @@ void bio_integrity_prep(struct bio *bio, unsigned int action)
 		bio_integrity_setup_default(bio);
 
 	/* Auto-generate integrity metadata if this is a write */
-	if (bio_data_dir(bio) == WRITE && bip_should_check(&bid->bip))
+	if (bio_data_dir(bio) == WRITE && (bid->bip.bip_flags & BIP_CHECK_FLAGS))
 		bio_integrity_generate(bio);
 	else
 		bid->saved_bio_iter = bio->bi_iter;
-- 
2.53.0

