Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F271E9B25
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907403; cv=none; b=eTBNaH3JotyoSs5C6fwng18B7XZKGH19sna386wyz3Y0FrVMpW96UY7FHfSw36GEHQICoOkg6IB2zN2HkR2hy42TYSKky1v2PbRRYMMPqKt/7PfyknB3PVtFo7GRd7sl8EZ19hbIAQF4xKAhHsXH1J94YYrX8TduM6rJNoZa9yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907403; c=relaxed/simple;
	bh=bHt3/obS1Kj0Iu8SNeDqu9a5k5FRkJ0D0hQaEZokd/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEakL4w0umqW/XkNrcKRdKoAJ5OC8QKhrYRPRUHQs18xFpT2lEq5cN4PhN7t/2YilDaes/HWVuDX/GpVKwinYwsQ5Hpj0JRfZUIsC5hzoRW7G8COYFpdso2Mvqawl/D/d5Idgkgb4hTKusYRtNYk6A9pc+o9xpIgP7jMUoicI84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XSguB5ER; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XSguB5ER"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=E/tvN5jw29m3FdZmzwqO1aZgi92l4WeHW5wIuxkMeMM=; b=XSguB5ER5UzE7Re1Um+/ZXeZa6
	CtGpBdQs/SjxsVVeNmeoZJuEAeRFpiWkR1wx/i8czRCWEFgzoCDWjttFwBYwTzNNoDlLKn6MFB80x
	rayYasXhNgyMtHgiVnYts009MrkxDFwzFlbPQBoqURVps3MzZjF8tKxeBGXNeM3LM4tt09UAMvOct
	Q56J0ABb6epX9gI+YIj0j6s4gYbv8QjhQMEy78IyzYv5YDqtv8w/sk9uMn0ROMUG+q4VJvSCPxXIC
	/SZcVOAqEe66rkkwTZIR/gBw2kuOO+YCUY9JbETeMpph/VpAzKiB6cfYniT0oUAHYAv0tFJZNMZw/
	Ck3yEfGA==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWP-0000000EIy5-00BP;
	Wed, 11 Dec 2024 08:56:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/43] xfs: constify feature checks
Date: Wed, 11 Dec 2024 09:54:26 +0100
Message-ID: <20241211085636.1380516-2-hch@lst.de>
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

We'll need to call them on a const structure in growfs in a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

