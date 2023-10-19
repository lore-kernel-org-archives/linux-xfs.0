Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCED2CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbjJSQXl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjJSQXk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:23:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472D99B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:23:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCBBC433C7;
        Thu, 19 Oct 2023 16:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732617;
        bh=5WxqxuYjiR5bFNtlgqSmAcOr6cUSI4cuUev2RdfFSEo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=JujtWBrl+WNogSvMBV3E1KhD8XpAsDLn5p8EazxAuQG9KKfHATCIybqMd36WrhRdz
         Sn11PI2+UmHaUzICn+5w8QAqmJwuu9t96SnEBBrUDDSZrFcAOFBnstuGexGFat2IcW
         /01dplVLjXxR4aEGnWeZNJwdpkWVqT4JshVe15xLFlfeSnaPgt3eX5RTR8YB09IXT/
         NGc/2SzA05DSoa2bJGUjM+kU2pdqXvX5LXE02k0oLX8aU4xusoktcu1eDZWIYRItS+
         dF1dTCgZRtqJy+RFWC/lb51dIffPe3kFVokouHu84y0XsJanz+LUegBKsFfyhxGupX
         cuX8y+wFnoCug==
Date:   Thu, 19 Oct 2023 09:23:37 -0700
Subject: [PATCH 5/8] xfs: convert rt bitmap/summary block numbers to
 xfs_fileoff_t
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210203.225045.1898622539697064218.stgit@frogsfrogsfrogs>
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

