Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB9CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbiL3Xps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235662AbiL3Xpr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:45:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8023B54
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:45:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4836361B98
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7F9C433D2;
        Fri, 30 Dec 2022 23:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443944;
        bh=bl1SQsCFtfF2HQZMiPfOn9dL4rh3TJSqdVNBF9ALUXc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=abIU9myD6yHz9VjK97Xm5KIHc9FucynJZtnVFhLl5WnuXI+3wM3FUGJtRg/02rVhi
         HcvhULFYctvB7Jav8wgfrSFLN0fZpeSZSb0tS3HOID01DLbWktc84aYMJ7lFn9fjIN
         FGytalGIUfgeOrnl0dAzgXrlOIgBtrkrZztFzByxjsI5pE9I72nur8NWsogEnXB126
         0HLO1yAoVm1AEnqYBUk6xdsCGd1kLl5NoMaxNeq5dhAvDV88Iv42icjD8mWSxyN3y3
         zqeHqhsytQ5f6DMOcUc6j4DdLX49oBK1LLKnee3W5G0gcW9lIAiKR+rKFy9hWatbjQ
         9JBWDNI/Xm+3A==
Subject: [PATCH 7/9] xfs: remove the unnecessary daddr paramter to _init_block
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:34 -0800
Message-ID: <167243841470.696890.3597907693562700617.stgit@magnolia>
In-Reply-To: <167243841359.696890.6518296492918665756.stgit@magnolia>
References: <167243841359.696890.6518296492918665756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that all of the callers pass XFS_BUF_DADDR_NULL as the daddr
parameter, we can elide that too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c          |    3 +--
 fs/xfs/libxfs/xfs_bmap_btree.c    |    3 +--
 fs/xfs/libxfs/xfs_btree.c         |   19 ++++++++++++++++---
 fs/xfs/libxfs/xfs_btree.h         |    2 +-
 fs/xfs/libxfs/xfs_btree_staging.c |    5 ++---
 5 files changed, 21 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ac20971a8c18..ee94c935702d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -639,8 +639,7 @@ xfs_bmap_extents_to_btree(
 	 * Fill in the root.
 	 */
 	block = ifp->if_broot;
-	xfs_btree_init_block(mp, block, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL, 1,
-			1, ip->i_ino);
+	xfs_btree_init_block(mp, block, &xfs_bmbt_ops, 1, 1, ip->i_ino);
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index f70194293f54..2f9202ed41dd 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -43,8 +43,7 @@ xfs_bmdr_to_bmbt(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	xfs_btree_init_block(mp, rblock, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL,
-			0, 0, ip->i_ino);
+	xfs_btree_init_block(mp, rblock, &xfs_bmbt_ops, 0, 0, ip->i_ino);
 	rblock->bb_level = dblock->bb_level;
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	rblock->bb_numrecs = dblock->bb_numrecs;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index b3f9b7324c93..54afec1f9121 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1212,8 +1212,8 @@ xfs_btree_set_sibling(
 	}
 }
 
-void
-xfs_btree_init_block(
+static void
+__xfs_btree_init_block(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*buf,
 	const struct xfs_btree_ops *ops,
@@ -1254,6 +1254,19 @@ xfs_btree_init_block(
 	}
 }
 
+void
+xfs_btree_init_block(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*block,
+	const struct xfs_btree_ops *ops,
+	__u16			level,
+	__u16			numrecs,
+	__u64			owner)
+{
+	__xfs_btree_init_block(mp, block, ops, XFS_BUF_DADDR_NULL, level,
+			numrecs, owner);
+}
+
 void
 xfs_btree_init_buf(
 	struct xfs_mount		*mp,
@@ -1263,7 +1276,7 @@ xfs_btree_init_buf(
 	__u16				numrecs,
 	__u64				owner)
 {
-	xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
+	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 5557aa4148e6..451263e77144 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -456,7 +456,7 @@ void xfs_btree_init_buf(struct xfs_mount *mp, struct xfs_buf *bp,
 		__u64 owner);
 void xfs_btree_init_block(struct xfs_mount *mp,
 		struct xfs_btree_block *buf, const struct xfs_btree_ops *ops,
-		xfs_daddr_t blkno, __u16 level, __u16 numrecs, __u64 owner);
+		__u16 level, __u16 numrecs, __u64 owner);
 
 /*
  * Common btree core entry points.
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index de17d333ffb3..73d9aaeafead 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -404,9 +404,8 @@ xfs_btree_bload_prep_block(
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */
-		xfs_btree_init_block(cur->bc_mp, ifp->if_broot,
-				cur->bc_ops, XFS_BUF_DADDR_NULL, level,
-				nr_this_block, cur->bc_ino.ip->i_ino);
+		xfs_btree_init_block(cur->bc_mp, ifp->if_broot, cur->bc_ops,
+				level, nr_this_block, cur->bc_ino.ip->i_ino);
 
 		*bpp = NULL;
 		*blockp = ifp->if_broot;

