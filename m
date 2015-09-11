Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 93F107F37
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 13:53:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 84CAF304039
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:53:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kXTjNFnMrFQ7veU9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:53:57 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 2AD248E3C0
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 18:53:57 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-37.bos.redhat.com [10.18.41.37])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8BIruAT025859
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 14:53:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC v2 2/2] xfs: validate metadata LSNs against log on v5 superblocks
Date: Fri, 11 Sep 2015 14:53:55 -0400
Message-Id: <1441997635-36644-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1441997635-36644-1-git-send-email-bfoster@redhat.com>
References: <1441997635-36644-1-git-send-email-bfoster@redhat.com>
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

This problem is ultimately addressed and repaired in the associated
userspace tools. The kernel is still responsible to detect the problem
and notify the user that something is wrong. Check the superblock LSN at
mount time and notify the user and fail the mount if it is invalid.
>From that point on, simply warn the user if an invalid metadata LSN is
detected from the various metadata I/O verifiers. A new xfs_mount flag
is added to guarantee that a warning fires at least once for each
affected filesystem mount. From that point forward, further instances of
the problem are rate limited to a once per 24 hour period.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |  9 +++++--
 fs/xfs/libxfs/xfs_attr_leaf.c      |  2 ++
 fs/xfs/libxfs/xfs_btree.c          | 14 +++++++++--
 fs/xfs/libxfs/xfs_da_btree.c       |  3 +++
 fs/xfs/libxfs/xfs_dir2_block.c     |  1 +
 fs/xfs/libxfs/xfs_dir2_data.c      |  1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c      |  1 +
 fs/xfs/libxfs/xfs_ialloc.c         |  8 +++++--
 fs/xfs/libxfs/xfs_sb.c             |  8 +++++++
 fs/xfs/libxfs/xfs_symlink_remote.c |  3 +++
 fs/xfs/xfs_log.c                   |  1 -
 fs/xfs/xfs_log_priv.h              | 24 +++++++++++++++++++
 fs/xfs/xfs_log_recover.c           | 15 +++++++++++-
 fs/xfs/xfs_mount.c                 | 49 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h                 |  3 +++
 16 files changed, 135 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ffad7f2..cb26016 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -482,6 +482,8 @@ xfs_agfl_verify(
 		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
 			return false;
 	}
+
+	xfs_detect_invalid_lsn(mp, be64_to_cpu(XFS_BUF_TO_AGFL(bp)->agfl_lsn));
 	return true;
 }
 
@@ -2259,9 +2261,12 @@ xfs_agf_verify(
  {
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
+		xfs_detect_invalid_lsn(mp,
+				be64_to_cpu(XFS_BUF_TO_AGF(bp)->agf_lsn));
+	}
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 33df52d..643ba73 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -266,6 +266,8 @@ xfs_attr3_leaf_verify(
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
+
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(hdr3->info.lsn));
 	} else {
 		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
 			return false;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f7d7ee7..c2c5765 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -243,8 +243,13 @@ bool
 xfs_btree_lblock_verify_crc(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn));
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
+	}
 
 	return true;
 }
@@ -275,8 +280,13 @@ bool
 xfs_btree_sblock_verify_crc(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn));
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
+	}
 
 	return true;
 }
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index be43248..2ea7982 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -150,6 +150,8 @@ xfs_da3_node_verify(
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
+
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(hdr3->info.lsn));
 	} else {
 		if (ichdr.magic != XFS_DA_NODE_MAGIC)
 			return false;
@@ -322,6 +324,7 @@ xfs_da3_node_create(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
+		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
 		ichdr.magic = XFS_DA3_NODE_MAGIC;
 		hdr3->info.blkno = cpu_to_be64(bp->b_bn);
 		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 4778d1d..9cd553f 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -71,6 +71,7 @@ xfs_dir3_block_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(hdr3->lsn));
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
 			return false;
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 824131e..d9c6d6e 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -224,6 +224,7 @@ xfs_dir3_data_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(hdr3->lsn));
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC))
 			return false;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index f300240..896de9e 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -164,6 +164,7 @@ xfs_dir3_leaf_verify(
 			return false;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
 			return false;
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(leaf3->info.lsn));
 	} else {
 		if (leaf->hdr.info.magic != cpu_to_be16(magic))
 			return false;
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index cc28e92..c0bfeef 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -97,6 +97,7 @@ xfs_dir3_free_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		xfs_detect_invalid_lsn(mp, be64_to_cpu(hdr3->lsn));
 	} else {
 		if (hdr->magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC))
 			return false;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 54deb2d..e91343b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2500,9 +2500,13 @@ xfs_agi_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
