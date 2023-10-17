Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C9BCDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344082AbjJQPsm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343939AbjJQPsl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:48:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B0CB0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:48:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF4FC433C8;
        Tue, 17 Oct 2023 15:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557719;
        bh=MNxeo9RJ6sVSu/qIm7Idxss7yE3AZli4J1cXhHuSg+s=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=dCpIKElAlinBbdHubr3c60QRhm5IH4s2ir4HanMmM6oZIPIRuE58gfdFnSVu4fOXp
         yrz0zGsA7YfUboOSzO99iuB812YKibOFPykhSP0BR+sAtEXELGXZCsm6jph+KTQRoq
         y0kuymYWzLyCcS5sbNdJ1WE08pYF/POkoYBLAzAv760h8Q76z4sRTUI3rvxhfjdET2
         m7UiEsP0E4PggGZrcWXENVtCuHbv32iYXhrMWlNWWou6svkVE7TO0X3DuGJMAZKWGo
         K822Mrv+GAi7WMU36c2QB11DQUTPMt3uZg7PDBO+lgS1OvA6gM22yl2GNRZVw7Ioux
         cpl2Kf2I39n6w==
Date:   Tue, 17 Oct 2023 08:48:38 -0700
Subject: [PATCH 3/8] xfs: move the xfs_rtbitmap.c declarations to
 xfs_rtbitmap.h
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755741324.3165534.8809235220859103361.stgit@frogsfrogsfrogs>
In-Reply-To: <169755741268.3165534.11886536508035251574.stgit@frogsfrogsfrogs>
References: <169755741268.3165534.11886536508035251574.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move all the declarations for functionality in xfs_rtbitmap.c into a
separate xfs_rtbitmap.h header file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c     |    2 +
 fs/xfs/libxfs/xfs_rtbitmap.c |    1 +
 fs/xfs/libxfs/xfs_rtbitmap.h |   82 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/fscounters.c    |    2 +
 fs/xfs/scrub/rtbitmap.c      |    2 +
 fs/xfs/scrub/rtsummary.c     |    2 +
 fs/xfs/xfs_fsmap.c           |    2 +
 fs/xfs/xfs_rtalloc.c         |    1 +
 fs/xfs/xfs_rtalloc.h         |   73 -------------------------------------
 9 files changed, 89 insertions(+), 78 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 617cc7e78e38..a47da8d3d1bc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -21,7 +21,7 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 655108a4cd05..9eb1b5aa7e35 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -16,6 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
new file mode 100644
index 000000000000..546dea34bb37
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 05be757668bb..5799e9a94f1f 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -16,7 +16,7 @@
 #include "xfs_health.h"
 #include "xfs_btree.h"
 #include "xfs_ag.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 008ddb599e13..2e5fd52f7af3 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -11,7 +11,7 @@
 #include "xfs_mount.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 437ed9acbb27..f4635a920470 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -13,7 +13,7 @@
 #include "xfs_inode.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_bit.h"
 #include "xfs_bmap.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 736e5545f584..8982c5d6cbd0 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -23,7 +23,7 @@
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc_btree.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_ag.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 0e4e2df08aed..f2eb0c8b595d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -19,6 +19,7 @@
 #include "xfs_icache.h"
 #include "xfs_rtalloc.h"
 #include "xfs_sb.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Read and return the summary information for a given extent size,
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 65c284e9d33e..11859c259a1c 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -11,22 +11,6 @@
 struct xfs_mount;
 struct xfs_trans;
 
-/*
- * XXX: Most of the realtime allocation functions deal in units of realtime
- * extents, not realtime blocks.  This looks funny when paired with the type
- * name and screams for a larger cleanup.
- */
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
 #ifdef CONFIG_XFS_RT
 /*
  * Function prototypes for exported functions.
@@ -48,19 +32,6 @@ xfs_rtallocate_extent(
 	xfs_extlen_t		prod,	/* extent product factor */
 	xfs_rtblock_t		*rtblock); /* out: start block allocated */
 
-/*
- * Free an extent in the realtime subvolume.  Length is expressed in
- * realtime extents, as is the block number.
- */
-int					/* error */
-xfs_rtfree_extent(
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_rtblock_t		bno,	/* starting block number to free */
-	xfs_extlen_t		len);	/* length of extent freed */
-
-/* Same as above, but in units of rt blocks. */
-int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
-		xfs_filblks_t rtlen);
 
 /*
  * Initialize realtime fields in the mount structure.
@@ -102,55 +73,11 @@ xfs_growfs_rt(
 	struct xfs_mount	*mp,	/* file system mount structure */
 	xfs_growfs_rt_t		*in);	/* user supplied growfs struct */
 
-/*
- * From xfs_rtbitmap.c
- */
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
-int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		const struct xfs_rtalloc_rec *low_rec,
-		const struct xfs_rtalloc_rec *high_rec,
-		xfs_rtalloc_query_range_fn fn, void *priv);
-int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
-			  xfs_rtalloc_query_range_fn fn,
-			  void *priv);
-bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
-int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
-			       xfs_rtblock_t start, xfs_extlen_t len,
-			       bool *is_free);
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
-# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
-# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
 # define xfs_growfs_rt(mp,in)				(-ENOSYS)
-# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
-# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
-# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
-# define xfs_verify_rtbno(m, r)				(false)
-# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 # define xfs_rtalloc_reinit_frextents(m)		(0)
 static inline int		/* error */
 xfs_rtmount_init(

