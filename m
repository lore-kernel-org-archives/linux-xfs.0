Return-Path: <SRS0=Nxvu=26=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746D4C282DD
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4670B20678
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:45:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RGh/QwI7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbgAISpG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 13:45:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51632 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729778AbgAISpG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jan 2020 13:45:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009Id9Yt156687
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=HvHYceRH3pipWrbPe1fEcIejpDpTdvIm/q0mMr2/4PQ=;
 b=RGh/QwI7ILgWt1HyG5MCEX6bRu4tDD4K8FJTMQNgtrjTxjx9oxAH8OI0t7BTD5Z6pfeU
 XFwqATGFWdt2BWNv6s+9MzOsCVn0EFd4CnSKqKq8Bj2R/qerishReDC1lFYQUY+vzq4b
 wNMANjswMZJgd8F+9uoKFNQcpYANKGsETSYAKpLR6LhE0hcJfzuyDaAbFR++ItSS9Bis
 tAlLLRO56LULohp8gnRbcsJXE6JvOnvjGY3xy7vXYqpfWDqVrmc7oSwhsU/5sTvFrsGR
 q1vogcxWyZxv0wufC6IeSr6sdBBxSJOGCGkJ4DnHU0XNzHTUXYzERPf0Nio1LOfWGln9 fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xaj4ucwbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:45:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009Ide5T050680
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:45:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xdj4r95vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:45:04 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 009Ij2km030974
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:45:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 10:45:02 -0800
Subject: [PATCH 3/5] xfs: clean up xfs_buf_item_get_format return value
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 09 Jan 2020 10:45:00 -0800
Message-ID: <157859550017.164065.4715415441588345394.stgit@magnolia>
In-Reply-To: <157859548029.164065.5207227581806532577.stgit@magnolia>
References: <157859548029.164065.5207227581806532577.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001090154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001090154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The only thing that can cause a nonzero return from
xfs_buf_item_get_format is if the kmem_alloc fails, which it can't.
Get rid of all the unnecessary error handling.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

