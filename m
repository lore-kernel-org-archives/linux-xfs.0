Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CB531F996;
	Fri, 19 Jun 2026 05:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781845278; cv=none; b=d7/xs2hibqWikMOEWdWn4kqNR7CTZxou1BRbb3dNbd4s6jCqulrMwi34ltrdJZjiipCjulRaOsj0GvG66RTveypBgcO6Vus9RPDLkecq+1j05sUNT96GNNSRcDd2GM8z7BPyo6T51fx9Yl7iUnjOZ9nB9zHPrjMZrKE5nqVHsK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781845278; c=relaxed/simple;
	bh=KIKu48UlLh/Zhxw9hg/hDrFH3sSAkBWXyiLt0vjFmR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INcaOwyIqPo2rskxOYSkxPDb6+LWmj4hF5liwN+i6/mk5XuGHWG+Ewn4undHqDoctclZr40LIxjQDFwoxmtu10TyFABJokxA7io0JQi4XeKAEHNTHHk6cacsSNBd0bu8+WPF1EWvykHyHPrDo3YojUy/4tl+KPXfJRYBcr7ldL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zVbODfNP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zVbODfNP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OGz8ag5/wPHrsxPlGRkhiL5M14tr2RNW2uLLU3X9sLY=; b=zVbODfNPcB82udYs6SGhVOPonS
	iy3ICX4rlT1nD2AXfEi79J1BgjNpAltwUMHb4KB57n4D+IE9nh0NrnA7YOJqD9eV1HFFchH1bD90i
	AwKbXoXz1vbUoxI2WBcFT5dXe4dfsgVHBzEQvAhTU8W30+Q9HfFAcK0FoVG24syxa9D3yb+kEVXVs
	aRIiubdqe1EyYRjYPhOYgbEVMgq3LmCPNjthNGBfbQ1gZq/vCtUcLcdd3Xp3uInlxr2h2eBHYW194
	fDgZ0ASICIDRoPfwSl9OEDditGYcbLdvA225VIa2rR3OD1G8LMcg6bNHorejSc+M05mq9oPrM/5/A
	0TJfowrQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waRLv-00000001ziK-0OkJ;
	Fri, 19 Jun 2026 05:01:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] iomap: submit read bio after each extent
Date: Fri, 19 Jun 2026 07:00:53 +0200
Message-ID: <20260619050105.439956-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260619050105.439956-1-hch@lst.de>
References: <20260619050105.439956-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the iomap buffered read path tries to build up read context
(i.e. bios for the typical block based case) over multiple iomaps as
long as the sector matches.  This does not take into account files
that can map to multiple different devices.  While this could be fixed
by a bdev check in iomap_bio_read_folio_range, the building up of I/O
over iomaps actually was a problem for the not yet merged ext2 iomap
port, as that does want to send out I/O at the end of an indirect
block mapped range.

So instead of adding more checks move over to a model where a bio
only spans a single iomap.  File systems can still create iomap
that span more than an extent if they want to build larger I/O.

Reported-by: Kelu Ye <yekelu1@huawei.com>
Reported-by: Yifan Zhao <zhaoyifan28@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8d4806dc46d4..7449cfd995d5 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -524,6 +524,14 @@ static void iomap_read_end(struct folio *folio, size_t bytes_submitted)
 	}
 }
 
+static void iomap_read_submit(struct iomap_iter *iter,
+		struct iomap_read_folio_ctx *ctx)
+{
+	if (ctx->read_ctx && ctx->ops->submit_read)
+		ctx->ops->submit_read(iter, ctx);
+	ctx->read_ctx = NULL;
+}
+
 static int iomap_read_folio_iter(struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx, size_t *bytes_submitted)
 {
@@ -642,12 +650,11 @@ void iomap_read_folio(const struct iomap_ops *ops,
 		fsverity_readahead(ctx->vi, folio->index,
 				   folio_nr_pages(folio));
 
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, ops)) > 0) {
 		iter.status = iomap_read_folio_iter(&iter, ctx,
 				&bytes_submitted);
-
-	if (ctx->read_ctx && ctx->ops->submit_read)
-		ctx->ops->submit_read(&iter, ctx);
+		iomap_read_submit(&iter, ctx);
+	}
 
 	if (ctx->cur_folio)
 		iomap_read_end(ctx->cur_folio, bytes_submitted);
@@ -718,12 +725,11 @@ void iomap_readahead(const struct iomap_ops *ops,
 		fsverity_readahead(ctx->vi, readahead_index(rac),
 				readahead_count(rac));
 
-	while (iomap_iter(&iter, ops) > 0)
+	while (iomap_iter(&iter, ops) > 0) {
 		iter.status = iomap_readahead_iter(&iter, ctx,
 					&cur_bytes_submitted);
-
-	if (ctx->read_ctx && ctx->ops->submit_read)
-		ctx->ops->submit_read(&iter, ctx);
+		iomap_read_submit(&iter, ctx);
+	}
 
 	if (ctx->cur_folio)
 		iomap_read_end(ctx->cur_folio, cur_bytes_submitted);
-- 
2.53.0

