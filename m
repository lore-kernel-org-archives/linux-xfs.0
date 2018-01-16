Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56338 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750823AbeAPXbB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 18:31:01 -0500
Date: Tue, 16 Jan 2018 15:30:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 3/5] xfs: directory scrubber must walk through data block
 to offset
Message-ID: <20180116233045.GF5602@magnolia>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
 <151579465813.8694.2293343683195960907.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151579465813.8694.2293343683195960907.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_scrub_dir_rec, we must walk through the directory block entries
to arrive at the offset given by the hash structure.  If we blindly
trust the hash address, we can end up midway into a directory entry and
stray outside the block.  Found by lastbit fuzzing lents[3].address in
xfs/390 with KASAN enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: refactor endp users to call the helper
v2: improve defensive pointer checking (endp theoretically can be null)
---
 fs/xfs/libxfs/xfs_dir2.h      |    2 ++
 fs/xfs/libxfs/xfs_dir2_data.c |   43 +++++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_dir2_sf.c   |    4 +---
 fs/xfs/scrub/dir.c            |   38 +++++++++++++++++++++++++++++-------
 fs/xfs/xfs_dir2_readdir.c     |    4 +---
 5 files changed, 58 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 1a8f2cf..388d67c 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -340,5 +340,7 @@ xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
 #define XFS_READDIR_BUFSIZE	(32768)
 
 unsigned char xfs_dir3_get_dtype(struct xfs_mount *mp, uint8_t filetype);
