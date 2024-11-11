Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6F41CDA1E
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 23:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731368946; cv=none; b=JdUx1RuSQFto0px3LFqsVEaDG1BgFxdSblPO7dsYN9L3JKZbFgvH/x/Uccyxy5cSwuaXNaehfrOcLUNGTTtBJuchxT/IYO7yQTPIkEr/dvhqJiohT6p4kLIY5bhhNnDC6cFgT5aiyuNpoKIw0PWojggSv8pJO7xhIbAMMeY3kuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731368946; c=relaxed/simple;
	bh=g/haD3K2EU2Y4QS833/TY88VMz3RgG7lve6et2tjW0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/GUv0OJYonUG4Q0KqHZaQpFAqtWAU6S6uxMd2yfZumXjUxAmEiP7PGUNb5JQy8Bv5oWOqpDeAoCvRZja5RUC6G+jk6nAv1ZtIQQvFiXggyQiGi/oHwN5bKJ7rAzT7EcvBdhOr9d9zauXgg/Cqhtg7XlPUHd75KZTL0oRqQHeI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DiY4ayqz; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DiY4ayqz"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-720be27db27so4124198b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 15:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731368945; x=1731973745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MuWHSESvZxScxt1gtQJTtWY+NoQXodLd0kknM0wzZSI=;
        b=DiY4ayqzzDxIFKJRkM05e6VspCONzC/qGzPdoWEEbQfWMJMgiLpMZD3swUijZxqMAE
         IUWhkquDG2fMenZuNEbnc5+vNuxgqeD4jnb8WMIJtxWgzd5gfYmZs16g1lV4iKVXWrpJ
         KvWLo+QQRV7Bf55axkLLjyJ5MyS5bRNb8h0WxNG2r63B8ejocaaSTK8oaxTb94Js+u04
         umkCd6PEWkI58RYrfgXO4Bbhobj3XCjIsF2c2KhLiRRh0yz6bxaZ6CzevDMTKKsIggxg
         6qYDUIv4aM/5tjGXcexy4XjGVEpG7mlil7fwaF8d89jGv+3Xmy1l3Cmjf4lYJnthgzQ2
         6TrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731368945; x=1731973745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MuWHSESvZxScxt1gtQJTtWY+NoQXodLd0kknM0wzZSI=;
        b=B761KojbVUF4myg3SLEC3xGSSUIiNMR22y4V8mPmBDEoXC7rummi8KyIiH2DJa/mfn
         yd55JiY+tCuuKz8GPvEQIGV1Gp/ZSzzvVB2lp+XLMUs9+asv63NxADFbL0DdNLqn+MpI
         Dk96y2BjeiK0H/WkfPCopr549hlT4cT1yQeWRb0zgXkCnSMA0Kbud54sgf5oukM/64KY
         XI6r1is6nYLGWhYUQSo7cyjr5Zz+CJyk7oxYI+1wS3cyWIRWk+HSsy4LtRF6NGMxT/GX
         2i12AmwSniWyDk0yg0HTfGhasZ79WnthF1GTsYbYoLk81DJNDWNl/gPkJ5Zo8JIVmOtV
         Y80A==
X-Forwarded-Encrypted: i=1; AJvYcCXIt3ShLnjwcfxuMcbcLmWlFcL5gJPd/nLXb0MRTt2xjMm50VWir0Y5lzotRPduLRtoUsGS/wjtV4o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0pr6WKMF6q/GjYJzMYJD9lAh8j0CpI/pEXnXlNMfnx75wqROg
	LDLodzZTMsX7mIJqSidHjj26pESoaD12lBmFJhnbqdBG/g1jbS6nb277Pey2+Zw=
X-Google-Smtp-Source: AGHT+IGY8U2EPa5TOjOCgJt8zYCC4on7T5T+FZCdrixkNsVQpkNRkQsZMbpHQUFVB4Pf9fNlDncpCQ==
X-Received: by 2002:a05:6a00:22d2:b0:71e:755c:6dad with SMTP id d2e1a72fcca58-7244a4fdea0mr1056066b3a.5.1731368944673;
        Mon, 11 Nov 2024 15:49:04 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724078a7ee9sm10046057b3a.64.2024.11.11.15.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 15:49:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: hannes@cmpxchg.org,
	clm@meta.com,
	linux-kernel@vger.kernel.org,
	willy@infradead.org,
	kirill@shutemov.name,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/16] mm: add FGP_UNCACHED folio creation flag
Date: Mon, 11 Nov 2024 16:37:38 -0700
Message-ID: <20241111234842.2024180-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241111234842.2024180-1-axboe@kernel.dk>
References: <20241111234842.2024180-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Callers can pass this in for uncached folio creation, in which case if
a folio is newly created it gets marked as uncached. If a folio exists
for this index and lookup succeeds, then it will not get marked as
uncached. If an !uncached lookup finds a cached folio, clear the flag.
For that case, there are competeting uncached and cached users of the
folio, and it should not get pruned.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/pagemap.h | 2 ++
 mm/filemap.c            | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index d35280744aa1..0b298e81fcae 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -741,6 +741,7 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  * * %FGP_NOFS - __GFP_FS will get cleared in gfp.
  * * %FGP_NOWAIT - Don't block on the folio lock.
  * * %FGP_STABLE - Wait for the folio to be stable (finished writeback)
+ * * %FGP_UNCACHED - Uncached buffered IO
  * * %FGP_WRITEBEGIN - The flags to use in a filesystem write_begin()
  *   implementation.
  */
@@ -754,6 +755,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_NOWAIT		((__force fgf_t)0x00000020)
 #define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
 #define FGP_STABLE		((__force fgf_t)0x00000080)
+#define FGP_UNCACHED		((__force fgf_t)0x00000100)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
diff --git a/mm/filemap.c b/mm/filemap.c
index 0d312de4e20c..0949f0f340f5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1985,6 +1985,8 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 			/* Init accessed so avoid atomic mark_page_accessed later */
 			if (fgp_flags & FGP_ACCESSED)
 				__folio_set_referenced(folio);
+			if (fgp_flags & FGP_UNCACHED)
+				__folio_set_uncached(folio);
 
 			err = filemap_add_folio(mapping, folio, index, gfp);
 			if (!err)
@@ -2007,6 +2009,9 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 
 	if (!folio)
 		return ERR_PTR(-ENOENT);
+	/* not an uncached lookup, clear uncached if set */
+	if (folio_test_uncached(folio) && !(fgp_flags & FGP_UNCACHED))
+		folio_clear_uncached(folio);
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio);
-- 
2.45.2

