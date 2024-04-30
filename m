Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE4217592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481386; cv=none; b=ojPFEh9ptiKWg9exIhy5ROXv3jFMyL6voaHt4722FGmP/0RTyih/gNwqk3a8HKcM8xZCpgwoL9+dPNoMiGSrSUBP8+2Xiu4POtl8Z5don6zmTjojp+XlmXqOLY616csnWz3EwRGXAhVesX/YB88LmIYyZgfCy+j68M4gARTfyxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481386; c=relaxed/simple;
	bh=TC5TkAOofh1IkDr7pP/Aa39/OyAv6TzQ8lp0q3H8wm0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UuYMOPzznM7mHPeDzE5Hzr7cAB2yfFDttcakbBLi9AlojmNE7taBpC/jSN7J8Vyche8+1UphZCAVope9KAff+ONjPlt2gTna9+6B2Zy4eTCdc5HjLae8N1IkcDL/RhSLBkI6+7e2gsXW5uLMCBvgxbRNvGjM9g5iBDmPPN+gREs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J8Go+qpN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J8Go+qpN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aYhOywS1kMSN/f9+6kUT/enpURKtzoSQL+SDjUldOTg=; b=J8Go+qpNEXppq7dgr3f+mnFTDk
	iRtgFM8q6Wi1/biK7aXZc9b16MW7i3FNOwqzzTloIMf8oUaL5mhlyNyclqMgpEIcLz9b4KYNqwndi
	YcMvNqYVcRHpoSwVfOGtzYiB85IzGoejFD7J8GzryyTCyU4W470cjmRpDgwcpVBaBeathUVBMr3qU
	QlRkwMsUCyHDkWIAnLC6CRTrFly20MWDcXz4jy1jo2Mp64aF4TgkYH/mwJuncxTEQytBdlop2+P9r
	6SvDw2/ChXl/6d2J7siNBnKM5+OB+WDh3yW2gvXdSCEHFaO+KR3pGU59fNbFNrpu9CawEGsb5I4u8
	U8dL7kyw==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvY-00000006Nit-2sSP;
	Tue, 30 Apr 2024 12:49:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 05/16] xfs: move the "does it fit" check into xfs_dir2_block_to_sf
