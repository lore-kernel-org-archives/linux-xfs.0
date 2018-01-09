Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932369AbeAIOLw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jan 2018 09:11:52 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v5 17/19] xfs: avoid setting XFS_ILOG_CORE if i_version doesn't need incrementing
Date: Tue,  9 Jan 2018 09:10:57 -0500
Message-Id: <20180109141059.25929-18-jlayton@kernel.org>
In-Reply-To: <20180109141059.25929-1-jlayton@kernel.org>
References: <20180109141059.25929-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com, krzk@kernel.org

From: Jeff Layton <jlayton@redhat.com>

If XFS_ILOG_CORE is already set then go ahead and increment it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trans_inode.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 225544327c4f..4a89da4b6fe7 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -112,15 +112,17 @@ xfs_trans_log_inode(
 
 	/*
 	 * First time we log the inode in a transaction, bump the inode change
-	 * counter if it is configured for this to occur. We don't use
-	 * inode_inc_version() because there is no need for extra locking around
-	 * i_version as we already hold the inode locked exclusively for
-	 * metadata modification.
+	 * counter if it is configured for this to occur. While we have the
+	 * inode locked exclusively for metadata modification, we can usually
+	 * avoid setting XFS_ILOG_CORE if no one has queried the value since
+	 * the last time it was incremented. If we have XFS_ILOG_CORE already
+	 * set however, then go ahead and bump the i_version counter
+	 * unconditionally.
 	 */
 	if (!(ip->i_itemp->ili_item.li_desc->lid_flags & XFS_LID_DIRTY) &&
 	    IS_I_VERSION(VFS_I(ip))) {
-		inode_inc_iversion(VFS_I(ip));
-		flags |= XFS_ILOG_CORE;
+		if (inode_maybe_inc_iversion(VFS_I(ip), flags & XFS_ILOG_CORE))
+			flags |= XFS_ILOG_CORE;
 	}
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
-- 
2.14.3

