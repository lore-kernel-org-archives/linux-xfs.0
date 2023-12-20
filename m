Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4B71D528
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 06:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eSc++Ogj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IGqNWpRcIMrhu3RKy4LJgvj6T5EEtFtO18/EHgHXgH0=; b=eSc++OgjCDyiQFcgIQtU5pSJJV
	HTRbzVYk5KpLMGlASansV8iOE8q+Q8wLyOuejEAfRzW61AzfXmsIKSJ5dTmaP7N/8QefJu/QIw2VQ
	2vjHT7ZNS+NqaPenN//o3ljrIDImby5H6kP+sUaHRa+x88RhVqvX1V+6ZOhqRIrWg3skMvrm9jdfj
	I1AX88iIWFReSg0Klan/gAvzCjVO+8io6m93TyicMPPovdFnjSKElvetTARf9IVUbe1Ti63ECrFoG
	zUew1C6hO6vv+M/eetzxtWVWpCpqFRjdCjf4BC0fiWewDcvqtCZRdxNcbdpJbARvHfPwkwdnZ5qN1
	cBbvk1IA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rFqAd-00GJOO-0c;
	Wed, 20 Dec 2023 06:35:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/9] xfs: return if_data from xfs_idata_realloc
Date: Wed, 20 Dec 2023 07:34:56 +0100
Message-Id: <20231220063503.1005804-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231220063503.1005804-1-hch@lst.de>
References: <20231220063503.1005804-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Many of the xfs_idata_realloc callers need to set a local pointer to the
just reallocated if_data memory.  Return the pointer to simplify them a
bit and use the opportunity to re-use krealloc for freeing if_data if the
size hits 0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |  7 +++----
 fs/xfs/libxfs/xfs_dir2_sf.c    | 25 ++++++++++---------------
 fs/xfs/libxfs/xfs_inode_fork.c | 20 ++++++++------------
 fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
 4 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 3e5377fd498471..2e3334ac32287a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -690,8 +690,8 @@ xfs_attr_shortform_create(
 	ASSERT(ifp->if_bytes == 0);
 	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS)
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
-	xfs_idata_realloc(dp, sizeof(*hdr), XFS_ATTR_FORK);
-	hdr = ifp->if_data;
+
+	hdr = xfs_idata_realloc(dp, sizeof(*hdr), XFS_ATTR_FORK);
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->totsize = cpu_to_be16(sizeof(*hdr));
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
@@ -767,8 +767,7 @@ xfs_attr_shortform_add(
 
 	offset = (char *)sfe - (char *)sf;
 	size = xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
-	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
-	sf = ifp->if_data;
+	sf = xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
 	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
 
 	sfe->namelen = args->namelen;
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 0b63138d2b9f0e..e1f83fc7b6ad11 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -466,12 +466,11 @@ xfs_dir2_sf_addname_easy(
 	/*
 	 * Grow the in-inode space.
 	 */
-	xfs_idata_realloc(dp, xfs_dir2_sf_entsize(mp, sfp, args->namelen),
+	sfp = xfs_idata_realloc(dp, xfs_dir2_sf_entsize(mp, sfp, args->namelen),
 			  XFS_DATA_FORK);
 	/*
 	 * Need to set up again due to realloc of the inode data.
 	 */
-	sfp = dp->i_df.if_data;
 	sfep = (xfs_dir2_sf_entry_t *)((char *)sfp + byteoff);
 	/*
 	 * Fill in the new entry.
@@ -551,11 +550,8 @@ xfs_dir2_sf_addname_hard(
 	 * the data.
 	 */
 	xfs_idata_realloc(dp, -old_isize, XFS_DATA_FORK);
-	xfs_idata_realloc(dp, new_isize, XFS_DATA_FORK);
-	/*
-	 * Reset the pointer since the buffer was reallocated.
-	 */
-	sfp = dp->i_df.if_data;
+	sfp = xfs_idata_realloc(dp, new_isize, XFS_DATA_FORK);
+
 	/*
 	 * Copy the first part of the directory, including the header.
 	 */
@@ -820,15 +816,13 @@ xfs_dir2_sf_create(
 	ASSERT(dp->i_df.if_bytes == 0);
 	i8count = pino > XFS_DIR2_MAX_SHORT_INUM;
 	size = xfs_dir2_sf_hdr_size(i8count);
+
 	/*
-	 * Make a buffer for the data.
-	 */
-	xfs_idata_realloc(dp, size, XFS_DATA_FORK);
-	/*
-	 * Fill in the header,
+	 * Make a buffer for the data and fill in the header.
 	 */
-	sfp = dp->i_df.if_data;
+	sfp = xfs_idata_realloc(dp, size, XFS_DATA_FORK);
 	sfp->i8count = i8count;
+
 	/*
 	 * Now can put in the inode number, since i8count is set.
 	 */
@@ -976,11 +970,12 @@ xfs_dir2_sf_removename(
 	 */
 	sfp->count--;
 	dp->i_disk_size = newsize;
+
 	/*
 	 * Reallocate, making it smaller.
 	 */
-	xfs_idata_realloc(dp, newsize - oldsize, XFS_DATA_FORK);
-	sfp = dp->i_df.if_data;
+	sfp = xfs_idata_realloc(dp, newsize - oldsize, XFS_DATA_FORK);
+
 	/*
 	 * Are we changing inode number size?
 	 */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index d23910e503a1ae..d8405a8d3c14f9 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -496,7 +496,7 @@ xfs_iroot_realloc(
  * byte_diff -- the change in the number of bytes, positive or negative,
  *	 requested for the if_data array.
  */
-void
+void *
 xfs_idata_realloc(
 	struct xfs_inode	*ip,
 	int64_t			byte_diff,
@@ -508,19 +508,15 @@ xfs_idata_realloc(
 	ASSERT(new_size >= 0);
 	ASSERT(new_size <= xfs_inode_fork_size(ip, whichfork));
 
-	if (byte_diff == 0)
-		return;
-
-	if (new_size == 0) {
-		kmem_free(ifp->if_data);
-		ifp->if_data = NULL;
-		ifp->if_bytes = 0;
-		return;
+	if (byte_diff) {
+		ifp->if_data = krealloc(ifp->if_data, new_size,
+					GFP_NOFS | __GFP_NOFAIL);
+		if (new_size == 0)
+			ifp->if_data = NULL;
+		ifp->if_bytes = new_size;
 	}
 
-	ifp->if_data = krealloc(ifp->if_data, new_size,
-			GFP_NOFS | __GFP_NOFAIL);
-	ifp->if_bytes = new_size;
+	return ifp->if_data;
 }
 
 /* Free all memory and reset a fork back to its initial state. */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7edcf0e8cd5388..96303249d28ab4 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -168,7 +168,7 @@ int		xfs_iformat_attr_fork(struct xfs_inode *, struct xfs_dinode *);
 void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 				struct xfs_inode_log_item *, int);
 void		xfs_idestroy_fork(struct xfs_ifork *ifp);
-void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
+void *		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
 				int whichfork);
 void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
-- 
2.39.2

