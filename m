Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 494D57F63
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 17:21:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 29386304048
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 15:21:38 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cHxakMPj3miE7b62 for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 15:21:36 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W6TaT-0006Pu-KE
	for xfs@oss.sgi.com; Fri, 24 Jan 2014 10:21:29 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W6TaT-0008C0-JX
	for xfs@oss.sgi.com; Fri, 24 Jan 2014 10:21:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] libxfs: remove map from libxfs_readbufr_map
Date: Fri, 24 Jan 2014 10:21:23 +1100
Message-Id: <1390519284-31440-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1390519284-31440-1-git-send-email-david@fromorbit.com>
References: <1390519284-31440-1-git-send-email-david@fromorbit.com>
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

The map passed in to libxfs_readbufr_map is used to check the buffer
matches the map. However, the repair readahead code has no map it
can use to validate the buffer it set up previously, so just get rid
of the map being passed in because it serves no useful purpose.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/io.c          |  4 +---
 include/libxfs.h |  3 +--
 libxfs/rdwr.c    | 12 ++----------
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/db/io.c b/db/io.c
index 123214d..d29816c 100644
--- a/db/io.c
+++ b/db/io.c
@@ -449,9 +449,7 @@ write_cur_bbs(void)
 
 
 	/* re-read buffer from disk */
-	ret = libxfs_readbufr_map(mp->m_ddev_targp, iocur_top->bp,
-				  iocur_top->bbmap->b, iocur_top->bbmap->nmaps,
-				  0);
+	ret = libxfs_readbufr_map(mp->m_ddev_targp, iocur_top->bp, 0);
 	if (ret != 0)
 		dbprintf(_("read error: %s\n"), strerror(ret));
 }
diff --git a/include/libxfs.h b/include/libxfs.h
index 2872410..bb0369f 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -448,8 +448,7 @@ extern void	libxfs_putbufr(xfs_buf_t *);
 extern int	libxfs_writebuf_int(xfs_buf_t *, int);
 extern int	libxfs_writebufr(struct xfs_buf *);
 extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
-extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *,
-				    struct xfs_buf_map *, int, int);
+extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
 
 extern int libxfs_bhash_size;
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index bf92788..ac7739f 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -727,27 +727,19 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
 }
 
 int
-libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp,
-		    struct xfs_buf_map *map, int nmaps, int flags)
+libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 {
 	int	fd = libxfs_device_to_fd(btp->dev);
 	int	error = 0;
 	char	*buf;
 	int	i;
 
-	ASSERT(BBTOB(len) <= bp->b_bcount);
-
-	ASSERT(bp->b_nmaps == nmaps);
-
 	fd = libxfs_device_to_fd(btp->dev);
 	buf = bp->b_addr;
 	for (i = 0; i < bp->b_nmaps; i++) {
 		off64_t	offset = LIBXFS_BBTOOFF64(bp->b_map[i].bm_bn);
 		int len = BBTOB(bp->b_map[i].bm_len);
 
-		ASSERT(bp->b_map[i].bm_bn == map[i].bm_bn);
-		ASSERT(bp->b_map[i].bm_len == map[i].bm_len);
-
 		error = __read_buf(fd, buf, len, offset, flags);
 		if (error) {
 			bp->b_error = error;
@@ -787,7 +779,7 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
 		return bp;
 
-	error = libxfs_readbufr_map(btp, bp, map, nmaps, flags);
+	error = libxfs_readbufr_map(btp, bp, flags);
 	if (!error) {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 		if (bp->b_ops)
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
