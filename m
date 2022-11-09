Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB25C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiKICGK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKICGK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:06:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACE0663D8
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:06:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBF12B81CC4
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F20C433C1;
        Wed,  9 Nov 2022 02:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959565;
        bh=2nNqxIlR0BfBKCWmaciTLxX2lwhjOywxBms7atRMe3s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tnOnc0z+qNh8bvuz6cROCkRvE9xlNzimxtVopsOCPPhV1MvjvFuEhOIvXqoDp4Ulc
         CK6reqe/xlK8fK1Golth903K5KbE1UJPmC2yNz+kD0JtLRuystqHsqkRGXkEPPokPo
         kbhGZ0iNnHIcbw5afUrOZ5kSjD4rc9oUVw74Xbye2Ev1gh82uz34mwdn9PeZsVsf9j
         ISJplpQY00jrG+M2akcyG2bmZ0CqFERCOggdP+O3RRA6RKcKwplGeI1kGiqX6Ihoe0
         BIIRk0UHoV+62WETwt9sDjWsGsUpElETl47eHWo7lMu1bWh7K6b5PXaaxTHWB/GXIq
         ku6X6RyG4lCcA==
Subject: [PATCH 04/24] xfs: rearrange the logic and remove the broken comment
 for xfs_dir2_isxx
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Shida Zhang <zhangshida@kylinos.cn>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:06:05 -0800
Message-ID: <166795956500.3761583.4853170066354811352.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Shida Zhang <zhangshida@kylinos.cn>

Source kernel commit: c098576f5f63bc0ee2424bba50892514a71d54e8

xfs_dir2_isleaf is used to see if the directory is a single-leaf
form directory instead, as commented right above the function.

Besides getting rid of the broken comment, we rearrange the logic by
converting everything over to standard formatting and conventions,
at the same time, to make it easier to understand and self documenting.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 db/namei.c        |    2 +-
 libxfs/xfs_dir2.c |   50 ++++++++++++++++++++++++++++++--------------------
 libxfs/xfs_dir2.h |    4 ++--
 repair/phase6.c   |    4 ++--
 4 files changed, 35 insertions(+), 25 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index 6c57cc624e..7a5d749a77 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -449,8 +449,8 @@ listdir(
 		.dp		= dp,
 		.geo		= dp->i_mount->m_dir_geo,
 	};
+	bool			isblock;
 	int			error;
-	int			isblock;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
 		return list_sfdir(&args);
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index fac072fcb1..d6a192963f 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -260,7 +260,7 @@ xfs_dir_createname(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	int			v;		/* type-checking value */
+	bool			v;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 
@@ -356,7 +356,7 @@ xfs_dir_lookup(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	int			v;	  /* type-checking value */
+	bool			v;
 	int			lock_mode;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
@@ -434,7 +434,7 @@ xfs_dir_removename(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	int			v;		/* type-checking value */
+	bool			v;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
@@ -492,7 +492,7 @@ xfs_dir_replace(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	int			v;		/* type-checking value */
+	bool			v;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 
@@ -609,19 +609,23 @@ xfs_dir2_grow_inode(
 int
 xfs_dir2_isblock(
 	struct xfs_da_args	*args,
-	int			*vp)	/* out: 1 is block, 0 is not block */
+	bool			*isblock)
 {
-	xfs_fileoff_t		last;	/* last file offset */
-	int			rval;
+	struct xfs_mount	*mp = args->dp->i_mount;
+	xfs_fileoff_t		eof;
+	int			error;
 
-	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
-		return rval;
-	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
-	if (XFS_IS_CORRUPT(args->dp->i_mount,
-			   rval != 0 &&
-			   args->dp->i_disk_size != args->geo->blksize))
+	error = xfs_bmap_last_offset(args->dp, &eof, XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	*isblock = false;
+	if (XFS_FSB_TO_B(mp, eof) != args->geo->blksize)
+		return 0;
+
+	*isblock = true;
+	if (XFS_IS_CORRUPT(mp, args->dp->i_disk_size != args->geo->blksize))
 		return -EFSCORRUPTED;
-	*vp = rval;
 	return 0;
 }
 
@@ -631,14 +635,20 @@ xfs_dir2_isblock(
 int
 xfs_dir2_isleaf(
 	struct xfs_da_args	*args,
-	int			*vp)	/* out: 1 is block, 0 is not block */
+	bool			*isleaf)
 {
-	xfs_fileoff_t		last;	/* last file offset */
-	int			rval;
+	xfs_fileoff_t		eof;
+	int			error;
 
-	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
-		return rval;
-	*vp = last == args->geo->leafblk + args->geo->fsbcount;
+	error = xfs_bmap_last_offset(args->dp, &eof, XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	*isleaf = false;
+	if (eof != args->geo->leafblk + args->geo->fsbcount)
+		return 0;
+
+	*isleaf = true;
 	return 0;
 }
 
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index b6df3c34b2..dd39f17dd9 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -61,8 +61,8 @@ extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
 /*
  * Interface routines used by userspace utilities
  */
-extern int xfs_dir2_isblock(struct xfs_da_args *args, int *r);
-extern int xfs_dir2_isleaf(struct xfs_da_args *args, int *r);
+extern int xfs_dir2_isblock(struct xfs_da_args *args, bool *isblock);
+extern int xfs_dir2_isleaf(struct xfs_da_args *args, bool *isleaf);
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_buf *bp);
 
diff --git a/repair/phase6.c b/repair/phase6.c
index fefb9755f5..81fccff9d4 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2250,8 +2250,8 @@ longform_dir2_entry_check(
 	xfs_dablk_t		da_bno;
 	freetab_t		*freetab;
 	int			i;
-	int			isblock;
-	int			isleaf;
+	bool			isblock;
+	bool			isleaf;
 	xfs_fileoff_t		next_da_bno;
 	int			seeval;
 	int			fixit = 0;

