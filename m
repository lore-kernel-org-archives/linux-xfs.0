Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62900195
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371908; cv=none; b=JaARk7C+NUG8HadpbcvJnddOJYkEQ+YAUCSF1nycVDXlPnO4jzVRCY/8OMJORJ7j0ds9S6wvgqDmvTYpqBSt1tHqjaweiXooPregYfLR5FUxbxEzRTYOa/U9z81aelmA7Tnjguf36CgLr0saB4c0CdmELsyOp9tC4xrrBykE+0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371908; c=relaxed/simple;
	bh=FzWFaLSWQVLYtMu05hHXWbQ/jdTrGuq2XzGaa6r5+UY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ikRazxuE6XJrXsofZhAGZ3D0gZNuuuDo1RYxTZ/tFKKk0+FOOyKHQj+j1sxSdziFtHkt1O4oYNwskAyBesoPtjZWpbQksi3xp0PSfM+FfqfHNti4LK45PskCQPv/Bb6a71FhJM5fzpJ5xm2yHucOAICVcTdMThDJlMY96TTaec8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Drh6zXFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Drh6zXFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390E7C32782;
	Fri, 23 Aug 2024 00:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371908;
	bh=FzWFaLSWQVLYtMu05hHXWbQ/jdTrGuq2XzGaa6r5+UY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Drh6zXFprMfuUFUJmJrd1z7JojefRsVjcWTuKvApJj4+mfIfX0gzvZYhiayRpKOgg
	 TD+Gzm/2od+mSkkZpSsq73xUNKL6Qx6FpB196nZmjEE0M7hsRL5APGTt9bMeWkKOP7
	 bxR2hFpK2+OIEgoL7y3xw9j2WU8Mq8SD0VakN3cIpIlX49d9Evc6QYNWI6sK/kUa1L
	 dn/qb23PNvv5P4D6fNyGGvELn5A/c1WMZ2eXlsJmlmZbQn1YYRcelx7LNXilDDixhJ
	 krVhkPEKDwEZqguuoHbzHyxUz0Gs0e+rXb4hljAvJAB4qMbd/gcuFW+Ks6bGdxtw9U
	 WKn5aGef++MUQ==
Date: Thu, 22 Aug 2024 17:11:47 -0700
Subject: [PATCH 11/12] xfs: factor out rtbitmap/summary initialization helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086208.58604.13633887639855830783.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
References: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
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

Add helpers to libxfs that can be shared by growfs and mkfs for
initializing the rtbitmap and summary, and by passing the optional data
pointer also by repair for rebuilding them.  This will become even more
useful when the rtgroups feature adds a metadata header to each block,
which means even more shared code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor documentation and data advance tweaks]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |  126 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h |    3 +
 fs/xfs/xfs_rtalloc.c         |  121 +---------------------------------------
 3 files changed, 133 insertions(+), 117 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 02d6668d860fd..715d2c54ce029 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -13,6 +13,8 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
@@ -1255,3 +1257,127 @@ xfs_rtbitmap_unlock_shared(
 	if (rbmlock_flags & XFS_RBMLOCK_BITMAP)
 		xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 }
