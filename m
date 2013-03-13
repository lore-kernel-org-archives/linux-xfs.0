Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 906857F3F
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 19:29:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1BC8CAC004
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 17:29:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kTfy1JGFu0LLHFuv for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 17:29:14 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UFZYy-00037w-8D
	for xfs@oss.sgi.com; Wed, 13 Mar 2013 11:29:00 +1100
Date: Wed, 13 Mar 2013 11:29:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 23/21] xfs: fix endian issues reported by sparse
Message-ID: <20130313002900.GS21651@dastard>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363091454-8852-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


From: Dave Chinner <dchinner@redhat.com>

Sparse reports several problems in the new code with incorrect
endian conversions being done on variables. Fix them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_btree.c   |    2 +-
 fs/xfs/xfs_dinode.h     |    2 +-
 fs/xfs/xfs_dir2_block.c |    4 ++--
 fs/xfs/xfs_dir2_data.c  |    4 ++--
 fs/xfs/xfs_dir2_leaf.c  |    2 +-
 fs/xfs/xfs_dir2_node.c  |    6 +++---
 fs/xfs/xfs_mount.c      |    1 -
 7 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 10bfeaa..a78865e 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2287,7 +2287,7 @@ xfs_da3_swap_lastblock(
 			goto done;
 		par_node = par_buf->b_addr;
 		xfs_da3_node_hdr_from_disk(&par_hdr, par_node);
-		if (level >= 0 && level != be16_to_cpu(par_hdr.level) + 1) {
+		if (level >= 0 && level != par_hdr.level + 1) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(4)",
 					 XFS_ERRLEVEL_LOW, mp);
 			error = XFS_ERROR(EFSCORRUPTED);
diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
index bdc946a..f7a0e95 100644
--- a/fs/xfs/xfs_dinode.h
+++ b/fs/xfs/xfs_dinode.h
@@ -72,7 +72,7 @@ typedef struct xfs_dinode {
 	__be32		di_next_unlinked;/* agi unlinked list ptr */
 
 	/* start of the extended dinode, writable fields */
-	__be32		di_crc;		/* CRC of the inode */
+	__le32		di_crc;		/* CRC of the inode */
 	__be64		di_changecount;	/* number of attribute changes */
 	__be64		di_lsn;		/* flush sequence */
 	__be64		di_flags2;	/* more random flags */
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 8c387e4..58816ec 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -67,14 +67,14 @@ xfs_dir3_block_verify(
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		if (hdr3->magic != be32_to_cpu(XFS_DIR3_BLOCK_MAGIC))
+		if (hdr3->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
 			return false;
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
 	} else {
-		if (hdr3->magic != be32_to_cpu(XFS_DIR2_BLOCK_MAGIC))
+		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
 			return false;
 	}
 	if (__xfs_dir3_data_check(NULL, bp))
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 20a4aaf..5e0c711 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -200,14 +200,14 @@ xfs_dir3_data_verify(
 	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		if (hdr3->magic != be32_to_cpu(XFS_DIR3_DATA_MAGIC))
+		if (hdr3->magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC))
 			return false;
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
 	} else {
-		if (hdr3->magic != be32_to_cpu(XFS_DIR2_DATA_MAGIC))
+		if (hdr3->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC))
 			return false;
 	}
 	if (__xfs_dir3_data_check(NULL, bp))
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 43a5c8543c4..9bf588c 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -180,7 +180,7 @@ xfs_dir3_leaf1_check(
 static bool
 xfs_dir3_leaf_verify(
 	struct xfs_buf		*bp,
-	__be16			magic)
+	__uint16_t		magic)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 7d1ee7d..9e542e7 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -90,14 +90,14 @@ xfs_dir3_free_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
-		if (hdr3->magic != be32_to_cpu(XFS_DIR3_FREE_MAGIC))
+		if (hdr3->magic != cpu_to_be32(XFS_DIR3_FREE_MAGIC))
 			return false;
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
 	} else {
-		if (hdr->magic != be32_to_cpu(XFS_DIR2_FREE_MAGIC))
+		if (hdr->magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC))
 			return false;
 	}
 
@@ -1284,7 +1284,7 @@ xfs_dir2_leafn_remove(
 	{
 		struct xfs_dir3_icfree_hdr freehdr;
 		xfs_dir3_free_hdr_from_disk(&freehdr, free);
-		ASSERT(be32_to_cpu(freehdr.firstdb) ==
+		ASSERT(freehdr.firstdb ==
 				       xfs_dir3_free_max_bests(mp) *
 				       (fdb - XFS_DIR2_FREE_FIRSTDB(mp)));
 	}
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 97443c9..cbef607 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -568,7 +568,6 @@ xfs_sb_from_disk(
 	to->sb_features_compat = be32_to_cpu(from->sb_features_compat);
 	to->sb_features_ro_compat = be32_to_cpu(from->sb_features_ro_compat);
 	to->sb_features_incompat = be32_to_cpu(from->sb_features_incompat);
-	to->sb_crc = be32_to_cpu(from->sb_crc);
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
