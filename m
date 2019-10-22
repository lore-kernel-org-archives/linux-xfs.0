Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00114CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFCE520B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rEfoOefG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732580AbfJVSqt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:46:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46572 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732548AbfJVSqt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:46:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiRJr089262;
        Tue, 22 Oct 2019 18:46:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=TkD6vPVxFhY/ifPiloc8+f2f+QpWNQjdHEGk9WYj/m4=;
 b=rEfoOefGDinQ95vEz5CAkG70O+WytCkCCzOQGrrFQ2c/6BKi1OFfJprTjgIMBUZ+KIXZ
 Rii7em6oxFfNmmRYY/WvEz9lKwKu+SkSVnA4lfRbY7QERAkjbK2D0Dcj+Lu7c1Vo/kUs
 5qbp0IwYIsv/sKjAbDxRrfysqcGR96edyHulIXYQYpjQTCwPzddGAMPsUKKeojpm3KzI
 GXw0f1uM6sorPRlNOSxx7nSS9CLDOEoo346nnUayRP/nxbBzgkePgHwlrS0VNUVu5boK
 Jw/EXCngIXV2rVZg+JbrzlqCx8m0Ah5aYtMjf7Fc2VypphkXWXLWFstihwLW9dcr2tSX jQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vqu4qrjqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:46:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhOxk125252;
        Tue, 22 Oct 2019 18:46:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vsx239n0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:46:45 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIkjRn028480;
        Tue, 22 Oct 2019 18:46:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:46:45 -0700
Subject: [PATCH 2/5] xfs_db: btheight should check geometry more carefully
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:46:44 -0700
Message-ID: <157177000412.1458930.8971655647877190011.stgit@magnolia>
In-Reply-To: <157176999124.1458930.5678023201951458107.stgit@magnolia>
References: <157176999124.1458930.5678023201951458107.stgit@magnolia>
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

