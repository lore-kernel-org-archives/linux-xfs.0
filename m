Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D341C9DCB
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 23:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731368937; cv=none; b=NYZIhxmzmTXVULgHCF9k/dVdZuczMi9b4eevZCCsA9dbPHZChbYMdJg9ykLD6KSRPIqAKNqaG/sscn5U1LK2YGGd3ArJtMBHF3tRSho8IhXvbT+GRGEkBQ8XEA/x+VA31hV+1OHA0gf6riH2Dqq0gfUns7yM7UbdBY2xBqwjGZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731368937; c=relaxed/simple;
	bh=HNesIF4+NCKJRgMS8RJOzPdBmK2CQSC6p10zaqTN28c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+aJ7HPoXdK82HK8SIZh+A1tpSXE02cXZfBv2acWyWCUKia6E9fRiGpUMc6QObcHlitALcehnKp1fkVFOShh54JCeUZRDV6Lo8J+Xvkx9vJ8MXR52QvEmoQcNBSfIyCtbd+l14MbZG5b2KIA+84quCDHgeC76VL09WDBTC8wlCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OF0WUr0e; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OF0WUr0e"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-723db2798caso5111463b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 15:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731368935; x=1731973735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=573A7VIJaN7Phef7EPro6/84rHuXaF2Ar2GUBUbETSc=;
        b=OF0WUr0e79AhMimpy85I61HjDhF5jReL4TeivNjN63K7r49rrhSv7C6PCMZY9s0O3m
         sLe8wGHHnzUhI7aCOzrlNV/u7656/fPSZM9IXjsZu386cjzZppTSuX3jZxFFhcNeBequ
         IOforrBU/9NM2a6r8qfZeumikX1uIs0sRNcxiBBcn5X8g6QJJlCMCMx+yr8oj9MBmg1s
         8JkNJHdepngU/Kl7g4gqt60K2PlqJua1d01OgSKE1APkdCy6rjaKAnM9PW60BL83fFS3
         7XD9h1iDmcXobE4n0Xy4+P85IofXytwjL5Vcg1VRFIwp2MQf0WjHLASbw50JezW06b2T
         BGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731368935; x=1731973735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=573A7VIJaN7Phef7EPro6/84rHuXaF2Ar2GUBUbETSc=;
        b=vpxU6gvQADjlLjCbz6J1DairSbOISY1KZ/b8dcvNRiZGR7hSL7NpbHU89cyM5YLoMD
         5LpmZwutAXxRR1udlVcFmDtxUXKYTmDJws0ljtRdHbVZISkwhdcsHsfZQHyCIzMKN1Jz
         WoscRqtAXZXnPsYnIiWZjrmAc1lg1CFTifa6r2bwCQKkSkumLC1qwWq0mf1WX5+3Rxqm
         aJGJiqsOLLfz9n69hiQt6haSRQ7eyfu5LOwBgm1J0yNGMPCNQU+rAHy+HGKKcWNcOpO5
         fNF05bRS+UZGCoyo3K6sPwaLhwgv5kx/vm877tS/ZNIixFELE/95YRX4unXWHFnoZczI
         JPcg==
X-Forwarded-Encrypted: i=1; AJvYcCVATUpuhTBe1lGz659v4tW9QHIOW4w2Gc41TImAGFi6r4V0m3e9JrCobnNE3WfuXJkYRXtKSMsg0Cg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRSA4mZxRrpwVjlk/Pf+/OE+6IARXsLJyracmtA7VPEZIlYSlD
	KU5yVDR7sI74NuyK9VUklwvAbimZhym+xzwPZQqTxTeSdyIFL0zRgGwkw73wZiI=
X-Google-Smtp-Source: AGHT+IFFv9yEg9ETjAil4BLRBKswDm5bw1d1rwvQrtFRdIgpywcgln1Dsm8EO2zN3a/ZuXT+tu0A8A==
X-Received: by 2002:a05:6a00:460e:b0:71e:75c0:2545 with SMTP id d2e1a72fcca58-7244a5d480fmr1035562b3a.25.1731368934821;
        Mon, 11 Nov 2024 15:48:54 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724078a7ee9sm10046057b3a.64.2024.11.11.15.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 15:48:54 -0800 (PST)
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
Subject: [PATCH 05/16] mm/filemap: use page_cache_sync_ra() to kick off read-ahead
Date: Mon, 11 Nov 2024 16:37:32 -0700
Message-ID: <20241111234842.2024180-6-axboe@kernel.dk>
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

Rather than use the page_cache_sync_readahead() helper, define our own
ractl and use page_cache_sync_ra() directly. In preparation for needing
to modify ractl inside filemap_get_pages().

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 mm/filemap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 91974308e9bf..02d9cb585195 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2528,7 +2528,6 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
 {
 	struct file *filp = iocb->ki_filp;
 	struct address_space *mapping = filp->f_mapping;
-	struct file_ra_state *ra = &filp->f_ra;
 	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
 	pgoff_t last_index;
 	struct folio *folio;
@@ -2543,12 +2542,13 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
 
 	filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
 	if (!folio_batch_count(fbatch)) {
+		DEFINE_READAHEAD(ractl, filp, &filp->f_ra, mapping, index);
+
 		if (iocb->ki_flags & IOCB_NOIO)
 			return -EAGAIN;
 		if (iocb->ki_flags & IOCB_NOWAIT)
 			flags = memalloc_noio_save();
-		page_cache_sync_readahead(mapping, ra, filp, index,
-				last_index - index);
+		page_cache_sync_ra(&ractl, last_index - index);
 		if (iocb->ki_flags & IOCB_NOWAIT)
 			memalloc_noio_restore(flags);
 		filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
-- 
2.45.2

