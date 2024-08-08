Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6B9190477
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 15:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130911; cv=none; b=dnzFg0If5vvNWdYzVuvJnEbR3aViK8bi052LuTHBbHru0ojRUphDzjgNXjWma5+/THO4zdGXuhwN+aL3qomPUXrAQ1l6YjJvv+OY1q/B4NiUQnx96hekmOQki126RHpAJ//CgRff3wVfYRUE3VmTvODp04T1en3izPPjVaTHlRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130911; c=relaxed/simple;
	bh=Dl5MaigYOAPQ68kwjH9IryRR6Kjf2nByPXWhszyp14U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC6MVShFiqxDxeLJRGLuUZOlF6rZPlKPJ3j49oHAgNwqa7ImZLn8R1k8kPwzXeEtNtAPdG2SbIkRx43d2L0+++5blGy+lmAcecdn+6adfvOYVYS3vYKmZpE64yEo1TQL5Bboxm8L1Euv28E1imKYwyA3js6BRxdH7buySxTQlFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HZvncQYA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HZvncQYA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DjF6ucnJBIWGCwOnYkS1ECrAhhls1IrKDFiA1tfmPcc=; b=HZvncQYAE72eTuS9JP7XHT1BmL
	KN7dV0bOgPutWogO++NkyZqo1pD31ga4zHQsi5wnwmFNEHWXhQd789V8Kq7ZejekD3C0Y9tvS4LN5
	SDxvNVIHh73PClYylw6aydmfv219Jts7CAeNSDI01vupN4qI7uSTkYww8p03EtGJ8tt8agEobXARM
	d53nN4EFdptggl/xZOCiEe0CTT4hsxyZXD+5CFnWlPrx3B2TnhGr9635vMNjNU0EtTEzYpeNDyA9K
	8pRdQQQl9B/NNzJnvVQBn2eWG5Z9VBvyCrW7S06yk5oBERTjk04A6FuBBEAxYrA4alKLZ94bh7YXt
	kY6jdSuQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sc541-00000008kXQ-1mJ9;
	Thu, 08 Aug 2024 15:28:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: simplify extent lookup in xfs_can_free_eofblocks
Date: Thu,  8 Aug 2024 08:27:34 -0700
Message-ID: <20240808152826.3028421-9-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240808152826.3028421-1-hch@lst.de>
References: <20240808152826.3028421-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_can_free_eofblocks just cares if there is an extent beyond EOF.
Replace the call to xfs_bmapi_read with a xfs_iext_lookup_extent
as we've already checked that extents are read in earlier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fe2e2c93097550..9c42cfb62cf2dc 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -492,12 +492,12 @@ bool
 xfs_can_free_eofblocks(
 	struct xfs_inode	*ip)
 {
-	struct xfs_bmbt_irec	imap;
 	struct xfs_mount	*mp = ip->i_mount;
+	bool			found_blocks = false;
 	xfs_fileoff_t		end_fsb;
 	xfs_fileoff_t		last_fsb;
-	int			nimaps = 1;
-	int			error;
+	struct xfs_bmbt_irec	imap;
+	struct xfs_iext_cursor	icur;
 
 	/*
 	 * Caller must either hold the exclusive io lock; or be inactivating
@@ -544,21 +544,13 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Look up the mapping for the first block past EOF.  If we can't find
-	 * it, there's nothing to free.
+	 * Check if there is an post-EOF extent to free.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error = xfs_bmapi_read(ip, end_fsb, last_fsb - end_fsb, &imap, &nimaps,
-			0);
+	if (xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
+		found_blocks = true;
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	if (error || nimaps == 0)
-		return false;
-
-	/*
-	 * If there's a real mapping there or there are delayed allocation
-	 * reservations, then we have post-EOF blocks to try to free.
-	 */
-	return imap.br_startblock != HOLESTARTBLOCK || ip->i_delayed_blks;
+	return found_blocks;
 }
 
 /*
-- 
2.43.0

