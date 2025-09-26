Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972951A9FB0
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 00:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758846585; cv=none; b=ELoIa2qjgvfo6t13Kni5eHxBlOzqou4C3/c42QTJvCKE6VJ+9L6pxMyrtdSRIbCLK3mk7lTPNc/7ofWWqkE63fOQ1pNaDc+55Cl5cPYEpIlBPb3q4uMxa/rAhkEZ0g2zkLIRVwOcfbOdFUXVg1jwt6Ly+akDRKJLlGqkayu36Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758846585; c=relaxed/simple;
	bh=K4U/CA7tbg/bUek9YcVC9Q6ozcjFrUj/3jdxNsXhIUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Do350Zphn+PnwZ82kzEUN63hIAfldEMuXuK5DkhZNYcBsYGkNTf3WBZMzw98kGAOY0Gzgfrr/aoblr1WTOg0AAEaXJrDlBglhwDEq4e2Ea/bZq9Xvi3bTCtlb/PShKTYjkeyHczla02jLlp4dDb6mWwRjmkxlUZ6ppAqTpSnAg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QPyWRK44; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QPyWRK44"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77f207d0891so1604664b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 17:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758846583; x=1759451383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cnw5A92oVT9gS4E1+yrEsisFkg+/g1YXgFVE1vK/hEw=;
        b=QPyWRK44jKM9h0nlW1qwvNRtnVA/3vxNlJ9vaOftxKLhmrMhpKm1x+0pigvVHGLmTJ
         a8pKU6/KthmMGAZXtD2MppiVcrpADe/1w0rIqTgucSvHsaav0TdakPXHfoKPbZkQNb/u
         PMxZGc+qH261BK70S6EJrDKQXTo9k3LZvX5Z1vm5ZLtiSvHVd1KaiJ656MiINaCcmz+9
         DGBf+xMlfzPbWxwwjRi2sDAY1++wSs7Rldv2k9pB0mtAo/F8XKb+wfTLG5k9cSPPSfEd
         a5VKxgfIE+zLPiq/avRCLsU+s/Z1N1EUz6TclKq8e3rFsJVBH6YmcqTst7nT9Me0U81Q
         K3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758846583; x=1759451383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cnw5A92oVT9gS4E1+yrEsisFkg+/g1YXgFVE1vK/hEw=;
        b=tOzypkaQmcKlqZ+yfwz0Eu2RxjapIsxYnSnyxCiwTbmS0PZ266uppPcyLqzcQsBJXb
         YnPCBhitwIn6qr7fE6xP4CSislJCR6muHLlNtR4tJojS2hIJF2dPoJPB4sBHSTnBu9Lg
         Mg34buAskzJ2O8jfk1y1v6m1tJiTQt8mXbPM0IX9DNNcxYcXz7yFCI0HR5YtzuMhWpQk
         rjkGneqGG++7MrU5mwd+Ne8MuKeZhbk4G64u74w/2nb+hFf2IIXxEjKRvct6KXd+sR09
         asisz1czuLqikXWF0szxr+ICfy6t/nsaNrHaQcborVBScqTG078xi4JF3YwwnYaUwI8S
         6okA==
X-Forwarded-Encrypted: i=1; AJvYcCWOQ23ksv/mkGJt5PqcSwHECWbuQkwBTI+x3B+zq9uR5OcA1SPehBhA0ME+jWYKdzNhWPhd88Z+BWw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFiuzd20MdDCed+NWY574hKGXLAvqrc85YIUAKFSgEdJ44KTB4
	J1xMM5mJiSwumqvSYwxOaZRpzcrjIdfsaYwCQo/8FzqdKQ3gVB/8UwKC
X-Gm-Gg: ASbGncungOsBVMDFSQsGYnERLLbBs1JLZS9oIh/J0Gg7TyqF9v/bVYGTcNKvsXNbyhk
	B8KgTl37+kSqNE1J8Qwu7/aI0xP93V75BBZ+krxUBYenKZQdQHSz5UdcQP0L6GqSOmrHRFTVcYz
	epKeg35UJ0Hmpepja5/LPz6wLSqYPD9XtOsRg/DHerUUSt8JuznStYudb80iB3S13nTfdDgs0AA
	wFOlUjSa7tyBDUjD0e6GrjHrQPzMmLonzolU2R0l36et/XqJDdw1OuLzf9GycGxcW2tuy0CpLAF
	CzSAn8cXDZJRMO9socXX4f4H1jSqkTzmT0sUE8oLTfTaxLoWTgIL77EdV77Kuv0PIIKjoIPArYq
	/s4amwq6L6GxpkLtQbnh5bFlh7HSRcfkclyd0u+Z4PDVRJeOq
X-Google-Smtp-Source: AGHT+IFgIIl1rPGc21eAT8naPz071UhBkST8ixc2RolNH6OJ4L9deyZJbJu4MjaCN5pTwkxEVsJ2zA==
X-Received: by 2002:a17:90b:1808:b0:32d:4187:7bc8 with SMTP id 98e67ed59e1d1-3342a2b11acmr5934143a91.27.1758846582994;
        Thu, 25 Sep 2025 17:29:42 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3347472e49esm3605217a91.21.2025.09.25.17.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 17:29:42 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	miklos@szeredi.hu
Cc: djwong@kernel.org,
	hch@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-block@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v5 12/14] fuse: use iomap for read_folio
Date: Thu, 25 Sep 2025 17:26:07 -0700
Message-ID: <20250926002609.1302233-13-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250926002609.1302233-1-joannelkoong@gmail.com>
References: <20250926002609.1302233-1-joannelkoong@gmail.com>
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
 fs/fuse/file.c | 80 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 56 insertions(+), 24 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4adcf09d4b01..db93c83ee4a3 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -828,23 +828,69 @@ static int fuse_do_readfolio(struct file *file, struct folio *folio,
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
@@ -1394,20 +1440,6 @@ static const struct iomap_write_ops fuse_iomap_write_ops = {
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

