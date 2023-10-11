Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E8FCDB474
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjJKSEa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbjJKSE3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:04:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B65C94
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:04:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83D9C433C8;
        Wed, 11 Oct 2023 18:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047465;
        bh=MM3HjLFXpseSzmN6W04R2Dv1SBYbTcu56TBbRk+pnKQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=TqW90wzLySljzrMAUmkA/wd5Rxg7oDs1RtmrT5wzMJ1AV24vFqmslxlYrn/Wg7EPe
         JUz1I1w6zf+0rRDSN6pnfVYI3h7dj5s2l3cthzS3jOI3DgSW+0Lp0M1ZSTsyjmrHKm
         0gxOF+l4GJm99h6Nkbb+h3jZwY0YASszmZPjNvLK9d+C/rI1w6YLKVheFiyxhiWnlw
         z6jJIJXXUs5NWCap7N+s8jrO99w+DFkxr8ophuy9ORPvIEV/Uo6+tHiyERUCjyfjot
         MUu60wbSAmCkN3ydH0LeXZgsV5d1I49mQk2OzHVj4H00hoFaDg5yFFhsmZdPEDZDo+
         F4c+73/z8Ja3g==
Date:   Wed, 11 Oct 2023 11:04:24 -0700
Subject: [PATCH 7/7] xfs: convert rt extent numbers to xfs_rtxnum_t
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704720833.1773388.4754367347907860075.stgit@frogsfrogsfrogs>
In-Reply-To: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
References: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Further disambiguate the xfs_rtblock_t uses by creating a new type,
xfs_rtxnum_t, to store the position of an extent within the realtime
section, in units of rtextents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   86 +++++++++++++--------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   26 ++++----
 fs/xfs/libxfs/xfs_types.h    |    2 +
 fs/xfs/scrub/rtbitmap.c      |    6 +-
 fs/xfs/scrub/rtsummary.c     |    2 -
 fs/xfs/scrub/trace.h         |    4 +
 fs/xfs/xfs_bmap_util.c       |   12 ++--
 fs/xfs/xfs_rtalloc.c         |  134 +++++++++++++++++++++---------------------
 fs/xfs/xfs_rtalloc.h         |    6 +-
 9 files changed, 138 insertions(+), 140 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 50a9d23c00c6d..ce14436811319 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -102,9 +102,9 @@ int
 xfs_rtfind_back(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* starting block to look at */
-	xfs_rtblock_t	limit,		/* last block to look at */
-	xfs_rtblock_t	*rtblock)	/* out: start block found */
+	xfs_rtxnum_t	start,		/* starting rtext to look at */
+	xfs_rtxnum_t	limit,		/* last rtext to look at */
+	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
@@ -112,9 +112,9 @@ xfs_rtfind_back(
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
-	xfs_rtblock_t	firstbit;	/* first useful bit in the word */
-	xfs_rtblock_t	i;		/* current bit number rel. to start */
-	xfs_rtblock_t	len;		/* length of inspected area */
+	xfs_rtxnum_t	firstbit;	/* first useful bit in the word */
+	xfs_rtxnum_t	i;		/* current bit number rel. to start */
+	xfs_rtxnum_t	len;		/* length of inspected area */
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
@@ -163,7 +163,7 @@ xfs_rtfind_back(
 			 */
 			xfs_trans_brelse(tp, bp);
 			i = bit - XFS_RTHIBIT(wdiff);
-			*rtblock = start - i + 1;
+			*rtx = start - i + 1;
 			return 0;
 		}
 		i = bit - firstbit + 1;
@@ -209,7 +209,7 @@ xfs_rtfind_back(
 			 */
 			xfs_trans_brelse(tp, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
-			*rtblock = start - i + 1;
+			*rtx = start - i + 1;
 			return 0;
 		}
 		i += XFS_NBWORD;
@@ -256,7 +256,7 @@ xfs_rtfind_back(
 			 */
 			xfs_trans_brelse(tp, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
-			*rtblock = start - i + 1;
+			*rtx = start - i + 1;
 			return 0;
 		} else
 			i = len;
@@ -265,7 +265,7 @@ xfs_rtfind_back(
 	 * No match, return that we scanned the whole area.
 	 */
 	xfs_trans_brelse(tp, bp);
-	*rtblock = start - i + 1;
+	*rtx = start - i + 1;
 	return 0;
 }
 
@@ -277,9 +277,9 @@ int
 xfs_rtfind_forw(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* starting block to look at */
-	xfs_rtblock_t	limit,		/* last block to look at */
-	xfs_rtblock_t	*rtblock)	/* out: start block found */
+	xfs_rtxnum_t	start,		/* starting rtext to look at */
+	xfs_rtxnum_t	limit,		/* last rtext to look at */
+	xfs_rtxnum_t	*rtx)		/* out: start rtext found */
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
@@ -287,9 +287,9 @@ xfs_rtfind_forw(
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
-	xfs_rtblock_t	i;		/* current bit number rel. to start */
-	xfs_rtblock_t	lastbit;	/* last useful bit in the word */
-	xfs_rtblock_t	len;		/* length of inspected area */
+	xfs_rtxnum_t	i;		/* current bit number rel. to start */
+	xfs_rtxnum_t	lastbit;	/* last useful bit in the word */
+	xfs_rtxnum_t	len;		/* length of inspected area */
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	want;		/* mask for "good" values */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
@@ -337,7 +337,7 @@ xfs_rtfind_forw(
 			 */
 			xfs_trans_brelse(tp, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
-			*rtblock = start + i - 1;
+			*rtx = start + i - 1;
 			return 0;
 		}
 		i = lastbit - bit;
@@ -382,7 +382,7 @@ xfs_rtfind_forw(
 			 */
 			xfs_trans_brelse(tp, bp);
 			i += XFS_RTLOBIT(wdiff);
-			*rtblock = start + i - 1;
+			*rtx = start + i - 1;
 			return 0;
 		}
 		i += XFS_NBWORD;
@@ -426,7 +426,7 @@ xfs_rtfind_forw(
 			 */
 			xfs_trans_brelse(tp, bp);
 			i += XFS_RTLOBIT(wdiff);
-			*rtblock = start + i - 1;
+			*rtx = start + i - 1;
 			return 0;
 		} else
 			i = len;
@@ -435,7 +435,7 @@ xfs_rtfind_forw(
 	 * No match, return that we scanned the whole area.
 	 */
 	xfs_trans_brelse(tp, bp);
-	*rtblock = start + i - 1;
+	*rtx = start + i - 1;
 	return 0;
 }
 
@@ -540,7 +540,7 @@ int
 xfs_rtmodify_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* starting block to modify */
+	xfs_rtxnum_t	start,		/* starting rtext to modify */
 	xfs_rtxlen_t	len,		/* length of extent to modify */
 	int		val)		/* 1 for free, 0 for allocated */
 {
@@ -696,15 +696,15 @@ int
 xfs_rtfree_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* starting block to free */
+	xfs_rtxnum_t	start,		/* starting rtext to free */
 	xfs_rtxlen_t	len,		/* length to free */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
 {
-	xfs_rtblock_t	end;		/* end of the freed extent */
+	xfs_rtxnum_t	end;		/* end of the freed extent */
 	int		error;		/* error value */
-	xfs_rtblock_t	postblock;	/* first block freed > end */
-	xfs_rtblock_t	preblock;	/* first block freed < start */
+	xfs_rtxnum_t	postblock;	/* first rtext freed > end */
+	xfs_rtxnum_t	preblock;	/* first rtext freed < start */
 
 	end = start + len - 1;
 	/*
@@ -772,10 +772,10 @@ int
 xfs_rtcheck_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* starting block number of extent */
+	xfs_rtxnum_t	start,		/* starting rtext number of extent */
 	xfs_rtxlen_t	len,		/* length of extent */
 	int		val,		/* 1 for free, 0 for allocated */
-	xfs_rtblock_t	*new,		/* out: first block not matching */
+	xfs_rtxnum_t	*new,		/* out: first rtext not matching */
 	int		*stat)		/* out: 1 for matches, 0 for not */
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
@@ -784,8 +784,8 @@ xfs_rtcheck_range(
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
-	xfs_rtblock_t	i;		/* current bit number rel. to start */
-	xfs_rtblock_t	lastbit;	/* last useful bit in word */
+	xfs_rtxnum_t	i;		/* current bit number rel. to start */
+	xfs_rtxnum_t	lastbit;	/* last useful bit in word */
 	xfs_rtword_t	mask;		/* mask of relevant bits for value */
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
 	int		word;		/* word number in the buffer */
@@ -948,14 +948,14 @@ STATIC int				/* error */
 xfs_rtcheck_alloc_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	bno,		/* starting block number of extent */
+	xfs_rtxnum_t	start,		/* starting rtext number of extent */
 	xfs_rtxlen_t	len)		/* length of extent */
 {
-	xfs_rtblock_t	new;		/* dummy for xfs_rtcheck_range */
+	xfs_rtxnum_t	new;		/* dummy for xfs_rtcheck_range */
 	int		stat;
 	int		error;
 
-	error = xfs_rtcheck_range(mp, tp, bno, len, 0, &new, &stat);
+	error = xfs_rtcheck_range(mp, tp, start, len, 0, &new, &stat);
 	if (error)
 		return error;
 	ASSERT(stat);
@@ -971,7 +971,7 @@ xfs_rtcheck_alloc_range(
 int					/* error */
 xfs_rtfree_extent(
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	bno,		/* starting block number to free */
+	xfs_rtxnum_t	start,		/* starting rtext number to free */
 	xfs_rtxlen_t	len)		/* length of extent freed */
 {
 	int		error;		/* error value */
@@ -984,14 +984,14 @@ xfs_rtfree_extent(
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
-	error = xfs_rtcheck_alloc_range(mp, tp, bno, len);
+	error = xfs_rtcheck_alloc_range(mp, tp, start, len);
 	if (error)
 		return error;
 
 	/*
 	 * Free the range of realtime blocks.
 	 */
-	error = xfs_rtfree_range(mp, tp, bno, len, &sumbp, &sb);
+	error = xfs_rtfree_range(mp, tp, start, len, &sumbp, &sb);
 	if (error) {
 		return error;
 	}
@@ -1025,7 +1025,7 @@ xfs_rtfree_blocks(
 	xfs_filblks_t		rtlen)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	xfs_rtblock_t		bno;
+	xfs_rtxnum_t		start;
 	xfs_filblks_t		len;
 	xfs_extlen_t		mod;
 
@@ -1037,13 +1037,13 @@ xfs_rtfree_blocks(
 		return -EIO;
 	}
 
-	bno = div_u64_rem(rtbno, mp->m_sb.sb_rextsize, &mod);
+	start = div_u64_rem(rtbno, mp->m_sb.sb_rextsize, &mod);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
 	}
 
-	return xfs_rtfree_extent(tp, bno, len);
+	return xfs_rtfree_extent(tp, start, len);
 }
 
 /* Find all the free records within a given range. */
@@ -1057,9 +1057,9 @@ xfs_rtalloc_query_range(
 	void				*priv)
 {
 	struct xfs_rtalloc_rec		rec;
-	xfs_rtblock_t			rtstart;
-	xfs_rtblock_t			rtend;
-	xfs_rtblock_t			high_key;
+	xfs_rtxnum_t			rtstart;
+	xfs_rtxnum_t			rtend;
+	xfs_rtxnum_t			high_key;
 	int				is_free;
 	int				error = 0;
 
@@ -1122,11 +1122,11 @@ int
 xfs_rtalloc_extent_is_free(
 	struct xfs_mount		*mp,
 	struct xfs_trans		*tp,
-	xfs_rtblock_t			start,
+	xfs_rtxnum_t			start,
 	xfs_rtxlen_t			len,
 	bool				*is_free)
 {
-	xfs_rtblock_t			end;
+	xfs_rtxnum_t			end;
 	int				matches;
 	int				error;
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index b0a81fb8dbda2..5e2afb7fea0e7 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -7,12 +7,10 @@
 #define	__XFS_RTBITMAP_H__
 
 /*
- * XXX: Most of the realtime allocation functions deal in units of realtime
- * extents, not realtime blocks.  This looks funny when paired with the type
- * name and screams for a larger cleanup.
+ * Functions for walking free space rtextents in the realtime bitmap.
  */
 struct xfs_rtalloc_rec {
-	xfs_rtblock_t		ar_startext;
+	xfs_rtxnum_t		ar_startext;
 	xfs_rtbxlen_t		ar_extcount;
 };
 
@@ -26,16 +24,16 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
 		  xfs_fileoff_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		      xfs_rtblock_t start, xfs_rtxlen_t len, int val,
-		      xfs_rtblock_t *new, int *stat);
+		      xfs_rtxnum_t start, xfs_rtxlen_t len, int val,
+		      xfs_rtxnum_t *new, int *stat);
 int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
-		    xfs_rtblock_t start, xfs_rtblock_t limit,
-		    xfs_rtblock_t *rtblock);
+		    xfs_rtxnum_t start, xfs_rtxnum_t limit,
+		    xfs_rtxnum_t *rtblock);
 int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
-		    xfs_rtblock_t start, xfs_rtblock_t limit,
-		    xfs_rtblock_t *rtblock);
+		    xfs_rtxnum_t start, xfs_rtxnum_t limit,
+		    xfs_rtxnum_t *rtblock);
 int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		       xfs_rtblock_t start, xfs_rtxlen_t len, int val);
+		       xfs_rtxnum_t start, xfs_rtxlen_t len, int val);
 int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
 			     int log, xfs_fileoff_t bbno, int delta,
 			     struct xfs_buf **rbpp, xfs_fileoff_t *rsb,
