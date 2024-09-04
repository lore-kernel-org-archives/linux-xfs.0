Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6392D824AD
	for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2024 05:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725428339; cv=none; b=qWE368iau2PrpS64fdVR8rlEMnhpy5kEpOUzE4zzxNETKQIwQn5uhpVnJ1WYvUVU8qQCenDhLql8cS2aHu+sVULxTyc9rSua43pPvRDoGNdbrYBchJoDv5aB7EnbKJ/y/QDAB0s/4F8ZenxguXR9K0yKBF8Drk+LCZud5zEWOj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725428339; c=relaxed/simple;
	bh=mypaGk34lKJVKx5hRLqxmihZeTSrvy4P4LKBCQxoSHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JL9XvXCd+sA4X6UHS3IghxcRPVpqtYIp3LBI6EDFV4TaASzXhvmkwD95KE8kqnJJJbsAbihLCnlpMnt0zYH6Z5v8QoeZiGsGxXdfVuk0xRZIaglYtWG8ToMplT86qS+CwHeeBSovNJSghH/YvyWpeH1P5ORYZvyULBL/iO6rQj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Sz90G0+L; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sz90G0+L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/AUXgbTvSFKL4WFAjFUh/TY0cCUjeIcBHvTW+HFLaOM=; b=Sz90G0+Lh6HQj9sX1HxVyE9Fjh
	yDQeITI5SEFXPxad18ew4fYo+7oKzidjk7WMLT6DJBavKejJAQBKSr/ok4N2yndiwd4vD0PF3FqhG
	uFZFKGsy8FzM1xAdypMuZ92K5ejFvaff0wuJ6e5CtVu9Ukqm0Lh9S1YZ7xnhGlI8lYXaILgeQ66Dn
	wOCIKDF65DCL0FgGLrpEzUGWyGkWV46djKm+oTmTSGXjkeKGxIRFRw35+giKJMw9Wq6rlD1v6H4O7
	KcKdh+qxhywo9ygeQg/9FjZTCQg5vjjmoXpJDHshvEdLUN2xKYGepc3V3RkHvaJ1Vl+dO2EN9Ch3w
	E2E5S3+Q==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1slijI-00000002vAo-3lbt;
	Wed, 04 Sep 2024 05:38:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
Date: Wed,  4 Sep 2024 08:37:59 +0300
Message-ID: <20240904053820.2836285-9-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240904053820.2836285-1-hch@lst.de>
References: <20240904053820.2836285-1-hch@lst.de>
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
index 2873566dea3d3d..f1c3beb2c435ba 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3492,7 +3492,13 @@ xfs_bmap_exact_minlen_extent_alloc(
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

