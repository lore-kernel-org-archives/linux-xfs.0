Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936248AbcLUREC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:02 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 14/30] afs: convert to new i_version API
Date: Wed, 21 Dec 2016 12:03:31 -0500
Message-Id: <1482339827-7882-15-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

For AFS, it's generally treated as an opaque value.

Note that AFS has quite a different definition for this counter. AFS
only increments it on changes to the data, not for the metadata. We'll
need to reconcile that somehow if we ever want to present this to
userspace via statx.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/afs/fsclient.c | 2 +-
 fs/afs/inode.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 31c616ab9b40..7958001a2bf7 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -108,7 +108,7 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
 		vnode->vfs_inode.i_ctime.tv_sec	= status->mtime_server;
 		vnode->vfs_inode.i_mtime	= vnode->vfs_inode.i_ctime;
 		vnode->vfs_inode.i_atime	= vnode->vfs_inode.i_ctime;
-		vnode->vfs_inode.i_version	= data_version;
+		inode_set_iversion(&vnode->vfs_inode, data_version);
 	}
 
 	expected_version = status->data_version;
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 86cc7264c21c..ec3a0274dc95 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -77,7 +77,7 @@ static int afs_inode_map_status(struct afs_vnode *vnode, struct key *key)
 	inode->i_atime		= inode->i_mtime = inode->i_ctime;
 	inode->i_blocks		= 0;
 	inode->i_generation	= vnode->fid.unique;
-	inode->i_version	= vnode->status.data_version;
+	inode_set_iversion(inode, vnode->status.data_version);
 	inode->i_mapping->a_ops	= &afs_fs_aops;
 
 	/* check to see whether a symbolic link is really a mountpoint */
@@ -182,7 +182,7 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
 	inode->i_ctime.tv_nsec	= 0;
 	inode->i_atime		= inode->i_mtime = inode->i_ctime;
 	inode->i_blocks		= 0;
-	inode->i_version	= 0;
+	inode_set_iversion(inode, 0);
 	inode->i_generation	= 0;
 
 	set_bit(AFS_VNODE_PSEUDODIR, &vnode->flags);
-- 
2.7.4

