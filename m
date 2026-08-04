Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EB730E0CC;
	Tue,  4 Aug 2026 12:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785847208; cv=none; b=kV44qukB435AgVDIyPAv3XaOYMzlxWYTjIj5bjnYMQNaanq9cnuKLCepI/8U07P7/Dw7FQhbVunFXEgwyAF3j77pgDMetSQzKFF3orOMYlH973eM6GAA59yA4QCb4RqZVYzVYPIcnwTRmSLp7zmmpeWp5rEB7E7ZHGvgKKKJVAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785847208; c=relaxed/simple;
	bh=CPme+yfC99DCtyE1QX/mh/ZCvpqHkWKW6WuCg32hflw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8p2b71iLOe5N50WXXzlXO+S7QlZKRRd5T83k1tITkUyA7BihV2gax3RJfBN14XiHajtDb91G/bY1LCJGowynMiUJ0xxF2QCjTqqH3ehmJxMYdVeAWLQN0YhSzLit6/B7cxHqkIeDCt9gpKR5+2GJNgI1VeZDPyswsbg4ZusANg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rc9qpsDD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rc9qpsDD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9jZjKQs656w4V2s9BlyqOTKJlInU5DzthZO/Y3kRAZY=; b=rc9qpsDDgALhftdpoo66arLM77
	RClxaflsBYpddfF2sBHhX6hF7kegdVR78r4GXpyPyu9mlaY05KNrvpRjFnIN1OkFUDCcKxPjczBaP
	Z4RqX06XMuPCEM+Jyf4aH9Koaybjx5gBEHCeylendOtqd5UtE79pBOtbbDjIRXCJ0G2zLkPhMT0Ug
	iXGObc8VbIAsCTJFi3ro7M0MpO5IHKgAWc/+Ti0Tas1SfXbszjtQOtpx/eMmfEAlI6MA2h5TPJAIy
	U2DhrmdwTrv0uHBfRZRYYkk0nnDuPj9yYplLnERFK7s3uqq6TbJwCssXvMN7sRri99RbrsY1mXxdg
	0efIjYZw==;
Received: from [93.123.20.94] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrER8-00000001pxP-29E9;
	Tue, 04 Aug 2026 12:40:03 +0000
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
Subject: [PATCH 2/3] block: lift BIP_CHECK_FLAGS to include/linux/bio-integrity.h
Date: Tue,  4 Aug 2026 05:39:24 -0700
Message-ID: <20260804123928.736596-3-hch@lst.de>
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

To allow for users outside of bio-integrity-auto.c.  Also add a little
comment explaining it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity-auto.c    | 2 --
 include/linux/bio-integrity.h | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
index 43ac9f338183..9456dcffd17a 100644
--- a/block/bio-integrity-auto.c
+++ b/block/bio-integrity-auto.c
@@ -44,8 +44,6 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 	bio_endio(bio);
 }
 
-#define BIP_CHECK_FLAGS (BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
-
 /**
  * __bio_integrity_endio - Integrity I/O completion function
  * @bio:	Protected bio
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index c3dda32fd803..0ea2a8bf7efb 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -17,6 +17,9 @@ enum bip_flags {
 	BIP_MEMPOOL		= 1 << 15, /* buffer backed by mempool */
 };
 
+/* flags that require generate/verify action. */
+#define BIP_CHECK_FLAGS (BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
+
 struct bio_integrity_payload {
 	struct bvec_iter	bip_iter;
 
-- 
2.53.0

