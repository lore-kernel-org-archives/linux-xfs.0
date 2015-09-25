Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE1647F37
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 07:24:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 824448F8064
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 05:24:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tF1p02S9wjBCSS2e (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Sep 2015 05:24:31 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 8762319F21C
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 12:24:30 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8PCOUPm019980
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 08:24:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: validate metadata LSNs against log on v5 superblocks
Date: Fri, 25 Sep 2015 08:24:29 -0400
Message-Id: <1443183869-16487-1-git-send-email-bfoster@redhat.com>
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
mount time and fail the mount if it is invalid. From that point on,
trigger verifier failure on any metadata I/O where an invalid LSN is
detected. This results in a filesystem shutdown and guarantees that we
do not log metadata changes with invalid LSNs on disk. Since this is a
known issue with a known recovery path, present a warning to instruct
the user how to recover.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Here's a first non-rfc version of v5 sb metadata LSN verification. The
biggest difference with this version is the attempt to mitigate lock
contention in the LSN helper and corresponding tweak to how the log
fields are updated when the head wraps around the end of the log. The
idea is to do a racy check and only acquire the lock when there appears
to be risk of an invalid LSN.

AFAICS, this is not safe with the current code as the current LSN can be
sampled in a state that transiently pushes the LSN forward to the end of
the next cycle (if the cycle is updated, both cycle/block are sampled,
and then the block is updated). This means that a false negative can
occur if an invalid LSN happens to exist but is within the bounds of the
next full log cycle. Therefore, this patch also tweaks the current LSN
update and sample code to rewind the current block before the cycle is
updated and uses a memory barrier to guarantee that the sample code
always sees the rewound current block if it sees the updated cycle. Note
that it is still possible to see the rewound block before the cycle
update (a transient backwards LSN), but this is safe because such false
positives are explicitly reverified with the lock held before failure is
triggered.

Otherwise, this refactors/relocates the helpers and converts back to the
more simple behavior of verifier failure on detection of invalid
metadata LSN. Thoughts, reviews, flames appreciated.

Brian

v1:
- Converted back to verifier failure (fs shutdown) behavior.
- Relocated and renamed support functions.
- Perform racy LSN check before locked check to minimize lock
  contention.
- Updated log cycle wrap code to support racy check.
- Handle NULLCOMMITLSN metadata LSN in verifiers.
rfcv2: http://oss.sgi.com/pipermail/xfs/2015-September/043627.html
- Refactored lsn validation and warning code into separate helpers.
- Updated warning mechanism to warn at least once per fs (ratelimited
  thereafter).
- No longer shutdown the fs on invalid metadata lsn detection.
rfcv1: http://oss.sgi.com/pipermail/xfs/2015-August/043396.html

 fs/xfs/libxfs/xfs_alloc.c          | 12 ++++++---
 fs/xfs/libxfs/xfs_attr_leaf.c      |  3 +++
 fs/xfs/libxfs/xfs_btree.c          | 17 ++++++++++--
 fs/xfs/libxfs/xfs_da_btree.c       |  4 +++
 fs/xfs/libxfs/xfs_dir2_block.c     |  3 +++
 fs/xfs/libxfs/xfs_dir2_data.c      |  3 +++
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  3 +++
 fs/xfs/libxfs/xfs_dir2_node.c      |  3 +++
 fs/xfs/libxfs/xfs_ialloc.c         | 10 +++++--
 fs/xfs/libxfs/xfs_sb.c             | 10 +++++++
 fs/xfs/libxfs/xfs_symlink_remote.c |  4 +++
 fs/xfs/xfs_log.c                   | 54 ++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_log.h                   |  1 +
 fs/xfs/xfs_log_priv.h              | 51 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c           | 12 ++++++++-
 15 files changed, 180 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ffad7f2..d39e6d8 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -482,7 +482,9 @@ xfs_agfl_verify(
 		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
 			return false;
 	}
-	return true;
+
+	return xfs_log_check_lsn(mp,
+				 be64_to_cpu(XFS_BUF_TO_AGFL(bp)->agfl_lsn));
 }
 
 static void
