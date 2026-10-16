Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D26534D4DE;
	Fri, 16 Oct 2026 03:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121696; cv=none; b=T1bktmRLj9gt/4ApIPP4rV2q3OyiLoJBrct0fgRMWWndDlRIHO9RRMqcs7cpK+xVEXsJlqTZJXjNPC49kiUHGa73rYE7aX/57lXDnCduP0b4KVyrjTOUK02vIwpwWBxEh9i8owPAqveHaIVfqAYCe1squOFxLXk9YtJhS8P+yL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121696; c=relaxed/simple;
	bh=GI4uW1biJCwRcv236sumjEXh9TE1xK13bLC45NlIVpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaAojr0MUR9f3udtkZ3UmGxzO/WTUhp+hv4HerMdqNvd/3GqlDbwONGSQkaWYc51sgcn0gEcsoBw5pxyt0DVrseqBu9oHE/0VkmOayK/NXCwWgdVokGew/5EZAEais0X+N2C2uZyTUs4kMJN3Ibf5932fD/kneUUKLPSlxowneI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Ct4RlcMp; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Ct4RlcMp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=JE
	ckqeMbM8QJx/dbwfWdJKJGqcYLg0iquPq0z23nLoM=; b=Ct4RlcMp5SjtBF2gWw
	j3o/3EHLBh+rkZFQCFMZ+sB9Hz59S9iF9jtOkPL+mJVs+bQJefWIPZPcolRZMWhv
	m4Nd3cWbcTR5vQP8vEhn954HwrBdsCysZtMk54mbJavh++GUIg4loyymFg64MVNq
	dvnbmFsGvII7/f568kCUHAihM=
Received: from czl-pc (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDnU5c7m9Fqw1V+AA--.15038S3;
	Fri, 16 Oct 2026 11:34:22 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v3 1/8] iomap: export iomap_bio_read_folio_range_sync()
Date: Fri, 16 Oct 2026 11:33:42 +0800
Message-ID: <20261016033349.3104509-2-chizhiling@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261016033349.3104509-1-chizhiling@163.com>
References: <20261016033349.3104509-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDnU5c7m9Fqw1V+AA--.15038S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxCF18Zw4UWF1xXw4rWFyxuFg_yoW5AF17pF
	yDKF98Gr48Xr47W34DGryDA3yakrW5Jr48AFWUW3sIy3Z0yr47Ka4kK3WY9Fy5G3s7CF4x
	ur1vv34rZr15AF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UtrchUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC2x4FomrRmz6AlgAA3q

From: Chi Zhiling <chizhiling@kylinos.cn>

Filesystems that provide a buffered write ->read_folio_range handler
need to perform the same synchronous bio read as the default handler.
Move the declaration of iomap_bio_read_folio_range_sync() from the
internal header to <linux/iomap.h>, together with the !CONFIG_BLOCK
fallback, and export it so that modular filesystems can call it.

exfat will call it from its own ->read_folio_range handler to zero
the stale bytes between valid_size and the end of the block under
the folio lock during buffered writes.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/iomap/bio.c        |  1 +
 fs/iomap/internal.h   | 12 ------------
 include/linux/iomap.h |  9 +++++++++
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 48100c614431..abb649f024a3 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -187,3 +187,4 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
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
index bc7ae6327dbf..35b686cbb586 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -763,6 +763,8 @@ extern struct bio_set iomap_ioend_bioset;
 #ifdef CONFIG_BLOCK
 int iomap_bio_read_folio_range(const struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx, size_t plen);
+int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
+		struct folio *folio, loff_t pos, size_t len);
 void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx, bio_end_io_t end_io);
 
@@ -789,6 +791,13 @@ static inline void iomap_bio_readahead(struct readahead_control *rac,
 
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

