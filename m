Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B7AE7F14D
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjI0AT7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjI0AR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:17:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1AD3580
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:38:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5A5C433C7;
        Tue, 26 Sep 2023 23:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771522;
        bh=xWEmlQ3UzOI6xLr9YHRjcRt6nTARqg6cw9ILrRSUsaA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=McYTbVND4K3TMTn7NgYsf9UJYpycsGiJhU0EcO2SdNzhbGY2FEySgZd3bmzuUAmGS
         X71kZ33sli+gQ22H0J88n78WtTbW184KyKgOQobJ3uUqxFlx+GZ2AYF/56S2pkKkVG
         pqK1lbDhpmvBnAzfiLaermNMa9Qp+I2nT/6bP5/hPF7wFGFNLyxEzgPnIveov/zKQN
         l4F0YPYFcbhQMX5EmxuKRBHmRDgFT54SzDF5en3UsX3YUT06Jx8nA6Q/DfhbjukzJY
         0JhqN/ZU4VOx44g5YgvqEPj8AVjfYh2cWxxRjjC1IlOWQ0qDEuFg8rH8713wwil4bE
         xopvZVcGPyLog==
Date:   Tue, 26 Sep 2023 16:38:42 -0700
Subject: [PATCH 2/4] xfs: create a new inode fork block unmap helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577061217.3315493.3049593931693882049.stgit@frogsfrogsfrogs>
In-Reply-To: <169577061183.3315493.6171012860982301231.stgit@frogsfrogsfrogs>
References: <169577061183.3315493.6171012860982301231.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new helper to unmap blocks from an inode's fork.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   39 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |    2 ++
 fs/xfs/xfs_inode.c       |   24 ++++--------------------
 3 files changed, 45 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index aabce6e218888..25c08519934aa 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6248,3 +6248,42 @@ xfs_bmap_validate_extent(
 	return xfs_bmap_validate_extent_raw(ip->i_mount,
 			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
 }
+
+/*
+ * Used in xfs_itruncate_extents().  This is the maximum number of extents
+ * freed from a file in a single transaction.
+ */
+#define	XFS_ITRUNC_MAX_EXTENTS	2
+
+/*
+ * Unmap every extent in part of an inode's fork.  We don't do any higher level
+ * invalidation work at all.
+ */
+int
+xfs_bunmapi_range(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	uint32_t		flags,
+	xfs_fileoff_t		startoff,
+	xfs_fileoff_t		endoff)
+{
+	xfs_filblks_t		unmap_len = endoff - startoff + 1;
+	int			error = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	while (unmap_len > 0) {
+		ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
+		error = __xfs_bunmapi(*tpp, ip, startoff, &unmap_len, flags,
+				XFS_ITRUNC_MAX_EXTENTS);
+		if (error)
+			goto out;
+
+		/* free the just unmapped extents */
+		error = xfs_defer_finish(tpp);
+		if (error)
+			goto out;
+	}
+out:
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 8518324db2855..9bc78c717ecf7 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -273,6 +273,8 @@ int xfs_bmap_complain_bad_rec(struct xfs_inode *ip, int whichfork,
 int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
 		uint32_t flags);
+int	xfs_bunmapi_range(struct xfs_trans **tpp, struct xfs_inode *ip,
+		uint32_t flags, xfs_fileoff_t startoff, xfs_fileoff_t endoff);
 
 extern struct kmem_cache	*xfs_bmap_intent_cache;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4d55f58d99b7a..96731b98fad21 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -40,12 +40,6 @@
 
 struct kmem_cache *xfs_inode_cache;
 
-/*
- * Used in xfs_itruncate_extents().  This is the maximum number of extents
- * freed from a file in a single transaction.
- */
-#define	XFS_ITRUNC_MAX_EXTENTS	2
-
 STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
 STATIC int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 	struct xfs_inode *);
@@ -1332,7 +1326,6 @@ xfs_itruncate_extents_flags(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
 	xfs_fileoff_t		first_unmap_block;
-	xfs_filblks_t		unmap_len;
 	int			error = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -1364,19 +1357,10 @@ xfs_itruncate_extents_flags(
 		return 0;
 	}
 
-	unmap_len = XFS_MAX_FILEOFF - first_unmap_block + 1;
-	while (unmap_len > 0) {
-		ASSERT(tp->t_highest_agno == NULLAGNUMBER);
-		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
-				flags, XFS_ITRUNC_MAX_EXTENTS);
-		if (error)
-			goto out;
-
-		/* free the just unmapped extents */
-		error = xfs_defer_finish(&tp);
-		if (error)
-			goto out;
-	}
+	error = xfs_bunmapi_range(&tp, ip, flags, first_unmap_block,
+			XFS_MAX_FILEOFF);
+	if (error)
+		goto out;
 
 	if (whichfork == XFS_DATA_FORK) {
 		/* Remove all pending CoW reservations. */

