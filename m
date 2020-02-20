Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4A5C7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01F7821D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g6NKI2P2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgBTBnT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:43:19 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49026 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBnT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:43:19 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1cvaA039912;
        Thu, 20 Feb 2020 01:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lUxgPvUZGH15FNqehbt2FY6YkR2J3Ep/vQHe4VrE1j8=;
 b=g6NKI2P24n0H088I1ZzVeBBssrq2DMeL2m06CWJvCTuXiVAebJFUm/opd3MiA7Px6bc6
 CIvfBbqXCg2sVixwNqhZFi37jcR7EnT4xQqkV1nE/G64z6PeTxPFIuCHA7VFRJegPwGt
 MzhLw6Z6zxi8JMRaH9lsP66HC6iowztK70kP+XWN7O9aeTDdsM33VNcKh8UpWNlIfhYR
 gn4kTEIlmNguPKo78ae8jf0XO16rbdljq+iDJ85xadssjA3PBu1v57kLeICV1Vx7aUBL
 wzLeMGDvcqmb13Npvr1dPjzSIHzV8aPihHfrjR5W6UUx/t8PnHCrjVYVb6hqRpZufTzU 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2y8ud16sba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gdW7147411;
        Thu, 20 Feb 2020 01:43:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2y8ud4pxna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:15 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1hEuj002942;
        Thu, 20 Feb 2020 01:43:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:43:13 -0800
Subject: [PATCH 06/18] libxfs: replace libxfs_readbuf with libxfs_buf_read
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:43:13 -0800
Message-ID: <158216299309.602314.10312057165892234719.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=2 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=2 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change all the libxfs_readbuf calls to libxfs_buf_read to match the
kernel interface.  This enables us to hide libxfs_readbuf and simplify
the userspace buffer interface further.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 copy/xfs_copy.c          |    4 ++-
 db/init.c                |    2 +-
 db/io.c                  |    2 +-
 libxfs/init.c            |    8 +++----
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/libxfs_io.h       |   25 +++++++++++++++------
 libxfs/rdwr.c            |   56 +++++++++++++++++++++++-----------------------
 mkfs/xfs_mkfs.c          |    4 ++-
 repair/attr_repair.c     |    6 ++---
 repair/dino_chunks.c     |    4 ++-
 repair/dinode.c          |    6 ++---
 repair/phase3.c          |    2 +-
 repair/prefetch.c        |    2 +-
 repair/rt.c              |    4 ++-
 repair/scan.c            |   12 +++++-----
 15 files changed, 75 insertions(+), 63 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 74dd2e23..bb3ecd43 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -710,7 +710,7 @@ main(int argc, char **argv)
 
 	/* We don't yet know the sector size, so read maximal size */
 	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
-	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR,
+	sbp = libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
 			     1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
 	sb = &mbuf.m_sb;
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
@@ -718,7 +718,7 @@ main(int argc, char **argv)
 	/* Do it again, now with proper length and verifier */
 	libxfs_buf_relse(sbp);
 	libxfs_purgebuf(sbp);
-	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR,
+	sbp = libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
 			     1 << (sb->sb_sectlog - BBSHIFT),
 			     0, &xfs_sb_buf_ops);
 	libxfs_buf_relse(sbp);
