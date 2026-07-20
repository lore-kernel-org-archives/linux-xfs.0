Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE133D25C5;
	Mon, 20 Jul 2026 09:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538310; cv=none; b=XQ2kkiK1SRJGyI4mtMMHTQULGpXdgIXsz/0lP3T/ae5s9LlC9WIWDm9mmRYwk3eWbR/sCw5ntlgKa5aoYXKcICluc9nmZgvKILLGnQgk9U4sPoVrswcRxlR6A5zdmehaHp2tGdSjo9VVUL/O1DwRgQ5gT6pvoOUQWRKvOiil4W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538310; c=relaxed/simple;
	bh=/lEimu60ir8h89TDAJlmJ5NfBTPDNjM3BayXCl0gkW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzNVMcL8kxBLqZ+QxAX16WCq5xkbdhCxWPHlVDjiNRbmDd05FP/Gvnhaf/+mNBTNc2sHI1LsVPo5HzBYaHkP9Q2DSIIbzQ9zLRrxJNTE3MvlF45k0VvYbDI48GiSp2im1V1cc53m054PGSxjPjqHaXqgJXhjBqsQV32kU/Adhmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kE/B7BtT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kE/B7BtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DCC1F00A3A;
	Mon, 20 Jul 2026 09:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538309;
	bh=o9yINbcuiiybi8O3LP5dR8y/qvFNadlQFmrpMBfoyMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kE/B7BtT5RA5OSwwML9Uh1ggbU8mbnLRKE/1vCYVzYI8iXk86AAOz0QvQc7zVJnDp
	 hI2SkCJTyPtvkrw+fSA+7JQKdhBlRiCEE9UT3jFGPTZynp0MMWy/ywyYz5y3Wv4Gmh
	 FkPLOlvX+lv31fjSHb5x7XaBHH3twvf3LQ1Kmvqn66Emjqj9aMGQ1c0QRNUihoXiVq
	 WCnW4lujMoZeBOZEq9Cokj/Kb5CC1bGRSD2hcMm2dT7Dzsr+6rfEKWJXZ83SJM7ADH
	 I2FMwq1iAf7BnJmXFrh34kL1nAO5UFTkAbnwpHQPVXfrvH76memG5u1hgJ8rJi9uyP
	 Y4AFPPvi9UYQQ==
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
Subject: [PATCH v12 05/21] fsverity: improve flushing performance of fsverity_fill_zerohash
Date: Mon, 20 Jul 2026 11:03:33 +0200
Message-ID: <20260720090410.3487990-6-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720090410.3487990-1-aalbersh@kernel.org>
References: <20260720090410.3487990-1-aalbersh@kernel.org>
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

