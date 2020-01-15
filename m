Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3A9C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2C9A214AF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MHlYTj6L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAORDz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:03:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41522 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgAORDz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:03:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGiNFk037628;
        Wed, 15 Jan 2020 17:03:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RvPXSqHRROQ6ThRw3NURgWgHiYlyuksT/e+rT8fVz/o=;
 b=MHlYTj6LEkdOWZ8vJs5LWqldkhQOjDlT0alCcEvp3QM9wulukJxXZIxnJNuaDkmA8zYB
 qLlYAiwnjOGJIhk0FvG220lPLVO9FjSSSzzPD1a+ZMYUA4TjBrRfK0qYfs82dxIcvy+d
 Q0qovzniaE3qX5kxeoqSqdUqg0+oAxnEC9AUvF/6zKaUG3jZYzWfk1TESfooP1u2RC35
 ZgEU0s11VE+y+Y+o+6DP8kXRedz6uZhhLnzuktr7XHh7QyYYoqcVgd4xQ2NBCoeuHGHf
 dxynTAsjvwIiq/+tnTM6dMzlmTR408dmWL7QVhBE3lnEOv7SGWUANVOF9Hp9gJOr+Ati UA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74sdecq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGicg6183329;
        Wed, 15 Jan 2020 17:03:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xj1apwr8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:48 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00FH3l71012008;
        Wed, 15 Jan 2020 17:03:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:03:46 -0800
Subject: [PATCH 1/9] xfs: make xfs_buf_alloc return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 09:03:46 -0800
Message-ID: <157910782597.2028217.5043572462444167802.stgit@magnolia>
In-Reply-To: <157910781961.2028217.1250106765923436515.stgit@magnolia>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
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

Convert _xfs_buf_alloc() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a0229c368e78..546af31bb375 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -198,12 +198,13 @@ xfs_buf_free_maps(
 	}
 }
 
-static struct xfs_buf *
+static int
 _xfs_buf_alloc(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	xfs_buf_flags_t		flags)
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
 {
 	struct xfs_buf		*bp;
 	int			error;
@@ -211,7 +212,7 @@ _xfs_buf_alloc(
 
 	bp = kmem_zone_zalloc(xfs_buf_zone, KM_NOFS);
 	if (unlikely(!bp))
-		return NULL;
+		return -ENOMEM;
 
 	/*
 	 * We don't want certain flags to appear in b_flags unless they are
@@ -239,7 +240,7 @@ _xfs_buf_alloc(
 	error = xfs_buf_get_maps(bp, nmaps);
 	if (error)  {
 		kmem_cache_free(xfs_buf_zone, bp);
-		return NULL;
+		return error;
 	}
 
 	bp->b_bn = map[0].bm_bn;
@@ -256,7 +257,8 @@ _xfs_buf_alloc(
 	XFS_STATS_INC(bp->b_mount, xb_create);
 	trace_xfs_buf_init(bp, _RET_IP_);
 
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 /*
@@ -715,8 +717,8 @@ xfs_buf_get_map(
 		return NULL;
 	}
 
-	new_bp = _xfs_buf_alloc(target, map, nmaps, flags);
-	if (unlikely(!new_bp))
+	error = _xfs_buf_alloc(target, map, nmaps, flags, &new_bp);
+	if (unlikely(error))
 		return NULL;
 
 	error = xfs_buf_allocate_memory(new_bp, flags);
@@ -917,8 +919,8 @@ xfs_buf_get_uncached(
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
 
 	/* flags might contain irrelevant bits, pass only what we care about */
-	bp = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT);
-	if (unlikely(bp == NULL))
+	error = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT, &bp);
+	if (unlikely(error))
 		goto fail;
 
 	page_count = PAGE_ALIGN(numblks << BBSHIFT) >> PAGE_SHIFT;

