Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 670237F37
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 13:03:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 452178F8033
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 11:03:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 72sKnQgNhWfFL1Ra (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Aug 2015 11:03:36 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 6E2448EA3E
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 18:03:35 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-103.bos.redhat.com [10.18.41.103])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7SI3Y81004423
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 14:03:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] xfs: validate metadata LSNs against log on v5 superblocks
Date: Fri, 28 Aug 2015 14:03:33 -0400
Message-Id: <1440785013-17035-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Since the onset of v5 superblocks, the LSN of the last modification has
been included in a variety of on-disk data structures. This LSN is used
to provide log recovery ordering guarantees (e.g., to ensure an older
log recovery item is not replayed over a newer target data structure).

While this works correctly from the point a filesystem is formatted and
mounted, userspace tools have some problematic behaviors that defeat
this mechanism. For example, xfs_repair historically zeroes out the log
unconditionally (regardless of whether corruption is detected). If this
occurs, the LSN of the filesystem is reset and the log is now in a
problematic state with respect to on-disk metadata structures that might
have a larger LSN. Until either the log catches up to the highest
previously used metadata LSN or each affected data structure is modified
and written out without incident (which resets the metadata LSN), log
recovery is susceptible to filesystem corruption.

Going foward, this problem is primarily addressed in the associated
userspace tools. The kernel is still responsible to detect the problem
and notify the user that something is wrong. Update the kernel to verify
metadata LSNs against the current log in the associated read/write
verifier helper functions. If a metadata LSN is ahead of the current
LSN, fire a warning about the problem and trigger a verifier error.

XXX:
- The WARN_ONCE() mechanism seems pointless if we always trigger
verifier errors. The failure is going to be noisy and hard and not
warning just removes useful information about the problem. I'm also not
a fan of causing the subsequent fs shutdown for something that is not a
severe, unrecoverable error. Perhaps we should not fail the verifier and
replace the WARN_ONCE() with a mechanism that fires a warning every so
often (once per-day per-fs?). Thoughts?

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is an RFC as this is only lightly tested so far. I'm not quite sure
verifier failure is the right thing to do (see above). Finally, this
depends on the existence of a not yet available mechanism to resolve the
problem. I'm posting this for further discussion and to serve as a
basis for the associated userspace patches that are forthcoming.
Thoughts, reviews, flames appreciated.

Brian

 fs/xfs/libxfs/xfs_alloc.c          | 10 +++++++--
 fs/xfs/libxfs/xfs_attr_leaf.c      |  3 +++
 fs/xfs/libxfs/xfs_btree.c          | 18 +++++++++++++--
 fs/xfs/libxfs/xfs_da_btree.c       |  3 +++
 fs/xfs/libxfs/xfs_dir2_block.c     |  2 ++
 fs/xfs/libxfs/xfs_dir2_data.c      |  2 ++
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  2 ++
 fs/xfs/libxfs/xfs_dir2_node.c      |  2 ++
 fs/xfs/libxfs/xfs_ialloc.c         |  9 ++++++--
 fs/xfs/libxfs/xfs_sb.c             |  9 ++++++++
 fs/xfs/libxfs/xfs_symlink_remote.c |  3 +++
 fs/xfs/xfs_log_recover.c           | 15 ++++++++++++-
 fs/xfs/xfs_mount.c                 | 46 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h                 |  2 ++
 14 files changed, 119 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ffad7f2..8628225 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -468,6 +468,8 @@ xfs_agfl_verify(
 		return false;
 	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
 		return false;
+	if (!xfs_valid_lsn(mp, be64_to_cpu(XFS_BUF_TO_AGFL(bp)->agfl_lsn)))
+		return false;
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
@@ -2259,9 +2261,13 @@ xfs_agf_verify(
  {
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
+		if (!xfs_valid_lsn(mp,
+				   be64_to_cpu(XFS_BUF_TO_AGF(bp)->agf_lsn)))
+			return false;
+	}
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 33df52d..dcb30d4 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -266,6 +266,9 @@ xfs_attr3_leaf_verify(
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
+
+		if (!xfs_valid_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
+			return false;
 	} else {
 		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
 			return false;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f7d7ee7..4be8053 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -243,8 +243,15 @@ bool
 xfs_btree_lblock_verify_crc(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+		if (!xfs_valid_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn)))
+			return false;
+
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
+	}
 
 	return true;
 }
@@ -275,8 +282,15 @@ bool
 xfs_btree_sblock_verify_crc(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+		if (!xfs_valid_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
+			return false;
+
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
+	}
 
 	return true;
 }
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index cd2201f..7ce7354 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -150,6 +150,9 @@ xfs_da3_node_verify(
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
+
+		if (!xfs_valid_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
+			return false;
 	} else {
 		if (ichdr.magic != XFS_DA_NODE_MAGIC)
 			return false;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 4778d1d..1b37f6d 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -71,6 +71,8 @@ xfs_dir3_block_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		if (!xfs_valid_lsn(mp, be64_to_cpu(hdr3->lsn)))
+			return false;
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
 			return false;
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 824131e..3632703 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -224,6 +224,8 @@ xfs_dir3_data_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		if (!xfs_valid_lsn(mp, be64_to_cpu(hdr3->lsn)))
+			return false;
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC))
 			return false;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index f300240..1072b7d 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -164,6 +164,8 @@ xfs_dir3_leaf_verify(
 			return false;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
 			return false;
+		if (!xfs_valid_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
+			return false;
 	} else {
 		if (leaf->hdr.info.magic != cpu_to_be16(magic))
 			return false;
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index cc28e92..9131c3b 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -97,6 +97,8 @@ xfs_dir3_free_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		if (!xfs_valid_lsn(mp, be64_to_cpu(hdr3->lsn)))
+			return false;
 	} else {
 		if (hdr->magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC))
 			return false;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 54deb2d..c426438 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2500,9 +2500,14 @@ xfs_agi_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
+			return false;
+		if (!xfs_valid_lsn(mp,
+				   be64_to_cpu(XFS_BUF_TO_AGI(bp)->agi_lsn)))
 			return false;
+	}
+
 	/*
 	 * Validate the magic number of the agi block.
 	 */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 4742514..c4fe6f1 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -163,6 +163,15 @@ xfs_mount_validate_sb(
 "Filesystem can not be safely mounted by this kernel.");
 			return -EINVAL;
 		}
