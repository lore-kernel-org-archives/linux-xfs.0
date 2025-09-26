Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45222824A3
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 00:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758846573; cv=none; b=goLRMzLnRRN2KkKJgdwWtO7J/vsuda/ZSSXvYGx9+QdO2UlxHevmU89M+sK/QQcZaZ6BH1rS6hiAK8j0vdHfjF/Ol0dEr4MZr3hcaLxotAslctmDJ12L9u/FOg+BcPVDJbaB3nKXVLJFQxaf6eFm6mYf0Heh9gWSN4OKf2KfpQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758846573; c=relaxed/simple;
	bh=a/zyIEvLQc/XUbs4Regz+PNxwhBjl1k4o/jZih5gfXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGGtl3BpkpksGOOQE3LLqgeQ+Lt1BMPrOP30BkDwoyZwwG73oobbRqtaaTLqayUyfZr5CaGrP+mUfkWnHBSN1SKtHdT8xyWolOxiaNhPm9BFaptFlp1Z4Uc/68woMnhknKhAYoyiyYNVXEqt0k9WLAB2eBjFKavEb5vwku3Q2gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KsXtOm4+; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KsXtOm4+"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3306eb96da1so1318239a91.1
        for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 17:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758846572; x=1759451372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gt8zIXCwfRruji0SsRLpuIon4IqvB5IR8pbhHdgxKmc=;
        b=KsXtOm4+swYd1IuB+WbyeC/E7xFvzvOvg7u3ETbMc32wm6w0qRSsIhDneSHWExKt9p
         9jpI7mtjHbIzlTFC0shx7Ml35qVThjNk134ZyRzelO5jtfXDIO+HkO/JqXnAMq2YpclS
         QxOBb70CY3j1CKVBjsrDLViK4ZcvKcLA9yRhesx+kg42y7a8KFmKZd+IJk+odiP2Y1yy
         WgxFRTnDacqoSz0byXtc3imEBy+m2BEn+79ZXXnXitGvJEh/bKVTLlzxdeTE8Ljy6OVw
         571usIf3vXEYVtPytKDZlO5oKYOfxUwSxKaeJmUUL2twfrrmNnbAAKB82oy1t7wmwlpR
         J1PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758846572; x=1759451372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gt8zIXCwfRruji0SsRLpuIon4IqvB5IR8pbhHdgxKmc=;
        b=N2af9du7kO1elcZiPxm0hnpmp1oFdyOOk8W3fc3Ba9IJm7MQ4kG8J3lUb89jfM1U88
         b+ShuUUppypyXHFRVtv1JAZkHLOxTAv458W/zgGtdxtd/0GZWJ3PIa3yT2fQCV+Jyfu9
         OG3gpzH6VPAzRa6k88KArBUnKKCNW1C4ufo0OEGT56vEMAVuDq4W2po8Oc0seFwCHZdw
         cw9U3NEZSitXO15vB0rrfxhRpevZUenmN8gQKRM9kOiqkVCQaW1chq9/Vqip59Iwb/ov
         xGIl4yycRINq8GNY0fYVA2mcLkw22ri4B/HBoUHEV3C9O6NFtuOLm9p3WiM8ErZrS6/t
         Pzyw==
X-Forwarded-Encrypted: i=1; AJvYcCXxvQnMzZkK8mDNW4xV3AkYTDWkjVo7qZf6gb6D8s1Q7WCwdY0yWCNrdLQfqVDHXJ5Hg+HmtUchxh0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvU3oi3gqGPIjiRcxCCN3a7wvcrb9l/lKsaHyV9s/uvSHbjJw7
	k1kAdn4703FAxIm6yzUcOwxRTi1NtZ2+kv/q+Cs/UikzHdqAzOhQz5s0
X-Gm-Gg: ASbGnctq3vbiGS2HP41a/741+r/dGssxGbfb4UT900VMj6wgHvXjm5floKJ/g9xbg9J
	IY2qEoU4+iqulTUTuZGPIUxV2XM9B4Z8pj5rxJesyeRRL8Be9MIc/cRbo754G2OnSQSPFa7KQHG
	jgmTbrDUJYzuhhRY5szh2tP1aRohLiprhDGUcAksJFQamI6a0sqaoJkArt2QLkxzZFrznk7uOkF
	XWZ00TiANg8XQNjXMenPf0Emwf6EWs1VFL8iXy+6bD7Rv5AquCipcJTW9EZZ2Cao+ICRIS74Jf3
	mNLQc4ZsXskknGYaXg1fp8OOAbljuW38LeO+XDQYYDQreDK6v2hpcXw+tBQZaNSz3sVy7i5Qphk
	2I58Q+koQwDEwBD/hOguecy8nZcND2UNLoUJOXZq+7Edkd0gr
