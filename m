Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 036D97F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 06:23:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E6B538F8050
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 04:22:59 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2cV8wpSSRQyBxVzr for <xfs@oss.sgi.com>;
	Wed, 28 Aug 2013 04:22:58 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VEdpp-0004xa-EX
	for xfs@oss.sgi.com; Wed, 28 Aug 2013 21:22:49 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VEdpp-0001i9-De
	for xfs@oss.sgi.com; Wed, 28 Aug 2013 21:22:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: check LSN ordering for v5 superblocks during recovery
Date: Wed, 28 Aug 2013 21:22:47 +1000
Message-Id: <1377688967-6480-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1377688967-6480-1-git-send-email-david@fromorbit.com>
References: <1377688967-6480-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Log recovery has some strict ordering requirements which unordered
or reordered metadata writeback can defeat. This can occur when an
item is logged in a transaction, written back to disk, and then
logged in a new transaction before the tail of the log is moved past
the original modification.

The result of this is that when we read an object off disk for
recovery purposes, the buffer that we read may not contain the
object type that recovery is expecting and hence at the end of the
checkpoint being recovered we have an invalid object in memory.

This isn't usually a problem, as recovery will then replay all the
other checkpoints and that brings the object back to a valid and
correct state, but the issue is that while the object is in the
invalid state it can be flushed to disk. This results in the object
verifier failing and triggering a corruption shutdown of log
recover. This is correct behaviour for the verifiers - the problem
is that we are not detecting that the object we've read off disk is
newer than the transaction we are replaying.

All metadata in v5 filesystems has the LSN of it's last modification
stamped in it. This enabled log recover to read that field and
determine the age of the object on disk correctly. If the LSN of the
object on disk is older than the transaction being replayed, then we
replay the modification. If the LSN of the object matches or is more
recent than the transaction's LSN, then we should avoid overwriting
the object as that is what leads to the transient corrupt state.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 169 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 156 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 769c4a1..7c0c1fd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1959,6 +1959,104 @@ xlog_recover_do_inode_buffer(
 }
 
 /*
+ * V5 filesystems know the age of the buffer on disk being recovered. We can
+ * have newer objects on disk than we are replaying, and so for these cases we
+ * don't want to replay the current change as that will make the buffer contents
+ * temporarily invalid on disk.
+ *
+ * The magic number might not match the buffer type we are going to recover
+ * (e.g. reallocated blocks), so we ignore the xfs_buf_log_format flags.  Hence
+ * extract the LSN of the existing object in the buffer based on it's current
+ * magic number.  If we don't recognise the magic number in the buffer, then
+ * return a LSN of -1 so that the caller knows it was an unrecognised block and
+ * so can recover the buffer.
+ */
+static xfs_lsn_t
+xlog_recover_get_buf_lsn(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp)
+{
+	__uint32_t		magic32;
+	__uint16_t		magic16;
+	__uint16_t		magicda;
+	void			*blk = bp->b_addr;
+
+	/* v4 filesystems always recover immediately */
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		goto recover_immediately;
+
+	magic32 = be32_to_cpu(*(__be32 *)blk);
+	switch (magic32) {
+	case XFS_ABTB_CRC_MAGIC:
+	case XFS_ABTC_CRC_MAGIC:
+	case XFS_ABTB_MAGIC:
+	case XFS_ABTC_MAGIC:
+	case XFS_IBT_CRC_MAGIC:
+	case XFS_IBT_MAGIC:
+		return be64_to_cpu(
+				((struct xfs_btree_block *)blk)->bb_u.s.bb_lsn);
+	case XFS_BMAP_CRC_MAGIC:
+	case XFS_BMAP_MAGIC:
+		return be64_to_cpu(
+				((struct xfs_btree_block *)blk)->bb_u.l.bb_lsn);
+	case XFS_AGF_MAGIC:
+		return be64_to_cpu(((struct xfs_agf *)blk)->agf_lsn);
+	case XFS_AGFL_MAGIC:
+		return be64_to_cpu(((struct xfs_agfl *)blk)->agfl_lsn);
+	case XFS_AGI_MAGIC:
+		return be64_to_cpu(((struct xfs_agi *)blk)->agi_lsn);
+	case XFS_SYMLINK_MAGIC:
+		return be64_to_cpu(((struct xfs_dsymlink_hdr *)blk)->sl_lsn);
+	case XFS_DIR3_BLOCK_MAGIC:
+	case XFS_DIR3_DATA_MAGIC:
+	case XFS_DIR3_FREE_MAGIC:
+		return be64_to_cpu(((struct xfs_dir3_blk_hdr *)blk)->lsn);
+	case XFS_ATTR3_RMT_MAGIC:
+		return be64_to_cpu(((struct xfs_attr3_rmt_hdr *)blk)->rm_lsn);
+	case XFS_SB_MAGIC:
+		return be64_to_cpu(((struct xfs_sb *)blk)->sb_lsn);
+	default:
+		break;
+	}
+
+	magicda = be16_to_cpu(((struct xfs_da_blkinfo *)blk)->magic);
+	switch (magicda) {
+	case XFS_DIR3_LEAF1_MAGIC:
+	case XFS_DIR3_LEAFN_MAGIC:
+	case XFS_DA3_NODE_MAGIC:
+		return be64_to_cpu(((struct xfs_da3_blkinfo *)blk)->lsn);
+	default:
+		break;
+	}
+
+	/*
+	 * We do individual object checks on dquot and inode buffers as they
+	 * have their own individual LSN records. Also, we could have a stale
+	 * buffer here, so we have to at least recognise these buffer types.
+	 *
+	 * A notd complexity here is inode unlinked list processing - it logs
+	 * the inode directly in the buffer, but we don't know which inodes have
+	 * been modified, and there is no global buffer LSN. Hence we need to
+	 * recover all inode buffer types immediately. This problem will be
+	 * fixed by logical logging of the unlinked list modifications.
+	 */
+	magic16 = be16_to_cpu(*(__be16 *)blk);
+	switch (magic16) {
+	case XFS_DQUOT_MAGIC:
+	case XFS_DINODE_MAGIC:
+		goto recover_immediately;
+	default:
+		break;
+	}
+
+	/* unknown buffer contents, recover immediately */
+
+recover_immediately:
+	return (xfs_lsn_t)-1;
+
+}
+
+/*
  * Validate the recovered buffer is of the correct type and attach the
  * appropriate buffer operations to them for writeback. Magic numbers are in a
  * few places:
@@ -1967,7 +2065,7 @@ xlog_recover_do_inode_buffer(
  *	inside a struct xfs_da_blkinfo at the start of the buffer.
  */
 static void
