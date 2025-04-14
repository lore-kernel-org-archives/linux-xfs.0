Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0285C1A0BE0
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609070; cv=none; b=oGKGmhUr9Jw8PAYDbodyOIO89emzcQXJsHtX4RCL+nYhAiECcKRGOYemFsP9doG+Lua7/3VFDqaA41Gat9IEtrLws+auf5dHmO7Z3aqEhAiOsEmKuFCC/aSuGcPoX+BibuzNM85xlC27c8fIHb0+y6HtycK2zaSWN8b7/kYKZNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609070; c=relaxed/simple;
	bh=Tkor6IGjdbvJ418ZD3pVUlh8/ML/89Lh3nT5bBca5tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMMs6wtt6fYv9TCV2c8IEAdjNBMN09QstMTxRDabbY6gyPQLomXmZ+Fy8QrfB5qlb9lpDGx2gi3qUK5rb6uRDuw1MnrBWdpA9aDEQalXSbjZqNXm6X3pHkBUGEeEpmJVqeMepPdPwAC+rmJn7vRPWsy7YbNFr+HxIA5Opbsmz0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3/5cAepC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3/5cAepC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jHORbZjpZGFaRonQ1e1Fqpbh5G0E7l0B9AILyOixt5I=; b=3/5cAepC2t1QYUwMDudaQceAUF
	5o8KlxVS1ueDBkot6GtmTxw10k4FyVPwuzYuPh8wD4Eh7lKbEvEXuyPQBFyTxfi3L21U22fm9HTX/
	FHG9qE+Pcznj0/3eorHLBQAx9w9IfygQ6dEKQaiIgKZ4N+bLogwdY/iwzmuh6yh9RI4xtP99cj6JV
	eGrPHlWZ6p7MTxPVGRjxHt1+nekwm1OF6FI++3anZ9Z5E4WtJy1R0WgMyZ6mXxHKd1Xhk0B+SEe9K
	mme651XrjJ2rGJxAu/g/hV/ZsElGBYsCw4LzTTtdLIsAELZi4I9+8qLCA/PRzApFMUMekwIP5NeCD
	twZZPNXA==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVw-00000000iLB-1ebj;
	Mon, 14 Apr 2025 05:37:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 26/43] libfrog: report the zoned geometry
Date: Mon, 14 Apr 2025 07:36:09 +0200
Message-ID: <20250414053629.360672-27-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The rtdev_name helper is based on example code posted by Darrick Wong.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/fsgeom.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index b5220d2d6ffd..571d376c6b3c 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -8,6 +8,20 @@
 #include "fsgeom.h"
 #include "util.h"
 
+static inline const char *
+rtdev_name(
+	struct xfs_fsop_geom	*geo,
+	const char		*rtname)
+{
+	if (!geo->rtblocks)
+		return _("none");
+	if (geo->rtstart)
+		return _("internal");
+	if (!rtname)
+		return _("external");
+	return rtname;
+}
+
 void
 xfs_report_geom(
 	struct xfs_fsop_geom	*geo,
@@ -34,6 +48,7 @@ xfs_report_geom(
 	int			exchangerange;
 	int			parent;
 	int			metadir;
+	int			zoned;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -55,6 +70,7 @@ xfs_report_geom(
 	exchangerange = geo->flags & XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE ? 1 : 0;
 	parent = geo->flags & XFS_FSOP_GEOM_FLAGS_PARENT ? 1 : 0;
 	metadir = geo->flags & XFS_FSOP_GEOM_FLAGS_METADIR ? 1 : 0;
+	zoned = geo->flags & XFS_FSOP_GEOM_FLAGS_ZONED ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
@@ -68,7 +84,8 @@ xfs_report_geom(
 "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
-"         =%-22s rgcount=%-4d rgsize=%u extents\n"),
+"         =%-22s rgcount=%-4d rgsize=%u extents\n"
+"         =%-22s zoned=%-6d start=%llu reserved=%llu\n"),
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
@@ -81,10 +98,11 @@ xfs_report_geom(
 		isint ? _("internal log") : logname ? logname : _("external"),
 			geo->blocksize, geo->logblocks, logversion,
 		"", geo->logsectsize, geo->logsunit / geo->blocksize, lazycount,
-		!geo->rtblocks ? _("none") : rtname ? rtname : _("external"),
+		rtdev_name(geo, rtname),
 		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
 			(unsigned long long)geo->rtextents,
-		"", geo->rgcount, geo->rgextents);
+		"", geo->rgcount, geo->rgextents,
+		"", zoned, geo->rtstart, geo->rtreserved);
 }
 
 /* Try to obtain the xfs geometry.  On error returns a negative error code. */
-- 
2.47.2

