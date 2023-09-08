Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3F9EE14C3
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Sep 2023 03:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbjIHDn3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 23:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjIHDn2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2023 23:43:28 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF621BDB
        for <linux-xfs@vger.kernel.org>; Thu,  7 Sep 2023 20:43:21 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6bf58009a8dso1158285a34.1
        for <linux-xfs@vger.kernel.org>; Thu, 07 Sep 2023 20:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694144600; x=1694749400; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4THi47kNo/l5kRtv1srMm3ynROjkaSmcqkQAdbKIfxA=;
        b=AFmX18lvX/r/uayTmHQb7xN0JYRaYvmmTNLSTXoZwWhLcYuNUQ3nzc6Xv2xlOVW2ys
         wuJRJcvOnuFnjWUSD9CR/PIXuBh299mzyWBwkF+9feEvewfwWizgthHcFcgmK88xAi1S
         15M+RaVqLzwRNjWz6WhZKGfg8hxxiaFaVzDNVs2XbVikzUYJVOUSJTfC1OKTPTiLAQzS
         lWgYCLMGlvnAsu4sg4qXHEdCtN32s3Q+yQfCQtYrZM0bGVpWw+KRCTIUNx4XtCy7+pbM
         AC876AGqrKe5GVt8rPjG9CDxjWEJLz6UorxNwiyYnhzvqnMf5zr6Eey/cseTIhiFgNOS
         AO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694144600; x=1694749400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4THi47kNo/l5kRtv1srMm3ynROjkaSmcqkQAdbKIfxA=;
        b=TBpixSxXyDNA4pS4nRkoL8Ax6R48aFG1TGgOA0gDzKjT1ql8y1nFaQqc6Om9uA8RKj
         IH+W3Tq8OnGKjNaF465CnPIpEqlcbmtC+XvETqGGQi372Qg20+8zY32U4gf4qmGQ85eG
         dgWzfaXq+4bRj+xEzPTon3AOczKDNqRfcXGGrG+zw81p5PNwv8mTmWzLx/VKBJNPQ8YF
         GbMFrjhdfaAvflMmRz1n1Cqjxb/rYq9Yfls/SR0INWCKXP+tAJCpb9USG254aSeTfeTb
         AzxW/xEAFkN4snFkuTA5YG6przxKvpWWXGINImOgj+5JhigIq0bqUb4TzO5uzKkyZmC/
         S0iA==
X-Gm-Message-State: AOJu0YxIMPVoQPtY8bCjA8sRRfNY12d/Smb0QNMN4omv6w9luxnty5+v
        fH5c5IqHJ4lXJjsyqdwNC59tBQ==
X-Google-Smtp-Source: AGHT+IHYW49l9+LiaHOufljk1s8ElFYp39pq5z8uYkAyAiYdydegKE72AsP0QIKLy/o7PDZhQ38QxA==
X-Received: by 2002:a05:6830:18e7:b0:6b9:b1b1:135 with SMTP id d7-20020a05683018e700b006b9b1b10135mr1300439otf.13.1694144600242;
        Thu, 07 Sep 2023 20:43:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id v10-20020a63f20a000000b00563df2ba23bsm320074pgh.50.2023.09.07.20.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 20:43:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qeSOp-00CJ3A-36;
        Fri, 08 Sep 2023 13:43:15 +1000
Date:   Fri, 8 Sep 2023 13:43:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        kernel-team@fb.com, Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH v2 1/6] xfs: cache last bitmap block in realtime allocator
Message-ID: <ZPqYU79pTYYZFmf9@dread.disaster.area>
References: <cover.1693950248.git.osandov@osandov.com>
 <317bb892b0afe4d3355ab78eb7132f174e44d7f7.1693950248.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <317bb892b0afe4d3355ab78eb7132f174e44d7f7.1693950248.git.osandov@osandov.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 05, 2023 at 02:51:52PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Profiling a workload on a highly fragmented realtime device showed a ton
> of CPU cycles being spent in xfs_trans_read_buf() called by
> xfs_rtbuf_get(). Further tracing showed that much of that was repeated
> calls to xfs_rtbuf_get() for the same block of the realtime bitmap.
> These come from xfs_rtallocate_extent_block(): as it walks through
> ranges of free bits in the bitmap, each call to xfs_rtcheck_range() and
> xfs_rtfind_{forw,back}() gets the same bitmap block. If the bitmap block
> is very fragmented, then this is _a lot_ of buffer lookups.
> 
> The realtime allocator already passes around a cache of the last used
> realtime summary block to avoid repeated reads (the parameters rbpp and
> rsb). We can do the same for the realtime bitmap.
> 
> This replaces rbpp and rsb with a struct xfs_rtbuf_cache, which caches
> the most recently used block for both the realtime bitmap and summary.
> xfs_rtbuf_get() now handles the caching instead of the callers, which
> requires plumbing xfs_rtbuf_cache to more functions but also makes sure
> we don't miss anything.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c | 179 ++++++++++++++++++-----------------
>  fs/xfs/xfs_rtalloc.c         | 119 +++++++++++------------
>  fs/xfs/xfs_rtalloc.h         |  30 ++++--
>  3 files changed, 170 insertions(+), 158 deletions(-)

....

> diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> index 62c7ad79cbb6..72f4261bb101 100644
> --- a/fs/xfs/xfs_rtalloc.h
> +++ b/fs/xfs/xfs_rtalloc.h
> @@ -101,29 +101,40 @@ xfs_growfs_rt(
>  /*
>   * From xfs_rtbitmap.c
>   */
> +struct xfs_rtbuf_cache {
> +	struct xfs_buf *bbuf;	/* bitmap block buffer */
> +	xfs_fileoff_t bblock;	/* bitmap block number */
> +	struct xfs_buf *sbuf;	/* summary block buffer */
> +	xfs_fileoff_t sblock;	/* summary block number */

I don't think the block numbers are file offsets? Most of the code
passes the bitmap and summary block numbers around as a
xfs_fsblock_t...

> +};
> +
> +void xfs_rtbuf_cache_relse(struct xfs_trans *tp, struct xfs_rtbuf_cache *cache);
>  int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
> -		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
> +		  xfs_rtblock_t block, int issum, struct xfs_rtbuf_cache *cache,
> +		  struct xfs_buf **bpp);
>  int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
>  		      xfs_rtblock_t start, xfs_extlen_t len, int val,
> -		      xfs_rtblock_t *new, int *stat);
> +		      struct xfs_rtbuf_cache *rtbufc, xfs_rtblock_t *new,
> +		      int *stat);
>  int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
>  		    xfs_rtblock_t start, xfs_rtblock_t limit,
> -		    xfs_rtblock_t *rtblock);
> +		    struct xfs_rtbuf_cache *rtbufc, xfs_rtblock_t *rtblock);
>  int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
>  		    xfs_rtblock_t start, xfs_rtblock_t limit,
> -		    xfs_rtblock_t *rtblock);
> +		    struct xfs_rtbuf_cache *rtbufc, xfs_rtblock_t *rtblock);
>  int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
> -		       xfs_rtblock_t start, xfs_extlen_t len, int val);
> +		       xfs_rtblock_t start, xfs_extlen_t len, int val,
> +		       struct xfs_rtbuf_cache *rtbufc);
>  int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
>  			     int log, xfs_rtblock_t bbno, int delta,
> -			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
> +			     struct xfs_rtbuf_cache *rtbufc,
>  			     xfs_suminfo_t *sum);
>  int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
> -			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
> -			 xfs_fsblock_t *rsb);
> +			 xfs_rtblock_t bbno, int delta,
> +			 struct xfs_rtbuf_cache *rtbufc);
>  int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
>  		     xfs_rtblock_t start, xfs_extlen_t len,
> -		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
> +		     struct xfs_rtbuf_cache *rtbufc);
>  int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
>  		const struct xfs_rtalloc_rec *low_rec,
>  		const struct xfs_rtalloc_rec *high_rec,

Given that this is basically plumbing a new structure into almost
the entire rt allocator API, I have to wonder if this would be
better done as a 'struct xfs_rtalloc_args' similar to how we pass
all these args around the btree allocator (i.e. struct
xfs_alloc_arg).

That is:

struct xfs_rtalloc_arg {
	struct xfs_mount	*mp;
	struct xfs_trans	*tp;
	struct xfs_buf		*bitmap_buf;
	struct xfs_buf		*summary_buf;
	xfs_fsblock_t		bitmap_block;
	xfs_fsblock_t		simmary_block;
};

And now the api changes becomes a one off change like this:

