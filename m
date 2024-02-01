Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC59343AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817365; cv=none; b=uXCezNs6vHSwGlXOIiuLa3ostlnKseLdOYN/PPHx6thkvySgrRYQfrfCBLavkA/CDDAqyH1cBEvR/FzA+tJ6link5I9xCu8/HcNdGSOFShF1BXPukzE1NjJDH8g/ca2HmDXNRwc55F7ehwzJb/Kypd3BQfifrJGgTsBlW68cAJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817365; c=relaxed/simple;
	bh=gZFV2lhU0JtNWu94d9JZzDxnTLnVBujb8ijLGhjRbQc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VFOUqjToBBnx6zkrCro7pGZXvFU5UqioAcKZKhhUETTihXdd/K8HqS0NxUMfF7sSQh7/KYVec8SkoRWl+/IM8GbwdnsUQ3xJtW2kPhMzXu/I7BLlCjDhwVXGn0kKfw2A9psIhyVZ8QUIAk1+VflPOv9doBRpyOjK4pK8pTwbD9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lMRzjBum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lMRzjBum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E198C433F1;
	Thu,  1 Feb 2024 19:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817365;
	bh=gZFV2lhU0JtNWu94d9JZzDxnTLnVBujb8ijLGhjRbQc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lMRzjBumkda5elaoVtZ7HcuqCE1EJf0OY3hID/4gyVF05eZv4gLxL4pDk5ijX80Dm
	 eNSeepLd5tBgRq3U4euNDawkxF3mSLye6BE+D6f8oA6ofWl0P6cY0XISuTP6+2XVdv
	 25kvp9Ou3v2b2bqm28l7ELeqyKqzSHSG1pAfEUxI9n3lBVaCyQyalZyQyzPR+ZUjj7
	 WLjAjEOqV6WtcpOCJ+hAnJYvLgYME8bxFb23iy49YE0vKvO5GEgwDWmkFcD0YxUtls
	 stKBP5VVA0fgzKOI6YVWeqipIIX9LeqflJSmOmmJiNfIcsBizT5Dxz1EpncEKTN5v3
	 owPPKRfspQNpQ==
Date: Thu, 01 Feb 2024 11:56:05 -0800
Subject: [PATCH 3/4] xfs: move and rename xfs_btree_read_bufl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681336178.1608096.76946402904328952.stgit@frogsfrogsfrogs>
In-Reply-To: <170681336120.1608096.10255376163152255295.stgit@frogsfrogsfrogs>
References: <170681336120.1608096.10255376163152255295.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Despite its name, xfs_btree_read_bufl doesn't contain any btree-related
functionaliy and isn't used by the btree code.  Move it to xfs_bmap.c,
hard code the refval and ops arguments and rename it to
xfs_bmap_read_buf.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c  |   33 +++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_btree.c |   30 ------------------------------
 fs/xfs/libxfs/xfs_btree.h |   13 -------------
 3 files changed, 25 insertions(+), 51 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5537483c2e539..b4a2adb42df33 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -226,6 +226,28 @@ xfs_bmap_forkoff_reset(
 	}
 }
 
+static int
+xfs_bmap_read_buf(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	xfs_fsblock_t		fsbno,		/* file system block number */
+	struct xfs_buf		**bpp)		/* buffer for fsbno */
+{
+	struct xfs_buf		*bp;		/* return value */
+	int			error;
+
+	if (!xfs_verify_fsbno(mp, fsbno))
+		return -EFSCORRUPTED;
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(mp, fsbno), mp->m_bsize, 0, &bp,
+			&xfs_bmbt_buf_ops);
+	if (!error) {
+		xfs_buf_set_ref(bp, XFS_BMAP_BTREE_REF);
+		*bpp = bp;
+	}
+	return error;
+}
+
 #ifdef DEBUG
 STATIC struct xfs_buf *
 xfs_bmap_get_bp(
@@ -365,9 +387,7 @@ xfs_bmap_check_leaf_extents(
 		bp = xfs_bmap_get_bp(cur, XFS_FSB_TO_DADDR(mp, bno));
 		if (!bp) {
 			bp_release = 1;
-			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
-						XFS_BMAP_BTREE_REF,
-						&xfs_bmbt_buf_ops);
+			error = xfs_bmap_read_buf(mp, NULL, bno, &bp);
 			if (xfs_metadata_is_sick(error))
 				xfs_btree_mark_sick(cur);
 			if (error)
@@ -454,9 +474,7 @@ xfs_bmap_check_leaf_extents(
 		bp = xfs_bmap_get_bp(cur, XFS_FSB_TO_DADDR(mp, bno));
 		if (!bp) {
 			bp_release = 1;
-			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
-						XFS_BMAP_BTREE_REF,
-						&xfs_bmbt_buf_ops);
+			error = xfs_bmap_read_buf(mp, NULL, bno, &bp);
 			if (xfs_metadata_is_sick(error))
 				xfs_btree_mark_sick(cur);
 			if (error)
@@ -573,8 +591,7 @@ xfs_bmap_btree_to_extents(
 		return -EFSCORRUPTED;
 	}
 #endif
-	error = xfs_btree_read_bufl(mp, tp, cbno, &cbp, XFS_BMAP_BTREE_REF,
-				&xfs_bmbt_buf_ops);
+	error = xfs_bmap_read_buf(mp, tp, cbno, &cbp);
 	if (xfs_metadata_is_sick(error))
 		xfs_btree_mark_sick(cur);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 0f06ee026d9aa..ecdd5ea27a038 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -859,36 +859,6 @@ xfs_btree_offsets(
 	}
 }
 
-/*
- * Get a buffer for the block, return it read in.
- * Long-form addressing.
- */
-int
-xfs_btree_read_bufl(
-	struct xfs_mount	*mp,		/* file system mount point */
-	struct xfs_trans	*tp,		/* transaction pointer */
-	xfs_fsblock_t		fsbno,		/* file system block number */
-	struct xfs_buf		**bpp,		/* buffer for fsbno */
-	int			refval,		/* ref count value for buffer */
-	const struct xfs_buf_ops *ops)
-{
-	struct xfs_buf		*bp;		/* return value */
-	xfs_daddr_t		d;		/* real disk block address */
-	int			error;
-
-	if (!xfs_verify_fsbno(mp, fsbno))
-		return -EFSCORRUPTED;
-	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
-				   mp->m_bsize, 0, &bp, ops);
-	if (error)
-		return error;
-	if (bp)
-		xfs_buf_set_ref(bp, refval);
-	*bpp = bp;
-	return 0;
-}
-
 STATIC int
 xfs_btree_readahead_fsblock(
 	struct xfs_btree_cur	*cur,
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 5100f84a760c1..790eccb771866 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -378,19 +378,6 @@ xfs_btree_offsets(
 	int			*first,	/* output: first byte offset */
 	int			*last);	/* output: last byte offset */
 
-/*
- * Get a buffer for the block, return it read in.
- * Long-form addressing.
- */
-int					/* error */
-xfs_btree_read_bufl(
-	struct xfs_mount	*mp,	/* file system mount point */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_fsblock_t		fsbno,	/* file system block number */
-	struct xfs_buf		**bpp,	/* buffer for fsbno */
-	int			refval,	/* ref count value for buffer */
-	const struct xfs_buf_ops *ops);
-
 /*
  * Initialise a new btree block header
  */

