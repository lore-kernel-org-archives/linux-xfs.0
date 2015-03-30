Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF40E7F54
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 10:12:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF9AA304032
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 08:12:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uGjAg6HoCqHul4zV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2015 08:12:47 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t2UFCkZa020160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 11:12:47 -0400
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t2UFCke0004651
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 11:12:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/3] xfs: use larger in-core attr firstused field and
	detect overflow
Date: Mon, 30 Mar 2015 11:12:44 -0400
Message-Id: <1427728365-15842-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1427728365-15842-1-git-send-email-bfoster@redhat.com>
References: <1427728365-15842-1-git-send-email-bfoster@redhat.com>
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

The on-disk xfs_attr3_leaf_hdr structure firstused field is 16-bit and
subject to overflow when fs block size is 64k. The field is typically
initialized to block size when an attr leaf block is initialized. This
problem is demonstrated by assert failures when running xfstests
generic/117 on an fs with 64k blocks.

To support the existing attr leaf block algorithms for insertion,
rebalance and entry movement, increase the size of the in-core firstused
field to 32-bit and handle the potential overflow on conversion to/from
the on-disk structure. If the overflow condition occurs, set a special
value in the firstused field that is translated back on header read. The
special value is only required in the case of an empty 64k attr block. A
value of zero is used because firstused is initialized to the block size
and grows backwards from there. Furthermore, the attribute block header
occupies the first bytes of the block. Thus, a value of zero has no
other legitimate meaning for this structure. Two new conversion helpers
are created to manage the conversion of firstused to and from disk.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 84 ++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_da_format.h | 14 +++++++-
 2 files changed, 92 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 3337516..149ef3f 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -86,6 +86,80 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
 			int move_count);
 STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
 
