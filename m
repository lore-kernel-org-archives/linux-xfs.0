Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3D5C2D0DE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 371FC206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FNFKrCeb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgAABMj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:12:39 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50610 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABMj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:12:39 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011BxHn093074
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=xbAqdd82pvNghYrKIrCDsBSMUUM9XkHqr6W/jY8MLH4=;
 b=FNFKrCebR5HLiFDGuW7uoypaOg5XBRh8HVbuUsLhe4Z4JD6VplVoy0Oh2J+TTXdLrYuC
 ssBdl4i84J7CCHcuiHIA2NkZl1+ams1fHZhPUquhh28fq8zisOr9hgTLKx1L9o6PFilJ
 mfk0KIeZsBbvdJvkFBjIUSyr/BV6YK51gIqJpS7ltUPV3l7fdElT+31rSd5PjyCTdbI2
 uvDtgWxlLXSbOnnSNyRbjWNXEs29Gh27CL6kJEIx8suCHKNAU4MDwglhszl2U3sZunvX
 Sv4JzN93yZ3wPSpiCwlg3n+0QBte3UzE9IGTH58m6DPOahJglba0ZsYR7Ar8633apqa5 xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vQD190292
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2x8bsrg0nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:38 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011AbrT028407
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:37 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:10:36 -0800
Subject: [PATCH 4/5] xfs: implement live quotacheck as part of quota repair
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:10:34 -0800
Message-ID: <157784103458.1364003.10041166419649712004.stgit@magnolia>
In-Reply-To: <157784100871.1364003.10658176827446969836.stgit@magnolia>
References: <157784100871.1364003.10658176827446969836.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the fs freezing mechanism we developed for the rmapbt repair to
freeze the fs, this time to scan the fs for a live quotacheck.  We add a
new dqget variant to use the existing scrub transaction to allocate an
on-disk dquot block if it is missing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/quota.c        |   22 ++++++-
 fs/xfs/scrub/quota_repair.c |  139 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_qm.c             |   94 ++++++++++++++++++-----------
 fs/xfs/xfs_qm.h             |    3 +
 4 files changed, 221 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index bab55b6cd723..64e24fe5dcb2 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -16,6 +16,7 @@
 #include "xfs_qm.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/repair.h"
 
 /* Convert a scrub type code to a DQ flag, or return 0 if error. */
 uint
@@ -53,12 +54,31 @@ xchk_setup_quota(
 	mutex_lock(&sc->mp->m_quotainfo->qi_quotaofflock);
 	if (!xfs_this_quota_on(sc->mp, dqtype))
 		return -ENOENT;
+
+	/*
+	 * Freeze out anything that can alter an inode because we reconstruct
+	 * the quota counts by iterating all the inodes in the system.
+	 */
+	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
+	    ((sc->flags & XCHK_TRY_HARDER) || XFS_QM_NEED_QUOTACHECK(sc->mp))) {
+		error = xchk_fs_freeze(sc);
+		if (error)
+			return error;
+	}
+
 	error = xchk_setup_fs(sc, ip);
 	if (error)
 		return error;
 	sc->ip = xfs_quota_inode(sc->mp, dqtype);
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
 	sc->ilock_flags = XFS_ILOCK_EXCL;
+	/*
+	 * Pretend to be an ILOCK parent to shut up lockdep if we're going to
+	 * do a full inode scan of the fs.  Quota inodes do not count towards
+	 * quota accounting, so we shouldn't deadlock on ourselves.
+	 */
+	if (sc->flags & XCHK_FS_FROZEN)
+		sc->ilock_flags |= XFS_ILOCK_PARENT;
+	xfs_ilock(sc->ip, sc->ilock_flags);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 5f76c4f4db1a..61d7e43ba56b 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -23,6 +23,11 @@
 #include "xfs_qm.h"
 #include "xfs_dquot.h"
 #include "xfs_dquot_item.h"
