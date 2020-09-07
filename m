Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADD0C43461
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42F66208C7
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:55:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lRffEPg9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgIGRyn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:54:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58212 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729432AbgIGRy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 13:54:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087Hnvdo043291;
        Mon, 7 Sep 2020 17:54:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PBAg1Gm/tX5n3xpwcyT/v++IEBFX0SEa8n4y5YgAdbI=;
 b=lRffEPg9EYVglNvcGYm07KuvowqqSpoDQRCDaXNpj8q20o3ZJXJa5kI1UbyfxdMT0a3L
 DG2lFSunMUiB3c4QqUiEbS4j1yC2/o2fhNJJWw1vk3FxWWCLOzknYXSO58sruBr1VHqv
 vslStN2iGZV2MUkSvJGCHe3Zs20OC0XU4j47+MSULc31LHdxVmoepGHtzEJcqj1nxZMv
 DChQ4CKszQOOQLX+RZI79+fkBsBs5YtbC7x8J5Xrv8Jaw6Hkhkl32Nv10Kn4OuS9tEBR
 21M9Pk0s6gORBToFSz9i47cwAp02T8MOzgrlsH8VNHqxsL/vNNeZyObIrS5mr+PDii5w Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33c3amqgsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Sep 2020 17:54:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HnNIs066201;
        Mon, 7 Sep 2020 17:52:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33cmepvgdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Sep 2020 17:52:26 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 087HqOx5002328;
        Mon, 7 Sep 2020 17:52:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 10:51:43 -0700
Subject: [PATCH 2/4] mkfs.xfs: tweak wording of external log device size
 complaint
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 10:51:42 -0700
Message-ID: <159950110270.567664.7772913999736955021.stgit@magnolia>
In-Reply-To: <159950108982.567664.1544351129609122663.stgit@magnolia>
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the external log device is too small to satisfy minimum requirements,
mkfs will complain about "external log device 512 too small...".  That
doesn't make any sense, so add a few missing words to clarify what we're
talking about:

"external log device size 512 blocks too small..."

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a687f385a9c1..39fad9576088 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3095,7 +3095,7 @@ calculate_log_size(
 	if (!cfg->loginternal) {
 		if (min_logblocks > cfg->logblocks) {
 			fprintf(stderr,
-_("external log device %lld too small, must be at least %lld blocks\n"),
+_("external log device size %lld blocks too small, must be at least %lld blocks\n"),
 				(long long)cfg->logblocks,
 				(long long)min_logblocks);
 			usage();

