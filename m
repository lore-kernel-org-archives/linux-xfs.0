Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46591 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754574AbdAaAXN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2017 19:23:13 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0V0NBjQ010845
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 00:23:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v0V0NBNx004425
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 00:23:11 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v0V0NBfV007039
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 00:23:11 GMT
Subject: [PATCH 1/7] xfs: fix toctou race when locking an inode to access
 the data map
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 30 Jan 2017 16:23:10 -0800
Message-ID: <148582219035.12293.12084220786527965512.stgit@birch.djwong.org>
In-Reply-To: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We use di_format and if_flags to decide whether we're grabbing the ilock
in btree mode (btree extents not loaded) or shared mode (anything else),
but the state of those fields can be changed by other threads that are
also trying to load the btree extents -- IFEXTENTS gets set before the
_bmap_read_extents call and cleared if it fails.  Therefore, once we've
grabbed the shared ilock we have to re-check the fields to see if we
actually need to upgrade to the exclusive ilock in order to try loading
the extents.

Without this patch, we trigger ilock assert failures when a bunch of
threads try to access a btree format directory with a corrupt bmbt root
and corrupt the incore data structures, leading to a crash.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index de32f0f..7d7206c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -125,6 +125,18 @@ xfs_ilock_data_map_shared(
 	    (ip->i_df.if_flags & XFS_IFEXTENTS) == 0)
 		lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lock_mode);
+	/*
+	 * We can change if_flags under ilock if we try to read the
+	 * extents and fail.  Since we hadn't grabbed the ilock at check
+	 * time, we have to re-check and upgrade the lock now.
+	 */
+	if (lock_mode == XFS_ILOCK_SHARED &&
+	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
+	    (ip->i_df.if_flags & XFS_IFEXTENTS) == 0) {
+		xfs_iunlock(ip, lock_mode);
+		lock_mode = XFS_ILOCK_EXCL;
+		xfs_ilock(ip, lock_mode);
+	}
 	return lock_mode;
 }
 

