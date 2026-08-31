Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7635A3B47FF;
	Mon, 31 Aug 2026 06:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158444; cv=none; b=Q3sUN5Yw0pQDbMfUW+w9oZFVdIo7n1+vp1tlishp/VTUCLjWzemjiVTHa0MiwhdTxJZpLJucf36bHelIXkNjviifJ7OqscG3E+RAEe7sVAXSvznNwn4X8FPFw4Spmy4dExbDWrRKvZQxOcfLI3H8igdul+mCEA66Y6CO2iH3f6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158444; c=relaxed/simple;
	bh=oxEgDGdgd3qUyweCCyjhTvPWdEl5kB65tYSKwYNV9hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKwLW52Ak3T6cQJQbgUr8e3fWwJ2l0qYkwawn+TI1E7jjb0PZznEHQha+mVnGGervGxv/bGS4GroHRjp7vJPWXzVMeNj/gTxmm31c8Htkv8DNHQM1wUYkDgiVSDcJS/QCyIJexqNYHBONo6/5Adg1LLku5nY2xbAAuoAGEryD3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kqGc8Xbq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kqGc8Xbq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yLWi2vt0FMebLo/fLpETCKylggWYmZgOLyVrpPhu80c=; b=kqGc8XbqVKBI3rCvipxQtPylkl
	fznPjGgGXe5MqyD9iYI/JpFHNVr9R939RKRQYIm+bHFJjz6mqkMXvBWitR2JSIhE2hVp8yC9RRrFq
	IuXWf/V9+4H5RdPt4Yh8gho/5wlT3LYzyWAqR8dUvdOfNNPTrXbc3l5PK7BrBTztN8lsdOTxF58PM
	JyjdHN54JgvFFe5vp6yjitBOk9/3sQWqHcee4Qeb5mIY1mlkY48cjxr9DgdYzXfjScDDYu+VOQsM4
	JtyynXStouPjAJXZ1dUda7SuqkBrTLd5cT371XXEGWCCpD6DH3yTbc20bJKNa8OjCtPHmTnaDw9Fp
	0pgXKlig==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vhB-00000008cuG-2lsS;
	Mon, 31 Aug 2026 06:40:42 +0000
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
Subject: [PATCH 04/17] block: export fs_bio_integrity_{alloc,free}
Date: Mon, 31 Aug 2026 09:39:52 +0300
Message-ID: <20260831064010.2574896-5-hch@lst.de>
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

We'll move integrity generation and verification into the iomap
submission helpers, which means they will be needed in modular file
system code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity-fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index 692403dfa047..4f67b34bf289 100644
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

