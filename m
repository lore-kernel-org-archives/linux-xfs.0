Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757057AbdLPNrj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 08:47:39 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 16/19] fs: only set S_VERSION when updating times if necessary
Date: Sat, 16 Dec 2017 08:46:53 -0500
Message-Id: <20171216134656.15561-17-jlayton@kernel.org>
In-Reply-To: <20171216134656.15561-1-jlayton@kernel.org>
References: <20171216134656.15561-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

From: Jeff Layton <jlayton@redhat.com>

We only really need to update i_version if someone has queried for it
since we last incremented it. By doing that, we can avoid having to
update the inode if the times haven't changed.

If the times have changed, then we go ahead and forcibly increment the
counter, under the assumption that we'll be going to the storage
anyway, and the increment itself is relatively cheap.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/inode.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 03102d6ef044..82d625203e34 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1634,17 +1634,24 @@ static int relatime_need_update(const struct path *path, struct inode *inode,
 int generic_update_time(struct inode *inode, struct timespec *time, int flags)
 {
 	int iflags = I_DIRTY_TIME;
+	bool dirty = false;
 
-	if (flags & S_ATIME)
+	if (flags & S_ATIME) {
 		inode->i_atime = *time;
+		dirty |= !(inode->i_sb->s_flags & SB_LAZYTIME);
+	}
 	if (flags & S_VERSION)
-		inode_inc_iversion(inode);
-	if (flags & S_CTIME)
+		dirty |= inode_maybe_inc_iversion(inode, dirty);
+	if (flags & S_CTIME) {
 		inode->i_ctime = *time;
-	if (flags & S_MTIME)
+		dirty = true;
+	}
+	if (flags & S_MTIME) {
 		inode->i_mtime = *time;
+		dirty = true;
+	}
 
-	if (!(inode->i_sb->s_flags & SB_LAZYTIME) || (flags & S_VERSION))
+	if (dirty)
 		iflags |= I_DIRTY_SYNC;
 	__mark_inode_dirty(inode, iflags);
 	return 0;
@@ -1863,7 +1870,7 @@ int file_update_time(struct file *file)
 	if (!timespec_equal(&inode->i_ctime, &now))
 		sync_it |= S_CTIME;
 
-	if (IS_I_VERSION(inode))
+	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
 		sync_it |= S_VERSION;
 
 	if (!sync_it)
-- 
2.14.3

