Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935649AbcLURD5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:03:57 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 09/30] reiserfs: remove unneeded i_version bump
Date: Wed, 21 Dec 2016 12:03:26 -0500
Message-Id: <1482339827-7882-10-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

The i_version field in reiserfs is not initialized and is only ever
updated here. Nothing ever views it, so just remove it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/reiserfs/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index e314cb30a181..b7cf777fc2ac 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2521,7 +2521,6 @@ static ssize_t reiserfs_quota_write(struct super_block *sb, int type,
 		return err;
 	if (inode->i_size < off + len - towrite)
 		i_size_write(inode, off + len - towrite);
-	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = current_time(inode);
 	mark_inode_dirty(inode);
 	return len - towrite;
-- 
2.7.4

