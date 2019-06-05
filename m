Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59760 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbfFETQg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:16:36 -0400
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbOg-0002Fw-3B
        for linux-xfs@vger.kernel.org; Wed, 05 Jun 2019 19:16:36 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/24] xfs: add struct xfs_mount pointer to struct xfs_buf
Date: Wed,  5 Jun 2019 21:15:11 +0200
Message-Id: <20190605191511.32695-25-hch@lst.de>
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We need to derive the mount pointer from a buffer in a lot of place.
Add a direct pointer to short cut the pointer chasing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 .../xfs-self-describing-metadata.txt          |  8 ++---
 fs/xfs/libxfs/xfs_alloc.c                     | 12 +++----
 fs/xfs/libxfs/xfs_alloc_btree.c               |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                 | 12 +++----
 fs/xfs/libxfs/xfs_attr_remote.c               |  4 +--
 fs/xfs/libxfs/xfs_bmap_btree.c                |  2 +-
 fs/xfs/libxfs/xfs_btree.c                     | 16 +++++-----
 fs/xfs/libxfs/xfs_da_btree.c                  |  6 ++--
 fs/xfs/libxfs/xfs_dir2_block.c                |  6 ++--
 fs/xfs/libxfs/xfs_dir2_data.c                 |  9 +++---
 fs/xfs/libxfs/xfs_dir2_leaf.c                 |  6 ++--
 fs/xfs/libxfs/xfs_dir2_node.c                 |  6 ++--
 fs/xfs/libxfs/xfs_dquot_buf.c                 |  8 ++---
 fs/xfs/libxfs/xfs_ialloc.c                    |  6 ++--
 fs/xfs/libxfs/xfs_ialloc_btree.c              |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c                 |  2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c            |  2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c                |  2 +-
 fs/xfs/libxfs/xfs_sb.c                        |  4 +--
 fs/xfs/libxfs/xfs_symlink_remote.c            |  6 ++--
 fs/xfs/xfs_attr_inactive.c                    |  2 +-
 fs/xfs/xfs_buf.c                              | 32 +++++++++----------
 fs/xfs/xfs_buf.h                              |  1 +
 fs/xfs/xfs_buf_item.c                         |  4 +--
 fs/xfs/xfs_error.c                            |  2 +-
 fs/xfs/xfs_log_recover.c                      | 11 +++----
 26 files changed, 85 insertions(+), 88 deletions(-)