We should use xfs_fileoff_t to store the file block offset of any
location within the realtime bitmap or summary files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   22 +++++++++++-----------
 fs/xfs/libxfs/xfs_rtbitmap.h |   12 ++++++------
 fs/xfs/xfs_rtalloc.c         |   34 +++++++++++++++++-----------------
 3 files changed, 34 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index d33c3e561077..de9730a34f7b 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -55,7 +55,7 @@ int
 xfs_rtbuf_get(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	block,		/* block number in bitmap or summary */
+	xfs_fileoff_t	block,		/* block number in bitmap or summary */
 	int		issum,		/* is summary not bitmap */
 	struct xfs_buf	**bpp)		/* output: buffer for the block */
 {
@@ -101,7 +101,7 @@ xfs_rtfind_back(
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
@@ -276,7 +276,7 @@ xfs_rtfind_forw(
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
@@ -446,15 +446,15 @@ xfs_rtmodify_summary_int(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_fileoff_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
 	struct xfs_buf	*bp;		/* buffer for the summary block */
 	int		error;		/* error value */
-	xfs_fsblock_t	sb;		/* summary fsblock */
+	xfs_fileoff_t	sb;		/* summary fsblock */
 	int		so;		/* index into the summary file */
 	xfs_suminfo_t	*sp;		/* pointer to returned data */
 
@@ -516,10 +516,10 @@ xfs_rtmodify_summary(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_fileoff_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
 {
 	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
 					delta, rbpp, rsb, NULL);
@@ -539,7 +539,7 @@ xfs_rtmodify_range(
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
@@ -692,7 +692,7 @@ xfs_rtfree_range(
 	xfs_rtblock_t	start,		/* starting block to free */
 	xfs_rtxlen_t	len,		/* length to free */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the freed extent */
 	int		error;		/* error value */
@@ -773,7 +773,7 @@ xfs_rtcheck_range(
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index d4449610154a..e2ea6d31c38b 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -24,7 +24,7 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 
 #ifdef CONFIG_XFS_RT
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
-		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
+		  xfs_fileoff_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		      xfs_rtblock_t start, xfs_rtxlen_t len, int val,
 		      xfs_rtblock_t *new, int *stat);
@@ -37,15 +37,15 @@ int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		       xfs_rtblock_t start, xfs_rtxlen_t len, int val);
 int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
-			     int log, xfs_rtblock_t bbno, int delta,
-			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
+			     int log, xfs_fileoff_t bbno, int delta,
+			     struct xfs_buf **rbpp, xfs_fileoff_t *rsb,
 			     xfs_suminfo_t *sum);
 int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
-			 xfs_fsblock_t *rsb);
+			 xfs_fileoff_t bbno, int delta, struct xfs_buf **rbpp,
+			 xfs_fileoff_t *rsb);
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_rtxlen_t len,
-		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+		     struct xfs_buf **rbpp, xfs_fileoff_t *rsb);
 int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		const struct xfs_rtalloc_rec *low_rec,
 		const struct xfs_rtalloc_rec *high_rec,
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 1789ae818662..a109dd06f87a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -32,9 +32,9 @@ xfs_rtget_summary(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_fileoff_t	bbno,		/* bitmap block number */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
 	return xfs_rtmodify_summary_int(mp, tp, log, bbno, 0, rbpp, rsb, sum);
@@ -50,9 +50,9 @@ xfs_rtany_summary(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		low,		/* low log2 extent size */
 	int		high,		/* high log2 extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_fileoff_t	bbno,		/* bitmap block number */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	int		*stat)		/* out: any good extents here? */
 {
 	int		error;		/* error value */
@@ -104,12 +104,12 @@ xfs_rtcopy_summary(
 	xfs_mount_t	*nmp,		/* new file system mount point */
 	xfs_trans_t	*tp)		/* transaction pointer */
 {
-	xfs_rtblock_t	bbno;		/* bitmap block number */
+	xfs_fileoff_t	bbno;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* summary buffer */
 	int		error;		/* error return value */
 	int		log;		/* summary level number (log length) */
 	xfs_suminfo_t	sum;		/* summary data */
-	xfs_fsblock_t	sumbno;		/* summary block number */
+	xfs_fileoff_t	sumbno;		/* summary block number */
 
 	bp = NULL;
 	for (log = omp->m_rsumlevels - 1; log >= 0; log--) {
@@ -146,7 +146,7 @@ xfs_rtallocate_range(
 	xfs_rtblock_t	start,		/* start block to allocate */
 	xfs_rtxlen_t	len,		/* length to allocate */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the allocated extent */
 	int		error;		/* error value */
@@ -239,13 +239,13 @@ STATIC int				/* error */
 xfs_rtallocate_extent_block(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_fileoff_t	bbno,		/* bitmap block number */
 	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
 	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	xfs_rtblock_t	*nextp,		/* out: next block to try */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
@@ -364,7 +364,7 @@ xfs_rtallocate_extent_exact(
 	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
@@ -444,12 +444,12 @@ xfs_rtallocate_extent_near(
 	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
 	int		any;		/* any useful extents from summary */
-	xfs_rtblock_t	bbno;		/* bitmap block number */
+	xfs_fileoff_t	bbno;		/* bitmap block number */
 	int		error;		/* error value */
 	int		i;		/* bitmap block offset (loop control) */
 	int		j;		/* secondary loop control */
@@ -648,12 +648,12 @@ xfs_rtallocate_extent_size(
 	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
 	int		error;		/* error value */
-	int		i;		/* bitmap block number */
+	xfs_fileoff_t	i;		/* bitmap block number */
 	int		l;		/* level number (loop control) */
 	xfs_rtblock_t	n;		/* next block to be tried */
 	xfs_rtblock_t	r;		/* result block number */
@@ -929,7 +929,7 @@ xfs_growfs_rt(
 	xfs_mount_t	*mp,		/* mount point for filesystem */
 	xfs_growfs_rt_t	*in)		/* growfs rt input struct */
 {
-	xfs_rtblock_t	bmbno;		/* bitmap block number */
+	xfs_fileoff_t	bmbno;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* temporary buffer */
 	int		error;		/* error return value */
 	xfs_mount_t	*nmp;		/* new (fake) mount structure */
@@ -944,7 +944,7 @@ xfs_growfs_rt(
 	xfs_extlen_t	rbmblocks;	/* current number of rt bitmap blocks */
 	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
 	xfs_sb_t	*sbp;		/* old superblock */
-	xfs_fsblock_t	sumbno;		/* summary block number */
+	xfs_fileoff_t	sumbno;		/* summary block number */
 	uint8_t		*rsum_cache;	/* old summary cache */
 
 	sbp = &mp->m_sb;
@@ -1207,7 +1207,7 @@ xfs_rtallocate_extent(
 	xfs_mount_t	*mp = tp->t_mountp;
 	int		error;		/* error value */
 	xfs_rtblock_t	r;		/* result allocated block */
-	xfs_fsblock_t	sb;		/* summary file block number */
+	xfs_fileoff_t	sb;		/* summary file block number */
 	struct xfs_buf	*sumbp;		/* summary file block buffer */
 
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));

