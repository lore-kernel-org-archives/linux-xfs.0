Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AE9CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbjJSQX0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbjJSQXZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:23:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68FA126
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:23:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E916C433C9;
        Thu, 19 Oct 2023 16:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732602;
        bh=mOTRttv6MYQZR+xkioJ+HgVwJSNOy5pqOhEtWR5MkyA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=d0yFivCbgSYZQ4xhXSSnJlsU66VrVCt8Xgtg+fJ9RPBS39AwUFXs3ODT4PM5JZJi8
         zjemE/4O5+i2d5BCDdl58qe+C2zkxQahGlwCHWAL1gjaLYTnc2dcwSkb+AQWRfuJPX
         nrmYJOaJOc7rV9RsxFKcdBC4b6/3cclnSaUXHGCSlG20N8ORUNVf0YYJVO+b4Zm4f7
         WZOGOAMBdSs+vb1/Ps/HjulTHY6Q3+zfttPZhwqrwnBWRiA6FEOMirV2vaVksOfucG
         Ff7CKro2qsBgn2Tn2J0MzlVRw16qYNjWc31XSmj9i6CP/xavaDcWD/oFTucIDHbO/H
         oNDJkUziTh5QA==
Date:   Thu, 19 Oct 2023 09:23:21 -0700
Subject: [PATCH 4/8] xfs: convert xfs_extlen_t to xfs_rtxlen_t in the rt
 allocator
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210186.225045.7589178969366628987.stgit@frogsfrogsfrogs>
In-Reply-To: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
References: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In most of the filesystem, we use xfs_extlen_t to store the length of a
file (or AG) space mapping in units of fs blocks.  Unfortunately, the
realtime allocator also uses it to store the length of a rt space
mapping in units of rt extents.  This is confusing, since one rt extent
can consist of many fs blocks.

Separate the two by introducing a new type (xfs_rtxlen_t) to store the
length of a space mapping (in units of realtime extents) that would be
found in a file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   12 ++++-----
 fs/xfs/libxfs/xfs_rtbitmap.h |   11 ++++----
 fs/xfs/libxfs/xfs_types.h    |    1 +
 fs/xfs/scrub/rtbitmap.c      |    2 +
 fs/xfs/xfs_bmap_util.c       |    6 ++--
 fs/xfs/xfs_rtalloc.c         |   58 +++++++++++++++++++++---------------------
 fs/xfs/xfs_rtalloc.h         |   10 ++++---
 7 files changed, 50 insertions(+), 50 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 9eb1b5aa7e35..d33c3e561077 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -534,7 +534,7 @@ xfs_rtmodify_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to modify */
-	xfs_extlen_t	len,		/* length of extent to modify */
+	xfs_rtxlen_t	len,		/* length of extent to modify */
 	int		val)		/* 1 for free, 0 for allocated */
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
@@ -690,7 +690,7 @@ xfs_rtfree_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to free */
-	xfs_extlen_t	len,		/* length to free */
+	xfs_rtxlen_t	len,		/* length to free */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
@@ -766,7 +766,7 @@ xfs_rtcheck_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block number of extent */
-	xfs_extlen_t	len,		/* length of extent */
+	xfs_rtxlen_t	len,		/* length of extent */
 	int		val,		/* 1 for free, 0 for allocated */
 	xfs_rtblock_t	*new,		/* out: first block not matching */
 	int		*stat)		/* out: 1 for matches, 0 for not */
@@ -942,7 +942,7 @@ xfs_rtcheck_alloc_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	bno,		/* starting block number of extent */
-	xfs_extlen_t	len)		/* length of extent */
+	xfs_rtxlen_t	len)		/* length of extent */
 {
 	xfs_rtblock_t	new;		/* dummy for xfs_rtcheck_range */
 	int		stat;
@@ -965,7 +965,7 @@ int					/* error */
 xfs_rtfree_extent(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	bno,		/* starting block number to free */
-	xfs_extlen_t	len)		/* length of extent freed */
+	xfs_rtxlen_t	len)		/* length of extent freed */
 {
 	int		error;		/* error value */
 	xfs_mount_t	*mp;		/* file system mount structure */
@@ -1116,7 +1116,7 @@ xfs_rtalloc_extent_is_free(
 	struct xfs_mount		*mp,
 	struct xfs_trans		*tp,
 	xfs_rtblock_t			start,
-	xfs_extlen_t			len,
+	xfs_rtxlen_t			len,
 	bool				*is_free)
 {
 	xfs_rtblock_t			end;
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 546dea34bb37..d4449610154a 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -26,7 +26,7 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
 		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		      xfs_rtblock_t start, xfs_extlen_t len, int val,
+		      xfs_rtblock_t start, xfs_rtxlen_t len, int val,
 		      xfs_rtblock_t *new, int *stat);
 int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
 		    xfs_rtblock_t start, xfs_rtblock_t limit,
@@ -35,7 +35,7 @@ int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
 		    xfs_rtblock_t start, xfs_rtblock_t limit,
 		    xfs_rtblock_t *rtblock);
 int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		       xfs_rtblock_t start, xfs_extlen_t len, int val);
