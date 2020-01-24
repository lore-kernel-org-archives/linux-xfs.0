Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17D6C2D0CE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A6692071A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 05:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oLujvlBa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgAXFTZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 00:19:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgAXFTY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 00:19:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5ISMx033775;
        Fri, 24 Jan 2020 05:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=FWIeXTgl/iBFsw9EpHaUOSQQMLqsgzfBhs5qewk6mfE=;
 b=oLujvlBaRtCMx72hFlqiv4z8AV0z8KjweUZyPfHkEKFxIG3M9G/aOO/7aOR2TVSkOZfH
 TXzAHuknJqx1d+Zo9WY/W4UUhghBfV7CN/O3QcHhqRopnP6SkEGQqSJck7ZsU6uiCEb7
 MbYtXLGb3XbEUO07kvLBE9pf+7G+zFkxCRlmDAQBmeEGLrG+e6C7PI0jEss9OW0TahFX
 Yv8QbhTUMIqwYrn8auvZGh98TJyCfzUx5Hv7S2dwikEOUHoIOCY6RYfmCSXJsv8dMryc
 JLlMn98/cAp2CYQcJ23v9qqDaoGj+K0PnP9R9QXe1tPIwKBJI9Yi4fENK4EwGf28UH79 sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnrps2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:19:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5II7R031240;
        Fri, 24 Jan 2020 05:19:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xqmwckt57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:19:17 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O5JHKc020573;
        Fri, 24 Jan 2020 05:19:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 21:19:16 -0800
