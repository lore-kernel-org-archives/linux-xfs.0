Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3A7C48BCF
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23B2D61285
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhFMRWJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 13:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhFMRWJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3274C61284;
        Sun, 13 Jun 2021 17:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604808;
        bh=QW8tbXwGzlW567uavBiUxGIgNrJH2VxU7aX8TJPbCCE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gAwLKqFOasZ1Ho0W4Vm5MQCHsEqmCFmx6mo0A3WbWRMvdcxRmGPZbRfpgAGFQ81Li
         I7840G1i+FCI5uPQ4as4HGQyqmAsLVUdjqvgk0yGP+f9WopUgEvQrjqQdArCPx7vWE
         k4yD7FZBLtBEGBVeOvy4k4JR0raZ3Mnd7DCPLAPli3Qn0jnYBUJsuwttJbdDGS3yfK
         JJInrieIhf+1bv0DqfJIjf32gdpUHwq/1DOe8sT67z/VToVY14wYTBO5u6F+sS+61Y
         202vx/QVZlq1frMmodVjYlJXxxjPFQUQC8SvCvO84xqVr/TbaNAlnwZCkZskXk1FFM
         GPADwRGSKzkUw==
Subject: [PATCH 02/16] xfs: move xfs_inactive call to
 xfs_inode_mark_reclaimable
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:20:07 -0700
Message-ID: <162360480791.1530792.12003297610956705274.stgit@locust>
In-Reply-To: <162360479631.1530792.17147217854887531696.stgit@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the xfs_inactive call and all the other debugging checks and stats
updates into xfs_inode_mark_reclaimable because most of that are
implementation details about the inode cache.  This is preparation for
deferred inactivation that is coming up.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.c  |   50 --------------------------------------------------
 2 files changed, 49 insertions(+), 50 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 37229517c8f7..a2d81331867b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -301,6 +301,32 @@ xfs_perag_clear_inode_tag(
 	trace_xfs_perag_clear_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
 }
 
+#ifdef DEBUG
+static void
+xfs_check_delalloc(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_bmbt_irec	got;
+	struct xfs_iext_cursor	icur;
+
+	if (!ifp || !xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got))
+		return;
+	do {
+		if (isnullstartblock(got.br_startblock)) {
+			xfs_warn(ip->i_mount,
+	"ino %llx %s fork has delalloc extent at [0x%llx:0x%llx]",
+				ip->i_ino,
+				whichfork == XFS_DATA_FORK ? "data" : "cow",
+				got.br_startoff, got.br_blockcount);
+		}
+	} while (xfs_iext_next_extent(ifp, &icur, &got));
+}
+#else
+#define xfs_check_delalloc(ip, whichfork)	do { } while (0)
+#endif
+
 /*
  * We set the inode flag atomically with the radix tree tag.
  * Once we get tag lookups on the radix tree, this inode flag
@@ -313,6 +339,29 @@ xfs_inode_mark_reclaimable(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
 
+	xfs_inactive(ip);
+
+	if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
+		xfs_check_delalloc(ip, XFS_DATA_FORK);
+		xfs_check_delalloc(ip, XFS_COW_FORK);
+		ASSERT(0);
+	}
+
+	XFS_STATS_INC(mp, vn_reclaim);
+
+	/*
+	 * We should never get here with one of the reclaim flags already set.
+	 */
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
+
+	/*
+	 * We always use background reclaim here because even if the inode is
+	 * clean, it still may be under IO and hence we have wait for IO
+	 * completion to occur before we can reclaim the inode. The background
+	 * reclaim path handles this more efficiently than we can here, so
+	 * simply let background reclaim tear down all inodes.
+	 */
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3a7fd4f02aa7..dd1ee333dcb3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -603,32 +603,6 @@ xfs_fs_alloc_inode(
 	return NULL;
 }
 
-#ifdef DEBUG
-static void
-xfs_check_delalloc(
-	struct xfs_inode	*ip,
-	int			whichfork)
-{
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
-	struct xfs_bmbt_irec	got;
-	struct xfs_iext_cursor	icur;
-
-	if (!ifp || !xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got))
-		return;
-	do {
-		if (isnullstartblock(got.br_startblock)) {
-			xfs_warn(ip->i_mount,
-	"ino %llx %s fork has delalloc extent at [0x%llx:0x%llx]",
-				ip->i_ino,
-				whichfork == XFS_DATA_FORK ? "data" : "cow",
-				got.br_startoff, got.br_blockcount);
-		}
-	} while (xfs_iext_next_extent(ifp, &icur, &got));
-}
-#else
-#define xfs_check_delalloc(ip, whichfork)	do { } while (0)
-#endif
-
 /*
  * Now that the generic code is guaranteed not to be accessing
  * the linux inode, we can inactivate and reclaim the inode.
@@ -644,30 +618,6 @@ xfs_fs_destroy_inode(
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
-
-	xfs_inactive(ip);
-
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
-		xfs_check_delalloc(ip, XFS_DATA_FORK);
-		xfs_check_delalloc(ip, XFS_COW_FORK);
-		ASSERT(0);
-	}
-
-	XFS_STATS_INC(ip->i_mount, vn_reclaim);
-
-	/*
-	 * We should never get here with one of the reclaim flags already set.
-	 */
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
-
-	/*
-	 * We always use background reclaim here because even if the inode is
-	 * clean, it still may be under IO and hence we have wait for IO
-	 * completion to occur before we can reclaim the inode. The background
-	 * reclaim path handles this more efficiently than we can here, so
-	 * simply let background reclaim tear down all inodes.
-	 */
 	xfs_inode_mark_reclaimable(ip);
 }
 

