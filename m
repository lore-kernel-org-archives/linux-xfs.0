Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096E1FA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD3D02077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:02:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cjKWTNY+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733057AbfKGDCx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:02:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57260 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGDCx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:02:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72xIjd039138
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=R/yYWlRmhZm8mxErIHLneJ2U968D81tQbDWI20Lq1/I=;
 b=cjKWTNY+iJupfRmfD55ZD5XvB+txM3DNPEzEH5x8Vd98Isq2mFYgOKUQ//pBxwKIsiYL
 BcfqkLY7pPQcDgaXE069hImrbGkfoW8XzhtwOutvjl8UCnCG0O7wF9Mr/xdE286e7gjK
 Smd8XCQQWZUBTSxVcZgWZtvoTxcSBagaaSuUzHpEwLSpcOSDQpGq6NnbRpYVNk9rL9m1
 soxcKNwJKbK86Z4doaq72grkGh1YgoyT8HNqnrsgWPpLpu484QNvZufwqMQBPdnCbk3L
 k+Lv8JQN8+HByLLRg5nMk4FSYYTYx2Pj9AIf6oPKdARjwQ9STH+WKSlmbcMVAjnZSYpG 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w0u0jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:02:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72wimm151765
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w41w8kq87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:02:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA732ov3028948
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:02:49 -0800
Subject: [PATCH 4/6] xfs: null out bma->prev if no previous extent
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:02:49 -0800
Message-ID: <157309576896.46520.15012779727563336898.stgit@magnolia>
In-Reply-To: <157309573874.46520.18107298984141751739.stgit@magnolia>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=726
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=806 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Coverity complains that we don't check the return value of
xfs_iext_peek_prev_extent like we do nearly all of the time.  If there
is no previous extent then just null out bma->prev like we do elsewhere
in the bmap code.

Coverity-id: 1424057
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 64f623d07f82..7392ca92ab34 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4014,7 +4014,8 @@ xfs_bmapi_allocate(
 	if (bma->wasdel) {
 		bma->length = (xfs_extlen_t)bma->got.br_blockcount;
 		bma->offset = bma->got.br_startoff;
-		xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev);
+		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
+			bma->prev.br_startoff = NULLFILEOFF;
 	} else {
 		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
 		if (!bma->eof)

