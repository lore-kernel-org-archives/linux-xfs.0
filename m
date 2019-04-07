Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52154 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfDGU12 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Apr 2019 16:27:28 -0400
Subject: [PATCH 2/4] xfs: unlock inode when xfs_ioctl_setattr_get_trans
 can't get transaction
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 07 Apr 2019 13:27:16 -0700
Message-ID: <155466883603.633834.5683596746694707981.stgit@magnolia>
In-Reply-To: <155466882175.633834.15261194784129614735.stgit@magnolia>
References: <155466882175.633834.15261194784129614735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We passed an inode into xfs_ioctl_setattr_get_trans with join_flags
indicating which locks are held on that inode.  If we can't allocate a
transaction then we need to unlock the inode before we bail out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6ecdbb3af7de..91938c4f3c67 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1142,7 +1142,7 @@ xfs_ioctl_setattr_get_trans(
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
 	if (error)
-		return ERR_PTR(error);
+		goto out_unlock;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | join_flags);
