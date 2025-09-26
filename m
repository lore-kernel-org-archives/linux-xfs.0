Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A3015CD74
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 00:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758846570; cv=none; b=OVULVEFn/myZTtL7pdVLeQr8H5rqQWPPJ4uHON8SS/n8iGyXcy5y7OpP/fj9v7B20TzakngqN7pw04Xy5zTF/IZBVjWog3tVMLLuVdQMlMb1HGkzVjehwcmCKMlNSQZndMcQtZq+jw8LdoMwoEntoTI0cqeXzEjX6H8cJYFo06o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758846570; c=relaxed/simple;
	bh=EIuqb+bEXzHKheYSg8/gT99wnpLEGYyBUdzthx12unM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avfv1PXpcyl6l7aTpW8Fbly29jfwX0vNylIZkdU8A+UIjwhlnefKyEbA+rPbjDD8VWz/KMl2c0Waez2EKmObpdKXkrto/Zq4K/sE8JY6AjFLm7PBBQkhtjat1rWUaznjB3uuqodPTpUNcsl5IqkyFOfnWC7uwlPj3o/Qyf/Tt64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VKmmG5T6; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VKmmG5T6"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b550eff972eso1102115a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 17:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758846568; x=1759451368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vApv1A8U/+p+Slbx14eQKwBqtf6JexlqDhpDLkVD4XQ=;
        b=VKmmG5T6vkrGY2k7DgKj3GuReAhB2ZFCsDa3KUZ8TFL7rFaKQuyrHXDz8mbPBOt6Jf
         03BGyi+O5o6AE5Iwqa0kIp8WT0biZHlMveNf/DC0IpYObOlTwvWFfpzOZugLqC8pgl62
         3bgUKf7AFU6s0doBeOgvgXMY15rcc/m4Bn8C3rYKXDmEqqxheTJdfnlxStA8WKnxcp88
         kiS1h2c4xpArrG2eUJf+jYOXegskASvhokggGr71e7sBJmA9TLjgWeQgdud0IUbAZJSo
         0R4AHa1vucuaIRvyeo0JDBMGhB8Bjd3K958lRZtA8/RZ2i6WGmkMGsXFVYmN8BdcqPUP
         3/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758846568; x=1759451368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vApv1A8U/+p+Slbx14eQKwBqtf6JexlqDhpDLkVD4XQ=;
        b=oZBdIxurg/X6+0pHOkSQNo6ZqXfHQ/2hBLfcL55SqEB7/W3aHEP0QZ+ujvfR4P2iNa
         BWcrb33ZjRvJSW0MESfdsGmAtYadIf8zeroEFHiR12TsELU99VHpQfXaAcJynZI21dpM
         JRLYzalxzNQ4elSgKertjAnj4Z32Pp51cul8Bc0g5P0gv7+hW09geRxMst63NUtihyMj
         u7JGia7YIkdjtx3AeMF6Rscfu5lUyc4Ro+RtwxQ+0V+VQBOzDGo1heL0LbIvuXASRHar
         ldFHs1WuZd1ywlxH6fRzzYYwiAswhIqy3ilf/pty+kmZWSC4bPpS9ubkb5ju++Lw/sI+
         zpqg==
X-Forwarded-Encrypted: i=1; AJvYcCWSI1loK4yqg04KxK3N3vNf1rIpSGOUOlgR1uimjO3m5R4ktS4D92eMDtuOqK9DkeD4NYz/v1sb3CI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMVH2BiNjAzlsEKvPGXfSnsbwvPnnJJSb6y9B0Ppl4M7MJ4aIL
	otAZObsO+ygM0uve/z6dhA6JvoiXZnhwseU9jGETdFW7JNAW3knUdd+l
