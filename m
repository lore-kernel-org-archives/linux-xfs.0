Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B9737F5F
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 03:00:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B33430407F
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 01:00:01 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id GRbGXdB8TzG7TdUc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 00:59:58 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WYsqz-0006GO-0e
	for xfs@oss.sgi.com; Sat, 12 Apr 2014 07:59:57 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/9] xfs: remove XFS_IFILESTREAM
Date: Sat, 12 Apr 2014 10:01:59 +0200
Message-Id: <1397289723-26243-6-git-send-email-hch@lst.de>
In-Reply-To: <1397289723-26243-1-git-send-email-hch@lst.de>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
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

We never test the flag except in xfs_inode_is_filestream, but that
function already tests the on-disk flag or filesystem wide flags,
and is used to decide if we want to set XFS_IFILESTREAM in the
first place.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_filestream.c |    2 --
 fs/xfs/xfs_filestream.h |    1 -
 fs/xfs/xfs_inode.c      |    2 --
 fs/xfs/xfs_inode.h      |    4 +---
 4 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index dde529f..c422110 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -430,8 +430,6 @@ xfs_fstrm_free_func(
 		container_of(mru, fstrm_item_t, mru);
 	xfs_inode_t	*ip = item->ip;
 
-	xfs_iflags_clear(ip, XFS_IFILESTREAM);
-
 	/* Drop the reference taken on the AG when the item was added. */
 	xfs_filestream_put_ag(ip->i_mount, item->ag);
 
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 6d61dbe..c4fa9a0 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -63,7 +63,6 @@ xfs_inode_is_filestream(
 	struct xfs_inode	*ip)
 {
 	return (ip->i_mount->m_flags & XFS_MOUNT_FILESTREAMS) ||
-		xfs_iflags_test(ip, XFS_IFILESTREAM) ||
 		(ip->i_d.di_flags & XFS_DIFLAG_FILESTREAM);
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5e7a38f..3328320 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -849,8 +849,6 @@ xfs_ialloc(
 		error = xfs_filestream_associate(pip, ip);
 		if (error < 0)
 			return -error;
-		if (!error)
-			xfs_iflags_set(ip, XFS_IFILESTREAM);
 	}
 
 	*ipp = ip;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 396cc1f..a7c2ebf 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -209,7 +209,6 @@ xfs_get_initial_prid(struct xfs_inode *dp)
 #define XFS_ISTALE		(1 << 1) /* inode has been staled */
 #define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
 #define XFS_INEW		(1 << 3) /* inode has just been allocated */
-#define XFS_IFILESTREAM		(1 << 4) /* inode is in a filestream dir. */
 #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
 #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
 #define __XFS_IFLOCK_BIT	7	 /* inode is being flushed right now */
@@ -225,8 +224,7 @@ xfs_get_initial_prid(struct xfs_inode *dp)
  */
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
-	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | \
-	 XFS_IFILESTREAM);
+	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED)
 
 /*
  * Synchronize processes attempting to flush the in-core inode back to disk.
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
