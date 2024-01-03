Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27DD182A2
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="29MO4YRf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JyTeuU47XuQs/S1QReYYzbLy/yqaC4/phAnhRBZRZ6E=; b=29MO4YRfLExY/z1gx34n+St5Br
	wJZHtdNQtl7aItiOb0oXEIRfoH77oZEj6VqZCdqTihnqysV86tOwebaFr4XtebXskmXpABjpN5iHg
	FTkxaiBPVS3V0RTS9P62FJ0a8mRD01IcBfTKTeSnIQ8VQJukz3PObvmp8irOlj05rOIaMBdbdZN96
	AT3mXCLOqZI5bA3JbFwLfQyabOUueuB0rkBXaFVYeJXVYMdshaOVXLOhK1hS4mACw9NSXR2I+KzSo
	ZYDLD6apY6ZRNWfjHxq/hBJp2mzMncRy9GPLUE2XPE6GVUffy+N/HxSFGIBXD/AslTzka8xOS9dBE
	OmeEuniA==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwp6-00A6gR-2s;
	Wed, 03 Jan 2024 08:42:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/15] xfs: don't try to handle non-update pages in xfile_obj_load
Date: Wed,  3 Jan 2024 08:41:17 +0000
Message-Id: <20240103084126.513354-7-hch@lst.de>
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

shmem_read_mapping_page_gfp always returns an uptodate page or an
ERR_PTR.  Remove the code that tries to handle a non-uptodate page.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfile.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 9e25ecf3dc2fec..46f4a06029cd4b 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -166,18 +166,14 @@ xfile_obj_load(
 			goto advance;
 		}
 
-		if (PageUptodate(page)) {
-			/*
-			 * xfile pages must never be mapped into userspace, so
-			 * we skip the dcache flush.
-			 */
-			kaddr = kmap_local_page(page);
-			p = kaddr + offset_in_page(pos);
-			memcpy(buf, p, len);
-			kunmap_local(kaddr);
-		} else {
-			memset(buf, 0, len);
-		}
+		/*
+		 * xfile pages must never be mapped into userspace, so
+		 * we skip the dcache flush.
+		 */
+		kaddr = kmap_local_page(page);
+		p = kaddr + offset_in_page(pos);
+		memcpy(buf, p, len);
+		kunmap_local(kaddr);
 		put_page(page);
 
 advance:
-- 
2.39.2

