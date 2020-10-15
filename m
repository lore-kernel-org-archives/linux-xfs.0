Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB785C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7562B2224A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgJOHWL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:11 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35830 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729108AbgJOHWL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:11 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 61EA058C550
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvu-VR
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qMA-NH
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/27] xfsprogs: convert libxfs_readbufr to libxfs_buf_read_uncached
Date:   Thu, 15 Oct 2020 18:21:45 +1100
Message-Id: <20201015072155.1631135-18-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=2IXkeuMCADDlZlyG1XUA:9
        a=Xn2UWHS1tANKfdoD:21 a=OBjrrwIp2ZLFUI45:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

libxfs_readbufr()  and libxfs_readbufr_map() are messy ways of
reading an existing buffer. We have xfs_bwrite() already, so
introduced this function, implement it with the new buftarg based IO
engine, and call it xfs_bread().

Note that to make this new code be discontiguous buffer agnostic
and still play nice with rdwr.c's LIBXFS_B_DISCONTIG buffoonery,
we need to ensure buffers init both bp->b_bn and bp->b_maps[0].bm_bn
correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/io.c                   | 29 ++++------------------
 libxfs/buftarg.c          | 51 ++++++++++++++++++++++++++++++++-------
 libxfs/libxfs_api_defs.h  |  1 +
 libxfs/libxfs_io.h        |  4 +--
 libxfs/libxfs_priv.h      |  1 -
 libxfs/rdwr.c             | 24 ++++++++++--------
 libxfs/xfs_buftarg.h      | 15 ++++++++----
 libxlog/xfs_log_recover.c |  7 ++----
 repair/prefetch.c         | 22 +++++++++++------
 9 files changed, 89 insertions(+), 65 deletions(-)

diff --git a/db/io.c b/db/io.c
index c79cf1059b9e..6ba2540d89ef 100644
--- a/db/io.c
+++ b/db/io.c
@@ -424,31 +424,15 @@ ring_add(void)
 static void
 write_cur_buf(void)
 {
-	int ret;
+	struct xfs_buf	*bp = iocur_top->bp;
+	int		ret;
 
-	ret = -libxfs_bwrite(iocur_top->bp);
+	ret = -libxfs_bwrite(bp);
 	if (ret != 0)
 		dbprintf(_("write error: %s\n"), strerror(ret));
 
 	/* re-read buffer from disk */
-	ret = -libxfs_readbufr(mp->m_ddev_targp, iocur_top->bb, iocur_top->bp,
-			      iocur_top->blen, 0);
-	if (ret != 0)
-		dbprintf(_("read error: %s\n"), strerror(ret));
-}
-
-static void
-write_cur_bbs(void)
-{
-	int ret;
-
-	ret = -libxfs_bwrite(iocur_top->bp);
-	if (ret != 0)
-		dbprintf(_("write error: %s\n"), strerror(ret));
-
-
-	/* re-read buffer from disk */
-	ret = -libxfs_readbufr_map(mp->m_ddev_targp, iocur_top->bp, 0);
+	ret = -libxfs_bread(bp, bp->b_length);
 	if (ret != 0)
 		dbprintf(_("read error: %s\n"), strerror(ret));
 }
@@ -488,10 +472,7 @@ write_cur(void)
 		else if (iocur_top->dquot_buf)
 			xfs_dquot_set_crc(iocur_top->bp);
 	}
-	if (iocur_top->bbmap)
-		write_cur_bbs();
-	else
-		write_cur_buf();
+	write_cur_buf();
 
 	/* If we didn't write the crc automatically, re-check inode validity */
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
diff --git a/libxfs/buftarg.c b/libxfs/buftarg.c
index d98952940ee8..62c2bea87b5c 100644
--- a/libxfs/buftarg.c
+++ b/libxfs/buftarg.c
@@ -125,6 +125,9 @@ xfs_buf_ioend(
 		ASSERT(!bp->b_iodone);
 		bp->b_ops->verify_read(bp);
 	}
+
+	if (!bp->b_error)
+		bp->b_flags |= XBF_DONE;
 }
 
 static void
@@ -293,12 +296,47 @@ xfs_buf_get_uncached_daddr(
 
 	INIT_LIST_HEAD(&bp->b_node.cn_hash);
 	bp->b_node.cn_count = 1;
-	bp->b_bn = daddr;
+	bp->b_bn = XFS_BUF_DADDR_NULL;
         bp->b_maps[0].bm_bn = daddr;
 	*bpp = bp;
 	return 0;
 }
 
