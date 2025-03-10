Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177581A9B3B
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 13:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612773; cv=none; b=V0BxxEt/zWYD4AbxY9QH1+Qxpw5Zb9oJ6dvRsfbFWBlErCikiEUeVjXTGtv050GsD7lQVxLIHd9khxW06scGc1vQs/zGc7m8DaOgm6cxjm4rhKn4cjQKdInybzoK1N1YPC6FXNeOzNIuBi20m0/yWt5+nwgkCupTYS0+HlRc3Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612773; c=relaxed/simple;
	bh=jH8xYyWdrS/f+mes1+Lz2MYeJcplOu8H5nErCYr8Fcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gkg/mAIiqEqkNct0Y+8TRGeDhmQNYRGE+D1rKolxvN8/poZFAmt2fHwtETJAI2LxZCQaoTtRDKz10eqrApdIL80jpU69gwLCdSxB8ZXgoWe14M8UaAxHQrM/D169nrwyI+21gKGAs6R+m+psr/u2+nIZm4lSpigkEOgG9fSrGPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yJlY4hg/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yJlY4hg/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+as5Rra19jF7aKj2oyUncN1Vc+WhmMOc1AfmzuTg+6A=; b=yJlY4hg/kuB1qXnhDthou1xhAB
	uXrR6gEK86axyEowAGr+qRJkh/fK7SbNArSX+QR8ggzCQ4Yhm2KMgQN2zVDuKZcwRE2ZFBf9BCbgd
	bdt5A7QLnEbQ2Pxel5U//bQ2hUOhfBV/1GKTCt8erXzcL5xH9SkbFbL1Wa0MvsYI4oUZZX1Cap2EU
	z/h1f2kVWFwfPv+fFwTySbrgz1krhQEtB4qbqCORlc/uOdp2kgFUCciWD5ny/C5YiDT8o8NoH5p5/
	qd7KXx3ZWOthHitj1TxtVyuf71/AgLpJGxP3QuabT1xXjTSghcjXBmn9MOC+Ju3hNBoUFwdfdtmD1
	rUQAknHw==;
Received: from [212.185.66.17] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1trd2X-00000002lgB-1cHi;
	Mon, 10 Mar 2025 13:19:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/12] xfs: add a fast path to xfs_buf_zero when b_addr is set
Date: Mon, 10 Mar 2025 14:19:05 +0100
Message-ID: <20250310131917.552600-3-hch@lst.de>
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

No need to walk the page list if bp->b_addr is valid.  That also means
b_offset doesn't need to be taken into account in the unmapped loop as
b_offset is only set for kmem backed buffers which are always mapped.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 5d560e9073f4..ba0bdff3ad57 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1633,13 +1633,18 @@ xfs_buf_zero(
 {
 	size_t			bend;
 
+	if (bp->b_addr) {
+		memset(bp->b_addr + boff, 0, bsize);
+		return;
+	}
+
 	bend = boff + bsize;
 	while (boff < bend) {
 		struct page	*page;
 		int		page_index, page_offset, csize;
 
-		page_index = (boff + bp->b_offset) >> PAGE_SHIFT;
-		page_offset = (boff + bp->b_offset) & ~PAGE_MASK;
+		page_index = boff >> PAGE_SHIFT;
+		page_offset = boff & ~PAGE_MASK;
 		page = bp->b_pages[page_index];
 		csize = min_t(size_t, PAGE_SIZE - page_offset,
 				      BBTOB(bp->b_length) - boff);
-- 
2.45.2

