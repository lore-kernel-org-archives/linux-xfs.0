Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50A81A9B3B
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 13:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612778; cv=none; b=RwqU2QXCuvfDS8D93ydSDu+uT6EPu0K+W4j/eUlCUhVZ0v+rx9e3SplRSa3mwYK7OmOVdBHu8SALqsRDcaVvBS4i+DelZz2d9T2Kr/4fbtnMh8DZtTuNZBy13E3x4faQZurOWrMyp6li8wBgtLWuZKm7x8wDm9qv761PWGreAaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612778; c=relaxed/simple;
	bh=/UYgwA8tl3lQuCjztwAngi4hc/BXGTO+jWniccE8FoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSg10zLdoK6iA91nKC6nE4EXSjNhFi9t1+t/0yjTdEB4TrZxfwcic8a8GEFZTFxYlVgJ+VIo1lSaCg+IkQ4D7BIvRBTE4Hj3ME4gza0EHhpfwRDp60uB85AVboNgxYXgpSDujpNc5Dx4zcszZU7PKp6lJk8ZREagHW5uTdqe7bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FNK2sr3r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FNK2sr3r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0eW2Rv1LVtA5+Ams/kXM04UOBsDx1bzq4cTBZA/fPuE=; b=FNK2sr3rAoPPsPyXouPUlOlPhA
	e8thJgCZAMWe1Mknw/BWQtBoTRMG3aOtFmBPZxogD8Qv2IsnWVj+rAnN8ycpwdfERJbKLUULPnztQ
	fRgSdq6fUG/Bt31/mWbhxzzbrJA+HCXhBjhlNnVUBL4VC2a46i/VAsAqxXt/ny/ci4uVX8+3P3ebm
	HNZ5BlOBNsRr6VjlMtGXSceCqgfLx90MbHR9Nao2EqjgdYuR0WT0gSqqjVvWif86sWC+UYeIF93e4
	KWBWdnItTDpKJyJN8CW874MsXwZ6Yfdfij8o6Rc5EiKOtYkgYmejmNcyr8CPDG7WlrFFxOx6oBJ7N
	rSu9buCQ==;
Received: from [212.185.66.17] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1trd2c-00000002lhH-3Zk1;
	Mon, 10 Mar 2025 13:19:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/12] xfs: remove xfs_buf.b_offset
Date: Mon, 10 Mar 2025 14:19:06 +0100
Message-ID: <20250310131917.552600-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250310131917.552600-1-hch@lst.de>
References: <20250310131917.552600-1-hch@lst.de>
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

