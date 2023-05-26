Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABC4C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjEZAzc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbjEZAzb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:55:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8043D1A4
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:55:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14C00617B3
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76707C433D2;
        Fri, 26 May 2023 00:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062529;
        bh=TWjZ6fVplkgZS9UykjnHITsSA7XwYwh8ggR8iFxoQIo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UVbJa3okK8t5fIYzC1ZpebIoAdnjOfiAGs9LGET8F3CJVgbWioHLVn0wtVEaudBPV
         TLWMcNpsoyt1sr6PZFIUPx2XfRKXYKOtV3W2BYY0V0JgOPE60LY5nLGlkcZAt7Hr0g
         /sSnHONFwxswbd0nJS4yOJZhSZfZsbnzjqUEfyKVcu6xaqFo1wy4Fzwzb3+navSUCD
         kCgPqm8rOvYqEmDUJ89MAw55iqN/d94HOCq1S9y68o3obulMM0itnnE+cwJWodNqaQ
         po1LVhDXf5y26mZeYF/gTMlHjMKVrmSqPHVcINaB89+116bGxRt76fcWtTTgfH+Qrs
         4OPx8dmK1Qr+g==
Date:   Thu, 25 May 2023 17:55:29 -0700
Subject: [PATCH 2/4] xfs: create a new inode fork block unmap helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506059129.3730797.3163867418022885866.stgit@frogsfrogsfrogs>
In-Reply-To: <168506059095.3730797.12158750493561425588.stgit@frogsfrogsfrogs>
References: <168506059095.3730797.12158750493561425588.stgit@frogsfrogsfrogs>
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
index 3cbc4d0db47f..18bfa70a90b3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6240,3 +6240,42 @@ xfs_bmap_validate_extent(
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
index 8518324db285..9bc78c717ecf 100644
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
index 5808abab786c..296ebc3cf82e 100644
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
@@ -1333,7 +1327,6 @@ xfs_itruncate_extents_flags(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
 	xfs_fileoff_t		first_unmap_block;
-	xfs_filblks_t		unmap_len;
 	int			error = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -1365,19 +1358,10 @@ xfs_itruncate_extents_flags(
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

