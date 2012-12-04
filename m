Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB4N61QG203873 for <xfs@oss.sgi.com>; Tue, 4 Dec 2012 17:06:01 -0600
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 84D7F8F804B
	for <xfs@oss.sgi.com>; Tue,  4 Dec 2012 15:08:22 -0800 (PST)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	qB4N8LPD008575
	for <xfs@oss.sgi.com>; Tue, 4 Dec 2012 17:08:21 -0600 (CST)
	(envelope-from tinguely@sgi.com)
Message-Id: <20121204224938.820985192@sgi.com>
Date: Tue, 04 Dec 2012 17:18:04 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v3 3/5] xfs: fix segment in xfs_buf_item_format_segment
References: <20121204231801.982422341@sgi.com>
Content-Disposition: inline; filename=v3-2b-handle-non-busy-segments.patch
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Not every segment in a multi-segment buffer is dirty in a
transaction and they will not be outputted. The assert in
xfs_buf_item_format_segment() that checks for the at least
one chunk of data in the segment to be used is not necessary
true for multi-segmented buffers.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_buf_item.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

Index: b/fs/xfs/xfs_buf_item.c
===================================================================
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -287,6 +287,17 @@ xfs_buf_item_format_segment(
 	 */
 	base_size = offsetof(struct xfs_buf_log_format, blf_data_map) +
 			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
+
+	nvecs = 0;
+	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
+	if (!(bip->bli_flags & XFS_BLI_STALE) && first_bit == -1) {
+		/*
+		 * If the map is not be dirty in the transaction, mark
+		 * the size as zero and do not advance the vector pointer.
+		 */
+		goto out;
+	}
+
 	vecp->i_addr = blfp;
 	vecp->i_len = base_size;
 	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
@@ -301,15 +312,13 @@ xfs_buf_item_format_segment(
 		 */
 		trace_xfs_buf_item_format_stale(bip);
 		ASSERT(blfp->blf_flags & XFS_BLF_CANCEL);
-		blfp->blf_size = nvecs;
-		return vecp;
+		goto out;
 	}
 
 	/*
 	 * Fill in an iovec for each set of contiguous chunks.
 	 */
-	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
-	ASSERT(first_bit != -1);
+
 	last_bit = first_bit;
 	nbits = 1;
 	for (;;) {
@@ -371,7 +380,8 @@ xfs_buf_item_format_segment(
 			nbits++;
 		}
 	}
-	bip->__bli_format.blf_size = nvecs;
+out:
+	blfp->blf_size = nvecs;
 	return vecp;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
