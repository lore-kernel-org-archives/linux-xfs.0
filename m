Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n481DLSh241690 for <xfs@oss.sgi.com>; Thu, 7 May 2009 20:13:21 -0500
From: Felix Blyakher <felixb@sgi.com>
Subject: [PATCH] xfs: fix double unlock in xfs_swap_extents()
Date: Thu,  7 May 2009 20:13:22 -0500
Message-Id: <1241745202-7452-1-git-send-email-felixb@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org, a.beregalov@gmail.com

Regreesion from commit ef8f7fc, which rearranged the code in
xfs_swap_extents() leading to double unlock of xfs inode iolock.
That resulted in xfs_fsr deadlocking itself on platforms, which
don't handle double unlock of rw_semaphore nicely. It caused the
count go negative, which represents the write holder, without
really having one. ia64 is one of the platforms where deadlock
was easily reproduced and the fix was tested.

Signed-off-by: Felix Blyakher <felixb@sgi.com>
---
 fs/xfs/xfs_dfrag.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index e6d839b..7465f9e 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -347,13 +347,15 @@ xfs_swap_extents(
 
 	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
 
-out_unlock:
-	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 out:
 	kmem_free(tempifp);
 	return error;
 
+out_unlock:
+	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	goto out;
+
 out_trans_cancel:
 	xfs_trans_cancel(tp, 0);
 	goto out_unlock;
-- 
1.5.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
