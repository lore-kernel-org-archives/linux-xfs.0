Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D4F221FBB;
	Thu,  7 May 2026 05:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778130128; cv=none; b=E+3Lv8kWT3QK2nUokeq6+eJNQkkEBXnsKaff+hjFM9216dFY7WCP6M3PWbAQI7VE4plw9YnasCl64iLBx4aFQ4vKvNP16SsDMY0qsCf4MmFkft2SRciCudseqAQhbCMecj4mqfZT9hCn0tW/OBGwwj4ExWUqZBEyFDoYSnpctyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778130128; c=relaxed/simple;
	bh=7EBB5GHCkHN0TskgiyxxoRk10u5pmW6e6NqBn22cBxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQu0oZwbP6QCeTJxaySeHMIPqWH0RbvVjfcaW+Ugk4sbwm2G5C5JF3hQF82kGQBSTZstgRfeR83Hzb+t5MB3ww9gcSE5AeiIGgQjuI/0cCHnUqzlykwFkYWYrqloZby5r3pL7hDwoSd1E9yF/4QNwMN1cppmj5HE2c6jBLH8yrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4vRWR5Kw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4vRWR5Kw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mDN+B9dh+NPxIY/UB0rdWyWd3aHMT0pACMhP7a3XzOM=; b=4vRWR5KwZkPPg6LdybCjDetnMH
	A786va23jzt+cNxDaQrkM1wCrgRFjCPqJ4yW1c7ObSPJbIbywzAQJ0KVmKVW1q9c4lXp7lTV/h0xg
	EAozP7kAbsPbqXtQZLcRo8qoJZ5Zplu3py19VrFTSzqM9Mt8omQh5ZgoBgYQHMAzu3hxgKkitJgaE
	5eyk9b1Kg6wJIGFSVtMy0fTsyGDoY5OzN5Mx1d403nxlqnr3FVXrkxNZQ5+ozA7sIvafvzrDG4S3V
	69RyS218hsdpCJEK5prxb0Qz2zgXTe2widhoN1sAMCkcjY/YK20A+zkXFICxIwPbd1hZkcZC8husb
	B8vFbepQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wKqsA-00000002lyY-17sW;
	Thu, 07 May 2026 05:02:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Pankaj Raghav <pankaj.raghav@linux.dev>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] block: align down bounces bios
Date: Thu,  7 May 2026 07:01:48 +0200
Message-ID: <20260507050153.1298375-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260507050153.1298375-1-hch@lst.de>
References: <20260507050153.1298375-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Just like for the extract user pages path, we need to align down the
size to the supported boundary.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index f3e5d8bea08c..5f10900b3f42 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1345,7 +1345,7 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 
 	if (!bio->bi_iter.bi_size)
 		return -ENOMEM;
-	return 0;
+	return bio_iov_iter_align_down(bio, iter, minsize - 1);
 }
 
 static int bio_iov_iter_bounce_read(struct bio *bio, struct iov_iter *iter,
@@ -1383,7 +1383,7 @@ static int bio_iov_iter_bounce_read(struct bio *bio, struct iov_iter *iter,
 	bvec_set_folio(&bio->bi_io_vec[0], folio, bio->bi_iter.bi_size, 0);
 	if (iov_iter_extract_will_pin(iter))
 		bio_set_flag(bio, BIO_PAGE_PINNED);
-	return 0;
+	return bio_iov_iter_align_down(bio, iter, minsize - 1);
 }
 
 /**
-- 
2.53.0

