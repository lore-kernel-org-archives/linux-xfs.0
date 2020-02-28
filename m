Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E888C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FE6B2469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PN8xt0B+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgB1XjA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:39:00 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgB1XjA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:39:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNbnd8160778;
        Fri, 28 Feb 2020 23:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SgfvDRLQ00oMdtbW6ekG3r4LJwxjrp0JB0KuyMGdSsk=;
 b=PN8xt0B+7w0hHnbtkw8dogskN8+0Z98ChMXOMwiLDdeanLC/v0d7oaJ7oP4qLYtlYMVP
 sVQNFdqyEGNa92vc8HYHhfL/FM/CNYBLqQKu9Jt7wOJMuyPgO5nEHEEQ6A/SM3JanZoE
 qESLwnhlNoXapJwgzAt0Yasx1z0UHlLNAl+5Gf45E+A99xKZwAAwmm4ZwXyOoWmlbKAU
 Uo6+ZNh5yHf6L6IbjCny9VDhpZ8u0RCmDIhk6izyLV0oHvp+HsSRfj2Fhm2F1Pa04KkM
 Q2Ym7t+xhIrp5FKXRnUvnW45dTaV6+H2l+MjR8dJVdy6cjXrRiL1tJ+auUmrIIEGtiS+ vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yf0dmc5xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWOlU155973;
        Fri, 28 Feb 2020 23:36:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ydcsgb6r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:36:53 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SNaqwJ020345;
        Fri, 28 Feb 2020 23:36:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:36:48 -0800
Subject: [PATCH 05/26] libxfs: replace libxfs_getbuf with libxfs_buf_get
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:36:47 -0800
Message-ID: <158293300761.1549542.5257443971275230708.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change all the libxfs_getbuf calls to libxfs_buf_get to match the
kernel interface, since one is a #define of the other.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/cache.h          |    2 +-
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/libxfs_io.h       |   21 ++++++++++++++++-----
 libxfs/libxfs_priv.h     |    1 -
 libxfs/rdwr.c            |   34 ++++++++++++++++------------------
 mkfs/xfs_mkfs.c          |    9 +++++----
 repair/phase5.c          |   30 +++++++++++++++---------------
 7 files changed, 54 insertions(+), 44 deletions(-)


diff --git a/include/cache.h b/include/cache.h
index 552b9248..334ad263 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -33,7 +33,7 @@ enum {
  * For prefetch support, the top half of the range starts at
  * CACHE_PREFETCH_PRIORITY and everytime the buffer is fetched and is at or
  * above this priority level, it is reduced to below this level (refer to
- * libxfs_getbuf).
+ * libxfs_buf_get).
  *
  * If we have dirty nodes, we can't recycle them until they've been cleaned. To
  * keep these out of the reclaimable lists (as there can be lots of them) give
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 8bca7ddf..6d86774f 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -44,6 +44,7 @@
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
 #define xfs_btree_init_block		libxfs_btree_init_block
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
+#define xfs_buf_get			libxfs_buf_get
 #define xfs_buf_relse			libxfs_buf_relse
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 3ddfc0c8..50b7cef8 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -139,7 +139,7 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_writebuf(buf, flags) \
 	libxfs_trace_writebuf(__FUNCTION__, __FILE__, __LINE__, \
 			      (buf), (flags))
-#define libxfs_getbuf(dev, daddr, len) \
+#define libxfs_buf_get(dev, daddr, len) \
 	libxfs_trace_getbuf(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len))
 #define libxfs_getbuf_map(dev, map, nmaps, flags) \
@@ -159,8 +159,9 @@ extern xfs_buf_t *libxfs_trace_readbuf_map(const char *, const char *, int,
 			const struct xfs_buf_ops *);
 extern int	libxfs_trace_writebuf(const char *, const char *, int,
 			xfs_buf_t *, int);
-extern xfs_buf_t *libxfs_trace_getbuf(const char *, const char *, int,
-			struct xfs_buftarg *, xfs_daddr_t, int);
+struct xfs_buf *libxfs_trace_getbuf(const char *func, const char *file,
+			int line, struct xfs_buftarg *btp, xfs_daddr_t daddr,
+			size_t len);
 extern xfs_buf_t *libxfs_trace_getbuf_map(const char *, const char *, int,
 			struct xfs_buftarg *, struct xfs_buf_map *, int, int);
 extern xfs_buf_t *libxfs_trace_getbuf_flags(const char *, const char *, int,
@@ -175,14 +176,24 @@ extern xfs_buf_t *libxfs_readbuf(struct xfs_buftarg *, xfs_daddr_t, int, int,
 extern xfs_buf_t *libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 			int, int, const struct xfs_buf_ops *);
 extern int	libxfs_writebuf(xfs_buf_t *, int);
-extern xfs_buf_t *libxfs_getbuf(struct xfs_buftarg *, xfs_daddr_t, int);
 extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
 			struct xfs_buf_map *, int, int);
 extern xfs_buf_t *libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t,
 			int, unsigned int);
 void	libxfs_buf_relse(struct xfs_buf *bp);
 
