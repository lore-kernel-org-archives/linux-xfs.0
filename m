Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8899F7F5D
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 10:12:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 770B9304048
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 08:12:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pU4psoqAkbV5PQXx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 08:12:29 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sA3GCShv003973
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:12:29 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sA3GCS0j017061
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:12:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 10/17] xfs: helpers to convert holemask to/from generic
	bitmap
Date: Mon,  3 Nov 2014 11:12:19 -0500
Message-Id: <1415031146-9107-11-git-send-email-bfoster@redhat.com>
In-Reply-To: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
References: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
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
compatibility. This makes the type somewhat complex for use in higher
level inode manipulations such as individual inode allocation, etc.

Rather than foist the complexity of dealing with this field to every bit
of logic that requires inode granular information, create the
xfs_inobt_ialloc_bitmap() helper to convert the holemask to an inode
allocation bitmap. The inode allocation bitmap is inode granularity
similar to the inobt record free mask and indicates which inodes of the
chunk are physically allocated on disk, irrespective of whether the
inode is considered allocated or free by the filesystem. The generic
bitmap type requires the use of generic kernel bitmap APIs.

The bitmap_to_u64() helper is provided to convert the bitmap back to a
native 64-bit type (for native bitwise operations). This is required
because the generic bitmap code represents a bitmap as an array of
unsigned long in a little endian style (though each array value is cpu
order). To ensure compatibility with various word sizes and endianness',
bitmap_to_u64() exports the bitmap to little endian and swaps back to
cpu byte order.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h |  1 +
 fs/xfs/libxfs/xfs_ialloc.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c81c1a7..f2ff6d5 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -202,6 +202,7 @@ typedef __be32 xfs_alloc_ptr_t;
 #define	XFS_FIBT_CRC_MAGIC	0x46494233	/* 'FIB3' */
 
 typedef	__uint64_t	xfs_inofree_t;
+typedef	__uint64_t	xfs_inoalloc_t;
 #define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
 #define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
 #define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d22dd8a..88ca72f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -910,6 +910,73 @@ xfs_ialloc_get_rec(
 	return 0;
 }
 
+static inline uint64_t
+bitmap_to_u64(
+	const unsigned long	*bitmap,
+	int			nbits)
+{
+	__le64			lebitmap;
+
+	ASSERT(nbits <= 64);
+
+	/*
+	 * The bitmap format depends on the native word size. E.g., bit 0 could
+	 * land in the middle of the 64 bits on a big endian 32-bit arch (see
+	 * arch/powerpc/include/asm/bitops.h). To handle this, export the bitmap
+	 * as 64-bit little endian and convert back to native byte order.
+	 */
+	bitmap_copy_le(&lebitmap, bitmap, nbits);
+	return le64_to_cpu(lebitmap);
+}
+
+/*
+ * Convert the inode record holemask to an inode allocation bitmap. The inode
+ * allocation bitmap is inode granularity and specifies whether an inode is
+ * physically allocated on disk (not whether the inode is considered allocated
+ * or free by the fs).
+ *
+ * We have to be careful with regard to byte order and word size since the
+ * generic bitmap code uses primitive types.
+ */
+STATIC void
+xfs_inobt_ialloc_bitmap(
+	unsigned long			*allocbmap,
+	struct xfs_inobt_rec_incore	*rec)
+{
+	int				nextbit;
+	DECLARE_BITMAP(holemask, 16);
+
+	bitmap_zero(allocbmap, 64);
+
+	/*
+	 * bitmaps are represented as an array of unsigned long (each in cpu
+	 * byte order). ir_holemask is only 16 bits, so direct assignment is
+	 * safe.
+	 */
+	ASSERT(sizeof(rec->ir_holemask) <= sizeof(holemask[0]));
+	holemask[0] = rec->ir_holemask;
+
+	/*
+	 * holemask is a 16-bit bitmap and inode records span 64 inodes. Thus
+	 * each holemask bit represents multiple (XFS_INODES_PER_HOLEMASK_BIT)
+	 * inodes. Since holemask bits represent holes, each set bit represents
+	 * a region of the physical chunk that is not tracked by the record.
+	 *
+	 * We want an inode granularity allocation bitmap. We have to invert the
+	 * holemask and set XFS_INODES_PER_HOLEMASK_BIT bits for each set bit.
+	 * We invert and expand simultaneously by walking the unset (zeroed)
+	 * holemask bits. For each zero bit in holemask, set the corresponding
+	 * XFS_INODES_PER_HOLEMASK_BIT bits in the allocation bitmap.
+	 */
+	nextbit = find_first_zero_bit(holemask, 16);
+	while (nextbit < 16) {
+		bitmap_set(allocbmap, nextbit * XFS_INODES_PER_HOLEMASK_BIT,
+			   XFS_INODES_PER_HOLEMASK_BIT);
+
+		nextbit = find_next_zero_bit(holemask, 16, nextbit + 1);
+	}
+}
+
 /*
  * Allocate an inode using the inobt-only algorithm.
  */
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
