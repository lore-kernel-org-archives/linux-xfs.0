Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B1A729E18
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 00:29:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6D0728F8040
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 22:29:26 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	MvzJEoeKpRK8bNN2 for <xfs@oss.sgi.com>;
	Sun, 02 Jun 2013 22:29:24 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] xfs: rework dquot CRCs
Date: Mon,  3 Jun 2013 15:28:46 +1000
Message-Id: <1370237332-24757-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1370237332-24757-1-git-send-email-david@fromorbit.com>
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

From: Dave Chinner <dchinner@redhat.com>

Calculating dquot CRCs when the backing buffer is written back just
doesn't work reliably. There are several places which manipulate
dquots directly in the buffers, and they don't calculate CRCs
appropriately, nor do they always set the buffer up to calculate
CRCs appropriately.

Firstly, if we log a dquot buffer (e.g. during allocation) it gets
logged without valid CRC, and so on recovery we end up with a dquot
that is not valid.

Secondly, if we recover/repair a dquot, we don't have a verifier
attached to the buffer and hence CRCs arenot calculate don the way
down to disk.

Thirdly, calculating the CRC after we've changed the contents means
that if we re-read the dquot from the buffer, we cannot verify the
contents of the dquot are valid, as the CRC is invalid.

So, to avoid all the dquot CRC errors that are being detected by the
read verifier, change to using the same model as for inodes. that
is, dquot CRCs are calculated and written to the backing buffer at
the time the dquot is flushed to the backing buffer. If we modify
the dquuot directly in the backing buffer, calculate the CRC
immediately after the modification is complete. Hence the dquot in
the on-disk buffer should always have a valid CRC.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c       |   37 ++++++++++++++++---------------------
 fs/xfs/xfs_log_recover.c |   10 ++++++++++
 fs/xfs/xfs_qm.c          |   40 ++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_quota.h       |    2 ++
 4 files changed, 58 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a41f8bf..044e97a 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -249,8 +249,11 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
 		d->dd_diskdq.d_flags = type;
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_uuid);
+			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
+					 XFS_DQUOT_CRC_OFF);
+		}
 	}
 
 	xfs_trans_dquot_buf(tp, bp,
@@ -286,23 +289,6 @@ xfs_dquot_set_prealloc_limits(struct xfs_dquot *dqp)
 	dqp->q_low_space[XFS_QLOWSP_5_PCNT] = space * 5;
 }
 
-STATIC void
-xfs_dquot_buf_calc_crc(
-	struct xfs_mount	*mp,
-	struct xfs_buf		*bp)
-{
-	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
-	int			i;
-
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return;
-
-	for (i = 0; i < mp->m_quotainfo->qi_dqperchunk; i++, d++) {
-		xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
-				 offsetof(struct xfs_dqblk, dd_crc));
-	}
-}
-
 STATIC bool
 xfs_dquot_buf_verify_crc(
 	struct xfs_mount	*mp,
@@ -328,12 +314,11 @@ xfs_dquot_buf_verify_crc(
 
 	for (i = 0; i < ndquots; i++, d++) {
 		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
-				 offsetof(struct xfs_dqblk, dd_crc)))
+				 XFS_DQUOT_CRC_OFF))
 			return false;
 		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_uuid))
 			return false;
 	}
-
 	return true;
 }
 
@@ -393,6 +378,11 @@ xfs_dquot_buf_read_verify(
 	}
 }
 
+/*
+ * we don't calculate the CRC here as that is done when the dquot is flushed to
+ * the buffer after the update is done. This ensures that the dquot in the
+ * buffer always has an up-to-date CRC value.
+ */
 void
 xfs_dquot_buf_write_verify(
 	struct xfs_buf	*bp)
@@ -404,7 +394,6 @@ xfs_dquot_buf_write_verify(
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 		return;
 	}
