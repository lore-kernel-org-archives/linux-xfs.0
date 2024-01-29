Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9465115350F
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538924; cv=none; b=SritXeGGQaZxWGgmZu9IZ1JREsc7kmUsOGdRi+wIf2GqW8wuWKu0OPRrIE4OPAOISf2BV0aK1BuaR7i90PZ5z9pNEoEAsulpjxp1lNum5FM0qqEVME00hdhM2DqQ7TXlKiljywvXf+TVFOMW3S8TI03JkHERMb7zhmZj5UnKoG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538924; c=relaxed/simple;
	bh=asWyTZR5sM/RtofU9C1Ep424/hv8nEGWcp+XbhedjP8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RU54gc9CsbTeuzlb3siciuDYux8T38A1gXr+8zMb4kZU0ENOtwb3FXdWI/RU39Mg64WGb+YD9+BPqkPj76NsXj0tFDvSJHitzGATu58hfXvZTl7iH7f4t3tvvJ1ScDXUYHz1UR/LwAyVlfazsNCsjuUzWjFaEFLJ2rbUxHYFkw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2gCP3F/U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2gCP3F/U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=G9kCHf8br8WAlr/5Maj7Cft4763G9D9A1HkLivVroEo=; b=2gCP3F/UxeEY7kVyHSDZNlItku
	82h0FYfRO55DAH0+pxF5F3y3d6lb/9DgXvfZ3qyaDWnkHG+EkuZcW63H2X3pEK947OLLhr/9bDAKP
	2M/LMNDWB0LhTx6pzW8UMEtaLtqlZfG+RvwnJ51Ljo8CW2PX2aKGniubgl/RZ/I+NW8vZ/nzlatSW
	t4V9D+sOq9cFSN8ZsLtBsv4NRRbiaO+fmBa+FWlsaeyMbkd+vfZ77sAIXlZLf973QMosnPttfXbgd
	hXlF3SQarWOTss2QtuCs0XtjMpeVssyGxodk9Z5cBp5+0xdcwn+g3dW9s/xOLTTm6fQaDEWnPnweR
	cnhXQ+TA==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSjH-0000000D687-2zyb;
	Mon, 29 Jan 2024 14:35:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 04/20] shmem: move the shmem_mapping assert into shmem_get_folio_gfp
Date: Mon, 29 Jan 2024 15:34:46 +0100
Message-Id: <20240129143502.189370-5-hch@lst.de>
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

Move the check that the inode really is a shmemfs one from
shmem_read_folio_gfp to shmem_get_folio_gfp given that shmem_get_folio
can also be called from outside of shmem.c.  Also turn it into a
WARN_ON_ONCE and error return instead of BUG_ON to be less severe.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 mm/shmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 1900916aa84d13..ad533b2f0721a7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1972,6 +1972,9 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	int error;
 	bool alloced;
 
+	if (WARN_ON_ONCE(!shmem_mapping(inode->i_mapping)))
+		return -EINVAL;
+
 	if (index > (MAX_LFS_FILESIZE >> PAGE_SHIFT))
 		return -EFBIG;
 repeat:
@@ -4915,7 +4918,6 @@ struct folio *shmem_read_folio_gfp(struct address_space *mapping,
 	struct folio *folio;
 	int error;
 
-	BUG_ON(!shmem_mapping(mapping));
 	error = shmem_get_folio_gfp(inode, index, &folio, SGP_CACHE,
 				    gfp, NULL, NULL);
 	if (error)
-- 
2.39.2

