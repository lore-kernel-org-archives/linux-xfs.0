Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A09200AC
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324061; cv=none; b=deXFzMbioNLKylAGm83QDWRANSy2NnnyvEODbYKssdQXwB0gtNx/J2dGpMWEn7WfeQro/OZu2JnKe81A+FEuvyhcSYklc6+POHzULUlD1q6NepKi9S4dGCA2bijleVeFAdUu8RVZMHOQdHHrICb2N79Lx9NJppVauYqwKRGRJEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324061; c=relaxed/simple;
	bh=xoLTLDPCHrurTKYVj2cWLZ34bq5bIliWgKrK8ARNZG4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EU93Iiy/bgDUha//fRgJDftmKrG+nAIxexNuM/CiSw/xNYN3nhQYV9xjCP80GdhYIkc4081AAmncSbLEciveYfXQdVzEdZvizjDTuiZs4pFlu8negZvAC+aatxIswByg8Jyh5ioHU0ER5mGxMDqdqGXIP7vEk8ZYnMsdtltDhhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wCSCFJdh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wCSCFJdh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PKxPHKzpQ4kwpuIEhYrsnVzQ37Gdt6u06KSfR24TJS0=; b=wCSCFJdhZ+pJGYDDB2gcwfsxyv
	DtHYc5mwCOcHLH6FBHeIpogSXZLO5pgQmclOZKqEof3kUHtHsfClwuGjkwXSSMADZ6vm1mDQ6LEGn
	ux1rXGEaynPi8UjoiYBcMmvRodaNcrtkLAwrv3omOM1tCDyB8aT5Y3h+LqEQSus9JZCjqBctqUrv2
	2+UGwLkTs7qEbBVZ4GrW+JdNQTzjJdpDMgDK3QDDasrwxOhNgSLNGRJM3xVfQKi3n6rxkhYf5CDv2
	6b1YubOqwKG2nX3KbvEWgkKQOIo3wbx6BE8TXo0XOj5buU17oLKM+MgtV/+r+QozoaoHw0NfhoQbf
	wygPpU9w==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx7p-00000009F79-0oF6;
	Mon, 19 Feb 2024 06:27:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 05/22] shmem: export shmem_get_folio
Date: Mon, 19 Feb 2024 07:27:13 +0100
Message-Id: <20240219062730.3031391-6-hch@lst.de>
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

Export shmem_get_folio as a slightly lower-level variant of
shmem_read_folio_gfp.  This will be useful for XFS xfile use cases
that want to pass SGP_NOALLOC or get a locked page, which the thin
shmem_read_folio_gfp wrapper can't provide.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 mm/shmem.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index ad533b2f0721a7..aeb1fd19ea3f72 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2137,12 +2137,32 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	return error;
 }
 
+/**
+ * shmem_get_folio - find, and lock a shmem folio.
+ * @inode:	inode to search
+ * @index:	the page index.
+ * @foliop:	pointer to the folio if found
+ * @sgp:	SGP_* flags to control behavior
+ *
+ * Looks up the page cache entry at @inode & @index.  If a folio is
+ * present, it is returned locked with an increased refcount.
+ *
+ * When no folio is found, the behavior depends on @sgp:
+ *  - for SGP_READ, *foliop is %NULL and 0 is returned
+ *  - for SGP_NOALLOC, *foliop is %NULL and -ENOENT is returned
+ *  - for all other flags a new folio is allocated, inserted into the
+ *    page cache and returned locked in @foliop.
+ *
+ * Context: May sleep.
+ * Return: 0 if successful, else a negative error code.
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

