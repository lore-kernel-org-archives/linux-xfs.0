Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992E11922D3
	for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 17:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724173542; cv=none; b=QojjLTLgPDcaVtSuWI9gcICYOyORzgRTzylf7aCW4cC+tzB8UMYLKP/kTmMxlzCLjMDGy0vlln2WGEMgQ1JN/R5Z9uoPj2LzQ0N3erNRvgBukib3ttu7URqvPZFzOWXigbjx1f8ZPF+SJDKY3+EM+OodJqBUceVUhuAAPkWH4fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724173542; c=relaxed/simple;
	bh=jQzuOXax4MV0X0/ru/sDbUIAN5ufYeXYbtHiwS6OZ7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5U3Ot4+/h5ktUNCby6H1p7H57hhODi7S1ApxN5LQiXOIQ4vjs5XRF4LiUS9k1KukPALKA1aIxgm3S1tSlXF9+8NtcDWFKgxcI0nAaovJIL6o0r5cig5TGpHlk7DDo34tQJQ4KWEXxC7CFhMwDiyxPwrFVRPDjiO8PeITAhrI6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q5nPqTeZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q5nPqTeZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6zY6LdHYGroXTMNX5/DB0oiV6Dd4xVJ25rjGPQrAQrI=; b=q5nPqTeZP3WVGDuDiC9EP3P/sc
	C0+JzSdGQodUTtkVh3/QMEQeG1doNLxVFiwgWz//XGWsBcBBbKGNmdBQeYT7NC2mD6J8tJUdaq9vP
	Z7OmxHbXJL2jcaE/Ynkoby68/16CyAaVC802Dsz6VMGwZGT9hMrRSsexd8JN2SfRfShbu6YI0CsxV
	inPhVHT74WxUQi8Xjaz//TOj5Qd0BPoDWvtNL2DH8QIuxKrTgxqhq0ZoJCz9a2xD+EwBVAMReNDa9
	Ohja0wbh65hjhFj8p+hXOK7s7EXR1W9QP5yL6Vs9jF9OmLJcCDAZi6C3S0HLAPfhxq3h/oV1T/2qO
	aP+4NgHA==;
Received: from 2a02-8389-2341-5b80-6a7b-305c-cbe0-c9b8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:6a7b:305c:cbe0:c9b8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgSIe-000000066eL-33sY;
	Tue, 20 Aug 2024 17:05:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
Date: Tue, 20 Aug 2024 19:04:57 +0200
Message-ID: <20240820170517.528181-7-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240820170517.528181-1-hch@lst.de>
References: <20240820170517.528181-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the debug-only xfs_bmap_exact_minlen_extent_alloc allocation
variant fails to drop into the lowmode last restor allocator, and
thus can sometimes fail allocations for which the caller has a
transaction block reservation.

Fix this by using xfs_bmap_btalloc_low_space to do the actual allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b5eeaea164ee46..784dd5dda2a1a2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3493,7 +3493,13 @@ xfs_bmap_exact_minlen_extent_alloc(
 	 */
 	ap->blkno = XFS_AGB_TO_FSB(ap->ip->i_mount, 0, 0);
 
-	return xfs_alloc_vextent_first_ag(args, ap->blkno);
+	/*
+	 * Use the low space allocator as it first does a "normal" AG iteration
+	 * and then drops the reservation to minlen, which might be required to
+	 * find an allocation for the transaction reservation when the file
+	 * system is very full.
+	 */
+	return xfs_bmap_btalloc_low_space(ap, args);
 }
 #else
 
-- 
2.43.0

