Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB3FBA39
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275756; cv=none; b=C7i1FwMOX/U8UIgLMYa4BwJP1UEBcCX7vzBYLZEDf+eOjspT5SERI4SKBV2IN3NXSqwEJuzYsmdVkaXlSIsiLuowoWwlVWeQjbnobMxD9Xsm0dyHq3otgvWwCgWDTPby1WQOT4d9kdvMSawJ7Mc4SHezSiM5CoDz//qRh4H+rvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275756; c=relaxed/simple;
	bh=BUyG2cKXUw5lyv+vJg4pt6nhZcLuhIZva5lQVQm/gKo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cMjPok9rJf6I/gWSMe4/yQWnYKmpaytnLas8U7uWDOJs7LNb1K5Fsn70rTZ/90ef6S0MHUHz9xNnwVp/adwDdPbhNApvCJtlOxZwZrIZl5/GbQGAeAwQG6hdVoRabMOQ7Z0oNOtp7C6A7ZSCcbtEUMUEBl38IuQ/AP4K3XhH4UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vCE7GgAB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vCE7GgAB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=owr/vlw+gG+D7l+zahUOl4d4YuUBj7TuMNS/fLNtya0=; b=vCE7GgABB7RKVc1xXrUquxSSXo
	Tm+y/gatJCRztthVwTFX3SDm2qMdDX0H9Thx0vNKqlDHrYiujhIH01vgp8bPJnMONQLQtpo0i6vgv
	x1yYUuD9Ot9Y1TKfMA5v/DA5EVQqQheYxTNJqa5WwdSY6AEMsWVdj3o0LFDp8Ua8w0z0EzQZ0iggj
	AmfKZ5m4Wh5/BXsHh9PDc+zQbJR/WBnxBWhK57cN00I4ZU3vuQC/1GjPVOe8L9nxGd/uO3Bb4/Iij
	HVf+QMAqRxy2vhFzbk1LGoP1mEKMcN3fqwMDJbkcNcszTPMwEg6HDROIvSZx558PCexj78+7vTL/G
	lW15wIiQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMGe-00000004Ca1-0B1C;
	Fri, 26 Jan 2024 13:29:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/21] mm: move mapping_set_update out of <linux/swap.h>
Date: Fri, 26 Jan 2024 14:28:43 +0100
Message-Id: <20240126132903.2700077-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240126132903.2700077-1-hch@lst.de>
References: <20240126132903.2700077-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

mapping_set_update is only used inside mm/.  Move mapping_set_update to
mm/internal.h and turn it into an inline function instead of a macro.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/swap.h | 10 ----------
 mm/filemap.c         |  9 +++++++++
 mm/internal.h        |  4 ++++
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4db00ddad26169..755fc64ba48ded 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -350,16 +350,6 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg);
 void workingset_refault(struct folio *folio, void *shadow);
 void workingset_activation(struct folio *folio);
 
-/* Only track the nodes of mappings with shadow entries */
-void workingset_update_node(struct xa_node *node);
-extern struct list_lru shadow_nodes;
-#define mapping_set_update(xas, mapping) do {				\
-	if (!dax_mapping(mapping) && !shmem_mapping(mapping)) {		\
-		xas_set_update(xas, workingset_update_node);		\
-		xas_set_lru(xas, &shadow_nodes);			\
-	}								\
-} while (0)
-
 /* linux/mm/page_alloc.c */
 extern unsigned long totalreserve_pages;
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 750e779c23db74..6c8b089f00d26a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -124,6 +124,15 @@
  *    ->private_lock		(zap_pte_range->block_dirty_folio)
  */
 
+static void mapping_set_update(struct xa_state *xas,
+		struct address_space *mapping)
+{
+	if (dax_mapping(mapping) || shmem_mapping(mapping))
+		return;
+	xas_set_update(xas, workingset_update_node);
+	xas_set_lru(xas, &shadow_nodes);
+}
+
 static void page_cache_delete(struct address_space *mapping,
 				   struct folio *folio, void *shadow)
 {
diff --git a/mm/internal.h b/mm/internal.h
index f309a010d50fb6..4398f572485f00 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1266,4 +1266,8 @@ static inline void shrinker_debugfs_remove(struct dentry *debugfs_entry,
 }
 #endif /* CONFIG_SHRINKER_DEBUG */
 
+/* Only track the nodes of mappings with shadow entries */
+void workingset_update_node(struct xa_node *node);
+extern struct list_lru shadow_nodes;
+
 #endif	/* __MM_INTERNAL_H */
-- 
2.39.2

