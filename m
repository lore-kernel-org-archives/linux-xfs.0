Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D610CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbjJQPyb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbjJQPy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:54:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0590F0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:54:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6EAC433C9;
        Tue, 17 Oct 2023 15:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697558064;
        bh=S0LTby6CThzMRPFtpWjx7V60LTBGvWHCnIw+24gPidg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=uEDrzXDhCYx852oF3gwhk44+6e5wFOYsz0F1fU/18+D7N46Rt/vQPYnDWlu5VkQM2
         2jmynZOS4lXUvZuZdeCnEXYXKRsxj5p5/ViJCj9iuakv//mQv/wwSxMX5zUuSyr6wZ
         Q3BdH5AcBCkUrE9Ii29MyZaLFVdF/MO4ffT2/aaMEoQQNOT5PxpCgxgBtn9IvA/HO2
         Cx79/meQKI4GdMvhN3Wzx/ELEgfNOKDvRnmQKQIM5xlaP0dBTEJ8PWUabg1Xsia7b0
         4sdKl+hl34Fe+C1XrltlAONqSd4vNHqqizK+gMDSes66PAVT22IcJ3cCadsl8cfnn0
         WIHMbq3BK99dw==
Date:   Tue, 17 Oct 2023 08:54:23 -0700
Subject: [PATCH 2/7] xfs: cache last bitmap block in realtime allocator
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        osandov@fb.com, osandov@osandov.com, linux-xfs@vger.kernel.org,
        hch@lst.de
Message-ID: <169755742610.3167911.17327120267300651170.stgit@frogsfrogsfrogs>
In-Reply-To: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
References: <169755742570.3167911.7092954680401838151.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Profiling a workload on a highly fragmented realtime device showed a ton
of CPU cycles being spent in xfs_trans_read_buf() called by
xfs_rtbuf_get(). Further tracing showed that much of that was repeated
calls to xfs_rtbuf_get() for the same block of the realtime bitmap.
These come from xfs_rtallocate_extent_block(): as it walks through
ranges of free bits in the bitmap, each call to xfs_rtcheck_range() and
xfs_rtfind_{forw,back}() gets the same bitmap block. If the bitmap block
is very fragmented, then this is _a lot_ of buffer lookups.

The realtime allocator already passes around a cache of the last used
realtime summary block to avoid repeated reads (the parameters rbpp and
rsb). We can do the same for the realtime bitmap.

This replaces rbpp and rsb with a struct xfs_rtbuf_cache, which caches
the most recently used block for both the realtime bitmap and summary.
xfs_rtbuf_get() now handles the caching instead of the callers, which
requires plumbing xfs_rtbuf_cache to more functions but also makes sure
we don't miss anything.

Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |  130 ++++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   17 ++++-
 fs/xfs/scrub/rtsummary.c     |    4 +
 fs/xfs/xfs_rtalloc.c         |  109 ++++++++++++++---------------------
 4 files changed, 120 insertions(+), 140 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 5a7994e031f3..428a3a5b660d 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -47,6 +47,20 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
 	.verify_write = xfs_rtbuf_verify_write,
 };
 
+void
+xfs_rtbuf_cache_relse(
+	struct xfs_rtalloc_args	*args)
+{
+	if (args->bbuf) {
+		xfs_trans_brelse(args->trans, args->bbuf);
+		args->bbuf = NULL;
+	}
+	if (args->sbuf) {
+		xfs_trans_brelse(args->trans, args->sbuf);
+		args->sbuf = NULL;
+	}
+}
+
 /*
  * Get a buffer for the bitmap or summary file block specified.
  * The buffer is returned read and locked.
@@ -59,12 +73,32 @@ xfs_rtbuf_get(
 	struct xfs_buf		**bpp)		/* output: buffer for the block */
 {
 	struct xfs_mount	*mp = args->mount;
+	struct xfs_buf		**cbpp;		/* cached block buffer */
+	xfs_fsblock_t		*cbp;		/* cached block number */
 	struct xfs_buf		*bp;		/* block buffer, result */
 	struct xfs_inode	*ip;		/* bitmap or summary inode */
 	struct xfs_bmbt_irec	map;
 	int			nmap = 1;
 	int			error;		/* error value */
 
+	cbpp = issum ? &args->bbuf : &args->sbuf;
+	cbp = issum ? &args->bblock : &args->sblock;
+	/*
+	 * If we have a cached buffer, and the block number matches, use that.
+	 */
+	if (*cbpp && *cbp == block) {
+		*bpp = *cbpp;
+		return 0;
+	}
+	/*
+	 * Otherwise we have to have to get the buffer.  If there was an old
+	 * one, get rid of it first.
+	 */
+	if (*cbpp) {
+		xfs_trans_brelse(args->trans, *cbpp);
+		*cbpp = NULL;
+	}
+
 	ip = issum ? mp->m_rsumip : mp->m_rbmip;
 
 	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, 0);
