Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9A742049D;
	Mon,  3 Aug 2026 20:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787762; cv=none; b=jHHHgIOaJ3qTE2oFOdNK35B7TQUmXzSBQP9txyVPFa8IQHfpIgQz7cOaYJ0Grl0/LF1aIz3xp1+BuXUE1vLeDsOQBLVrtIgYTBeB5GrfZQ/GTupJXDSfenGJafwgbc8vCJWnCGnMGb1SKpjjv1VYAFHEAcu0dOHbAAxLFoIX7Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787762; c=relaxed/simple;
	bh=vvBJkYxxOMUdxPQvRNWFjbdqDYu6ibnNDulSFIkVvYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVKn2kZhP3w+W4SB9x5LGfxNDTGVNlbnGSe6klk3/pV3qCLaI3e6GQ6LZpbvW74+r/WEGACe7r/RWk4/5UbyW9NTTQzQXtjF1zwDhXY+3Ocz4NGaPj4EJhJzBoxBfS3yCmHkR+NMJudjyTnz/5CmUFMeUwrOMTq9NJKNXcJmn0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X9Rcboru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X9Rcboru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D857C1F00A3E;
	Mon,  3 Aug 2026 20:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785787760;
	bh=1i5PkmN5JfVODQHHHlqnvp3yzz22XTSFm/6ynxgAmcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9RcboruTw2IJHtaxvhR10PRk1ivwDxJxgwv0N+FSASdMBEoiY9rL9eHwfZjRCyyv
	 XCSWXvwIHQRPvTl9ChdpPWuxi3x2M4LdSXGowQrRtaCtam9GKVfeg6pJ5ReoMtB7w0
	 H3I4zcCN2Z+yLIPv/9gncxf6GWL0cdTqL8bgJ0ZppzGa5MqIR9eco+VGdoz/ZeoYK6
	 Qphx9pdWt2eHMwaWKK78ODOc5OQhG53xHHsPoYrnhen5JWgdbM8g6gbMADxeG8pKYy
	 OtjgViViXYtZGEKEBOc1PzRQL3NiOBscsTcbZg6IzwsDAMZ2qpOpQ7Ahgp9MFzZMcf
	 aK0G+P1zuu2Gw==
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
Subject: [PATCH v14 05/21] fsverity: improve flushing performance of fsverity_fill_zerohash
Date: Mon,  3 Aug 2026 22:07:55 +0200
Message-ID: <20260803200820.393203-6-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260803200820.393203-1-aalbersh@kernel.org>
References: <20260803200820.393203-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current version calls flush_dcache_folio(), in memcpy_to_folio(), to
flush whole folio on every digest (which is 128 for 4k) on the HIGHMEM
systems. Open code folio mapping and flushing to copy all digests at
once.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/linux-fsdevel/20260401222717.GH2466@quark/
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/verity/pagecache.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/verity/pagecache.c b/fs/verity/pagecache.c
index 9d82e6b74ba1..911207dc0ef7 100644
--- a/fs/verity/pagecache.c
+++ b/fs/verity/pagecache.c
@@ -68,14 +68,38 @@ EXPORT_SYMBOL_GPL(generic_readahead_merkle_tree);
 void fsverity_fill_zerohash(struct folio *folio, size_t offset, size_t len,
 			      struct fsverity_info *vi)
 {
-	size_t off = offset;
+	size_t off;
 
 	WARN_ON_ONCE(!IS_ALIGNED(offset, vi->tree_params.digest_size));
 	WARN_ON_ONCE(!IS_ALIGNED(len, vi->tree_params.digest_size));
+#ifdef CONFIG_HIGHMEM
+	WARN_ON_ONCE(offset + len > folio_size(folio));
 
-	for (; off < (offset + len); off += vi->tree_params.digest_size)
+	do {
+		void *vaddr = kmap_local_folio(folio, offset);
+		void *to = vaddr;
+
+		off = len;
+
+		if (folio_test_partial_kmap(folio) &&
+		    off > PAGE_SIZE - offset_in_page(offset))
+			off = PAGE_SIZE - offset_in_page(offset);
+		for (; to < (vaddr + off); to += vi->tree_params.digest_size)
+			memcpy(to, vi->tree_params.zero_digest,
+				vi->tree_params.digest_size);
+		kunmap_local(vaddr);
+
+		offset += off;
+		len -= off;
+	} while (len > 0);
+
+	flush_dcache_folio(folio);
+#else
+	for (off = offset; off < (offset + len);
+			off += vi->tree_params.digest_size)
 		memcpy_to_folio(folio, off, vi->tree_params.zero_digest,
 				vi->tree_params.digest_size);
+#endif
 }
 EXPORT_SYMBOL_GPL(fsverity_fill_zerohash);
 
-- 
2.54.0

