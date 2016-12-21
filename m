Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933996AbcLURDx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:03:53 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 05/30] hpfs: don't bother with the i_version counter
Date: Wed, 21 Dec 2016 12:03:22 -0500
Message-Id: <1482339827-7882-6-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Nothing uses it on HPFS.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/hpfs/dir.c   | 1 -
 fs/hpfs/dnode.c | 2 --
 fs/hpfs/super.c | 1 -
 3 files changed, 4 deletions(-)

diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index 7b9150c2e75c..1a9fded00378 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -149,7 +149,6 @@ static int hpfs_readdir(struct file *file, struct dir_context *ctx)
 			if (unlikely(ret < 0))
 				goto out;
 			ctx->pos = ((loff_t) hpfs_de_as_down_as_possible(inode->i_sb, hpfs_inode->i_dno) << 4) + 1;
-			file->f_version = inode->i_version;
 		}
 		next_pos = ctx->pos;
 		if (!(de = map_pos_dirent(inode, &next_pos, &qbh))) {
diff --git a/fs/hpfs/dnode.c b/fs/hpfs/dnode.c
index 86ab7e790b4e..454acb0a009a 100644
--- a/fs/hpfs/dnode.c
+++ b/fs/hpfs/dnode.c
@@ -418,7 +418,6 @@ int hpfs_add_dirent(struct inode *i,
 		c = 1;
 		goto ret;
 	}	
-	i->i_version++;
 	c = hpfs_add_to_dnode(i, dno, name, namelen, new_de, 0);
 	ret:
 	return c;
@@ -725,7 +724,6 @@ int hpfs_remove_dirent(struct inode *i, dnode_secno dno, struct hpfs_dirent *de,
 			return 2;
 		}
 	}
-	i->i_version++;
 	for_all_poss(i, hpfs_pos_del, (t = get_pos(dnode, de)) + 1, 1);
 	hpfs_delete_de(i->i_sb, dnode, de);
 	hpfs_mark_4buffers_dirty(qbh);
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 82067ca22f2b..2fd66c854255 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -235,7 +235,6 @@ static struct inode *hpfs_alloc_inode(struct super_block *sb)
 	ei = kmem_cache_alloc(hpfs_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
-	ei->vfs_inode.i_version = 1;
 	return &ei->vfs_inode;
 }
 
-- 
2.7.4