@@ -83,7 +117,8 @@ xfs_rtbuf_get(
 
 	xfs_trans_buf_set_type(args->trans, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
 					     : XFS_BLFT_RTBITMAP_BUF);
-	*bpp = bp;
+	*cbpp = *bpp = bp;
+	*cbp = block;
 	return 0;
 }
 
@@ -174,7 +209,6 @@ xfs_rtfind_back(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			i = bit - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -188,7 +222,6 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			error = xfs_rtbuf_get(args, --block, 0, &bp);
 			if (error) {
 				return error;
@@ -221,7 +254,6 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -235,7 +267,6 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			error = xfs_rtbuf_get(args, --block, 0, &bp);
 			if (error) {
 				return error;
@@ -269,7 +300,6 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtx = start - i + 1;
 			return 0;
@@ -279,7 +309,6 @@ xfs_rtfind_back(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(args->trans, bp);
 	*rtx = start - i + 1;
 	return 0;
 }
@@ -351,7 +380,6 @@ xfs_rtfind_forw(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*rtx = start + i - 1;
 			return 0;
@@ -365,7 +393,6 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
@@ -398,7 +425,6 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtx = start + i - 1;
 			return 0;
@@ -412,7 +438,6 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
@@ -444,7 +469,6 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtx = start + i - 1;
 			return 0;
@@ -454,7 +478,6 @@ xfs_rtfind_forw(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(args->trans, bp);
 	*rtx = start + i - 1;
 	return 0;
 }
@@ -491,8 +514,6 @@ xfs_rtmodify_summary_int(
 	int			log,		/* log2 of extent size */
 	xfs_fileoff_t		bbno,		/* bitmap block number */
 	int			delta,		/* change to make to summary info */
-	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t		*sum)		/* out: summary info for this block */
 {
 	struct xfs_mount	*mp = args->mount;
@@ -511,30 +532,11 @@ xfs_rtmodify_summary_int(
 	 * Compute the block number in the summary file.
 	 */
 	sb = xfs_rtsumoffs_to_block(mp, so);
-	/*
-	 * If we have an old buffer, and the block number matches, use that.
-	 */
-	if (*rbpp && *rsb == sb)
-		bp = *rbpp;
-	/*
-	 * Otherwise we have to get the buffer.
-	 */
-	else {
-		/*
-		 * If there was an old one, get rid of it first.
-		 */
-		if (*rbpp)
-			xfs_trans_brelse(args->trans, *rbpp);
-		error = xfs_rtbuf_get(args, sb, 1, &bp);
-		if (error) {
-			return error;
-		}
-		/*
-		 * Remember this buffer and block for the next call.
-		 */
-		*rbpp = bp;
-		*rsb = sb;
-	}
+
+	error = xfs_rtbuf_get(args, sb, 1, &bp);
+	if (error)
+		return error;
+
 	/*
 	 * Point to the summary information, modify/log it, and/or copy it out.
 	 */
@@ -564,11 +566,9 @@ xfs_rtmodify_summary(
 	struct xfs_rtalloc_args	*args,
 	int			log,		/* log2 of extent size */
 	xfs_fileoff_t		bbno,		/* bitmap block number */
-	int			delta,		/* change to make to summary info */
-	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb)		/* in/out: summary block number */
+	int			delta)		/* in/out: summary block number */
 {
-	return xfs_rtmodify_summary_int(args, log, bbno, delta, rbpp, rsb, NULL);
+	return xfs_rtmodify_summary_int(args, log, bbno, delta, NULL);
 }
 
 /*
@@ -742,9 +742,7 @@ int
 xfs_rtfree_range(
 	struct xfs_rtalloc_args	*args,
 	xfs_rtxnum_t		start,		/* starting rtext to free */
-	xfs_rtxlen_t		len,		/* length to free */
-	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb)		/* in/out: summary block number */
+	xfs_rtxlen_t		len)		/* in/out: summary block number */
 {
 	struct xfs_mount	*mp = args->mount;
 	xfs_rtxnum_t		end;		/* end of the freed extent */
@@ -773,7 +771,7 @@ xfs_rtfree_range(
 	 * Find the next allocated block (end of allocated extent).
 	 */
 	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
-		&postblock);
+			&postblock);
 	if (error)
 		return error;
 	/*
@@ -782,8 +780,8 @@ xfs_rtfree_range(
 	 */
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(args,
-			XFS_RTBLOCKLOG(start - preblock),
-			xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
+				XFS_RTBLOCKLOG(start - preblock),
+				xfs_rtx_to_rbmblock(mp, preblock), -1);
 		if (error) {
 			return error;
 		}
@@ -794,8 +792,8 @@ xfs_rtfree_range(
 	 */
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(args,
-			XFS_RTBLOCKLOG(postblock - end),
-			xfs_rtx_to_rbmblock(mp, end + 1), -1, rbpp, rsb);
+				XFS_RTBLOCKLOG(postblock - end),
+				xfs_rtx_to_rbmblock(mp, end + 1), -1);
 		if (error) {
 			return error;
 		}
@@ -804,10 +802,9 @@ xfs_rtfree_range(
 	 * Increment the summary information corresponding to the entire
 	 * (new) free extent.
 	 */
-	error = xfs_rtmodify_summary(args,
-		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
-	return error;
+	return xfs_rtmodify_summary(args,
+			XFS_RTBLOCKLOG(postblock + 1 - preblock),
+			xfs_rtx_to_rbmblock(mp, preblock), 1);
 }
 
 /*
@@ -879,7 +876,6 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*new = start + i;
 			*stat = 0;
@@ -894,7 +890,6 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
@@ -927,7 +922,6 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -942,7 +936,6 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
@@ -974,7 +967,6 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(args->trans, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -985,7 +977,6 @@ xfs_rtcheck_range(
 	/*
 	 * Successful, return.
 	 */
-	xfs_trans_brelse(args->trans, bp);
 	*new = start + i;
 	*stat = 1;
 	return 0;
@@ -1030,8 +1021,6 @@ xfs_rtfree_extent(
 		.trans		= tp,
 	};
 	int			error;		/* error value */
-	xfs_fsblock_t		sb;		/* summary file block number */
-	struct xfs_buf		*sumbp = NULL;	/* summary file block buffer */
 
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
@@ -1043,10 +1032,10 @@ xfs_rtfree_extent(
 	/*
 	 * Free the range of realtime blocks.
 	 */
-	error = xfs_rtfree_range(&args, start, len, &sumbp, &sb);
-	if (error) {
-		return error;
-	}
+	error = xfs_rtfree_range(&args, start, len);
+	if (error)
+		goto out;
+
 	/*
 	 * Mark more blocks free in the superblock.
 	 */
@@ -1062,7 +1051,10 @@ xfs_rtfree_extent(
 		*(uint64_t *)&VFS_I(mp->m_rbmip)->i_atime = 0;
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 	}
-	return 0;
+	error = 0;
+out:
+	xfs_rtbuf_cache_relse(&args);
+	return error;
 }
 
 /*
@@ -1153,6 +1145,7 @@ xfs_rtalloc_query_range(
 		rtstart = rtend + 1;
 	}
 
+	xfs_rtbuf_cache_relse(&args);
 	return error;
 }
 
@@ -1191,6 +1184,7 @@ xfs_rtalloc_extent_is_free(
 	int				error;
 
 	error = xfs_rtcheck_range(&args, start, len, 1, &end, &matches);
+	xfs_rtbuf_cache_relse(&args);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 39da0adf0f45..720856192818 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -237,8 +237,16 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 struct xfs_rtalloc_args {
 	struct xfs_mount	*mount;
 	struct xfs_trans	*trans;
+
+	struct xfs_buf *bbuf;	/* bitmap block buffer */
+	struct xfs_buf *sbuf;	/* summary block buffer */
+
+	xfs_fileoff_t bblock;	/* bitmap block number */
+	xfs_fileoff_t sblock;	/* summary block number */
 };
 
+void xfs_rtbuf_cache_relse(struct xfs_rtalloc_args *args);
+
 int xfs_rtbuf_get(struct xfs_rtalloc_args *args, xfs_fileoff_t block,
 		int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
@@ -250,13 +258,11 @@ int xfs_rtfind_forw(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 int xfs_rtmodify_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxlen_t len, int val);
 int xfs_rtmodify_summary_int(struct xfs_rtalloc_args *args, int log,
-		xfs_fileoff_t bbno, int delta, struct xfs_buf **rbpp,
-		xfs_fileoff_t *rsb, xfs_suminfo_t *sum);
+		xfs_fileoff_t bbno, int delta, xfs_suminfo_t *sum);
 int xfs_rtmodify_summary(struct xfs_rtalloc_args *args, int log,
-		xfs_fileoff_t bbno, int delta, struct xfs_buf **rbpp,
-		xfs_fileoff_t *rsb);
+		xfs_fileoff_t bbno, int delta);
 int xfs_rtfree_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
-		xfs_rtxlen_t len, struct xfs_buf **rbpp, xfs_fileoff_t *rsb);
+		xfs_rtxlen_t len);
 int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		const struct xfs_rtalloc_rec *low_rec,
 		const struct xfs_rtalloc_rec *high_rec,
