Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934631AbcLURDu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:03:50 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 02/30] ecryptfs: remove unnecessary i_version bump
Date: Wed, 21 Dec 2016 12:03:19 -0500
Message-Id: <1482339827-7882-3-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

ecryptfs bumps the i_version counter when a new inode is
instantiated, but never touches it again.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ecryptfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index e7413f82d27b..9493e8614de1 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -64,7 +64,6 @@ static int ecryptfs_inode_set(struct inode *inode, void *opaque)
 	/* i_size will be overwritten for encrypted regular files */
 	fsstack_copy_inode_size(inode, lower_inode);
 	inode->i_ino = lower_inode->i_ino;
-	inode->i_version++;
 	inode->i_mapping->a_ops = &ecryptfs_aops;
 
 	if (S_ISLNK(inode->i_mode))
-- 
2.7.4

