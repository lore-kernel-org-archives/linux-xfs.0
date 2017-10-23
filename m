Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdJWOqs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Oct 2017 10:46:48 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6F82E356CF
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 14:46:48 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 545F95D96F
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 14:46:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/4] xfs: drain the buffer LRU on mount
Date: Mon, 23 Oct 2017 10:46:45 -0400
Message-Id: <20171023144646.50107-4-bfoster@redhat.com>
In-Reply-To: <20171023144646.50107-1-bfoster@redhat.com>
References: <20171023144646.50107-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Log recovery of v4 filesystems does not use buffer verifiers because
log recovery historically can result in transient buffer corruption
when target buffers might be ahead of the log after a crash. v5
filesystems work around this problem with metadata LSN ordering.

While the log recovery behavior is necessary on v4 supers, it
currently can result in leaving buffers around in the LRU without
verifiers attached for a significant amount of time. This can lead
to use of unverified buffers while the filesystem is in active use,
long after recovery has completed.

To address this problem and provide a more consistent clean,
post-mount buffer cache state, update the log mount sequence to
unconditionally drain all buffers from the LRU as a final step.

Reported-by: Darrick Wong <darrick.wong@oracle.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index dc95a49..e282fd8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -744,6 +744,7 @@ xfs_log_mount_finish(
 {
 	int	error = 0;
 	bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
+	bool	recovered = mp->m_log->l_flags & XLOG_RECOVERY_NEEDED;
 
 	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
@@ -780,6 +781,18 @@ xfs_log_mount_finish(
 	mp->m_super->s_flags &= ~MS_ACTIVE;
 	evict_inodes(mp->m_super);
 
+	/*
+	 * Drain the buffer LRU after log recovery. This is required for v4
+	 * filesystems to avoid leaving around buffers with NULL verifier ops,
+	 * but we do it unconditionally to make sure we're always in a clean
+	 * cache state after mount.
+	 */
+	if (recovered) {
+		xfs_log_force(mp, XFS_LOG_SYNC);
+		xfs_ail_push_all_sync(mp->m_ail);
+	}
+	xfs_wait_buftarg(mp->m_ddev_targp);
+
 	if (readonly)
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 
-- 
2.9.5