-	xfs_dquot_buf_calc_crc(mp, bp);
 }
 
 const struct xfs_buf_ops xfs_dquot_buf_ops = {
@@ -1151,11 +1140,17 @@ xfs_qm_dqflush(
 	 * copy the lsn into the on-disk dquot now while we have the in memory
 	 * dquot here. This can't be done later in the write verifier as we
 	 * can't get access to the log item at that point in time.
+	 *
+	 * We also calculate the CRC here so that the on-disk dquot in the
+	 * buffer always has a valid CRC. This ensures there is no possibility
+	 * of a dquot without an up-to-date CRC getting to disk.
 	 */
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_dqblk *dqb = (struct xfs_dqblk *)ddqp;
 
 		dqb->dd_lsn = cpu_to_be64(dqp->q_logitem.qli_item.li_lsn);
+		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
+				 XFS_DQUOT_CRC_OFF);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d9e4d3c..d6204d1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2266,6 +2266,12 @@ xfs_qm_dqcheck(
 	d->dd_diskdq.d_flags = type;
 	d->dd_diskdq.d_id = cpu_to_be32(id);
 
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		uuid_copy(&d->dd_uuid, &mp->m_sb.sb_uuid);
+		xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
+				 XFS_DQUOT_CRC_OFF);
+	}
+
 	return errs;
 }
 
@@ -2793,6 +2799,10 @@ xlog_recover_dquot_pass2(
 	}
 
 	memcpy(ddq, recddq, item->ri_buf[1].i_len);
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		xfs_update_cksum((char *)ddq, sizeof(struct xfs_dqblk),
+				 XFS_DQUOT_CRC_OFF);
+	}
 
 	ASSERT(dq_f->qlf_size == 2);
 	ASSERT(bp->b_target->bt_mount == mp);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f41702b..b75c9bb 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -41,6 +41,7 @@
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_cksum.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -839,7 +840,7 @@ xfs_qm_reset_dqcounts(
 	xfs_dqid_t	id,
 	uint		type)
 {
-	xfs_disk_dquot_t	*ddq;
+	struct xfs_dqblk	*dqb;
 	int			j;
 
 	trace_xfs_reset_dqcounts(bp, _RET_IP_);
@@ -853,8 +854,12 @@ xfs_qm_reset_dqcounts(
 	do_div(j, sizeof(xfs_dqblk_t));
 	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
 #endif
-	ddq = bp->b_addr;
+	dqb = bp->b_addr;
 	for (j = 0; j < mp->m_quotainfo->qi_dqperchunk; j++) {
+		struct xfs_disk_dquot	*ddq;
+
+		ddq = (struct xfs_disk_dquot *)&dqb[j];
+
 		/*
 		 * Do a sanity check, and if needed, repair the dqblk. Don't
 		 * output any warnings because it's perfectly possible to
@@ -871,7 +876,12 @@ xfs_qm_reset_dqcounts(
 		ddq->d_bwarns = 0;
 		ddq->d_iwarns = 0;
 		ddq->d_rtbwarns = 0;
-		ddq = (xfs_disk_dquot_t *) ((xfs_dqblk_t *)ddq + 1);
+
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			xfs_update_cksum((char *)&dqb[j],
+					 sizeof(struct xfs_dqblk),
+					 XFS_DQUOT_CRC_OFF);
+		}
 	}
 }
 
@@ -907,19 +917,29 @@ xfs_qm_dqiter_bufs(
 			      XFS_FSB_TO_DADDR(mp, bno),
 			      mp->m_quotainfo->qi_dqchunklen, 0, &bp,
 			      &xfs_dquot_buf_ops);
-		if (error)
-			break;
 
 		/*
-		 * XXX(hch): need to figure out if it makes sense to validate
-		 *	     the CRC here.
+		 * CRC and validation errors will return a EFSCORRUPTED here. If
+		 * this occurs, re-read without CRC validation so that we can
+		 * repair the damage via xfs_qm_reset_dqcounts(). This process
+		 * will leave a trace in the log indicating corruption has
+		 * been detected.
 		 */
+		if (error == EFSCORRUPTED) {
+			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
+				      XFS_FSB_TO_DADDR(mp, bno),
+				      mp->m_quotainfo->qi_dqchunklen, 0, &bp,
+				      NULL);
+		}
+
+		if (error)
+			break;
+
 		xfs_qm_reset_dqcounts(mp, bp, firstid, type);
 		xfs_buf_delwri_queue(bp, buffer_list);
 		xfs_buf_relse(bp);
-		/*
-		 * goto the next block.
-		 */
+
+		/* goto the next block. */
 		bno++;
 		firstid += mp->m_quotainfo->qi_dqperchunk;
 	}
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index c61e31c..c38068f 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -87,6 +87,8 @@ typedef struct xfs_dqblk {
 	uuid_t		  dd_uuid;	/* location information */
 } xfs_dqblk_t;
 
+#define XFS_DQUOT_CRC_OFF	offsetof(struct xfs_dqblk, dd_crc)
+
 /*
  * flags for q_flags field in the dquot.
  */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
