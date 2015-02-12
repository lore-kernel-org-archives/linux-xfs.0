Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B7D157F51
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 12:17:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B31A304062
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 10:17:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IAIt60NE6MrkF9G3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2015 10:17:29 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1CIHTtS020186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:29 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1CIHSP6030675
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 12/18] xfs: helpers to convert holemask to/from generic
	bitmap
Date: Thu, 12 Feb 2015 13:17:19 -0500
Message-Id: <1423765045-15791-13-git-send-email-bfoster@redhat.com>
In-Reply-To: <1423765045-15791-1-git-send-email-bfoster@redhat.com>
References: <1423765045-15791-1-git-send-email-bfoster@redhat.com>
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
of logic that requires inode granular information, create a helper to
convert the holemask to an inode allocation bitmap. The inode allocation
bitmap is inode granularity similar to the inobt record free mask and
indicates which inodes of the chunk are physically allocated on disk,
irrespective of whether the inode is considered allocated or free by the
filesystem. The generic bitmap type requires the use of generic kernel
bitmap APIs.

A separate helper is provided to convert the bitmap back to a native
64-bit type (for native bitwise operations). This is required because
the generic bitmap code represents a bitmap as an array of unsigned long
in a little endian style (though each array value is cpu order). To
ensure compatibility with various word sizes and endianness',
bitmap_to_u64() exports the bitmap to little endian and swaps back to
cpu byte order.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c | 91 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc_btree.h |  7 ++++
 2 files changed, 98 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index b95aac5..6ee8697 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -427,3 +427,94 @@ xfs_inobt_maxrecs(
 		return blocklen / sizeof(xfs_inobt_rec_t);
 	return blocklen / (sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
 }
+
+/*
+ * Convert a generic bitmap to native u64.
+ */
+uint64_t
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
+ *
+ * A bit value of 1 means the inode is allocated, a value of 0 means it is free.
+ */
+void
+xfs_inobt_irec_to_allocmap(
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
+	BUILD_BUG_ON(sizeof(rec->ir_holemask) > sizeof(holemask[0]));
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
+/*
+ * Return a host format mask of all the allocated inodes in the chunk.  The
+ * bitmap format depends on the native word size (e.g.  see
+ * arch/powerpc/include/asm/bitops.h) and so we have to marshall the bitmap
+ * through a defined endian conversion so that we can perform host native 64 bit
+ * logic operations on the resultant allocation mask.
+ *
+ * A bit value of 1 means the inode is allocated, a value of 0 means it is free.
+ */
+u64
+xfs_inobt_irec_to_allocmask(
+	struct xfs_inobt_rec_incore	*irec)
+{
+	DECLARE_BITMAP(allocmap, 64);
+
+	xfs_inobt_irec_to_allocmap(allocmap, irec);
+	return bitmap_to_u64(allocmap, 64);
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index d7ebea7..cc20850 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -62,4 +62,11 @@ extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		xfs_btnum_t);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
+/*
+ * Inode record holemask to allocation bitmap conversion helpers.
+ */
+uint64_t bitmap_to_u64(const unsigned long *, int);
+void xfs_inobt_irec_to_allocmap(unsigned long *, struct xfs_inobt_rec_incore *);
+u64 xfs_inobt_irec_to_allocmask(struct xfs_inobt_rec_incore *);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
