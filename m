Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D588C7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 523E721D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="v5J+Bak3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgBTBpk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:45:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47084 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBpj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:45:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1h9sh092867;
        Thu, 20 Feb 2020 01:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2rM4SfoTyM5DYGzH+QslqRC8bG7WobbUsBq/ESBZxkI=;
 b=v5J+Bak3g0Ee7+vYDC9LvJZCuq0/h9Na7D2GfMH8bJwddo/ninNlw/5x7nsHV2eSLiHw
 LwpA5szM/pxI8xnIZqAfUIg9u91nUKvDrJQm4ObOmSTBaj0KJgUFpYIhvMyss6M5ZsRE
 7G/EUE8x4JZxpd/0GwUBH0B6QNAogD7xlCofcAu2DVUZy6qYuMTNnX6drrEiFwWw7PgX
 TY6qsJk3Ga8V/y1CwN2m3LTDaBi9HUOi2A1NN6PlIuVoVa33FZR4sbkxwgamXkRC6yaK
 /oTz3gsORqM++mYFt357WEqfmEWbMLtZ3xFDlZk6NbzvWOIfOwqvcS6+VrDCjZ/bwr49 4w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2y8udd6tkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gMjl146790;
        Thu, 20 Feb 2020 01:45:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2y8ud4q1f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:30 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1jTm5003188;
        Thu, 20 Feb 2020 01:45:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:45:29 -0800
