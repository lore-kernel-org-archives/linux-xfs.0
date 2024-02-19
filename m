Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FF1200AE
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324066; cv=none; b=gdvOkUpd8jGBdC4If1QMqu+JWvQPxsM4sx/MsQgkxwQRZAKozT1PRMCm2nSGutIB0SKI0EETcQJr3eP+CYdkI0QoAT/yuY3N6t2skJhXDXTnRsTVHhiWMYbVnBJARLuVom3rGQNm3tNwMw8N0A2b1rv3m+D1b0iiYokdGtnh3HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324066; c=relaxed/simple;
	bh=V1LYXTJ47ZAeZRQ7IVX8DH7rIPBA4Kk0EOnCSlH86zs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jmkk5L7RIolX0RIfpSBLXQlyIzxJ93NV3hVJwDn73Y+gaV0M8e6qrlnAYEcuSjduz6TcuxAkBEhnpCd5w+GoTSfFywf7QAN4IaqA/d4lOpvZ8GH3ZrARFbgrgyNY/NMQyOax5uujjccblOe+dgmFtlHxmeOty7zcDQ9zQ8PILag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RoEVH2/H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RoEVH2/H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tv4iW6mVqD6GYccLIm15nNo+UB3SFoik06dWZEM41Vo=; b=RoEVH2/HhV1lqYtnFtwme3tKDG
	+x/uoXjToMK4Ur/e9iFCojRvxK8jioQY+Vqlo5P9rjfUE85L3kLULYYSG11Qi0fI/Ld+VlguPVOqy
	AziW06IRsuCLmzHZVh0Tl5VBzbMqyGRpAHYMTISXI+9Lnu1kERqCJyegVbleHI3sWGJySEFCI0sX7
	+zioSoojHuUAHLHXuthz4BGqIV9V0ZrVAVJn2lbSltqeVh38xLTqujY7/mD2IriDsMJOnvNZYm/6/
	C8vJ+UfVL3gmDbBkpsN5/WRCx1xD/+VLFzg4gaMJwNUdvcu5LaublV7E4dzDnGBoiThMi6KU9Dk7D
	BBsXE+7g==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx7u-00000009F9h-0dAC;
	Mon, 19 Feb 2024 06:27:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 07/22] shmem: document how to "persist" data when using shmem_*file_setup
Date: Mon, 19 Feb 2024 07:27:15 +0100
Message-Id: <20240219062730.3031391-8-hch@lst.de>
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

Add a blurb that simply dirtying the folio will persist data for in-kernel
shmem files.  This is what most of the callers already do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 mm/shmem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 95e70e9ea060f3..fb76da93d369cf 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2147,6 +2147,10 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
  * Looks up the page cache entry at @inode & @index.  If a folio is
  * present, it is returned locked with an increased refcount.
  *
+ * If the caller modifies data in the folio, it must call folio_mark_dirty()
+ * before unlocking the folio to ensure that the folio is not reclaimed.
+ * There is no need to reserve space before calling folio_mark_dirty().
+ *
  * When no folio is found, the behavior depends on @sgp:
  *  - for SGP_READ, *foliop is %NULL and 0 is returned
  *  - for SGP_NOALLOC, *foliop is %NULL and -ENOENT is returned
-- 
2.39.2

