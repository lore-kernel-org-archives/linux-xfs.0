Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA68A46F49C;
	Tue, 21 Jul 2026 18:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659450; cv=none; b=G5ddfUKYproq4pwiL91vjho4ql8zVDWwwSqBDucgdTNJ2Gki0Quunq61FDfTtCQQ1wKzS63mPHkbosexL3FUKFMXzaKSbfx/uHwImFLtZdFWLCet80ZBXwGTH44QlZCwC1ASKmmU4Cghd4Dta2wAav3uy7yObB0vNIhTVt6C514=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659450; c=relaxed/simple;
	bh=/lEimu60ir8h89TDAJlmJ5NfBTPDNjM3BayXCl0gkW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5NBkTR9WEVcmI2YPnlGb8017MftC9uZKImy2yz4e0FCuvhQ5vgGU1Z7PA1pA0W4qyLLX2D7F2hKjuu1EaTvv19AQr0VWbBORITONS4uPiQ6Fxtjf57AVA3cvPZjAj3kRzEqR3wk6yGO4pycAS+8D7V4NhJQqFBDIAabVHSfyro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fSj+A8th; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fSj+A8th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCC41F00A3E;
	Tue, 21 Jul 2026 18:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659449;
	bh=o9yINbcuiiybi8O3LP5dR8y/qvFNadlQFmrpMBfoyMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fSj+A8thaY94a8iuY+JDh+LoPKx340k86jg2tC+sJdB9HB9863X+QFL5nXUfXml2Z
	 p3JIakyKGoM3haTusZHHQr90T+wyK1MR7X2gbsHGCyMESLR84Ut+qxSS1sNoK2UXTp
	 I+HWQQXNgWit/unYoPC8QULB6r5U6JSTvcQaZ3vrUj0GjXQthZibLIwiPo2Vqe4yzR
	 CyssNBI3NXux+D+YuoyqTlD4gwRwT+dCErBJgjUSTT4FVkgn8YTKn+4wUtS3xknJAK
	 A7RSwviYa+KEMa1e3InWJ6oyUavFQnNwq6aaxqpT4QPzUP91QUUyoYyzh5tj6ZVl4+
	 JhDXlFF3J07zw==
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
Subject: [PATCH v13 05/23] fsverity: improve flushing performance of fsverity_fill_zerohash
Date: Tue, 21 Jul 2026 20:40:42 +0200
Message-ID: <20260721184346.416657-6-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current version calls flush_dcache_folio(), in memcpy_to_folio(), to
flush whole folio on every digest (which is 128 for 4k). Open code folio
mapping and flushing to copy all digests at once.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/linux-fsdevel/20260401222717.GH2466@quark/
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/verity/pagecache.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/verity/pagecache.c b/fs/verity/pagecache.c
index 9d82e6b74ba1..270abd652e48 100644
--- a/fs/verity/pagecache.c
+++ b/fs/verity/pagecache.c
@@ -68,14 +68,32 @@ EXPORT_SYMBOL_GPL(generic_readahead_merkle_tree);
 void fsverity_fill_zerohash(struct folio *folio, size_t offset, size_t len,
 			      struct fsverity_info *vi)
 {
-	size_t off = offset;
+	void *vaddr;
+	void *to;
+	size_t chunk;
 
 	WARN_ON_ONCE(!IS_ALIGNED(offset, vi->tree_params.digest_size));
 	WARN_ON_ONCE(!IS_ALIGNED(len, vi->tree_params.digest_size));
+	WARN_ON_ONCE(offset + len > folio_size(folio));
 
-	for (; off < (offset + len); off += vi->tree_params.digest_size)
-		memcpy_to_folio(folio, off, vi->tree_params.zero_digest,
+	do {
+		vaddr = kmap_local_folio(folio, offset);
+		chunk = len;
+		to = vaddr;
+
+		if (folio_test_partial_kmap(folio) &&
+		    chunk > PAGE_SIZE - offset_in_page(offset))
+			chunk = PAGE_SIZE - offset_in_page(offset);
+		for (; to < (vaddr + chunk); to += vi->tree_params.digest_size)
+			memcpy(to, vi->tree_params.zero_digest,
 				vi->tree_params.digest_size);
+		kunmap_local(vaddr);
+
+		offset += chunk;
+		len -= chunk;
+	} while (len > 0);
+
+	flush_dcache_folio(folio);
 }
 EXPORT_SYMBOL_GPL(fsverity_fill_zerohash);
 
-- 
2.54.0

