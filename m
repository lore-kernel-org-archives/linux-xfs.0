Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40584 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757161AbdLWBOM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:14:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN1D1jc079788
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:11 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2f1cvd8210-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:09 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN18vtH022456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:08:58 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN18vqJ006651
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:08:57 GMT
Subject: [PATCH 18/20] xfs: standardize quota verification function outputs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:08:56 -0800
Message-ID: <151399133641.23543.18383563898958249777.stgit@magnolia>
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

Rename xfs_dqcheck to xfs_dquot_verify and make it return an
xfs_failaddr_t like every other structure verifier function.
This enables us to check on-disk quotas in the same way that we check
everything else.  Callers are now responsible for logging errors, as
XFS_QMOPT_DOWARN goes away.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |  142 ++++++++++++++--------------------------
 fs/xfs/libxfs/xfs_quota_defs.h |    6 +-
 fs/xfs/xfs_dquot.c             |    8 +-
 fs/xfs/xfs_log_recover.c       |   24 ++++---
 fs/xfs/xfs_qm.c                |   28 +++-----
 5 files changed, 86 insertions(+), 122 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 6b15c50..8b7a6c3 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -42,17 +42,14 @@ xfs_calc_dquots_per_chunk(
 /*
  * Do some primitive error checking on ondisk dquot data structures.
  */
-int
-xfs_dqcheck(
+xfs_failaddr_t
+xfs_dquot_verify(
 	struct xfs_mount *mp,
 	xfs_disk_dquot_t *ddq,
 	xfs_dqid_t	 id,
 	uint		 type,	  /* used only when IO_dorepair is true */
-	uint		 flags,
-	const char	 *str)
+	uint		 flags)
 {
-	int		errs = 0;
-
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
 	 * 1. If we crash while deleting the quotainode(s), and those blks got
@@ -68,77 +65,38 @@ xfs_dqcheck(
 	 * This is all fine; things are still consistent, and we haven't lost
 	 * any quota information. Just don't complain about bad dquot blks.
 	 */
-	if (ddq->d_magic != cpu_to_be16(XFS_DQUOT_MAGIC)) {
-		if (flags & XFS_QMOPT_DOWARN)
-			xfs_alert(mp,
-			"%s : XFS dquot ID 0x%x, magic 0x%x != 0x%x",
-			str, id, be16_to_cpu(ddq->d_magic), XFS_DQUOT_MAGIC);
-		errs++;
-	}
-	if (ddq->d_version != XFS_DQUOT_VERSION) {
-		if (flags & XFS_QMOPT_DOWARN)
-			xfs_alert(mp,
-			"%s : XFS dquot ID 0x%x, version 0x%x != 0x%x",
-			str, id, ddq->d_version, XFS_DQUOT_VERSION);
-		errs++;
-	}
+	if (ddq->d_magic != cpu_to_be16(XFS_DQUOT_MAGIC))
+		return __this_address;
+	if (ddq->d_version != XFS_DQUOT_VERSION)
+		return __this_address;
 
 	if (ddq->d_flags != XFS_DQ_USER &&
 	    ddq->d_flags != XFS_DQ_PROJ &&
-	    ddq->d_flags != XFS_DQ_GROUP) {
-		if (flags & XFS_QMOPT_DOWARN)
-			xfs_alert(mp,
-			"%s : XFS dquot ID 0x%x, unknown flags 0x%x",
-			str, id, ddq->d_flags);
-		errs++;
-	}
+	    ddq->d_flags != XFS_DQ_GROUP)
+		return __this_address;
 
-	if (id != -1 && id != be32_to_cpu(ddq->d_id)) {
-		if (flags & XFS_QMOPT_DOWARN)
-			xfs_alert(mp,
-			"%s : ondisk-dquot 0x%p, ID mismatch: "
-			"0x%x expected, found id 0x%x",
-			str, ddq, id, be32_to_cpu(ddq->d_id));
-		errs++;
-	}
+	if (id != -1 && id != be32_to_cpu(ddq->d_id))
+		return __this_address;
 
-	if (!errs && ddq->d_id) {
-		if (ddq->d_blk_softlimit &&
-		    be64_to_cpu(ddq->d_bcount) >
-				be64_to_cpu(ddq->d_blk_softlimit)) {
-			if (!ddq->d_btimer) {
-				if (flags & XFS_QMOPT_DOWARN)
-					xfs_alert(mp,
-			"%s : Dquot ID 0x%x (0x%p) BLK TIMER NOT STARTED",
-					str, (int)be32_to_cpu(ddq->d_id), ddq);
-				errs++;
-			}
-		}
-		if (ddq->d_ino_softlimit &&
-		    be64_to_cpu(ddq->d_icount) >
-				be64_to_cpu(ddq->d_ino_softlimit)) {
-			if (!ddq->d_itimer) {
-				if (flags & XFS_QMOPT_DOWARN)
-					xfs_alert(mp,
-			"%s : Dquot ID 0x%x (0x%p) INODE TIMER NOT STARTED",
-					str, (int)be32_to_cpu(ddq->d_id), ddq);
-				errs++;
-			}
-		}
-		if (ddq->d_rtb_softlimit &&
-		    be64_to_cpu(ddq->d_rtbcount) >
-				be64_to_cpu(ddq->d_rtb_softlimit)) {
-			if (!ddq->d_rtbtimer) {
-				if (flags & XFS_QMOPT_DOWARN)
-					xfs_alert(mp,
-			"%s : Dquot ID 0x%x (0x%p) RTBLK TIMER NOT STARTED",
-					str, (int)be32_to_cpu(ddq->d_id), ddq);
-				errs++;
-			}
-		}
-	}
+	if (!ddq->d_id)
+		return NULL;
 
-	return errs;
+	if (ddq->d_blk_softlimit &&
+	    be64_to_cpu(ddq->d_bcount) > be64_to_cpu(ddq->d_blk_softlimit) &&
+	    !ddq->d_btimer)
+		return __this_address;
+
+	if (ddq->d_ino_softlimit &&
+	    be64_to_cpu(ddq->d_icount) > be64_to_cpu(ddq->d_ino_softlimit) &&
+	    !ddq->d_itimer)
+		return __this_address;
+
+	if (ddq->d_rtb_softlimit &&
+	    be64_to_cpu(ddq->d_rtbcount) > be64_to_cpu(ddq->d_rtb_softlimit) &&
+	    !ddq->d_rtbtimer)
+		return __this_address;
+
+	return NULL;
 }
 
 /*
@@ -206,13 +164,13 @@ xfs_dquot_buf_verify_crc(
 	return true;
 }
 
-STATIC bool
+STATIC xfs_failaddr_t
 xfs_dquot_buf_verify(
 	struct xfs_mount	*mp,
-	struct xfs_buf		*bp,
-	int			warn)
+	struct xfs_buf		*bp)
 {
 	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
+	xfs_failaddr_t		fa;
 	xfs_dqid_t		id = 0;
 	int			ndquots;
 	int			i;
@@ -236,41 +194,43 @@ xfs_dquot_buf_verify(
 	 */
 	for (i = 0; i < ndquots; i++) {
 		struct xfs_disk_dquot	*ddq;
-		int			error;
 
 		ddq = &d[i].dd_diskdq;
 
 		if (i == 0)
 			id = be32_to_cpu(ddq->d_id);
 
-		error = xfs_dqcheck(mp, ddq, id + i, 0, warn, __func__);
-		if (error)
-			return false;
+		fa = xfs_dquot_verify(mp, ddq, id + i, 0, 0);
+		if (fa)
+			return fa;
 	}
-	return true;
+
+	return NULL;
 }
 
 static xfs_failaddr_t
 xfs_dquot_buf_verify_struct(
-	struct xfs_buf	*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (!xfs_dquot_buf_verify(mp, bp, 0))
-		return __this_address;
-	return NULL;
+	return xfs_dquot_buf_verify(mp, bp);
 }
 
 static void
 xfs_dquot_buf_read_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
 	if (!xfs_dquot_buf_verify_crc(mp, bp))
 		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
