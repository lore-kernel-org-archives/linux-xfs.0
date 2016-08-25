Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D9397D01
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:31:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C669B8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:31:25 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id dtNjsNlY7y0OIKS9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:31:23 -0700 (PDT)
Subject: [PATCH 5/6] iomap: don't set FIEMAP_EXTENT_MERGED for extent based
	filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:31:13 -0700
Message-ID: <147216787356.525.16980820316846690768.stgit@birch.djwong.org>
In-Reply-To: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, viro@ZenIV.linux.org.uk, darrick.wong@oracle.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-api@vger.kernel.org, xfs@oss.sgi.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

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
 fs/iomap.c            |    5 ++++-
 include/linux/iomap.h |    8 +++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/fs/iomap.c b/fs/iomap.c
index 7b295d5..e9b3f99 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -510,9 +510,12 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
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
index b2e30e5..3a56212 100644
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
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
