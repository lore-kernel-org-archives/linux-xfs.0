Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA731DE8B5
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 00:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758587642; cv=none; b=o+1tlSGs1ZOyvHP0VNgz/wekRwOhdj8OqouxO9nrnyR2mzb9F628vH2JpjVJ0okEyNhx8zjCTCd/2q4XSlzuKmKa7Z18jtFumDVX4/zGoCIWzUrhZ1w3rjxdU7oRSGvjhw5ormoBWaK7j624bn+BBLTbj9A0kcUheMcXdMdbzZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758587642; c=relaxed/simple;
	bh=a/zyIEvLQc/XUbs4Regz+PNxwhBjl1k4o/jZih5gfXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOy1fKrXfLEEfuIJ1zs6twaGq60Lccpu9Lr4o3rA2gOVRNjqKT+KgcX7JmXwZ6HyVRcaDZBy0S7/SZLPNSnS6tYABDLuFk8eGROrSUjCAEfWMlS4F2H77xpb7+Wheu7GRxgm4KkmvPcHsGEOQ+cB4hn0/aPz+3q3ETd8aGielFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FXhkpGQL; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FXhkpGQL"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2445806e03cso64246395ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 17:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758587638; x=1759192438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gt8zIXCwfRruji0SsRLpuIon4IqvB5IR8pbhHdgxKmc=;
        b=FXhkpGQL/gTgFwPNnUREcfYZCX98ZU4B5pvjzfspzeKJjPRi5wEBrLufkZ8GGkDC1b
         IWPSwuF6ts5wTUYZZ0uF/U3wnn831Ub9BuobGeiTYduIDCzoNLgsz0hnQRQ/gynJmm7X
         Sf/7q65mOmKhWOb08nabUs72CrYfQl4GuQV33CEMHZhZqWojZR9IUQPU3Z0JBiO9hPmY
         yDxpIXlYthNOUO4gNxE0WChEBP/wyC0IVfUD1cARmdYnn/Q1lfG1v8DqCMriLl+f4i6r
         59xE/3NTb2fZQHpoF2Suj440KEqZQtHdr1qapR/T6inl5mJPkceM+821tr3Q17JlEUAF
         ajBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758587638; x=1759192438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gt8zIXCwfRruji0SsRLpuIon4IqvB5IR8pbhHdgxKmc=;
        b=NEGapbR2c/dYtbukIdTENFskC+KSKpcUgqf/X4ddkNhmoBfyWbNvWbdd6OHpDgB1R6
         WutWwegR/HrANIx6Ofxxygy1Oi+NjqB4myRTEm0Z1L4wUohpKlqEBnsSWQDqBu4nrBPh
         0eYtXZcmHfIb1r2Z5iwCCzxI/qhWNEM8gsZKgn8ByLR1kC4a9+VP1I2Rxq+oaUsW6aTW
         v6G9o/8c/r5ff64kVKe+3kQYl50wW2tM9GowtrOXEFBask7Wi06RIYs7zAldwTBYMXl3
         3lhz3UNHqqTJoJt2y3dbV85cv8IJDlKvdn+1tn+O/8bofkqnMrpUhmFpYF+9E9bj1+1H
         7Z7w==
X-Forwarded-Encrypted: i=1; AJvYcCWg11R2McSGTfb7NHIXl0+ME4toEyQBoZ+gSfcAm0v8VeJTa0QHEXTmtyLlrPnoJBWD5He41hCYSyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCftOGOR4Qfs/iy0dGlZXD2ZMz2pXl5rldoyO3200nD1H2YYXO
	qiUjuMvtoJ+GcRyeiYECad2kwwsOIAHwVyERcVm6tqyC/pKPf4MK3ffvwFZOEw==
X-Gm-Gg: ASbGnctN+WMpUabXf8n61tmwAZ9EgRKm6n13DQtbO9ttcyZB1pF+2EzNwp+4WhEf/Xe
	BwaTqoRurSqZKKD+WAYUZC1JnKbv3M5LkhzePtOnsLzsVPwGDXwkaU+Vy3zvFySQTQwAQ38jvZI
	EPsn1YRPOtbCGqoMqzORwtfBel7cbVdM3SdTcNqyZmVoZOdvy4yOUzvmnKS46SpHv5NOLkYc1bY
	7NPzbv/OGtPA4si3be7Q0wkmNMC7ep9YvNnjhHmsMUzpnoLpZTmO0J02T9kqp7yuj5cIUCtG6lE
	kN0vadFiZstudE/jTEAEWP8gU8Cx2ug/UIEIK4s6mYZEu4H4LIXWKWmIiBpENZd8yUqoJ/YNjgu
	EFAU91PtWTvbIwJAvAAMdPyJxUBv6N1LiZ7JnKifyLCDbBnlf1g==
X-Google-Smtp-Source: AGHT+IGQISl64Y5Qz4l069Hr+dg6JwXOBP5WOcZIs2GDXy1YtKD9sDPga2/FeznyhaigCtWuIUSimw==
X-Received: by 2002:a17:903:46c4:b0:267:cd93:cba9 with SMTP id d9443c01a7336-27cc696e79cmr8418715ad.35.1758587638366;
        Mon, 22 Sep 2025 17:33:58 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:49::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26980053dd5sm145263185ad.26.2025.09.22.17.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 17:33:58 -0700 (PDT)
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
	kernel-team@meta.com,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 04/15] iomap: iterate over folio mapping in iomap_readpage_iter()
Date: Mon, 22 Sep 2025 17:23:42 -0700
Message-ID: <20250923002353.2961514-5-joannelkoong@gmail.com>
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

