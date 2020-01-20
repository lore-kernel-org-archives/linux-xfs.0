Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F82FC33CAA
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBA9B22522
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:59:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IP2mSNQp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgATW7z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:59:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38356 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATW7z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 17:59:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMwNwh079560;
        Mon, 20 Jan 2020 22:59:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=o102+i9Opcuf7KV9VgsfzVJ0av3ssihGaBtgNDvGwpU=;
 b=IP2mSNQpoblUwlqWkSlMu9HVsacoqWPljY+/NYzFaD1LVSvbxs8Gt0zXlvOHDhIc2jlF
 bLLb+ZdpIFWmhjmqj17yMLuIJX2uCEhaT1gz/UwWuxN923BAAECS66C67wxunCt54n4/
 4G8PJcyCqrh1p0jnvSj5vnhKM42c9qZ0B05f+EyGfnQGi5dafjiuHGU0x1ozLUOLIBWE
 mMIxRS0jqYCEJvyuVNGxeb+Ml+Yn4LfVIt1CHA6aOWO6zqWz6WqOKrKEYeVYqsFS08+e
 uwBSi0gDXYwlUocY3I3Z2xSh6r9y9tPAlkxAos6Fg8mpS+/3XwJdNCwZZL6UIuGlKe/x Kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseu9uau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:59:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMnBtl169388;
        Mon, 20 Jan 2020 22:57:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xmbj4m956-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:57:48 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00KMvlBb012477;
        Mon, 20 Jan 2020 22:57:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 14:57:47 -0800
Subject: [PATCH 12/13] xfs: move buffer read io error logging to
 xfs_buf_read_map
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Mon, 20 Jan 2020 14:57:46 -0800
Message-ID: <157956106624.1166689.13426769287670717867.stgit@magnolia>
In-Reply-To: <157956098906.1166689.13651975861399490259.stgit@magnolia>
References: <157956098906.1166689.13651975861399490259.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200193
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the open-coded logic that reports metadata IO read / corruption
errors and stales the buffer into xfs_buf_read_map so that it's all
consistent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |   10 -------
 fs/xfs/xfs_buf.c                |   53 +++++++++++++++++++++++++++++----------
 fs/xfs/xfs_log_recover.c        |   10 -------
 fs/xfs/xfs_symlink.c            |   10 -------
 fs/xfs/xfs_trans_buf.c          |   34 +++++++------------------
 5 files changed, 49 insertions(+), 68 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 46f055804433..8b7f74b3bea2 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -422,16 +422,6 @@ xfs_attr_rmtval_get(
 					0, &bp, &xfs_attr3_rmt_buf_ops);
 			if (error)
 				return error;
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
index 306394300863..c0b4d516fa2c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -817,28 +817,55 @@ xfs_buf_read_map(
 
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
 
-	if (!(bp->b_flags & XBF_DONE)) {
+	if (bp->b_flags & XBF_DONE) {
+		/* Buffer already read; all we need to do is check it. */
+		xfs_buf_reverify(bp, ops);
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
+	} else {
+		/* Initiate the buffer read and wait. */
 		XFS_STATS_INC(target->bt_mount, xb_get_read);
 		bp->b_ops = ops;
 		_xfs_buf_read(bp, flags);
-		*bpp = bp;
-		return 0;
+
+		/* Readahead iodone already dropped the buffer, so exit. */
+		if (flags & XBF_ASYNC)
+			return 0;
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
+	if (bp->b_error) {
+		error = bp->b_error;
 
-	if (flags & XBF_ASYNC) {
-		/*
-		 * Read ahead call which is already satisfied,
-		 * drop the buffer
-		 */
+		if (!XFS_FORCED_SHUTDOWN(target->bt_mount))
+			xfs_buf_ioerror_alert(bp, __func__);
+
+		bp->b_flags &= ~XBF_DONE;
+		xfs_buf_stale(bp);
 		xfs_buf_relse(bp);
-		return 0;
+
+		/* bad CRC means corrupted metadata */
+		if (error == -EFSBADCRC)
+			error = -EFSCORRUPTED;
+		return error;
 	}
 
-	/* We do not want read in the flags */
-	bp->b_flags &= ~XBF_READ;
-	ASSERT(bp->b_ops != NULL || ops == NULL);
 	*bpp = bp;
 	return 0;
 }
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b29806846916..ac79537d3275 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2749,11 +2749,6 @@ xlog_recover_buffer_pass2(
 			  buf_flags, &bp, NULL);
 	if (error)
 		return error;
-	error = bp->b_error;
-	if (error) {
-		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#1)");
-		goto out_release;
-	}
 
 	/*
 	 * Recover the buffer only if we get an LSN from it and it's less than
@@ -2954,11 +2949,6 @@ xlog_recover_inode_pass2(
 			0, &bp, &xfs_inode_buf_ops);
 	if (error)
 		goto error;
-	error = bp->b_error;
-	if (error) {
-		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#2)");
-		goto out_release;
-	}
 	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
 	dip = xfs_buf_offset(bp, in_f->ilf_boffset);
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a283d6d6fb46..d762d42ed0ff 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -57,16 +57,6 @@ xfs_readlink_bmap_ilocked(
 				&bp, &xfs_symlink_buf_ops);
 		if (error)
 			return error;
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
index babbfddbe505..449be0f8c10f 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -303,32 +303,16 @@ xfs_trans_read_buf_map(
 	}
 
 	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops);
-	if (error)
-		return error;
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
+	switch (error) {
+	case 0:
+		break;
+	case -EFSCORRUPTED:
+	case -EIO:
 		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
-			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
-		xfs_buf_relse(bp);
-
-		/* bad CRC means corrupted metadata */
-		if (error == -EFSBADCRC)
-			error = -EFSCORRUPTED;
+			xfs_force_shutdown(tp->t_mountp,
+					SHUTDOWN_META_IO_ERROR);
+		/* fall through */
+	default:
 		return error;
 	}
 