@@ -44,7 +42,7 @@ int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
 			 xfs_fileoff_t bbno, int delta, struct xfs_buf **rbpp,
 			 xfs_fileoff_t *rsb);
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		     xfs_rtblock_t start, xfs_rtxlen_t len,
+		     xfs_rtxnum_t start, xfs_rtxlen_t len,
 		     struct xfs_buf **rbpp, xfs_fileoff_t *rsb);
 int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		const struct xfs_rtalloc_rec *low_rec,
@@ -54,7 +52,7 @@ int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
 			  void *priv);
 int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
-			       xfs_rtblock_t start, xfs_rtxlen_t len,
+			       xfs_rtxnum_t start, xfs_rtxlen_t len,
 			       bool *is_free);
 /*
  * Free an extent in the realtime subvolume.  Length is expressed in
@@ -63,7 +61,7 @@ int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
 int					/* error */
 xfs_rtfree_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_rtblock_t		bno,	/* starting block number to free */
+	xfs_rtxnum_t		start,	/* starting rtext number to free */
 	xfs_rtxlen_t		len);	/* length of extent freed */
 
 /* Same as above, but in units of rt blocks. */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 532447a357321..abb07a1c7b0b4 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -32,6 +32,7 @@ typedef uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
 typedef uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
 typedef uint64_t	xfs_fileoff_t;	/* block number in a file */
 typedef uint64_t	xfs_filblks_t;	/* number of blocks in a file */