+		       xfs_rtblock_t start, xfs_rtxlen_t len, int val);
 int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
 			     int log, xfs_rtblock_t bbno, int delta,
 			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
@@ -44,7 +44,7 @@ int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
 			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
 			 xfs_fsblock_t *rsb);
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		     xfs_rtblock_t start, xfs_extlen_t len,
+		     xfs_rtblock_t start, xfs_rtxlen_t len,
 		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
 int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		const struct xfs_rtalloc_rec *low_rec,
@@ -53,9 +53,8 @@ int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
 			  void *priv);
-bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
-			       xfs_rtblock_t start, xfs_extlen_t len,
+			       xfs_rtblock_t start, xfs_rtxlen_t len,
 			       bool *is_free);
 /*
  * Free an extent in the realtime subvolume.  Length is expressed in
@@ -65,7 +64,7 @@ int					/* error */
 xfs_rtfree_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_rtblock_t		bno,	/* starting block number to free */
-	xfs_extlen_t		len);	/* length of extent freed */
+	xfs_rtxlen_t		len);	/* length of extent freed */
 
 /* Same as above, but in units of rt blocks. */
 int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 851220021484..713cb70311ef 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -11,6 +11,7 @@ typedef uint32_t	prid_t;		/* project ID */
 typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
+typedef uint32_t	xfs_rtxlen_t;	/* file extent length in rtextents */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
 typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
 typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 2e5fd52f7af3..71d3e8b85844 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -133,7 +133,7 @@ xchk_xref_is_used_rt_space(
 {
 	xfs_rtblock_t		startext;
 	xfs_rtblock_t		endext;
-	xfs_rtblock_t		extcount;
+	xfs_rtxlen_t		extcount;
 	bool			is_free;
 	int			error;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fcefab687285..574665ca8fea 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -76,13 +76,13 @@ xfs_bmap_rtalloc(
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	xfs_fileoff_t		orig_offset = ap->offset;
 	xfs_rtblock_t		rtb;
-	xfs_extlen_t		prod = 0;  /* product factor for allocators */
+	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
 	xfs_extlen_t		mod = 0;   /* product factor for allocators */
-	xfs_extlen_t		ralen = 0; /* realtime allocation length */
+	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
 	xfs_extlen_t		align;     /* minimum allocation alignment */
 	xfs_extlen_t		orig_length = ap->length;
 	xfs_extlen_t		minlen = mp->m_sb.sb_rextsize;
-	xfs_extlen_t		raminlen;
+	xfs_rtxlen_t		raminlen;
 	bool			rtlocked = false;
 	bool			ignore_locality = false;
 	int			error;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f2eb0c8b595d..1789ae818662 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -144,7 +144,7 @@ xfs_rtallocate_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* start block to allocate */
-	xfs_extlen_t	len,		/* length to allocate */
+	xfs_rtxlen_t	len,		/* length to allocate */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
@@ -216,14 +216,14 @@ xfs_rtallocate_range(
  * Make sure we don't run off the end of the rt volume.  Be careful that
  * adjusting maxlen downwards doesn't cause us to fail the alignment checks.
  */
-static inline xfs_extlen_t
+static inline xfs_rtxlen_t
 xfs_rtallocate_clamp_len(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		startrtx,
-	xfs_extlen_t		rtxlen,
-	xfs_extlen_t		prod)
+	xfs_rtxlen_t		rtxlen,
+	xfs_rtxlen_t		prod)
 {
-	xfs_extlen_t		ret;
+	xfs_rtxlen_t		ret;
 
 	ret = min(mp->m_sb.sb_rextents, startrtx + rtxlen) - startrtx;
 	return rounddown(ret, prod);
@@ -240,13 +240,13 @@ xfs_rtallocate_extent_block(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
-	xfs_extlen_t	minlen,		/* minimum length to allocate */
-	xfs_extlen_t	maxlen,		/* maximum length to allocate */
-	xfs_extlen_t	*len,		/* out: actual length allocated */
+	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
+	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
+	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	xfs_rtblock_t	*nextp,		/* out: next block to try */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
-	xfs_extlen_t	prod,		/* extent product factor */
+	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
 	xfs_rtblock_t	besti;		/* best rtblock found so far */
@@ -319,7 +319,7 @@ xfs_rtallocate_extent_block(
 	 * Searched the whole thing & didn't find a maxlen free extent.
 	 */
 	if (minlen < maxlen && besti != -1) {
-		xfs_extlen_t	p;	/* amount to trim length by */
+		xfs_rtxlen_t	p;	/* amount to trim length by */
 
 		/*
 		 * If size should be a multiple of prod, make that so.
@@ -360,16 +360,16 @@ xfs_rtallocate_extent_exact(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	bno,		/* starting block number to allocate */
-	xfs_extlen_t	minlen,		/* minimum length to allocate */
-	xfs_extlen_t	maxlen,		/* maximum length to allocate */
-	xfs_extlen_t	*len,		/* out: actual length allocated */
+	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
+	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
+	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
-	xfs_extlen_t	prod,		/* extent product factor */
+	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
 	int		error;		/* error value */
-	xfs_extlen_t	i;		/* extent length trimmed due to prod */
+	xfs_rtxlen_t	i;		/* extent length trimmed due to prod */
 	int		isfree;		/* extent is free */
 	xfs_rtblock_t	next;		/* next block to try (dummy) */
 
@@ -440,12 +440,12 @@ xfs_rtallocate_extent_near(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	bno,		/* starting block number to allocate */
-	xfs_extlen_t	minlen,		/* minimum length to allocate */
-	xfs_extlen_t	maxlen,		/* maximum length to allocate */
-	xfs_extlen_t	*len,		/* out: actual length allocated */
+	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
+	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
+	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
-	xfs_extlen_t	prod,		/* extent product factor */
+	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
 	int		any;		/* any useful extents from summary */
@@ -644,12 +644,12 @@ STATIC int				/* error */
 xfs_rtallocate_extent_size(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_extlen_t	minlen,		/* minimum length to allocate */
-	xfs_extlen_t	maxlen,		/* maximum length to allocate */
-	xfs_extlen_t	*len,		/* out: actual length allocated */
+	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
+	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
+	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
-	xfs_extlen_t	prod,		/* extent product factor */
+	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
 	int		error;		/* error value */
@@ -1197,11 +1197,11 @@ int					/* error */
 xfs_rtallocate_extent(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	bno,		/* starting block number to allocate */
-	xfs_extlen_t	minlen,		/* minimum length to allocate */
-	xfs_extlen_t	maxlen,		/* maximum length to allocate */
-	xfs_extlen_t	*len,		/* out: actual length allocated */
+	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
+	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
+	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	int		wasdel,		/* was a delayed allocation extent */
-	xfs_extlen_t	prod,		/* extent product factor */
+	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
 	xfs_mount_t	*mp = tp->t_mountp;
@@ -1217,7 +1217,7 @@ xfs_rtallocate_extent(
 	 * If prod is set then figure out what to do to minlen and maxlen.
 	 */
 	if (prod > 1) {
-		xfs_extlen_t	i;
+		xfs_rtxlen_t	i;
 
 		if ((i = maxlen % prod))
 			maxlen -= i;
@@ -1444,7 +1444,7 @@ int					/* error */
 xfs_rtpick_extent(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_extlen_t	len,		/* allocation length (rtextents) */
+	xfs_rtxlen_t	len,		/* allocation length (rtextents) */
 	xfs_rtblock_t	*pick)		/* result rt extent */
 {
 	xfs_rtblock_t	b;		/* result block */
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 11859c259a1c..24a4a1321de0 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -25,11 +25,11 @@ int					/* error */
 xfs_rtallocate_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_rtblock_t		bno,	/* starting block number to allocate */
-	xfs_extlen_t		minlen,	/* minimum length to allocate */
-	xfs_extlen_t		maxlen,	/* maximum length to allocate */
-	xfs_extlen_t		*len,	/* out: actual length allocated */
+	xfs_rtxlen_t		minlen,	/* minimum length to allocate */
+	xfs_rtxlen_t		maxlen,	/* maximum length to allocate */
+	xfs_rtxlen_t		*len,	/* out: actual length allocated */
 	int			wasdel,	/* was a delayed allocation extent */
-	xfs_extlen_t		prod,	/* extent product factor */
+	xfs_rtxlen_t		prod,	/* extent product factor */
 	xfs_rtblock_t		*rtblock); /* out: start block allocated */
 
 
@@ -62,7 +62,7 @@ int					/* error */
 xfs_rtpick_extent(
 	struct xfs_mount	*mp,	/* file system mount point */
 	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_extlen_t		len,	/* allocation length (rtextents) */
+	xfs_rtxlen_t		len,	/* allocation length (rtextents) */
 	xfs_rtblock_t		*pick);	/* result rt extent */
 
 /*

