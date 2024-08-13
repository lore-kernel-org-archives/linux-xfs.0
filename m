Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADD958ABF
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 07:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534828; cv=none; b=eUcoJJRUMjbGwh8t+ckdAkfuq9DJ2w7LTG58G2Y51/tjCxP24F4eqM8OlqIjaARus2sZ5yyrN5UrmO7E7FofZyygQyJw+ehWJrr4KzX2b1wGTO8RDlwwvFPFz+wgIY6kL17du+IttWo5QaGfSxHxkAQfSyC/N+yEaWtNef9jRXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534828; c=relaxed/simple;
	bh=Dl5MaigYOAPQ68kwjH9IryRR6Kjf2nByPXWhszyp14U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJuzC/odVfyPWo9i0/EafX86V0SOYYWhQK2SbTa+g1uy6ijgvEg9Aaex1XzLBsYkX7kOccY8PVkuX3LlnpKrvQIkoIocaIi6tUrKuNFqrbIKrin4LGoAJGugyAEuTttuOQxa9D6Yk1jbeFuHMTtQxLZhg77h2+kr8p0u6cRbQWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cZ6lM/Bt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cZ6lM/Bt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DjF6ucnJBIWGCwOnYkS1ECrAhhls1IrKDFiA1tfmPcc=; b=cZ6lM/Btqjk9O9qGhAoe8EVRe/
	yw9H8L4MSTueH98ApD+4VGLNaED1y54QUkm0MbBv0uQpjujnDcAiyvtQdwXLOfhx+4gpYCm3F5iXO
	SlF7/CpmRp9X0dNVjdApTf6gC+uYixlNxFJhyibspc44KAkUJINbnzhBAKXQzcPW0wRtHQ62+8T9x
	NmE67beaH1AWoWXkr6zabjtn0DOhsK5cqphlTlVeEriNnHFREVIg3dRcWY2AjXlL95x8jWqPm1URs
	oeAjdhEfE5PR7chZ8xeQSPUukdM/Qk1q0BEFVZg+pGD6qEPCE+SNaEDmit+UcUk8vZcwwpJI8Qrf3
	HsRoxbgw==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm8o-00000002lCf-1c2I;
	Tue, 13 Aug 2024 07:40:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: simplify extent lookup in xfs_can_free_eofblocks
Date: Tue, 13 Aug 2024 09:39:41 +0200
Message-ID: <20240813073952.81360-9-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240813073952.81360-1-hch@lst.de>
References: <20240813073952.81360-1-hch@lst.de>
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

