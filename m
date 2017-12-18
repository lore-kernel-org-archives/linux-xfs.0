Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758829AbdLRPMQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Dec 2017 10:12:16 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v3 06/19] btrfs: convert to new i_version API
Date: Mon, 18 Dec 2017 10:11:43 -0500
Message-Id: <20171218151156.14565-7-jlayton@kernel.org>
In-Reply-To: <20171218151156.14565-1-jlayton@kernel.org>
References: <20171218151156.14565-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

From: Jeff Layton <jlayton@redhat.com>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/btrfs/delayed-inode.c | 7 +++++--
 fs/btrfs/file.c          | 1 +
 fs/btrfs/inode.c         | 7 +++++--
 fs/btrfs/ioctl.c         | 1 +
 fs/btrfs/tree-log.c      | 4 +++-
 fs/btrfs/xattr.c         | 1 +
 6 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 5d73f79ded8b..6a246ae2bcb2 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/iversion.h>
 #include "delayed-inode.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -1700,7 +1701,8 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_inode_nbytes(inode_item, inode_get_bytes(inode));
 	btrfs_set_stack_inode_generation(inode_item,
 					 BTRFS_I(inode)->generation);
-	btrfs_set_stack_inode_sequence(inode_item, inode->i_version);
+	btrfs_set_stack_inode_sequence(inode_item,
+				       inode_peek_iversion(inode));
 	btrfs_set_stack_inode_transid(inode_item, trans->transid);
 	btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev);
 	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
@@ -1754,7 +1756,8 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 	BTRFS_I(inode)->generation = btrfs_stack_inode_generation(inode_item);
         BTRFS_I(inode)->last_trans = btrfs_stack_inode_transid(inode_item);
 
-	inode->i_version = btrfs_stack_inode_sequence(inode_item);
+	inode_set_iversion_queried(inode,
+				   btrfs_stack_inode_sequence(inode_item));
 	inode->i_rdev = 0;
 	*rdev = btrfs_stack_inode_rdev(inode_item);
 	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index eb1bac7c8553..c95d7b2efefb 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/btrfs.h>
 #include <linux/uio.h>
+#include <linux/iversion.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e1a7f3cb5be9..ac8692849a81 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -43,6 +43,7 @@
 #include <linux/posix_acl_xattr.h>
 #include <linux/uio.h>
 #include <linux/magic.h>
+#include <linux/iversion.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -3777,7 +3778,8 @@ static int btrfs_read_locked_inode(struct inode *inode)
 	BTRFS_I(inode)->generation = btrfs_inode_generation(leaf, inode_item);
 	BTRFS_I(inode)->last_trans = btrfs_inode_transid(leaf, inode_item);
 
-	inode->i_version = btrfs_inode_sequence(leaf, inode_item);
+	inode_set_iversion_queried(inode,
+				   btrfs_inode_sequence(leaf, inode_item));
 	inode->i_generation = BTRFS_I(inode)->generation;
 	inode->i_rdev = 0;
 	rdev = btrfs_inode_rdev(leaf, inode_item);
@@ -3945,7 +3947,8 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 				     &token);
 	btrfs_set_token_inode_generation(leaf, item, BTRFS_I(inode)->generation,
 					 &token);
-	btrfs_set_token_inode_sequence(leaf, item, inode->i_version, &token);
+	btrfs_set_token_inode_sequence(leaf, item, inode_peek_iversion(inode),
+				       &token);
 	btrfs_set_token_inode_transid(leaf, item, trans->transid, &token);
 	btrfs_set_token_inode_rdev(leaf, item, inode->i_rdev, &token);
 	btrfs_set_token_inode_flags(leaf, item, BTRFS_I(inode)->flags, &token);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2ef8acaac688..aa452c9e2eff 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -43,6 +43,7 @@
 #include <linux/uuid.h>
 #include <linux/btrfs.h>
 #include <linux/uaccess.h>
+#include <linux/iversion.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7bf9b31561db..1b7d92075c1f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/list_sort.h>
+#include <linux/iversion.h>
 #include "tree-log.h"
 #include "disk-io.h"
 #include "locking.h"
@@ -3609,7 +3610,8 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_token_inode_nbytes(leaf, item, inode_get_bytes(inode),
 				     &token);
 
-	btrfs_set_token_inode_sequence(leaf, item, inode->i_version, &token);
+	btrfs_set_token_inode_sequence(leaf, item,
+				       inode_peek_iversion(inode), &token);
 	btrfs_set_token_inode_transid(leaf, item, trans->transid, &token);
 	btrfs_set_token_inode_rdev(leaf, item, inode->i_rdev, &token);
 	btrfs_set_token_inode_flags(leaf, item, BTRFS_I(inode)->flags, &token);
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 2c7e53f9ff1b..5258c1714830 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -23,6 +23,7 @@
 #include <linux/xattr.h>
 #include <linux/security.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/iversion.h>
 #include "ctree.h"
 #include "btrfs_inode.h"
 #include "transaction.h"
-- 
2.14.3

