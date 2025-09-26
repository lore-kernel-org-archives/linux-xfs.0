Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AAF824BD
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 00:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758846567; cv=none; b=AEyPjEGm4efOLfawZTsrFso+9nC7n4eTRx5izrteeHapB1Ltx+NWAk7XnVWRmpIlZbs1J5F8QLj1UGjqw/af1a1Jbm1m/HbYqhmLLbtv6NWRzhcbrJVTA9tuN0cZncgX473U/+bNZQA4AH5gwFrg1cL+QpvZ4IiUUWnlFgBnNbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758846567; c=relaxed/simple;
	bh=CSiGtKrWb8zqpNUe8yL7Pevqy9qFJhFmaY58ZJGrYSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC7h6HiqEcajR4oEL3YTuMsH/LThhk1RzDcTAzBiZM0TXgbrElBZo/0YVvvNzmJzi0q56RmbGFa88LQ8VNTknclGpofFQ+6cTuL1V1Dmf1G5QKP17ZZlvVOQK47edGGeC/FqkIrG3x4YYz6bFuMO4Z8vqeB/kJqBfZgSmT8Er/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B8S+lD3d; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B8S+lD3d"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b4f9d61e7deso1134190a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 17:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758846565; x=1759451365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L8Zc1MP+97msutqoeYloSdkN6RJEwl1bHJXdXkLR+a8=;
        b=B8S+lD3dhzSUP09O2UevSQy9dxglRsq0XlUBNrJyWk0RM0pteAxqO1UD0d2AEP+VaC
         e6QMlr5A/P+I/SOyJ8sqe/VCx26ZyWVD/SL2Nf6PJxEnxPjHGYzBQMjam8iACnsTuySJ
         hWomCj3ltBaXIPEmjy9IhOcFnokdwu5Ezhw1D21k5q3Iu5e4vhuDx51euf27pUIyPrrB
         XuYTfphRdGXR8uoV9JUbC9M/IFNiNTWjsGDm6LXLRx5qzN6ny25XxgkMGHuIgdmoX0JH
         cpe77a2KeacbEtglivcxOsN8OWGf4E+otT0Vg7uuuptPpEKUEAENvAkHMXUC4yqeeXOX
         CTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758846565; x=1759451365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L8Zc1MP+97msutqoeYloSdkN6RJEwl1bHJXdXkLR+a8=;
        b=TKcUvrsaxGBAA46HVCZgrmSwabMK04BBuXgJeSFTGmrvtcXjGTxglOzcCCa75rrXSm
         nNJRSvLjU7yXi41vKhB3fXswYD4/Wp2fej3+Hgispxrw0qbXNlhFxLmwIqv0Px4SaS8Y
         7OAM2NP8CDiqjXpL+kYyR9Vq4TAqv28LQOSdY7Eyom3Q1kTqwNAvJZVHQnlexPehLGOQ
         j6BKSf+pjz+g13bPpEGD8+vC/ASvwYIN0bUBfbSHS9ZytoBTtt3xcr5nfwc3UcfdBtTn
         0DucCMB1TeQQnIAxNaIZ0SsKTx9nBK6RankKul7lXihTnfoVL93NnT1UM9UqqN2p1wWF
         aD8A==
X-Forwarded-Encrypted: i=1; AJvYcCXYwXeCgpEDhOObQ+ou+JnaPou84IA8oIL1jgZpsLAYB+swBW1uH84tqb7cMdALujMAvuAqKbNycfI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZpFsFW1qmfQ1uP9OffZfqzbgXZHzHBtfkq4yNzT81BtBJ2Acp
	Afmv2+NP8wB6hSUjFjs38HuPOia9UlHTcpPV+oiYLIx6/DYm7z1R1cC6
X-Gm-Gg: ASbGncsmRpB0QXNRZBYZF9bROQ9Mm70CrEMh5qzBdUpizbMPnSOUZ7iFAg0Ja/97dP5
	dwGuIBk8f5tS9nSIe1KA/3+bzNhRUxeSg4pgelc8g2dCl30ijQuvcxiNEoGVwa6N1h3SZaAXtwZ
	6XEA1UzraCS22dBTurI/1LsLn+/pUFnLx3RNOSbb6Xih5qIY0dVmxMbU8sjrkiS857fsvmRBc08
	f+3vv9AyGtzKjvDxGa5zNbJGlotrub1HCqV67h4mnD/ukDwCUrdD98VFf/qNNDDyPFzFo7t7ZYA
	8OcgNqFgG1K08oEOIY0AvdzWnBsmoj+wJ1Sd5sak3KxpdSGzrNhlB2cxNLgLSetMQIXNB/Wa5OO
	MEfw0fNQ5qlR8w7fAooYZr27bWKxIqhdA7Lndo/vJobgUVLnL
X-Google-Smtp-Source: AGHT+IHNIEbxa6UAWQsKzdL61JfAyD30h+IPFl21tAc/+urvhLse02Zgh6O344jn51W+QYvc3zIEvQ==
X-Received: by 2002:a17:902:db06:b0:25c:46cd:1dc1 with SMTP id d9443c01a7336-27ed4a2d078mr55247085ad.33.1758846565475;
        Thu, 25 Sep 2025 17:29:25 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed671225fsm37637505ad.43.2025.09.25.17.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 17:29:25 -0700 (PDT)
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
Subject: [PATCH v5 01/14] iomap: move bio read logic into helper function
Date: Thu, 25 Sep 2025 17:25:56 -0700
Message-ID: <20250926002609.1302233-2-joannelkoong@gmail.com>
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

Move the iomap_readpage_iter() bio read logic into a separate helper
function, iomap_bio_read_folio_range(). This is needed to make iomap
read/readahead more generically usable, especially for filesystems that
do not require CONFIG_BLOCK.

Additionally rename buffered write's iomap_read_folio_range() function
to iomap_bio_read_folio_range_sync() to better describe its synchronous
behavior.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 68 ++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 9535733ed07a..7e65075b6345 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -367,36 +367,15 @@ struct iomap_readpage_ctx {
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
-		return iomap_iter_advance(iter, length);
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
@@ -435,6 +414,37 @@ static int iomap_readpage_iter(struct iomap_iter *iter,
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
+		return iomap_iter_advance(iter, length);
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
@@ -559,7 +569,7 @@ void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
 }
 EXPORT_SYMBOL_GPL(iomap_readahead);
 
-static int iomap_read_folio_range(const struct iomap_iter *iter,
+static int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
 		struct folio *folio, loff_t pos, size_t len)
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
@@ -572,7 +582,7 @@ static int iomap_read_folio_range(const struct iomap_iter *iter,
 	return submit_bio_wait(&bio);
 }
 #else
-static int iomap_read_folio_range(const struct iomap_iter *iter,
+static int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
 		struct folio *folio, loff_t pos, size_t len)
 {
 	WARN_ON_ONCE(1);
@@ -749,7 +759,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
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

