Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C826CC7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A28C524672
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:43:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wBbeA9nB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgBTBnl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:43:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33798 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbgBTBnk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:43:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1hdQS064547;
        Thu, 20 Feb 2020 01:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=w26Y+3v7Ys3mShTAHqspDNQ1G9QNWGQf5upfZJK7d8g=;
 b=wBbeA9nBn3twlUYMG0VKfdX8l8Pmfz58nPi6vZIBj5RSPJcv7LeL+8tX8qalACZVHeUL
 5wEtBC5t2Zw//ABcKwsuPoLhVjsH1pBb0rl8mos/tkVvJ1lM8Ace47J8lt92Od9BEdfK
 5Em3SvqSeKHAJ2ddgIlsJ4ZSuFg+BW2J/UW8rVfHH7zgTF96Tcg76rQCTIdz0Yhlhj8Y
 0qzerHxDe7bUlt1BRn/JFfHT2tqwTopWgVzRsaRbIejGCOvazq2zEkb7r3dvViZ0tCHo
 K2NSz54SiI6pQJFImK1vrs7tyuv8RTUfG9/9n2hkhMM49dUEjIEtDW6RiKURqq3diDm3 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2y8udket0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1hboc114171;
        Thu, 20 Feb 2020 01:43:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2y8ud2g3ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:43:38 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1hWbs002256;
        Thu, 20 Feb 2020 01:43:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:43:32 -0800
Subject: [PATCH 09/18] libxfs: make libxfs_readbufr stash the error value in
 b_error
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:43:31 -0800
Message-ID: <158216301140.602314.6904049540452018739.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=758 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=809 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make libxfs_readbufr stash the error value in b_error, which will make
the behavior consistent between regular and multi-mapping buffers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 24c5eaf6..51f93c3e 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -940,6 +940,7 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
 		pthread_self(), __FUNCTION__, bytes, error,
 		(long long)LIBXFS_BBTOOFF64(blkno), (long long)blkno, bp);
 #endif
+	bp->b_error = error;
 	return error;
 }
 
@@ -999,9 +1000,7 @@ libxfs_readbuf(
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

