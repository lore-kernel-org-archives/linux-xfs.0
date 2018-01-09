Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932310AbeAIOLt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jan 2018 09:11:49 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v5 16/19] fs: only set S_VERSION when updating times if necessary
Date: Tue,  9 Jan 2018 09:10:56 -0500
Message-Id: <20180109141059.25929-17-jlayton@kernel.org>
In-Reply-To: <20180109141059.25929-1-jlayton@kernel.org>
References: <20180109141059.25929-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com, krzk@kernel.org

From: Jeff Layton <jlayton@redhat.com>

We only really need to update i_version if someone has queried for it
since we last incremented it. By doing that, we can avoid having to
update the inode if the times haven't changed.

If the times have changed, then we go ahead and forcibly increment the
counter, under the assumption that we'll be going to the storage
anyway, and the increment itself is relatively cheap.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 19e72f500f71..e2ca0f4b5151 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1635,17 +1635,21 @@ static int relatime_need_update(const struct path *path, struct inode *inode,
 int generic_update_time(struct inode *inode, struct timespec *time, int flags)
 {
 	int iflags = I_DIRTY_TIME;
+	bool dirty = false;
 
 	if (flags & S_ATIME)
 		inode->i_atime = *time;
 	if (flags & S_VERSION)
-		inode_inc_iversion(inode);
+		dirty = inode_maybe_inc_iversion(inode, false);
 	if (flags & S_CTIME)
 		inode->i_ctime = *time;
 	if (flags & S_MTIME)
 		inode->i_mtime = *time;
+	if ((flags & (S_ATIME | S_CTIME | S_MTIME)) &&
+	    !(inode->i_sb->s_flags & SB_LAZYTIME))
+		dirty = true;
 
-	if (!(inode->i_sb->s_flags & SB_LAZYTIME) || (flags & S_VERSION))
+	if (dirty)
 		iflags |= I_DIRTY_SYNC;
 	__mark_inode_dirty(inode, iflags);
 	return 0;
@@ -1864,7 +1868,7 @@ int file_update_time(struct file *file)
 	if (!timespec_equal(&inode->i_ctime, &now))
 		sync_it |= S_CTIME;
 
-	if (IS_I_VERSION(inode))
+	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
 		sync_it |= S_VERSION;
 
 	if (!sync_it)
-- 
2.14.3