-xlog_recovery_validate_buf_type(
+xlog_recover_validate_buf_type(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp,
 	xfs_buf_log_format_t	*buf_f)
@@ -2246,7 +2344,7 @@ xlog_recover_do_reg_buffer(
 	 * just avoid the verification stage for non-crc filesystems
 	 */
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		xlog_recovery_validate_buf_type(mp, bp, buf_f);
+		xlog_recover_validate_buf_type(mp, bp, buf_f);
 }
 
 /*
@@ -2444,13 +2542,15 @@ STATIC int
 xlog_recover_buffer_pass2(
 	struct xlog			*log,
 	struct list_head		*buffer_list,
-	struct xlog_recover_item	*item)
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			current_lsn)
 {
 	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
 	xfs_mount_t		*mp = log->l_mp;
 	xfs_buf_t		*bp;
 	int			error;
 	uint			buf_flags;
+	xfs_lsn_t		lsn;
 
 	/*
 	 * In this pass we only want to recover all the buffers which have
@@ -2475,10 +2575,17 @@ xlog_recover_buffer_pass2(
 	error = bp->b_error;
 	if (error) {
 		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#1)");
-		xfs_buf_relse(bp);
-		return error;
+		goto out_release;
 	}
 
+	/*
+	 * recover the buffer only if we get an LSN from it and it's less than
+	 * the lsn of the transaction we are replaying.
+	 */
+	lsn = xlog_recover_get_buf_lsn(mp, bp);
+	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0)
+		goto out_release;
+
 	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
 		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
 	} else if (buf_f->blf_flags &
@@ -2488,7 +2595,7 @@ xlog_recover_buffer_pass2(
 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f);
 	}
 	if (error)