+/*
+ * Run the IO requested on a pre-configured uncached buffer. The length of the
+ * IO is capped by @bblen, so a shorter IO than the entire buffer can be done
+ * easily.
+ */
+static int
+xfs_buf_uncached_submit(
+	struct xfs_buftarg	*target,
+	struct xfs_buf		*bp,
+	size_t			bblen,
+	int			flags)
+{
+	ASSERT(bp->b_bn == XFS_BUF_DADDR_NULL);
+
+	bp->b_flags &= ~(XBF_READ | XBF_WRITE);
+	bp->b_flags |= flags;
+	bp->b_length = bblen;
+	bp->b_error = 0;
+
+	xfs_buftarg_submit_io(bp);
+	return bp->b_error;
+}
+
+int
+xfs_bread(
+	struct xfs_buf		*bp,
+	size_t			bblen)
+{
+	return xfs_buf_uncached_submit(bp->b_target, bp, bblen, XBF_READ);
+}
+
+/*
+ * Read a single contiguous range of a buftarg and return the buffer to the
+ * caller. This buffer is not cached.
+ */
 int
 xfs_buf_read_uncached(
 	struct xfs_buftarg	*target,
@@ -311,24 +349,19 @@ xfs_buf_read_uncached(
 	struct xfs_buf		 *bp;
 	int			error;
 
-
 	error = xfs_buf_get_uncached(target, bblen, flags, &bp);
 	if (error)
 		return error;
 
-	/* set up the buffer for a read IO */
 	ASSERT(bp->b_map_count == 1);
-	bp->b_maps[0].bm_bn = daddr;
-	bp->b_flags |= XBF_READ;
 	bp->b_ops = ops;
+	bp->b_maps[0].bm_bn = daddr;
 
-	xfs_buftarg_submit_io(bp);
-	if (bp->b_error) {
-		error = bp->b_error;
+	error = xfs_bread(bp, bblen);
+	if (error) {
 		xfs_buf_relse(bp);
 		return error;
 	}
-
 	*bpp = bp;
 	return 0;
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e7e42e93a07e..f4a31782020c 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -42,6 +42,7 @@
 #define xfs_bmbt_maxrecs		libxfs_bmbt_maxrecs
 #define xfs_bmdr_maxrecs		libxfs_bmdr_maxrecs
 
+#define xfs_bread			libxfs_bread
 #define xfs_btree_bload			libxfs_btree_bload
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 8408f436e5a5..c59d42e02040 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -80,9 +80,7 @@ bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
 typedef unsigned int xfs_buf_flags_t;
 
 #define xfs_buf_offset(bp, offset)	((bp)->b_addr + (offset))
-#define XFS_BUF_ADDR(bp)		((bp)->b_bn)
-
-#define XFS_BUF_SET_ADDR(bp,blk)	((bp)->b_bn = (blk))
+#define XFS_BUF_ADDR(bp)		((bp)->b_maps[0].bm_bn)
 
 void libxfs_buf_set_priority(struct xfs_buf *bp, int priority);
 int libxfs_buf_priority(struct xfs_buf *bp);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 72665f71098e..dce77024b5de 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -408,7 +408,6 @@ howmany_64(uint64_t x, uint32_t y)
 /* buffer management */
 #define XBF_TRYLOCK			0
 #define XBF_UNMAPPED			0
-#define XBF_DONE			0
 #define xfs_buf_stale(bp)		((bp)->b_flags |= LIBXFS_B_STALE)
 #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 3e755402b024..af70dbe339e4 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -247,19 +247,17 @@ __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 	bp->b_recur = 0;
 	bp->b_ops = NULL;
 	INIT_LIST_HEAD(&bp->b_li_list);
-
-	if (!bp->b_maps) {
-		bp->b_map_count = 1;
-		bp->b_maps = &bp->__b_map;
-		bp->b_maps[0].bm_bn = bp->b_bn;
-		bp->b_maps[0].bm_len = bp->b_length;
-	}
 }
 
 static void
 libxfs_initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 		unsigned int bytes)
 {
+	bp->b_map_count = 1;
+	bp->b_maps = &bp->__b_map;
+	bp->b_maps[0].bm_bn = bno;
+	bp->b_maps[0].bm_len = bytes;
+
 	__initbuf(bp, btp, bno, bytes);
 }
 
@@ -270,6 +268,11 @@ libxfs_initbuf_map(struct xfs_buf *bp, struct xfs_buftarg *btp,
 	unsigned int bytes = 0;
 	int i;
 
+	if (nmaps == 1) {
+		libxfs_initbuf(bp, btp, map[0].bm_bn, map[0].bm_len);
+		return;
+	}
+
 	bytes = sizeof(struct xfs_buf_map) * nmaps;
 	bp->b_maps = malloc(bytes);
 	if (!bp->b_maps) {
@@ -573,7 +576,7 @@ __read_buf(int fd, void *buf, int len, off64_t offset, int flags)
 	return 0;
 }
 
-int
+static int
 libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
 		int len, int flags)
 {
@@ -607,7 +610,7 @@ libxfs_readbuf_verify(
 	return bp->b_error;
 }
 
-int
+static int
 libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 {
 	int	fd;
@@ -762,7 +765,8 @@ libxfs_bwrite(
 
 	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
 		bp->b_error = __write_buf(fd, bp->b_addr, BBTOB(bp->b_length),
-				    LIBXFS_BBTOOFF64(bp->b_bn), bp->b_flags);
+				    LIBXFS_BBTOOFF64(bp->b_maps[0].bm_bn),
+				    bp->b_flags);
 	} else {
 		int	i;
 		void	*buf = bp->b_addr;
diff --git a/libxfs/xfs_buftarg.h b/libxfs/xfs_buftarg.h
index b6e365c4f5be..71054317ee9d 100644
--- a/libxfs/xfs_buftarg.h
+++ b/libxfs/xfs_buftarg.h
@@ -79,8 +79,16 @@ int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 			  size_t bblen, int flags, struct xfs_buf **bpp,
 			  const struct xfs_buf_ops *ops);
 
-#define XBF_READ	(1 << 0)
-#define XBF_WRITE	(1 << 1)
+int xfs_bread(struct xfs_buf *bp, size_t bblen);
+
+/*
+ * Temporary: these need to be the same as the LIBXFS_B_* flags until we change
+ * over to the kernel structures. For those that aren't the same or don't yet
+ * exist, start the numbering from the top down.
+ */
+#define XBF_READ	(1 << 31)
+#define XBF_WRITE	(1 << 30)
+#define XBF_DONE	(1 << 3)	// LIBXFS_B_UPTODATE 0x0008
 
 /*
  * Raw buffer access functions. These exist as temporary bridges for uncached IO
@@ -89,8 +97,5 @@ int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
  */
 struct xfs_buf *libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno,
 			int bblen);
-int libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, struct xfs_buf *, int,
-			int);
-int libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
 
 #endif /* __XFS_BUFTARG_H */
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index f566c3b54bd0..28487e233aec 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -110,15 +110,12 @@ xlog_bread_noalign(
 
 	blk_no = round_down(blk_no, log->l_sectBBsize);
 	nbblks = round_up(nbblks, log->l_sectBBsize);
-
 	ASSERT(nbblks > 0);
 	ASSERT(nbblks <= bp->b_length);
 
-	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	bp->b_length = nbblks;
-	bp->b_error = 0;
+	bp->b_maps[0].bm_bn = log->l_logBBstart + blk_no;
 
-	return libxfs_readbufr(log->l_dev, XFS_BUF_ADDR(bp), bp, nbblks, 0);
+	return libxfs_bread(bp, nbblks);
 }
 
 int
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 22a0c0c902d9..aacb96cec0da 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -474,6 +474,7 @@ pf_batch_read(
 	void			*buf)
 {
 	struct xfs_buf		*bplist[MAX_BUFS];
+	struct xfs_buf		*lbp;
 	unsigned int		num;
 	off64_t			first_off, last_off, next_off;
 	int			len, size;
@@ -518,18 +519,21 @@ pf_batch_read(
 		if (!num)
 			return;
 
+
 		/*
 		 * do a big read if 25% of the potential buffer is useful,
 		 * otherwise, find as many close together blocks and
 		 * read them in one read
 		 */
+		lbp = bplist[num - 1];
 		first_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[0]));
