Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964943AbcLUREP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:15 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 28/30] btrfs: only dirty the inode in btrfs_update_time if something was changed
Date: Wed, 21 Dec 2016 12:03:45 -0500
Message-Id: <1482339827-7882-29-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

At this point, we know that "now" and the file times may differ, and we
suspect that the i_version has been flagged to be bumped. Attempt to
bump the i_version, and only mark the inode dirty if that actually
occurred or if one of the times was updated.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/btrfs/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a03e5a1d5e05..65a7065c0fbf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6025,19 +6025,20 @@ static int btrfs_update_time(struct inode *inode, struct timespec *now,
 			     int flags)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	bool dirty = flags & ~S_VERSION;
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
 
 	if (flags & S_VERSION)
-		inode_inc_iversion(inode, true);
+		dirty |= inode_inc_iversion(inode, dirty);
 	if (flags & S_CTIME)
 		inode->i_ctime = *now;
 	if (flags & S_MTIME)
 		inode->i_mtime = *now;
 	if (flags & S_ATIME)
 		inode->i_atime = *now;
-	return btrfs_dirty_inode(inode);
+	return dirty ? btrfs_dirty_inode(inode) : 0;
 }
 
 /*
-- 
2.7.4

