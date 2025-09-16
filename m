Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFE82F0C4D
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 23:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758066638; cv=none; b=ejqsQN3IgT8q+OUUhHAKTRsbCba+JlltObNH7J4+vyhv7oKHsEjV9ozcJJB14AgworWeyYcqu0hxwue1KEbXu/inbp8NH7ej/MKSz5ssCp6iNStFNU8Kna1yeFv4GSORkzbeGmfxrXVSJnvMsoDt0Sy7ELkzv2Phb1or7QaBpFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758066638; c=relaxed/simple;
	bh=Yyt3s3tbXY7QwAI4TPD26F/A94LWO5nXEEs4FjwMAGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PENN7hSgeozaSu7/Bot+f+hbDbW5mqmcU9P+YY6rsFqHa7cKX9JG4JTUPI8PycwHBgEnx5CKR2OD/o08EaUj5THKN5nVMoVtoqD/lMGEw+i7nxEoJgo/Mcr8xPKvP5+9KGZs6YZCZ4WGPOQVrGHlESVx2cEWGXKMrDbQ+1KUBZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mtylDoEz; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mtylDoEz"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-261682fdfceso3761135ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066636; x=1758671436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KIk1L4IFEloGQNbnkxMN6KLWRcTMndGu9WccIzvQI/M=;
        b=mtylDoEzFiXzubc1PO8uiX/d47ncZQiUF6Cp4MVXmImsq3CS1d5OIF7xvvW82lkt/w
         3tEL56P8yYsjD9o3Iju+4lQFklS7x5ojgi4oXwPO2ADmEV3coIzP5bwH+ORL3G2EsUfB
         aiGX6EtGL5DjryHvalYW98uOO7MRZkvdxwA6R9apD+9oP2UAurgznC27DBS954bAfHef
         nyQVh8R1RPT2vTgL6a3TSLlGlHl4RaoeQ+4DL1ahY58a5UDexg/LWcTMD7e0fIegCUkn
         ghgevEyRDBtyg81ScbulW35vilYbjGKcK9i9ioaEjtVKZjFY7+XtOp8xcVgL8xKbBwK4
         zIyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066636; x=1758671436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KIk1L4IFEloGQNbnkxMN6KLWRcTMndGu9WccIzvQI/M=;
        b=KvCSE4wuBagyXrg85ruMJAuG2P3RwAktF1MDTmfnw5RW9rg2OLBEfVHCs564gdFnHb
         8fuQbNQxLN5fKRS8e5LvYuaElnX2KnaPvFCpuRagDa79AnQqUlYW5d71z5BpdiSaAeSy
         PbA5+hy8Fj+L3rLdIgw3L96nPgM28FmA6VjJn3AAjE4od3KUKSUU7lDXyH+AaIx1ClYa
         kYIIgQssXo7KekV5FQlukQJulN5anCHRe8wlG8bguL523FWi/9aCh9/jpcTPfT7nv2b2
         RYpC/0x/xNeMTxM5kEJ/k+nkTpKGEv1VchBCfJUqMqkkOFlq4tvs//QdOgXJRy9Jyx5T
         rCww==
X-Forwarded-Encrypted: i=1; AJvYcCWtjSl1+HyhhuJnBaKGmayuxafnr/7uyqelgj3/MrQVdmYNIrU5ltaV/HVbqnGglBqXe2UZitK+j2I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8wAOcRmr8uf9ZKWdIkfD0Vnx/oEK4CzFDQll2KsqJuT4+lk+V
	zP39Dlp42WKyVXNNX+Purhu+NS17JTuajmRR1QRAnBASr0554lcDPD+0
X-Gm-Gg: ASbGncuU0FWVFI6oOUkbvFUFAtwTUw+dtd7WbqNsDM6gRLkARgKKaaY3QgOKLRzwG0x
	aGI0VkGzrTJ+g3GQH0wOhPaR6AmPpyf5BZHUh5epfV5OcIEPZmBbI6nUzFdiAV2N+Wsfo3KwIfe
	KNI76pfemBZD8RY09p+urPWKTKw+O7Q32Bm7Z4Y23oHnnZRH7xUCEkHkALD7VnuP2hfbfzXz9e5
	Z+P6X0LtCZ0l6zdFZlDSQTvZOEAJBDOvAPu9GMBGj0vXBP9ZR2l/cF7jnqrnOpq9RK88irVL/Gd
	Bw9QUCp4RCnOVBubHi2hiawYQ4VVCAJyK192c4TYBPYSX7jTznl2TTFQuljaglwB7Epp9PKY2qP
	f8YF3tcorKyQWAbFgf+Fo0hVvljfYZ+byN2UXg4LS3ke2ze0lt68jugDcfdtV
X-Google-Smtp-Source: AGHT+IHNyQDV8MtJvN6c+ZIdOgaZI0j/AlCjhhT7u/T86oO3i7+BLfkpWtoSR/NM9VEtGl/sAno5YA==
X-Received: by 2002:a17:902:fc4e:b0:267:7a5d:42b1 with SMTP id d9443c01a7336-26810c50bb2mr1969135ad.30.1758066636134;
        Tue, 16 Sep 2025 16:50:36 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-267bd70598csm39576735ad.145.2025.09.16.16.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 16:50:35 -0700 (PDT)
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
Subject: [PATCH v3 06/15] iomap: rename iomap_readpage_ctx struct to iomap_read_folio_ctx
Date: Tue, 16 Sep 2025 16:44:16 -0700
Message-ID: <20250916234425.1274735-7-joannelkoong@gmail.com>
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

->readpage was deprecated and reads are now on folios.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d6266cb702e3..6c5a631848b7 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -350,14 +350,14 @@ static void iomap_read_end_io(struct bio *bio)
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
 
@@ -366,7 +366,7 @@ static void iomap_bio_submit_read(struct iomap_readpage_ctx *ctx)
 }
 
 static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
-		struct iomap_readpage_ctx *ctx, loff_t pos, size_t plen)
+		struct iomap_read_folio_ctx *ctx, loff_t pos, size_t plen)
 {
 	struct folio *folio = ctx->cur_folio;
 	const struct iomap *iomap = &iter->iomap;
@@ -413,7 +413,7 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 }
 
 static int iomap_read_folio_iter(struct iomap_iter *iter,
-		struct iomap_readpage_ctx *ctx)
+		struct iomap_read_folio_ctx *ctx)
 {
 	const struct iomap *iomap = &iter->iomap;
 	loff_t pos = iter->pos;
@@ -469,7 +469,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 		.pos		= folio_pos(folio),
 		.len		= folio_size(folio),
 	};
-	struct iomap_readpage_ctx ctx = {
+	struct iomap_read_folio_ctx ctx = {
 		.cur_folio	= folio,
 	};
 	int ret;
@@ -494,7 +494,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 EXPORT_SYMBOL_GPL(iomap_read_folio);
 
 static int iomap_readahead_iter(struct iomap_iter *iter,
-		struct iomap_readpage_ctx *ctx)
+		struct iomap_read_folio_ctx *ctx)
 {
 	int ret;
 
@@ -539,7 +539,7 @@ void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
 		.pos	= readahead_pos(rac),
 		.len	= readahead_length(rac),
 	};
-	struct iomap_readpage_ctx ctx = {
+	struct iomap_read_folio_ctx ctx = {
 		.rac	= rac,
 	};
 
-- 
2.47.3