+#include "xfs_trans_space.h"
+#include "xfs_error.h"
+#include "xfs_errortag.h"
+#include "xfs_health.h"
+#include "xfs_iwalk.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -37,6 +42,11 @@
  * verifiers complain about, cap any counters or limits that make no sense,
  * and schedule a quotacheck if we had to fix anything.  We also repair any
  * data fork extent records that don't apply to metadata files.
+ *
+ * Online quotacheck is fairly straightforward.  We engage a repair freeze,
+ * zero all the dquots, and scan every inode in the system to recalculate the
+ * appropriate quota charges.  Finally, we log all the dquots to disk and
+ * set the _CHKD flags.
  */
 
 struct xrep_quota_info {
@@ -312,6 +322,116 @@ xrep_quota_data_fork(
 	return error;
 }
 
+/* Online Quotacheck */
+
+/*
+ * Zero a dquot prior to regenerating the counts.  We skip flushing the dirty
+ * dquots to disk because we've already cleared the CHKD flags in the ondisk
+ * superblock so if we crash we'll just rerun quotacheck.
+ */
+static int
+xrep_quotacheck_zero_dquot(
+	struct xfs_dquot	*dq,
+	uint			dqtype,
+	void			*priv)
+{
+	dq->q_res_bcount -= be64_to_cpu(dq->q_core.d_bcount);
+	dq->q_core.d_bcount = 0;
+	dq->q_res_icount -= be64_to_cpu(dq->q_core.d_icount);
+	dq->q_core.d_icount = 0;
+	dq->q_res_rtbcount -= be64_to_cpu(dq->q_core.d_rtbcount);
+	dq->q_core.d_rtbcount = 0;
+	dq->dq_flags |= XFS_DQ_DIRTY;
+	return 0;
+}
+
+/* Execute an online quotacheck. */
+STATIC int
+xrep_quotacheck(
+	struct xfs_scrub	*sc)
+{
+	LIST_HEAD		(buffer_list);
+	struct xfs_mount	*mp = sc->mp;
+	uint			qflag = 0;
+	int			error;
+
+	/*
+	 * We can rebuild all the quota information, so we need to be able to
+	 * update both the health status and the CHKD flags.
+	 */
+	if (XFS_IS_UQUOTA_ON(mp)) {
+		sc->sick_mask |= XFS_SICK_FS_UQUOTA;
+		qflag |= XFS_UQUOTA_CHKD;
+	}
+	if (XFS_IS_GQUOTA_ON(mp)) {
+		sc->sick_mask |= XFS_SICK_FS_GQUOTA;
+		qflag |= XFS_GQUOTA_CHKD;
+	}
+	if (XFS_IS_PQUOTA_ON(mp)) {
+		sc->sick_mask |= XFS_SICK_FS_PQUOTA;
+		qflag |= XFS_PQUOTA_CHKD;
+	}
+
+	/* Clear the CHKD flags. */
+	spin_lock(&sc->mp->m_sb_lock);
+	sc->mp->m_qflags &= ~qflag;
+	sc->mp->m_sb.sb_qflags &= ~qflag;
+	spin_unlock(&sc->mp->m_sb_lock);
+	xfs_log_sb(sc->tp);
+
+	/*
+	 * Commit the transaction so that we can allocate new quota ip
+	 * mappings if we have to.  If we crash after this point, the sb
+	 * still has the CHKD flags cleared, so mount quotacheck will fix
+	 * all of this up.
+	 */
+	error = xfs_trans_commit(sc->tp);
+	sc->tp = NULL;
+	if (error)
+		return error;
+
+	/*
+	 * Zero all the dquots, and remember that we rebuild all three quota
+	 * types.  We hold the quotaoff lock, so these won't change.
+	 */
+	if (XFS_IS_UQUOTA_ON(mp)) {
+		error = xfs_qm_dqiterate(mp, XFS_DQ_USER,
+				xrep_quotacheck_zero_dquot, NULL);
+		if (error)
+			goto out;
+	}
+	if (XFS_IS_GQUOTA_ON(mp)) {
+		error = xfs_qm_dqiterate(mp, XFS_DQ_GROUP,
+				xrep_quotacheck_zero_dquot, NULL);
+		if (error)
+			goto out;
+	}
+	if (XFS_IS_PQUOTA_ON(mp)) {
+		error = xfs_qm_dqiterate(mp, XFS_DQ_PROJ,
+				xrep_quotacheck_zero_dquot, NULL);
+		if (error)
+			goto out;
+	}
+
+	/* Walk the inodes and reset the dquots. */
+	error = xfs_qm_quotacheck_walk_and_flush(mp, true, &buffer_list);
+	if (error)
+		goto out;
+
+	/* Set quotachecked flag. */
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		goto out;
+
+	spin_lock(&sc->mp->m_sb_lock);
+	sc->mp->m_qflags |= qflag;
+	sc->mp->m_sb.sb_qflags |= qflag;
+	spin_unlock(&sc->mp->m_sb_lock);
+	xfs_log_sb(sc->tp);
+out:
+	return error;
+}
+
 /*
  * Go fix anything in the quota items that we could have been mad about.  Now
  * that we've checked the quota inode data fork we have to drop ILOCK_EXCL to
@@ -332,8 +452,10 @@ xrep_quota_problems(
 		return error;
 
 	/* Make a quotacheck happen. */
-	if (rqi.need_quotacheck)
+	if (rqi.need_quotacheck ||
+	    XFS_TEST_ERROR(false, sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
 		xrep_force_quotacheck(sc, dqtype);
+
 	return 0;
 }
 
@@ -343,6 +465,7 @@ xrep_quota(
 	struct xfs_scrub	*sc)
 {
 	uint			dqtype;
+	uint			flag;
 	int			error;
 
 	dqtype = xchk_quota_to_dqtype(sc);
@@ -358,6 +481,20 @@ xrep_quota(
 
 	/* Fix anything the dquot verifiers complain about. */
 	error = xrep_quota_problems(sc, dqtype);
+	if (error)
+		goto out;
+
+	/* Do we need a quotacheck?  Did we need one? */
+	flag = xfs_quota_chkd_flag(dqtype);
+	if (!(flag & sc->mp->m_qflags)) {
+		/* We need to freeze the fs before we can scan inodes. */
+		if (!(sc->flags & XCHK_FS_FROZEN)) {
+			error = -EDEADLOCK;
+			goto out;
+		}
+
+		error = xrep_quotacheck(sc);
+	}
 out:
 	return error;
 }
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index fc3898f5e27d..0ce334c51d73 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1140,11 +1140,12 @@ xfs_qm_dqusage_adjust(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_ino_t		ino,
-	void			*data)
+	void			*need_ilocks)
 {
 	struct xfs_inode	*ip;
 	xfs_qcnt_t		nblks;
 	xfs_filblks_t		rtblks = 0;	/* total rt blks */
+	uint			ilock_flags = 0;
 	int			error;
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
@@ -1156,16 +1157,19 @@ xfs_qm_dqusage_adjust(
 	if (xfs_is_quota_inode(&mp->m_sb, ino))
 		return 0;
 
-	/*
-	 * We don't _need_ to take the ilock EXCL here because quotacheck runs
-	 * at mount time and therefore nobody will be racing chown/chproj.
-	 */
+	/* Grab inode and lock it if needed. */
 	error = xfs_iget(mp, tp, ino, XFS_IGET_DONTCACHE, 0, &ip);
 	if (error == -EINVAL || error == -ENOENT)
 		return 0;
 	if (error)
 		return error;
 
+	if (need_ilocks) {
+		ilock_flags = XFS_IOLOCK_SHARED | XFS_MMAPLOCK_SHARED;
+		xfs_ilock(ip, ilock_flags);
+		ilock_flags |= xfs_ilock_data_map_shared(ip);
+	}
+
 	ASSERT(ip->i_delayed_blks == 0);
 
 	if (XFS_IS_REALTIME_INODE(ip)) {
@@ -1216,6 +1220,8 @@ xfs_qm_dqusage_adjust(
 	}
 
 error0:
+	if (ilock_flags)
+		xfs_iunlock(ip, ilock_flags);
 	xfs_irele(ip);
 	return error;
 }
@@ -1272,17 +1278,61 @@ xfs_qm_flush_one(
 	return error;
 }
 
+/*
+ * Walk the inodes and adjust quota usage.  Caller must have previously
+ * zeroed all dquots.
+ */
+int
+xfs_qm_quotacheck_walk_and_flush(
+	struct xfs_mount	*mp,
+	bool			need_ilocks,
+	struct list_head	*buffer_list)
+{
+	int			error, error2;
+
+	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0,
+			!need_ilocks, NULL);
+	if (error)
+		return error;
+
+	/*
+	 * We've made all the changes that we need to make incore.  Flush them
+	 * down to disk buffers if everything was updated successfully.
+	 */
+	if (XFS_IS_UQUOTA_ON(mp)) {
+		error = xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_flush_one,
+					  buffer_list);
+	}
+	if (XFS_IS_GQUOTA_ON(mp)) {
+		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_flush_one,
+					   buffer_list);
+		if (!error)
+			error = error2;
+	}
+	if (XFS_IS_PQUOTA_ON(mp)) {
+		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_flush_one,
+					   buffer_list);
+		if (!error)
+			error = error2;
+	}
+
+	error2 = xfs_buf_delwri_submit(buffer_list);
+	if (!error)
+		error = error2;
+	return error;
+}
+
 /*
  * Walk thru all the filesystem inodes and construct a consistent view
  * of the disk quota world. If the quotacheck fails, disable quotas.
  */
 STATIC int
 xfs_qm_quotacheck(
-	xfs_mount_t	*mp)
+	struct xfs_mount	*mp)
 {
-	int			error, error2;
-	uint			flags;
+	int			error;
 	LIST_HEAD		(buffer_list);
+	uint			flags;
 	struct xfs_inode	*uip = mp->m_quotainfo->qi_uquotaip;
 	struct xfs_inode	*gip = mp->m_quotainfo->qi_gquotaip;
 	struct xfs_inode	*pip = mp->m_quotainfo->qi_pquotaip;
@@ -1323,36 +1373,10 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
-	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
-			NULL);
+	error = xfs_qm_quotacheck_walk_and_flush(mp, false, &buffer_list);
 	if (error)
 		goto error_return;
 
