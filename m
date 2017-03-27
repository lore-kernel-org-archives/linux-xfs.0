Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44997 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751801AbdC0Uq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 16:46:26 -0400
Date: Mon, 27 Mar 2017 13:46:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: don't let suspend freeze the buffer workqueue
Message-ID: <20170327204611.GA4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-pm@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

Suspend has this annoying behavior in XFS where it freezes workqueues in
some arbitrary order.  This is a problem because the sync call can cause
an AIL push, which may have to perform a RMW cycle on an inode cluster
buffer if that buffer has been reclaimed.  When this happens, the AIL
issues a buffer read for which the io completion ends up on the xfs_buf
workqueue.  If /that/ workqueue has already been frozen, the suspend
will timeout because we froze the workqueues in the wrong order.

It seems suspicious to be freezing IO helper threads[1], so let's just
not do that anymore.  Prior to this patch, 4.10 fails to suspend on my
laptop about 80% of the time; afterwards, it works every time.  I've not
done much suspend-and-crash testing on it though.

[1] https://lwn.net/Articles/705269/

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7af5ca9..216ab89 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -842,7 +842,7 @@ xfs_init_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	mp->m_buf_workqueue = alloc_workqueue("xfs-buf/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_fsname);
+			WQ_MEM_RECLAIM, 1, mp->m_fsname);
 	if (!mp->m_buf_workqueue)
 		goto out;
 
