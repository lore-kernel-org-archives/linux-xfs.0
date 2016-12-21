Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964931AbcLUREO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:14 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 27/30] xfs: avoid setting XFS_ILOG_CORE if i_version doesn't need incrementing
Date: Wed, 21 Dec 2016 12:03:44 -0500
Message-Id: <1482339827-7882-28-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

We do go ahead and increment it though if XFS_ILOG_CORE is already
set when we get to this point.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/xfs/xfs_trans_inode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 844c08886170..fac422da0bbe 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -110,15 +110,15 @@ xfs_trans_log_inode(
 
 	/*
 	 * First time we log the inode in a transaction, bump the inode change
-	 * counter if it is configured for this to occur. We don't use
-	 * inode_inc_version() because there is no need for extra locking around
-	 * i_version as we already hold the inode locked exclusively for
-	 * metadata modification.
+	 * counter if it is configured for this to occur. While we hold the
+	 * inode locked exclusively for metadata modification, we still use
+	 * inode_inc_iversion as it allows us to avoid setting XFS_ILOG_CORE
+	 * if the version hasn't been queried since the last bump.
 	 */
 	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
 	    IS_I_VERSION(VFS_I(ip))) {
-		inode_inc_iversion_locked(VFS_I(ip));
-		flags |= XFS_ILOG_CORE;
+		if (inode_inc_iversion(VFS_I(ip), flags & XFS_ILOG_CORE))
+			flags |= XFS_ILOG_CORE;
 	}
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
-- 
2.7.4