@@ -304,6 +310,7 @@ void xfs_suminfo_add(struct xfs_mount *mp, union xfs_suminfo_raw *infoptr,
 # define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
 # define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 static inline xfs_filblks_t
 xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 3f6f6efe7375..e711e68ff996 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -217,7 +217,7 @@ xchk_rtsum_compare(
 		/* Read a block's worth of computed rtsummary file. */
 		error = xfsum_copyout(sc, sumoff, sc->buf, mp->m_blockwsize);
 		if (error) {
-			xfs_trans_brelse(sc->tp, bp);
+			xfs_rtbuf_cache_relse(&args);
 			return error;
 		}
 
@@ -225,7 +225,7 @@ xchk_rtsum_compare(
 					mp->m_blockwsize << XFS_WORDLOG) != 0)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
 
-		xfs_trans_brelse(sc->tp, bp);
+		xfs_rtbuf_cache_relse(&args);
 		sumoff += mp->m_blockwsize;
 	}
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 922d2fdcf953..f481efcf8445 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -32,11 +32,9 @@ xfs_rtget_summary(
 	struct xfs_rtalloc_args	*args,
 	int			log,		/* log2 of extent size */
 	xfs_fileoff_t		bbno,		/* bitmap block number */
-	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t		*sum)		/* out: summary info for this block */
 {
-	return xfs_rtmodify_summary_int(args, log, bbno, 0, rbpp, rsb, sum);
+	return xfs_rtmodify_summary_int(args, log, bbno, 0, sum);
 }
 
 /*
@@ -49,8 +47,6 @@ xfs_rtany_summary(
 	int			low,		/* low log2 extent size */
 	int			high,		/* high log2 extent size */
 	xfs_fileoff_t		bbno,		/* bitmap block number */
