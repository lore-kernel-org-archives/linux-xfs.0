Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC5D3A16A0;
	Thu,  9 Apr 2026 13:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740478; cv=none; b=ZFZF8XSr4Rrg6DRTyoUr+MztbfeN2/zqDgNWrt+aq9RZ/rsInuqjCQSl2m4kSbz/AJND15UwyW/DtSayp6puEsgCsSkPpypaErzPUjMVX31SLi3azqBlUtnwmq7B4LleU3IFoPmPBaGCT+HTURTzAHFIZNMj5nYfdbtROjyzrH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740478; c=relaxed/simple;
	bh=5p8RSIL/qqpPyP2Ea+WCebFmPMKr9xGnDDmczm8lq+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyFeEgqjh4EJh2BQQKvH/jr//HfVx4RHvggrgipV4syz6yAWDkCF0ATO/R4GCvpOpoFEaSHb6aIhjXV/cP188bK/EHMNDDO9RuUSRlPPWJvyBgKyeSvHjuRDcvnx96Nghd42SMOe4FhPLFw00u9D6ihDupAmCtN8G48wUob7oS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yy4RL3N1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yy4RL3N1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5ADC19424;
	Thu,  9 Apr 2026 13:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740477;
	bh=5p8RSIL/qqpPyP2Ea+WCebFmPMKr9xGnDDmczm8lq+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yy4RL3N14+WsWbEPHwDdbA+jrJw1UBUd0j/aGAW+Xe1/iyORdnKqMtlIrTHShZGwO
	 1WJ+tYMvGjyqW+Kzzbf+PNXt1VIs9f3HsWpJNNeuk/U7ciUtQIb81dxfmB6PUIRF7n
	 lLla8oshU/XVLuKMNgCxIHiYmrJVIXlQB1M3cA3V26UxWtaehEzXD85MHadzZCmWbr
	 BaM0h4MVFp6W7LjJEYGkqCe4jbOcGq0czGrOumZRSZ0BogZVsw+U0JqopYh0hQSjj0
	 eZGJVg//UcV9nNoeJ1WgivY+VOkXBRXqXGk2NhFfzqDLAq9pXQ1xTXeB1Y9J/7bHmw
	 yqDtMHQvpJEKg==
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
	djwong@kernel.org
Subject: [PATCH v7 09/22] iomap: introduce iomap_fsverity_write() for writing fsverity metadata
Date: Thu,  9 Apr 2026 15:13:41 +0200
Message-ID: <20260409131404.1545834-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260409131404.1545834-1-aalbersh@kernel.org>
References: <20260409131404.1545834-1-aalbersh@kernel.org>
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
index 843314852663..5c9fd925a62f 100644
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
index 4d9202cae29f..83586f09f365 100644
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

