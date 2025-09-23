Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F5A1E98E6
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 00:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758587646; cv=none; b=aB/Q7PbasoRipeJ5KJnc0Cjgfim60cxsJDgHoHqar380g1JirGZ0LfYjSmPqiih+P1kPo4D9xuoGJx92SO4B5/UVYHGVO8GfLuFSJlwwJNzEkdV6S3XdIiy91YSgQrVsECsVt4ro8OStKxQXsgSrj+CsvEfxCJYbEA9eQOduAdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758587646; c=relaxed/simple;
	bh=wL9lZimimYPepUkw6uokO76yAdo/rrFpXRGxdT20nX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOYUTn39e3Wl1OKOsZcjiaiJQUJ9iznA/ZyAhrkfs1uKojAu4oL+fmQ4ySNrf+yYKxAVa0KNNpcHCR1owLpqsYMoSs9ZBWWk+/gSf0m3Tvaw4aScwCImnl24k2UPswIYkf2VceNvq5LhMPj8rK92qka9rWLGLPRxrtZfBKZTw8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aCcGPBPf; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aCcGPBPf"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b49c1c130c9so3361851a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 17:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758587644; x=1759192444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K5LoytNdOZjWYJW/+eSct1yfmQv94J0ZLKj78CJDynY=;
        b=aCcGPBPfMr2uG6WKESyUGdPsgiiIahPLQgBbCQOS7q9zHQsyIDd9McjV8lgKSENFq/
         7OdYCJglsYyXBIjxndB+wk/mlX7PBguZB7P5WmklHea0OB1rdk+nVb+Dgw6AaEIS6esh
         7g/COTeCpOdU8UeGgYtRj43Kl5PDdaGtyzJ91fTVbxLdBhyJmE7H9/Ah5+j9O5n/hNDY
         I8L93nQieGJ+FacpgRM0pbgPFkthIQGUSeRljqtautCI++B4VAZPNPSKTagylzjAsZOs
         WPPqnZUKSYsl/p7cbFPuEKXoAfJtqtemmYkwpm805L8Ajk0S9ycxEWnhWnePtM8eSSMP
         KpYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758587644; x=1759192444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K5LoytNdOZjWYJW/+eSct1yfmQv94J0ZLKj78CJDynY=;
        b=F18BDUnEp+MH2zoIFGTOO+bG2bGZwqRwqDpAPBFJNfZJyBLHL/w1+x9NhJo4TEoUEq
         DXUNXAnJOKPzUSWShXOTGjj/vvd2F/ZXF323xaAqsS+kHAFJOvWU4xmnDzaUOSh1UFZO
         XwKbb0MxthNCC0gI82lfqB+YTnkzEXSXZxvA5YnBjPga44u6jVS5UDaovd1Xn5UXw0tz
         xUkWUI1vPF4zpmw8BtUMJhyn66LTZEQztcNcDSurusw4O8t9tGZtaruRIbEcUPPIBMvF
         JJC3f2Fo5tQoQf/4+90xRALGxhQ7/GrUeFKLnoI0aorPqgx8SUCVVZ6+jSDybU/13+6E
         fbzg==
X-Forwarded-Encrypted: i=1; AJvYcCUnr0FnI78I4d/s7kuwJDyFPO3qYkKO1uKFGhVvg8wAhMHmDwpH5MscJqRTDtEqms+KBzp8dVZ3jVE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcU1XJvsYPgy3Pnpra7O4OvsfcIL0oJC+Vw7ZIzviksGt6kPxV
	KZGjojKHCABpJY+kU9GzlHS6V0oHFPku/NR7In1kVOOOob9OBwtfZDeX
X-Gm-Gg: ASbGnct13jk1P2Z4a6EKKLZAELqTkvq28T1yZMmUwH6cH1CllaDIIkpziSVSSIzPIex
	z2RGVblSck070RGfCRZYnKkOE8m7m3wDEa+s5MONjdv2tkbwpDWIsSDqcWJGEtpIiC5thgVFINA
	nywQWvybyarZpIKmOJ9bP8+hE3o9nu3U9Kude1RWv/fXHR9Paa/MmGo03eDfgwypgqsei9iz5Gr
	zobaKCOtttVSBi5s0pVEHN7LU8jGvsQcKsphwEjspMDDNZOLVzLGl4vCxQ2bC2sXVK9KEgUjMNo
	2ZMQIJ3pdzzlTGe558EtOwFaO+71nT8Q0tBi6NbNy20zJVc9Ne3PeDXwxfNPCipD/OiEHH8/waZ
	nRcDHTS8aVyctVxfkfuTfZLNYZhuQ5SQLrup+T20vU4AgS+UmpQ==
