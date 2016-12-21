Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964921AbcLUREO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:14 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 26/30] fs: only set S_VERSION when updating times if it has been queried
Date: Wed, 21 Dec 2016 12:03:43 -0500
Message-Id: <1482339827-7882-27-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

We only really need to update i_version if someone has queried for it
since we last incremented it. By doing that, we can avoid having to
update the inode if the times haven't changed.

If the times have changed, then we go ahead and forcibly increment the
counter, under the assumption that we'll be going to the storage
anyway, and the increment itself is relatively cheap.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/inode.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 2484d91ae8ef..584516a32905 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1621,17 +1621,18 @@ static int relatime_need_update(const struct path *path, struct inode *inode,
 int generic_update_time(struct inode *inode, struct timespec *time, int flags)
 {
 	int iflags = I_DIRTY_TIME;
+	bool dirty = flags & ~S_VERSION;
 
 	if (flags & S_ATIME)
 		inode->i_atime = *time;
-	if (flags & S_VERSION)
-		inode_inc_iversion(inode, true);
 	if (flags & S_CTIME)
 		inode->i_ctime = *time;
 	if (flags & S_MTIME)
 		inode->i_mtime = *time;
+	if (flags & S_VERSION)
+		dirty |= inode_inc_iversion(inode, dirty);
 
-	if (!(inode->i_sb->s_flags & MS_LAZYTIME) || (flags & S_VERSION))
+	if (dirty || !(inode->i_sb->s_flags & MS_LAZYTIME))
 		iflags |= I_DIRTY_SYNC;
 	__mark_inode_dirty(inode, iflags);
 	return 0;
@@ -1850,7 +1851,7 @@ int file_update_time(struct file *file)
 	if (!timespec_equal(&inode->i_ctime, &now))
 		sync_it |= S_CTIME;
 
-	if (IS_I_VERSION(inode))
+	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
 		sync_it |= S_VERSION;
 
 	if (!sync_it)
-- 
2.7.4