-#endif
+static inline struct xfs_buf*
+libxfs_buf_get(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks)
+{
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+
+	return libxfs_getbuf_map(target, &map, 1, 0);
+}
+
+#endif /* XFS_BUF_TRACING */
 
 extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
 			const struct xfs_buf_ops *ops);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 4bd3c462..0f26120f 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -377,7 +377,6 @@ roundup_64(uint64_t x, uint32_t y)
 	(len) = __bar; /* no set-but-unused warning */	\
 	NULL;						\
 })
-#define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
 #define xfs_buf_oneshot(bp)		((void) 0)
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index a7f9c327..8fc9222e 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -30,7 +30,7 @@
  * outside libxfs clears bp->b_error - very little code even checks it - so the
  * libxfs code is tripping on stale errors left by the userspace code.
  *
- * We can't clear errors or zero buffer contents in libxfs_getbuf-* like we do
+ * We can't clear errors or zero buffer contents in libxfs_buf_get-* like we do
  * in the kernel, because those functions are used by the libxfs_readbuf_*
  * functions and hence need to leave the buffers unchanged on cache hits. This
  * is actually the only way to gather a write error from a libxfs_writebuf()
@@ -44,7 +44,7 @@
  *
  * IOWs, userspace is behaving quite differently to the kernel and as a result
  * it leaks errors from reads, invalidations and writes through
- * libxfs_getbuf/libxfs_readbuf.
+ * libxfs_buf_get/libxfs_readbuf.
  *
  * The result of this is that until the userspace code outside libxfs is cleaned
  * up, functions that release buffers from userspace control (i.e
@@ -391,7 +391,6 @@ libxfs_log_header(
 #undef libxfs_readbuf
 #undef libxfs_readbuf_map
 #undef libxfs_writebuf
-#undef libxfs_getbuf
 #undef libxfs_getbuf_map
 #undef libxfs_getbuf_flags
 
@@ -400,7 +399,8 @@ xfs_buf_t	*libxfs_readbuf(struct xfs_buftarg *, xfs_daddr_t, int, int,
 xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int, const struct xfs_buf_ops *);
 int		libxfs_writebuf(xfs_buf_t *, int);
-xfs_buf_t	*libxfs_getbuf(struct xfs_buftarg *, xfs_daddr_t, int);
+struct xfs_buf *libxfs_buf_get(struct xfs_buftarg *btp, xfs_daddr_t daddr,
+				size_t len);
 xfs_buf_t	*libxfs_getbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int);
 xfs_buf_t	*libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t, int,
@@ -443,11 +443,19 @@ libxfs_trace_writebuf(const char *func, const char *file, int line, xfs_buf_t *b
 	return libxfs_writebuf(bp, flags);
 }
 
-xfs_buf_t *
-libxfs_trace_getbuf(const char *func, const char *file, int line,
-		struct xfs_buftarg *btp, xfs_daddr_t blkno, int len)
+struct xfs_buf *
+libxfs_trace_getbuf(
+	const char		*func,
+	const char		*file,
+	int			line,
+	struct xfs_buftarg	*btp,
+	xfs_daddr_t		blkno,
+	size_t			len)
 {
-	xfs_buf_t	*bp = libxfs_getbuf(btp, blkno, len);
+	struct xfs_buf		*bp;
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+
+	bp = libxfs_getbuf_map(target, &map, 1, 0);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -806,16 +814,6 @@ reset_buf_state(
 				LIBXFS_B_UPTODATE);
 }
 
-struct xfs_buf *
-libxfs_getbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len)
-{
-	struct xfs_buf	*bp;
-
-	bp = libxfs_getbuf_flags(btp, blkno, len, 0);
-	reset_buf_state(bp);
-	return bp;
-}
-
 static struct xfs_buf *
 __libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map,
 		    int nmaps, int flags)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 25bdf8df..cc84705c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3444,7 +3444,7 @@ prepare_devices(
 	 * the end of the device.  (MD sb is ~64k from the end, take out a wider
 	 * swath to be sure)
 	 */
-	buf = libxfs_getbuf(mp->m_ddev_targp, (xi->dsize - whack_blks),
+	buf = libxfs_buf_get(mp->m_ddev_targp, (xi->dsize - whack_blks),
 			    whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
 	libxfs_writebuf(buf, 0);
@@ -3456,13 +3456,14 @@ prepare_devices(
 	 * swap (somewhere around the page size), jfs (32k),
 	 * ext[2,3] and reiserfs (64k) - and hopefully all else.
 	 */
-	buf = libxfs_getbuf(mp->m_ddev_targp, 0, whack_blks);
+	buf = libxfs_buf_get(mp->m_ddev_targp, 0, whack_blks);
 	memset(buf->b_addr, 0, WHACK_SIZE);
 	libxfs_writebuf(buf, 0);
 	libxfs_purgebuf(buf);
 
 	/* OK, now write the superblock... */
-	buf = libxfs_getbuf(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1));
+	buf = libxfs_buf_get(mp->m_ddev_targp, XFS_SB_DADDR,
+			XFS_FSS_TO_BB(mp, 1));
 	buf->b_ops = &xfs_sb_buf_ops;
 	memset(buf->b_addr, 0, cfg->sectorsize);
 	libxfs_sb_to_disk(buf->b_addr, sbp);
@@ -3482,7 +3483,7 @@ prepare_devices(
 
 	/* finally, check we can write the last block in the realtime area */
 	if (mp->m_rtdev_targp->dev && cfg->rtblocks > 0) {
-		buf = libxfs_getbuf(mp->m_rtdev_targp,
+		buf = libxfs_buf_get(mp->m_rtdev_targp,
 				    XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
 				    BTOBB(cfg->blocksize));
 		memset(buf->b_addr, 0, cfg->blocksize);
diff --git a/repair/phase5.c b/repair/phase5.c
index 7f7d3d18..cdbf6697 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -689,7 +689,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 
 		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
 
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
+		lptr->buf_p = libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp, 1));
 		lptr->agbno = agbno;
@@ -767,7 +767,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		lptr = &btree_curs->level[i];
 
 		agbno = get_next_blockaddr(agno, i, btree_curs);
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
+		lptr->buf_p = libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp, 1));
 
@@ -877,7 +877,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
 			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
 
-			lptr->buf_p = libxfs_getbuf(mp->m_dev,
+			lptr->buf_p = libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
 					XFS_FSB_TO_BB(mp, 1));
 		}
@@ -1054,7 +1054,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 
 		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
 
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
+		lptr->buf_p = libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp, 1));
 		lptr->agbno = agbno;
