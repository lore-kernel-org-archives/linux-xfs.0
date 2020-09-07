Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4A1C433E2
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61DF2208C7
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SS/tQzcH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgIGRwv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:52:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57626 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbgIGRwl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 13:52:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HnGoq100150;
        Mon, 7 Sep 2020 17:52:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=brmWY9IyKB1yP4GFNvqSV/7RyxRXVd1KeB3oCV8JysQ=;
 b=SS/tQzcHF8EHz0frUvcqOyc2EG+fIfvbt500PzrKN3A+pmyVatGHajtxS3eUPodckm6t
 5Tej9PSKAgamTIlNHJEEBdMHUACdXEfEpRWroP8mM/4zcK+1LJCrHWujDqovlRB3HYgx
 KTTxDi21jBc8pjtuqA7PKSAt6iM6G1ZcrnLp40bXR6kEpW5GPRY+duwJdC9tbnJVIRXD
 uIp5nUlpgFTEHiQzZQTn09Kjsp1rmsJY8JtZ7cj3ZBDbnrv6iK3Ctuy09Ts7TZZfoVCk
 guzjIeOzKJ8q/nsiZHfp+71fiVVah/STpa4hCnfZYXmV2zJn8cgJrvA0dD8FzPJ7rFv/ BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33c2mkqj92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Sep 2020 17:52:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HoCQO066176;
        Mon, 7 Sep 2020 17:52:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33cmkuurcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Sep 2020 17:52:38 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 087HqbUI012306;
        Mon, 7 Sep 2020 17:52:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 10:51:50 -0700
Subject: [PATCH 3/4] mkfs: fix reflink/rmap logic w.r.t. realtime devices and
 crc=0 support
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 10:51:49 -0700
Message-ID: <159950110896.567664.15989009829117632135.stgit@magnolia>
In-Reply-To: <159950108982.567664.1544351129609122663.stgit@magnolia>
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

mkfs has some logic to deal with situations where reflink or rmapbt are
turned on and the administrator has configured a realtime device or a V4
filesystem; such configurations are not allowed.

The logic ought to disable reflink and/or rmapbt if they're enabled due
to being the defaults, and it ought to complain and abort if they're
enabled because the admin explicitly turned them on.

Unfortunately, the logic here doesn't do that and makes no sense at all
since usage() exits the program.  Fix it to follow what everything else
does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 39fad9576088..6b55ca3e4c57 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1973,7 +1973,7 @@ _("sparse inodes not supported without CRC support\n"));
 		}
 		cli->sb_feat.spinodes = false;
 
-		if (cli->sb_feat.rmapbt) {
+		if (cli->sb_feat.rmapbt && cli_opt_set(&mopts, M_RMAPBT)) {
 			fprintf(stderr,
 _("rmapbt not supported without CRC support\n"));
 			usage();
@@ -1995,17 +1995,19 @@ _("cowextsize not supported without reflink support\n"));
 		usage();
 	}
 
-	if (cli->sb_feat.reflink && cli->xi->rtname) {
-		fprintf(stderr,
+	if (cli->xi->rtname) {
+		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
+			fprintf(stderr,
 _("reflink not supported with realtime devices\n"));
-		usage();
+			usage();
+		}
 		cli->sb_feat.reflink = false;
-	}
 
-	if (cli->sb_feat.rmapbt && cli->xi->rtname) {
-		fprintf(stderr,
+		if (cli->sb_feat.rmapbt && cli_opt_set(&mopts, M_RMAPBT)) {
+			fprintf(stderr,
 _("rmapbt not supported with realtime devices\n"));
-		usage();
+			usage();
+		}
 		cli->sb_feat.rmapbt = false;
 	}
 

