Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36086 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727676AbfEJUSn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 16:18:43 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 02/11] libxfs: remove xfs_inode_log_item ili_flags
Date: Fri, 10 May 2019 15:18:21 -0500
Message-Id: <1557519510-10602-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

ili_flags is only set to zero and asserted to be zero; it serves
no purpose, so remove it.

(it was renamed to ili_lock_flags in the kernel in commit 898621d5,
for some reason userspace had both, with ili_flags ~unused)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 include/xfs_trans.h | 1 -
 libxfs/trans.c      | 6 +-----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index e6bb74c..832bde1 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -29,7 +29,6 @@ typedef struct xfs_log_item {
 typedef struct xfs_inode_log_item {
 	xfs_log_item_t		ili_item;		/* common portion */
 	struct xfs_inode	*ili_inode;		/* inode pointer */
-	unsigned short		ili_flags;		/* misc flags */
 	unsigned short		ili_lock_flags;		/* lock flags */
 	unsigned int		ili_fields;		/* fields to be logged */
 	unsigned int		ili_last_fields;	/* fields when flushed*/
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 101019b..64131b2 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -347,7 +347,6 @@ libxfs_trans_ijoin(
 	if (ip->i_itemp == NULL)
 		xfs_inode_item_init(ip, ip->i_mount);
 	iip = ip->i_itemp;
-	ASSERT(iip->ili_flags == 0);
 	ASSERT(iip->ili_inode != NULL);
 
 	ASSERT(iip->ili_lock_flags == 0);
@@ -812,10 +811,8 @@ inode_item_done(
 	mp = iip->ili_item.li_mountp;
 	ASSERT(ip != NULL);
 
-	if (!(iip->ili_fields & XFS_ILOG_ALL)) {
-		iip->ili_flags = 0;	/* reset all flags */
+	if (!(iip->ili_fields & XFS_ILOG_ALL))
 		goto free;
-	}
 
 	/*
 	 * Get the buffer containing the on-disk inode.
@@ -921,7 +918,6 @@ static void
 inode_item_unlock(
 	xfs_inode_log_item_t	*iip)
 {
-	iip->ili_flags = 0;
 	xfs_inode_item_put(iip);
 }
 
-- 
1.8.3.1
