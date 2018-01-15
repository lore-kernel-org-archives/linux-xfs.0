Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60174 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbeAOUFT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jan 2018 15:05:19 -0500
Date: Mon, 15 Jan 2018 12:04:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 3/5] xfs: directory scrubber must walk through data block
 to offset
Message-ID: <20180115200447.GD5602@magnolia>
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
Cc: Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_scrub_dir_rec, we must walk through the directory block entries
to arrive at the offset given by the hash structure.  If we blindly
trust the hash address, we can end up midway into a directory entry and
stray outside the block.  Found by lastbit fuzzing lents[3].address in
xfs/390 with KASAN enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
v2: improve defensive pointer checking (endp theoretically can be null)
---
 fs/xfs/libxfs/xfs_dir2.h      |    1 +
 fs/xfs/libxfs/xfs_dir2_data.c |   19 +++++++++++++++++++
 fs/xfs/scrub/dir.c            |   30 +++++++++++++++++++++++++++++-
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 1a8f2cf..2c77195 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -340,5 +340,6 @@ xfs_dir2_leaf_tail_p(struct xfs_da_geometry *geo, struct xfs_dir2_leaf *lp)
 #define XFS_READDIR_BUFSIZE	(32768)
 
 unsigned char xfs_dir3_get_dtype(struct xfs_mount *mp, uint8_t filetype);
+void *xfs_dir3_data_endp(struct xfs_mount *mp, struct xfs_dir2_data_hdr *hdr);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 853d9ab..b87db03 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -1098,3 +1098,22 @@ xfs_dir2_data_use_free(
 	}
 	*needscanp = needscan;
 }
+
+/* Find the end of the entry data in a data/block format dir block. */
+void *
+xfs_dir3_data_endp(
+	struct xfs_mount		*mp,
+	struct xfs_dir2_data_hdr	*hdr)
+{
+	switch (hdr->magic) {
+	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
+	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
+		return xfs_dir2_block_leaf_p(
+				xfs_dir2_block_tail_p(mp->m_dir_geo, hdr));
+	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
+	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
+		return (char *)hdr + mp->m_dir_geo->blksize;
+	default:
+		return NULL;
+	}
+}
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index f5a0d17..106813f 100644
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
+	endp = xfs_dir3_data_endp(mp, bp->b_addr);
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
