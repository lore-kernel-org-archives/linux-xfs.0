Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF50A2E888C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 23:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758066635; cv=none; b=Zc7caMvnHL0xCQmANOLXnKBQhsRNqXnLFZdxx4jDCYFuLXnEZW37B8pnukqGhxk97z4/RQWvmzkDT3QRqe+JZFdW+V5Htq7s//aIdLozl9+bvkqxHOMlB/MAiUWkNSkKs5QPkDju9hLtVJe7CGGm8V2V5ZxFoGI3Kxp2BoVBXGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758066635; c=relaxed/simple;
	bh=ZHh5Aoj2S2I/9stdudNSxl02KoF0A8sv8D1PC9opnSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/J1Y2JMApYvg4N5F5frxMxft2UnTdTeUfcKYQ5Rbi9iL3yI+jeWIa9xqNL1Tybnmfq9iYyWZnjhfvQjDzZT3Q8Q5I2dUnDdk+yvsKX5tgPoPqSQ5uVCD7qhjP+VN/iY4kxzxz5V1F2r0IqxgSi7p+uBLh1toQGofA9zJYTqfaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PktAmt6Q; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PktAmt6Q"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7761a8a1dbcso3836007b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066633; x=1758671433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jL16gHrgiHX13VM701419cqvxPOFfSZ8+kJ1tFZqH7A=;
        b=PktAmt6QME2Nhh1YtTsHCTs7U6N8o6+lHWBVlxbCG0qYKbCRYEgYotpdrlVGB66nmI
         ANTveY72SL4qGL8j2zu5PVIfvrzl7z2jfdhQp2aUDsAA3uZ78AtZq7vN1Q6CJJOAXGcM
         +YL+DcfPRxBCBojoU4pjiOYbqYPLgHVHHHm8MHlSZOVy6ueSOtEAWVMOtOv5YL4ArT/a
         LOBlQb19pbY5x+1YigKURqkXszBtl0AMF/gZHJ2P51S4ZanCgkD17Lp2BCagpmEtv+ad
         f2Cc8FRrKOLZz5Tu1V1yrYYiqZIV4whxpi37/aVheD1V0YU0LDx+YdaiyHjmVVJu2blX
         uvXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066633; x=1758671433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jL16gHrgiHX13VM701419cqvxPOFfSZ8+kJ1tFZqH7A=;
        b=slhjx/SUxz7KIuC5MsXxs38Y6hcRsFT+UQHRfZuFxzygsQtbmCOC65UvLJgFCqYqUV
         zYR3q66DXnLljPYIR0NPNvFQ8pZB7ZbtsWP/DpG5PuagfZQ/Y2j8mhE5zwtvoE+FTA8S
         Ds7FhuIrJhAeTh6bJjUkkwGXZPcHNNpfOI8wPPw46Vwcx+N09heedkzudY/SwVYyMo6Y
         MHbm2VoP1TnC4d2E1ekBYqBQlemCHh0q+19UaDVuT0wUXReXBOzLci5YXHDJg0CqBYDK
         mprpXFvngoLQcJZHnPCFZERQOCyCVia6rBEcFTmOoCtW5Z6FwX77jxzAS+yCKsPk8mI8
         mlHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLu7bDyp16t+cETMkMH9wYz4npm6CaRI4Jhro+Ha1gDQnEHNG2livs5wIpgOx6jCx+17+vABSwRPg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyiTB3Bv38/Ua0NaWfB8yarjT5+3O3an8ImATTYtVZVcU2cTIM
	nVO9adh8X+7UcRZPqjrpgIN7VIeQI2X2wQM70X4G6tACB5Ll+OShSr6w
X-Gm-Gg: ASbGncviKqqmgLwK4D7V6YTkKwsrtD6Q2CmYTRwJY75+hXIhfGyizbNmOhtKIQ/occa
	8I80hu6D+bMvDWZXaNpdiU9JnE9nn8L1dgCXF8QluTRjtbTHC0WhGRTvUgT7E+1qwV3mvQRLNrG
	Y2OKxtRAuDblNvkvnh3LzP5uIuZOIP2HA/PEeYpvcIwzJ/MhdG+Y/tWrO5+4yUJuJPJbLtdVPLp
	JRPQ9JtHFTKgcco6HR4ONQolpzlEOuqNGAH+up/qQkKbPyiTOF93th6LnPOIcSJ9zXwAF+i78Wm
	g85TPV1B0J2bqahKyNmdp24xvTAHXEOx/mP+xLanghHcmzD7c9E3h4tActz6Sw2UjdTpHuLs7uF
	O0OJJZOIiIoRWk8evlpHaQTceogp0Z2S9D2f8F+NKFrVRYo0cNg==
