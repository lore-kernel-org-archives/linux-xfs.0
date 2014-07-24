Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 26F3F7F51
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:23:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AABD0AC00F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 07:23:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BHqrdL2fhGiKCYUf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 07:23:12 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OENADI002639
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:11 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENAdK030185
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 12/18] xfs: helper to convert inobt record holemask to inode
	alloc. bitmap
Date: Thu, 24 Jul 2014 10:23:02 -0400
Message-Id: <1406211788-63206-13-git-send-email-bfoster@redhat.com>
In-Reply-To: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
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

The inobt record holemask field is a condensed data type designed to fit
into the existing on-disk record and is zero based (allocated regions
are set to 0, sparse regions are set to 1) to provide backwards
compatibility. Thus the type is unnecessarily complex for use in higher
level inode manipulations such as individual inode allocations, etc.

Rather than foist the complexity of dealing with this field to every bit
of logic that requires inode chunk allocation information, create the
xfs_inobt_ialloc_bitmap() helper to convert the inobt record holemask to
an inode allocation bitmap. The inode allocation bitmap is inode
granularity similar to the inobt record free mask and indicates which
inodes of the chunk are physically allocated on disk irrespective of
whether the inode is considered allocated or free by the filesystem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h |  1 +
 fs/xfs/libxfs/xfs_ialloc.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 0baad50..cbc3296 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -206,6 +206,7 @@ typedef __be32 xfs_alloc_ptr_t;
 #define	XFS_FIBT_CRC_MAGIC	0x46494233	/* 'FIB3' */
 
 typedef	__uint64_t	xfs_inofree_t;
+typedef	__uint64_t	xfs_inoalloc_t;
 #define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
 #define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
 #define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 4e98a21..166602e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -863,6 +863,73 @@ xfs_ialloc_get_rec(
 }
 
 /*
+ * Convert the inode record holemask to an inode allocation bitmap. The inode
+ * allocation bitmap is inode granularity and specifies whether an inode is
+ * physically allocated on disk (not whether the inode is considered allocated
+ * or free by the fs).
+ */
+STATIC xfs_inoalloc_t
+xfs_inobt_ialloc_bitmap(
+	struct xfs_inobt_rec_incore	*rec)
+{
+	xfs_inofree_t	bitmap = 0;
+	xfs_inofree_t	sparsebits;
+	int		nextbit;
+	int		shift;
+	__uint16_t	allocmask;
+	uint		allocbitmap;
+
+	/*
+	 * Each holemask bit represents XFS_INODES_PER_SPCHUNK inodes. Determine
+	 * the inode bits per holemask bit.
+	 */
+	sparsebits = xfs_mask64lo(XFS_INODES_PER_SPCHUNK);
+
+	/*
+	 * The bit flip and type conversion are intentionally done separately
+	 * here to zero-extend the bitmask.
+	 */
+	allocmask = ~rec->ir_holemask;
+	allocbitmap = allocmask;
+
+	/*
+	 * Each bit of allocbitmap represents an allocated region of the inode
+	 * chunk. Thus, each bit represents XFS_INODES_PER_SPCHUNK physical
+	 * inodes. Walk through allocbitmap and set the associated individual
+	 * inode bits in the inode bitmap for each allocated chunk.
+	 *
+	 * For example, consider a 512b inode fs with a cluster size of 16k.
+	 * Each holemask bit represents 4 inodes and each cluster contains 32
+	 * inodes. Since sparse chunks are allocated at cluster granularity, a
+	 * valid 16-bit holemask (and negated allocbitmap) with this geometry
+	 * might look as follows:
+	 *
+	 * 	holemask		~	allocbitmap
+	 * 	0000 0000 1111 1111	=>	1111 1111 0000 0000
+	 *
+	 * At 4 inodes per bit, this indicates that the first 32 inodes of the
+	 * chunk are not physically allocated inodes. This is a hole from the
+	 * perspective of the inode record. Converting the allocbitmap to a
+	 * 64-bit inode allocation bitmap yields:
+	 *
+	 * 	0xFFFFFFFF00000000
+	 *
+	 * ... where any of the 32 inodes defined by the higher order 32 bits of
+	 * the map could be in use or free. Logically AND this bitmap with the
+	 * record ir_free map to identify which of the physically allocated
+	 * inodes are in use.
+	 */
+	nextbit = xfs_next_bit(&allocbitmap, 1, 0);
+	while (nextbit != -1) {
+		shift = nextbit * XFS_INODES_PER_SPCHUNK;
+		bitmap |= (sparsebits << shift);
+		nextbit = xfs_next_bit(&allocbitmap, 1, nextbit + 1);
+	}
+
+	return bitmap;
+}
+
+/*
  * Allocate an inode using the inobt-only algorithm.
  */
 STATIC int
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
