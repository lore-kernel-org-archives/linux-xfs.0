Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F361531C8
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479536; cv=none; b=nAndZkrzcL84FGzKIgqUOGLD7cgRTtThfZSHQWCi3pa+8MLwOH0EohYqz6HoRWi8FavXyvSUCIE7jNxYfEl3JxZLmynTa9v1kTHws0a7oUJy7orO4FL3jSG4UHm9UCavDIm1oHBcqrMdDw7jnRVb0mg7+1yAQjLG9oRg2I1xlAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479536; c=relaxed/simple;
	bh=kxPe4iVy8cfXDJreWP8Pt1QLN8EVveJqg39cW/XQiHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ge3qcu+OpDRI3iZfAsqXrK19g9ks9qA8VV5BM9DtdswmJdK4bZtdWUnBbcjV2y7UMf2sWaw2Ks5DBlYt7MyIXKg0G9+1kWgTxgbQOdTFhAkTNDlnRvuURz+ZN+QZJpB9tmuyXdFcC4LzTbU/Y2lvncpKC2Msh9kcNpi2NLl8b0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WI8YwiMU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WI8YwiMU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/zZXrzyOsl6xfQYeEnalw30bjT7COLAi5eAiBDs0mSE=;
	b=WI8YwiMUYBo1JWvf9UKDGcwbmTLanTvpmOEXdQNoBtBuxZ89Z5G4gHtwx9R9d5NPQGjGH4
	uBfHB54YQl28o1OG2a2RR8SPuoyErSW1fTOFChec4CfoaoNBGnnJfXAgbceEhwzbVB7ScG
	n4rywXooUzd1OQPLwl3yiA8BhfQP+vA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558--ekqFzJLPxmm-F3RpL8C5A-1; Sun, 29 Dec 2024 08:38:52 -0500
X-MC-Unique: -ekqFzJLPxmm-F3RpL8C5A-1
X-Mimecast-MFC-AGG-ID: -ekqFzJLPxmm-F3RpL8C5A
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4359206e1e4so67762635e9.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:38:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479530; x=1736084330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/zZXrzyOsl6xfQYeEnalw30bjT7COLAi5eAiBDs0mSE=;
        b=hxCPvzqpxy0TddJ1SUuZTKaX3fUQJE/K02sa0lEmp9lR2GTnYBwUXlRLO17qkILaGc
         Ap3j1AC6gWKLe5rHugVgeYYK2Im9Rka2kTaVFH51qMPpaF4riH+7W3G37C1iP/euzeGp
         HfVF5DNMOBcg03xbcbQeUYiZn38oyND7QshR0UcePN6ol9Bq5jGvJZr9bx+7MgWl3bJ4
         rTt5gE21FaBDmc20hR46NsNFnFPbU+pdhYXgZXY2ekJPtTZKAS+qvd2jCXmHlUvYNKot
         Hd8kpwPltxLEe0H+vO2s3vyHGycuXtD47COS3YjJmqtY2tNh+j8h9wJ/ghfegV5cJt9o
         LSmg==
X-Gm-Message-State: AOJu0YwgvDHeyjf4+VpbS7xdGwO+PuXrLXPIkXpH38OSn+1VAzl0LoEr
	1K6aaDS6ZPaL2SWstLpbG9oOT/2ZQvdvI91epokVA96RYJqdrga/tHEut7FHnb+SEVK+0ihCy6Q
	dvxNIWprk8tw8VE97jqZU/jdPk6nBP6eAqbOt3qNNrljckQn1h2FrpeDLQGB5Rzf8c2eIs6qVW4
	ExLtCjFwhSf4Pb6UM4JlVR+IlWV8/CZWyiKSSstP4B
X-Gm-Gg: ASbGncuzHULHfLlwMwfO1RABI96ipIEbQmMs8p/g1ytf6wB3o4tPDV9hnoCr/VBgAEZ
	8lrN8MXu229OCVizHjhkkgivcDZgx8j0u5h3akEOcdMFJioBFx0qRkt/QC7OI/QqSrNg0NZNbnR
	7WYFFeL89Ysw/7M/zvJ85DaVjPAymDnrsONFjdP4J4hTIgBiJoHhdbxK1ZVHJIsWBONZBz4wYUt
	LA+d36w9MRx/FRB8eb/6TuVVoiCHakAgZEHvKb1hUl17fvS5yaDi5xNFhtu672dwCiKtdHvlFdd
	aGqPw4KRras9xFw=
X-Received: by 2002:a05:600c:4709:b0:436:1ac2:1acf with SMTP id 5b1f17b1804b1-43668a3a35dmr247083475e9.20.1735479530551;
        Sun, 29 Dec 2024 05:38:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHtf7A57Lm/8C8shYrRZeaxy4+osMFkjjSCIKKSDFZ2bFlMclRie5Wi2KENF6Snjko31IZKw==
X-Received: by 2002:a05:600c:4709:b0:436:1ac2:1acf with SMTP id 5b1f17b1804b1-43668a3a35dmr247083285e9.20.1735479530160;
        Sun, 29 Dec 2024 05:38:50 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:38:49 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 01/14] iomap: add wrapper to pass readpage_ctx to read path
