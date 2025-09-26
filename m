Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709CD19E992
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 00:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758846577; cv=none; b=Vf+9t0xmCr9nat3nt7/G5FWQ0gtMs2PJ4sZoZLiJH6c8KX+QXLVTZc1PjNLmmCda2ePhdKYOO7WT9/rGLap7l7qIX6uiTnCEOv8mnyrSJtslClfSQsdioyVa//LDjBSJifTfkbDL13qNAmASmoYABFyUu4JSA+IOAA51txWKaMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758846577; c=relaxed/simple;
	bh=vIAY62bPonaFy7vGVNyvqO/mtaIvl07zVQLoOf2yQSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gU2fDTn1YQBwvEOT5aMIj/AZSpeo242pGdAHoGbQ+83oHA/XtINWGM7PHoYixRCqzw1taOk7/XVkmK93HtQs9OFirPAwmFDnGera35GRVmFZrheunAOfL32IMrP3pp2oX+Fe3Ol13j7jW+PfwwZNwPEy3tZtYGshPJ2xGH9obds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BVhoifj2; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVhoifj2"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3352018e051so1035614a91.0
        for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 17:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758846575; x=1759451375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5+CvxTz0as+KK3qYoCdGCPxNBywOK1cIFwpk87cxKA=;
        b=BVhoifj2QvJEPBhUBsx+Z/o3VunIVABUfPNrHrFKDlFoLc6El5GjeeLWu75NgtOdhP
         FdlRRmBGPnDDFlSTJep2+2lp42UF24GPmp4qjD9j1LUwF3+NxHq8qEPkdmczwxblupvp
         weDbeymXApAW2snpoYCwtQv/h10r0aledVY/tRGZX5u/DOHUvYPGaE3NnFplZ9kUnJWV
         Hj3L8zNuFsYvCc93/wAbv/rGgGzJiDIitzQLQ0Obg3R0fTGU7zohowhw5PUxd2v6aTtV
         aA4Gs0DbD6EY412y+71v0ADSttQqq+4engj7a/79jit7YKZzAKKaR2JJTwKNqFCrTIxW
         bVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758846575; x=1759451375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V5+CvxTz0as+KK3qYoCdGCPxNBywOK1cIFwpk87cxKA=;
        b=nRjb0MCiCvjjQ+uunyHNDNUILeq6RCT4auZQvzgQP9Pt0iHLJ+Zaya+LAqnDrO28Xp
         IW/sSzjKjUD1XVGXZox6Mi+2LipMSwrvLY5eg/+628EK74y9vvOqmsbYA1Et4IlA7T3X
         MT7CAAAje4Wn9V4uC7bWwV7lyoW/KQvD60Vev/5x4OdScRFf/GfXkSNphz6+R7Qo+Wmt
         Ggcc6qXx16bmEe0Y5+4kU4avpIU1KeN5JY1ZFT4Egqj0eRUxTx2kr+k5OwmYQ29cuGdH
         iXginA317eivaX1ROd89aY6VlnnQFZUdqQXqorDJv1keE3AI+VY1x0doVqk7njAivjWf
         RPRA==
X-Forwarded-Encrypted: i=1; AJvYcCXXqgSTqwzCLa9H35ppv0A5JgSfnXuG0HUPDR65zetsLYSjaTE8K/0OCZwxmGfUqXohmP2CZmcCJ9Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzopLhx9fQCE2eAAeEQdqgFywKTRuD1MZ2JpPaf0MNT/SdaHwjC
	r7kWrdDhKx4NslOX2s0byyUT5cAgaxa/yjxvPbz9brU48OMs+mOpCzFH
