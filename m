Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2FB21CA0D
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585169; cv=none; b=sQXkPeDCJ4c4qnu52OJfLe8CtDSM/Jro3Po86kmItXTMiDr4vkN7ervDO0GOIKOdJExPJpEOjGGmRuj7uiGpFnQYcHJLNBH0vu8Gwv14Vl5syf3YlexoNdZFvuCgglEJWbVtku5LZYCE3JZS913PQugkOZjfv0DY8geaZwDlQr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585169; c=relaxed/simple;
	bh=uER3PstcB2L55h73M6TqnyPTLd1PTuJwuj7MjcDxTWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJRpVRFiTgtWd65GV8JK2fZWXha+pXpKvINT5126aE8owK/ytp6bAcfOzUqXG4YOekiCqkZMlMLx6PCiTqD6zpsyFl57ks86NM0KYUrmmgExyFUFBbXXp+jdjI/UAV+nNF0QcyOQEijMv3uVWS+G/DrXTUDP2dG7e3qVJvmpr/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tBNuvO3S; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tBNuvO3S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bXfjvp20aEpc2lNimXve+0LJZ0zx5ojlMZCnSrxYFI4=; b=tBNuvO3SuRztWJm1Pdo/W/iJ+V
	H7/NZxpsezFLPV2iSN5utWEtPjUgZJAHk+eV+NJiGTvy814h+pIPFyGUubYOFUi1kMtyjeANWMEtv
	NPmBhI4A+6VYgwr/VqbRRPDk/CHQ7O5KnvAiSSx1wcjfvCjdnVtdNstkU4W9fDFG/klqLjHEd0gfs
	K77jwifClj89QWfS96iJHtuToqI0TpXr1/sccWz35rJ+kfN1FNyhQCnmhYf55HZsmZ2Vx+ydRKnSt
	PcMstRUpNjaBHdxi5lIghDeXQoWna0Z2g6Jx2aPMphGg3jUADubtniax+HpFJtQk2DFdMSDrZGyfa
	BxlrRIeA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnJiJ-00000004PMm-2UqA;
	Wed, 26 Feb 2025 15:52:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/12] xfs: trace what memory backs a buffer
Date: Wed, 26 Feb 2025 07:51:40 -0800
Message-ID: <20250226155245.513494-13-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226155245.513494-1-hch@lst.de>
References: <20250226155245.513494-1-hch@lst.de>
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
---
 fs/xfs/xfs_buf.c   | 4 ++++
 fs/xfs/xfs_trace.h | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0393dd302cf6..a396b628e9b0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -299,6 +299,7 @@ xfs_buf_alloc_kmem(
 		return -ENOMEM;
 	}
 	bp->b_flags |= _XBF_KMEM;
+	trace_xfs_buf_backing_kmem(bp, _RET_IP_);
 	return 0;
 }
 
@@ -379,9 +380,11 @@ xfs_buf_alloc_backing_mem(
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
@@ -395,6 +398,7 @@ xfs_buf_alloc_backing_mem(
 		memalloc_retry_wait(gfp_mask);
 	}
 
+	trace_xfs_buf_backing_vmalloc(bp, _RET_IP_);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b29462363b81..c8f64daf6d75 100644
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

