Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59582 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 15:04:45 -0400
Subject: [PATCH 2/8] xfs: unlock inode when xfs_ioctl_setattr_get_trans
 can't get transaction
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Apr 2019 12:04:39 -0700
Message-ID: <155552787973.20411.3438010430489882890.stgit@magnolia>
In-Reply-To: <155552786671.20411.6442426840435740050.stgit@magnolia>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We passed an inode into xfs_ioctl_setattr_get_trans with join_flags
indicating which locks are held on that inode.  If we can't allocate a
transaction then we need to unlock the inode before we bail out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ae615a79b266..21d6f433c375 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1153,7 +1153,7 @@ xfs_ioctl_setattr_get_trans(
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
 	if (error)
-		return ERR_PTR(error);
+		goto out_unlock;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | join_flags);
