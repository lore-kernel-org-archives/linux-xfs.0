Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2134A7F5D
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 02:40:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ADF7DAC003
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:40:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id qaRzgl2UIVqWs1OK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 00:40:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VmJcG-00009c-Dx
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 08:40:00 +0000
Message-Id: <20131129084000.310003388@bombadil.infradead.org>
Date: Fri, 29 Nov 2013 00:39:21 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/10] xfs: refactor xfs_buf_item_format_segment
References: <20131129083919.207915844@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0002-xfs-refactor-xfs_buf_item_format_segment.patch
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

Add two helpers to make the code more readable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c |   72 ++++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a64f67b..a30c1fb 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -182,6 +182,34 @@ xfs_buf_item_size(
 	trace_xfs_buf_item_size(bip);
 }
 
+static inline struct xfs_log_iovec *
+xfs_buf_item_copy_iovec(
+	struct xfs_log_iovec	*vecp,
+	struct xfs_buf		*bp,
+	uint			offset,
+	int			first_bit,
+	uint			nbits)
+{
+	offset += first_bit * XFS_BLF_CHUNK;
+
+	vecp->i_type = XLOG_REG_TYPE_BCHUNK;
+	vecp->i_addr = xfs_buf_offset(bp, offset);
+	vecp->i_len = nbits * XFS_BLF_CHUNK;
+	return vecp + 1;
+}
+
+static inline bool
+xfs_buf_item_straddle(
+	struct xfs_buf		*bp,
+	uint			offset,
+	int			next_bit,
+	int			last_bit)
+{
+	return xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
+		(xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
+		 XFS_BLF_CHUNK);
+}
+
 static struct xfs_log_iovec *
 xfs_buf_item_format_segment(
 	struct xfs_buf_log_item	*bip,
@@ -196,7 +224,6 @@ xfs_buf_item_format_segment(
 	int		last_bit;
 	int		next_bit;
 	uint		nbits;
-	uint		buffer_offset;
 
 	/* copy the flags across from the base format item */
 	blfp->blf_flags = bip->__bli_format.blf_flags;
@@ -239,7 +266,6 @@ xfs_buf_item_format_segment(
 	/*
 	 * Fill in an iovec for each set of contiguous chunks.
 	 */
-
 	last_bit = first_bit;
 	nbits = 1;
 	for (;;) {
@@ -252,42 +278,22 @@ xfs_buf_item_format_segment(
 		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
 					(uint)last_bit + 1);
 		/*
-		 * If we run out of bits fill in the last iovec and get
-		 * out of the loop.
-		 * Else if we start a new set of bits then fill in the
-		 * iovec for the series we were looking at and start
-		 * counting the bits in the new one.
-		 * Else we're still in the same set of bits so just
-		 * keep counting and scanning.
+		 * If we run out of bits fill in the last iovec and get out of
+		 * the loop.  Else if we start a new set of bits then fill in
+		 * the iovec for the series we were looking at and start
+		 * counting the bits in the new one.  Else we're still in the
+		 * same set of bits so just keep counting and scanning.
 		 */
 		if (next_bit == -1) {
-			buffer_offset = offset + first_bit * XFS_BLF_CHUNK;
-			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
-			vecp->i_len = nbits * XFS_BLF_CHUNK;
-			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
+			xfs_buf_item_copy_iovec(vecp, bp, offset,
+						first_bit, nbits);
 			nvecs++;
 			break;
-		} else if (next_bit != last_bit + 1) {
-			buffer_offset = offset + first_bit * XFS_BLF_CHUNK;
-			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
-			vecp->i_len = nbits * XFS_BLF_CHUNK;
-			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
-			nvecs++;
-			vecp++;
-			first_bit = next_bit;
-			last_bit = next_bit;
-			nbits = 1;
-		} else if (xfs_buf_offset(bp, offset +
-					      (next_bit << XFS_BLF_SHIFT)) !=
-			   (xfs_buf_offset(bp, offset +
-					       (last_bit << XFS_BLF_SHIFT)) +
-			    XFS_BLF_CHUNK)) {
-			buffer_offset = offset + first_bit * XFS_BLF_CHUNK;
-			vecp->i_addr = xfs_buf_offset(bp, buffer_offset);
-			vecp->i_len = nbits * XFS_BLF_CHUNK;
-			vecp->i_type = XLOG_REG_TYPE_BCHUNK;
+		} else if (next_bit != last_bit + 1 ||
+		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
+			vecp = xfs_buf_item_copy_iovec(vecp, bp, offset,
+						       first_bit, nbits);
 			nvecs++;
-			vecp++;
 			first_bit = next_bit;
 			last_bit = next_bit;
 			nbits = 1;
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