@@ -1104,7 +1104,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 	xfs_agi_t	*agi;
 	int		i;
 
-	agi_buf = libxfs_getbuf(mp->m_dev,
+	agi_buf = libxfs_buf_get(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 			mp->m_sb.sb_sectsize/BBSIZE);
 	agi_buf->b_ops = &xfs_agi_buf_ops;
@@ -1174,7 +1174,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		lptr = &btree_curs->level[i];
 
 		agbno = get_next_blockaddr(agno, i, btree_curs);
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
+		lptr->buf_p = libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp, 1));
 
@@ -1306,7 +1306,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
 			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
 
-			lptr->buf_p = libxfs_getbuf(mp->m_dev,
+			lptr->buf_p = libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
 					XFS_FSB_TO_BB(mp, 1));
 		}
@@ -1459,7 +1459,7 @@ prop_rmap_cursor(
 
 		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
 
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
+		lptr->buf_p = libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp, 1));
 		lptr->agbno = agbno;
@@ -1569,7 +1569,7 @@ build_rmap_tree(
 		lptr = &btree_curs->level[i];
 
 		agbno = get_next_blockaddr(agno, i, btree_curs);
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
+		lptr->buf_p = libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp, 1));
 
@@ -1668,7 +1668,7 @@ _("Insufficient memory to construct reverse-map cursor."));
 			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
 			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
 
-			lptr->buf_p = libxfs_getbuf(mp->m_dev,
+			lptr->buf_p = libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
 					XFS_FSB_TO_BB(mp, 1));
 		}
@@ -1809,7 +1809,7 @@ prop_refc_cursor(
 
 		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
 
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
+		lptr->buf_p = libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp, 1));
 		lptr->agbno = agbno;
@@ -1874,7 +1874,7 @@ build_refcount_tree(
 		lptr = &btree_curs->level[i];
 
 		agbno = get_next_blockaddr(agno, i, btree_curs);
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
+		lptr->buf_p = libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp, 1));
 
@@ -1961,7 +1961,7 @@ _("Insufficient memory to construct refcount cursor."));
 			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
 			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
 
-			lptr->buf_p = libxfs_getbuf(mp->m_dev,
+			lptr->buf_p = libxfs_buf_get(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
 					XFS_FSB_TO_BB(mp, 1));
 		}
@@ -1996,7 +1996,7 @@ build_agf_agfl(
 	__be32			*freelist;
 	int			error;
 
-	agf_buf = libxfs_getbuf(mp->m_dev,
+	agf_buf = libxfs_buf_get(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			mp->m_sb.sb_sectsize/BBSIZE);
 	agf_buf->b_ops = &xfs_agf_buf_ops;
@@ -2068,7 +2068,7 @@ build_agf_agfl(
 		platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
 
 	/* initialise the AGFL, then fill it if there are blocks left over. */
-	agfl_buf = libxfs_getbuf(mp->m_dev,
+	agfl_buf = libxfs_buf_get(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
 			mp->m_sb.sb_sectsize/BBSIZE);
 	agfl_buf->b_ops = &xfs_agfl_buf_ops;

