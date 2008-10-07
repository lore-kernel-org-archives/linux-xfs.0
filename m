Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:50:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97LoZZ6003748
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:50:36 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBD564C62C8
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:52:15 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id h1Jr82b16b33OsxE for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:52:15 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] XFS: Never call mark_inode_dirty_sync() directly
Date: Wed,  8 Oct 2008 08:52:09 +1100
Message-Id: <1223416332-7026-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1223416332-7026-1-git-send-email-david@fromorbit.com>
References: <1223416332-7026-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

Once the Linux inode and the XFS inode are combined, we cannot rely
on just check if the linux inode exists as a method of determining
if it is valid or not. Hence we should always call
xfs_mark_inode_dirty_sync() instead as it does the correct checks to
determine if the liinux inode is in a valid state or not.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_aops.c  |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c  |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index a44d68e..8fbc97d 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -191,7 +191,7 @@ xfs_setfilesize(
 		ip->i_d.di_size = isize;
 		ip->i_update_core = 1;
 		ip->i_update_size = 1;
-		mark_inode_dirty_sync(ioend->io_inode);
+		xfs_mark_inode_dirty_sync(ip);
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 095d271..3bfb3c0 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -128,7 +128,7 @@ xfs_ichgtime(
 	if (sync_it) {
 		SYNCHRONIZE();
 		ip->i_update_core = 1;
-		mark_inode_dirty_sync(inode);
+		xfs_mark_inode_dirty_sync(ip);
 	}
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 1f9c5a9..7474859 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -948,7 +948,7 @@ xfs_fs_write_inode(
 	 * it dirty again so we'll try again later.
 	 */
 	if (error)
-		mark_inode_dirty_sync(inode);
+		xfs_mark_inode_dirty_sync(XFS_I(inode));
 
 	return -error;
 }
-- 
1.5.6.5
