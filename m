Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53018 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfAACRA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:17:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012E2He168455
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:16:59 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2pnxedxaq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:16:59 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012GwZF000935
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:16:58 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012Gw1L000457
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:16:58 GMT
Subject: [PATCH 01/12] xfs: free COW staging extents when freezing filesystem
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:16:57 -0800
Message-ID: <154630901708.16693.4337908735292154622.stgit@magnolia>
In-Reply-To: <154630901076.16693.13111277988041606505.stgit@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're freezing the filesystem, free all the COW staging extents
before we shut the log down so that we can minimize the amount of
recovery work that will be necessary during the next mount.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   17 ++++++++++++-----
 fs/xfs/xfs_super.c  |   18 ++++++++++++++++++
 2 files changed, 30 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 245483cc282b..36d986087abb 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1741,6 +1741,7 @@ xfs_inode_free_cowblocks(
 	void			*args)
 {
 	struct xfs_eofblocks	*eofb = args;
+	uint			lock_mode = 0;
 	int			match;
 	int			ret = 0;
 
@@ -1761,9 +1762,15 @@ xfs_inode_free_cowblocks(
 			return 0;
 	}
 
-	/* Free the CoW blocks */
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+	/*
+	 * Free the CoW blocks.  We don't need to lock the inode if we're in
+	 * the process of freezing the filesystem because we've already locked
+	 * out writes and page faults.
+	 */
+	if (ip->i_mount->m_super->s_writers.frozen == SB_UNFROZEN)
+		lock_mode = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	if (lock_mode)
+		xfs_ilock(ip, lock_mode);
 
 	/*
 	 * Check again, nobody else should be able to dirty blocks or change
@@ -1772,8 +1779,8 @@ xfs_inode_free_cowblocks(
 	if (xfs_prep_free_cowblocks(ip))
 		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
 
-	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	if (lock_mode)
+		xfs_iunlock(ip, lock_mode);
 
 	return ret;
 }
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6903b36eac5d..bb4953cfd683 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1102,6 +1102,24 @@ xfs_fs_sync_fs(
 	if (!wait)
 		return 0;
 
+	/*
+	 * If we're in the middle of freezing the filesystem, this is our last
+	 * chance to run regular transactions.  Clear all the COW staging
+	 * extents so that we can freeze the filesystem with as little recovery
+	 * work to do at the next mount as possible.  It's safe to do this
+	 * without locking inodes because the freezer code flushed all the
+	 * dirty data from the page cache and locked out writes and page faults.
+	 */
+	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
+		int		error;
+
+		error = xfs_icache_free_cowblocks(mp, NULL);
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			return error;
+		}
+	}
+
 	xfs_log_force(mp, XFS_LOG_SYNC);
 	if (laptop_mode) {
 		/*
