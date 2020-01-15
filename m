Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3E2C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0659224656
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:04:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bDeJ4rmF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgAORED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:04:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45668 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbgAORED (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:04:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhOWL012333;
        Wed, 15 Jan 2020 17:03:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=14Houvna0Lz2aOPyPMT2q1JtbiGMLvM1AMZilVMqvuA=;
 b=bDeJ4rmFn4f4RnekARO21jYrMLBxlj4airhCsyzSNEaJ4zCeadzTkPYKMZBXVbYZrnPy
 4wn0Ep0laTwl699P1MiXfyBRwgtWgftI4DruaOoH0tgdDoXq1iiXcpsI51wBFcHoLDZp
 EmwMn0bE40k3Co66UKC70r8u0vQvq9fmXoA7FyU0KQm9dNXsX9RQtHNbqjk9CBQPxmYw
 2c+1TPa/wWojHCqHrnWs7uGt7B3Sg5ZL9rcG5KBP3lyKYzr9HwvLdGyDYbvyI4gLzpXZ
 x+PkKWIX27SL3PSwzGa8/0BVrwhPHxjc1jxMFRzG35wo21MaZV3jp64KPP9NX5czWtjp Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xf73yndxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGiaS4183215;
        Wed, 15 Jan 2020 17:03:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xj1apwrd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:53 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FH3rht023914;
        Wed, 15 Jan 2020 17:03:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:03:53 -0800
Subject: [PATCH 2/9] xfs: make xfs_buf_read return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 09:03:52 -0800
Message-ID: <157910783215.2028217.1338010488330820754.stgit@magnolia>
In-Reply-To: <157910781961.2028217.1250106765923436515.stgit@magnolia>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfs_buf_read() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |   16 +++-------------
 fs/xfs/xfs_buf.c                |   32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h                |   14 +++-----------
 fs/xfs/xfs_log_recover.c        |   26 +++++++-------------------
 fs/xfs/xfs_symlink.c            |   17 ++++-------------
 5 files changed, 49 insertions(+), 56 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index a266d05df146..46c516809086 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -418,20 +418,10 @@ xfs_attr_rmtval_get(
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			bp = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt, 0,
-					&xfs_attr3_rmt_buf_ops);
-			if (!bp)
-				return -ENOMEM;
-			error = bp->b_error;
-			if (error) {
-				xfs_buf_ioerror_alert(bp, __func__);
-				xfs_buf_relse(bp);
-
-				/* bad CRC means corrupted metadata */
-				if (error == -EFSBADCRC)
-					error = -EFSCORRUPTED;
+			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
+					0, &bp, &xfs_attr3_rmt_buf_ops);
+			if (error)
 				return error;
-			}
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 546af31bb375..e11fc43c52de 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -850,6 +850,38 @@ xfs_buf_read_map(
 	return bp;
 }
 
+int
+xfs_buf_read(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp,
+	const struct xfs_buf_ops *ops)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	bp = xfs_buf_read_map(target, &map, 1, flags, ops);
+	if (!bp)
+		return -ENOMEM;
+	error = bp->b_error;
+	if (error) {
+		xfs_buf_ioerror_alert(bp, __func__);
+		xfs_buf_stale(bp);
+		xfs_buf_relse(bp);
+
+		/* bad CRC means corrupted metadata */
+		if (error == -EFSBADCRC)
+			error = -EFSCORRUPTED;
+		return error;
+	}
+
+	*bpp = bp;
+	return 0;
+}
+
 /*
  *	If we are not low on memory then do the readahead in a deadlock
  *	safe manner.
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 56e081dd1d96..f04722554f63 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -213,17 +213,9 @@ xfs_buf_get(
 	return xfs_buf_get_map(target, &map, 1, 0);
 }
 
-static inline struct xfs_buf *
-xfs_buf_read(
-	struct xfs_buftarg	*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
-	xfs_buf_flags_t		flags,
-	const struct xfs_buf_ops *ops)
-{
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_buf_read_map(target, &map, 1, flags, ops);
-}
+int xfs_buf_read(struct xfs_buftarg *target, xfs_daddr_t blkno, size_t numblks,
+		xfs_buf_flags_t flags, struct xfs_buf **bpp,
+		const struct xfs_buf_ops *ops);
 
 static inline void
 xfs_buf_readahead(
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0d683fb96396..ac79537d3275 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2745,15 +2745,10 @@ xlog_recover_buffer_pass2(
 	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
 		buf_flags |= XBF_UNMAPPED;
 
-	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
-			  buf_flags, NULL);
-	if (!bp)
-		return -ENOMEM;
-	error = bp->b_error;
-	if (error) {
-		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#1)");
-		goto out_release;
-	}
+	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
+			  buf_flags, &bp, NULL);
+	if (error)
+		return error;
 
 	/*
 	 * Recover the buffer only if we get an LSN from it and it's less than
@@ -2950,17 +2945,10 @@ xlog_recover_inode_pass2(
 	}
 	trace_xfs_log_recover_inode_recover(log, in_f);
 
-	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len, 0,
-			  &xfs_inode_buf_ops);
-	if (!bp) {
-		error = -ENOMEM;
+	error = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
+			0, &bp, &xfs_inode_buf_ops);
+	if (error)
 		goto error;
-	}
-	error = bp->b_error;
-	if (error) {
-		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#2)");
-		goto out_release;
-	}
 	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
 	dip = xfs_buf_offset(bp, in_f->ilf_boffset);
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a25502bc2071..f4b14569039f 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -53,20 +53,11 @@ xfs_readlink_bmap_ilocked(
 		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
 		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 
-		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
-				  &xfs_symlink_buf_ops);
-		if (!bp)
-			return -ENOMEM;
-		error = bp->b_error;
-		if (error) {
-			xfs_buf_ioerror_alert(bp, __func__);
-			xfs_buf_relse(bp);
-
-			/* bad CRC means corrupted metadata */
-			if (error == -EFSBADCRC)
-				error = -EFSCORRUPTED;
+		error = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
+				&bp, &xfs_symlink_buf_ops);
+		if (error)
 			goto out;
-		}
+
 		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
 		if (pathlen < byte_cnt)
 			byte_cnt = pathlen;

