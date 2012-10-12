Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9C5ic3M072565 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 00:44:39 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qPwMTpMgL11dLZbU for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 22:46:09 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TMY3I-0003Zc-AN
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:52 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TMY37-00056Q-OE
	for xfs@oss.sgi.com; Fri, 12 Oct 2012 16:44:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/23] xfs: verify dquot blocks as they are read from disk
Date: Fri, 12 Oct 2012 16:44:17 +1100
Message-Id: <1350020669-19504-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1350020669-19504-1-git-send-email-david@fromorbit.com>
References: <1350020669-19504-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Add a dquot buffer verify callback function and pass it into the
buffer read functions. This checks all the dquots in a buffer, but
cannot completely verify the dquot ids are correct. Also, errors
cannot be repaired, so an additional function is added to repair bad
dquots in the buffer if such an error is detected in a context where
repair is allowed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c |  117 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 95 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index e95f800..2e18382 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -360,6 +360,89 @@ xfs_qm_dqalloc(
 	return (error);
 }
 
+STATIC void
+xfs_dquot_read_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
+	struct xfs_disk_dquot	*ddq;
+	xfs_dqid_t		id = 0;
+	int			i;
+
+	/*
+	 * On the first read of the buffer, verify that each dquot is valid.
+	 * We don't know what the id of the dquot is supposed to be, just that
+	 * they should be increasing monotonically within the buffer. If the
+	 * first id is corrupt, then it will fail on the second dquot in the
+	 * buffer so corruptions could point to the wrong dquot in this case.
+	 */
+	for (i = 0; i < mp->m_quotainfo->qi_dqperchunk; i++) {
+		int	error;
+
+		ddq = &d[i].dd_diskdq;
+
+		if (i == 0)
+			id = be32_to_cpu(ddq->d_id);
+
+		error = xfs_qm_dqcheck(mp, ddq, id + i, 0, XFS_QMOPT_DOWARN,
+					"xfs_dquot_read_verify");
+		if (error) {
+			XFS_CORRUPTION_ERROR("xfs_dquot_read_verify",
+					     XFS_ERRLEVEL_LOW, mp, d);
+			xfs_buf_ioerror(bp, EFSCORRUPTED);
+			break;
+		}
+	}
+	bp->b_iodone = NULL;
+	xfs_buf_ioend(bp, 0);
+}
+
+STATIC int
+xfs_qm_dqrepair(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*dqp,
+	xfs_dqid_t		firstid,
+	struct xfs_buf		**bpp)
+{
+	int			error;
+	struct xfs_disk_dquot	*ddq;
+	struct xfs_dqblk	*d;
+	int			i;
+
+	/*
+	 * Read the buffer without verification so we get the corrupted
+	 * buffer returned to us.
+	 */
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, dqp->q_blkno,
+				   mp->m_quotainfo->qi_dqchunklen,
+				   0, bpp, NULL);
+
+	if (error) {
+		ASSERT(*bpp == NULL);
+		return XFS_ERROR(error);
+	}
+
+	ASSERT(xfs_buf_islocked(*bpp));
+	d = (struct xfs_dqblk *)(*bpp)->b_addr;
+
+	/* Do the actual repair of dquots in this buffer */
+	for (i = 0; i < mp->m_quotainfo->qi_dqperchunk; i++) {
+		ddq = &d[i].dd_diskdq;
+		error = xfs_qm_dqcheck(mp, ddq, firstid + i,
+				       dqp->dq_flags & XFS_DQ_ALLTYPES,
+				       XFS_QMOPT_DQREPAIR, "xfs_qm_dqrepair");
+		if (error) {
+			/* repair failed, we're screwed */
+			xfs_trans_brelse(tp, *bpp);
+			return XFS_ERROR(EIO);
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Maps a dquot to the buffer containing its on-disk version.
  * This returns a ptr to the buffer containing the on-disk dquot
@@ -378,7 +461,6 @@ xfs_qm_dqtobp(
 	xfs_buf_t	*bp;
 	xfs_inode_t	*quotip = XFS_DQ_TO_QIP(dqp);
 	xfs_mount_t	*mp = dqp->q_mount;
-	xfs_disk_dquot_t *ddq;
 	xfs_dqid_t	id = be32_to_cpu(dqp->q_core.d_id);
 	xfs_trans_t	*tp = (tpp ? *tpp : NULL);
 
@@ -439,33 +521,24 @@ xfs_qm_dqtobp(
 		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 					   dqp->q_blkno,
 					   mp->m_quotainfo->qi_dqchunklen,
-					   0, &bp, NULL);
-		if (error || !bp)
-			return XFS_ERROR(error);
-	}
+					   0, &bp, xfs_dquot_read_verify);
 
-	ASSERT(xfs_buf_islocked(bp));
-
-	/*
-	 * calculate the location of the dquot inside the buffer.
-	 */
-	ddq = bp->b_addr + dqp->q_bufoffset;
+		if (error == EFSCORRUPTED && (flags & XFS_QMOPT_DQREPAIR)) {
+			xfs_dqid_t firstid = (xfs_dqid_t)map.br_startoff *
+						mp->m_quotainfo->qi_dqperchunk;
+			ASSERT(bp == NULL);
+			error = xfs_qm_dqrepair(mp, tp, dqp, firstid, &bp);
+		}
 
-	/*
-	 * A simple sanity check in case we got a corrupted dquot...
-	 */
-	error = xfs_qm_dqcheck(mp, ddq, id, dqp->dq_flags & XFS_DQ_ALLTYPES,
-			   flags & (XFS_QMOPT_DQREPAIR|XFS_QMOPT_DOWARN),
-			   "dqtobp");
-	if (error) {
-		if (!(flags & XFS_QMOPT_DQREPAIR)) {
-			xfs_trans_brelse(tp, bp);
-			return XFS_ERROR(EIO);
+		if (error) {
+			ASSERT(bp == NULL);
+			return XFS_ERROR(error);
 		}
 	}
 
+	ASSERT(xfs_buf_islocked(bp));
 	*O_bpp = bp;
-	*O_ddpp = ddq;
+	*O_ddpp = bp->b_addr + dqp->q_bufoffset;
 
 	return (0);
 }
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
