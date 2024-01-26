Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4803B1B80A
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275774; cv=none; b=n+D15f4DT5M8U9UYLof4z/CFML/PlNg7XzpCikNvTF/sL1kK+IB6YC0tvzgnX3lPyA6hD1e7KHyIv0Hnl8dh9u9ZqC+tqHwWTMm5vvxqoAbyiXBC7maMQo48BTT/OAevjNLiPV25pLxjkmStoCC++GwUH7P8XzP5vGBCQtcYUg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275774; c=relaxed/simple;
	bh=zmv5G3goXQFImW0Hx6IelY3MNx1wnWohQfB/EcHrcQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LRY/Ns3PpsPRHxSAnbfVCFe4BABhzrBpkoy6TCKf3KhZ3XdK465Q73Go6o2u7lW6Xtq0/7zFQ5F+h9M7n8HYwyEHObzRyYcsdumf4DE4yEwwq1D6nIzM8qTg6XoQGdIA13BIfqvYv1SCLoqpGxmyrHjDCjrBOETiE/fTA03J010=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hBXzXlpS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hBXzXlpS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1ZlI1ZeOEvNmLW1NU66Umna2PQgDHzmJWRjfo1IHrxA=; b=hBXzXlpSNVfwODPh0iAWHy5XE2
	Hfntstaa47+3zsTC9HXLiMvZQcVj6O03twOhOK6sB6yQ7L8H+JIabfU+ALOLsBbqYrQInmBVtRjOZ
	0gVY/MvRjLVuwMcxSmb/QApth1Ze7qjV6wJ3ZU1ocbv5cwpC8Evwz1nU+3qN9oA6LHrW/pwrfJK3v
	Fnhb8fbzAT60tCdce84FedQ5jOY1+4PaTrQMI7jP1eNgExBD6hAMRNcy7ICC2YoWmoN0HudxwXuG+
	P0eBnPJT2yNlX3nu9wwNPpscRVLswTIpaKDPw6x0ZZM/DpKawySlvRxz+oP5AsEts6ZY0fM9dYgB1
	zParwbug==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMGx-00000004Chj-2hTj;
	Fri, 26 Jan 2024 13:29:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/21] shmem: document how to "persist" data when using shmem_*file_setup
Date: Fri, 26 Jan 2024 14:28:49 +0100
Message-Id: <20240126132903.2700077-8-hch@lst.de>
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

Add a blurb that simply dirtying the folio will persist data for in-kernel
shmem files.  This is what most of the callers already do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 mm/shmem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index e89fb5eccb0c0a..f7d6848fb294d6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2150,6 +2150,11 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
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

