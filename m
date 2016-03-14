Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9025C7CDA
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 16:03:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D506AC002
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 14:02:58 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id y1R5r1FXx99DZm9v (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Mar 2016 14:02:55 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1afZde-0000GX-Bw
	for xfs@oss.sgi.com; Mon, 14 Mar 2016 21:02:54 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/7] xfs: make xfs_find_bdev_for_inode available outside of
	xfs_aops.c
Date: Mon, 14 Mar 2016 22:02:46 +0100
Message-Id: <1457989370-6904-4-git-send-email-hch@lst.de>
In-Reply-To: <1457989370-6904-1-git-send-email-hch@lst.de>
References: <1457989370-6904-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  | 17 ++---------------
 fs/xfs/xfs_inode.h |  9 +++++++++
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 75a39a8..72ee3f2 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -70,19 +70,6 @@ xfs_count_page_state(
 	} while ((bh = bh->b_this_page) != head);
 }
 
-STATIC struct block_device *
-xfs_find_bdev_for_inode(
-	struct inode		*inode)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-
-	if (XFS_IS_REALTIME_INODE(ip))
-		return mp->m_rtdev_targp->bt_bdev;
-	else
-		return mp->m_ddev_targp->bt_bdev;
-}
-
 /*
  * We're now finished for good with this ioend structure.
  * Update the page state via the associated buffer_heads,
@@ -1256,7 +1243,7 @@ __xfs_get_blocks(
 	 * If this is a realtime file, data may be on a different device.
 	 * to that pointed to from the buffer_head b_bdev currently.
 	 */
-	bh_result->b_bdev = xfs_find_bdev_for_inode(inode);
+	bh_result->b_bdev = xfs_find_bdev_for_inode(ip);
 
 	/*
 	 * If we previously allocated a block out beyond eof and we are now
@@ -1420,7 +1407,7 @@ xfs_vm_direct_IO(
 				 xfs_get_blocks_direct, endio, 0);
 	}
 
-	bdev = xfs_find_bdev_for_inode(inode);
+	bdev = xfs_find_bdev_for_inode(XFS_I(inode));
 	return  __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
 			xfs_get_blocks_direct, endio, NULL, flags);
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 43e1d51..70bedf0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -474,6 +474,15 @@ do { \
 	iput(VFS_I(ip)); \
 } while (0)
 
+static inline struct block_device *xfs_find_bdev_for_inode(struct xfs_inode *ip)
+{
+	if (XFS_IS_REALTIME_INODE(ip))
+		return ip->i_mount->m_rtdev_targp->bt_bdev;
+	else
+		return ip->i_mount->m_ddev_targp->bt_bdev;
+}
+
+
 extern struct kmem_zone	*xfs_inode_zone;
 
 /*
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
