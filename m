Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEE3C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F89821927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:17:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zRI1DAjH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgBYARS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:17:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55056 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYARS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:17:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07uFB050193;
        Tue, 25 Feb 2020 00:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CCrUTGJTvEK/NFc/wQiyUFFNQKiVLmQJfzhmRD72SXc=;
 b=zRI1DAjHTGdSTg5pf3jho+oUzKccED23ZDpWFO58pFyIElsI6hdFFxPAS+dp8ppRG75b
 4bDlmIj/wss2kHTX/tPGMikSK2070Fm8aA6V8ESwqravFNqhtzFwqOAWJ3WsEOXUsLR4
 twFkGQawlD3feuJSDOO5Ij4eiBEwhh2tplpm1fSmJxqJ1UdSNekQ2gpB82O5gT2W5aom
 AuGBiSbIoNmQRUiijLEZWhOJyidWyjQv3+i2C90FFLD1lgX3eFK2JvBremqWpPo2lDPC
 wcHzFBKN3R+bcmtaQd0n4mwuvXBHs9MdKIWQsoCB+ijFqZKPDnHbVZw5jzen+XAcbG+x 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q3rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P084lU109916;
        Tue, 25 Feb 2020 00:15:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ybe12etfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:11 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0FARI001570;
        Tue, 25 Feb 2020 00:15:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:15:10 -0800
Subject: [PATCH 09/14] xfs: make xfs_buf_read return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Mon, 24 Feb 2020 16:15:08 -0800
Message-ID: <158258970866.453666.7637294707029943305.stgit@magnolia>
In-Reply-To: <158258964941.453666.10913737544282124969.stgit@magnolia>
References: <158258964941.453666.10913737544282124969.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=2 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=2 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 0e3eccce5e0e438bc1aa3c2913221d3d43a1bef4

Convert xfs_buf_read() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 copy/xfs_copy.c          |   11 +++++--
 db/io.c                  |    3 +-
 libxfs/init.c            |   35 +++++++++++----------
 libxfs/libxfs_io.h       |   21 +++++--------
 libxfs/rdwr.c            |   20 +++++++-----
 libxfs/xfs_attr_remote.c |    8 ++---
 mkfs/xfs_mkfs.c          |   13 ++++----
 repair/attr_repair.c     |   29 ++++++++++--------
 repair/dino_chunks.c     |   23 ++++++++------
 repair/dinode.c          |   25 ++++++++++-----
 repair/phase3.c          |    8 +++--
 repair/prefetch.c        |    8 +++--
 repair/rt.c              |   12 ++++---
 repair/scan.c            |   76 ++++++++++++++++++++++++++++++++++------------
 14 files changed, 178 insertions(+), 114 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 5cab1a5f..91c2ae01 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -725,9 +725,14 @@ main(int argc, char **argv)
 	/* Do it again, now with proper length and verifier */
 	libxfs_buf_relse(sbp);
 
-	sbp = libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
-			     1 << (sb->sb_sectlog - BBSHIFT),
-			     0, &xfs_sb_buf_ops);
+	error = -libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
+			1 << (sb->sb_sectlog - BBSHIFT), 0, &sbp,
+			&xfs_sb_buf_ops);
+	if (error) {
+		do_log(_("%s: couldn't read superblock, error=%d\n"),
+				progname, error);
+		exit(1);
+	}
 	libxfs_buf_relse(sbp);
 
 	mp = libxfs_mount(&mbuf, sb, xargs.ddev, xargs.logdev, xargs.rtdev, 0);