+void *xfs_dir3_data_endp(struct xfs_da_geometry *geo,
+		struct xfs_dir2_data_hdr *hdr);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 853d9ab..a1e30c7 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -89,7 +89,6 @@ __xfs_dir3_data_check(
 	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
 		btp = xfs_dir2_block_tail_p(geo, hdr);
 		lep = xfs_dir2_block_leaf_p(btp);
-		endp = (char *)lep;
 
 		/*
 		 * The number of leaf entries is limited by the size of the
@@ -104,11 +103,13 @@ __xfs_dir3_data_check(
 		break;
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
-		endp = (char *)hdr + geo->blksize;
 		break;
 	default:
 		return __this_address;
 	}
+	endp = xfs_dir3_data_endp(geo, hdr);
+	if (!endp)
+		return __this_address;
 
 	/*
 	 * Account for zero bestfree entries.
@@ -546,7 +547,6 @@ xfs_dir2_data_freescan_int(
 	struct xfs_dir2_data_hdr *hdr,
 	int			*loghead)
 {
-	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* active data entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused data entry */
 	struct xfs_dir2_data_free *bf;
@@ -568,12 +568,7 @@ xfs_dir2_data_freescan_int(
 	 * Set up pointers.
 	 */
 	p = (char *)ops->data_entry_p(hdr);
-	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
-	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
-		btp = xfs_dir2_block_tail_p(geo, hdr);
-		endp = (char *)xfs_dir2_block_leaf_p(btp);
-	} else
-		endp = (char *)hdr + geo->blksize;
+	endp = xfs_dir3_data_endp(geo, hdr);
 	/*
 	 * Loop over the block's entries.
 	 */
@@ -786,17 +781,9 @@ xfs_dir2_data_make_free(
 	/*
 	 * Figure out where the end of the data area is.
 	 */
-	if (hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
-	    hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC))
-		endptr = (char *)hdr + args->geo->blksize;
-	else {
-		xfs_dir2_block_tail_t	*btp;	/* block tail */
+	endptr = xfs_dir3_data_endp(args->geo, hdr);
+	ASSERT(endptr != NULL);
 
-		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
-			hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
-		btp = xfs_dir2_block_tail_p(args->geo, hdr);
-		endptr = (char *)xfs_dir2_block_leaf_p(btp);
-	}
 	/*
 	 * If this isn't the start of the block, then back up to
 	 * the previous entry and see if it's free.
@@ -1098,3 +1085,21 @@ xfs_dir2_data_use_free(
 	}
 	*needscanp = needscan;
 }
+
+/* Find the end of the entry data in a data/block format dir block. */
+void *
+xfs_dir3_data_endp(
+	struct xfs_da_geometry		*geo,
+	struct xfs_dir2_data_hdr	*hdr)
+{
+	switch (hdr->magic) {
+	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
+	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
+		return xfs_dir2_block_leaf_p(xfs_dir2_block_tail_p(geo, hdr));
+	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
+	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
+		return (char *)hdr + geo->blksize;
+	default:
+		return NULL;
+	}
+}
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 8500fa2..0c75a7f 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -156,7 +156,6 @@ xfs_dir2_block_to_sf(
 	xfs_dir2_sf_hdr_t	*sfhp)		/* shortform directory hdr */
 {
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
-	xfs_dir2_block_tail_t	*btp;		/* block tail pointer */
 	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	xfs_dir2_data_unused_t	*dup;		/* unused data pointer */
@@ -192,9 +191,8 @@ xfs_dir2_block_to_sf(
 	/*
 	 * Set up to loop over the block's entries.
 	 */
-	btp = xfs_dir2_block_tail_p(args->geo, hdr);
 	ptr = (char *)dp->d_ops->data_entry_p(hdr);
-	endptr = (char *)xfs_dir2_block_leaf_p(btp);
+	endptr = xfs_dir3_data_endp(args->geo, hdr);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	/*
 	 * Loop over the active and unused entries.
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index f5a0d17..50b6a26 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -200,6 +200,7 @@ xfs_scrub_dir_rec(
 	struct xfs_inode		*dp = ds->dargs.dp;
 	struct xfs_dir2_data_entry	*dent;
 	struct xfs_buf			*bp;
+	char				*p, *endp;
 	xfs_ino_t			ino;
 	xfs_dablk_t			rec_bno;
 	xfs_dir2_db_t			db;
@@ -239,8 +240,35 @@ xfs_scrub_dir_rec(
 	}
 	xfs_scrub_buffer_recheck(ds->sc, bp);
 
-	/* Retrieve the entry, sanity check it, and compare hashes. */
 	dent = (struct xfs_dir2_data_entry *)(((char *)bp->b_addr) + off);
+
+	/* Make sure we got a real directory entry. */
+	p = (char *)mp->m_dir_inode_ops->data_entry_p(bp->b_addr);
+	endp = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
+	if (!endp) {
+		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out_relse;
+	}
+	while (p < endp) {
+		struct xfs_dir2_data_entry	*dep;
+		struct xfs_dir2_data_unused	*dup;
+
+		dup = (struct xfs_dir2_data_unused *)p;
+		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			p += be16_to_cpu(dup->length);
+			continue;
+		}
+		dep = (struct xfs_dir2_data_entry *)p;
+		if (dep == dent)
+			break;
+		p += mp->m_dir_inode_ops->data_entsize(dep->namelen);
+	}
+	if (p >= endp) {
+		xfs_scrub_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out_relse;
+	}
+
+	/* Retrieve the entry, sanity check it, and compare hashes. */
 	ino = be64_to_cpu(dent->inumber);
 	hash = be32_to_cpu(ent->hashval);
 	tag = be16_to_cpup(dp->d_ops->data_entry_tag_p(dent));
@@ -363,13 +391,7 @@ xfs_scrub_directory_data_bestfree(
 
 	/* Make sure the bestfrees are actually the best free spaces. */
 	ptr = (char *)d_ops->data_entry_p(bp->b_addr);
-	if (is_block) {
-		struct xfs_dir2_block_tail	*btp;
-
-		btp = xfs_dir2_block_tail_p(mp->m_dir_geo, bp->b_addr);
-		endptr = (char *)xfs_dir2_block_leaf_p(btp);
-	} else
-		endptr = (char *)bp->b_addr + BBTOB(bp->b_length);
+	endptr = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
 
 	/* Iterate the entries, stopping when we hit or go past the end. */
 	while (ptr < endptr) {
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 0c58918..b6ae359 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -152,7 +152,6 @@ xfs_dir2_block_getdents(
 	struct xfs_inode	*dp = args->dp;	/* incore directory inode */
 	xfs_dir2_data_hdr_t	*hdr;		/* block header */
 	struct xfs_buf		*bp;		/* buffer for block */
-	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* block data entry */
 	xfs_dir2_data_unused_t	*dup;		/* block unused entry */
 	char			*endptr;	/* end of the data entries */
@@ -185,9 +184,8 @@ xfs_dir2_block_getdents(
 	/*
 	 * Set up values for the loop.
 	 */
-	btp = xfs_dir2_block_tail_p(geo, hdr);
 	ptr = (char *)dp->d_ops->data_entry_p(hdr);
-	endptr = (char *)xfs_dir2_block_leaf_p(btp);
+	endptr = xfs_dir3_data_endp(geo, hdr);
 
 	/*
 	 * Loop over the data portion of the block.
