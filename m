Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4111922DD
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 00:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758587644; cv=none; b=kOg9Ps42nkIWemYMIhtLZoEkR4EI7EVBIzy0Oja7W6C+h+6MrIMF51f2l3++z9O2Uky9WD4FuhCXMvyrZnDFIRbbrF3n98jxqF3vw5/Vni2+Ndx4Avvr0B4EE5t/1pozbFKzl2XL7FetHUToS3tYlcr7LoNUdv2hTJyEGN5Vc40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758587644; c=relaxed/simple;
	bh=EYt7dCnbv1WdNsWBo8OON9ZEzcHLtnoEPgeM+z1gNyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuuYrUvxaxNsXqWjO65ZIZXiBUPrpNBwz0d0JvtNp2vy6g3ZSMKT9ByGuxZlCbOVm5FiPMpHUx9TirbY1elWF62bBcnBNZe7WBe03sELCPPPekrj7xeHCOYvTHwQXtbhRCDR7w0AEHkN05ck+9Y6Q/3wwqsPJ2F27f+/miii44c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z3rIMnxy; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3rIMnxy"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24457f581aeso49776215ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 17:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758587642; x=1759192442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U11mrEsklOyGoG+ah0Y0223e+PC7aMyCc8N4lhMP5fo=;
        b=Z3rIMnxya4iKX7Z+/h712th52teXNlvdERcFMuhf9pMoO7NjLoWuBY1VhuhRG+6Kwj
         HU+FB4Vpdbs25kscDmaawZjP5UV9arx3qFIOhekZ9X/Xu06Kol8GsHW8sA9F/jB+mnXa
         YUOz9VvEqfXDSLeWJ3EyUQqptSGYfXG9pKVJDyrqPKJAl/EiQtZJv3OiYujaBhJREqhG
         Tgslf4NQ0BqoDdOu7bsEzGQpqiALpoSxHeH7EcKUkxZnNuEClE2z1zbUHn9gD2eX52k8
         xJDcr3iYv+D9vng/ynW49l2a1HwCqz0de/yAd53ORa2dwez86NXqY6okNi74ZCbV2OKa
         JDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758587642; x=1759192442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U11mrEsklOyGoG+ah0Y0223e+PC7aMyCc8N4lhMP5fo=;
        b=tjAf54ip6ZiGAL8TfB8lOqrB4Vh6+cMK3L9UKdhNAiWk03T1pl3kjwzPfWysWLsjlN
         Ht0axvatf4DCEqWVGOJkoKek8Fe/YYtEql11lqoLOWflq+UMwr7ojSGFe+xLo6mh0MYp
         4m8eqTIT04pY0si9gg8gZi7GJuAMkp1BDbjNXnr8qegLYv497be9SiFByb+M9Tzgp6O3
         ZWpLMjIVb3mDAfKssCSJQbySPeFiaw93V1Nd8S7D3JHHE9UiAySw/n1A8RSPyPQZy5IQ
         HFbc8Tn51arev+Ehf4II9rKr/mNGj5bpiZ/zh6B6WYUf5sxIoYLG0cJJhaBApogDno27
         PUcw==
X-Forwarded-Encrypted: i=1; AJvYcCUL+hGf+e+XQyiYpRGGuSLz6PLfp5AxXFmNQUTis6vWGG2IEBFnJ9XCSjbyS8HntN2EytvEgqI0Zqk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx7d+ZiH9gKfCirOFc0ylAbD5Ss8z9dYxbStgtwqc99XX7jcJM
	voMhkG9lzKnfLOEGeRRldV6++tx1O+RXbpfbxVqKYxUu8DKRLKT+iL+D
X-Gm-Gg: ASbGnctVHA4m5h6MMcsfIojKHsxbxRkrIZh5MBgF8xEdiBFTxOZvLV9OmGFK/ixkRJ3
	aQxniZm2kJoxn3aP60D+dDn4bwddxk3A9kUeuyGlNmJqz2Z2o2hXbijc5I0I1juqOCDAK71bwtt
	3KbG8QVeWuTX3S6uSdhBt9FOOV/BcXc3xQUXCECyCRWeadokdZqZlgvNd6sGdTzhCO660KgRBkE
	M4BtcvGgSNmPW8zrT/39+4LtHFxGVdcJ16Gmtd89eEymOB0FPawAVMuYL9sbZU8PgDpLlUrJ6PK
	qThHZ1eLJ/tuvZWh1rq/mzEv2RKYBlY1SqWlHznop8GFV7d+Qcpbjk8PAVRIwLAxe6APjYsHA1+
	+VPiOCq4sjTDLj+ujmghw3+hSDTRGG8qjELLBH4Yz7laESIyWCl3l/jGFno0=
X-Google-Smtp-Source: AGHT+IGMA0cPE2R/eep3lFhZE4wE7iE8qhOhR6c724oiDvW6uLYQwIWJa0jSbnPosxnhtfnxB7mH6g==
X-Received: by 2002:a17:903:1904:b0:27a:6c30:49c with SMTP id d9443c01a7336-27cc2d8f60fmr7678505ad.27.1758587642453;
        Mon, 22 Sep 2025 17:34:02 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2698016c076sm145590885ad.42.2025.09.22.17.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 17:34:02 -0700 (PDT)
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
Subject: [PATCH v4 07/15] iomap: track read/readahead folio ownership internally
Date: Mon, 22 Sep 2025 17:23:45 -0700
Message-ID: <20250923002353.2961514-8-joannelkoong@gmail.com>
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

