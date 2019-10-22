Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D10CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA3FB20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SQu1Oc3I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732316AbfJVStO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:49:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbfJVStO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:49:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiTRT089273;
        Tue, 22 Oct 2019 18:49:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=IH7LzTOSaqV9fC8qr4n9LeedqiZW44fl66h9Oio3mU0=;
 b=SQu1Oc3Imc7chA4wl0+mk42247qiAIZ7fwr3R+OlDZZCgSCajDenvBnVpJgePFKkQCkv
 BzMNwK+BH6q+X6FlEvgNVuJJAuprlShKKWkmrCfP5aL249zhDCZ5k4N7KXonEuxROnrc
 qumT5xLi10Uf90SIYqjk+//Xq1W1Gx4DDENs0xYqAqQpuZbUiL/dRdJUbsZwR8rOjobo
 1bxNkMNoesoaEO0luQEal770MGAuH0We9+/blBAKewkzzztBj7ErxNWwTxwDKlPgeoUD
 ziJ3oK6NGRd4si4gv7fTtqbi84eiya4Yt7qJ9f2UM3RrtI55e/J2pLlefgAt5A6dgX5Y Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vqu4qrkaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiO1m064403;
        Tue, 22 Oct 2019 18:49:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vt2hdkg1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:10 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIn96S030315;
        Tue, 22 Oct 2019 18:49:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:49:09 -0700
Subject: [PATCH 3/7] xfs_scrub: clean up error level table
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:49:08 -0700
Message-ID: <157177014843.1460394.980952412513737663.stgit@magnolia>
In-Reply-To: <157177012894.1460394.4672572733673534420.stgit@magnolia>
References: <157177012894.1460394.4672572733673534420.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rework the error levels table in preparation for adding a few more error
categories that won't fit on a single line.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index 7632a8d8..90fbad64 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -46,11 +46,26 @@ static struct {
 	const char *string;
 	int loglevel;
 } err_levels[] = {
-	[S_ERROR]  = { .string = "Error",	.loglevel = LOG_ERR },
-	[S_WARN]   = { .string = "Warning",	.loglevel = LOG_WARNING },
-	[S_REPAIR] = { .string = "Repaired",	.loglevel = LOG_INFO },
-	[S_INFO]   = { .string = "Info",	.loglevel = LOG_INFO },
-	[S_PREEN]  = { .string = "Optimized",	.loglevel = LOG_INFO }
+	[S_ERROR]  = {
+		.string = "Error",
+		.loglevel = LOG_ERR,
+	},
+	[S_WARN]   = {
+		.string = "Warning",
+		.loglevel = LOG_WARNING,
+	},
+	[S_REPAIR] = {
+		.string = "Repaired",
+		.loglevel = LOG_INFO,
+	},
+	[S_INFO]   = {
+		.string = "Info",
+		.loglevel = LOG_INFO,
+	},
+	[S_PREEN]  = {
+		.string = "Optimized",
+		.loglevel = LOG_INFO,
+	},
 };
 
 /* If stream is a tty, clear to end of line to clean up progress bar. */

