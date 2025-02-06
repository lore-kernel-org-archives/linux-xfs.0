Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D1723C378
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882169; cv=none; b=SQhnHfNOVsNnBXaL+JvW0D1k5bFL1kiJArDrhiWIr4fo49gaY14xWn/9X/q4e6UnXWuUeEO8VbmRtxU9/NWBzjgskWvsc3pDWmHjlx4xpW/bXZn/slDa90OQVPpC3hlo5mlT7O9yDhC7sdkPe3ji8ehP2Wp4uvk3hiVNiQEgv44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882169; c=relaxed/simple;
	bh=QHDk2ZT0vVlnkeZh81hhjlBMad+dHTle8pX6+1yCvPg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C3USRtk1iHOR1iHrPlArfWy4AkhHd2etpZHzzMCRUulBRILMxUty1i3TJWqUWQfLPfulx27H2tpA3lkwBFIGzb4Biz5hNtQFetrww/K8kYxxVWFVx3lM01GxsUwOrW23jfhxegJXCdi4Vxx3LUO5uKZuw6OxKgtVv/bzrxJEfPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pe4JOj/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pe4JOj/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEC4C4CEDD;
	Thu,  6 Feb 2025 22:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882169;
	bh=QHDk2ZT0vVlnkeZh81hhjlBMad+dHTle8pX6+1yCvPg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Pe4JOj/vuCOWb5cMhO9Th+Oz6SsjGCizL9ZnQ5UtExJokkCZe9hfp+zajwc1YMw3Y
	 0ZeOv3W+cvwHLCseqO21apwf1BQndn9Ogn64LmBPr5uxEbo0qH9+PXFCYrDmzFrlZ2
	 3bmSonQhgYF0BKQfEjf9/wG9qXHgSC7j7+iRs133QE+XB/MwjBZJ/ozIfo8v2rpIpS
	 ky+NCSDw9PLEhxEX4AYJUyIsraMkAQo/7s/uu7XuhuF9ufsZf4zN/1jd5ArnZUTJgo
	 UxKPwDzBw1Yk8klK/zJKL31rXwYIrD1OAq7zKUF6nVPCNDdRU5pBuZq4UrMeraSVoL
	 RRdbVd+iijm4Q==
Date: Thu, 06 Feb 2025 14:49:28 -0800
Subject: [PATCH 55/56] xfs: constify feature checks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, cmaiolino@redhat.com, cem@kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173888087633.2739176.17487395520889328668.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 183d988ae9e7ada9d7d4333e2289256e74a5ab5b

They will eventually be needed to be const for zoned growfs, but even
now having such simpler helpers as const as possible is a good thing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/xfs_mount.h  |   12 ++++++------
 libxfs/xfs_rtgroup.c |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index efe7738bcb416a..383cba7d6e3fee 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -207,7 +207,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
 
 #define __XFS_HAS_FEAT(name, NAME) \
-static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
+static inline bool xfs_has_ ## name (const struct xfs_mount *mp) \
 { \
 	return mp->m_features & XFS_FEAT_ ## NAME; \
 }
@@ -253,25 +253,25 @@ __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
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
@@ -279,7 +279,7 @@ static inline bool xfs_has_rtreflink(struct xfs_mount *mp)
 
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
-static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
+static inline bool xfs_has_ ## name (const struct xfs_mount *mp) \
 { \
 	return false; \
 }
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index ba1a38633a6ead..24fb160b806757 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -335,7 +335,7 @@ struct xfs_rtginode_ops {
 	unsigned int		fmt_mask; /* all valid data fork formats */
 
 	/* Does the fs have this feature? */
-	bool			(*enabled)(struct xfs_mount *mp);
+	bool			(*enabled)(const struct xfs_mount *mp);
 
 	/* Create this rtgroup metadata inode and initialize it. */
 	int			(*create)(struct xfs_rtgroup *rtg,

