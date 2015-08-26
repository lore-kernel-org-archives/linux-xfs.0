Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7310A7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 19:32:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62253304043
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:32:49 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id HrxG1hiNAGnDmqnm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 17:32:48 -0700 (PDT)
Subject: [PATCH 04/11] libxfs: clear buffer state flags in libxfs_getbuf and
	variants
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Aug 2015 17:32:46 -0700
Message-ID: <20150826003246.23973.12895.stgit@birch.djwong.org>
In-Reply-To: <20150826003220.23973.59731.stgit@birch.djwong.org>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

When we're running xfs_repair with prefetch enabled, it's possible
that repair will decide to clear an inode without examining all
metadata blocks owned by that inode.  This leaves the unreferenced
prefetched buffers marked UNCHECKED, which will cause a subsequent CRC
error if the block is reallocated to a different structure and read
more than once.  Typically this happens when a large directory is
corrupted and lost+found has to grow to accomodate all the
disconnected inodes.

In libxfs_getbuf*(), we're supposed to return an unused buffer which
has a clean state.  Unfortunately, things like UNCHECKED can hang
around to cause incorrect verifier errors later, so change those
functions to launder the state bits clean.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 4f8212f..d28cea8 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -631,15 +631,39 @@ libxfs_getbuf_flags(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len,
 	return __cache_lookup(&key, flags);
 }
 
+/*
+ * Clean the buffer flags for libxfs_getbuf*(), which wants to return
+ * an unused buffer with clean state.  This prevents CRC errors on a
+ * re-read of a corrupt block that was prefetched and freed.  This
+ * can happen with a massively corrupt directory that is discarded,
+ * but whose blocks are then recycled into expanding lost+found.
+ *
+ * Note however that if the buffer's dirty (prefetch calls getbuf)
+ * we'll leave the state alone because we don't want to discard blocks
+ * that have been fixed.
+ */
+static void
+try_clean_buf(
+	struct xfs_buf	*bp)
+{
+	if (bp && !(bp->b_flags & LIBXFS_B_DIRTY))
+		bp->b_flags &= ~(LIBXFS_B_UNCHECKED | LIBXFS_B_STALE |
+				LIBXFS_B_UPTODATE);
+}
+
 struct xfs_buf *
 libxfs_getbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len)
 {
-	return libxfs_getbuf_flags(btp, blkno, len, 0);
+	struct xfs_buf	*bp;
+
+	bp = libxfs_getbuf_flags(btp, blkno, len, 0);
+	try_clean_buf(bp);
+	return bp;
 }
 
-struct xfs_buf *
-libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
-		  int nmaps, int flags)
+static struct xfs_buf *
+__libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
+		    int nmaps, int flags)
 {
 	struct xfs_bufkey key = {0};
 	int i;
@@ -659,6 +683,17 @@ libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 	return __cache_lookup(&key, flags);
 }
 
+struct xfs_buf *
+libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
+		  int nmaps, int flags)
+{
+	struct xfs_buf	*bp;
+
+	bp = __libxfs_getbuf_map(btp, map, nmaps, flags);
+	try_clean_buf(bp);
+	return bp;
+}
+
 void
 libxfs_putbuf(xfs_buf_t *bp)
 {
@@ -779,7 +814,7 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
 	xfs_buf_t	*bp;
 	int		error;
 
-	bp = libxfs_getbuf(btp, blkno, len);
+	bp = libxfs_getbuf_flags(btp, blkno, len, 0);
 	if (!bp)
 		return NULL;
 
@@ -860,7 +895,7 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		return libxfs_readbuf(btp, map[0].bm_bn, map[0].bm_len,
 					flags, ops);
 
-	bp = libxfs_getbuf_map(btp, map, nmaps, 0);
+	bp = __libxfs_getbuf_map(btp, map, nmaps, 0);
 	if (!bp)
 		return NULL;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
