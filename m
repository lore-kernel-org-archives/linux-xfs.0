Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385EAC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06D5721883
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:31:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mfUWnpCK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfHZVb4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:31:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35612 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbfHZVb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:31:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDlDU000821;
        Mon, 26 Aug 2019 21:31:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=P5l5f/+tYVAj77qCj2BiPr+7b6pIqH9mkNpAO5X5vAs=;
 b=mfUWnpCKi7BvWd5jxs5vfR3g3O7nc1s31+FPCfyXbRH7TAFJlwixI4CcD4uxvcM6d5R7
 R3uldc0Psx+rOhrQSRbRkZlg/ZhfsS6MjnxfUjf9uH0cbqnju+ucOyRkbUWoIq1IwDQ7
 DHNS8Fzr3Ar1fkGzMj5oFQTXHz2FjKKj7Fg1gHnMGPTDSGoQVnCDX9f2ujKwnHjKXAic
 +vlHcvH+11se9cVLIRd9ceUitb9JbK8Oi6u3zqA1cEXFb06h8sRSWTuYWj9p6UQvpIHT
 +xpOo+mkB9KEEzFRulFO5uxP+PH7QHLI28mDLhWdKMlbzP5GKEaqRvDwd/w65q9P8mRt 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2umpxx05nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLItFb185000;
        Mon, 26 Aug 2019 21:31:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2umj2xw044-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:31:54 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLVrdt009033;
        Mon, 26 Aug 2019 21:31:53 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:31:53 -0700
Subject: [PATCH 07/11] xfs_scrub: request fewer bmaps when we can
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:31:52 -0700
Message-ID: <156685511262.2843133.11543255530722170850.stgit@magnolia>
In-Reply-To: <156685506615.2843133.16536353613627426823.stgit@magnolia>
References: <156685506615.2843133.16536353613627426823.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
index dc8f4881..4dfa3fe6 100644
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

