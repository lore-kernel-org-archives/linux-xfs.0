Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727DC200AE
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324051; cv=none; b=pPATeO7B1QkOsrH9Aqbmfrljqi0ayFPE3vjEsziCGc159IC4hsnETb/tjTQvPKlrn9xaMbZ7/mFPjktoGjNGiZ/cb0SBCorwMvZ71lMfeI+D5+dfDwoJB+XaKr/g4RH6Wxfr8yBZDToe94l6F+KUj5EaLxrWuJgRhvfeMcVuc2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324051; c=relaxed/simple;
	bh=SEYxslorzlltQcKJcVCUGxw1pyfAOqgouvc8HE45FBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GNQxRcRum/H1ZqscGdRDKuxaYzb7Lz8r84JawTlViESEwnENnHEnHsFPEssz+m6uE9ct9UaXP5tv8maGzqFxwVTIVjoSyvYICqWxfSSz1g0aSfcGmV0kqet1Wwpabp7L8QUETMM+dh1NyhOBY6qAlYH5+Ic+GkZjz2uIrRJEUEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o0EtrNd8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o0EtrNd8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IGlT4PlWbZpkcMxkrjhe0P1uDfgYrW+CfMT58/K5QjU=; b=o0EtrNd8SJNNdeLSG2ZNs0BML1
	OtsQZjSd8igrS57WzP6+ylJmDfLZoIRil/TiGd523WMu51mUeJnnUr2YDp8MS8grJZi/8K3WHBX1O
	Rhc8T0BGQDv6kdWEuCMQexZ2r0sDkavWcYLhDdHLdQmriWocYxMyI1+bvkK40ahrs4ezHEc/balS/
	fEa6djNPr4HxUqWvrQDP5fmjCZoMjeGhVzrWPFs7N6Gg2UVWKgjo9YK2822oqTizGQIE9hyyuQS9D
	Rb/xszANs5QziVLR9/uEVezp124zDmWqx2024qddTKXvW/3ZAkDZPGbOFydxTiGtYTIjZjdZgVNcW
	Sz4oarcw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx7f-00000009F5F-2FJX;
	Mon, 19 Feb 2024 06:27:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 01/22] mm: move mapping_set_update out of <linux/swap.h>
Date: Mon, 19 Feb 2024 07:27:09 +0100
Message-Id: <20240219062730.3031391-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219062730.3031391-1-hch@lst.de>
References: <20240219062730.3031391-1-hch@lst.de>
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
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/swap.h | 10 ----------
 mm/filemap.c         |  9 +++++++++
 mm/internal.h        |  4 ++++
 mm/workingset.c      |  1 +
 4 files changed, 14 insertions(+), 10 deletions(-)

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
diff --git a/mm/workingset.c b/mm/workingset.c
index 2260129743282d..f2a0ecaf708d76 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -16,6 +16,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include "internal.h"
 
 /*
  *		Double CLOCK lists
-- 
2.39.2

