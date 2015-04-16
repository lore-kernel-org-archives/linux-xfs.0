Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E632F7F3F
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 00:01:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82268AC006
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2015 22:00:59 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8mBzHPllXGRkx9Rd for <xfs@oss.sgi.com>;
	Wed, 15 Apr 2015 22:00:57 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Yibv0-0005Qg-PE
	for xfs@oss.sgi.com; Thu, 16 Apr 2015 15:00:50 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Yibv0-0001Fk-OS
	for xfs@oss.sgi.com; Thu, 16 Apr 2015 15:00:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: extent size hints can round up extents past MAXEXTLEN
Date: Thu, 16 Apr 2015 15:00:50 +1000
Message-Id: <1429160450-4782-1-git-send-email-david@fromorbit.com>
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

This results in BMBT corruption, as seen by this test:

# mkfs.xfs -f -d size=40051712b,agcount=4 /dev/vdc
....
# mount /dev/vdc /mnt/scratch
# xfs_io -ft -c "extsize 16m" -c "falloc 0 30g" -c "bmap -vp" /mnt/scratch/foo

which results in this failure on a debug kernel:

XFS: Assertion failed: (blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0, file: fs/xfs/libxfs/xfs_bmap_btree.c, line: 211
....
Call Trace:
 [<ffffffff814cf0ff>] xfs_bmbt_set_allf+0x8f/0x100
 [<ffffffff814cf18d>] xfs_bmbt_set_all+0x1d/0x20
 [<ffffffff814f2efe>] xfs_iext_insert+0x9e/0x120
 [<ffffffff814c7956>] ? xfs_bmap_add_extent_hole_real+0x1c6/0xc70
 [<ffffffff814c7956>] xfs_bmap_add_extent_hole_real+0x1c6/0xc70
 [<ffffffff814caaab>] xfs_bmapi_write+0x72b/0xed0
 [<ffffffff811c72ac>] ? kmem_cache_alloc+0x15c/0x170
 [<ffffffff814fe070>] xfs_alloc_file_space+0x160/0x400
 [<ffffffff81ddcc29>] ? down_write+0x29/0x60
 [<ffffffff815063eb>] xfs_file_fallocate+0x29b/0x310
 [<ffffffff811d2bc8>] ? __sb_start_write+0x58/0x120
 [<ffffffff811e3e18>] ? do_vfs_ioctl+0x318/0x570
 [<ffffffff811cd680>] vfs_fallocate+0x140/0x260
 [<ffffffff811ce6f8>] SyS_fallocate+0x48/0x80
 [<ffffffff81ddec09>] system_call_fastpath+0x12/0x17

The tracepoint that indicates the extent that triggered the assert
failure is:

xfs_iext_insert:   idx 0 offset 0 block 16777224 count 2097152 flag 1

Clearly indicating that the extent length is greater than MAXEXTLEN,
which is 2097151. A prior trace point shows the allocation was an
exact size match and that a length greater than MAXEXTLEN was asked
for:

xfs_alloc_size_done:  agno 1 agbno 8 minlen 2097152 maxlen 2097152
					    ^^^^^^^        ^^^^^^^

The issue is that the extent size hint alignment is rounding up the
extent size past MAXEXTLEN, because xfs_bmapi_write() is not taking
into account extent size hints when calculating the maximum extent
length to allocate. xfs_bmapi_reserve_delalloc() is already doing
this, but direct extent allocation is not.

We don't see this problem with extent size hints through the IO path
because we can't do single IOs large enough to trigger MAXEXTLEN
allocation. fallocate(), OTOH, is not limited in it's allocation
sizes and so needs help here. The fix is simply to copy the logic
from xfs_bmapi_reserve_delalloc() and apply it apropriately to
xfs_bmapi_write().

I also add an ASSERT() to xfs_bmap_extsize_align() so we'll catch
cases of alignment exceeding MAXEXTLEN on debug kernel machines in
future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 51 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index aeffeaa..37949b5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3224,12 +3224,21 @@ xfs_bmap_extsize_align(
 		align_alen += temp;
 		align_off -= temp;
 	}
+
+	/* Same adjustment for the end of the requested area. */
+	temp = (align_alen % extsz);
+	if (temp)
+		align_alen += extsz - temp;
+
 	/*
-	 * Same adjustment for the end of the requested area.
+	 * we are in trouble if the caller requested an extent that will align
+	 * to something larger than the supported on disk extent size.  Assert
+	 * fail here to catch callers that make this mistake; they should always
+	 * be setting the maximum allocation length to be (MAXEXTLEN - extsz) so
+	 * we can round outwards here for alignment.
 	 */
-	if ((temp = (align_alen % extsz))) {
-		align_alen += extsz - temp;
-	}
+	ASSERT(align_alen <= MAXEXTLEN);
+
 	/*
 	 * If the previous block overlaps with this proposed allocation
 	 * then move the start forward without adjusting the length.
@@ -4074,6 +4083,27 @@ xfs_bmapi_read(
 	return 0;
 }
 
+/*
+ * Calculate the maximum extent length we can ask to allocate after taking into
+ * account the on-disk size limitations, the extent size hints and the size
+ * being requested. We have to deal with the extent size hint here because the
+ * allocation will attempt alignment and hence grow the length outwards by up to
+ * @extsz on either side.
+ */
+static inline xfs_extlen_t
+xfs_bmapi_max_extlen(
+	struct xfs_inode	*ip,
+	xfs_extlen_t		length)
+{
+	xfs_extlen_t		extsz = xfs_get_extsz_hint(ip);
+	xfs_extlen_t		max_length = MAXEXTLEN;
+
+	if (extsz)
+		max_length -= 2 * extsz - 1;
+
+	return (length < max_length) ? length : max_length;
+}
+
 STATIC int
 xfs_bmapi_reserve_delalloc(
 	struct xfs_inode	*ip,
@@ -4092,20 +4122,13 @@ xfs_bmapi_reserve_delalloc(
 	xfs_extlen_t		extsz;
 	int			error;
 
-	alen = XFS_FILBLKS_MIN(len, MAXEXTLEN);
+	alen = xfs_bmapi_max_extlen(ip, len);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 
-	/* Figure out the extent size, adjust alen */
+	/* Figure out the extent size, align alen */
 	extsz = xfs_get_extsz_hint(ip);
 	if (extsz) {
-		/*
-		 * Make sure we don't exceed a single extent length when we
-		 * align the extent by reducing length we are going to
-		 * allocate by the maximum amount extent size aligment may
-		 * require.
-		 */
-		alen = XFS_FILBLKS_MIN(len, MAXEXTLEN - (2 * extsz - 1));
 		error = xfs_bmap_extsize_align(mp, got, prev, extsz, rt, eof,
 					       1, 0, &aoff, &alen);
 		ASSERT(!error);
@@ -4287,7 +4310,7 @@ xfs_bmapi_allocate(
 					 &bma->prev);
 		}
 	} else {
-		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
+		bma->length = xfs_bmapi_max_extlen(bma->ip, bma->length);
 		if (!bma->eof)
 			bma->length = XFS_FILBLKS_MIN(bma->length,
 					bma->got.br_startoff - bma->offset);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
