Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC2F3AB498;
	Fri, 10 Jul 2026 08:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673621; cv=none; b=NoSSQWHc7BhMuqL7NiA3zfF2WswRwpUSA9lA1FDD+lMK1FPfrbD0DQUVu/egyYP0WU7mhD7rOzFYwy7DAVv4fuFhxlW9jRleX9/mp7v35gHSuuUfgvDI302rdXjGxL8xA+LzF+JDZxdKGA9BGeAYkKxwni/b4y6Yv+p0sz2v1BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673621; c=relaxed/simple;
	bh=/lEimu60ir8h89TDAJlmJ5NfBTPDNjM3BayXCl0gkW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tktXxn26YaXdvfAn658/r1sNASbEFhzNPlDJRp03kQEpVlW5XYUqloKUUi7Ce7chAYyRV4MUxA/lubbc46oVbFEARbtADU/Z3q/PzIkrbLel5gRuZ7GSmAEvXs/ztpoMHPOTKk+GZ8oq2zaRwHJjYi16qNHIdcYOv+uf5U67l/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iNZ3ljOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNZ3ljOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287201F000E9;
	Fri, 10 Jul 2026 08:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673619;
	bh=o9yINbcuiiybi8O3LP5dR8y/qvFNadlQFmrpMBfoyMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNZ3ljOBGURYaa0L6W/BRF5YJllyoNLJDGA/9tht4fljyIfaTRhv8BVpx8A5NHaRp
	 05qRpZzQExsrmCfBFUki1jJjgi7AEQx0ZDVNG9t+ZMdYps5BQp03IUTwM9CtO4ct/p
	 gLkF8EEThG19DKxLXwDtDMGx1+4C2SmAeeCEjfSM9AMAyKROMKa7cwtMJUFjw8UeyX
	 WDWgHpwi/D3MkwLaXblfqUePy7s64Q76rt4LZvJl/lMlUCXTu4XWEeRbUn79PsXRuN
	 POoNDahZivRGha9/Zp3RAXure/dshRqPdlpMe2hlBH4WGLi3tCnXmv8bkkHEekeToD
	 V0oA2Qo+Nfg4g==
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
Subject: [PATCH v11 05/20] fsverity: improve flushing performance of fsverity_fill_zerohash
Date: Fri, 10 Jul 2026 10:52:33 +0200
Message-ID: <20260710085256.3464201-6-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
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

