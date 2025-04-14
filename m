Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6E41862
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609033; cv=none; b=UGQA/s6RlRlKr6cgaWqHIgNLpBUURofAejBcoHi4nevoJfM8KQ95/ZY7KRsvGJfDm8IG7sJ4oZ4TgnalFtRV0sl9MFaUWw1qBVPrRbeCd5/MGxbEer+Tfy1eiR3kWhkvaAFexatCEnPIQ2Nb0ejb+J4918cHn++Jzvom/eB+55o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609033; c=relaxed/simple;
	bh=QOsqewRUbe0PGyimK4ufkoNLmMWcUFmc3K/HAF3BxzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmSuKlvl4U4WSMaE92+3DiRfvdegHje/a6w3N37rjNj6xQtZSqorN1farWFOcrFDgROYnonXrz+mm8tBNAmLkb4kDqqk4zXf3TS25wNC+9eFO4ZIqmKRduXekeU5RFUZQuA0M/orMp3FJEPoMWYHPSkcwMdGB8R5oKJzQNjifvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=peJHFOfO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="peJHFOfO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0K2ALQXLY+D8g8SNSSbrPfQmxiOA4rEdTCdHO2J9ybU=; b=peJHFOfO64tOqz8t+fjuww27Vo
	jMZuO8UmeqXqsuk84T1eXM9PW/qRi+wBhViVbVBJM4HFRrQ9SW1wwu9+anAYmAyLZMW0mAHDrLfhC
	0AHqosnkTU7LOJdqzfoxPYyuXGbUtA0aoiQ29oXPU2DVCjbWJMhWFjEOUXrGj0+l9coaLCLXe4pfy
	gl52A9dLWgWdT7d6mTCS2jzbKmI1v/A6slLJa8AxYCcEU5mY2kIyHKoSjalMtS62NEIVqfOf0xsvg
	tOYVEtuxL+ulppi+JSVs2gd8X+ro3MS1vulueOHhwPJqKx2HI/YXx7TM6X9fspOox9/9dQhmUMuC/
	vMgNMnfQ==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVL-00000000iDW-10bi;
	Mon, 14 Apr 2025 05:37:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/43] xfs: allow internal RT devices for zoned mode
Date: Mon, 14 Apr 2025 07:35:55 +0200
Message-ID: <20250414053629.360672-13-hch@lst.de>
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

Source kernel commit: bdc03eb5f98f6f1ae4bd5e020d1582a23efb7799

Allow creating an RT subvolume on the same device as the main data
device.  This is mostly used for SMR HDDs where the conventional zones
are used for the data device and the sequential write required zones
for the zoned RT section.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_group.h   | 6 ++++--
 libxfs/xfs_rtgroup.h | 8 +++++---
 libxfs/xfs_sb.c      | 1 +
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
index 242b05627c7a..a70096113384 100644
--- a/libxfs/xfs_group.h
+++ b/libxfs/xfs_group.h
@@ -107,9 +107,11 @@ xfs_gbno_to_daddr(
 	xfs_agblock_t		gbno)
 {
 	struct xfs_mount	*mp = xg->xg_mount;
-	uint32_t		blocks = mp->m_groups[xg->xg_type].blocks;
+	struct xfs_groups	*g = &mp->m_groups[xg->xg_type];
+	xfs_fsblock_t		fsbno;
 
-	return XFS_FSB_TO_BB(mp, (xfs_fsblock_t)xg->xg_gno * blocks + gbno);
+	fsbno = (xfs_fsblock_t)xg->xg_gno * g->blocks + gbno;
+	return XFS_FSB_TO_BB(mp, g->start_fsb + fsbno);
 }
 
 static inline uint32_t
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 9c7e03f913cb..e35d1d798327 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -230,7 +230,8 @@ xfs_rtb_to_daddr(
 	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
 	uint64_t		start_bno = (xfs_rtblock_t)rgno * g->blocks;
 
-	return XFS_FSB_TO_BB(mp, start_bno + (rtbno & g->blkmask));
+	return XFS_FSB_TO_BB(mp,
+		g->start_fsb + start_bno + (rtbno & g->blkmask));
 }
 
 static inline xfs_rtblock_t
@@ -238,10 +239,11 @@ xfs_daddr_to_rtb(
 	struct xfs_mount	*mp,
 	xfs_daddr_t		daddr)
 {
-	xfs_rfsblock_t		bno = XFS_BB_TO_FSBT(mp, daddr);
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	xfs_rfsblock_t		bno;
 
+	bno = XFS_BB_TO_FSBT(mp, daddr) - g->start_fsb;
 	if (xfs_has_rtgroups(mp)) {
-		struct xfs_groups *g = &mp->m_groups[XG_TYPE_RTG];
 		xfs_rgnumber_t	rgno;
 		uint32_t	rgbno;
 
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index bc84792c565c..a95d712363fa 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1201,6 +1201,7 @@ xfs_sb_mount_rextsize(
 		rgs->blocks = sbp->sb_rgextents * sbp->sb_rextsize;
 		rgs->blklog = mp->m_sb.sb_rgblklog;
 		rgs->blkmask = xfs_mask32lo(mp->m_sb.sb_rgblklog);
+		rgs->start_fsb = mp->m_sb.sb_rtstart;
 	} else {
 		rgs->blocks = 0;
 		rgs->blklog = 0;
-- 
2.47.2

