Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A2A24C074
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183536; cv=none; b=n0QjGjALNdlwMiBUMqmr9oqMN8xnT/x46uRodyVGE5zkgUpM5kfTgtik8CXqHG4bwjJE24SZT3o6ic/9FGP0XC3Kv96Pb6RtQ6qN3WnlS9nGvljiQaajD4Zn4DeNgLxPVsl1qSAT2cR2bPR1bSxJj+j6mUSJE4lXveel6CVJIyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183536; c=relaxed/simple;
	bh=/UYgwA8tl3lQuCjztwAngi4hc/BXGTO+jWniccE8FoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDwmP4N1rSWlfKQnCHq+G6HIZgvrYEPmoNoILRJx9kC+HUS0Yd/H6o6RreSSDWWdte01tvFO2LmOXA0ahZn3x73VhmwQ3lH3LE8XsqsCTk9PaA7c2eHYQXH0xZQRWGvixv4tjKuyUHD0WlG8enTwuTM0RRhzJkkGIEjohbDxYt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=krHHLfzY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="krHHLfzY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0eW2Rv1LVtA5+Ams/kXM04UOBsDx1bzq4cTBZA/fPuE=; b=krHHLfzYqQWnlXW4UXq5QR7Q+Z
	X6B7vrSnrDbGxwMabpzKEasHfhA5I4M4wu+j+YtBxJE7jXy+l+b5Pb18wmS6xY1YdiKUvj1G3wuun
	XCKi1mkgkr3m/iioeEFAlePgeTtQCnhKb/8eDPpoH+DdTBAyrY9t8ej9vXMsTguxoCnbBCdSKjO/E
	QCijQU18GYPDSwEe1BA4yQzeopQBbWi8uUVt3zdBX4KPXiyHsc3V9nloorIdpxTeZOT/TyCHrQN8H
	3Hx6rE7GZI9drAIaCAC0A7oSyHmu4N7wt5W6Ws0EShLiVU1JwnvE9An7AqtH3ISfUV49M/2hVr9xl
	C1DICLeQ==;
Received: from [199.117.230.82] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tppNN-00000008Hoi-3Xfn;
	Wed, 05 Mar 2025 14:05:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/12] xfs: remove xfs_buf.b_offset
Date: Wed,  5 Mar 2025 07:05:20 -0700
Message-ID: <20250305140532.158563-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250305140532.158563-1-hch@lst.de>
References: <20250305140532.158563-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

b_offset is only set for slab backed buffers and always set to
offset_in_page(bp->b_addr), which can be done just as easily in the only
user of b_offset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 3 +--
 fs/xfs/xfs_buf.h | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ba0bdff3ad57..972ea34ecfd4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -278,7 +278,6 @@ xfs_buf_alloc_kmem(
 		bp->b_addr = NULL;
 		return -ENOMEM;
 	}
-	bp->b_offset = offset_in_page(bp->b_addr);
 	bp->b_pages = bp->b_page_array;
 	bp->b_pages[0] = kmem_to_page(bp->b_addr);
 	bp->b_page_count = 1;
@@ -1474,7 +1473,7 @@ xfs_buf_submit_bio(
 
 	if (bp->b_flags & _XBF_KMEM) {
 		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
-				bp->b_offset);
+				offset_in_page(bp->b_addr));
 	} else {
 		for (p = 0; p < bp->b_page_count; p++)
 			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 80e06eecaf56..c92a328252cc 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -194,8 +194,6 @@ struct xfs_buf {
 	int			b_map_count;
 	atomic_t		b_pin_count;	/* pin count */
 	unsigned int		b_page_count;	/* size of page array */
-	unsigned int		b_offset;	/* page offset of b_addr,
-						   only for _XBF_KMEM buffers */
 	int			b_error;	/* error code on I/O */
 	void			(*b_iodone)(struct xfs_buf *bp);
 
-- 
2.45.2

