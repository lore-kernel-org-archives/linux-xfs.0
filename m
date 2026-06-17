Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D6946B5
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 05:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781675910; cv=none; b=QKqdHVkUPuP5aj7zJz8wh1Os9wl4mmklBiwliYSWjILKxswTVK0P1JeyMfD1d9IA4t3um1ZIliRX9L+T6SwJblfmNMHg6fFfxjFfMTs0oiwTPm6gpYlDQg+lsLNFjGXxiBFM5GyiWfKPkGsFk6jQuY7XHfFuxzEKGJptFZ7A8BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781675910; c=relaxed/simple;
	bh=4CCyecvRl+IIlr7kO0T2pJxOl0a74M73zuh23c1ql2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNnKnXgZfI5ohNPck0jGlzpL6udVTflrvcFmgpkTnUrefuTtS3FpDZ3kRfKTp2gqD/WRuNskj2ayeWDObtLJpGwrQxp5/yhogbMoGAfbGWg2y5ZtUrs5mpWvfYU+XSmZIPfjX03EbvobAMErYTALH7hVzBaTNv1zX7mzX/h+z78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nfJZP817; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nfJZP817"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kCQuOoe5TC5xj9VCcZFdajvdAtMfJLwt7gIZE0Brg88=; b=nfJZP817m4FW5Q6jNUPB+0v50b
	96PLhtq793RxjfudL2yp8yEU5ecrws1h0zQH5ZjfNU20gzuJ+AZdFakEh0KvhxD8l+Ed0dIOY1XV5
	RW0yrqtUQ/gbLuKFOVO0JsVEYws7xkUJp76Ds5ydw5NPAlCoSx0ZVpTMj4pOlsBdRQPTRfHk6JQAX
	WkusM0Ka+Mv4nNUufGndv5g+/rWPQz8bIMJlgd8nvi1yEr5HquVSu61GdxLWvaIHM5L/aUDb1RKbx
	wXkO7we36h6KeyyDy+mzh2Xp9eMxEufdFIAJy5KEiGcn1wu1owppnMjhiaufTwxTyG62U8U/BuZWJ
	O5P2IFyg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZjIC-0000000GgAg-2TCb;
	Wed, 17 Jun 2026 05:58:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: simplify the failure path in xfs_buf_alloc_vmalloc
Date: Wed, 17 Jun 2026 07:58:05 +0200
Message-ID: <20260617055814.3842058-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260617055814.3842058-1-hch@lst.de>
References: <20260617055814.3842058-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Look at the __GFP_NORETRY flag set for readahead so that we don't
have to pass both the gfp_t and the flags in.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index eea2a8757fe1..1ed9f01b3275 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -168,14 +168,13 @@ static int
 xfs_buf_alloc_vmalloc(
 	struct xfs_buf		*bp,
 	size_t			size,
-	gfp_t			gfp_mask,
-	xfs_buf_flags_t		flags)
+	gfp_t			gfp_mask)
 {
 	for (;;) {
 		bp->b_addr = __vmalloc(size, gfp_mask);
 		if (bp->b_addr)
 			break;
-		if (flags & XBF_READ_AHEAD)
+		if (gfp_mask & __GFP_NORETRY)
 			return -ENOMEM;
 		XFS_STATS_INC(bp->b_mount, xb_page_retries);
 		memalloc_retry_wait(gfp_mask);
@@ -244,7 +243,7 @@ xfs_buf_alloc_backing_mem(
 				return 0;
 			trace_xfs_buf_backing_fallback(bp, _RET_IP_);
 		}
-		return xfs_buf_alloc_vmalloc(bp, size, gfp_mask, flags);
+		return xfs_buf_alloc_vmalloc(bp, size, gfp_mask);
 	}
 
 	/*
-- 
2.53.0

