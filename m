Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B755C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CDF721927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:18:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SnUgEzSv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgBYAS2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:18:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56500 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAS2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:18:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07aIl050075;
        Tue, 25 Feb 2020 00:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AhFUEL13vi5PW2uuFBkXy4yLv+BVpSQHSMRuqaYkXiw=;
 b=SnUgEzSvqXYHUHoYldhrvg+6krrxxdhmsclLIMs7XrLTUxJKlM185sWqqmth1JbSVau3
 gDrqfcm/Ia1egfXxYzlKXlcTWp2o7Ah4GAMglsgDQcp60TWCtaxbVViPFTC4bi7S3pfP
 V2ZS7Q4twVvfcWO+Kg3L4WQIznP9ruPW7XQAADwwhWmIoi7kH/x9dOl4Ck0VtL/yCmT9
 IisJSFTd9gVoBYDtshbwR8NrhOH8W0A5uHlsVTw/el/gfM3oOUm4W5r94Ud8rxjmy3zq
 qIrYgw3orG0oPbtJcUH6apQtVPjnCoVMP95TqH4H7fVdts67zNNR5CeGhvBKl8ruuSOS Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q43b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:16:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07vUI109346;
        Tue, 25 Feb 2020 00:14:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ybe12esc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:14:23 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0ENHx001052;
        Tue, 25 Feb 2020 00:14:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:14:22 -0800
Subject: [PATCH 02/14] libxfs: make libxfs_getbuf_flags return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:14:21 -0800
Message-ID: <158258966171.453666.1345655269569262600.stgit@magnolia>
In-Reply-To: <158258964941.453666.10913737544282124969.stgit@magnolia>
References: <158258964941.453666.10913737544282124969.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=687 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=739 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert libxfs_getbuf_flags() to return numeric error codes like most
everywhere else in xfsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/rdwr.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 955284d0..ea9979a2 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -538,25 +538,21 @@ __cache_lookup(
 	return 0;
 }
 
-static struct xfs_buf *
+static int
 libxfs_getbuf_flags(
 	struct xfs_buftarg	*btp,
 	xfs_daddr_t		blkno,
 	int			len,
-	unsigned int		flags)
+	unsigned int		flags,
+	struct xfs_buf		**bpp)
 {
 	struct xfs_bufkey	key = {NULL};
-	struct xfs_buf		*bp;
-	int			error;
 
 	key.buftarg = btp;
 	key.blkno = blkno;
 	key.bblen = len;
 
-	error = __cache_lookup(&key, flags, &bp);
-	if (error)
-		return NULL;
-	return bp;
+	return __cache_lookup(&key, flags, bpp);
 }
 
 /*
@@ -591,9 +587,13 @@ __libxfs_buf_get_map(
 	int			i;
 	int			error;
 
-	if (nmaps == 1)
-		return libxfs_getbuf_flags(btp, map[0].bm_bn, map[0].bm_len,
-					   flags);
+	if (nmaps == 1) {
+		error = libxfs_getbuf_flags(btp, map[0].bm_bn, map[0].bm_len,
+				flags, &bp);
+		if (error)
+			return NULL;
+		return bp;
+	}
 
 	key.buftarg = btp;
 	key.blkno = map[0].bm_bn;
@@ -741,8 +741,8 @@ libxfs_readbuf(
 	struct xfs_buf		*bp;
 	int			error;
 
-	bp = libxfs_getbuf_flags(btp, blkno, len, 0);
-	if (!bp)
+	error = libxfs_getbuf_flags(btp, blkno, len, 0, &bp);
+	if (error)
 		return NULL;
 
 	/*

