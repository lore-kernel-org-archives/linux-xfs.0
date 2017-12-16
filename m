Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757079AbdLPNrn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 08:47:43 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 18/19] btrfs: only dirty the inode in btrfs_update_time if something was changed
Date: Sat, 16 Dec 2017 08:46:55 -0500
Message-Id: <20171216134656.15561-19-jlayton@kernel.org>
In-Reply-To: <20171216134656.15561-1-jlayton@kernel.org>
References: <20171216134656.15561-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

From: Jeff Layton <jlayton@redhat.com>

At this point, we know that "now" and the file times may differ, and we
suspect that the i_version has been flagged to be bumped. Attempt to
bump the i_version, and only mark the inode dirty if that actually
occurred or if one of the times was updated.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/btrfs/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1dfa299a31a9..5d1956ad6d39 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6106,19 +6106,20 @@ static int btrfs_update_time(struct inode *inode, struct timespec *now,
 			     int flags)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	bool dirty = flags & ~S_VERSION;
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
 
 	if (flags & S_VERSION)
-		inode_inc_iversion(inode);
+		dirty |= inode_maybe_inc_iversion(inode, dirty);
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
2.14.3

