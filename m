Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42678221FCF;
	Tue, 17 Feb 2026 23:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370436; cv=none; b=Kll6WhVY49LlfB+EfbDwYF/sLRwrdNsrtbcN+kzSK3KQMW8eT7Ct9vqHqZBOnWIxH/+RIUiqhRtimo/QF1taJJm92hVXjdhv6VuPYmwv3d7VelDB74Rhqt5EhoPtwxMN6J5USb7CFsGwotfXSyXdBE7SMD68ZNapYMlIEOtpyHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370436; c=relaxed/simple;
	bh=ly6gH551L/QHUDzLivTibvpnGeZLBHPv1gpPAD4EIvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcTpyM7kerl7zq87HoM2dgRjvYXMJZorA05nAORJMNYitcPYX6ysq+bkwX3sKUDGFA6BjxF+GvyftXpESkY/ZPeBlKru0OeEMbqvV1FsTchTt4C7XDOKWTYr1/GWOEiFTBccTkwJQwumo5esseftveZCo818AqKk19s7rPKjSDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IFqRITsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IFqRITsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E03C19423;
	Tue, 17 Feb 2026 23:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370435;
	bh=ly6gH551L/QHUDzLivTibvpnGeZLBHPv1gpPAD4EIvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFqRITsmDUcrLfnM8nEBOKi6DX2J4xh9IjfYyVIqG5pbVV0Kw7r1iUlxbp3bkjHQC
	 +cKewfkmJm5DfnQpQGq30j4P8lX0M5zbW28gQ6nmYR5TfxLaoxh9fIfn3nb3QCwBSW
	 HR4q6M9XcmkpXlHAKHR3ogxvlOseQ2ztJv0GhVn0BE1ZmdkJBEAEounPR29dfRxljy
	 vkP+D+6Msh1Aol9+Sp+xzMr2vkpS35jmT3Xn6KstZvB3Y5r0rRuNhaTlsw3DLS6rjX
	 pzHyYscpMTW1/1ouIqFHKrNRcP7lm34yMsulDvCyEFrGyQB44pwIZqkXXMYYLAk2cn
	 mAHvd5E4Nu2Bg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v3 01/35] fsverity: report validation errors back to the filesystem
Date: Wed, 18 Feb 2026 00:19:01 +0100
Message-ID: <20260217231937.1183679-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217231937.1183679-1-aalbersh@kernel.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Provide a new function call so that validation errors can be reported
back to the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/verity/verify.c              |  4 ++++
 include/linux/fsverity.h        | 14 ++++++++++++++
 include/trace/events/fsverity.h | 19 +++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 404ab68aaf9b..8f930b2ed9c0 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -312,6 +312,10 @@ static bool verify_data_block(struct fsverity_info *vi,
 		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
 		params->hash_alg->name, hsize,
 		level == 0 ? dblock->real_hash : real_hash);
+	trace_fsverity_file_corrupt(inode, data_pos, params->block_size);
+	if (inode->i_sb->s_vop->file_corrupt)
+		inode->i_sb->s_vop->file_corrupt(inode, data_pos,
+						 params->block_size);
 error:
 	for (; level > 0; level--) {
 		kunmap_local(hblocks[level - 1].addr);
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index fed91023bea9..d8b581e3ce48 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -132,6 +132,20 @@ struct fsverity_operations {
 	 */
 	int (*write_merkle_tree_block)(struct file *file, const void *buf,
 				       u64 pos, unsigned int size);
+
+	/**
+	 * Notify the filesystem that file data is corrupt.
+	 *
+	 * @inode: the inode being validated
+	 * @pos: the file position of the invalid data
+	 * @len: the length of the invalid data
+	 *
+	 * This function is called when fs-verity detects that a portion of a
+	 * file's data is inconsistent with the Merkle tree, or a Merkle tree
+	 * block needed to validate the data is inconsistent with the level
+	 * above it.
+	 */
+	void (*file_corrupt)(struct inode *inode, loff_t pos, size_t len);
 };
 
 #ifdef CONFIG_FS_VERITY
diff --git a/include/trace/events/fsverity.h b/include/trace/events/fsverity.h
index a8c52f21cbd5..0c842aaa4158 100644
--- a/include/trace/events/fsverity.h
+++ b/include/trace/events/fsverity.h
@@ -140,6 +140,25 @@ TRACE_EVENT(fsverity_verify_merkle_block,
 		__entry->hidx)
 );
 
+TRACE_EVENT(fsverity_file_corrupt,
+	TP_PROTO(const struct inode *inode, loff_t pos, size_t len),
+	TP_ARGS(inode, pos, len),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(loff_t, pos)
+		__field(size_t, len)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->pos = pos;
+		__entry->len = len;
+	),
+	TP_printk("ino %lu pos %llu len %zu",
+		(unsigned long) __entry->ino,
+		__entry->pos,
+		__entry->len)
+);
+
 #endif /* _TRACE_FSVERITY_H */
 
 /* This part must be outside protection */
-- 
2.51.2

