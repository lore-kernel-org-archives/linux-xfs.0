Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60764 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753072AbdLSVI7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 16:08:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBJL6vn3066042
        for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2017 21:08:58 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2ey9gbgnkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2017 21:08:58 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBJL8v69016819
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2017 21:08:57 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBJL8vWq011507
        for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2017 21:08:57 GMT
Date: Tue, 19 Dec 2017 13:08:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 3/4] xfs: remove leftover CoW reservations when remounting
 ro
Message-ID: <20171219210856.GG12613@magnolia>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
 <151335789173.26575.16460983789473064032.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151335789173.26575.16460983789473064032.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're remounting the filesystem readonly, remove all CoW
preallocations prior to going ro.  If the fs goes down after the ro
remount, we never clean up the staging extents, which means xfs_check
will trip over them on a subsequent run.  Practically speaking, the next
mount will clean them up too, so this is unlikely to be seen.  Since we
shut down the cowblocks cleaner on remount-ro, we also have to make sure
we start it back up if/when we remount-rw.

Found by adding clonerange to fsstress and running xfs/017.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |    2 +-
 fs/xfs/xfs_icache.h |    1 +
 fs/xfs/xfs_super.c  |    9 +++++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 58d2d42..3861d61 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -870,7 +870,7 @@ xfs_eofblocks_worker(
  * based on the 'speculative_cow_prealloc_lifetime' tunable (5m by default).
  * (We'll just piggyback on the post-EOF prealloc space workqueue.)
  */
-STATIC void
+void
 xfs_queue_cowblocks(
 	struct xfs_mount *mp)
 {
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index bff4d85..d4a7758 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -81,6 +81,7 @@ void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
 int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
 void xfs_cowblocks_worker(struct work_struct *);
+void xfs_queue_cowblocks(struct xfs_mount *);
 
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, int flags, void *args),
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f663022..2db6a40 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1360,6 +1360,7 @@ xfs_fs_remount(
 			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 			return error;
 		}
+		xfs_queue_cowblocks(mp);
 
 		/* Create the per-AG metadata reservation pool .*/
 		error = xfs_fs_reserve_ag_blocks(mp);
@@ -1369,6 +1370,14 @@ xfs_fs_remount(
 
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
