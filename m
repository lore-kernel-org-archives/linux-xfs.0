Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A07254B03;
	Wed, 22 Jul 2026 12:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724591; cv=none; b=hddl5cak9cFnUx0c9oWIEnMsArcFsfJb+ZCvRIsoqJgh5pdVGV4irvLbCcO5fD/h7/i1yWPQzpX/Ml1EoFR8TLYSyM5pf1jjNuDIZrR392OWcEHs6x3mxTwt17mmaQzvNV7Y67OYMa36CkYCidDXo/3C8d/klLaqN/ol9s8Zw6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724591; c=relaxed/simple;
	bh=ITxvFHHtfwpMau3NYWVTQceI3asYlug+obRoToqbH48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtE/mVTdmmqj3jZ6lH644EKykG2KPA75byfDZTJVjX7fx6rnAbTXkemoup01yd6Kt0Sf7/tOcn3ukB8Qv5N9Q0dSYNbVUxxARdrdCaXic0G4W3zpQGPxO1RYYYWK2ZK1HjX8cJKoqNUsjG9HMmNyZYfCLBTlIwBYX2JPOsQnUoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xAua58qn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xAua58qn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CVRW2G8GFu+kfUFK2PN5SJ1Dep7fyf8mcB0jb1clTMU=; b=xAua58qnGgLVESQz8NyZl9pZ1n
	8iBJTeXrqOX8mqD2VWgzyYKTEYlrqqss4yMcpGEqUr1qEc9CrYYt6L66XKuNHATu310hdKNnmAjur
	7vfOnyTVDj6B/NL027ENDZEbGbws8jSktvESK2Osk+yueMEWS4Za1AOQBxU6mJ7cCi/OgHX/DrYRv
	PxcN0xxxd/9dktcxOayqP8it/9BfNzKY7/mmKLaK72GOIVL5xOOztwomgLSR/vIvEcsvSdtpEQ2mO
	O3QtF6O8Ow1ixlbmXyB4E+XxPaKrgS6k4mPszbYFk1TkhZwGfgtdAswHJQART3daS72rRMmuRFVpv
	N3KamX9g==;
Received: from [2001:4bb8:2d6:3a78:eb21:714c:af4c:ee7d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmWOS-0000000Bnca-03DL;
	Wed, 22 Jul 2026 12:49:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: changfengnan@bytedance.com,
	Joanne Koong <joannelkoong@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Carlos Maiolino <cem@kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/3] iomap: use GFP_NOWAIT when application for iomap_dio_simple allocations
Date: Wed, 22 Jul 2026 14:49:28 +0200
Message-ID: <20260722124931.3159664-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722124931.3159664-1-hch@lst.de>
References: <20260722124931.3159664-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

For non-blocking iocbs we should avoid blocking allocation where
possible, so switch to a GFP_NOWAIT allocation here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ca35da9e6cab..3bdfbd0efa07 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -986,6 +986,7 @@ static void iomap_dio_simple_end_io(struct bio *bio)
 ssize_t __iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
 		struct iomap_iter *iomi)
 {
+	gfp_t gfp = (iomi->flags & IOMAP_NOWAIT) ? GFP_NOWAIT : GFP_KERNEL;
 	struct iomap_dio_simple *sr;
 	unsigned int alignment;
 	struct bio *bio;
@@ -1011,7 +1012,9 @@ ssize_t __iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
 
 	bio = bio_alloc_bioset(iomi->iomap.bdev,
 			       bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS),
-			       REQ_OP_READ, GFP_KERNEL, &iomap_dio_simple_pool);
+			       REQ_OP_READ, gfp, &iomap_dio_simple_pool);
+	if (!bio)
+		return -EAGAIN;
 	sr = container_of(bio, struct iomap_dio_simple, bio);
 	sr->iocb = iocb;
 	sr->dio_flags = 0;
-- 
2.53.0