-		return XFS_ERROR(error);
+		goto out_release;
 
 	/*
 	 * Perform delayed write on the buffer.  Asynchronous writes will be
@@ -2517,6 +2624,7 @@ xlog_recover_buffer_pass2(
 		xfs_buf_delwri_queue(bp, buffer_list);
 	}
 
+out_release:
 	xfs_buf_relse(bp);
 	return error;
 }
@@ -2525,7 +2633,8 @@ STATIC int
 xlog_recover_inode_pass2(
 	struct xlog			*log,
 	struct list_head		*buffer_list,
-	struct xlog_recover_item	*item)
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			current_lsn)
 {
 	xfs_inode_log_format_t	*in_f;
 	xfs_mount_t		*mp = log->l_mp;
@@ -2605,6 +2714,20 @@ xlog_recover_inode_pass2(
 	}
 
 	/*
+	 * If the inode has an LSN in it, recover the inode only if it's less
+	 * than the lsn of the transaction we are replaying.
+	 */
+	if (dip->di_version >= 3) {
+		xfs_lsn_t	lsn = be64_to_cpu(dip->di_lsn);
+
+		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
+			trace_xfs_log_recover_inode_skip(log, in_f);
+			error = 0;
+			goto out_release;
+		}
+	}
+
+	/*
 	 * di_flushiter is only valid for v1/2 inodes. All changes for v3 inodes
 	 * are transactional and if ordering is necessary we can determine that
 	 * more accurately by the LSN field in the V3 inode core. Don't trust
@@ -2793,6 +2916,8 @@ write_inode_buffer:
 	ASSERT(bp->b_target->bt_mount == mp);
 	bp->b_iodone = xlog_recover_iodone;
 	xfs_buf_delwri_queue(bp, buffer_list);
+
+out_release:
 	xfs_buf_relse(bp);
 error:
 	if (need_free)
@@ -2834,7 +2959,8 @@ STATIC int
 xlog_recover_dquot_pass2(
 	struct xlog			*log,
 	struct list_head		*buffer_list,
-	struct xlog_recover_item	*item)
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			current_lsn)
 {
 	xfs_mount_t		*mp = log->l_mp;
 	xfs_buf_t		*bp;
@@ -2908,6 +3034,19 @@ xlog_recover_dquot_pass2(
 		return XFS_ERROR(EIO);
 	}
 
+	/*
+	 * If the dquot has an LSN in it, recover the dquot only if it's less
+	 * than the lsn of the transaction we are replaying.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddq;
+		xfs_lsn_t	lsn = be64_to_cpu(dqb->dd_lsn);
+
+		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
+			goto out_release;
+		}
+	}
+
 	memcpy(ddq, recddq, item->ri_buf[1].i_len);
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
@@ -2918,9 +3057,10 @@ xlog_recover_dquot_pass2(
 	ASSERT(bp->b_target->bt_mount == mp);
 	bp->b_iodone = xlog_recover_iodone;
 	xfs_buf_delwri_queue(bp, buffer_list);
-	xfs_buf_relse(bp);
 
-	return (0);
+out_release:
+	xfs_buf_relse(bp);
+	return 0;
 }
 
 /*
@@ -3267,15 +3407,18 @@ xlog_recover_commit_pass2(
 
 	switch (ITEM_TYPE(item)) {
 	case XFS_LI_BUF:
-		return xlog_recover_buffer_pass2(log, buffer_list, item);
+		return xlog_recover_buffer_pass2(log, buffer_list, item,
+						 trans->r_lsn);
 	case XFS_LI_INODE:
-		return xlog_recover_inode_pass2(log, buffer_list, item);
+		return xlog_recover_inode_pass2(log, buffer_list, item,
+						 trans->r_lsn);
 	case XFS_LI_EFI:
 		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
 	case XFS_LI_EFD:
 		return xlog_recover_efd_pass2(log, item);
 	case XFS_LI_DQUOT:
-		return xlog_recover_dquot_pass2(log, buffer_list, item);
+		return xlog_recover_dquot_pass2(log, buffer_list, item,
+						trans->r_lsn);
 	case XFS_LI_ICREATE:
 		return xlog_recover_do_icreate_pass2(log, buffer_list, item);
 	case XFS_LI_QUOTAOFF:
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
