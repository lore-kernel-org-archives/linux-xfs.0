Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DF818784A
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 15:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731598090; cv=none; b=LxsAp4Guh6fHq2FlDhA8HdVI/1VgjhFrfWylUpoey0lCNcTgZ1HlnujFrOn5o/w7XWp4pe5WuMBokHkcb1ZuU0gkb7GcJhLgpRTEC4JwDy6+2ISFAxmIG6cZtc6ZCzTuSg2JRWCgH/oSLK0KAQtXN1aKBAJUXW5vGOCZvZw819E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731598090; c=relaxed/simple;
	bh=AFLrZl3fH+/hMhwZTjgZ0OWM0ndgzDi220n1zUDQffQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/HmA3rYuZKGzYFz3ND+oSN+N/J1MrYBPUxtbOx7ZmlGq9U6BbhTSRzWxJIazBOTOMEsh2ABn7KLJIrd1FsbDNZ39+4d90uZ0zhVAjz8a884h8A0XHqSv96xSGxNfTDxB1kYOJaoTHBRMWT5A1V4WKkpj0eOS8WEncd1yCv6d3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=arnRiepF; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="arnRiepF"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5ebc5b4190eso366715eaf.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 07:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731598087; x=1732202887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jvfAlDie45/dO/q2Oa4nMUlSYRbUQddnQckYeJvFoiA=;
        b=arnRiepFOtCGKagziS6xtO4Vv/Jf+8LAVE0J8ryI70wI6+zLwxYTiedTsJ537HC4a2
         LNlkH6zA2veKrY6gC1AV/soymGZv4dcjTFrRd401ey51Z2ZRNhbCWz1MrRG2VaHDZzZU
         CtXa6Q7kxE3rM7/IfGcF6ekYH/Sf/DSYhadei8uNuwK+yUUDnHirrUBAfcWJ607o30su
         d6FeQ+b3xv7erZkoT8Tz+ZkoIVPCu/Hde48Xczj9XrRav8FokUakSv8Xe5BFKkhjJUpF
         y0R/VAeybRFMVsO0vmqjYr9OX8GJ++AAgoqqGbbxdip/H442BYrrkZHwQK0MuurJgjD/
         r0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731598087; x=1732202887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jvfAlDie45/dO/q2Oa4nMUlSYRbUQddnQckYeJvFoiA=;
        b=xQAwQGaWR/L2nMnIVht1JQtDXrikdJDQR1KWVvhnH2SF+96RCWDAAdJrZAD6jWEK81
         HbsC38lzwgATCef0/Ojz0Jfh58tt/34eDQiOym0ZMdXyMvS4Za8IMzxxwlmA1WcYXZvT
         wA07GKmDUKb8m9njRGJQwFc3s/NrqSwc7WcJZNoTrTgSBuWz35rprMs9r6wXci9Xzc6S
         1lSaktqQAWXGNcIaQOcSxGBrbbSiAByY7EILJI8Y0lpGNjgrGtalGNlzrqKk0r47LpNS
         9dAQKtCsaIr8LfAJcU22nXWuPraZNfK6msac5yeXS3ZbSQwYg352ry9SGIEGHOvULTSc
         AOKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIqMSrMBYOzuE9mzo2Yoq5r5s+uGs1aAg+cvxPCDU2/UyBxhUy9nFpqo03H4YLsjrTGIr8YoiDzIo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+xAiDQ/bIvUHI6qtiQC7j/rltejQU3ZpdvwZ5TOoEy6IEPaRu
	ji7CUr3gtz8hKNVXOXLOTd1z0HUQIm7Z8aZ9aOudhwvOcH7YmbBiUAhgW8Br71w=
X-Google-Smtp-Source: AGHT+IH7eepGaxoKX7XFVQSCKcZ5tiiQfUtPjwDWCbNdm4JNlvZQy9y+41dOTUM8EVcPpq30RA+88A==
X-Received: by 2002:a05:6820:278c:b0:5ee:710:83fa with SMTP id 006d021491bc7-5ee922a81aemr6235784eaf.8.1731598087197;
        Thu, 14 Nov 2024 07:28:07 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5eea026eb41sm368250eaf.39.2024.11.14.07.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 07:28:06 -0800 (PST)
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
	bfoster@redhat.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/17] mm/readahead: add readahead_control->uncached member
Date: Thu, 14 Nov 2024 08:25:08 -0700
Message-ID: <20241114152743.2381672-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241114152743.2381672-2-axboe@kernel.dk>
References: <20241114152743.2381672-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If ractl->uncached is set to true, then folios created are marked as
uncached as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/pagemap.h | 1 +
 mm/readahead.c          | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 68a5f1ff3301..8afacb7520d4 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1350,6 +1350,7 @@ struct readahead_control {
 	pgoff_t _index;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
+	bool uncached;
 	bool _workingset;
 	unsigned long _pflags;
 };
diff --git a/mm/readahead.c b/mm/readahead.c
index 003cfe79880d..8dbeab9bc1f0 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -191,7 +191,13 @@ static void read_pages(struct readahead_control *rac)
 static struct folio *ractl_alloc_folio(struct readahead_control *ractl,
 				       gfp_t gfp_mask, unsigned int order)
 {
-	return filemap_alloc_folio(gfp_mask, order);
+	struct folio *folio;
+
+	folio = filemap_alloc_folio(gfp_mask, order);
+	if (folio && ractl->uncached)
+		__folio_set_uncached(folio);
+
+	return folio;
 }
 
 /**
-- 
2.45.2

