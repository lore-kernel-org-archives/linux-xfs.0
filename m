Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4699421FF46
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 00:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758587653; cv=none; b=LOKGyUoSAKkUgRRfMeI0+XY3rikGH7R2X1Mv5XSe2kHIB0jV29jWuHoeyWxNm+7ATRJDByg+H0zJheAuwQ2ONuWZaZkz+L/QWEensatmKAMdgcuu2yNumuebmBdphQCXSRgK8bFUammMYcxQCFH7hGjziit29UGTyUKCMx5Pv5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758587653; c=relaxed/simple;
	bh=LyOsg2Bu1m9/Q4KGCsDW7iDLciMuCVOGZhuLWbBDsng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6giNBs2Xj/HFnAlum7NhoV/g4b6rd61w6KeLn5yb64JJxWvUFlwaHkWJU25caRSvbbHSGVvun55UeIxTbf6MMZOGJDwuf19T/W84vO3NRTLaxknGUBN6AxNE37u4SfE+e/TGeFLMv7D5agz/MHjLv3MkNc95cdukwer63OBh3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNyewmMu; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNyewmMu"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-77f2e960728so2283604b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 17:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758587650; x=1759192450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HGUNyWs1OxmiVEgLdMH+/qyYZ15HscPzayJVEDJfjsE=;
        b=nNyewmMubgRg/htQHWcoavsVoAEtwnHksZchXXcjCh8pGiO6/RA/jhA95xj28ze9ti
         ha7PXccL8GJc1KpuE7wJtBUQzRcuTRqJsw4Q3W+aMGjLPnPqWJhlGd2uidjWQDOibyqd
         R9s0L2wL7P6diNmseMM5ataaEeG3aGPKvbsDT9+TIHUgg1PfUfv1pWOXZZ6zWkplstj+
         91WDVQbeLw/5wF1FECC5FbakEnRa4/4Z8Q5TTlYeXlVQyJ+wrquxMC4WY8KC0wCXaqtR
         R9b7YIbqpX5leriFdiNvyIT9Ot6LOg1ZTZ/SC1LPShsg41EDtTU/SrRddcABgXuwAos1
         RPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758587650; x=1759192450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HGUNyWs1OxmiVEgLdMH+/qyYZ15HscPzayJVEDJfjsE=;
        b=s0iNtR3gFpJo5FTuZC23CvdmR6kexVz3IOGPYHvmT9o2zRhVILC6nK3yLzMs82wxFx
         rb91oAZHHqQ60oKveCHTaxKbSl9qcm9AR2cFDIYS35ugg16w80+J/0mrU0bYKaXGDKKT
         HTw1B+6KYazL2OgavjRP3MXk9uaSuDiR2s4T/sq8aV74hkTWY6iYIbh8YnfGLiLy8h8i
         i3akTS3goKTBMPP8TbJMBBV/ylzkLsa3fXXLztbw9c1ov8bflCF1tiPQdytOclLq9jFR
         MniVL+Ty0KPIYj2W1l/UfUKMHRZYystPwFSxqOrWqC4Q+w2gIGPKSw+rlEfEmUV1j6nL
         7tbw==
X-Forwarded-Encrypted: i=1; AJvYcCVdvjWmp8wecnjJy9qDLbn/fKYhXTr507qxr7YxGdiN1Z2FeT0xrRoAjpVxca3+lSObVe5ghJ18R1c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsYOwMYZZliozsgu7Yan8vOzSXRRTv8wq39u+iDgH+hoDfzkkz
	pE+p28b7/rnMG4EfRrUXh07qR4t8W4tuN7lvs4kmW4eFRFtNo1kPmgVm
X-Gm-Gg: ASbGncvEJ3vfZAlJLQLX2ilm9xDx5BTxd9Hc7uruJ2CnkzERgmkqQpxi+AgpFaTKIwV
	5ohtuqtz0fc3R/t2vmSs5TYf+GerVFK+MYtD0wmtFHfNFkm89DL+dvCXXJNSutkPY7XAclgc4WK
	RVxZsf6CMZM0cMnPi8LvV5RlE0nYcs+Y3scxHbUUWFUC6W3PknD4/o4AImeuJ1BELPr0S+jqREX
	zKsdKLqGQbI7SkPHaggZ2Ru6A+rQ/rE+qzk4bi1SIYCyIdM8hVwS/pmF+a5XObDKBl4rRX+vFVE
	npcuMcghDBP1/JUM1ypnRMnVdQT106fklUepKG0FwcKz5l2g67cROwrVM+KH4lFOO8WbQhvruHZ
	9U/KziWMwkYx9/DQSjtuNuTquSyaMoKLDC1hcA+ig8e8aOZEW
X-Google-Smtp-Source: AGHT+IFDRYIdyBl04iBYoDUtSI9mRjhTN7zVi/dDiSEIGK216VfDG1RkUSAPcnJWtf4ohk7umhb2Jg==
X-Received: by 2002:a05:6a00:a93:b0:77f:4306:d248 with SMTP id d2e1a72fcca58-77f53ab8044mr872603b3a.22.1758587650623;
        Mon, 22 Sep 2025 17:34:10 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:a::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f0ef2db80sm9374730b3a.24.2025.09.22.17.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 17:34:10 -0700 (PDT)
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
Subject: [PATCH v4 13/15] fuse: use iomap for read_folio
Date: Mon, 22 Sep 2025 17:23:51 -0700
Message-ID: <20250923002353.2961514-14-joannelkoong@gmail.com>
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

