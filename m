Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA9629B775
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 23:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758066631; cv=none; b=raYqZN0x8DgP4Ig9Td+sihDE1VHL+NwCq5bzTPrJALXgsoJW8CmFM3M/xDxzFUOFR31AY0kOObzOlCrR3A0OblRvXcogFpNlBrXqBHOfDTer+/7UpTL7veqxFrD0A4lVYD3cDVmgdHx0zNAmtmJ+CjhEfRvQxjJn/MkVbh+d+gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758066631; c=relaxed/simple;
	bh=w7oHmQ9XFnwraqw2yEaSdByUgxP5t881lYwL3uOQXDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0JAp3Pdcvha01uP5hLSH/ACivoNYIhwIk+tBeCA/3tObT1aEFqjIVt8lwlMXbcH6oEZX2mB4WgdzHwNdC7YAEldHksfq1GTJDf6Ik5aICaut+WGR4At599Bk1fwFdzNpcFk4vMjzVxZJ+nvNcIQSHMHjJl37+tynou9fv7V4TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JOGKUWqM; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JOGKUWqM"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b4d1e7d5036so4003097a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066629; x=1758671429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=igl0szEKM52u4N7LjkG17Yn1ot1jDVlccs4WBeJ3GIU=;
        b=JOGKUWqM6hmg8NbRBW8fKEvclPVuamXSEsrc3Vq8RX4Y6rL4ut7srCj3Ymj9DmOKtQ
         gfF/c65n88R1WHXKGRiXbsLBNOnNo6/wnr5UNaei5t47oue3dL52cK7ovdEobS/AZVKP
         nXupuxq6FG/pY7lVe+4c3Rol+kLx5+3huLIFXfnjtlSpGNIbm5miis1wQKox0FRAgbH3
         BoOxIGJ8k6D8bnIYxP0eh65g9Gp4d5OJ0Tzu/yj6FsyKGXEyPD10C584QKY+MTdn2IRT
         TBkBNphNrcFzDIo1Macncf1cwpjgLft3w5WsNQD8C/dm6IdcrRJ+f+JA4xImJ3r4B6Q4
         Zlrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066629; x=1758671429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=igl0szEKM52u4N7LjkG17Yn1ot1jDVlccs4WBeJ3GIU=;
        b=DICQmhHajkk94ikT/eqqfgdgTDXbcKb4vpITFiyJF6sd5irBbm7MvfFpfkiZtn4kGq
         FOnTKxxqA1cvUyQb2+ZTG0/eWoWpYmaGLUzditbFXwUZg5Gzxfy2aqNPCG0xHHli5y9T
         /CB2dtCcRwMPBr1RCd7706nD+xSz2GjYHy9WhpJ9o77xdXzFfiSW5rtjcVkoGB8Ala4p
         DiST2CbFIH2pbEsmPckU8db1UzN+R5xQI9PnsidVP9hlF8Rrc52P30yS8jLQ7VTkXFGm
         IQZf/WLPn+VJXMtxwquzTCzj5SeBS5E0RNxKCORf4eoNJvg1YYeG34Z3IqIxHZsYMgP3
         hVoA==
X-Forwarded-Encrypted: i=1; AJvYcCVHCytaK/qgYDempmLT6osKt5eSuZPrUbymiBoNEdJtn6E4fu+mc+CuC17jrJV0r/Uh/jeiPGUQwqM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMPmPYkP/Plinf1LgCBqyt9czweQktW1AH5/bJBAdG5Qytiqbp
	3CIjnj+eMqIO9fHvQvP7seXJ7FJqmwtgL7IZSx7WOgHDhBQFAFv7SENL
X-Gm-Gg: ASbGncv+CD4wN/29tqzlLt42yxWdaJrkqH1+X1wpq+fK5Dqsv9UsmvxNce4aUA1Ozg7
	6VPiUmbktV5Cek6XR2nVa0eaLvVc3pcqlL/BB+0NC6KQtl6zU25e3k46ydvxf20e0+HEertzsHy
	KSE3hPDxlYaPMjfytKPhLTqyfBCm6R4hf1IGAt3TxKTmwpVOo4WfHWM9+RP5Mea/vuTh22ba+Pd
	JMXawMUs6RSzTvK2ahnsiN4h6QNoLP0Z6YwwgWeEjTHuPNRkKkftr9qEP1tKgFXF+KULsdVVYki
	o/9xruHM1X8/P67Mplme3w16YhkbXkKMBM585mWvZv2te2EmEGpIH5R1zffDFS3rGBL4H7SzU8z
	vVJYJwBNIBabWWq0KA/8Z/oh7fC9a8OfMAEm5bY/WTN2eZLk+/Q==
X-Google-Smtp-Source: AGHT+IEwM37n6OeuEIlANEEpCI0EjMz/gqdNYw7ssUAAFOa4ZLo8dnWTZo/sk9QfoO9n62XpLdWOZw==
X-Received: by 2002:a17:902:db0d:b0:265:c476:9a53 with SMTP id d9443c01a7336-26813cf234fmr721615ad.41.1758066628820;
        Tue, 16 Sep 2025 16:50:28 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:40::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2680889f486sm3438975ad.137.2025.09.16.16.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 16:50:28 -0700 (PDT)
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
	linux-doc@vger.kernel.org
