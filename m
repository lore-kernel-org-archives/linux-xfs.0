Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3BE8635C
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 00:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758846572; cv=none; b=TC1p3MQn/RvRSALr32AKj+idfBZWy2zDRQdVtognnw/TRjI+XMQLU7g0UDTuSJsQo1guNO0/6Ksey3lKUWHGL8DNKsnuZJcn0936k8KaovtWblqkYab7//zC4x7CFyR+9foggYG0CDAR041LasF4aEEvoJUlWU0Xzi9LQ7Ce9Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758846572; c=relaxed/simple;
	bh=Bb9XHeMlSIhgxocJi7zMkwUhCzQElY81IHbj2qnvjQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VznpwLl3HLccSwceZftaQDpsdtQy5jS6v4I+ea6V65Ntb5zojXVb2PHIxO2iJenlyIIgpeNXF4gjyZ5XMhc8j+qp/OmMnSBWUkv2Va3emGfHrvVa7g4qsq9LXDricbtraGknjNkOM/IoCaUgplaXxh+otUFLV2JRxPIvxcAHtd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CXobwTje; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CXobwTje"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-780f6632e64so877105b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 17:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758846570; x=1759451370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UcpVeAYougECMqYDjv+WTibeO0LuSWTiGkan9JcZFA0=;
        b=CXobwTje4Nh3A3GHc56icn4lMotNIQDzp1vesdjfYBO+BCp1Yxo2urrSbdo0Ks35/h
         //9EE0DqZSfwptrgRCPgHZ+zrVcYdAbCGzA4A+PoZ8PcE9E4DxkGTIyRo1pRj5oeZr1C
         dVAhtBo16W6umn5ZaVxBgR39ZxE3ZLYHtw/8hDYT7nUfrmYz64DBPt8qTKrN1O4E7EZ6
         lvsArN8EfyYA1YeCFNplS/gSFTsNQdn0BV0JYJnHUHno0R8Kt82Y6zbvNZY/7FfzzHQX
         KNZtHbuIMVSf1eHxptdlXocSus8SJYtiTHTHCBv0SbbKk+PxI/aZMITnSNRR4LSD+iN9
         tD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758846570; x=1759451370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UcpVeAYougECMqYDjv+WTibeO0LuSWTiGkan9JcZFA0=;
        b=egXulWg+KWYsiKil22+8mVG60s78DIPBERIzpgWUKQXNxCvBu4MpPJ3CISobseNHDR
         i2q1x9t44dEcRm9ol2BJ68ZTU+WP/270GsxTx2bDwVBmHXPPiByQWGHqy4UrUuL9pDJu
         tDMmOdJsHX46125nnNHjl1HFFE1LR8joY6+cBD1jCcI816Ex6I0P1CmIK11I6RLDDedc
         RnYmJZs+DTlDvbcIP0q9Eb3gXYCz4FnwWNpSzps9nrmI8zUzbx48WNZWIB1rNcFX1Kri
         m/ZAho+nnQY+o3T6jlD8tZr4EY0wqGxWmEnEHA245ntvDjA7QbJ4HobauG3qR/dOIZiR
         OgSA==
X-Forwarded-Encrypted: i=1; AJvYcCVEnMgwd/JAsr2qpp+G0xATGgXT2KsdFTyBtfw04mtwK3iji77gREiYxUsY++N8yga7Dd1pMM8Vhls=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8uvQNCBa9Mtdbg2XMHZ5JFG6qOVkRVKub73h+oreWI2jdxpuY
	7jA+VnsCIuRHdeU/PRPhvdC8O7Xx/z1KyxIA6k4OJduuQx1bQyK0dmHg
X-Gm-Gg: ASbGncsE2XvTMpl9dqpS+nE7QqwJUk8MbPAoqsfAJ/p+Uf/+c97MMydR9PHitsu+gvZ
	LAGUMZ6Z6y2NmeQl30k+YayL4BIOwNJL+XZdr1Mvyb/PRKBgDIbRuLcq5frPj55a0S5J4Y4Zymk
	YoC1zqF1MAQPk6XkYZ8BFUVgHJoYtzBvdr/172uYBcY3H1HW/X9KtMJorZikNyPpBZLgpUrAILf
	lIP5HSOgMdniXdYBliObK9nx7gYIjZ8PHzzDboQOQEji+CYtHe1rsL8yNKrLvjXixdR5glpxf8d
	19BQOhJKk+ue3jPUleeXslMsMOgMEqeUGD12AgWo9AlU6QtYmXPl5V3pJG5In+JHWlkTFLFSnVM
	FAADinTcvWPgSWQi5roFRYLIuONLe34C2RcCpsUKAJh+/Yf5YZw==
