Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43026 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdHJFXv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2017 01:23:51 -0400
Subject: [PATCH 1/3] xfs: clear MS_ACTIVE after finishing log recovery to
 avoid inode leak
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 09 Aug 2017 22:23:40 -0700
Message-ID: <150234262066.13754.6534116056866237943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Way back when we established inode block-map redo log items, it was
discovered that we needed to prevent the VFS from evicting inodes during
log recovery because any given inode might be have bmap redo items to
replay even if the inode has no link count and is ultimately deleted,
and any eviction of an unlinked inode causes the inode to be truncated
and freed too early.

To make this possible, we set MS_ACTIVE so that inodes would not be torn
down immediately upon release.  Unfortunately, this also results in the
quota inodes not being released at all if a later part of the mount
process should fail, because we never reclaim the inodes.  So, clear
MS_ACTIVE immediately after we finish the log recovery so that the quota
inodes will be torn down properly if we abort the mount.

Fixes: 17c12bcd30 ("xfs: when replaying bmap operations, don't let unlinked inodes get reaped")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
v2: wrap the xfs_log_mount_finish more tightly with the MS_ACTIVE mods
---
 fs/xfs/xfs_mount.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 40d4e8b..d63a367 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -945,20 +945,21 @@ xfs_mountfs(
 	}
 
 	/*
+	 * Finish recovering the file system.  This part needed to be delayed
+	 * until after the root and real-time bitmap inodes were consistently
+	 * read in.
+	 *
 	 * During the second phase of log recovery, we need iget and
 	 * iput to behave like they do for an active filesystem.
 	 * xfs_fs_drop_inode needs to be able to prevent the deletion
 	 * of inodes before we're done replaying log items on those
-	 * inodes.
+	 * inodes.  Turn it off immediately after xfs_log_mount_finish
+	 * so that we don't leak the quota inodes if subsequent mount
+	 * activities fail.
 	 */
 	mp->m_super->s_flags |= MS_ACTIVE;
-
-	/*
-	 * Finish recovering the file system.  This part needed to be delayed
-	 * until after the root and real-time bitmap inodes were consistently
-	 * read in.
-	 */
 	error = xfs_log_mount_finish(mp);
+	mp->m_super->s_flags &= ~MS_ACTIVE;
 	if (error) {
 		xfs_warn(mp, "log mount finish failed");
 		goto out_rtunmount;
@@ -1028,7 +1029,6 @@ xfs_mountfs(
  out_quota:
 	xfs_qm_unmount_quotas(mp);
  out_rtunmount:
-	mp->m_super->s_flags &= ~MS_ACTIVE;
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:
 	IRELE(rip);

