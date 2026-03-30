Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDA81EE7C6
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849568; cv=none; b=BKdwOZ1iX8X8pP05SaRolpGxJ+pF5JX2bMVir+GdOAfk1NdWqM2xvCVoiXElstFkkWIeLp/o1NgyJf3x5jXZxR+XfXMvkV4I/2FjMZ6AFm4ehR8vsSKAXqTdm6awW/W+AxAQ0OHPQk09hTXV7DGQ4IuYPx5Si+VBLGC4tue6AN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849568; c=relaxed/simple;
	bh=sBZRtxW4iz7LEfXjZSwSJ+/X9KaVuoY2MpGo6sIbIMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L26adgU3QaE9pZclIGedP63ZyWuQ2BWUt9Q4gddIxtUOjZzWfZkVy88pbwnZjBPXHI8pa20Y6wdnXcazhTz8dxLkWWpx1QCUjsjtfs1eKNB1wCMq3q8+f+tqxol/6fCYmxX1MUuInExymAewedxkx/nG3S9naplnRE8Y2xCVVZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o0P4Eu3m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o0P4Eu3m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RUPYt04fmGl/cHM4PXnN24Z+m6xWEHrH/5GLqbsQ1e0=; b=o0P4Eu3msPkXfvprtFErUTa+j0
	k8Q9riNj5t1v2dpP0S+xYCb5fWHKYw4wXS8dFAIZ6Qs6A39SgbsN8WH/isV9BCHHMiBHRcUhCozlI
	FHUYC/KTfET92RyH0H+waEntxvkGUN7LkcBnkYq3aerp6K9hhiVSuQM/U9pqpxpbmVCwDo4qTyrlh
	fAIlchAPnWH/A4eVscIVcE7LKJWSfQQaShj31bDuxK/UekSYanLuVQEetimsKBy/pxpERPTrdaAT4
	1TVd1GFIZBqgWtmfQGs/Mx3RrIg1sHFbYpIq0acDiP7PEm5e+6hl1U7VzSMZ9nK1iF9XsnRS8InoL
	z9oX81Rg==;
Received: from [81.201.198.26] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75Ru-0000000AeWl-3VpE;
	Mon, 30 Mar 2026 05:46:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: rename xfs_zone_gc_iter_next to xfs_zone_gc_iter_irec
Date: Mon, 30 Mar 2026 07:44:14 +0200
Message-ID: <20260330054533.3856339-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330054533.3856339-1-hch@lst.de>
References: <20260330054533.3856339-1-hch@lst.de>
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
---
 fs/xfs/xfs_zone_gc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 273c496c2f1c..3723f5293a64 100644
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

