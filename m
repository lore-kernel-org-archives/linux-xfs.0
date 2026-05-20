Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400583E1689;
	Wed, 20 May 2026 12:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280672; cv=none; b=qJIWoPVTMzTq7u92AsmFkjH07hHNBn8JcgTBsf9UQ8KKW0Vd04JcKxWyE5cECBbSLkrQhs12fVGioJawuuKtgOuAtkHYVMqhzuvNDm/eN/f/bQnURtt2P38UDY4QWXSyHV2PYlSOTKjipg2YZV7+brF5HmUE2fQiuoiZRaES1xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280672; c=relaxed/simple;
	bh=1YGKwRWSwDpwL0zPksrmqnNVlgXD5DrMzp6PtbmNMqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaZ9WPnlE1UMiSzJewrdWSbWCA2iQPT0kO38qzxRJv0eLAlPMJE52R4LppkK51xNhuGYdoXNVFguwlbo9UyqVc/3YniF7/PyOL2rI1sOU2Pqjjccw7k+jkfs7oMYBYWoMF5SGEmJ7WibuVfdNWHpwaeXtetD6hpmcncrGTPgchc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZW53TEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZW53TEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C1E1F000E9;
	Wed, 20 May 2026 12:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280670;
	bh=HzdcyfQPNerVORYm1bBgmiQ6yYyGFk9EgoKl05CxMyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZW53TEQcamrcSJeuP8xVdiBhGLi/o/4IHVdtbH4S3GGk9uYKEMn8PGxsZ8JDjwgn
	 svt/50otd+fBBnsYluQwsOVExQjhfwh87goTxxAAIkX3jFm7jyy5fuqFHerrTbrGlJ
	 RRNtIc14qmEs0C/H8JZjiko2Z5mnS+6ZBSrJT6ys7OwgLMBYsl+dwMasPZwaLkepzf
	 lV8nVOeYm+2T5j86bI6ml2JFF4erDNAlgcHbGGoTGOY4zwE824nJoh+C1NxOfwbNVf
	 WxOYYe0PWHaun2sK0+sWPfC4GxtN52NCxGFf3+XMmlUhLPwmXlQ9oAv/CNVWvXV/td
	 50H+T+3xztDpA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v10 09/22] iomap: introduce iomap_fsverity_write() for writing fsverity metadata
Date: Wed, 20 May 2026 14:37:07 +0200
Message-ID: <20260520123722.405752-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
References: <20260520123722.405752-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is just a wrapper around iomap_file_buffered_write() to create
necessary iterator over metadata.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 25 +++++++++++++++++++++++++
 include/linux/iomap.h  |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 1c66a1c362a7..eed646d7eb48 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1287,6 +1287,31 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
+int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
+		const void *buf, const struct iomap_ops *ops,
+		const struct iomap_write_ops *write_ops)
+{
+	int			ret;
+	struct iov_iter		iiter;
+	struct kvec		kvec = {
+		.iov_base	= (void *)buf,
+		.iov_len	= length,
+	};
+	struct kiocb		iocb = {
+		.ki_filp	= file,
+		.ki_ioprio	= get_current_ioprio(),
+		.ki_pos		= pos,
+	};
+
+	iov_iter_kvec(&iiter, WRITE, &kvec, 1, length);
+
+	ret = iomap_file_buffered_write(&iocb, &iiter, ops, write_ops, NULL);
+	if (ret < 0)
+		return ret;
+	return ret == length ? 0 : -EIO;
+}
+EXPORT_SYMBOL_GPL(iomap_fsverity_write);
+
 static void iomap_write_delalloc_ifs_punch(struct inode *inode,
 		struct folio *folio, loff_t start_byte, loff_t end_byte,
 		struct iomap *iomap, iomap_punch_t punch)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 94afe4e170d0..5517bd9622ca 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -359,6 +359,9 @@ static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops,
 		const struct iomap_write_ops *write_ops, void *private);
+int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
+		const void *buf, const struct iomap_ops *ops,
+		const struct iomap_write_ops *write_ops);
 void iomap_read_folio(const struct iomap_ops *ops,
 		struct iomap_read_folio_ctx *ctx, void *private);
 void iomap_readahead(const struct iomap_ops *ops,
-- 
2.51.2

