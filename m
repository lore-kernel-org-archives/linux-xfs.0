Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3618E4594D
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157411; cv=none; b=CnWUbQPm2lAROo5spxA8snDJ3HwZz/lEB34hFphMT+UMwWJy/xmeFlyO1prQGOJvhcuAipdTAOKRB4agGIwWfHqRcHZb1pJFwpf9NJhLnW5pP8jL+QJ7u6/vbZCmmo6yT+PHZd685Y24Iq3Rwl0hSvYrj31dETZw+4i41twr5Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157411; c=relaxed/simple;
	bh=anJEo2bbTF+THuR0i3EULj6MNyoXknXcW4hwEWz49hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSV5pRYm0akoCACuC31T/zmvkBlCz5WJxgEPoJPndhWu939F5X8N/vu+D0recOVa6M6hywgqF/IrdYOGMzSwzKJpRf3/LRCh60dV8Fsy35HMMlNHN2LaqDw3C1qruXEas6rCI9xEwQIOQAYeJyW1KbhYl89BzkeXNRDIZo+q4JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2G65lnZt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2G65lnZt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bqZ06RYMmMkz1k2bsy+DSpuOZWoTKYfDkLEhoOE0lo0=; b=2G65lnZtsbqvbaE4A+r9l4UDgD
	6MV1MUsthtK8NIqALoa6oKOneztywLgfjXhNw+b98LxFr9slul9MjoDL5tH6jT8Ob/DYVZ50kmVA1
	HvAyXcPXvemyproO5zNE3XHTc51/qbx2x7B+Se8NpTmaYfkTg+tfSA+ftob75CNW/lwK8TdTeYVVA
	qGQHCbGZQ70Nm9CJbZ2R0/KXYoyXQVrGfIh4JcJdTG9ZckCgywmd7Y9hJOUrbc7G5g43H4edHPhdx
	DGTNHKOG7E4rDn0TDB6O7wp23qH61owDcQ/x6Uyr9wi6m0PeL2cQy1t3WkQoPG0k4U4nVbTleRLTd
	gItdktHQ==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqr-00000000lNo-0mRc;
	Mon, 06 Jan 2025 09:56:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/15] xfs: always complete the buffer inline in xfs_buf_submit
Date: Mon,  6 Jan 2025 10:54:49 +0100
Message-ID: <20250106095613.847700-13-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095613.847700-1-hch@lst.de>
References: <20250106095613.847700-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buf_submit now only completes a buffer on error, or for in-memory
buftargs.  There is no point in using a workqueue for the latter as
the completion will just wake up the caller.  Optimize this case by
avoiding the workqueue roundtrip.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 352cc50aeea5..0ad3cacfdba1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1670,10 +1670,7 @@ xfs_buf_submit(
 	xfs_buf_submit_bio(bp);
 	return 0;
 done:
-	if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
-		xfs_buf_ioend(bp);
-	else
-		xfs_buf_ioend_async(bp);
+	xfs_buf_ioend(bp);
 	return 0;
 }
 
-- 
2.45.2