+
+static int
+xfs_rtfile_alloc_blocks(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	xfs_filblks_t		count_fsb,
+	struct xfs_bmbt_irec	*map)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			nmap = 1;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtalloc,
+			XFS_GROWFSRT_SPACE_RES(mp, count_fsb), 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
+			XFS_BMAPI_METADATA, 0, map, &nmap);
+	if (error)
+		goto out_trans_cancel;
+
+	return xfs_trans_commit(tp);
+
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+/* Get a buffer for the block. */
+static int
+xfs_rtfile_initialize_block(
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		fsbno,
+	void			*data)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	struct xfs_buf		*bp;
+	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
+	enum xfs_blft		buf_type;
+	int			error;
+
+	if (ip == mp->m_rsumip)
+		buf_type = XFS_BLFT_RTSUMMARY_BUF;
+	else
+		buf_type = XFS_BLFT_RTBITMAP_BUF;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero, 0, 0, 0, &tp);
+	if (error)
+		return error;
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(mp, fsbno), mp->m_bsize, 0, &bp);
+	if (error) {
+		xfs_trans_cancel(tp);
+		return error;
+	}
+
+	xfs_trans_buf_set_type(tp, bp, buf_type);
+	bp->b_ops = &xfs_rtbuf_ops;
+	if (data)
+		memcpy(bp->b_addr, data, copylen);
+	else
+		memset(bp->b_addr, 0, copylen);
+	xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
+	return xfs_trans_commit(tp);
+}
+
+/*
+ * Allocate space to the bitmap or summary file, and zero it, for growfs.
+ * @data must be a contiguous buffer large enough to fill all blocks in the
+ * file; or NULL to initialize the contents to zeroes.
+ */
+int
+xfs_rtfile_initialize_blocks(
+	struct xfs_inode	*ip,		/* inode (bitmap/summary) */
+	xfs_fileoff_t		offset_fsb,	/* offset to start from */
+	xfs_fileoff_t		end_fsb,	/* offset to allocate to */
+	void			*data)		/* data to fill the blocks */
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
+
+	while (offset_fsb < end_fsb) {
+		struct xfs_bmbt_irec	map;
+		xfs_filblks_t		i;
+		int			error;
+
+		error = xfs_rtfile_alloc_blocks(ip, offset_fsb,
+				end_fsb - offset_fsb, &map);
+		if (error)
+			return error;
+
+		/*
+		 * Now we need to clear the allocated blocks.
+		 *
+		 * Do this one block per transaction, to keep it simple.
+		 */
+		for (i = 0; i < map.br_blockcount; i++) {
+			error = xfs_rtfile_initialize_block(ip,
+					map.br_startblock + i, data);
+			if (error)
+				return error;
+			if (data)
+				data += copylen;
+		}
+
+		offset_fsb = map.br_startoff + map.br_blockcount;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index e87e2099cff5e..0d5ab5e2cb6a3 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -343,6 +343,9 @@ xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 
+int xfs_rtfile_initialize_blocks(struct xfs_inode *ip,
+		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb, void *data);
+
 void xfs_rtbitmap_lock(struct xfs_trans *tp, struct xfs_mount *mp);
 void xfs_rtbitmap_unlock(struct xfs_mount *mp);
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 5bead4db164e9..52ed8448d9925 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -643,121 +643,6 @@ xfs_rtallocate_extent_size(
 	return -ENOSPC;
 }
 
-/*
- * Allocate space to the bitmap or summary file, and zero it, for growfs.
- */
-STATIC int
-xfs_growfs_rt_alloc(
-	struct xfs_mount	*mp,		/* file system mount point */
-	xfs_extlen_t		oblocks,	/* old count of blocks */
-	xfs_extlen_t		nblocks,	/* new count of blocks */
-	struct xfs_inode	*ip)		/* inode (bitmap/summary) */
-{
-	xfs_fileoff_t		bno;		/* block number in file */
-	struct xfs_buf		*bp;	/* temporary buffer for zeroing */
-	xfs_daddr_t		d;		/* disk block address */
-	int			error;		/* error return value */
-	xfs_fsblock_t		fsbno;		/* filesystem block for bno */
-	struct xfs_bmbt_irec	map;		/* block map output */
-	int			nmap;		/* number of block maps */
-	int			resblks;	/* space reservation */
-	enum xfs_blft		buf_type;
-	struct xfs_trans	*tp;
-
-	if (ip == mp->m_rsumip)
-		buf_type = XFS_BLFT_RTSUMMARY_BUF;
-	else
-		buf_type = XFS_BLFT_RTBITMAP_BUF;
-
-	/*
-	 * Allocate space to the file, as necessary.
-	 */
-	while (oblocks < nblocks) {
-		resblks = XFS_GROWFSRT_SPACE_RES(mp, nblocks - oblocks);
-		/*
-		 * Reserve space & log for one extent added to the file.
-		 */
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtalloc, resblks,
-				0, 0, &tp);
-		if (error)
-			return error;
-		/*
-		 * Lock the inode.
-		 */
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
-		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error)
-			goto out_trans_cancel;
-
-		/*
-		 * Allocate blocks to the bitmap file.
-		 */
-		nmap = 1;
-		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
-					XFS_BMAPI_METADATA, 0, &map, &nmap);
-		if (error)
-			goto out_trans_cancel;
-		/*
-		 * Free any blocks freed up in the transaction, then commit.
-		 */
-		error = xfs_trans_commit(tp);
-		if (error)
-			return error;
-		/*
-		 * Now we need to clear the allocated blocks.
-		 * Do this one block per transaction, to keep it simple.
-		 */
-		for (bno = map.br_startoff, fsbno = map.br_startblock;
-		     bno < map.br_startoff + map.br_blockcount;
-		     bno++, fsbno++) {
-			/*
-			 * Reserve log for one block zeroing.
-			 */
-			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero,
-					0, 0, 0, &tp);
-			if (error)
-				return error;
-			/*
-			 * Lock the bitmap inode.
-			 */
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-			/*
-			 * Get a buffer for the block.
-			 */
-			d = XFS_FSB_TO_DADDR(mp, fsbno);
-			error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-					mp->m_bsize, 0, &bp);
-			if (error)
-				goto out_trans_cancel;
-
-			xfs_trans_buf_set_type(tp, bp, buf_type);
-			bp->b_ops = &xfs_rtbuf_ops;
-			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
-			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
-			/*
-			 * Commit the transaction.
-			 */
-			error = xfs_trans_commit(tp);
-			if (error)
-				return error;
-		}
-		/*
-		 * Go on to the next extent, if any.
-		 */
-		oblocks = map.br_startoff + map.br_blockcount;
-	}
-
-	return 0;
-
-out_trans_cancel:
-	xfs_trans_cancel(tp);
-	return error;
-}
-
 static int
 xfs_alloc_rsum_cache(
 	struct xfs_mount	*mp,
@@ -1064,10 +949,12 @@ xfs_growfs_rt(
 	/*
 	 * Allocate space to the bitmap and summary files, as necessary.
 	 */
-	error = xfs_growfs_rt_alloc(mp, rbmblocks, nrbmblocks, mp->m_rbmip);
+	error = xfs_rtfile_initialize_blocks(mp->m_rbmip, rbmblocks,
+			nrbmblocks, NULL);
 	if (error)
 		goto out_unlock;
-	error = xfs_growfs_rt_alloc(mp, rsumblocks, nrsumblocks, mp->m_rsumip);
+	error = xfs_rtfile_initialize_blocks(mp->m_rsumip, rsumblocks,
+			nrsumblocks, NULL);
 	if (error)
 		goto out_unlock;
 

