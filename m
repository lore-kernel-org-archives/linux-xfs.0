Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903584611CA;
	Tue, 31 Mar 2026 21:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992539; cv=none; b=ZUcxe3ajLjcGi2L3QsRVNEXvrg1THSFZ3DooPzYmoJUHCXYaHzvF0niPMwAXEm0HFLPX0HDhF9Kj7W81PXRtJZhPJ4lrzy313MaGkviNxxSYcaej28VOLnus+ZmM1wYI/BIRCbH6ptuz9Ojvd8c3TUey7FjgNCFliHBFCSfrV8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992539; c=relaxed/simple;
	bh=7Lj/a8CKiTN9mj7lNRCnK8QwMfszRCV4ywKWfTMkpjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGRRUVwGEYowTQhtHE43gC1f7v3xmk67dk99he0urF/8MQf5abd+cLKrX71eEyPMGU0ytDSN0Wpk9yzcBff6CKE44RmtBiFdwcBz1+pkN0BTubFZgcDL3QAEa3Z3w1rjjNuOt9crmpbu3Ci+9XR+2/wesOlfPhuCIpPLzmMjyFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5+PdM2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5+PdM2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0563FC2BCB2;
	Tue, 31 Mar 2026 21:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774992539;
	bh=7Lj/a8CKiTN9mj7lNRCnK8QwMfszRCV4ywKWfTMkpjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5+PdM2S8hqtB8kdmZqgcUUfhozKxOZo6xzAuHkaXy9WclvAC/xlVoFuSTjErl+0Z
	 RBbIcw+SwD2izQ3Kb4JefaLVknPYQAnsmZ1m2Q/aR5qNNRkLdOwf71oRahNNpi60zC
	 WDQrwsrAVz2ECnLsw6W8rall4qu00qoSOiD3Y1LK0UlvNdaWOAfGDyvhN6U8nepGTF
	 O5IrkSntdI+TSYstdsfLngfMxRqrUdZJWKxL9snXPCSgSOeYPzS90Kn0ie64tTVRij
	 1ihdqDNqg1J+zaNpFfXgsJWUqMtCLb63O4SZc4Gku7F0JiLaW4Pg/xp8ADNaeeNMDY
	 jhmGDWGrOXRKg==
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
Subject: [PATCH v6 08/22] iomap: introduce iomap_fsverity_write() for writing fsverity metadata
Date: Tue, 31 Mar 2026 23:28:09 +0200
Message-ID: <20260331212827.2631020-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260331212827.2631020-1-aalbersh@kernel.org>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
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
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 25 +++++++++++++++++++++++++
 include/linux/iomap.h  |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 7ac319618f8e..0f89225dc3d7 100644
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

