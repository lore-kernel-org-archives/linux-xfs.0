Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29034 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752939AbdHNWHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 18:07:20 -0400
Subject: [PATCH 2/3] xfs: don't leak quotacheck dquots when cow recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 14 Aug 2017 15:07:11 -0700
Message-ID: <150274843164.16269.3698971967364371469.stgit@magnolia>
In-Reply-To: <150274842319.16269.6356165894145725007.stgit@magnolia>
References: <150274842319.16269.6356165894145725007.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

If we fail a mount on account of cow recovery errors, it's possible that
a previous quotacheck left some dquots in memory.  The bailout clause of
xfs_mountfs forgets to purge these, and so we leak them.  Fix that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_mount.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 151a82db..ea7d4b4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1024,6 +1024,8 @@ xfs_mountfs(
 	IRELE(rip);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
+	/* Clean out dquots that might be in memory after quotacheck. */
+	xfs_qm_unmount(mp);
  out_log_dealloc:
 	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);

