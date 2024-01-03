Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88353182A2
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lwuKokl9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lo04JMqhsFGkQ8TlRgHQOmhRNZvE2v0cppmArCUs8rY=; b=lwuKokl9u6QXkYesoWSmuTt3UM
	28rIQJEb0WRqGFlb4Uvq1J6D6VRwtf7PQ0nPrU3NIuIp277ZHrHJ1PMbR0r/rU1GgTzu+NOeSFjzl
	fFdobPKyYC7J6D82wluQHy9jQcPXz9GG77j49J8FiiKSTtzLknJhoLprAerz59Y7zb+eJV52dGWvs
	G09csf6c7y1coPI9VcSuLeofiCD+iu8I9Zb2xlGSx/MfWcccYiTw7t0Cny0uaVK7wySSMEcVpMfXE
	Bp1Svfq81sdy0WIl5WUrUr0asyTG/+SZY/jGo8mKwa2NPojfx9cKBlYyC8pvz/y1x1XoyMFEYrdud
	Ja8t42fA==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwoq-00A6ZS-33;
	Wed, 03 Jan 2024 08:41:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/15] shmem: document how to "persist" data when using shmem_*file_setup
Date: Wed,  3 Jan 2024 08:41:14 +0000
Message-Id: <20240103084126.513354-4-hch@lst.de>
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

Add a blurb that simply dirtying the folio will persist data for in-kernel
shmem files.  This is what most of the callers already do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/shmem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 328eb3dbea9f1c..235fac6dc53a0b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2129,6 +2129,11 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
  *
  * Return: The found folio, %NULL if SGP_READ or SGP_NOALLOC was passed in @sgp
  * and no folio was found at @index, or an ERR_PTR() otherwise.
+ *
+ * If the caller modifies data in the returned folio, it must call
+ * folio_mark_dirty() on the locked folio before dropping the reference to
+ * ensure the folio is not reclaimed.  Unlike for normal file systems there is
+ * no need to reserve space for users of shmem_*file_setup().
  */
 int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
 		enum sgp_type sgp)
-- 
2.39.2

