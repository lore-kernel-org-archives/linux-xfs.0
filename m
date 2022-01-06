Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06936C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 02:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344793AbiAFCcl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 21:32:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49376 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344794AbiAFCcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 21:32:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6768DB81ED1
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jan 2022 02:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207EFC36AE9;
        Thu,  6 Jan 2022 02:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641436356;
        bh=ViMhb8BH2cELT0XYKQ/SPlXKt+qBEUOcqu8UHpU/lrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cYX+3+nk/j0cM1ikBSv7MLAljLET3Jwp3qCCklrJdT2V4amwZdXh18WNDedGiL+9e
         gWYhCKvLBHXHufjFUkt6qqNuRZSd+I6L5rA6DE4gpNd8wVhxY53A8ZYiJcP6WU3SUX
         pir7g1e/TvDGs3v+em+jgREAbz7ELq+P+o/horsNfil2rU4aqndrvhUdBVcxEnLiQB
         Teg04VkmwhPR7V1AwBgUUlf0IFkKEFSDMH4opR8KUNrpEqcd1dUThnO3zWB/r35XcH
         D6lajEuUjDcnxIlRfxHbXKTap0VWjd/kqBAmkbVd3q842r8hWsc4mDJzTTOADfdvrr
         3fXOrsqdfJ65Q==
Date:   Wed, 5 Jan 2022 18:32:35 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3] xfs: take the ILOCK when accessing the inode core
Message-ID: <20220106023235.GL31606@magnolia>
References: <20220105195226.GL656707@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105195226.GL656707@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I was poking around in the directory code while diagnosing online fsck
bugs, and noticed that xfs_readdir doesn't actually take the directory
ILOCK when it calls xfs_dir2_isblock.  xfs_dir_open most probably loaded
the data fork mappings and the VFS took i_rwsem (aka IOLOCK_SHARED) so
we're protected against writer threads, but we really need to follow the
locking model like we do in other places.

To avoid unnecessarily cycling the ILOCK for fairly small directories,
change the block/leaf _getdents functions to consume the ILOCK hold that
the parent readdir function took to decide on a _getdents implementation.

It is ok to cycle the ILOCK in readdir because the VFS takes the IOLOCK
in the appropriate mode during lookups and writes, and we don't want to
be holding the ILOCK when we copy directory entries to userspace in case
there's a page fault.  We really only need it to protect against data
fork lookups, like we do for other files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v3: better documentation and assertions around the IOLOCK
v2: reduce the scope of the locked region, and reduce lock cycling
---
 fs/xfs/xfs_dir2_readdir.c |   55 +++++++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 8310005af00f..a7174a5b3203 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -138,7 +138,8 @@ xfs_dir2_sf_getdents(
 STATIC int
 xfs_dir2_block_getdents(
 	struct xfs_da_args	*args,
-	struct dir_context	*ctx)
+	struct dir_context	*ctx,
+	unsigned int		*lock_mode)
 {
 	struct xfs_inode	*dp = args->dp;	/* incore directory inode */
 	struct xfs_buf		*bp;		/* buffer for block */
@@ -146,7 +147,6 @@ xfs_dir2_block_getdents(
 	int			wantoff;	/* starting block offset */
 	xfs_off_t		cook;
 	struct xfs_da_geometry	*geo = args->geo;
-	int			lock_mode;
 	unsigned int		offset, next_offset;
 	unsigned int		end;
 
@@ -156,12 +156,13 @@ xfs_dir2_block_getdents(
 	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
 		return 0;
 
-	lock_mode = xfs_ilock_data_map_shared(dp);
 	error = xfs_dir3_block_read(args->trans, dp, &bp);
-	xfs_iunlock(dp, lock_mode);
 	if (error)
 		return error;
 
+	xfs_iunlock(dp, *lock_mode);
+	*lock_mode = 0;
+
 	/*
 	 * Extract the byte offset we start at from the seek pointer.
 	 * We'll skip entries before this.
@@ -344,7 +345,8 @@ STATIC int
 xfs_dir2_leaf_getdents(
 	struct xfs_da_args	*args,
 	struct dir_context	*ctx,
-	size_t			bufsize)
+	size_t			bufsize,
+	unsigned int		*lock_mode)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -356,7 +358,6 @@ xfs_dir2_leaf_getdents(
 	xfs_dir2_off_t		curoff;		/* current overall offset */
 	int			length;		/* temporary length value */
 	int			byteoff;	/* offset in current block */
-	int			lock_mode;
 	unsigned int		offset = 0;
 	int			error = 0;	/* error return value */
 
@@ -390,13 +391,16 @@ xfs_dir2_leaf_getdents(
 				bp = NULL;
 			}
 
-			lock_mode = xfs_ilock_data_map_shared(dp);
+			if (*lock_mode == 0)
+				*lock_mode = xfs_ilock_data_map_shared(dp);
 			error = xfs_dir2_leaf_readbuf(args, bufsize, &curoff,
 					&rablk, &bp);
-			xfs_iunlock(dp, lock_mode);
 			if (error || !bp)
 				break;
 
+			xfs_iunlock(dp, *lock_mode);
+			*lock_mode = 0;
+
 			xfs_dir3_data_check(dp, bp);
 			/*
 			 * Find our position in the block.
@@ -496,7 +500,7 @@ xfs_dir2_leaf_getdents(
  *
  * If supplied, the transaction collects locked dir buffers to avoid
  * nested buffer deadlocks.  This function does not dirty the
- * transaction.  The caller should ensure that the inode is locked
+ * transaction.  The caller must hold the IOLOCK (shared or exclusive)
  * before calling this function.
  */
 int
@@ -507,8 +511,9 @@ xfs_readdir(
 	size_t			bufsize)
 {
 	struct xfs_da_args	args = { NULL };
-	int			rval;
-	int			v;
+	unsigned int		lock_mode;
+	int			isblock;
+	int			error;
 
 	trace_xfs_readdir(dp);
 
@@ -516,6 +521,7 @@ xfs_readdir(
 		return -EIO;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+	ASSERT(xfs_isilocked(dp, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
 	XFS_STATS_INC(dp->i_mount, xs_dir_getdents);
 
 	args.dp = dp;
@@ -523,13 +529,22 @@ xfs_readdir(
 	args.trans = tp;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
-		rval = xfs_dir2_sf_getdents(&args, ctx);
-	else if ((rval = xfs_dir2_isblock(&args, &v)))
-		;
-	else if (v)
-		rval = xfs_dir2_block_getdents(&args, ctx);
-	else
-		rval = xfs_dir2_leaf_getdents(&args, ctx, bufsize);
-
-	return rval;
+		return xfs_dir2_sf_getdents(&args, ctx);
+
+	lock_mode = xfs_ilock_data_map_shared(dp);
+	error = xfs_dir2_isblock(&args, &isblock);
+	if (error)
+		goto out_unlock;
+
+	if (isblock) {
+		error = xfs_dir2_block_getdents(&args, ctx, &lock_mode);
+		goto out_unlock;
+	}
+
+	error = xfs_dir2_leaf_getdents(&args, ctx, bufsize, &lock_mode);
+
+out_unlock:
+	if (lock_mode)
+		xfs_iunlock(dp, lock_mode);
+	return error;
 }
