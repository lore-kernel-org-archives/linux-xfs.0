Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68407C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38E8B20872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:40:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IbXBlN/J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfIYVk6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:40:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49626 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfIYVk6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:40:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdOiP013211;
        Wed, 25 Sep 2019 21:40:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Tsqoi56MpsHIxZeCBT6G7oa1798nq3B9s+weeCUp5+U=;
 b=IbXBlN/Jy87+9xGVsYvo99effua8zccj8xzOhJAu4h5Uf0I32odMYfr1M9Ox6If4MSPN
 T5uCa4gV++VTzI5qt8sjmbyfUyqDd8oiKtEf4HPO0n0wPFeEumAQyVhVN8mVKDWdcZcy
 Uxquub/WL3kPIEtc+DAW4PwlqnrE/SGCXbj5Xkl/V54633fLhrJVAtvi//mC7GLtyS9f
 HKyTRVllvanmgHBzcVxzZWWAoB8xpOHa9PZK5Brg06bT9dvM+xYZoTQvIEAIPzkKpQYz
 JJ2fKhPzZMC592rh7SI+EcvEazAcndUKzQXVdU3AXiqeWWzZD+4LLuEXk7wzdEQX4q44 sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v5btq7jeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:40:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdH2C021219;
        Wed, 25 Sep 2019 21:40:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v829w5889-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:40:56 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLetem018029;
        Wed, 25 Sep 2019 21:40:55 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:40:55 -0700
Subject: [PATCH 1/2] xfs_db: btheight should check geometry more carefully
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:40:53 -0700
Message-ID: <156944765385.303060.16945955453073433913.stgit@magnolia>
In-Reply-To: <156944764785.303060.15428657522073378525.stgit@magnolia>
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The btheight command needs to check user-supplied geometry more
carefully so that we don't hit floating point exceptions.

Coverity-id: 1453661, 1453659
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/btheight.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 6 deletions(-)


diff --git a/db/btheight.c b/db/btheight.c
index 289e5d84..e2c9759f 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -138,6 +138,10 @@ construct_records_per_block(
 		perror(p);
 		goto out;
 	}
+	if (record_size == 0) {
+		fprintf(stderr, _("%s: record size cannot be zero.\n"), tag);
+		goto out;
+	}
 
 	p = strtok(NULL, ":");
 	if (!p) {
@@ -149,6 +153,10 @@ construct_records_per_block(
 		perror(p);
 		goto out;
 	}
+	if (key_size == 0) {
+		fprintf(stderr, _("%s: key size cannot be zero.\n"), tag);
+		goto out;
+	}
 
 	p = strtok(NULL, ":");
 	if (!p) {
@@ -160,6 +168,10 @@ construct_records_per_block(
 		perror(p);
 		goto out;
 	}
+	if (ptr_size == 0) {
+		fprintf(stderr, _("%s: pointer size cannot be zero.\n"), tag);
+		goto out;
+	}
 
 	p = strtok(NULL, ":");
 	if (!p) {
@@ -180,6 +192,27 @@ construct_records_per_block(
 		goto out;
 	}
 
+	if (record_size > blocksize) {
+		fprintf(stderr,
+			_("%s: record size must be less than %u bytes.\n"),
+			tag, blocksize);
+		goto out;
+	}
+
+	if (key_size > blocksize) {
+		fprintf(stderr,
+			_("%s: key size must be less than %u bytes.\n"),
+			tag, blocksize);
+		goto out;
+	}
+
+	if (ptr_size > blocksize) {
+		fprintf(stderr,
+			_("%s: pointer size must be less than %u bytes.\n"),
+			tag, blocksize);
+		goto out;
+	}
+
 	p = strtok(NULL, ":");
 	if (p) {
 		fprintf(stderr,
@@ -211,13 +244,24 @@ report(
 	int			ret;
 
 	ret = construct_records_per_block(tag, blocksize, records_per_block);
-	if (ret) {
-		printf(_("%s: Unable to determine records per block.\n"),
-				tag);
+	if (ret)
 		return;
-	}
 
 	if (report_what & REPORT_MAX) {
+		if (records_per_block[0] < 2) {
+			fprintf(stderr,
+_("%s: cannot calculate best case scenario due to leaf geometry underflow.\n"),
+				tag);
+			return;
+		}
+
+		if (records_per_block[1] < 4) {
+			fprintf(stderr,
+_("%s: cannot calculate best case scenario due to node geometry underflow.\n"),
+				tag);
+			return;
+		}
+
 		printf(
 _("%s: best case per %u-byte block: %u records (leaf) / %u keyptrs (node)\n"),
 				tag, blocksize, records_per_block[0],
@@ -230,6 +274,20 @@ _("%s: best case per %u-byte block: %u records (leaf) / %u keyptrs (node)\n"),
 		records_per_block[0] /= 2;
 		records_per_block[1] /= 2;
 
+		if (records_per_block[0] < 1) {
+			fprintf(stderr,
+_("%s: cannot calculate worst case scenario due to leaf geometry underflow.\n"),
+				tag);
+			return;
+		}
+
+		if (records_per_block[1] < 2) {
+			fprintf(stderr,
+_("%s: cannot calculate worst case scenario due to node geometry underflow.\n"),
+				tag);
+			return;
+		}
+
 		printf(
 _("%s: worst case per %u-byte block: %u records (leaf) / %u keyptrs (node)\n"),
 				tag, blocksize, records_per_block[0],
@@ -284,8 +342,26 @@ btheight_f(
 		}
 	}
 
-	if (argc == optind || blocksize <= 0 || blocksize > INT_MAX ||
-	    nr_records == 0) {
+	if (nr_records == 0) {
+		fprintf(stderr,
+_("Number of records must be greater than zero.\n"));
+		return 0;
+	}
+
+	if (blocksize > INT_MAX) {
+		fprintf(stderr,
+_("The largest block size this command will consider is %u bytes.\n"),
+			INT_MAX);
+		return 0;
+	}
+
+	if (blocksize < 128) {
+		fprintf(stderr,
+_("The smallest block size this command will consider is 128 bytes.\n"));
+		return 0;
+	}
+
+	if (argc == optind) {
 		btheight_help();
 		return 0;
 	}

