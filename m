Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDAC3659E7;
	Mon,  9 Mar 2026 19:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084289; cv=none; b=J4FPdjt0HsLhNqxy/aL68GtfJxyppO9N2Z6z9XKPQ88ptOln83CVHX20BSWeihO2GxZXKD6xJRMLuerTnnBEfzVOdtMmIvS8ZRXgp/pi80jo8erWZ0Wx17L81B5cCsCDnuNAObGpCS4rymwzWY1IktcUcDChHke72v+FlRP8y1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084289; c=relaxed/simple;
	bh=etGIrqcNXIU4r5QxlQePtDsAPSree6HNQOZ2b+h8++Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5qCY+LjgRKeEknwK2ynPAbdTJoR0K03YDJ2Wz8DYoC5TcuqvrRmPQEwGfHTf5lmnDmqpS2maUVO8YrQ2p6stJ/dbA+l2/CAYP2XZYebi5+iK5qzKevs7nZARFDKEmIMF2Mb498zfK3mkiyZ/sq4CQXjsk7AGgli0R8DBKPmpOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vGtE4aaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vGtE4aaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEFAC2BC9E;
	Mon,  9 Mar 2026 19:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084289;
	bh=etGIrqcNXIU4r5QxlQePtDsAPSree6HNQOZ2b+h8++Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGtE4aaJ+XU17c/DS6suD3WEue3n1zyHY43O6eGaKy4PWb9PVLzA2tg6kMO/HI1j2
	 kKecN+CZ3PhSQ4aqgXnIdDF90Q9/o0h0nHZy26rUD30ErqPcNrlyeLQ53o4WiudZgt
	 fbfk3IQt1GBai42Y810IvQx7Yxqog0Br4Ur4Q9z8lCK/XL4ExNUxXCOTTWN2xC7R0j
	 DAKY+Mj1niQbe6tELn2Wsy6duOLqEvYLwLIGOJZiBTLlccfD45ylIJj4bI2sFTU2IP
	 4GtuXNykXcvogaZ9pfc6Ss1ifcWKkvRnQyd3CEncU0g8jRS96Pu8fO3+q1P39zHb0P
	 aJyhQt7QaLyoQ==
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
Subject: [PATCH v4 11/25] iomap: introduce iomap_fsverity_write() for writing fsverity metadata
Date: Mon,  9 Mar 2026 20:23:26 +0100
Message-ID: <20260309192355.176980-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260309192355.176980-1-aalbersh@kernel.org>
References: <20260309192355.176980-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is just a wrapper around iomap_file_buffered_write() to create
necessary iterator over metadata.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 25 +++++++++++++++++++++++++
 include/linux/iomap.h  |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 31e39ab93a2e..88fe4723bb22 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1259,6 +1259,31 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
+ssize_t iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
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
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iomap_fsverity_write);
+
 static void iomap_write_delalloc_ifs_punch(struct inode *inode,
 		struct folio *folio, loff_t start_byte, loff_t end_byte,
 		struct iomap *iomap, iomap_punch_t punch)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 89e5a7abc012..844fc8414363 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -356,6 +356,9 @@ static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops,
 		const struct iomap_write_ops *write_ops, void *private);
+ssize_t iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
+		const void *buf, const struct iomap_ops *ops,
+		const struct iomap_write_ops *write_ops);
 void iomap_read_folio(const struct iomap_ops *ops,
 		struct iomap_read_folio_ctx *ctx, void *private);
 void iomap_readahead(const struct iomap_ops *ops,
-- 
2.51.2

