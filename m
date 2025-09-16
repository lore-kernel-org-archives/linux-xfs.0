Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E8A223710
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 23:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758066632; cv=none; b=lbtSMMoQOwDVMMMM3G1noyouKFOE9MEzFXRHHcaT9PsiGF6NlWDhjYfIIcQ6wJq1e0rs6LFgwwUXICo1cYvU55qR0bOHI85BsEGeGttAngt3SUxz57+ct7WB9nGRAQtaud04MzGtSdDRtk0S0uzNljG/BKi6K0zzCEJ8D1lrod4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758066632; c=relaxed/simple;
	bh=oQMvt3x5Q2N+uSt74k4pmpTEp6W00XYhfBugSskMdWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2ai9T0KtAx9KhwWzD9yn4/D/TkGW/moTxiLDFhL9CFMFO2arcaGRxC1JxDwWNsyF/wn112PdrXtUzciLZ9OoU5BTy2nzRcBH98vU3KjofjSSTiyeKw5pH3q0dSs6PKCZP7oZMJpBAR4yilGrfXM3f39GyfvYXfRQ9/HcndVMs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ibE84cvN; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ibE84cvN"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b54a588ad96so289810a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066630; x=1758671430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Ad09+MQKPROP4xJOPPVDT/APdYePwOoTN3n11YylRQ=;
        b=ibE84cvNHpHe2yOPUS1s1jKOO+ztjpBHw/t3qKGb2i1FzRB1waAMhUFT1SggEHkxf4
         EKWJl7/5ye/RqcSI14hRRqYW4cG2Xgr7OtkEa17eOCyzfRR7PczlbmRdCP1juLsJSJzJ
         5ubYiHkijurimBzyN2CDTVgehM1UgE9YeglNwC3VeqAzHceAPkQ/PWi6BRIGSbK+3zPj
         PzJIF4ld81KLW5UzcugTztVyRwsidwkABVfxXKlY+33fNfiZAeTiMZ+H+HXh62SXm8IY
         jGxLLF3/tCjs7dtgkZfAx/dufr3wJ2DUKw66JZRaFUu2BU2XTbIIEfNQlgwYrxnEBp7C
         Haew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066630; x=1758671430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Ad09+MQKPROP4xJOPPVDT/APdYePwOoTN3n11YylRQ=;
        b=aNkht/BYsfWeXpOj4fL1obsOEtFzb/EmTuWqioeizFDGAM0GEqEeyTBWDPZnW7NGlk
         5ivMAmkGm2wqe6a3S3FN5FikVaao8CG0kQjlf3HM5gTwGSx+rWDIU+etnZCekBZmWbKZ
         vuVixa+71vsQgvVTJympm6wUZ3+Zah7I/T5Jc+OfQTD1hVTP69xY0Q7vs1gkVdqzrqqH
         sRC22VcwMQacWCqe9K03EDBzm7iWSoNMF2P+VcshQJdrskegUB6qdb2WBKLxUtj7pj7s
         2SX3SPKvx7mVU1xxQovkMfc6UfCMN4ZRANe/4a2Q7Fof2x+aIbUfF/ftiXUlIvygCD87
         sCtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWk1iR1bgz8QSzrAhKk+DRzx8Yh1QOqndvMBbyixfB6dKx4ZJdgVY9bVqteGk6D2se9ja7Px4rbvpA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrZl68P5OFD2RJLZB8J9spWU6gQYTwoNrjlFi5ts9ABGASHJ/M
	57hTi+sKzmFP15FUuUsHST7hNPElbjix1XscCz4vFcTXfq9+CTylpgnl
X-Gm-Gg: ASbGnct/sNs5tWagvGXchqvY6HisfHamUgBFO2nVJqUqOQgO+RKIcLcsxCXCXioF0iW
	cxjNSMCb6SQpxzrngQ85Sa7bxibT/gr0ERB7utiflg6qG1S9RPt0ONPpP/x7Ct4tUG2hAlqGCn4
	UjwF6ctF+trPJWrLogQG//RagDTPOWzPrkHd4vhGEaznpl7YXyBfijM4XmGC41TY/yP1uFPthck
	+VyFPYrd75rmS3iPrBCtzSu/b0j3VagqYb9TUsMNmENOU8sjs8puQJ+13W3DD2FuoOb+Kk/tHg/
	+emropufcaRqAZxwA6SmTIZXTXIkI+ZlVMIcypN4E9MfHpYAzJG3Tqds0iBT/sHtCEpxR4QtCnJ
	N/X4vRIeJXAIQasq9J+SyypzTEwDcStk4N10CKG5uUy2Ex2tt
X-Google-Smtp-Source: AGHT+IEBXsoPFEqPmLi3eim0ez8AD7ra+R5wqscn78wj7CppFc2BDvERHIUoydzeJ3XEBjfYKljMBg==
X-Received: by 2002:a05:6a20:3ca6:b0:261:ed47:c9b5 with SMTP id adf61e73a8af0-266e5bf9c68mr6068804637.13.1758066630224;
        Tue, 16 Sep 2025 16:50:30 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a398aa76sm15413902a12.44.2025.09.16.16.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 16:50:29 -0700 (PDT)
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
Subject: [PATCH v3 02/15] iomap: move read/readahead bio submission logic into helper function
Date: Tue, 16 Sep 2025 16:44:12 -0700
Message-ID: <20250916234425.1274735-3-joannelkoong@gmail.com>
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

Move the read/readahead bio submission logic into a separate helper.
This is needed to make iomap read/readahead more generically usable,
especially for filesystems that do not require CONFIG_BLOCK.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/buffered-io.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 05399aaa1361..ee96558b6d99 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -357,6 +357,14 @@ struct iomap_readpage_ctx {
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
@@ -382,8 +390,7 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 		gfp_t orig_gfp = gfp;
 		unsigned int nr_vecs = DIV_ROUND_UP(length, PAGE_SIZE);
 
-		if (ctx->bio)
-			submit_bio(ctx->bio);
+		iomap_bio_submit_read(ctx);
 
 		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
@@ -478,13 +485,10 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
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
@@ -550,12 +554,10 @@ void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
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

