Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932482367DF
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 14:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761835796; cv=none; b=DjAQ0Y/9SDjNjlbMSANTgpc3aJPJfjruGiSSoHuMFn1kh8KIoVM64A7DPlApdFcl3sx3g412hAObVj4hrrlbll7ZIEl6/GYO4HGlfCxYzLSzak6mXuB3CYFOgfdaow1obCR1LxMOwWyckPj2serUZ4BLePhtdrnW08r9V17qEdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761835796; c=relaxed/simple;
	bh=8fROsvf2edthjPUztXqCykGkUBOO0818Re7mvMfWWY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkCKPIB0tt/vCNjCEotLQDL0TAhrXojirBFVHr2qnWaXaAG0yIe01ubKWYczsSXiVuG3ZWSeyRFNKRbzMtAPbMPlXUoHpFfwDrQlN+cCZioPzHtfa8xDXshZigtV9Smd1ZFr3U09MOSYiWYjTH6owSqcdMpFQcuggdikQ2lScRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K+NquV3V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K+NquV3V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YnPhJSvR7FHA7WHyjJJ9XlaqBixD4f15K6Co6rBh9wo=; b=K+NquV3VzzzGRhAnbeewYUJu39
	2nlGPROPQBWW7QyBGXakaLek4/sk96B31my79kKf0pk7AHxu2OcN/E8HUI7wtv5At8IW+gBg2jxZj
	bB6pZP+hYuq4S2aQ76fTj3Hheh3sKgOfljOzdoFeAM7YJ8NVILrFYyjuuLZgtHwd12no6bG8BP07e
	62EdpumF8PbbFYh2Ph8qZhYRFW6fM56EyVxqIJ7mhn7w8a2NoLkwPfo+kKU+5yRMmM2gukmodcxGF
	50/0s/PBkpq2Wo3zPH1KqZcVfKZFV7Loql360AJdEVkRpY3Uas5siKP0g/GpM4iY4QE/jQvBgfwct
	d29IEsVA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vETyL-00000004KNO-3Cuy;
	Thu, 30 Oct 2025 14:49:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 02/10] xfs: set lv_bytes in xlog_write_one_vec
Date: Thu, 30 Oct 2025 15:49:12 +0100
Message-ID: <20251030144946.1372887-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030144946.1372887-1-hch@lst.de>
References: <20251030144946.1372887-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

lv_bytes is mostly just use by the CIL code, but has crept into the
low-level log writing code to decide on a full or partial iclog
write.  Ensure it is valid even for the special log writes that don't
go through the CIL by initializing it in xlog_write_one_vec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ed83a0e3578e..382c55f4d8d2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -858,14 +858,15 @@ xlog_write_one_vec(
 	struct xfs_log_vec	lv = {
 		.lv_niovecs	= 1,
 		.lv_iovecp	= reg,
+		.lv_bytes	= reg->i_len,
 	};
 	LIST_HEAD		(lv_chain);
 
 	/* account for space used by record data */
-	ticket->t_curr_res -= reg->i_len;
+	ticket->t_curr_res -= lv.lv_bytes;
 
 	list_add(&lv.lv_list, &lv_chain);
-	return xlog_write(log, ctx, &lv_chain, ticket, reg->i_len);
+	return xlog_write(log, ctx, &lv_chain, ticket, lv.lv_bytes);
 }
 
 /*
-- 
2.47.3

