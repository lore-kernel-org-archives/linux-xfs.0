Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 314167F62
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 12:13:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 110B38F8040
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 10:13:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GYLbI1cHCAqcZFq8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 10:13:48 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1JIDkic017838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:13:47 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1JIDkEv029976
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:13:46 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 12/18] xfs: helper to convert holemask to inode alloc.
	bitmap
Date: Thu, 19 Feb 2015 13:13:37 -0500
Message-Id: <1424369623-5656-13-git-send-email-bfoster@redhat.com>
In-Reply-To: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
References: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
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
filesystem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c | 51 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc_btree.h |  3 +++
 2 files changed, 54 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index b95aac5..aa13b46 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -427,3 +427,54 @@ xfs_inobt_maxrecs(
 		return blocklen / sizeof(xfs_inobt_rec_t);
 	return blocklen / (sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
 }
+
+/*
+ * Convert the inode record holemask to an inode allocation bitmap. The inode
+ * allocation bitmap is inode granularity and specifies whether an inode is
+ * physically allocated on disk (not whether the inode is considered allocated
+ * or free by the fs).
+ *
+ * A bit value of 1 means the inode is allocated, a value of 0 means it is free.
+ */
+uint64_t
+xfs_inobt_irec_to_allocmask(
+	struct xfs_inobt_rec_incore	*rec)
+{
+	uint64_t			bitmap = 0;
+	uint64_t			inodespbit;
+	int				nextbit;
+	uint				allocbitmap;
+
+	/*
+	 * The holemask has 16-bits for a 64 inode record. Therefore each
+	 * holemask bit represents multiple inodes. Create a mask of bits to set
+	 * in the allocmask for each holemask bit.
+	 */
+	inodespbit = (1 << XFS_INODES_PER_HOLEMASK_BIT) - 1;
+
+	/*
+	 * Allocated inodes are represented by 0 bits in holemask. Invert the 0
+	 * bits to 1 and convert to a uint so we can use xfs_next_bit(). Mask
+	 * anything beyond the 16 holemask bits since this casts to a larger
+	 * type.
+	 */
+	allocbitmap = ~rec->ir_holemask & ((1 << XFS_INOBT_HOLEMASK_BITS) - 1);
+
+	/*
+	 * allocbitmap is the inverted holemask so every set bit represents
+	 * allocated inodes. To expand from 16-bit holemask granularity to
+	 * 64-bit (e.g., bit-per-inode), set inodespbit bits in the target
+	 * bitmap for every holemask bit.
+	 */
+	nextbit = xfs_next_bit(&allocbitmap, 1, 0);
+	while (nextbit != -1) {
+		ASSERT(nextbit < (sizeof(rec->ir_holemask) * NBBY));
+
+		bitmap |= (inodespbit <<
+			   (nextbit * XFS_INODES_PER_HOLEMASK_BIT));
+
+		nextbit = xfs_next_bit(&allocbitmap, 1, nextbit + 1);
+	}
+
+	return bitmap;
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index d7ebea7..2c581ba 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -62,4 +62,7 @@ extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		xfs_btnum_t);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
+/* ir_holemask to inode allocation bitmap conversion */
+uint64_t xfs_inobt_irec_to_allocmask(struct xfs_inobt_rec_incore *);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
