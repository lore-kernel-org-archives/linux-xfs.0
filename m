Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751EC192D8A
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864694; cv=none; b=maaSU7NJxmZE4DbYTCCXmXqEqXMn2JZJAgqgIbrM3XLf6/hPHE3bcbI01E19VMfg7gMNRAgcWtjWXntCWHuPeVamuqZifHgJL6gArC5VQgtMK1MeX70x+sFDScjP62RWtdyNgCda4kOF27VaHMAEJ7Xniqq3BjI39kHtbY4PWDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864694; c=relaxed/simple;
	bh=GHBQ4M07NJw6IdGMb/Vsg8l8qqZbiKFmM+Iz88nZqN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDmFELvLjxc7/5hpunnbcAELI3Ty5Uvv2YVV95Azz8dublOqGTs3DDHSkYcYmGTTsFIAjoZzas45vStepYylg5kmIyvOMqjEaJg0GjeTp8k374C4gpqcl3h7U8nLU4jsIxewCIKHLMR+X0zhcsZi/kQj9UBNvfTuIfhwZeLEVdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GhwB8u8e; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GhwB8u8e"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-69eb8b6bea8so26516eaf.3
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864692; x=1783469492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pzFOMzoZ/TuBR5zRrI/HwvF0+uDiZgYlmh/DCwsRYfQ=;
        b=GhwB8u8etTnd9n5iRgB1BTYVIuNcB0ZR2OXbJ3HvknmiKzKvnRE6xb1VWvDtsv69Kg
         omHRMW1qAufmzCerd1yzHGIytBvUojoNRO4BuUn+MG0auRNotSz/Ln45diMZs7qBm/Hf
         sdD7C6XVV3HTEBDOKSy5BL+lkbft9Whzqr39dlnFdhuySrqrdtZaxWJ41aCNVGFk4wk8
         5vc3Cp7nch+KOY0hFiwgEdq2US4ADbgVLAolXappqaurTi3Dt8OKCiaJV16BRAYa5v0t
         yHRB28NyGms6ezd5/gjryeXgPHZu6QDjhasCoLkHh+NNmwH2HOusoX+zKvDeZlf5MZh5
         WZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864692; x=1783469492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pzFOMzoZ/TuBR5zRrI/HwvF0+uDiZgYlmh/DCwsRYfQ=;
        b=iHrIZ84KvTm+HahkfaiP7luKatpcIZ9ivJIv8W0iCdmsd3kdRrglyhety9rTilTPtQ
         05CxYQlvL+fqeAiup9zb7I0OpOkLSX9kDkpWzSsQ56H04t+vuA2+YEFT8GKgCR8hJslJ
         Dhz6WfOGFI7qpf30RYpcRpZrLrRLIqxqmW/EbihEoru5HkCk3i7rze89lKCY8DomKWIx
         YKGJrtbaSYiHvM6KeB0Jn+ubIjjvKlFDQHYUXutoObUVqpioXKx0NvUu2B+CYSpcf2YO
         a1riJKO+/WsOYIRN8GthPhJMIEF+fhYpKPiyV7FyoWAKhDUU5BZdXHpGvTmCfIz2MxNl
         MlVw==
X-Forwarded-Encrypted: i=1; AFNElJ/03onwXRidGgoAAlIndBHyQ43fu+YsibsISj0mjo/lbZrD7sqjx1LGctimktJs+Uxq1Nk/9ZqwrjU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTnp1YWdkzNWGlq7bsiKQw8OZIcHp674KhfYFJ9zgtP+9mf+lb
	IeKPXj5+m4i/QY6zEp4kALg1+pJ1tyojj65jQjw/jB53XLO8mkFP1tHc
X-Gm-Gg: AfdE7clYIDRw2oVZYBnTL93FuNyfVnP+XaEyq7WqwiV1/N5NgD5oWnB1awsLVm/IDCI
	71vNdhvxQqAcVoHSQNdUd8hD43xfIxNi0zKyPOC9nkem2f837P+g82G+L6mfG/SVqJoBvedzTn2
	UZkrOaVCFIqiF2TVzIePtOOx/xapwFuWWwyx2PST4Fiui+qQsuWNNO3xRcWiN357A7lGR+dHWFL
	D3MkRHTJsjo5+u96Vu6o2r21n6NHxg1BkBE+7PRWPJUO7b0O5GnN36Py/97OHnoDvliOz/a5Coe
	5HyDELej7gPLuNbPRWxSkslKCyXh72cBuUsjgMQCRxTg4PQ7XOQmalbDj3AyD5RLvk3WecTcPVL
	LBg4okyk8+rMmziDWV2oozHmf3CsLwgDw70I6d4fp6/n5eCH0NEGk+wzp8wt4M3gWQrT5BXq/K0
	dAGKF8qHXpfxaMvUwTI9yEfksbRxDP9jcgHlhx+CZE2I3IOg4F+/AC6bq5dFoAI3s=
