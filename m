Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17343 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbdFZGEv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2017 02:04:51 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v5Q64oPS007166
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2017 06:04:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v5Q64nok011030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2017 06:04:50 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v5Q64lVL018619
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2017 06:04:48 GMT
Date: Sun, 25 Jun 2017 23:04:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/13] xfs: grab dquots without taking the ilock
Message-ID: <20170626060446.GB4733@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add a new dqget flag that grabs the dquot without taking the ilock.
This will be used by the scrubber (which will have already grabbed
the ilock) to perform basic sanity checking of the quota data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |    2 ++
 fs/xfs/xfs_dquot.c             |   11 +++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index d69c772..2834574 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -136,6 +136,8 @@ typedef uint16_t	xfs_qwarncnt_t;
  */
 #define XFS_QMOPT_INHERIT	0x1000000
 
+#define XFS_QMOPT_NOLOCK	0x2000000 /* don't ilock during dqget */
+
 /*
  * flags to xfs_trans_mod_dquot.
  */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index e57c6cc..3519efc 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -472,18 +472,20 @@ xfs_qm_dqtobp(
 	struct xfs_mount	*mp = dqp->q_mount;
 	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
 	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
-	uint			lock_mode;
+	uint			lock_mode = 0;
 
 	quotip = xfs_quota_inode(dqp->q_mount, dqp->dq_flags);
 	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
 
-	lock_mode = xfs_ilock_data_map_shared(quotip);
+	if (!(flags & XFS_QMOPT_NOLOCK))
+		lock_mode = xfs_ilock_data_map_shared(quotip);
 	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
 		/*
 		 * Return if this type of quotas is turned off while we
 		 * didn't have the quota inode lock.
 		 */
-		xfs_iunlock(quotip, lock_mode);
+		if (lock_mode)
+			xfs_iunlock(quotip, lock_mode);
 		return -ESRCH;
 	}
 
@@ -493,7 +495,8 @@ xfs_qm_dqtobp(
 	error = xfs_bmapi_read(quotip, dqp->q_fileoffset,
 			       XFS_DQUOT_CLUSTER_SIZE_FSB, &map, &nmaps, 0);
 
-	xfs_iunlock(quotip, lock_mode);
+	if (lock_mode)
+		xfs_iunlock(quotip, lock_mode);
 	if (error)
 		return error;
 
