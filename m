Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9495F1A9B3B
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 13:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612812; cv=none; b=qTHbiYE2TGz8Nrw0CkA9zj1O2yBW46JxkXk8jswkDtb72xpys/+S/19MdXi3oEJrI9VBqld3YmsmZFICHa1CFLGbg69CHpvDPvRaJqbvzZiWvq0wInzbxbvJ3D/ZwuYS8YbweiGKEDiGggCu46nxJVGpHL6LIaYq0cCSOxvjpv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612812; c=relaxed/simple;
	bh=Wuts/J3QJ/q4jxQRYvnzCVDZISAHofSf1oxBmNRyqWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ailWbaQHUbo0UG440w457B4oZBitlJTOiqdVo70BzSS5iPzhuSLlJofUw6YRRwb3lOpOoHCYfYtrEx80/UaKhY9dAxtnYlCDAvj4opYzXlnjdmaRtQUCOgXe9Bb31tzf6q1aZdDwRqD5WkO8yncRgJOb/RKqkL7pZdE9rMQJ0L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3RFXAau5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3RFXAau5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HtHvnVmAE1idLBw47h3xGds5ruPtYjoGwHY6TWAg6nY=; b=3RFXAau5RE9u9acFZ3lLgcKN3l
	CrfvyUIZ+X/MDFmF0ORWsynlQZOsgvbd3OWNEPQHVF3nlUidE21ITGiTa9EfuIin4E2AfA1cjuTHz
	Y6gR+ruJn0gIU2PSBJIRYyDrdAgdcImRDb8y2OzUSwTufp+wtU4CJ0BOm0hxcyEkAt9cE7RhsfbnC
	Evv02O5b6u+YhFlO4F4STZGToCnS2FOECwePCVfivdZoZoZMbDtA6viU2jE6kxXtys6kslIsFQo64
	DUw8aC23D/zxTwGCZksu+xZYIPsGclPXVLnKI/YuMMaXUm392A2iFkEwktSuEOo3+QCmHekS58cjx
	QGmHkkvg==;
Received: from [212.185.66.17] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1trd3B-00000002loa-2AKA;
	Mon, 10 Mar 2025 13:20:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/12] xfs: trace what memory backs a buffer
Date: Mon, 10 Mar 2025 14:19:15 +0100
Message-ID: <20250310131917.552600-13-hch@lst.de>
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

Add three trace points for the different backing memory allocators for
buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c   | 4 ++++
 fs/xfs/xfs_trace.h | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a7430fcd8301..106ee81fa56f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -240,6 +240,7 @@ xfs_buf_alloc_kmem(
 		return -ENOMEM;
 	}
 	bp->b_flags |= _XBF_KMEM;
+	trace_xfs_buf_backing_kmem(bp, _RET_IP_);
 	return 0;
 }
 
@@ -319,9 +320,11 @@ xfs_buf_alloc_backing_mem(
 	if (!folio) {
 		if (size <= PAGE_SIZE)
 			return -ENOMEM;
+		trace_xfs_buf_backing_fallback(bp, _RET_IP_);
 		goto fallback;
 	}
 	bp->b_addr = folio_address(folio);
+	trace_xfs_buf_backing_folio(bp, _RET_IP_);
 	return 0;
 
 fallback:
@@ -335,6 +338,7 @@ xfs_buf_alloc_backing_mem(
 		memalloc_retry_wait(gfp_mask);
 	}
 
+	trace_xfs_buf_backing_vmalloc(bp, _RET_IP_);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index bfc2f1249022..4a3724043713 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -545,6 +545,10 @@ DEFINE_BUF_EVENT(xfs_buf_iodone_async);
 DEFINE_BUF_EVENT(xfs_buf_error_relse);
 DEFINE_BUF_EVENT(xfs_buf_drain_buftarg);
 DEFINE_BUF_EVENT(xfs_trans_read_buf_shut);
+DEFINE_BUF_EVENT(xfs_buf_backing_folio);
+DEFINE_BUF_EVENT(xfs_buf_backing_kmem);
+DEFINE_BUF_EVENT(xfs_buf_backing_vmalloc);
+DEFINE_BUF_EVENT(xfs_buf_backing_fallback);
 
 /* not really buffer traces, but the buf provides useful information */
 DEFINE_BUF_EVENT(xfs_btree_corrupt);
-- 
2.45.2

