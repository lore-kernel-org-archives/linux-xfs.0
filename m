Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD01C7CC5
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:54:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80F0E304067
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:54:09 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 5emsv4ga1FW42Ztj (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:54:07 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/8] xfs: use iomap fiemap implementation
Date: Tue, 12 Apr 2016 13:53:02 -0700
Message-Id: <1460494382-14547-9-git-send-email-hch@lst.de>
In-Reply-To: <1460494382-14547-1-git-send-email-hch@lst.de>
References: <1460494382-14547-1-git-send-email-hch@lst.de>
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
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org

Note that this removes support for the untested FIEMAP_FLAG_XATTR.  It
could be added relatively easily with iomap ops for the attr fork, but
without test coverage I don't feel safe doing this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c | 80 ++++---------------------------------------------------
 1 file changed, 5 insertions(+), 75 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6dfa10c..6e3614a 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -44,7 +44,7 @@
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
 #include <linux/security.h>
-#include <linux/fiemap.h>
+#include <linux/iomap.h>
 #include <linux/slab.h>
 
 /*
@@ -1004,51 +1004,6 @@ xfs_vn_update_time(
 	return xfs_trans_commit(tp);
 }
 
-#define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
-
-/*
- * Call fiemap helper to fill in user data.
- * Returns positive errors to xfs_getbmap.
- */
-STATIC int
-xfs_fiemap_format(
-	void			**arg,
-	struct getbmapx		*bmv,
-	int			*full)
-{
-	int			error;
-	struct fiemap_extent_info *fieinfo = *arg;
-	u32			fiemap_flags = 0;
-	u64			logical, physical, length;
-
-	/* Do nothing for a hole */
-	if (bmv->bmv_block == -1LL)
-		return 0;
-
-	logical = BBTOB(bmv->bmv_offset);
-	physical = BBTOB(bmv->bmv_block);
-	length = BBTOB(bmv->bmv_length);
-
-	if (bmv->bmv_oflags & BMV_OF_PREALLOC)
-		fiemap_flags |= FIEMAP_EXTENT_UNWRITTEN;
-	else if (bmv->bmv_oflags & BMV_OF_DELALLOC) {
-		fiemap_flags |= (FIEMAP_EXTENT_DELALLOC |
-				 FIEMAP_EXTENT_UNKNOWN);
-		physical = 0;   /* no block yet */
-	}
-	if (bmv->bmv_oflags & BMV_OF_LAST)
-		fiemap_flags |= FIEMAP_EXTENT_LAST;
-
-	error = fiemap_fill_next_extent(fieinfo, logical, physical,
-					length, fiemap_flags);
-	if (error > 0) {
-		error = 0;
-		*full = 1;	/* user array now full */
-	}
-
-	return error;
-}
-
 STATIC int
 xfs_vn_fiemap(
 	struct inode		*inode,
@@ -1056,38 +1011,13 @@ xfs_vn_fiemap(
 	u64			start,
 	u64			length)
 {
-	xfs_inode_t		*ip = XFS_I(inode);
-	struct getbmapx		bm;
 	int			error;
 
-	error = fiemap_check_flags(fieinfo, XFS_FIEMAP_FLAGS);
-	if (error)
-		return error;
-
-	/* Set up bmap header for xfs internal routine */
-	bm.bmv_offset = BTOBBT(start);
-	/* Special case for whole file */
-	if (length == FIEMAP_MAX_OFFSET)
-		bm.bmv_length = -1LL;
-	else
-		bm.bmv_length = BTOBB(start + length) - bm.bmv_offset;
-
-	/* We add one because in getbmap world count includes the header */
-	bm.bmv_count = !fieinfo->fi_extents_max ? MAXEXTNUM :
-					fieinfo->fi_extents_max + 1;
-	bm.bmv_count = min_t(__s32, bm.bmv_count,
-			     (PAGE_SIZE * 16 / sizeof(struct getbmapx)));
-	bm.bmv_iflags = BMV_IF_PREALLOC | BMV_IF_NO_HOLES;
-	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
-		bm.bmv_iflags |= BMV_IF_ATTRFORK;
-	if (!(fieinfo->fi_flags & FIEMAP_FLAG_SYNC))
-		bm.bmv_iflags |= BMV_IF_DELALLOC;
-
-	error = xfs_getbmap(ip, &bm, xfs_fiemap_format, fieinfo);
-	if (error)
-		return error;
+	xfs_ilock(XFS_I(inode), XFS_IOLOCK_SHARED);
+	error = iomap_fiemap(inode, fieinfo, start, length, &xfs_iomap_ops);
+	xfs_iunlock(XFS_I(inode), XFS_IOLOCK_SHARED);
 
-	return 0;
+	return error;
 }
 
 STATIC int
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