Subject: [PATCH v3 01/15] iomap: move bio read logic into helper function
Date: Tue, 16 Sep 2025 16:44:11 -0700
Message-ID: <20250916234425.1274735-2-joannelkoong@gmail.com>
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

Move the iomap_readpage_iter() bio read logic into a separate helper
function, iomap_bio_read_folio_range(). This is needed to make iomap
read/readahead more generically usable, especially for filesystems that
do not require CONFIG_BLOCK.

Additionally rename buffered write's iomap_read_folio_range() function
to iomap_bio_read_folio_range_sync() to better describe its synchronous
behavior.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/buffered-io.c | 68 ++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index fd827398afd2..05399aaa1361 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -357,36 +357,15 @@ struct iomap_readpage_ctx {
 	struct readahead_control *rac;
 };
 
-static int iomap_readpage_iter(struct iomap_iter *iter,
-		struct iomap_readpage_ctx *ctx)
+static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
+		struct iomap_readpage_ctx *ctx, loff_t pos, size_t plen)
 {
+	struct folio *folio = ctx->cur_folio;
 	const struct iomap *iomap = &iter->iomap;
-	loff_t pos = iter->pos;
+	struct iomap_folio_state *ifs = folio->private;
+	size_t poff = offset_in_folio(folio, pos);
 	loff_t length = iomap_length(iter);
-	struct folio *folio = ctx->cur_folio;
-	struct iomap_folio_state *ifs;
-	size_t poff, plen;
 	sector_t sector;
-	int ret;
-
-	if (iomap->type == IOMAP_INLINE) {
-		ret = iomap_read_inline_data(iter, folio);
-		if (ret)
-			return ret;
-		return iomap_iter_advance(iter, &length);
-	}
-
-	/* zero post-eof blocks as the page may be mapped */
-	ifs = ifs_alloc(iter->inode, folio, iter->flags);
-	iomap_adjust_read_range(iter->inode, folio, &pos, length, &poff, &plen);
-	if (plen == 0)
-		goto done;
-
-	if (iomap_block_needs_zeroing(iter, pos)) {
-		folio_zero_range(folio, poff, plen);
-		iomap_set_range_uptodate(folio, poff, plen);
-		goto done;
-	}
 
 	ctx->cur_folio_in_bio = true;
 	if (ifs) {
@@ -425,6 +404,37 @@ static int iomap_readpage_iter(struct iomap_iter *iter,
 		ctx->bio->bi_end_io = iomap_read_end_io;
 		bio_add_folio_nofail(ctx->bio, folio, plen, poff);
 	}
+}
+
+static int iomap_readpage_iter(struct iomap_iter *iter,
+		struct iomap_readpage_ctx *ctx)
+{
+	const struct iomap *iomap = &iter->iomap;
+	loff_t pos = iter->pos;
+	loff_t length = iomap_length(iter);
+	struct folio *folio = ctx->cur_folio;
+	size_t poff, plen;
+	int ret;
+
+	if (iomap->type == IOMAP_INLINE) {
+		ret = iomap_read_inline_data(iter, folio);
+		if (ret)
+			return ret;
+		return iomap_iter_advance(iter, &length);
+	}
+
+	/* zero post-eof blocks as the page may be mapped */
+	ifs_alloc(iter->inode, folio, iter->flags);
+	iomap_adjust_read_range(iter->inode, folio, &pos, length, &poff, &plen);
+	if (plen == 0)
+		goto done;
+
+	if (iomap_block_needs_zeroing(iter, pos)) {
+		folio_zero_range(folio, poff, plen);
+		iomap_set_range_uptodate(folio, poff, plen);
+	} else {
+		iomap_bio_read_folio_range(iter, ctx, pos, plen);
+	}
 
 done:
 	/*
@@ -549,7 +559,7 @@ void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
 }
 EXPORT_SYMBOL_GPL(iomap_readahead);
 
-static int iomap_read_folio_range(const struct iomap_iter *iter,
+static int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
 		struct folio *folio, loff_t pos, size_t len)
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
@@ -562,7 +572,7 @@ static int iomap_read_folio_range(const struct iomap_iter *iter,
 	return submit_bio_wait(&bio);
 }
 #else
-static int iomap_read_folio_range(const struct iomap_iter *iter,
+static int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
 		struct folio *folio, loff_t pos, size_t len)
 {
 	WARN_ON_ONCE(1);
@@ -739,7 +749,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
 				status = write_ops->read_folio_range(iter,
 						folio, block_start, plen);
 			else
-				status = iomap_read_folio_range(iter,
+				status = iomap_bio_read_folio_range_sync(iter,
 						folio, block_start, plen);
 			if (status)
 				return status;
-- 
2.47.3

