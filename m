Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9AB24E4A7
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 14:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183540; cv=none; b=PB7WQMPb2Kv8GbXk5xfj2xzGqhmx+BsYEDo1ykz0i8Aeoh3T7hnvbU0IkKCO6dJ2x0rP5TMR/vVUhWem0AaTFAoKhjoPVws4MJ2vVOe9Stb8MCr6fXlgDomxsl1STTCkhPyn20HVTjV6C0mhM/HmvJjtSU4fWbq82c55ZqOsM1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183540; c=relaxed/simple;
	bh=WJwebKNJRZtwcnnoKX4IfB2Po8BTyJ1rO++t8rtOFxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nh9vf+E8qr+gXwrEgOZRH+X98/gWgWAbXEHb06tr8Lwyx5pr5qVNY0HT9PKbt3rR3MkQHW3/V05CJNAUAR/ZU2bZJnksSaaJzSZ6eYpjFQWl726VXueg+u04++2Htl4CT63YzmWAzZ6UIKfUwR4xT93IlnKXTVKkbURx4/dDFIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4Uzt384A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4Uzt384A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=J+F6z6iOsrh+HjSwq9AW0bJJ/LVnwTTxKc79/fB5lWI=; b=4Uzt384AmVIVI3kP7+CD8UZLYg
	c2tAVYW4AK1ERGp4btlO7yLZKgp1gq8FKGm8cM5kY/IIlQGA4Wcqse2XoU8RETXAWVoTCCt91e1RY
	mlGE6HYJ2q7Il7alq0qjE3g1v9R8pjbDHAMu6pcLg8go963uFMF8vOV18s3JApU7l959UzU2EDwFb
	j6ecvSM40eO/mfmRVgAq6InoNZZ2X/ygkzuUONRFVg5KJJKFQms7/9Poympl6BHbtoQTMcCyILwlG
	ct6dyDvaLcoWpO1aU5zdMUqtEslwiocfNF4gIzRSak8f0XlMZ5eBdWGnd0v1Gb3h3OglPW2/Im5wh
	NswXQWww==;
Received: from [199.117.230.82] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tppNS-00000008HqI-1xOK;
	Wed, 05 Mar 2025 14:05:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/12] xfs: trace what memory backs a buffer
Date: Wed,  5 Mar 2025 07:05:29 -0700
Message-ID: <20250305140532.158563-13-hch@lst.de>
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

Add three trace points for the different backing memory allocators for
buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c   | 4 ++++
 fs/xfs/xfs_trace.h | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index c7f4cafda705..0014cfab3414 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -240,6 +240,7 @@ xfs_buf_alloc_kmem(
 		return -ENOMEM;
 	}
 	bp->b_flags |= _XBF_KMEM;
+	trace_xfs_buf_backing_kmem(bp, _RET_IP_);
 	return 0;
 }
 
@@ -315,9 +316,11 @@ xfs_buf_alloc_backing_mem(
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
@@ -331,6 +334,7 @@ xfs_buf_alloc_backing_mem(
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

