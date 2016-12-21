Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36916 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935358AbcLURDz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:03:55 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 07/30] nilfs2: remove inode->i_version initialization
Date: Wed, 21 Dec 2016 12:03:24 -0500
Message-Id: <1482339827-7882-8-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

It's never used in nilfs2.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/nilfs2/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 12eeae62a2b1..d157f6f96d9a 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -160,7 +160,6 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
 	ii->i_bh = NULL;
 	ii->i_state = 0;
 	ii->i_cno = 0;
-	ii->vfs_inode.i_version = 1;
 	nilfs_mapping_init(&ii->i_btnode_cache, &ii->vfs_inode);
 	return &ii->vfs_inode;
 }
-- 
2.7.4

