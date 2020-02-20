Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEFA6C7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B43E221D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RHqT4Zc5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgBTBqC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:46:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgBTBqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:46:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1i5pq168770;
        Thu, 20 Feb 2020 01:45:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4yzqYDSgNbYh1WfbgUC/7+UYRK5yQHxrwnvf3MBvcZA=;
 b=RHqT4Zc5w2qbf4iu1vnfap4APjcoZA8+2uiNCJO3UcqFDk/mcMUnzQT+iWxVmTPwr0T4
 jWWKE2aIwa1g6ub3B9Go1w4pmyAzRJRX/4OqCkKyQtNcrr4pZP5juVWYr9Uy8dTJK/EN
 5NtRrNVXXJD1aFZAvVvEDlxGVKjV61UKorvqaZGdtoLOyHMOKpdEgawbYYOMVX4fXkR6
 HhJDYUQ3TGrK/RqFTz8f+SMnFEStSdvLVIxPleA2Ww0IfJh3KT1qeYYdULOCZwyNO+g2
 l34GaQxFvxYgwsWeUKcLOJul9RWE7YopSRH53tA9NFAEpAEa1VqI7iRyebs2ylQdATqx Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y8ud16sjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gEW9094337;
        Thu, 20 Feb 2020 01:45:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2y8udbmmka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:45:55 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1jsd7007414;
        Thu, 20 Feb 2020 01:45:54 GMT
Received: from localhost (/67.169.218.210) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Wed, 19 Feb 2020 17:45:35 -0800
USER-AGENT: StGit/0.17.1-dirty
MIME-Version: 1.0
Message-ID: <158216313447.603628.14166657759232654808.stgit@magnolia>
Date:   Thu, 20 Feb 2020 01:45:34 +0000 (UTC)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 10/14] xfs: make xfs_trans_get_buf_map return an error code
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
In-Reply-To: <158216306957.603628.16404096061228456718.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=2 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=2 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 9676b54e6e28689af1b4247569f14466bdfc5390

Convert xfs_trans_get_buf_map() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h   |   15 ++++++++++-----
 libxfs/trans.c        |   22 +++++++++++-----------
 libxfs/xfs_da_btree.c |    8 ++------
 3 files changed, 23 insertions(+), 22 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index cff27546..d94617e0 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -105,10 +105,9 @@ void	libxfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *,
 				uint, uint);
 bool	libxfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 
-struct xfs_buf	*libxfs_trans_get_buf_map(struct xfs_trans *tp,
-					struct xfs_buftarg *btp,
-					struct xfs_buf_map *map, int nmaps,
-					xfs_buf_flags_t flags);
+int 	libxfs_trans_get_buf_map(struct xfs_trans *tp, struct xfs_buftarg *btp,
+		struct xfs_buf_map *map, int nmaps, xfs_buf_flags_t flags,
+		struct xfs_buf **bpp);
 
 int	libxfs_trans_read_buf_map(struct xfs_mount *mp, struct xfs_trans *tp,
 				  struct xfs_buftarg *btp,
@@ -123,8 +122,14 @@ libxfs_trans_get_buf(
 	int			numblks,
 	uint			flags)
 {
+	struct xfs_buf		*bp;
+	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return libxfs_trans_get_buf_map(tp, btp, &map, 1, flags);
+
+	error = libxfs_trans_get_buf_map(tp, btp, &map, 1, flags, &bp);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 static inline int
diff --git a/libxfs/trans.c b/libxfs/trans.c
index b833e369..d200038b 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -415,24 +415,22 @@ libxfs_trans_bhold_release(
  * If the transaction pointer is NULL, make this just a normal
  * get_buf() call.
  */
-struct xfs_buf *
+int
 libxfs_trans_get_buf_map(
 	struct xfs_trans	*tp,
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	xfs_buf_flags_t		flags)
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
 {
 	struct xfs_buf		*bp;
 	struct xfs_buf_log_item	*bip;
 	int			error;
 
-	if (!tp) {
-		error = libxfs_buf_get_map(target, map, nmaps, 0, &bp);
-		if (error)
-			return NULL;
-		return bp;
-	}
+	*bpp = NULL;
+	if (!tp)
+		return libxfs_buf_get_map(target, map, nmaps, 0, bpp);
 
 	/*
 	 * If we find the buffer in the cache with this transaction
@@ -447,18 +445,20 @@ libxfs_trans_get_buf_map(
 		ASSERT(bip != NULL);
 		bip->bli_recur++;
 		trace_xfs_trans_get_buf_recur(bip);
-		return bp;
+		*bpp = bp;
+		return 0;
 	}
 
 	error = libxfs_buf_get_map(target, map, nmaps, 0, &bp);
 	if (error)
-		return NULL;
+		return error;
 
 	ASSERT(!bp->b_error);
 
 	_libxfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_get_buf(bp->b_log_item);
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 xfs_buf_t *
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 5102c6e0..3f40e99e 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2588,13 +2588,9 @@ xfs_da_get_buf(
 	if (error || nmap == 0)
 		goto out_free;
 
-	bp = xfs_trans_get_buf_map(tp, mp->m_ddev_targp, mapp, nmap, 0);
-	error = bp ? bp->b_error : -EIO;
-	if (error) {
-		if (bp)
-			xfs_trans_brelse(tp, bp);
+	error = xfs_trans_get_buf_map(tp, mp->m_ddev_targp, mapp, nmap, 0, &bp);
+	if (error)
 		goto out_free;
-	}
 
 	*bpp = bp;
 

