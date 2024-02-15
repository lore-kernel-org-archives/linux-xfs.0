Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6742712BF17
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998959; cv=none; b=DMEuhQLzikG8wvEDUXq57MlWB3UH5FNIDMKVAFSqfzXHWyJiNptWAaPoVWtESV8wstuz6ToiUKsvvIXro/Hy1jcaR79gGP3jWR30OcTQsQBZ1aghQFEAHu0MpnStEVZ7BCFY5F77p4OnreWK49txVKdnSzitWL+78at4MJrIEVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998959; c=relaxed/simple;
	bh=PUZr2Cy0g5IXniPfdiNvYvPSIb0bDK6fHaUy8yjCtm4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGFA+jDHMzcCADiRMUq0OPCuasp8nBY5iRI0hSxz7+rYLqrWokFvPdEaNQ3MzxGYkQgup/3ZSC4Y6YtlZmH66V17wkAhOMHhyUCmQvHFEtdlwTnqr6rVpRJD4Lg8ZrgxbEShm9rOUPsATG5LVzBQ3Rkq4J+8AaUQwfnqLWhg+MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLHzvi/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLHzvi/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E453C433F1
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998958;
	bh=PUZr2Cy0g5IXniPfdiNvYvPSIb0bDK6fHaUy8yjCtm4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LLHzvi/0540lXm3mqw1SzTnWYbyY7zr7LZKNNoIx7pZ0VVHGHqhEnl1IebgJCrz/c
	 lzpk1seBL3y3atwheJqzajADnx7qeowPA4Vok7FW/KLt+m/+IGIK36ePCQmD5J0ptI
	 5hvXPnKeH2erYiMg8DGctMTvVG/FwrDNvd7uKjIYpUAuOjXUL6y93AquSitQVIUUK+
	 TKCvqPzhKNjiVm00EqCcZuaJJrMEQMsmJaxM6CMcxKRce6mNS51zDC5+Vn+44EaT66
	 73BEW78BQbGAjkc+4a/t4FJk0Kdg6nr6keITYeqAVKGtAcrEgiroGDyLCOy7LwVqAw
	 po4iA8oO2eqww==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 04/35] xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h
Date: Thu, 15 Feb 2024 13:08:16 +0100
Message-ID: <20240215120907.1542854-5-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 13928113fc5b5e79c91796290a99ed991ac0efe2

Move all the declarations for functionality in xfs_rtbitmap.c into a
separate xfs_rtbitmap.h header file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/libxfs_priv.h  | 56 ++---------------------------
 libxfs/xfs_bmap.c     |  1 +
 libxfs/xfs_rtbitmap.c |  1 +
 libxfs/xfs_rtbitmap.h | 82 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+), 54 deletions(-)
 create mode 100644 libxfs/xfs_rtbitmap.h

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 21d772cf4..ed437e38e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -37,6 +37,8 @@
 #ifndef __LIBXFS_INTERNAL_XFS_H__
 #define __LIBXFS_INTERNAL_XFS_H__
 
+#define CONFIG_XFS_RT
+
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"
 #include "xfs.h"
@@ -494,23 +496,6 @@ void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
 void
 xfs_buf_corruption_error(struct xfs_buf *bp, xfs_failaddr_t fa);
 
-/* XXX: this is clearly a bug - a shared header needs to export this */
-/* xfs_rtalloc.c */
-int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
-int libxfs_rtfree_blocks(struct xfs_trans *, xfs_fsblock_t, xfs_filblks_t);
-bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
-
-struct xfs_rtalloc_rec {
-	xfs_rtblock_t		ar_startext;
-	xfs_rtblock_t		ar_extcount;
-};
-
-typedef int (*xfs_rtalloc_query_range_fn)(
-	struct xfs_mount		*mp,
-	struct xfs_trans		*tp,
-	const struct xfs_rtalloc_rec	*rec,
-	void				*priv);
-
 int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
                         xfs_off_t count_fsb);
 
@@ -547,43 +532,6 @@ xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *mp,
 		xfs_agnumber_t agcount);
 
 /* Keep static checkers quiet about nonstatic functions by exporting */
