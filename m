Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56564 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752307AbdIRJQn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 05:16:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 48/78] xfs: clear MS_ACTIVE after finishing log recovery
Date: Mon, 18 Sep 2017 11:11:57 +0200
Message-Id: <20170918091133.599214652@linuxfoundation.org>
In-Reply-To: <20170918091126.077483037@linuxfoundation.org>
References: <20170918091126.077483037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 8204f8ddaafafcae074746fcf2a05a45e6827603 upstream.

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
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log.c   |   11 +++++++++++
 fs/xfs/xfs_mount.c |   10 ----------
 2 files changed, 11 insertions(+), 10 deletions(-)

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
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -925,15 +925,6 @@ xfs_mountfs(
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
@@ -1008,7 +999,6 @@ xfs_mountfs(
  out_quota:
 	xfs_qm_unmount_quotas(mp);
  out_rtunmount:
-	mp->m_super->s_flags &= ~MS_ACTIVE;
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:
 	IRELE(rip);


