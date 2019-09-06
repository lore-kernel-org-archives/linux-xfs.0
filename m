Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17AD5C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 123D6206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:39:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mj0p1k6V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387776AbfIFDjn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:39:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38680 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbfIFDjn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:39:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dIJb108594;
        Fri, 6 Sep 2019 03:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4h3OQuBn8pRUP0g/Wi+oBN7oH8p3EQKoSQamm3fBr9w=;
 b=mj0p1k6V0qRziDZtunCSqx38YGABmHYoRIqi8pTrM8Sw9pQN/doCgYc3feOaB0hYqDx6
 4YuaBesdbzaiBqoZKgJbFt+aRDrBLdAcu7b9yZJgA4H7fN64Vw3hZnbACSSs4iJPN1Zb
 0jZ0y076ZyWvDs/G7dQ7xxB5raaMNqqBcqztcz/Y6O0MGe6TnBbAy/rLw4qSUuz8xham
 gvR3Ov7hNtreNOkES/poFfb7zIz98hjXuSq0hM4BE73u4uT9cF1HfNJTANkeM4VBNjr+
 CnHZgdIbaWdzfWmGy6QoX1CiCDcSw2saRyxj0WC3FBOvrXZgslUhGDSJGIPU3tj9H7PD iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uuf5f83ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863dGaA112714;
        Fri, 6 Sep 2019 03:39:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uud7p2su8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:39:40 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863ddm3006329;
        Fri, 6 Sep 2019 03:39:39 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:39:39 -0700
Subject: [PATCH 07/11] xfs_scrub: request fewer bmaps when we can
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:39:39 -0700
Message-ID: <156774117912.2645432.10361703081233421846.stgit@magnolia>
In-Reply-To: <156774113533.2645432.14942831726168941966.stgit@magnolia>
References: <156774113533.2645432.14942831726168941966.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_iterate_filemaps, we query the number of bmaps for a given file
that we're going to iterate, so feed that information to bmap so that
the kernel won't waste time allocating in-kernel memory unnecessarily.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/filemap.c b/scrub/filemap.c
index bdc6d8f9..aaaa0521 100644
--- a/scrub/filemap.c
+++ b/scrub/filemap.c
@@ -71,7 +71,6 @@ xfs_iterate_filemaps(
 		map->bmv_length = ULLONG_MAX;
 	else
 		map->bmv_length = BTOBB(key->bm_length);
-	map->bmv_count = BMAP_NR;
 	map->bmv_iflags = BMV_IF_NO_DMAPI_READ | BMV_IF_PREALLOC |
 			  BMV_IF_NO_HOLES;
 	switch (whichfork) {
@@ -96,6 +95,7 @@ xfs_iterate_filemaps(
 		moveon = false;
 		goto out;
 	}
+	map->bmv_count = min(fsx.fsx_nextents + 2, BMAP_NR);
 
 	while ((error = ioctl(fd, XFS_IOC_GETBMAPX, map)) == 0) {
 		for (i = 0, p = &map[i + 1]; i < map->bmv_entries; i++, p++) {

