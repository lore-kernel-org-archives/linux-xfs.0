Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024AF1F8ADD
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 06:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104218; cv=none; b=NzfksLq0O0h6TND1rZ314k+x/EUQ+8AIgGqmJCHPf33w5b8DhnK4A8wMW7lkYSq+bssgvXPIfXyNaqsSp+dcBrM9wmKf8q08T1KlgISRqdcVRy4utbNakNhVeOZARF9lgcO9iJ8BOLmPy8tDmBTvZF/mIZl1g0mwdyhcjHOzcqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104218; c=relaxed/simple;
	bh=ewZwCDYzHsNPR25GZdPYk83g6bnsx+jH2tDR/dZ8gSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=om2VnqFWqiR0msuduUIzmg9BbFWj9SmYVFrmnh/tNIQ72HmehYoiG9sswOWr6ZyaJwXq615sQSuE0kNV2hy/ThnKIxxFekrL2f9XgtBqUvKvAg03C+O1A+7ELW/rqcOi6XIzatrYP72ay/WkYqbOWYzhF2qA4xX5zo3MnUyyQWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2mWtf3XG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2mWtf3XG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=30ks+sTAgLtHUlxiIBnet75k3Kn/g1z0acQQiJGajbc=; b=2mWtf3XGpFaROOGvwWn3034ETB
	2QQaw29sH0if5eBQ6A+DgBiNJLokR8tw6xYrTDPo7EVWKWSZF+MAvplsXzbCOb9I6S3jnpYuCpUF0
	L2nOU7FGY1UCl498R7erh4uoI4guZ6pSlVfmIK7/2kSCb510jZJII+p6rTmV5Y0Tp9ttPxvHMmFiw
	HNNA79e7geHbb3FTTOcLLg6JOSTlQfurF2OUiC/ZfJYpSQgBjqGENY7+Xs4Tip8iYdDwycobplJa9
	gHqTt2uZas/aneNq8w9R+lQhXO029lmpFw8k9ZUfkihT/0qjf8MS5mTRfGLdGCBwi1DNEQFQMEUIP
	znppYrEA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uN3uK-0000000Eq6w-0iSA;
	Thu, 05 Jun 2025 06:16:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: [PATCH 4/4] xfs: move xfs_submit_zoned_bio a bit
Date: Thu,  5 Jun 2025 08:16:30 +0200
Message-ID: <20250605061638.993152-5-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250605061638.993152-1-hch@lst.de>
References: <20250605061638.993152-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Commit f3e2e53823b9 ("xfs: add inode to zone caching for data placement")
add the new code right between xfs_submit_zoned_bio and
xfs_zone_alloc_and_submit which implement the main zoned write path.
Move xfs_submit_zoned_bio down to keep it together again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 0de6f64b3169..01315ed75502 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -777,26 +777,6 @@ xfs_mark_rtg_boundary(
 		ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
 }
 
-static void
-xfs_submit_zoned_bio(
-	struct iomap_ioend	*ioend,
-	struct xfs_open_zone	*oz,
-	bool			is_seq)
-{
-	ioend->io_bio.bi_iter.bi_sector = ioend->io_sector;
-	ioend->io_private = oz;
-	atomic_inc(&oz->oz_ref); /* for xfs_zoned_end_io */
-
-	if (is_seq) {
-		ioend->io_bio.bi_opf &= ~REQ_OP_WRITE;
-		ioend->io_bio.bi_opf |= REQ_OP_ZONE_APPEND;
-	} else {
-		xfs_mark_rtg_boundary(ioend);
-	}
-
-	submit_bio(&ioend->io_bio);
-}
-
 /*
  * Cache the last zone written to for an inode so that it is considered first
  * for subsequent writes.
@@ -891,6 +871,26 @@ xfs_zone_cache_create_association(
 	xfs_mru_cache_insert(mp->m_zone_cache, ip->i_ino, &item->mru);
 }
 
+static void
+xfs_submit_zoned_bio(
+	struct iomap_ioend	*ioend,
+	struct xfs_open_zone	*oz,
+	bool			is_seq)
+{
+	ioend->io_bio.bi_iter.bi_sector = ioend->io_sector;
+	ioend->io_private = oz;
+	atomic_inc(&oz->oz_ref); /* for xfs_zoned_end_io */
+
+	if (is_seq) {
+		ioend->io_bio.bi_opf &= ~REQ_OP_WRITE;
+		ioend->io_bio.bi_opf |= REQ_OP_ZONE_APPEND;
+	} else {
+		xfs_mark_rtg_boundary(ioend);
+	}
+
+	submit_bio(&ioend->io_bio);
+}
+
 void
 xfs_zone_alloc_and_submit(
 	struct iomap_ioend	*ioend,
-- 
2.47.2

