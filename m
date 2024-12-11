Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472911EC4D9
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907429; cv=none; b=HNJnJqyzaatrTuia+jaZGiA1rkY1kA3sZUe6eck92lXCFrSBmH46RUiPWLpYD1n6eFd3zCOxLQk+cDKAzIAjWazqNMgM0nsUrLEBAxizdBx/jIG1IZ/qFz7sroJG4k3Qvi2eEm8T9ZbHkeSNnD+qAXYY8ONxFLwY0tAFmUx4dYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907429; c=relaxed/simple;
	bh=jzLysYlqg5crXiKNneEAPxoervqFGHMnINdxXXRsm38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjuBiHOGvPlJxZl2vPNdIRQ+S7Vypb64/2n0XeFQErVJePI4LbwRy8zRNp7OEUr/j7wkbcY1Eh8439m34gQt4UC1BHoyzrQ/Xa8uYPSTdzsrpPwT6KDgiG0ZL2xpwTcWLwh6Reg3e/tGNeDaPVjeevjna5S85XiFSDOmVsaYH8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yIvTUqh8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yIvTUqh8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0TJpoP7c28gKy/57v+sJ5s2VADf/UPRqHTwaJfjJ694=; b=yIvTUqh8qPWNQKQO+HRYpJ7wsw
	6uzumUPY4j1zRW31kfbUIBh6eERpxdUu6tFU7jFZJnBN2TP8WmyvFDOyWmI0MlJWVGZ1fgECCNxop
	6N419LJ+8UE2ZYpa7pPTc0kITVWrOORns+bhZdLQZwnepL/YYACphJyVBCBhUtl6YDImyjNZ3kKSt
	/TwQjgRy07shbRs1rT1TpRkRh4Hkh24KgJHjEuhPl3QuesWBCd3A82KlVAXQQvgr7NiJxlpvz9VPq
	nKhASZ6Qzju0A4LRcACdS3yY+WdnP32RhjzVTwZ5UEtVk5oODTvaAHf/YgXg9TRn0g8uNArFtpt0z
	lfFaIxXQ==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWp-0000000EJ6o-1kKr;
	Wed, 11 Dec 2024 08:57:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/43] xfs: skip always_cow inodes in xfs_reflink_trim_around_shared
Date: Wed, 11 Dec 2024 09:54:36 +0100
Message-ID: <20241211085636.1380516-12-hch@lst.de>
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

xfs_reflink_trim_around_shared tries to find shared blocks in the
refcount btree.  Always_cow inodes don't have that tree, so don't
bother.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 59f7fc16eb80..3e778e077d09 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -235,7 +235,7 @@ xfs_reflink_trim_around_shared(
 	int			error = 0;
 
 	/* Holes, unwritten, and delalloc extents cannot be shared */
-	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
+	if (!xfs_is_reflink_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
 		*shared = false;
 		return 0;
 	}
-- 
2.45.2

