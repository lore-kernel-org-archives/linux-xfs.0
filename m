Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E62B182A2
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D9eZc7RV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MnEk4kJaE+n+b3v1j4i9S3VKDanv67ejVN4lnTe2Pcw=; b=D9eZc7RVxxXXOXkgoj7zZ58Fl0
	jMw2mz7+rfptKsKGD2aMtn4h2BUSroL0SOyvQ/wIomLgwWbFAlMztnWTc0uKonXjwdsaB3ObGgJW1
	hvFV+kBeNG78FsfdgR9MYcsJFW9ssjZRpVhKYz/54DGPEF53EfXnSnl/VO+vZ/vRrR+fi9m5Er8W6
	JWo3lelBuE2aKxAETb4bvr+f+lyoSO0Pw6asoiRKV/gaasS256KHO2aMX5jYNBWPg0JUl7w1bhHSH
	q/QnhPhcZPaClOC8i3T5qgcJ+N4L/tl4GbrVW3otEMtx6boSodtS7BsbP8ro8gr/p81k9i0f/jJe/
	hSkg/fEg==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwoi-00A6WW-1d;
	Wed, 03 Jan 2024 08:41:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/15] shmem: move the shmem_mapping assert into shmem_get_folio_gfp
Date: Wed,  3 Jan 2024 08:41:12 +0000
Message-Id: <20240103084126.513354-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103084126.513354-1-hch@lst.de>
References: <20240103084126.513354-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the check that the inode really is a shmemfs one from
shmem_read_folio_gfp to shmem_get_folio_gfp given that shmem_get_folio
can also be called from outside of shmem.c.  Also turn it into a
WARN_ON_ONCE and error return instead of BUG_ON to be less severe.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/shmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 91e2620148b2f6..3349df6d4e0360 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1951,6 +1951,9 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	int error;
 	bool alloced;
 
+	if (WARN_ON_ONCE(!shmem_mapping(inode->i_mapping)))
+		return -EINVAL;
+
 	if (index > (MAX_LFS_FILESIZE >> PAGE_SHIFT))
 		return -EFBIG;
 repeat:
@@ -4895,7 +4898,6 @@ struct folio *shmem_read_folio_gfp(struct address_space *mapping,
 	struct folio *folio;
 	int error;
 
-	BUG_ON(!shmem_mapping(mapping));
 	error = shmem_get_folio_gfp(inode, index, &folio, SGP_CACHE,
 				    gfp, NULL, NULL);
 	if (error)
-- 
2.39.2

