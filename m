Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D0127380A;
	Fri, 12 Jun 2026 06:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781245507; cv=none; b=jgsY/bbqdI7tsqGv13UO7/FDZYJIwecU5IsQAvyVpck4yhnK3tWs5SqxpmqAyFu2PUuC2FYG3iBubgXnH+BuaQRsmYaZt73rKMi8tCx31mC2UoJQ4iNJizWFUH4/XW3RporZ4fBmHJTiwxz0/DQhQZJsT0dQKnzLpXo6X2iG++s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781245507; c=relaxed/simple;
	bh=T5Tilw//UyMWy7mCCW06YEMBkq7I/iVhoXbn6rIzV2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=didRjBRe+6aW/ltxHqbBzml/lJZjMx0iFKFXJ4X6pjKyEAuDLR6jPHQk/njKUdX3q8jChBTJ8gaGNps3vPjPF6jsc8VN/4OwaG5v9xdRey0srOKzZHBzT1hf908L1L4fi67yEFf562xzUQunVjHtW0eYcU8ASHBoa/heHktk6CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ObczGAzb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ObczGAzb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rI0raFviJ2x5V3Pg2Cj/RLpf5nmtmcdmjAOKknNf2M0=; b=ObczGAzbSwq881Nu/6SJ4bKRlq
	K1spnwZVoskC4eLl67EujfZJ7BmIwM8NQOVql2SWSjddDeTUFrPsI3ds5COz98hBM5vDkx3+zYana
	ioi7mTUPlHUlmxs6Sbg145Oqms6rPCrXrqZZHYTkpkOy7r6wABIEwZ9Fp7o53+zwk8maqgwCplPEY
	wVJO2XIMJcTNrA9NToqbW0OLdlfKyYXktzGDmX9HeMnn5TWJI+s3qZ2MJ4remGTl4jnED6i9A6ex8
	Z/vQXTbpqlyHjVgmgHCO8rQB6tPHdYzgpE9fHeLnFQ7eJb9xl7BYz5TRCdcVCX+MzcZUycRg3iwXW
	LAQTmPew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXvKC-0000000APUt-2dul;
	Fri, 12 Jun 2026 06:25:04 +0000
Date: Thu, 11 Jun 2026 23:25:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, yekelu1@huawei.com,
	jingrui@huawei.com, zhukeqian1@huawei.com,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>
Subject: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
Message-ID: <aiumQL8LEWQX_Nag@infradead.org>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 12, 2026 at 11:42:38AM +0800, Gao Xiang wrote:
> > Reported-by: Kelu Ye <yekelu1@huawei.com>
> > Assisted-by: Codex:GPT-5.5
> > Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
> 
> I think it's an iomap bug instead, see:
> 
> iomap_bio_read_folio_range(), we should fix iomap instead.

Yes.  iomap should not try to build bios over iomap boundaries.
caused various issues.  Ritesh ran into that with the ext2 port
back in the day, and I actually ran into it again with an under
development xfs feature.

Can you try this patch?

---
From 297230cc3c08cbfef3670b08c4e35813c18c523e Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sun, 7 Jun 2026 08:53:20 +0200
Subject: iomap: submit read bio after each extent

This keeps bios from crossing RTG boundaries in XFS and probably fixes
all kinds of other stuff..

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d55b936e6986..3642a11c102f 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -597,12 +597,13 @@ void iomap_read_folio(const struct iomap_ops *ops,
 
 	trace_iomap_readpage(iter.inode, 1);
 
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, ops)) > 0) {
 		iter.status = iomap_read_folio_iter(&iter, ctx,
 				&bytes_submitted);
-
-	if (ctx->read_ctx && ctx->ops->submit_read)
-		ctx->ops->submit_read(&iter, ctx);
+		if (ctx->read_ctx && ctx->ops->submit_read)
+			ctx->ops->submit_read(&iter, ctx);
+		ctx->read_ctx = NULL;
+	}
 
 	if (ctx->cur_folio)
 		iomap_read_end(ctx->cur_folio, bytes_submitted);
@@ -664,12 +665,13 @@ void iomap_readahead(const struct iomap_ops *ops,
 
 	trace_iomap_readahead(rac->mapping->host, readahead_count(rac));
 
-	while (iomap_iter(&iter, ops) > 0)
+	while (iomap_iter(&iter, ops) > 0) {
 		iter.status = iomap_readahead_iter(&iter, ctx,
 					&cur_bytes_submitted);
-
-	if (ctx->read_ctx && ctx->ops->submit_read)
-		ctx->ops->submit_read(&iter, ctx);
+		if (ctx->read_ctx && ctx->ops->submit_read)
+			ctx->ops->submit_read(&iter, ctx);
+		ctx->read_ctx = NULL;
+	}
 
 	if (ctx->cur_folio)
 		iomap_read_end(ctx->cur_folio, cur_bytes_submitted);
-- 
2.53.0

