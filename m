Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19D2C32771
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A1B322522
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 22:58:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wicrj5oO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgATW6B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:58:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36888 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATW6B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 17:58:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMvWhm078641;
        Mon, 20 Jan 2020 22:57:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GAhYExrrCh9UBYewsS9Stsc2KfwOJ27VqmX3xdEpv1g=;
 b=Wicrj5oOdY5NLKLEpezN8UPGlF+7ebOeLC8lgSEwSdO2nvSZY+2Jv1FJMaAFYST0aTW8
 px26oLeuuTfolRnYfWp83Iv9sWPZ41MNbpd8T2rvGIpaCxS1Ok61JMQswnJ93YbzDiHP
 j7tee1uzSjLUBC2o0t2hRY2pugZ2ckgh4z9tjObG7MTer8VyeCJ0E4LmIBCbbXtlc80J
 B9JvMLceiCdkIq12vKOkjBB6cnyTmyKRyyJz2rPkTTabBy90Y8zvfE+umVyCcgaeXho5
 fSzRxWQFp/0aacSO4As3GOW+P9LFknwjWs8pwcOsbc/4IRnY22Aa467kViIkbcOF07LE zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xkseu9u6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:57:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KMn3i7037008;
        Mon, 20 Jan 2020 22:57:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xmc5mc654-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 22:57:54 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00KMvs1R012488;
        Mon, 20 Jan 2020 22:57:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 14:57:53 -0800
Subject: [PATCH 13/13] xfs: fix xfs_buf_ioerror_alert location reporting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Mon, 20 Jan 2020 14:57:52 -0800
Message-ID: <157956107260.1166689.424050523367883640.stgit@magnolia>
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
 definitions=main-2001200192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Instead of passing __func__ to the error reporting function, let's use
the return address builtins so that the messages actually tell you which
higher level function called the buffer functions.  This was previously
true for the xfs_buf_read callers, but not for the xfs_trans_read_buf
callers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c         |   12 +++++++-----
 fs/xfs/xfs_buf.h         |    7 ++++---
 fs/xfs/xfs_buf_item.c    |    2 +-
 fs/xfs/xfs_log_recover.c |    4 ++--
 fs/xfs/xfs_trans_buf.c   |    5 +++--
 5 files changed, 17 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index c0b4d516fa2c..122e9b3d0cba 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -803,7 +803,8 @@ xfs_buf_read_map(
 	int			nmaps,
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp,
-	const struct xfs_buf_ops *ops)
+	const struct xfs_buf_ops *ops,
+	xfs_failaddr_t		fa)
 {
 	struct xfs_buf		*bp;
 	int			error;
@@ -854,7 +855,7 @@ xfs_buf_read_map(
 		error = bp->b_error;
 
 		if (!XFS_FORCED_SHUTDOWN(target->bt_mount))
-			xfs_buf_ioerror_alert(bp, __func__);
+			xfs_buf_ioerror_alert(bp, fa);
 
 		bp->b_flags &= ~XBF_DONE;
 		xfs_buf_stale(bp);
@@ -887,7 +888,8 @@ xfs_buf_readahead_map(
 		return;
 
 	xfs_buf_read_map(target, map, nmaps,
-		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops);
+		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops,
+		     __this_address);
 }
 
 /*
@@ -1236,10 +1238,10 @@ __xfs_buf_ioerror(
 void
 xfs_buf_ioerror_alert(
 	struct xfs_buf		*bp,
-	const char		*func)
+	xfs_failaddr_t		func)
 {
 	xfs_alert(bp->b_mount,
-"metadata I/O error in \"%s\" at daddr 0x%llx len %d error %d",
+"metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
 			func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
 			-bp->b_error);
 }
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d1908a5038a2..567ec2c24244 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -196,7 +196,7 @@ int xfs_buf_get_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
 		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp);
 int xfs_buf_read_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
 		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp,
-		const struct xfs_buf_ops *ops);
+		const struct xfs_buf_ops *ops, xfs_failaddr_t fa);
 void xfs_buf_readahead_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
 		int nmaps, const struct xfs_buf_ops *ops);
 
@@ -223,7 +223,8 @@ xfs_buf_read(
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	return xfs_buf_read_map(target, &map, 1, flags, bpp, ops);
+	return xfs_buf_read_map(target, &map, 1, flags, bpp, ops,
+			__builtin_return_address(0));
 }
 
 static inline void
@@ -260,7 +261,7 @@ extern void xfs_buf_ioend(struct xfs_buf *bp);
 extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 		xfs_failaddr_t failaddr);
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
-extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
+extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa);
 
 extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
 static inline int xfs_buf_submit(struct xfs_buf *bp)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 5be8973a452c..663810e6cd59 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1113,7 +1113,7 @@ xfs_buf_iodone_callback_error(
 	if (bp->b_target != lasttarg ||
 	    time_after(jiffies, (lasttime + 5*HZ))) {
 		lasttime = jiffies;
-		xfs_buf_ioerror_alert(bp, __func__);
+		xfs_buf_ioerror_alert(bp, __this_address);
 	}
 	lasttarg = bp->b_target;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ac79537d3275..25cfc85dbaa7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -294,7 +294,7 @@ xlog_recover_iodone(
 		 * this during recovery. One strike!
 		 */
 		if (!XFS_FORCED_SHUTDOWN(bp->b_mount)) {
-			xfs_buf_ioerror_alert(bp, __func__);
+			xfs_buf_ioerror_alert(bp, __this_address);
 			xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
 		}
 	}
@@ -5627,7 +5627,7 @@ xlog_do_recover(
 	error = xfs_buf_submit(bp);
 	if (error) {
 		if (!XFS_FORCED_SHUTDOWN(mp)) {
-			xfs_buf_ioerror_alert(bp, __func__);
+			xfs_buf_ioerror_alert(bp, __this_address);
 			ASSERT(0);
 		}
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 449be0f8c10f..2ffa401ebcc6 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -280,7 +280,7 @@ xfs_trans_read_buf_map(
 		ASSERT(bp->b_ops != NULL);
 		error = xfs_buf_reverify(bp, ops);
 		if (error) {
-			xfs_buf_ioerror_alert(bp, __func__);
+			xfs_buf_ioerror_alert(bp, __return_address);
 
 			if (tp->t_flags & XFS_TRANS_DIRTY)
 				xfs_force_shutdown(tp->t_mountp,
@@ -302,7 +302,8 @@ xfs_trans_read_buf_map(
 		return 0;
 	}
 
-	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops);
+	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops,
+			__return_address);
 	switch (error) {
 	case 0:
 		break;

