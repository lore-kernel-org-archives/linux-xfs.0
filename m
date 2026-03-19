Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC213ED5A2;
	Thu, 19 Mar 2026 17:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939789; cv=none; b=AdsLbZ8k8NHivT+s4tRaVkP06clBDYGOBJRxJm/O8aPExgtc8YxF9XJu9yaWzsC3Mr51v/CvwUChrcR1e04Xx8z7kS8GU2sGomuR1oO/YN4hfPudk9gjn0lDwSeTdI3DEMsf3EI+E2LhFCVBKHeD9FT4f5az+rO7ZhruvRiFJu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939789; c=relaxed/simple;
	bh=XHG/nRI8Rqp13Qzi1VFGPdLdeT/dxqtSoBYoQC8fRVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkbhLpOph84WJK59qCWqDgDyiAlKTGYOf++a/HsLbPiVZonT9Kyqb8c7WVvSrSI0dhhr+DvsUoRLfJFSYFt+bq9U4Uh90btb29SzyvYLdxrL+XkHj/w5pQaDnWX69sK97w799yMD+CabKlDIr90O0QJNSUxZgvZanE4tuw2blh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wkokxi00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wkokxi00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC33C19425;
	Thu, 19 Mar 2026 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939789;
	bh=XHG/nRI8Rqp13Qzi1VFGPdLdeT/dxqtSoBYoQC8fRVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wkokxi00h8MaDgOvlIpprD8/nP3r5IDMESpXcSPv0U0uQylR8rCAKoZ16c0tnhg7j
	 kHgfe7+KoccmS4AANBWjYMfLss/PpYNsmGs61HOo6NC4GtAyMnfXfMnfHcEbF0YNCK
	 fZU3QUP0bl6j8Id1W+gJPZAzF0W+ArPkraJheC8M0QAnHZi+ihUcQr6nmdTNTl9DXq
	 ol19nz859tYy3ctyZKRRQlmS9ZRhcRdaPi2icZVrjo9MaHIzDR7RLEpqgREsSSQBCl
	 3Xyyj/D8ZrBFEjSyTDUsRDH4DiQ6a/PFXwzhhSRAvTdl/BAT0T+G4q761+w0ngkhAR
	 Ek6nXOqTDD5OQ==
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
Subject: [PATCH v5 11/25] iomap: introduce iomap_fsverity_write() for writing fsverity metadata
Date: Thu, 19 Mar 2026 18:01:58 +0100
Message-ID: <20260319170231.1455553-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
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
index fce748dfb2cf..9836fb64720d 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1272,6 +1272,31 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
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
index 89e5a7abc012..4ac1440868fe 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -356,6 +356,9 @@ static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
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

