Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F2F797F9F
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:31:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72352AC002
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:31:14 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	uBOf1Z693WoDHoH4 for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 05:31:12 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UFOMG-0001Ro-9e
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:31:08 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UFOM6-0002MB-62
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:30:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/21] xfs: add CRC checks for quota blocks
Date: Tue, 12 Mar 2013 23:30:41 +1100
Message-Id: <1363091454-8852-9-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@lst.de>

Use the reserved space in struct xfs_dqblk to store a UUID and a crc
for the quota blocks.

[dchinner@redhat.com] Add a LSN field and update for current verifier
infrastructure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c       |  112 ++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_log_recover.c |   10 +++++
 fs/xfs/xfs_qm.c          |   23 ++++++++--
 fs/xfs/xfs_qm.h          |    2 +
 fs/xfs/xfs_quota.h       |   11 ++++-
 5 files changed, 141 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8025eb2..aedf29c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -36,6 +36,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
+#include "xfs_cksum.h"
 #include "xfs_trace.h"
 
 /*
@@ -239,6 +240,8 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
 		d->dd_diskdq.d_flags = type;
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_uuid);
 	}
 
 	xfs_trans_dquot_buf(tp, bp,
@@ -248,25 +251,87 @@ xfs_qm_init_dquot_blk(
 	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
 }
 
-static void
+STATIC void
+xfs_dquot_buf_calc_crc(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
+	int			i;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	for (i = 0; i < mp->m_quotainfo->qi_dqperchunk; i++, d++) {
+		xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
+				 offsetof(struct xfs_dqblk, dd_crc));
+	}
+}
+
+STATIC bool
+xfs_dquot_buf_verify_crc(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
+	int			ndquots;
+	int			i;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return true;
+
+	/*
+	 * if we are in log recovery, the quota subsystem has not been
+	 * initialised so we have no quotainfo structure. In that case, we need
+	 * to manually calculate the number of dquots in the buffer.
+	 */
+	if (mp->m_quotainfo)
+		ndquots = mp->m_quotainfo->qi_dqperchunk;
+	else
+		ndquots = xfs_qm_calc_dquots_per_chunk(mp,
+					XFS_BB_TO_FSB(mp, bp->b_length));
+
+	for (i = 0; i < ndquots; i++, d++) {
+		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
+				 offsetof(struct xfs_dqblk, dd_crc)))
+			return false;
+		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_uuid))
+			return false;
+	}
+
+	return true;
+}
+
+STATIC bool
 xfs_dquot_buf_verify(
+	struct xfs_mount	*mp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
-	struct xfs_disk_dquot	*ddq;
 	xfs_dqid_t		id = 0;
+	int			ndquots;
 	int			i;
 
 	/*
+	 * if we are in log recovery, the quota subsystem has not been
+	 * initialised so we have no quotainfo structure. In that case, we need
+	 * to manually calculate the number of dquots in the buffer.
+	 */
+	if (mp->m_quotainfo)
+		ndquots = mp->m_quotainfo->qi_dqperchunk;
+	else
+		ndquots = xfs_qm_calc_dquots_per_chunk(mp, bp->b_length);
+
+	/*
 	 * On the first read of the buffer, verify that each dquot is valid.
 	 * We don't know what the id of the dquot is supposed to be, just that
 	 * they should be increasing monotonically within the buffer. If the
 	 * first id is corrupt, then it will fail on the second dquot in the
 	 * buffer so corruptions could point to the wrong dquot in this case.
 	 */
-	for (i = 0; i < mp->m_quotainfo->qi_dqperchunk; i++) {
-		int	error;
+	for (i = 0; i < ndquots; i++) {
+		struct xfs_disk_dquot	*ddq;
+		int			error;
 
 		ddq = &d[i].dd_diskdq;
 
@@ -274,27 +339,37 @@ xfs_dquot_buf_verify(
 			id = be32_to_cpu(ddq->d_id);
 
 		error = xfs_qm_dqcheck(mp, ddq, id + i, 0, XFS_QMOPT_DOWARN,
-					"xfs_dquot_read_verify");
-		if (error) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, d);
-			xfs_buf_ioerror(bp, EFSCORRUPTED);
-			break;
-		}
+				       "xfs_dquot_buf_verify");
+		if (error)
+			return false;
 	}
