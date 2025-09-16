Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8843F23BF9B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 23:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758066650; cv=none; b=YR+5cVDqYyyUr0ycs/JUJeE7KRQC6RxLXacuu0ulfS2sUE2/YZ/ttcURUuxlJVKaxMwAsxt0G9NbJFseRDqVTNmmlxZv2tioba36oxcChOtMrGh2I+JVcomXawYDebZnySVru0PmFsklradeRhXcOFYvxFEnr6J+dllP8D7LDts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758066650; c=relaxed/simple;
	bh=LyOsg2Bu1m9/Q4KGCsDW7iDLciMuCVOGZhuLWbBDsng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEM0uRppdArZwgt9SPwtLyf/dkMWEZPOUTh9FuheMiszDnPTYx27hGK9cFBkNC1LyqFHzyvPwqujDJrc2iFeXBCF95r+yZ3mY8LMg521BsDcIYOB5sfYJUgl53QONxf7to/IaCRgSQGWcixE9L6/RrfCHEsAljhjfGvC7lLyc2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bkVuVp4v; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bkVuVp4v"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b49c1c130c9so4048434a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066647; x=1758671447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HGUNyWs1OxmiVEgLdMH+/qyYZ15HscPzayJVEDJfjsE=;
        b=bkVuVp4vM9nZkstX93tbmtvmp8fmXylyozjHXX+nfwo7jlhWbc+O2joE8gayybxBRX
         v2arqopH7u1Ob+GfUuGPm5vLyVfoE/B0WRSZdKFZ+Z5WIW0utF1SArFDT0j/iCqAtybK
         deVuD+1tT62Bf7nq/BFrZykP4jYN6MF2GnUmKfjsE7M5zLO3K9fipa8jnzSW1y+l0Haz
         8k2HBZ1+x3kBA+Ja194Sxy345waPZbFG/BO0siMkPJV9zvufHfFLA3f9GRO4T5gm96rr
         27eZHvm71fcUG3r4QH2l7M2eNR6sRUZc9sRKIE+gKvsuBV/t4Cy8aErO259zJJXh8Xdu
         0dfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066647; x=1758671447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HGUNyWs1OxmiVEgLdMH+/qyYZ15HscPzayJVEDJfjsE=;
        b=Pbc43NwxHJsUAqmOtzmDrPZqt3nTVU5ieFwaPb48bVq5Jtvcuqm852XvcqqAVRShgp
         tpfP5j8Us0UWOkTPjuRCE4UFmDkKdbbm9LEbA9/skiVnjOEnIMmY4ZYsa0frXD+dvHy6
         faGYwonaRXYtRDD9VY0k2zGu/iIkQrgbyO8SVdo8omtGzVgjnRKIJ7i1DLsNhyN1pnh1
         VPZb8FjL7fYXzT6MV0vQOskk/Rh8uUaCxkJIJRwLjsuUEc+86954cD5xK4BIzGXZUf5o
         8LBqS7SIdm43Bw/i2n0kc5lb0NdP6tNUx/lTGcwGOcLNq5CAcf0ficbKKofpPuJj1bOk
         JRLw==
X-Forwarded-Encrypted: i=1; AJvYcCU27dLRT8/FdUObZ6IjqxMpe7MLuwrWPDsJJO9l/vB3W72i2xWTw2ST/o3Kpsl2mL/Vk8uTvkXkFXg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGBZsF18rTbNs6BmYtTMHlc0SYGfPBDvU79G7KjP2QfCUj9e3G
	h+nHTOM6MYlzaz03jxenY8RZ6vUAy+/jni3iWWDh95EMNlVpTdFEXxXB
X-Gm-Gg: ASbGncsfgMAwAnNYrJosKxDPZ6Q7xf7ByUPcFwJkOckY2fKqltmcuXjG2VqLVYbxisB
	WbD9abBoqaJIppit+ge4SIFiXfpX5yJ9q/SuYOL0mL/Wqom/Zao5PH7gOLmCKA0eqvy5gTyc5Yv
	JbO9N46ilTtHMQEdTcgj4afsCdnx4IbSLzHkXYLfHmR7JniPnYaWygTOQmL4VBI0eHoKDILgda4
	vSFn5kjL16c0nKW9xf2LJxocL5eioApBY07UYoGUeTgoiDAf7l1MUszN4ROejBftvdYDaNm6inT
	1yVKSzVUivfEUz/gDK+Hd4UT3GzmQt9fJCM+BKIV9PabVgaGR20fYhNyqQlbR+cUCMhzyCp5AN5
	wUP5AWCVDDA8kLKyW7zOukDosplrvmp9QJyg0mHrwJ16MUc6mMQ==