Subject: [PATCH 09/14] xfs: make xfs_buf_read return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Wed, 19 Feb 2020 17:45:28 -0800
Message-ID: <158216312811.603628.13612770543668606110.stgit@magnolia>
In-Reply-To: <158216306957.603628.16404096061228456718.stgit@magnolia>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=2
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
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
 copy/xfs_copy.c          |   11 +++++++---
 db/io.c                  |    3 ++-
 libxfs/init.c            |   36 +++++++++++++++++----------------
 libxfs/libxfs_io.h       |   21 ++++++++-----------
 libxfs/rdwr.c            |   20 +++++++++++-------
 libxfs/xfs_attr_remote.c |    8 ++++---
 mkfs/xfs_mkfs.c          |    8 ++++---
 repair/attr_repair.c     |   29 ++++++++++++++++-----------
 repair/dino_chunks.c     |   23 ++++++++++++---------
 repair/dinode.c          |   25 +++++++++++++++--------
 repair/phase3.c          |    8 +++++--
 repair/prefetch.c        |    8 +++++--
 repair/rt.c              |   12 ++++++-----
 repair/scan.c            |   50 ++++++++++++++++++++++++++++------------------
 14 files changed, 149 insertions(+), 113 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 75c39407..26d7d7d0 100644
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
index c66cb785..4551b6d6 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -403,9 +403,10 @@ rtmount_init(
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
@@ -438,9 +439,9 @@ rtmount_init(
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
@@ -721,10 +722,10 @@ libxfs_mount(
 	if (!(flags & LIBXFS_MOUNT_DEBUGGER))
 		readflags |= LIBXFS_READBUF_FAIL_EXIT;
 
-	bp = libxfs_buf_read(mp->m_dev,
+	error = libxfs_buf_read(mp->m_dev,
 			d - XFS_FSS_TO_BB(mp, 1), XFS_FSS_TO_BB(mp, 1),
-			readflags, NULL);
-	if (!bp) {
+			readflags, &bp, NULL);
+	if (error) {
 		fprintf(stderr, _("%s: data size check failed\n"), progname);
 		if (!(flags & LIBXFS_MOUNT_DEBUGGER))
 			return NULL;
@@ -734,11 +735,10 @@ libxfs_mount(
 	if (mp->m_logdev_targp->dev &&
 	    mp->m_logdev_targp->dev != mp->m_ddev_targp->dev) {
 		d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
-		if ( (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) ||
-		     (!(bp = libxfs_buf_read(mp->m_logdev_targp,
-					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_BB(mp, 1),
-					readflags, NULL))) ) {
+		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks ||
+		    libxfs_buf_read(mp->m_logdev_targp,
+				d - XFS_FSB_TO_BB(mp, 1), XFS_FSB_TO_BB(mp, 1),
+				readflags, &bp, NULL)) {
 			fprintf(stderr, _("%s: log size checks failed\n"),
 					progname);
 			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
@@ -763,10 +763,10 @@ libxfs_mount(
 	 * read the first one and let the user know to check the geometry.
 	 */
 	if (sbp->sb_agcount > 1000000) {
-		bp = libxfs_buf_read(mp->m_dev,
+		error = libxfs_buf_read(mp->m_dev,
 				XFS_AG_DADDR(mp, sbp->sb_agcount - 1, 0), 1,
-				readflags, NULL);
-		if (bp->b_error) {
+				readflags, &bp, NULL);
+		if (error) {
 			fprintf(stderr, _("%s: read of AG %u failed\n"),
 						progname, sbp->sb_agcount);
 			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
@@ -774,8 +774,8 @@ libxfs_mount(
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
index 6fbf976b..81f4269c 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -134,9 +134,9 @@ extern struct cache_operations	libxfs_bcache_operations;
 
 #ifdef XFS_BUF_TRACING
 
-#define libxfs_buf_read(dev, daddr, len, flags, ops) \
+#define libxfs_buf_read(dev, daddr, len, flags, bpp, ops) \
 	libxfs_trace_readbuf(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (daddr), (len), (flags), (ops))
+			    (dev), (daddr), (len), (flags), (bpp), (ops))
 #define libxfs_buf_read_map(dev, map, nmaps, flags, bpp, ops) \
 	libxfs_trace_readbuf_map(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (map), (nmaps), (flags), (bpp), (ops))
@@ -152,9 +152,10 @@ extern struct cache_operations	libxfs_bcache_operations;
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
@@ -192,22 +193,18 @@ libxfs_buf_get(
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
index 0bfe46f3..91de86ec 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -408,7 +408,7 @@ do {						\
 	}					\
 } while (0)
 
-struct xfs_buf *
+int
 libxfs_trace_readbuf(
 	const char		*func,
 	const char		*file,
@@ -417,14 +417,15 @@ libxfs_trace_readbuf(
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
@@ -509,8 +510,11 @@ struct xfs_buf *
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
index e6b44575..83098c35 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3595,11 +3595,11 @@ rewrite_secondary_superblocks(
 	struct xfs_buf		*buf;
 
 	/* rewrite the last superblock */
-	buf = libxfs_buf_read(mp->m_dev,
+	libxfs_buf_read(mp->m_dev,
 			XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount - 1,
 				XFS_SB_DADDR),
 			XFS_FSS_TO_BB(mp, 1),
-			LIBXFS_READBUF_FAIL_EXIT, &xfs_sb_buf_ops);
+			LIBXFS_READBUF_FAIL_EXIT, &buf, &xfs_sb_buf_ops);
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
 	libxfs_buf_dirty(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
 	libxfs_buf_relse(buf);
@@ -3608,11 +3608,11 @@ rewrite_secondary_superblocks(
 	if (mp->m_sb.sb_agcount <= 2)
 		return;
 
-	buf = libxfs_buf_read(mp->m_dev,
+	libxfs_buf_read(mp->m_dev,
 			XFS_AGB_TO_DADDR(mp, (mp->m_sb.sb_agcount - 1) / 2,
 				XFS_SB_DADDR),
 			XFS_FSS_TO_BB(mp, 1),
-			LIBXFS_READBUF_FAIL_EXIT, &xfs_sb_buf_ops);
+			LIBXFS_READBUF_FAIL_EXIT, &buf, &xfs_sb_buf_ops);
 	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
 	libxfs_buf_dirty(buf, LIBXFS_WRITEBUF_FAIL_EXIT);
 	libxfs_buf_relse(buf);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index fb64b0be..8352f17e 100644
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
index 1378fc59..028541d4 100644
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
index 276dd2e1..1f5fa4f8 100644
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
index 396743a4..8bbc4e6b 100644
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
index 587b3b1f..9a6de206 100644
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
index 8b91b27e..f8cc9590 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -66,11 +66,13 @@ scan_sbtree(
 	void		*priv,
 	const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
+	int		error;
 
-	bp = libxfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, root),
-			XFS_FSB_TO_BB(mp, 1), 0, ops);
-	if (!bp) {
+	error = -libxfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, root),
+			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
+			ops);
+	if (error) {
 		do_error(_("can't read btree block %d/%d\n"), agno, root);
 		return;
 	}
@@ -123,9 +125,10 @@ scan_lbtree(
 	int		dirty = 0;
 	bool		badcrc = false;
 
-	bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
-		      XFS_FSB_TO_BB(mp, 1), 0, ops);
-	if (!bp)  {
+	err = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
+			XFS_FSB_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &bp,
+			ops);
+	if (err) {
 		do_error(_("can't read btree block %d/%d\n"),
 			XFS_FSB_TO_AGNO(mp, root),
 			XFS_FSB_TO_AGBNO(mp, root));
@@ -2102,6 +2105,7 @@ scan_freelist(
 	xfs_buf_t		*agflbuf;
 	xfs_agnumber_t		agno;
 	struct agfl_state	state;
+	int			error;
 
 	agno = be32_to_cpu(agf->agf_seqno);
 
@@ -2113,10 +2117,11 @@ scan_freelist(
 	if (be32_to_cpu(agf->agf_flcount) == 0)
 		return;
 
-	agflbuf = libxfs_buf_read(mp->m_dev,
-				 XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
-				 XFS_FSS_TO_BB(mp, 1), 0, &xfs_agfl_buf_ops);
-	if (!agflbuf)  {
+	error = -libxfs_buf_read(mp->m_dev,
+			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &agflbuf,
+			&xfs_agfl_buf_ops);
+	if (error) {
 		do_abort(_("can't read agfl block for ag %d\n"), agno);
 		return;
 	}
@@ -2330,6 +2335,7 @@ scan_ag(
 	int		sb_dirty = 0;
 	int		status;
 	char		*objname = NULL;
+	int		error;
 
 	sb = (struct xfs_sb *)calloc(BBTOB(XFS_FSS_TO_BB(mp, 1)), 1);
 	if (!sb) {
@@ -2337,27 +2343,31 @@ scan_ag(
 		return;
 	}
 
-	sbbuf = libxfs_buf_read(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
-				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
-	if (!sbbuf)  {
+	error = -libxfs_buf_read(mp->m_dev,
+			XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
+			XFS_FSS_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &sbbuf,
+			&xfs_sb_buf_ops);
+	if (error) {
 		objname = _("root superblock");
 		goto out_free_sb;
 	}
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbbuf));
 
-	agfbuf = libxfs_buf_read(mp->m_dev,
+	error = -libxfs_buf_read(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agf_buf_ops);
-	if (!agfbuf)  {
+			XFS_FSS_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &agfbuf,
+			&xfs_agf_buf_ops);
+	if (error) {
 		objname = _("agf block");
 		goto out_free_sbbuf;
 	}
 	agf = XFS_BUF_TO_AGF(agfbuf);
 
-	agibuf = libxfs_buf_read(mp->m_dev,
+	error = -libxfs_buf_read(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agi_buf_ops);
-	if (!agibuf)  {
+			XFS_FSS_TO_BB(mp, 1), LIBXFS_READBUF_SALVAGE, &agibuf,
+			&xfs_agi_buf_ops);
+	if (error) {
 		objname = _("agi block");
 		goto out_free_agfbuf;
 	}