Date: Tue, 30 Apr 2024 14:49:15 +0200
Message-Id: <20240430124926.1775355-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430124926.1775355-1-hch@lst.de>
References: <20240430124926.1775355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All callers of xfs_dir2_block_to_sf first check if the block format
directory would actually fit into the short format.  Move this code
into xfs_dir2_block_to_sf and rename the function to
xfs_dir2_try_block_to_sf.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_block.c | 24 ++----------------------
 fs/xfs/libxfs/xfs_dir2_priv.h  |  5 +----
 fs/xfs/libxfs/xfs_dir2_sf.c    | 25 +++++++++++++++++--------
 fs/xfs/libxfs/xfs_exchmaps.c   |  8 +-------
 4 files changed, 21 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 20d4e86e14ab08..378d3aefdd9ced 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -795,8 +795,6 @@ xfs_dir2_block_removename(
 	int			error;		/* error return value */
 	int			needlog;	/* need to log block header */
 	int			needscan;	/* need to fixup bestfree */
-	xfs_dir2_sf_hdr_t	sfh;		/* shortform header */
-	int			size;		/* shortform size */
 	xfs_trans_t		*tp;		/* transaction pointer */
 
 	trace_xfs_dir2_block_removename(args);
@@ -845,17 +843,8 @@ xfs_dir2_block_removename(
 	if (needlog)
 		xfs_dir2_data_log_header(args, bp);
 	xfs_dir3_data_check(dp, bp);
-	/*
-	 * See if the size as a shortform is good enough.
-	 */
-	size = xfs_dir2_block_sfsize(dp, hdr, &sfh);
-	if (size > xfs_inode_data_fork_size(dp))
-		return 0;
 
-	/*
-	 * If it works, do the conversion.
-	 */
-	return xfs_dir2_block_to_sf(args, bp, size, &sfh);
+	return xfs_dir2_try_block_to_sf(args, bp);
 }
 
 /*
@@ -944,7 +933,6 @@ xfs_dir2_leaf_to_block(
 	xfs_mount_t		*mp;		/* file system mount point */
 	int			needlog;	/* need to log data header */
 	int			needscan;	/* need to scan for bestfree */
-	xfs_dir2_sf_hdr_t	sfh;		/* shortform header */
 	int			size;		/* bytes used */
 	__be16			*tagp;		/* end of entry (tag) */
 	int			to;		/* block/leaf to index */
@@ -1058,15 +1046,7 @@ xfs_dir2_leaf_to_block(
 	error = xfs_da_shrink_inode(args, args->geo->leafblk, lbp);
 	if (error)
 		return error;
-
-	/*
-	 * Now see if the resulting block can be shrunken to shortform.
-	 */
-	size = xfs_dir2_block_sfsize(dp, hdr, &sfh);
-	if (size > xfs_inode_data_fork_size(dp))
-		return 0;
-
-	return xfs_dir2_block_to_sf(args, dbp, size, &sfh);
+	return xfs_dir2_try_block_to_sf(args, dbp);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 3befb32509fa44..1e4401f9ec936e 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -167,10 +167,7 @@ uint8_t xfs_dir2_sf_get_ftype(struct xfs_mount *mp,
 		struct xfs_dir2_sf_entry *sfep);
 struct xfs_dir2_sf_entry *xfs_dir2_sf_nextentry(struct xfs_mount *mp,
 		struct xfs_dir2_sf_hdr *hdr, struct xfs_dir2_sf_entry *sfep);
-extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
-		struct xfs_dir2_data_hdr *block, struct xfs_dir2_sf_hdr *sfhp);
-extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
-		int size, xfs_dir2_sf_hdr_t *sfhp);
+int xfs_dir2_try_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp);
 extern int xfs_dir2_sf_addname(struct xfs_da_args *args);
 extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
 extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 1cd5228e1ce6af..fad3fd28175368 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -163,7 +163,7 @@ xfs_dir2_sf_put_ftype(
  * space currently present in the inode.  If it won't fit, the output
  * size is too big (but not accurate).
  */
-int						/* size for sf form */
+static int					/* size for sf form */
 xfs_dir2_block_sfsize(
 	xfs_inode_t		*dp,		/* incore inode pointer */
 	xfs_dir2_data_hdr_t	*hdr,		/* block directory data */
@@ -250,15 +250,12 @@ xfs_dir2_block_sfsize(
 }
 
 /*
- * Convert a block format directory to shortform.
- * Caller has already checked that it will fit, and built us a header.
+ * Try to convert a block format directory to shortform.
  */
 int						/* error */
-xfs_dir2_block_to_sf(
+xfs_dir2_try_block_to_sf(
 	struct xfs_da_args	*args,		/* operation arguments */
-	struct xfs_buf		*bp,
-	int			size,		/* shortform directory size */
-	struct xfs_dir2_sf_hdr	*sfhp)		/* shortform directory hdr */
+	struct xfs_buf		*bp)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -267,8 +264,20 @@ xfs_dir2_block_to_sf(
 	struct xfs_dir2_sf_entry *sfep;		/* shortform entry */
 	struct xfs_dir2_sf_hdr	*sfp;		/* shortform directory header */
 	unsigned int		offset = args->geo->data_entry_offset;
+	struct xfs_dir2_sf_hdr	sfh;
+	int			size;
 	unsigned int		end;
 
+	/*
+	 * See if it would fit into the shortform format.  If not we are done.
+	 */
+	size = xfs_dir2_block_sfsize(dp, bp->b_addr, &sfh);
+	if (size > xfs_inode_data_fork_size(dp))
+		return 0;
+
+	/*
+	 * It would fit into the shortform formt, do the conversion now.
+	 */
 	trace_xfs_dir2_block_to_sf(args);
 
 	/*
@@ -277,7 +286,7 @@ xfs_dir2_block_to_sf(
 	 * the block and copy the formatted data into the inode literal area.
 	 */
 	sfp = kmalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | __GFP_NOFAIL);
-	memcpy(sfp, sfhp, xfs_dir2_sf_hdr_size(sfhp->i8count));
+	memcpy(sfp, &sfh, xfs_dir2_sf_hdr_size(sfh.i8count));
 
 	/*
 	 * Loop over the active and unused entries.  Stop when we reach the
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 2021396651de27..bca6b6b0985464 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -463,9 +463,7 @@ xfs_exchmaps_dir_to_sf(
 		.trans		= tp,
 		.owner		= xmi->xmi_ip2->i_ino,
 	};
-	struct xfs_dir2_sf_hdr	sfh;
 	struct xfs_buf		*bp;
-	int			size;
 	int			error = 0;
 
 	if (xfs_dir2_format(&args, &error) != XFS_DIR2_FMT_BLOCK)
@@ -475,11 +473,7 @@ xfs_exchmaps_dir_to_sf(
 	if (error)
 		return error;
 
-	size = xfs_dir2_block_sfsize(xmi->xmi_ip2, bp->b_addr, &sfh);
-	if (size > xfs_inode_data_fork_size(xmi->xmi_ip2))
-		return 0;
-
-	return xfs_dir2_block_to_sf(&args, bp, size, &sfh);
+	return xfs_dir2_try_block_to_sf(&args, bp);
 }
 
 /* Convert inode2's remote symlink target back to shortform, if possible. */
-- 
2.39.2

