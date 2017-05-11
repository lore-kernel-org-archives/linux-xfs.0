Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25739 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933190AbdEKRzO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 13:55:14 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4BHtDVr001117
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 17:55:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v4BHtDmL032620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 17:55:13 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v4BHtDL1009327
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 17:55:13 GMT
Date: Thu, 11 May 2017 10:55:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: only return detailed fsmap info if the caller has
 CAP_SYS_ADMIN
Message-ID: <20170511175511.GC4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

There were a number of handwaving complaints that one could "possibly"
use inode numbers and extent maps to fingerprint a filesystem hosting
multiple containers and somehow use the information to guess at the
contents of other containers and attack them.  Despite the total lack of
any demonstration that this is actually possible, it's easier to
restrict access now and broaden it later, so use the rmapbt fsmap
backends only if the caller has CAP_SYS_ADMIN.  Unprivileged users will
just have to make do with only getting the free space information.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 3683819..814ed729 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -828,6 +828,7 @@ xfs_getfsmap(
 	struct xfs_fsmap		dkeys[2];	/* per-dev keys */
 	struct xfs_getfsmap_dev		handlers[XFS_GETFSMAP_DEVS];
 	struct xfs_getfsmap_info	info = { NULL };
+	bool				use_rmap;
 	int				i;
 	int				error = 0;
 
@@ -837,12 +838,14 @@ xfs_getfsmap(
 	    !xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[1]))
 		return -EINVAL;
 
+	use_rmap = capable(CAP_SYS_ADMIN) &&
+		   xfs_sb_version_hasrmapbt(&mp->m_sb);
 	head->fmh_entries = 0;
 
 	/* Set up our device handlers. */
 	memset(handlers, 0, sizeof(handlers));
 	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (use_rmap)
 		handlers[0].fn = xfs_getfsmap_datadev_rmapbt;
 	else
 		handlers[0].fn = xfs_getfsmap_datadev_bnobt;