X-Google-Smtp-Source: AGHT+IEDsgdnT7+nNQrDhXR5m+p9OqwQpqgyiqsnD7pJqTnVO6zC/tJ8dk2Wmo0J+/77Bc7uR5fcOA==
X-Received: by 2002:a17:903:1a68:b0:267:b2fc:8a2 with SMTP id d9443c01a7336-268121808e6mr1290225ad.23.1758066646820;
        Tue, 16 Sep 2025 16:50:46 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4f::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-267e52d1621sm22110075ad.40.2025.09.16.16.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 16:50:46 -0700 (PDT)
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
Subject: [PATCH v3 13/15] fuse: use iomap for read_folio
Date: Tue, 16 Sep 2025 16:44:23 -0700
Message-ID: <20250916234425.1274735-14-joannelkoong@gmail.com>
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

Read folio data into the page cache using iomap. This gives us granular
uptodate tracking for large folios, which optimizes how much data needs
to be read in. If some portions of the folio are already uptodate (eg
through a prior write), we only need to read in the non-uptodate
portions.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/fuse/file.c | 81 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 24 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4adcf09d4b01..4f27a3b0c20a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -828,23 +828,70 @@ static int fuse_do_readfolio(struct file *file, struct folio *folio,
 	return 0;
 }
 
+static int fuse_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+			    unsigned int flags, struct iomap *iomap,
+			    struct iomap *srcmap)
+{
+	iomap->type = IOMAP_MAPPED;
+	iomap->length = length;
+	iomap->offset = offset;
+	return 0;
+}
+
+static const struct iomap_ops fuse_iomap_ops = {
+	.iomap_begin	= fuse_iomap_begin,
+};
+
+struct fuse_fill_read_data {
+	struct file *file;
+};
+
+static int fuse_iomap_read_folio_range_async(const struct iomap_iter *iter,
+					     struct iomap_read_folio_ctx *ctx,
+					     size_t len)
+{
+	struct fuse_fill_read_data *data = ctx->read_ctx;
+	struct folio *folio = ctx->cur_folio;
+	loff_t pos =  iter->pos;
+	size_t off = offset_in_folio(folio, pos);
+	struct file *file = data->file;
+	int ret;
+
+	/*
+	 *  for non-readahead read requests, do reads synchronously since
+	 *  it's not guaranteed that the server can handle out-of-order reads
+	 */
+	iomap_start_folio_read(folio, len);
+	ret = fuse_do_readfolio(file, folio, off, len);
+	iomap_finish_folio_read(folio, off, len, ret);
+	return ret;
+}
+
+static const struct iomap_read_ops fuse_iomap_read_ops = {
+	.read_folio_range = fuse_iomap_read_folio_range_async,
+};
+
 static int fuse_read_folio(struct file *file, struct folio *folio)
 {
 	struct inode *inode = folio->mapping->host;
-	int err;
+	struct fuse_fill_read_data data = {
+		.file = file,
+	};
+	struct iomap_read_folio_ctx ctx = {
+		.cur_folio = folio,
+		.ops = &fuse_iomap_read_ops,
+		.read_ctx = &data,
 
-	err = -EIO;
-	if (fuse_is_bad(inode))
-		goto out;
+	};
 
-	err = fuse_do_readfolio(file, folio, 0, folio_size(folio));
-	if (!err)
-		folio_mark_uptodate(folio);
+	if (fuse_is_bad(inode)) {
+		folio_unlock(folio);
+		return -EIO;
+	}
 
+	iomap_read_folio(&fuse_iomap_ops, &ctx);
 	fuse_invalidate_atime(inode);
- out:
-	folio_unlock(folio);
-	return err;
+	return 0;
 }
 
 static int fuse_iomap_read_folio_range(const struct iomap_iter *iter,
@@ -1394,20 +1441,6 @@ static const struct iomap_write_ops fuse_iomap_write_ops = {
 	.read_folio_range = fuse_iomap_read_folio_range,
 };
 
-static int fuse_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
-			    unsigned int flags, struct iomap *iomap,
-			    struct iomap *srcmap)
-{
-	iomap->type = IOMAP_MAPPED;
-	iomap->length = length;
-	iomap->offset = offset;
-	return 0;
-}
-
-static const struct iomap_ops fuse_iomap_ops = {
-	.iomap_begin	= fuse_iomap_begin,
-};
-
 static ssize_t fuse_cache_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
-- 
2.47.3