-	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
 	int			*stat)		/* out: any good extents here? */
 {
 	struct xfs_mount	*mp = args->mount;
@@ -69,7 +65,7 @@ xfs_rtany_summary(
 		/*
 		 * Get one summary datum.
 		 */
-		error = xfs_rtget_summary(args, log, bbno, rbpp, rsb, &sum);
+		error = xfs_rtget_summary(args, log, bbno, &sum);
 		if (error) {
 			return error;
 		}
@@ -103,34 +99,31 @@ xfs_rtcopy_summary(
 	struct xfs_rtalloc_args	*nargs)
 {
 	xfs_fileoff_t		bbno;		/* bitmap block number */
-	struct xfs_buf		*bp;		/* summary buffer */
 	int			error;		/* error return value */
 	int			log;		/* summary level number (log length) */
 	xfs_suminfo_t		sum;		/* summary data */
-	xfs_fileoff_t		sumbno;		/* summary block number */
 
-	bp = NULL;
 	for (log = oargs->mount->m_rsumlevels - 1; log >= 0; log--) {
 		for (bbno = oargs->mount->m_sb.sb_rbmblocks - 1;
 		     (xfs_srtblock_t)bbno >= 0;
 		     bbno--) {
-			error = xfs_rtget_summary(oargs, log, bbno, &bp,
-				&sumbno, &sum);
+			error = xfs_rtget_summary(oargs, log, bbno, &sum);
 			if (error)
-				return error;
+				goto out;
 			if (sum == 0)
 				continue;
-			error = xfs_rtmodify_summary(oargs, log, bbno, -sum,
-				&bp, &sumbno);
+			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
 			if (error)
-				return error;
-			error = xfs_rtmodify_summary(nargs, log, bbno, sum,
-				&bp, &sumbno);
+				goto out;
+			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
 			if (error)
-				return error;
+				goto out;
 			ASSERT(sum > 0);
 		}
 	}
+	error = 0;
+out:
+	xfs_rtbuf_cache_relse(oargs);
 	return 0;
 }
 /*
@@ -141,9 +134,7 @@ STATIC int				/* error */
 xfs_rtallocate_range(
 	struct xfs_rtalloc_args	*args,
 	xfs_rtxnum_t		start,		/* start rtext to allocate */
-	xfs_rtxlen_t		len,		/* length to allocate */
-	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb)		/* in/out: summary block number */
+	xfs_rtxlen_t		len)		/* in/out: summary block number */
 {
 	struct xfs_mount	*mp = args->mount;
 	xfs_rtxnum_t		end;		/* end of the allocated rtext */
@@ -165,7 +156,7 @@ xfs_rtallocate_range(
 	 * Find the next allocated block (end of free extent).
 	 */
 	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
-		&postblock);
+			&postblock);
 	if (error) {
 		return error;
 	}
@@ -174,8 +165,8 @@ xfs_rtallocate_range(
 	 * (old) free extent.
 	 */
 	error = xfs_rtmodify_summary(args,
-		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
+			XFS_RTBLOCKLOG(postblock + 1 - preblock),
+			xfs_rtx_to_rbmblock(mp, preblock), -1);
 	if (error) {
 		return error;
 	}
@@ -185,8 +176,8 @@ xfs_rtallocate_range(
 	 */
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(args,
-			XFS_RTBLOCKLOG(start - preblock),
-			xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
+				XFS_RTBLOCKLOG(start - preblock),
+				xfs_rtx_to_rbmblock(mp, preblock), 1);
 		if (error) {
 			return error;
 		}
@@ -197,8 +188,8 @@ xfs_rtallocate_range(
 	 */
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(args,
-			XFS_RTBLOCKLOG(postblock - end),
-			xfs_rtx_to_rbmblock(mp, end + 1), 1, rbpp, rsb);
+				XFS_RTBLOCKLOG(postblock - end),
+				xfs_rtx_to_rbmblock(mp, end + 1), 1);
 		if (error) {
 			return error;
 		}
@@ -241,8 +232,6 @@ xfs_rtallocate_extent_block(
 	xfs_rtxlen_t		maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t		*len,		/* out: actual length allocated */
 	xfs_rtxnum_t		*nextp,		/* out: next rtext to try */
-	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t		prod,		/* extent product factor */
 	xfs_rtxnum_t		*rtx)		/* out: start rtext allocated */
 {
@@ -278,8 +267,7 @@ xfs_rtallocate_extent_block(
 			/*
 			 * i for maxlen is all free, allocate and return that.
 			 */
-			error = xfs_rtallocate_range(args, i, maxlen, rbpp,
-				rsb);
+			error = xfs_rtallocate_range(args, i, maxlen);
 			if (error) {
 				return error;
 			}
@@ -331,7 +319,7 @@ xfs_rtallocate_extent_block(
 		/*
 		 * Allocate besti for bestlen & return that.
 		 */
-		error = xfs_rtallocate_range(args, besti, bestlen, rbpp, rsb);
+		error = xfs_rtallocate_range(args, besti, bestlen);
 		if (error) {
 			return error;
 		}
@@ -360,8 +348,6 @@ xfs_rtallocate_extent_exact(
 	xfs_rtxlen_t		minlen,		/* minimum length to allocate */
 	xfs_rtxlen_t		maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t		*len,		/* out: actual length allocated */
-	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t		prod,		/* extent product factor */
 	xfs_rtxnum_t		*rtx)		/* out: start rtext allocated */
 {
@@ -383,7 +369,7 @@ xfs_rtallocate_extent_exact(
 		/*
 		 * If it is, allocate it and return success.
 		 */
-		error = xfs_rtallocate_range(args, start, maxlen, rbpp, rsb);
+		error = xfs_rtallocate_range(args, start, maxlen);
 		if (error) {
 			return error;
 		}
@@ -418,7 +404,7 @@ xfs_rtallocate_extent_exact(
 	/*
 	 * Allocate what we can and return it.
 	 */
-	error = xfs_rtallocate_range(args, start, maxlen, rbpp, rsb);
+	error = xfs_rtallocate_range(args, start, maxlen);
 	if (error) {
 		return error;
 	}
@@ -439,8 +425,6 @@ xfs_rtallocate_extent_near(
 	xfs_rtxlen_t		minlen,		/* minimum length to allocate */
 	xfs_rtxlen_t		maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t		*len,		/* out: actual length allocated */
-	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t		prod,		/* extent product factor */
 	xfs_rtxnum_t		*rtx)		/* out: start rtext allocated */
 {
@@ -475,7 +459,7 @@ xfs_rtallocate_extent_near(
 	 * Try the exact allocation first.
 	 */
 	error = xfs_rtallocate_extent_exact(args, start, minlen, maxlen, len,
-			rbpp, rsb, prod, &r);
+			prod, &r);
 	if (error) {
 		return error;
 	}
@@ -499,7 +483,7 @@ xfs_rtallocate_extent_near(
 		 * starting in this bitmap block.
 		 */
 		error = xfs_rtany_summary(args, log2len, mp->m_rsumlevels - 1,
-			bbno + i, rbpp, rsb, &any);
+				bbno + i, &any);
 		if (error) {
 			return error;
 		}
@@ -517,8 +501,8 @@ xfs_rtallocate_extent_near(
 				 * this block.
 				 */
 				error = xfs_rtallocate_extent_block(args,
-					bbno + i, minlen, maxlen, len, &n, rbpp,
-					rsb, prod, &r);
+						bbno + i, minlen, maxlen, len,
+						&n, prod, &r);
 				if (error) {
 					return error;
 				}
@@ -546,8 +530,9 @@ xfs_rtallocate_extent_near(
 					 * this bitmap block.
 					 */
 					error = xfs_rtany_summary(args,
-						log2len, mp->m_rsumlevels - 1,
-						bbno + j, rbpp, rsb, &any);
+							log2len,
+							mp->m_rsumlevels - 1,
+							bbno + j, &any);
 					if (error) {
 						return error;
 					}
@@ -562,8 +547,9 @@ xfs_rtallocate_extent_near(
 					if (any)
 						continue;
 					error = xfs_rtallocate_extent_block(args,
-						bbno + j, minlen, maxlen,
-						len, &n, rbpp, rsb, prod, &r);
+							bbno + j, minlen,
+							maxlen, len, &n, prod,
+							&r);
 					if (error) {
 						return error;
 					}
@@ -584,8 +570,8 @@ xfs_rtallocate_extent_near(
 				 * that we found.
 				 */
 				error = xfs_rtallocate_extent_block(args,
-					bbno + i, minlen, maxlen, len, &n, rbpp,
-					rsb, prod, &r);
+						bbno + i, minlen, maxlen, len,
+						&n, prod, &r);
 				if (error) {
 					return error;
 				}
@@ -643,8 +629,6 @@ xfs_rtallocate_extent_size(
 	xfs_rtxlen_t		minlen,		/* minimum length to allocate */
 	xfs_rtxlen_t		maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t		*len,		/* out: actual length allocated */
-	struct xfs_buf		**rbpp,		/* in/out: summary block buffer */
-	xfs_fileoff_t		*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t		prod,		/* extent product factor */
 	xfs_rtxnum_t		*rtx)		/* out: start rtext allocated */
 {
@@ -675,8 +659,7 @@ xfs_rtallocate_extent_size(
 			/*
 			 * Get the summary for this level/block.
 			 */
-			error = xfs_rtget_summary(args, l, i, rbpp, rsb,
-				&sum);
+			error = xfs_rtget_summary(args, l, i, &sum);
 			if (error) {
 				return error;
 			}
@@ -689,7 +672,7 @@ xfs_rtallocate_extent_size(
 			 * Try allocating the extent.
 			 */
 			error = xfs_rtallocate_extent_block(args, i, maxlen,
-				maxlen, len, &n, rbpp, rsb, prod, &r);
+					maxlen, len, &n, prod, &r);
 			if (error) {
 				return error;
 			}
@@ -734,8 +717,7 @@ xfs_rtallocate_extent_size(
 			/*
 			 * Get the summary information for this level/block.
 			 */
-			error =	xfs_rtget_summary(args, l, i, rbpp, rsb,
-						  &sum);
+			error =	xfs_rtget_summary(args, l, i, &sum);
 			if (error) {
 				return error;
 			}
@@ -752,7 +734,7 @@ xfs_rtallocate_extent_size(
 			error = xfs_rtallocate_extent_block(args, i,
 					XFS_RTMAX(minlen, 1 << l),
 					XFS_RTMIN(maxlen, (1 << (l + 1)) - 1),
-					len, &n, rbpp, rsb, prod, &r);
+					len, &n, prod, &r);
 			if (error) {
 				return error;
 			}
@@ -941,7 +923,6 @@ xfs_growfs_rt(
 	xfs_extlen_t	rbmblocks;	/* current number of rt bitmap blocks */
 	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
 	xfs_sb_t	*sbp;		/* old superblock */
-	xfs_fileoff_t	sumbno;		/* summary block number */
 	uint8_t		*rsum_cache;	/* old summary cache */
 
 	sbp = &mp->m_sb;
@@ -1136,9 +1117,9 @@ xfs_growfs_rt(
 		/*
 		 * Free new extent.
 		 */
-		bp = NULL;
 		error = xfs_rtfree_range(&nargs, sbp->sb_rextents,
-			nsbp->sb_rextents - sbp->sb_rextents, &bp, &sumbno);
+				nsbp->sb_rextents - sbp->sb_rextents);
+		xfs_rtbuf_cache_relse(&nargs);
 		if (error) {
 error_cancel:
 			xfs_trans_cancel(tp);
@@ -1213,8 +1194,6 @@ xfs_rtallocate_extent(
 	};
 	int			error;		/* error value */
 	xfs_rtxnum_t		r;		/* result allocated rtext */
-	xfs_fileoff_t		sb;		/* summary file block number */
-	struct xfs_buf		*sumbp;		/* summary file block buffer */
 
 	ASSERT(xfs_isilocked(args.mount->m_rbmip, XFS_ILOCK_EXCL));
 	ASSERT(minlen > 0 && minlen <= maxlen);
@@ -1236,15 +1215,15 @@ xfs_rtallocate_extent(
 	}
 
 retry:
-	sumbp = NULL;
 	if (start == 0) {
 		error = xfs_rtallocate_extent_size(&args, minlen,
-				maxlen, len, &sumbp, &sb, prod, &r);
+				maxlen, len, prod, &r);
 	} else {
 		error = xfs_rtallocate_extent_near(&args, start, minlen,
-				maxlen, len, &sumbp, &sb, prod, &r);
+				maxlen, len, prod, &r);
 	}
 
+	xfs_rtbuf_cache_relse(&args);
 	if (error)
 		return error;
 

