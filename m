Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B8BC33CA9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2D2020678
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 06:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="isqpCLPS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgANGeC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 01:34:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38280 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgANGeC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 01:34:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E6XdEc170783;
        Tue, 14 Jan 2020 06:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=k9B1QmUDoYWo6SDL+gs3SMjhcGc51z4ptVAODp6aLhg=;
 b=isqpCLPSHfnNiuSE5k3dDUc96D+wlCJod83GbbH97ehB9YV72grpj3rLjvLUDNZ3/u5X
 cW/30uVOpki5ljHvUuhuQY/GCytludzmu9eyUQItn61tXEUmp3VvEDK0iFbX8CfSbzL+
 pMwp6boEcIf/Bgi633MkrvHTeze0G9RhhoCX4YqTEqsMlDnTU3R/6s3U+6PasXcoUWHV
 WAX4KeT5Sj5F1W4H+dF2z5QwRM0VmRxSsv2dkha4x9NL/ojMXeGN+mgrhwWiVXb47rf6
 qcz28vh47l3RjIvJCaSlzcAJLprp3n4+4erYvUTeVLR8B9zIIGydzlTm9LOb2dMOVC8a ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xf74s3ur8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 06:33:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00E6Uxxx016988;
        Tue, 14 Jan 2020 06:31:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xh8erg0vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 06:31:54 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00E6VpQ7032063;
        Tue, 14 Jan 2020 06:31:51 GMT
Received: from localhost (/10.159.236.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 22:31:51 -0800
Subject: [PATCH 3/6] xfs: clean up xfs_buf_item_get_format return value
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Date:   Mon, 13 Jan 2020 22:31:50 -0800
Message-ID: <157898351013.1566005.10997259699613299740.stgit@magnolia>
In-Reply-To: <157898348940.1566005.3231891474158666998.stgit@magnolia>
References: <157898348940.1566005.3231891474158666998.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001140056
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001140056
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