+/*
+ * attr3 block 'firstused' conversion helpers.
+ *
+ * firstused refers to the offset of the first used byte of the nameval region
+ * of an attr leaf block. The region starts at the tail of the block and expands
+ * backwards towards the middle. As such, firstused is initialized to the block
+ * size for an empty leaf block and is reduced from there.
+ *
+ * The attr3 block size is pegged to the fsb size and the maximum fsb is 64k.
+ * The in-core firstused field is 32-bit and thus supports the maximum fsb size.
+ * The on-disk field is only 16-bit, however, and overflows at 64k. Since this
+ * only occurs at exactly 64k, we use zero as a magic on-disk value to represent
+ * the attr block size. The following helpers manage the conversion between the
+ * in-core and on-disk formats.
+ */
+
+static void
+xfs_attr3_leaf_firstused_from_disk(
+	struct xfs_da_geometry		*geo,
+	struct xfs_attr3_icleaf_hdr	*to,
+	struct xfs_attr_leafblock	*from)
+{
+	struct xfs_attr3_leaf_hdr	*hdr3;
+
+	if (from->hdr.info.magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC)) {
+		hdr3 = (struct xfs_attr3_leaf_hdr *) from;
+		to->firstused = be16_to_cpu(hdr3->firstused);
+	} else {
+		to->firstused = be16_to_cpu(from->hdr.firstused);
+	}
+
+	/*
+	 * Convert from the magic fsb size value to actual blocksize. This
+	 * should only occur for empty blocks when the block size overflows
+	 * 16-bits.
+	 */
+	if (to->firstused == XFS_ATTR3_LEAF_NULLOFF) {
+		ASSERT(!to->count && !to->usedbytes);
+		ASSERT(geo->blksize > USHRT_MAX);
+		to->firstused = geo->blksize;
+	}
+}
+
+static void
+xfs_attr3_leaf_firstused_to_disk(
+	struct xfs_da_geometry		*geo,
+	struct xfs_attr_leafblock	*to,
+	struct xfs_attr3_icleaf_hdr	*from)
+{
+	struct xfs_attr3_leaf_hdr	*hdr3;
+	uint32_t			firstused;
+
+	/* magic value should only be seen on disk */
+	ASSERT(from->firstused != XFS_ATTR3_LEAF_NULLOFF);
+
+	/*
+	 * Scale down the 32-bit in-core firstused value to the 16-bit on-disk
+	 * value. This only overflows at the max supported value of 64k. Use the
+	 * magic on-disk value to represent block size in this case.
+	 */
+	firstused = from->firstused;
+	if (firstused > USHRT_MAX) {
+		ASSERT(from->firstused == geo->blksize);
+		firstused = XFS_ATTR3_LEAF_NULLOFF;
+	}
+
+	if (from->magic == XFS_ATTR3_LEAF_MAGIC) {
+		hdr3 = (struct xfs_attr3_leaf_hdr *) to;
+		hdr3->firstused = cpu_to_be16(firstused);
+	} else {
+		to->hdr.firstused = cpu_to_be16(firstused);
+	}
+}
+
 void
 xfs_attr3_leaf_hdr_from_disk(
 	struct xfs_da_geometry		*geo,
@@ -105,7 +179,7 @@ xfs_attr3_leaf_hdr_from_disk(
 		to->magic = be16_to_cpu(hdr3->info.hdr.magic);
 		to->count = be16_to_cpu(hdr3->count);
 		to->usedbytes = be16_to_cpu(hdr3->usedbytes);
-		to->firstused = be16_to_cpu(hdr3->firstused);
+		xfs_attr3_leaf_firstused_from_disk(geo, to, from);
 		to->holes = hdr3->holes;
 
 		for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
@@ -119,7 +193,7 @@ xfs_attr3_leaf_hdr_from_disk(
 	to->magic = be16_to_cpu(from->hdr.info.magic);
 	to->count = be16_to_cpu(from->hdr.count);
 	to->usedbytes = be16_to_cpu(from->hdr.usedbytes);
-	to->firstused = be16_to_cpu(from->hdr.firstused);
+	xfs_attr3_leaf_firstused_from_disk(geo, to, from);
 	to->holes = from->hdr.holes;
 
 	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
@@ -134,7 +208,7 @@ xfs_attr3_leaf_hdr_to_disk(
 	struct xfs_attr_leafblock	*to,
 	struct xfs_attr3_icleaf_hdr	*from)
 {
-	int	i;
+	int				i;
 
 	ASSERT(from->magic == XFS_ATTR_LEAF_MAGIC ||
 	       from->magic == XFS_ATTR3_LEAF_MAGIC);
@@ -147,7 +221,7 @@ xfs_attr3_leaf_hdr_to_disk(
 		hdr3->info.hdr.magic = cpu_to_be16(from->magic);
 		hdr3->count = cpu_to_be16(from->count);
 		hdr3->usedbytes = cpu_to_be16(from->usedbytes);
-		hdr3->firstused = cpu_to_be16(from->firstused);
+		xfs_attr3_leaf_firstused_to_disk(geo, to, from);
 		hdr3->holes = from->holes;
 		hdr3->pad1 = 0;
 
@@ -162,7 +236,7 @@ xfs_attr3_leaf_hdr_to_disk(
 	to->hdr.info.magic = cpu_to_be16(from->magic);
 	to->hdr.count = cpu_to_be16(from->count);
 	to->hdr.usedbytes = cpu_to_be16(from->usedbytes);
-	to->hdr.firstused = cpu_to_be16(from->firstused);
+	xfs_attr3_leaf_firstused_to_disk(geo, to, from);
 	to->hdr.holes = from->holes;
 	to->hdr.pad1 = 0;
 
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 0a49b02..74bcbab 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -725,7 +725,13 @@ struct xfs_attr3_icleaf_hdr {
 	__uint16_t	magic;
 	__uint16_t	count;
 	__uint16_t	usedbytes;
-	__uint16_t	firstused;
+	/*
+	 * firstused is 32-bit here instead of 16-bit like the on-disk variant
+	 * to support maximum fsb size of 64k without overflow issues throughout
+	 * the attr code. Instead, the overflow condition is handled on
+	 * conversion to/from disk.
+	 */
+	__uint32_t	firstused;
 	__u8		holes;
 	struct {
 		__uint16_t	base;
@@ -734,6 +740,12 @@ struct xfs_attr3_icleaf_hdr {
 };
 
 /*
+ * Special value to represent fs block size in the leaf header firstused field.
+ * Only used when block size overflows the 2-bytes available on disk.
+ */
+#define XFS_ATTR3_LEAF_NULLOFF	0
+
+/*
  * Flags used in the leaf_entry[i].flags field.
  * NOTE: the INCOMPLETE bit must not collide with the flags bits specified
  * on the system call, they are "or"ed together for various operations.
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