-int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp, 
+int xfs_rtcheck_range(struct xfs_rtalloc_arg *arg,

and the wrapping code becomes:

	struct xfs_rtalloc_arg	args = {
		.mount	= mp,
		.trans	= tp,
	};

.....
	xfs_rtalloc_done(&args);

rebase this patch on an initial change like the (compile
tested only) patch below? Then adding the cached buffer
infrastructure becomes a much smaller change
(no api changes needed at all) and the context in which the cached
buffers are valid becomes very clear. AFAICT, the rest of the
patchset should be unaffected by doing this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: consolidate realtime allocation arguments

From: Dave Chinner <dchinner@redhat.com>

Consolidate the arguments passed around the rt allocator into a
struct xfs_rtalloc_arg similar to how the btree allocator arguments
are consolidated in a struct xfs_alloc_arg....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 157 +++++++++++++++++++++++--------------------
 fs/xfs/scrub/rtsummary.c     |   6 +-
 fs/xfs/xfs_rtalloc.c         | 119 +++++++++++++++++---------------
 fs/xfs/xfs_rtalloc.h         |  22 +++---
 4 files changed, 166 insertions(+), 138 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index fa180ab66b73..b48ea8e30d81 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -52,12 +52,12 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
  */
 int
 xfs_rtbuf_get(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	xfs_rtblock_t	block,		/* block number in bitmap or summary */
 	int		issum,		/* is summary not bitmap */
 	struct xfs_buf	**bpp)		/* output: buffer for the block */
 {
+	struct xfs_mount	*mp = args->mount;
 	struct xfs_buf	*bp;		/* block buffer, result */
 	xfs_inode_t	*ip;		/* bitmap or summary inode */
 	xfs_bmbt_irec_t	map;
@@ -74,13 +74,13 @@ xfs_rtbuf_get(
 		return -EFSCORRUPTED;
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+	error = xfs_trans_read_buf(mp, args->trans, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
 				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
 	if (error)
 		return error;
 
-	xfs_trans_buf_set_type(tp, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
+	xfs_trans_buf_set_type(args->trans, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
 					     : XFS_BLFT_RTBITMAP_BUF);
 	*bpp = bp;
 	return 0;
@@ -92,12 +92,12 @@ xfs_rtbuf_get(
  */
 int
 xfs_rtfind_back(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	xfs_rtblock_t	start,		/* starting block to look at */
 	xfs_rtblock_t	limit,		/* last block to look at */
 	xfs_rtblock_t	*rtblock)	/* out: start block found */
 {
+	struct xfs_mount	*mp = args->mount;
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
@@ -116,7 +116,7 @@ xfs_rtfind_back(
 	 * Compute and read in starting bitmap block for starting block.
 	 */
 	block = XFS_BITTOBLOCK(mp, start);
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(args, block, 0, &bp);
 	if (error) {
 		return error;
 	}
@@ -153,7 +153,7 @@ xfs_rtfind_back(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i = bit - XFS_RTHIBIT(wdiff);
 			*rtblock = start - i + 1;
 			return 0;
@@ -167,8 +167,8 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
+			xfs_trans_brelse(args->trans, bp);
+			error = xfs_rtbuf_get(args, --block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -199,7 +199,7 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtblock = start - i + 1;
 			return 0;
@@ -213,8 +213,8 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
+			xfs_trans_brelse(args->trans, bp);
+			error = xfs_rtbuf_get(args, --block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -246,7 +246,7 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtblock = start - i + 1;
 			return 0;
@@ -256,7 +256,7 @@ xfs_rtfind_back(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(tp, bp);
+	xfs_trans_brelse(args->trans, bp);
 	*rtblock = start - i + 1;
 	return 0;
 }
@@ -267,12 +267,12 @@ xfs_rtfind_back(
  */
 int
 xfs_rtfind_forw(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	xfs_rtblock_t	start,		/* starting block to look at */
 	xfs_rtblock_t	limit,		/* last block to look at */
 	xfs_rtblock_t	*rtblock)	/* out: start block found */
 {
+	struct xfs_mount	*mp = args->mount;
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
@@ -291,7 +291,7 @@ xfs_rtfind_forw(
 	 * Compute and read in starting bitmap block for starting block.
 	 */
 	block = XFS_BITTOBLOCK(mp, start);
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(args, block, 0, &bp);
 	if (error) {
 		return error;
 	}
@@ -327,7 +327,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*rtblock = start + i - 1;
 			return 0;
@@ -341,8 +341,8 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_brelse(args->trans, bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -372,7 +372,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtblock = start + i - 1;
 			return 0;
@@ -386,8 +386,8 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_brelse(args->trans, bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -416,7 +416,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtblock = start + i - 1;
 			return 0;
@@ -426,7 +426,7 @@ xfs_rtfind_forw(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(tp, bp);
+	xfs_trans_brelse(args->trans, bp);
 	*rtblock = start + i - 1;
 	return 0;
 }
@@ -442,8 +442,7 @@ xfs_rtfind_forw(
  */
 int
 xfs_rtmodify_summary_int(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
@@ -451,6 +450,7 @@ xfs_rtmodify_summary_int(
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
+	struct xfs_mount	*mp = args->mount;
 	struct xfs_buf	*bp;		/* buffer for the summary block */
 	int		error;		/* error value */
 	xfs_fsblock_t	sb;		/* summary fsblock */
@@ -478,8 +478,8 @@ xfs_rtmodify_summary_int(
 		 * If there was an old one, get rid of it first.
 		 */
 		if (*rbpp)
-			xfs_trans_brelse(tp, *rbpp);
-		error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
+			xfs_trans_brelse(args->trans, *rbpp);
+		error = xfs_rtbuf_get(args, sb, 1, &bp);
 		if (error) {
 			return error;
 		}
@@ -503,7 +503,7 @@ xfs_rtmodify_summary_int(
 			if (*sp != 0 && log < mp->m_rsum_cache[bbno])
 				mp->m_rsum_cache[bbno] = log;
 		}
-		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
+		xfs_trans_log_buf(args->trans, bp, first, first + sizeof(*sp) - 1);
 	}
 	if (sum)
 		*sum = *sp;
@@ -512,15 +512,14 @@ xfs_rtmodify_summary_int(
 
 int
 xfs_rtmodify_summary(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
-	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
+	return xfs_rtmodify_summary_int(args, log, bbno,
 					delta, rbpp, rsb, NULL);
 }
 
@@ -530,12 +529,12 @@ xfs_rtmodify_summary(
  */
 int
 xfs_rtmodify_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	xfs_rtblock_t	start,		/* starting block to modify */
 	xfs_extlen_t	len,		/* length of extent to modify */
 	int		val)		/* 1 for free, 0 for allocated */
 {
+	struct xfs_mount	*mp = args->mount;
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
@@ -555,7 +554,7 @@ xfs_rtmodify_range(
 	/*
 	 * Read the bitmap block, and point to its data.
 	 */
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(args, block, 0, &bp);
 	if (error) {
 		return error;
 	}
@@ -597,10 +596,10 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_buf(tp, bp,
+			xfs_trans_log_buf(args->trans, bp,
 				(uint)((char *)first - (char *)bufp),
 				(uint)((char *)b - (char *)bufp));
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -637,10 +636,10 @@ xfs_rtmodify_range(
 			 * Log the changed part of this block.
 			 * Get the next one.
 			 */
-			xfs_trans_log_buf(tp, bp,
+			xfs_trans_log_buf(args->trans, bp,
 				(uint)((char *)first - (char *)bufp),
 				(uint)((char *)b - (char *)bufp));
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -675,8 +674,9 @@ xfs_rtmodify_range(
 	 * Log any remaining changed bytes.
 	 */
 	if (b > first)
-		xfs_trans_log_buf(tp, bp, (uint)((char *)first - (char *)bufp),
-			(uint)((char *)b - (char *)bufp - 1));
+		xfs_trans_log_buf(args->trans, bp,
+				(uint)((char *)first - (char *)bufp),
+				(uint)((char *)b - (char *)bufp - 1));
 	return 0;
 }
 
@@ -686,13 +686,13 @@ xfs_rtmodify_range(
  */
 int
 xfs_rtfree_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	xfs_rtblock_t	start,		/* starting block to free */
 	xfs_extlen_t	len,		/* length to free */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
+	struct xfs_mount	*mp = args->mount;
 	xfs_rtblock_t	end;		/* end of the freed extent */
 	int		error;		/* error value */
 	xfs_rtblock_t	postblock;	/* first block freed > end */
@@ -702,7 +702,7 @@ xfs_rtfree_range(
 	/*
 	 * Modify the bitmap to mark this extent freed.
 	 */
-	error = xfs_rtmodify_range(mp, tp, start, len, 1);
+	error = xfs_rtmodify_range(args, start, len, 1);
 	if (error) {
 		return error;
 	}
@@ -711,14 +711,14 @@ xfs_rtfree_range(
 	 * We need to find the beginning and end of the extent so we can
 	 * properly update the summary.
 	 */
-	error = xfs_rtfind_back(mp, tp, start, 0, &preblock);
+	error = xfs_rtfind_back(args, start, 0, &preblock);
 	if (error) {
 		return error;
 	}
 	/*
 	 * Find the next allocated block (end of allocated extent).
 	 */
-	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
+	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
 		&postblock);
 	if (error)
 		return error;
@@ -727,7 +727,7 @@ xfs_rtfree_range(
 	 * old extent, add summary data for them to be allocated.
 	 */
 	if (preblock < start) {
-		error = xfs_rtmodify_summary(mp, tp,
+		error = xfs_rtmodify_summary(args,
 			XFS_RTBLOCKLOG(start - preblock),
 			XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
 		if (error) {
@@ -739,7 +739,7 @@ xfs_rtfree_range(
 	 * old extent, add summary data for them to be allocated.
 	 */
 	if (postblock > end) {
-		error = xfs_rtmodify_summary(mp, tp,
+		error = xfs_rtmodify_summary(args,
 			XFS_RTBLOCKLOG(postblock - end),
 			XFS_BITTOBLOCK(mp, end + 1), -1, rbpp, rsb);
 		if (error) {
@@ -750,7 +750,7 @@ xfs_rtfree_range(
 	 * Increment the summary information corresponding to the entire
 	 * (new) free extent.
 	 */
-	error = xfs_rtmodify_summary(mp, tp,
+	error = xfs_rtmodify_summary(args,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
 		XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
 	return error;
@@ -762,14 +762,14 @@ xfs_rtfree_range(
  */
 int
 xfs_rtcheck_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	xfs_rtblock_t	start,		/* starting block number of extent */
 	xfs_extlen_t	len,		/* length of extent */
 	int		val,		/* 1 for free, 0 for allocated */
 	xfs_rtblock_t	*new,		/* out: first block not matching */
 	int		*stat)		/* out: 1 for matches, 0 for not */
 {
+	struct xfs_mount	*mp = args->mount;
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
@@ -789,7 +789,7 @@ xfs_rtcheck_range(
 	/*
 	 * Read the bitmap block.
 	 */
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(args, block, 0, &bp);
 	if (error) {
 		return error;
 	}
@@ -824,7 +824,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*new = start + i;
 			*stat = 0;
@@ -839,8 +839,8 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_brelse(args->trans, bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -870,7 +870,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -885,8 +885,8 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			xfs_trans_brelse(args->trans, bp);
+			error = xfs_rtbuf_get(args, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
@@ -915,7 +915,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(tp, bp);
+			xfs_trans_brelse(args->trans, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -926,7 +926,7 @@ xfs_rtcheck_range(
 	/*
 	 * Successful, return.
 	 */
-	xfs_trans_brelse(tp, bp);
+	xfs_trans_brelse(args->trans, bp);
 	*new = start + i;
 	*stat = 1;
 	return 0;
@@ -938,8 +938,7 @@ xfs_rtcheck_range(
  */
 STATIC int				/* error */
 xfs_rtcheck_alloc_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	xfs_rtblock_t	bno,		/* starting block number of extent */
 	xfs_extlen_t	len)		/* length of extent */
 {
@@ -947,14 +946,14 @@ xfs_rtcheck_alloc_range(
 	int		stat;
 	int		error;
 
-	error = xfs_rtcheck_range(mp, tp, bno, len, 0, &new, &stat);
+	error = xfs_rtcheck_range(args, bno, len, 0, &new, &stat);
 	if (error)
 		return error;
 	ASSERT(stat);
 	return 0;
 }
 #else
-#define xfs_rtcheck_alloc_range(m,t,b,l)	(0)
+#define xfs_rtcheck_alloc_range(a,b,l)	(0)
 #endif
 /*
  * Free an extent in the realtime subvolume.  Length is expressed in
@@ -966,24 +965,26 @@ xfs_rtfree_extent(
 	xfs_rtblock_t	bno,		/* starting block number to free */
 	xfs_extlen_t	len)		/* length of extent freed */
 {
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_rtalloc_args	args = {
+		.mount	= mp,
+		.trans	= tp,
+	};
 	int		error;		/* error value */
-	xfs_mount_t	*mp;		/* file system mount structure */
 	xfs_fsblock_t	sb;		/* summary file block number */
 	struct xfs_buf	*sumbp = NULL;	/* summary file block buffer */
 
-	mp = tp->t_mountp;
-
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
-	error = xfs_rtcheck_alloc_range(mp, tp, bno, len);
+	error = xfs_rtcheck_alloc_range(&args, bno, len);
 	if (error)
 		return error;
 
 	/*
 	 * Free the range of realtime blocks.
 	 */
-	error = xfs_rtfree_range(mp, tp, bno, len, &sumbp, &sb);
+	error = xfs_rtfree_range(&args, bno, len, &sumbp, &sb);
 	if (error) {
 		return error;
 	}
@@ -1015,6 +1016,10 @@ xfs_rtalloc_query_range(
 	xfs_rtalloc_query_range_fn	fn,
 	void				*priv)
 {
+	struct xfs_rtalloc_args		args = {
+		.mount	= mp,
+		.trans	= tp,
+	};
 	struct xfs_rtalloc_rec		rec;
 	xfs_rtblock_t			rtstart;
 	xfs_rtblock_t			rtend;
@@ -1034,13 +1039,13 @@ xfs_rtalloc_query_range(
 	rtstart = low_rec->ar_startext;
 	while (rtstart <= high_key) {
 		/* Is the first block free? */
-		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtend,
+		error = xfs_rtcheck_range(&args, rtstart, 1, 1, &rtend,
 				&is_free);
 		if (error)
 			break;
 
 		/* How long does the extent go for? */
-		error = xfs_rtfind_forw(mp, tp, rtstart, high_key, &rtend);
+		error = xfs_rtfind_forw(&args, rtstart, high_key, &rtend);
 		if (error)
 			break;
 
@@ -1085,11 +1090,15 @@ xfs_rtalloc_extent_is_free(
 	xfs_extlen_t			len,
 	bool				*is_free)
 {
+	struct xfs_rtalloc_args		args = {
+		.mount	= mp,
+		.trans	= tp,
+	};
 	xfs_rtblock_t			end;
 	int				matches;
 	int				error;
 
-	error = xfs_rtcheck_range(mp, tp, start, len, 1, &end, &matches);
+	error = xfs_rtcheck_range(&args, start, len, 1, &end, &matches);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 437ed9acbb27..471a0e22bccd 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -177,6 +177,10 @@ STATIC int
 xchk_rtsum_compare(
 	struct xfs_scrub	*sc)
 {
+	struct xfs_rtalloc_args args = {
+		.mount = sc->mp,
+		.trans = sc->tp,
+	};
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_buf		*bp;
 	struct xfs_bmbt_irec	map;
@@ -205,7 +209,7 @@ xchk_rtsum_compare(
 		}
 
 		/* Read a block's worth of ondisk rtsummary file. */
-		error = xfs_rtbuf_get(mp, sc->tp, off, 1, &bp);
+		error = xfs_rtbuf_get(&args, off, 1, &bp);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, off, &error))
 			return error;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 16534e9873f6..a388fcd91339 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -28,15 +28,14 @@
  */
 static int
 xfs_rtget_summary(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
-	return xfs_rtmodify_summary_int(mp, tp, log, bbno, 0, rbpp, rsb, sum);
+	return xfs_rtmodify_summary_int(args, log, bbno, 0, rbpp, rsb, sum);
 }
 
 /*
@@ -45,8 +44,7 @@ xfs_rtget_summary(
  */
 STATIC int				/* error */
 xfs_rtany_summary(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	int		low,		/* low log2 extent size */
 	int		high,		/* high log2 extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
@@ -54,6 +52,7 @@ xfs_rtany_summary(
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	int		*stat)		/* out: any good extents here? */
 {
+	struct xfs_mount	*mp = args->mount;
 	int		error;		/* error value */
 	int		log;		/* loop counter, log2 of ext. size */
 	xfs_suminfo_t	sum;		/* summary data */
@@ -69,7 +68,7 @@ xfs_rtany_summary(
 		/*
 		 * Get one summary datum.
 		 */
-		error = xfs_rtget_summary(mp, tp, log, bbno, rbpp, rsb, &sum);
+		error = xfs_rtget_summary(args, log, bbno, rbpp, rsb, &sum);
 		if (error) {
 			return error;
 		}
@@ -99,9 +98,8 @@ xfs_rtany_summary(
  */
 STATIC int				/* error */
 xfs_rtcopy_summary(
-	xfs_mount_t	*omp,		/* old file system mount point */
-	xfs_mount_t	*nmp,		/* new file system mount point */
-	xfs_trans_t	*tp)		/* transaction pointer */
+	struct xfs_rtalloc_args	*oargs,
+	struct xfs_rtalloc_args	*nargs)
 {
 	xfs_rtblock_t	bbno;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* summary buffer */
@@ -111,21 +109,21 @@ xfs_rtcopy_summary(
 	xfs_fsblock_t	sumbno;		/* summary block number */
 
 	bp = NULL;
-	for (log = omp->m_rsumlevels - 1; log >= 0; log--) {
-		for (bbno = omp->m_sb.sb_rbmblocks - 1;
+	for (log = oargs->mount->m_rsumlevels - 1; log >= 0; log--) {
+		for (bbno = oargs->mount->m_sb.sb_rbmblocks - 1;
 		     (xfs_srtblock_t)bbno >= 0;
 		     bbno--) {
-			error = xfs_rtget_summary(omp, tp, log, bbno, &bp,
+			error = xfs_rtget_summary(oargs, log, bbno, &bp,
 				&sumbno, &sum);
 			if (error)
 				return error;
 			if (sum == 0)
 				continue;
-			error = xfs_rtmodify_summary(omp, tp, log, bbno, -sum,
+			error = xfs_rtmodify_summary(oargs, log, bbno, -sum,
 				&bp, &sumbno);
 			if (error)
 				return error;
-			error = xfs_rtmodify_summary(nmp, tp, log, bbno, sum,
+			error = xfs_rtmodify_summary(nargs, log, bbno, sum,
 				&bp, &sumbno);
 			if (error)
 				return error;
@@ -140,13 +138,13 @@ xfs_rtcopy_summary(
  */
 STATIC int				/* error */
 xfs_rtallocate_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	xfs_rtblock_t	start,		/* start block to allocate */
 	xfs_extlen_t	len,		/* length to allocate */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
+	struct xfs_mount	*mp = args->mount;
 	xfs_rtblock_t	end;		/* end of the allocated extent */
 	int		error;		/* error value */
 	xfs_rtblock_t	postblock = 0;	/* first block allocated > end */
@@ -158,14 +156,14 @@ xfs_rtallocate_range(
 	 * We need to find the beginning and end of the extent so we can
 	 * properly update the summary.
 	 */
-	error = xfs_rtfind_back(mp, tp, start, 0, &preblock);
+	error = xfs_rtfind_back(args, start, 0, &preblock);
 	if (error) {
 		return error;
 	}
 	/*
 	 * Find the next allocated block (end of free extent).
 	 */
-	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
+	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
 		&postblock);
 	if (error) {
 		return error;
@@ -174,7 +172,7 @@ xfs_rtallocate_range(
 	 * Decrement the summary information corresponding to the entire
 	 * (old) free extent.
 	 */
-	error = xfs_rtmodify_summary(mp, tp,
+	error = xfs_rtmodify_summary(args,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
 		XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
 	if (error) {
@@ -185,7 +183,7 @@ xfs_rtallocate_range(
 	 * old extent, add summary data for them to be free.
 	 */
 	if (preblock < start) {
-		error = xfs_rtmodify_summary(mp, tp,
+		error = xfs_rtmodify_summary(args,
 			XFS_RTBLOCKLOG(start - preblock),
 			XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
 		if (error) {
@@ -197,7 +195,7 @@ xfs_rtallocate_range(
 	 * old extent, add summary data for them to be free.
 	 */
 	if (postblock > end) {
-		error = xfs_rtmodify_summary(mp, tp,
+		error = xfs_rtmodify_summary(args,
 			XFS_RTBLOCKLOG(postblock - end),
 			XFS_BITTOBLOCK(mp, end + 1), 1, rbpp, rsb);
 		if (error) {
@@ -207,7 +205,7 @@ xfs_rtallocate_range(
 	/*
 	 * Modify the bitmap to mark this extent allocated.
 	 */
-	error = xfs_rtmodify_range(mp, tp, start, len, 0);
+	error = xfs_rtmodify_range(args, start, len, 0);
 	return error;
 }
 
@@ -219,8 +217,7 @@ xfs_rtallocate_range(
  */
 STATIC int				/* error */
 xfs_rtallocate_extent_block(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
@@ -231,6 +228,7 @@ xfs_rtallocate_extent_block(
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
+	struct xfs_mount	*mp = args->mount;
 	xfs_rtblock_t	besti;		/* best rtblock found so far */
 	xfs_rtblock_t	bestlen;	/* best length found so far */
 	xfs_rtblock_t	end;		/* last rtblock in chunk */
@@ -254,7 +252,7 @@ xfs_rtallocate_extent_block(
 		 * See if there's a free extent of maxlen starting at i.
 		 * If it's not so then next will contain the first non-free.
 		 */
-		error = xfs_rtcheck_range(mp, tp, i, maxlen, 1, &next, &stat);
+		error = xfs_rtcheck_range(args, i, maxlen, 1, &next, &stat);
 		if (error) {
 			return error;
 		}
@@ -262,7 +260,7 @@ xfs_rtallocate_extent_block(
 			/*
 			 * i for maxlen is all free, allocate and return that.
 			 */
-			error = xfs_rtallocate_range(mp, tp, i, maxlen, rbpp,
+			error = xfs_rtallocate_range(args, i, maxlen, rbpp,
 				rsb);
 			if (error) {
 				return error;
@@ -290,7 +288,7 @@ xfs_rtallocate_extent_block(
 		 * If not done yet, find the start of the next free space.
 		 */
 		if (next < end) {
-			error = xfs_rtfind_forw(mp, tp, next, end, &i);
+			error = xfs_rtfind_forw(args, next, end, &i);
 			if (error) {
 				return error;
 			}
@@ -315,7 +313,7 @@ xfs_rtallocate_extent_block(
 		/*
 		 * Allocate besti for bestlen & return that.
 		 */
-		error = xfs_rtallocate_range(mp, tp, besti, bestlen, rbpp, rsb);
+		error = xfs_rtallocate_range(args, besti, bestlen, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -339,8 +337,7 @@ xfs_rtallocate_extent_block(
  */
 STATIC int				/* error */
 xfs_rtallocate_extent_exact(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	xfs_rtblock_t	bno,		/* starting block number to allocate */
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
@@ -359,7 +356,7 @@ xfs_rtallocate_extent_exact(
 	/*
 	 * Check if the range in question (for maxlen) is free.
 	 */
-	error = xfs_rtcheck_range(mp, tp, bno, maxlen, 1, &next, &isfree);
+	error = xfs_rtcheck_range(args, bno, maxlen, 1, &next, &isfree);
 	if (error) {
 		return error;
 	}
@@ -367,7 +364,7 @@ xfs_rtallocate_extent_exact(
 		/*
 		 * If it is, allocate it and return success.
 		 */
-		error = xfs_rtallocate_range(mp, tp, bno, maxlen, rbpp, rsb);
+		error = xfs_rtallocate_range(args, bno, maxlen, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -402,7 +399,7 @@ xfs_rtallocate_extent_exact(
 	/*
 	 * Allocate what we can and return it.
 	 */
-	error = xfs_rtallocate_range(mp, tp, bno, maxlen, rbpp, rsb);
+	error = xfs_rtallocate_range(args, bno, maxlen, rbpp, rsb);
 	if (error) {
 		return error;
 	}
@@ -418,8 +415,7 @@ xfs_rtallocate_extent_exact(
  */
 STATIC int				/* error */
 xfs_rtallocate_extent_near(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	xfs_rtblock_t	bno,		/* starting block number to allocate */
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
@@ -429,6 +425,7 @@ xfs_rtallocate_extent_near(
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
+	struct xfs_mount	*mp = args->mount;
 	int		any;		/* any useful extents from summary */
 	xfs_rtblock_t	bbno;		/* bitmap block number */
 	int		error;		/* error value */
@@ -456,7 +453,7 @@ xfs_rtallocate_extent_near(
 	/*
 	 * Try the exact allocation first.
 	 */
-	error = xfs_rtallocate_extent_exact(mp, tp, bno, minlen, maxlen, len,
+	error = xfs_rtallocate_extent_exact(args, bno, minlen, maxlen, len,
 		rbpp, rsb, prod, &r);
 	if (error) {
 		return error;
@@ -480,7 +477,7 @@ xfs_rtallocate_extent_near(
 		 * Get summary information of extents of all useful levels
 		 * starting in this bitmap block.
 		 */
-		error = xfs_rtany_summary(mp, tp, log2len, mp->m_rsumlevels - 1,
+		error = xfs_rtany_summary(args, log2len, mp->m_rsumlevels - 1,
 			bbno + i, rbpp, rsb, &any);
 		if (error) {
 			return error;
@@ -498,7 +495,7 @@ xfs_rtallocate_extent_near(
 				 * Try to allocate an extent starting in
 				 * this block.
 				 */
-				error = xfs_rtallocate_extent_block(mp, tp,
+				error = xfs_rtallocate_extent_block(args,
 					bbno + i, minlen, maxlen, len, &n, rbpp,
 					rsb, prod, &r);
 				if (error) {
@@ -527,7 +524,7 @@ xfs_rtallocate_extent_near(
 					 * Grab the summary information for
 					 * this bitmap block.
 					 */
-					error = xfs_rtany_summary(mp, tp,
+					error = xfs_rtany_summary(args,
 						log2len, mp->m_rsumlevels - 1,
 						bbno + j, rbpp, rsb, &any);
 					if (error) {
@@ -543,8 +540,8 @@ xfs_rtallocate_extent_near(
 					 */
 					if (any)
 						continue;
-					error = xfs_rtallocate_extent_block(mp,
-						tp, bbno + j, minlen, maxlen,
+					error = xfs_rtallocate_extent_block(args,
+						bbno + j, minlen, maxlen,
 						len, &n, rbpp, rsb, prod, &r);
 					if (error) {
 						return error;
@@ -565,7 +562,7 @@ xfs_rtallocate_extent_near(
 				 * Try to allocate from the summary block
 				 * that we found.
 				 */
-				error = xfs_rtallocate_extent_block(mp, tp,
+				error = xfs_rtallocate_extent_block(args,
 					bbno + i, minlen, maxlen, len, &n, rbpp,
 					rsb, prod, &r);
 				if (error) {
@@ -619,10 +616,9 @@ xfs_rtallocate_extent_near(
  * specified.  If we don't get maxlen then use prod to trim
  * the length, if given.  The lengths are all in rtextents.
  */
-STATIC int				/* error */
+static int				/* error */
 xfs_rtallocate_extent_size(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtalloc_args	*args,
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
@@ -631,6 +627,7 @@ xfs_rtallocate_extent_size(
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
+	struct xfs_mount	*mp = args->mount;
 	int		error;		/* error value */
 	int		i;		/* bitmap block number */
 	int		l;		/* level number (loop control) */
@@ -656,7 +653,7 @@ xfs_rtallocate_extent_size(
 			/*
 			 * Get the summary for this level/block.
 			 */
-			error = xfs_rtget_summary(mp, tp, l, i, rbpp, rsb,
+			error = xfs_rtget_summary(args, l, i, rbpp, rsb,
 				&sum);
 			if (error) {
 				return error;
@@ -669,7 +666,7 @@ xfs_rtallocate_extent_size(
 			/*
 			 * Try allocating the extent.
 			 */
-			error = xfs_rtallocate_extent_block(mp, tp, i, maxlen,
+			error = xfs_rtallocate_extent_block(args, i, maxlen,
 				maxlen, len, &n, rbpp, rsb, prod, &r);
 			if (error) {
 				return error;
@@ -715,7 +712,7 @@ xfs_rtallocate_extent_size(
 			/*
 			 * Get the summary information for this level/block.
 			 */
-			error =	xfs_rtget_summary(mp, tp, l, i, rbpp, rsb,
+			error =	xfs_rtget_summary(args, l, i, rbpp, rsb,
 						  &sum);
 			if (error) {
 				return error;
@@ -730,7 +727,7 @@ xfs_rtallocate_extent_size(
 			 * minlen/maxlen are in the possible range for
 			 * this summary level.
 			 */
-			error = xfs_rtallocate_extent_block(mp, tp, i,
+			error = xfs_rtallocate_extent_block(args, i,
 					XFS_RTMAX(minlen, 1 << l),
 					XFS_RTMIN(maxlen, (1 << (l + 1)) - 1),
 					len, &n, rbpp, rsb, prod, &r);
@@ -1023,6 +1020,12 @@ xfs_growfs_rt(
 		     ((sbp->sb_rextents & ((1 << mp->m_blkbit_log) - 1)) != 0);
 	     bmbno < nrbmblocks;
 	     bmbno++) {
+		struct xfs_rtalloc_args	args = {
+			.mount	= mp,
+		};
+		struct xfs_rtalloc_args	nargs = {
+			.mount	= nmp,
+		};
 		struct xfs_trans	*tp;
 		xfs_rfsblock_t		nrblocks_step;
 
@@ -1053,6 +1056,9 @@ xfs_growfs_rt(
 				&tp);
 		if (error)
 			break;
+		args.trans = tp;
+		nargs.trans = tp;
+
 		/*
 		 * Lock out other callers by grabbing the bitmap inode lock.
 		 */
@@ -1086,7 +1092,7 @@ xfs_growfs_rt(
 		 */
 		if (sbp->sb_rbmblocks != nsbp->sb_rbmblocks ||
 		    mp->m_rsumlevels != nmp->m_rsumlevels) {
-			error = xfs_rtcopy_summary(mp, nmp, tp);
+			error = xfs_rtcopy_summary(&args, &nargs);
 			if (error)
 				goto error_cancel;
 		}
@@ -1112,7 +1118,7 @@ xfs_growfs_rt(
 		 * Free new extent.
 		 */
 		bp = NULL;
-		error = xfs_rtfree_range(nmp, tp, sbp->sb_rextents,
+		error = xfs_rtfree_range(&nargs, sbp->sb_rextents,
 			nsbp->sb_rextents - sbp->sb_rextents, &bp, &sumbno);
 		if (error) {
 error_cancel:
@@ -1182,13 +1188,16 @@ xfs_rtallocate_extent(
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
-	xfs_mount_t	*mp = tp->t_mountp;
+	struct xfs_rtalloc_args	args = {
+		.mount	= tp->t_mountp,
+		.trans	= tp,
+	};
 	int		error;		/* error value */
 	xfs_rtblock_t	r;		/* result allocated block */
 	xfs_fsblock_t	sb;		/* summary file block number */
 	struct xfs_buf	*sumbp;		/* summary file block buffer */
 
-	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(args.mount->m_rbmip, XFS_ILOCK_EXCL));
 	ASSERT(minlen > 0 && minlen <= maxlen);
 
 	/*
@@ -1210,10 +1219,10 @@ xfs_rtallocate_extent(
 retry:
 	sumbp = NULL;
 	if (bno == 0) {
-		error = xfs_rtallocate_extent_size(mp, tp, minlen, maxlen, len,
+		error = xfs_rtallocate_extent_size(&args, minlen, maxlen, len,
 				&sumbp,	&sb, prod, &r);
 	} else {
-		error = xfs_rtallocate_extent_near(mp, tp, bno, minlen, maxlen,
+		error = xfs_rtallocate_extent_near(&args, bno, minlen, maxlen,
 				len, &sumbp, &sb, prod, &r);
 	}
 
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 62c7ad79cbb6..427a83944cd7 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -11,6 +11,11 @@
 struct xfs_mount;
 struct xfs_trans;
 
+struct xfs_rtalloc_args {
+	struct xfs_mount	*mount;
+	struct xfs_trans	*trans;
+};
+
 /*
  * XXX: Most of the realtime allocation functions deal in units of realtime
  * extents, not realtime blocks.  This looks funny when paired with the type
@@ -101,29 +106,30 @@ xfs_growfs_rt(
 /*
  * From xfs_rtbitmap.c
  */
-int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
+int xfs_rtbuf_get(struct xfs_rtalloc_args *args,
 		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
-int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
+int xfs_rtcheck_range(struct xfs_rtalloc_args *args,
 		      xfs_rtblock_t start, xfs_extlen_t len, int val,
 		      xfs_rtblock_t *new, int *stat);
-int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
+int xfs_rtfind_back(struct xfs_rtalloc_args *args,
 		    xfs_rtblock_t start, xfs_rtblock_t limit,
 		    xfs_rtblock_t *rtblock);
-int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
+int xfs_rtfind_forw(struct xfs_rtalloc_args *args,
 		    xfs_rtblock_t start, xfs_rtblock_t limit,
 		    xfs_rtblock_t *rtblock);
-int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
+int xfs_rtmodify_range(struct xfs_rtalloc_args *args,
 		       xfs_rtblock_t start, xfs_extlen_t len, int val);
-int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
+int xfs_rtmodify_summary_int(struct xfs_rtalloc_args *args,
 			     int log, xfs_rtblock_t bbno, int delta,
 			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
 			     xfs_suminfo_t *sum);
-int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
+int xfs_rtmodify_summary(struct xfs_rtalloc_args *args, int log,
 			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
 			 xfs_fsblock_t *rsb);
-int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
+int xfs_rtfree_range(struct xfs_rtalloc_args *args,
 		     xfs_rtblock_t start, xfs_extlen_t len,
 		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+
 int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		const struct xfs_rtalloc_rec *low_rec,
 		const struct xfs_rtalloc_rec *high_rec,
