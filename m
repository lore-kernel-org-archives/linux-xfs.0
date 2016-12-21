Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936401AbcLURED (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:03 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 15/30] btrfs: convert to new i_version API
Date: Wed, 21 Dec 2016 12:03:32 -0500
Message-Id: <1482339827-7882-16-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/btrfs/delayed-inode.c | 4 ++--
 fs/btrfs/inode.c         | 4 ++--
 fs/btrfs/tree-log.c      | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 80982a83c9fd..5e1015705c8b 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1744,7 +1744,7 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_inode_nbytes(inode_item, inode_get_bytes(inode));
 	btrfs_set_stack_inode_generation(inode_item,
 					 BTRFS_I(inode)->generation);
-	btrfs_set_stack_inode_sequence(inode_item, inode->i_version);
+	btrfs_set_stack_inode_sequence(inode_item, inode_get_iversion(inode));
 	btrfs_set_stack_inode_transid(inode_item, trans->transid);
 	btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev);
 	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
@@ -1798,7 +1798,7 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 	BTRFS_I(inode)->generation = btrfs_stack_inode_generation(inode_item);
         BTRFS_I(inode)->last_trans = btrfs_stack_inode_transid(inode_item);
 
-	inode->i_version = btrfs_stack_inode_sequence(inode_item);
+	inode_set_iversion_read(inode, btrfs_stack_inode_sequence(inode_item));
 	inode->i_rdev = 0;
 	*rdev = btrfs_stack_inode_rdev(inode_item);
 	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f2b281ad7af6..a56a45a3e992 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3732,7 +3732,7 @@ static int btrfs_read_locked_inode(struct inode *inode)
 	BTRFS_I(inode)->generation = btrfs_inode_generation(leaf, inode_item);
 	BTRFS_I(inode)->last_trans = btrfs_inode_transid(leaf, inode_item);
 
-	inode->i_version = btrfs_inode_sequence(leaf, inode_item);
+	inode_set_iversion_read(inode, btrfs_inode_sequence(leaf, inode_item));
 	inode->i_generation = BTRFS_I(inode)->generation;
 	inode->i_rdev = 0;
 	rdev = btrfs_inode_rdev(leaf, inode_item);
@@ -3903,7 +3903,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 				     &token);
 	btrfs_set_token_inode_generation(leaf, item, BTRFS_I(inode)->generation,
 					 &token);
-	btrfs_set_token_inode_sequence(leaf, item, inode->i_version, &token);
+	btrfs_set_token_inode_sequence(leaf, item, inode_get_iversion(inode), &token);
 	btrfs_set_token_inode_transid(leaf, item, trans->transid, &token);
 	btrfs_set_token_inode_rdev(leaf, item, inode->i_rdev, &token);
 	btrfs_set_token_inode_flags(leaf, item, BTRFS_I(inode)->flags, &token);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f10bf5213ed8..4acc4d27383a 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3585,7 +3585,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_token_inode_nbytes(leaf, item, inode_get_bytes(inode),
 				     &token);
 
-	btrfs_set_token_inode_sequence(leaf, item, inode->i_version, &token);
+	btrfs_set_token_inode_sequence(leaf, item, inode_get_iversion(inode), &token);
 	btrfs_set_token_inode_transid(leaf, item, trans->transid, &token);
 	btrfs_set_token_inode_rdev(leaf, item, inode->i_rdev, &token);
 	btrfs_set_token_inode_flags(leaf, item, BTRFS_I(inode)->flags, &token);
-- 
2.7.4

