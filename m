Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64134594D
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157406; cv=none; b=e5TJJtUlmbDi1qisLu94256s8njXeSaeyb7hMTzfM/fHB3Ts3MQ7cU5zln0gzLDUhFd2ZOtm8im67MrYws4unectyjiu5XT4T+ZA2p6mXiatqqsAHrTSwNQC/XMnU9eqDNBZXvFoChvf1VjinKaU1FUqOHwieBEPS0yHBI+Fb74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157406; c=relaxed/simple;
	bh=abon8vPzKzheEXdvXgXsxMNWmtyjF4Eeno45nWAb1/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oqwq4iR61iurX1QwJyAufT7V8gv+fZwzcN1LhQ75wMsXCB7Hx25MlbYF85DRni60hCt/m4gQioqYHRiFepczjXQn+8MEEz2nJ26vFn2/uUj7mbASUfQXs4Q0wmwgNpSxzPA3E+GQaYW74MPkd3fBL9nw+sORvpnmLgsw4snsS+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HCbZwL+P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HCbZwL+P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h3yVqAxtjtK2tPwvFlRTko0HmU09NHPhGY/oZeHk5Gw=; b=HCbZwL+PVHaPy3Cq/1gMpPPJKH
	KjV92X6cm/Vh6HHNvNLuKbz0qf7Vso+AbRdrYsHqGPsvGD7wazhVFZSBZcJLnghAAR4fFqwCJOg2T
	AXOW54H+BswD1my6bxhvuOf4RLn7CikPIEvEwJIW0D2hnu8wXV9LaKGzR2266NOTr3NHv+qEKVCG+
	qlxCAwrgSQX7PjZli6M4l4DjAUaEVufoLB2biDAJXv8O9x7QpE6S6t20WNjZ8JoK4s0TAxKmIZkRh
	9dIoD6MTSaEEpNP75hRpRpKuWVkpH46qtCbUVbnL+DVpHIonM/G/hW/ZIwwpeYCaD0qdBdtM+2s1u
	uiIFJDfw==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqm-00000000lMc-0rNL;
	Mon, 06 Jan 2025 09:56:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/15] xfs: move invalidate_kernel_vmap_range to xfs_buf_ioend
Date: Mon,  6 Jan 2025 10:54:47 +0100
Message-ID: <20250106095613.847700-11-hch@lst.de>
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

Invalidating cache lines can be fairly expensive, so don't do it
in interrupt context.  Note that in practice very few setup will
actually do anything here as virtually indexed caches are rather
uncommon, but we might as well move the call to the proper place
while touching this area.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 094f16457998..49df4adf0e98 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1365,6 +1365,9 @@ xfs_buf_ioend(
 	trace_xfs_buf_iodone(bp, _RET_IP_);
 
 	if (bp->b_flags & XBF_READ) {
+		if (!bp->b_error && xfs_buf_is_vmapped(bp))
+			invalidate_kernel_vmap_range(bp->b_addr,
+					xfs_buf_vmap_len(bp));
 		if (!bp->b_error && bp->b_ops)
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
@@ -1495,9 +1498,6 @@ xfs_buf_bio_end_io(
 		 XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
 		xfs_buf_ioerror(bp, -EIO);
 
-	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
-		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
-
 	xfs_buf_ioend_async(bp);
 	bio_put(bio);
 }
-- 
2.45.2

