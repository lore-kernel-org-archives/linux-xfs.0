Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A67153517
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538927; cv=none; b=G010N3XdfdIoRI9+vASIaYK1k5LlFmxvx6t6xkkLEjyceLAFbZ4zXX8Bzn7ejz0P3kq0UA9C28G9dCiZhmwU65NiKzrVVKmBpkwssxZCELQgm2gUsAiGuSN765M8F6XyiXAb8nJT/3VoEji5y1iehNBipoV5/aot2XH82vLbMr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538927; c=relaxed/simple;
	bh=5qMjOYOcS077gMDjgabjLkqpM6WS0xZfJzxq+2IDdVs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a+y5iIJzRoCfTxJH93CwsmpDk8erHUYhWyE8hbCp9ylCs+BGdSICpWAnb2cSaPokZGmG2SxZV6YJHEh1nGcD7oI95fW0E/ihpxfQc97kuzSXU357lWO1E87zmmaIrzhmVfWjUh2fkmI3ejw8Md8Wjha9U0ZOm5dLhnxF0xrzE+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dm2yohlU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dm2yohlU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sbna0CyeYoAgz7SQMNzBd+8sEOvcwkV3+E75n3nY3SM=; b=dm2yohlUA04AgYc6fUHgyd5ApS
	VtMMvtDqA8FvbyJvysLCIpRSRY+5tRypYODRbJMUkg5khV4Q/nGnnhVRtD6qUkAuCLagjA/jIENrl
	Zswq/LPZAay+AGzBNV3i1JB3OTqiuljlb+39qmDPrhF5twhzzM2LghfudqIXsIkISWSXFkrmL2WqW
	JZEL1RXUQLFF0OphQkjfcPn81igW3bBhLA0W+FYUkq3kqb3wNdhbY2PZ7a5viAzLJnd7tMvIoUalI
	67M7TWNM979b6PEWzhM6kAf+Vo5QZpybOGg4fQ0CDo7KMKKx1epTdFPHPHRcJXcZ+3p0ask6+uJnB
	DxZS2doQ==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSjL-0000000D69v-0T0M;
	Mon, 29 Jan 2024 14:35:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 05/20] shmem: export shmem_get_folio
Date: Mon, 29 Jan 2024 15:34:47 +0100
Message-Id: <20240129143502.189370-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129143502.189370-1-hch@lst.de>
References: <20240129143502.189370-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Export shmem_get_folio as a slightly lower-level variant of
shmem_read_folio_gfp.  This will be useful for XFS xfile use cases
that want to pass SGP_NOALLOC or get a locked page, which the thin
shmem_read_folio_gfp wrapper can't provide.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 mm/shmem.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index ad533b2f0721a7..dae684cd3c99fb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2137,12 +2137,27 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	return error;
 }
 
+/**
+ * shmem_get_folio - find and get a reference to a shmem folio.
+ * @inode:	inode to search
+ * @index:	the page index.
+ * @foliop:	pointer to the found folio if one was found
+ * @sgp:	SGP_* flags to control behavior
+ *
+ * Looks up the page cache entry at @inode & @index.
+ *
+ * If this function returns a folio, it is returned with an increased refcount.
+ *
+ * Return: The found folio, %NULL if SGP_READ or SGP_NOALLOC was passed in @sgp
+ * and no folio was found at @index, or an ERR_PTR() otherwise.
+ */
 int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
 		enum sgp_type sgp)
 {
 	return shmem_get_folio_gfp(inode, index, foliop, sgp,
 			mapping_gfp_mask(inode->i_mapping), NULL, NULL);
 }
+EXPORT_SYMBOL_GPL(shmem_get_folio);
 
 /*
  * This is like autoremove_wake_function, but it removes the wait queue
-- 
2.39.2

