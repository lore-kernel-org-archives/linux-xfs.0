Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842ED27F73A
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 04:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758601331; cv=none; b=uhHGFyTUBhDnWoCuytbmu57cVGIXeUkbnhKhZWzQLO3au+YODQpj9TGPFan8x0FRl8BlO+XfNp49o3en3cE9GO4jnCHZK+9UnIXWCrctwpmqPrb1uMC3jXM/7Y2TP6By0OZUGFShrqBvIxzF3mEcO+EzxLHfJ3/ZPhRXrO5CREA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758601331; c=relaxed/simple;
	bh=5eH935+lsN0R/DItA1U64YcW9yDNKNSWjjrWljodN0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzBlN3FLSO6JI/zHUJbP8VhEtfW83TYcwPNxmkmWjQvrZ1u2JA3UYvAsZNOI6tx9S07J8ygOqXepbJVrPXKHvpJTzGUOq96md6AO5vzSlxug+WMhM1SoROkP2T9nBf+87kJ5brjkFwWvnF2mW6k+X9onjogFQsvgSMY5Qbrvis0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bb8nCN0t; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bb8nCN0t"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-77e87003967so1866741b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 21:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758601329; x=1759206129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTiKYWhp9DqW3xIE0b9hgxXBoYHgu3XtAiRm2w5aZUo=;
        b=bb8nCN0tbhRXM3QVcmVwW+hzdss3hHiWvKEcGF2RSoxdOMY8JjpT5p4WnaO8m8UTeC
         J1P008BG3hWRFsIpM4ThVD4XcjYLfqxwyiBkokZtP0f6SuICViCMAZWaheKnkCNX8olo
         4thsFUf1MB7fDJNjq1CTExjEFTHaEVeUbCQhkGstoG2fueWdu0Rnb0R8U3Tzb+3sXooo
         hNghaEYu0d/ZSwqAgUZl7YtqSWPkNXmHvvaHh8mYmzQTUiwP7OE89PGnaaD8T/n+7LNq
         NwAoLdCZZYYyzqVMiaB07oEh7DuJv/WuyDKXZfLHg8e6HkQib+KWSQwSoLJTgEie7Bkb
         SPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758601329; x=1759206129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTiKYWhp9DqW3xIE0b9hgxXBoYHgu3XtAiRm2w5aZUo=;
        b=f/3JPi/uIA/bRuge7JfHWSXUXcMBoxSxpKxVyH60UNeTHKvoaTdPMQTHKp0c2JmewL
         Lejdky6bRr+VFzPz9Guqync6MTZj3XLK1bSBGIOb8cLnwSDzqKSP80TbWN8Z+e0pFDpm
         G30asrE8q374bcki/BX5lOWbKhe4flF1hITwKM3oEdr+PPCjIap86JMAw/vFZnOS2Mwb
         3Wcf1R1WT6DEBEVzBNw0ag+ajzH4MC7k4QZWsvsyo49Xe4LFzutT8cc7pQrLd3atoPrU
         We+B2tqCCjqjoqwb4ek3Q9tyrGaw6sEPAbeFwp6fEAQJj4Eyx9dxb4su+nD971hK+agu
         CA1Q==
X-Gm-Message-State: AOJu0YwLE9Hy0T0THh+0LF8nOs1jCtIsuXFwGibbcBp2OSFAeU/jeUZT
	8T8mwmgze6zK8hbf6RFBhAIjDezuhEIgaBw9WEswgBDat/G5J2qJ900p
X-Gm-Gg: ASbGncsSU2+K5mjaVVc8zhYg2BkNhAp5pQT/PfyFSZ9iq33g+9BVRMlY/78+6xUIY0y
	4FPb6fJjd5y0RXhzZKcjUces9f4R4N08PYQGcWl7Rez7Iia1Q8emPGF1/BijBK10ioF5XtEmJ00
	Nwux+cByl/fftWcyWmhY7sAgs3+EKY5ADFsKbZiIPj43Vt/zAZ3KbjHIqxTAZM7t2VHqv8d42nw
	i4x65eeJhK+Y0l7szpTjdw9SvVuhWLkRvDxyB8BxYcScVxyx/5RcVMXEQOTK8Tk9MyOpNZ3rD9J
	jJjXAoqIq0IHEiWB23IR/X0URXIB6opUQcOfNjjRQbrhFAHfP03Rro2DUjKTjY5XFMV1KWZJbna
	4ZmtYI8zts7xwAftXmplvzkgIcjvCO4m2jg==
