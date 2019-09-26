Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F1BC4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 19:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41414217F4
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 19:09:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PsXw7W7v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfIZTJR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 15:09:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48438 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbfIZTJR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 15:09:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QJ8YO4141341;
        Thu, 26 Sep 2019 19:09:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=4FBy1J7d+Fk7+9NvVHPh/gweneUv8ij0XUAC/XxkX5U=;
 b=PsXw7W7vunAplPyiVOtIH6VFn8/H7wlIjtzTvH8Ghg01Sj0Nc5W1j6iGd5jBtUqMk/+X
 0HXOIkxh8haytMtvVL5PpHk/StTESBy3KVbRA4aYlUv83hxoIXr4axKMyjF8He9QYiDM
 Bf7V8xccdJolNjXxpqmjHJM/fzOQVCSVlEel+C+EARGxVfS1NbmN8mqABAeY1BsGh41Z
 FmSA7ySGFMqZUcWbnRkl8tct43R1RbivpugcLAfJ7x8B2c3bFxAmSMe3yytYWnNV5OEp
 SJl/Jhp4b1tEKpPfjyD0vAjVNhbmK4N5YAwMVcXDM6flfcRElQdBRvqXG9scNxOPP0ao pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v5b9u5ux3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 19:09:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QIsV6B038048;
        Thu, 26 Sep 2019 19:09:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v8yjwyj91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 19:09:14 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8QJ9Cxe025634;
        Thu, 26 Sep 2019 19:09:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 12:09:12 -0700
Date:   Thu, 26 Sep 2019 12:09:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/2] xfs_db: btheight should check geometry more carefully
Message-ID: <20190926190911.GG9916@magnolia>
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765385.303060.16945955453073433913.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944765385.303060.16945955453073433913.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909260151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909260152
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
index 289e5d84..8aa17c89 100644
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
+_("%s: record size must be less than selected block size (%u bytes).\n"),
+			tag, blocksize);
+		goto out;
+	}
+
+	if (key_size > blocksize) {
+		fprintf(stderr,
+_("%s: key size must be less than selected block size (%u bytes).\n"),
+			tag, blocksize);
+		goto out;
+	}
+
+	if (ptr_size > blocksize) {
+		fprintf(stderr,
+_("%s: pointer size must be less than selected block size (%u bytes).\n"),
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
