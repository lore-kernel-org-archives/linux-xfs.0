Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56988 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbeD3FoM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 01:44:12 -0400
Subject: [PATCH 06/13] xfs: fetch dquots directly during quotacheck
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 29 Apr 2018 22:43:52 -0700
Message-ID: <152506703202.21553.3937789203901382882.stgit@magnolia>
In-Reply-To: <152506698177.21553.13500862866416804148.stgit@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

Quotacheck only runs during mount, which means that there are no other
processes in the system that could be doing chown or chproj.  Therefore
there's no potential for racing to attach dquots to the inode so we can
drop all the ILOCK and race detection bits from quotacheck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 25c0718e1993..fb14954610ee 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1062,16 +1062,17 @@ xfs_qm_dqiterate(
 STATIC int
 xfs_qm_quotacheck_dqadjust(
 	struct xfs_inode	*ip,
-	xfs_dqid_t		id,
 	uint			type,
 	xfs_qcnt_t		nblks,
 	xfs_qcnt_t		rtblks)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_dquot	*dqp;
+	xfs_dqid_t		id;
 	int			error;
 
-	error = xfs_qm_dqget_inode(ip, type, true, &dqp);
+	id = xfs_qm_id_for_quotatype(ip, type);
+	error = xfs_qm_dqget(mp, id, type, XFS_QMOPT_DQALLOC, &dqp);
 	if (error) {
 		/*
 		 * Shouldn't be able to turn off quotas here.
@@ -1144,13 +1145,10 @@ xfs_qm_dqusage_adjust(
 	}
 
 	/*
-	 * We don't _need_ to take the ilock EXCL. However, the xfs_qm_dqget
-	 * interface expects the inode to be exclusively locked because that's
-	 * the case in all other instances. It's OK that we do this because
-	 * quotacheck is done only at mount time.
+	 * We don't _need_ to take the ilock EXCL here because quotacheck runs
+	 * at mount time and therefore nobody will be racing chown/chproj.
 	 */
-	error = xfs_iget(mp, NULL, ino, XFS_IGET_DONTCACHE, XFS_ILOCK_EXCL,
-			 &ip);
+	error = xfs_iget(mp, NULL, ino, XFS_IGET_DONTCACHE, 0, &ip);
 	if (error) {
 		*res = BULKSTAT_RV_NOTHING;
 		return error;
@@ -1185,33 +1183,31 @@ xfs_qm_dqusage_adjust(
 	 * and quotaoffs don't race. (Quotachecks happen at mount time only).
 	 */
 	if (XFS_IS_UQUOTA_ON(mp)) {
-		error = xfs_qm_quotacheck_dqadjust(ip, ip->i_d.di_uid,
-						   XFS_DQ_USER, nblks, rtblks);
+		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQ_USER, nblks,
+				rtblks);
 		if (error)
 			goto error0;
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp)) {
-		error = xfs_qm_quotacheck_dqadjust(ip, ip->i_d.di_gid,
-						   XFS_DQ_GROUP, nblks, rtblks);
+		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQ_GROUP, nblks,
+				rtblks);
 		if (error)
 			goto error0;
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp)) {
-		error = xfs_qm_quotacheck_dqadjust(ip, xfs_get_projid(ip),
-						   XFS_DQ_PROJ, nblks, rtblks);
+		error = xfs_qm_quotacheck_dqadjust(ip, XFS_DQ_PROJ, nblks,
+				rtblks);
 		if (error)
 			goto error0;
 	}
 
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	IRELE(ip);
 	*res = BULKSTAT_RV_DIDONE;
 	return 0;
 
 error0:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	IRELE(ip);
 	*res = BULKSTAT_RV_GIVEUP;
 	return error;

