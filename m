Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2124A2E19;
	Thu, 23 Jul 2026 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818254; cv=none; b=IImp83DkkH7ERK8/loRjZXJ5woGY/bJKk4msqIDhNJfaSFwAjiZ6F48Xk5KGkTinIZAXq0tKagYRvV1Hb0ke4StYGBkSJ8zuElaQtjWH67ukmbo6j36QB1d4F2apA1h51m0t7M8urPRJGBorcXenfgNmNuLyHyowtnADpyynHEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818254; c=relaxed/simple;
	bh=PjdA7BPPPxsjC8aTLiT0+YpwG21tUJaLHqw13NPZsYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyGAZPGJSmmpENYH1o9cPMG6+jH6F4C1heAH0sU6oSXzXfur8gwsPZNNq8Eq9ap+E5VlnO056xqSfSa93gEONXne6GVVg0uBQraG98UrhO3DutBj/7M5EQ1kNb+q05q4ZNqScP2VCDlRLgJhJT28axxEs4FirKQ/ku3gggG0t9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e6TRf3fw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e6TRf3fw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tWwcyBevwjWp3ZUotEQ9s6Qho9qawevVa8i8qW8VNKU=; b=e6TRf3fw6tSrjqpCE1+WDMRVlj
	8fO4McIQ0+idPLLxE7cTXBTwgJ4ZCRgk4ax5OebxyF5rBW21Sg3fPeKl8lDvfn3nHeKxpEuSy8QiX
	Go7fc79sX3AIQUQcqN3dM7dP7Ri6BJvmhlCClvZeN19Akk1sOQAev13wyOfRVdZ5IYaPz8LOHgnQ9
	N0+owRAeQzCx4i/BSuQqui/0d7CdwewEJGY2U31NMp/c5EehYHGElgXvhdhgLZ9TZxuU7T+DNVN7H
	JTXMwT2LVonVtS3v/vPeSDMhT7ZL8x3Wo/bwyrLSTXW2fdkyJCuTEaKOnFo/hDv0prEicSlWizbK5
	2yexGYxw==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmul9-0000000EXL7-3D3n;
	Thu, 23 Jul 2026 14:50:52 +0000
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
Subject: [PATCH 10/22] block: export fs_bio_integrity_{alloc,free}
Date: Thu, 23 Jul 2026 16:49:35 +0200
Message-ID: <20260723145000.116419-11-hch@lst.de>
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

We'll move integrity generation and verification into the iomap
submission helpers, which means they will be needed in modular file
system code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity-fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index dd6c85530913..c8e91ada8ca6 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -31,6 +31,7 @@ unsigned int fs_bio_integrity_alloc(struct bio *bio)
 		bio_integrity_setup_default(bio);
 	return action;
 }
+EXPORT_SYMBOL_GPL(fs_bio_integrity_alloc);
 
 void fs_bio_integrity_free(struct bio *bio)
 {
@@ -43,6 +44,7 @@ void fs_bio_integrity_free(struct bio *bio)
 	bio->bi_integrity = NULL;
 	bio->bi_opf &= ~REQ_INTEGRITY;
 }
+EXPORT_SYMBOL_GPL(fs_bio_integrity_free);
 
 void fs_bio_integrity_generate(struct bio *bio)
 {
-- 
2.53.0

