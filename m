Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38053 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752916AbdHNWHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 18:07:07 -0400
Subject: [PATCH 1/3] xfs: clear MS_ACTIVE after finishing log recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 14 Aug 2017 15:07:03 -0700
Message-ID: <150274842319.16269.6356165894145725007.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

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
process should fail, because we never reclaim the inodes.  So, set
MS_ACTIVE right before we do the last part of log recovery and clear it
immediately after we finish the log recovery so that everything
will be torn down properly if we abort the mount.

Fixes: 17c12bcd30 ("xfs: when replaying bmap operations, don't let unlinked inodes get reaped")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c   |   11 +++++++++++
 fs/xfs/xfs_mount.c |   10 ----------
 2 files changed, 11 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0053bcf..4ebd0ba 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -749,9 +749,20 @@ xfs_log_mount_finish(
 		return 0;
 	}
 
+	/*
+	 * During the second phase of log recovery, we need iget and
+	 * iput to behave like they do for an active filesystem.
+	 * xfs_fs_drop_inode needs to be able to prevent the deletion
+	 * of inodes before we're done replaying log items on those
+	 * inodes.  Turn it off immediately after recovery finishes
+	 * so that we don't leak the quota inodes if subsequent mount
+	 * activities fail.
+	 */
+	mp->m_super->s_flags |= MS_ACTIVE;
 	error = xlog_recover_finish(mp->m_log);
 	if (!error)
 		xfs_log_work_queue(mp);
+	mp->m_super->s_flags &= ~MS_ACTIVE;
 
 	return error;
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 40d4e8b..151a82db 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -945,15 +945,6 @@ xfs_mountfs(
 	}
 
 	/*
-	 * During the second phase of log recovery, we need iget and
-	 * iput to behave like they do for an active filesystem.
-	 * xfs_fs_drop_inode needs to be able to prevent the deletion
-	 * of inodes before we're done replaying log items on those
-	 * inodes.
-	 */
-	mp->m_super->s_flags |= MS_ACTIVE;
-
-	/*
 	 * Finish recovering the file system.  This part needed to be delayed
 	 * until after the root and real-time bitmap inodes were consistently
 	 * read in.
@@ -1028,7 +1019,6 @@ xfs_mountfs(
  out_quota:
 	xfs_qm_unmount_quotas(mp);
  out_rtunmount:
-	mp->m_super->s_flags &= ~MS_ACTIVE;
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:
 	IRELE(rip);