X-Gm-Gg: ASbGnctVAIGwxGPa7JcIdKDTv0p5ElojBMSmYBs4EDZE3sSb8lVBnH644nyfzmfQPkU
	Y1LZoX4KwbhzPmEz9AfLUwzge7K5Hua+l3MtdfAvtjJ+GzToxh7LK8Nek512FnB1S2VyLOB06dV
	GU85SFUfYMOnLRuSYEPiaEtiTsmnzs2EZTc4BxR/EWE84zsJIlBoSlQ+35lU0Axf+hle5c9w6ZI
	ADXayR6wAYBrI3jGmdYFZaiBYEJgxgWTAy2o8tAFR4GMr9D5MlYgO9kaTnPowxk1LiBIQrJ/ZMn
	RKG1y8PdLtY6nVay563Y3qklBZduunv1JRYukFaEYxBQLKPQQXD8MQBoj7aOWcj6Ok4U3flImkq
	ymzA0l2YrS/YUe7m1wTsbJ4P+9h7/UesMl/F2pQF7y1+vW8l+rg==
X-Google-Smtp-Source: AGHT+IH23dwF1NgLX5PleNnijXd7QbsowqYTMDXXK2Av0KZS7klqMtWV6FrRS8eSIiqXbBxh0MCuvg==
X-Received: by 2002:a17:902:d4c2:b0:267:a1f1:9b23 with SMTP id d9443c01a7336-27ed49fbd2fmr63113575ad.18.1758846568053;
        Thu, 25 Sep 2025 17:29:28 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cdfafsm36331395ad.30.2025.09.25.17.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 17:29:27 -0700 (PDT)
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
	linux-doc@vger.kernel.org
Subject: [PATCH v5 02/14] iomap: move read/readahead bio submission logic into helper function
Date: Thu, 25 Sep 2025 17:25:57 -0700
Message-ID: <20250926002609.1302233-3-joannelkoong@gmail.com>
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

Move the read/readahead bio submission logic into a separate helper.
This is needed to make iomap read/readahead more generically usable,
especially for filesystems that do not require CONFIG_BLOCK.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 7e65075b6345..f8b985bb5a6b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -367,6 +367,14 @@ struct iomap_readpage_ctx {
 	struct readahead_control *rac;
 };
 
+static void iomap_bio_submit_read(struct iomap_readpage_ctx *ctx)
+{
+	struct bio *bio = ctx->bio;
+
+	if (bio)
+		submit_bio(bio);
+}
+
 static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 		struct iomap_readpage_ctx *ctx, loff_t pos, size_t plen)
 {
@@ -392,8 +400,7 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 		gfp_t orig_gfp = gfp;
 		unsigned int nr_vecs = DIV_ROUND_UP(length, PAGE_SIZE);
 
-		if (ctx->bio)
-			submit_bio(ctx->bio);
+		iomap_bio_submit_read(ctx);
 
 		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
@@ -488,13 +495,10 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_read_folio_iter(&iter, &ctx);
 
-	if (ctx.bio) {
-		submit_bio(ctx.bio);
-		WARN_ON_ONCE(!ctx.cur_folio_in_bio);
-	} else {
-		WARN_ON_ONCE(ctx.cur_folio_in_bio);
+	iomap_bio_submit_read(&ctx);
+
+	if (!ctx.cur_folio_in_bio)
 		folio_unlock(folio);
-	}
 
 	/*
 	 * Just like mpage_readahead and block_read_full_folio, we always
@@ -560,12 +564,10 @@ void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
 	while (iomap_iter(&iter, ops) > 0)
 		iter.status = iomap_readahead_iter(&iter, &ctx);
 
-	if (ctx.bio)
-		submit_bio(ctx.bio);
-	if (ctx.cur_folio) {
-		if (!ctx.cur_folio_in_bio)
-			folio_unlock(ctx.cur_folio);
-	}
+	iomap_bio_submit_read(&ctx);
+
+	if (ctx.cur_folio && !ctx.cur_folio_in_bio)
+		folio_unlock(ctx.cur_folio);
 }
 EXPORT_SYMBOL_GPL(iomap_readahead);
 
-- 
2.47.3