The purpose of "struct iomap_read_folio_ctx->cur_folio_in_bio" is to
track folio ownership to know who is responsible for unlocking it.
Rename "cur_folio_in_bio" to "cur_folio_owned" to better reflect this
purpose and so that this can be generically used later on by filesystems
that are not block-based.

Since "struct iomap_read_folio_ctx" will be made a public interface
later on when read/readahead takes in caller-provided callbacks, track
the folio ownership state internally instead of exposing it in "struct
iomap_read_folio_ctx" to make the interface simpler for end users.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/buffered-io.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 09e65771a947..34df1cddf65c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -362,7 +362,6 @@ static void iomap_read_end_io(struct bio *bio)
 
 struct iomap_read_folio_ctx {
 	struct folio		*cur_folio;
-	bool			cur_folio_in_bio;
 	void			*read_ctx;
 	struct readahead_control *rac;
 };
@@ -386,7 +385,6 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 	sector_t sector;
 	struct bio *bio = ctx->read_ctx;
 
-	ctx->cur_folio_in_bio = true;
 	if (ifs) {
 		spin_lock_irq(&ifs->state_lock);
 		ifs->read_bytes_pending += plen;
@@ -423,7 +421,7 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 }
 
 static int iomap_read_folio_iter(struct iomap_iter *iter,
-		struct iomap_read_folio_ctx *ctx)
+		struct iomap_read_folio_ctx *ctx, bool *folio_owned)
 {
 	const struct iomap *iomap = &iter->iomap;
 	loff_t pos = iter->pos;
@@ -460,6 +458,7 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
 			folio_zero_range(folio, poff, plen);
 			iomap_set_range_uptodate(folio, poff, plen);
 		} else {
+			*folio_owned = true;
 			iomap_bio_read_folio_range(iter, ctx, pos, plen);
 		}
 
@@ -482,16 +481,22 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 	struct iomap_read_folio_ctx ctx = {
 		.cur_folio	= folio,
 	};
+	/*
+	 * If an IO helper takes ownership of the folio, it is responsible for
+	 * unlocking it when the read completes.
+	 */
+	bool folio_owned = false;
 	int ret;
 
 	trace_iomap_readpage(iter.inode, 1);
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.status = iomap_read_folio_iter(&iter, &ctx);
+		iter.status = iomap_read_folio_iter(&iter, &ctx,
+				&folio_owned);
 
 	iomap_bio_submit_read(&ctx);
 
-	if (!ctx.cur_folio_in_bio)
+	if (!folio_owned)
 		folio_unlock(folio);
 
 	/*
@@ -504,14 +509,15 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 EXPORT_SYMBOL_GPL(iomap_read_folio);
 
 static int iomap_readahead_iter(struct iomap_iter *iter,
-		struct iomap_read_folio_ctx *ctx)
+		struct iomap_read_folio_ctx *ctx,
+		bool *cur_folio_owned)
 {
 	int ret;
 
 	while (iomap_length(iter)) {
 		if (ctx->cur_folio &&
 		    offset_in_folio(ctx->cur_folio, iter->pos) == 0) {
-			if (!ctx->cur_folio_in_bio)
+			if (!*cur_folio_owned)
 				folio_unlock(ctx->cur_folio);
 			ctx->cur_folio = NULL;
 		}
@@ -519,9 +525,9 @@ static int iomap_readahead_iter(struct iomap_iter *iter,
 			ctx->cur_folio = readahead_folio(ctx->rac);
 			if (WARN_ON_ONCE(!ctx->cur_folio))
 				return -EINVAL;
-			ctx->cur_folio_in_bio = false;
+			*cur_folio_owned = false;
 		}
-		ret = iomap_read_folio_iter(iter, ctx);
+		ret = iomap_read_folio_iter(iter, ctx, cur_folio_owned);
 		if (ret)
 			return ret;
 	}
@@ -554,15 +560,21 @@ void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
 	struct iomap_read_folio_ctx ctx = {
 		.rac	= rac,
 	};
+	/*
+	 * If an IO helper takes ownership of the folio, it is responsible for
+	 * unlocking it when the read completes.
+	 */
+	bool cur_folio_owned = false;
 
 	trace_iomap_readahead(rac->mapping->host, readahead_count(rac));
 
 	while (iomap_iter(&iter, ops) > 0)
-		iter.status = iomap_readahead_iter(&iter, &ctx);
+		iter.status = iomap_readahead_iter(&iter, &ctx,
+					&cur_folio_owned);
 
 	iomap_bio_submit_read(&ctx);
 
-	if (ctx.cur_folio && !ctx.cur_folio_in_bio)
+	if (ctx.cur_folio && !cur_folio_owned)
 		folio_unlock(ctx.cur_folio);
 }
 EXPORT_SYMBOL_GPL(iomap_readahead);
-- 
2.47.3

