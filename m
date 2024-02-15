Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9492012BEA6
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998964; cv=none; b=Gk09kpAkPDRnSvNOBwDnhtSi+z8b5LfXkftRAE0ZDpQ/nErBz5PImyNABWN5vWgYOKZWLXsuWmHI2ZZF2shDTUR6wycT8Zf6WDM545ekuaYKb0gHc6GGwrq+Yto7sfJTF3SZcueoL6bPajkoxOaHS80OzGYOZuJfpg1Zyj7amIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998964; c=relaxed/simple;
	bh=l7laD9kY8taAQOekYLAh4twtUeH45R8YrJUFJJKNaNI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZMeUcY3JTShApcUg19/BWm9YuKj4Por9+MBTf5MuH0klZrzcwsrP3MsB7Qn/4TMIQmLk8DHgf70af6KjbpCLdldcMp9at3W28hyRE6V51KReLlAfF5aLKXTxDGAFC4eTlmk98iztfNR63OQhvVty2DCl6plNrM17qdzV7VyARM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWRPwetX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWRPwetX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4ED5C43390
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998964;
	bh=l7laD9kY8taAQOekYLAh4twtUeH45R8YrJUFJJKNaNI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HWRPwetXg65WIaW22qVaHQoLaodX49JySQN70BOK5C6LTQZ/3kpaLOvtBYWWnQakt
	 Utc6nRyY1t78k+yfpcpuIv8Kwcpaid0q46PtqtHTjSYxz1ZwtjPRz+8mDfl5cBnXTo
	 bNNgCGUJohtHVsFE33jQ1JviZbWE7/DS9OK6/5Tpo5ezHpxC4hVgz5iibPI5P+Pex8
	 V4xYFL2juWWe9GBtV6DtAOxrx7NlDB+W2t2mMoHO3/yMXnXzqTwhEn3mFoIndKX3lJ
	 rC1JXNJbwq2SOM8Ya5xM+/fF778MNr6jPqU8BWVLpdf1CthIFfUpU4lfKe9eewJU9j
	 ce8qL/P7htamg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 09/35] xfs: convert rt extent numbers to xfs_rtxnum_t
Date: Thu, 15 Feb 2024 13:08:21 +0100
Message-ID: <20240215120907.1542854-10-cem@kernel.org>
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

Source kernel commit: 2d5f216b77e33f9b503bd42998271da35d4b7055

Further disambiguate the xfs_rtblock_t uses by creating a new type,
xfs_rtxnum_t, to store the position of an extent within the realtime
section, in units of rtextents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 86 +++++++++++++++++++++----------------------
 libxfs/xfs_rtbitmap.h | 26 ++++++-------
 libxfs/xfs_types.h    |  2 +
 3 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 9a9097edd..4085f29b6 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -93,9 +93,9 @@ int
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
@@ -103,9 +103,9 @@ xfs_rtfind_back(
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
@@ -154,7 +154,7 @@ xfs_rtfind_back(
 			 */
 			xfs_trans_brelse(tp, bp);
 			i = bit - XFS_RTHIBIT(wdiff);
-			*rtblock = start - i + 1;
+			*rtx = start - i + 1;
 			return 0;
 		}
 		i = bit - firstbit + 1;
@@ -200,7 +200,7 @@ xfs_rtfind_back(
 			 */
 			xfs_trans_brelse(tp, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
-			*rtblock = start - i + 1;
+			*rtx = start - i + 1;
 			return 0;
 		}
 		i += XFS_NBWORD;
@@ -247,7 +247,7 @@ xfs_rtfind_back(
 			 */
 			xfs_trans_brelse(tp, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
-			*rtblock = start - i + 1;
+			*rtx = start - i + 1;
 			return 0;
 		} else
 			i = len;
@@ -256,7 +256,7 @@ xfs_rtfind_back(
 	 * No match, return that we scanned the whole area.
 	 */
 	xfs_trans_brelse(tp, bp);
-	*rtblock = start - i + 1;
+	*rtx = start - i + 1;
 	return 0;
 }
 
@@ -268,9 +268,9 @@ int
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
@@ -278,9 +278,9 @@ xfs_rtfind_forw(
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
@@ -328,7 +328,7 @@ xfs_rtfind_forw(
 			 */
 			xfs_trans_brelse(tp, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
-			*rtblock = start + i - 1;
+			*rtx = start + i - 1;
 			return 0;
 		}
 		i = lastbit - bit;
@@ -373,7 +373,7 @@ xfs_rtfind_forw(
 			 */
 			xfs_trans_brelse(tp, bp);
 			i += XFS_RTLOBIT(wdiff);
-			*rtblock = start + i - 1;
+			*rtx = start + i - 1;
 			return 0;
 		}
 		i += XFS_NBWORD;
@@ -417,7 +417,7 @@ xfs_rtfind_forw(
 			 */
 			xfs_trans_brelse(tp, bp);
 			i += XFS_RTLOBIT(wdiff);
-			*rtblock = start + i - 1;
+			*rtx = start + i - 1;
 			return 0;
 		} else
 			i = len;
@@ -426,7 +426,7 @@ xfs_rtfind_forw(
 	 * No match, return that we scanned the whole area.
 	 */
 	xfs_trans_brelse(tp, bp);
-	*rtblock = start + i - 1;
+	*rtx = start + i - 1;
 	return 0;
 }
 
@@ -531,7 +531,7 @@ int
 xfs_rtmodify_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* starting block to modify */
+	xfs_rtxnum_t	start,		/* starting rtext to modify */
 	xfs_rtxlen_t	len,		/* length of extent to modify */
 	int		val)		/* 1 for free, 0 for allocated */
 {
@@ -687,15 +687,15 @@ int
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
@@ -763,10 +763,10 @@ int
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
@@ -775,8 +775,8 @@ xfs_rtcheck_range(
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
@@ -939,14 +939,14 @@ STATIC int				/* error */
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
@@ -962,7 +962,7 @@ xfs_rtcheck_alloc_range(
 int					/* error */
 xfs_rtfree_extent(
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	bno,		/* starting block number to free */
+	xfs_rtxnum_t	start,		/* starting rtext number to free */
 	xfs_rtxlen_t	len)		/* length of extent freed */
 {
 	int		error;		/* error value */
@@ -975,14 +975,14 @@ xfs_rtfree_extent(
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
@@ -1016,7 +1016,7 @@ xfs_rtfree_blocks(
 	xfs_filblks_t		rtlen)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	xfs_rtblock_t		bno;
+	xfs_rtxnum_t		start;
 	xfs_filblks_t		len;
 	xfs_extlen_t		mod;
 
@@ -1028,13 +1028,13 @@ xfs_rtfree_blocks(
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
@@ -1048,9 +1048,9 @@ xfs_rtalloc_query_range(
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
 
@@ -1113,11 +1113,11 @@ int
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
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index b0a81fb8d..5e2afb7fe 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 9e45f13f6..c78237852 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
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
+#define	NULLRTEXTNO	((xfs_rtxnum_t)-1)
 
 #define	NULLAGBLOCK	((xfs_agblock_t)-1)
 #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
-- 
2.43.0

