Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AED3C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC422186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PKfy6TSn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfHZV2U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:28:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49724 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV2T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:28:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLQwiP003384;
        Mon, 26 Aug 2019 21:28:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=43jIuszhxPag7Psx0A0SSz19qWl2pEv1GC6O2qrQx40=;
 b=PKfy6TSn9Sj/yATQrrR2wX21yPgeXqZr6SHupgSjYVoOI4D3DNG75Ssnc4LWKC/g4pX+
 Xs67L5ZQOEr/Bv4cUUzKmOyfUjIjeXsbxFXe/uofB/osRgxrfj2VviEqkPl7KAWRmNyd
 e9i5o0T3EQS3QtFxrdt+DybXoZGC3OJESkySSCFROcBhFsqB1EkVLT5+AQpL8ryVo0m3
 RoivQxWvsSIGGybmyWHlyuHUPY/ZyhHthuPFc85dBLCVLqyZ6VTTl7K6PJvq+ueRdkcu
 4Zxh7x9Mq/5fqBocWjYMXOpTQLSt0mzIqvm1N4smnev7aGFGqApq2P6q3lKe9PPSa2Cs vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2umqbe806v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIsDh184971;
        Mon, 26 Aug 2019 21:28:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2umj2xvw54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:16 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLSGkn005663;
        Mon, 26 Aug 2019 21:28:16 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:28:16 -0700
Subject: [PATCH 4/4] xfs_scrub: batch inumbers calls during fscounters
 calculation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:28:15 -0700
Message-ID: <156685489550.2841421.9905052854315806096.stgit@magnolia>
In-Reply-To: <156685486843.2841421.7117771040713668517.stgit@magnolia>
References: <156685486843.2841421.7117771040713668517.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Improve the efficiency of the phase 7 inode counts by batching requests,
now that we have per-AG inumbers wrappers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/fscounters.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 91487ebc..c90143c0 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -43,9 +43,10 @@ xfs_count_inodes_ag(
 {
 	struct xfs_inumbers_req	*ireq;
 	uint64_t		nr = 0;
+	unsigned int		i;
 	int			error;
 
-	ireq = xfrog_inumbers_alloc_req(1, 0);
+	ireq = xfrog_inumbers_alloc_req(64, 0);
 	if (!ireq) {
 		str_info(ctx, descr, _("Insufficient memory; giving up."));
 		return false;
@@ -55,7 +56,8 @@ xfs_count_inodes_ag(
 	while (!(error = xfrog_inumbers(&ctx->mnt, ireq))) {
 		if (ireq->hdr.ocount == 0)
 			break;
-		nr += ireq->inumbers[0].xi_alloccount;
+		for (i = 0; i < ireq->hdr.ocount; i++)
+			nr += ireq->inumbers[i].xi_alloccount;
 	}
 
 	free(ireq);