X-Received: by 2002:a05:6820:4c11:b0:6a1:50eb:d50d with SMTP id 006d021491bc7-6a196cbb08dmr1695221eaf.62.1782864692434;
        Tue, 30 Jun 2026 17:11:32 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a1891cf544sm3043560eaf.5.2026.06.30.17.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:11:31 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 05/18] ntfs: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:20 -0700
Message-ID: <20260701000949.1666714-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260701000949.1666714-1-joannelkoong@gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert ntfs iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ntfs/iomap.c | 56 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs/iomap.c b/fs/ntfs/iomap.c
index 52eecf5cb256..0f9f02e1593e 100644
--- a/fs/ntfs/iomap.c
+++ b/fs/ntfs/iomap.c
@@ -277,8 +277,14 @@ static int ntfs_read_iomap_begin(struct inode *inode, loff_t offset, loff_t leng
 			srcmap, true);
 }
 
+static int ntfs_read_iomap_next(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, ntfs_read_iomap_begin, NULL);
+}
+
 const struct iomap_ops ntfs_read_iomap_ops = {
-	.iomap_begin = ntfs_read_iomap_begin,
+	.iomap_next = ntfs_read_iomap_next,
 };
 
 /*
@@ -329,13 +335,25 @@ static int ntfs_zero_read_iomap_end(struct inode *inode, loff_t pos, loff_t leng
 	return written;
 }
 
+static int ntfs_zero_read_iomap_next(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, ntfs_seek_iomap_begin,
+			ntfs_zero_read_iomap_end);
+}
+
 static const struct iomap_ops ntfs_zero_read_iomap_ops = {
-	.iomap_begin = ntfs_seek_iomap_begin,
-	.iomap_end = ntfs_zero_read_iomap_end,
+	.iomap_next = ntfs_zero_read_iomap_next,
 };
 
+static int ntfs_seek_iomap_next(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, ntfs_seek_iomap_begin, NULL);
+}
+
 const struct iomap_ops ntfs_seek_iomap_ops = {
-	.iomap_begin = ntfs_seek_iomap_begin,
+	.iomap_next = ntfs_seek_iomap_next,
 };
 
 int ntfs_dio_zero_range(struct inode *inode, loff_t offset, loff_t length)
@@ -764,9 +782,15 @@ static int ntfs_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return written;
 }
 
+static int ntfs_write_iomap_next(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, ntfs_write_iomap_begin,
+			ntfs_write_iomap_end);
+}
+
 const struct iomap_ops ntfs_write_iomap_ops = {
-	.iomap_begin		= ntfs_write_iomap_begin,
-	.iomap_end		= ntfs_write_iomap_end,
+	.iomap_next		= ntfs_write_iomap_next,
 };
 
 static int ntfs_page_mkwrite_iomap_begin(struct inode *inode, loff_t offset,
@@ -777,9 +801,15 @@ static int ntfs_page_mkwrite_iomap_begin(struct inode *inode, loff_t offset,
 			NTFS_IOMAP_FLAGS_MKWRITE);
 }
 
+static int ntfs_page_mkwrite_iomap_next(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, ntfs_page_mkwrite_iomap_begin,
+			ntfs_write_iomap_end);
+}
+
 const struct iomap_ops ntfs_page_mkwrite_iomap_ops = {
-	.iomap_begin		= ntfs_page_mkwrite_iomap_begin,
-	.iomap_end		= ntfs_write_iomap_end,
+	.iomap_next		= ntfs_page_mkwrite_iomap_next,
 };
 
 static int ntfs_dio_iomap_begin(struct inode *inode, loff_t offset,
@@ -790,9 +820,15 @@ static int ntfs_dio_iomap_begin(struct inode *inode, loff_t offset,
 			NTFS_IOMAP_FLAGS_DIO);
 }
 
+static int ntfs_dio_iomap_next(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, ntfs_dio_iomap_begin,
+			ntfs_write_iomap_end);
+}
+
 const struct iomap_ops ntfs_dio_iomap_ops = {
-	.iomap_begin		= ntfs_dio_iomap_begin,
-	.iomap_end		= ntfs_write_iomap_end,
+	.iomap_next		= ntfs_dio_iomap_next,
 };
 
 static ssize_t ntfs_writeback_range(struct iomap_writepage_ctx *wpc,
-- 
2.52.0

