Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67F13DB8D
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mi/e6DK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D029C433C8;
	Fri, 24 Nov 2023 23:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700870131;
	bh=8Y/o4uNxx4ZnNcBVKyIEX1cJl3jWJ7srSol9VqA9e1k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mi/e6DK6ZyVVb1k/xcSXngLYBUgsP+w84zjtBRbc/FlzbdgZ/ty6IVR71Mf81QH5U
	 TxaWpGovhEFHnDniB/bD2QEDjdW5DoSsR6aqVTu8OBYZ9uV0XtGjv6t/jrGZYkWZm9
	 8hZ1Dyd2H8ztk8a2OqYpjU/HtuyLOuEcJppLb0QQq6hhIRp5ybpEQ2x5cI3eNmeQ1I
	 HqAbyNpYs924ZUsJnp/o2bWAGNoO8b5S11Hk25AMEYhN/PtlijkquAigom/dO2ZJww
	 lsE9j+oCV7TORfnSNwRyRl5SNU/pDaGKIC49TXYzPV8Krp9wGE7MB5rDdMHUfparxU
	 xXqjOYou4MHMw==
Date: Fri, 24 Nov 2023 15:55:30 -0800
Subject: [PATCH 5/6] xfs: create a new inode fork block unmap helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086928423.2771542.5465422173713890786.stgit@frogsfrogsfrogs>
In-Reply-To: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a new helper to unmap blocks from an inode's fork.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   39 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |    2 ++
 fs/xfs/xfs_inode.c       |   24 ++++--------------------
 3 files changed, 45 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9968a3a6e6d8d..cebf490daf43e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6231,3 +6231,42 @@ xfs_bmap_validate_extent(
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
index c0f1c89786c2a..424b03628b7cf 100644
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
@@ -1339,7 +1333,6 @@ xfs_itruncate_extents_flags(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
 	xfs_fileoff_t		first_unmap_block;
-	xfs_filblks_t		unmap_len;
 	int			error = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -1371,19 +1364,10 @@ xfs_itruncate_extents_flags(
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

