Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39666 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757158AbdLWBOE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:14:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN1CS7k079597
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:03 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2f1cvd81df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:03 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBN18pfH030771
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:08:51 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN18p2N006636
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:08:51 GMT
Subject: [PATCH 17/20] xfs: separate dquot repair into a separate function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:08:50 -0800
Message-ID: <151399133030.23543.13471674725718289527.stgit@magnolia>
In-Reply-To: <151399122361.23543.15718507168231759645.stgit@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the dquot repair code into a separate function and remove
XFS_QMOPT_DQREPAIR in favor of calling the helper directly.  Remove
other dead code because quotacheck is the only caller of DQREPAIR.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |   22 +++++++++++-----
 fs/xfs/libxfs/xfs_quota_defs.h |    3 +-
 fs/xfs/xfs_dquot.c             |   54 ----------------------------------------
 fs/xfs/xfs_qm.c                |    7 ++++-
 4 files changed, 22 insertions(+), 64 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index f8b62fc..6b15c50 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -51,7 +51,6 @@ xfs_dqcheck(
 	uint		 flags,
 	const char	 *str)
 {
-	xfs_dqblk_t	 *d = (xfs_dqblk_t *)ddq;
 	int		errs = 0;
 
 	/*
@@ -139,17 +138,26 @@ xfs_dqcheck(
 		}
 	}
 
-	if (!errs || !(flags & XFS_QMOPT_DQREPAIR))
-		return errs;
+	return errs;
+}
+
+/*
+ * Do some primitive error checking on ondisk dquot data structures.
+ */
+int
+xfs_dquot_repair(
+	struct xfs_mount	*mp,
+	struct xfs_disk_dquot	*ddq,
+	xfs_dqid_t		id,
+	uint			type)
+{
+	struct xfs_dqblk	*d = (struct xfs_dqblk *)ddq;
 
-	if (flags & XFS_QMOPT_DOWARN)
-		xfs_notice(mp, "Re-initializing dquot ID 0x%x", id);
 
 	/*
 	 * Typically, a repair is only requested by quotacheck.
 	 */
 	ASSERT(id != -1);
-	ASSERT(flags & XFS_QMOPT_DQREPAIR);
 	memset(d, 0, sizeof(xfs_dqblk_t));
 
 	d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
@@ -163,7 +171,7 @@ xfs_dqcheck(
 				 XFS_DQUOT_CRC_OFF);
 	}
 
-	return errs;
+	return 0;
 }
 
 STATIC bool
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index d69c772..7187ec9 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -113,7 +113,6 @@ typedef uint16_t	xfs_qwarncnt_t;
 #define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
 #define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
 #define XFS_QMOPT_DOWARN        0x0000400 /* increase warning cnt if needed */
-#define XFS_QMOPT_DQREPAIR	0x0001000 /* repair dquot if damaged */
 #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
 #define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
 #define XFS_QMOPT_DQNEXT	0x0008000 /* return next dquot >= this ID */
@@ -156,5 +155,7 @@ typedef uint16_t	xfs_qwarncnt_t;
 extern int xfs_dqcheck(struct xfs_mount *mp, xfs_disk_dquot_t *ddq,
 		       xfs_dqid_t id, uint type, uint flags, const char *str);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
+extern int xfs_dquot_repair(struct xfs_mount *mp, struct xfs_disk_dquot *ddq,
+		xfs_dqid_t id, uint type);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f248708..0d8c52b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -399,52 +399,6 @@ xfs_qm_dqalloc(
 	return error;
 }
 
-STATIC int
-xfs_qm_dqrepair(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	struct xfs_dquot	*dqp,
-	xfs_dqid_t		firstid,
-	struct xfs_buf		**bpp)
-{
-	int			error;
-	struct xfs_disk_dquot	*ddq;
-	struct xfs_dqblk	*d;
-	int			i;
-
-	/*
-	 * Read the buffer without verification so we get the corrupted
-	 * buffer returned to us. make sure we verify it on write, though.
-	 */
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen,
-				   0, bpp, NULL);
-
-	if (error) {
-		ASSERT(*bpp == NULL);
-		return error;
-	}
-	(*bpp)->b_ops = &xfs_dquot_buf_ops;
-
-	ASSERT(xfs_buf_islocked(*bpp));
-	d = (struct xfs_dqblk *)(*bpp)->b_addr;
-
-	/* Do the actual repair of dquots in this buffer */
-	for (i = 0; i < mp->m_quotainfo->qi_dqperchunk; i++) {
-		ddq = &d[i].dd_diskdq;
-		error = xfs_dqcheck(mp, ddq, firstid + i,
-				       dqp->dq_flags & XFS_DQ_ALLTYPES,
-				       XFS_QMOPT_DQREPAIR, "xfs_qm_dqrepair");
-		if (error) {
-			/* repair failed, we're screwed */
-			xfs_trans_brelse(tp, *bpp);
-			return -EIO;
-		}
-	}
-
-	return 0;
-}
-
 /*
  * Maps a dquot to the buffer containing its on-disk version.
  * This returns a ptr to the buffer containing the on-disk dquot
@@ -526,14 +480,6 @@ xfs_qm_dqtobp(
 					   dqp->q_blkno,
 					   mp->m_quotainfo->qi_dqchunklen,
 					   0, &bp, &xfs_dquot_buf_ops);
-
-		if (error == -EFSCORRUPTED && (flags & XFS_QMOPT_DQREPAIR)) {
-			xfs_dqid_t firstid = (xfs_dqid_t)map.br_startoff *
-						mp->m_quotainfo->qi_dqperchunk;
-			ASSERT(bp == NULL);
-			error = xfs_qm_dqrepair(mp, tp, dqp, firstid, &bp);
-		}
-
 		if (error) {
 			ASSERT(bp == NULL);
 			return error;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ec952df..407a12b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -847,6 +847,7 @@ xfs_qm_reset_dqcounts(
 {
 	struct xfs_dqblk	*dqb;
 	int			j;
+	int			error;
 
 	trace_xfs_reset_dqcounts(bp, _RET_IP_);
 
@@ -870,8 +871,10 @@ xfs_qm_reset_dqcounts(
 		 * output any warnings because it's perfectly possible to
 		 * find uninitialised dquot blks. See comment in xfs_dqcheck.
 		 */
-		xfs_dqcheck(mp, ddq, id+j, type, XFS_QMOPT_DQREPAIR,
-			    "xfs_quotacheck");
+		error = xfs_dqcheck(mp, ddq, id+j, type, 0, "xfs_quotacheck");
+		if (error)
+			xfs_dquot_repair(mp, ddq, id + j, type);
+
 		/*
 		 * Reset type in case we are reusing group quota file for
 		 * project quotas or vice versa