X-Google-Smtp-Source: AGHT+IETu8Xg6FKNcFj6KdxYVe833AhhKxJaGKFG0k6oD3PiYvStleW8dB/qiT8f+QPOWW4g7bx/lg==
X-Received: by 2002:a17:90b:4d82:b0:332:afb1:d050 with SMTP id 98e67ed59e1d1-3342a28c02amr5853259a91.14.1758846571573;
        Thu, 25 Sep 2025 17:29:31 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:1::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c53babe8sm3275923a12.6.2025.09.25.17.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 17:29:31 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	miklos@szeredi.hu
Cc: djwong@kernel.org,
	hch@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-block@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 04/14] iomap: iterate over folio mapping in iomap_readpage_iter()
Date: Thu, 25 Sep 2025 17:25:59 -0700
Message-ID: <20250926002609.1302233-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250926002609.1302233-1-joannelkoong@gmail.com>
References: <20250926002609.1302233-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Iterate over all non-uptodate ranges of a folio mapping in a single call
to iomap_readpage_iter() instead of leaving the partial iteration to the
caller.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 53 ++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index b06b532033ad..dbe5783ee68c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -430,6 +430,7 @@ static int iomap_readpage_iter(struct iomap_iter *iter,
 	loff_t length = iomap_length(iter);
 	struct folio *folio = ctx->cur_folio;
 	size_t poff, plen;
+	loff_t count;
 	int ret;
 
 	if (iomap->type == IOMAP_INLINE) {
@@ -439,41 +440,35 @@ static int iomap_readpage_iter(struct iomap_iter *iter,
 		return iomap_iter_advance(iter, length);
 	}
 
-	/* zero post-eof blocks as the page may be mapped */
 	ifs_alloc(iter->inode, folio, iter->flags);
-	iomap_adjust_read_range(iter->inode, folio, &pos, length, &poff, &plen);
-	if (plen == 0)
-		goto done;
 
-	if (iomap_block_needs_zeroing(iter, pos)) {
-		folio_zero_range(folio, poff, plen);
-		iomap_set_range_uptodate(folio, poff, plen);
-	} else {
-		iomap_bio_read_folio_range(iter, ctx, pos, plen);
-	}
+	length = min_t(loff_t, length,
+			folio_size(folio) - offset_in_folio(folio, pos));
+	while (length) {
+		iomap_adjust_read_range(iter->inode, folio, &pos, length, &poff,
+				&plen);
 
-done:
-	/*
-	 * Move the caller beyond our range so that it keeps making progress.
-	 * For that, we have to include any leading non-uptodate ranges, but
-	 * we can skip trailing ones as they will be handled in the next
-	 * iteration.
-	 */
-	length = pos - iter->pos + plen;
-	return iomap_iter_advance(iter, length);
-}
+		count = pos - iter->pos + plen;
+		if (WARN_ON_ONCE(count > length))
+			return -EIO;
 
-static int iomap_read_folio_iter(struct iomap_iter *iter,
-		struct iomap_readpage_ctx *ctx)
-{
-	int ret;
+		if (plen == 0)
+			return iomap_iter_advance(iter, count);
 
-	while (iomap_length(iter)) {
-		ret = iomap_readpage_iter(iter, ctx);
+		/* zero post-eof blocks as the page may be mapped */
+		if (iomap_block_needs_zeroing(iter, pos)) {
+			folio_zero_range(folio, poff, plen);
+			iomap_set_range_uptodate(folio, poff, plen);
+		} else {
+			iomap_bio_read_folio_range(iter, ctx, pos, plen);
+		}
+
+		ret = iomap_iter_advance(iter, count);
 		if (ret)
 			return ret;
+		length -= count;
+		pos = iter->pos;
 	}
-
 	return 0;
 }
 
@@ -492,7 +487,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 	trace_iomap_readpage(iter.inode, 1);
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.status = iomap_read_folio_iter(&iter, &ctx);
+		iter.status = iomap_readpage_iter(&iter, &ctx);
 
 	iomap_bio_submit_read(&ctx);
 
@@ -522,6 +517,8 @@ static int iomap_readahead_iter(struct iomap_iter *iter,
 		}
 		if (!ctx->cur_folio) {
 			ctx->cur_folio = readahead_folio(ctx->rac);
+			if (WARN_ON_ONCE(!ctx->cur_folio))
+				return -EINVAL;
 			ctx->cur_folio_in_bio = false;
 		}
 		ret = iomap_readpage_iter(iter, ctx);
-- 
2.47.3

