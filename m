Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A202F28FB
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 23:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758066641; cv=none; b=NUdq57PeCNetYIFXNW9u/paBprYephYsJIO4h9uqU2/OqDdqUuDorzFxMaQsUngDDRqlaHQo9Qutg8HuMvtW2ONf0dYt9Ecb9N1psk4krqfZqmvUQBPFFRycQN2pjzV+IQzZ5f/VCFw+6FSZ9LwLrMvHrqSkcu29Tlg3d6MSYeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758066641; c=relaxed/simple;
	bh=VGunh0uENs1oKVEipOlQeeSZnl9YmLScA2w1/AQ6cfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=As4tZJ7L5d7YjarzbSGg5AyGnoM1cm5YcSXe443GWeiZQncVcYaLwwfL522wsaB0r+5uJ9Vwo90BpN+Xn1XMmKn46k7gTNwLfuKsuNcnZoujkb0oszuFlGw9xkdmSf6C3OKjUTP5f2pnRcs2o7h91Tdue7JtiRj+YQ4Y1Pi8aOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f4xui5Z6; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f4xui5Z6"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-267f0fe72a1so6527795ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066640; x=1758671440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gu5+EirSaOm4rVQJq+asKnmescHkhWbNcqUv5AEv4JM=;
        b=f4xui5Z6Bex2u4OM8MAMuqRy+WEX6XuktJZz2qoG1L1o9d0khx92oQDknljPYOWYtu
         2JwoR58f2H2aSzlF/Q6dmOQqJ0hh0Y0Udjm3DVaUq4rFhEcXWoxOuOLMbXMstuOT07jO
         Oap5wNgYzI+B9hwqZFgk2zAWFWG+ggdgCngdUtJAVgzn2W8aXOTDDsUgTYIThou9bRJb
         Szn76SKjd0+/cjnRjNabDjIW4plVbEErMocYrOKlX/TeF1xfTosl1SB032YzHr52nxUF
         b2CjNyGPc820G3fzqNkvkvkw4EV3PMF6mIT1xZOC8aExYSjtVK5/SqKK3h4D/eISD3n6
         ys2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066640; x=1758671440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gu5+EirSaOm4rVQJq+asKnmescHkhWbNcqUv5AEv4JM=;
        b=G2hespGFk+hruUPlbhwmkZs247ZYUj8PHeWLfJKecXuDnVTXk30CnOiX+YWqwhKasr
         6rBdXVJ/AwHVI7ijIUEWnXgh3qeqTBINat0jbF6KAqvdvXI0tZiJMaZXQBemL67plItj
         CYDvQHQAFs6E/H946Oj/Qgg8BnM2qO3FkeUmSgV3J/izpjqadsz+0GSoF3FcgfU/VOpv
         Cx7OfYWshO77jEQt6vRKFKcKGP4XrVueXkto5/syGWrIyaxPTj616YJpW9/sMRjI5CoS
         efsnUVnUYjt37WH2ARMtrvsHsnhmT8vwv6k32a92m13bmYTwS+GX398oVmVH5WkEOTfu
         tzkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhOh5tQmoGmNfq6Df09tukM/su6KnRLpR/7+o6cEMPUY4SuQCHgsKEpp7q4vlCTMF1IDoRNBkLRTc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXsKBPzLHwUYhGWIDVUrf4p8yVJoxTcrzI7BdosEPMG2zj70ZT
	KF3VyBrVErkNHMPEl4+p/YJHO/rY18vAPJDR8ephDZrLFp3PjBc6SvdI
X-Gm-Gg: ASbGncvTJatqlvVG0Yu+FZK3fz+jaMhKdXOPER8+vmmT6kNzlNGJXORkEfW6ERUerOb
	r6APelHVUoFw4E9DYWMjTKrcaJQi/xk4il0vRBs2dM0sP8ioh5EcSRqTWBJbVJClpqLr9pBLOYS
	EGmjcTnEimZ8nlM/7DGgFEi5Kz2GNPEaZpYf4lDtRgc8pn4UKliWuxTnA4HiWCX232dbVRqKoRl
	yCGawZk0OzgpVspfxlUG2iCTlxYF7fPq3wMCDSBRu4M1GPUcC4IgDuWN4TYyfBRMF5Uu//ybrWL
	DZJGf7hakz+vVXxdvjZDrjZsftkIMJuTLAQn4lpUt+Eg+hDGL68p1TYN2W7UICydhADwcllbRU/
	R1G9VzVtc9KdauEfbv0i3uYhv1g0TdG6bSrgGXgY28eMP790D6g==
X-Google-Smtp-Source: AGHT+IHXWaeobMccRHFmyjLsVkTTEzUvEQdZmGHGgnJY3NdcpQ/VkaAqzQfWkHRXLscEGvW5AibjWQ==
X-Received: by 2002:a17:903:11cc:b0:262:661d:eb1d with SMTP id d9443c01a7336-268118b9516mr1315115ad.1.1758066639177;
        Tue, 16 Sep 2025 16:50:39 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:55::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2631ee2ceb2sm100151495ad.141.2025.09.16.16.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 16:50:38 -0700 (PDT)
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
	linux-doc@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 08/15] iomap: add public start/finish folio read helpers
Date: Tue, 16 Sep 2025 16:44:18 -0700
Message-ID: <20250916234425.1274735-9-joannelkoong@gmail.com>
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
index 587bbdbd24bc..379438970347 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -317,9 +317,20 @@ static int iomap_read_inline_data(const struct iomap_iter *iter,
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
@@ -339,7 +350,9 @@ static void iomap_finish_folio_read(struct folio *folio, size_t off,
 	if (finished)
 		folio_end_read(folio, uptodate);
 }
+EXPORT_SYMBOL_GPL(iomap_finish_folio_read);
 
+#ifdef CONFIG_BLOCK
 static void iomap_read_end_io(struct bio *bio)
 {
 	int error = blk_status_to_errno(bio->bi_status);
@@ -369,17 +382,12 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
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
index 73dceabc21c8..0938c4a57f4c 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -467,6 +467,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
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