X-Google-Smtp-Source: AGHT+IE91xeIbJoMIgNgyO/VNwoiIUYpZQSjScYdCH6vsO7wqyXKLToHX1mNo7t9dJIby0AcE/ZZqg==
X-Received: by 2002:a05:6a20:5604:b0:2f2:f7d6:4803 with SMTP id adf61e73a8af0-2f2f7d648a4mr1387026637.16.1758846569813;
        Thu, 25 Sep 2025 17:29:29 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:7e::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3343621d2e3sm1807110a91.5.2025.09.25.17.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 17:29:29 -0700 (PDT)
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
Subject: [PATCH v5 03/14] iomap: store read/readahead bio generically
Date: Thu, 25 Sep 2025 17:25:58 -0700
Message-ID: <20250926002609.1302233-4-joannelkoong@gmail.com>
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

Store the iomap_readpage_ctx bio generically as a "void *read_ctx".
This makes the read/readahead interface more generic, which allows it to
be used by filesystems that may not be block-based and may not have
CONFIG_BLOCK set.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index f8b985bb5a6b..b06b532033ad 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -363,13 +363,13 @@ static void iomap_read_end_io(struct bio *bio)
 struct iomap_readpage_ctx {
 	struct folio		*cur_folio;
 	bool			cur_folio_in_bio;
-	struct bio		*bio;
+	void			*read_ctx;
 	struct readahead_control *rac;
 };
 
 static void iomap_bio_submit_read(struct iomap_readpage_ctx *ctx)
 {
-	struct bio *bio = ctx->bio;
+	struct bio *bio = ctx->read_ctx;
 
 	if (bio)
 		submit_bio(bio);
@@ -384,6 +384,7 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 	size_t poff = offset_in_folio(folio, pos);
 	loff_t length = iomap_length(iter);
 	sector_t sector;
+	struct bio *bio = ctx->read_ctx;
 
 	ctx->cur_folio_in_bio = true;
 	if (ifs) {
@@ -393,9 +394,8 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 	}
 
 	sector = iomap_sector(iomap, pos);
-	if (!ctx->bio ||
-	    bio_end_sector(ctx->bio) != sector ||
-	    !bio_add_folio(ctx->bio, folio, plen, poff)) {
+	if (!bio || bio_end_sector(bio) != sector ||
+	    !bio_add_folio(bio, folio, plen, poff)) {
 		gfp_t gfp = mapping_gfp_constraint(folio->mapping, GFP_KERNEL);
 		gfp_t orig_gfp = gfp;
 		unsigned int nr_vecs = DIV_ROUND_UP(length, PAGE_SIZE);
@@ -404,22 +404,21 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 
 		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
-		ctx->bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs),
-				     REQ_OP_READ, gfp);
+		bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs), REQ_OP_READ,
+				     gfp);
 		/*
 		 * If the bio_alloc fails, try it again for a single page to
 		 * avoid having to deal with partial page reads.  This emulates
 		 * what do_mpage_read_folio does.
 		 */
-		if (!ctx->bio) {
-			ctx->bio = bio_alloc(iomap->bdev, 1, REQ_OP_READ,
-					     orig_gfp);
-		}
+		if (!bio)
+			bio = bio_alloc(iomap->bdev, 1, REQ_OP_READ, orig_gfp);
 		if (ctx->rac)
-			ctx->bio->bi_opf |= REQ_RAHEAD;
-		ctx->bio->bi_iter.bi_sector = sector;
-		ctx->bio->bi_end_io = iomap_read_end_io;
-		bio_add_folio_nofail(ctx->bio, folio, plen, poff);
+			bio->bi_opf |= REQ_RAHEAD;
+		bio->bi_iter.bi_sector = sector;
+		bio->bi_end_io = iomap_read_end_io;
+		bio_add_folio_nofail(bio, folio, plen, poff);
+		ctx->read_ctx = bio;
 	}
 }
 
-- 
2.47.3