-		last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
-			BBTOB(bplist[num-1]->b_length);
+		last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(lbp)) +
+							BBTOB(lbp->b_length);
 		while (num > 1 && last_off - first_off > pf_max_bytes) {
 			num--;
-			last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
-				BBTOB(bplist[num-1]->b_length);
+			lbp = bplist[num - 1];
+			last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(lbp)) +
+							BBTOB(lbp->b_length);
 		}
 		if (num < ((last_off - first_off) >> (mp->m_sb.sb_blocklog + 3))) {
 			/*
@@ -545,6 +549,7 @@ pf_batch_read(
 				last_off = next_off;
 			}
 			num = i;
+			lbp = bplist[num - 1];
 		}
 
 		for (i = 0; i < num; i++) {
@@ -583,11 +588,12 @@ pf_batch_read(
 		 * guarantees that only the last buffer in the list will be a
 		 * discontiguous buffer.
 		 */
-		if ((bplist[num - 1]->b_flags & LIBXFS_B_DISCONTIG)) {
-			libxfs_readbufr_map(mp->m_ddev_targp, bplist[num - 1], 0);
-			bplist[num - 1]->b_flags |= LIBXFS_B_UNCHECKED;
-			libxfs_buf_relse(bplist[num - 1]);
+		if (lbp->b_flags & LIBXFS_B_DISCONTIG) {
+			libxfs_bread(lbp, lbp->b_length);
+			lbp->b_flags |= LIBXFS_B_UNCHECKED;
+			libxfs_buf_relse(lbp);
 			num--;
+			lbp = bplist[num - 1];
 		}
 
 		if (len > 0) {
-- 
2.28.0

