Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA04F7F5D
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2013 23:05:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 889F2304032
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2013 21:05:09 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	R5VCaSgIWXoWgv9Q for <xfs@oss.sgi.com>;
	Sun, 10 Feb 2013 21:05:07 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1U4lZg-0000qy-Oo
	for xfs@oss.sgi.com; Mon, 11 Feb 2013 16:05:04 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1U4lZg-0005KY-L2
	for xfs@oss.sgi.com; Mon, 11 Feb 2013 16:05:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: limit speculative prealloc size on sparse files
Date: Mon, 11 Feb 2013 16:05:01 +1100
Message-Id: <1360559102-20432-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1360559102-20432-1-git-send-email-david@fromorbit.com>
References: <1360559102-20432-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Speculative preallocation based on the current file size works well
for contiguous files, but is sub-optimal for sparse files where the
EOF preallocation can fill holes and result in large amounts of
zeros being written when it is not necessary.

The algorithm is modified to prevent EOF speculative preallocation
from triggering larger allocations on IO patterns of
truncate--to-zero-seek-write-seek-write-....  which results in
non-sparse files for large files. This, unfortunately, is the way cp
now behaves when copying sparse files and so needs to be fixed.

What this code does is that it looks at the existing extent adjacent
to the current EOF and if it determines that it is a hole we disable
speculative preallocation altogether. To avoid the next write from
doing a large prealloc, it takes the size of subsequent
preallocations from the current size of the existing EOF extent.
IOWs, if you leave a hole in the file, it resets preallocation
behaviour to the same as if it was a zero size file.

Example new behaviour:

$ xfs_io -f -c "pwrite 0 31m" \
            -c "pwrite 33m 1m" \
            -c "pwrite 128m 1m" \
            -c "fiemap -v" /mnt/scratch/blah
wrote 32505856/32505856 bytes at offset 0
31 MiB, 7936 ops; 0.0000 sec (1.608 GiB/sec and 421432.7439 ops/sec)
wrote 1048576/1048576 bytes at offset 34603008
1 MiB, 256 ops; 0.0000 sec (1.462 GiB/sec and 383233.5329 ops/sec)
wrote 1048576/1048576 bytes at offset 134217728
1 MiB, 256 ops; 0.0000 sec (1.719 GiB/sec and 450704.2254 ops/sec)
/mnt/scratch/blah:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..65535]:      96..65631        65536   0x0
   1: [65536..67583]:  hole              2048
   2: [67584..69631]:  67680..69727      2048   0x0
   3: [69632..262143]: hole             192512
   4: [262144..264191]: 262240..264287    2048   0x1

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c |   77 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 67 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 364818e..e751d8d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -311,6 +311,62 @@ xfs_iomap_eof_want_preallocate(
 }
 
 /*
+ * Determine the initial size of the preallocation. We are beyond the current
+ * EOF here, but we need to take into account whether this is a sparse write or
+ * an extending write when determining the preallocation size.  Hence we need to
+ * look up the extent that ends at the current write offset and use the result
+ * to determine the preallocation size.
+ *
+ * If the extent is a hole, then preallocation is essentially disabled.
+ * Otherwise we take the size of the preceeding data extent as the basis for the
+ * preallocation size. If the size of the extent is greater than half the
+ * maximum extent length, then use the current offset as the basis. This ensures
+ * that for large files the preallocation size always extends to MAXEXTLEN
+ * rather than falling short due to things like stripe unit/width alignment of
+ * real extents.
+ */
+STATIC int
+xfs_iomap_eof_prealloc_initial_size(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_bmbt_irec_t		*imap,
+	int			nimaps)
+{
+	xfs_fileoff_t   start_fsb;
+	int		imaps = 1;
+	int		error;
+
+	ASSERT(nimaps >= imaps);
+
+	/* if we are using a specific prealloc size, return now */
+	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
+		return 0;
+
+	/*
+	 * As we write multiple pages, the offset will always align to the
+	 * start of a page and hence point to a hole at EOF. i.e. if the size if
+	 * 4096 bytes, we only have one block at FSB 0, but XFS_B_TO_FSB(4096)
+	 * will return FSB 1. Hence if there are blocks in the file, we want to
+	 * point to the block prior to the EOF block and not the hole that maps
+	 * directly at @offset.
+	 */
+	start_fsb = XFS_B_TO_FSB(mp, offset);
+	if (start_fsb)
+		start_fsb--;
+	error = xfs_bmapi_read(ip, start_fsb, 1, imap, &imaps, XFS_BMAPI_ENTIRE);
+	if (error)
+		return 0;
+
+	ASSERT(imaps == 1);
+	if (imap[0].br_startblock == HOLESTARTBLOCK)
+		return 0;
+	if (imap[0].br_blockcount <= (MAXEXTLEN >> 1))
+		return imap[0].br_blockcount;
+	return XFS_B_TO_FSB(mp, offset);
+}
+
+/*
  * If we don't have a user specified preallocation size, dynamically increase
  * the preallocation size as the size of the file grows. Cap the maximum size
  * at a single extent or less if the filesystem is near full. The closer the
@@ -319,20 +375,19 @@ xfs_iomap_eof_want_preallocate(
 STATIC xfs_fsblock_t
 xfs_iomap_prealloc_size(
 	struct xfs_mount	*mp,
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	struct xfs_bmbt_irec	*imap,
+	int			nimaps)
 {
 	xfs_fsblock_t		alloc_blocks = 0;
 
-	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
+	alloc_blocks = xfs_iomap_eof_prealloc_initial_size(mp, ip, offset,
+							   imap, nimaps);
+	if (alloc_blocks > 0) {
 		int shift = 0;
 		int64_t freesp;
 
-		/*
-		 * rounddown_pow_of_two() returns an undefined result
-		 * if we pass in alloc_blocks = 0. Hence the "+ 1" to
-		 * ensure we always pass in a non-zero value.
-		 */
-		alloc_blocks = XFS_B_TO_FSB(mp, XFS_ISIZE(ip)) + 1;
 		alloc_blocks = XFS_FILEOFF_MIN(MAXEXTLEN,
 					rounddown_pow_of_two(alloc_blocks));
 
@@ -399,7 +454,6 @@ xfs_iomap_write_delay(
 	extsz = xfs_get_extsz_hint(ip);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
-
 	error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
 				imap, XFS_WRITE_IMAPS, &prealloc);
 	if (error)
@@ -407,7 +461,10 @@ xfs_iomap_write_delay(
 
 retry:
 	if (prealloc) {
-		xfs_fsblock_t	alloc_blocks = xfs_iomap_prealloc_size(mp, ip);
+		xfs_fsblock_t	alloc_blocks;
+
+		alloc_blocks = xfs_iomap_prealloc_size(mp, ip, offset, imap,
+						       XFS_WRITE_IMAPS);
 
 		aligned_offset = XFS_WRITEIO_ALIGN(mp, (offset + count - 1));
 		ioalign = XFS_B_TO_FSBT(mp, aligned_offset);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
