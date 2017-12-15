Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49896 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755504AbdLORVf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 12:21:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBFHKaAJ177663
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:21:34 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2evjq7807j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:21:34 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBFHBXdX023968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:33 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBFHBW2O000571
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:33 GMT
Subject: [PATCH 3/4] xfs: remove leftover CoW reservations when remounting ro
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 15 Dec 2017 09:11:31 -0800
Message-ID: <151335789173.26575.16460983789473064032.stgit@magnolia>
In-Reply-To: <151335786780.26575.15542999972223359181.stgit@magnolia>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're remounting the filesystem readonly, remove all CoW
preallocations prior to going ro.  If the fs goes down after the ro
remount, we never clean up the staging extents, which means xfs_check
will trip over them on a subsequent run.  Practically speaking, the
next mount will clean them up too, so this is unlikely to be seen.

Found by adding clonerange to fsstress and running xfs/017.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f663022..7b6d150 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1369,6 +1369,14 @@ xfs_fs_remount(
 
 	/* rw -> ro */
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
+		/* Get rid of any leftover CoW reservations... */
+		cancel_delayed_work_sync(&mp->m_cowblocks_work);
+		error = xfs_icache_free_cowblocks(mp, NULL);
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			return error;
+		}
+
 		/* Free the per-AG metadata reservation pool. */
 		error = xfs_fs_unreserve_ag_blocks(mp);
 		if (error) {