+	return true;
 }
 
 static void
 xfs_dquot_buf_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_dquot_buf_verify(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (!xfs_dquot_buf_verify_crc(mp, bp) || !xfs_dquot_buf_verify(mp, bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
 }
 
 void
 xfs_dquot_buf_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_dquot_buf_verify(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+
+	if (!xfs_dquot_buf_verify(mp, bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+	xfs_dquot_buf_calc_crc(mp, bp);
 }
 
 const struct xfs_buf_ops xfs_dquot_buf_ops = {
@@ -1035,6 +1110,17 @@ xfs_qm_dqflush(
 					&dqp->q_logitem.qli_item.li_lsn);
 
 	/*
+	 * copy the lsn into the on-disk dquot now while we have the in memory
+	 * dquot here. This can't be done later in the write verifier as we
+	 * can't get access to the log item at that point in time.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddqp;
+
+		dqb->dd_lsn = cpu_to_be64(dqp->q_logitem.qli_item.li_lsn);
+	}
+
+	/*
 	 * Attach an iodone routine so that we can remove this dquot from the
 	 * AIL and release the flush lock once the dquot is synced to disk.
 	 */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8f70c4e..d750c34 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1979,6 +1979,16 @@ xlog_recover_do_reg_buffer(
 		}
 		bp->b_ops = &xfs_agi_buf_ops;
 		break;
+	case XFS_BLF_UDQUOT_BUF:
+	case XFS_BLF_PDQUOT_BUF:
+	case XFS_BLF_GDQUOT_BUF:
+		if (*(__be16 *)bp->b_addr != cpu_to_be16(XFS_DQUOT_MAGIC)) {
+			xfs_warn(mp, "Bad DQUOT block magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_dquot_buf_ops;
+		break;
 	default:
 		break;
 	}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e5b5cf9..9d00500 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -617,6 +617,20 @@ xfs_qm_dqdetach(
 	}
 }
 
+int
+xfs_qm_calc_dquots_per_chunk(
+	struct xfs_mount	*mp,
+	unsigned int		nbblks)	/* basic block units */
+{
+	unsigned int	ndquots;
+
+	ASSERT(nbblks > 0);
+	ndquots = BBTOB(nbblks);
+	do_div(ndquots, sizeof(xfs_dqblk_t));
+
+	return ndquots;
+}
+
 /*
  * This initializes all the quota information that's kept in the
  * mount structure
@@ -656,9 +670,8 @@ xfs_qm_init_quotainfo(
 
 	/* Precalc some constants */
 	qinf->qi_dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
-	ASSERT(qinf->qi_dqchunklen);
-	qinf->qi_dqperchunk = BBTOB(qinf->qi_dqchunklen);
-	do_div(qinf->qi_dqperchunk, sizeof(xfs_dqblk_t));
+	qinf->qi_dqperchunk = xfs_qm_calc_dquots_per_chunk(mp,
+							qinf->qi_dqchunklen);
 
 	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
 
@@ -897,6 +910,10 @@ xfs_qm_dqiter_bufs(
 		if (error)
 			break;
 
+		/*
+		 * XXX(hch): need to figure out if it makes sense to validate
+		 *	     the CRC here.
+		 */
 		xfs_qm_reset_dqcounts(mp, bp, firstid, type);
 		xfs_buf_delwri_queue(bp, buffer_list);
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 44b858b..45d1656 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -75,6 +75,8 @@ typedef struct xfs_quotainfo {
 	 &((qi)->qi_gquota_tree))
 
 
+extern int	xfs_qm_calc_dquots_per_chunk(struct xfs_mount *mp,
+					     unsigned int nbblks);
 extern void	xfs_trans_mod_dquot(xfs_trans_t *, xfs_dquot_t *, uint, long);
 extern int	xfs_trans_reserve_quota_bydquots(xfs_trans_t *, xfs_mount_t *,
 			xfs_dquot_t *, xfs_dquot_t *, long, long, uint);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index b50ec5b..c61e31c 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -77,7 +77,14 @@ typedef struct	xfs_disk_dquot {
  */
 typedef struct xfs_dqblk {
 	xfs_disk_dquot_t  dd_diskdq;	/* portion that lives incore as well */
-	char		  dd_fill[32];	/* filling for posterity */
+	char		  dd_fill[4];	/* filling for posterity */
+
+	/*
+	 * These two are only present on filesystems with the CRC bits set.
+	 */
+	__be32		  dd_crc;	/* checksum */
+	__be64		  dd_lsn;	/* last modification in log */
+	uuid_t		  dd_uuid;	/* location information */
 } xfs_dqblk_t;
 
 /*
@@ -380,5 +387,7 @@ extern int xfs_qm_dqcheck(struct xfs_mount *, xfs_disk_dquot_t *,
 				xfs_dqid_t, uint, uint, char *);
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
+extern const struct xfs_buf_ops xfs_dquot_buf_ops;
+
 #endif	/* __KERNEL__ */
 #endif	/* __XFS_QUOTA_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
