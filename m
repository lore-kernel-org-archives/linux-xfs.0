Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BDBC47CAF
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 11:16:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B6BA304032
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 09:16:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7ktaK7KZkQG3HEO8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2016 09:16:37 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id E5E20E7D17
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 16:16:36 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-134.bos.redhat.com [10.18.41.134])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u6DGGaGF023084
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 12:16:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/3] xfs: helper to set flags on uncached buffer reads
Date: Wed, 13 Jul 2016 12:16:33 -0400
Message-Id: <1468426595-35032-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1468426595-35032-1-git-send-email-bfoster@redhat.com>
References: <1468426595-35032-1-git-send-email-bfoster@redhat.com>
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

xfs_buf_read_uncached() allocates an uncached buffer and performs a read
in one go. As part of the upcoming buftarg I/O accounting mechanism,
some sites may need to set flags on a buffer before I/O submission.

Create a new helper to support the ability to set flags on a buffer
before it is submitted for I/O. This use case is the exception, so
create a wrapper for the original xfs_buf_read_uncached().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c | 20 +++++++++++++++++---
 fs/xfs/xfs_buf.h |  4 ++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4665ff6..f007713 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -693,13 +693,14 @@ xfs_buf_readahead_map(
  * buffer containing the disk contents or nothing.
  */
 int
-xfs_buf_read_uncached(
+xfs_buf_read_uncached_flags(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		daddr,
 	size_t			numblks,
 	int			flags,
 	struct xfs_buf		**bpp,
-	const struct xfs_buf_ops *ops)
+	const struct xfs_buf_ops *ops,
+	int			bflags)
 {
 	struct xfs_buf		*bp;
 
@@ -713,7 +714,7 @@ xfs_buf_read_uncached(
 	ASSERT(bp->b_map_count == 1);
 	bp->b_bn = XFS_BUF_DADDR_NULL;  /* always null for uncached buffers */
 	bp->b_maps[0].bm_bn = daddr;
-	bp->b_flags |= XBF_READ;
+	bp->b_flags |= XBF_READ | bflags;
 	bp->b_ops = ops;
 
 	xfs_buf_submit_wait(bp);
@@ -727,6 +728,19 @@ xfs_buf_read_uncached(
 	return 0;
 }
 
+int
+xfs_buf_read_uncached(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		daddr,
+	size_t			numblks,
+	int			flags,
+	struct xfs_buf		**bpp,
+	const struct xfs_buf_ops *ops)
+{
+	return xfs_buf_read_uncached_flags(target, daddr, numblks, flags, bpp,
+					   ops, 0);
+}
+
 /*
  * Return a buffer allocated as an empty buffer and associated to external
  * memory via xfs_buf_associate_memory() back to it's empty state.
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8bfb974..a3c7ba4 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -295,6 +295,10 @@ struct xfs_buf *xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 			  size_t numblks, int flags, struct xfs_buf **bpp,
 			  const struct xfs_buf_ops *ops);
+int xfs_buf_read_uncached_flags(struct xfs_buftarg *target, xfs_daddr_t daddr,
+				size_t numblks, int flags, struct xfs_buf **bpp,
+				const struct xfs_buf_ops *ops, int blags);
+
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