-int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
-		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
-int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		      xfs_rtblock_t start, xfs_extlen_t len, int val,
-		      xfs_rtblock_t *new, int *stat);
-int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
-		    xfs_rtblock_t start, xfs_rtblock_t limit,
-		    xfs_rtblock_t *rtblock);
-int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
-		    xfs_rtblock_t start, xfs_rtblock_t limit,
-		    xfs_rtblock_t *rtblock);
-int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		       xfs_rtblock_t start, xfs_extlen_t len, int val);
-int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
-			     int log, xfs_rtblock_t bbno, int delta,
-			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
-			     xfs_suminfo_t *sum);
-int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
-			 xfs_fsblock_t *rsb);
-int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		     xfs_rtblock_t start, xfs_extlen_t len,
-		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
-int xfs_rtalloc_query_range(struct xfs_mount *mp,
-			    struct xfs_trans *tp,
-			    const struct xfs_rtalloc_rec *low_rec,
-			    const struct xfs_rtalloc_rec *high_rec,
-			    xfs_rtalloc_query_range_fn fn,
-			    void *priv);
-int xfs_rtalloc_query_all(struct xfs_mount *mp,
-			  struct xfs_trans *tp,
-			  xfs_rtalloc_query_range_fn fn,
-			  void *priv);
-bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
-int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
-			       xfs_rtblock_t start, xfs_extlen_t len,
-			       bool *is_free);
 /* xfs_bmap_util.h */
 struct xfs_bmalloca;
 int xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 6fbfcb25a..bc82b71f3 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -29,6 +29,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
+#include "xfs_rtbitmap.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 2c20c6538..bd0925c9a 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -14,6 +14,7 @@
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_trans.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
new file mode 100644
index 000000000..546dea34b
--- /dev/null
+++ b/libxfs/xfs_rtbitmap.h
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_RTBITMAP_H__
+#define	__XFS_RTBITMAP_H__
+
+/*
+ * XXX: Most of the realtime allocation functions deal in units of realtime
+ * extents, not realtime blocks.  This looks funny when paired with the type
+ * name and screams for a larger cleanup.
+ */
+struct xfs_rtalloc_rec {
+	xfs_rtblock_t		ar_startext;
+	xfs_rtblock_t		ar_extcount;
+};
+
+typedef int (*xfs_rtalloc_query_range_fn)(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv);
+
+#ifdef CONFIG_XFS_RT
+int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
+		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
+int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		      xfs_rtblock_t start, xfs_extlen_t len, int val,
+		      xfs_rtblock_t *new, int *stat);
+int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
+		    xfs_rtblock_t start, xfs_rtblock_t limit,
+		    xfs_rtblock_t *rtblock);
+int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
+		    xfs_rtblock_t start, xfs_rtblock_t limit,
+		    xfs_rtblock_t *rtblock);
+int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		       xfs_rtblock_t start, xfs_extlen_t len, int val);
+int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
+			     int log, xfs_rtblock_t bbno, int delta,
+			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
+			     xfs_suminfo_t *sum);
+int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
+			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
+			 xfs_fsblock_t *rsb);
+int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		     xfs_rtblock_t start, xfs_extlen_t len,
+		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		const struct xfs_rtalloc_rec *low_rec,
+		const struct xfs_rtalloc_rec *high_rec,
+		xfs_rtalloc_query_range_fn fn, void *priv);
+int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
+			  xfs_rtalloc_query_range_fn fn,
+			  void *priv);
+bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
+int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
+			       xfs_rtblock_t start, xfs_extlen_t len,
+			       bool *is_free);
+/*
+ * Free an extent in the realtime subvolume.  Length is expressed in
+ * realtime extents, as is the block number.
+ */
+int					/* error */
+xfs_rtfree_extent(
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_rtblock_t		bno,	/* starting block number to free */
+	xfs_extlen_t		len);	/* length of extent freed */
+
+/* Same as above, but in units of rt blocks. */
+int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
+		xfs_filblks_t rtlen);
+#else /* CONFIG_XFS_RT */
+# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
+# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
+# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
+# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+#endif /* CONFIG_XFS_RT */
+
+#endif /* __XFS_RTBITMAP_H__ */
-- 
2.43.0

