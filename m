Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019BBC129
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 04:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714366168; cv=none; b=jxvb+vtzppvoo/ECy5av/sh+v8w/FPYsOz9DDPQtZl0B0S3vgjAZlbizFDzTjFSquJHEWqMCCSvCkmkL622ZOZ9FdF3VdJNzUDZkf+ds0/MPuqyaR1dAYW+mw+L5RzUih+HfodHtfXfwhfKw2BmyWGB1UA2u4xvRU3J+cCyZDMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714366168; c=relaxed/simple;
	bh=fsPgkn26zdjYdjd6qmuC6bskW4HXsUTLqEl+teK7in0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CpCC2d6qqGmATHgrShffJ9OfFotjPCAJ4KIkuChjRvTaR+St/H7O93aAQyIRUFVZXTU4PIgi3348qTbIcIuzYupVZ2d7QxsmeT3/Ntzvogrm2JU6JPu2qQwnfuGxIzpngudhdMIkHEUwB54GD2hliuHXMoyv4LhJEz5IW5J7b5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bROKuwXj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bROKuwXj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fXvv2gQOqGyZT04ePXFPVzIb9yv5GF39uRGki/KfwcA=; b=bROKuwXjGJ7lmka//GHSie7oxR
	Vf5BjrUIxg1LdRjz7qWluZu6gehzmdwvQEHUxjeLEgEDGYVYUgE7fggi9L966NPV8nakLeN2n3aRb
	MppF11GR9q4xpeKwIObgdtmWSAF/Ouqzv1Tf5uG3ByZtnTpYUrAXaMJkRwqMWWQbzyN3APxYPpJHs
	lY4ZsndqGzrCydrA325uDPZh82NOLm/YY2sPJCSPPR2MS6MLUKthn6a4F7hYXVHfMluu2u7XV87zv
	tzQy4cpO/tGtU0NzDdQDwCe54BMcnY0z7/KptRCqNXjD7cH7seOqCNSwlz02jJM66ondyDJvXrg07
	5mW7ONgg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1IxC-00000001S5J-136C;
	Mon, 29 Apr 2024 04:49:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent
Date: Mon, 29 Apr 2024 06:49:11 +0200
Message-Id: <20240429044917.1504566-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429044917.1504566-1-hch@lst.de>
References: <20240429044917.1504566-1-hch@lst.de>
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

