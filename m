Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227150228.353aruju2qbqv76y@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mx1.redhat.com ([209.132.183.28]:14957 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751515AbdBXTxW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Feb 2017 14:53:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/3] xfs: fix up quotacheck buffer list error handling
Date: Fri, 24 Feb 2017 14:53:19 -0500
Message-Id: <1487966001-63263-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
References: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Martin Svec <martin.svec@zoner.cz>

The quotacheck error handling of the delwri buffer list assumes the
resident buffers are locked and doesn't clear the _XBF_DELWRI_Q flag
on the buffers that are dequeued. This can lead to assert failures
on buffer release and possibly other locking problems.

Update the error handling code to lock each buffer as it is removed
from the buffer list and clear the delwri queue flag.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c | 2 ++
 fs/xfs/xfs_qm.c  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ac3b4db..e566510 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1078,6 +1078,8 @@ void
 xfs_buf_unlock(
 	struct xfs_buf		*bp)
 {
+	ASSERT(xfs_buf_islocked(bp));
+
 	XB_CLEAR_OWNER(bp);
 	up(&bp->b_sema);
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b669b12..4ff993c 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1387,6 +1387,8 @@ xfs_qm_quotacheck(
 	while (!list_empty(&buffer_list)) {
 		struct xfs_buf *bp =
 			list_first_entry(&buffer_list, struct xfs_buf, b_list);
+		xfs_buf_lock(bp);
+		bp->b_flags &= ~_XBF_DELWRI_Q;
 		list_del_init(&bp->b_list);
 		xfs_buf_relse(bp);
 	}
-- 
2.7.4

