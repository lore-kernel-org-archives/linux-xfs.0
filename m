Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6780F7CA0
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 16:47:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B8FE8F8035
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 14:47:11 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ICuCOHS0B5oDYcWu (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Aug 2016 14:47:06 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] iomap: don't set FIEMAP_EXTENT_MERGED for extent based
	filesystems
Date: Sun, 21 Aug 2016 23:47:03 +0200
Message-Id: <1471816023-28739-1-git-send-email-hch@lst.de>
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
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, agruenba@redhat.com

Filesystems like XFS that use extents should not set the
FIEMAP_EXTENT_MERGED flag in the fiemap extent structures.  To allow
for both behaviors for the upcoming gfs2 usage split the iomap
type field into type and flags, and only set FIEMAP_EXTENT_MERGED if
the IOMAP_F_MERGED flag is set.  The flags field will also come in
handy for future features such as shared extents on reflink-enabled
file systems.

Reported-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c            | 5 ++++-
 include/linux/iomap.h | 8 +++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 0342254..706270f 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -428,9 +428,12 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
 		break;
 	}
 
+	if (iomap->flags & IOMAP_F_MERGED)
+		flags |= FIEMAP_EXTENT_MERGED;
+
 	return fiemap_fill_next_extent(fi, iomap->offset,
 			iomap->blkno != IOMAP_NULL_BLOCK ? iomap->blkno << 9: 0,
-			iomap->length, flags | FIEMAP_EXTENT_MERGED);
+			iomap->length, flags);
 
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3267df4..3d70ece 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -19,6 +19,11 @@ struct vm_fault;
 #define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
 
 /*
+ * Flags for iomap mappings:
+ */
+#define IOMAP_F_MERGED	0x01	/* contains multiple blocks/extents */
+
+/*
  * Magic value for blkno:
  */
 #define IOMAP_NULL_BLOCK -1LL	/* blkno is not valid */
@@ -27,7 +32,8 @@ struct iomap {
 	sector_t		blkno;	/* 1st sector of mapping, 512b units */
 	loff_t			offset;	/* file offset of mapping, bytes */
 	u64			length;	/* length of mapping, bytes */
-	int			type;	/* type of mapping */
+	u16			type;	/* type of mapping */
+	u16			flags;	/* flags for mapping */
 	struct block_device	*bdev;	/* block device for I/O */
 };
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