-	else if (!xfs_dquot_buf_verify(mp, bp, XFS_QMOPT_DOWARN))
-		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+	else {
+		fa = xfs_dquot_buf_verify(mp, bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+	}
 }
 
 /*
@@ -286,7 +246,7 @@ xfs_dquot_buf_readahead_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
 	if (!xfs_dquot_buf_verify_crc(mp, bp) ||
-	    !xfs_dquot_buf_verify(mp, bp, 0)) {
+	    xfs_dquot_buf_verify(mp, bp) != NULL) {
 		xfs_buf_ioerror(bp, -EIO);
 		bp->b_flags &= ~XBF_DONE;
 	}
@@ -299,14 +259,14 @@ xfs_dquot_buf_readahead_verify(
  */
 static void
 xfs_dquot_buf_write_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	xfs_failaddr_t		fa;
 
-	if (!xfs_dquot_buf_verify(mp, bp, XFS_QMOPT_DOWARN)) {
+	fa = xfs_dquot_buf_verify(mp, bp);
+	if (fa)
 		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
-		return;
-	}
 }
 
 const struct xfs_buf_ops xfs_dquot_buf_ops = {
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 7187ec9..bb1b13a 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -112,7 +112,6 @@ typedef uint16_t	xfs_qwarncnt_t;
 #define XFS_QMOPT_PQUOTA	0x0000008 /* project dquot requested */
 #define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
 #define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
-#define XFS_QMOPT_DOWARN        0x0000400 /* increase warning cnt if needed */
 #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
 #define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
 #define XFS_QMOPT_DQNEXT	0x0008000 /* return next dquot >= this ID */
@@ -152,8 +151,9 @@ typedef uint16_t	xfs_qwarncnt_t;
 		(XFS_QMOPT_UQUOTA | XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)
 #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
 
-extern int xfs_dqcheck(struct xfs_mount *mp, xfs_disk_dquot_t *ddq,
-		       xfs_dqid_t id, uint type, uint flags, const char *str);
+extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
+		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type,
+		uint flags);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern int xfs_dquot_repair(struct xfs_mount *mp, struct xfs_disk_dquot *ddq,
 		xfs_dqid_t id, uint type);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 0d8c52b..43572f8 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -956,6 +956,7 @@ xfs_qm_dqflush(
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_buf		*bp;
 	struct xfs_disk_dquot	*ddqp;
+	xfs_failaddr_t		fa;
 	int			error;
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
@@ -1002,9 +1003,10 @@ xfs_qm_dqflush(
 	/*
 	 * A simple sanity check in case we got a corrupted dquot..
 	 */
-	error = xfs_dqcheck(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0,
-			   XFS_QMOPT_DOWARN, "dqflush (incore copy)");
-	if (error) {
+	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0, 0);
+	if (fa) {
+		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
+				be32_to_cpu(ddqp->d_id), fa);
 		xfs_buf_relse(bp);
 		xfs_dqfunlock(dqp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 04f5b30..4fe2dd4 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2652,7 +2652,7 @@ xlog_recover_do_reg_buffer(
 	int			i;
 	int			bit;
 	int			nbits;
-	int                     error;
+	xfs_failaddr_t		fa;
 
 	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
 
@@ -2687,7 +2687,7 @@ xlog_recover_do_reg_buffer(
 		 * the first dquot in the buffer should do. XXXThis is
 		 * probably a good thing to do for other buf types also.
 		 */
-		error = 0;
+		fa = NULL;
 		if (buf_f->blf_flags &
 		   (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
 			if (item->ri_buf[i].i_addr == NULL) {
@@ -2701,11 +2701,14 @@ xlog_recover_do_reg_buffer(
 					item->ri_buf[i].i_len, __func__);
 				goto next;
 			}
-			error = xfs_dqcheck(mp, item->ri_buf[i].i_addr,
-					       -1, 0, XFS_QMOPT_DOWARN,
-					       "dquot_buf_recover");
-			if (error)
+			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr,
+					       -1, 0, 0);
+			if (fa) {
+				xfs_alert(mp,
+					"dquot corrupt at %pS trying to replay into block 0x%llx",
+					fa, bp->b_bn);
 				goto next;
+			}
 		}
 
 		memcpy(xfs_buf_offset(bp,
@@ -3307,6 +3310,7 @@ xlog_recover_dquot_pass2(
 	xfs_mount_t		*mp = log->l_mp;
 	xfs_buf_t		*bp;
 	struct xfs_disk_dquot	*ddq, *recddq;
+	xfs_failaddr_t		fa;
 	int			error;
 	xfs_dq_logformat_t	*dq_f;
 	uint			type;
@@ -3349,10 +3353,12 @@ xlog_recover_dquot_pass2(
 	 */
 	dq_f = item->ri_buf[0].i_addr;
 	ASSERT(dq_f);
-	error = xfs_dqcheck(mp, recddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
-			   "xlog_recover_dquot_pass2 (log copy)");
-	if (error)
+	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0, 0);
+	if (fa) {
+		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
+				dq_f->qlf_id, fa);
 		return -EIO;
+	}
 	ASSERT(dq_f->qlf_len == 1);
 
 	/*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 407a12b..e6084b9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -291,8 +291,7 @@ xfs_qm_dqattach_one(
 	 * exist on disk and we didn't ask it to allocate; ESRCH if quotas got
 	 * turned off suddenly.
 	 */
-	error = xfs_qm_dqget(ip->i_mount, ip, id, type,
-			     doalloc | XFS_QMOPT_DOWARN, &dqp);
+	error = xfs_qm_dqget(ip->i_mount, ip, id, type, doalloc, &dqp);
 	if (error)
 		return error;
 
@@ -574,7 +573,7 @@ xfs_qm_set_defquota(
 	struct xfs_def_quota    *defq;
 	int			error;
 
-	error = xfs_qm_dqread(mp, 0, type, XFS_QMOPT_DOWARN, &dqp);
+	error = xfs_qm_dqread(mp, 0, type, 0, &dqp);
 
 	if (!error) {
 		xfs_disk_dquot_t        *ddqp = &dqp->q_core;
@@ -652,7 +651,7 @@ xfs_qm_init_quotainfo(
 			XFS_IS_UQUOTA_RUNNING(mp) ? XFS_DQ_USER :
 			 (XFS_IS_GQUOTA_RUNNING(mp) ? XFS_DQ_GROUP :
 			  XFS_DQ_PROJ),
-			XFS_QMOPT_DOWARN, &dqp);
+			0, &dqp);
 
 	if (!error) {
 		xfs_disk_dquot_t	*ddqp = &dqp->q_core;
@@ -847,7 +846,7 @@ xfs_qm_reset_dqcounts(
 {
 	struct xfs_dqblk	*dqb;
 	int			j;
-	int			error;
+	xfs_failaddr_t		fa;
 
 	trace_xfs_reset_dqcounts(bp, _RET_IP_);
 
@@ -869,10 +868,11 @@ xfs_qm_reset_dqcounts(
 		/*
 		 * Do a sanity check, and if needed, repair the dqblk. Don't
 		 * output any warnings because it's perfectly possible to
-		 * find uninitialised dquot blks. See comment in xfs_dqcheck.
+		 * find uninitialised dquot blks. See comment in
+		 * xfs_dquot_verify.
 		 */
-		error = xfs_dqcheck(mp, ddq, id+j, type, 0, "xfs_quotacheck");
-		if (error)
+		fa = xfs_dquot_verify(mp, ddq, id + j, type, 0);
+		if (fa)
 			xfs_dquot_repair(mp, ddq, id + j, type);
 
 		/*
@@ -1081,8 +1081,7 @@ xfs_qm_quotacheck_dqadjust(
 	struct xfs_dquot	*dqp;
 	int			error;
 
-	error = xfs_qm_dqget(mp, ip, id, type,
-			     XFS_QMOPT_DQALLOC | XFS_QMOPT_DOWARN, &dqp);
+	error = xfs_qm_dqget(mp, ip, id, type, XFS_QMOPT_DQALLOC, &dqp);
 	if (error) {
 		/*
 		 * Shouldn't be able to turn off quotas here.
@@ -1685,8 +1684,7 @@ xfs_qm_vop_dqalloc(
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, NULL, uid,
 						 XFS_DQ_USER,
-						 XFS_QMOPT_DQALLOC |
-						 XFS_QMOPT_DOWARN,
+						 XFS_QMOPT_DQALLOC,
 						 &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
@@ -1712,8 +1710,7 @@ xfs_qm_vop_dqalloc(
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, NULL, gid,
 						 XFS_DQ_GROUP,
-						 XFS_QMOPT_DQALLOC |
-						 XFS_QMOPT_DOWARN,
+						 XFS_QMOPT_DQALLOC,
 						 &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
@@ -1732,8 +1729,7 @@ xfs_qm_vop_dqalloc(
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
 						 XFS_DQ_PROJ,
-						 XFS_QMOPT_DQALLOC |
-						 XFS_QMOPT_DOWARN,
+						 XFS_QMOPT_DQALLOC,
 						 &pq);
 			if (error) {
 				ASSERT(error != -ENOENT);

