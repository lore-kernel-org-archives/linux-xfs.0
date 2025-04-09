Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB19725A638
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185466; cv=none; b=ho+SwLW2XGqo940Yk8pvfCzNj5CXUaUNVaWrq/YwgKpRpMN4dCDfU9aAbhoLzLa4/KfcdwUmMlNa/yVI+rYiioLInbe6s98BV9YXHfB5Ey86ijLPD2NpbbobdIb4F576bxVJ/BdIcWLp7rHbrZRaQfELgTiCknvOd+947T2QJJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185466; c=relaxed/simple;
	bh=gMVbqX6e9JUQ04Hu1lgS0k4qYtb+RILaL7NbJnGaJy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBfK+PcBq98ws1LEcCt4BXssnJg7jZPRqes6Ra2Vr1hdMHCfiSmbeAtx46W+OyiOgr+EDxV9s1+gTmuisyduKO/7j4mx9zA76E8eKFqvl5TppzGgiVEnd/+KFGWIyG9gEKLhB7aBYe2HGEKeelfvYG6qXTmfRzTcpZNW3wrUaeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c8rjEGFF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c8rjEGFF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=blT+FXP6Y3QSJAGbddZHoTTcYadJClLm6YRo5uQmJLg=; b=c8rjEGFFGnrAf1HT83uonLjhfl
	xv12hRFn55HDhnYLHZeTpUcVGIVKszQzPrBMQKhyruU6sDK03++SVkuofo9JEbB8ehLAZcOdHHi7p
	j7Y12qGlMbRtjscWhN/OrAUtf32A743r+YNJEaWznX697OSwojphLfZjnSYT8kIoHFrWt9ON/30xF
	sGHMAdrvURfZVJWYGA0yVzPssQ5FEZeDdVPnmIzOR6LqX+HWPTLCH+/Xo8T+R1wyreMbMWIht9E5g
	X4evqWZ/JFw7C212XiudyBNg0uuEuO9lzyvSa/zdDKwTXNJSTGtFhaQghaqLKezocqF6wvUcGvhuL
	CAyuINnA==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QJc-00000006Ub5-0Lgh;
	Wed, 09 Apr 2025 07:57:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 26/45] libfrog: report the zoned flag
Date: Wed,  9 Apr 2025 09:55:29 +0200
Message-ID: <20250409075557.3535745-27-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/fsgeom.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 13df88ae43a7..5c4ba29ca9ac 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -34,6 +34,7 @@ xfs_report_geom(
 	int			exchangerange;
 	int			parent;
 	int			metadir;
+	int			zoned;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -55,6 +56,7 @@ xfs_report_geom(
 	exchangerange = geo->flags & XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE ? 1 : 0;
 	parent = geo->flags & XFS_FSOP_GEOM_FLAGS_PARENT ? 1 : 0;
 	metadir = geo->flags & XFS_FSOP_GEOM_FLAGS_METADIR ? 1 : 0;
+	zoned = geo->flags & XFS_FSOP_GEOM_FLAGS_ZONED ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
@@ -68,7 +70,7 @@ xfs_report_geom(
 "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
-"         =%-22s rgcount=%-4d rgsize=%u extents\n"),
+"         =%-22s rgcount=%-4d rgsize=%u extents, zoned=%d\n"),
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
@@ -84,7 +86,7 @@ xfs_report_geom(
 		!geo->rtblocks ? _("none") : rtname ? rtname : _("internal"),
 		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
 			(unsigned long long)geo->rtextents,
-		"", geo->rgcount, geo->rgextents);
+		"", geo->rgcount, geo->rgextents, zoned);
 }
 
 /* Try to obtain the xfs geometry.  On error returns a negative error code. */
-- 
2.47.2