diff --git a/Documentation/filesystems/xfs-self-describing-metadata.txt b/Documentation/filesystems/xfs-self-describing-metadata.txt
index 68604e67a495..8db0121d0980 100644
--- a/Documentation/filesystems/xfs-self-describing-metadata.txt
+++ b/Documentation/filesystems/xfs-self-describing-metadata.txt
@@ -222,7 +222,7 @@ static void
 xfs_foo_read_verify(
 	struct xfs_buf	*bp)
 {
-       struct xfs_mount *mp = bp->b_target->bt_mount;
+       struct xfs_mount *mp = bp->b_mount;
 
         if ((xfs_sb_version_hascrc(&mp->m_sb) &&
              !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
@@ -245,7 +245,7 @@ static bool
 xfs_foo_verify(
 	struct xfs_buf		*bp)
 {
-        struct xfs_mount	*mp = bp->b_target->bt_mount;
+        struct xfs_mount	*mp = bp->b_mount;
         struct xfs_ondisk_hdr	*hdr = bp->b_addr;
 
         if (hdr->magic != cpu_to_be32(XFS_FOO_MAGIC))
@@ -272,7 +272,7 @@ static bool
 xfs_foo_verify(
 	struct xfs_buf		*bp)
 {
-        struct xfs_mount	*mp = bp->b_target->bt_mount;
+        struct xfs_mount	*mp = bp->b_mount;
         struct xfs_ondisk_hdr	*hdr = bp->b_addr;
 
         if (hdr->magic == cpu_to_be32(XFS_FOO_CRC_MAGIC)) {
@@ -297,7 +297,7 @@ static void
 xfs_foo_write_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
 	if (!xfs_foo_verify(bp)) {
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a9ff3cf82cce..88f00beddee7 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -555,7 +555,7 @@ static xfs_failaddr_t
 xfs_agfl_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount *mp = bp->b_mount;
 	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
 	int		i;
 
@@ -596,7 +596,7 @@ static void
 xfs_agfl_read_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount *mp = bp->b_mount;
 	xfs_failaddr_t	fa;
 
 	/*
@@ -621,7 +621,7 @@ static void
 xfs_agfl_write_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	xfs_failaddr_t		fa;
 
@@ -2586,7 +2586,7 @@ static xfs_failaddr_t
 xfs_agf_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(bp);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
@@ -2644,7 +2644,7 @@ static void
 xfs_agf_read_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount *mp = bp->b_mount;
 	xfs_failaddr_t	fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
@@ -2661,7 +2661,7 @@ static void
 xfs_agf_write_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	xfs_failaddr_t		fa;
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 9fe949f6055e..9b2786ee4081 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -292,7 +292,7 @@ static xfs_failaddr_t
 xfs_allocbt_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
 	xfs_failaddr_t		fa;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 1f6e3965ff74..654a599a3754 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -240,7 +240,7 @@ xfs_attr3_leaf_verify(
 	struct xfs_buf			*bp)
 {
 	struct xfs_attr3_icleaf_hdr	ichdr;
-	struct xfs_mount		*mp = bp->b_target->bt_mount;
+	struct xfs_mount		*mp = bp->b_mount;
 	struct xfs_attr_leafblock	*leaf = bp->b_addr;
 	struct xfs_attr_leaf_entry	*entries;
 	uint32_t			end;	/* must be 32bit - see below */
@@ -313,7 +313,7 @@ static void
 xfs_attr3_leaf_write_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_attr3_leaf_hdr *hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
@@ -343,7 +343,7 @@ static void
 xfs_attr3_leaf_read_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
@@ -865,7 +865,7 @@ xfs_attr_shortform_allfit(
 	struct xfs_attr3_icleaf_hdr leafhdr;
 	int			bytes;
 	int			i;
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
@@ -1525,7 +1525,7 @@ xfs_attr_leaf_order(
 {
 	struct xfs_attr3_icleaf_hdr ichdr1;
 	struct xfs_attr3_icleaf_hdr ichdr2;
-	struct xfs_mount *mp = leaf1_bp->b_target->bt_mount;
+	struct xfs_mount *mp = leaf1_bp->b_mount;
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr1, leaf1_bp->b_addr);
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr2, leaf2_bp->b_addr);
@@ -2568,7 +2568,7 @@ xfs_attr_leaf_lasthash(
 {
 	struct xfs_attr3_icleaf_hdr ichdr;
 	struct xfs_attr_leaf_entry *entries;
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount *mp = bp->b_mount;
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, bp->b_addr);
 	entries = xfs_attr3_leaf_entryp(bp->b_addr);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 65ff600a8067..563c842ddfcf 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -111,7 +111,7 @@ __xfs_attr3_rmt_read_verify(
 	bool		check_crc,
 	xfs_failaddr_t	*failaddr)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount *mp = bp->b_mount;
 	char		*ptr;
 	int		len;
 	xfs_daddr_t	bno;
@@ -175,7 +175,7 @@ static void
 xfs_attr3_rmt_write_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount *mp = bp->b_mount;
 	xfs_failaddr_t	fa;
 	int		blksize = mp->m_attr_geo->blksize;
 	char		*ptr;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index aff82ed112c9..e6100bd3ec62 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -411,7 +411,7 @@ static xfs_failaddr_t
 xfs_bmbt_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	xfs_failaddr_t		fa;
 	unsigned int		level;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index bbdae2b4559f..a2099c15ac09 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -276,7 +276,7 @@ xfs_btree_lblock_calc_crc(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	if (!xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	if (!xfs_sb_version_hascrc(&bp->b_mount->m_sb))
 		return;
 	if (bip)
 		block->bb_u.l.bb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
@@ -288,7 +288,7 @@ xfs_btree_lblock_verify_crc(
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn)))
@@ -314,7 +314,7 @@ xfs_btree_sblock_calc_crc(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	if (!xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	if (!xfs_sb_version_hascrc(&bp->b_mount->m_sb))
 		return;
 	if (bip)
 		block->bb_u.s.bb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
@@ -326,7 +326,7 @@ xfs_btree_sblock_verify_crc(
 	struct xfs_buf		*bp)
 {
 	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
@@ -4433,7 +4433,7 @@ xfs_btree_lblock_v5hdr_verify(
 	struct xfs_buf		*bp,
 	uint64_t		owner)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
@@ -4454,7 +4454,7 @@ xfs_btree_lblock_verify(
 	struct xfs_buf		*bp,
 	unsigned int		max_recs)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 
 	/* numrecs verification */
@@ -4484,7 +4484,7 @@ xfs_failaddr_t
 xfs_btree_sblock_v5hdr_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
 
@@ -4510,7 +4510,7 @@ xfs_btree_sblock_verify(
 	struct xfs_buf		*bp,
 	unsigned int		max_recs)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	xfs_agblock_t		agno;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e2737e2ac2ae..224631d66ade 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -126,7 +126,7 @@ xfs_da3_blkinfo_verify(
 	struct xfs_buf		*bp,
 	struct xfs_da3_blkinfo	*hdr3)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_da_blkinfo	*hdr = &hdr3->hdr;
 
 	if (!xfs_verify_magic16(bp, hdr->magic))
@@ -148,7 +148,7 @@ static xfs_failaddr_t
 xfs_da3_node_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_da_intnode	*hdr = bp->b_addr;
 	struct xfs_da3_icnode_hdr ichdr;
 	const struct xfs_dir_ops *ops;
@@ -186,7 +186,7 @@ static void
 xfs_da3_node_write_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index b7d6d78f4ce2..6da84d2631d3 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -50,7 +50,7 @@ static xfs_failaddr_t
 xfs_dir3_block_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
 	if (!xfs_verify_magic(bp, hdr3->magic))
@@ -71,7 +71,7 @@ static void
 xfs_dir3_block_read_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
@@ -88,7 +88,7 @@ static void
 xfs_dir3_block_write_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index b7b9ce002cb9..17a95b65caf1 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -50,14 +50,13 @@ __xfs_dir3_data_check(
 	int			i;		/* leaf index */
 	int			lastfree;	/* last entry was unused */
 	xfs_dir2_leaf_entry_t	*lep=NULL;	/* block leaf entries */
-	xfs_mount_t		*mp;		/* filesystem mount point */
+	struct xfs_mount	*mp = bp->b_mount;
 	char			*p;		/* current data position */
 	int			stale;		/* count of stale leaves */
 	struct xfs_name		name;
 	const struct xfs_dir_ops *ops;
 	struct xfs_da_geometry	*geo;
 
-	mp = bp->b_target->bt_mount;
 	geo = mp->m_dir_geo;
 
 	/*
@@ -249,7 +248,7 @@ static xfs_failaddr_t
 xfs_dir3_data_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
 	if (!xfs_verify_magic(bp, hdr3->magic))
@@ -298,7 +297,7 @@ static void
 xfs_dir3_data_read_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
@@ -315,7 +314,7 @@ static void
 xfs_dir3_data_write_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 9c2a0a13ed61..b799c4db2151 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -144,7 +144,7 @@ static xfs_failaddr_t
 xfs_dir3_leaf_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 	xfs_failaddr_t		fa;
 
@@ -159,7 +159,7 @@ static void
 xfs_dir3_leaf_read_verify(
 	struct xfs_buf  *bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
@@ -176,7 +176,7 @@ static void
 xfs_dir3_leaf_write_verify(
 	struct xfs_buf  *bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 16731d2d684b..f16139d38208 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -84,7 +84,7 @@ static xfs_failaddr_t
 xfs_dir3_free_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dir2_free_hdr *hdr = bp->b_addr;
 
 	if (!xfs_verify_magic(bp, hdr->magic))
@@ -110,7 +110,7 @@ static void
 xfs_dir3_free_read_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
@@ -127,7 +127,7 @@ static void
 xfs_dir3_free_write_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 	xfs_failaddr_t		fa;
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 88fa11071f9f..194d2f0194aa 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -224,7 +224,7 @@ static xfs_failaddr_t
 xfs_dquot_buf_verify_struct(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	return xfs_dquot_buf_verify(mp, bp, false);
 }
@@ -233,7 +233,7 @@ static void
 xfs_dquot_buf_read_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	if (!xfs_dquot_buf_verify_crc(mp, bp, false))
 		return;
@@ -250,7 +250,7 @@ static void
 xfs_dquot_buf_readahead_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	if (!xfs_dquot_buf_verify_crc(mp, bp, true) ||
 	    xfs_dquot_buf_verify(mp, bp, true) != NULL) {
@@ -268,7 +268,7 @@ static void
 xfs_dquot_buf_write_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	xfs_dquot_buf_verify(mp, bp, false);
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index fe9898875097..76f9c5182d74 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2493,7 +2493,7 @@ static xfs_failaddr_t
 xfs_agi_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount *mp = bp->b_mount;
 	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
 	int		i;
 
@@ -2545,7 +2545,7 @@ static void
 xfs_agi_read_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount *mp = bp->b_mount;
 	xfs_failaddr_t	fa;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
@@ -2562,7 +2562,7 @@ static void
 xfs_agi_write_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	xfs_failaddr_t		fa;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index bc2dfacd2f4a..16f7a001b29c 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -255,7 +255,7 @@ static xfs_failaddr_t
 xfs_inobt_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	xfs_failaddr_t		fa;
 	unsigned int		level;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e021d5133ccb..c5c11c79f979 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -80,7 +80,7 @@ xfs_inode_buf_verify(
 	struct xfs_buf	*bp,
 	bool		readahead)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount *mp = bp->b_mount;
 	xfs_agnumber_t	agno;
 	int		i;
 	int		ni;
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 5d9de9b21726..5d1dfc49ac89 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -203,7 +203,7 @@ STATIC xfs_failaddr_t
 xfs_refcountbt_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
 	xfs_failaddr_t		fa;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 5d1f8884c888..e9fe53e0dcc8 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -292,7 +292,7 @@ static xfs_failaddr_t
 xfs_rmapbt_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_perag	*pag = bp->b_pag;
 	xfs_failaddr_t		fa;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index e76a3e5d28d7..5fd629244aee 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -686,7 +686,7 @@ xfs_sb_read_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_sb		sb;
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
 	int			error;
 
@@ -752,7 +752,7 @@ xfs_sb_write_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_sb		sb;
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	int			error;
 
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index a0ccc253c43d..264b94bb2295 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -90,7 +90,7 @@ static xfs_failaddr_t
 xfs_symlink_verify(
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
@@ -116,7 +116,7 @@ static void
 xfs_symlink_read_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount *mp = bp->b_mount;
 	xfs_failaddr_t	fa;
 
 	/* no verification of non-crc buffers */
@@ -136,7 +136,7 @@ static void
 xfs_symlink_write_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_mount *mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	xfs_failaddr_t		fa;
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 228821b2ebe0..d4f4c96bcd4c 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -121,7 +121,7 @@ xfs_attr3_leaf_inactive(
 	int			size;
 	int			tmp;
 	int			i;
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 26027a93bdd3..9477702d60a2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -243,6 +243,7 @@ _xfs_buf_alloc(
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
 	spin_lock_init(&bp->b_lock);
 	bp->b_target = target;
+	bp->b_mount = target->bt_mount;
 	bp->b_flags = flags;
 
 	/*
@@ -267,7 +268,7 @@ _xfs_buf_alloc(
 	atomic_set(&bp->b_pin_count, 0);
 	init_waitqueue_head(&bp->b_waiters);
 
-	XFS_STATS_INC(target->bt_mount, xb_create);
+	XFS_STATS_INC(bp->b_mount, xb_create);
 	trace_xfs_buf_init(bp, _RET_IP_);
 
 	return bp;
@@ -424,12 +425,12 @@ xfs_buf_allocate_memory(
 					current->comm, current->pid,
 					__func__, gfp_mask);
 
-			XFS_STATS_INC(bp->b_target->bt_mount, xb_page_retries);
+			XFS_STATS_INC(bp->b_mount, xb_page_retries);
 			congestion_wait(BLK_RW_ASYNC, HZ/50);
 			goto retry;
 		}
 
-		XFS_STATS_INC(bp->b_target->bt_mount, xb_page_found);
+		XFS_STATS_INC(bp->b_mount, xb_page_found);
 
 		nbytes = min_t(size_t, size, PAGE_SIZE - offset);
 		size -= nbytes;
@@ -1102,7 +1103,7 @@ xfs_buf_lock(
 	trace_xfs_buf_lock(bp, _RET_IP_);
 
 	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
-		xfs_log_force(bp->b_target->bt_mount, 0);
+		xfs_log_force(bp->b_mount, 0);
 	down(&bp->b_sema);
 
 	trace_xfs_buf_lock_done(bp, _RET_IP_);
@@ -1191,7 +1192,7 @@ xfs_buf_ioend_async(
 	struct xfs_buf	*bp)
 {
 	INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
-	queue_work(bp->b_target->bt_mount->m_buf_workqueue, &bp->b_ioend_work);
+	queue_work(bp->b_mount->m_buf_workqueue, &bp->b_ioend_work);
 }
 
 void
@@ -1210,7 +1211,7 @@ xfs_buf_ioerror_alert(
 	struct xfs_buf		*bp,
 	const char		*func)
 {
-	xfs_alert(bp->b_target->bt_mount,
+	xfs_alert(bp->b_mount,
 "metadata I/O error in \"%s\" at daddr 0x%llx len %d error %d",
 			func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
 			-bp->b_error);
@@ -1229,10 +1230,8 @@ xfs_bwrite(
 			 XBF_WRITE_FAIL | XBF_DONE);
 
 	error = xfs_buf_submit(bp);
-	if (error) {
-		xfs_force_shutdown(bp->b_target->bt_mount,
-				   SHUTDOWN_META_IO_ERROR);
-	}
+	if (error)
+		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
 	return error;
 }
 
@@ -1369,12 +1368,12 @@ _xfs_buf_ioapply(
 		if (bp->b_ops) {
 			bp->b_ops->verify_write(bp);
 			if (bp->b_error) {
-				xfs_force_shutdown(bp->b_target->bt_mount,
+				xfs_force_shutdown(bp->b_mount,
 						   SHUTDOWN_CORRUPT_INCORE);
 				return;
 			}
 		} else if (bp->b_bn != XFS_BUF_DADDR_NULL) {
-			struct xfs_mount *mp = bp->b_target->bt_mount;
+			struct xfs_mount *mp = bp->b_mount;
 
 			/*
 			 * non-crc filesystems don't attach verifiers during
@@ -1452,7 +1451,7 @@ __xfs_buf_submit(
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 
 	/* on shutdown we stale and complete the buffer immediately */
-	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
+	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
 		xfs_buf_ioerror(bp, -EIO);
 		bp->b_flags &= ~XBF_DONE;
 		xfs_buf_stale(bp);
@@ -2107,8 +2106,7 @@ void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 	 * This allows userspace to disrupt buffer caching for debug/testing
 	 * purposes.
 	 */
-	if (XFS_TEST_ERROR(false, bp->b_target->bt_mount,
-			   XFS_ERRTAG_BUF_LRU_REF))
+	if (XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_LRU_REF))
 		lru_ref = 0;
 
 	atomic_set(&bp->b_lru_ref, lru_ref);
@@ -2124,7 +2122,7 @@ xfs_verify_magic(
 	struct xfs_buf		*bp,
 	__be32			dmagic)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	int			idx;
 
 	idx = xfs_sb_version_hascrc(&mp->m_sb);
@@ -2142,7 +2140,7 @@ xfs_verify_magic16(
 	struct xfs_buf		*bp,
 	__be16			dmagic)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	int			idx;
 
 	idx = xfs_sb_version_hascrc(&mp->m_sb);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index f95cf810126e..284e9955a7a5 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -151,6 +151,7 @@ typedef struct xfs_buf {
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
+	struct xfs_mount	*b_mount;
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
 	void			*b_addr;	/* virtual address of buffer */
 	struct work_struct	b_ioend_work;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 65b32acfa0f6..f3d814dc7518 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -520,7 +520,7 @@ xfs_buf_item_push(
 	/* has a previous flush failed due to IO errors? */
 	if ((bp->b_flags & XBF_WRITE_FAIL) &&
 	    ___ratelimit(&xfs_buf_write_fail_rl_state, "XFS: Failing async write")) {
-		xfs_warn(bp->b_target->bt_mount,
+		xfs_warn(bp->b_mount,
 "Failing async write on buffer block 0x%llx. Retrying async write.",
 			 (long long)bp->b_bn);
 	}
@@ -743,7 +743,7 @@ xfs_buf_item_init(
 	 * this buffer. If we do already have one, there is
 	 * nothing to do here so return.
 	 */
-	ASSERT(bp->b_target->bt_mount == mp);
+	ASSERT(bp->b_mount == mp);
 	if (bip) {
 		ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 		ASSERT(!bp->b_transp);
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index a1e177f66404..9a51a7b80fed 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -353,7 +353,7 @@ xfs_buf_verifier_error(
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 	xfs_failaddr_t		fa;
 	int			sz;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bbe5e38e2932..b03921b0548a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -299,10 +299,9 @@ xlog_recover_iodone(
 		 * We're not going to bother about retrying
 		 * this during recovery. One strike!
 		 */
-		if (!XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
+		if (!XFS_FORCED_SHUTDOWN(bp->b_mount)) {
 			xfs_buf_ioerror_alert(bp, __func__);
-			xfs_force_shutdown(bp->b_target->bt_mount,
-						SHUTDOWN_META_IO_ERROR);
+			xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
 		}
 	}
 
@@ -2821,7 +2820,7 @@ xlog_recover_buffer_pass2(
 		xfs_buf_stale(bp);
 		error = xfs_bwrite(bp);
 	} else {
-		ASSERT(bp->b_target->bt_mount == mp);
+		ASSERT(bp->b_mount == mp);
 		bp->b_iodone = xlog_recover_iodone;
 		xfs_buf_delwri_queue(bp, buffer_list);
 	}
@@ -3183,7 +3182,7 @@ xlog_recover_inode_pass2(
 	/* re-generate the checksum. */
 	xfs_dinode_calc_crc(log->l_mp, dip);
 
-	ASSERT(bp->b_target->bt_mount == mp);
+	ASSERT(bp->b_mount == mp);
 	bp->b_iodone = xlog_recover_iodone;
 	xfs_buf_delwri_queue(bp, buffer_list);
 
@@ -3322,7 +3321,7 @@ xlog_recover_dquot_pass2(
 	}
 
 	ASSERT(dq_f->qlf_size == 2);
-	ASSERT(bp->b_target->bt_mount == mp);
+	ASSERT(bp->b_mount == mp);
 	bp->b_iodone = xlog_recover_iodone;
 	xfs_buf_delwri_queue(bp, buffer_list);
 
-- 
2.20.1