diff --git a/db/io.c b/db/io.c
index 5c9d72bb..384e4c0f 100644
--- a/db/io.c
+++ b/db/io.c
@@ -545,7 +545,8 @@ set_cur(
 		libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b, bbmap->nmaps,
 				LIBXFS_READBUF_SALVAGE, &bp, ops);
 	} else {
-		bp = libxfs_buf_read(mp->m_ddev_targp, blknum, len, 0, ops);
+		libxfs_buf_read(mp->m_ddev_targp, blknum, len,
+				LIBXFS_READBUF_SALVAGE, &bp, ops);
 		iocur_top->bbmap = NULL;
 	}
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 328f46ac..dfddb0d5 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -415,9 +415,10 @@ rtmount_init(
 	xfs_mount_t	*mp,	/* file system mount structure */
 	int		flags)
 {
-	xfs_buf_t	*bp;	/* buffer for last block of subvolume */
+	struct xfs_buf	*bp;	/* buffer for last block of subvolume */
+	struct xfs_sb	*sbp;	/* filesystem superblock copy in mount */
 	xfs_daddr_t	d;	/* address of last block of subvolume */
-	xfs_sb_t	*sbp;	/* filesystem superblock copy in mount */
+	int		error;
 
 	sbp = &mp->m_sb;
 	if (sbp->sb_rblocks == 0)
@@ -450,9 +451,9 @@ rtmount_init(
 			(unsigned long long) mp->m_sb.sb_rblocks);
 		return -1;
 	}
