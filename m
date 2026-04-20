Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2E839E190;
	Mon, 20 Apr 2026 11:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776685682; cv=none; b=HOV2AtewtDSZZgEu2FxbH+L7yWmaPMnr4/CGW4ewbxp2W6F2n/M41l0xA8Y1t71FQ8vhhNHdrQ8lr+mtumWJQTA3GiB1/xhCl8e9HEdkPgclHdl+YQ+Ouf2TZmtWjZE5XwU9LtKRXhFgXDNlUzilcaEFwuFs1eOtIVjeTatveAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776685682; c=relaxed/simple;
	bh=5p8RSIL/qqpPyP2Ea+WCebFmPMKr9xGnDDmczm8lq+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkEdpTnndYSjC0v+lmM545B2tjTr4YCIh1tJHE0dBq47ZE2l3/etk1i8CX6l68Zln6GtQiXRsnVzgj1rN8BhkC3xmoTD2Qbn6jKFvoA1ni+uukMPzcd4EQNkF6riq0+E45gSKORkRWkiSZusixz2sCNzVD92DKgHoGxq92UEDfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKejZjbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKejZjbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B77C19425;
	Mon, 20 Apr 2026 11:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776685682;
	bh=5p8RSIL/qqpPyP2Ea+WCebFmPMKr9xGnDDmczm8lq+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKejZjbdY4Xt9bsYb1u+5N+ij3J3IwSXPRp1BYh4RUh8I5qkaylO1q2dT4Uy5IWd4
	 8Qol0fNFAGsFJELryHepTKzg0mabjNnQluCr+VKAN40pAxm1O+XwvCg6EHUmYFTjc6
	 5WYbGJqneMBE4dw9Dao1LacVX9I5mTqtAZEAzzGJcYT7VqCRqP5tNPRK9z51DJieIU
	 BFbbzkyQgn/+FkpcSH/2MRiCZL0EyRggyeYiZPMaLf5ftmOLQKS6A5wtjRij9wFjt1
	 43Ck/F1tdZgA53yGVtVxkFQwrjYs578M4VEB9i1oMYzFTDlWIPn/7PYhN6KmuF6sSJ
	 AOw/JdMFbugNg==
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
Subject: [PATCH v8 09/22] iomap: introduce iomap_fsverity_write() for writing fsverity metadata
Date: Mon, 20 Apr 2026 13:46:56 +0200
Message-ID: <20260420114714.1621982-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260420114714.1621982-1-aalbersh@kernel.org>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
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

