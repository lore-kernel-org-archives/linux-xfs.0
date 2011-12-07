Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB76Inv5046607 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 00:18:49 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E55132A1EA9
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 22:18:47 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8UCaD84W2ugW75Hx for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 22:18:47 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RYAq4-0003nw-UB
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:44 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RYApz-0003Uh-E3
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/12] xfs: add compound buffer get and read interfaces
Date: Wed,  7 Dec 2011 17:18:15 +1100
Message-Id: <1323238703-13198-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1323238703-13198-1-git-send-email-david@fromorbit.com>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

For a compound buffer, we need to have some way of specifying all
the extents that need to be part of the buffer in one structure. The
dabuf code gets this directly from xfs_bmapi() in the form of an
xfs_bmbt_irec array. It makes sense to simply use this as the method
of transferring the information to the compound buffer get and read
functions that are responsible for building such buffers.

Implement the get and read compound buffer functions using this
interface. Initially only support a single irec map to simplify the
initial implementation. Support for multiple records will be added
in future commits.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h |   10 +++++++
 2 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 152e855..aebe954 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -40,6 +40,8 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_trace.h"
+#include "xfs_bit.h"
+#include "xfs_bmap_btree.h"
 
 static kmem_zone_t *xfs_buf_zone;
 STATIC int xfsbufd(void *);
@@ -670,6 +672,82 @@ xfs_buf_readahead(
 }
 
 /*
+ * XXX: only supports a single map for now
+ */
+struct xfs_buf *
+xfs_buf_get_irec(
+	struct xfs_buftarg	*target,
+	struct xfs_bmbt_irec	*map,
+	int			nmaps,
+	xfs_buf_flags_t		flags)
+{
+	xfs_daddr_t		blkno;
+	size_t			numblks;
+	struct xfs_buf		*bp;
+
+	ASSERT_ALWAYS(nmaps == 1);
+
+	blkno = XFS_FSB_TO_DADDR(target->bt_mount, map->br_startblock);
+	numblks = XFS_FSB_TO_BB(target->bt_mount, map->br_blockcount);
+
+	bp = xfs_buf_get(target, blkno, numblks, flags);
+
+	return bp;
+}
+
+struct xfs_buf *
+xfs_buf_read_irec(
+	struct xfs_buftarg	*target,
+	struct xfs_bmbt_irec	*map,
+	int			nmaps,
+	xfs_buf_flags_t		flags)
+{
+	xfs_buf_t		*bp;
+
+	flags |= XBF_READ;
+
+	bp = xfs_buf_get_irec(target, map, nmaps, flags);
+	if (bp) {
+		trace_xfs_buf_read(bp, flags, _RET_IP_);
+
+		if (!XFS_BUF_ISDONE(bp)) {
+			XFS_STATS_INC(xb_get_read);
+			_xfs_buf_read(bp, flags);
+		} else if (flags & XBF_ASYNC) {
+			/*
+			 * Read ahead call which is already satisfied,
+			 * drop the buffer
+			 */
+			goto no_buffer;
+		} else {
+			/* We do not want read in the flags */
+			bp->b_flags &= ~XBF_READ;
+		}
+	}
+
+	return bp;
+
+ no_buffer:
+	if (flags & (XBF_LOCK | XBF_TRYLOCK))
+		xfs_buf_unlock(bp);
+	xfs_buf_rele(bp);
+	return NULL;
+}
+
+void
+xfs_buf_readahead_irec(
+	struct xfs_buftarg	*target,
+	struct xfs_bmbt_irec	*map,
+	int			nmaps)
+{
+	if (bdi_read_congested(target->bt_bdi))
+		return;
+
+	xfs_buf_read_irec(target, map, nmaps,
+		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD|XBF_DONT_BLOCK);
+}
+
+/*
  * Read an uncached buffer from disk. Allocates and returns a locked
  * buffer containing the disk contents or nothing.
  */
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 1a3367e..e3cbd73 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -122,6 +122,7 @@ typedef void (*xfs_buf_iodone_t)(struct xfs_buf *);
 
 #define XB_PAGES	2
 
+struct xfs_bmbt_irec;
 struct xfs_buf_vec {
 	xfs_daddr_t		bv_bn;	/* block number for I/O */
 	size_t			bv_len;	/* size of I/O */
@@ -189,6 +190,15 @@ struct xfs_buf *xfs_buf_read(struct xfs_buftarg *target, xfs_daddr_t blkno,
 void xfs_buf_readahead(struct xfs_buftarg *target, xfs_daddr_t blkno,
 				size_t numblks);
 
+struct xfs_buf *xfs_buf_get_irec(struct xfs_buftarg *target,
+				struct xfs_bmbt_irec *map, int nmaps,
+				xfs_buf_flags_t flags);
+struct xfs_buf *xfs_buf_read_irec(struct xfs_buftarg *target,
+				struct xfs_bmbt_irec *map, int nmaps,
+				xfs_buf_flags_t flags);
+void xfs_buf_readahead_irec(struct xfs_buftarg *target,
+				struct xfs_bmbt_irec *map, int nmaps);
+
 struct xfs_buf *xfs_buf_get_empty(struct xfs_buftarg *target, size_t numblks);
 struct xfs_buf *xfs_buf_alloc(struct xfs_buftarg *target, xfs_daddr_t blkno,
 				size_t numblks, xfs_buf_flags_t flags);
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
