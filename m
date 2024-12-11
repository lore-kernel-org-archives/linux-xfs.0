Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854071F0E4D
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907481; cv=none; b=BcwzjdQUPXmiX1xpHP2dBpjYvD1127oXdwzeL6RW76VoCw7RRari7GDO4zDLf87QawxkS9T+wE/yxfT4ED/r9VpXc575gHuCnQbumPtGE8jsaZtWcf37tJOkp9oKrmZASxSvrS+Yq5gkSXklv1EPycoTuvL6FIPFPuqphfrHjtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907481; c=relaxed/simple;
	bh=mBkqdH+Jlyv2aXvqA7d2xXPXU4fUhd2nR8N5gt21ulY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3jIValSoIFEbt/fsS6KIHqgXxjHCjasvRihEvYQOr0/ubWkK/xbOSbkYlr/L+k7vbUx+RQ2z50b8a1Tjjko/268xqKB+ce4rHQ7ajdtyQ75UcX6zdS8yPcfO0h1kRQXTVcJiKIrIeujCmGeuk29FwWtNdLWIaTeD/y50cwBS8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zgZ5AIQs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zgZ5AIQs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LwK5DHayF6ybrOig5cpfqNoSl7+InVjpFp9s3k6mrRU=; b=zgZ5AIQsd846CwV2kJxX0j8it4
	N+Q5sxkyaarVPGmvWzaHpVLieTsG2/L6w5vI9mQHmc9RFfTz0CANN9aJPvt81Wj8n0oTpKnIx+Rsc
	yB7Tpp2GPHYOigdfhGPT575JTvGtmr4TOQ2t1lLyEBedCiL2lGqf2VXT1y41/Sv2uNkbQBNaFxXYi
	o+TIECvu68HQW8Hu2hcjEXUk2s0I/demoettjktRHIthpgxBBfEAsUeNR4b2jRPfJS/rIire06VTN
	7p4XY5Lz6QprO2ppj9B1x9z8wq2A/CGVwRPnnhOe0tSmaZ8fOghlMErzRiP9l73iHnSzFD4ehKTz9
	FeehuMJw==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXf-0000000EJMR-1g9b;
	Wed, 11 Dec 2024 08:58:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 29/43] xfs: wire up zoned block freeing in xfs_rtextent_free_finish_item
Date: Wed, 11 Dec 2024 09:54:54 +0100
Message-ID: <20241211085636.1380516-30-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Make xfs_rtextent_free_finish_item call into the zoned allocator to free
blocks on zoned RT devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extfree_item.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a25c713ff888..777438b853da 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -29,6 +29,7 @@
 #include "xfs_inode.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_zone_alloc.h"
 
 struct kmem_cache	*xfs_efi_cache;
 struct kmem_cache	*xfs_efd_cache;
@@ -767,21 +768,35 @@ xfs_rtextent_free_finish_item(
 
 	trace_xfs_extent_free_deferred(mp, xefi);
 
-	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED)) {
-		if (*rtgp != to_rtg(xefi->xefi_group)) {
-			*rtgp = to_rtg(xefi->xefi_group);
-			xfs_rtgroup_lock(*rtgp, XFS_RTGLOCK_BITMAP);
-			xfs_rtgroup_trans_join(tp, *rtgp,
-					XFS_RTGLOCK_BITMAP);
-		}
-		error = xfs_rtfree_blocks(tp, *rtgp,
-				xefi->xefi_startblock, xefi->xefi_blockcount);
+	if (xefi->xefi_flags & XFS_EFI_CANCELLED)
+		goto done;
+
+	if (*rtgp != to_rtg(xefi->xefi_group)) {
+		unsigned int		lock_flags;
+
+		if (xfs_has_zoned(mp))
+			lock_flags = XFS_RTGLOCK_RMAP;
+		else
+			lock_flags = XFS_RTGLOCK_BITMAP;
+
+		*rtgp = to_rtg(xefi->xefi_group);
+		xfs_rtgroup_lock(*rtgp, lock_flags);
+		xfs_rtgroup_trans_join(tp, *rtgp, lock_flags);
 	}
+
+	if (xfs_has_zoned(mp)) {
+		error = xfs_zone_free_blocks(tp, *rtgp, xefi->xefi_startblock,
+				xefi->xefi_blockcount);
+	} else {
+		error = xfs_rtfree_blocks(tp, *rtgp, xefi->xefi_startblock,
+				xefi->xefi_blockcount);
+	}
+
 	if (error == -EAGAIN) {
 		xfs_efd_from_efi(efdp);
 		return error;
 	}
-
+done:
 	xfs_efd_add_extent(efdp, xefi);
 	xfs_extent_free_cancel_item(item);
 	return error;
-- 
2.45.2

