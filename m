Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C52C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiL3Xch (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235687AbiL3Xcf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:32:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31D61DF1A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:32:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A5E7B81D97
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AD1C433EF;
        Fri, 30 Dec 2022 23:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443151;
        bh=5Lhs3qbenYy5WMGNR2iWzn16cN/bvPfy+0XvjoWOIow=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r6AO4ORJ5WNtWSoPZCZXRizVduSHpeq1HRA7Kv1P6Nff0ZrsWFd2Hl5O4IBv2+e75
         nXIQLZ+3+5cZjfHqCToPM5fMvgDnpu+gASGBiJt2nlHK3fQnAZpE0qilyLpjFgQtGw
         U+ETP+2mS/2LzkZ3ZaA2XV3Vp8ltyGgNdh57QgHyKJYt/xeRAUDxZNOiq9fEb4y+MV
         yQGJ6rHS71NeLZmhvNIUhQMDwxbFXukTZZIAIztpDMpjwj+MeuRnKLdOnx7HkOBMCN
         rj6t6B0ddYqZ0hXeEeqvJ7t4bk9TIPBM2HVp0So0O+tyuQtx9MzvCIEtrjijvR/l4K
         m+GcDie8qdP1w==
Subject: [PATCH 2/4] xfs: create a new inode fork block unmap helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:00 -0800
Message-ID: <167243838021.695277.17056653213899507871.stgit@magnolia>
In-Reply-To: <167243837989.695277.12249962882609806700.stgit@magnolia>
References: <167243837989.695277.12249962882609806700.stgit@magnolia>
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
index d689a262ce39..2f626ad1f4b4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6268,3 +6268,42 @@ xfs_bmap_validate_extent(
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
+		ASSERT((*tpp)->t_firstblock == NULLFSBLOCK);
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
index 903047c146c3..1201ee024c1f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -266,6 +266,8 @@ int xfs_bmap_complain_bad_rec(struct xfs_inode *ip, int whichfork,
 int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
 		uint32_t flags);
+int	xfs_bunmapi_range(struct xfs_trans **tpp, struct xfs_inode *ip,
+		uint32_t flags, xfs_fileoff_t startoff, xfs_fileoff_t endoff);
 
 extern struct kmem_cache	*xfs_bmap_intent_cache;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d354ea2b74f9..47197e4cdbe8 100644
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
-		ASSERT(tp->t_firstblock == NULLFSBLOCK);
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

