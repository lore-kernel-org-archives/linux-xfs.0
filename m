Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AAA824BB
	for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2024 05:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725428330; cv=none; b=mDhvi9KTB9zDndbgWRgHS9+T++HrMy+GwNBBb5K2DXUgaXYVztx+e9KG4mrH+xAya9y2+w9CERKh3xIO4FK1hicg+pLfq+6mpgTpKhlqmg+VUNIuvxeEnVUqEuRXQem7rgxqiGHidKZG+KaQvpuAiK5Ant9H6Q6o/J5v58TuKR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725428330; c=relaxed/simple;
	bh=/AF6AZBhrD3JCjMsN9+N3jeK3AH23NUlKw+UFg/1z0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApyvPWKOs6eHJ8NYyDke4KqckafbkOqyLrexEE8o0Xfnp8UN+o/pOur+79XqVHsp8otcCN79p0woIf56/gCCnUoGppSdyIPsi3deXK+ylliFaEmIanosGKZPsJvLBZUMEUvHJmCCayA57R8McoiM8M7JqGq/aqtbQyv3iNH9I/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m8gqUAts; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m8gqUAts"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GxakuWnZlk1Cja6zNPKoYqRJawfrro9f9mes9fRMKX0=; b=m8gqUAtsEdiZ3yim2yHpYhX24p
	91QahTV1ZlQ/82f6zN8kAe1y3/eOFCQ9Dl+2Lw0buARYnF6k2NVoLj9c5nYrRHMhJNV9M7vqB+NmH
	wbprWgGZYq4y/8AgE9sS9ROL4BRVYFYGc9NUjtCcibEAlOVGVJ/c155cefsot15FilO7tkhxr7Zun
	DUc5QugsgEUjRqQaSx2Uo2+OPo2iK944oX8jZBc58SUO7Z+lSFqpa+GWPHzfyXf8J89au1/0egNnU
	aRVA7Nlr203WzWPLGLrr364Wi/8Pd8vZhHcFJudZh14fiBLFZ6gKUfOENVawEsNAnUYRe5HeTyaVU
	RLBQFlOQ==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1slijA-00000002v9l-2TLW;
	Wed, 04 Sep 2024 05:38:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: don't ifdef around the exact minlen allocations
Date: Wed,  4 Sep 2024 08:37:57 +0300
Message-ID: <20240904053820.2836285-7-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240904053820.2836285-1-hch@lst.de>
References: <20240904053820.2836285-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Exact minlen allocations only exist as an error injection tool for debug
builds.  Currently this is implemented using ifdefs, which means the code
isn't even compiled for non-XFS_DEBUG builds.  Enhance the compile test
coverage by always building the code and use the compilers' dead code
elimination to remove it from the generated binary instead.

The only downside is that the new bitfield is unconditionally added to
struct xfs_alloc_args now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c | 7 ++-----
 fs/xfs/libxfs/xfs_alloc.h | 2 --
 fs/xfs/libxfs/xfs_bmap.c  | 6 ------
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 59326f84f6a571..04f64cf9777e21 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2766,7 +2766,6 @@ xfs_alloc_commit_autoreap(
 		xfs_defer_item_unpause(tp, aarp->dfp);
 }
 
-#ifdef DEBUG
 /*
  * Check if an AGF has a free extent record whose length is equal to
  * args->minlen.
@@ -2806,7 +2805,6 @@ xfs_exact_minlen_extent_available(
 
 	return error;
 }
-#endif
 
 /*
  * Decide whether to use this allocation group for this allocation.
@@ -2880,15 +2878,14 @@ xfs_alloc_fix_freelist(
 	if (!xfs_alloc_space_available(args, need, alloc_flags))
 		goto out_agbp_relse;
 
-#ifdef DEBUG
-	if (args->alloc_minlen_only) {
+	if (IS_ENABLED(CONFIG_XFS_DEBUG) && args->alloc_minlen_only) {
 		int stat;
 
 		error = xfs_exact_minlen_extent_available(args, agbp, &stat);
 		if (error || !stat)
 			goto out_agbp_relse;
 	}
-#endif
+
 	/*
 	 * Make the freelist shorter if it's too long.
 	 *
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index fae170825be064..3e927e628f4418 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -55,9 +55,7 @@ typedef struct xfs_alloc_arg {
 	char		wasfromfl;	/* set if allocation is from freelist */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 	enum xfs_ag_resv_type	resv;	/* block reservation to use */
-#ifdef DEBUG
 	bool		alloc_minlen_only; /* allocate exact minlen extent */
-#endif
 } xfs_alloc_arg_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 36ff4c553ba5f7..2f7cfbacec952b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3468,7 +3468,6 @@ xfs_bmap_process_allocated_extent(
 	xfs_bmap_alloc_account(ap);
 }
 
-#ifdef DEBUG
 static int
 xfs_bmap_exact_minlen_extent_alloc(
 	struct xfs_bmalloca	*ap)
@@ -3530,11 +3529,6 @@ xfs_bmap_exact_minlen_extent_alloc(
 
 	return 0;
 }
-#else
-
-#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
-
-#endif
 
 /*
  * If we are not low on available data blocks and we are allocating at
-- 
2.45.2

