Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 011687F51
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 14:50:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D46868F8094
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 12:50:28 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PBEu83OmKBOB2ZqU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2015 12:50:27 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1OKoQHW018652
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 15:50:26 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1OKoQAZ030696
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 15:50:26 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] xfs: use larger in-core attr firstused field and detect
	overflow
Date: Tue, 24 Feb 2015 15:50:24 -0500
Message-Id: <1424811024-24839-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1424811024-24839-1-git-send-email-bfoster@redhat.com>
References: <1424811024-24839-1-git-send-email-bfoster@redhat.com>
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
other legitimate meaning for this structure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 36 +++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_da_format.h |  8 +++++++-
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 3337516..3277b40 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -106,6 +106,12 @@ xfs_attr3_leaf_hdr_from_disk(
 		to->count = be16_to_cpu(hdr3->count);
 		to->usedbytes = be16_to_cpu(hdr3->usedbytes);
 		to->firstused = be16_to_cpu(hdr3->firstused);
+		if (to->firstused == XFS_ATTR3_LEAF_NULLOFF) {
+			/* only empty blocks when size overflows firstused! */
+			ASSERT(!to->count && !to->usedbytes &&
+			       geo->blksize > USHRT_MAX);
+			to->firstused = geo->blksize;
+		}
 		to->holes = hdr3->holes;
 
 		for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
@@ -120,6 +126,12 @@ xfs_attr3_leaf_hdr_from_disk(
 	to->count = be16_to_cpu(from->hdr.count);
 	to->usedbytes = be16_to_cpu(from->hdr.usedbytes);
 	to->firstused = be16_to_cpu(from->hdr.firstused);
+	if (to->firstused == XFS_ATTR3_LEAF_NULLOFF) {
+		/* only empty blocks when size overflows firstused! */
+		ASSERT(!to->count && !to->usedbytes &&
+		       geo->blksize > USHRT_MAX);
+		to->firstused = geo->blksize;
+	}
 	to->holes = from->hdr.holes;
 
 	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
@@ -134,11 +146,29 @@ xfs_attr3_leaf_hdr_to_disk(
 	struct xfs_attr_leafblock	*to,
 	struct xfs_attr3_icleaf_hdr	*from)
 {
-	int	i;
+	int				i;
+	uint16_t			firstused;
 
 	ASSERT(from->magic == XFS_ATTR_LEAF_MAGIC ||
 	       from->magic == XFS_ATTR3_LEAF_MAGIC);
 
+	/*
+	 * Handle overflow of the on-disk firstused field. firstused is
+	 * typically initialized to block size, but we only have 2-bytes in the
+	 * on-disk structure. This means a 64k block size overflows the field.
+	 *
+	 * firstused should only match block size for an empty attr block so set
+	 * a special value that the from_disk() variant can convert back to
+	 * blocksize in the in-core structure.
+	 */
+	if (from->firstused > USHRT_MAX) {
+		ASSERT(from->firstused == geo->blksize);
+		firstused = XFS_ATTR3_LEAF_NULLOFF;
+	} else {
+		ASSERT(from->firstused != 0);
+		firstused = from->firstused;
+	}
+
 	if (from->magic == XFS_ATTR3_LEAF_MAGIC) {
 		struct xfs_attr3_leaf_hdr *hdr3 = (struct xfs_attr3_leaf_hdr *)to;
 
@@ -147,7 +177,7 @@ xfs_attr3_leaf_hdr_to_disk(
 		hdr3->info.hdr.magic = cpu_to_be16(from->magic);
 		hdr3->count = cpu_to_be16(from->count);
 		hdr3->usedbytes = cpu_to_be16(from->usedbytes);
-		hdr3->firstused = cpu_to_be16(from->firstused);
+		hdr3->firstused = cpu_to_be16(firstused);
 		hdr3->holes = from->holes;
 		hdr3->pad1 = 0;
 
@@ -162,7 +192,7 @@ xfs_attr3_leaf_hdr_to_disk(
 	to->hdr.info.magic = cpu_to_be16(from->magic);
 	to->hdr.count = cpu_to_be16(from->count);
 	to->hdr.usedbytes = cpu_to_be16(from->usedbytes);
-	to->hdr.firstused = cpu_to_be16(from->firstused);
+	to->hdr.firstused = cpu_to_be16(firstused);
 	to->hdr.holes = from->holes;
 	to->hdr.pad1 = 0;
 
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 0a49b02..d2d0498 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -725,7 +725,7 @@ struct xfs_attr3_icleaf_hdr {
 	__uint16_t	magic;
 	__uint16_t	count;
 	__uint16_t	usedbytes;
-	__uint16_t	firstused;
+	__uint32_t	firstused;
 	__u8		holes;
 	struct {
 		__uint16_t	base;
@@ -734,6 +734,12 @@ struct xfs_attr3_icleaf_hdr {
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
