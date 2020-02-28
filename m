Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267EAC3F2D3
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F12722469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n/etYltF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgB1XjS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:39:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47426 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgB1XjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:39:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNbnPo160790;
        Fri, 28 Feb 2020 23:39:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=D5NJLN6fgC0Vm5MsXdabNFHi/HykL6hkGWFAHDrO6xc=;
 b=n/etYltFZzNr8YqWL1ECxVoPlSxglrVph8rX3+qnQgQYN71wmfYbX6bpFpSy0Xtn+KSV
 zmAr+rAY9FbBTYJtPYd36Qh16WAuMxNNIBOglrHQAWcNQ0serDLmEve2wztj5zQU2IZ6
 E5S192bNLql5WK2uBqiYYzDuvLIX4bQ58T+vxhGbmKe9hqM7mzV2+g+yQBx4mNtnIOhq
 ko2wAvmpZvy6hLQFLLnzAI7K1bxdQaOIqxlhSjn6iRFf13vF2yoI+TgD/df0u4gl00A5
 rgLUqlkwo8WiEzb3odl4kRQzmIJEcOxwZ52PevcRoHVrFRhnFKNPDDmmqE9ZDKjd0VZH hQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yf0dmc5ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:39:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNaml4113033;
        Fri, 28 Feb 2020 23:37:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ydcsgehqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:37:14 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNbD13012819;
        Fri, 28 Feb 2020 23:37:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:37:13 -0800
Subject: [PATCH 09/26] libxfs: make libxfs_readbufr stash the error value in
 b_error
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:37:12 -0800
Message-ID: <158293303256.1549542.6584670677452981760.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=773 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=840 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make libxfs_readbufr stash the error value in b_error, which will make
the behavior consistent between regular and multi-mapping buffers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/rdwr.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 83c6142f..2c67edde 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -943,6 +943,7 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
 		pthread_self(), __FUNCTION__, bytes, error,
 		(long long)LIBXFS_BBTOOFF64(blkno), (long long)blkno, bp);
 #endif
+	bp->b_error = error;
 	return error;
 }
 
@@ -1002,9 +1003,7 @@ libxfs_readbuf(
 	 * contents. *cough* xfs_da_node_buf_ops *cough*.
 	 */
 	error = libxfs_readbufr(btp, blkno, bp, len, flags);
-	if (error)
-		bp->b_error = error;
-	else
+	if (!error)
 		libxfs_readbuf_verify(bp, ops);
 	return bp;
 }