diff --git a/db/init.c b/db/init.c
index be4a08e5..acab349c 100644
--- a/db/init.c
+++ b/db/init.c
@@ -112,7 +112,7 @@ init(
 	 */
 	memset(&xmount, 0, sizeof(struct xfs_mount));
 	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
-	bp = libxfs_readbuf(xmount.m_ddev_targp, XFS_SB_DADDR,
+	bp = libxfs_buf_read(xmount.m_ddev_targp, XFS_SB_DADDR,
 			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
 
 	if (!bp || bp->b_error) {
diff --git a/db/io.c b/db/io.c
index a11b7bb1..163ccc89 100644
--- a/db/io.c
+++ b/db/io.c
@@ -545,7 +545,7 @@ set_cur(
 		bp = libxfs_readbuf_map(mp->m_ddev_targp, bbmap->b,
 					bbmap->nmaps, 0, ops);
 	} else {
-		bp = libxfs_readbuf(mp->m_ddev_targp, blknum, len, 0, ops);
+		bp = libxfs_buf_read(mp->m_ddev_targp, blknum, len, 0, ops);
 		iocur_top->bbmap = NULL;
 	}
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 2c290428..c66cb785 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -438,7 +438,7 @@ rtmount_init(
 			(unsigned long long) mp->m_sb.sb_rblocks);
 		return -1;
 	}
-	bp = libxfs_readbuf(mp->m_rtdev,
+	bp = libxfs_buf_read(mp->m_rtdev,
 			d - XFS_FSB_TO_BB(mp, 1), XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (bp == NULL) {
 		fprintf(stderr, _("%s: realtime size check failed\n"),
@@ -721,7 +721,7 @@ libxfs_mount(
 	if (!(flags & LIBXFS_MOUNT_DEBUGGER))
 		readflags |= LIBXFS_READBUF_FAIL_EXIT;
 
-	bp = libxfs_readbuf(mp->m_dev,
+	bp = libxfs_buf_read(mp->m_dev,
 			d - XFS_FSS_TO_BB(mp, 1), XFS_FSS_TO_BB(mp, 1),
 			readflags, NULL);
 	if (!bp) {
@@ -735,7 +735,7 @@ libxfs_mount(
 	    mp->m_logdev_targp->dev != mp->m_ddev_targp->dev) {
 		d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 		if ( (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) ||
-		     (!(bp = libxfs_readbuf(mp->m_logdev_targp,
+		     (!(bp = libxfs_buf_read(mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
 					XFS_FSB_TO_BB(mp, 1),
 					readflags, NULL))) ) {
@@ -763,7 +763,7 @@ libxfs_mount(
 	 * read the first one and let the user know to check the geometry.
 	 */
 	if (sbp->sb_agcount > 1000000) {
-		bp = libxfs_readbuf(mp->m_dev,
+		bp = libxfs_buf_read(mp->m_dev,
 				XFS_AG_DADDR(mp, sbp->sb_agcount - 1, 0), 1,
 				readflags, NULL);
 		if (bp->b_error) {
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 6d86774f..57cf5f83 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -45,6 +45,7 @@
 #define xfs_btree_init_block		libxfs_btree_init_block
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
+#define xfs_buf_read			libxfs_buf_read
 #define xfs_buf_relse			libxfs_buf_relse
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 5087f03d..9484c627 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -132,7 +132,7 @@ extern struct cache_operations	libxfs_bcache_operations;
 
 #ifdef XFS_BUF_TRACING
 
-#define libxfs_readbuf(dev, daddr, len, flags, ops) \
+#define libxfs_buf_read(dev, daddr, len, flags, ops) \
 	libxfs_trace_readbuf(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len), (flags), (ops))
 #define libxfs_readbuf_map(dev, map, nmaps, flags, ops) \
@@ -153,9 +153,9 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_buf_relse(buf) \
 	libxfs_trace_putbuf(__FUNCTION__, __FILE__, __LINE__, (buf))
 
-extern xfs_buf_t *libxfs_trace_readbuf(const char *, const char *, int,
-			struct xfs_buftarg *, xfs_daddr_t, int, int,
-			const struct xfs_buf_ops *);
+struct xfs_buf *libxfs_trace_readbuf(const char *func, const char *file,
+			int line, struct xfs_buftarg *btp, xfs_daddr_t daddr,
+			size_t len, int flags, const struct xfs_buf_ops *ops);
 extern xfs_buf_t *libxfs_trace_readbuf_map(const char *, const char *, int,
 			struct xfs_buftarg *, struct xfs_buf_map *, int, int,
 			const struct xfs_buf_ops *);
@@ -173,8 +173,6 @@ extern void	libxfs_trace_putbuf (const char *, const char *, int,
 
 #else
 
-extern xfs_buf_t *libxfs_readbuf(struct xfs_buftarg *, xfs_daddr_t, int, int,
-			const struct xfs_buf_ops *);
 extern xfs_buf_t *libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 			int, int, const struct xfs_buf_ops *);
 extern int	libxfs_writebuf(xfs_buf_t *, int);
@@ -195,11 +193,24 @@ libxfs_buf_get(
 	return libxfs_getbuf_map(target, &map, 1, 0);
 }
 
+static inline struct xfs_buf*
+libxfs_buf_read(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	xfs_buf_flags_t		flags,
+	const struct xfs_buf_ops *ops)
+{
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+
+	return libxfs_readbuf_map(target, &map, 1, flags, ops);
+}
+
 #endif /* XFS_BUF_TRACING */
 
 extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
 			const struct xfs_buf_ops *ops);
-extern xfs_buf_t *libxfs_getsb(struct xfs_mount *);
+struct xfs_buf *libxfs_getsb(struct xfs_mount *);
 extern void	libxfs_bcache_purge(void);
 extern void	libxfs_bcache_free(void);
 extern void	libxfs_bcache_flush(void);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 56c50d47..ea2f4a13 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -44,7 +44,7 @@
  *
  * IOWs, userspace is behaving quite differently to the kernel and as a result
  * it leaks errors from reads, invalidations and writes through
- * libxfs_buf_get/libxfs_readbuf.
+ * libxfs_buf_get/libxfs_buf_read.
  *
  * The result of this is that until the userspace code outside libxfs is cleaned
  * up, functions that release buffers from userspace control (i.e
@@ -381,14 +381,11 @@ libxfs_log_header(
 
 #ifdef XFS_BUF_TRACING
 
-#undef libxfs_readbuf
 #undef libxfs_readbuf_map
 #undef libxfs_writebuf
 #undef libxfs_getbuf_map
 #undef libxfs_getbuf_flags
 
-xfs_buf_t	*libxfs_readbuf(struct xfs_buftarg *, xfs_daddr_t, int, int,
-				const struct xfs_buf_ops *);
 xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int, const struct xfs_buf_ops *);
 int		libxfs_writebuf(xfs_buf_t *, int);
@@ -409,22 +406,21 @@ do {						\
 	}					\
 } while (0)
 
-xfs_buf_t *
-libxfs_trace_readbuf(const char *func, const char *file, int line,
-		struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
-		const struct xfs_buf_ops *ops)
+struct xfs_buf *
+libxfs_trace_readbuf(
+	const char		*func,
+	const char		*file,
+	int			line,
+	struct xfs_buftarg	*btp,
+	xfs_daddr_t		blkno,
+	size_t			len,
+	int			flags,
+	const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t	*bp = libxfs_readbuf(btp, blkno, len, flags, ops);
-	__add_trace(bp, func, file, line);
-	return bp;
-}
+	struct xfs_buf		*bp;
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-xfs_buf_t *
-libxfs_trace_readbuf_map(const char *func, const char *file, int line,
-		struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps, int flags,
-		const struct xfs_buf_ops *ops)
-{
-	xfs_buf_t	*bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
+	bp = libxfs_readbuf_map(btp, &map, 1, flags, ops);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -483,11 +479,12 @@ libxfs_trace_putbuf(const char *func, const char *file, int line, xfs_buf_t *bp)
 #endif
 
 
-xfs_buf_t *
-libxfs_getsb(xfs_mount_t *mp)
+struct xfs_buf *
+libxfs_getsb(
+	struct xfs_mount	*mp)
 {
-	return libxfs_readbuf(mp->m_ddev_targp, XFS_SB_DADDR,
-				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
+	return libxfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR,
+			XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
 }
 
 kmem_zone_t			*xfs_buf_zone;
@@ -956,13 +953,16 @@ libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops)
 	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
 }
 
-
-xfs_buf_t *
-libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
-		const struct xfs_buf_ops *ops)
+static struct xfs_buf *
+libxfs_readbuf(
+	struct xfs_buftarg	*btp,
+	xfs_daddr_t		blkno,
+	size_t			len,
+	int			flags,
+	const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t	*bp;
-	int		error;
+	struct xfs_buf		*bp;
+	int			error;
 
 	bp = libxfs_getbuf_flags(btp, blkno, len, 0);
 	if (!bp)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 948749e9..9ca4cb1a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3573,7 +3573,7 @@ rewrite_secondary_superblocks(
 	struct xfs_buf		*buf;
 
 	/* rewrite the last superblock */
-	buf = libxfs_readbuf(mp->m_dev,
+	buf = libxfs_buf_read(mp->m_dev,
 			XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount - 1,
 				XFS_SB_DADDR),
 			XFS_FSS_TO_BB(mp, 1),
@@ -3585,7 +3585,7 @@ rewrite_secondary_superblocks(
 	if (mp->m_sb.sb_agcount <= 2)
 		return;
 
-	buf = libxfs_readbuf(mp->m_dev,
+	buf = libxfs_buf_read(mp->m_dev,
 			XFS_AGB_TO_DADDR(mp, (mp->m_sb.sb_agcount - 1) / 2,
 				XFS_SB_DADDR),
 			XFS_FSS_TO_BB(mp, 1),
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index ec068ba2..cc20b1a1 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -405,7 +405,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 			clearit = 1;
 			break;
 		}
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
+		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
 				    XFS_FSB_TO_BB(mp, 1), 0,
 				    &xfs_attr3_rmt_buf_ops);
 		if (!bp) {
@@ -763,7 +763,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 			goto error_out;
 		}
 
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, dev_bno),
+		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, dev_bno),
 				    XFS_FSB_TO_BB(mp, 1), 0,
 				    &xfs_attr3_leaf_buf_ops);
 		if (!bp) {
@@ -1093,7 +1093,7 @@ process_longform_attr(
 		return 1;
 	}
 
-	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
+	bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
 				XFS_FSB_TO_BB(mp, 1), 0, &xfs_da3_node_buf_ops);
 	if (!bp) {
 		do_warn(
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 863c4531..76e9f773 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -39,7 +39,7 @@ check_aginode_block(xfs_mount_t	*mp,
 	 * tree and we wouldn't be here and we stale the buffers out
 	 * so no one else will overlap them.
 	 */
-	bp = libxfs_readbuf(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, agbno),
+	bp = libxfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, agbno),
 			XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (!bp) {
 		do_warn(_("cannot read agbno (%u/%u), disk block %" PRId64 "\n"),
@@ -656,7 +656,7 @@ process_inode_chunk(
 		pftrace("about to read off %llu in AG %d",
 			XFS_AGB_TO_DADDR(mp, agno, agbno), agno);
 
-		bplist[bp_index] = libxfs_readbuf(mp->m_dev,
+		bplist[bp_index] = libxfs_buf_read(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp,
 						M_IGEO(mp)->blocks_per_cluster),
diff --git a/repair/dinode.c b/repair/dinode.c
index 928698cb..848eac09 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -748,7 +748,7 @@ get_agino_buf(
 		cluster_agino, cluster_daddr, cluster_blks);
 #endif
 
-	bp = libxfs_readbuf(mp->m_dev, cluster_daddr, cluster_blks,
+	bp = libxfs_buf_read(mp->m_dev, cluster_daddr, cluster_blks,
 			0, &xfs_inode_buf_ops);
 	if (!bp) {
 		do_warn(_("cannot read inode (%u/%u), disk block %" PRIu64 "\n"),
@@ -1179,7 +1179,7 @@ process_quota_inode(
 		fsbno = blkmap_get(blkmap, qbno);
 		dqid = (xfs_dqid_t)qbno * dqperchunk;
 
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
+		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
 				    dqchunklen, 0, &xfs_dquot_buf_ops);
 		if (!bp) {
 			do_warn(
@@ -1284,7 +1284,7 @@ _("cannot read inode %" PRIu64 ", file block %d, NULL disk block\n"),
 
 		byte_cnt = XFS_FSB_TO_B(mp, blk_cnt);
 
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
+		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
 				    BTOBB(byte_cnt), 0, &xfs_symlink_buf_ops);
 		if (!bp) {
 			do_warn(
diff --git a/repair/phase3.c b/repair/phase3.c
index 1c6929ac..886acd1f 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -28,7 +28,7 @@ process_agi_unlinked(
 	xfs_agnumber_t		i;
 	int			agi_dirty = 0;
 
-	bp = libxfs_readbuf(mp->m_dev,
+	bp = libxfs_buf_read(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 			mp->m_sb.sb_sectsize/BBSIZE, 0, &xfs_agi_buf_ops);
 	if (!bp)
diff --git a/repair/prefetch.c b/repair/prefetch.c
index f7ea9c8f..12272932 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -271,7 +271,7 @@ pf_scan_lbtree(
 	xfs_buf_t		*bp;
 	int			rc;
 
-	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, dbno),
+	bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, dbno),
 			XFS_FSB_TO_BB(mp, 1), 0, &xfs_bmbt_buf_ops);
 	if (!bp)
 		return 0;
diff --git a/repair/rt.c b/repair/rt.c
index 3319829c..b514998d 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -193,7 +193,7 @@ process_rtbitmap(xfs_mount_t	*mp,
 			error = 1;
 			continue;
 		}
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
+		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
 				XFS_FSB_TO_BB(mp, 1), NULL);
 		if (!bp) {
 			do_warn(_("can't read block %d for rtbitmap inode\n"),
@@ -255,7 +255,7 @@ process_rtsummary(xfs_mount_t	*mp,
 			error++;
 			continue;
 		}
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
+		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
 				XFS_FSB_TO_BB(mp, 1), NULL);
 		if (!bp) {
 			do_warn(_("can't read block %d for rtsummary inode\n"),
diff --git a/repair/scan.c b/repair/scan.c
index c961e843..f4e4fef5 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -68,7 +68,7 @@ scan_sbtree(
 {
 	xfs_buf_t	*bp;
 
-	bp = libxfs_readbuf(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, root),
+	bp = libxfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, root),
 			XFS_FSB_TO_BB(mp, 1), 0, ops);
 	if (!bp) {
 		do_error(_("can't read btree block %d/%d\n"), agno, root);
@@ -123,7 +123,7 @@ scan_lbtree(
 	int		dirty = 0;
 	bool		badcrc = false;
 
-	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
+	bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
 		      XFS_FSB_TO_BB(mp, 1), 0, ops);
 	if (!bp)  {
 		do_error(_("can't read btree block %d/%d\n"),
@@ -2111,7 +2111,7 @@ scan_freelist(
 	if (be32_to_cpu(agf->agf_flcount) == 0)
 		return;
 
-	agflbuf = libxfs_readbuf(mp->m_dev,
+	agflbuf = libxfs_buf_read(mp->m_dev,
 				 XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
 				 XFS_FSS_TO_BB(mp, 1), 0, &xfs_agfl_buf_ops);
 	if (!agflbuf)  {
@@ -2335,7 +2335,7 @@ scan_ag(
 		return;
 	}
 
-	sbbuf = libxfs_readbuf(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
+	sbbuf = libxfs_buf_read(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
 				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
 	if (!sbbuf)  {
 		objname = _("root superblock");
@@ -2343,7 +2343,7 @@ scan_ag(
 	}
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbbuf));
 
-	agfbuf = libxfs_readbuf(mp->m_dev,
+	agfbuf = libxfs_buf_read(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agf_buf_ops);
 	if (!agfbuf)  {
@@ -2352,7 +2352,7 @@ scan_ag(
 	}
 	agf = XFS_BUF_TO_AGF(agfbuf);
 
-	agibuf = libxfs_readbuf(mp->m_dev,
+	agibuf = libxfs_buf_read(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agi_buf_ops);
 	if (!agibuf)  {

