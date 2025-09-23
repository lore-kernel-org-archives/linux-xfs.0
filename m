Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAF41C8606
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 00:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758587637; cv=none; b=f469e9oivCivqz4HF10YqyZJ2asbIzoTUao+85I9hVo/jUrQ0Lq0cyUrd0e4IR0nMYh3gCMAL6qd52VBlPxArTlx8VsQhgrw/37xfMjaAB/BQCglZDitTKEFXlfd+NTwK0wumayoak+PS0rFE25NIGDEacbqtQWGk3cN4xNKUu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758587637; c=relaxed/simple;
	bh=EIuqb+bEXzHKheYSg8/gT99wnpLEGYyBUdzthx12unM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwrU6W0yad/BuWk3cB2jJoEmS5x14zbU0KxJrRODFelJeoPO85tWVxhKM/0Wfwxf8pMuNN2V5ovLTFQhzYzRL4XrKi0V4ZWny8Xg6jaKy494c6o6T7k3RLwBLebWWy09sa3jElGTOs7M7wMzu4euXjI+IHFJjWHJ28eU0XQEdew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k4y5rP/3; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4y5rP/3"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-269639879c3so50144765ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 17:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758587635; x=1759192435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vApv1A8U/+p+Slbx14eQKwBqtf6JexlqDhpDLkVD4XQ=;
        b=k4y5rP/3axS9MdonLYX3xhcRiKET5eSdG1oobLiCXTAt60PMq9x2fLL1r4Vx7wBmmA
         BhEL8gS/vWO3rOt8ReMlHGj+rrYm8/8HQLQ2baQQc6/F9B4xqj3ztSoRi+TRLcj3ECl6
         7dCMqrc1bVd3e2qIStZIVWhSF+vL8jxwQFaE8rIA1d24mNEIU0UCbQXF0r6RL/D67RUa
         oGvXmEUslG0yx6l8o0hNQKBLaPxDxAOmP0tR1E4XT/812bQGPuf90MJpuAfwmv4Wj8OZ
         t+8o8fnHHv3miuwB547WbsdwcjZWOOcRtClTKlTlYegw33fq3+pWuhoM7AColJmI70oJ
         z0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758587635; x=1759192435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vApv1A8U/+p+Slbx14eQKwBqtf6JexlqDhpDLkVD4XQ=;
        b=TcUgURwVhue/VhkoOps/UELjq4vi0gpnBdhMLOUs0dMvxcAuBV1eTOfWsNvjxV2mgW
         SD6NYFiIsw+OdfDMkYkXDFfS0l9kD1FQMYfe7i2JOI8knC38EfnH8QzKzF+rbbV/6+pl
         Rep2Y/W6Li4UVgik6GIiBjYRX/gmg+NSoQa5F5bCebDEm+uKMQQAC276JY8A6atxrwL2
         vlxDXF8bsHeitAXc/Q7EsqzkSZEDSQ5UxMq8DJKonKtxBJnjmI/7c2Z0VOIYag/WY5md
         No9uzkCXQc6Mkf2t8PDmV8u2TE9XV+reGJ3rFSaEPwPss8g6v1xPp46MkVpIasZR0L4F
         8CdQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1OAzLSL8ssH04Oys93dwkqRK5AHq++IBfTqEGHaoDHXB0XPfkiG45vnu9bKB2skHjpCE8GLbZy6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCTk87sRrNueQ8pw/4urbjFRFpn8pZaWRonoKiBnyAdWLfFihz
	fNa5694ARLduWp/q3QOZkoBuPxg1QoPsbjNjtcSkU2RaK/4m5m5dCZA2
X-Gm-Gg: ASbGnctX/2anvTQnyrnVRVwi7UQt68N6liesyDl2LaEwmXcHBRV3kA7OjYO0mHS9iPr
	UNEjf27RSF8khUwhX0cjq81/HvBfTsZOVW3cgmpTlSGpqdgjNllgqTOXmbo+SIfS81JaG09bXgR
	4y2bvPopExuvk+YfrQj5miudRuHWLPmyNBvf/J16awbYCL+s1Oe7M7IBAPHP824pM2JWwHbINOy
	ok2DoyCRZJ8y1UVcNexG84lJSgWC37XTCwqdIO3EijTrfEn8c8CtNdCQy//cj3JOVPrMvdQcc7P
	PE6NtBxqD515KYB+d7/QkIhpLFBPAcWpNTmTzfPMBGUDt7MnjPOynzCWADVCHPyGteyJJVeJzPY
	ZRBbGlQzD3Chd22HMP273/dTZNcOFbbk02d7XRaiXhX/ucOgsxywTOdrS90U=
X-Google-Smtp-Source: AGHT+IFYTpNSjfUD4M2hqi+bqTZwEMz3Dj9iqDCa9q6c/0wRbqwF/PnO6+RzUOlJ1m1U0d+6bAdDOA==
X-Received: by 2002:a17:902:fc8f:b0:25c:982e:2b1d with SMTP id d9443c01a7336-27cc7da64famr8085685ad.59.1758587635368;
        Mon, 22 Sep 2025 17:33:55 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802df446sm144936935ad.68.2025.09.22.17.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 17:33:55 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	miklos@szeredi.hu
Cc: djwong@kernel.org,
	hch@infradead.org,
	linux-block@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	hsiangkao@linux.alibaba.com,
	kernel-team@meta.com
Subject: [PATCH v4 02/15] iomap: move read/readahead bio submission logic into helper function
Date: Mon, 22 Sep 2025 17:23:40 -0700
Message-ID: <20250923002353.2961514-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250923002353.2961514-1-joannelkoong@gmail.com>
References: <20250923002353.2961514-1-joannelkoong@gmail.com>
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

