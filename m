Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70366403E88;
	Mon, 29 Jun 2026 12:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782737554; cv=none; b=cWVMt2xFzn5OTIV6Ok4wae8rxE9E2fZtRt2OQTtVH1gIfp5L6Zn9hFdoDPFGMrZcU4DPD4g/eQLspKYvwpxzFCSQDQznp9SeM4VEs1d+92LxCIlxUuX61Hbz8QMn+G5I56dDO7mXhZvvrZ82p1Bpj3WsC1QJLP5o5jXU23aho/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782737554; c=relaxed/simple;
	bh=vjzIQr56bbqUuQen8ZFQwVtLzMuamG2MhEmPkalHAW4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tP6pJ7JdX+/Gc4Jeg0VYDjeim6hQesWOoQHN205wnFrMTgtCK5hXKLbWgzYJ3Vplm4o/fP6znGfA3cHjOk6q5hDRHClK6+IYuAIl6D2w0W7LmFXATPBIbarOtaCnaeDQucpl3Jifk7BUW1FU2lg0EYG1ly1cSr8XTMgAIn3gOiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gkf6uLQ6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gkf6uLQ6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=HmlQw2V1WZ28aGLruHO3F2lLCys9wkoeDrBY4NR/HTc=; b=gkf6uLQ6ScM1Eni7QCM45B/EmT
	SSkNaslADsDjzoarvWLPbtXXdOgYZvgoqusxj/K+dAs5vx4CrtPGCSM0a2682+A9y/gprXWs8o4yC
	sp0H73mOQj+/54IxsGiiF2sQTNzT29xVXQk4xxkARn1/R9ty/CD7IRz4xPu5wdGh4t3obIt65y49z
	zff9M23f0iIe8mrcY5Wp+DBXuCzCS8EDPcDAcPJ/MY9P8beJGfEH6TpsJM0aeLL0hqpZJ3ztywbe8
	WJDBdyIMNpj5hCg0JgzsfXBM4s0UcxGUIivqiQBVpB38f29I+HB1io4Ez7acCIpZGV0MfWI6uatjg
	SIqflsTg==;
Received: from clnet-b08-202.ikbnet.co.at ([83.175.123.202] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weBTU-0000000EdEd-2jTr;
	Mon, 29 Jun 2026 12:52:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: brauner@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] iomap: add a separate bio_set for iomap_split_ioend
Date: Mon, 29 Jun 2026 14:52:29 +0200
Message-ID: <20260629125229.3400726-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

iomap_split_ioend can split bios that already come from
iomap_ioend_bioset and thus deadlock when the bioset is exhausted.

Add a separate bio_set to avoid this deadlock.

Fixes: 5fcbd555d483 ("iomap: split bios to zone append limits in the submission handlers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/ioend.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 01287f1ae021..2fbcb06f6938 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -13,6 +13,7 @@
 
 struct bio_set iomap_ioend_bioset;
 EXPORT_SYMBOL_GPL(iomap_ioend_bioset);
+struct bio_set iomap_ioend_split_bioset;
 
 struct iomap_ioend *iomap_init_ioend(struct inode *inode,
 		struct bio *bio, loff_t file_offset, u16 ioend_flags)
@@ -483,7 +484,8 @@ struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
 	sector_offset = ALIGN_DOWN(sector_offset << SECTOR_SHIFT,
 			i_blocksize(ioend->io_inode)) >> SECTOR_SHIFT;
 
-	split = bio_split(bio, sector_offset, GFP_NOFS, &iomap_ioend_bioset);
+	split = bio_split(bio, sector_offset, GFP_NOFS,
+			&iomap_ioend_split_bioset);
 	if (IS_ERR(split))
 		return ERR_CAST(split);
 	split->bi_private = bio->bi_private;
@@ -506,8 +508,23 @@ EXPORT_SYMBOL_GPL(iomap_split_ioend);
 
 static int __init iomap_ioend_init(void)
 {
-	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
+	const unsigned int nr_mempool_entries = 4 * (PAGE_SIZE / SECTOR_SIZE);
+	int error;
+
+	error = bioset_init(&iomap_ioend_bioset, nr_mempool_entries,
 			   offsetof(struct iomap_ioend, io_bio),
 			   BIOSET_NEED_BVECS);
+	if (error)
+		return error;
+	error = bioset_init(&iomap_ioend_split_bioset, nr_mempool_entries,
+			   offsetof(struct iomap_ioend, io_bio),
+			   BIOSET_NEED_BVECS);
+	if (error)
+		goto out_exit_ioend_bioset;
+	return 0;
+
+out_exit_ioend_bioset:
+	bioset_exit(&iomap_ioend_bioset);
+	return error;
 }
 fs_initcall(iomap_ioend_init);
-- 
2.53.0

