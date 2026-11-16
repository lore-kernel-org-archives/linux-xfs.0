Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819576;
	b=WLo9K/EQBWzR+91rj+lEKsRgq3/wQGLv7hxchnxVsInzeqbESQSAirpCJoLmow7kuYQj
	 B+b+6iacxoq8jxDzacrFbVaf5wjDtbYRgTHOljzN3hMLR7My+nZSUW02FnuYkNAz5X3x4
	 dw0FzzxPRs9FxnL3C+CQk8f/oyVfm8nVGIPejEFx9i/YZd8okfl9n0AmoUloZ4d9COngp
	 IzovP/2FP8uMQcvbkz3mXfjcuGbko3eAZ8s04ggBhDW9701JWy6qi1lAb1DzAoa4iVgm8
	 2ltVYc89Y9MKuBYB/+gAtda1kvpjV5Z07Qxd/sPvpj3k6VC+/TbinzMnyOf7heCwZBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819576;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=b7ZdXuD7hYFi8N2LU3QII+o11sPre2+sYCqft4uoaY0=;
	b=4Tl964OBanGdDwELOR0qtLRXvOE4/er2Zwd7Y8zyLaQ2RvqjNN90mOoxfij5/kYbDhkA
	 1RCui2WdllySkjf2bPYP37Ts+rEFonQbjVktqFIZb2u8HU4JcmszOhYy3rNxVpgOR/auJ
	 vcbYTyVgL2Lb2s4ON4QRwL4TIAopkaV7T1BRui5yFWv/hS3FqBH4r2TphgjwgO9REAIFA
	 tX6Qc+x4IofpsyTchOcVs/narmXnJRFK7mybpC0Lfez+rLrl75eo041uGrgCZXoLdQHOq
	 08x7UFF13KstgkToHYJZ1PUX/WL8FOahjgnJL6oAWK4CKU6aa9IJk8SdCUCWmicex1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=DcqvghQX;
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEEC606A329;
	Mon, 16 Nov 2026 08:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FEEC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=DcqvghQX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=b7
	ZdXuD7hYFi8N2LU3QII+o11sPre2+sYCqft4uoaY0=; b=DcqvghQXrz4oyph2C/
	bZSL2mCUgYoIuhSxK1GXw93qsApHgKhjOTzX6ht5cPfp8jVe4dOiGwjx7VuP49aP
	FNgb+PhjnNtQfJSj0xqBtkmKJRLBzPd34Kp79WhPhLzFnR0K3bART5kqk1dUCOuu
	D1y2dvxF55xrS4WNE1r8ZcyVs=
Received: from czl-pc (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wAH5iLPxfpqqlTnHw--.59228S3;
	Mon, 16 Nov 2026 16:58:58 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 1/5] iomap: export iomap_bio_read_folio_range_sync()
Date: Mon, 16 Nov 2026 16:57:48 +0800
Message-ID: <20261116085752.3908082-2-chizhiling@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116085752.3908082-1-chizhiling@163.com>
References: <20261116085752.3908082-1-chizhiling@163.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAH5iLPxfpqqlTnHw--.59228S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxCF18Zw4UWF1xXF4fXr4DCFg_yoW5CrW8pF
	yqkF98Gr48Xr47W34DGFWDAayak398Jw48AFWUW39Iyan0yr47Ka4kK3WY9Fy5G3s7CF4x
	Zrn2934rCr15AF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U_GYJUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9xL+nGr6xdKT1wAA3E

From: Chi Zhiling <chizhiling@kylinos.cn>

Filesystems that provide a buffered write ->read_folio_range handler
need to perform the same synchronous bio read as the default handler.
Move the declaration of iomap_bio_read_folio_range_sync() from the
internal header to <linux/iomap.h>, together with the !CONFIG_BLOCK
fallback, and export it so that modular filesystems can call it.

exfat will call it from its own ->read_folio_range handler to zero
the stale bytes between valid_size and the end of the block under
the folio lock during buffered writes.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/iomap/bio.c        |  1 +
 fs/iomap/internal.h   | 12 ------------
 include/linux/iomap.h |  9 +++++++++
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 153b779949e9..1dddb33c51b2 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -147,3 +147,4 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
 	bio_uninit(&bio);
 	return error;
 }
+EXPORT_SYMBOL_GPL(iomap_bio_read_folio_range_sync);
diff --git a/fs/iomap/internal.h b/fs/iomap/internal.h
index 74e898b196dc..d13aff5e1e91 100644
--- a/fs/iomap/internal.h
+++ b/fs/iomap/internal.h
@@ -20,16 +20,4 @@ static inline size_t iomap_max_bio_size(const struct iomap *iomap)
 u32 iomap_finish_ioend_buffered_read(struct iomap_ioend *ioend);
 u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend);
 
-#ifdef CONFIG_BLOCK
-int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
-		struct folio *folio, loff_t pos, size_t len);
-#else
-static inline int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
-		struct folio *folio, loff_t pos, size_t len)
-{
-	WARN_ON_ONCE(1);
-	return -EIO;
-}
-#endif /* CONFIG_BLOCK */
-
 #endif /* _IOMAP_INTERNAL_H */
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 59718f73c15a..7b7ace3e1a35 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -799,6 +799,8 @@ extern struct bio_set iomap_ioend_bioset;
 #ifdef CONFIG_BLOCK
 int iomap_bio_read_folio_range(const struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx, size_t plen);
+int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
+		struct folio *folio, loff_t pos, size_t len);
 void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx, bio_end_io_t end_io);
 
@@ -825,6 +827,13 @@ static inline void iomap_bio_readahead(struct readahead_control *rac,
 
 	iomap_readahead(ops, &ctx, NULL);
 }
+#else /* !CONFIG_BLOCK */
+static inline int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
+		struct folio *folio, loff_t pos, size_t len)
+{
+	WARN_ON_ONCE(1);
+	return -EIO;
+}
 #endif /* CONFIG_BLOCK */
 
 #endif /* LINUX_IOMAP_H */
-- 
2.53.0

