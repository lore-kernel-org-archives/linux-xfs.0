Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24668 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdAUIA1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:00:27 -0500
Subject: [PATCH 01/55] xfs: fix toctou race when locking an inode to access
 the data map
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:00:22 -0800
Message-ID: <148498562203.15323.8801239738994829098.stgit@birch.djwong.org>
In-Reply-To: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
References: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

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
index b955779..b04bda8 100644
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
 