X-Google-Smtp-Source: AGHT+IE2rDd9Yyv5lah4zvV6w6qJu6a1A3PLSQl9h6wVx4RGpLkLw8rukfKuDkaefPlT+C3jXqTA3w==
X-Received: by 2002:a17:903:2ac5:b0:264:ee2:c3f5 with SMTP id d9443c01a7336-27cc22efd33mr7650465ad.19.1758587643804;
        Mon, 22 Sep 2025 17:34:03 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:41::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2698030ee20sm145121615ad.109.2025.09.22.17.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 17:34:03 -0700 (PDT)
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
Subject: [PATCH v4 08/15] iomap: add public start/finish folio read helpers
Date: Mon, 22 Sep 2025 17:23:46 -0700
Message-ID: <20250923002353.2961514-9-joannelkoong@gmail.com>
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

Move ifs read_bytes_pending increment logic into a separate helper,
iomap_start_folio_read(), which will be needed later on by
caller-provided read callbacks (added in a later commit) for
read/readahead. This is the counterpart to the currently existing
iomap_finish_folio_read().

Make iomap_start_folio_read() and iomap_finish_folio_read() publicly
accessible. These need to be accessible in order for caller-provided
read callbacks to use.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 26 +++++++++++++++++---------
 include/linux/iomap.h  |  3 +++
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 34df1cddf65c..469079524208 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -327,9 +327,20 @@ static int iomap_read_inline_data(const struct iomap_iter *iter,
 	return 0;
 }
 
-#ifdef CONFIG_BLOCK
-static void iomap_finish_folio_read(struct folio *folio, size_t off,
-		size_t len, int error)
+void iomap_start_folio_read(struct folio *folio, size_t len)
+{
+	struct iomap_folio_state *ifs = folio->private;
+
+	if (ifs) {
+		spin_lock_irq(&ifs->state_lock);
+		ifs->read_bytes_pending += len;
+		spin_unlock_irq(&ifs->state_lock);
+	}
+}
+EXPORT_SYMBOL_GPL(iomap_start_folio_read);
+
+void iomap_finish_folio_read(struct folio *folio, size_t off, size_t len,
+		int error)
 {
 	struct iomap_folio_state *ifs = folio->private;
 	bool uptodate = !error;
@@ -349,7 +360,9 @@ static void iomap_finish_folio_read(struct folio *folio, size_t off,
 	if (finished)
 		folio_end_read(folio, uptodate);
 }
+EXPORT_SYMBOL_GPL(iomap_finish_folio_read);
 
+#ifdef CONFIG_BLOCK
 static void iomap_read_end_io(struct bio *bio)
 {
 	int error = blk_status_to_errno(bio->bi_status);
@@ -379,17 +392,12 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 {
 	struct folio *folio = ctx->cur_folio;
 	const struct iomap *iomap = &iter->iomap;
-	struct iomap_folio_state *ifs = folio->private;
 	size_t poff = offset_in_folio(folio, pos);
 	loff_t length = iomap_length(iter);
 	sector_t sector;
 	struct bio *bio = ctx->read_ctx;
 
-	if (ifs) {
-		spin_lock_irq(&ifs->state_lock);
-		ifs->read_bytes_pending += plen;
-		spin_unlock_irq(&ifs->state_lock);
-	}
+	iomap_start_folio_read(folio, plen);
 
 	sector = iomap_sector(iomap, pos);
 	if (!bio || bio_end_sector(bio) != sector ||
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 4469b2318b08..edc7b3682903 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -465,6 +465,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 		loff_t pos, loff_t end_pos, unsigned int dirty_len);
 int iomap_ioend_writeback_submit(struct iomap_writepage_ctx *wpc, int error);
 
+void iomap_start_folio_read(struct folio *folio, size_t len);
+void iomap_finish_folio_read(struct folio *folio, size_t off, size_t len,
+		int error);
 void iomap_start_folio_write(struct inode *inode, struct folio *folio,
 		size_t len);
 void iomap_finish_folio_write(struct inode *inode, struct folio *folio,
-- 
2.47.3