-	bp = libxfs_buf_read(mp->m_rtdev,
-			d - XFS_FSB_TO_BB(mp, 1), XFS_FSB_TO_BB(mp, 1), 0, NULL);
-	if (bp == NULL) {
+	error = libxfs_buf_read(mp->m_rtdev, d - XFS_FSB_TO_BB(mp, 1),
+			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error) {
 		fprintf(stderr, _("%s: realtime size check failed\n"),
 			progname);
 		return -1;
@@ -730,9 +731,9 @@ libxfs_mount(
 		return mp;
 
 	/* device size checks must pass unless we're a debugger. */
-	bp = libxfs_buf_read(mp->m_dev, d - XFS_FSS_TO_BB(mp, 1),
-			XFS_FSS_TO_BB(mp, 1), 0, NULL);
-	if (!bp) {
+	error = libxfs_buf_read(mp->m_dev, d - XFS_FSS_TO_BB(mp, 1),
+			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error) {
 		fprintf(stderr, _("%s: data size check failed\n"), progname);
 		if (!debugger)
 			return NULL;
@@ -742,10 +743,10 @@ libxfs_mount(
 	if (mp->m_logdev_targp->dev &&
 	    mp->m_logdev_targp->dev != mp->m_ddev_targp->dev) {
 		d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
-		if ( (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) ||
-		     (!(bp = libxfs_buf_read(mp->m_logdev_targp,
-					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_BB(mp, 1), 0, NULL)))) {
+		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks ||
+		    libxfs_buf_read(mp->m_logdev_targp,
+				d - XFS_FSB_TO_BB(mp, 1), XFS_FSB_TO_BB(mp, 1),
+				0, &bp, NULL)) {
 			fprintf(stderr, _("%s: log size checks failed\n"),
 					progname);
 			if (!debugger)
@@ -770,10 +771,10 @@ libxfs_mount(
 	 * read the first one and let the user know to check the geometry.
 	 */
 	if (sbp->sb_agcount > 1000000) {
-		bp = libxfs_buf_read(mp->m_dev,
+		error = libxfs_buf_read(mp->m_dev,
 				XFS_AG_DADDR(mp, sbp->sb_agcount - 1, 0), 1,
-				0, NULL);
-		if (bp->b_error) {
+				0, &bp, NULL);
+		if (error) {
 			fprintf(stderr, _("%s: read of AG %u failed\n"),
 						progname, sbp->sb_agcount);
 			if (!debugger)
@@ -781,8 +782,8 @@ libxfs_mount(
 			fprintf(stderr, _("%s: limiting reads to AG 0\n"),
 								progname);
 			sbp->sb_agcount = 1;
-		}
-		libxfs_buf_relse(bp);
+		} else
+			libxfs_buf_relse(bp);
 	}
 
 	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 703a2168..0e5df33d 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -132,9 +132,9 @@ extern struct cache_operations	libxfs_bcache_operations;
 
 #ifdef XFS_BUF_TRACING
 
-#define libxfs_buf_read(dev, daddr, len, flags, ops) \
+#define libxfs_buf_read(dev, daddr, len, flags, bpp, ops) \
 	libxfs_trace_readbuf(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (daddr), (len), (flags), (ops))
+			    (dev), (daddr), (len), (flags), (bpp), (ops))
 #define libxfs_buf_read_map(dev, map, nmaps, flags, bpp, ops) \
 	libxfs_trace_readbuf_map(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (map), (nmaps), (flags), (bpp), (ops))
@@ -150,9 +150,10 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_buf_relse(buf) \
 	libxfs_trace_putbuf(__FUNCTION__, __FILE__, __LINE__, (buf))
 
-struct xfs_buf *libxfs_trace_readbuf(const char *func, const char *file,
-			int line, struct xfs_buftarg *btp, xfs_daddr_t daddr,
-			size_t len, int flags, const struct xfs_buf_ops *ops);
+int libxfs_trace_readbuf(const char *func, const char *file, int line,
+			struct xfs_buftarg *btp, xfs_daddr_t daddr, size_t len,
+			int flags, const struct xfs_buf_ops *ops,
+			struct xfs_buf **bpp);
 int libxfs_trace_readbuf_map(const char *func, const char *file, int line,
 			struct xfs_buftarg *btp, struct xfs_buf_map *maps,
 			int nmaps, int flags, struct xfs_buf **bpp,
@@ -190,22 +191,18 @@ libxfs_buf_get(
 	return libxfs_buf_get_map(target, &map, 1, 0, bpp);
 }
 
-static inline struct xfs_buf*
+static inline int
 libxfs_buf_read(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		blkno,
 	size_t			numblks,
 	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
-	struct xfs_buf		*bp;
-	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	error = libxfs_buf_read_map(target, &map, 1, flags, &bp, ops);
-	if (error)
-		return NULL;
-	return bp;
+	return libxfs_buf_read_map(target, &map, 1, flags, bpp, ops);
 }
 
 #endif /* XFS_BUF_TRACING */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 2d056009..5918566c 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -170,7 +170,7 @@ do {						\
 	}					\
 } while (0)
 
-struct xfs_buf *
+int
 libxfs_trace_readbuf(
 	const char		*func,
 	const char		*file,
@@ -179,14 +179,15 @@ libxfs_trace_readbuf(
 	xfs_daddr_t		blkno,
 	size_t			len,
 	int			flags,
-	const struct xfs_buf_ops *ops)
+	const struct xfs_buf_ops *ops,
+	struct xfs_buf		**bpp)
 {
-	struct xfs_buf		*bp;
+	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	libxfs_buf_read_map(btp, &map, 1, flags, &bp, ops);
-	__add_trace(bp, func, file, line);
-	return bp;
+	error = libxfs_buf_read_map(btp, &map, 1, flags, bpp, ops);
+	__add_trace(*bpp, func, file, line);
+	return error;
 }
 
 int
@@ -270,8 +271,11 @@ struct xfs_buf *
 libxfs_getsb(
 	struct xfs_mount	*mp)
 {
-	return libxfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR,
-			XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
+	struct xfs_buf		*bp;
+
+	libxfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1),
+			0, &bp, &xfs_sb_buf_ops);
+	return bp;
 }
 
 kmem_zone_t			*xfs_buf_zone;
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 88163ea8..b2a01567 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -417,10 +417,10 @@ xfs_attr_rmtval_get(
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			bp = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt, 0,
-					&xfs_attr3_rmt_buf_ops);
-			if (!bp)
-				return -ENOMEM;
+			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
+					0, &bp, &xfs_attr3_rmt_buf_ops);
+			if (error)
+				return error;
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index efe4feaa..8a6534f3 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3593,13 +3593,14 @@ rewrite_secondary_superblocks(
 	struct xfs_mount	*mp)
 {
 	struct xfs_buf		*buf;
+	int			error;
 
 	/* rewrite the last superblock */
-	buf = libxfs_buf_read(mp->m_dev,
+	error = -libxfs_buf_read(mp->m_dev,
 			XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount - 1,
 				XFS_SB_DADDR),
-			XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
-	if (!buf) {
+			XFS_FSS_TO_BB(mp, 1), 0, &buf, &xfs_sb_buf_ops);
+	if (error) {
 		fprintf(stderr, _("%s: could not re-read AG %u superblock\n"),
 				progname, mp->m_sb.sb_agcount - 1);
 		exit(1);
@@ -3612,11 +3613,11 @@ rewrite_secondary_superblocks(
 	if (mp->m_sb.sb_agcount <= 2)
 		return;
 
-	buf = libxfs_buf_read(mp->m_dev,
+	error = -libxfs_buf_read(mp->m_dev,
 			XFS_AGB_TO_DADDR(mp, (mp->m_sb.sb_agcount - 1) / 2,
 				XFS_SB_DADDR),
-			XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
-	if (!buf) {
+			XFS_FSS_TO_BB(mp, 1), 0, &buf, &xfs_sb_buf_ops);
+	if (error) {
 		fprintf(stderr, _("%s: could not re-read AG %u superblock\n"),
 				progname, (mp->m_sb.sb_agcount - 1) / 2);
 		exit(1);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 3cef3004..9d68f61b 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -391,6 +391,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 	xfs_buf_t	*bp;
 	int		clearit = 0, i = 0, length = 0, amountdone = 0;
 	int		hdrsize = 0;
+	int		error;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		hdrsize = sizeof(struct xfs_attr3_rmt_hdr);
@@ -405,10 +406,10 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 			clearit = 1;
 			break;
 		}
-		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				    XFS_FSB_TO_BB(mp, 1), 0,
-				    &xfs_attr3_rmt_buf_ops);
-		if (!bp) {
+		error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
+				XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE,
+				&bp, &xfs_attr3_rmt_buf_ops);
+		if (error) {
 			do_warn(
 	_("can't read remote block for attributes of inode %" PRIu64 "\n"), ino);
 			clearit = 1;
@@ -737,6 +738,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 	xfs_dahash_t		current_hashval = 0;
 	xfs_dahash_t		greatest_hashval;
 	struct xfs_attr3_icleaf_hdr leafhdr;
+	int			error;
 
 	da_bno = da_cursor->level[0].bno;
 	ino = da_cursor->ino;
@@ -763,10 +765,11 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 			goto error_out;
 		}
 
-		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, dev_bno),
-				    XFS_FSB_TO_BB(mp, 1), 0,
-				    &xfs_attr3_leaf_buf_ops);
-		if (!bp) {
+		error = -libxfs_buf_read(mp->m_dev,
+				XFS_FSB_TO_DADDR(mp, dev_bno),
+				XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE,
+				&bp, &xfs_attr3_leaf_buf_ops);
+		if (error) {
 			do_warn(
 	_("can't read file block %u (fsbno %" PRIu64 ") for attribute fork of inode %" PRIu64 "\n"),
 				da_bno, dev_bno, ino);
@@ -1073,6 +1076,7 @@ process_longform_attr(
 	xfs_fsblock_t		bno;
 	struct xfs_buf		*bp;
 	struct xfs_da_blkinfo	*info;
+	int			error;
 
 	*repair = 0;
 
@@ -1094,13 +1098,14 @@ process_longform_attr(
 		return 1;
 	}
 
-	bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				XFS_FSB_TO_BB(mp, 1), 0, &xfs_da3_node_buf_ops);
-	if (!bp) {
+	error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
+			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
+			&xfs_da3_node_buf_ops);
+	if (error) {
 		do_warn(
 	_("can't read block 0 of inode %" PRIu64 " attribute fork\n"),
 			ino);
-		return(1);
+		return 1;
 	}
 	if (bp->b_error == -EFSBADCRC)
 		(*repair)++;
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index b2ed1112..6685a4d2 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -31,6 +31,7 @@ check_aginode_block(xfs_mount_t	*mp,
 	int		i;
 	int		cnt = 0;
 	xfs_buf_t	*bp;
+	int		error;
 
 	/*
 	 * it's ok to read these possible inode blocks in one at
@@ -39,9 +40,10 @@ check_aginode_block(xfs_mount_t	*mp,
 	 * tree and we wouldn't be here and we stale the buffers out
 	 * so no one else will overlap them.
 	 */
-	bp = libxfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, agbno),
-			XFS_FSB_TO_BB(mp, 1), 0, NULL);
-	if (!bp) {
+	error = -libxfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, agbno),
+			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
+			NULL);
+	if (error) {
 		do_warn(_("cannot read agbno (%u/%u), disk block %" PRId64 "\n"),
 			agno, agbno, XFS_AGB_TO_DADDR(mp, agno, agbno));
 		return(0);
@@ -612,6 +614,7 @@ process_inode_chunk(
 	int			bp_index;
 	int			cluster_offset;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	int			error;
 
 	ASSERT(first_irec != NULL);
 	ASSERT(XFS_AGINO_TO_OFFSET(mp, first_irec->ino_startnum) == 0);
@@ -656,13 +659,13 @@ process_inode_chunk(
 		pftrace("about to read off %llu in AG %d",
 			XFS_AGB_TO_DADDR(mp, agno, agbno), agno);
 
-		bplist[bp_index] = libxfs_buf_read(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp,
-						M_IGEO(mp)->blocks_per_cluster),
-					0,
-					&xfs_inode_buf_ops);
-		if (!bplist[bp_index]) {
+		error = -libxfs_buf_read(mp->m_dev,
+				XFS_AGB_TO_DADDR(mp, agno, agbno),
+				XFS_FSB_TO_BB(mp,
+					M_IGEO(mp)->blocks_per_cluster),
+				LIBXFS_READBUF_SALVAGE, &bplist[bp_index],
+				&xfs_inode_buf_ops);
+		if (error) {
 			do_warn(_("cannot read inode %" PRIu64 ", disk block %" PRId64 ", cnt %d\n"),
 				XFS_AGINO_TO_INO(mp, agno, first_irec->ino_startnum),
 				XFS_AGB_TO_DADDR(mp, agno, agbno),
diff --git a/repair/dinode.c b/repair/dinode.c
index 08521ac8..e771558d 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -730,6 +730,7 @@ get_agino_buf(
 	xfs_daddr_t		cluster_daddr;
 	xfs_daddr_t		cluster_blks;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	int			error;
 
 	/*
 	 * Inode buffers have been read into memory in inode_cluster_size
@@ -748,9 +749,9 @@ get_agino_buf(
 		cluster_agino, cluster_daddr, cluster_blks);
 #endif
 
-	bp = libxfs_buf_read(mp->m_dev, cluster_daddr, cluster_blks,
-			0, &xfs_inode_buf_ops);
-	if (!bp) {
+	error = -libxfs_buf_read(mp->m_dev, cluster_daddr, cluster_blks, 0,
+			&bp, &xfs_inode_buf_ops);
+	if (error) {
 		do_warn(_("cannot read inode (%u/%u), disk block %" PRIu64 "\n"),
 			agno, cluster_agino, cluster_daddr);
 		return NULL;
@@ -1149,6 +1150,7 @@ process_quota_inode(
 	xfs_fileoff_t		qbno;
 	int			i;
 	int			t = 0;
+	int			error;
 
 	switch (ino_type) {
 		case XR_INO_UQUOTA:
@@ -1179,9 +1181,11 @@ process_quota_inode(
 		fsbno = blkmap_get(blkmap, qbno);
 		dqid = (xfs_dqid_t)qbno * dqperchunk;
 
-		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
-				    dqchunklen, 0, &xfs_dquot_buf_ops);
-		if (!bp) {
+		error = -libxfs_buf_read(mp->m_dev,
+				XFS_FSB_TO_DADDR(mp, fsbno), dqchunklen,
+				LIBXFS_READBUF_SALVAGE, &bp,
+				&xfs_dquot_buf_ops);
+		if (error) {
 			do_warn(
 _("cannot read inode %" PRIu64 ", file block %" PRIu64 ", disk block %" PRIu64 "\n"),
 				lino, qbno, fsbno);
@@ -1255,6 +1259,7 @@ process_symlink_remote(
 	int			pathlen;
 	int			offset;
 	int			i;
+	int			error;
 
 	offset = 0;
 	pathlen = be64_to_cpu(dino->di_size);
@@ -1286,9 +1291,11 @@ _("cannot read inode %" PRIu64 ", file block %d, NULL disk block\n"),
 
 		byte_cnt = XFS_FSB_TO_B(mp, blk_cnt);
 
-		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
-				    BTOBB(byte_cnt), 0, &xfs_symlink_buf_ops);
-		if (!bp) {
+		error = -libxfs_buf_read(mp->m_dev,
+				XFS_FSB_TO_DADDR(mp, fsbno), BTOBB(byte_cnt),
+				LIBXFS_READBUF_SALVAGE, &bp,
+				&xfs_symlink_buf_ops);
+		if (error) {
 			do_warn(
 _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
 				lino, i, fsbno);
diff --git a/repair/phase3.c b/repair/phase3.c
index 79dc65f8..d30a698e 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -27,11 +27,13 @@ process_agi_unlinked(
 	struct xfs_agi		*agip;
 	xfs_agnumber_t		i;
 	int			agi_dirty = 0;
+	int			error;
 
-	bp = libxfs_buf_read(mp->m_dev,
+	error = -libxfs_buf_read(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			mp->m_sb.sb_sectsize/BBSIZE, 0, &xfs_agi_buf_ops);
-	if (!bp)
+			mp->m_sb.sb_sectsize / BBSIZE, LIBXFS_READBUF_SALVAGE,
+			&bp, &xfs_agi_buf_ops);
+	if (error)
 		do_error(_("cannot read agi block %" PRId64 " for ag %u\n"),
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)), agno);
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 3cc85501..e9be2c71 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -272,10 +272,12 @@ pf_scan_lbtree(
 {
 	xfs_buf_t		*bp;
 	int			rc;
+	int			error;
 
-	bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, dbno),
-			XFS_FSB_TO_BB(mp, 1), 0, &xfs_bmbt_buf_ops);
-	if (!bp)
+	error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, dbno),
+			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
+			&xfs_bmbt_buf_ops);
+	if (error)
 		return 0;
 
 	XFS_BUF_SET_PRIORITY(bp, isadir ? B_DIR_BMAP : B_BMAP);
diff --git a/repair/rt.c b/repair/rt.c
index b514998d..d901e751 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -193,9 +193,9 @@ process_rtbitmap(xfs_mount_t	*mp,
 			error = 1;
 			continue;
 		}
-		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				XFS_FSB_TO_BB(mp, 1), NULL);
-		if (!bp) {
+		error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
+				XFS_FSB_TO_BB(mp, 1), 0, NULL, &bp);
+		if (error) {
 			do_warn(_("can't read block %d for rtbitmap inode\n"),
 					bmbno);
 			error = 1;
@@ -255,9 +255,9 @@ process_rtsummary(xfs_mount_t	*mp,
 			error++;
 			continue;
 		}
-		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				XFS_FSB_TO_BB(mp, 1), NULL);
-		if (!bp) {
+		error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
+				XFS_FSB_TO_BB(mp, 1), 0, NULL, &bp);
+		if (error) {
 			do_warn(_("can't read block %d for rtsummary inode\n"),
 					sumbno);
 			error++;
diff --git a/repair/scan.c b/repair/scan.c
index 66b596db..99f65cff 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -46,6 +46,39 @@ set_mp(xfs_mount_t *mpp)
 	mp = mpp;
 }
 
+/*
+ * Read a buffer into memory, even if it fails verifier checks.
+ * If an IO error happens, return a zeroed buffer.
+ */
+static inline int
+salvage_buffer(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	struct xfs_buf		**bpp,
+	const struct xfs_buf_ops *ops)
+{
+	int			error;
+
+	error = -libxfs_buf_read(target, blkno, numblks,
+			LIBXFS_READBUF_SALVAGE, bpp, ops);
+	if (error != EIO)
+		return error;
+
+	/*
+	 * If the read produced an IO error, grab the buffer (which will now
+	 * be full of zeroes) and make it look like we read the data from the
+	 * disk but it failed verification.
+	 */
+	error = -libxfs_buf_get(target, blkno, numblks, bpp);
+	if (error)
+		return error;
+
+	(*bpp)->b_error = -EFSCORRUPTED;
+	(*bpp)->b_ops = ops;
+	return 0;
+}
+
 static void
 scan_sbtree(
 	xfs_agblock_t	root,
@@ -66,11 +99,12 @@ scan_sbtree(
 	void		*priv,
 	const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
+	int		error;
 
-	bp = libxfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, root),
-			XFS_FSB_TO_BB(mp, 1), 0, ops);
-	if (!bp) {
+	error = salvage_buffer(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, root),
+			XFS_FSB_TO_BB(mp, 1), &bp, ops);
+	if (error) {
 		do_error(_("can't read btree block %d/%d\n"), agno, root);
 		return;
 	}
@@ -123,9 +157,9 @@ scan_lbtree(
 	int		dirty = 0;
 	bool		badcrc = false;
 
-	bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
-		      XFS_FSB_TO_BB(mp, 1), 0, ops);
-	if (!bp)  {
+	err = salvage_buffer(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
+			XFS_FSB_TO_BB(mp, 1), &bp, ops);
+	if (err) {
 		do_error(_("can't read btree block %d/%d\n"),
 			XFS_FSB_TO_AGNO(mp, root),
 			XFS_FSB_TO_AGBNO(mp, root));
@@ -2102,6 +2136,7 @@ scan_freelist(
 	xfs_buf_t		*agflbuf;
 	xfs_agnumber_t		agno;
 	struct agfl_state	state;
+	int			error;
 
 	agno = be32_to_cpu(agf->agf_seqno);
 
@@ -2113,10 +2148,10 @@ scan_freelist(
 	if (be32_to_cpu(agf->agf_flcount) == 0)
 		return;
 
-	agflbuf = libxfs_buf_read(mp->m_dev,
-				 XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
-				 XFS_FSS_TO_BB(mp, 1), 0, &xfs_agfl_buf_ops);
-	if (!agflbuf)  {
+	error = salvage_buffer(mp->m_dev,
+			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), &agflbuf, &xfs_agfl_buf_ops);
+	if (error) {
 		do_abort(_("can't read agfl block for ag %d\n"), agno);
 		return;
 	}
@@ -2330,6 +2365,7 @@ scan_ag(
 	int		sb_dirty = 0;
 	int		status;
 	char		*objname = NULL;
+	int		error;
 
 	sb = (struct xfs_sb *)calloc(BBTOB(XFS_FSS_TO_BB(mp, 1)), 1);
 	if (!sb) {
@@ -2337,27 +2373,27 @@ scan_ag(
 		return;
 	}
 
-	sbbuf = libxfs_buf_read(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
-				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
-	if (!sbbuf)  {
+	error = salvage_buffer(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
+			XFS_FSS_TO_BB(mp, 1), &sbbuf, &xfs_sb_buf_ops);
+	if (error) {
 		objname = _("root superblock");
 		goto out_free_sb;
 	}
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbbuf));
 
-	agfbuf = libxfs_buf_read(mp->m_dev,
+	error = salvage_buffer(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agf_buf_ops);
-	if (!agfbuf)  {
+			XFS_FSS_TO_BB(mp, 1), &agfbuf, &xfs_agf_buf_ops);
+	if (error) {
 		objname = _("agf block");
 		goto out_free_sbbuf;
 	}
 	agf = XFS_BUF_TO_AGF(agfbuf);
 
-	agibuf = libxfs_buf_read(mp->m_dev,
+	error = salvage_buffer(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agi_buf_ops);
-	if (!agibuf)  {
+			XFS_FSS_TO_BB(mp, 1), &agibuf, &xfs_agi_buf_ops);
+	if (error) {
 		objname = _("agi block");
 		goto out_free_agfbuf;
 	}

