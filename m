Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E3D25A359
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185409; cv=none; b=s6O8pNmMI47GLE5w5FJ9fMwIk1F6JcbY7cZQnL3PehXIaTwwszhEq+vs21hS9OxWzyHUNfZ8q/fdw9aEuZPTBIVeGBQ1OOlvrfHWYvuFGR8oSaBU1JvOeDUrQcsyUGZVBnhtVsmUjWQhAM4Vp9lPf7Qikkp4bJQQclGZTSlcSxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185409; c=relaxed/simple;
	bh=m2hQj/C25WM0wV81NC9cWgR44fv+FyMvV1lDxyzoLLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQEqFf1lmfa3u6+3qldoSdCB6wF/M4IhharqGx2zYKby22y3gxInb1OU1GfAI3bc6rLWGWjefUAFSYhO8xXgsq86ol9ATAFQJwR3n2gbwQdqK+K2L9vq8bjlgvsfkCA6js5Pi7g0cK9UJe4+HdVq5OrcSnjBrqXz/frwcNCXSZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JP9U/LrP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JP9U/LrP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Lp5Y3tagXYVXUHIpoCqkkk4JkRV/RDPsF/KsILdjENA=; b=JP9U/LrPE99J7LghTBECT1V+ei
	zjn/YV2vJ0lDHguU8fbytsjJvz+83+hBfF4LfRa2e2yvQoQVyrT/CMAMt9TflmDiWpJCPSmPpkTih
	xdI9JKjU0j8MAVR0aH27bfbD9XsxGkKWAQ5XyTOW6H3ONJrjg/YkbAZQB1uAIlhANRxoL74br4BdA
	Qg0OEarvNN3tywpa8uFIzZKB5e6nZhnsPX0orDuEebQW/87fPMyj0hZm1LNmFZqU9alTGJxFHopaZ
	P8ESw6nAd8W3z5pbbPtifCBih+ET1hR/2mWDrHcv5qdhOsINV5r3ZorDcK7HFq89Hm9urWWyP7fQm
	smfPHnOg==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QIh-00000006ULY-0mx8;
	Wed, 09 Apr 2025 07:56:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/45] FIXUP: xfs: define the zoned on-disk format
Date: Wed,  9 Apr 2025 09:55:14 +0200
Message-ID: <20250409075557.3535745-12-hch@lst.de>
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

---
 include/xfs_inode.h |  6 ++++++
 include/xfs_mount.h | 12 ++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 5bb31eb4aa53..efef0da636d1 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -234,6 +234,7 @@ typedef struct xfs_inode {
 	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
 	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
 	union {
+		uint32_t	i_used_blocks;
 		xfs_extlen_t	i_cowextsize;	/* basic cow extent size */
 		uint16_t	i_flushiter;	/* incremented on flush */
 	};
@@ -361,6 +362,11 @@ static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
 }
 #define XFS_IS_REALTIME_INODE(ip) ((ip)->i_diflags & XFS_DIFLAG_REALTIME)
 
+static inline bool xfs_is_zoned_inode(struct xfs_inode *ip)
+{
+	return xfs_has_zoned(ip->i_mount) && XFS_IS_REALTIME_INODE(ip);
+}
+
 /* inode link counts */
 static inline void set_nlink(struct inode *inode, uint32_t nlink)
 {
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 0acf952eb9d7..7856acfb9f8e 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -207,6 +207,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
 #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
+#define XFS_FEAT_ZONED		(1ULL << 29)	/* zoned RT device */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (const struct xfs_mount *mp) \
@@ -253,7 +254,7 @@ __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
-
+__XFS_HAS_FEAT(zoned, ZONED)
 
 static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
 {
@@ -264,7 +265,9 @@ static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
 static inline bool xfs_has_rtsb(const struct xfs_mount *mp)
 {
 	/* all rtgroups filesystems with an rt section have an rtsb */
-	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp);
+	return xfs_has_rtgroups(mp) &&
+		xfs_has_realtime(mp) &&
+		!xfs_has_zoned(mp);
 }
 
 static inline bool xfs_has_rtrmapbt(const struct xfs_mount *mp)
@@ -279,6 +282,11 @@ static inline bool xfs_has_rtreflink(const struct xfs_mount *mp)
 	       xfs_has_reflink(mp);
 }
 
+static inline bool xfs_has_nonzoned(const struct xfs_mount *mp)
+{
+	return !xfs_has_zoned(mp);
+}
+
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
 static inline bool xfs_has_ ## name (const struct xfs_mount *mp) \
-- 
2.47.2

