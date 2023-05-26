Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF36C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbjEZBJ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZBJ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:09:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF704199
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 881CA64C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FB1C433D2;
        Fri, 26 May 2023 01:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063388;
        bh=8sKXM5+PWsZ0UnJjTu7ZfHVHQ40yB3CO2fLtypk+q3A=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ogqPVmV2ogLNjoKoS2EiCE5V+LSYyi/yNY2XRrAc+GXWSp37BUBoNf8hGtcZtzaLF
         50ESoI5oPNlYCFBBc7LoodPriQX1xMLMgL4jy+4wsDRatUimOEgEgZsC5L3VZuFtgt
         gIeawtWuTjPrO+qOZ7LLXOZi0mG3Djy2HTR12R8zPi37XqBA7RGqlM7F4BiWkG6bkI
         LUZoo9cVpMVpnUPCp9XOSPKS0vks/r00F9N+P7OcMuHbohsPdly1Ypttcpvm/i1c/L
         TD1jrCHrUX2wsdJJU0m0OSndgz66mulab/+IApS7gnpl/wUvFWWCZIL/ruEqoChWNM
         K3/TrqCJQlpDg==
Date:   Thu, 25 May 2023 18:09:47 -0700
Subject: [PATCH 7/9] xfs: remove the unnecessary daddr paramter to _init_block
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506062782.3733506.7561063243937883814.stgit@frogsfrogsfrogs>
In-Reply-To: <168506062668.3733506.5702088548886151666.stgit@frogsfrogsfrogs>
References: <168506062668.3733506.5702088548886151666.stgit@frogsfrogsfrogs>
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
index f81f336a69e5..456f2559790b 100644
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
index 904971502dc6..c6b0993bde47 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -44,8 +44,7 @@ xfs_bmdr_to_bmbt(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	xfs_btree_init_block(mp, rblock, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL,
-			0, 0, ip->i_ino);
+	xfs_btree_init_block(mp, rblock, &xfs_bmbt_ops, 0, 0, ip->i_ino);
 	rblock->bb_level = dblock->bb_level;
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	rblock->bb_numrecs = dblock->bb_numrecs;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 0fdaacefe45e..285dc609daa8 100644
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
index 925bcd245bcf..7edf8f2b3240 100644
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