X-Google-Smtp-Source: AGHT+IH6HBhAi03cdQLfqQC6cecOw3p26zijbrqK/kBrzopVVn6ri+wpqvCMc/oJTTwEYKJ19Ui/VQ==
X-Received: by 2002:a05:6a21:99a7:b0:24b:c7d9:88e4 with SMTP id adf61e73a8af0-2cfece8b630mr1830042637.42.1758601328808;
        Mon, 22 Sep 2025 21:22:08 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77d8c3adfd4sm13316513b3a.82.2025.09.22.21.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 21:22:08 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	kernel@pankajraghav.com
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH v5 3/4] iomap: make iomap_write_end() return the number of written length again
Date: Tue, 23 Sep 2025 12:21:57 +0800
Message-ID: <20250923042158.1196568-4-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250923042158.1196568-1-alexjlzheng@tencent.com>
References: <20250923042158.1196568-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

In the next patch, we allow iomap_write_end() to conditionally accept
partial writes, so this patch makes iomap_write_end() return the number
of accepted write bytes in preparation for the next patch.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/iomap/buffered-io.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index e130db3b761e..6e516c7d9f04 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -873,7 +873,7 @@ static int iomap_write_begin(struct iomap_iter *iter,
 	return status;
 }
 
-static bool __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
+static int __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
 		size_t copied, struct folio *folio)
 {
 	flush_dcache_folio(folio);
@@ -890,11 +890,11 @@ static bool __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
 	 * redo the whole thing.
 	 */
 	if (unlikely(copied < len && !folio_test_uptodate(folio)))
-		return false;
+		return 0;
 	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), len);
 	iomap_set_range_dirty(folio, offset_in_folio(folio, pos), copied);
 	filemap_dirty_folio(inode->i_mapping, folio);
-	return true;
+	return copied;
 }
 
 static void iomap_write_end_inline(const struct iomap_iter *iter,
@@ -915,10 +915,10 @@ static void iomap_write_end_inline(const struct iomap_iter *iter,
 }
 
 /*
- * Returns true if all copied bytes have been written to the pagecache,
- * otherwise return false.
+ * Returns number of copied bytes have been written to the pagecache,
+ * zero if block is partial update.
  */
-static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
+static int iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
 		struct folio *folio)
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
@@ -926,7 +926,7 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
 
 	if (srcmap->type == IOMAP_INLINE) {
 		iomap_write_end_inline(iter, folio, pos, copied);
-		return true;
+		return copied;
 	}
 
 	if (srcmap->flags & IOMAP_F_BUFFER_HEAD) {
@@ -934,7 +934,7 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
 
 		bh_written = block_write_end(pos, len, copied, folio);
 		WARN_ON_ONCE(bh_written != copied && bh_written != 0);
-		return bh_written == copied;
+		return bh_written;
 	}
 
 	return __iomap_write_end(iter->inode, pos, len, copied, folio);
@@ -1000,8 +1000,7 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 			flush_dcache_folio(folio);
 
 		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
-		written = iomap_write_end(iter, bytes, copied, folio) ?
-			  copied : 0;
+		written = iomap_write_end(iter, bytes, copied, folio);
 
 		/*
 		 * Update the in-memory inode size after copying the data into
@@ -1315,7 +1314,7 @@ static int iomap_unshare_iter(struct iomap_iter *iter,
 	do {
 		struct folio *folio;
 		size_t offset;
-		bool ret;
+		int ret;
 
 		bytes = min_t(u64, SIZE_MAX, bytes);
 		status = iomap_write_begin(iter, write_ops, &folio, &offset,
@@ -1327,7 +1326,7 @@ static int iomap_unshare_iter(struct iomap_iter *iter,
 
 		ret = iomap_write_end(iter, bytes, bytes, folio);
 		__iomap_put_folio(iter, write_ops, bytes, folio);
-		if (WARN_ON_ONCE(!ret))
+		if (WARN_ON_ONCE(ret != bytes))
 			return -EIO;
 
 		cond_resched();
@@ -1388,7 +1387,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 	do {
 		struct folio *folio;
 		size_t offset;
-		bool ret;
+		int ret;
 
 		bytes = min_t(u64, SIZE_MAX, bytes);
 		status = iomap_write_begin(iter, write_ops, &folio, &offset,
@@ -1406,7 +1405,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 
 		ret = iomap_write_end(iter, bytes, bytes, folio);
 		__iomap_put_folio(iter, write_ops, bytes, folio);
-		if (WARN_ON_ONCE(!ret))
+		if (WARN_ON_ONCE(ret != bytes))
 			return -EIO;
 
 		status = iomap_iter_advance(iter, &bytes);
-- 
2.49.0