Subject: [PATCH 03/12] xfs: make xfs_buf_read_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Thu, 23 Jan 2020 21:19:15 -0800
Message-ID: <157984315522.3139258.1946613629222213561.stgit@magnolia>
In-Reply-To: <157984313582.3139258.1136501362141645797.stgit@magnolia>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfs_buf_read_map() to return numeric error codes like most
everywhere else in xfs.  This involves moving the open-coded logic that
reports metadata IO read / corruption errors and stales the buffer into
xfs_buf_read_map so that the logic is all in one place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c       |   11 ++++---
 fs/xfs/libxfs/xfs_attr_remote.c |   10 ------
 fs/xfs/xfs_buf.c                |   63 +++++++++++++++++++++++++++++----------
 fs/xfs/xfs_buf.h                |   15 ++++++---
 fs/xfs/xfs_log_recover.c        |   10 ------
 fs/xfs/xfs_symlink.c            |   10 ------
 fs/xfs/xfs_trans_buf.c          |   36 +++++-----------------
 7 files changed, 72 insertions(+), 83 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index fc93fd88ec89..4cc10aa43edf 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2956,14 +2956,17 @@ xfs_read_agf(
 	trace_xfs_read_agf(mp, agno);
 
 	ASSERT(agno != NULLAGNUMBER);
-	error = xfs_trans_read_buf(
-			mp, tp, mp->m_ddev_targp,
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
+	/*
+	 * Callers of xfs_read_agf() currently interpret a NULL bpp as EAGAIN
+	 * and need to be converted to check for EAGAIN specifically.
+	 */
+	if (error == -EAGAIN)
+		return 0;
 	if (error)
 		return error;
-	if (!*bpp)
-		return 0;
 
 	ASSERT(!(*bpp)->b_error);
 	xfs_buf_set_ref(*bpp, XFS_AGF_REF);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index a266d05df146..88e50e904436 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -422,16 +422,6 @@ xfs_attr_rmtval_get(
 					&xfs_attr3_rmt_buf_ops);
 			if (!bp)
 				return -ENOMEM;
-			error = bp->b_error;
-			if (error) {
-				xfs_buf_ioerror_alert(bp, __func__);
-				xfs_buf_relse(bp);
-
-				/* bad CRC means corrupted metadata */
-				if (error == -EFSBADCRC)
-					error = -EFSCORRUPTED;
-				return error;
-			}
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 5c07b4a70026..871abaabff3d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -796,47 +796,76 @@ xfs_buf_reverify(
 	return bp->b_error;
 }
 
-xfs_buf_t *
+int
 xfs_buf_read_map(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
 	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
 	int			error;
 
 	flags |= XBF_READ;
+	*bpp = NULL;
 
 	error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
 	if (error)
-		return NULL;
+		return error;
 
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
 
 	if (!(bp->b_flags & XBF_DONE)) {
+		/* Initiate the buffer read and wait. */
 		XFS_STATS_INC(target->bt_mount, xb_get_read);
 		bp->b_ops = ops;
-		_xfs_buf_read(bp, flags);
-		return bp;
+		error = _xfs_buf_read(bp, flags);
+
+		/* Readahead iodone already dropped the buffer, so exit. */
+		if (flags & XBF_ASYNC)
+			return 0;
+	} else {
+		/* Buffer already read; all we need to do is check it. */
+		error = xfs_buf_reverify(bp, ops);
+
+		/* Readahead already finished; drop the buffer and exit. */
+		if (flags & XBF_ASYNC) {
+			xfs_buf_relse(bp);
+			return 0;
+		}
+
+		/* We do not want read in the flags */
+		bp->b_flags &= ~XBF_READ;
+		ASSERT(bp->b_ops != NULL || ops == NULL);
 	}
 
-	xfs_buf_reverify(bp, ops);
+	/*
+	 * If we've had a read error, then the contents of the buffer are
+	 * invalid and should not be used. To ensure that a followup read tries
+	 * to pull the buffer from disk again, we clear the XBF_DONE flag and
+	 * mark the buffer stale. This ensures that anyone who has a current
+	 * reference to the buffer will interpret it's contents correctly and
+	 * future cache lookups will also treat it as an empty, uninitialised
+	 * buffer.
+	 */
+	if (error) {
+		if (!XFS_FORCED_SHUTDOWN(target->bt_mount))
+			xfs_buf_ioerror_alert(bp, __func__);
 
-	if (flags & XBF_ASYNC) {
-		/*
-		 * Read ahead call which is already satisfied,
-		 * drop the buffer
-		 */
+		bp->b_flags &= ~XBF_DONE;
+		xfs_buf_stale(bp);
 		xfs_buf_relse(bp);
-		return NULL;
+
+		/* bad CRC means corrupted metadata */
+		if (error == -EFSBADCRC)
+			error = -EFSCORRUPTED;
+		return error;
 	}
 
-	/* We do not want read in the flags */
-	bp->b_flags &= ~XBF_READ;
-	ASSERT(bp->b_ops != NULL || ops == NULL);
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 /*
@@ -850,11 +879,13 @@ xfs_buf_readahead_map(
 	int			nmaps,
 	const struct xfs_buf_ops *ops)
 {
+	struct xfs_buf		*bp;
+
 	if (bdi_read_congested(target->bt_bdev->bd_bdi))
 		return;
 
 	xfs_buf_read_map(target, map, nmaps,
-		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD, ops);
+		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops);
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 25dd2aa4322b..f58147354b02 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -194,10 +194,9 @@ struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
 
 int xfs_buf_get_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
 		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp);
-struct xfs_buf *xfs_buf_read_map(struct xfs_buftarg *target,
-			       struct xfs_buf_map *map, int nmaps,
-			       xfs_buf_flags_t flags,
-			       const struct xfs_buf_ops *ops);
+int xfs_buf_read_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
+		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp,
+		const struct xfs_buf_ops *ops);
 void xfs_buf_readahead_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
 			       const struct xfs_buf_ops *ops);
@@ -226,8 +225,14 @@ xfs_buf_read(
 	xfs_buf_flags_t		flags,
 	const struct xfs_buf_ops *ops)
 {
+	struct xfs_buf		*bp;
+	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return xfs_buf_read_map(target, &map, 1, flags, ops);
+
+	error = xfs_buf_read_map(target, &map, 1, flags, &bp, ops);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 static inline void
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0d683fb96396..c805a02f0078 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2749,11 +2749,6 @@ xlog_recover_buffer_pass2(
 			  buf_flags, NULL);
 	if (!bp)
 		return -ENOMEM;
-	error = bp->b_error;
-	if (error) {
-		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#1)");
-		goto out_release;
-	}
 
 	/*
 	 * Recover the buffer only if we get an LSN from it and it's less than
@@ -2956,11 +2951,6 @@ xlog_recover_inode_pass2(
 		error = -ENOMEM;
 		goto error;
 	}
-	error = bp->b_error;
-	if (error) {
-		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#2)");
-		goto out_release;
-	}
 	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
 	dip = xfs_buf_offset(bp, in_f->ilf_boffset);
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a25502bc2071..b255a393a73b 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -57,16 +57,6 @@ xfs_readlink_bmap_ilocked(
 				  &xfs_symlink_buf_ops);
 		if (!bp)
 			return -ENOMEM;
-		error = bp->b_error;
-		if (error) {
-			xfs_buf_ioerror_alert(bp, __func__);
-			xfs_buf_relse(bp);
-
-			/* bad CRC means corrupted metadata */
-			if (error == -EFSBADCRC)
-				error = -EFSCORRUPTED;
-			goto out;
-		}
 		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
 		if (pathlen < byte_cnt)
 			byte_cnt = pathlen;
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 288333fef13a..cdb66c661425 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -302,36 +302,16 @@ xfs_trans_read_buf_map(
 		return 0;
 	}
 
-	bp = xfs_buf_read_map(target, map, nmaps, flags, ops);
-	if (!bp) {
-		if (!(flags & XBF_TRYLOCK))
-			return -ENOMEM;
-		return tp ? 0 : -EAGAIN;
-	}
-
-	/*
-	 * If we've had a read error, then the contents of the buffer are
-	 * invalid and should not be used. To ensure that a followup read tries
-	 * to pull the buffer from disk again, we clear the XBF_DONE flag and
-	 * mark the buffer stale. This ensures that anyone who has a current
-	 * reference to the buffer will interpret it's contents correctly and
-	 * future cache lookups will also treat it as an empty, uninitialised
-	 * buffer.
-	 */
-	if (bp->b_error) {
-		error = bp->b_error;
-		if (!XFS_FORCED_SHUTDOWN(mp))
-			xfs_buf_ioerror_alert(bp, __func__);
-		bp->b_flags &= ~XBF_DONE;
-		xfs_buf_stale(bp);
-
+	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops);
+	switch (error) {
+	case 0:
+		break;
+	default:
 		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
 			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
-		xfs_buf_relse(bp);
-
-		/* bad CRC means corrupted metadata */
-		if (error == -EFSBADCRC)
-			error = -EFSCORRUPTED;
+		/* fall through */
+	case -ENOMEM:
+	case -EAGAIN:
 		return error;
 	}
 

