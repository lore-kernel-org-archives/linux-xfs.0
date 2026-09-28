Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E55348D87E;
	Mon, 28 Sep 2026 09:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790586688; cv=none; b=vEBFQlpowpui+57LAzke0gaaipbgg5jL1uAe4YrnJqJmymgATxzMQZ45h1vkGbUumvB/2/tzvY1bgD8qHmTco0dojchwAXmdyoJflWk+eK2hMuku4Hf8J8pUP128CY8ZUIrRgVTasZy1KREOiBl8Nb/68tVD2gfOhaf+gt8tSZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790586688; c=relaxed/simple;
	bh=VL2lxkJDiRKYveqpgUSO2Xr7lBYjiUAmvkRqx26VBjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxGgUhLgZx1qjlN++DL0ZZB+AC567dmu6bdWrjUlU1Q/gh1Jv64I5/uJT7zr5HjMfSDv7IJvmNDKwaCuKPhrmU/AUD0JNXY0Ox5uSPwQM6YDucgpmo1Z6hlrZQeBAu6KSgCIyn1JVPF6DgcJUyTM/7DFo3hha3BAMna8WzJEEYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hc9KgI2W; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hc9KgI2W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hwGuirUCOg77p3Z3AONylmK3adLyu9T9C6Pnekuqe5c=; b=hc9KgI2WMRGjitgPh4vUwkBZcp
	z93kKMVcJKNLuZOZNYYaKZRc+axxr3ZXvkKP1o8Eq+Acjv2BeSqOjlyKhPAP+Ci2QufdDVlwdMqIz
	XLBBTvr+nJEcWY7dCem0A6WTDgB88mgAO53bW2WGbGa98hqLfHy2bqvDWbLkjecRL9SWg5xf7iP4q
	BQXcw9DB8SG3u073I66V7nyIyv6H76I0Dk59c/sDhGS0dKzM38muDyDnX7sB9cK5XWZK0EnYF78gy
	6aTL0+Z+f32R/mfhJXSmYBtqF0iiyq5PDdsh3OPKih6TcgYEIJf0UMHZkksH2AXk5/tcyI/dbKk6a
	hgMMFpxQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB7OO-00000000Bo4-3IP1;
	Mon, 28 Sep 2026 09:11:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/3] iomap: use bio_complete_in_task for buffered simple dio read failures
Date: Mon, 28 Sep 2026 11:11:09 +0200
Message-ID: <20260928091111.3986811-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928091111.3986811-1-hch@lst.de>
References: <20260928091111.3986811-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use bio_complete_in_task to defer the bio completion handler to task
context instead of the homegrown deferral.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 8b4039d16ce8..8ee8db6bb794 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -919,7 +919,6 @@ struct iomap_dio_simple {
 	struct kiocb		*iocb;
 	size_t			size;
 	unsigned int		dio_flags;
-	struct work_struct	work;
 	/*
 	 * Align @bio to a cacheline boundary so that, combined with the
 	 * front_pad passed to bioset_init(), the bio sits at the start of
@@ -961,30 +960,14 @@ static ssize_t iomap_dio_simple_complete(struct iomap_dio_simple *sr)
 	return ret;
 }
 
-static void iomap_dio_simple_complete_work(struct work_struct *work)
-{
-	struct iomap_dio_simple *sr =
-		container_of(work, struct iomap_dio_simple, work);
-	struct kiocb *iocb = sr->iocb;
-
-	WRITE_ONCE(iocb->private, NULL);
-	iocb->ki_complete(iocb, iomap_dio_simple_complete(sr));
-}
-
 static void iomap_dio_simple_end_io(struct bio *bio)
 {
 	struct iomap_dio_simple *sr =
 		container_of(bio, struct iomap_dio_simple, bio);
 	struct kiocb *iocb = sr->iocb;
 
-	if (unlikely(sr->bio.bi_status)) {
-		struct inode *inode = file_inode(iocb->ki_filp);
-
-		INIT_WORK(&sr->work, iomap_dio_simple_complete_work);
-		queue_work(inode->i_sb->s_dio_done_wq, &sr->work);
+	if (unlikely(bio->bi_status) && bio_complete_in_task(bio))
 		return;
-	}
-
 	WRITE_ONCE(iocb->private, NULL);
 	iocb->ki_complete(iocb, iomap_dio_simple_complete(sr));
 }
-- 
2.53.0

