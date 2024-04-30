Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4E917167B
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481773; cv=none; b=SK218ewh10jCujLczeo00gQyEue7tYi4Df6DKC7TIvx3VOEBR74+BZmiep2wrIpkXG+3ECGRVlko9TW6cnypmF6VHGp1PjR7dcR81xJZK/KZypByWbucEwu+bAB3bFe/2XMRNs0t+Cg1AB9DacQZy9+/lfxgqXouc/Z0yrOiMT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481773; c=relaxed/simple;
	bh=yJKJYxSidfPEHZoQ4Vx55gh75nsSKKrhS4UgHmdyxOg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WDWaqTnHa/ln4a9B0tBXIjit/3Gu1ficzoBAvJoT3m+X/UTRWqQ5HADpa/rb2xJHNnMOrYRJQpkbV+NjBEyTJeCHfgK4EkgeTlid4tNrpFh1/mAVTLcUbu2RR7Kc/p3LqIHTNFG7In05lV3vtOLF6IxYXQH2B3KCtjdfUj8R0o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Oxcaz5eh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Oxcaz5eh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=E6CuyosgAUgne0n/mnNjvPk23t2Bmo/u3/goEC/2enA=; b=Oxcaz5ehm5AGEl2+mh8Qjo1B9e
	AIAniEJOxOMKSBdbn65Hhf+Lhrp2JZGs4Y9Jyg2wwFunYMTMKRU7eJazb3jhzSpGXJm0KHPTD1Yid
	Qu3KENFgjt/JJB4EMuzbj5YWDuMGAwJGOBCS8KB2vSEmIGzFYY2+rZeZ5iKwSIZRhMxNpJVT/l9ug
	bUyXm1P+6+gaWVh+I4fFFpG/TF3CCDlTdnJ+Ne2rHufrOeAa6SkawCHoCI0LKT1Yzz9QHTJ7EttV7
	z0pDDl5Au8higYA5lQvrlDzjU+AtI/7RR9TSBCaJ8H8tPjJrnl+vbowz250mur7DSxgf5aDSIGm21
	sbgqUc3g==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1n1n-00000006P6h-0eXY;
	Tue, 30 Apr 2024 12:56:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent
Date: Tue, 30 Apr 2024 14:56:01 +0200
Message-Id: <20240430125602.1776108-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430125602.1776108-1-hch@lst.de>
References: <20240430125602.1776108-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Accessing if_bytes without the ilock is racy.  Remove the initial
if_bytes == 0 check in xfs_reflink_end_cow_extent and let
ext_iext_lookup_extent fail for this case after we've taken the ilock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 9ce37d366534c3..0ab2ef5b58f6c4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -731,12 +731,6 @@ xfs_reflink_end_cow_extent(
 	int			nmaps;
 	int			error;
 
-	/* No COW extents?  That's easy! */
-	if (ifp->if_bytes == 0) {
-		*offset_fsb = end_fsb;
-		return 0;
-	}
-
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
 			XFS_TRANS_RESERVE, &tp);
-- 
2.39.2