X-Google-Smtp-Source: AGHT+IHZm7Yh1fz6JZu1L3xEnGn7JMKrOXnTZumBizZxvxbg3JjAtN8zElKhbjwsHr97+f7iaLVWWw==
X-Received: by 2002:a05:6a21:6d9f:b0:24d:9042:c856 with SMTP id adf61e73a8af0-27a97701057mr76284637.17.1758066632972;
        Tue, 16 Sep 2025 16:50:32 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:42::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a387b543sm15282161a12.33.2025.09.16.16.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 16:50:32 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	miklos@szeredi.hu
Cc: hch@infradead.org,
	djwong@kernel.org,
	hsiangkao@linux.alibaba.com,
	linux-block@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 04/15] iomap: iterate over entire folio in iomap_readpage_iter()
Date: Tue, 16 Sep 2025 16:44:14 -0700
Message-ID: <20250916234425.1274735-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250916234425.1274735-1-joannelkoong@gmail.com>
References: <20250916234425.1274735-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Iterate over all non-uptodate ranges in a single call to
iomap_readpage_iter() instead of leaving the partial folio iteration to
the caller.

This will be useful for supporting caller-provided async folio read
callbacks (added in later commit) because that will require tracking
when the first and last async read request for a folio is sent, in order
to prevent premature read completion of the folio.

This additionally makes the iomap_readahead_iter() logic a bit simpler.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 69 ++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 2a1709e0757b..0c4ba2a63490 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -420,6 +420,7 @@ static int iomap_readpage_iter(struct iomap_iter *iter,
 	loff_t length = iomap_length(iter);
 	struct folio *folio = ctx->cur_folio;
 	size_t poff, plen;
+	loff_t count;
 	int ret;
 
 	if (iomap->type == IOMAP_INLINE) {
@@ -431,39 +432,33 @@ static int iomap_readpage_iter(struct iomap_iter *iter,
 
 	/* zero post-eof blocks as the page may be mapped */
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
-	return iomap_iter_advance(iter, &length);
-}
+		count = pos - iter->pos + plen;
+		if (WARN_ON_ONCE(count > length))
+			return -EIO;
 
-static int iomap_read_folio_iter(struct iomap_iter *iter,
-		struct iomap_readpage_ctx *ctx)
-{
-	int ret;
+		if (plen == 0)
+			return iomap_iter_advance(iter, &count);
 
-	while (iomap_length(iter)) {
-		ret = iomap_readpage_iter(iter, ctx);
+		if (iomap_block_needs_zeroing(iter, pos)) {
+			folio_zero_range(folio, poff, plen);
+			iomap_set_range_uptodate(folio, poff, plen);
+		} else {
+			iomap_bio_read_folio_range(iter, ctx, pos, plen);
+		}
+
+		length -= count;
+		ret = iomap_iter_advance(iter, &count);
 		if (ret)
 			return ret;
+		pos = iter->pos;
 	}
-
 	return 0;
 }
 
@@ -482,7 +477,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 	trace_iomap_readpage(iter.inode, 1);
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.status = iomap_read_folio_iter(&iter, &ctx);
+		iter.status = iomap_readpage_iter(&iter, &ctx);
 
 	iomap_bio_submit_read(&ctx);
 
@@ -504,16 +499,16 @@ static int iomap_readahead_iter(struct iomap_iter *iter,
 	int ret;
 
 	while (iomap_length(iter)) {
-		if (ctx->cur_folio &&
-		    offset_in_folio(ctx->cur_folio, iter->pos) == 0) {
-			if (!ctx->cur_folio_in_bio)
-				folio_unlock(ctx->cur_folio);
-			ctx->cur_folio = NULL;
-		}
-		if (!ctx->cur_folio) {
-			ctx->cur_folio = readahead_folio(ctx->rac);
-			ctx->cur_folio_in_bio = false;
-		}
+		if (ctx->cur_folio && !ctx->cur_folio_in_bio)
+			folio_unlock(ctx->cur_folio);
+		ctx->cur_folio = readahead_folio(ctx->rac);
+		/*
+		 * We should never in practice hit this case since the iter
+		 * length matches the readahead length.
+		 */
+		if (WARN_ON_ONCE(!ctx->cur_folio))
+			return -EINVAL;
+		ctx->cur_folio_in_bio = false;
 		ret = iomap_readpage_iter(iter, ctx);
 		if (ret)
 			return ret;
-- 
2.47.3

