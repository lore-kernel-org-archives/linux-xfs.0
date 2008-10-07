Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:42:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97Lg5fp032756
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:42:05 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2BB7129BB9F
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:43:45 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id YTeWH9ZaSUjabFCY for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:43:45 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKLE-0001k5-7Q
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:43:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/10] XFS: xfssyncd: don't call xfs_sync
Date: Wed,  8 Oct 2008 08:43:34 +1100
Message-Id: <1223415819-6599-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1223415819-6599-1-git-send-email-david@fromorbit.com>
References: <1223415819-6599-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Start de-multiplexing xfs_sync() by making xfs_sync_worker()
call the specific sync functions it needs. This is only a small,
unique subset of the entire xfs_sync() code so is easier to
follow.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index d4b7b21..3c31137 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -526,6 +526,11 @@ xfs_flush_device(
 	xfs_log_force(ip->i_mount, (xfs_lsn_t)0, XFS_LOG_FORCE|XFS_LOG_SYNC);
 }
 
+/*
+ * Every sync period we need to unpin all items, reclaim inodes, sync
+ * quota and write out the superblock. We might need to cover the log
+ * to indicate it is idle.
+ */
 STATIC void
 xfs_sync_worker(
 	struct xfs_mount *mp,
@@ -533,8 +538,15 @@ xfs_sync_worker(
 {
 	int		error;
 
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY))
-		error = xfs_sync(mp, SYNC_FSDATA | SYNC_BDFLUSH | SYNC_ATTR);
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
+		xfs_finish_reclaim_all(mp, 1, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+		/* dgc: errors ignored here */
+		error = XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
+		error = xfs_sync_fsdata(mp, SYNC_BDFLUSH);
+		if (xfs_log_need_covered(mp))
+			error = xfs_commit_dummy_trans(mp, XFS_LOG_FORCE);
+	}
 	mp->m_sync_seq++;
 	wake_up(&mp->m_wait_single_sync_task);
 }
-- 
1.5.6.5
