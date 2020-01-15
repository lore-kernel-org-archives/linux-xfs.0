Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BB9C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D45D214AF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="krb4DKF8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAORDc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:03:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41032 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728899AbgAORDc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:03:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhP7Y037021;
        Wed, 15 Jan 2020 17:03:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=k9B1QmUDoYWo6SDL+gs3SMjhcGc51z4ptVAODp6aLhg=;
 b=krb4DKF8mXzLgJ1HcZzEUlSYROTIKzE9ffpFdWY+VWKiNK4CtsLtN+Qz3OVKacFgMHr7
 EcYyVUfTU/4OtXKwkvUMmYaVklOU1dTk3BGpn93NZIAWJ9pQrTjj+WNU2XtQOVQdo34A
 +YAYrEUlxHlraz2nJTzCxpjj3HLNij2+XDGxKEyfj9emfCKKmycICNaofmBmaIrvZp4o
 M2eAzHkOcqrf6sCPnCvVtKeAuQSP6GooIk4QGYmvM3x9wtU+kUh8TcOuzzO8ZJ8kWM7z
 N2mO0DUyeFbm3MkDGdSu7HYULM0X8RfjPLf/XCMzcZHSe4SaeoOs8S+OThcJllvw9IO7 +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74sde8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGicSA183352;
        Wed, 15 Jan 2020 17:03:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xj1apwqke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:20 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00FH3Jwo028898;
        Wed, 15 Jan 2020 17:03:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:03:19 -0800
Subject: [PATCH 4/7] xfs: clean up xfs_buf_item_get_format return value
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 15 Jan 2020 09:03:18 -0800
Message-ID: <157910779863.2028015.13882323129750373731.stgit@magnolia>
In-Reply-To: <157910777330.2028015.5017943601641757827.stgit@magnolia>
References: <157910777330.2028015.5017943601641757827.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The only thing that can cause a nonzero return from
xfs_buf_item_get_format is if the kmem_alloc fails, which it can't.
Get rid of all the unnecessary error handling.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3984779e5911..9737f177a49b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -688,7 +688,7 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_push	= xfs_buf_item_push,
 };
 
-STATIC int
+STATIC void
 xfs_buf_item_get_format(
 	struct xfs_buf_log_item	*bip,
 	int			count)
@@ -698,14 +698,11 @@ xfs_buf_item_get_format(
 
 	if (count == 1) {
 		bip->bli_formats = &bip->__bli_format;
-		return 0;
+		return;
 	}
 
 	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
 				0);
-	if (!bip->bli_formats)
-		return -ENOMEM;
-	return 0;
 }
 
 STATIC void
@@ -731,7 +728,6 @@ xfs_buf_item_init(
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	int			chunks;
 	int			map_size;
-	int			error;
 	int			i;
 
 	/*
@@ -760,13 +756,7 @@ xfs_buf_item_init(
 	 * Discontiguous buffer support follows the layout of the underlying
 	 * buffer. This makes the implementation as simple as possible.
 	 */
-	error = xfs_buf_item_get_format(bip, bp->b_map_count);
-	ASSERT(error == 0);
-	if (error) {	/* to stop gcc throwing set-but-unused warnings */
-		kmem_cache_free(xfs_buf_item_zone, bip);
-		return error;
-	}
-
+	xfs_buf_item_get_format(bip, bp->b_map_count);
 
 	for (i = 0; i < bip->bli_format_count; i++) {
 		chunks = DIV_ROUND_UP(BBTOB(bp->b_maps[i].bm_len),