-	/*
-	 * We've made all the changes that we need to make incore.  Flush them
-	 * down to disk buffers if everything was updated successfully.
-	 */
-	if (XFS_IS_UQUOTA_ON(mp)) {
-		error = xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_flush_one,
-					  &buffer_list);
-	}
-	if (XFS_IS_GQUOTA_ON(mp)) {
-		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_flush_one,
-					   &buffer_list);
-		if (!error)
-			error = error2;
-	}
-	if (XFS_IS_PQUOTA_ON(mp)) {
-		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_flush_one,
-					   &buffer_list);
-		if (!error)
-			error = error2;
-	}
-
-	error2 = xfs_buf_delwri_submit(&buffer_list);
-	if (!error)
-		error = error2;
-
 	/*
 	 * We can get this error if we couldn't do a dquot allocation inside
 	 * xfs_qm_dqusage_adjust (via bulkstat). We don't care about the
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 7823af39008b..a3d9932f2e65 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -179,4 +179,7 @@ xfs_get_defquota(struct xfs_dquot *dqp, struct xfs_quotainfo *qi)
 	return defq;
 }
 
+int xfs_qm_quotacheck_walk_and_flush(struct xfs_mount *mp, bool need_ilocks,
+		struct list_head *buffer_list);
+
 #endif /* __XFS_QM_H__ */

