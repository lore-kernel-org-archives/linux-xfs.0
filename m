Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA63BC6FA86
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Sep 2022 06:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiIRGuf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Sep 2022 02:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIRGue (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Sep 2022 02:50:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8B2248D5
        for <linux-xfs@vger.kernel.org>; Sat, 17 Sep 2022 23:50:33 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q62-20020a17090a17c400b00202a3497516so3291080pja.1
        for <linux-xfs@vger.kernel.org>; Sat, 17 Sep 2022 23:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=a2X+9yISI8Xh60D1Q8sjFyKXE/5fz0NueCR5kBPaKRM=;
        b=NZ1q/jAvjVCSLa+RYxkJZKfPFerLlbjxCdX6npxWehDZzj5x9Fui59a292utr8HDpI
         wNFzEbIcZa4WvSW5chepzzI/zuTQNhjWqZTxfLHbL51yy8ZC/fGmJ10d596O1GHaJCiV
         7seWpJvioQuxnnWdEX0uY7S4dzsSEW/G9bUXtYMr9ZrZlkPkhmZGR1Q0FP/PGI3FOrn5
         0qD/LTo6rl2D7/IMpxdYo+4OxJhw2in/guLtpRncd3C6CHeKFWlZTvykSozAoXHHMx6T
         UuOYRce2TX/rrVt0NamVgPv4plKP50OinHZtUt4nqfMZR+OWY8VoyGDTuZ7/myyUlvNC
         t5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=a2X+9yISI8Xh60D1Q8sjFyKXE/5fz0NueCR5kBPaKRM=;
        b=PLXo0ZId3eHeBqLxL5zy3JfUoEdPzZafR1cvznII/l2TQOaqBAgvZuaOQOOlMBtrMJ
         37vlgCM9lMA9+2b7vPYIp+011dCuxe7c4jAnBOXJuuQS6pAlJT7ALFO/pq6FHfkySovo
         CTbH0uMMm8f2XY8gJv4YHq1LoKaQSxj0uSZ2Pr4cR4CFi3kWbW1D4nfjoE4UcECwnQCh
         X80UYYqDzKF9MGkd/UumugQ5TAOKHFh1sZfS7bTI9BpRv5ei1TgScAEf19neHGH0xt9e
         mDWR0ffW2WPoBoZXXmAfZuyXteHKg9xVXM/jDp3PAxmIn7XkYsQPaAZLbM1zOTkDgmgV
         Y1Lw==
X-Gm-Message-State: ACrzQf2sXn8ZaotTQBgdbTSMimNk6Yjbj1A1o3YWjoU/DnkPUMBJkW6e
        Bwo5JfVTDdo4Rh/y3PfeEFw=
X-Google-Smtp-Source: AMsMyM5DrnxFT18BavB8/S1M2MXN+e0G1l5W65pjjb+DxqoByiXB7r88kRHHVASLW8QKCMqnuLfKzQ==
X-Received: by 2002:a17:902:d512:b0:178:2898:8099 with SMTP id b18-20020a170902d51200b0017828988099mr7414325plg.131.1663483832543;
        Sat, 17 Sep 2022 23:50:32 -0700 (PDT)
Received: from localhost.localdomain ([165.154.253.46])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902680600b00176b84eb29asm17773121plk.301.2022.09.17.23.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 23:50:32 -0700 (PDT)
From:   Stephen Zhang <starzhangzsd@gmail.com>
X-Google-Original-From: Stephen Zhang <zhangshida@kylinos.cn>
To:     djwong@kernel.org, dchinner@redhat.com, chandan.babu@oracle.com
Cc:     zhangshida@kylinos.cn, starzhangzsd@gmail.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: rearrange the logic and remove the broken comment for xfs_dir2_isxx
Date:   Sun, 18 Sep 2022 14:50:26 +0800
Message-Id: <20220918065026.1207016-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_dir2_isleaf is used to see if the directory is a single-leaf
form directory instead, as commented right above the function.

Besides getting rid of the broken comment, we rearrange the logic by
converting everything over to standard formatting and conventions,
at the same time, to make it easier to understand and self documenting.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
Changes from v1:
- v1 is only designed to fix the broken comment, while v2 rearranges the
  logic in addition to that, which is suggested by Dave.
---
 fs/xfs/libxfs/xfs_dir2.c  | 50 +++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_dir2.h  |  4 ++--
 fs/xfs/scrub/dir.c        |  2 +-
 fs/xfs/xfs_dir2_readdir.c |  2 +-
 4 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 76eedc2756b3..33738165d67d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -261,7 +261,7 @@ xfs_dir_createname(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	int			v;		/* type-checking value */
+	bool			v;		/* type-checking value */
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 
@@ -357,7 +357,7 @@ xfs_dir_lookup(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	int			v;	  /* type-checking value */
+	bool			v;	  /* type-checking value */
 	int			lock_mode;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
@@ -435,7 +435,7 @@ xfs_dir_removename(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	int			v;		/* type-checking value */
+	bool			v;		/* type-checking value */
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
@@ -493,7 +493,7 @@ xfs_dir_replace(
 {
 	struct xfs_da_args	*args;
 	int			rval;
-	int			v;		/* type-checking value */
+	bool			v;		/* type-checking value */
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 
@@ -610,19 +610,23 @@ xfs_dir2_grow_inode(
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
 
@@ -632,14 +636,20 @@ xfs_dir2_isblock(
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
 
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index b6df3c34b26a..dd39f17dd9a9 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
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
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 5abb5fdb71d9..b9c5764e7437 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -676,7 +676,7 @@ xchk_directory_blocks(
 	xfs_dablk_t		dabno;
 	xfs_dir2_db_t		last_data_db = 0;
 	bool			found;
-	int			is_block = 0;
+	bool			is_block = false;
 	int			error;
 
 	/* Ignore local format directories. */
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index e295fc8062d8..9f3ceb461515 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -512,7 +512,7 @@ xfs_readdir(
 {
 	struct xfs_da_args	args = { NULL };
 	unsigned int		lock_mode;
-	int			isblock;
+	bool			isblock;
 	int			error;
 
 	trace_xfs_readdir(dp);
-- 
2.27.0

