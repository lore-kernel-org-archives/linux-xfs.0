Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6F08248D
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 05:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726637507; cv=none; b=i4XYtODMC1jwG+yQfxTj8xtOtD7hSYKlUvTblPo06m0pEi9qUFnTxeKxrXQo+I+kKUB4/xsAnpdBpEYfv+MYllejb91nj0kC57QSXvH25x75bk1PRRwdeWpFadqHM2gtmdXUTw6Thky6NRo7hoRHLFPUxGZa9mhFhpzpqrpVQMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726637507; c=relaxed/simple;
	bh=/il1Fu8XShWPmuTP7UKyWzf/rJ4TEAhOplMiUciYDXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qB4TACu13inkGXhawT8g9asKuyjKs5nEFMDatdodyv/R4amw1AbnsP0651Nbtej7J0ptyA9kK80pkgS3pezijTguoRZ2Re7CYEDb8v2+a2HQfd5bPEZDdN1+UqqSeIRdwUpJxp4zJAlXoeSG6GByigyS7b6Atxe2NmxSDCDjaK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Kmz6h1uT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kmz6h1uT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=svaorK2ynsYAlNhQa/cI+wayuRM/8agYRwlVIZojftQ=; b=Kmz6h1uTTzfh1TR0u0Q1w8SDi2
	bkUWXF9DhbkeVUco3YXhuGgvVta5XerQ7IAdZPpfDqIV5OjCBHQxz5wRw+YNYTAgFP84LfYm6y441
	MmD4ppE6dQWZ87mpCCxV19ymdC29ih++TiQAmUId9gSsD3GoZjy2W13cYHwBkqG2EO5ypx0LAnztJ
	9/Ek61XZMTz4XgMSj4cVRsXMoPIDXu02vnGHXWw6gtnZ1B+/pR55icUvykiTmpVBGPauu9Sn89loI
	hk6HIE1yldkmhmvUzuOtluFWcUtb2rAT36IHG0rutUzYJzGMZb826uuv1uM4WQNZzauKg5oID+Z5l
	eQXdPNMw==;
Received: from [62.218.44.93] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1sqnI1-00000007Tnw-3axy;
	Wed, 18 Sep 2024 05:31:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
Date: Wed, 18 Sep 2024 07:30:10 +0200
Message-ID: <20240918053117.774001-9-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240918053117.774001-1-hch@lst.de>
References: <20240918053117.774001-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the debug-only xfs_bmap_exact_minlen_extent_alloc allocation
variant fails to drop into the lowmode last resort allocator, and
thus can sometimes fail allocations for which the caller has a
transaction block reservation.

Fix this by using xfs_bmap_btalloc_low_space to do the actual allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 756faae9ba6341..36dd08d132931d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3501,7 +3501,13 @@ xfs_bmap_exact_minlen_extent_alloc(
 	 */
 	ap->blkno = XFS_AGB_TO_FSB(ap->ip->i_mount, 0, 0);
 
-	return xfs_alloc_vextent_first_ag(args, ap->blkno);
+	/*
+	 * Call xfs_bmap_btalloc_low_space here as it first does a "normal" AG
+	 * iteration and then drops args->total to args->minlen, which might be
+	 * required to find an allocation for the transaction reservation when
+	 * the file system is very full.
+	 */
+	return xfs_bmap_btalloc_low_space(ap, args);
 }
 
 /*
-- 
2.45.2

