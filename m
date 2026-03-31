Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CF71B4257
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 15:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970891; cv=none; b=DcsLtqjIGnww5EU8BFQurVJn/eg/7o45fUCqS1PIJBZjubNxvQnScaj2DBNIU3tVrWKLRjwwuYqyTUAPfTy9pIalAJGBSp+C6e3rmnjBoiNlIyFuQ90rDTfPGewuqEJmlkOQ3jHwJg25MhkiLsGBsckDV4AUYPZhI13mbIrSJ3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970891; c=relaxed/simple;
	bh=C+tIsFwrl+x+pFaZDi8TPhy9io1mYrspNtDPCaFEMq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKViC1oX39i1NkZRj8MTYgqCifZ/snrqH6yxDsUd94WA8h0ZDhc7Ptz6TkpzSIbYtNqQvfwaX8TCs3u0HsMKKJpvcyz3yrRYpmwP1uOisFB7YNfTocXkiOE7jvU+wwZEGNun1/rYQ7PNwZNrO1rAXPzJ0yHp4EwcpWeoI7dn9ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pWVdITjt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pWVdITjt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vgM3bQjPeEdbi3spT+YXuwdo3vXy7wB+SUOV546Lwx8=; b=pWVdITjt7v5KpzvLiLwonRSO9G
	Q/TR1tcHEZ6Y5hcyENPt05/59LksegPIhsAgD1x0X7H9qJ8K42Nc5uj97D6Xw49hd0ljbcg25uUmh
	0PCnCHmvrQc3+A9ump53bopAv5xWXUDPTj+KttTSUj5zKNAagScU3ZGm31O4boInQjTxlG3f0qSGS
	c7vp93N6je9b43MfqdYgONsGN+Ml6YcsNOrplHga65Sh7EcjcP7+r0G8BSkg4Ec14+yRkg1sVuyAq
	DMY+6qAA2qcdDa0/44mX0LK4mqgnJsujPg575e8ooIeLYP2Ivbec3hnhlNd84fTJiJrWkeC7dRrxM
	U+jnTpgg==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7b0j-0000000DBEe-1kTB;
	Tue, 31 Mar 2026 15:28:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 4/9] xfs: rename xfs_zone_gc_iter_next to xfs_zone_gc_iter_irec
Date: Tue, 31 Mar 2026 17:27:26 +0200
Message-ID: <20260331152751.4048218-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331152751.4048218-1-hch@lst.de>
References: <20260331152751.4048218-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This function returns the current iterator position, which makes the
_next postfix a bit misleading.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_zone_gc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 0c1e22409ef1..cd4f52af295e 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -374,7 +374,7 @@ xfs_zone_gc_query(
 }
 
 static bool
-xfs_zone_gc_iter_next(
+xfs_zone_gc_iter_irec(
 	struct xfs_mount	*mp,
 	struct xfs_zone_gc_iter	*iter,
 	struct xfs_rmap_irec	*chunk_rec,
@@ -691,7 +691,7 @@ xfs_zone_gc_start_chunk(
 	if (xfs_is_shutdown(mp))
 		return false;
 
-	if (!xfs_zone_gc_iter_next(mp, iter, &irec, &ip))
+	if (!xfs_zone_gc_iter_irec(mp, iter, &irec, &ip))
 		return false;
 	oz = xfs_zone_gc_alloc_blocks(data, &irec.rm_blockcount, &daddr,
 			&is_seq);
-- 
2.47.3

