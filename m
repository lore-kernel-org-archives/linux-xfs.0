Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756477AbeAIOLS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jan 2018 09:11:18 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v5 05/19] afs: convert to new i_version API
Date: Tue,  9 Jan 2018 09:10:45 -0500
Message-Id: <20180109141059.25929-6-jlayton@kernel.org>
In-Reply-To: <20180109141059.25929-1-jlayton@kernel.org>
References: <20180109141059.25929-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com, krzk@kernel.org

From: Jeff Layton <jlayton@redhat.com>

For AFS, it's generally treated as an opaque value, so we use the
*_raw variants of the API here.

Note that AFS has quite a different definition for this counter. AFS
only increments it on changes to the data to the data in regular files
and contents of the directories. Inode metadata changes do not result
in a version increment.

We'll need to reconcile that somehow if we ever want to present this to
userspace via statx.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/afs/fsclient.c | 3 ++-
 fs/afs/inode.c    | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index b90ef39ae914..88ec38c2d83c 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/circ_buf.h>
+#include <linux/iversion.h>
 #include "internal.h"
 #include "afs_fs.h"
 
@@ -124,7 +125,7 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
 		vnode->vfs_inode.i_ctime.tv_sec	= status->mtime_client;
 		vnode->vfs_inode.i_mtime	= vnode->vfs_inode.i_ctime;
 		vnode->vfs_inode.i_atime	= vnode->vfs_inode.i_ctime;
-		vnode->vfs_inode.i_version	= data_version;
+		inode_set_iversion_raw(&vnode->vfs_inode, data_version);
 	}
 
 	expected_version = status->data_version;
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 3415eb7484f6..dcd2e08d6cdb 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
+#include <linux/iversion.h>
 #include "internal.h"
 
 static const struct inode_operations afs_symlink_inode_operations = {
@@ -89,7 +90,7 @@ static int afs_inode_map_status(struct afs_vnode *vnode, struct key *key)
 	inode->i_atime		= inode->i_mtime = inode->i_ctime;
 	inode->i_blocks		= 0;
 	inode->i_generation	= vnode->fid.unique;
-	inode->i_version	= vnode->status.data_version;
+	inode_set_iversion_raw(inode, vnode->status.data_version);
 	inode->i_mapping->a_ops	= &afs_fs_aops;
 
 	read_sequnlock_excl(&vnode->cb_lock);
@@ -218,7 +219,7 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
 	inode->i_ctime.tv_nsec	= 0;
 	inode->i_atime		= inode->i_mtime = inode->i_ctime;
 	inode->i_blocks		= 0;
-	inode->i_version	= 0;
+	inode_set_iversion_raw(inode, 0);
 	inode->i_generation	= 0;
 
 	set_bit(AFS_VNODE_PSEUDODIR, &vnode->flags);
-- 
2.14.3

