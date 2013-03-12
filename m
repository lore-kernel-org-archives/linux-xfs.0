Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD14A7F83
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:31:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79121304048
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:31:04 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	fBt2FCYpEzfDwqEJ for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 05:31:02 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UFOM6-0001Rl-8R
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:30:58 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UFOM6-0002M8-58
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:30:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/21] xfs: add CRC checks to the AGI
Date: Tue, 12 Mar 2013 23:30:40 +1100
Message-Id: <1363091454-8852-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1363091454-8852-1-git-send-email-david@fromorbit.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dgc@sgi.com>

Same set of changes made to the AGF need to be made to the AGI.
This patch has a similar history to the AGF, hence a similar
sign-off chain.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dgc@redhat.com>
---
 fs/xfs/xfs_ag.h          |    8 +++++++
 fs/xfs/xfs_buf_item.h    |    4 +++-
 fs/xfs/xfs_fsops.c       |    3 +++
 fs/xfs/xfs_ialloc.c      |   57 ++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_log_recover.c |    8 +++++++
 5 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 272ef09..317aa86 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -152,6 +152,7 @@ typedef struct xfs_agi {
 	__be32		agi_root;	/* root of inode btree */
 	__be32		agi_level;	/* levels in inode btree */
 	__be32		agi_freecount;	/* number of free inodes */
+
 	__be32		agi_newino;	/* new inode just allocated */
 	__be32		agi_dirino;	/* last directory inode chunk */
 	/*
@@ -159,6 +160,13 @@ typedef struct xfs_agi {
 	 * still being referenced.
 	 */
 	__be32		agi_unlinked[XFS_AGI_UNLINKED_BUCKETS];
+
+	uuid_t		agi_uuid;	/* uuid of filesystem */
+	__be32		agi_crc;	/* crc of agi sector */
+	__be32		agi_pad32;
+	__be64		agi_lsn;	/* last write sequence */
+
+	/* structure must be padded to 64 bit alignment */
 } xfs_agi_t;
 
 #define	XFS_AGI_MAGICNUM	0x00000001
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 067d5f0..c256606 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -47,6 +47,7 @@ extern kmem_zone_t	*xfs_buf_item_zone;
 #define XFS_BLF_BTREE_BUF	(1<<5)
 #define XFS_BLF_AGF_BUF		(1<<6)
 #define XFS_BLF_AGFL_BUF	(1<<7)
+#define XFS_BLF_AGI_BUF		(1<<8)
 
 #define XFS_BLF_TYPE_MASK	\
 		(XFS_BLF_UDQUOT_BUF | \
@@ -54,7 +55,8 @@ extern kmem_zone_t	*xfs_buf_item_zone;
 		 XFS_BLF_GDQUOT_BUF | \
 		 XFS_BLF_BTREE_BUF | \
 		 XFS_BLF_AGF_BUF | \
-		 XFS_BLF_AGFL_BUF)
+		 XFS_BLF_AGFL_BUF | \
+		 XFS_BLF_AGI_BUF)
 
 #define	XFS_BLF_CHUNK		128
 #define	XFS_BLF_SHIFT		7
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index a693a54..87595b2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -304,8 +304,11 @@ xfs_growfs_data_private(
 		agi->agi_freecount = 0;
 		agi->agi_newino = cpu_to_be32(NULLAGINO);
 		agi->agi_dirino = cpu_to_be32(NULLAGINO);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
 		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
 			agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
+
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
 		if (error)
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index ba62661..6d0a495 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -36,6 +36,8 @@
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_bmap.h"
+#include "xfs_cksum.h"
+#include "xfs_buf_item.h"
 
 
 /*
@@ -1453,6 +1455,7 @@ xfs_ialloc_log_agi(
 	/*
 	 * Log the allocation group inode header buffer.
 	 */
+	xfs_trans_buf_set_type(tp, bp, XFS_BLF_AGI_BUF);
 	xfs_trans_log_buf(tp, bp, first, last);
 }
 
@@ -1470,19 +1473,23 @@ xfs_check_agi_unlinked(
 #define xfs_check_agi_unlinked(agi)
 #endif
 
-static void
+static bool
 xfs_agi_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
-	int		agi_ok;
 
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_uuid))
+			return false;
 	/*
 	 * Validate the magic number of the agi block.
 	 */
-	agi_ok = agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC) &&
-		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum));
+	if (agi->agi_magicnum != cpu_to_be32(XFS_AGI_MAGIC))
+		return false;
+	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
+		return false;
 
 	/*
 	 * during growfs operations, the perag is not fully initialised,
@@ -1490,30 +1497,52 @@ xfs_agi_verify(
 	 * use it by using uncached buffers that don't have the perag attached
 	 * so we can detect and avoid this problem.
 	 */
-	if (bp->b_pag)
-		agi_ok = agi_ok && be32_to_cpu(agi->agi_seqno) ==
-						bp->b_pag->pag_agno;
+	if (bp->b_pag && be32_to_cpu(agi->agi_seqno) != bp->b_pag->pag_agno)
+		return false;
 
-	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
-			XFS_RANDOM_IALLOC_READ_AGI))) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, agi);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
 	xfs_check_agi_unlinked(agi);
+	return true;
 }
 
 static void
 xfs_agi_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_agi_verify(bp);
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	int		agi_ok = 1;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		agi_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+					  offsetof(struct xfs_agi, agi_crc));
+	agi_ok = agi_ok && xfs_agi_verify(bp);
+
+	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
+			XFS_RANDOM_IALLOC_READ_AGI))) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
 }
 
 static void
 xfs_agi_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_agi_verify(bp);
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+
+	if (!xfs_agi_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (bip)
+		XFS_BUF_TO_AGI(bp)->agi_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
+			 offsetof(struct xfs_agi, agi_crc));
 }
 
 const struct xfs_buf_ops xfs_agi_buf_ops = {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8fefbc5..8f70c4e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1971,6 +1971,14 @@ xlog_recover_do_reg_buffer(
 		}
 		bp->b_ops = &xfs_agfl_buf_ops;
 		break;
+	case XFS_BLF_AGI_BUF:
+		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_AGI_MAGIC)) {
+			xfs_warn(mp, "Bad AGI block magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_agi_buf_ops;
+		break;
 	default:
 		break;
 	}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
