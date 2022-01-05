Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDC1C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 19:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243763AbiAETwi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 14:52:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33440 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243764AbiAETw3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 14:52:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C62E1B81DA0
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 19:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D987C36AE0;
        Wed,  5 Jan 2022 19:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641412346;
        bh=kHQLLc3c1tRDknxHzWy2QSN5QS6xPRKbwUvPQ8nbvbE=;
        h=Date:From:To:Cc:Subject:From;
        b=rxwBOnovjJuT0L/iDAcfC/aTnCeF+0GTcYbhJfqUGRqZSIS7VJ77vyFMIXci9O/jk
         XC9uWZ9Y/KYue2sMxo6xqKkIAjtmoME0Ol1ObfsYjMrwJ8Uuq1+APD+1xUpUsDgCBh
         8SBzeROlDyHkMAtJG0cR0HdxDAx7uIeajOeeOt1PBtOXEtczmzMx0iZY+MaZpwbVJO
         QcQaCiM2pFDtoDAWSOFx2+DvG+HTytenjmKN9SLd830iVHWmSTAMNeZkBzUJ7grjyR
         q/rwlGvXz5BTax1cSGj4Lxr6iyQ1c9/MbEPGz8jNd6GGoLikMf/aROihrreK5yg0bm
         dSPfahxxlGjGQ==
Date:   Wed, 5 Jan 2022 11:52:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: take the ILOCK when accessing the inode core
Message-ID: <20220105195226.GL656707@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
v2: reduce the scope of the locked region, and reduce lock cycling
---
 fs/xfs/xfs_dir2_readdir.c |   52 +++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 8310005af00f..74844edd86a7 100644
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
 
@@ -523,13 +528,22 @@ xfs_readdir(
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