@@ -2259,9 +2261,13 @@ xfs_agf_verify(
  {
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
+		if (!xfs_log_check_lsn(mp,
+				be64_to_cpu(XFS_BUF_TO_AGF(bp)->agf_lsn)))
+			return false;
+	}
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 33df52d..aa187f7 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -41,6 +41,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
 #include "xfs_dir2.h"
+#include "xfs_log.h"
 
 
 /*
@@ -266,6 +267,8 @@ xfs_attr3_leaf_verify(
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
+			return false;
 	} else {
 		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
 			return false;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f7d7ee7..b16a8ba 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -32,6 +32,7 @@
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_alloc.h"
+#include "xfs_log.h"
 
 /*
  * Cursor allocation zone.
@@ -243,8 +244,14 @@ bool
 xfs_btree_lblock_verify_crc(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn)))
+			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
+	}
 
 	return true;
 }
@@ -275,8 +282,14 @@ bool
 xfs_btree_sblock_verify_crc(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
+	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
+			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
+	}
 
 	return true;
 }
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index be43248..e89a0f8 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -39,6 +39,7 @@
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_buf_item.h"
+#include "xfs_log.h"
 
 /*
  * xfs_da_btree.c
@@ -150,6 +151,8 @@ xfs_da3_node_verify(
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
+			return false;
 	} else {
 		if (ichdr.magic != XFS_DA_NODE_MAGIC)
 			return false;
@@ -322,6 +325,7 @@ xfs_da3_node_create(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
+		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
 		ichdr.magic = XFS_DA3_NODE_MAGIC;
 		hdr3->info.blkno = cpu_to_be64(bp->b_bn);
 		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 4778d1d..9c10e2b 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -34,6 +34,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
+#include "xfs_log.h"
 
 /*
  * Local function prototypes.
@@ -71,6 +72,8 @@ xfs_dir3_block_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
+			return false;
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
 			return false;
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 824131e..af71a84 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -31,6 +31,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
+#include "xfs_log.h"
 
 /*
  * Check the consistency of the data block.
@@ -224,6 +225,8 @@ xfs_dir3_data_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
+			return false;
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC))
 			return false;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index f300240..3923e1f 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -33,6 +33,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
+#include "xfs_log.h"
 
 /*
  * Local function declarations.
@@ -164,6 +165,8 @@ xfs_dir3_leaf_verify(
 			return false;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
 			return false;
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
+			return false;
 	} else {
 		if (leaf->hdr.info.magic != cpu_to_be16(magic))
 			return false;
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index cc28e92..70b0cb2 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -33,6 +33,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_cksum.h"
+#include "xfs_log.h"
 
 /*
  * Function declarations.
@@ -97,6 +98,8 @@ xfs_dir3_free_verify(
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
+		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
+			return false;
 	} else {
 		if (hdr->magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC))
 			return false;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 54deb2d..70c1db9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -38,6 +38,7 @@
 #include "xfs_icreate_item.h"
 #include "xfs_icache.h"
 #include "xfs_trace.h"
+#include "xfs_log.h"
 
 
 /*
@@ -2500,9 +2501,14 @@ xfs_agi_verify(
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
 
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
+			return false;
+		if (!xfs_log_check_lsn(mp,
+				be64_to_cpu(XFS_BUF_TO_AGI(bp)->agi_lsn)))
 			return false;
+	}
+
 	/*
 	 * Validate the magic number of the agi block.
 	 */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 4742514..a0b071d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -35,6 +35,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
+#include "xfs_log.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -163,6 +164,15 @@ xfs_mount_validate_sb(
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
+		if (!xfs_log_check_lsn(mp, sbp->sb_lsn))
+			return -EFSCORRUPTED;
 	}
 
 	if (xfs_sb_version_has_pquotino(sbp)) {
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 8f8af05..60eed7a 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -31,6 +31,7 @@
 #include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_log.h"
 
 
 /*
@@ -60,6 +61,7 @@ xfs_symlink_hdr_set(
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return 0;
 
+	memset(dsl, 0, sizeof(struct xfs_dsymlink_hdr));
 	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
 	dsl->sl_offset = cpu_to_be32(offset);
 	dsl->sl_bytes = cpu_to_be32(size);
@@ -116,6 +118,8 @@ xfs_symlink_verify(
 		return false;
 	if (dsl->sl_owner == 0)
 		return false;
+	if (!xfs_log_check_lsn(mp, be64_to_cpu(dsl->sl_lsn)))
+		return false;
 
 	return true;
 }
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index aaadee0..0c8ef76 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3165,11 +3165,19 @@ xlog_state_switch_iclogs(
 	}
 
 	if (log->l_curr_block >= log->l_logBBsize) {
+		/*
+		 * Rewind the current block before the cycle is bumped to make
+		 * sure that the combined LSN never transiently moves forward
+		 * when the log wraps to the next cycle. This is to support the
+		 * unlocked sample of these fields from xlog_valid_lsn(). Most
+		 * other cases should acquire l_icloglock.
+		 */
+		log->l_curr_block -= log->l_logBBsize;
+		ASSERT(log->l_curr_block >= 0);
+		smp_wmb();
 		log->l_curr_cycle++;
 		if (log->l_curr_cycle == XLOG_HEADER_MAGIC_NUM)
 			log->l_curr_cycle++;
-		log->l_curr_block -= log->l_logBBsize;
-		ASSERT(log->l_curr_block >= 0);
 	}
 	ASSERT(iclog == log->l_iclog);
 	log->l_iclog = iclog->ic_next;
