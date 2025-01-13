Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634D84E1CA
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 04:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742684; cv=none; b=FLbWPcUD4tevbqFyZ3nqQ9dY8CxuVo78CxuMK3awjs9dyP7TQNqMIa+UC1DkwekLuIVbqAfezp2yf4Z+KspyTX00BfgClNb+S4Xa9EMnkNgVa7mSqIeaTImO5acCEjuGOFg1iIzfPBx9LOrgJJP+5eA+MMgPZH9Ewk7oiBJ5BUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742684; c=relaxed/simple;
	bh=aH1x6J4xdOm/pl+wYtcM5U8tRA8M26WEXRbrzbBbEYY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FygsO4bWtRMn33WWbyB82jEV0x/aodq863XDDEDyqHiZQISCwnQDF/Q+xwqyiPlNehfjn8J32/4xu8wczMNr1/Wz7DmNY0EjSylGMOQMVYoCVB0WZhRD4TeVeYUwofAWihqYBl3dcqXZpq9D8jmK3L4b+duqTOfNaqx8hb5jlUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f90BMLeF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f90BMLeF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gVuIUO0q8PGlYzLCNFOG33HQnPC7w8eVX/Xo62pbs0c=; b=f90BMLeFTaxm+BSBz+yKtsgeDE
	KK5fmBZS74nV0MpSZQDfPilH08zyn8ackM+d/ANscTnwBROkqZprM/GaxNfbfy2w8mjEPIBdx7c2I
	9nmOEKtgLXPyRfhax25I3FgF3kzPFmwbI1HoOq4yzeWIZ/q8FvqntJ/QcAzmxRoOoeLjuGr+/B7js
	sQQ01iGokQGdVxvlQCSDhMlxqKzTIVgtbs5cydH3TQKtv4hXLW8cAPaF/WWjyD17rr3tFgSks1GWe
	+ubLKeudvRU6BIAnF1nF400CuOXI1oVjiVaOJW5DGKvEFS4PMwqhHpiiAOXJjYjQmvb9UoznhMoTc
	RhVVxh9g==;
Received: from 2a02-8389-2341-5b80-421b-ad95-8448-da51.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:421b:ad95:8448:da51] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXC6k-00000003z91-3MTe;
	Mon, 13 Jan 2025 04:31:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: constify feature checks
Date: Mon, 13 Jan 2025 05:31:20 +0100
Message-ID: <20250113043120.2054080-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

They will eventually be needed to be const for zoned growfs, but even
now having such simpler helpers as const as possible is a good thing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.c |  2 +-
 fs/xfs/scrub/scrub.h        |  2 +-
 fs/xfs/xfs_mount.h          | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index a6468e591232..d84d32f1b48f 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -338,7 +338,7 @@ struct xfs_rtginode_ops {
 	unsigned int		fmt_mask; /* all valid data fork formats */
 
 	/* Does the fs have this feature? */
-	bool			(*enabled)(struct xfs_mount *mp);
+	bool			(*enabled)(const struct xfs_mount *mp);
 
 	/* Create this rtgroup metadata inode and initialize it. */
 	int			(*create)(struct xfs_rtgroup *rtg,
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index a1086f1f06d0..a3f1abc91390 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -96,7 +96,7 @@ struct xchk_meta_ops {
 	int		(*repair_eval)(struct xfs_scrub *sc);
 
 	/* Decide if we even have this piece of metadata. */
-	bool		(*has)(struct xfs_mount *);
+	bool		(*has)(const struct xfs_mount *);
 
 	/* type describing required/allowed inputs */
 	enum xchk_type	type;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9a1516080e63..fbed172d6770 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -357,7 +357,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NOUUID		(1ULL << 63)	/* ignore uuid during mount */
 
 #define __XFS_HAS_FEAT(name, NAME) \
-static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
+static inline bool xfs_has_ ## name (const struct xfs_mount *mp) \
 { \
 	return mp->m_features & XFS_FEAT_ ## NAME; \
 }
@@ -393,25 +393,25 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
 
-static inline bool xfs_has_rtgroups(struct xfs_mount *mp)
+static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
 {
 	/* all metadir file systems also allow rtgroups */
 	return xfs_has_metadir(mp);
 }
 
-static inline bool xfs_has_rtsb(struct xfs_mount *mp)
+static inline bool xfs_has_rtsb(const struct xfs_mount *mp)
 {
 	/* all rtgroups filesystems with an rt section have an rtsb */
 	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp);
 }
 
-static inline bool xfs_has_rtrmapbt(struct xfs_mount *mp)
+static inline bool xfs_has_rtrmapbt(const struct xfs_mount *mp)
 {
 	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp) &&
 	       xfs_has_rmapbt(mp);
 }
 
-static inline bool xfs_has_rtreflink(struct xfs_mount *mp)
+static inline bool xfs_has_rtreflink(const struct xfs_mount *mp)
 {
 	return xfs_has_metadir(mp) && xfs_has_realtime(mp) &&
 	       xfs_has_reflink(mp);
-- 
2.45.2