Date: Sun, 29 Dec 2024 14:38:23 +0100
Message-ID: <20241229133836.1194272-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133836.1194272-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133836.1194272-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make filesystems able to create readpage context, similar as
iomap_writepage_ctx in write path. This will allow filesystem to
pass _ops to iomap for ioend configuration (->prepare_ioend) which
in turn can be used to set BIO end callout (bio->bi_end_io).

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 76 ++++++++++++++++++++++++------------------
 include/linux/iomap.h  | 12 +++++++
 2 files changed, 55 insertions(+), 33 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0f33ac975209..0d9291719d75 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -320,14 +320,6 @@ static void iomap_read_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
-struct iomap_readpage_ctx {
-	struct folio		*cur_folio;
-	bool			cur_folio_in_bio;
-	struct bio		*bio;
-	struct readahead_control *rac;
-	int			flags;
-};
-
 /**
  * iomap_read_inline_data - copy inline data into the page cache
  * @iter: iteration structure
@@ -461,28 +453,27 @@ static loff_t iomap_read_folio_iter(const struct iomap_iter *iter,
 	return done;
 }
 
-int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
+int iomap_read_folio_ctx(struct iomap_readpage_ctx *ctx,
+		const struct iomap_ops *ops)
 {
+	struct folio *folio = ctx->cur_folio;
 	struct iomap_iter iter = {
 		.inode		= folio->mapping->host,
 		.pos		= folio_pos(folio),
 		.len		= folio_size(folio),
 	};
-	struct iomap_readpage_ctx ctx = {
-		.cur_folio	= folio,
-	};
 	int ret;
 
 	trace_iomap_readpage(iter.inode, 1);
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.processed = iomap_read_folio_iter(&iter, &ctx);
+		iter.processed = iomap_read_folio_iter(&iter, ctx);
 
-	if (ctx.bio) {
-		submit_bio(ctx.bio);
-		WARN_ON_ONCE(!ctx.cur_folio_in_bio);
+	if (ctx->bio) {
+		submit_bio(ctx->bio);
+		WARN_ON_ONCE(!ctx->cur_folio_in_bio);
 	} else {
-		WARN_ON_ONCE(ctx.cur_folio_in_bio);
+		WARN_ON_ONCE(ctx->cur_folio_in_bio);
 		folio_unlock(folio);
 	}
 
@@ -493,6 +484,16 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 	 */
 	return 0;
 }
+EXPORT_SYMBOL_GPL(iomap_read_folio_ctx);
+
+int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
+{
+	struct iomap_readpage_ctx ctx = {
+		.cur_folio	= folio,
+	};
+
+	return iomap_read_folio_ctx(&ctx, ops);
+}
 EXPORT_SYMBOL_GPL(iomap_read_folio);
 
 static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
@@ -520,6 +521,30 @@ static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
 	return done;
 }
 
+void iomap_readahead_ctx(struct iomap_readpage_ctx *ctx,
+		const struct iomap_ops *ops)
+{
+	struct readahead_control *rac = ctx->rac;
+	struct iomap_iter iter = {
+		.inode	= rac->mapping->host,
+		.pos	= readahead_pos(rac),
+		.len	= readahead_length(rac),
+	};
+
+	trace_iomap_readahead(rac->mapping->host, readahead_count(rac));
+
+	while (iomap_iter(&iter, ops) > 0)
+		iter.processed = iomap_readahead_iter(&iter, ctx);
+
+	if (ctx->bio)
+		submit_bio(ctx->bio);
+	if (ctx->cur_folio) {
+		if (!ctx->cur_folio_in_bio)
+			folio_unlock(ctx->cur_folio);
+	}
+}
+EXPORT_SYMBOL_GPL(iomap_readahead_ctx);
+
 /**
  * iomap_readahead - Attempt to read pages from a file.
  * @rac: Describes the pages to be read.
@@ -537,26 +562,11 @@ static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
  */
 void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
 {
-	struct iomap_iter iter = {
-		.inode	= rac->mapping->host,
-		.pos	= readahead_pos(rac),
-		.len	= readahead_length(rac),
-	};
 	struct iomap_readpage_ctx ctx = {
 		.rac	= rac,
 	};
 
-	trace_iomap_readahead(rac->mapping->host, readahead_count(rac));
-
-	while (iomap_iter(&iter, ops) > 0)
-		iter.processed = iomap_readahead_iter(&iter, &ctx);
-
-	if (ctx.bio)
-		submit_bio(ctx.bio);
-	if (ctx.cur_folio) {
-		if (!ctx.cur_folio_in_bio)
-			folio_unlock(ctx.cur_folio);
-	}
+	iomap_readahead_ctx(&ctx, ops);
 }
 EXPORT_SYMBOL_GPL(iomap_readahead);
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3297ed36c26b..b5ae08955c87 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -296,9 +296,21 @@ static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
 		iter->srcmap.type == IOMAP_MAPPED;
 }
 
+struct iomap_readpage_ctx {
+	struct folio			*cur_folio;
+	bool				cur_folio_in_bio;
+	struct bio			*bio;
+	struct readahead_control	*rac;
+	int				flags;
+};
+
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops, void *private);
+int iomap_read_folio_ctx(struct iomap_readpage_ctx *ctx,
+		const struct iomap_ops *ops);
 int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops);
+void iomap_readahead_ctx(struct iomap_readpage_ctx *ctx,
+		const struct iomap_ops *ops);
 void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops);
 bool iomap_is_partially_uptodate(struct folio *, size_t from, size_t count);
 struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len);
-- 
2.47.0