X-Gm-Gg: ASbGncsBg906ZVxO+EOEoypZSy6x80yDK8cKVlwMf+AkbG+RnOi+Fn1g2e4WLm6lqJL
	vgQf+nS7XBAD6+oYX81b4QEhiS1Uk52uIKTLBW8R5W2eoRbnUMwUWKVkp3p6N3PN+VYWByCG228
	gwD1J4rZLQVZof4sAEHSMwoEpoZAu/lbsikUEQQg/LbC5Ka+3u3iC2tE3gdMV/glnYgM1LfOc1h
	Le6iLAYWa9vwDc5SHgbNGZ5pUbHSUEDkczIMkMOr1SqHXiqGQ+2WrFbg5j+ujkjsiUOSLWzu3Xw
	2R5fBxdm0nsjOmrRc4Fq9C8cNFnqcggc9XejGjEx4B5qzpMiLa1rBhCROcHwG7A8/wNjrB7XGi7
	OEJ3S5bjZLrStrrfK/d9KPBCQzGnozLVqRpwhDvBHZwtqWAsROA==
X-Google-Smtp-Source: AGHT+IFjaZEdrafbvd2zyiTkt6VCFBB0ZO2mwZEYv3mz1oaOZduHe0Q3Y+mjwZVDt2v6FhCaKr5ObQ==
X-Received: by 2002:a17:90b:4ac2:b0:32b:dfdb:b276 with SMTP id 98e67ed59e1d1-3342a3070d5mr5430211a91.34.1758846574661;
        Thu, 25 Sep 2025 17:29:34 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c55a339dsm3185031a12.40.2025.09.25.17.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 17:29:34 -0700 (PDT)
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
Subject: [PATCH v5 06/14] iomap: rename iomap_readpage_ctx struct to iomap_read_folio_ctx
Date: Thu, 25 Sep 2025 17:26:01 -0700
Message-ID: <20250926002609.1302233-7-joannelkoong@gmail.com>
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

->readpage was deprecated and reads are now on folios.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 23601373573e..09e65771a947 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -360,14 +360,14 @@ static void iomap_read_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
-struct iomap_readpage_ctx {
+struct iomap_read_folio_ctx {
 	struct folio		*cur_folio;
 	bool			cur_folio_in_bio;
 	void			*read_ctx;
 	struct readahead_control *rac;
 };
 
-static void iomap_bio_submit_read(struct iomap_readpage_ctx *ctx)
+static void iomap_bio_submit_read(struct iomap_read_folio_ctx *ctx)
 {
 	struct bio *bio = ctx->read_ctx;
 
@@ -376,7 +376,7 @@ static void iomap_bio_submit_read(struct iomap_readpage_ctx *ctx)
 }
 
 static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
-		struct iomap_readpage_ctx *ctx, loff_t pos, size_t plen)
+		struct iomap_read_folio_ctx *ctx, loff_t pos, size_t plen)
 {
 	struct folio *folio = ctx->cur_folio;
 	const struct iomap *iomap = &iter->iomap;
@@ -423,7 +423,7 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 }
 
 static int iomap_read_folio_iter(struct iomap_iter *iter,
-		struct iomap_readpage_ctx *ctx)
+		struct iomap_read_folio_ctx *ctx)
 {
 	const struct iomap *iomap = &iter->iomap;
 	loff_t pos = iter->pos;
@@ -479,7 +479,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 		.pos		= folio_pos(folio),
 		.len		= folio_size(folio),
 	};
-	struct iomap_readpage_ctx ctx = {
+	struct iomap_read_folio_ctx ctx = {
 		.cur_folio	= folio,
 	};
 	int ret;
@@ -504,7 +504,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 EXPORT_SYMBOL_GPL(iomap_read_folio);
 
 static int iomap_readahead_iter(struct iomap_iter *iter,
-		struct iomap_readpage_ctx *ctx)
+		struct iomap_read_folio_ctx *ctx)
 {
 	int ret;
 
@@ -551,7 +551,7 @@ void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
 		.pos	= readahead_pos(rac),
 		.len	= readahead_length(rac),
 	};
-	struct iomap_readpage_ctx ctx = {
+	struct iomap_read_folio_ctx ctx = {
 		.rac	= rac,
 	};
 
-- 
2.47.3