+typedef uint64_t	xfs_rtxnum_t;	/* rtextent number */
 typedef uint64_t	xfs_rtbxlen_t;	/* rtbitmap extent length in rtextents */
 
 typedef int64_t		xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
@@ -49,6 +50,7 @@ typedef void *		xfs_failaddr_t;
 #define	NULLRFSBLOCK	((xfs_rfsblock_t)-1)
 #define	NULLRTBLOCK	((xfs_rtblock_t)-1)
 #define	NULLFILEOFF	((xfs_fileoff_t)-1)
+#define NULLRTEXTNO	((xfs_rtxnum_t)-1)
 
 #define	NULLAGBLOCK	((xfs_agblock_t)-1)
 #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 0d4bed1e6b8ce..fe871ce224c89 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -59,7 +59,7 @@ xchk_rtbitmap_rec(
 	void			*priv)
 {
 	struct xfs_scrub	*sc = priv;
-	xfs_rtblock_t		startblock;
+	xfs_rtxnum_t		startblock;
 	xfs_filblks_t		blockcount;
 
 	startblock = rec->ar_startext * mp->m_sb.sb_rextsize;
@@ -143,8 +143,8 @@ xchk_xref_is_used_rt_space(
 	xfs_rtblock_t		fsbno,
 	xfs_extlen_t		len)
 {
-	xfs_rtblock_t		startext;
-	xfs_rtblock_t		endext;
+	xfs_rtxnum_t		startext;
+	xfs_rtxnum_t		endext;
 	xfs_rtxlen_t		extcount;
 	bool			is_free;
 	int			error;
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index b96a464ca3e85..c03f6e0074d4d 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -131,7 +131,7 @@ xchk_rtsum_record_free(
 {
 	struct xfs_scrub		*sc = priv;
 	xfs_fileoff_t			rbmoff;
-	xfs_rtblock_t			rtbno;
+	xfs_rtxnum_t			rtbno;
 	xfs_filblks_t			rtlen;
 	xchk_rtsumoff_t			offs;
 	unsigned int			lenlog;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 70cb27e8c292e..5fc3e07d85ebd 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1260,14 +1260,14 @@ TRACE_EVENT(xfarray_sort_stats,
 
 #ifdef CONFIG_XFS_RT
 TRACE_EVENT(xchk_rtsum_record_free,
-	TP_PROTO(struct xfs_mount *mp, xfs_rtblock_t start,
+	TP_PROTO(struct xfs_mount *mp, xfs_rtxnum_t start,
 		 xfs_rtbxlen_t len, unsigned int log, loff_t pos,
 		 xfs_suminfo_t v),
 	TP_ARGS(mp, start, len, log, pos, v),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(dev_t, rtdev)
-		__field(xfs_rtblock_t, start)
+		__field(xfs_rtxnum_t, start)
 		__field(unsigned long long, len)
 		__field(unsigned int, log)
 		__field(loff_t, pos)
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f2efa508200b3..285e9cafe29ef 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -76,7 +76,7 @@ xfs_bmap_rtalloc(
 {
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	xfs_fileoff_t		orig_offset = ap->offset;
-	xfs_rtblock_t		rtb;
+	xfs_rtxnum_t		rtx;
 	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
 	xfs_extlen_t		mod = 0;   /* product factor for allocators */
 	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
@@ -145,8 +145,6 @@ xfs_bmap_rtalloc(
 	 * pick an extent that will space things out in the rt area.
 	 */
 	if (ap->eof && ap->offset == 0) {
-		xfs_rtblock_t rtx; /* realtime extent no */
-
 		error = xfs_rtpick_extent(mp, ap->tp, ralen, &rtx);
 		if (error)
 			return error;
@@ -164,16 +162,16 @@ xfs_bmap_rtalloc(
 		ap->blkno = 0;
 	else
 		do_div(ap->blkno, mp->m_sb.sb_rextsize);
-	rtb = ap->blkno;
+	rtx = ap->blkno;
 	ap->length = ralen;
 	raminlen = max_t(xfs_extlen_t, 1, minlen / mp->m_sb.sb_rextsize);
 	error = xfs_rtallocate_extent(ap->tp, ap->blkno, raminlen, ap->length,
-			&ralen, ap->wasdel, prod, &rtb);
+			&ralen, ap->wasdel, prod, &rtx);
 	if (error)
 		return error;
 
-	if (rtb != NULLRTBLOCK) {
-		ap->blkno = rtb * mp->m_sb.sb_rextsize;
+	if (rtx != NULLRTEXTNO) {
+		ap->blkno = rtx * mp->m_sb.sb_rextsize;
 		ap->length = ralen * mp->m_sb.sb_rextsize;
 		ap->ip->i_nblocks += ap->length;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 5eb23cff281d1..4bb776911a4fb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -148,15 +148,15 @@ STATIC int				/* error */
 xfs_rtallocate_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* start block to allocate */
+	xfs_rtxnum_t	start,		/* start rtext to allocate */
 	xfs_rtxlen_t	len,		/* length to allocate */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
 {
-	xfs_rtblock_t	end;		/* end of the allocated extent */
+	xfs_rtxnum_t	end;		/* end of the allocated rtext */
 	int		error;		/* error value */
-	xfs_rtblock_t	postblock = 0;	/* first block allocated > end */
-	xfs_rtblock_t	preblock = 0;	/* first block allocated < start */
+	xfs_rtxnum_t	postblock = 0;	/* first rtext allocated > end */
+	xfs_rtxnum_t	preblock = 0;	/* first rtext allocated < start */
 
 	end = start + len - 1;
 	/*
@@ -220,7 +220,7 @@ xfs_rtallocate_range(
 /*
  * Attempt to allocate an extent minlen<=len<=maxlen starting from
  * bitmap block bbno.  If we don't get maxlen then use prod to trim
- * the length, if given.  Returns error; returns starting block in *rtblock.
+ * the length, if given.  Returns error; returns starting block in *rtx.
  * The lengths are all in rtextents.
  */
 STATIC int				/* error */
@@ -231,18 +231,18 @@ xfs_rtallocate_extent_block(
 	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
 	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t	*len,		/* out: actual length allocated */
-	xfs_rtblock_t	*nextp,		/* out: next block to try */
+	xfs_rtxnum_t	*nextp,		/* out: next rtext to try */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t	prod,		/* extent product factor */
-	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
+	xfs_rtxnum_t	*rtx)		/* out: start rtext allocated */
 {
-	xfs_rtblock_t	besti;		/* best rtblock found so far */
-	xfs_rtblock_t	bestlen;	/* best length found so far */
-	xfs_rtblock_t	end;		/* last rtblock in chunk */
+	xfs_rtxnum_t	besti;		/* best rtext found so far */
+	xfs_rtxnum_t	bestlen;	/* best length found so far */
+	xfs_rtxnum_t	end;		/* last rtext in chunk */
 	int		error;		/* error value */
-	xfs_rtblock_t	i;		/* current rtblock trying */
-	xfs_rtblock_t	next;		/* next rtblock to try */
+	xfs_rtxnum_t	i;		/* current rtext trying */
+	xfs_rtxnum_t	next;		/* next rtext to try */
 	int		stat;		/* status from internal calls */
 
 	/*
@@ -279,7 +279,7 @@ xfs_rtallocate_extent_block(
 				return error;
 			}
 			*len = maxlen;
-			*rtblock = i;
+			*rtx = i;
 			return 0;
 		}
 		/*
@@ -289,7 +289,7 @@ xfs_rtallocate_extent_block(
 		 * so far, remember it.
 		 */
 		if (minlen < maxlen) {
-			xfs_rtblock_t	thislen;	/* this extent size */
+			xfs_rtxnum_t	thislen;	/* this extent size */
 
 			thislen = next - i;
 			if (thislen >= minlen && thislen > bestlen) {
@@ -331,47 +331,47 @@ xfs_rtallocate_extent_block(
 			return error;
 		}
 		*len = bestlen;
-		*rtblock = besti;
+		*rtx = besti;
 		return 0;
 	}
 	/*
 	 * Allocation failed.  Set *nextp to the next block to try.
 	 */
 	*nextp = next;
-	*rtblock = NULLRTBLOCK;
+	*rtx = NULLRTEXTNO;
 	return 0;
 }
 
 /*
  * Allocate an extent of length minlen<=len<=maxlen, starting at block
  * bno.  If we don't get maxlen then use prod to trim the length, if given.
- * Returns error; returns starting block in *rtblock.
+ * Returns error; returns starting block in *rtx.
  * The lengths are all in rtextents.
  */
 STATIC int				/* error */
 xfs_rtallocate_extent_exact(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	bno,		/* starting block number to allocate */
+	xfs_rtxnum_t	start,		/* starting rtext number to allocate */
 	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
 	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t	prod,		/* extent product factor */
-	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
+	xfs_rtxnum_t	*rtx)		/* out: start rtext allocated */
 {
 	int		error;		/* error value */
 	xfs_rtxlen_t	i;		/* extent length trimmed due to prod */
 	int		isfree;		/* extent is free */
-	xfs_rtblock_t	next;		/* next block to try (dummy) */
+	xfs_rtxnum_t	next;		/* next rtext to try (dummy) */
 
 	ASSERT(minlen % prod == 0);
 	ASSERT(maxlen % prod == 0);
 	/*
 	 * Check if the range in question (for maxlen) is free.
 	 */
-	error = xfs_rtcheck_range(mp, tp, bno, maxlen, 1, &next, &isfree);
+	error = xfs_rtcheck_range(mp, tp, start, maxlen, 1, &next, &isfree);
 	if (error) {
 		return error;
 	}
@@ -379,23 +379,23 @@ xfs_rtallocate_extent_exact(
 		/*
 		 * If it is, allocate it and return success.
 		 */
-		error = xfs_rtallocate_range(mp, tp, bno, maxlen, rbpp, rsb);
+		error = xfs_rtallocate_range(mp, tp, start, maxlen, rbpp, rsb);
 		if (error) {
 			return error;
 		}
 		*len = maxlen;
-		*rtblock = bno;
+		*rtx = start;
 		return 0;
 	}
 	/*
 	 * If not, allocate what there is, if it's at least minlen.
 	 */
-	maxlen = next - bno;
+	maxlen = next - start;
 	if (maxlen < minlen) {
 		/*
 		 * Failed, return failure status.
 		 */
-		*rtblock = NULLRTBLOCK;
+		*rtx = NULLRTEXTNO;
 		return 0;
 	}
 	/*
@@ -407,39 +407,39 @@ xfs_rtallocate_extent_exact(
 			/*
 			 * Now we can't do it, return failure status.
 			 */
-			*rtblock = NULLRTBLOCK;
+			*rtx = NULLRTEXTNO;
 			return 0;
 		}
 	}
 	/*
 	 * Allocate what we can and return it.
 	 */
-	error = xfs_rtallocate_range(mp, tp, bno, maxlen, rbpp, rsb);
+	error = xfs_rtallocate_range(mp, tp, start, maxlen, rbpp, rsb);
 	if (error) {
 		return error;
 	}
 	*len = maxlen;
-	*rtblock = bno;
+	*rtx = start;
 	return 0;
 }
 
 /*
  * Allocate an extent of length minlen<=len<=maxlen, starting as near
- * to bno as possible.  If we don't get maxlen then use prod to trim
+ * to start as possible.  If we don't get maxlen then use prod to trim
  * the length, if given.  The lengths are all in rtextents.
  */
 STATIC int				/* error */
 xfs_rtallocate_extent_near(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	bno,		/* starting block number to allocate */
+	xfs_rtxnum_t	start,		/* starting rtext number to allocate */
 	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
 	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t	prod,		/* extent product factor */
-	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
+	xfs_rtxnum_t	*rtx)		/* out: start rtext allocated */
 {
 	int		any;		/* any useful extents from summary */
 	xfs_fileoff_t	bbno;		/* bitmap block number */
@@ -447,8 +447,8 @@ xfs_rtallocate_extent_near(
 	int		i;		/* bitmap block offset (loop control) */
 	int		j;		/* secondary loop control */
 	int		log2len;	/* log2 of minlen */
-	xfs_rtblock_t	n;		/* next block to try */
-	xfs_rtblock_t	r;		/* result block */
+	xfs_rtxnum_t	n;		/* next rtext to try */
+	xfs_rtxnum_t	r;		/* result rtext */
 
 	ASSERT(minlen % prod == 0);
 	ASSERT(maxlen % prod == 0);
@@ -457,25 +457,25 @@ xfs_rtallocate_extent_near(
 	 * If the block number given is off the end, silently set it to
 	 * the last block.
 	 */
-	if (bno >= mp->m_sb.sb_rextents)
-		bno = mp->m_sb.sb_rextents - 1;
+	if (start >= mp->m_sb.sb_rextents)
+		start = mp->m_sb.sb_rextents - 1;
 
 	/*
 	 * Make sure we don't run off the end of the rt volume.  Be careful
 	 * that adjusting maxlen downwards doesn't cause us to fail the
 	 * alignment checks.
 	 */
-	maxlen = min(mp->m_sb.sb_rextents, bno + maxlen) - bno;
+	maxlen = min(mp->m_sb.sb_rextents, start + maxlen) - start;
 	maxlen -= maxlen % prod;
 	if (maxlen < minlen) {
-		*rtblock = NULLRTBLOCK;
+		*rtx = NULLRTEXTNO;
 		return 0;
 	}
 
 	/*
 	 * Try the exact allocation first.
 	 */
-	error = xfs_rtallocate_extent_exact(mp, tp, bno, minlen, maxlen, len,
+	error = xfs_rtallocate_extent_exact(mp, tp, start, minlen, maxlen, len,
 		rbpp, rsb, prod, &r);
 	if (error) {
 		return error;
@@ -483,11 +483,11 @@ xfs_rtallocate_extent_near(
 	/*
 	 * If the exact allocation worked, return that.
 	 */
-	if (r != NULLRTBLOCK) {
-		*rtblock = r;
+	if (r != NULLRTEXTNO) {
+		*rtx = r;
 		return 0;
 	}
-	bbno = XFS_BITTOBLOCK(mp, bno);
+	bbno = XFS_BITTOBLOCK(mp, start);
 	i = 0;
 	ASSERT(minlen != 0);
 	log2len = xfs_highbit32(minlen);
@@ -526,8 +526,8 @@ xfs_rtallocate_extent_near(
 				/*
 				 * If it worked, return it.
 				 */
-				if (r != NULLRTBLOCK) {
-					*rtblock = r;
+				if (r != NULLRTEXTNO) {
+					*rtx = r;
 					return 0;
 				}
 			}
@@ -571,8 +571,8 @@ xfs_rtallocate_extent_near(
 					/*
 					 * If it works, return the extent.
 					 */
-					if (r != NULLRTBLOCK) {
-						*rtblock = r;
+					if (r != NULLRTEXTNO) {
+						*rtx = r;
 						return 0;
 					}
 				}
@@ -593,8 +593,8 @@ xfs_rtallocate_extent_near(
 				/*
 				 * If it works, return the extent.
 				 */
-				if (r != NULLRTBLOCK) {
-					*rtblock = r;
+				if (r != NULLRTEXTNO) {
+					*rtx = r;
 					return 0;
 				}
 			}
@@ -629,7 +629,7 @@ xfs_rtallocate_extent_near(
 		else
 			break;
 	}
-	*rtblock = NULLRTBLOCK;
+	*rtx = NULLRTEXTNO;
 	return 0;
 }
 
@@ -648,13 +648,13 @@ xfs_rtallocate_extent_size(
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t	prod,		/* extent product factor */
-	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
+	xfs_rtxnum_t	*rtx)		/* out: start rtext allocated */
 {
 	int		error;		/* error value */
 	xfs_fileoff_t	i;		/* bitmap block number */
 	int		l;		/* level number (loop control) */
-	xfs_rtblock_t	n;		/* next block to be tried */
-	xfs_rtblock_t	r;		/* result block number */
+	xfs_rtxnum_t	n;		/* next rtext to be tried */
+	xfs_rtxnum_t	r;		/* result rtext number */
 	xfs_suminfo_t	sum;		/* summary information for extents */
 
 	ASSERT(minlen % prod == 0);
@@ -697,8 +697,8 @@ xfs_rtallocate_extent_size(
 			/*
 			 * If it worked, return that.
 			 */
-			if (r != NULLRTBLOCK) {
-				*rtblock = r;
+			if (r != NULLRTEXTNO) {
+				*rtx = r;
 				return 0;
 			}
 			/*
@@ -715,7 +715,7 @@ xfs_rtallocate_extent_size(
 	 * we're asking for a fixed size extent.
 	 */
 	if (minlen > --maxlen) {
-		*rtblock = NULLRTBLOCK;
+		*rtx = NULLRTEXTNO;
 		return 0;
 	}
 	ASSERT(minlen != 0);
@@ -760,8 +760,8 @@ xfs_rtallocate_extent_size(
 			/*
 			 * If it worked, return that extent.
 			 */
-			if (r != NULLRTBLOCK) {
-				*rtblock = r;
+			if (r != NULLRTEXTNO) {
+				*rtx = r;
 				return 0;
 			}
 			/*
@@ -776,7 +776,7 @@ xfs_rtallocate_extent_size(
 	/*
 	 * Got nothing, return failure.
 	 */
-	*rtblock = NULLRTBLOCK;
+	*rtx = NULLRTEXTNO;
 	return 0;
 }
 
@@ -933,7 +933,7 @@ xfs_growfs_rt(
 	xfs_mount_t	*nmp;		/* new (fake) mount structure */
 	xfs_rfsblock_t	nrblocks;	/* new number of realtime blocks */
 	xfs_extlen_t	nrbmblocks;	/* new number of rt bitmap blocks */
-	xfs_rtblock_t	nrextents;	/* new number of realtime extents */
+	xfs_rtxnum_t	nrextents;	/* new number of realtime extents */
 	uint8_t		nrextslog;	/* new log2 of sb_rextents */
 	xfs_extlen_t	nrsumblocks;	/* new number of summary blocks */
 	uint		nrsumlevels;	/* new rt summary levels */
@@ -1194,17 +1194,17 @@ xfs_growfs_rt(
 int					/* error */
 xfs_rtallocate_extent(
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	bno,		/* starting block number to allocate */
+	xfs_rtxnum_t	start,		/* starting rtext number to allocate */
 	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
 	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	int		wasdel,		/* was a delayed allocation extent */
 	xfs_rtxlen_t	prod,		/* extent product factor */
-	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
+	xfs_rtxnum_t	*rtblock)	/* out: start rtext allocated */
 {
 	xfs_mount_t	*mp = tp->t_mountp;
 	int		error;		/* error value */
-	xfs_rtblock_t	r;		/* result allocated block */
+	xfs_rtxnum_t	r;		/* result allocated rtext */
 	xfs_fileoff_t	sb;		/* summary file block number */
 	struct xfs_buf	*sumbp;		/* summary file block buffer */
 
@@ -1222,18 +1222,18 @@ xfs_rtallocate_extent(
 		if ((i = minlen % prod))
 			minlen += prod - i;
 		if (maxlen < minlen) {
-			*rtblock = NULLRTBLOCK;
+			*rtblock = NULLRTEXTNO;
 			return 0;
 		}
 	}
 
 retry:
 	sumbp = NULL;
-	if (bno == 0) {
+	if (start == 0) {
 		error = xfs_rtallocate_extent_size(mp, tp, minlen, maxlen, len,
 				&sumbp,	&sb, prod, &r);
 	} else {
-		error = xfs_rtallocate_extent_near(mp, tp, bno, minlen, maxlen,
+		error = xfs_rtallocate_extent_near(mp, tp, start, minlen, maxlen,
 				len, &sumbp, &sb, prod, &r);
 	}
 
@@ -1243,7 +1243,7 @@ xfs_rtallocate_extent(
 	/*
 	 * If it worked, update the superblock.
 	 */
-	if (r != NULLRTBLOCK) {
+	if (r != NULLRTEXTNO) {
 		long	slen = (long)*len;
 
 		ASSERT(*len >= minlen && *len <= maxlen);
@@ -1451,9 +1451,9 @@ xfs_rtpick_extent(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtxlen_t	len,		/* allocation length (rtextents) */
-	xfs_rtblock_t	*pick)		/* result rt extent */
+	xfs_rtxnum_t	*pick)		/* result rt extent */
 {
-	xfs_rtblock_t	b;		/* result block */
+	xfs_rtxnum_t	b;		/* result rtext */
 	int		log2;		/* log of sequence number */
 	uint64_t	resid;		/* residual after log removed */
 	uint64_t	seq;		/* sequence number of file creation */
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index ec03cc566bec8..5ac9c15948c82 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -24,13 +24,13 @@ struct xfs_trans;
 int					/* error */
 xfs_rtallocate_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_rtblock_t		bno,	/* starting block number to allocate */
+	xfs_rtxnum_t		start,	/* starting rtext number to allocate */
 	xfs_rtxlen_t		minlen,	/* minimum length to allocate */
 	xfs_rtxlen_t		maxlen,	/* maximum length to allocate */
 	xfs_rtxlen_t		*len,	/* out: actual length allocated */
 	int			wasdel,	/* was a delayed allocation extent */
 	xfs_rtxlen_t		prod,	/* extent product factor */
-	xfs_rtblock_t		*rtblock); /* out: start block allocated */
+	xfs_rtxnum_t		*rtblock); /* out: start rtext allocated */
 
 
 /*
@@ -63,7 +63,7 @@ xfs_rtpick_extent(
 	struct xfs_mount	*mp,	/* file system mount point */
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_rtxlen_t		len,	/* allocation length (rtextents) */
-	xfs_rtblock_t		*pick);	/* result rt extent */
+	xfs_rtxnum_t		*pick);	/* result rt extent */
 
 /*
  * Grow the realtime area of the filesystem.

