Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03820334689
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 06:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760681251; cv=none; b=sJpDAMG5fQa5+b76OxVuM3q9j9x0ZSLATTbYZZF7G4G3d6NP/p+fPTbha0tH5ZQgfhuFXHmpHIOajITWPGsu3ODIuH4vh+I4jqgQP5GcPapf+RNLmRDqfDi0IHvDPyx1SJ20nQVf+16u0aZdAdRNrjejjeda9fca9Kcf1Ax1qAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760681251; c=relaxed/simple;
	bh=917LoMxq8+soGCrrOl1uLWfjQu/9neSoOyrsqnBZU74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDsnlxmtB52/4RWWHntfULbLtpQBN9DaWq59GOg1pVn/kejjT8pgdCrc9katA46FJCtwlCTERm7/PhzGiuKqJPSsRX6LK58/zFP8hp1iI4m1ySiTfIZSm2efBu7E6eul6FzGG9fKIhyHEiKzODSu7GbvQ6fzLcymcckke1buOo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B3zcxFQN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B3zcxFQN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NCLumH7JfFK+n3+LIB8zbZg/YVks7fvJogExyv83gTo=; b=B3zcxFQNsCqheY1ED+K8095MHN
	HmGPUWzIFXVKfJZZlYW07EjtHiHUW5PU+yHPK2tUTdBF07jDdLIUqlBqq2nFON16MtuRGQpl0gU34
	DIQN2HXEj691RKbabJNyVzEEMp8v2GnFjd1P0gHEeKh195O8mycv6vUm7tOo9P3Gej2RA9jMN4Aqz
	fSyWVNx2R8xRYToLe6zwowJ348j3fM/aWe904SSBOOfm+rFWT8N54HxD2nLQam7QCK2sUVyi55XmQ
	g7Lztfe5ll6q6ynAFtPJ9A1lDAlivX7hX+G1Oz4b9Tabl8snhnxMLt4myeIFu5gKLbzXq9CSeLIxu
	0Y9qT7/g==;
Received: from 5-226-109-134.static.ip.netia.com.pl ([5.226.109.134] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9dcf-00000006hF9-1M6K;
	Fri, 17 Oct 2025 06:07:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: document another racy GC case in xfs_zoned_map_extent
Date: Fri, 17 Oct 2025 08:07:03 +0200
Message-ID: <20251017060710.696868-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017060710.696868-1-hch@lst.de>
References: <20251017060710.696868-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Besides blocks being invalidated, there is another case when the original
mapping could have changed between querying the rmap for GC and calling
xfs_zoned_map_extent.  Document it there as it took us quite some time
to figure out what is going on while developing the multiple-GC
protection fix.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index e7e439918f6d..2790001ee0f1 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -246,6 +246,14 @@ xfs_zoned_map_extent(
 	 * If a data write raced with this GC write, keep the existing data in
 	 * the data fork, mark our newly written GC extent as reclaimable, then
 	 * move on to the next extent.
+	 *
+	 * Note that this can also happen when racing with operations that do
+	 * not actually invalidate the data, but just move it to a different
+	 * inode (XFS_IOC_EXCHANGE_RANGE), or to a different offset inside the
+	 * inode (FALLOC_FL_COLLAPSE_RANGE / FALLOC_FL_INSERT_RANGE).  If the
+	 * data was just moved around, GC fails to free the zone, but the zone
+	 * becomes a GC candidate again as soon as all previous GC I/O has
+	 * finished and these blocks will be moved out eventually.
 	 */
 	if (old_startblock != NULLFSBLOCK &&
 	    old_startblock != data.br_startblock)
-- 
2.47.3

