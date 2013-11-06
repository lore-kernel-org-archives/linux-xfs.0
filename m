Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1090C29E3E
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 89E65AC007
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:47 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2dlTtlSkerskBHEC for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:45 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003OK-Ae
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-0008VR-9u
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 19/37] libxfs: refactor libxfs_buf_read_map for xfs_db
Date: Wed,  6 Nov 2013 12:07:05 +1100
Message-Id: <1383700043-32305-20-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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

xfs_db requires low level read/write buffer primitives that are the
equivalent of libxfs_readbufr/writebufr. The implementation of
libxfs_writebufr already handles discontiguous buffers, but there is
no equivalent libxfs_readbufr_map support in the code.

Refactor libxfs_readbuf_map into two parts - one that does the
buffer cache lookup, and the other that does the read IO. This
provides the implementation of libxfs_readbufr_map that is required
for xfs_db.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h |  3 +++
 libxfs/rdwr.c    | 61 +++++++++++++++++++++++++++++++++++++-------------------
 2 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index e017b32..b097bd2 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -444,7 +444,10 @@ extern xfs_buf_t *libxfs_getbufr(struct xfs_buftarg *, xfs_daddr_t, int);
 extern void	libxfs_putbufr(xfs_buf_t *);
 
 extern int	libxfs_writebuf_int(xfs_buf_t *, int);
+extern int	libxfs_writebufr(struct xfs_buf *);
 extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
+extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *,
+				    struct xfs_buf_map *, int, int);
 
 extern int libxfs_bhash_size;
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index f507855..7eaea0a 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -719,30 +719,18 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
 	return bp;
 }
 
-struct xfs_buf *
-libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
-		int flags, const struct xfs_buf_ops *ops)
+int
+libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp,
+		    struct xfs_buf_map *map, int nmaps, int flags)
 {
-	xfs_buf_t	*bp;
-	int		error = 0;
-	int		fd;
-	int		i;
-	char		*buf;
-
-	if (nmaps == 1)
-		return libxfs_readbuf(btp, map[0].bm_bn, map[0].bm_len,
-					flags, ops);
-
-	bp = libxfs_getbuf_map(btp, map, nmaps);
-	if (!bp)
-		return NULL;
+	int	fd = libxfs_device_to_fd(btp->dev);
+	int	error = 0;
+	char	*buf;
+	int	i;
 
-	bp->b_error = 0;
-	bp->b_ops = ops;
-	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
-		return bp;
+	ASSERT(BBTOB(len) <= bp->b_bcount);
 
-	ASSERT(bp->b_nmaps = nmaps);
+	ASSERT(bp->b_nmaps == nmaps);
 
 	fd = libxfs_device_to_fd(btp->dev);
 	buf = bp->b_addr;
@@ -762,6 +750,37 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		offset += len;
 	}
 
+	if (!error);
+		bp->b_flags |= LIBXFS_B_UPTODATE;
+#ifdef IO_DEBUG
+	printf("%lx: %s: read %u bytes, error %d, blkno=0x%llx(0x%llx), %p\n",
+		pthread_self(), __FUNCTION__, , error,
+		(long long)LIBXFS_BBTOOFF64(blkno), (long long)blkno, bp);
+#endif
+	return error;
+}
+
+struct xfs_buf *
+libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
+		int flags, const struct xfs_buf_ops *ops)
+{
+	struct xfs_buf	*bp;
+	int		error = 0;
+
+	if (nmaps == 1)
+		return libxfs_readbuf(btp, map[0].bm_bn, map[0].bm_len,
+					flags, ops);
+
+	bp = libxfs_getbuf_map(btp, map, nmaps);
+	if (!bp)
+		return NULL;
+
+	bp->b_error = 0;
+	bp->b_ops = ops;
+	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
+		return bp;
+
+	error = libxfs_readbufr_map(btp, bp, map, nmaps, flags);
 	if (!error) {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 		if (bp->b_ops)
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