@@ -4023,3 +4031,45 @@ xlog_iclogs_empty(
 	return 1;
 }
 
+/*
+ * Verify that an LSN stamped into a piece of metadata is valid. This is
+ * intended for use in read verifiers on v5 superblocks.
+ */
+bool
+xfs_log_check_lsn(
+	struct xfs_mount	*mp,
+	xfs_lsn_t		lsn)
+{
+	struct xlog		*log = mp->m_log;
+	bool			valid;
+
+	/*
+	 * norecovery mode skips mount-time log processing and unconditionally
+	 * resets the in-core LSN. We can't validate in this mode, but
+	 * modifications are not allowed anyways so just return true.
+	 */
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		return true;
+
+	/*
+	 * Some metadata LSNs are initialized to NULL (e.g., the agfl). This is
+	 * handled by recovery and thus safe to ignore here.
+	 */
+	if (lsn == NULLCOMMITLSN)
+		return true;
+
+	valid = xlog_valid_lsn(mp->m_log, lsn);
+
+	/* warn the user about what's gone wrong before verifier failure */
+	if (!valid) {
+		spin_lock(&log->l_icloglock);
+		xfs_warn(mp,
+"Corruption warning: Metadata has LSN (%d:%d) ahead of current LSN (%d:%d). "
+"Please unmount and run xfs_repair (>= v4.3) to resolve.",
+			 CYCLE_LSN(lsn), BLOCK_LSN(lsn),
+			 log->l_curr_cycle, log->l_curr_block);
+		spin_unlock(&log->l_icloglock);
+	}
+
+	return valid;
+}
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 09d91d3..aa533a7 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -181,5 +181,6 @@ bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 void	xfs_log_work_queue(struct xfs_mount *mp);
 void	xfs_log_worker(struct work_struct *work);
 void	xfs_log_quiesce(struct xfs_mount *mp);
+bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 
 #endif	/* __XFS_LOG_H__ */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 950f3f9..8daba74 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -560,4 +560,55 @@ static inline void xlog_wait(wait_queue_head_t *wq, spinlock_t *lock)
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
+	int		cur_cycle;
+	int		cur_block;
+	bool		valid = true;
+
+	/*
+	 * First, sample the current lsn without locking to avoid added
+	 * contention from metadata I/O. The current cycle and block are updated
+	 * (in xlog_state_switch_iclogs()) and read here in a particular order
+	 * to avoid false negatives (e.g., thinking the metadata LSN is valid
+	 * when it is not).
+	 *
+	 * The current block is always rewound before the cycle is bumped in
+	 * xlog_state_switch_iclogs() to ensure the current LSN is never seen in
+	 * a transiently forward state. Instead, we can see the LSN in a
+	 * transiently behind state if we happen to race with a cycle wrap.
+	 */
+	cur_cycle = ACCESS_ONCE(log->l_curr_cycle);
+	smp_rmb();
+	cur_block = ACCESS_ONCE(log->l_curr_block);
+
+	if ((CYCLE_LSN(lsn) > cur_cycle) ||
+	    (CYCLE_LSN(lsn) == cur_cycle && BLOCK_LSN(lsn) > cur_block)) {
+		/*
+		 * If the metadata LSN appears invalid, it's possible the check
+		 * above raced with a wrap to the next log cycle. Grab the lock
+		 * to check for sure.
+		 */
+		spin_lock(&log->l_icloglock);
+		cur_cycle = log->l_curr_cycle;
+		cur_block = log->l_curr_block;
+		spin_unlock(&log->l_icloglock);
+
+		if ((CYCLE_LSN(lsn) > cur_cycle) ||
+		    (CYCLE_LSN(lsn) == cur_cycle && BLOCK_LSN(lsn) > cur_block))
+			valid = false;
+	}
+
+	return valid;
+}
+
 #endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 512a094..f8f1363 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4609,9 +4609,19 @@ xlog_recover(
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
+	    !xfs_log_check_lsn(log->l_mp, log->l_mp->m_sb.sb_lsn))
+		return -EINVAL;
+
 	if (tail_blk != head_blk) {
 		/* There used to be a comment here:
 		 *
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
