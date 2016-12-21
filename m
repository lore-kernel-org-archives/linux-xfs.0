Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935274AbcLURDy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:03:54 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 06/30] jfs: remove initialization of i_version counter
Date: Wed, 21 Dec 2016 12:03:23 -0500
Message-Id: <1482339827-7882-7-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

It's bumped on quota writes but is otherwise untouched.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/jfs/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 85671f7f8518..2739600f826e 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -829,7 +829,6 @@ static ssize_t jfs_quota_write(struct super_block *sb, int type,
 	}
 	if (inode->i_size < off+len-towrite)
 		i_size_write(inode, off+len-towrite);
-	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = current_time(inode);
 	mark_inode_dirty(inode);
 	inode_unlock(inode);
-- 
2.7.4

