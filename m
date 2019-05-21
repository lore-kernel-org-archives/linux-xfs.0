Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56370 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfEUDrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 23:47:12 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5/7] xfs: factor log item initialisation
Date: Mon, 20 May 2019 22:47:05 -0500
Message-Id: <1558410427-1837-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Each log item type does manual initialisation of the log item.
Delayed logging introduces new fields that need initialisation, so
factor all the open coded initialisation into a common function
first.

Source kernel commit: 43f5efc5b59db1b66e39fe9fdfc4ba6a27152afa

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
[sandeen: merge to userspace]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/libxfs_priv.h |  1 +
 libxfs/logitem.c     |  8 ++------
 libxfs/util.c        | 12 ++++++++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index d668a15..a8c0f0b 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -564,6 +564,7 @@ int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 
 
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
+void xfs_log_item_init(struct xfs_mount *, struct xfs_log_item *, int);
 #define xfs_log_in_recovery(mp)	(false)
 
 /* xfs_icache.c */
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index e862ab4..14c62f6 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -103,9 +103,7 @@ xfs_buf_item_init(
 	fprintf(stderr, "adding buf item %p for not-logged buffer %p\n",
 		bip, bp);
 #endif
-	bip->bli_item.li_type = XFS_LI_BUF;
-	bip->bli_item.li_mountp = mp;
-	INIT_LIST_HEAD(&bip->bli_item.li_trans);
+	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF);
 	bip->bli_buf = bp;
 	bip->__bli_format.blf_type = XFS_LI_BUF;
 	bip->__bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
@@ -149,8 +147,6 @@ xfs_inode_item_init(
 		ip->i_ino, iip);
 #endif
 
-	iip->ili_item.li_type = XFS_LI_INODE;
-	iip->ili_item.li_mountp = mp;
-	INIT_LIST_HEAD(&iip->ili_item.li_trans);
+	xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE);
 	iip->ili_inode = ip;
 }
diff --git a/libxfs/util.c b/libxfs/util.c
index 8c9954f..0496dcb 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -692,6 +692,18 @@ xfs_log_check_lsn(
 	return true;
 }
 
+void
+xfs_log_item_init(
+	struct xfs_mount	*mp,
+	struct xfs_log_item	*item,
+	int			type)
+{
+	item->li_mountp = mp; 
+	item->li_type = type;
+        
+	INIT_LIST_HEAD(&item->li_trans);
+}   
+
 static struct xfs_buftarg *
 xfs_find_bdev_for_inode(
 	struct xfs_inode	*ip)
-- 
1.8.3.1