+		xfs_detect_invalid_lsn(mp,
+				be64_to_cpu(XFS_BUF_TO_AGI(bp)->agi_lsn));
+	}
+
 	/*
 	 * Validate the magic number of the agi block.
 	 */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 4742514..badf587 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -163,6 +163,14 @@ xfs_mount_validate_sb(
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
+		xfs_detect_invalid_lsn(mp, sbp->sb_lsn);
 	}
 
 	if (xfs_sb_version_has_pquotino(sbp)) {
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 8f8af05..aa6b3c1 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -60,6 +60,7 @@ xfs_symlink_hdr_set(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return 0;
 
+	memset(dsl, 0, sizeof(struct xfs_dsymlink_hdr));
 	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
 	dsl->sl_offset = cpu_to_be32(offset);
 	dsl->sl_bytes = cpu_to_be32(size);
@@ -117,6 +118,8 @@ xfs_symlink_verify(
 	if (dsl->sl_owner == 0)
 		return false;
 
+	xfs_detect_invalid_lsn(mp, be64_to_cpu(dsl->sl_lsn));
+
 	return true;
 }
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index aaadee0..a34476b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -4022,4 +4022,3 @@ xlog_iclogs_empty(
 	} while (iclog != log->l_iclog);
 	return 1;
 }
-
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 950f3f9..c0acc71 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -560,4 +560,28 @@ static inline void xlog_wait(wait_queue_head_t *wq, spinlock_t *lock)
 	remove_wait_queue(wq, &wait);
 }
 
+/*
+ * The LSN is valid so long as it is behind the current LSN. If it isn't, this
+ * means that the next log record that includes this metadata could have a
+ * smaller LSN. In turn, this means that the modification in the log would not
+ * replay.
+ */
+static inline bool
+xlog_valid_lsn(
+	struct xlog	*log,
+	xfs_lsn_t	lsn)
+{
+	int		cycle = CYCLE_LSN(lsn);
+	int		block = BLOCK_LSN(lsn);
+	bool		valid = true;
+
+	spin_lock(&log->l_icloglock);
+	if ((cycle > log->l_curr_cycle) ||
+	    (cycle == log->l_curr_cycle && block > log->l_curr_block))
+		valid = false;
+	spin_unlock(&log->l_icloglock);
+
+	return valid;
+}
+
 #endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 512a094..c6ea06a 100644
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
+	    !xlog_valid_lsn(log, log->l_mp->m_sb.sb_lsn)) {
+		xfs_warn(log->l_mp,
+	"Invalid superblock LSN (ahead of log). Please run xfs_repair.");
+		return -EINVAL;
+	}
+
 	if (tail_blk != head_blk) {
 		/* There used to be a comment here:
 		 *
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bf92e0c..0acfea8 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -41,6 +41,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_sysfs.h"
+#include "xfs_log_priv.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -1301,3 +1302,51 @@ xfs_dev_is_read_only(
 	}
 	return 0;
 }
+
+/*
+ * Verify that an LSN stamped into a piece of metadata is valid. This is
+ * intended for use in read verifiers on v5 superblocks.
+ */
+void
+xfs_detect_invalid_lsn(
+	struct xfs_mount	*mp,
+	xfs_lsn_t		lsn)
+{
+	struct xlog		*log = mp->m_log;
+	int			cycle = CYCLE_LSN(lsn);
+	int			block = BLOCK_LSN(lsn);
+	const char 		*fmt;
+
+	/*
+	 * 'norecovery' mode skips mount-time log processing and unconditionally
+	 * resets the LSN.
+	 */
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		return;
+
+	if (xlog_valid_lsn(mp->m_log, lsn))
+		return;
+
+	/*
+	 * Warn at least once for each filesystem susceptible to this problem
+	 * and once per day thereafter.
+	 *
+	 * XXX: Specify the minimum xfs_repair version required to resolve?
+	 * Older versions will silently reintroduce the problem.
+	 *
+	 * We should eventually convert this condition into a hard error (via
+	 * verifier failure). Defer that behavior for a few release cycles or so
+	 * until the userspace fixes have had the opportunity to propogate
+	 * throughout the various distributions.
+	 */
+	fmt = "WARNING: Metadata has LSN (%d:%d) ahead of current LSN (%d:%d). "
+"This may result in filesystem failure. Please unmount and run xfs_repair to resolve.";
+	if (!mp->m_warned_bad_lsn) {
+		mp->m_warned_bad_lsn = true;
+		xfs_warn(mp, fmt, cycle, block, log->l_curr_cycle,
+			 log->l_curr_block);
+	} else {
+		xfs_warn_daily(mp, fmt, cycle, block, log->l_curr_cycle,
+			       log->l_curr_block);
+	}
+}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7999e91..572ebfc 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -127,6 +127,7 @@ typedef struct xfs_mount {
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
+	bool			m_warned_bad_lsn;/* bad metadata lsn detected */
 
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_data_workqueue;
@@ -336,4 +337,6 @@ extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
 
 extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 
+extern void	xfs_detect_invalid_lsn(struct xfs_mount *, xfs_lsn_t);
+
 #endif	/* __XFS_MOUNT_H__ */
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