+	} else if (xfs_sb_version_hascrc(sbp)) {
+		/*
+		 * We can't read verify the sb LSN because the read verifier is
+		 * called before the log is allocated and processed. We know the
+		 * log is set up before write verifier (!check_version) calls,
+		 * so just check it here.
+		 */
+		if (!xfs_valid_lsn(mp, sbp->sb_lsn))
+			return -EINVAL;
 	}
 
 	if (xfs_sb_version_has_pquotino(sbp)) {
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 8f8af05..1362190 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -60,6 +60,7 @@ xfs_symlink_hdr_set(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return 0;
 
+	memset(dsl, 0, sizeof(struct xfs_dsymlink_hdr));
 	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
 	dsl->sl_offset = cpu_to_be32(offset);
 	dsl->sl_bytes = cpu_to_be32(size);
@@ -116,6 +117,8 @@ xfs_symlink_verify(
 		return false;
 	if (dsl->sl_owner == 0)
 		return false;
+	if (!xfs_valid_lsn(mp, be64_to_cpu(dsl->sl_lsn)))
+		return false;
 
 	return true;
 }
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 512a094..fe25e53 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4609,9 +4609,22 @@ xlog_recover(
 	int		error;
 
 	/* find the tail of the log */
-	if ((error = xlog_find_tail(log, &head_blk, &tail_blk)))
+	error = xlog_find_tail(log, &head_blk, &tail_blk);
+	if (error)
 		return error;
 
+	/*
+	 * The superblock was read before the log was available and thus the LSN
+	 * could not be verified. Check the superblock LSN against the current
+	 * LSN now that it's known.
+	 */
+	if (xfs_sb_version_hascrc(&log->l_mp->m_sb) &&
+	    !xfs_valid_lsn(log->l_mp, log->l_mp->m_sb.sb_lsn)) {
+		xfs_warn(log->l_mp,
+	"Invalid superblock LSN (ahead of log). Please run xfs_repair.");
+		return -EINVAL;
+	}
+
 	if (tail_blk != head_blk) {
 		/* There used to be a comment here:
 		 *
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bf92e0c..45ed63d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -41,6 +41,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_sysfs.h"
+#include "xfs_log_priv.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -1301,3 +1302,48 @@ xfs_dev_is_read_only(
 	}
 	return 0;
 }
+
+/*
+ * Verify that an LSN stamped into a piece of metadata is valid. This is
+ * intended for use in read verifiers on v5 superblocks. Returns true for a
+ * valid LSN, false otherwise.
+ */
+bool
+xfs_valid_lsn(
+	struct xfs_mount	*mp,
+	xfs_lsn_t		lsn)
+{
+	struct xlog		*log = mp->m_log;
+	int			cycle = CYCLE_LSN(lsn);
+	int			block = BLOCK_LSN(lsn);
+	bool			valid = true;
+
+	/*
+	 * 'norecovery' mode skips mount-time log processing and unconditionally
+	 * resets the LSN.
+	 */
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		return valid;
+
+	/*
+	 * The LSN is valid so long as it is behind the current LSN. If it
+	 * isn't, this means that the next log record that includes this
+	 * metadata could have a smaller LSN. In turn, this means that the
+	 * modification in the log would not replay.
+	 */
+	if (cycle > log->l_curr_cycle)
+		valid = false;
+	else if (cycle == log->l_curr_cycle &&
+		 block > log->l_curr_block)
+		valid = false;
+
+	/*
+	 * XXX: is WARN_ONCE() appropriate? This is a per-fs state after all...
+	 */
+	WARN_ONCE(!valid,
+		  "%s: Metadata has LSN (%d:%d) ahead of current LSN (%d:%d). "
+		  "Please unmount and run xfs_repair to resolve.", mp->m_fsname,
+		  cycle, block, log->l_curr_cycle, log->l_curr_block);
+
+	return valid;
+}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7999e91..156567d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -336,4 +336,6 @@ extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
 
 extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 
+extern bool	xfs_valid_lsn(struct xfs_mount *, xfs_lsn_t);
+
 #endif	/* __XFS_MOUNT_H__ */
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
